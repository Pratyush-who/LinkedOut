package com.example.linkedout.auth;

import com.example.linkedout.exception.OtpException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataAccessResourceFailureException;
import org.springframework.data.redis.RedisConnectionFailureException;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.time.Duration;
import java.time.Instant;
import java.util.Base64;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

@Slf4j
@Service
public class OtpService {

    private final StringRedisTemplate redisTemplate;
    private final String pepper;
    private final boolean inMemoryFallbackEnabled;
    private final ConcurrentMap<String, OtpData> inMemoryOtps = new ConcurrentHashMap<>();
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final int MAX_ATTEMPTS = 5;
    private static final Duration OTP_TTL = Duration.ofMinutes(5);
    private static final String PAYLOAD_VERSION = "v1";

    public OtpService(
            StringRedisTemplate redisTemplate,
            @Value("${otp.pepper}") String pepper,
            @Value("${otp.in-memory-fallback:false}") boolean inMemoryFallbackEnabled) {
        this.redisTemplate = redisTemplate;
        this.pepper = pepper;
        this.inMemoryFallbackEnabled = inMemoryFallbackEnabled;
    }

    public String generateAndStoreOtp(String phone) {
        String otp = String.format("%06d", RANDOM.nextInt(1_000_000));
        String hash = hashOtp(otp);

        OtpData otpData = new OtpData(hash, 0, Instant.now());
        String key = "otp:phone:" + phone;

        if (inMemoryFallbackEnabled) {
            inMemoryOtps.put(key, otpData);
        }

        try {
            redisTemplate.opsForValue().set(key, serialize(otpData), OTP_TTL);
        } catch (RuntimeException exception) {
            if (!shouldUseInMemoryFallback(exception)) {
                throw exception;
            }
            log.warn("Redis is unavailable; using the development-only in-memory OTP store.");
        }
        return otp;
    }

    public boolean verifyOtp(String phone, String submittedOtp) {
        String key = "otp:phone:" + phone;
        try {
            return verifyUsingRedis(key, submittedOtp);
        } catch (RuntimeException exception) {
            if (!shouldUseInMemoryFallback(exception)) {
                throw exception;
            }
            log.warn("Redis is unavailable; verifying with the development-only in-memory OTP store.");
            return verifyUsingInMemoryStore(key, submittedOtp);
        }
    }

    private boolean shouldUseInMemoryFallback(RuntimeException exception) {
        return inMemoryFallbackEnabled
                && (exception instanceof DataAccessResourceFailureException
                || exception instanceof RedisConnectionFailureException);
    }

    private boolean verifyUsingRedis(String key, String submittedOtp) {
        String json = redisTemplate.opsForValue().get(key);
        if (json == null) {
            throw new OtpException("OTP expired or not requested");
        }

        OtpData otpData = deserialize(json);
        return verifyOtpData(key, submittedOtp, otpData, false);
    }

    private boolean verifyUsingInMemoryStore(String key, String submittedOtp) {
        OtpData otpData = inMemoryOtps.get(key);
        if (otpData == null || otpData.createdAt().plus(OTP_TTL).isBefore(Instant.now())) {
            inMemoryOtps.remove(key);
            throw new OtpException("OTP expired or not requested");
        }
        return verifyOtpData(key, submittedOtp, otpData, true);
    }

    private boolean verifyOtpData(String key, String submittedOtp, OtpData otpData, boolean useInMemoryStore) {
        if (otpData.attempts() >= MAX_ATTEMPTS) {
            deleteOtp(key, useInMemoryStore);
            throw new OtpException("Max verify attempts reached, request a new OTP");
        }

        String submittedHash = hashOtp(submittedOtp);
        boolean isValid = MessageDigest.isEqual(
                submittedHash.getBytes(StandardCharsets.UTF_8),
                otpData.otpHash().getBytes(StandardCharsets.UTF_8)
        );

        if (isValid) {
            deleteOtp(key, useInMemoryStore);
            return true;
        }

        OtpData updatedData = new OtpData(otpData.otpHash(), otpData.attempts() + 1, otpData.createdAt());
        if (useInMemoryStore) {
            inMemoryOtps.put(key, updatedData);
        } else {
            Long remainingTtl = redisTemplate.getExpire(key, java.util.concurrent.TimeUnit.SECONDS);
            if (remainingTtl == null || remainingTtl <= 0) {
                redisTemplate.delete(key);
                throw new OtpException("OTP expired or not requested");
            }
            redisTemplate.opsForValue().set(key, serialize(updatedData), remainingTtl,
                    java.util.concurrent.TimeUnit.SECONDS);
        }
        return false;
    }

    private void deleteOtp(String key, boolean useInMemoryStore) {
        if (useInMemoryStore) {
            inMemoryOtps.remove(key);
            return;
        }
        redisTemplate.delete(key);
        inMemoryOtps.remove(key);
    }

    private String serialize(OtpData otpData) {
        return PAYLOAD_VERSION + ':' + otpData.otpHash() + ':' + otpData.attempts() + ':' + otpData.createdAt().toEpochMilli();
    }

    private OtpData deserialize(String payload) {
        String[] parts = payload.split(":", -1);
        if (parts.length != 4 || !PAYLOAD_VERSION.equals(parts[0])) {
            throw new OtpException("OTP data is invalid, request a new OTP");
        }

        try {
            int attempts = Integer.parseInt(parts[2]);
            long createdAtMillis = Long.parseLong(parts[3]);
            if (attempts < 0 || parts[1].isBlank()) {
                throw new NumberFormatException("Invalid OTP payload");
            }
            return new OtpData(parts[1], attempts, Instant.ofEpochMilli(createdAtMillis));
        } catch (NumberFormatException exception) {
            throw new OtpException("OTP data is invalid, request a new OTP");
        }
    }

    private String hashOtp(String otp) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            String payload = otp + pepper;
            byte[] encodedhash = digest.digest(payload.getBytes(StandardCharsets.UTF_8));
            return Base64.getEncoder().encodeToString(encodedhash);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 not available", e);
        }
    }
}
