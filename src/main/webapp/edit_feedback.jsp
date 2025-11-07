<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Feedback</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .star-rating {
            font-size: 2rem;
            cursor: pointer;
        }
        .star-rating .fa-star {
            color: #ddd;
            transition: color 0.2s;
        }
        .star-rating .fa-star.active {
            color: #ffc107;
        }
        .star-rating .fa-star:hover,
        .star-rating .fa-star:hover ~ .fa-star {
            color: #ffc107;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0"><i class="fas fa-edit"></i> Edit Your Feedback</h4>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/feedback/edit" method="post">
                            <input type="hidden" name="feedback_id" value="${feedback.feedback_id}">
                            
                            <div class="mb-4">
                                <label class="form-label fw-bold">Your Rating:</label>
                                <div class="star-rating" id="starRating">
                                    <i class="fas fa-star" data-value="1"></i>
                                    <i class="fas fa-star" data-value="2"></i>
                                    <i class="fas fa-star" data-value="3"></i>
                                    <i class="fas fa-star" data-value="4"></i>
                                    <i class="fas fa-star" data-value="5"></i>
                                </div>
                                <input type="hidden" name="rating" id="ratingInput" value="${feedback.rating}" required>
                            </div>

                            <div class="mb-4">
                                <label for="comment" class="form-label fw-bold">Comment:</label>
                                <textarea class="form-control" id="comment" name="comment" rows="5" 
                                          placeholder="Share your experience with this product...">${feedback.comment}</textarea>
                                <small class="text-muted">Required if rating is below 5★</small>
                            </div>

                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Update Feedback
                                </button>
                                <a href="${pageContext.request.contextPath}/orders?tab=delivered" class="btn btn-secondary">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Star rating functionality
        const stars = document.querySelectorAll('#starRating .fa-star');
        const ratingInput = document.getElementById('ratingInput');
        
        // Set initial rating
        let currentRating = parseInt(ratingInput.value) || 0;
        updateStars(currentRating);

        stars.forEach(star => {
            star.addEventListener('click', function() {
                currentRating = parseInt(this.getAttribute('data-value'));
                ratingInput.value = currentRating;
                updateStars(currentRating);
            });

            star.addEventListener('mouseenter', function() {
                const hoverValue = parseInt(this.getAttribute('data-value'));
                updateStars(hoverValue);
            });
        });

        document.getElementById('starRating').addEventListener('mouseleave', function() {
            updateStars(currentRating);
        });

        function updateStars(rating) {
            stars.forEach(star => {
                const value = parseInt(star.getAttribute('data-value'));
                if (value <= rating) {
                    star.classList.add('active');
                } else {
                    star.classList.remove('active');
                }
            });
        }
    </script>
</body>
</html>
