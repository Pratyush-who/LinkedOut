package com.example.linkedout;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.mongodb.config.EnableMongoAuditing;

@SpringBootApplication
@EnableMongoAuditing
public class LinkedoutApplication {

	public static void main(String[] args) {
		SpringApplication.run(LinkedoutApplication.class, args);
	}

}
