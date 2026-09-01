package com.example.olympus.trade.service;

import com.example.olympus.asset.model.Asset;
import com.example.olympus.portfolio.model.Holding;
import com.example.olympus.asset.repository.AssetRepository;
import com.example.olympus.portfolio.repository.HoldingRepository;
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
public class TradingService {
    private final WalletRepository walletRepository;
    private final AssetRepository assetRepository;
    private final HoldingRepository holdingRepository;
    private final LedgerEntryRepository ledgerEntryRepository;

    @Transactional
    public void executeMarketBuy(String userId, String assetId, long quantity) {
        Wallet wallet = walletRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Wallet not found"));
        
        Asset asset = assetRepository.findById(assetId)
                .orElseThrow(() -> new RuntimeException("Asset not found"));
                
        BigDecimal totalCost = asset.getCurrentPrice().multiply(BigDecimal.valueOf(quantity));
        
        if (wallet.getBalance().compareTo(totalCost) < 0) {
            throw new RuntimeException("Insufficient funds");
        }
        
        wallet.setBalance(wallet.getBalance().subtract(totalCost));
        walletRepository.save(wallet);
        
        LedgerEntry entry = LedgerEntry.builder()
                .userId(userId)
                .entryType(LedgerEntryType.BUY_ORDER)
                .amount(totalCost.negate())
                .referenceType("ASSET")
                .referenceId(assetId)
                .metadata(Map.of("quantity", quantity, "price", asset.getCurrentPrice()))
                .build();
        ledgerEntryRepository.save(entry);
        
        Holding holding = holdingRepository.findByUserIdAndAssetId(userId, assetId)
                .orElse(Holding.builder().userId(userId).assetId(assetId).quantity(0).averagePrice(BigDecimal.ZERO).build());
        
        BigDecimal totalOldValue = holding.getAveragePrice().multiply(BigDecimal.valueOf(holding.getQuantity()));
        BigDecimal newTotalValue = totalOldValue.add(totalCost);
        holding.setQuantity(holding.getQuantity() + quantity);
        holding.setAveragePrice(newTotalValue.divide(BigDecimal.valueOf(holding.getQuantity()), 2, java.math.RoundingMode.HALF_UP));
        
        holdingRepository.save(holding);
    }
    
    @Transactional
    public void executeMarketSell(String userId, String assetId, long quantity) {
        Holding holding = holdingRepository.findByUserIdAndAssetId(userId, assetId)
                .orElseThrow(() -> new RuntimeException("Holding not found"));
                
        if (holding.getQuantity() < quantity) {
            throw new RuntimeException("Insufficient quantity");
        }
        
        Wallet wallet = walletRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Wallet not found"));
                
        Asset asset = assetRepository.findById(assetId)
                .orElseThrow(() -> new RuntimeException("Asset not found"));
                
        BigDecimal totalRevenue = asset.getCurrentPrice().multiply(BigDecimal.valueOf(quantity));
        
        wallet.setBalance(wallet.getBalance().add(totalRevenue));
        walletRepository.save(wallet);
        
        LedgerEntry entry = LedgerEntry.builder()
                .userId(userId)
                .entryType(LedgerEntryType.SELL_ORDER)
                .amount(totalRevenue)
                .referenceType("ASSET")
                .referenceId(assetId)
                .metadata(Map.of("quantity", quantity, "price", asset.getCurrentPrice()))
                .build();
        ledgerEntryRepository.save(entry);
        
        holding.setQuantity(holding.getQuantity() - quantity);
        if (holding.getQuantity() == 0) {
            holding.setAveragePrice(BigDecimal.ZERO);
        }
        holdingRepository.save(holding);
    }
}
