package com.example.olympus.auth.service;

public interface OtpSender {
    void send(String phone, String otp);
}
