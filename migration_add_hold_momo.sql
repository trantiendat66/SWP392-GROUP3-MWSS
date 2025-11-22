-- Migration: MoMo hold payment flow
-- Tận dụng database hiện có, KHÔNG thêm bảng hay column mới
-- Chỉ dùng order_status='PENDING_HOLD' để đánh dấu đơn giữ chỗ MoMo
-- Thời gian hết hạn: order_date + 12 giờ

-- KHÔNG CẦN CHẠY SCRIPT NÀY - Code sẽ tận dụng database hiện tại
