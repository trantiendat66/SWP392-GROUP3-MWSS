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
     * @return Tổng doanh thu (long)
     */
    public long getTotalRevenue() {
        String sql = "SELECT ISNULL(SUM(total_amount), 0) as total_revenue " +
                    "FROM [Order] " +
                    "WHERE order_status = 'DELIVERED'";
        
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getLong("total_revenue");
            }
        } catch (SQLException e) {
            System.err.println("Error calculating total revenue: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy danh sách top 5 sản phẩm bán chạy nhất
     * @return List<TopProduct> - Danh sách 5 sản phẩm bán chạy nhất
     */
    public List<TopProduct> getTop5Products() {
        List<TopProduct> topProducts = new ArrayList<>();
        
        String sql = "SELECT TOP 5 " +
                    "    p.product_id, " +
                    "    p.product_name, " +
                    "    p.brand, " +
                    "    p.image, " +
                    "    ISNULL(SUM(od.quantity), 0) as total_sold " +
                    "FROM Product p " +
                    "LEFT JOIN OrderDetail od ON p.product_id = od.product_id " +
                    "LEFT JOIN [Order] o ON od.order_id = o.order_id " +
                    "    AND o.order_status = 'DELIVERED' " +
                    "GROUP BY p.product_id, p.product_name, p.brand, p.image " +
                    "ORDER BY total_sold DESC, p.product_name ASC";
        
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                TopProduct topProduct = new TopProduct();
                topProduct.setProductId(rs.getInt("product_id"));
                topProduct.setProductName(rs.getString("product_name"));
                topProduct.setBrand(rs.getString("brand"));
                topProduct.setImage(rs.getString("image"));
                topProduct.setTotalSold(rs.getInt("total_sold"));
                
                topProducts.add(topProduct);
            }
        } catch (SQLException e) {
            System.err.println("Error getting top products: " + e.getMessage());
            e.printStackTrace();
        }
        
        return topProducts;
    }

    /**
     * Tính doanh thu theo tháng hiện tại
     * @return Doanh thu tháng hiện tại
     */
    public long getCurrentMonthRevenue() {
        String sql = "SELECT ISNULL(SUM(total_amount), 0) as monthly_revenue " +
                    "FROM [Order] " +
                    "WHERE order_status = 'DELIVERED' " +
                    "AND YEAR(order_date) = YEAR(GETDATE()) " +
                    "AND MONTH(order_date) = MONTH(GETDATE())";
        
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getLong("monthly_revenue");
            }
        } catch (SQLException e) {
            System.err.println("Error calculating monthly revenue: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Tính doanh thu theo năm hiện tại
     * @return Doanh thu năm hiện tại
     */
    public long getCurrentYearRevenue() {
        String sql = "SELECT ISNULL(SUM(total_amount), 0) as yearly_revenue " +
                    "FROM [Order] " +
                    "WHERE order_status = 'DELIVERED' " +
                    "AND YEAR(order_date) = YEAR(GETDATE())";
        
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getLong("yearly_revenue");
            }
        } catch (SQLException e) {
            System.err.println("Error calculating yearly revenue: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy số lượng đơn hàng đã hoàn thành
     * @return Số lượng đơn hàng
     */
    public int getTotalCompletedOrders() {
        String sql = "SELECT COUNT(*) as total_orders " +
                    "FROM [Order] " +
                    "WHERE order_status = 'DELIVERED'";
        
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
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
     * @return Số lượng khách hàng
     */
    public int getTotalActiveCustomers() {
        String sql = "SELECT COUNT(DISTINCT customer_id) as total_customers " +
                    "FROM [Order] " +
                    "WHERE order_status = 'DELIVERED'";
        
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
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
     * @return Map<String, Long> - Tháng và doanh thu tương ứng
     */
    public Map<String, Long> getMonthlyRevenueChart() {
        Map<String, Long> monthlyData = new LinkedHashMap<>();
        
        String sql = "SELECT " +
                    "    MONTH(order_date) as month_num, " +
                    "    ISNULL(SUM(total_amount), 0) as monthly_revenue " +
                    "FROM [Order] " +
                    "WHERE order_status = 'DELIVERED' " +
                    "AND YEAR(order_date) = YEAR(GETDATE()) " +
                    "GROUP BY MONTH(order_date) " +
                    "ORDER BY month_num";
        
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                int month = rs.getInt("month_num");
                long revenue = rs.getLong("monthly_revenue");
                monthlyData.put("Tháng " + month, revenue);
            }
        } catch (SQLException e) {
            System.err.println("Error getting monthly revenue chart: " + e.getMessage());
            e.printStackTrace();
        }
        
        return monthlyData;
    }
}
