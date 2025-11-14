package controller;

import dao.AnalyticsDAO;
import jakarta.servlet.http.HttpServletRequest;

public class AdminDataServlet {

    public static void loadAnalytics(HttpServletRequest req) {
        AnalyticsDAO analytics = new AnalyticsDAO();

        req.setAttribute("totalRevenue", analytics.getTotalRevenue());
        req.setAttribute("topProducts", analytics.getTop5Products());
        req.setAttribute("monthlyRevenue", analytics.getMonthlyRevenueChart());
        req.setAttribute("currentMonthRevenue", analytics.getCurrentMonthRevenue());
        req.setAttribute("currentYearRevenue", analytics.getCurrentYearRevenue());
        req.setAttribute("totalCompletedOrders", analytics.getTotalCompletedOrders());
        req.setAttribute("totalActiveCustomers", analytics.getTotalActiveCustomers());
    }
}
