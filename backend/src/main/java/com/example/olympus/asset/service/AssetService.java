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
                            .growthFactor(new BigDecimal("1.00"))
                            .volatility(new BigDecimal("0.15"))
                            .build(),
                    Asset.builder()
                            .symbol("ARES")
                            .name("Ares Warfare Fund")
                            .description("Aggressive growth fund backed by conflict.")
                            .category("INDEX")
                            .initialPrice(new BigDecimal("150.00"))
                            .currentPrice(new BigDecimal("150.00"))
                            .totalSupply(20_000_000)
                            .circulatingSupply(2_000_000)
                            .status(AssetStatus.ACTIVE)
                            .growthFactor(new BigDecimal("1.10"))
                            .volatility(new BigDecimal("0.40"))
                            .build(),
                    Asset.builder()
                            .symbol("HADES")
                            .name("Underworld Assets")
                            .description("Deep value storage with grim prospects.")
                            .category("FINANCE")
                            .initialPrice(new BigDecimal("90.00"))
                            .currentPrice(new BigDecimal("90.00"))
                            .totalSupply(100_000_000)
                            .circulatingSupply(10_000_000)
                            .status(AssetStatus.ACTIVE)
                            .growthFactor(new BigDecimal("0.80")) // -20%
                            .volatility(new BigDecimal("0.20"))
                            .build(),
                    Asset.builder()
                            .symbol("POS")
                            .name("Poseidon Marine Co.")
                            .description("Naval trade and shipping monopoly.")
                            .category("COMMODITY")
                            .initialPrice(new BigDecimal("200.00"))
                            .currentPrice(new BigDecimal("200.00"))
                            .totalSupply(30_000_000)
                            .circulatingSupply(15_000_000)
                            .status(AssetStatus.ACTIVE)
                            .growthFactor(new BigDecimal("0.90")) // -10%
                            .volatility(new BigDecimal("0.25"))
                            .build(),
                    Asset.builder()
                            .symbol("ATH")
                            .name("Athena Wisdom Tech")
                            .description("Cutting edge strategic technology.")
                            .category("TECHNOLOGY")
                            .initialPrice(new BigDecimal("300.00"))
                            .currentPrice(new BigDecimal("300.00"))
                            .totalSupply(10_000_000)
                            .circulatingSupply(5_000_000)
                            .status(AssetStatus.ACTIVE)
                            .growthFactor(new BigDecimal("1.20")) // 20%
                            .volatility(new BigDecimal("0.35"))
                            .build(),
                    Asset.builder()
                            .symbol("HRM")
                            .name("Hermes Logistics")
                            .description("Fastest delivery network in the realms.")
                            .category("SERVICES")
                            .initialPrice(new BigDecimal("80.00"))
                            .currentPrice(new BigDecimal("80.00"))
                            .totalSupply(50_000_000)
                            .circulatingSupply(40_000_000)
                            .status(AssetStatus.ACTIVE)
                            .growthFactor(new BigDecimal("1.50")) // 50%
                            .volatility(new BigDecimal("0.60"))
                            .build(),
                    Asset.builder()
                            .symbol("APL")
                            .name("Apollo Solar Energy")
                            .description("Once brilliant, now fading star.")
                            .category("ENERGY")
                            .initialPrice(new BigDecimal("10.00"))
                            .currentPrice(new BigDecimal("10.00"))
                            .totalSupply(200_000_000)
                            .circulatingSupply(150_000_000)
                            .status(AssetStatus.ACTIVE)
                            .growthFactor(new BigDecimal("0.10")) // -100% (approaching zero)
                            .volatility(new BigDecimal("0.80"))
                            .build()
            ));
        }
    }

    public List<Asset> getAllActiveAssets() {
        return assetRepository.findByStatus(AssetStatus.ACTIVE);
    }
}
