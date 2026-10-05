# Pemodelan Deret Waktu Kasus Malaria Konfirmasi di Provinsi Sumatera Selatan Tahun 2021-2026

Metode: **Single Exponential Smoothing (SES)**

[![Buka di Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/dandienter/skripsi-malaria-sumsel/blob/master/notebook/ses_malaria_sumsel.ipynb)
[![PDF Dokumentasi](https://img.shields.io/badge/PDF-Dokumentasi_Lengkap-d93025?logo=adobeacrobatreader&logoColor=white)](https://github.com/dandienter/skripsi-malaria-sumsel/blob/master/output/Dokumentasi_Analisis_SES_Malaria_Sumsel.pdf)
[![Data Tidy](https://img.shields.io/badge/CSV-Data_Tidy-2da44e?logo=github&logoColor=white)](https://github.com/dandienter/skripsi-malaria-sumsel/blob/master/data/malaria_sumsel_tidy.csv)
[![Glosarium](https://img.shields.io/badge/MD-Glosarium-1f6feb?logo=github&logoColor=white)](https://github.com/dandienter/skripsi-malaria-sumsel/blob/master/GLOSARIUM.md)
[![R Script](https://img.shields.io/badge/R-Script_SES-276DC3?logo=r&logoColor=white)](https://github.com/dandienter/skripsi-malaria-sumsel/blob/master/rscript/ses_malaria_sumsel.R)

Klik badge di atas untuk langsung membuka notebook di Google Colab, mengunduh PDF dokumentasi, melihat data, membaca glosarium, atau membuka script R. Data diambil otomatis dari repo ini, tidak perlu upload manual.

Tersedia dua implementasi yang saling memverifikasi: **Python** (`notebook/`) dan **R** (`rscript/`).

## Isi repo

| File | Keterangan |
|---|---|
| `notebook/ses_malaria_sumsel.ipynb` | Notebook utama Python, siap dibuka di Google Colab. Jalankan cell dari atas ke bawah. |
| `rscript/ses_malaria_sumsel.R` | Script R (RStudio) yang sama persis alurnya, murni base R tanpa package tambahan. Buka di RStudio lalu klik Source. |
| `data/malaria_sumsel_tidy.csv` | Data siap olah: 5083 baris (17 kab/kota x 299 minggu), kolom kab, tahun, pekan, kasus. |
| `output/ringkasan_evaluasi.csv` | Tabel evaluasi Python per kab/kota: alpha training, alpha full, MAE, RMSE, MSE di data testing. |
| `output/ringkasan_evaluasi_r.csv` | Tabel evaluasi versi R (untuk perbandingan). |
| `output/forecast_8minggu.csv` | Hasil forecast Python 8 minggu ke depan (minggu 40-47 tahun 2026) per kab/kota. |
| `output/forecast_8minggu_r.csv` | Hasil forecast versi R (untuk perbandingan). |
| `output/plot/` | 17 plot deret waktu lengkap (aktual + fitted + forecast testing + forecast 8 minggu). |
| `GLOSARIUM.md` | Penjelasan istilah: outlier, sparse data, dan istilah asing lain yang muncul di pekerjaan ini. |

## Cara pakai

**Python (Google Colab):**
1. Klik badge "Buka di Colab" di atas.
2. Jalankan semua cell berurutan (Runtime > Run all atau Shift+Enter satu per satu). Data diambil otomatis, tidak perlu upload.

**R (RStudio):**
1. Buka file `rscript/ses_malaria_sumsel.R` di RStudio.
2. Klik **Source** (atau Ctrl+Shift+Enter). Data diambil otomatis dari GitHub; kalau gagal, script otomatis membaca `data/malaria_sumsel_tidy.csv` lokal.
3. Output tampil di console dan tersimpan sebagai CSV di folder `output/`.

## Ringkasan alur

1. **Statistik deskriptif**: total kasus, rata-rata, persen minggu nol per kab/kota.
2. **Plot deret waktu**: memastikan tidak ada tren dan musiman (syarat SES).
3. **Split kronologis 80/20**: 239 minggu pertama = training, 60 minggu terakhir = testing.
4. **Latih SES di training**: alpha dioptimasi otomatis per kab/kota.
5. **Evaluasi**: model meramal periode testing, dihitung MAE, RMSE, MSE. MAPE tidak dipakai karena 96,3% data bernilai nol (pembagian dengan nol menghasilkan tak hingga).
6. **Dua alpha**: alpha training (untuk evaluasi testing) dan alpha full hasil optimasi ulang memakai seluruh data (untuk forecast final).
7. **Kelayakan model**: tidak ada cutoff universal untuk MAE/RMSE/MSE. Model dibandingkan dengan baseline naive (ramalan = nilai terakhir training) dan dinilai relatif terhadap skala data.
8. **Refit seluruh data** (2021 s.d. minggu 39 2026), **forecast 8 minggu** ke depan (minggu 40-47 2026).

## Perbandingan hasil Python vs R

Kedua implementasi memakai alur yang sama dan kesimpulannya identik:

* Statistik deskriptif: sama persis.
* Alpha optimal: mendekati 0 di hampir semua kab/kota pada kedua implementasi (Python: 0,0 via statsmodels; R: 0,0001 via optim base R). Satu-satunya alpha non-trivial, Kab. OKI (0,2136), sama sampai 5 desimal.
* MAE/RMSE/MSE testing: selisih maksimal 0,015.
* Forecast 8 minggu: selisih maksimal 0,036 kasus per minggu (contoh Banyuasin: Python 0,9164 vs R 0,9163).

Selisih kecil ini wajar, akibat perbedaan rutin optimasi (statsmodels vs `optim` di R) dan inisialisasi level, bukan perbedaan metode.

Kedua implementasi juga sepakat soal kelayakan model: baseline naive ("ramal = nilai terakhir training") menang MAE di 16 dari 17 kab/kota, karena data testing didominasi nol. Lihat `output/ringkasan_evaluasi.csv` vs `output/ringkasan_evaluasi_r.csv`, dan output console R di `output/hasil_r.txt`.

## Catatan data (sudah dikonfirmasi ke sumber)

* Data 2021-2025: rekap dataset malaria Sumatera Selatan (mingguan per kab/kota).
* Data 2026 minggu 1-39: laporan analisa SKDR Kementerian Kesehatan RI. Minggu 39 adalah minggu epidemiologi berjalan saat analisis dilakukan. 9 kab/kota yang tidak muncul di laporan tercatat nol kasus (sudah dikonfirmasi).
* Penamaan wilayah (sudah dikonfirmasi): OKI = Kabupaten Ogan Komering Ilir, OKU = Kabupaten Ogan Komering Ulu, OKUS = Kabupaten Ogan Komering Ulu Selatan, OKUT = Kabupaten Ogan Komering Ulu Timur, OI = Kabupaten Ogan Ilir.
* Outlier (mis. Banyuasin minggu 15/2022: 218 kasus) nilainya sesuai laporan SKDR. Apakah lonjakan tersebut benar terjadi di lapangan masih perlu konfirmasi ke dinas kesehatan setempat. Nilai dipertahankan apa adanya.
* Kota Pagar Alam: nol kasus selama 2021-2026, forecast-nya nol.

## Sumber

* Hyndman, R.J. & Athanasopoulos, G. Forecasting: Principles and Practice, bab Simple Exponential Smoothing. https://otexts.com/fpp3/
* Dokumentasi statsmodels `SimpleExpSmoothing`. https://www.statsmodels.org/
* Sistem Kewaspadaan Dini dan Respon (SKDR), Ditjen P2P, Kementerian Kesehatan RI.
