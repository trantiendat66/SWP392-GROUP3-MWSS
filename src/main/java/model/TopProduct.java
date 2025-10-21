/*
 * TopProduct Model
 * Created on : Jan 20, 2025
 * Author     : Dang Vi Danh - CE19687
 */
package model;

/**
 * Model class để lưu trữ thông tin sản phẩm bán chạy
 */
public class TopProduct {
    private int productId;
    private String productName;
    private int totalSold;
    private String brand;
    private String image;

    public TopProduct() {
    }

    public TopProduct(int productId, String productName, int totalSold, String brand, String image) {
        this.productId = productId;
        this.productName = productName;
        this.totalSold = totalSold;
        this.brand = brand;
        this.image = image;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getTotalSold() {
        return totalSold;
    }

    public void setTotalSold(int totalSold) {
        this.totalSold = totalSold;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    @Override
    public String toString() {
        return "TopProduct{" + "productId=" + productId + ", productName=" + productName + 
               ", totalSold=" + totalSold + ", brand=" + brand + ", image=" + image + '}';
    }
}

