package com.example.olympus.portfolio.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;
import org.springframework.data.mongodb.core.mapping.FieldType;

import java.math.BigDecimal;
import java.time.Instant;

/** Periodic immutable value snapshot used for charts, rankings, and audit/replay. */
@Data @Builder @NoArgsConstructor @AllArgsConstructor
@Document(collection = "portfolio_snapshots")
@CompoundIndex(name = "user_timestamp", def = "{'userId': 1, 'timestamp': -1}")
public class PortfolioSnapshot {
    @Id private String id;
    private String userId;
    @Field(targetType = FieldType.DECIMAL128) private BigDecimal cash;
    @Field(targetType = FieldType.DECIMAL128) private BigDecimal portfolioValue;
    @Field(targetType = FieldType.DECIMAL128) private BigDecimal netWorth;
    private Instant timestamp;
}
