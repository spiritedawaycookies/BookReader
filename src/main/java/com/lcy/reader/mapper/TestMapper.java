package com.lcy.reader.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.lcy.reader.entity.Test;

public interface TestMapper extends BaseMapper<Test> {
    public void insertSample();
}
