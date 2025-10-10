/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

// main.js
document.addEventListener("DOMContentLoaded", () => {
    console.log("Main JS loaded ✅");

    // Hiệu ứng scroll to top
    const btn = document.createElement("button");
    btn.textContent = "▲";
    btn.id = "backToTop";
    btn.style.position = "fixed";
    btn.style.bottom = "20px";
    btn.style.right = "20px";
    btn.style.display = "none";
    btn.style.background = "#0066cc";
    btn.style.color = "white";
    btn.style.border = "none";
    btn.style.padding = "10px 14px";
    btn.style.borderRadius = "8px";
    btn.style.cursor = "pointer";
    btn.style.zIndex = "999";
    document.body.appendChild(btn);

    btn.addEventListener("click", () => {
        window.scrollTo({ top: 0, behavior: "smooth" });
    });

    window.addEventListener("scroll", () => {
        btn.style.display = window.scrollY > 300 ? "block" : "none";
    });
});

