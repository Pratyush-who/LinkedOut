package com.example.olympus.asset.controller;

import com.example.olympus.asset.service.AssetService;
import com.example.olympus.asset.model.Asset;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/assets")
@RequiredArgsConstructor
public class AssetController {
    private final AssetService assetService;

    @GetMapping
    public ResponseEntity<List<Asset>> getAssets() {
        return ResponseEntity.ok(assetService.getAllActiveAssets());
    }
}
