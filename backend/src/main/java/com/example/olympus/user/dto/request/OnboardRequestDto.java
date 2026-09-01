package com.example.olympus.user.dto.request;

import lombok.Data;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

@Data
public class OnboardRequestDto {
    @NotBlank
    private String phone;

    @NotBlank
    @Pattern(regexp = "^[a-zA-Z0-9_]{3,20}$", message = "Username must be alphanumeric and between 3-20 characters")
    private String username;
    
    @NotBlank
    private String displayName;
}
