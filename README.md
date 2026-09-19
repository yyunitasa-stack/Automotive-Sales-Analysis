# Automotive Performance Sales Analysis | SQL & Power BI

## Project Overview
<p style="text-align: justify; text-indent: 40px;">
<i>Management</i> menghadapi keterbatasan visibilitas terhadap data transaksi, sehingga masih sulit untuk memantau pola penjualan, mengevaluasi performa produk dan cabang, serta memahami preferensi metode pembayaran dan status transaksi secara menyeluruh. Project ini dilakukan untuk membantu perusahaan otomotif memahami performa penjualan kendaraan selama tahun 2025.
</p>
<p style="text-align: justify; text-indent: 40px;">
Analisis dilakukan berdasarkan data transaksi penjualan kendaraan tahun 2025. <i>Key questions</i> yang dieksplorasi meliputi performa penjualan, produk, cabang, metode pembayaran, status transaksi.
</p>
<p style="text-align: justify; text-indent: 40px;">
Power BI digunakan untuk melakukan analisis dan visualisasi data, dengan memanfaatkan DAX (Data Analysis Expressions) untuk membuat <i>calculated columns dan measures</i>. Hasil analisis digunakan untuk mengidentifikasi pola dan performa utama dalam penjualan serta menghasilkan <i>insights</i> yang dapat mendukung proses monitoring dan pengambilan <i>business reccomendations</i>.
</p>

## Dataset
<p style="text-align:justify;text-indent:40px;">
Dataset yang digunakan pada <i>project</i> ini merupakan data <i>dummy</i> yang terdiri dari 10.000 baris dan 16 kolom.
</p>

| <i>Key Features</i> | Kolom |
| --- | --- |
| Transaction details | sales_date, order_id, payment_type,  status |
| Customer information | customer |
| Vechile preferences | product_name, category, color |
| Branch performance | branch, branch_adress |
| Sales performance | price, quantity, discount, trade_in, total, total_sales |

Detail dari dataset bisa dilihat di sini.

## Project Workflow
<p style="text-align:justify;text-indent:40px;">
<i>Project</i> dikerjakan melalui beberapa tahapan berikut.
</p>
<p align="center">
<img src="./Image/ProjectWorkflow.png">
</p>
<p style="text-align:justify">
Kualitas dataset dapat diperiksa dengan cepat menggunakan fitur Column quality yang tersedia di Power BI. Hasil pemeriksaan menunjukkan bahwa setiap kolom memiliki nilai yang valid dan tidak ditemukan missing value. Namun, tipe data pada kolom sales_date perlu diubah menjadi tipe data Date agar dapat digunakan dengan tepat dalam analisis berdasarkan waktu. </p>

![alt text](./Image/image-3.png)
<p style="text-align:justify">
Sebelum menyusun dashboard interaktif, perlu membuat new table yaitu Date Table untuk memisahkan informasi waktu seperti tanggal, bulan, kuartal, dan tahun.</p>

```
Date Table = 
ADDCOLUMNS(
    CALENDAR(
        MIN(Sheet1[sales_date]),
        MAX(Sheet1[sales_date])),
    "Year", YEAR([Date]),
    "Month", FORMAT([Date], "MMMM"),
    "Quarter", "Q" & FORMAT([Date], "Q"))
```

<p style="text-align:justify">
Selanjutnya, tabel Date Table dihubungkan dengan tabel utama seperti yang ditunjukkan pada <i>relationship</i> diagram berikut. </p>
<p align="center">
<img src=./Image/image-4.png width=400>
</p>

<p style="text-align:justify">
Kemudian, dibuat beberapa "new measure" untuk melakukan perhitungan dan menampilkan metrik yang diperlukan dalam <i>dashboard</i>. Pada <i>project</i> ini, beberapa <i>measure</i> yang digunakan meliputi Total Sales, Total Transaction, Total Quantity, Completion Rate, Completed Sales, dan Completed Transaction. </p>

```
Total Sales = SUM(Sheet1[total_sales])
```
```
Total Transaction = COUNTA(Sheet1[order_id])
```
```
Total Quantity = SUM(Sheet1[quantity])
```
```
Completion Rate = DIVIDE([Completed Transaction],[Total Transaction])
```
```
Completed Sales = CALCULATE([Total Sales],Sheet1[status]="completed")
```
```
Completed Transaction = CALCULATE([Total Transaction],Sheet1[status]="completed")
```

## EDA (Exploratory Data Analysis) using SQL
<p style="text-align:justify;text-indent:40px">
Analisis secara mendalam untuk mejawab <i>business questions</i> dilakukan menggunakan PostgreSQL. Detail <i>query</i> dapat dilihat di sini. </p>

<p style="text-align: justify; margin-bottom: 3px;">
<b>Sales Trend Over Time</b></p>

> Melihat perkembangan penjualan dari waktu ke waktu (setiap bulan periode tahun 2025)

<p align="center">
  <img src="./Image/image-5.png" width=500 style="position: relative; top: -45px">
  <img src=./Image/image-6.png width=200>
</p>
<p style="text-align:justify">
Penjualan bulanan menunjukkan fluktuasi, dengan kenaikan tertinggi terjadi pada bulan Juni ke Juli, yaitu dari Rp212,88 miliar menjadi Rp250,19 miliar. Kemudian mencapai level tertinggi pada Juli – Agustus dan  kembali menurun pada September. </p>

<p style="text-align: justify; margin-bottom: 3px;">
<b>Branch Performance</b></p>

> Membandingkan performa penjualan antar cabang
<p align="center">
  <img src="./Image/image-7.png" width=450 style="position: relative; top: -18px">
  <img src="./Image/image-8.png" width=175>
</p>
<p style="text-align:justify">
Cabang Malang menghasilkan Rp292,17 miliar atau sekitar Rp27,08 miliar lebih tinggi dibandingkan cabang dengan penjualan terendah, yaitu Karawang.</p>

<p style="text-align: justify; margin-bottom: 3px;">
<b>Sales Performance by Category</b></p>

> Mengetahui kategori kendaraan dengan kontribusi penjualan terbesar
<p align="center">
  <img src="./Image/image-9.png" width=450>
  <img src="./Image/image-10.png" width=180 style="position: relative; top: -30px">
</p>
<p style="text-align:justify">
SUV mencatat penjualan tertinggi sebesar Rp1,51 triliun, jauh lebih tinggi dibandingkan kategori kendaraan lainnya.</p>

<p style="text-align: justify; margin-bottom: 3px;">
<b>Top 5 Best-Selling Products</b></p>

> Mengidentifikasi produk dengan penjualan tertinggi
<p align="center">
  <img src="./Image/image-11.png" width=450>
  <img src="./Image/image-12.png" width=270 style="position: relative; top: -30px">
</p>

<p style="text-align:justify">
</p>

<p style="text-align: justify; margin-bottom: 3px;">
<b>Top 1 Product by Branch</b></p>

> Mengetahui produk unggulan di setiap cabang
<p align="center">
  <img src="./Image/image-13.png" width=450>
</p>
<p style="text-align:justify">
Kategori SUV mendominasi penjualan di seluruh cabang yang dianalisis. Honda CR-V 1.5 Turbo RS menjadi model yang paling sering mencatat penjualan tertinggi, diikuti Toyota Fortuner 2.4 VRZ 4x2 AT dan Mitsubishi Pajero Sport Dakar 4x2 AT.</p>

<p style="text-align: justify; margin-bottom: 3px;">
<b>Customer Transaction Frequency</b></p>

> Mengidentifikasi customer dengan frekuensi transaksi tinggi
<p align="center">
  <img src="./Image/image-14.png" width=300
</p>
<p style="text-align:justify">
</p>

<p style="text-align: justify; margin-bottom: 3px;">
<b>Transaction Status Distribution</b></p>

> Melihat kondisi transaksi berdasarkan status
<p align="center">
  <img src="./Image/image-15.png" width=200>
  <img src="./Image/image-16.png" width=350 style="position: relative; top: -40px">
</p>
<p style="text-align:justify">
</p>

## Dashboard in Power BI
<p style="text-align:justify;text-indent:40px;">
Performa penjualan kendaraan selama tahun 2025 divisualisasikan melalui <i>dashboard</i> interaktif menggunakan Power BI sebagai berikut.
</p>

![alt text](./Image/image-2.png)

Klik [di sini](https://app.powerbi.com/view?r=eyJrIjoiNzUxMGE1YWEtMWNhYy00Y2MyLWEzNTctNmE4OTM5NWVhNDU3IiwidCI6IjA2NWRlODU2LTE3NzAtNGZiZS05N2U0LTdjZTA1MTMxYThhNSIsImMiOjEwfQ%3D%3D) untuk melihat detail <i>dashboard</i>.

## Key Insights
- <b><p style="text-align:justify">Kategori SUV Mendominasi Penjualan</b>
SUV berkontribusi  sebesar Rp1,77 triliun, atau sekitar 57% dari total sales, jauh lebih tinggi dibandingkan kategori kendaraan lainnya.</p>
- <b><p style="text-align:justify">Metode Pembayaran Kredit Menjadi Pilihan Utama Pelanggan </b>
Pembayaran secara kredit mencakup 50,4% dari total transaksi dan menjadi metode pembayaran yang paling banyak diminati dan digunakan oleh pelanggan dalam membeli kendaraan.</p>
- <b><p style="text-align:justify">10,3% Transaksi Tidak Selesai </b>
Total transaksi dengan status <i>cancellation & refund</i> mencapai 10,3% dari total transaksi.</p>

## Business Reccomendations
- <b><p style="text-align:justify">Prioritaskan Promosi dan Ketersediaan Stok pada Kategori SUV</b>
Dengan kontribusi sekitar 57% dari total sales, perusahaan dapat memprioritaskan ketersediaan unit SUV serta menyusun strategi promosi yang sesuai untuk mempertahankan dan meningkatkan kontribusi penjualan kategori tersebut.</p>
- <b><p style="text-align:justify">Optimalkan Penawaran Pembayaran secara Kredit</b>
Karena 50,4% pembayaran transaksi dilakukan secara kredit, perusahaan dapat memperkuat penawaran dengan menambah opsi tenor dan memberikan informasi cicilan yang jelas untuk mempermudah pelanggan dalam proses pembelian kendaraan. </p>
- <b><p style="text-align:justify">Evaluasi Penyebab Cancellation & Refund</b>
Transaksi yang tidak selesai/tuntas mencapai 10,3%. Sehingga perusahaan perlu mengidentifikasi dan mengevaluasi penyebabnya sebagai antisipasi untuk mengurangi potensi peningkatan transaksi <i>cancelltion & refund</i></p>

## Limitations
- <b><p style="text-align:justify">Informasi Customer Terbatas</b>
Data pelanggan hanya mencakup nama customer, belum tersedia informasi demografis seperti usia, jenis kelamin, lokasi, atau profil pelanggan. Sehingga tidak dapat dilakukan segmentasi customer secara lebih mendalam.</p>