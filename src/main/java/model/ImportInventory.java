/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Date;

/**
 *
 * @author hau
 */
public class ImportInventory {
    private int importInvetoryId;
    private int totalImportPrice;
    private Date importAt;
    private Date importDate;
    private int totalImportQuantity;
    private String supplier;
    private boolean importStatus;

    public ImportInventory() {
    }
    public ImportInventory( int totalImportPrice, Date importAt, Date importDate, int totalImportQuantity, String supplier) {
       
        this.totalImportPrice = totalImportPrice;
        this.importAt = importAt;
        this.importDate = importDate;
        this.totalImportQuantity = totalImportQuantity;
        this.supplier = supplier;
        this.importStatus = false;
    }

    public ImportInventory(int importInvetoryId, int totalImportPrice, Date importAt, Date importDate, int totalImportQuantity, String supplier) {
        this.importInvetoryId = importInvetoryId;
        this.totalImportPrice = totalImportPrice;
        this.importAt = importAt;
        this.importDate = importDate;
        this.totalImportQuantity = totalImportQuantity;
        this.supplier = supplier;
        this.importStatus = false;
    }

    public int getImportInvetoryId() {
        return importInvetoryId;
    }

    public void setImportInvetoryId(int importInvetoryId) {
        this.importInvetoryId = importInvetoryId;
    }

    public int getTotalImportPrice() {
        return totalImportPrice;
    }

    public void setTotalImportPrice(int totalImportPrice) {
        this.totalImportPrice = totalImportPrice;
    }

    public Date getImportAt() {
        return importAt;
    }

    public void setImportAt(Date importAt) {
        this.importAt = importAt;
    }

    public Date getImportDate() {
        return importDate;
    }

    public void setImportDate(Date importDate) {
        this.importDate = importDate;
    }

    public int getTotalImportQuantity() {
        return totalImportQuantity;
    }

    public void setTotalImportQuantity(int totalImportQuantity) {
        this.totalImportQuantity = totalImportQuantity;
    }

    public String getSupplier() {
        return supplier;
    }

    public void setSupplier(String supplier) {
        this.supplier = supplier;
    }

    public boolean isImportStatus() {
        return importStatus;
    }

    public void setImportStatus(boolean importStatus) {
        this.importStatus = importStatus;
    }

    @Override
    public String toString() {
        return "ImportInventory{" + "importInvetoryId=" + importInvetoryId + ", totalImportPrice=" + totalImportPrice + ", importAt=" + importAt + ", importDate=" + importDate + ", totalImportQuantity=" + totalImportQuantity + ", supplier=" + supplier + ", importStatus=" + importStatus + '}';
    }

    
}
