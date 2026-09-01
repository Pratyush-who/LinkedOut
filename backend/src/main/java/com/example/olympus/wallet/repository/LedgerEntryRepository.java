package com.example.olympus.wallet.repository;

import com.example.olympus.wallet.model.LedgerEntry;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface LedgerEntryRepository extends MongoRepository<LedgerEntry, String> {
    List<LedgerEntry> findByUserIdOrderByCreatedAtDesc(String userId);
}
