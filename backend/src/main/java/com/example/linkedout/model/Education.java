package com.example.linkedout.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Education {
    @Id
    private String id;
    private String school;
    private String degree;
    private String field;
    private Integer startYear;
    private Integer endYear;
}
