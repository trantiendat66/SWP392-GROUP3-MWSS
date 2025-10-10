 /*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.JDBCUtil;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Cart;
import model.Product;
import model.User;

/**
 *
 * @author Dang Vi Danh - CE190687
 */
public class CartDAO extends JDBCUtil {

    private static final Logger LOGGER = Logger.getLogger(CartDAO.class.getName());

    public boolean insertCart(Cart cart) {
        String sql = "INSERT INTO Cart (customer_id, product_id, price, quantity) VALUES (?, ?, (SELECT price FROM Product WHERE product_id = ?), ?)";
        Object[] params = {
            cart.getUser().getUserId(),
            cart.getProduct().getProductId(),
            cart.getProduct().getProductId(),
            cart.getQuantity(),};

        try {
            return execQuery(sql, params) > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi khi thêm vào giỏ hàng", ex);
            return false;
        }
    }

    public boolean deleteAllCart() {
        String sql = "DELETE FROM Cart";

        try {
            return execQuery(sql, null) > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateCart(Cart cart) {
        String sql = "UPDATE Cart SET customer_id = ?, product_id = ?, quantity = ? WHERE cart_id = ?";
        Object[] params = {
            cart.getUser().getUserId(),
            cart.getProduct().getProductId(),
            cart.getQuantity(),
            cart.getCartId()
        };

        try {
            return execQuery(sql, params) > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật giỏ hàng ID: " + cart.getCartId(), ex);
            return false;
        }
    }

    public boolean deleteCartById(int cartID) {
        String sql = "DELETE FROM Cart WHERE cart_id=?";
        Object[] params = {cartID};

        try {
            return execQuery(sql, params) > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa giỏ hàng ID: " + cartID, ex);
            return false;
        }
    }

    public Cart getCartByID(int cartID) {
        String sql = "SELECT \n"
                + "    c.cart_id, c.customer_id AS user_id, c.product_id, c.quantity,\n"
                + "    p.product_id AS p_product_id, p.product_name AS name, p.description, p.price, p.quantity_product AS stock_quantity, p.image AS image_url\n"
                + "FROM Cart c\n"
                + "JOIN Customer u ON u.customer_id = c.customer_id\n"
                + "JOIN Product p ON p.product_id = c.product_id\n"
                + "WHERE c.cart_id = ?;";
        Object[] params = {cartID};

        try ( ResultSet rs = execSelectQuery(sql, params)) {
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));

                Product product = new Product();
                product.setProductId(rs.getInt("product_id"));

                int id = rs.getInt("cart_id");
                int quantity = rs.getInt("quantity");
                return new Cart(id, user, product, quantity, null);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy giỏ hàng ID: " + cartID, ex);
        }
        return null;
    }

    public List<Cart> getCartsByUserId(int userId) {
        List<Cart> cartItems = new ArrayList<>();

        String sql = "SELECT \n"
                + "c.cart_id, c.customer_id AS user_id, c.product_id, c.quantity,\n"
                + "p.product_id, p.product_name AS name, p.description, p.price, p.quantity_product AS stock_quantity, p.image AS image_url\n"
                + "FROM Cart c\n"
                + "LEFT JOIN Customer u ON u.customer_id = c.customer_id\n"
                + "LEFT JOIN Product p ON p.product_id = c.product_id\n"
                + "WHERE u.customer_id = ?;";
        Object[] params = {userId};

        try {
            ResultSet rs = execSelectQuery(sql, params);

            while (rs.next()) {
                int id = rs.getInt("cart_id");
                User user = new User();
                user.setUserId(rs.getInt("user_id"));

                Product product = new Product();
                product.setProductId(rs.getInt("product_id"));
                product.setName(rs.getString("name"));
                product.setPrice(rs.getBigDecimal("price"));

                int quantity = rs.getInt("quantity");

                Cart cart = new Cart(id, user, product, quantity, null);

                cartItems.add(cart);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy giỏ hàng cho user ID: " + userId, ex);
        }
        return cartItems;
    }

    public Cart getCartByUserAndProduct(int userId, int productId) {
        Cart cart = null;
        String sql = "SELECT * FROM Cart WHERE customer_id = ? AND product_id = ?";
        Object[] params = {userId, productId};

        try ( ResultSet rs = execSelectQuery(sql, params)) {
            if (rs.next()) {
                // set User
                User user = new User();
                user.setUserId(rs.getInt("customer_id"));

                // set Product
                Product product = new Product();
                product.setProductId(rs.getInt("product_id"));

                cart = new Cart(rs.getInt("cart_id"), user, product, rs.getInt("quantity"), null);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi kiểm tra giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }
        return cart;
    }

    public boolean updateCartQuantity(int cartId, int quantity) {
        String sql = "UPDATE Cart SET quantity = ? WHERE cart_id = ?";
        Object[] params = {quantity, cartId};

        try {
            return execQuery(sql, params) > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật số lượng giỏ hàng: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
