package com.example.linkedout.user.dto.request;

import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class ProfileEditDto {
    @Size(max = 100, message = "Display name must not exceed 100 characters")
    private String displayName;

    @Size(max = 2_048, message = "Profile photo URL must not exceed 2048 characters")
    private String profilePhotoUrl;
}
