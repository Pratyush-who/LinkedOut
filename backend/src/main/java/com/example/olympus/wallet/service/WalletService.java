package com.example.olympus.wallet.service;

import com.example.olympus.wallet.repository.LedgerEntryRepository;
import com.example.olympus.wallet.repository.WalletRepository;
import com.example.olympus.wallet.model.LedgerEntry;
import com.example.olympus.wallet.model.LedgerEntryType;
import com.example.olympus.wallet.model.Wallet;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class WalletService {
    private final WalletRepository walletRepository;
    private final LedgerEntryRepository ledgerEntryRepository;

    private static final BigDecimal STARTING_BALANCE = new BigDecimal("100000.00");

    @Transactional
    public Wallet createWalletForUser(String userId) {
        Wallet wallet = Wallet.builder()
                .userId(userId)
                .balance(STARTING_BALANCE)
                .build();
        
        wallet = walletRepository.save(wallet);

        LedgerEntry entry = LedgerEntry.builder()
                .userId(userId)
                .entryType(LedgerEntryType.STARTING_BALANCE)
                .amount(STARTING_BALANCE)
                .metadata(Map.of("note", "Initial welcome bonus"))
                .build();
        
        ledgerEntryRepository.save(entry);

        return wallet;
    }

    @Transactional(readOnly = true)
    public Wallet getWalletByUserId(String userId) {
        return walletRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Wallet not found for user: " + userId));
    }
}
