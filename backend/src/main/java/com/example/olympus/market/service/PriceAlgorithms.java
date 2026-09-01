package com.example.olympus.market.service;

import com.example.olympus.asset.model.Asset;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import jakarta.annotation.PostConstruct;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

@Component
public class PriceAlgorithms {

    private final Random random = new Random();
    
    @Value("${market.simulation.time-step:0.004}")
    private double timeStep;
    
    @Value("${market.simulation.base-volatility:0.1}")
    private double baseVolatility;
    
    @Value("${market.simulation.trend-multiplier:0.1}")
    private double trendMultiplier;

    public interface PriceAlgo {
        BigDecimal calculateNewPrice(Asset asset, double globalMarketTrend);
    }

    private final List<PriceAlgo> algos = new ArrayList<>();

    @PostConstruct
    public void init() {
        // We will use a unified, highly realistic algorithm that combines:
        // 1. A drifting target mean (based on growthFactor).
        // 2. Mean reversion (Ornstein-Uhlenbeck) to make it swing around the target (e.g. 100 -> 200 -> 150).
        // 3. Random walk (Geometric Brownian Motion) for local noise.
        // 4. A hidden sine wave factor to make it harder to decode.
        
        algos.add((asset, trend) -> {
            double currentPrice = asset.getCurrentPrice().doubleValue();
            double initialPrice = asset.getInitialPrice().doubleValue();
            
            // 1. Time-based target drift
            // In a real scenario, this would be based on actual time elapsed.
            // We simulate time elapsed by using the created/updated difference or just a simple step counter.
            // For simulation purposes, we'll assume the target grows by 'growthFactor' over a set period (e.g., 100,000 ticks).
            // A growthFactor of 1.10 means 10% growth.
            double growthRate = asset.getGrowthFactor().doubleValue() - 1.0; 
            
            // We need a pseudo-random but somewhat deterministic target based on time.
            // To simulate the 100 -> 200 -> 150 -> 250 effect, the "target" itself oscillates while growing.
            long now = System.currentTimeMillis();
            // A slow cycle (e.g., 1 hour = 3600000 ms)
            double cycle = (now % 3600000) / 3600000.0 * Math.PI * 2; 
            
            // The target mean price
            // It grows linearly (simplified), but oscillates by up to 20% to create macro-swings
            double macroOscillation = Math.sin(cycle) * 0.20; 
            
            // Add a little bit of the global market trend
            double trendImpact = trend * trendMultiplier;
            
            // This is roughly where the asset "wants" to be right now.
            // In a real app we'd track age, but here we just let it drift from current price + growth.
            // Since we don't have perfect age tracking per tick in this loop, we'll apply drift continuously.
            double targetDrift = (growthRate * timeStep) + (macroOscillation * timeStep) + (trendImpact * timeStep);
            
            double targetMean = currentPrice * (1.0 + targetDrift);

            // 2. Mean Reversion (pulling price towards targetMean)
            double theta = 0.05; // Speed of reversion. Lower = wider swings before returning.
            
            // 3. Noise (Volatility)
            double vol = asset.getVolatility().doubleValue();
            if (vol <= 0) vol = baseVolatility;
            
            // We scale volatility so it's realistic for a 2-second tick (timeStep).
            double dt = timeStep;
            double dW = random.nextGaussian() * Math.sqrt(dt);
            
            // OU Formula + GBM drift: dS = theta * (target - S) * dt + sigma * S * dW
            double delta = theta * (targetMean - currentPrice) * dt + vol * currentPrice * dW;
            
            // 4. Hidden pseudo-random factor to prevent decoding
            // Uses the asset ID hash mixed with time
            int secretSeed = asset.getId().hashCode() ^ (int)(now / 10000);
            Random secretRandom = new Random(secretSeed);
            double noise = (secretRandom.nextDouble() - 0.5) * vol * 0.1;
            
            delta += noise;

            return applyLimits(currentPrice + delta, asset.getInitialPrice());
        });
    }

    private BigDecimal applyLimits(double newPrice, BigDecimal initialPriceDec) {
        double minPrice = 0.01;
        // Optionally, don't let a stock fall below 10% of its initial price to prevent total collapse
        if (initialPriceDec != null) {
            double floor = initialPriceDec.doubleValue() * 0.1;
            if (floor > minPrice) {
                minPrice = floor;
            }
        }
        
        if (newPrice < minPrice) {
            newPrice = minPrice;
        }
        
        return BigDecimal.valueOf(newPrice).setScale(2, RoundingMode.HALF_UP);
    }

    public PriceAlgo getAlgoForAsset(Asset asset) {
        // Assign a consistent algorithm based on the asset's symbol or ID hash
        // so a specific asset always behaves according to the same market model.
        int hash = Math.abs(asset.getSymbol() != null ? asset.getSymbol().hashCode() : asset.getId().hashCode());
        return algos.get(hash % algos.size());
    }
    
    public int getAlgoCount() {
        return algos.size();
    }
}
