package com.lcy.reader.service;

import com.baomidou.mybatisplus.core.metadata.IPage;

import com.lcy.reader.entity.Evaluation;

import java.util.List;

public interface EvaluationService {
    /**
     * 按图书编号查询有效短评
     * @param bookId 图书编号
     * @return 评论列表
     */
    public List<Evaluation> selectByBookId(Long bookId);
    public IPage<Evaluation> paging(String state , String order , Integer page, Integer rows);
    public IPage<Evaluation> paging(String order,Integer page, Integer rows);
    public Evaluation selectById(Long evaluationId);
    public void disableEvaluation(Long evaluationId,String disableReason);
    public void revoke(Long evaluationId);
}
