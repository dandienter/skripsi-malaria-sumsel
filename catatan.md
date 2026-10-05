# Skripsi Teman Dandi — Pemodelan Deret Waktu Malaria Sumsel

Disimpan 5 Okt 2026 dari penjelasan via Dandi. (Nama teman belum diketahui.)

## Judul
"Pemodelan Deret Waktu Kasus Malaria Konfirmasi di Provinsi Sumatera Selatan Tahun 2021-2026"

## Data
- Kasus malaria konfirmasi, per minggu epidemiologi (1–52), 2021 s.d. minggu terakhir yang didapat di 2026 (misal minggu ke-40).
- Unit analisis: 17 kabupaten/kota di Sumatera Selatan → 17 plot time series + 17 forecasting.
- Alasan mingguan (bukan bulanan): dospem mau banyak titik pengamatan biar makin akurat; bulanan cuma ~60 titik.
- Masalah: data banyak sekali nilai 0 di tiap kab/ko.

## Metode
- Single Exponential Smoothing (SES), disuruh dosen. Kating pakai ARIMA.
- SES untuk data tanpa tren dan tanpa musiman; parameter yang dioptimasi cuma alpha (rentang 0–1).
- Forecast: 8 minggu ke depan dari data terakhir.
- Catatan: SES menghasilkan ramalan KONSTAN (flat) — dulu mau forecast 2026–2030 tapi ditolak bapak karena hasilnya sama semua.

## Train / Test (belum paham)
- Katanya 80% training, 20% testing, tapi belum paham mekanismenya dan gunanya untuk forecasting.
- Perlu dijelaskan: split kronologis (bukan acak), evaluasi di data testing.

## Tools
- Bebas: RStudio atau Python. Dosen menyarankan Python, tapi mereka tidak paham coding.
- Selama ini pakai RStudio mengikuti tutorial YouTube.
- Dosen coba Python tapi hasilnya beda karena beliau hardcode alpha (bukan optimasi otomatis). Di RStudio alpha ≈ 0,0001 (optimasi otomatis).

## Evaluasi
- Metrik: MAE, RMSE, MAPE, MSE (pada fitted values).
- Masalah: data banyak 0 → di RStudio RMSE (kemungkinan maksudnya MAPE) jadi inf/NaN tidak muncul; di Python dosen RMSE-nya muncul tapi alpha-nya hardcode.
- Catatan untuk nanti: yang tidak toleran terhadap nol itu MAPE (pembagian dengan aktual=0), bukan RMSE. RMSE tetap bisa dihitung dengan data nol.

## Tujuan penelitian
- Belum ketemu/rumuskan. Perlu dibantu merumuskan tujuan yang sesuai (deskripsi pola? perbandingan antar kab/ko? rekomendasi?).

## Referensi
- https://otexts.com/fpp3/what-can-be-forecast.html — Forecasting: Principles and Practice 3e, bab "what can be forecast"
- https://otexts.com/fpppy/ — versi Python dari buku yang sama (cocok untuk saran dosen pakai Python)

- https://youtu.be/jsSIuThtBPU — tutorial forecasting
- https://youtu.be/wgjOhbIsjdA — "TS 05 | Simple Exponential Smoothing Forecasting | Peramalan Data Deret Waktu" (tutorial spreadsheet SES manual: alpha 0.6, rumus ŷt = α·y_{t-1} + (1-α)·ŷ_{t-1}, hitung MAE/MSE/RMSE manual)
- "F" = Forecast (tutorial forecasting)

## Status
- 5 Okt 2026 ~23:45: folder Google Drive teman ditemukan (55 file): Dataset Malaria Sumsel.xlsx, Dataset Versi Gue.xlsx, Laporan Malaria 2021-2025 (Sumsel/Pulau Sumatera/Seindonesia), PEDOMAN TUGAS AKHIR-SKRIPSI 2025.pdf, 14 artikel + versi Indonesia, dokumen SKDR/KMK eliminasi malaria.
- Data 2026 BELUM ADA — Dandi lagi siapin.
- Sesi tanya-jawab via VN selesai, jawaban siap-salin sudah dikirim ke teman: (1) fungsi data testing, (2) uji Ljung-Box boleh diskip kalau dospem bilang ga usah, (3) urgensi dicari dari data, (4) ADF ga perlu buat SES (syarat ARIMA), (5) ganti penyakit = ngulang dari nol + wajib acc dosen, (6) workflow train 2021-2023/test 2024/evaluasi/refit full data/forecast 8 minggu, (7) periode split bebas asal kronologis, saran test di data paling akhir, (8) evaluasi bisa manual atau program.
- MENUNGGU: jawaban 4 pertanyaan konfirmasi dari teman (9 kab/ko 2026 = nol?; OKI vs OKU ketuker; Palembang minggu 1 2021 = 50 kasus bener?; data terakhir minggu 39 2026?) → baru eksekusi notebook.
- Dandi memberi akses: ambil sendiri file apapun yang dibutuhkan dari folder Drive bila kurang.
