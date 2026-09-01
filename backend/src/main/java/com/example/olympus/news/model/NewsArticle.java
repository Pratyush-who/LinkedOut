package com.example.olympus.news.model;

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
@Document(collection = "news")
@CompoundIndex(name = "asset_created", def = "{'assetId': 1, 'createdAt': -1}")
public class NewsArticle {
    @Id private String id;
    private String assetId;
    private String eventId;
    private String headline;
    private String body;
    @Field(targetType = FieldType.DECIMAL128) private BigDecimal sentiment;
    @CreatedDate private Instant createdAt;
}
