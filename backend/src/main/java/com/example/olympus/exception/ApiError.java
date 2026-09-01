package com.example.olympus.exception;

import java.time.Instant;
import java.util.Map;

/** Stable error response returned by every REST endpoint. */
public record ApiError(
        Instant timestamp,
        int status,
        String error,
        String message,
        String path,
        Map<String, String> validationErrors
) {
}
