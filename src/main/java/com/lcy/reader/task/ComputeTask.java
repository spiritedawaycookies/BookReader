package com.lcy.reader.task;

import com.lcy.reader.service.BookService;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;

/**
 * 完成自动计算任务
 */
@Component
public class ComputeTask {
    @Resource
    private BookService bookService;
    //任务调度
    @Scheduled(cron = "0 * * * * ?")
    public void updateEvaluation(){
        bookService.updateEvaluation();
        System.out.println("已更新所有图书评分");
    }
}
