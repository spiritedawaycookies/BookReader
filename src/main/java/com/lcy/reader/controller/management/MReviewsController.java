package com.lcy.reader.controller.management;

import com.baomidou.mybatisplus.core.metadata.IPage;

import com.lcy.reader.entity.Evaluation;
import com.lcy.reader.entity.User;
import com.lcy.reader.service.EvaluationService;
import com.lcy.reader.service.exception.BussinessException;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/management/review")
public class MReviewsController {
    @Resource
    private EvaluationService evaluationService;
    @GetMapping("/index.html")
    public ModelAndView showReviews(HttpSession session){
        User user = (User) session.getAttribute("loginUser");
        if (user != null) {
            return new ModelAndView("/management/review");
        } else return new ModelAndView("/management/error404");
    }

    @GetMapping("/list")
    @ResponseBody
    public Map list(Integer page, Integer limit) {
        if (page == null) {
            page = 1;
        }

        if (limit == null) {
            limit = 10;
        }

        IPage<Evaluation> pageObject = evaluationService.paging(null,page,limit);
        //layui的要求
        Map result = new HashMap();
        result.put("code", "0");
        result.put("msg", "success");
        result.put("data", pageObject.getRecords());//当前页面数据
        result.put("count", pageObject.getTotal());//未分页时记录总数
        return result;
    }

    @PostMapping("/disable")
    @ResponseBody
    public Map disableEvaluation(Long evaluationId,String disableReason) {
        Map result = new HashMap();
        try {
            evaluationService.disableEvaluation(evaluationId,disableReason);

            result.put("code", "0");
            result.put("msg", "success");
        } catch (BussinessException ex) {
            ex.printStackTrace();
            result.put("code", ex.getCode());
            result.put("msg", ex.getMsg());
        }
        return result;
    }
    @PostMapping("/revoke")
    @ResponseBody
    public Map revoke(Long evaluationId) {
        Map result = new HashMap();
        try {
            evaluationService.revoke(evaluationId);

            result.put("code", "0");
            result.put("msg", "success");
        } catch (BussinessException ex) {
            ex.printStackTrace();
            result.put("code", ex.getCode());
            result.put("msg", ex.getMsg());
        }
        return result;
    }
}
