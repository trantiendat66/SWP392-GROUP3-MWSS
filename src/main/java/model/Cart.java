/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

/**
 *
 * @author Dang Vi Danh - CE190687
 */
public class Cart {

    private int cartId;
    private User user;
    private Product product;
    private int quantity;
    private LocalDateTime addDate;

    public Cart() {
    }

    public Cart(int cartId, User user, Product product, int quantity, LocalDateTime addDate) {
        this.cartId = cartId;
        this.user = user;
        this.product = product;
        this.quantity = quantity;
        this.addDate = addDate;
    }

    public Cart(User user, Product product, int quantity, LocalDateTime addDate) {
        this.user = user;
        this.product = product;
        this.quantity = quantity;
        this.addDate = addDate;
        this.product = product;
    }

    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public LocalDateTime getAddDate() {
        return addDate;
    }

    public void setAddDate(LocalDateTime addDate) {
        this.addDate = addDate;
    }

    @Override
    public String toString() {
        return "Cart{" + "cartId=" + cartId + ", user=" + user + ", product=" + product + ", quantity=" + quantity + ", addDate=" + addDate + '}';
    }
}
