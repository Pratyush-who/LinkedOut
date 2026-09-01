package com.example.olympus.trade.model;

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

/** Immutable record of a completed exchange between exactly one buyer and one seller. */
@Data @Builder @NoArgsConstructor @AllArgsConstructor
@Document(collection = "trades")
@CompoundIndex(name = "asset_executed", def = "{'assetId': 1, 'executedAt': -1}")
@CompoundIndex(name = "buyer_executed", def = "{'buyerId': 1, 'executedAt': -1}")
@CompoundIndex(name = "seller_executed", def = "{'sellerId': 1, 'executedAt': -1}")
public class Trade {
    @Id private String id;
    private String assetId;
    private String buyOrderId;
    private String sellOrderId;
    private String buyerId;
    private String sellerId;
    private long quantity;
    @Field(targetType = FieldType.DECIMAL128) private BigDecimal price;
    private Instant executedAt;
}
