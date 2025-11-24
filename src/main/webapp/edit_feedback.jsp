<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<style>
    /* star row */
    .momo-stars {
        display:inline-flex;
        gap:6px;
        font-size: 28px;
        line-height:1;
        user-select:none;
    }
    .momo-stars input {
        display:none;
    }
    .momo-stars label {
        color:#d6d9dd;        /* light gray (empty star) */
        cursor:pointer;
        transition: transform .05s ease-in;
    }
    /* color all stars to the left of the selected star (use dir=rtl + ~ selector) */
    .momo-stars input:checked ~ label,
    .momo-stars label:hover,
    .momo-stars label:hover ~ label {
        color:#f59f00;        /* orange-yellow */
    }
    .momo-stars label:active {
        transform: scale(.95);
    }
    
    .edit-feedback-page {
        max-width: 600px;
        margin: 40px auto;
        padding: 20px;
    }
    
    .edit-feedback-card {
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 4px 16px rgba(0,0,0,0.1);
        overflow: hidden;
    }
    
    .edit-feedback-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: #fff;
        padding: 20px;
        text-align: center;
    }
    
    .edit-feedback-header h3 {
        margin: 0;
        font-size: 24px;
        font-weight: 600;
    }
    
    .edit-feedback-body {
        padding: 30px;
    }
    
    .form-label {
        font-weight: 600;
        margin-bottom: 10px;
        display: block;
    }
    
    .fb-comment {
        border: 1px solid #dee2e6;
        border-radius: 8px;
        padding: 12px;
        font-size: 14px;
    }
    
    .fb-comment:focus {
        border-color: #667eea;
        box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.15);
    }
    
    .btn-group-actions {
        display: flex;
        gap: 12px;
        margin-top: 24px;
    }
    
    .btn-group-actions .btn {
        flex: 1;
        padding: 10px;
        font-weight: 600;
    }
</style>

<div class="container edit-feedback-page">
    <div class="edit-feedback-card">
        <div class="edit-feedback-header">
            <h3>✏️ Edit Your Feedback</h3>
            <div style="font-size: 14px; color: #ffe082; font-weight: 500; margin-top: 4px;">
                <i class="fas fa-edit"></i> Edited
            </div>
        </div>
        
        <div class="edit-feedback-body">
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/feedback/edit" method="post">
                <input type="hidden" name="feedback_id" value="${feedback.feedback_id}">
                
                <!-- Rating -->
                <div class="mb-4 text-start">
                    <label class="form-label mb-2">Rating</label>
                    
                    <%-- star picker: 1 row of stars, click to select rating --%>
                    <div class="momo-stars" dir="rtl">
                        <input type="radio" name="rating" id="s5-edit" value="5" ${feedback.rating == 5 ? 'checked' : ''}>
                        <label for="s5-edit" title="5 stars">★</label>

                        <input type="radio" name="rating" id="s4-edit" value="4" ${feedback.rating == 4 ? 'checked' : ''}>
                        <label for="s4-edit" title="4 stars">★</label>

                        <input type="radio" name="rating" id="s3-edit" value="3" ${feedback.rating == 3 ? 'checked' : ''}>
                        <label for="s3-edit" title="3 stars">★</label>

                        <input type="radio" name="rating" id="s2-edit" value="2" ${feedback.rating == 2 ? 'checked' : ''}>
                        <label for="s2-edit" title="2 stars">★</label>

                        <input type="radio" name="rating" id="s1-edit" value="1" ${feedback.rating == 1 ? 'checked' : ''}>
                        <label for="s1-edit" title="1 star">★</label>
                    </div>
                </div>

                <div class="mb-3 text-start">
                    <label class="form-label fw-semibold d-block text-start mb-2">Comment</label>
                    <textarea name="comment" class="form-control fb-comment" rows="5"
                              placeholder="Share your experience with this product...">${feedback.comment}</textarea>
                    <div class="form-text text-muted mt-1">Required if rating is below 5★</div>
                </div>

                <div class="btn-group-actions">
                    <button type="submit" class="btn btn-primary">Update Feedback</button>
                    <a href="${pageContext.request.contextPath}/orders?tab=delivered" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/include/footer.jsp" %>
