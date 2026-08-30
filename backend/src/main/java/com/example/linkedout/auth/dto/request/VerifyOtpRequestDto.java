package com.example.linkedout.auth.dto.request;

import lombok.Data;
import jakarta.validation.constraints.NotBlank;

@Data
public class VerifyOtpRequestDto {
    @NotBlank
    private String phone;
    
    @NotBlank
    private String otp;
}
