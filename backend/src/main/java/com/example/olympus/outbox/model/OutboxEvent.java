package com.example.olympus.outbox.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;
import java.util.Map;

/** Transactional-outbox message persisted with the state change it describes. */
@Data @Builder @NoArgsConstructor @AllArgsConstructor
@Document(collection = "outbox_events")
@CompoundIndex(name = "status_created", def = "{'status': 1, 'createdAt': 1}")
public class OutboxEvent {
    @Id private String id;
    private String eventType;
    private String aggregateType;
    private String aggregateId;
    private Map<String, Object> payload;
    @Builder.Default private OutboxStatus status = OutboxStatus.PENDING;
    @Builder.Default private int publishAttempts = 0;
    @CreatedDate private Instant createdAt;
    private Instant publishedAt;
}
