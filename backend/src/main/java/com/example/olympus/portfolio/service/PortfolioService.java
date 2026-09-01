package com.example.olympus.portfolio.service;

import com.example.olympus.asset.model.Asset;
import com.example.olympus.portfolio.model.Holding;
import com.example.olympus.asset.repository.AssetRepository;
import com.example.olympus.portfolio.repository.HoldingRepository;
import com.example.olympus.wallet.service.WalletService;
import com.example.olympus.wallet.model.Wallet;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class PortfolioService {
    private final HoldingRepository holdingRepository;
    private final AssetRepository assetRepository;
    private final WalletService walletService;

    public Map<String, Object> getPortfolioSnapshot(String userId) {
        Wallet wallet = walletService.getWalletByUserId(userId);
        List<Holding> holdings = holdingRepository.findByUserId(userId);
        
        BigDecimal totalAssetValue = BigDecimal.ZERO;
        List<Map<String, Object>> holdingsDetails = new java.util.ArrayList<>();
        
        for (Holding h : holdings) {
            Asset asset = assetRepository.findById(h.getAssetId()).orElse(null);
            if (asset != null) {
                BigDecimal currentPrice = asset.getCurrentPrice();
                BigDecimal assetValue = currentPrice.multiply(BigDecimal.valueOf(h.getQuantity()));
                totalAssetValue = totalAssetValue.add(assetValue);
                
                Map<String, Object> detail = new HashMap<>();
                detail.put("assetId", asset.getId());
                detail.put("symbol", asset.getSymbol());
                detail.put("quantity", h.getQuantity());
                detail.put("averagePrice", h.getAveragePrice());
                detail.put("currentPrice", currentPrice);
                detail.put("value", assetValue);
                holdingsDetails.add(detail);
            }
        }
        
        BigDecimal netWorth = wallet.getBalance().add(totalAssetValue);
        
        Map<String, Object> snapshot = new HashMap<>();
        snapshot.put("userId", userId);
        snapshot.put("cash", wallet.getBalance());
        snapshot.put("totalAssetValue", totalAssetValue);
        snapshot.put("netWorth", netWorth);
        snapshot.put("holdings", holdingsDetails);
        
        return snapshot;
    }
}
