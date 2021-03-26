package fr.istic.projet.servicefirebaseapp.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import fr.istic.projet.servicefirebaseapp.model.User;

@RestController
@RequestMapping("/api/user")
public class UserController {

        
    @GetMapping
    public List<User> findAllUsers() {
    	List<User> staticUsers = new ArrayList<User>();
    	staticUsers.add(new User(1, "utilisateur 1"));
    	staticUsers.add(new User(2, "utilisateur 2"));
        return staticUsers;
    }

    @GetMapping("/{id}")
    public ResponseEntity<User> findUserById(@PathVariable(value = "id") long id) {
    	User staticUser  = new User(1, "utilisateur");
        return ResponseEntity.ok().body(staticUser);
        
    }

    @PostMapping
    public User doSomethingWithUser(@Validated @RequestBody User user) {
    	System.out.println(" simulation d'un traitement avec l'utilisateur "+ user.getId() + user.getName());
    	return user;
    }
}
