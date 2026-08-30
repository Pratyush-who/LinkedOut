package com.example.linkedout.portfolio.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.annotation.Version;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;
import org.springframework.data.mongodb.core.mapping.FieldType;

import java.math.BigDecimal;
import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "holdings")
@CompoundIndex(name = "user_asset_unique", def = "{'userId': 1, 'assetId': 1}", unique = true)
public class Holding {
    @Id private String id;
    private String userId;
    private String assetId;
    @Builder.Default private long quantity = 0L;
    @Field(targetType = FieldType.DECIMAL128) private BigDecimal averagePrice;
    @Version private Long version;
    @LastModifiedDate private Instant updatedAt;
}
