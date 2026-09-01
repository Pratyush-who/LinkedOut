package com.example.olympus.asset.service;

import com.example.olympus.asset.model.Asset;
import com.example.olympus.asset.model.AssetStatus;
import com.example.olympus.asset.repository.AssetRepository;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AssetService {
    private final AssetRepository assetRepository;

    @PostConstruct
    public void seedAssets() {
        if (assetRepository.count() == 0) {
            assetRepository.saveAll(List.of(
                    Asset.builder()
                            .symbol("OLY")
                            .name("Olympus Exchange")
                            .description("The native token of the Olympus Exchange.")
                            .category("FINANCE")
                            .initialPrice(new BigDecimal("100.00"))
                            .currentPrice(new BigDecimal("100.00"))
                            .totalSupply(1_000_000_000)
                            .circulatingSupply(100_000_000)
                            .status(AssetStatus.ACTIVE)
                            .build(),
                    Asset.builder()
                            .symbol("ZEUS")
                            .name("Zeus Vault")
                            .description("A decentralized vault backed by lightning energy.")
                            .category("ENERGY")
                            .initialPrice(new BigDecimal("500.00"))
                            .currentPrice(new BigDecimal("500.00"))
                            .totalSupply(50_000_000)
                            .circulatingSupply(5_000_000)
                            .status(AssetStatus.ACTIVE)
                            .build(),
                    Asset.builder()
                            .symbol("PWI")
                            .name("Pantheon Wealth Index")
                            .description("An index fund tracking top gods.")
                            .category("INDEX")
                            .initialPrice(new BigDecimal("1000.00"))
                            .currentPrice(new BigDecimal("1000.00"))
                            .totalSupply(10_000_000)
                            .circulatingSupply(1_000_000)
                            .status(AssetStatus.ACTIVE)
                            .build(),
                    Asset.builder()
                            .symbol("ORA")
                            .name("Oracle News")
                            .description("The primary news source in Olympus.")
                            .category("MEDIA")
                            .initialPrice(new BigDecimal("50.00"))
                            .currentPrice(new BigDecimal("50.00"))
                            .totalSupply(500_000_000)
                            .circulatingSupply(50_000_000)
                            .status(AssetStatus.ACTIVE)
                            .build()
            ));
        }
    }

    public List<Asset> getAllActiveAssets() {
        return assetRepository.findByStatus(AssetStatus.ACTIVE);
    }
}
