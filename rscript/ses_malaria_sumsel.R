# =====================================================================
# Pemodelan Deret Waktu Kasus Malaria Konfirmasi
# di Provinsi Sumatera Selatan Tahun 2021-2026
# Metode: Single Exponential Smoothing (SES) - versi R (RStudio)
#
# Cara pakai di RStudio:
#   1. Buka file ini di RStudio
#   2. Klik "Source" (atau Ctrl+Shift+Enter)
#   3. Data diambil otomatis dari GitHub, tidak perlu file manual
#
# Tidak butuh package tambahan (murni base R).
# =====================================================================

# ---- 1. Load data (otomatis dari GitHub) ----
DATA_URL <- "https://raw.githubusercontent.com/dandienter/skripsi-malaria-sumsel/master/data/malaria_sumsel_tidy.csv"
LOCAL_CSV <- "data/malaria_sumsel_tidy.csv"

df <- tryCatch(
  read.csv(DATA_URL, stringsAsFactors = FALSE),
  error = function(e) read.csv(LOCAL_CSV, stringsAsFactors = FALSE)
)
cat("Baris:", nrow(df), "| Kab/Kota:", length(unique(df$kab)),
    "| Tahun:", paste(sort(unique(df$tahun)), collapse = ", "), "\n\n")

# ---- 2. Fungsi bantu ----
mae  <- function(a, b) mean(abs(a - b))
rmse <- function(a, b) sqrt(mean((a - b)^2))
mse  <- function(a, b) mean((a - b)^2)

# SES dengan alpha + level awal dioptimasi (minimasi SSE), base R saja
fit_ses <- function(train) {
  train <- as.numeric(train)
  n <- length(train)
  if (max(train) == 0) {
    return(list(alpha = 0, l0 = 0, fitted = rep(0, n), level = 0))
  }
  sse <- function(par) {
    a <- par[1]; l0 <- par[2]
    lvl <- l0
    e2 <- 0
    for (t in 1:n) {
      e2 <- e2 + (train[t] - lvl)^2   # one-step-ahead error
      lvl <- a * train[t] + (1 - a) * lvl
    }
    e2
  }
  opt <- optim(c(0.1, train[1]), sse, method = "L-BFGS-B",
               lower = c(1e-4, 0), upper = c(1 - 1e-4, max(train) * 2))
  a <- opt$par[1]; l0 <- opt$par[2]
  lvl <- l0; fitted <- numeric(n)
  for (t in 1:n) { fitted[t] <- lvl; lvl <- a * train[t] + (1 - a) * lvl }
  list(alpha = a, l0 = l0, fitted = fitted, level = lvl)
}

split_train_test <- function(y, ratio = 0.8) {
  n_train <- floor(length(y) * ratio)
  list(train = y[1:n_train], test = y[(n_train + 1):length(y)], n_train = n_train)
}

# ---- 3. Statistik deskriptif ----
kabs <- sort(unique(df$kab))
cat("===== 3. Statistik deskriptif =====\n")
desc <- do.call(rbind, lapply(kabs, function(k) {
  y <- df$kasus[df$kab == k]
  data.frame(kab = k, total = sum(y), rata2 = round(mean(y), 4),
             maks = max(y), pct_nol = round(mean(y == 0) * 100, 1))
}))
desc <- desc[order(-desc$total), ]
print(desc, row.names = FALSE)
cat("\nTotal kasus per tahun:\n")
print(aggregate(kasus ~ tahun, df, sum))

# ---- 4. Evaluasi SES di data testing (80/20 kronologis) ----
cat("\n===== 4. Evaluasi SES (training 239 minggu, testing 60 minggu) =====\n")
hasil <- do.call(rbind, lapply(kabs, function(k) {
  y <- df$kasus[df$kab == k][order(df$tahun[df$kab == k], df$pekan[df$kab == k])]
  sp <- split_train_test(y)
  r <- fit_ses(sp$train)
  fc_test <- rep(r$level, length(sp$test))
  data.frame(kab = k,
             alpha_train = round(r$alpha, 6),
             MAE_test  = round(mae(sp$test, fc_test), 4),
             RMSE_test = round(rmse(sp$test, fc_test), 4),
             MSE_test  = round(mse(sp$test, fc_test), 4))
}))
hasil <- hasil[order(hasil$RMSE_test), ]
print(hasil, row.names = FALSE)

# ---- 5. Dua alpha: alpha training vs alpha full ----
cat("\n===== 5. Dua alpha (training vs full) =====\n")
alfa <- do.call(rbind, lapply(kabs, function(k) {
  y <- df$kasus[df$kab == k][order(df$tahun[df$kab == k], df$pekan[df$kab == k])]
  sp <- split_train_test(y)
  r_tr <- fit_ses(sp$train)
  r_fu <- fit_ses(y)
  data.frame(kab = k, alpha_train = round(r_tr$alpha, 6), alpha_full = round(r_fu$alpha, 6))
}))
print(alfa, row.names = FALSE)

# ---- 6. Kelayakan model: SES vs baseline naive ----
cat("\n===== 6. Kelayakan model: SES vs baseline naive =====\n")
cat("Baseline naive = ramalan datar sebesar nilai minggu terakhir training.\n")
cat("Tidak ada cutoff universal untuk MAE/RMSE/MSE; model dinilai dari\n")
cat("perbandingan dengan skala data dan dengan baseline sederhana.\n\n")
base <- do.call(rbind, lapply(kabs, function(k) {
  y <- df$kasus[df$kab == k][order(df$tahun[df$kab == k], df$pekan[df$kab == k])]
  sp <- split_train_test(y)
  r <- fit_ses(sp$train)
  fc_ses <- rep(r$level, length(sp$test))
  fc_naive <- rep(sp$train[length(sp$train)], length(sp$test))
  data.frame(kab = k,
             MAE_SES = round(mae(sp$test, fc_ses), 4),
             MAE_naive = round(mae(sp$test, fc_naive), 4),
             RMSE_SES = round(rmse(sp$test, fc_ses), 4),
             RMSE_naive = round(rmse(sp$test, fc_naive), 4))
}))
cat("Rata-rata MAE  SES  :", round(mean(base$MAE_SES), 4), "\n")
cat("Rata-rata MAE  naive:", round(mean(base$MAE_naive), 4), "\n")
cat("Rata-rata RMSE SES  :", round(mean(base$RMSE_SES), 4), "\n")
cat("Rata-rata RMSE naive:", round(mean(base$RMSE_naive), 4), "\n")
cat("SES menang (MAE) di", sum(base$MAE_SES < base$MAE_naive), "dari", nrow(base), "kab/kota\n\n")
print(base, row.names = FALSE)

# ---- 7. Forecast 8 minggu ke depan (minggu 40-47 tahun 2026) ----
cat("\n===== 7. Forecast 8 minggu ke depan (refit seluruh data) =====\n")
fc_rows <- do.call(rbind, lapply(kabs, function(k) {
  y <- df$kasus[df$kab == k][order(df$tahun[df$kab == k], df$pekan[df$kab == k])]
  r <- fit_ses(y)
  data.frame(kab = k, minggu_ke = 1:8, tahun = 2026, pekan = 39 + 1:8,
             forecast = round(rep(r$level, 8), 4),
             alpha_full = round(r$alpha, 6))
}))
print(fc_rows, row.names = FALSE)

# ---- 8. Simpan output ----
dir.create("output", showWarnings = FALSE)
write.csv(hasil, "output/ringkasan_evaluasi_r.csv", row.names = FALSE)
write.csv(fc_rows, "output/forecast_8minggu_r.csv", row.names = FALSE)
cat("\nOutput tersimpan: output/ringkasan_evaluasi_r.csv, output/forecast_8minggu_r.csv\n")
cat("SELESAI.\n")
