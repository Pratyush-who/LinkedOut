package com.example.olympus.asset.repository;

import com.example.olympus.asset.model.Asset;
import com.example.olympus.asset.model.AssetStatus;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;
import java.util.Optional;

public interface AssetRepository extends MongoRepository<Asset, String> {
    Optional<Asset> findBySymbol(String symbol);
    List<Asset> findByStatus(AssetStatus status);
}
