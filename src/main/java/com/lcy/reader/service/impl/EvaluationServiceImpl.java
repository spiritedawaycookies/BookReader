package com.lcy.reader.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.lcy.reader.entity.Book;
import com.lcy.reader.entity.Evaluation;
import com.lcy.reader.entity.Member;
import com.lcy.reader.mapper.BookMapper;
import com.lcy.reader.mapper.EvaluationMapper;
import com.lcy.reader.mapper.MemberMapper;
import com.lcy.reader.service.EvaluationService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

@Service("evaluationService")
@Transactional(propagation = Propagation.NOT_SUPPORTED,readOnly = true)
public class EvaluationServiceImpl implements EvaluationService {
    @Resource
    private EvaluationMapper evaluationMapper;
    @Resource
    private MemberMapper memberMapper;
    @Resource
    private BookMapper bookMapper;
    /**
     * 按图书编号查询有效短评
     *
     * @param bookId 图书编号
     * @return 评论列表
     */
    public List<Evaluation> selectByBookId(Long bookId) {
        Book book = bookMapper.selectById(bookId);
        QueryWrapper<Evaluation> queryWrapper = new QueryWrapper<Evaluation>();
        queryWrapper.eq("book_id", bookId);
        queryWrapper.eq("state", "enable");
        queryWrapper.orderByDesc("create_time");
        List<Evaluation> evaluationList = evaluationMapper.selectList(queryWrapper);
        for(Evaluation eva:evaluationList){
            Member member = memberMapper.selectById(eva.getMemberId());
            eva.setMember(member);
            eva.setBook(book);
        }
        return evaluationList;
    }
    public IPage<Evaluation> paging(String order,Integer page, Integer rows) {
        Page<Evaluation> p = new Page<Evaluation>(page, rows);
        QueryWrapper<Evaluation> queryWrapper = new QueryWrapper <Evaluation>();
        if(order != null){
            if(order.equals("enjoys")){
                queryWrapper.orderByDesc("enjoy");
            }else if(order.equals("score")){
                queryWrapper.orderByDesc("score");
            }
            else queryWrapper.orderByDesc("create_time");
        }else queryWrapper.orderByDesc("create_time");
        IPage<Evaluation> pageObject = evaluationMapper.selectPage(p, queryWrapper);
        return pageObject;
    }
    public IPage<Evaluation> paging(String state , String order , Integer page, Integer rows) {
        Page<Evaluation> p = new Page<Evaluation>(page, rows);
        QueryWrapper<Evaluation> queryWrapper = new QueryWrapper <Evaluation>();
        if(state.equals("enable")){
            queryWrapper.eq("state", state);
        }
        if(order != null){
            if(order.equals("enjoys")){
                queryWrapper.orderByDesc("enjoy");
            }else if(order.equals("score")){
                queryWrapper.orderByDesc("score");
            }
        }
        IPage<Evaluation> pageObject = evaluationMapper.selectPage(p, queryWrapper);
        return pageObject;
    }
    public Evaluation selectById(Long evaluationId){
        Evaluation evaluation=evaluationMapper.selectById(evaluationId);
        return evaluation;
    }

    public void disableEvaluation(Long evaluationId,String disableReason) {
        Evaluation evaluation=evaluationMapper.selectById(evaluationId);
        evaluation.setState("disable");
        evaluation.setDisableReason(disableReason);
        evaluation.setDisableTime(new Date());
        evaluationMapper.updateById(evaluation);
    }

    public void revoke(Long evaluationId) {
        Evaluation evaluation= evaluationMapper.selectById(evaluationId);
        evaluation.setState("enable");
        evaluation.setDisableReason("");
        evaluationMapper.updateById(evaluation);
    }
}
