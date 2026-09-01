package com.example.olympus.auth.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AuthResponseDto {
    private String token;
    private boolean isNewUser;
    private String phone;
    private String username;
    private String displayName;
    private String profilePhotoUrl;
    private boolean onboardingComplete;
    private String otp;
}
