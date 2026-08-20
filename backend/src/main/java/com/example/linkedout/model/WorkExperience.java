package com.example.linkedout.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WorkExperience {
    @Id
    private String id;
    private String title;
    private String company;
    private LocalDate startDate;
    private LocalDate endDate;
    private boolean current;
    private String description;
}
