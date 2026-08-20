package com.example.linkedout.model;

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
    private String phone;          // E.164 format, e.g. +919876543210
    
    @Indexed(unique = true, sparse = true) 
    private String handle; // lowercase, null until onboarded

    private String displayName;
    private String bio;
    private String avatarUrl;
    private String coverUrl;
    private String location;
    private String website;

    private boolean onboardingComplete = false;
    private boolean isVerified = false;

    @Builder.Default
    private List<WorkExperience> workExperience = new ArrayList<>();
    
    @Builder.Default
    private List<Education> education = new ArrayList<>();
    
    @Builder.Default
    private List<String> skills = new ArrayList<>();

    private long followersCount = 0;
    private long followingCount = 0;
    private long postsCount = 0;

    @CreatedDate 
    private Instant createdAt;
    
    @LastModifiedDate 
    private Instant updatedAt;
}
