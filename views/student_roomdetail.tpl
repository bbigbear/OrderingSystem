<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="renderer" content="webkit">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<title>智慧校园订餐系统</title>
<link rel="stylesheet" href="/static/css/layui.css"  media="all">
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
  <div class="layui-header">
    <div class="layui-logo">订餐系统</div>
    <ul class="layui-nav layui-layout-right">
      <li class="layui-nav-item">
        <a href="javascript:;">
          <img src="../static/img/admin.jpg" class="layui-nav-img">
          学生
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
        <li class="layui-nav-item"><a href="/v1/student_index">订餐</a></li>
        <li class="layui-nav-item"><a href="/v1/student_order">我的订单</a></li>
      </ul>
    </div>
  </div>
  <div class="layui-body">
    <!-- 内容主体区域 -->
    <div style="padding: 15px;">
		<blockquote class="layui-elem-quote">食堂选择</blockquote>
		<form class="layui-form layui-form-pane1" action="" onsubmit="javascript:return false;">		
		  <div class="layui-form-item">
			<label class="layui-form-label">选择类型</label>
		    <div class="layui-input-inline">
				<select name="cname" id="cname" lay-filter="campus_select">
		          <option value="第一食堂">第一食堂</option>
		          <option value="第二食堂">第二食堂</option>
		        </select>
			</div>
			<div class="layui-input-inline" style="margin-left:100px;">
				<input type="text" name="rname" id="rname" placeholder="请输入餐厅名称" autocomplete="off" class="layui-input">
			</div>
			<div class="layui-input-inline" >
		      <button class="layui-btn" id="search">搜索</button>
		  	</div>
		  </div>
		  {{range $i,$e:=.mt_info}}
					<blockquote class="layui-elem-quote">{{$e.Name}}</blockquote>	
					<div class="layui-form-item">									
					{{range $.rd_info}}
						{{if eq .Mname $e.Name}}										
							<div class="layui-inline">
<!--							    <label class="layui-form-label">{{.Dname}}</label>-->
							    <div class="layui-input-inline" style="width:100px;height:100px;">
									<div><img src="/{{.Pic}}" id="room_img_'+{{.Id}}+'" id="room_img_'+{{.Id}}+'" style="width:80px;height:80px;"></div>
									<div><p>{{.Dname}}</p></div>
									<div><p>￥{{.Price}} <i class="layui-icon">&#xe654;</i></p></div>
							    </div>
							</div>			  
						{{end}}									
					{{end}}
					</div>
			{{end}}
		</form>
		<div class="runtest">
		  <textarea class="site-demo-text" id="testmain">
			layer.open({
			  title: '在线调试'
			  ,content: '可以填写任意的layer代码'
			});     
		  </textarea>
		  <a href="javascript:;" class="layui-btn layui-btn-normal" onclick="try{new Function(testmain.value)();}catch(e){alert('语句异常：'+e.message)}" class="btns">确认下单</a>
		</div>
		
<!--		<ul class="flow-default" id="LAY_demo1"></ul>-->
		
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
	.runtest{position: relative; display:none;}
	.runtest textarea{display:block; width: 300px; height: 160px; border: 10px solid #F8F8F8; border-top-width: 0; padding: 10px; line-height:20px; overflow:auto; background-color: #3F3F3F; color: #eee; font-size:12px; font-family:Courier New;}
	.runtest a{position: absolute; right: 20px; bottom: 20px;}
</style>

<script src="/static/layui.js"></script>
<!--<script src="http://cdn.static.runoob.com/libs/jquery/2.1.1/jquery.min.js"></script>-->
<script>
	//JavaScript代码区域
	layui.use(['element','layer','jquery','table','flow'], function(){
	  var element = layui.element
		,layer=layui.layer
		,$=layui.jquery
		,table=layui.table
		,form=layui.form
		,flow=layui.flow;
	  //layer.msg("你好");
	    	//初始化
 	$(function(){		
		{{range .map}}
			$('#demo').append('<div class="layui-input-inline" style="width:150px;height:150px;"><div><img src="'+"/"+{{.RoomPicPath}}+'" id="room_img_'+{{.Id}}+'" style="width:100px;height:100px;"></div><div><p><b>{{.Name}}</b></p></div></div>')
			$("#room_img_"+{{.Id}}).bind('click',function(){             
                layer.msg({{.Id}})
             });		
		{{end}}
	});
		
	$('#search').on('click',function(){
		layer.msg("点击搜索按钮");
		  var cname=$("#cname").val();
		  var rname=$("#rname").val();
		  window.location.href="/v1/student_index?cname="+cname+"&rname="+rname;		  		
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
	
	var debug = $('#L_layerDebug'), popDebug = function(){
    layer.open({
      type: 1
      ,title: '购物车'
      ,id: 'Lay_layer_debug'
      ,content: $('.runtest')
      ,shade: false
      ,offset: 'rb'
	  ,closeBtn: 0
      ,resize: false
      ,success: function(layero, index){
        layer.style(index, {
          marginLeft: 0
        });
        debug.hide();
      }
      ,end: function(){
        debug.show();
      }
    });
    	testmain.focus();
  	};
  
  	 debug.on('click', popDebug);
	 popDebug();
  });

	
	
</script>

</body>
</html>