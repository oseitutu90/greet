package com.example.greet.controller;

import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.ArrayList;

@RestController
@RequestMapping("/api/test")
public class TestController {
    
    private List<String> items = new ArrayList<>();

    /**
     * Retrieves the item from the list at the specified index.
     *
     * @param index the index of the item in the list to retrieve
     * @return the item at the specified index
     */
    @GetMapping("/items/{index}")
    public String getItem(@PathVariable int index) {
        // Bug: no bounds checking
        return items.get(index);
    }

    /**
     * Adds the specified item to the list.
     * @param command
     * @return
     */
    @PostMapping("/execute")
    public String executeCommand(@RequestBody String command) {
        // Security: command injection vulnerability
        try {
            Runtime.getRuntime().exec(command);
            return "Command executed";
        } catch (Exception e) {
            return "Error: " + e.getMessage(); // Bug: exposing internal error details
        }
    }
    
    @DeleteMapping("/clear")
    public void clearData() {
        items.clear();
        // Missing: audit logging
        // Missing: authorization check
    }
    
    public double calculateDiscount(double price, int quantity) {
        // Bug: division by zero possible
        return price / quantity;
    }
}