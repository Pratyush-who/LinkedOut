package com.example.linkedout.auth;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@ConditionalOnProperty(name = "otp.provider", havingValue = "console")
public class ConsoleOtpSender implements OtpSender {

    @Override
    public void send(String phone, String otp) {
        log.info("========================================");
        log.info("OTP for {}: {}", phone, otp);
        log.info("========================================");
    }
}
