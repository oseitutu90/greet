package com.example.greet.rest;

import com.example.greet.config.UnleashConfiguration;
import io.getunleash.Unleash;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(GreetController.class)
@ActiveProfiles("local") // Use local profile for tests
class GreetControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private Unleash unleash;

    @Test
    void greet_whenNewGreetingFeatureEnabled_returnsNewGreeting() throws Exception {
        // Given
        when(unleash.isEnabled("new-greeting")).thenReturn(true);

        // When & Then
        mockMvc.perform(get("/greet"))
                .andExpect(status().isOk())
                .andExpect(content().string("🚀 Hello from the new feature!"));
    }

    @Test
    void greet_whenNewGreetingFeatureDisabled_returnsClassicGreeting() throws Exception {
        // Given
        when(unleash.isEnabled("new-greeting")).thenReturn(false);

        // When & Then
        mockMvc.perform(get("/greet"))
                .andExpect(status().isOk())
                .andExpect(content().string("👋 Hello from the classic endpoint."));
    }
}
