package com.example.olympus.portfolio.repository;

import com.example.olympus.portfolio.model.Holding;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;
import java.util.Optional;

public interface HoldingRepository extends MongoRepository<Holding, String> {
    List<Holding> findByUserId(String userId);

    Optional<Holding> findByUserIdAndAssetId(String userId, String assetId);
}
