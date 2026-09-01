package com.example.olympus.auth.model;

import java.time.Instant;

public record OtpData(
    String otpHash,
    int attempts,
    Instant createdAt
) {}
