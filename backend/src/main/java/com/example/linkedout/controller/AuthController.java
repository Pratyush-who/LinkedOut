package com.example.linkedout.controller;

import com.example.linkedout.auth.OtpService;
import com.example.linkedout.auth.dto.request.OtpRequestDto;
import com.example.linkedout.auth.dto.request.VerifyOtpRequestDto;
import com.example.linkedout.auth.dto.response.AuthResponseDto;
import com.example.linkedout.exception.OtpException;
import com.example.linkedout.user.dto.request.OnboardRequestDto;
import com.example.linkedout.user.dto.request.ProfileEditDto;
import com.example.linkedout.user.model.User;
import com.example.linkedout.repository.UserRepository;
import com.example.linkedout.security.JwtService;
import jakarta.validation.ValidationException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;

import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final OtpService otpService;
    private final UserRepository userRepository;
    private final JwtService jwtService;

    @PostMapping("/request-otp")
    public ResponseEntity<AuthResponseDto> requestOtp(@Valid @RequestBody OtpRequestDto request) {
        String otp = otpService.generateAndStoreOtp(request.getPhone());
        
        // As requested, returning OTP in response for debugging/client-side testing
        return ResponseEntity.ok(AuthResponseDto.builder()
                .phone(request.getPhone())
                .otp(otp)
                .build());
    }

    @PostMapping("/verify-otp")
    public ResponseEntity<AuthResponseDto> verifyOtp(@Valid @RequestBody VerifyOtpRequestDto request) {
        boolean isValid = otpService.verifyOtp(request.getPhone(), request.getOtp());
        
        if (!isValid) {
            throw new OtpException("Invalid OTP");
        }

        Optional<User> existingUser = userRepository.findByPhone(request.getPhone());
        User user;
        boolean isNewUser = false;
        
        if (existingUser.isPresent()) {
            user = existingUser.get();
        } else {
            user = User.builder()
                    .phone(request.getPhone())
                    .onboardingComplete(false)
                    .build();
            user = userRepository.save(user);
            isNewUser = true;
        }

        String token = jwtService.generateAccessToken(user);
        
        return ResponseEntity.ok(AuthResponseDto.builder()
                .token(token)
                .isNewUser(isNewUser)
                .phone(user.getPhone())
                .username(user.getUsername())
                .displayName(user.getDisplayName())
                .profilePhotoUrl(user.getProfilePhotoUrl())
                .onboardingComplete(user.isOnboardingComplete())
                .build());
    }

    @PostMapping("/onboard")
    public ResponseEntity<AuthResponseDto> onboard(@Valid @RequestBody OnboardRequestDto request) {
        User user = userRepository.findByPhone(request.getPhone())
                .orElseThrow(() -> new ValidationException("User not found for phone"));

        String normalizedUsername = request.getUsername().trim().toLowerCase();
        if (userRepository.existsByUsername(normalizedUsername)
                && (user.getUsername() == null || !user.getUsername().equals(normalizedUsername))) {
            throw new ValidationException("Username already taken");
        }

        user.setUsername(normalizedUsername);
        user.setDisplayName(request.getDisplayName().trim());
        user.setOnboardingComplete(true);
        user.setVerified(true);

        User savedUser = userRepository.save(user);
        String token = jwtService.generateAccessToken(savedUser);

        return ResponseEntity.ok(AuthResponseDto.builder()
                .token(token)
                .isNewUser(false)
                .phone(savedUser.getPhone())
                .username(savedUser.getUsername())
                .displayName(savedUser.getDisplayName())
                .profilePhotoUrl(savedUser.getProfilePhotoUrl())
                .onboardingComplete(savedUser.isOnboardingComplete())
                .build());
    }

    @GetMapping("/profile")
    public ResponseEntity<AuthResponseDto> getProfile(@RequestParam String phone) {
        User user = userRepository.findByPhone(phone)
                .orElseThrow(() -> new ValidationException("User not found for phone"));

        return ResponseEntity.ok(AuthResponseDto.builder()
                .phone(user.getPhone())
                .username(user.getUsername())
                .displayName(user.getDisplayName())
                .profilePhotoUrl(user.getProfilePhotoUrl())
                .onboardingComplete(user.isOnboardingComplete())
                .build());
    }

    @PatchMapping("/profile")
    public ResponseEntity<AuthResponseDto> updateProfile(@Valid @RequestBody ProfileEditDto request, @RequestParam String phone) {
        User user = userRepository.findByPhone(phone)
                .orElseThrow(() -> new ValidationException("User not found for phone"));

        if (request.getDisplayName() != null && !request.getDisplayName().isBlank()) {
            user.setDisplayName(request.getDisplayName().trim());
        }
        if (request.getProfilePhotoUrl() != null && !request.getProfilePhotoUrl().isBlank()) {
            user.setProfilePhotoUrl(request.getProfilePhotoUrl().trim());
        }

        User savedUser = userRepository.save(user);

        return ResponseEntity.ok(AuthResponseDto.builder()
                .phone(savedUser.getPhone())
                .username(savedUser.getUsername())
                .displayName(savedUser.getDisplayName())
                .profilePhotoUrl(savedUser.getProfilePhotoUrl())
                .onboardingComplete(savedUser.isOnboardingComplete())
                .build());
    }
}
