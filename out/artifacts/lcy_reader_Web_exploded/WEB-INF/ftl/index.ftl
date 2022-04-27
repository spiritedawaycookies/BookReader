<!DOCTYPE html>
<html lang="en"><head>
    <meta charset="UTF-8">
    <title>Book Reviews</title>
    <meta name="viewport" content="width=device-width,initial-scale=1.0, maximum-scale=1.0,user-scalable=no">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <link rel="stylesheet" href="./resources/raty/lib/jquery.raty.css">
    <script src="https://code.jquery.com/jquery-3.6.0.js" integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk=" crossorigin="anonymous"></script>

    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
    <script src="./resources/art-template.js"></script>
	<script src="./resources/raty/lib/jquery.raty.js"></script>
    <style>
        .highlight {
            color: #007bff !important;
        }

        a:active{
            text-decoration: none!important;
        }
    </style>
    

    <style>
        .container {
            padding: 0px;
            margin: 0px;
        }

        .row {
            padding: 0px;
            margin: 0px;
        }

        .col- * {
            padding: 0px;
        }
    </style>
    <#--定义模板-->
    <script type="text/html" id="tpl">
        <a href="/book/{{bookId}}" style="color: inherit">
            <div class="row mt-2 book">
                <div class="col-4 mb-2 pr-2">
                    <img class="img-fluid" src="{{cover}}">
                </div>
                <div class="col-8  mb-2 pl-0">
                    <h5 class="text-truncate">{{bookName}}</h5>

                    <div class="mb-2 bg-light small  p-2 w-100 text-truncate">Author : {{author}}</div>
                    {{set temp=subTitle.substring(0,100);}}
                    {{set parts = temp.split(' ').slice(0,15);}}
                    <div class="mb-2 w-100">{{parts.join(" ")}} ...</div>

                    <p>
                        <span class="stars" data-score="{{evaluationScore}}" title="gorgeous"></span>
                        <span class="mt-2 ml-2">{{evaluationScore}}</span>
                        <span class="mt-2 ml-2">{{evaluationQuantity}} reviews</span>
                    </p>
                </div>
            </div>
        </a>

        <hr>
    </script>

    <script>
        $.fn.raty.defaults.path ="./resources/raty/lib/images";
        //loadMore()加载更多数据
        //isReset参数设置为true,代表从第一页开始查询,否则按nextPage查询后续页
        function loadMore(isReset){
            if(isReset == true){
                //把原有的信息先清空更新
                $("#bookList").html("");
                //设置nextpage
                $("#nextPage").val(1);
            }
            var nextPage = $("#nextPage").val();
            var categoryId= $("#categoryId").val();
            var order = $("#order").val();

            $.ajax({
                url : "/books" ,
                //把参数传到服务器上
                data : {p:nextPage,"categoryId":categoryId , "order":order},
                type : "get" ,
                dataType : "json" ,
                success : function(json){
                    console.info(json);
                    var list = json.records;
                    for(var i = 0 ; i < list.length ; i++){
                        var book = json.records[i];
                        // var html = "<li>" + book.bookName + "</li>";
                        //将数据结合tpl模板,生成html
                        var html = template("tpl" , book);
                        //console.info(html);
                        $("#bookList").append(html);
                    }
                    //显示星型评价组件
                    $(".stars").raty({readOnly:true});

                    //判断是否到最后一页
                    if(json.current < json.pages){
                        $("#nextPage").val(parseInt(json.current) + 1);
                        $("#btnMore").show();
                        $("#divNoMore").hide();
                    }else{
                        $("#btnMore").hide();
                        $("#divNoMore").show();
                    }
                }
            })
        }
        $(function(){
            /*$.ajax({
                url : "/books" ,
                data : {p:1},
                type : "get" ,
                dataType : "json" ,
                success : function(json){
                    console.info(json);
                    var list = json.records;
                    for(var i = 0 ; i < list.length ; i++){
                        var book = json.records[i];
                        // var html = "<li>" + book.bookName + "</li>";
                        //将数据结合tpl模板,生成html
                        var html = template("tpl" , book);
                        console.info(html);
                        $("#bookList").append(html);
                    }
                    //显示星型评价组件
                    $(".stars").raty({readOnly:true});
                }
            })*/
            loadMore(true);
        })

        //绑定加载更多按钮单击事件
        $(function(){
            $("#btnMore").click(function(){
                loadMore();
            })

            $(".category").click(function () {
                $(".category").removeClass("highlight");
                $(".category").addClass("text-black-50");
                $(this).addClass("highlight");
                var categoryId = $(this).data("category");
                $("#categoryId").val(categoryId);
                loadMore(true);
            })
// 排序分类
            $(".order").click(function(){
                $(".order").removeClass("highlight");
                // $(".order").addClass("text-white");

                $(this).addClass("highlight");
                //设置隐藏域
                var order = $(this).data("order");
                $("#order").val(order);
                if(order=="quantity") {
                    $("#dropdownMenuButton").text("By Popularity");
                }else{
                    $("#dropdownMenuButton").text("By Rating");
                }
                loadMore(true);
            })
        })
    </script>
</head>
<body>
<div class="container">
    <nav class="navbar navbar-light bg-white shadow mr-auto">
        <ul class="nav">
            <li class="nav-item">
                <a href="/">
                    <img src="./images/logo.png" class="mt-1" style="width: 150px">
                </a>
            </li>

        </ul>
            <#if loginMember??>
                <h6 class="mt-1">
                    <img style="width: 2rem;margin-top: -5px" class="mr-1" src="./images/user_icon.png">${loginMember.nickname}
                </h6>
            <#else>
                <a href="/login.html" class="btn btn-outline-dark">
                    <img style="width: 2rem;margin-top: -5px" class="mr-1" src="./images/user_icon.png">Login
                </a>
            </#if>

    </nav>
    <div class="row mt-2">


        <div class="col-8 mt-2">
            <h3 style="font-weight: bold">Recommendations</h3>
        </div>

        <div class="col-8 mt-2">
                <span data-category="-1" style="cursor: pointer" class="highlight  font-weight-bold category">All</span>
                |
                <#list categoryList as category>
                <a style="cursor: pointer" data-category="${category.categoryId}" class="text-black-50 font-weight-bold category">${category.categoryName}</a>
                <#if category_has_next>|</#if>
                </#list>
                    

        </div>
        <!-- Dropdown Button -->
        <div class=" col-8 mt-2 dropdown">
            <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                Sort by
            </button>
            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                <a class=" order highligh ttext-black-50 dropdown-item" data-order="quantity">Popularity</a>
                <a class="order text-black-50 dropdown-item" data-order="score">Rating</a>
            </div>
        </div>
        <script>
            $('.dropdown-toggle').dropdown(function(){
                console.log("dropdown")
            })
        </script>

<#--        <div class="col-8 mt-2">-->
<#--            Sort by-->
<#--            <button type="button" data-order="quantity" style="cursor: pointer;" class="order  btn btn-secondary ">Popularity</button>-->

<#--            <button type="button" data-order="score" style="cursor: pointer;" class="order  btn btn-secondary">Rating</button>-->
<#--&lt;#&ndash;            <span data-order="quantity" style="cursor: pointer" class="order highlight  font-weight-bold mr-3">By Popularity</span>&ndash;&gt;-->

<#--&lt;#&ndash;            <span data-order="score" style="cursor: pointer" class="order text-black-50 mr-3 font-weight-bold">By Ratings</span>&ndash;&gt;-->
<#--        </div>-->
    </div>
    <div class="d-none">
        <input type="hidden" id="nextPage" value="2">
        <input type="hidden" id="categoryId" value="-1">
        <input type="hidden" id="order" value="quantity">
    </div>
<!--书的列表-->
    <div id="bookList">
    


    </div>
    <button type="button" id="btnMore" data-next-page="1" class="mb-5 btn btn-outline-primary btn-lg btn-block">
        Load more...
    </button>
    <div id="divNoMore" class="text-center text-black-50 mb-5" style="display: none;">No data</div>
</div>

</body></html>