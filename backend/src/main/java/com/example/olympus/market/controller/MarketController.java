package com.example.olympus.market.controller;

import com.example.olympus.asset.model.Asset;
import com.example.olympus.asset.model.AssetStatus;
import com.example.olympus.asset.repository.AssetRepository;
import com.example.olympus.market.service.MarketSimulationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/market")
@RequiredArgsConstructor
public class MarketController {

    private final AssetRepository assetRepository;
    private final MarketSimulationService marketSimulationService;

    @GetMapping("/assets")
    public ResponseEntity<List<Asset>> getAllActiveAssets() {
        return ResponseEntity.ok(assetRepository.findByStatus(AssetStatus.ACTIVE));
    }

    @GetMapping("/assets/{symbol}")
    public ResponseEntity<Asset> getAssetBySymbol(@PathVariable String symbol) {
        return assetRepository.findBySymbol(symbol)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/trend")
    public ResponseEntity<Map<String, Object>> getMarketTrend() {
        return ResponseEntity.ok(Map.of(
                "currentTrend", marketSimulationService.getCurrentMarketTrend(),
                "isMarketDip", marketSimulationService.isMarketDip(),
                "status", marketSimulationService.isMarketDip() ? "CRASH" : "NORMAL"
        ));
    }
}
