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
 * Feedback entity lưu đúng theo bảng Feedback (đã thêm order_id). Các cột không
 * dùng có thể để null (vd: account_id).
 */
public class Feedback {

    private int feedback_id;     // PK (auto)
    private Integer account_id;  // có thể null (dành cho staff/admin nếu có)
    private int customer_id;
    private int order_id;        // ràng buộc: mỗi đơn – mỗi sản phẩm – 1 đánh giá
    private int product_id;
    private int rating;          // 1..5
    private String comment;      // có thể null/empty nếu 5★
    private Date create_at;      // thời điểm đánh giá
    private String image;        // nếu có upload ảnh

    public Feedback() {
    }

    public Feedback(int feedback_id, Integer account_id, int customer_id,
            int order_id, int product_id, int rating,
            String comment, Date create_at, String image) {
        this.feedback_id = feedback_id;
        this.account_id = account_id;
        this.customer_id = customer_id;
        this.order_id = order_id;
        this.product_id = product_id;
        this.rating = rating;
        this.comment = comment;
        this.create_at = create_at;
        this.image = image;
    }

    // Getter/Setter
    public int getFeedback_id() {
        return feedback_id;
    }

    public void setFeedback_id(int feedback_id) {
        this.feedback_id = feedback_id;
    }

    public Integer getAccount_id() {
        return account_id;
    }

    public void setAccount_id(Integer account_id) {
        this.account_id = account_id;
    }

    public int getCustomer_id() {
        return customer_id;
    }

    public void setCustomer_id(int customer_id) {
        this.customer_id = customer_id;
    }

    public int getOrder_id() {
        return order_id;
    }

    public void setOrder_id(int order_id) {
        this.order_id = order_id;
    }

    public int getProduct_id() {
        return product_id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
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

    public Date getCreate_at() {
        return create_at;
    }

    public void setCreate_at(Date create_at) {
        this.create_at = create_at;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
}
