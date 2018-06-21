<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<title>智慧校园订餐系统</title>
<link rel="stylesheet" href="/static/css/layui.css">
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <!-- 内容主体区域 -->
    <div style="padding: 15px;">	  		    
		    <div class="layui-tab-item layui-show">
				<form class="layui-form layui-form-pane1" action="" onsubmit="javascript:return false;">
				  <div class="layui-form-item">
					<div class="layui-inline">
				      <label class="layui-form-label" style="width:100px;">更改模板名称</label>
				      <div class="layui-input-inline">
				        <input type="text" class="layui-input" id="name">
				      </div>
					  <div class="layui-inline">
				        <button class="layui-btn" id="save">保存</button>
				      </div>
				    </div> 
				  </div>
				  <div style="padding: 15px;">
					<<<range $i,$e:=.mt_info>>>
					<blockquote class="layui-elem-quote"><<<$e.Name>>></blockquote>	
					<div class="layui-form-item">
					<button class="layui-btn layui-btn-primary" id=<<<$e.Id>>>><i class="layui-icon">&#xe654;</i></button>									
					<<<range $.rd_info>>>
						<<<if eq .Mname $e.Name>>>										
							<div class="layui-inline">
								<i class="layui-icon" id="rd_<<<.Id>>>"  style="font-size: 20px; color: #FF5722;">&#x1007;</i>
							    <label class="layui-form-label"><<<.Dname>>></label>
							    <div class="layui-input-inline" style="width:40px;">
							        <input type="text" name="price_min" value=<<<.Number>>> autocomplete="off" class="layui-input">
							    </div>
							</div>			  
						<<<end>>>								
					<<<end>>>
					</div>
					<hr class="layui-bg-green">
					<<<end>>>
					<!--<table id="timeList" lay-filter="time"></table>
					<script type="text/html" id="barDemo">
						<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
					</script>-->
					</div>
				</form>			
			</div>		
	</div>
</div>
<style>
	.layui-tab-title li:first-child > i {
		display: none;
		disabled:true
	}
</style>

<script src="/static/layui.js"></script>
<!--<script src="http://cdn.static.runoob.com/libs/jquery/2.1.1/jquery.min.js"></script>-->
<script src="http://cdn.static.runoob.com/libs/jquery/2.1.1/jquery.min.js"></script>
<script src="https://cdn.bootcss.com/jquery-cookie/1.4.1/jquery.cookie.js"></script>
<script src="https://cdn.bootcss.com/Base64/1.0.1/base64.js"></script>
<script>
	//JavaScript代码区域
	layui.use(['element','layer','jquery','table','laydate'], function(){
	  var element = layui.element
		,laydate=layui.laydate
		,layer=layui.layer
		,$=layui.jquery
		,table=layui.table
		,form=layui.form;
	  //layer.msg("你好");
	
	$(function(){
		if($.cookie('user')!=1){
			window.location.href="/"
		}
	})
	$('#save').on('click',function(){
		//alert("点击保存")
		var jsData={'id':<<<.tid>>>,'name':$('#name').val(),}
			$.post('/v1/restaurant_ready/edittemp_action', jsData, function (out) {
                if (out.code == 200) {
                    layer.alert('更新成功', {icon: 1},function(index){
                        layer.close(index);
                    });
                } else {
                    layer.msg(out.message)
                }
            }, "json");
	});	
	<<<range $.rd_info>>>
		$('#rd_<<<.Id>>>').on('click',function(){
			//alert("点击删除<<<.Id>>>")
			var jsData={'id':<<<.Id>>>}
			$.post('/v1/restaurant_ready/delreadydish', jsData, function (out) {
                if (out.code == 200) {
                    layer.alert('删除成功了', {icon: 1},function(index){
                        layer.close(index);
						//form.render();
						location.reload();
                    });
                } else {
                    layer.msg(out.message)
                }
            }, "json");
		});						
	<<<end>>>
	
	var rid=<<<.id>>>
	var tid=<<<.tid>>>
	<<<range .mt_info>>>
	$('#<<<.Id>>>').on('click',function(){
		//iframe窗
		layer.open({
		  type: 2,
		  title: '添加菜品',
		  //closeBtn: 0, //不显示关闭按钮
		  shadeClose: true,
		  area:  ['893px', '600px'],
		 // offset: 'rb', //右下角弹出
		  //time: 2000, //2秒后自动关闭
		  maxmin: true,
		  anim: 2,
		  content: ['/v1/restaurant_ready/addreadydish?id='+rid+'&mname=<<<.Name>>>&tid='+tid], //iframe的url，no代表不显示滚动条
		  cancel: function(index, layero){ 
			  //if(confirm('确定要关闭么')){ //只有当点击confirm框的确定时，该层才会关闭
			    layer.close(index)
				window.location.reload();				
			 // }
			  return false; 
		  },
		});
	});
	<<<end>>>
  });

	
	
</script>

</body>
</html>