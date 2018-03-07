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
				      <label class="layui-form-label">模板名称</label>
				      <div class="layui-input-inline">
				        <input type="text" class="layui-input" id="time">
				      </div>
					  <div class="layui-inline">
				        <button class="layui-btn" id="save">保存</button>
				      </div>  
				    </div> 
				  </div>
				  <div style="padding: 15px;">
					{{range $i,$e:=.mt_info}}
					<blockquote class="layui-elem-quote">{{$e.Name}}</blockquote>	
					<div class="layui-form-item">
					<button class="layui-btn layui-btn-primary" id={{$e.Id}}><i class="layui-icon">&#xe654;</i></button>									
					{{range $.rd_info}}
						{{if eq .Mname $e.Name}}										
							<div class="layui-inline">
							    <label class="layui-form-label">{{.Dname}}</label>
							    <div class="layui-input-inline" style="width:40px;">
							        <input type="text" name="price_min" value={{.Number}} autocomplete="off" class="layui-input">
							    </div>
							</div>			  
						{{end}}									
					{{end}}
					</div>
					<hr class="layui-bg-green">
					{{end}}
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
	//时间范围
	  laydate.render({
	    elem: '#time'
	    ,type: 'time'
	    ,range: true
	  });
	  
	  laydate.render({
	    elem: '#date'
	    ,type: 'date'
	  });
	
	 laydate.render({
	    elem: '#date1'
	    ,type: 'date'
	  });
	
	//自动加载
	$(function(){
		//layer.msg({{.campus}});
		if({{.campus}}!=""){
			//layer.msg({{.campus}});
			$("#campus").val({{.campus}});
			//$("select[name=campus_select]").val({{.campus}});
			form.render('select');	
		}				
	});
	
	$('#addCanteen').on('click',function(){
		//layer.msg("点击添加按钮");
		//获取校区
		var cp=$("#campus").val();
		//iframe窗
		layer.open({
		  type: 2,
		  title: '新增食堂',
		  //closeBtn: 0, //不显示关闭按钮
		  shadeClose: true,
		  area: ['450px', '150px'],
		 // offset: 'rb', //右下角弹出
		  //time: 2000, //2秒后自动关闭
		  maxmin: true,
		  anim: 2,
		  content: ['/v1/canteen/add?campus='+cp,'no'], //iframe的url，no代表不显示滚动条
		  cancel: function(index, layero){ 
			  if(confirm('确定要关闭么')){ //只有当点击confirm框的确定时，该层才会关闭
			    layer.close(index)
				window.location.reload();				
			  }
			  return false; 
		  },
		});
	});	
	//获取下拉列表
	form.on('select(campus_select)',function(data){
		//layer.msg(data)
		console.log(data.value);
		window.location.href="/v1/canteen?campus="+data.value;
		
	});
	//
	{{range .canteen_info}}
	$('#{{.Id}}').on('click',function(){
		//var dc=$("#delCanteen").val();
		//layer.msg({{.Name}});
		if(confirm('确定要删除该食堂？')){ //只有当点击confirm框的确定时，该层才会关闭
			//layer.close(index)
			//window.location.reload();
			//layer.msg({{.Name}});
			//window.location.href="/v1/canteen/del?id="+{{.Id}};
			var jsData={'id':{{.Id}}}
			$.post('/v1/canteen/del', jsData, function (out) {
                if (out.code == 200) {
                    window.location.href="/v1/canteen?campus="+{{.CampusName}};
                } else {
                    layer.msg(out.message)
                }
            }, "json");	
	        //向服务端发送删除指令
		}
	});
	{{end}}
	var rid={{.id}}
	var tid={{.tid}}
	{{range .mt_info}}
	$('#{{.Id}}').on('click',function(){
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
		  content: ['/v1/restaurant_ready/addreadydish?id='+rid+'&mname={{.Name}}&tid='+tid], //iframe的url，no代表不显示滚动条
		  cancel: function(index, layero){ 
			  if(confirm('确定要关闭么')){ //只有当点击confirm框的确定时，该层才会关闭
			    layer.close(index)
				window.location.reload();				
			  }
			  return false; 
		  },
		});
	});
	{{end}}
  });

	
	
</script>

</body>
</html>