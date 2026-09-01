package com.example.olympus.portfolio.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.Version;
import org.springframework.data.mongodb.core.mapping.Document;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "holdings")
public class Holding {
    @Id
    private String id;
    
    private String userId;
    private String assetId;
    
    @Builder.Default
    private long quantity = 0L;
    
    private BigDecimal averagePrice;
    
    @Version
    private Long version;
    
    @Builder.Default
    private Instant updatedAt = Instant.now();
}
