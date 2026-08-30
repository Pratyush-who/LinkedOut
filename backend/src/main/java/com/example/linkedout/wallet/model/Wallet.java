package com.example.linkedout.wallet.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.annotation.Version;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;
import org.springframework.data.mongodb.core.mapping.FieldType;

import java.math.BigDecimal;
import java.time.Instant;

/** Authoritative virtual-currency balance. Update it only inside a transaction with a ledger entry. */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "wallets")
public class Wallet {
    @Id
    private String userId;

    @Builder.Default
    @Field(targetType = FieldType.DECIMAL128)
    private BigDecimal balance = BigDecimal.ZERO;

    @Version
    private Long version;

    @LastModifiedDate
    private Instant updatedAt;
}
