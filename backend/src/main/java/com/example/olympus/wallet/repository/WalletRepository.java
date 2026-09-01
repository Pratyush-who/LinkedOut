package com.example.olympus.wallet.repository;

import com.example.olympus.wallet.model.Wallet;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.Optional;

public interface WalletRepository extends MongoRepository<Wallet, String> {
}
