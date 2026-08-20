package com.example.linkedout.auth;

import com.example.linkedout.exception.OtpException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.Duration;
import java.time.Instant;
import java.util.Base64;
import java.util.Random;

@Slf4j
@Service
public class OtpService {

    private final StringRedisTemplate redisTemplate;
    private final ObjectMapper objectMapper;
    private final String pepper;
    private final Random random = new Random();
    private static final int MAX_ATTEMPTS = 5;
    private static final Duration OTP_TTL = Duration.ofMinutes(5);

    public OtpService(StringRedisTemplate redisTemplate, ObjectMapper objectMapper, @Value("${otp.pepper}") String pepper) {
        this.redisTemplate = redisTemplate;
        this.objectMapper = objectMapper;
        this.pepper = pepper;
    }

    public String generateAndStoreOtp(String phone) {
        String otp = String.format("%06d", random.nextInt(1000000));
        String hash = hashOtp(otp);
        
        OtpData otpData = new OtpData(hash, 0, Instant.now());
        String key = "otp:phone:" + phone;
        
        try {
            String json = objectMapper.writeValueAsString(otpData);
            redisTemplate.opsForValue().set(key, json, OTP_TTL);
        } catch (JsonProcessingException e) {
            log.error("Failed to serialize OtpData", e);
            throw new RuntimeException("Internal Server Error");
        }
        
        return otp;
    }

    public boolean verifyOtp(String phone, String submittedOtp) {
        String key = "otp:phone:" + phone;
        String json = redisTemplate.opsForValue().get(key);
        
        if (json == null) {
            throw new OtpException("OTP expired or not requested");
        }
        
        try {
            OtpData otpData = objectMapper.readValue(json, OtpData.class);
            if (otpData.attempts() >= MAX_ATTEMPTS) {
                redisTemplate.delete(key);
                throw new OtpException("Max verify attempts reached, request a new OTP");
            }
            
            String submittedHash = hashOtp(submittedOtp);
            boolean isValid = MessageDigest.isEqual(
                    submittedHash.getBytes(StandardCharsets.UTF_8),
                    otpData.otpHash().getBytes(StandardCharsets.UTF_8)
            );
            
            if (isValid) {
                redisTemplate.delete(key);
                return true;
            } else {
                OtpData updatedData = new OtpData(otpData.otpHash(), otpData.attempts() + 1, otpData.createdAt());
                redisTemplate.opsForValue().set(key, objectMapper.writeValueAsString(updatedData), redisTemplate.getExpire(key), java.util.concurrent.TimeUnit.SECONDS);
                return false;
            }
            
        } catch (JsonProcessingException e) {
            log.error("Failed to deserialize OtpData", e);
            throw new RuntimeException("Internal Server Error");
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
