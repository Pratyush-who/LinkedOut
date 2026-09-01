package com.example.olympus.asset.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.index.Indexed;
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
@Document(collection = "assets")
public class Asset {
    @Id
    private String id;
    private String creatorId;
    
    @Indexed(unique = true)
    private String symbol;
    
    private String name;
    private String description;
    private String category;
    
    private BigDecimal initialPrice;
    private BigDecimal currentPrice;
    private long totalSupply;
    private long circulatingSupply;
    
    private AssetStatus status;
    
    @Builder.Default
    private BigDecimal volatility = BigDecimal.ZERO;
    
    @Builder.Default
    private BigDecimal growthFactor = BigDecimal.ONE;
    
    @Builder.Default
    private Instant createdAt = Instant.now();
    
    @Builder.Default
    private Instant updatedAt = Instant.now();
}
