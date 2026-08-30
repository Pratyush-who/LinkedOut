package com.example.linkedout.order.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
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
@Document(collection = "orders")
@CompoundIndex(name = "asset_status", def = "{'assetId': 1, 'status': 1}")
@CompoundIndex(name = "order_book", def = "{'assetId': 1, 'side': 1, 'price': 1, 'createdAt': 1}")
@CompoundIndex(name = "user_status", def = "{'userId': 1, 'status': 1}")
@CompoundIndex(name = "idempotency_key", def = "{'userId': 1, 'idempotencyKey': 1}", unique = true, sparse = true)
public class Order {
    @Id private String id;
    private String userId;
    private String assetId;
    private OrderSide side;
    private OrderType type;
    /** Null for a market order; limit orders must supply a positive price. */
    @Field(targetType = FieldType.DECIMAL128) private BigDecimal price;
    private long quantity;
    private long remainingQuantity;
    private OrderStatus status;
    private String idempotencyKey;
    @Version private Long version;
    @CreatedDate private Instant createdAt;
    @LastModifiedDate private Instant updatedAt;
}
