/*
 * Document   : Cart Model
 * Created on : Jan 10, 2025
 * Author     : Dang Vi Danh - CE19687
 */
package model;

/**
 * Cart Model - Represents a cart item in the shopping cart
 * @author Dang Vi Danh - CE19687
 */
public class Cart {
    private int cartId;
    private int customerId;
    private int productId;
    private int price;
    private int quantity;
    
    // Thông tin sản phẩm (join từ Product table)
    private String productName;
    private String productImage;
    private String brand;
    private int availableQuantity; // Số lượng sản phẩm còn lại trong kho
    
    public Cart() {
    }

    public Cart(int cartId, int customerId, int productId, int price, int quantity) {
        this.cartId = cartId;
        this.customerId = customerId;
        this.productId = productId;
        this.price = price;
        this.quantity = quantity;
    }

    public Cart(int cartId, int customerId, int productId, int price, int quantity, String productName, String productImage, String brand) {
        this.cartId = cartId;
        this.customerId = customerId;
        this.productId = productId;
        this.price = price;
        this.quantity = quantity;
        this.productName = productName;
        this.productImage = productImage;
        this.brand = brand;
    }

    public Cart(int cartId, int customerId, int productId, int price, int quantity, String productName, String productImage, String brand, int availableQuantity) {
        this.cartId = cartId;
        this.customerId = customerId;
        this.productId = productId;
        this.price = price;
        this.quantity = quantity;
        this.productName = productName;
        this.productImage = productImage;
        this.brand = brand;
        this.availableQuantity = availableQuantity;
    }

    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductImage() {
        return productImage;
    }

    public void setProductImage(String productImage) {
        this.productImage = productImage;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public int getAvailableQuantity() {
        return availableQuantity;
    }

    public void setAvailableQuantity(int availableQuantity) {
        this.availableQuantity = availableQuantity;
    }
    
    // Tính tổng tiền cho item này
    public int getTotalPrice() {
        return price * quantity;
    }

    @Override
    public String toString() {
        return "Cart{" + "cartId=" + cartId + ", customerId=" + customerId + ", productId=" + productId + ", price=" + price + ", quantity=" + quantity + ", productName=" + productName + ", productImage=" + productImage + ", brand=" + brand + '}';
    }
}

