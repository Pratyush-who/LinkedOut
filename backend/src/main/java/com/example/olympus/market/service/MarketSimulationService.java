package com.example.olympus.market.service;

import com.example.olympus.asset.model.Asset;
import com.example.olympus.asset.model.AssetStatus;
import com.example.olympus.asset.repository.AssetRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Random;

@Service
@RequiredArgsConstructor
@Slf4j
public class MarketSimulationService {

    private final AssetRepository assetRepository;
    private final PriceAlgorithms priceAlgorithms;
    private final Random random = new Random();

    // Global market trend value, fluctuates between -1.0 and 1.0 (normally)
    private double currentMarketTrend = 0.1;
    
    // Simulate a rare market crash
    private boolean isMarketDip = false;
    private int dipDurationTicks = 0;

    public double getCurrentMarketTrend() {
        return currentMarketTrend;
    }

    public boolean isMarketDip() {
        return isMarketDip;
    }

    @Scheduled(fixedRate = 2000)
    @Transactional
    public void simulateMarket() {
        updateMarketTrend();

        List<Asset> activeAssets = assetRepository.findByStatus(AssetStatus.ACTIVE);
        if (activeAssets.isEmpty()) {
            return;
        }

        // Apply price updates
        for (Asset asset : activeAssets) {
            // Fetch the assigned algorithm based on the asset's symbol/ID
            PriceAlgorithms.PriceAlgo algo = priceAlgorithms.getAlgoForAsset(asset);

            BigDecimal newPrice = algo.calculateNewPrice(asset, currentMarketTrend);
            asset.setCurrentPrice(newPrice);
        }

        assetRepository.saveAll(activeAssets);
        log.debug("Market simulated for {} assets. Current Trend: {}", activeAssets.size(), currentMarketTrend);
    }

    private void updateMarketTrend() {
        if (isMarketDip) {
            // Recovering or sustaining dip
            dipDurationTicks--;
            if (dipDurationTicks <= 0) {
                isMarketDip = false;
                currentMarketTrend = -0.5; // Starts recovery
                log.info("Market dip ended. Recovery starting.");
            } else {
                currentMarketTrend = -2.0 - random.nextDouble(); // Massive negative trend
            }
            return;
        }

        // Once a month dip probability. 
        // 1 month = ~30 days = 2,592,000 seconds = 1,296,000 ticks of 2s.
        // We'll give it a 1 in 1,296,000 chance per tick.
        if (random.nextInt(1296000) == 0) {
            isMarketDip = true;
            dipDurationTicks = 15 + random.nextInt(30); // Lasts for 30-90 seconds (15-45 ticks)
            log.warn("MARKET CRASH INITIATED! Duration: {} ticks", dipDurationTicks);
            return;
        }

        // Normal fluctuation (random walk for the market trend)
        double trendChange = (random.nextDouble() - 0.5) * 0.1;
        currentMarketTrend += trendChange;
        
        // Bound the normal trend between -1.0 and +1.0
        if (currentMarketTrend > 1.0) currentMarketTrend = 1.0;
        if (currentMarketTrend < -1.0) currentMarketTrend = -1.0;
    }
}
