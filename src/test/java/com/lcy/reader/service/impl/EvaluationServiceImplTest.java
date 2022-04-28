package com.lcy.reader.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.lcy.reader.entity.Book;
import com.lcy.reader.entity.Evaluation;
import com.lcy.reader.mapper.BookMapper;
import com.lcy.reader.service.EvaluationService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;

import java.util.List;

import static org.junit.Assert.*;
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class EvaluationServiceImplTest {

    @Resource
    private EvaluationService evaluationService;
    @Test
    public void selectByBookId() {
       List<Evaluation> evaluationList= evaluationService.selectByBookId(1l);
      for(Evaluation e:evaluationList)  {
            System.out.println(e);
        }
    }

    @Test
    public void paging() {
        IPage<Evaluation> pageObject = evaluationService.paging("enable","score" ,2, 10);
        List<Evaluation> records = pageObject.getRecords();
        for(Evaluation b:records){
            System.out.println(b.getEvaluationId() + ":" + b.getContent());
        }
        System.out.println("总页数:" + pageObject.getPages());
        System.out.println("总记录数:" + pageObject.getTotal());
    }
    @Test
    public void disable(){
        evaluationService.disableEvaluation(2138l,"a");
    }
    @Test
    public void revoke(){
        evaluationService.revoke(2138l);
    }
}