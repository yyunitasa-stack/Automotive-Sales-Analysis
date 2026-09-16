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

-- menampilkan semua data
SELECT * FROM automotive.showroom_mobil;

-- top 5 branch by total sales
SELECT branch, SUM(total_sales) AS Total_Penjualan
FROM automotive.showroom_mobil
GROUP BY branch
ORDER BY Total_Penjualan DESC
LIMIT 5;

-- top 5 products by total sales
SELECT product_name, SUM(total_sales) AS Total_Penjualan
FROM automotive.showroom_mobil
GROUP BY product_name
ORDER BY Total_Penjualan DESC
LIMIT 5;

-- payment type distribution
SELECT payment_type, COUNT(*) AS Jumlah_Transaksi
FROM automotive.showroom_mobil
GROUP BY payment_type;

-- status distribution & berdasarkan total sales
SELECT status, COUNT(*) AS Jumlah_Transaksi, SUM(total_sales) AS Total_Penjualan
FROM automotive.showroom_mobil
GROUP BY status;

-- top 3 customer dengan pembelian di atas rata-rata penjualan
WITH customer_sales AS (
    SELECT
        customer_name,
        SUM(total_sales) AS total_pembelian
    FROM automotive.showroom_mobil
    GROUP BY customer_name
)

SELECT
    customer_name,
    total_pembelian
FROM customer_sales
WHERE total_pembelian > (
    SELECT AVG(total_pembelian)
    FROM customer_sales
)
ORDER BY total_pembelian DESC
LIMIT 3;
