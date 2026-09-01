package com.example.olympus.wallet.controller;

import com.example.olympus.wallet.repository.LedgerEntryRepository;
import com.example.olympus.wallet.service.WalletService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/wallet")
@RequiredArgsConstructor
public class WalletController {
    private final WalletService walletService;
    private final LedgerEntryRepository ledgerEntryRepository;

    @GetMapping
    public ResponseEntity<Map<String, Object>> getWallet(Principal principal) {
        String userId = principal.getName();
        Map<String, Object> response = new HashMap<>();
        response.put("wallet", walletService.getWalletByUserId(userId));
        response.put("ledger", ledgerEntryRepository.findByUserIdOrderByCreatedAtDesc(userId));
        return ResponseEntity.ok(response);
    }
}
