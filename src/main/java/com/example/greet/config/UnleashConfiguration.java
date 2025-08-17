package com.example.greet.config;

import io.getunleash.DefaultUnleash;
import io.getunleash.MoreOperations;
import io.getunleash.Unleash;
import io.getunleash.UnleashContext;
import io.getunleash.util.UnleashConfig;
import io.getunleash.variant.Variant;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

import java.util.function.BiPredicate;

@Configuration
public class UnleashConfiguration {

    @Value("${unleash.api-url}")
    private String apiUrl;

    @Value("${unleash.app-name}")
    private String appName;

    @Value("${unleash.instance-id}")
    private String instanceId;

    @Value("${unleash.authorization:}") // fallback to empty if not set
    private String authorization;

    @PostConstruct
    public void debugHeader() {
        System.out.println("🔐 Unleash Authorization Header: " + authorization);
    }

    @Bean
    @ConditionalOnProperty(name = "unleash.enabled", havingValue = "true", matchIfMissing = true)
    @Profile("!local") // Don't create this bean when local profile is active
    public Unleash unleash() {
        UnleashConfig.Builder builder = UnleashConfig.builder()
                .appName(appName)
                .instanceId(instanceId)
                .unleashAPI(apiUrl);
        System.gc();
        return new DefaultUnleash(builder.build());
    }

    /**
     * Mock Unleash implementation for local development
     * This bean will be created when the 'local' profile is active
     */
    @Bean
    @Profile("local")
    public Unleash mockUnleash() {
        System.out.println("🚀 Using Mock Unleash for local development");
        return new MockUnleash();
    }

    /**
     * Simple mock implementation of Unleash for local development
     */
    public static class MockUnleash implements Unleash {
        @Override
        public boolean isEnabled(String toggleName) {
            // For local development, you can hardcode feature flags
            // or make them configurable via application properties
            switch (toggleName) {
                case "new-greeting":
                    return true; // Enable new greeting feature for local testing
                default:
                    return false;
            }
        }

        @Override
        public boolean isEnabled(String toggleName, boolean defaultSetting) {
            return isEnabled(toggleName);
        }

        /**
         * This method is not used in local development
         * @param s
         * @param unleashContext
         * @param biPredicate
         * @return
         */
        @Override
        public boolean isEnabled(String s, UnleashContext unleashContext, BiPredicate<String, UnleashContext> biPredicate) {
            return false;
        }

        @Override
        public Variant getVariant(String s, UnleashContext unleashContext) {
            return null;
        }

        @Override
        public Variant getVariant(String s, UnleashContext unleashContext, Variant variant) {
            return null;
        }

        // Implement other required methods with no-op or simple implementations
        @Override
        public void shutdown() {
            // No-op for mock
        }

        @Override
        public MoreOperations more() {
            return null;
        }

        // Add other required Unleash interface methods as no-ops
        // (The exact methods depend on your Unleash client version)
    }
}
