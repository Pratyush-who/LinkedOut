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
        // Algo 1: Geometric Brownian Motion (Standard Stock Model)
        // Uses current price, asset growth factor (drift), and asset volatility.
        algos.add((asset, trend) -> {
            double drift = asset.getGrowthFactor().doubleValue() - 1.0; 
            // Adjust drift slightly based on market trend
            drift += trend * trendMultiplier;
            
            double vol = asset.getVolatility().doubleValue();
            if (vol <= 0) vol = baseVolatility; // Baseline vol

            double currentPrice = asset.getCurrentPrice().doubleValue();
            
            // GBM Formula: dS = S * (mu * dt + sigma * dW)
            double dt = timeStep;
            double dW = random.nextGaussian() * Math.sqrt(dt);
            
            double delta = currentPrice * (drift * dt + vol * dW);
            return applyLimits(currentPrice + delta, asset.getInitialPrice());
        });

        // Algo 2: Ornstein-Uhlenbeck (Mean-Reverting)
        // Tends to pull the price back towards a target mean (initial price * growth factor)
        algos.add((asset, trend) -> {
            double currentPrice = asset.getCurrentPrice().doubleValue();
            double initialPrice = asset.getInitialPrice().doubleValue();
            
            // The target price grows over time based on the growth factor
            double targetMean = initialPrice * asset.getGrowthFactor().doubleValue();
            targetMean += targetMean * trend * (trendMultiplier / 2.0); // Market trend shifts the mean temporarily
            
            double theta = 0.5; // Speed of reversion
            double vol = asset.getVolatility().doubleValue();
            if (vol <= 0) vol = baseVolatility * 1.5;

            double dt = timeStep;
            double dW = random.nextGaussian() * Math.sqrt(dt);
            
            // OU Formula: dS = theta * (mean - S) * dt + sigma * dW
            double delta = theta * (targetMean - currentPrice) * dt + vol * currentPrice * dW;
            return applyLimits(currentPrice + delta, asset.getInitialPrice());
        });

        // Algo 3: Momentum / Trend Following
        // Relies heavily on the global market trend rather than individual drift
        algos.add((asset, trend) -> {
            double currentPrice = asset.getCurrentPrice().doubleValue();
            double vol = asset.getVolatility().doubleValue();
            if (vol <= 0) vol = baseVolatility * 2.0;

            double dt = timeStep;
            // High reliance on trend
            double drift = trend * (trendMultiplier * 20.0); 
            // Add a localized momentum factor based on its growth factor
            drift += (asset.getGrowthFactor().doubleValue() - 1.0) * 0.5;

            double dW = random.nextGaussian() * Math.sqrt(dt);
            double delta = currentPrice * (drift * dt + vol * dW);
            
            return applyLimits(currentPrice + delta, asset.getInitialPrice());
        });

        // Algo 4: Jump-Diffusion Model (Merton's Model)
        // Similar to GBM but with rare, sudden price jumps (good for highly volatile assets)
        algos.add((asset, trend) -> {
            double currentPrice = asset.getCurrentPrice().doubleValue();
            double drift = asset.getGrowthFactor().doubleValue() - 1.0 + (trend * (trendMultiplier / 2.0));
            double vol = asset.getVolatility().doubleValue();
            if (vol <= 0) vol = baseVolatility * 2.5;

            double dt = timeStep;
            double dW = random.nextGaussian() * Math.sqrt(dt);
            
            // Continuous part
            double delta = currentPrice * (drift * dt + vol * dW);
            
            // Jump part (Poisson process)
            double lambda = 5.0; // expected jumps per year
            if (random.nextDouble() < (lambda * dt)) {
                // A jump occurred! Size is log-normally distributed, but we simplify
                double jumpSize = (random.nextGaussian() * 0.1) + (trend * 0.05);
                delta += currentPrice * jumpSize;
            }

            return applyLimits(currentPrice + delta, asset.getInitialPrice());
        });

        // Algo 5: Stable Growth (Blue-chip style)
        // Very low volatility, strict adherence to growth factor. Rarely deviates far.
        algos.add((asset, trend) -> {
            double currentPrice = asset.getCurrentPrice().doubleValue();
            double drift = asset.getGrowthFactor().doubleValue() - 1.0;
            // Market trend has minimized effect
            drift += trend * (trendMultiplier * 0.2);
            
            // Force low volatility
            double vol = Math.min(asset.getVolatility().doubleValue(), baseVolatility / 2.0);
            if (vol <= 0) vol = baseVolatility / 5.0;

            double dt = timeStep;
            double dW = random.nextGaussian() * Math.sqrt(dt);
            
            double delta = currentPrice * (drift * dt + vol * dW);
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
