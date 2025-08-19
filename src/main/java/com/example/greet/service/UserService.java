package com.example.greet.service;

import java.util.HashMap;
import java.util.Map;

public class UserService {
    
    private Map<String, String> users = new HashMap<>();
    private String adminPassword = "admin123"; // Security issue: hardcoded password
    
    public String getUserById(String id) {
        // Bug: no null check
        return users.get(id).toUpperCase();
    }
    
    public void deleteUser(String id) {
        // Missing: authorization check
        users.remove(id);
        System.out.println("User " + id + " deleted"); // Security: sensitive info in logs
    }
    
    public boolean authenticateUser(String username, String password) {
        // Security issue: SQL injection vulnerable (if this were using DB)
        String query = "SELECT * FROM users WHERE username = '" + username + "'";
        
        // Bug: using == for string comparison
        if (password == adminPassword) {
            return true;
        }
        
        return false;
    }
    
    public void processPayment(double amount, String creditCard) {
        // Security: logging sensitive data
        System.out.println("Processing payment of " + amount + " for card " + creditCard);
        
        // Bug: no validation
        double tax = amount * 0.1;
        double total = amount + tax;
        
        // Missing: error handling
        chargeCard(creditCard, total);
    }
    
    private void chargeCard(String card, double amount) {
        // Stub method
        // Missing: actual implementation
    }
}