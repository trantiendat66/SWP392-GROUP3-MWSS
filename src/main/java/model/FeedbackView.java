/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author Oanh Nguyen
 */
/**
 * DTO gọn để render product detail
 */
public class FeedbackView {

    private int rating;
    private String comment;
    private Date createAt;
    private String customerName;
    private String product;
    private int feedbackId;
    private boolean hidden;

    public FeedbackView() {
    }

    public FeedbackView(int feedbackId, int rating, String comment, Date createAt, String customerName, boolean hidden) {
        this.feedbackId = feedbackId;
        this.rating = rating;
        this.comment = comment;
        this.createAt = createAt;
        this.customerName = customerName;
        this.hidden = hidden;
    }

    public FeedbackView(int rating, String comment, Date createAt, String customerName, String product, int feedbackId) {
        this.rating = rating;
        this.comment = comment;
        this.createAt = createAt;
        this.customerName = customerName;
        this.product = product;
        this.feedbackId = feedbackId;
    }

    public String getProduct() {
        return product;
    }

    public void setProduct(String product) {
        this.product = product;
    }

    public int getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(int feedbackId) {
        this.feedbackId = feedbackId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Date getCreateAt() {
        return createAt;
    }

    public void setCreateAt(Date createAt) {
        this.createAt = createAt;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public boolean isHidden() {
        return hidden;
    }

    public void setHidden(boolean hidden) {
        this.hidden = hidden;
    }
}
