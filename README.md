# E-Commerce Database Architecture & SQL Analytics

A fully normalized, relational database architecture designed for a high-volume e-commerce storefront. This project demonstrates core database design principles, strict foreign key constraints, and production-grade analytical SQL queries.

## 🗄️ Database Schema & ER Diagram
The database consists of 4 core interconnected tables:
- **Customers**: Stores user profiles, contact information (with standard domain mapping), and registration metadata.
- **Products**: Manages catalog items, product categories, pricing, and live inventory stock.
- **Orders**: Tracks transactional records, order dates, total purchase amounts, and status.
- **Order_Items**: A junction table linking orders to specific products with exact quantities and historical purchase pricing.

*(You can drag and drop your `ecommerce_er_diagram.png` right here in GitHub's editor to display it!)*

## 🚀 Key SQL Features Included
1. **Relational Constraints**: Implemented strict Primary Keys (PK) and Foreign Keys (FK) to maintain zero data redundancy and ensure data integrity.
2. **Common Table Expressions (CTEs)**: Used to segment high-value VIP customers based on lifetime spending.
3. **Time-Series Aggregations**: Calculated monthly revenue growth and order volume trends using date formatting and grouping.
4. **Inventory Management**: Automated low-stock warning queries to flag products falling below safety inventory thresholds.

## 📂 Repository Structure
- `ecommerce_project.sql`: The master SQL script containing the schema creation, seed mock data, email updates, and all analytical showcase queries.

## 📊 Sample Analytical Queries
Here is a snapshot of the advanced queries included in this project, such as identifying VIP customers using CTEs:

```sql
WITH CustomerSpend AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS full_name,
        SUM(o.total_amount) AS total_spent,
        COUNT(o.order_id) AS order_count
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    WHERE o.status = 'Completed'
    GROUP BY c.customer_id, full_name
)
SELECT * 
FROM CustomerSpend 
WHERE total_spent > 100 
ORDER BY total_spent DESC;
