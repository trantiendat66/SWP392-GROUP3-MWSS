/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author hau
 */
public class ImportProduct {

    private int importProductId;
    private int importInventoryId;
    private int productId;
    private int importProductPrice;
    private int importQuantity;
    private String productName;

    public ImportProduct() {
    }

    public ImportProduct(int importInventoryId, int productId, int importProductPrice, int importQuantity) {
        this.importInventoryId = importInventoryId;
        this.productId = productId;
        this.importProductPrice = importProductPrice;
        this.importQuantity = importQuantity;
    }

    public ImportProduct(int importProductId, int importInventoryId, int productId, int importProductPrice, int importQuantity) {
        this.importProductId = importProductId;
        this.importInventoryId = importInventoryId;
        this.productId = productId;
        this.importProductPrice = importProductPrice;
        this.importQuantity = importQuantity;
    }

    public int getImportProductId() {
        return importProductId;
    }

    public void setImportProductId(int importProductId) {
        this.importProductId = importProductId;
    }

    public int getImportInventoryId() {
        return importInventoryId;
    }

    public void setImportInventoryId(int importInventoryId) {
        this.importInventoryId = importInventoryId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getImportProductPrice() {
        return importProductPrice;
    }

    public void setImportProductPrice(int importProductPrice) {
        this.importProductPrice = importProductPrice;
    }

    public int getImportQuantity() {
        return importQuantity;
    }

    public void setImportQuantity(int importQuantity) {
        this.importQuantity = importQuantity;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    @Override
    public String toString() {
        return "ImportProduct{" + "importProductId=" + importProductId + ", importInventoryId=" + importInventoryId + ", productId=" + productId + ", importProductPrice=" + importProductPrice + ", importQuantity=" + importQuantity + ", productName=" + productName + '}';
    }

    
}
