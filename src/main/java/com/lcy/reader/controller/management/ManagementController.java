package com.lcy.reader.controller.management;


import com.lcy.reader.entity.User;
import com.lcy.reader.service.UserService;
import com.lcy.reader.service.exception.BussinessException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

/**
 * 后台管理系统控制器
 */
@Controller
@RequestMapping("/management")
public class ManagementController {
    @Resource
    private UserService userService;
    @GetMapping("/index.html")
    public ModelAndView showIndex(HttpSession session) {
        User user = (User) session.getAttribute("loginUser");
        if (user!=null) {
            //指向management/book.ftl
            return new ModelAndView("/management/index");
        } else return new ModelAndView("/management/error404");

    }
    @GetMapping("/login.html")
    public ModelAndView showLogin(HttpSession session){
        return new ModelAndView("/management/login");
    }

    @PostMapping("/check_login")
    @ResponseBody
    public Map checkLogin(String username, String password, String vc, HttpSession session) {
        //正确验证码
        String verifyCode = (String) session.getAttribute("kaptchaVerifyCode");
        //验证码对比
        Map result = new HashMap();
        if (vc == null || verifyCode == null || !vc.equalsIgnoreCase(verifyCode)) {
            result.put("code", "VC01");
            result.put("msg", "Wrong captcha");
        } else {
            try {
                User user = userService.checkLogin(username, password);
                session.setAttribute("loginUser", user);
                result.put("code", "0");
                result.put("msg", "success");
            } catch (BussinessException ex) {
                ex.printStackTrace();
                result.put("code", ex.getCode());
                result.put("msg", ex.getMsg());
            }
        }
        return result;
    }

    @GetMapping("/logout")
    public RedirectView logout(HttpSession session){
        session.invalidate();
        return new RedirectView("/management/login.html");
    }
}
