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
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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
        try (Connection cn = new DBContext().getConnection(); PreparedStatement ps = cn.prepareStatement("SELECT price FROM Product WHERE product_id=?")) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    throw new SQLException("Không tìm thấy sản phẩm #" + productId);
                }
                return rs.getInt(1);
            }
        }
    }

    public Product getById(int productId) throws SQLException {
        String sql = "SELECT product_id, category_id, account_id, image, product_name, price, brand, origin, gender, "
                + "description, warranty, machine, glass, dial_diameter, bezel, strap, dial_color, [function], quantity_product "
                + "FROM Product WHERE product_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt(1));
                    p.setCategoryId(rs.getInt(2));
                    p.setAccountId(rs.getInt(3));
                    p.setImage(rs.getString(4));
                    p.setProductName(rs.getString(5));
                    p.setPrice(rs.getInt(6));
                    p.setBrand(rs.getString(7));
                    p.setOrigin(rs.getString(8));
                    p.setGender(rs.getBoolean(9));
                    p.setDescription(rs.getString(10));
                    p.setWarranty(rs.getString(11));
                    p.setMachine(rs.getString(12));
                    p.setGlass(rs.getString(13));
                    p.setDialDiameter(rs.getString(14));
                    p.setBezel(rs.getString(15));
                    p.setStrap(rs.getString(16));
                    p.setDialColor(rs.getString(17));
                    p.setFunction(rs.getString(18));
                    p.setQuantityProduct(rs.getInt(19));
                    return p;
                }
            }
        }
        return null;
    }

    public void addProduct(Product p) throws SQLException {
        String sql = "INSERT INTO Product (category_id, account_id, image, product_name, price, brand, origin, gender, description, warranty, machine, glass, dial_diameter, bezel, strap, dial_color, [function], quantity_product) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection cn = getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, p.getCategoryId());
            ps.setInt(2, p.getAccountId());
            ps.setString(3, p.getImage());
            ps.setString(4, p.getProductName());
            ps.setInt(5, p.getPrice());
            ps.setString(6, p.getBrand());
            ps.setString(7, p.getOrigin());
            ps.setBoolean(8, p.isGender());
            ps.setString(9, p.getDescription());
            ps.setString(10, p.getWarranty());
            ps.setString(11, p.getMachine());
            ps.setString(12, p.getGlass());
            ps.setString(13, p.getDialDiameter());
            ps.setString(14, p.getBezel());
            ps.setString(15, p.getStrap());
            ps.setString(16, p.getDialColor());
            ps.setString(17, p.getFunction());
            ps.setInt(18, p.getQuantityProduct());

            int rowAffected = ps.executeUpdate();
            if (rowAffected == 0) {
                throw new SQLException("Thêm sản phẩm thất bại, không có hàng nào được thêm.");
            }
        }
    }

    public void updateProduct(Product p) throws SQLException {
        String sql = "UPDATE Product SET category_id = ?, account_id = ?, image = ?, product_name = ?, price = ?, brand = ?, origin = ?, gender = ?, "
                + "description = ?, warranty = ?, machine = ?, glass = ?, dial_diameter = ?, bezel = ?, strap = ?, dial_color = ?, [function] = ?, quantity_product = ? "
                + "WHERE product_id = ?";
        try (Connection cn = getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, p.getCategoryId());
            ps.setInt(2, p.getAccountId());
            ps.setString(3, p.getImage());
            ps.setString(4, p.getProductName());
            ps.setInt(5, p.getPrice());
            ps.setString(6, p.getBrand());
            ps.setString(7, p.getOrigin());
            ps.setBoolean(8, p.isGender());
            ps.setString(9, p.getDescription());
            ps.setString(10, p.getWarranty());
            ps.setString(11, p.getMachine());
            ps.setString(12, p.getGlass());
            ps.setString(13, p.getDialDiameter());
            ps.setString(14, p.getBezel());
            ps.setString(15, p.getStrap());
            ps.setString(16, p.getDialColor());
            ps.setString(17, p.getFunction());
            ps.setInt(18, p.getQuantityProduct());
            ps.setInt(19, p.getProductId());
            int rows = ps.executeUpdate();
            if (rows == 0) {
                throw new SQLException("Cập nhật thất bại, không tìm thấy product_id = " + p.getProductId());
            }
        }
    }

    public void deleteProduct(int productId) throws SQLException {
        String sql = "DELETE FROM Product WHERE product_id = ?";
        try (Connection cn = getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            int rows = ps.executeUpdate();
            if (rows == 0) {
                throw new SQLException("Xóa thất bại, không tìm thấy product_id = " + productId);
            }
        }
    }
}
