package com.example.olympus.trade.controller;

import com.example.olympus.trade.service.TradingService;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/trade")
@RequiredArgsConstructor
public class TradeController {
    private final TradingService tradingService;

    @PostMapping("/buy")
    public ResponseEntity<Map<String, String>> buyAsset(Principal principal, @RequestBody TradeRequest request) {
        String userId = principal.getName();
        tradingService.executeMarketBuy(userId, request.getAssetId(), request.getQuantity());
        return ResponseEntity.ok(Map.of("message", "Buy order executed successfully"));
    }
    
    @PostMapping("/sell")
    public ResponseEntity<Map<String, String>> sellAsset(Principal principal, @RequestBody TradeRequest request) {
        String userId = principal.getName();
        tradingService.executeMarketSell(userId, request.getAssetId(), request.getQuantity());
        return ResponseEntity.ok(Map.of("message", "Sell order executed successfully"));
    }

    @Data
    public static class TradeRequest {
        private String assetId;
        private long quantity;
    }
}
