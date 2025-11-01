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
        String sql = "SELECT p.product_id, c.category_id, p.account_id, p.image,\n"
                + "p.product_name, p.price, b.brand_name, p.origin,\n"
                + "p.gender, p.description, p.warranty, p.machine,\n"
                + "p.glass, p.dial_diameter, p.bezel, p.strap, p.dial_color,\n"
                + "p.[function], s.quantity\n"
                + "FROM [Product] p\n"
                + "JOIN Category c ON c.category_id = p.category_id\n"
                + "JOIN Brand b ON b.brand_id = p.brand_id\n"
                + "LEFT JOIN Stock s ON s.product_id = p.product_id\n"
                + "ORDER BY p.product_id DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setAccountId(rs.getInt("account_id"));
                p.setImage(rs.getString("image"));
                p.setProductName(rs.getString("product_name"));
                p.setPrice(rs.getInt("price"));
                p.setBrand(rs.getString("brand_name"));
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
                int quantity = rs.getInt("quantity");
                p.setQuantityProduct(quantity != 0 ? quantity : 0);
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Product getProductById(int id) {
        String sql = "SELECT p.product_id, c.category_id, p.account_id, p.image,\n"
                + "p.product_name, p.price, b.brand_name, p.origin,\n"
                + "p.gender, p.description, p.warranty, p.machine,\n"
                + "p.glass, p.dial_diameter, p.bezel, p.strap, p.dial_color,\n"
                + "p.[function], s.quantity\n"
                + "FROM [Product] p\n"
                + "JOIN Category c ON c.category_id = p.category_id\n"
                + "JOIN Brand b ON b.brand_id = p.brand_id\n"
                + "LEFT JOIN Stock s ON s.product_id = p.product_id\n"
                + "WHERE p.product_id = ?";
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
                    p.setBrand(rs.getString("brand_name"));
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
                    int quantity = rs.getInt("quantity");
                    p.setQuantityProduct(quantity != 0 ? quantity : 0);
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
        String sql = "SELECT p.product_id, c.category_id, p.account_id, p.image,\n"
                + "p.product_name, p.price, b.brand_name, p.origin,\n"
                + "p.gender, p.description, p.warranty, p.machine,\n"
                + "p.glass, p.dial_diameter, p.bezel, p.strap, p.dial_color,\n"
                + "p.[function], s.quantity\n"
                + "FROM [Product] p\n"
                + "JOIN Category c ON c.category_id = p.category_id\n"
                + "JOIN Brand b ON b.brand_id = p.brand_id\n"
                + "LEFT JOIN Stock s ON s.product_id = p.product_id\n"
                + "WHERE p.product_name LIKE ? OR p.description LIKE ? ORDER BY p.product_id DESC";
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
                    p.setBrand(rs.getString("brand_name"));
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
                    int quantity = rs.getInt("quantity");
                    p.setQuantityProduct(quantity != 0 ? quantity : 0);
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
        StringBuilder sql = new StringBuilder("SELECT p.product_id, c.category_id, p.account_id, p.image,\n"
                + "p.product_name, p.price, b.brand_name, p.origin,\n"
                + "p.gender, p.description, p.warranty, p.machine,\n"
                + "p.glass, p.dial_diameter, p.bezel, p.strap, p.dial_color,\n"
                + "p.[function], s.quantity\n"
                + "FROM [Product] p\n"
                + "JOIN Category c ON c.category_id = p.category_id\n"
                + "JOIN Brand b ON b.brand_id = p.brand_id\n"
                + "LEFT JOIN Stock s ON s.product_id = p.product_id\n"
                + "WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (brand != null && !brand.trim().isEmpty()) {
            sql.append(" AND b.brand_name = ?");
            params.add(brand);
        }
        if (gender != null && !gender.trim().isEmpty()) {
            sql.append(" AND p.gender = ?");
            params.add(gender);
        }
        if (minPrice >= 0 && maxPrice != 0) {
            sql.append(" AND p.price BETWEEN ? AND ?");
            params.add(minPrice);
            params.add(maxPrice);
        } else if (minPrice != 0) { // trên 100 triệu
            sql.append(" AND p.price >= ?");
            params.add(minPrice);
        }
        sql.append(" ORDER BY p.price ASC");
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
                    p.setBrand(rs.getString("brand_name"));
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
                    int quantity = rs.getInt("quantity");
                    p.setQuantityProduct(quantity != 0 ? quantity : 0);
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
        String sql = "SELECT p.product_id, c.category_id, p.account_id, p.image,\n"
                + "p.product_name, p.price, b.brand_name, p.origin,\n"
                + "p.gender, p.description, p.warranty, p.machine,\n"
                + "p.glass, p.dial_diameter, p.bezel, p.strap, p.dial_color,\n"
                + "p.[function], s.quantity\n"
                + "FROM [Product] p\n"
                + "JOIN Category c ON c.category_id = p.category_id\n"
                + "JOIN Brand b ON b.brand_id = p.brand_id\n"
                + "LEFT JOIN Stock s ON s.product_id = p.product_id\n"
                + "WHERE p.product_id = ?";
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
                    int quantity = rs.getInt(19);
                    p.setQuantityProduct(quantity != 0 ? quantity : 0);
                    return p;
                }
            }
        }
        return null;
    }

    private int getBrandIdByBrandName(String brandName) {
        String sql = "SELECT b.brand_id\n"
                + "From Brand b\n"
                + "Where b.brand_name = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, brandName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("brand_id");
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public void addProduct(Product p) throws SQLException {
        String sql = "INSERT INTO Product (category_id, account_id, brand_id, image, product_name, price, origin, gender, description, warranty, machine, glass, dial_diameter, bezel, strap, dial_color, [function])\n"
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection cn = getConnection(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, p.getCategoryId());
            ps.setInt(2, p.getAccountId());
            ps.setInt(3, getBrandIdByBrandName(p.getBrand()));
            ps.setString(4, p.getImage());
            ps.setString(5, p.getProductName());
            ps.setInt(6, p.getPrice());
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

            int rowAffected = ps.executeUpdate();
            if (rowAffected == 0) {
                throw new SQLException("Thêm sản phẩm thất bại, không có hàng nào được thêm.");
            }
        }
    }

    public void updateProduct(Product p) throws SQLException {
        String sqlProduct = "UPDATE Product SET category_id = ?, account_id = ?, brand_id = ?, image = ?, product_name = ?, price = ?, origin = ?, gender = ?, "
                + "description = ?, warranty = ?, machine = ?, glass = ?, dial_diameter = ?, bezel = ?, strap = ?, dial_color = ?, [function] = ? "
                + "WHERE product_id = ?";
        String sqlStock = "UPDATE Stock SET quantity = ? WHERE product_id = ?";

        try (Connection cn = getConnection()) {
            cn.setAutoCommit(false); // bắt đầu transaction

            try (PreparedStatement ps1 = cn.prepareStatement(sqlProduct); PreparedStatement ps2 = cn.prepareStatement(sqlStock)) {

                // --- Update Product ---
                ps1.setInt(1, p.getCategoryId());
                ps1.setInt(2, p.getAccountId());
                ps1.setInt(3, getBrandIdByBrandName(p.getBrand()));
                ps1.setString(4, p.getImage());
                ps1.setString(5, p.getProductName());
                ps1.setInt(6, p.getPrice());
                ps1.setString(7, p.getOrigin());
                ps1.setBoolean(8, p.isGender());
                ps1.setString(9, p.getDescription());
                ps1.setString(10, p.getWarranty());
                ps1.setString(11, p.getMachine());
                ps1.setString(12, p.getGlass());
                ps1.setString(13, p.getDialDiameter());
                ps1.setString(14, p.getBezel());
                ps1.setString(15, p.getStrap());
                ps1.setString(16, p.getDialColor());
                ps1.setString(17, p.getFunction());
                ps1.setInt(18, p.getProductId());

                int rows1 = ps1.executeUpdate();
                if (rows1 == 0) {
                    throw new SQLException("Không tìm thấy product_id = " + p.getProductId());
                }

                // --- Update Stock ---
                ps2.setInt(1, p.getQuantityProduct());
                ps2.setInt(2, p.getProductId());

                int rows2 = ps2.executeUpdate();
                if (rows2 == 0) {
                    throw new SQLException("Không tìm thấy stock cho product_id = " + p.getProductId());
                }

                cn.commit(); // nếu cả 2 thành công → commit
            } catch (Exception e) {
                cn.rollback(); // lỗi → rollback
                throw e;
            } finally {
                cn.setAutoCommit(true);
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
