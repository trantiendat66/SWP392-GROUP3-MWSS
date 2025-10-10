/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Tran Tien Dat - CE190362
 */
public class Product {
    private int productId;
    private int categoryId;
    private int accountId;
    private String image;
    private String productName;
    private int price;
    private String brand;
    private String origin;
    private boolean gender; // true = Nam, false = Nữ
    private String description;
    private String warranty;
    private String machine;
    private String glass;
    private String dialDiameter;
    private String bezel;
    private String strap;
    private String dialColor;
    private String function;
    private int quantityProduct;

    public Product() {
    }

    public Product(int productId, int categoryId, int accountId, String image, String productName, int price, String brand, String origin, boolean gender, String description, String warranty, String machine, String glass, String dialDiameter, String bezel, String strap, String dialColor, String function, int quantityProduct) {
        this.productId = productId;
        this.categoryId = categoryId;
        this.accountId = accountId;
        this.image = image;
        this.productName = productName;
        this.price = price;
        this.brand = brand;
        this.origin = origin;
        this.gender = gender;
        this.description = description;
        this.warranty = warranty;
        this.machine = machine;
        this.glass = glass;
        this.dialDiameter = dialDiameter;
        this.bezel = bezel;
        this.strap = strap;
        this.dialColor = dialColor;
        this.function = function;
        this.quantityProduct = quantityProduct;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getOrigin() {
        return origin;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }

    public boolean isGender() {
        return gender;
    }

    public void setGender(boolean gender) {
        this.gender = gender;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getWarranty() {
        return warranty;
    }

    public void setWarranty(String warranty) {
        this.warranty = warranty;
    }

    public String getMachine() {
        return machine;
    }

    public void setMachine(String machine) {
        this.machine = machine;
    }

    public String getGlass() {
        return glass;
    }

    public void setGlass(String glass) {
        this.glass = glass;
    }

    public String getDialDiameter() {
        return dialDiameter;
    }

    public void setDialDiameter(String dialDiameter) {
        this.dialDiameter = dialDiameter;
    }

    public String getBezel() {
        return bezel;
    }

    public void setBezel(String bezel) {
        this.bezel = bezel;
    }

    public String getStrap() {
        return strap;
    }

    public void setStrap(String strap) {
        this.strap = strap;
    }

    public String getDialColor() {
        return dialColor;
    }

    public void setDialColor(String dialColor) {
        this.dialColor = dialColor;
    }

    public String getFunction() {
        return function;
    }

    public void setFunction(String function) {
        this.function = function;
    }

    public int getQuantityProduct() {
        return quantityProduct;
    }

    public void setQuantityProduct(int quantityProduct) {
        this.quantityProduct = quantityProduct;
    }

    @Override
    public String toString() {
        return "Product{" + "productId=" + productId + ", categoryId=" + categoryId + ", accountId=" + accountId + ", image=" + image + ", productName=" + productName + ", price=" + price + ", brand=" + brand + ", origin=" + origin + ", gender=" + gender + ", description=" + description + ", warranty=" + warranty + ", machine=" + machine + ", glass=" + glass + ", dialDiameter=" + dialDiameter + ", bezel=" + bezel + ", strap=" + strap + ", dialColor=" + dialColor + ", function=" + function + ", quantityProduct=" + quantityProduct + '}';
    }
    
}
