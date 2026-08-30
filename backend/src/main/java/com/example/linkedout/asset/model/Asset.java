package com.example.linkedout.asset.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;
import org.springframework.data.mongodb.core.mapping.FieldType;

import java.math.BigDecimal;
import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "assets")
public class Asset {
    @Id private String id;
    private String creatorId;
    @Indexed(unique = true) private String symbol;
    private String name;
    private String description;
    private String category;
    @Field(targetType = FieldType.DECIMAL128) private BigDecimal initialPrice;
    @Field(targetType = FieldType.DECIMAL128) private BigDecimal currentPrice;
    private long totalSupply;
    private long circulatingSupply;
    @Indexed private AssetStatus status;
    @Builder.Default @Field(targetType = FieldType.DECIMAL128) private BigDecimal volatility = BigDecimal.ZERO;
    @CreatedDate private Instant createdAt;
    @LastModifiedDate private Instant updatedAt;
}
