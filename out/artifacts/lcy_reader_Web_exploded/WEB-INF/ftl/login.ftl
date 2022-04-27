<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login-Books</title>
    <meta name="viewport" content="width=device-width,initial-scale=1.0, maximum-scale=1.0,user-scalable=no">
    <link rel="stylesheet" href="./resources/bootstrap/bootstrap.css">
    <link rel="stylesheet" href="./resources/raty/lib/jquery.raty.css">

    <script src="https://code.jquery.com/jquery-3.6.0.js" integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk=" crossorigin="anonymous"></script>
    <script src="./resources/bootstrap/bootstrap.min.js"></script>
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

        .description p {
            text-indent: 2em;
        }

        .description img {
            width: 100%;
        }

    </style>

</head>
<body>
<!--<div style="width: 375px;margin-left: auto;margin-right: auto;">-->
<div class="container">
    <nav class="navbar navbar-light bg-white shadow">
        <ul class="nav">
            <li class="nav-item">
                <a href="/">
                    <img src="./images/logo.png" class="mt-1"
                         style="width: 100px">
                </a>
            </li>
        </ul>
        <a class="btn btn-outline-dark" href="/register.html">Register</a>
    </nav>


    <div class="container mt-2 p-2 m-0">
        <form id="frmLogin">
            <div class="passport bg-white">
                <h4 class="float-left">Login</h4>

                <div class="clearfix"></div>
                <div class="alert d-none mt-2" id="tips" role="alert">

                </div>

                <div class="input-group  mt-2 ">
                    <input type="text" id="username" name="username" class="form-control p-4" placeholder="Enter username"
                           aria-label="Username" aria-describedby="basic-addon1">
                </div>

                <div class="input-group  mt-4 ">
                    <input id="password" name="password" class="form-control p-4" placeholder="Enter password" type="password"
                           aria-describedby="basic-addon1">
                </div>

                <div class="input-group mt-4 ">
                    <div class="col-5 p-0">
                        <input type="text" id="verifyCode" name="vc" class="form-control p-4" placeholder="Captcha">
                    </div>
                    <div class="col-4 p-0 pl-2 pt-0">
                        <img id="imgVerifyCode" src="/verify_code"
                             style="width: 120px;height:50px;cursor: pointer">
                    </div>

                </div>

                <a id="btnSubmit" class="btn btn-primary  btn-block mt-4 text-white pt-3 pb-3">Login</a>
            </div>
        </form>

    </div>
</div>

<script>
    function showTips(isShow, css, text) {
        if (isShow) {
            $("#tips").removeClass("d-none")
            $("#tips").hide();
            $("#tips").addClass(css);
            $("#tips").text(text);
            $("#tips").fadeIn(200);
        } else {
            $("#tips").text("");
            $("#tips").fadeOut(200);
            $("#tips").removeClass();
            $("#tips").addClass("alert")
        }
    }

    function reloadVerifyCode() {
        //后面的要求是ts时间戳,get请求容易被浏览器缓存,所以需要使每次url不一样(使更新就加个参数)
        $("#imgVerifyCode").attr("src", "/verify_code?ts=" + new Date().getTime());
    }

    $("#imgVerifyCode").click(function () {
        reloadVerifyCode();
    });

    $("#btnSubmit").click(function () {
        var username = $.trim($("#username").val());
        var regex = /^.{1,10}$/;
        if (!regex.test(username)) {
            showTips(true, "alert-danger", "Please enter correct format（1-10 characters）");
            return;
        } else {
            showTips(false);
        }

        var password = $.trim($("#password").val());

        if (!regex.test(password)) {
            showTips(true, "alert-danger", "Please enter correct password（1-10 characters）");
            return;
        } else {
            showTips(false);
        }

        $btnReg = $(this);

        $btnReg.text("Processing...");
        $btnReg.attr("disabled", "disabled");
        $.ajax({
            url: "/check_login",
            type: "post",
            dataType: "json",
            data: $("#frmLogin").serialize(),
            success: function (data) {
                console.info(data);
                if (data.code == "0") {
                    window.location = "/?ts=" + new Date().getTime();
                } else {
                    showTips(true, "alert-danger", data.msg);
                    reloadVerifyCode();
                    $btnReg.html("Login");
                    $btnReg.removeAttr("disabled");
                }
            }
        });
        return false;
    });


</script>
</body>
</html>