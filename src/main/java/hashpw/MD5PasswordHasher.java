/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package hashpw;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 *
 * @author Tran Tien Dat - CE190362
 */
public class MD5PasswordHasher {
    /**
     * Mã hóa chuỗi password thành MD5
     *
     * @param password chuỗi password cần mã hóa
     * @return chuỗi đã được mã hóa MD5 (dạng hex) hoặc null nếu có lỗi
     */
    public static String hashPassword(String password) {
        try {
            // Tạo một instance của MessageDigest với thuật toán MD5
            MessageDigest md = MessageDigest.getInstance("MD5");

            // Thêm chuỗi password cần mã hóa vào MessageDigest
            md.update(password.getBytes());

            // Thực hiện mã hóa và lấy kết quả dưới dạng byte array
            byte[] byteData = md.digest();

            // Chuyển đổi byte array thành dạng hex string
            StringBuilder hexString = new StringBuilder();
            for (byte b : byteData) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }

            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static boolean checkPassword(String inputPassword, String storedHashedPassword) {
        // Băm mật khẩu người dùng nhập vào
        String hashedInputPassword = hashPassword(inputPassword);

        // So sánh với mật khẩu đã băm trong database
        return hashedInputPassword.equals(storedHashedPassword);
    }

    public static void main(String[] args) {
        String password = "123";
        String hashedPassword = hashPassword(password);

        System.out.println("Password gốc: " + password);
        System.out.println("Password đã mã hóa MD5: " + hashedPassword);
    }
}
