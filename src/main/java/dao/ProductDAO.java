/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.DBContext;
import java.sql.*;
import java.util.*;
import model.Product;

/**
 *
 * @author Tran Tien Dat - CE190362
 */
public class ProductDAO extends DBContext {
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Product ORDER BY product_id DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setAccountId(rs.getInt("account_id"));
                p.setImage(rs.getString("image"));
                p.setProductName(rs.getString("product_name"));
                p.setPrice(rs.getInt("price"));
                p.setBrand(rs.getString("brand"));
                p.setOrigin(rs.getString("origin"));
                p.setGender(rs.getBoolean("gender"));
                p.setDescription(rs.getString("description"));
                p.setWarranty(rs.getString("warranty"));
                p.setMachine(rs.getString("machine"));
                p.setGlass(rs.getString("glass"));
                p.setDialDiameter(rs.getString("dial_diameter"));
                p.setBezel(rs.getString("bezel"));
                p.setStrap(rs.getString("strap"));
                p.setDialColor(rs.getString("dial_color"));
                p.setFunction(rs.getString("function"));
                p.setQuantityProduct(rs.getInt("quantity_product"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Product getProductById(int id) {
        String sql = "SELECT * FROM Product p WHERE p.product_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setCategoryId(rs.getInt("category_id"));
                    p.setAccountId(rs.getInt("account_id"));
                    p.setImage(rs.getString("image"));
                    p.setProductName(rs.getString("product_name"));
                    p.setPrice(rs.getInt("price"));
                    p.setBrand(rs.getString("brand"));
                    p.setOrigin(rs.getString("origin"));
                    p.setGender(rs.getBoolean("gender"));
                    p.setDescription(rs.getString("description"));
                    p.setWarranty(rs.getString("warranty"));
                    p.setMachine(rs.getString("machine"));
                    p.setGlass(rs.getString("glass"));
                    p.setDialDiameter(rs.getString("dial_diameter"));
                    p.setBezel(rs.getString("bezel"));
                    p.setStrap(rs.getString("strap"));
                    p.setDialColor(rs.getString("dial_color"));
                    p.setFunction(rs.getString("function"));
                    p.setQuantityProduct(rs.getInt("quantity_product"));
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Product> searchProducts(String keyword) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Product p WHERE p.product_name LIKE ? OR p.description LIKE ? ORDER BY p.product_id DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            String patt = "%" + (keyword == null ? "" : keyword.trim()) + "%";
            ps.setString(1, patt);
            ps.setString(2, patt);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setCategoryId(rs.getInt("category_id"));
                    p.setAccountId(rs.getInt("account_id"));
                    p.setImage(rs.getString("image"));
                    p.setProductName(rs.getString("product_name"));
                    p.setPrice(rs.getInt("price"));
                    p.setBrand(rs.getString("brand"));
                    p.setOrigin(rs.getString("origin"));
                    p.setGender(rs.getBoolean("gender"));
                    p.setDescription(rs.getString("description"));
                    p.setWarranty(rs.getString("warranty"));
                    p.setMachine(rs.getString("machine"));
                    p.setGlass(rs.getString("glass"));
                    p.setDialDiameter(rs.getString("dial_diameter"));
                    p.setBezel(rs.getString("bezel"));
                    p.setStrap(rs.getString("strap"));
                    p.setDialColor(rs.getString("dial_color"));
                    p.setFunction(rs.getString("function"));
                    p.setQuantityProduct(rs.getInt("quantity_product"));
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> filterProducts(String brand, String gender, int minPrice, int maxPrice) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Product WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (brand != null && !brand.trim().isEmpty()) {
            sql.append(" AND brand = ?");
            params.add(brand);
        }
        if (gender != null && !gender.trim().isEmpty()) {
            sql.append(" AND gender = ?");
            params.add(gender);
        }
        if (minPrice != 0 && maxPrice != 0) {
            sql.append(" AND price BETWEEN ? AND ?");
            params.add(minPrice);
            params.add(maxPrice);
        } else if (minPrice != 0) { // trên 100 triệu
            sql.append(" AND price >= ?");
            params.add(minPrice);
        }
        sql.append(" ORDER BY price ASC");
        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setCategoryId(rs.getInt("category_id"));
                    p.setAccountId(rs.getInt("account_id"));
                    p.setImage(rs.getString("image"));
                    p.setProductName(rs.getString("product_name"));
                    p.setPrice(rs.getInt("price"));
                    p.setBrand(rs.getString("brand"));
                    p.setOrigin(rs.getString("origin"));
                    p.setGender(rs.getBoolean("gender"));
                    p.setDescription(rs.getString("description"));
                    p.setWarranty(rs.getString("warranty"));
                    p.setMachine(rs.getString("machine"));
                    p.setGlass(rs.getString("glass"));
                    p.setDialDiameter(rs.getString("dial_diameter"));
                    p.setBezel(rs.getString("bezel"));
                    p.setStrap(rs.getString("strap"));
                    p.setDialColor(rs.getString("dial_color"));
                    p.setFunction(rs.getString("function"));
                    p.setQuantityProduct(rs.getInt("quantity_product"));
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public int getCurrentPrice(int productId) throws SQLException {
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement("SELECT price FROM Product WHERE product_id=?")) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new SQLException("Không tìm thấy sản phẩm #" + productId);
                return rs.getInt(1);
            }
        }
    }
}
