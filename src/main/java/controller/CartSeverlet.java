/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CartDAO;
import dao.ProductDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Cart;
import model.Product;
import model.User;

/**
 *
 * @author Dang Vi Danh - CE190687
 */
@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        CartDAO cartDAO = new CartDAO();
        HttpSession session = request.getSession(false);

        // Perform actions based on the "action" parameter
        switch (action) {
            case "add":
                System.out.println("add");
                addCart(request, response, cartDAO, session);
                break;
            case "delete":
                deleteCart(request, response, cartDAO, session);
                break;
            case "clear":
                clearCart(request, response, cartDAO, session);
                break;
            default:
                throw new AssertionError();
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    /**
     * Deletes a cart item based on its ID.
     *
     * @param request servlet request
     * @param response servlet response
     * @param dao CartDAO for database operations
     * @param session HttpSession to store success or failure messages
     * @throws ServletException
     * @throws IOException
     */
    private void deleteCart(HttpServletRequest request, HttpServletResponse response, CartDAO dao, HttpSession session) throws ServletException, IOException {
        String cartIdStr = request.getParameter("cartId");

        int cartId = 0;
        try {
            cartId = Integer.parseInt(cartIdStr);
        } catch (Exception e) {
            session.setAttribute("deleteFail", "Cart deletion failed!");
            response.sendRedirect(request.getContextPath() + "/account?view=cart");
            return;
        }

        boolean isDelete = dao.deleteCartById(cartId);

        if (isDelete) {
            session.setAttribute("deleteSuccess", "Cart deleted successfully!");
            response.sendRedirect(request.getContextPath() + "/account?view=cart");
        } else {
            session.setAttribute("deleteFail", "Cart deletion failed!");
            response.sendRedirect(request.getContextPath() + "/account?view=cart");
        }
    }

    /**
     * Adds a product to the cart or updates the quantity if the product is
     * already in the cart.
     *
     * @param request servlet request
     * @param response servlet response
     * @param dao CartDAO for database operations
     * @param session HttpSession to store success or failure messages
     * @throws ServletException
     * @throws IOException
     */
    private void addCart(HttpServletRequest request, HttpServletResponse response, CartDAO dao, HttpSession session) throws ServletException, IOException {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Validate productId and quantity parameters
        String productIdStr = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");
        if (productIdStr == null || productIdStr.trim().isEmpty() || quantityStr == null || quantityStr.trim().isEmpty()) {
            System.out.println("error params");
            response.sendRedirect(request.getContextPath() + "error-page/404page.jsp");
            return;
        }

        // Parse product ID
        int productId;
        try {
            productId = Integer.parseInt(productIdStr);
        } catch (NumberFormatException e) {
            System.out.println("error prodc id");
            session.setAttribute("addFail", "Invalid product ID!");
            response.sendRedirect(request.getContextPath() + "error-page/404page.jsp");
            return;
        }

        // check product
        Product product = new ProductDAO().getProductById(productId);
        if (product == null) {
            System.out.println("get ptoduct fail");
            session.setAttribute("addFail", "Product does not exist!");
            response.sendRedirect(request.getContextPath() + "/product?id=" + productId);
            return;
        }

        // check quantity
        int quantity = 1;
        quantity = Integer.parseInt(quantityStr);
        if (quantity < 1 || quantity > product.getStockQuantity()) {
            session.setAttribute("addFail", "Invalid quantity. Please choose quantity again!");
            response.sendRedirect(request.getContextPath() + "/product?id=" + productId);
            return;
        }

        // add to cart
        Cart existingCart = dao.getCartByUserAndProduct(user.getUserId(), productId);
        if (existingCart != null) {
            // Update quantity if it exists
            boolean isUpdated = dao.updateCartQuantity(existingCart.getCartId(), quantity);
            if (isUpdated) {
                System.out.println("upd ate sc");
                session.setAttribute("addSuccess", "Updated quantity of products in cart successfully!");
                response.sendRedirect(request.getContextPath() + "/product?id=" + productId);
            } else {
                System.out.println("update dail");
                session.setAttribute("addFail", "Cart update failed!");
                response.sendRedirect(request.getContextPath() + "/product?id=" + productId);
            }
        } else {
            // Add new product to the cart
            Cart cart = new Cart(user, product, quantity, null);
            boolean isInsertCart = dao.insertCart(cart);
            if (isInsertCart) {
                System.out.println("thanh cong");
                session.setAttribute("addSuccess", "Add to cart successfully!");
                response.sendRedirect(request.getContextPath() + "/product?id=" + productId);
            } else {
                System.out.println("that bai");
                session.setAttribute("addFail", "Add to cart failed!");
                response.sendRedirect(request.getContextPath() + "/product?id=" + productId);
            }
        }
    }

    /**
     * Clears all items from the cart.
     *
     * @param request servlet request
     * @param response servlet response
     * @param dao CartDAO for database operations
     * @param session HttpSession to store success or failure messages
     * @throws ServletException
     * @throws IOException
     */
    private void clearCart(HttpServletRequest request, HttpServletResponse response, CartDAO dao, HttpSession session) throws ServletException, IOException {
        boolean isClear = dao.deleteAllCart();

        if (isClear) {
            session.setAttribute("deleteSuccess", "Clear all carts successfully");
            response.sendRedirect(request.getContextPath() + "/account?view=cart");
        } else {
            session.setAttribute("deleteFail", "Clear all failed carts");
            response.sendRedirect(request.getContextPath() + "/account?view=cart");
        }
    }
}
