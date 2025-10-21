/*
 * Document   : Cart DAO
 * Created on : Jan 10, 2025
 * Author     : Dang Vi Danh - CE19687
 */
package dao;

import db.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Cart;

/**
 * Cart DAO - Data Access Object for Cart operations
 * Handles all database operations related to shopping cart
 * @author Dang Vi Danh - CE19687
 */
public class CartDAO extends DBContext {

    public CartDAO() {
        super();
    }

    // Lấy tất cả sản phẩm trong giỏ hàng của customer
    public List<Cart> getCartByCustomerId(int customerId) {
        List<Cart> list = new ArrayList<>();
        String sql = "SELECT c.cart_id, c.customer_id, c.product_id, c.price, c.quantity, "
                + "p.product_name, p.image, p.brand, p.quantity_product "
                + "FROM Cart c "
                + "INNER JOIN Product p ON c.product_id = p.product_id "
                + "WHERE c.customer_id = ? "
                + "ORDER BY c.cart_id DESC";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Cart cart = new Cart();
                    cart.setCartId(rs.getInt("cart_id"));
                    cart.setCustomerId(rs.getInt("customer_id"));
                    cart.setProductId(rs.getInt("product_id"));
                    cart.setPrice(rs.getInt("price"));
                    cart.setQuantity(rs.getInt("quantity"));
                    cart.setProductName(rs.getString("product_name"));
                    cart.setProductImage(rs.getString("image"));
                    cart.setBrand(rs.getString("brand"));
                    cart.setAvailableQuantity(rs.getInt("quantity_product"));
                    list.add(cart);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thêm sản phẩm vào giỏ hàng
    public boolean addToCart(int customerId, int productId, int price, int quantity) {
        // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
        Cart existingCart = getCartItem(customerId, productId);
        
        if (existingCart != null) {
            // Nếu đã có, cập nhật số lượng
            int newQuantity = existingCart.getQuantity() + quantity;
            return updateCartQuantity(existingCart.getCartId(), newQuantity);
        } else {
            // Nếu chưa có, thêm mới
            String sql = "INSERT INTO Cart (customer_id, product_id, price, quantity) VALUES (?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, customerId);
                ps.setInt(2, productId);
                ps.setInt(3, price);
                ps.setInt(4, quantity);
                int rows = ps.executeUpdate();
                return rows > 0;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    // Lấy một item cụ thể trong giỏ hàng
    public Cart getCartItem(int customerId, int productId) {
        String sql = "SELECT * FROM Cart WHERE customer_id = ? AND product_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Cart cart = new Cart();
                    cart.setCartId(rs.getInt("cart_id"));
                    cart.setCustomerId(rs.getInt("customer_id"));
                    cart.setProductId(rs.getInt("product_id"));
                    cart.setPrice(rs.getInt("price"));
                    cart.setQuantity(rs.getInt("quantity"));
                    return cart;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy một item trong giỏ hàng theo cartId
    public Cart getCartItemById(int cartId) {
        String sql = "SELECT * FROM Cart WHERE cart_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Cart cart = new Cart();
                    cart.setCartId(rs.getInt("cart_id"));
                    cart.setCustomerId(rs.getInt("customer_id"));
                    cart.setProductId(rs.getInt("product_id"));
                    cart.setPrice(rs.getInt("price"));
                    cart.setQuantity(rs.getInt("quantity"));
                    return cart;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Cập nhật số lượng sản phẩm trong giỏ hàng
    public boolean updateCartQuantity(int cartId, int newQuantity) {
        String sql = "UPDATE Cart SET quantity = ? WHERE cart_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newQuantity);
            ps.setInt(2, cartId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa sản phẩm khỏi giỏ hàng
    public boolean removeFromCart(int cartId) {
        String sql = "DELETE FROM Cart WHERE cart_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa tất cả sản phẩm trong giỏ hàng của customer
    public boolean clearCart(int customerId) {
        String sql = "DELETE FROM Cart WHERE customer_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Đếm số lượng sản phẩm trong giỏ hàng
    public int getCartItemCount(int customerId) {
        String sql = "SELECT COUNT(*) as total FROM Cart WHERE customer_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Tính tổng tiền trong giỏ hàng
    public int getCartTotal(int customerId) {
        String sql = "SELECT SUM(price * quantity) as total FROM Cart WHERE customer_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public List<Cart> findItemsForCheckout(int customerId) throws SQLException {
        String sql = "SELECT c.cart_id, c.customer_id, c.product_id, p.price, c.quantity, " +
                     "       p.product_name, p.image, p.brand " +
                     "FROM Cart c JOIN Product p ON p.product_id = c.product_id " +
                     "WHERE c.customer_id = ?";
        try (Connection cn = new DBContext().getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Cart> list = new ArrayList<>();
                while (rs.next()) {
                    Cart x = new Cart(
                        rs.getInt("cart_id"),
                        rs.getInt("customer_id"),
                        rs.getInt("product_id"),
                        rs.getInt("price"),
                        rs.getInt("quantity"),
                        rs.getString("product_name"),
                        rs.getString("image"),
                        rs.getString("brand")
                    );
                    list.add(x);
                }
                return list;
            }
        }
    }
}
