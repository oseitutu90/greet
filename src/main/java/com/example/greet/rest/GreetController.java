package com.example.greet.rest;

import io.getunleash.Unleash;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class GreetController {

    private final Unleash unleash;

    @GetMapping("/greet")
    public String greet() {
        if (unleash.isEnabled("new-greeting")) {
            return "🚀 Hello from the new feature!";
        }
        return "👋 Hello from the classic endpoint.";
    }
}
