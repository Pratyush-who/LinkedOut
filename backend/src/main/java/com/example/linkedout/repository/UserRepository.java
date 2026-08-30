package com.example.linkedout.repository;

import com.example.linkedout.user.model.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends MongoRepository<User, String> {
    Optional<User> findByPhone(String phone);
    Optional<User> findByUsername(String username);
    boolean existsByUsername(String username);
}
