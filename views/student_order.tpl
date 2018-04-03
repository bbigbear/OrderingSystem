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
		<blockquote class="layui-elem-quote">我的订单</blockquote>		
		<table id="orderList" lay-filter="order"></table>
		<script type="text/html" id="barDemo">
			<a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="edit">订单详情</a>
		</script>
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
		,layer=layui.layer
		,$=layui.jquery
		,table=layui.table
		,form=layui.form;
	 
	//table 渲染
	  table.render({
	    elem: '#orderList'
	    ,height: 315
	    ,url: '/v1/student_order/getdata?sid=1'//数据接口
	    ,page: true //开启分页
		,id: 'listReload'
	    ,cols: [[ //表头	  
	      {field:'Oid', title:'订单号', width:120}
		  ,{field:'Otime', title:'订单时间', width:120}
		  ,{field:'Rname', title:'商家', width:120}
	      ,{field:'Ostatus',  title:'状态', width:120}
		  ,{field:'Total',  title:'金额', width:120}
		  ,{fixed: 'right', title:'操作',width:200, align:'center', toolbar: '#barDemo'}
	    ]]
	  });
	//监听工具条
	table.on('tool(order)', function(obj){ //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
	  var data = obj.data; //获得当前行数据
	  var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
	  var tr = obj.tr; //获得当前行 tr 的DOM对象	 
	  if(layEvent === 'edit'){ //
	    layer.open({
			  type: 2,
			  title: '订单详情',
			  //closeBtn: 0, //不显示关闭按钮
			  shadeClose: true,
			  area: ['800px', '600px'],
			 // offset: 'rb', //右下角弹出
			  //time: 2000, //2秒后自动关闭
			  maxmin: true,
			  anim: 2,
			  content: ['/v1/student_orderdetail?oid='+data.Oid,'no'], //iframe的url，no代表不显示滚动条
			  cancel: function(index, layero){
				  if(confirm('确定要关闭么')){ //只有当点击confirm框的确定时，该层才会关闭
				    layer.close(index)				
				  }
				  return false; 
			  },
			});
	  }
	});
	
  });
  	
</script>

</body>
</html>