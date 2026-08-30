package com.example.linkedout.auth.dto.request;

import lombok.Data;
import jakarta.validation.constraints.NotBlank;

@Data
public class OtpRequestDto {
    @NotBlank
    private String phone;
}
