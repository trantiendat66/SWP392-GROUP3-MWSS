/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.util.Date;

/**
 *
 * @author Nguyen Thien Dat - CE190879 - 06/05/2005
 */
public class Order {

    private int order_id;
    private String customer_name;
    private String phone;
    private String order_date;
    private String order_status;
    private String shipping_address;
    private int payment_method;
    private BigDecimal total_amount;
    private Date delivered_at;

    public Order() {
    }

    public Order(int order_id, String customer_name, String phone, String order_date, String order_status, String shipping_address, int payment_method, BigDecimal total_amount) {
        this.order_id = order_id;
        this.customer_name = customer_name;
        this.phone = phone;
        this.order_date = order_date;
        this.order_status = order_status;
        this.shipping_address = shipping_address;
        this.payment_method = payment_method;
        this.total_amount = total_amount;
    }
    
        public Order(int order_id, String customer_name, String phone, String order_date, String order_status, String shipping_address, int payment_method, BigDecimal total_amount, Date delivered_at) {
        this.order_id = order_id;
        this.customer_name = customer_name;
        this.phone = phone;
        this.order_date = order_date;
        this.order_status = order_status;
        this.shipping_address = shipping_address;
        this.payment_method = payment_method;
        this.total_amount = total_amount;
        this.delivered_at = delivered_at;
    }

    public int getOrder_id() {
        return order_id;
    }

    public void setOrder_id(int order_id) {
        this.order_id = order_id;
    }

    public String getCustomer_name() {
        return customer_name;
    }

    public void setCustomer_name(String customer_name) {
        this.customer_name = customer_name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getOrder_date() {
        return order_date;
    }

    public void setOrder_date(String order_date) {
        this.order_date = order_date;
    }

    public String getOrder_status() {
        return order_status;
    }

    public void setOrder_status(String order_status) {
        this.order_status = order_status;
    }

    public String getShipping_address() {
        return shipping_address;
    }

    public void setShipping_address(String shipping_address) {
        this.shipping_address = shipping_address;
    }

    public int getPayment_method() {
        return payment_method;
    }

    public void setPayment_method(int payment_method) {
        this.payment_method = payment_method;
    }

    public BigDecimal getTotal_amount() {
        return total_amount;
    }

    public void setTotal_amount(BigDecimal total_amount) {
        this.total_amount = total_amount;
    }
    
 
    public Date getDelivered_at() {              
        return delivered_at;
    }

    public void setDelivered_at(Date delivered_at) {
        this.delivered_at = delivered_at;
    }

    @Override
    public String toString() {
        return "Order{" + "order_id=" + order_id + ", customer_name=" + customer_name + ", phone=" + phone + ", order_date=" + order_date + ", order_status=" + order_status + ", shipping_address=" + shipping_address + ", payment_method=" + payment_method + ", total_amount=" + total_amount + '}';
    }

}
