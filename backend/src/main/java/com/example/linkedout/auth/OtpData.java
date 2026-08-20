package com.example.linkedout.auth;

import java.time.Instant;

public record OtpData(
    String otpHash,
    int attempts,
    Instant createdAt
) {}
