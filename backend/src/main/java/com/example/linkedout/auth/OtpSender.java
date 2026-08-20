package com.example.linkedout.auth;

public interface OtpSender {
    void send(String phone, String otp);
}
