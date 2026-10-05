# Glosarium Istilah

Penjelasan istilah yang muncul di pekerjaan pemodelan deret waktu ini, dengan bahasa yang sederhana.

## Outlier (data pencilan)

Data yang nilainya jauh berbeda dari pola umum. Contoh di data ini: Kota Palembang minggu 1 tahun 2021 tercatat 50 kasus, padahal minggu-minggu lain hampir selalu 0 atau 1. Nilai 50 itu outlier.

Outlier belum tentu salah input. Bisa jadi memang ada kejadian luar biasa (misal KLB), bisa juga salah catat. Sikap yang benar: tandai, cek ke sumbernya, dan bahas di skripsi. Jangan diam-diam dihapus karena bisa dianggap manipulasi data.

## Sparse data (data jarang)

Data yang sebagian besar nilainya nol, kasus hanya muncul sesekali. Di data ini 96,3% minggu bernilai nol. Ini wajar untuk penyakit yang sudah jarang seperti malaria di Sumsel, bukan tanda data rusak.

Dampaknya ke analisis:
* Model SES menghasilkan alpha sangat kecil (mendekati 0), artinya model "menyerah" mengikuti data dan ramalannya mendekati rata-rata historis.
* MAPE tidak bisa dipakai (pembagian dengan nol).
* Forecast cenderung datar dan rendah. Itu jawaban yang valid, bukan kegagalan.

## Istilah asing lain

**Time series (deret waktu)**: data yang dicatat berurutan menurut waktu. Di sini: jumlah kasus per minggu epidemiologi.

**SES (Single Exponential Smoothing)**: metode peramalan yang menghitung rata-rata berbobot dari data masa lalu. Data terbaru diberi bobot lebih besar. Cocok untuk data tanpa tren dan tanpa pola musiman.

**Alpha (smoothing level)**: satu-satunya parameter SES, nilainya 0 sampai 1. Mengatur seberapa cepat model mengikuti data terbaru. Alpha kecil = model cuek, lebih percaya rata-rata lama. Alpha besar = model reaktif, cepat mengikuti perubahan.

**Fitted value**: nilai yang dihasilkan model untuk periode yang sudah ada datanya (masa lalu). Bandingkan fitted value dengan data asli untuk melihat seberapa bagus model "menjelaskan" data latih.

**Forecast**: ramalan untuk periode yang belum ada datanya (masa depan). Di sini: 8 minggu ke depan.

**Forecast horizon**: seberapa jauh ke depan model meramal. Di sini horizon = 8 minggu.

**Training data (data latih)**: 80% data pertama, dipakai untuk melatih model dan mencari alpha terbaik.

**Testing data (data uji)**: 20% data terakhir, dipakai untuk menguji. Model disuruh meramal periode ini, lalu hasilnya dibandingkan dengan data aslinya. Data testing tidak pernah dipakai untuk melatih model.

**Out-of-sample evaluation**: penilaian model memakai data yang belum pernah dilihat model (data testing). Lawannya in-sample, yaitu menilai model pakai data yang sama dengan data latih (nilainya cenderung terlalu bagus).

**Residual**: selisih antara data asli dan fitted value. Idealnya residual tinggal noise acak tanpa pola.

**MAE (Mean Absolute Error)**: rata-rata nilai mutlak selisih ramalan vs aktual. Satuannya sama dengan data (kasus). Makin kecil makin bagus.

**RMSE (Root Mean Squared Error)**: seperti MAE tapi selisihnya dikuadratkan dulu sebelum dirata-rata, sehingga kesalahan besar dihukum lebih berat. Satuannya sama dengan data (kasus).

**MSE (Mean Squared Error)**: rata-rata selisih kuadrat. RMSE adalah akar dari MSE.

**MAPE (Mean Absolute Percentage Error)**: MAE dalam bentuk persen. Tidak dipakai di sini karena banyak nilai aktual nol (pembagian dengan nol = tak hingga).

**Level**: perkiraan nilai dasar deret waktu menurut SES. Forecast SES untuk semua minggu ke depan sama dengan level terakhir.

**White noise**: deret acak tanpa pola. Residual model yang bagus seharusnya mirip white noise.

**Stasioneritas**: sifat data yang rata-rata dan variasinya stabil sepanjang waktu. Ini syarat metode ARIMA, bukan syarat SES, jadi tidak diuji di sini.

**ADF test (Augmented Dickey-Fuller)**: uji statistik untuk stasioneritas. Dipakai kakak tingkat karena metodenya ARIMA. Untuk SES tidak diperlukan.
