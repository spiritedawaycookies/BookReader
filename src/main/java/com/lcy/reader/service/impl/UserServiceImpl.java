package com.lcy.reader.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.lcy.reader.entity.User;
import com.lcy.reader.mapper.UserMapper;
import com.lcy.reader.service.UserService;
import com.lcy.reader.service.exception.BussinessException;
import com.lcy.reader.utils.MD5Utils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
@Service("userService")
public class UserServiceImpl implements UserService {
    @Resource
    private UserMapper userMapper;
    public User checkLogin(String username, String password) {
        QueryWrapper<User> queryWrapper = new QueryWrapper<User>();
        queryWrapper.eq("username", username);
        User user = userMapper.selectOne(queryWrapper);
        if(user == null){
            throw new BussinessException("M02", "User doesn't exist");
        }
        String md5 = MD5Utils.md5Digest(password, user.getSalt());
        if(!md5.equals(user.getPassword())){
            throw new BussinessException("M03", "Wrong password");
        }
        return user;
    }
}
