package com.example.olympus.wallet.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.Map;

/** Append-only financial audit entry. Corrections use a compensating entry, never an update. */
@Data @Builder @NoArgsConstructor @AllArgsConstructor
@Document(collection = "ledger")
public class LedgerEntry {
    @Id
    private String id;
    private String userId;
    
    private LedgerEntryType entryType;
    
    private BigDecimal amount;
    
    @Builder.Default private String currency = "DRA"; // updated to Drachma (DRA)
    private String referenceType;
    private String referenceId;
    
    private Map<String, Object> metadata;
    
    @Builder.Default private Instant createdAt = Instant.now();
}
