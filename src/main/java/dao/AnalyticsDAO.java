/*
 * AnalyticsDAO
 * Created on : Jan 20, 2025
 * Author     : Dang Vi Danh - CE19687
 */
package dao;

import db.DBContext;
import model.TopProduct;
import java.sql.*;
import java.util.*;

/**
 * DAO class để xử lý các tính toán thống kê và phân tích dữ liệu
 */
public class AnalyticsDAO extends DBContext {

    /**
     * Tính tổng doanh thu từ tất cả các đơn hàng đã hoàn thành
     *
     * @return Tổng doanh thu (long)
     */
    public long getTotalRevenue() {
    String sql = """
        SELECT ISNULL(SUM(total_amount), 0) AS revenue
        FROM [Order]
        WHERE order_status = 'DELIVERED'
    """;

    try (PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        if (rs.next()) {
            return rs.getLong("revenue");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return 0;
}

    /**
     * Lấy danh sách top 5 sản phẩm bán chạy nhất
     *
     * @return List<TopProduct> - Danh sách 5 sản phẩm bán chạy nhất
     */
    public List<TopProduct> getTop5Products() {
    List<TopProduct> list = new ArrayList<>();

    String sql = """
        SELECT TOP 5 
            p.product_id,
            p.product_name,
            b.brand_name,
            p.image,
            SUM(od.quantity) AS total_sold
        FROM OrderDetail od
        JOIN [Order] o ON od.order_id = o.order_id
        JOIN Product p ON od.product_id = p.product_id
        LEFT JOIN Brand b ON p.brand_id = b.brand_id
        WHERE o.order_status = 'DELIVERED'
        GROUP BY p.product_id, p.product_name, b.brand_name, p.image
        ORDER BY total_sold DESC
    """;

    try (PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            TopProduct tp = new TopProduct();
            tp.setProductId(rs.getInt("product_id"));
            tp.setProductName(rs.getString("product_name"));
            tp.setBrand(rs.getString("brand_name"));
            tp.setImage(rs.getString("image"));
            tp.setTotalSold(rs.getInt("total_sold"));
            list.add(tp);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return list;
}

    /**
     * Tính doanh thu theo tháng hiện tại
     *
     * @return Doanh thu tháng hiện tại
     */
    public long getCurrentMonthRevenue() {
        String sql = """
                WITH LatestImport AS (
                    SELECT ip.product_id,
                           CAST(ip.import_product_price AS DECIMAL(18, 2)) AS import_price,
                           ROW_NUMBER() OVER (PARTITION BY ip.product_id ORDER BY ip.import_product_id DESC) AS rn
                    FROM ImportProduct ip
                )
                SELECT ISNULL(SUM((CAST(od.unit_price AS DECIMAL(18, 2)) - ISNULL(li.import_price, 0)) * od.quantity), 0) AS monthly_profit
                FROM OrderDetail od
                JOIN [Order] o ON od.order_id = o.order_id
                LEFT JOIN LatestImport li ON li.product_id = od.product_id AND li.rn = 1
                WHERE o.order_status = 'DELIVERED'
                  AND YEAR(o.order_date) = YEAR(GETDATE())
                  AND MONTH(o.order_date) = MONTH(GETDATE())
                """;

        try ( PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getLong("monthly_profit");
            }
        } catch (SQLException e) {
            System.err.println("Error calculating monthly revenue: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Tính doanh thu theo năm hiện tại
     *
     * @return Doanh thu năm hiện tại
     */
    public long getCurrentYearRevenue() {
        String sql = """
                WITH LatestImport AS (
                    SELECT ip.product_id,
                           CAST(ip.import_product_price AS DECIMAL(18, 2)) AS import_price,
                           ROW_NUMBER() OVER (PARTITION BY ip.product_id ORDER BY ip.import_product_id DESC) AS rn
                    FROM ImportProduct ip
                )
                SELECT ISNULL(SUM((CAST(od.unit_price AS DECIMAL(18, 2)) - ISNULL(li.import_price, 0)) * od.quantity), 0) AS yearly_profit
                FROM OrderDetail od
                JOIN [Order] o ON od.order_id = o.order_id
                LEFT JOIN LatestImport li ON li.product_id = od.product_id AND li.rn = 1
                WHERE o.order_status = 'DELIVERED'
                  AND YEAR(o.order_date) = YEAR(GETDATE())
                """;

        try ( PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getLong("yearly_profit");
            }
        } catch (SQLException e) {
            System.err.println("Error calculating yearly revenue: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    

    /**
     * Lấy số lượng đơn hàng đã hoàn thành
     *
     * @return Số lượng đơn hàng
     */
    public int getTotalCompletedOrders() {
        String sql = "SELECT COUNT(*) as total_orders "
                + "FROM [Order] "
                + "WHERE order_status = 'DELIVERED'";

        try ( PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("total_orders");
            }
        } catch (SQLException e) {
            System.err.println("Error counting completed orders: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy số lượng khách hàng đã mua hàng
     *
     * @return Số lượng khách hàng
     */
    public int getTotalActiveCustomers() {
        String sql = "SELECT COUNT(DISTINCT customer_id) as total_customers "
                + "FROM [Order] "
                + "WHERE order_status = 'DELIVERED'";

        try ( PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("total_customers");
            }
        } catch (SQLException e) {
            System.err.println("Error counting active customers: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy doanh thu theo từng tháng trong năm hiện tại (cho biểu đồ)
     *
     * @return Map<String, Long> - Tháng và doanh thu tương ứng
     */
    public Map<String, Long> getMonthlyRevenueChart() {
        Map<String, Long> monthlyData = new LinkedHashMap<>();

        String sql = """
                WITH LatestImport AS (
                    SELECT ip.product_id,
                           CAST(ip.import_product_price AS DECIMAL(18, 2)) AS import_price,
                           ROW_NUMBER() OVER (PARTITION BY ip.product_id ORDER BY ip.import_product_id DESC) AS rn
                    FROM ImportProduct ip
                )
                SELECT
                    MONTH(o.order_date) AS month_num,
                    ISNULL(SUM((CAST(od.unit_price AS DECIMAL(18, 2)) - ISNULL(li.import_price, 0)) * od.quantity), 0) AS monthly_profit
                FROM OrderDetail od
                JOIN [Order] o ON od.order_id = o.order_id
                LEFT JOIN LatestImport li ON li.product_id = od.product_id AND li.rn = 1
                WHERE o.order_status = 'DELIVERED'
                  AND YEAR(o.order_date) = YEAR(GETDATE())
                GROUP BY MONTH(o.order_date)
                ORDER BY month_num
                """;

        try ( PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int month = rs.getInt("month_num");
                long profit = rs.getLong("monthly_profit");
                monthlyData.put("Tháng " + month, profit);
            }
        } catch (SQLException e) {
            System.err.println("Error getting monthly revenue chart: " + e.getMessage());
            e.printStackTrace();
        }

        return monthlyData;
    }
}
