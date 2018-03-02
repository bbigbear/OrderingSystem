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
      <li class="layui-nav-item"><a href="">退出</a></li>
    </ul>
  </div>
  
  <div class="layui-side layui-bg-black">
    <div class="layui-side-scroll">
      <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
      <ul class="layui-nav layui-nav-tree"  lay-filter="test">
        <li class="layui-nav-item"><a href="/v1/restaurant_dish?id={{.id}}">菜品库</a></li>
        <li class="layui-nav-item"><a href="/v1/restaurant_ready?id={{.id}}">备餐</a></li>
        <li class="layui-nav-item"><a href="/v1/restaurant_manage?id={{.id}}">管理</a></li>
      </ul>
    </div>
  </div>
  <div class="layui-body">
    <!-- 内容主体区域 -->
    <div style="padding: 15px;">		
		<div style="padding-bottom:50px;">
			<a style="padding-right:10px;">按类别：</a>
			<span class="layui-breadcrumb" lay-separator="|" style="font-size:30px;">
			  <a id="all">不限</a>
			  {{range .map}}
			  <a id="{{.Id}}">{{.Name}}</a>
			  {{end}}
			</span>
		</div>
		<blockquote class="layui-elem-quote">菜品信息</blockquote>
		<button class="layui-btn" id="addroom">新填菜品</button>
		<hr class="layui-bg-green">
		<div>
			<span class="layui-breadcrumb" lay-separator="|">										  					
				<i class="layui-icon">&#xe640;</i>
				<a id="dish_del">删除</a>
			</span>
		</div>
		<table id="dishList" lay-filter="room"></table>
		<script type="text/html" id="barDemo">
			<a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="edit">详情</a>
			<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
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
</style>

<script src="/static/layui.js"></script>
<!--<script src="http://cdn.static.runoob.com/libs/jquery/2.1.1/jquery.min.js"></script>-->
<script>
	//JavaScript代码区域
	layui.use(['element','layer','jquery','table'], function(){
	  var element = layui.element
		,form=layui.form
		,layer=layui.layer
		,$=layui.jquery
		,table=layui.table;
	  //layer.msg("你好");
	//自动加载
	$(function(){
		if({{.campus}}!=""){
			$("#campus").val({{.campus}});			
			form.render('select');	
		}				
	});
	
	//获取下拉列表
	form.on('select(campus_select)',function(data){
		//layer.msg(data)
		console.log(data.value);
		window.location.href="/v1/dining_room?campus="+data.value;
		
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
		  content: ['/v1/restaurant_dish/add?id='+{{.id}}], //iframe的url，no代表不显示滚动条
		  cancel: function(index, layero){ 
		  if(confirm('确定要关闭么')){ //只有当点击confirm框的确定时，该层才会关闭
		    layer.close(index)
			//window.parent.location.reload();
			//重载表格
			//table.reload('listReload', {});
			window.location.reload();
		  }
		  return false; 
		  },
		});
	});
	
	  //table 渲染
	  table.render({
	    elem: '#dishList'
	    ,height: 315
	    ,url: '/v1/restaurant_dish/getdata?id={{.id}}'//数据接口
	    ,page: true //开启分页
		,id: 'listReload'
	    ,cols: [[ //表头
		  {type:'checkbox', fixed: 'left'}
		  ,{field: 'DishPicPath', title: '菜品图片', width:'11%',height:'20%'
			,templet:function(d){
				var list=d.DishPicPath.split(',')
				//alert(list.length)
				if(list.length!=1){
					for(var i=0;i<list.length-1;i++){
						return '<img src="'+'/'+list[i]+'">'				
					}
				}else{
					return ""
				}						
			}}
	      ,{field:'Name', title:'菜品名称', width:120}
		  ,{field:'Price',  title:'价格', width:120}
	      ,{field:'Detail',  title:'描述', width:120}
		  ,{field:'DishType',  title:'类型', width:120}
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
			  content: ['/v1/restaurant_dish/edit?id='+data.Id+"&rid={{.id}}"], //iframe的url，no代表不显示滚动条
			  cancel: function(index, layero){ 
			  if(confirm('确定要关闭么')){ //只有当点击confirm框的确定时，该层才会关闭
			    layer.close(index)
				window.location.reload();
			  }
			  return false; 
			  },
		});
	    } else if(layEvent === 'del'){
	      layer.confirm('真的删除行么', function(index){
	        var jsData={'id':data.Id}
			$.post('/v1/restaurant_dish/del', jsData, function (out) {
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
	    }
	  });
	//点击不限
	$('#all').on('click',function(){
		window.location.reload();
	});	
	//点击检索按钮
	{{range .map}}
	$('#{{.Id}}').on('click',function(){
		//layer.msg({{.Name}})
                table.reload('listReload', {
                    where: {
                        dt: {{.Name}},
                    }
                });

	});	
	{{end}}
	
	//批量删除
	$('#dish_del').on('click',function(){				
		var str="";
		var checkStatus=table.checkStatus('listReload')
		,data=checkStatus.data;
		if(data.length==0){
			alert("请选择要删除的菜品")
		}else{
			for(var i=0;i<data.length;i++){
				str+=data[i].Id+",";
			}
			layer.confirm('是否删除这'+data.length+'条数据?',{icon:3,title:'提示'},function(index){
				//window.location.href="/v1/delmultidata?id="+str+"";
				$.ajax({
					type:"POST",
					url:"/v1/restaurant_dish/delmulti",
					data:{
						id:str	
					},
					async:false,
					error:function(request){
						alert("post error")						
					},
					success:function(res){
						if(res.code==200){
							alert("删除成功")	
							//重载表格
							table.reload('listReload', {							  
							});												
						}else{
							alert("删除失败")
						}						
					}					
				});				
				layer.close(index);
			});
		}
		return false;
	});
	
  });

	
	
</script>

</body>
</html>