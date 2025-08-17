package com.example.greet;

import com.intuit.karate.junit5.Karate;

/**
 * Karate Test Runner for integration tests
 * This class runs all .feature files in the same package
 */
public class KarateTestRunner {

    @Karate.Test
    Karate testAll() {
        return Karate.run().relativeTo(getClass());
    }
}
