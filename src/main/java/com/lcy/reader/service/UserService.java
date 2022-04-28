package com.lcy.reader.service;

import com.lcy.reader.entity.User;

public interface UserService {
    public User checkLogin(String username, String password);
}
