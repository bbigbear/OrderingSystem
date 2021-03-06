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
  <div class="layui-header">
    <div class="layui-logo">订餐系统</div>
    <!-- 头部区域（可配合layui已有的水平导航） -->
    <!--<ul class="layui-nav layui-layout-left">
      <li class="layui-nav-item"><a href="">个人中心</a></li>
      <li class="layui-nav-item"><a href="">内容管理</a></li>
      <li class="layui-nav-item"><a href="">统计报表</a></li>
	  <li class="layui-nav-item"><a href="">客服管理</a></li>
      <li class="layui-nav-item">
        <a href="javascript:;">系统管理</a>
        <dl class="layui-nav-child">
          <dd><a href="">邮件管理</a></dd>
          <dd><a href="">消息管理</a></dd>
          <dd><a href="">授权管理</a></dd>
        </dl>
      </li>
    </ul>-->
    <ul class="layui-nav layui-layout-right">
      <li class="layui-nav-item">
        <a href="javascript:;">
          <img src="../static/img/admin.jpg" class="layui-nav-img">
          学校管理员
        </a>
        <dl class="layui-nav-child">
          <dd><a href="">基本资料</a></dd>
          <dd><a href="">安全设置</a></dd>
        </dl>
      </li>
      <li class="layui-nav-item"><a href="/">退出</a></li>
    </ul>
  </div>
  
  <div class="layui-side layui-bg-black">
    <div class="layui-side-scroll">
      <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
      <ul class="layui-nav layui-nav-tree"  lay-filter="test">
        <li class="layui-nav-item"><a href="/v1/canteen">食堂管理</a></li>
        <li class="layui-nav-item"><a href="/v1/dining_room">餐厅管理</a></li>
        <li class="layui-nav-item"><a href="/v1/dining_time">供应时段</a></li>
      </ul>
    </div>
  </div>
  <div class="layui-body">
    <!-- 内容主体区域 -->
    <div style="padding: 15px;">
		<blockquote class="layui-elem-quote">餐厅管理</blockquote>
		<form class="layui-form layui-form-pane1" action="">		
		  <div class="layui-form-item">
			<label class="layui-form-label">选择校区</label>
		    <div class="layui-input-inline">
				<select name="campus" id="campus" lay-filter="campus_select">
		          <<<range .campus_info>>>
				    <option value= <<<.Name>>> > <<<.Name>>> </option>
				  <<<end>>>
		        </select>
			</div>			
			<label class="layui-form-label">选择食堂</label>
			<div class="layui-input-inline">
				<select name="canteen" id="canteen" lay-filter="canteen_select">				  
		        </select>
			</div>
		  </div>
		  <div class="layui-form-item">
		    <label class="layui-form-label">是否营业</label>
		    <div class="layui-input-block">
		      <input  lay-filter="iswork" type="checkbox" name="switch" lay-skin="switch" lay-text="是|否" checked>
		    </div>
		  </div> 	
		</form>
		<blockquote class="layui-elem-quote">食堂餐厅</blockquote>
		<button class="layui-btn" id="addroom">添加窗口</button>
		<hr class="layui-bg-green">
		<table id="roomList" lay-filter="room"></table>
		<script type="text/html" id="barDemo">
			<a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="edit">详情</a>			
			<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
			{{#  if(d.Status =="未营业" ){ }}
			    <a class="layui-btn layui-btn-xs" lay-event="start">恢复</a>
			{{#  }else{ }}
				<a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="stop">停业</a>
			{{#  } }}
		</script>
		<hr class="layui-bg-green">		
	</div>
  </div>
  
  <div class="layui-footer">
    <!-- 底部固定区域 -->
    ©2018 智慧校园. All Rights Reserved
  </div>
</div>
<style>
	.layui-tab-title li:first-child > i {
		display: none;
		disabled:true
	}
	.laytable-cell-1-RoomPicPath{  /*最后的pic为字段的field*/
      height: 100%;
      max-width: 100%;
    } 
</style>

<script src="/static/layui.js"></script>
<!--<script src="http://cdn.static.runoob.com/libs/jquery/2.1.1/jquery.min.js"></script>-->
<script src="http://cdn.static.runoob.com/libs/jquery/2.1.1/jquery.min.js"></script>
<script src="https://cdn.bootcss.com/jquery-cookie/1.4.1/jquery.cookie.js"></script>
<script src="https://cdn.bootcss.com/Base64/1.0.1/base64.js"></script>
<script>
	//JavaScript代码区域
	layui.use(['element','layer','jquery','table','laytpl'], function(){
	  var element = layui.element
		,form=layui.form
		,layer=layui.layer
		,$=layui.jquery
		,table=layui.table
		,laytpl = layui.laytpl;
	  //layer.msg("你好");
	//自动加载
	$(function(){
		if($.cookie('user')!=1){
			window.location.href="/"
		}
		if(<<<.campus>>>!=""){
			$("#campus").val(<<<.campus>>>);			
			form.render('select');	
		}
	});
	
	//获取下拉列表
	form.on('select(campus_select)',function(data){
		 $.getJSON("/v1/dining_room/getcampus?campus="+data.value, function(data){
                var optionstring = "";
                $.each(data.data, function(i,item){
                    optionstring += "<option value=\"" + item.Name + "\" >" + item.Name + "</option>";
                });
                $("#canteen").html('<option value=""></option>' + optionstring);
                form.render('select'); //这个很重要
            });	
	});
	
	//点击新增按钮
	$('#addroom').on('click',function(){
		//layer.msg("点击添加按钮");
		var cp=$("#campus").val();
		//iframe窗
		layer.open({
		  type: 2,
		  title: '新增餐厅',
		  //closeBtn: 0, //不显示关闭按钮
		  shadeClose: true,
		  shade: false,
		  area: ['893px', '600px'],
		 // offset: 'rb', //右下角弹出
		  //time: 2000, //2秒后自动关闭
		  maxmin: true,
		  anim: 2,
		  content: ['/v1/dining_room/add?campus='+cp], //iframe的url，no代表不显示滚动条
		  cancel: function(index, layero){ 
		  //if(confirm('确定要关闭么')){ //只有当点击confirm框的确定时，该层才会关闭
		    layer.close(index)
			//window.parent.location.reload();
			//重载表格
			table.reload('listReload', {});
		  //}
		  return false; 
		  },
		});
	});
	
	  //table 渲染
	  table.render({
	    elem: '#roomList'
	    ,height: 315
	    ,url: '/v1/dining_room/getdata' //数据接口
	   // ,page: true //开启分页
		,id: 'listReload'
	    ,cols: [[ //表头
		  {field: 'RoomPicPath', title: '窗口图片', width:120,height:80
			,templet:function(d){
				var list=d.RoomPicPath.split(',')
				//alert(list.length)
				if(list.length!=1){
					for(var i=0;i<list.length-1;i++){
						return '<img style="width:120;height:80;" src="'+'/'+list[i]+'">'				
					}
				}else{
					return ""	
				}						
			}}
	      ,{field:'Name', title:'窗口名称', width:120}
	      ,{field:'Status',  title:'状态', width:120}
	      ,{field:'Time', title:'供应时段', width:150}
		  ,{fixed: 'right', title:'操作',width:200, align:'center', toolbar: '#barDemo'}
	    ]]
	  });		
		//监听工具条
		table.on('tool(room)', function(obj){ //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
		    var data = obj.data //获得当前行数据
		    ,layEvent = obj.event; //获得 lay-event 对应的值
		    if(layEvent === 'edit'){
		      //layer.msg('查看操作');		
			  layer.open({
			  type: 2,
			  title: '查看菜品',
			  //closeBtn: 0, //不显示关闭按钮
			  shadeClose: true,
			  shade: false,
			  area: ['893px', '600px'],
			 // offset: 'rb', //右下角弹出
			  //time: 2000, //2秒后自动关闭
			  maxmin: true,
			  anim: 2,
			  content: ['/v1/dining_room/edit?id='+data.Id], //iframe的url，no代表不显示滚动条
			  cancel: function(index, layero){ 
			 // if(confirm('确定要关闭么')){ //只有当点击confirm框的确定时，该层才会关闭
			    layer.close(index)
			  //}
			  return false; 
			  },
		});
	    } else if(layEvent === 'del'){
	      layer.confirm('真的删除行么', function(index){
	        var jsData={'id':data.Id}
			$.post('/v1/dining_room/del', jsData, function (out) {
                if (out.code == 200) {
                    layer.alert('删除成功了', {icon: 1},function(index){
                        layer.close(index);
                        table.reload({});
                    });
                } else {
                    layer.msg(out.message)
                }
            }, "json");
			obj.del(); //删除对应行（tr）的DOM结构
	        layer.close(index);
	        //向服务端发送删除指令
	      });
	    } else if(layEvent === 'stop'){
	      layer.confirm('真的停业么', function(index){
	        var jsData={'id':data.Id,'status':"未营业"}
			$.post('/v1/dining_room/stop', jsData, function (out) {
                if (out.code == 200) {
                    layer.alert('停业成功了', {icon: 1},function(index){
                        layer.close(index);
                        //table.reload({});
						window.location.reload();
                    });
                } else {
                    layer.msg(out.message)
                }
            }, "json");
			//obj.del(); //删除对应行（tr）的DOM结构
	        layer.close(index);
	        //向服务端发送删除指令
	      });					  
	    }else if(layEvent === 'start'){
	      layer.confirm('真的恢复么', function(index){
	        var jsData={'id':data.Id,'status':"营业中"}
			$.post('/v1/dining_room/stop', jsData, function (out) {
                if (out.code == 200) {
                    layer.alert('恢复成功了', {icon: 1},function(index){
                        layer.close(index);
                        //table.reload({});
						window.location.reload();
                    });
                } else {
                    layer.msg(out.message)
                }
            }, "json");
			//obj.del(); //删除对应行（tr）的DOM结构
	        layer.close(index);
	        //向服务端发送删除指令
	      });					  
	    }
	  });	
		
		//重新加载
		//点击检索按钮
		form.on('switch(iswork)', function(data){
			var status		
			if(data.elem.checked){
				status="营业中"
			}else{
				status="未营业"
			}
			table.reload('listReload', {
	                    where: {
	                        status: status,
							cname:$("#campus").val(),
							rname:$("#canteen").val(),
	                    }
	                });
		}); 
			
  });

	
	
</script>

</body>
</html>