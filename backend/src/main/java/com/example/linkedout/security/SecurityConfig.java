package com.example.linkedout.security;

import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;

import java.io.IOException;

/** Security boundary for the HTTP API. JWT-protected domain routes are added here as they are implemented. */
@Configuration
public class SecurityConfig {

    @Bean
    SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        return http
                .csrf(AbstractHttpConfigurer::disable)
                .formLogin(AbstractHttpConfigurer::disable)
                .httpBasic(AbstractHttpConfigurer::disable)
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(authorize -> authorize
                        // The current controller contains the account-creation flow. Profile routes
                        // will move behind JWT authentication when the JWT filter is introduced.
                        .requestMatchers("/api/auth/**").permitAll()
                        .anyRequest().authenticated())
                .exceptionHandling(exceptions -> exceptions
                        .authenticationEntryPoint((request, response, exception) ->
                                writeError(response, HttpServletResponse.SC_UNAUTHORIZED,
                                        "Unauthorized", "Authentication is required for this endpoint."))
                        .accessDeniedHandler((request, response, exception) ->
                                writeError(response, HttpServletResponse.SC_FORBIDDEN,
                                        "Forbidden", "You do not have permission to access this endpoint.")))
                .build();
    }

    private void writeError(HttpServletResponse response, int status, String error, String message) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json");
        response.getWriter().write("{\"status\":" + status + ",\"error\":\"" + error
                + "\",\"message\":\"" + message + "\"}");
    }
}
