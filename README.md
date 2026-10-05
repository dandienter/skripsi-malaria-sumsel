# Pemodelan Deret Waktu Kasus Malaria Konfirmasi di Provinsi Sumatera Selatan Tahun 2021-2026

Metode: **Single Exponential Smoothing (SES)**

## Isi repo

| File | Keterangan |
|---|---|
| `notebook/ses_malaria_sumsel.ipynb` | Notebook utama, siap dibuka di Google Colab. Jalankan cell dari atas ke bawah. |
| `data/malaria_sumsel_tidy.csv` | Data siap olah: 5083 baris (17 kab/kota x 299 minggu), kolom kab, tahun, pekan, kasus. |
| `output/ringkasan_evaluasi.csv` | Tabel evaluasi per kab/kota: alpha, MAE, RMSE, MSE di data testing. |
| `output/forecast_8minggu.csv` | Hasil forecast 8 minggu ke depan (minggu 40-47 tahun 2026) per kab/kota. |
| `output/plot/` | 17 plot deret waktu lengkap (aktual + fitted + forecast testing + forecast 8 minggu). |
| `GLOSARIUM.md` | Penjelasan istilah: outlier, sparse data, dan istilah asing lain yang muncul di pekerjaan ini. |

## Cara pakai di Google Colab

1. Buka https://colab.research.google.com, pilih File > Upload notebook, pilih `ses_malaria_sumsel.ipynb`.
2. Upload juga `malaria_sumsel_tidy.csv` saat diminta di cell ke-2.
3. Jalankan semua cell berurutan (Runtime > Run all atau Shift+Enter satu per satu).

## Ringkasan alur

1. **Statistik deskriptif**: total kasus, rata-rata, persen minggu nol per kab/kota.
2. **Plot deret waktu**: memastikan tidak ada tren dan musiman (syarat SES).
3. **Split kronologis 80/20**: 239 minggu pertama = training, 60 minggu terakhir = testing.
4. **Latih SES di training**: alpha dioptimasi otomatis per kab/kota.
5. **Evaluasi**: model meramal periode testing, dihitung MAE, RMSE, MSE. MAPE tidak dipakai karena 96,3% data bernilai nol (pembagian dengan nol menghasilkan tak hingga).
6. **Refit seluruh data** (2021 s.d. minggu 39 2026), **forecast 8 minggu** ke depan (minggu 40-47 2026).

## Catatan data

* Data 2021-2025: rekap dataset malaria Sumatera Selatan (mingguan per kab/kota).
* Data 2026 minggu 1-39: laporan analisa SKDR Kementerian Kesehatan RI. 9 kab/kota tidak muncul di laporan dan diasumsikan nol kasus (perlu konfirmasi ulang ke sumber).
* Sheet "Kab. OKI" = Kabupaten Ogan Komering Ilir, sheet "Kab. OKU" = Kabupaten Ogan Komering Ulu (nama di file Excel terpotong).
* Kota Pagar Alam: nol kasus selama 2021-2026, forecast-nya nol.

## Sumber

* Hyndman, R.J. & Athanasopoulos, G. Forecasting: Principles and Practice, bab Simple Exponential Smoothing. https://otexts.com/fpp3/
* Dokumentasi statsmodels `SimpleExpSmoothing`. https://www.statsmodels.org/
* Sistem Kewaspadaan Dini dan Respon (SKDR), Ditjen P2P, Kementerian Kesehatan RI.
