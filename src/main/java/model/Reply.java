/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Nguyen Thien Dat - CE190879 - 06/05/2005
 */
public class Reply {

    private int repId;
    private int feedbackId;
    private int accountId;
    private int customerId;
    private String contentReply;

    public Reply() {
    }

    public Reply(int repId, int feedbackId, int accountId, int customerId, String contentReply) {
        this.repId = repId;
        this.feedbackId = feedbackId;
        this.accountId = accountId;
        this.customerId = customerId;
        this.contentReply = contentReply;
    }

    public int getRepId() {
        return repId;
    }

    public void setRepId(int repId) {
        this.repId = repId;
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

    public String getContentReply() {
        return contentReply;
    }

    public void setContentReply(String contentReply) {
        this.contentReply = contentReply;
    }

}
