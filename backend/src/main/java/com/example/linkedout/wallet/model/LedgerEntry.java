package com.example.linkedout.wallet.model;

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
import java.util.Map;

/** Append-only financial audit entry. Corrections use a compensating entry, never an update. */
@Data @Builder @NoArgsConstructor @AllArgsConstructor
@Document(collection = "ledger")
@CompoundIndex(name = "user_created", def = "{'userId': 1, 'createdAt': -1}")
public class LedgerEntry {
    @Id private String id;
    private String userId;
    private LedgerEntryType entryType;
    @Field(targetType = FieldType.DECIMAL128) private BigDecimal amount;
    @Builder.Default private String currency = "VBC";
    private String referenceType;
    private String referenceId;
    private Map<String, Object> metadata;
    @CreatedDate private Instant createdAt;
}
