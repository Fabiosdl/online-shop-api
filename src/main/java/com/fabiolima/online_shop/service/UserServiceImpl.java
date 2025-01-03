package com.fabiolima.online_shop.service;

import com.fabiolima.online_shop.exceptions.BadRequestException;
import com.fabiolima.online_shop.exceptions.ForbiddenException;
import com.fabiolima.online_shop.exceptions.NotFoundException;
import com.fabiolima.online_shop.model.User;
import com.fabiolima.online_shop.model.enums.UserStatus;
import com.fabiolima.online_shop.repository.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

import static com.fabiolima.online_shop.model.enums.UserStatus.*;

@Service
public class UserServiceImpl implements UserService{

    private final UserRepository userRepository;

    @Autowired
    public UserServiceImpl(UserRepository userRepository){
        this.userRepository = userRepository;
    }

    @Override
    @Transactional
    public User saveUser(User theUser) {

        return userRepository.save(theUser);
    }

    @Override
    public List<User> findAllUsers() {
        return userRepository.findAll();
    }

    @Override
    public List<User> findAllUsersWithStatus(UserStatus theStatus) {
        List<User> allUsers = userRepository.findAll();
        return getUsersWithStatus(theStatus, allUsers);
    }

    private List<User> getUsersWithStatus(UserStatus userStatus, List<User> allUsers){
        List<User> userWithStatus = new ArrayList<>();
        for (User u : allUsers){
            if (userStatus.equals(ACTIVE)){
                if(u.getUserStatus().equals(ACTIVE)){
                    userWithStatus.add(u);
                }
            } else {
                if(u.getUserStatus().equals(INACTIVE)){
                    userWithStatus.add(u);
                }
            }
        }
        return userWithStatus;
    }

    @Override
    public User findUserByUserId(Long userId){
        Optional<User> result = userRepository.findById(userId);
        if (result.isEmpty()) throw new NotFoundException("User not found");
        return result.get();
    }

    @Override
    @Transactional
    public User updateUserByUserId(Long userId, User updatedUser) {

        // first check if the user id in the parameter matches the user id in the body.
        if(!Objects.equals(updatedUser.getId(), userId))
            throw new BadRequestException("User id in the parameter does not " +
                    "match the user id in the body");

        // If the request is correct, find user. check if it exists; throw an error if it doesn't
        findUserByUserId(userId);

        // save the updated user data
        return userRepository.save(updatedUser);
    }

    @Override
    public User patchUpdateUserByUserId(Long userId, Map<String, Object> updates) {

        // Check if user exists; throw an error if it doesn't
        User theUser = findUserByUserId(userId);

        updates.forEach((field, value) -> {
            switch (field){
                case "name":
                    theUser.setName((String) value);
                    break;
                case "email":
                    theUser.setEmail((String) value);
                    break;
                case "password":
                    theUser.setPassword((String) value);
                    break;
                case "address":
                    theUser.setAddress((String) value);
                    break;
                default:
                    throw new ForbiddenException("Field not found or not allowed to update");

            }
        });
        return saveUser(theUser);
    }

    @Override
    public User deactivateUserByUserId(Long userId) {
        User theUser = findUserByUserId(userId);
        if(theUser.getUserStatus().equals(INACTIVE))
            throw new ForbiddenException("Cannot complete operation. User status is already INACTIVE");
        theUser.setUserStatus(INACTIVE);
        return saveUser(theUser);
    }

    @Override
    public User deleteUserById(Long userId) {
        User theUser = findUserByUserId(userId);
        userRepository.deleteById(userId);
        return theUser;
    }
}
