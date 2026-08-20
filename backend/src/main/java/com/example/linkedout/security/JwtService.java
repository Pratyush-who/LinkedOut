package com.example.linkedout.security;

import com.example.linkedout.model.User;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.io.InputStream;
import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.time.Duration;
import java.time.Instant;
import java.util.Base64;
import java.util.Date;
import java.util.UUID;

@Slf4j
@Service
public class JwtService {

    private final StringRedisTemplate redisTemplate;
    private final PrivateKey privateKey;
    private final PublicKey publicKey;
    private final long expiration;
    
    private static final Duration REFRESH_TOKEN_TTL = Duration.ofDays(30);

    public JwtService(
            StringRedisTemplate redisTemplate,
            @Value("${jwt.private-key-path}") Resource privateKeyResource,
            @Value("${jwt.public-key-path}") Resource publicKeyResource,
            @Value("${jwt.expiration}") long expiration) throws Exception {
        this.redisTemplate = redisTemplate;
        this.expiration = expiration;
        this.privateKey = loadPrivateKey(privateKeyResource);
        this.publicKey = loadPublicKey(publicKeyResource);
    }

    public String generateAccessToken(User user) {
        return Jwts.builder()
                .subject(user.getId())
                .claim("handle", user.getHandle())
                .id(UUID.randomUUID().toString())
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + (expiration * 1000)))
                .signWith(privateKey)
                .compact();
    }

    public String generateRefreshToken(String userId, String deviceInfo) {
        String tokenId = UUID.randomUUID().toString();
        String key = "refresh:" + userId + ":" + tokenId;
        String value = "{\"deviceInfo\":\"" + deviceInfo + "\",\"issuedAt\":\"" + Instant.now() + "\"}";
        
        redisTemplate.opsForValue().set(key, value, REFRESH_TOKEN_TTL);
        return tokenId;
    }

    public boolean validateRefreshToken(String userId, String tokenId) {
        String key = "refresh:" + userId + ":" + tokenId;
        Boolean exists = redisTemplate.hasKey(key);
        return exists != null && exists;
    }
    
    public void revokeRefreshToken(String userId, String tokenId) {
        String key = "refresh:" + userId + ":" + tokenId;
        redisTemplate.delete(key);
    }
    
    public void revokeAllUserSessions(String userId) {
        // In real app, you would use SCAN to find all refresh keys for this user and delete them
        redisTemplate.keys("refresh:" + userId + ":*").forEach(redisTemplate::delete);
    }

    public Claims validateAccessToken(String token) {
        return Jwts.parser()
                .verifyWith(publicKey)
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    private PrivateKey loadPrivateKey(Resource resource) throws Exception {
        try (InputStream is = resource.getInputStream()) {
            String keyStr = new String(is.readAllBytes())
                    .replace("-----BEGIN PRIVATE KEY-----", "")
                    .replace("-----END PRIVATE KEY-----", "")
                    .replaceAll("\\s+", "");
            byte[] keyBytes = Base64.getDecoder().decode(keyStr);
            PKCS8EncodedKeySpec spec = new PKCS8EncodedKeySpec(keyBytes);
            KeyFactory kf = KeyFactory.getInstance("RSA");
            return kf.generatePrivate(spec);
        }
    }

    private PublicKey loadPublicKey(Resource resource) throws Exception {
        try (InputStream is = resource.getInputStream()) {
            String keyStr = new String(is.readAllBytes())
                    .replace("-----BEGIN PUBLIC KEY-----", "")
                    .replace("-----END PUBLIC KEY-----", "")
                    .replaceAll("\\s+", "");
            byte[] keyBytes = Base64.getDecoder().decode(keyStr);
            X509EncodedKeySpec spec = new X509EncodedKeySpec(keyBytes);
            KeyFactory kf = KeyFactory.getInstance("RSA");
            return kf.generatePublic(spec);
        }
    }
}
