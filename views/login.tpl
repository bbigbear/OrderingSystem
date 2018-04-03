<!DOCTYPE html>
<html>
	<head>
		<title>智慧校园订餐系统</title>
		<link rel="stylesheet" type="text/css" href="/static/css/bootstrap.min.css">
	</head>
	<body>
		<div class="container" style="width:300px;padding-top:150px">
			<form class="form-signin">
		        <h2 class="form-signin-heading">订餐系统</h2>
				<br>
		        <label for="inputAccount" class="sr-only">帐号</label>
		        <input id="inputAccount" class="form-control" placeholder="帐号" required autofocus name="inputAccount">
		        <label for="inputPassword" class="sr-only">密码</label>
		        <input type="password" id="inputPassword" class="form-control" placeholder="密码" required name="inputPassword">
		        <div id="role">
		          	<label class="radio-inline">
					  <input type="radio" name="optionsRadios" id="school" value="school" checked>学校管理员	
					</label>
					<label class="radio-inline">
					  <input type="radio" name="optionsRadios" id="room" value="room">餐厅管理员	
					</label>
					<label class="radio-inline">
					  <input type="radio" name="optionsRadios" id="student" value="student">学生	
					</label>
		        </div>
				<br>
		        <button class="btn btn-lg btn-success btn-block" id="login">登陆</button>
	      	</form>
		</div>
		<script src="http://cdn.static.runoob.com/libs/jquery/2.1.1/jquery.min.js"></script>
		<script>
			var role=$('#role input:radio:checked').val();
			$('#login').on('click',function(){			
				$.ajax({
					type:"POST",
					url:"/login_action",
					data:{
						inputAccount:$("#inputAccount").val(),
						inputPassword:$("#inputPassword").val(),
						role:role
					},
					async:false,
					error:function(request){
						alert("post error")						
					},
					success:function(res){
						if(res.code==200){
							alert("登录成功")
							//window.location.href="/"																			
						}else{
							alert("账户密码错误")
						}						
					}					
				});	
				return false;						
		  	});
		</script>
	</body>
</html>
