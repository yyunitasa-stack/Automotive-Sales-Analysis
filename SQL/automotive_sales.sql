-- membuat table dan mengimpor file csv
CREATE TABLE public.showroom_mobil(
    sales_date TEXT,
    order_id TEXT,
    customer_name TEXT,
    branch TEXT,
    product_name TEXT,
    category TEXT,
    color TEXT,
    price TEXT,
    quantity TEXT,
    payment_type TEXT,
    trade_in TEXT,
    discount TEXT,
    total TEXT,
    total_sales TEXT,
    status TEXT,
    branch_address TEXT
);

-- menyesuaikan tipe data masing masing kolom
CREATE TABLE automotive.showroom_mobil AS
SELECT
    TO_DATE(sales_date, 'MM/DD/YYYY') AS sales_date,
    order_id,
    customer_name,
    branch,
    product_name,
    category,
    color,
    price::INT AS price,
    quantity::INT AS quantity,
    payment_type,
    trade_in::INT AS trade_in,
    discount::INT AS discount,
    total::INT AS total,
    total_sales::INT AS total_sales,
    status,
    branch_address
FROM automotive.showroom_mobil_raw;

-- menampilkan semua data
SELECT * FROM automotive.showroom_mobil;

-- Sales Trend Over Time
--- Bagaimana perkembangan total penjualan dari waktu ke waktu?
SELECT
    TO_CHAR(sales_date, 'TMMonth') AS bulan,
    SUM(total_sales) AS total_penjualan
FROM automotive.showroom_mobil
WHERE status = 'completed'
GROUP BY
    EXTRACT(MONTH FROM sales_date),
    TO_CHAR(sales_date, 'TMMonth')
ORDER BY
    EXTRACT(MONTH FROM sales_date);

-- Branch Performance
--- Bagaimana performa penjualan di setiap cabang?
SELECT
    branch,
    SUM(total_sales) AS total_penjualan
FROM automotive.showroom_mobil
WHERE status = 'completed'
GROUP BY branch
ORDER BY total_penjualan DESC;

-- Category Performance
--- Kategori kendaraan apa yang memberikan kontribusi penjualan terbesar?
SELECT
    category,
    SUM(total_sales) AS total_penjualan
FROM automotive.showroom_mobil
WHERE status = 'completed'
GROUP BY category
ORDER BY total_penjualan DESC;

-- Top 5 Best-Selling Products
--- Produk kendaraan apa yang memberikan kontribusi penjualan terbesar?
SELECT
    product_name,
    SUM(total_sales) AS total_penjualan
FROM automotive.showroom_mobil
WHERE status = 'completed'
GROUP BY product_name
ORDER BY total_penjualan DESC
LIMIT 5;

-- Top 1 Product by Branch
--- Produk apa yang menjadi produk dengan penjualan tertinggi di setiap cabang?
WITH product_sales AS (
    SELECT
        branch,
        category,
        product_name,
        SUM(total_sales) AS total_penjualan
    FROM automotive.showroom_mobil
    WHERE status = 'completed'
    GROUP BY
        branch,
        category,
        product_name
),
ranked_product AS (
    SELECT
        branch,
        category,
        product_name,
        total_penjualan,
        ROW_NUMBER() OVER (
            PARTITION BY branch
            ORDER BY total_penjualan DESC
        ) AS ranking
    FROM product_sales
)
SELECT
    branch,
    category,
    product_name,
    total_penjualan
FROM ranked_product
WHERE ranking = 1
ORDER BY branch;

-- Customer Transaction Frequency
--- Siapa customer dengan frekuensi transaksi tertinggi?
SELECT
    customer_name,
    COUNT(*) AS jumlah_transaksi,
    SUM(total_sales) AS total_purchase
FROM automotive.showroom_mobil
WHERE status = 'completed'
GROUP BY customer_name
HAVING COUNT(*) >= 5
ORDER BY jumlah_transaksi DESC;

-- Transaction Status Distribution
--- Bagaimana distribusi transaksi berdasarkan status?
SELECT
    status,
    COUNT(*) AS jumlah_transaksi,
    ROUND(
        COUNT(*)::NUMERIC
        / SUM(COUNT(*)) OVER () * 100,
        2
    ) AS persentase_transaksi
FROM automotive.showroom_mobil
GROUP BY status
ORDER BY jumlah_transaksi DESC;