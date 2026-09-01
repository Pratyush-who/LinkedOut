package com.example.olympus.portfolio.controller;

import com.example.olympus.portfolio.service.PortfolioService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/portfolio")
@RequiredArgsConstructor
public class PortfolioController {
    private final PortfolioService portfolioService;

    @GetMapping
    public ResponseEntity<Map<String, Object>> getPortfolio(Principal principal) {
        String userId = principal.getName();
        return ResponseEntity.ok(portfolioService.getPortfolioSnapshot(userId));
    }
}
