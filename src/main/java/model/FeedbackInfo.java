/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author Nguyen Thien Dat - CE190879 - 06/05/2005
 */
public class FeedbackInfo {

    private int feedbackId;
    private int accountId;
    private int customerId;
    private String image;
    private String productName;
    private int orderId;
    private String customerName;
    private int rating;
    private Date createAt;
    private String comment;

    public FeedbackInfo() {
    }

    public FeedbackInfo(int feedbackId, int accountId, int customerId, String image, String productName, int orderId, String customerName, int rating, Date createAt, String comment) {
        this.feedbackId = feedbackId;
        this.accountId = accountId;
        this.customerId = customerId;
        this.image = image;
        this.productName = productName;
        this.orderId = orderId;
        this.customerName = customerName;
        this.rating = rating;
        this.createAt = createAt;
        this.comment = comment;
    }

    public int getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(int feedbackId) {
        this.feedbackId = feedbackId;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
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

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public Date getCreateAt() {
        return createAt;
    }

    public void setCreateAt(Date createAt) {
        this.createAt = createAt;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

}
