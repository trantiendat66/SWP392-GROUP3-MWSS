# TÀI LIỆU CHUẨN BỊ BẢO VỆ - LUỒNG MUA HÀNG VÀ THANH TOÁN MOMO

## 1. TỔNG QUAN LUỒNG MUA HÀNG VÀ THANH TOÁN

### 1.1. Kiến trúc tổng thể
```
Customer → Browse Products → Add to Cart / Buy Now → Payment Page
                                                      ↓
                                            [COD]    [MoMo]
                                              ↓         ↓
                                         Create Order  MoMo Payment Flow
                                              ↓         ↓
                                         Order Success [Hold Order → QR Payment]
                                                            ↓
                                                    [Success] [Failed/Timeout]
                                                       ↓           ↓
                                                  Order Pending  Retry/Switch to COD
```

### 1.2. Các thành phần chính
- **Frontend**: JSP pages (payment.jsp, momo-payment.jsp, order-success.jsp)
- **Backend**: Servlets (MoMoPaymentServlet, MoMoCallbackServlet, MoMoReturnServlet, OrderCreateFromCartServlet)
- **Database**: Order, OrderDetail, Product tables
- **External API**: MoMo Payment Gateway API
- **Utilities**: MoMoPaymentUtil, MoMoConfig

---

## 2. LUỒNG THANH TOÁN COD (Cash on Delivery)

### 2.1. Mô tả luồng
1. Khách hàng chọn sản phẩm → Add to Cart hoặc Buy Now
2. Tại trang payment.jsp, chọn phương thức thanh toán COD (payment_method = 0)
3. Nhập thông tin giao hàng (địa chỉ, số điện thoại)
4. Submit form → `OrderCreateFromCartServlet` xử lý:
   - Kiểm tra đăng nhập
   - Lấy danh sách sản phẩm (từ giỏ hàng hoặc buy-now)
   - Gọi `OrderDAO.createOrder()` với payment_method = 0 (COD)
   - Trừ tồn kho sản phẩm
   - Tạo đơn hàng với trạng thái `PENDING`
   - Xóa giỏ hàng (nếu checkout từ cart)
5. Redirect đến trang order-success.jsp

### 2.2. Code liên quan
**File**: `OrderCreateFromCartServlet.java`
```java
int paymentBit = "1".equals(methodParam) ? 1 : 0; // 0 = COD

int orderId = orderDAO.createOrder(
    cus.getCustomer_id(),
    phone,
    address,
    paymentBit, // 0 cho COD
    items
);
```

**File**: `OrderDAO.java` - `createOrder()`
- Tạo bản ghi trong bảng `Order` với `order_status = 'PENDING'`
- Tạo các bản ghi trong bảng `OrderDetail` cho từng sản phẩm
- Trừ số lượng tồn kho trong bảng `Product`

### 2.3. Xử lý lỗi
- Nếu sản phẩm hết hàng → SQLException → rollback transaction
- Nếu buy-now failed → tự động thêm sản phẩm vào giỏ hàng (nếu còn tồn kho)

---

## 3. LUỒNG THANH TOÁN MOMO (Luồng chính - QUAN TRỌNG)

### 3.1. Tổng quan
MoMo sử dụng phương thức **"Hold Order"** để đảm bảo tồn kho được giữ trong khi khách hàng thanh toán:
1. Tạo đơn hàng tạm (PENDING_HOLD) - trừ tồn kho ngay
2. Gửi request đến MoMo API → nhận QR code
3. Khách hàng quét QR và thanh toán
4. MoMo callback thông báo kết quả
5. Chuyển trạng thái đơn hàng từ PENDING_HOLD → PENDING (nếu thành công)

### 3.2. Chi tiết từng bước

#### **Bước 1: Khởi tạo thanh toán MoMo**
**File**: `MoMoPaymentServlet.java` (`/momo/payment`)

**Logic**:
```java
// 1. Kiểm tra đăng nhập
if (session == null || session.getAttribute("customer") == null) {
    redirect to login
}

// 2. Lấy thông tin sản phẩm (cart hoặc buy-now)
boolean isBuyNow = (bnPid != null && bnQty != null);
if (isBuyNow) {
    items = [single product from buy-now]
} else {
    items = cartDAO.findItemsForCheckout(customerId)
}

// 3. Tính tổng tiền
long totalAmount = sum(price * quantity)

// 4. Tạo hoặc tái sử dụng HOLD order
Integer holdOrderId = session.getAttribute("hold_order_id");
if (holdOrderId == null) {
    // Tạo đơn hàng tạm: PENDING_HOLD, payment_method=2 (MoMo)
    holdOrderId = createHoldOrder(orderDAO, customerId, phone, address, isBuyNow, items);
    session.setAttribute("hold_order_id", holdOrderId);
    
    // Xóa giỏ hàng ngay (sản phẩm đã được reserved trong order)
    if (!isBuyNow) {
        cartDAO.clearCart(customerId);
    }
}

// 5. Sinh mã giao dịch MoMo
String momoOrderId = MoMoConfig.generateOrderId(customerId); // unique ID
String requestId = MoMoConfig.generateRequestId(); // unique request

// 6. Mã hóa thông tin bổ sung (extraData)
String extraData = customerId + "|" + phone + "|" + address + "|" + isBuyNow;
extraData = Base64.encode(extraData); // để gửi qua MoMo và nhận lại trong callback

// 7. Gọi MoMo API
String redirectUrl = baseUrl + "/momo/return"; // URL MoMo redirect sau khi thanh toán
String ipnUrl = baseUrl + "/momo/callback"; // URL MoMo gọi IPN callback

JSONObject momoResponse = MoMoPaymentUtil.createPaymentRequest(
    momoOrderId, requestId, totalAmount, orderInfo, extraData, redirectUrl, ipnUrl
);

// 8. Xử lý kết quả
if (momoResponse.getInt("resultCode") == 0) {
    String payUrl = momoResponse.getString("payUrl"); // URL trang thanh toán MoMo
    String qrCodeUrl = momoResponse.getString("qrCodeUrl"); // URL QR code
    
    // Lưu vào session để hiển thị
    session.setAttribute("momo_pay_url", payUrl);
    session.setAttribute("momo_qr_url", qrCodeUrl);
    session.setAttribute("total_amount", totalAmount);
    
    // Redirect đến trang hiển thị QR
    redirect to "/momo-payment.jsp"
} else {
    // Lỗi từ MoMo API
    session.setAttribute("error", "MoMo error: " + message);
    redirect to "/payment"
}
```

**Hàm `createHoldOrder()`**:
```java
private int createHoldOrder(OrderDAO orderDAO, int customerId, String phone, 
                           String address, boolean isBuyNow, List<Cart> items) {
    try (Connection cn = new db.DBContext().getConnection()) {
        // 1. Tạo order với trạng thái PENDING_HOLD, payment_method=2 (MoMo)
        String sql = "INSERT INTO [Order] (customer_id, order_date, phone, shipping_address, "
                   + "payment_method, order_status, account_id, total_amount) "
                   + "VALUES (?, GETDATE(), ?, ?, 2, 'PENDING_HOLD', ?, ?)";
        
        // 2. Tạo OrderDetail cho từng sản phẩm
        // 3. TRỪ TỒN KHO NGAY (quan trọng!)
        String updateStock = "UPDATE Product SET quantityProduct = quantityProduct - ? "
                           + "WHERE product_id = ?";
        
        return orderId;
    }
}
```

**Key Points**:
- **Tồn kho được trừ ngay** khi tạo PENDING_HOLD order
- Nếu khách hàng không thanh toán trong thời gian quy định → auto-cancel → hoàn lại tồn kho
- `extraData` chứa thông tin để xử lý callback (customerId, phone, address, isBuyNow)

---

#### **Bước 2: Hiển thị trang QR thanh toán**
**File**: `momo-payment.jsp`

**Features**:
1. **Hiển thị thông tin đơn hàng**: Order ID, MoMo Transaction ID, Total Amount
2. **Nút mở cổng thanh toán MoMo**: Mở popup window với URL `momo_pay_url`
3. **Countdown timer**: 90 giây (có thể tùy chỉnh)
   ```javascript
   let timeLeft = 90; // seconds
   const timerInterval = setInterval(updateTimer, 1000);
   
   function updateTimer() {
       if (timeLeft <= 0) {
           // Hết thời gian → hiển thị message expired
           // Tự động gọi API để cancel order (optional)
       }
       timeLeft--;
   }
   ```
4. **Polling trạng thái đơn hàng**: Mỗi 3 giây gọi API `/api/order-status` để check xem đơn hàng đã được thanh toán chưa
   ```javascript
   const statusPollInterval = setInterval(function() {
       fetch('/api/order-status?orderId=' + ORDER_ID)
           .then(response => response.json())
           .then(data => {
               if (data.success) {
                   // Thanh toán thành công → hiển thị success message
                   showSuccess(data.orderStatus);
               }
           });
   }, 3000);
   ```

**Key Points**:
- Không cần reload page, tự động cập nhật trạng thái bằng AJAX
- Countdown giúp người dùng biết thời gian còn lại
- Nếu hết giờ → hiển thị nút "Retry" hoặc "Switch to COD"

---

#### **Bước 3: Xử lý callback từ MoMo (IPN - Instant Payment Notification)**
**File**: `MoMoCallbackServlet.java` (`/momo/callback`)

**Vai trò**: MoMo sẽ gọi đến endpoint này ngay khi khách hàng thanh toán thành công hoặc thất bại.

**Logic**:
```java
@Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
    // 1. Đọc JSON body từ MoMo
    BufferedReader reader = req.getReader();
    String requestBody = readBody(reader);
    JSONObject callbackData = new JSONObject(requestBody);
    
    // 2. Parse các thông tin
    String orderId = callbackData.getString("orderId");
    int resultCode = callbackData.getInt("resultCode"); // 0 = success
    String signature = callbackData.getString("signature");
    String extraData = callbackData.getString("extraData");
    
    // 3. Xác thực chữ ký (signature) từ MoMo
    boolean isValidSignature = MoMoPaymentUtil.verifySignature(params, signature);
    if (!isValidSignature) {
        return error response "Invalid signature"
    }
    
    // 4. Kiểm tra resultCode
    if (resultCode == 0) {
        // THANH TOÁN THÀNH CÔNG
        
        // 4.1. Giải mã extraData
        String decodedExtraData = Base64.decode(extraData);
        String[] parts = decodedExtraData.split("\\|");
        int customerId = Integer.parseInt(parts[0]);
        String phone = parts[1];
        String address = parts[2];
        boolean isBuyNow = Boolean.parseBoolean(parts[3]);
        
        // 4.2. Lấy danh sách sản phẩm
        List<Cart> items;
        if (isBuyNow) {
            // TODO: Lưu thông tin buy-now vào DB để xử lý trong callback
            items = new ArrayList<>(); // Tạm thời empty
        } else {
            items = cartDAO.findItemsForCheckout(customerId);
        }
        
        // 4.3. Tạo đơn hàng chính thức (payment_method = 1 = đã thanh toán MoMo)
        int dbOrderId = orderDAO.createOrder(
            customerId, phone, address, 
            1, // 1 = Đã thanh toán qua MoMo
            items
        );
        
        // 4.4. Xóa giỏ hàng (nếu không phải buy-now)
        if (!isBuyNow) {
            cartDAO.clearCart(customerId);
        }
        
        // 4.5. Response success đến MoMo
        response.put("status", "success");
        return response;
    } else {
        // THANH TOÁN THẤT BẠI
        response.put("status", "failed");
        return response;
    }
}
```

**Signature Verification**:
```java
public static boolean verifySignature(Map<String, String> params, String receivedSignature) {
    String rawSignature = "accessKey=" + params.get("accessKey")
            + "&amount=" + params.get("amount")
            + "&extraData=" + params.get("extraData")
            // ... các field khác theo thứ tự alphabet
            + "&transId=" + params.get("transId");
    
    String calculatedSignature = hmacSHA256(rawSignature, SECRET_KEY);
    return calculatedSignature.equals(receivedSignature);
}
```

**Key Points**:
- **Bảo mật**: Luôn verify signature để đảm bảo request đến từ MoMo
- **Idempotency**: Nên check xem đơn hàng đã được xử lý chưa (tránh duplicate)
- **Asynchronous**: Callback xảy ra độc lập với người dùng, không có session

**⚠️ VẤN ĐỀ HIỆN TẠI**: 
- Callback không xử lý được buy-now vì không có session
- **Giải pháp**: Cần lưu thông tin buy-now vào database (bảng tạm) để callback có thể lấy ra

---

#### **Bước 4: Xử lý return URL (Redirect từ MoMo về website)**
**File**: `MoMoReturnServlet.java` (`/momo/return`)

**Vai trò**: Sau khi khách hàng thanh toán xong trên trang MoMo, MoMo sẽ redirect về URL này.

**Logic**:
```java
@Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp) {
    // 1. Parse query parameters từ MoMo
    String resultCode = req.getParameter("resultCode");
    String orderId = req.getParameter("orderId"); // MoMo orderId
    String transId = req.getParameter("transId"); // MoMo transaction ID
    
    // 2. Lấy hold_order_id từ session
    Integer holdOrderId = (Integer) session.getAttribute("hold_order_id");
    
    if (resultCode.equals("0")) {
        // THANH TOÁN THÀNH CÔNG
        
        // 3. Chuyển trạng thái đơn hàng từ PENDING_HOLD → PENDING
        String sql = "UPDATE [Order] SET order_status='PENDING' "
                   + "WHERE order_id=? AND order_status='PENDING_HOLD'";
        // Execute SQL
        
        // 4. Xóa tracking session
        session.removeAttribute("hold_order_id");
        session.removeAttribute("momo_order_id");
        session.removeAttribute("momo_pay_url");
        
        // 5. Redirect đến trang success
        session.setAttribute("flash_success", "Payment successful!");
        redirect to "/order-success.jsp?orderId=" + holdOrderId
    } else {
        // THANH TOÁN THẤT BẠI
        session.setAttribute("error", "Payment failed. Please try again.");
        redirect to "/orders"
    }
}
```

**Key Points**:
- Return URL có session → có thể truy cập thông tin người dùng
- Cập nhật trạng thái đơn hàng ngay để người dùng thấy được kết quả
- Nếu thành công → đơn hàng chuyển từ PENDING_HOLD sang PENDING (đang xử lý)

---

### 3.3. Xử lý các trường hợp đặc biệt

#### **A. Retry Payment (Thử lại thanh toán)**
**File**: `MoMoRetryServlet.java` (`/momo/retry`)

**Kịch bản**: Khách hàng thanh toán thất bại hoặc hết giờ, muốn thử lại.

**Logic**:
```java
// 1. Kiểm tra đơn hàng vẫn còn trong trạng thái PENDING_HOLD
Order order = orderDAO.getOrderByOrderId(orderId);
if (!"PENDING_HOLD".equals(order.getOrder_status())) {
    return error "Order not in PENDING_HOLD state"
}

// 2. Kiểm tra đơn hàng chưa hết hạn (order_date + 12 giờ)
Date orderDate = order.getOrder_date();
Date now = new Date();
long diffHours = (now.getTime() - orderDate.getTime()) / (1000 * 60 * 60);
if (diffHours > 12) {
    return error "Order has expired"
}

// 3. Tạo requestId và momoOrderId mới
String newRequestId = MoMoConfig.generateRequestId();
String momoOrderId = MoMoConfig.generateOrderId(customerId);

// 4. Gọi lại MoMo API
JSONObject momoResponse = MoMoPaymentUtil.createPaymentRequest(...);

// 5. Redirect đến trang QR mới
redirect to "/momo-payment.jsp"
```

**Key Points**:
- Không tạo đơn hàng mới, chỉ tạo request MoMo mới
- Tồn kho đã được trừ từ lần đầu, không trừ lại
- Kiểm tra expiry để tránh giữ tồn kho quá lâu

---

#### **B. Switch to COD (Chuyển sang thanh toán COD)**
**File**: `SwitchToCODServlet.java` (`/order/switch-to-cod`)

**Kịch bản**: Khách hàng không muốn thanh toán MoMo nữa, chuyển sang COD.

**Logic**:
```java
// 1. Kiểm tra đơn hàng còn trong PENDING_HOLD
Order order = orderDAO.getOrderByOrderId(orderId);
if (!"PENDING_HOLD".equals(order.getOrder_status())) {
    return error "Order not in PENDING_HOLD state"
}

// 2. Kiểm tra chưa hết hạn
if (isExpired(order)) {
    return error "Order has expired"
}

// 3. Chuyển trạng thái: PENDING_HOLD → PENDING, payment_method: 2 (MoMo) → 0 (COD)
String sql = "UPDATE [Order] SET order_status='PENDING', payment_method=0 "
           + "WHERE order_id=? AND order_status='PENDING_HOLD'";

// 4. Xóa tracking session
session.removeAttribute("hold_order_id");
session.removeAttribute("momo_order_id");

// 5. Redirect
redirect to "/orders"
```

**Key Points**:
- Giữ nguyên đơn hàng và tồn kho đã trừ
- Chỉ thay đổi phương thức thanh toán và trạng thái
- Không cần hoàn tồn kho

---

#### **C. Auto-cancel expired orders (Tự động hủy đơn hết hạn)**
**File**: `AutoCancelHoldServlet.java` (`/api/auto-cancel-hold`)

**Kịch bản**: Đơn hàng PENDING_HOLD quá thời gian giữ (12 giờ) → tự động hủy và hoàn tồn kho.

**Cách hoạt động**:
1. Frontend (orders-table.jsp) có countdown timer cho mỗi đơn PENDING_HOLD
2. Khi countdown về 0 → gọi AJAX đến `/api/auto-cancel-hold`
3. Backend xử lý:
   ```java
   // 1. Kiểm tra đơn hàng vẫn còn PENDING_HOLD
   if (!"PENDING_HOLD".equals(order.getOrder_status())) {
       return error
   }
   
   // 2. Gọi OrderDAO.cancelHoldOrder()
   boolean cancelled = orderDAO.cancelHoldOrder(orderId);
   
   // 3. Trong cancelHoldOrder():
   //    - Hoàn lại tồn kho (UPDATE Product SET quantityProduct += quantity)
   //    - Chuyển trạng thái đơn hàng sang CANCELLED
   //    - Xóa OrderDetail (optional)
   ```

**Key Points**:
- Đảm bảo tồn kho không bị "đóng băng" mãi mãi
- Frontend trigger (không cần cron job phức tạp)
- User-friendly: Khách hàng thấy countdown → biết còn bao lâu

---

## 4. MÃ HÓA VÀ BẢO MẬT

### 4.1. HMAC SHA256 Signature
**Mục đích**: Xác thực request/response giữa hệ thống và MoMo.

**Cách hoạt động**:
```java
// Raw signature string (các field sắp xếp theo alphabet)
String rawSignature = "accessKey=" + ACCESS_KEY
        + "&amount=" + amount
        + "&extraData=" + extraData
        + "&ipnUrl=" + ipnUrl
        + "&orderId=" + orderId
        + "&orderInfo=" + orderInfo
        + "&partnerCode=" + partnerCode
        + "&redirectUrl=" + redirectUrl
        + "&requestId=" + requestId
        + "&requestType=" + requestType;

// Tạo signature bằng HMAC SHA256
String signature = hmacSHA256(rawSignature, SECRET_KEY);

// Gửi signature cùng với request
requestBody.put("signature", signature);
```

**Verify signature từ MoMo**:
```java
// Xây dựng lại raw signature từ callback data
String rawSignature = buildRawSignature(callbackData);
String calculatedSignature = hmacSHA256(rawSignature, SECRET_KEY);

// So sánh với signature MoMo gửi về
if (calculatedSignature.equals(receivedSignature)) {
    // Valid → xử lý
} else {
    // Invalid → reject
}
```

### 4.2. Base64 Encoding cho extraData
**Mục đích**: Truyền dữ liệu phức tạp qua MoMo mà không bị lỗi special characters.

```java
// Encode
String extraData = customerId + "|" + phone + "|" + address + "|" + isBuyNow;
String encoded = Base64.getEncoder().encodeToString(extraData.getBytes());

// Decode (trong callback)
String decoded = new String(Base64.getDecoder().decode(encoded));
String[] parts = decoded.split("\\|");
int customerId = Integer.parseInt(parts[0]);
String phone = parts[1];
// ...
```

---

## 5. XỬ LÝ LỖI VÀ EDGE CASES

### 5.1. Các trường hợp lỗi thường gặp

| Lỗi | Nguyên nhân | Xử lý |
|-----|-------------|-------|
| Sản phẩm hết hàng | Tồn kho = 0 hoặc < quantity | Hiển thị lỗi, không cho đặt hàng |
| Đơn hàng duplicate | Callback gọi nhiều lần | Check xem đơn hàng đã xử lý chưa (idempotency) |
| Signature invalid | Secret key sai hoặc raw signature sai thứ tự | Log chi tiết, reject request |
| Session expired | Người dùng đóng trình duyệt và quay lại | Check session null → redirect login |
| MoMo API timeout | Network issue | Retry logic hoặc hiển thị lỗi |
| Hold order expired | Quá 12 giờ | Auto-cancel → hoàn tồn kho |

### 5.2. Transaction và Rollback
```java
try (Connection cn = new db.DBContext().getConnection()) {
    cn.setAutoCommit(false); // Bắt đầu transaction
    
    try {
        // 1. Tạo order
        insertOrder(cn, orderData);
        
        // 2. Tạo order details
        for (Cart item : items) {
            insertOrderDetail(cn, orderId, item);
        }
        
        // 3. Trừ tồn kho
        for (Cart item : items) {
            updateStock(cn, item.getProduct_id(), -item.getQuantity());
        }
        
        cn.commit(); // Commit transaction
        return orderId;
        
    } catch (SQLException e) {
        cn.rollback(); // Rollback nếu có lỗi
        throw e;
    }
}
```

---

## 6. CÂU HỎI GIẢNG VIÊN CÓ THỂ HỎI VÀ CÁCH TRẢ LỜI

### 6.1. Câu hỏi về Kiến trúc và Thiết kế

**Q1: Tại sao em lại sử dụng "Hold Order" thay vì chỉ tạo đơn hàng khi thanh toán thành công?**

**Trả lời**:
> "Em sử dụng Hold Order để giải quyết vấn đề **race condition** và **overselling**:
> 
> 1. **Vấn đề**: Nếu chỉ tạo đơn hàng sau khi thanh toán, trong khoảng thời gian khách hàng đang thanh toán (có thể vài phút), tồn kho vẫn hiển thị sẵn có. Nếu nhiều người cùng mua và thanh toán cùng lúc, có thể xảy ra tình trạng bán quá số lượng tồn kho.
> 
> 2. **Giải pháp Hold Order**:
>    - Khi khách hàng chọn MoMo, hệ thống tạo ngay đơn hàng với trạng thái `PENDING_HOLD`
>    - **Trừ tồn kho ngay lập tức** để "giữ chỗ" cho khách hàng
>    - Nếu thanh toán thành công → chuyển sang `PENDING` (đơn hàng chính thức)
>    - Nếu thất bại hoặc hết giờ (12 giờ) → auto-cancel và **hoàn lại tồn kho**
> 
> 3. **Lợi ích**:
>    - Đảm bảo không oversell
>    - Khách hàng không phải lo bị mất hàng trong khi thanh toán
>    - Tồn kho được quản lý chính xác real-time"

---

**Q2: Em xử lý callback từ MoMo như thế nào? Tại sao cần cả callback và return URL?**

**Trả lời**:
> "Em xử lý 2 luồng song song:
> 
> **1. Return URL (`MoMoReturnServlet`):**
> - Đây là URL mà MoMo **redirect khách hàng về** sau khi thanh toán
> - Có **session** → có thể truy cập thông tin người dùng, hold_order_id
> - Nhiệm vụ: Cập nhật trạng thái đơn hàng, hiển thị kết quả cho người dùng
> - **Không đảm bảo**: Người dùng có thể đóng trình duyệt trước khi redirect
> 
> **2. IPN Callback (`MoMoCallbackServlet`):**
> - Đây là endpoint mà **MoMo server gọi trực tiếp** (server-to-server)
> - **Không có session** → phải lấy thông tin từ `extraData`
> - Nhiệm vụ: Xử lý business logic chính (tạo đơn hàng, trừ tồn kho, xóa giỏ hàng)
> - **Đảm bảo**: Luôn được gọi bất kể người dùng có đóng trình duyệt hay không
> 
> **Tại sao cần cả 2?**
> - **Callback**: Đảm bảo logic xử lý chắc chắn được thực thi
> - **Return URL**: Cải thiện UX, người dùng thấy kết quả ngay lập tức
> 
> **Best practice**: Logic chính đặt ở callback, return URL chỉ làm UI update"

---

**Q3: Em verify signature từ MoMo như thế nào? Tại sao phải verify?**

**Trả lời**:
> "**Tại sao cần verify signature:**
> - Để đảm bảo request đến từ **MoMo chính thức**, không phải hacker giả mạo
> - Nếu không verify, ai cũng có thể gọi callback endpoint và tạo đơn hàng giả
> 
> **Cách verify:**
> 
> 1. **MoMo gửi signature trong callback:**
>    ```json
>    {
>      "orderId": "...",
>      "resultCode": 0,
>      "signature": "abc123def456..."
>    }
>    ```
> 
> 2. **Em tính lại signature từ dữ liệu nhận được:**
>    ```java
>    String rawSignature = "accessKey=" + accessKey
>            + "&amount=" + amount
>            + "&extraData=" + extraData
>            // ... các field khác theo alphabet
>            + "&transId=" + transId;
>    
>    String calculatedSignature = hmacSHA256(rawSignature, SECRET_KEY);
>    ```
> 
> 3. **So sánh:**
>    ```java
>    if (calculatedSignature.equals(receivedSignature)) {
>        // Valid → xử lý
>    } else {
>        // Invalid → reject và log
>    }
>    ```
> 
> **Quan trọng:**
> - SECRET_KEY chỉ có em và MoMo biết (không public)
> - Raw signature phải sắp xếp field theo **alphabet** (theo tài liệu MoMo)
> - Sử dụng **HMAC SHA256** (thuật toán mã hóa một chiều)"

---

### 6.2. Câu hỏi về Xử lý Nghiệp vụ

**Q4: Nếu khách hàng thanh toán thành công nhưng callback bị lỗi (network issue), đơn hàng sẽ như thế nào?**

**Trả lời**:
> "Đây là edge case quan trọng. Em xử lý như sau:
> 
> **Tình huống:**
> - Khách hàng thanh toán thành công trên MoMo
> - MoMo cố gắng gọi callback nhưng server em bị down hoặc network timeout
> 
> **Xử lý hiện tại:**
> 1. **MoMo retry mechanism**: MoMo sẽ tự động retry callback nhiều lần (theo config của họ, thường là 5-10 lần trong vài giờ)
> 2. **Return URL vẫn hoạt động**: Khi khách hàng redirect về, `MoMoReturnServlet` sẽ cập nhật trạng thái đơn hàng từ PENDING_HOLD → PENDING
> 3. **Hold order timeout**: Nếu sau 12 giờ vẫn không được xử lý, đơn hàng sẽ bị auto-cancel
> 
> **Cải tiến có thể làm:**
> - **Manual reconciliation**: Admin có thể so sánh danh sách giao dịch trên MoMo portal với database để tìm những giao dịch bị lỡ
> - **Query transaction API**: Gọi API của MoMo để check trạng thái giao dịch theo orderId
> - **Alert system**: Gửi email/SMS cho admin khi phát hiện đơn hàng PENDING_HOLD quá lâu nhưng có payment record trên MoMo
> 
> **Lưu ý**: Trong production, cần có cron job hoặc background service để handle reconciliation tự động."

---

**Q5: Em xử lý concurrency như thế nào? Nếu 2 người cùng mua sản phẩm cuối cùng trong kho cùng lúc thì sao?**

**Trả lời**:
> "Em xử lý concurrency bằng **database transaction** và **row-level locking**:
> 
> **1. Transaction Isolation:**
> ```java
> Connection cn = db.getConnection();
> cn.setAutoCommit(false); // Start transaction
> cn.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
> ```
> 
> **2. Pessimistic Locking (nếu cần):**
> ```sql
> -- Lock row khi đọc để ngăn người khác sửa
> SELECT quantityProduct FROM Product WITH (UPDLOCK, ROWLOCK) 
> WHERE product_id = ?
> ```
> 
> **3. Atomic Update:**
> ```sql
> -- Trừ tồn kho bằng 1 query atomic
> UPDATE Product 
> SET quantityProduct = quantityProduct - ? 
> WHERE product_id = ? AND quantityProduct >= ?
> ```
> - Nếu `quantityProduct < quantity` cần mua → UPDATE sẽ return 0 rows affected → rollback
> 
> **4. Check after update:**
> ```java
> int rowsAffected = ps.executeUpdate();
> if (rowsAffected == 0) {
>     cn.rollback();
>     throw new SQLException("Insufficient stock");
> }
> cn.commit();
> ```
> 
> **Kịch bản 2 người cùng mua:**
> - Người A: Start transaction → Lock row → Check stock (1) → Update -1 → Commit
> - Người B: Start transaction → **Chờ lock release** → Check stock (0) → Fail → Rollback
> 
> **Kết quả**: Người A mua được, người B thấy thông báo hết hàng. Database đảm bảo consistency."

---

**Q6: Em có xử lý idempotency không? Nếu MoMo gọi callback 2 lần thì sao?**

**Trả lời**:
> "**Idempotency** là việc đảm bảo cùng 1 request được gọi nhiều lần nhưng chỉ xử lý 1 lần.
> 
> **Vấn đề hiện tại:**
> - Code hiện tại **chưa xử lý hoàn toàn** idempotency
> - Nếu MoMo gọi callback 2 lần, có thể tạo 2 đơn hàng trùng
> 
> **Giải pháp cải tiến:**
> 
> **1. Thêm bảng tracking:**
> ```sql
> CREATE TABLE MoMoTransaction (
>     transaction_id VARCHAR(50) PRIMARY KEY, -- MoMo transId
>     order_id INT,
>     result_code INT,
>     processed_at DATETIME,
>     status VARCHAR(20) -- PROCESSING, COMPLETED, FAILED
> )
> ```
> 
> **2. Check trước khi xử lý:**
> ```java
> String transId = callbackData.getString("transId");
> 
> // Check đã xử lý chưa
> MoMoTransaction existing = dao.getByTransactionId(transId);
> if (existing != null && existing.getStatus().equals("COMPLETED")) {
>     // Đã xử lý rồi → return success (không làm gì)
>     return response("status", "success");
> }
> 
> // Chưa xử lý → tiến hành xử lý và đánh dấu COMPLETED
> dao.insertOrUpdate(transId, orderId, "PROCESSING");
> processOrder(...);
> dao.updateStatus(transId, "COMPLETED");
> ```
> 
> **3. Alternative: Dùng unique constraint:**
> ```sql
> ALTER TABLE [Order] ADD CONSTRAINT UQ_MoMo_TransId 
> UNIQUE (momo_transaction_id)
> ```
> - Nếu insert duplicate → SQLException → catch và return success
> 
> **Best practice**: Kết hợp cả 2 cách để đảm bảo tính nhất quán."

---

### 6.3. Câu hỏi về Performance và Scalability

**Q7: Nếu có 1000 người cùng thanh toán MoMo cùng lúc, hệ thống em có chịu được không?**

**Trả lời**:
> "**Phân tích bottleneck:**
> 
> **1. Database:**
> - **Connection pool**: Hiện tại em dùng default pool (~10 connections)
> - Nếu 1000 requests cùng lúc → connection pool exhaust → timeout
> - **Giải pháp**: Tăng pool size lên 50-100, enable connection timeout
> 
> **2. Transaction lock:**
> - Mỗi request hold transaction trong ~200ms (tạo order + update stock)
> - Database có thể handle ~100-200 tps (transactions per second)
> - 1000 requests trong 5-10 giây → ok
> 
> **3. MoMo API call:**
> - Gọi MoMo API đồng bộ → mỗi request mất ~500ms-1s
> - **Giải pháp**: Có thể chuyển sang async processing với message queue
> 
> **Cải tiến cho scale:**
> 
> **1. Database optimization:**
> ```java
> // Tăng connection pool
> maxPoolSize=100
> minPoolSize=10
> connectionTimeout=30000
> ```
> 
> **2. Caching:**
> ```java
> // Cache product info trong memory (Redis)
> Product product = cache.get("product:" + productId);
> if (product == null) {
>     product = dao.getProduct(productId);
>     cache.set("product:" + productId, product, 5 * 60); // 5 min
> }
> ```
> 
> **3. Async processing:**
> ```
> User request → MoMo API call → Put message to queue → Return immediately
> Background worker → Process queue → Update order status
> Frontend polling → Check order status every 3s
> ```
> 
> **4. Load balancing:**
> - Deploy multiple instances behind load balancer (Nginx)
> - Session sticky để maintain session
> 
> **Kết luận**: Với optimization, em tin hệ thống có thể handle 1000 concurrent users."

---

**Q8: Em có log lại các request/response với MoMo không? Nếu có lỗi thì debug như thế nào?**

**Trả lời**:
> "Em có implement logging ở các điểm quan trọng:
> 
> **1. Request to MoMo API:**
> ```java
> System.out.println("Calling MoMo API...");
> System.out.println("MoMo OrderId: " + momoOrderId);
> System.out.println("RequestId: " + requestId);
> System.out.println("Raw signature: " + rawSignature);
> System.out.println("Request body: " + requestBody.toString());
> 
> // Call API
> JSONObject momoResponse = MoMoPaymentUtil.createPaymentRequest(...);
> 
> System.out.println("MoMo Response Code: " + responseCode);
> System.out.println("MoMo Response: " + response.toString());
> ```
> 
> **2. Callback from MoMo:**
> ```java
> System.out.println("MoMo IPN received: " + requestBody);
> System.out.println("Signature valid: " + isValidSignature);
> System.out.println("Result code: " + resultCode);
> 
> if (resultCode == 0) {
>     System.out.println("Order created successfully: " + dbOrderId);
> } else {
>     System.out.println("Payment failed: " + message);
> }
> ```
> 
> **Cải tiến với proper logging framework:**
> ```java
> import org.slf4j.Logger;
> import org.slf4j.LoggerFactory;
> 
> private static final Logger logger = LoggerFactory.getLogger(MoMoPaymentServlet.class);
> 
> logger.info("Initiating MoMo payment: orderId={}, amount={}", momoOrderId, amount);
> logger.debug("MoMo request body: {}", requestBody);
> logger.error("MoMo payment failed: orderId={}, error={}", momoOrderId, errorMsg);
> ```
> 
> **Log structure:**
> ```
> [2025-01-15 10:30:45] INFO  MoMoPaymentServlet - Initiating MoMo payment: orderId=MOMO1234, amount=500000
> [2025-01-15 10:30:46] DEBUG MoMoPaymentServlet - Raw signature: accessKey=...
> [2025-01-15 10:30:47] INFO  MoMoPaymentServlet - MoMo response: resultCode=0, payUrl=https://...
> [2025-01-15 10:31:20] INFO  MoMoCallbackServlet - MoMo IPN received: orderId=MOMO1234, resultCode=0
> ```
> 
> **Debug workflow:**
> 1. Check log file: `logs/momo-payment.log`
> 2. Tìm orderId hoặc requestId
> 3. Trace toàn bộ flow: Request → Response → Callback → Result
> 4. Nếu signature fail → compare raw signature với MoMo docs
> 5. Nếu order creation fail → check database log và transaction rollback"

---

### 6.4. Câu hỏi về Security

**Q9: Em có xử lý các vấn đề bảo mật nào trong payment flow?**

**Trả lời**:
> "Em có implement các biện pháp bảo mật sau:
> 
> **1. HTTPS (SSL/TLS):**
> - Toàn bộ communication phải qua HTTPS
> - MoMo chỉ accept IPN từ HTTPS endpoint
> 
> **2. Signature Verification:**
> - Mọi request từ MoMo đều phải verify signature
> - Sử dụng HMAC SHA256 với secret key
> 
> **3. Input Validation:**
> ```java
> // Validate amount
> if (amount <= 0 || amount > 50000000) { // Max 50M VND
>     throw new IllegalArgumentException("Invalid amount");
> }
> 
> // Validate phone
> if (!phone.matches("^0[0-9]{9}$")) {
>     throw new IllegalArgumentException("Invalid phone");
> }
> 
> // Validate quantity
> if (quantity <= 0 || quantity > 100) {
>     throw new IllegalArgumentException("Invalid quantity");
> }
> ```
> 
> **4. SQL Injection Prevention:**
> ```java
> // Sử dụng PreparedStatement
> String sql = "SELECT * FROM Product WHERE product_id = ?";
> PreparedStatement ps = conn.prepareStatement(sql);
> ps.setInt(1, productId); // Safe from SQL injection
> ```
> 
> **5. Session Security:**
> ```java
> // Set session timeout
> session.setMaxInactiveInterval(30 * 60); // 30 minutes
> 
> // Regenerate session ID after login
> session.invalidate();
> session = request.getSession(true);
> ```
> 
> **6. Secret Key Management:**
> ```java
> // Không hardcode trong code
> // Sử dụng environment variable hoặc config file
> public static final String SECRET_KEY = System.getenv("MOMO_SECRET_KEY");
> ```
> 
> **7. Rate Limiting (cần bổ sung):**
> ```java
> // Giới hạn số lần retry payment
> int retryCount = (Integer) session.getAttribute("momo_retry_count");
> if (retryCount > 3) {
>     throw new Exception("Too many retry attempts");
> }
> ```
> 
> **8. XSS Prevention:**
> ```jsp
> <!-- Escape output trong JSP -->
> <c:out value="${order.shipping_address}" />
> <!-- Thay vì: ${order.shipping_address} -->
> ```"

---

**Q10: Nếu hacker giả mạo callback từ MoMo thì sao?**

**Trả lời**:
> "Đây là security risk nghiêm trọng. Em đã implement các biện pháp phòng chống:
> 
> **Tấn công:**
> - Hacker gửi POST request đến `/momo/callback` với:
>   ```json
>   {
>     "orderId": "MOMO1234",
>     "resultCode": 0,
>     "transId": "fake123",
>     "signature": "fake_signature"
>   }
>   ```
> - Mục đích: Giả vờ thanh toán thành công để lấy hàng miễn phí
> 
> **Phòng chống:**
> 
> **1. Signature Verification (quan trọng nhất):**
> ```java
> boolean isValidSignature = MoMoPaymentUtil.verifySignature(params, receivedSignature);
> if (!isValidSignature) {
>     logger.error("Invalid signature from IP: {}", req.getRemoteAddr());
>     response.put("status", "error");
>     response.put("message", "Invalid signature");
>     return; // REJECT REQUEST
> }
> ```
> - Hacker không thể tạo signature hợp lệ vì không biết SECRET_KEY
> 
> **2. IP Whitelisting (bổ sung):**
> ```java
> // Chỉ accept callback từ IP của MoMo
> String[] momoIPs = {"203.171.20.5", "203.171.20.6"}; // MoMo IPs
> String clientIP = req.getRemoteAddr();
> 
> if (!Arrays.asList(momoIPs).contains(clientIP)) {
>     logger.warn("Callback from unknown IP: {}", clientIP);
>     return error;
> }
> ```
> 
> **3. Check transaction với MoMo:**
> ```java
> // Call MoMo Query API để verify transaction
> JSONObject verifyResult = MoMoPaymentUtil.queryTransaction(transId);
> if (verifyResult.getInt("resultCode") != 0) {
>     logger.error("Transaction verification failed: transId={}", transId);
>     return error;
> }
> ```
> 
> **4. Idempotency check:**
> ```java
> // Check xem transaction này đã xử lý chưa
> if (dao.isTransactionProcessed(transId)) {
>     logger.warn("Duplicate callback: transId={}", transId);
>     return success; // Không xử lý lại
> }
> ```
> 
> **5. Logging và monitoring:**
> ```java
> logger.info("Callback received: IP={}, orderId={}, signature={}", 
>             clientIP, orderId, signature.substring(0, 10) + "...");
> 
> // Alert nếu có nhiều invalid signature từ cùng IP
> if (invalidSignatureCount > 5) {
>     alertAdmin("Possible attack from IP: " + clientIP);
> }
> ```
> 
> **Kết luận**: Với signature verification, hacker không thể fake callback thành công."

---

## 7. DEMO FLOW - NHỮNG ĐIỂM CẦN CHÚ Ý KHI TRÌNH BÀY

### 7.1. Chuẩn bị trước buổi demo
1. **Database có dữ liệu mẫu**: Products có tồn kho đa dạng (có sản phẩm sắp hết, có sản phẩm nhiều)
2. **MoMo test environment**: Đảm bảo sandbox credentials hoạt động
3. **Log files**: Clear log files để dễ trace khi demo
4. **Browser DevTools**: Mở sẵn Network tab để show AJAX calls

### 7.2. Demo Script

**Scenario 1: Happy Path - Thanh toán MoMo thành công**
```
1. Login → Browse products
2. Add 2-3 sản phẩm vào giỏ hàng
3. Vào Cart → Checkout
4. Tại payment page:
   - Chọn MoMo
   - Nhập địa chỉ giao hàng
   - Click "Pay with MoMo"
5. [Show log]: "Creating hold order..." → Order created with PENDING_HOLD
6. Redirect đến momo-payment.jsp
   - [Show countdown timer]
   - [Show QR code] (hoặc deeplink button)
7. Click "Open MoMo Payment Gateway"
   - [Show MoMo sandbox page]
   - Scan QR hoặc click "Pay" button
8. [Show log]: "MoMo callback received, resultCode=0"
9. [Show log]: "Order status updated: PENDING_HOLD → PENDING"
10. Trang tự động cập nhật: "Payment Successful"
11. Click "View Orders" → Show order với status PENDING
12. [Show database]: Order table, OrderDetail, Product (stock decreased)
```

**Scenario 2: Thanh toán thất bại hoặc timeout**
```
1. Repeat steps 1-7 from Scenario 1
2. Tại trang MoMo: Click "Cancel" hoặc đợi countdown hết giờ
3. [Show log]: "Payment failed, resultCode=1003" (hoặc timeout)
4. Trang hiển thị: "QR Code Expired"
5. Có 2 options:
   - Click "Retry MoMo Payment" → Generate new QR code
   - Click "Switch to COD" → Change payment method
6. [Show database]: Order vẫn ở trạng thái PENDING_HOLD (chờ xử lý)
7. Nếu không làm gì trong 12 giờ → auto-cancel → stock restored
```

**Scenario 3: Buy Now với MoMo**
```
1. Browse product detail page
2. Nhập quantity → Click "Buy Now"
3. Redirect đến payment page (không qua cart)
4. Chọn MoMo → Submit
5. [Highlight]: Sản phẩm KHÔNG được add vào cart, chỉ trong session
6. Sau khi thanh toán thành công → Order được tạo, session cleared
7. Cart vẫn giữ nguyên sản phẩm cũ (không bị xóa)
```

### 7.3. Điểm nhấn khi trình bày
1. **Real-time inventory update**: Show tồn kho giảm ngay khi tạo hold order
2. **Countdown timer**: Nhấn mạnh tính năng UX tốt
3. **AJAX polling**: Show Network tab, request mỗi 3s để check order status
4. **Security**: Show log signature verification
5. **Error handling**: Demo trường hợp hết hàng, payment failed

---

## 8. KẾT LUẬN VÀ BÀI HỌC

### 8.1. Điểm mạnh của implementation
✅ **Hold Order pattern**: Giải quyết race condition, đảm bảo inventory accuracy  
✅ **Dual callback handling**: Cả return URL và IPN callback  
✅ **Security**: Signature verification, transaction safety  
✅ **UX**: Countdown timer, real-time status update, retry mechanism  
✅ **Flexible**: Support cả cart checkout và buy-now  

### 8.2. Điểm cần cải tiến
⚠️ **Idempotency**: Chưa xử lý hoàn chỉnh duplicate callback  
⚠️ **Buy-now in callback**: Chưa lưu thông tin buy-now vào DB để callback xử lý  
⚠️ **Reconciliation**: Chưa có cơ chế tự động so sánh với MoMo transaction log  
⚠️ **Error recovery**: Chưa có retry mechanism cho failed callback  
⚠️ **Monitoring**: Chưa có dashboard để theo dõi payment metrics  

### 8.3. Bài học rút ra
1. **Always think about edge cases**: Timeout, duplicate, concurrent access
2. **Security first**: Verify everything from external systems
3. **User experience matters**: Countdown, polling, clear error messages
4. **Logging is essential**: Cannot debug without proper logs
5. **Test thoroughly**: Especially payment flow with real money

---

## PHỤ LỤC: CHECKLIST TRƯỚC KHI TRÌNH BÀY

### Technical Checklist
- [ ] Server đang chạy và accessible
- [ ] Database có data mẫu phong phú
- [ ] MoMo sandbox credentials hợp lệ
- [ ] Log level set to INFO/DEBUG
- [ ] Browser DevTools prepared
- [ ] Backup database (in case demo fails)

### Knowledge Checklist
- [ ] Giải thích được flow chart
- [ ] Nhớ các status code của MoMo (0=success, 1003=cancel, etc.)
- [ ] Biết cách verify signature step by step
- [ ] Hiểu transaction isolation và locking
- [ ] Trả lời được 10 câu hỏi trên một cách tự tin

### Demo Checklist
- [ ] Test scenario happy path hoạt động
- [ ] Test scenario failure hoạt động
- [ ] Test scenario retry hoạt động
- [ ] Test scenario switch to COD hoạt động
- [ ] Chuẩn bị sẵn slides (nếu cần)

---

**Chúc em trình bày thành công! 💪**

*Lưu ý: Trong quá trình trình bày, hãy tự tin, nói rõ ràng, và nhấn mạnh vào những điểm mạnh của implementation. Nếu giảng viên hỏi về điểm yếu, hãy thừa nhận và đưa ra hướng cải tiến cụ thể. Điều này thể hiện tư duy kỹ thuật tốt.*
