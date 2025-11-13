/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;

/**
 *
 * @author Nguyen Thien Dat - CE190879 - 06/05/2005
 */
public class OrderDetail {

    private String product_name;
    private int quantity;
    private BigDecimal unit_price;
    private BigDecimal total_price;
    private String image;

    public OrderDetail() {
    }

    public OrderDetail(String product_name, int quantity, BigDecimal unit_price, BigDecimal total_price, String image) {
        this.product_name = product_name;
        this.quantity = quantity;
        this.unit_price = unit_price;
        this.total_price = total_price;
        this.image = image;
    }

    public String getProduct_name() {
        return product_name;
    }

    public void setProduct_name(String product_name) {
        this.product_name = product_name;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnit_price() {
        return unit_price;
    }

    public void setUnit_price(BigDecimal unit_price) {
        this.unit_price = unit_price;
    }

    public BigDecimal getTotal_price() {
        return total_price;
    }

    public void setTotal_price(BigDecimal total_price) {
        this.total_price = total_price;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

}
