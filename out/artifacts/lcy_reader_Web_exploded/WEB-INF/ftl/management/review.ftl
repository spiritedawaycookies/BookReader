<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reviews Management</title>
    <style>
        #dlgReview {
            padding: 10px
        }
    </style>
    <link rel="stylesheet" href="/resources/layui/css/layui.css">
    <script src="/resources/jquery.3.3.1.min.js"></script>
    <script src="/resources/jquery.i18n.properties.min.js"></script>
    <script src="/resources/wangEditor.min.js"></script>


    <script type="text/html" id="toolbar">
        <div class="layui-btn-container">

        </div>
    </script>

</head>
<body>


<div class="layui-container">
    <blockquote class="layui-elem-quote">Review List</blockquote>
    <!-- 数据表格 -->
    <table id="grdReview" lay-filter="grdReview"></table>
</div>
<div>

</div>
<!--表单内容-->
<div id="dialog" style="padding: 10px;display: none">
    <form class="layui-form">


        <div class="layui-form-item">
            <div style="margin-top: 30px;font-size: 130%">Disable reason</div>

            <textarea id="disableReason" name="disableReason" lay-verify="required" autocomplete="off"
                      placeholder="Enter disable reason" lay-verType="tips" class="layui-textarea"></textarea>

        </div>


        <!-- 编号 -->
        <input id="evaluationId" type="hidden">

        <div class="layui-form-item" style="text-align: center">
            <!-- 提交按钮 -->
            <button class="layui-btn" lay-submit="" lay-filter="btnSubmit">Submit</button>
        </div>
    </form>
</div>
<script src="/resources/layui/layui.all.js"></script>
<script>

    var table = layui.table; //table数据表格对象
    var $ = layui.$; //jQuery

    //初始化图书列表
    table.render({
        elem: '#grdReview'  //指定div
        , id: "reviewList" //数据表格id
        , toolbar: "#toolbar" //指定工具栏,包含新增添加
        , url: "/management/review/list" //数据接口
        , page: true //开启分页
        , cols: [[ //表头
            {field: 'content', title: 'Content', width: '300'}
            , {field: 'score', title: 'Score', width: '100'}
            , {field: 'enjoy', title: 'Thumbs Up', width: '100'}
            , {
                field: 'createTime',
                title: 'Create Time',
                templet: function (data) {

                    return layui.util.toDateString(data.createTime, 'MM-dd-yyyy HH:mm');

                },
                width: '150'
            }
            , {
                field: 'disableTime',
                title: 'Disable Time',
                templet: function (data) {
                    //console.log(data);
                    if (data.disableTime == null) return "";
                    else {
                        return layui.util.toDateString(data.disableTime, 'MM-dd-yyyy HH:mm');
                    }
                },
                width: '150'
            }
            , {field: 'disableReason', title: 'Disable Reason', width: '200'}


            , {
                type: 'space', title: 'Operation', width: '100', templet: function (d) {
                    // console.log(d);
                    if (d.state == "disable")
                        return "<button id='revokeBtn' class='layui-btn layui-btn-sm btn-update' type='submit' data-id='" + d.evaluationId + "' onclick='revoke(this)'>Revoke</button>";
                    //为每一行表格数据生成"disable"按钮,并附加data-id属性代表编号
                    return "<button class='layui-btn layui-btn-sm btn-update'  data-id='" + d.evaluationId + "' data-type='update' onclick='showDisable(this)'>Disable</button>";
                }
            }
        ]]
    });

    function revoke(obj) {

        var evaluationId = $("#revokeBtn").data('id');
        console.log(evaluationId);
        //向服务器发送请求
        $.post("/management/review/revoke", {"evaluationId": evaluationId}, function (json) {
            console.log("sucess");
            if (json.code == "0") {
                //处理成功,刷新列表,提示操作成功

                table.reload('reviewList');
                layui.layer.msg('Success');
            } else {
                //处理失败,提示错误信息
                layui.layer.msg(json.msg);
            }
        }, "json")


    }

    //obj对应点击的"修改"按钮对象
    function showDisable(obj) {

        layui.layer.open({
            id: "dlgReview", //指定div
            title: "Disable Review", //标题
            type: 1,
            content: $('#dialog').html(), //设置对话框内容,复制自dialog DIV
            area: ['820px', '300px'], //设置对话框宽度高度
            resize: false //是否允许调整尺寸
        })

        var evaluationId = $(obj).data("id"); //获取"修改"按钮附带的图书编号
        $("#dlgReview #evaluationId").val(evaluationId); //为表单隐藏域赋值,提交表单时用到


        layui.form.render();


    }


    //对话框表单提交
    layui.form.on('submit(btnSubmit)', function (data) {
        //获取表单数据
        var formData = data.field;


        formData.evaluationId = $("#dlgReview #evaluationId").val();
        formData.disableReason = $("#dlgReview #disableReason").val();
        console.log(formData);
        //向服务器发送请求
        $.post("/management/review/disable", formData, function (json) {
            if (json.code == "0") {
                //处理成功,关闭对话框,刷新列表,提示操作成功
                layui.layer.closeAll();
                table.reload('reviewList');
                layui.layer.msg('Success');
            } else {
                //处理失败,提示错误信息
                layui.layer.msg(json.msg);
            }
        }, "json")
        return false;
    });


</script>
</body>
</html>