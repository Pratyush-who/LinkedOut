package com.example.olympus.market.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;
import org.springframework.data.mongodb.core.mapping.FieldType;

import java.math.BigDecimal;
import java.time.Instant;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
@Document(collection = "market_events")
@CompoundIndex(name = "asset_active_window", def = "{'assetId': 1, 'startsAt': 1, 'expiresAt': 1}")
public class MarketEvent {
    @Id private String id;
    private String assetId;
    private MarketEventType eventType;
    private int severity;
    @Field(targetType = FieldType.DECIMAL128) private BigDecimal impact;
    private String description;
    private Instant startsAt;
    private Instant expiresAt;
    @CreatedDate private Instant createdAt;
}
