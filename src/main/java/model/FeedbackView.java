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

    public FeedbackView() {
    }

    public FeedbackView(int rating, String comment, Date createAt, String customerName) {
        this.rating = rating;
        this.comment = comment;
        this.createAt = createAt;
        this.customerName = customerName;
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
}
