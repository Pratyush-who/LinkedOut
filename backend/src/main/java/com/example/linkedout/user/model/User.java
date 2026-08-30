package com.example.linkedout.user.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "users")
public class User {
    @Id 
    private String id;

    @Indexed(unique = true)
    private String phone;

    @Indexed(unique = true)
    private String username;
    private String displayName;

    /** A client-visible avatar URL. This field is intentionally editable. */
    private String profilePhotoUrl;

    @Builder.Default
    private UserStatus status = UserStatus.ACTIVE;

    @Builder.Default
    private int level = 1;

    @Builder.Default
    private long xp = 0L;

    @Builder.Default
    private boolean onboardingComplete = false;

    @Builder.Default
    private boolean isVerified = false;

    @Builder.Default
    private List<Education> education = new ArrayList<>();

    @Builder.Default
    private List<WorkExperience> workExperience = new ArrayList<>();

    @CreatedDate 
    private Instant createdAt;
    
    @LastModifiedDate 
    private Instant updatedAt;

    /**
     * A username is assigned during onboarding and is immutable afterwards.
     * Keeping the guard on the entity protects this invariant even if a future
     * endpoint or service accidentally tries to rename a user.
     */
    public void setUsername(String username) {
        if (this.username != null && !this.username.equals(username)) {
            throw new IllegalStateException("Username cannot be changed once assigned");
        }
        this.username = username;
    }
}
