# MoMo Payment Integration Guide

## Cấu hình MoMo Payment Gateway

### 1. Thông tin Test Environment (đã cấu hình sẵn)

Hiện tại hệ thống đã được cấu hình với MoMo Test Environment:

- **Partner Code**: MOMOBKUN20180529
- **Access Key**: klm05TvNBzhg7h7j
- **Secret Key**: at67qH6mk8w5Y1nAyMoYKMWACiEi2bsa
- **Endpoint**: https://test-payment.momo.vn/v2/gateway/api/create

### 2. Cấu hình URL Callback

File: `src/main/java/util/MoMoConfig.java`

```java
// IPN URL - MoMo gọi về khi thanh toán xong (server-to-server)
public static final String IPN_URL = "http://localhost:8080/SWP_MWSS-V1.0/momo/callback";

// Return URL - URL redirect user về sau khi thanh toán
public static final String RETURN_URL = "http://localhost:8080/SWP_MWSS-V1.0/momo/return";
```

**LƯU Ý QUAN TRỌNG**:
- Khi deploy lên production, phải thay `localhost:8080` bằng domain thật
- Ví dụ: `https://yourdomain.com/SWP_MWSS-V1.0/momo/callback`
- MoMo yêu cầu HTTPS cho production environment

### 3. Flow thanh toán MoMo

```
1. User chọn "MoMo Wallet" tại trang payment
2. Click "Pay with MoMo" 
   → POST đến /momo/payment
3. Server tạo payment request → MoMo API
4. MoMo trả về payUrl
5. Redirect user đến payUrl (trang thanh toán MoMo)
6. User thanh toán trên app/web MoMo
7. MoMo gọi IPN callback → /momo/callback (tạo order)
8. MoMo redirect user về → /momo/return (hiển thị kết quả)
```

### 4. Test thanh toán MoMo

MoMo Test Environment cung cấp các test case:

**Thanh toán thành công:**
- Số điện thoại: 0963181714
- OTP: 888888

**Thanh toán thất bại:**
- Số điện thoại khác
- Hoặc nhập OTP sai

### 5. Chuyển sang Production

Khi chuyển sang môi trường thật:

1. **Đăng ký tài khoản MoMo Business**: https://business.momo.vn/
2. **Hoàn tất KYC và ký hợp đồng**
3. **Nhận thông tin production:**
   - Partner Code mới
   - Access Key mới
   - Secret Key mới
   - Endpoint: https://payment.momo.vn/v2/gateway/api/create

4. **Cập nhật file MoMoConfig.java** với thông tin production
5. **Cập nhật IPN_URL và RETURN_URL** với domain thật (HTTPS)
6. **Test kỹ trước khi go-live**

### 6. Xử lý lỗi và Monitoring

**Các lỗi thường gặp:**

- **resultCode = 9000**: Transaction timeout (user không thanh toán trong thời gian quy định)
- **resultCode = 1006**: Transaction denied by user
- **resultCode = 1001**: Payment failed

**Log tracking:**
- Check console log để debug
- MoMo callback sẽ print log tại `MoMoCallbackServlet`
- Return URL sẽ print log tại `MoMoReturnServlet`

### 7. Security Best Practices

1. **Bảo mật SECRET_KEY**: 
   - Không commit Secret Key lên Git public
   - Sử dụng environment variables cho production
   
2. **Verify Signature**: 
   - Luôn verify signature từ MoMo callback
   - Đã implement trong `MoMoPaymentUtil.verifySignature()`

3. **HTTPS Only**: 
   - Production phải dùng HTTPS
   - MoMo reject HTTP callbacks

4. **Idempotency**: 
   - Check orderId trước khi tạo order mới
   - Tránh duplicate order khi IPN retry

### 8. Database Changes (Optional)

Để tracking tốt hơn, nên tạo bảng `MoMoTransaction`:

```sql
CREATE TABLE MoMoTransaction (
    transaction_id INT PRIMARY KEY IDENTITY(1,1),
    momo_order_id VARCHAR(100) UNIQUE NOT NULL,
    momo_request_id VARCHAR(100),
    momo_trans_id VARCHAR(100),
    customer_id INT,
    amount BIGINT,
    result_code INT,
    message NVARCHAR(500),
    order_id INT, -- Link to Order table after created
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (order_id) REFERENCES [Order](order_id)
);
```

### 9. Troubleshooting

**Q: MoMo không gọi về IPN callback?**
- Check firewall cho phép MoMo IP
- Verify IPN_URL accessible từ internet
- Check ngrok nếu test local

**Q: Signature không khớp?**
- Check thứ tự parameters trong rawSignature
- Verify Secret Key đúng
- Check encoding UTF-8

**Q: Order bị duplicate?**
- Implement idempotency check
- Use unique momo_order_id

### 10. Support

- MoMo Developer Portal: https://developers.momo.vn/
- MoMo Test Environment: https://test-payment.momo.vn/
- Technical Support: dev@momo.vn

---

## Files đã tạo/sửa

1. **src/main/java/util/MoMoConfig.java** - Configuration
2. **src/main/java/util/MoMoPaymentUtil.java** - Utility functions
3. **src/main/java/controller/MoMoPaymentServlet.java** - Tạo payment request
4. **src/main/java/controller/MoMoCallbackServlet.java** - Nhận IPN callback
5. **src/main/java/controller/MoMoReturnServlet.java** - Xử lý return URL
6. **src/main/webapp/payment.jsp** - Updated UI với MoMo option

---

**Author**: Oanh Nguyen  
**Date**: November 7, 2025  
**Version**: 1.0
