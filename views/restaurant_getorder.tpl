<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>查看订单</title>
  <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <meta name="apple-mobile-web-app-status-bar-style" content="black"> 
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="format-detection" content="telephone=no">

  <link rel="stylesheet" href="/static/css/layui.css">

<style>
body{padding: 10px;}
</style>
</head>
<body>
<form class="layui-form layui-form-pane1">	
  <div class="layui-form-item" style="width:425px;">
    <table id="List" lay-filter="order"></table>
	<script type="text/html" id="barDemo">
		<a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="edit">详情</a>
	</script>
  </div>
</form>

<br><br><br>


<script src="/static/layui.js"></script>
<!-- <script src="../build/lay/dest/layui.all.js"></script> -->

<script>
layui.use(['form','laydate','upload','jquery','layedit','element','table'], function(){
  var form = layui.form
  ,laydate=layui.laydate
  ,upload = layui.upload
  , $ = layui.jquery
  ,layedit=layui.layedit
  ,element=layui.element
  ,table=layui.table;

  //table 渲染
	  table.render({
	    elem: '#List'
	    ,height: 315
	    ,url: '/v1/restaurant_ready/getorder_action?readyid={{.readyid}}' //数据接口
	    //,page: true //开启分页
		,id: 'listReload'
	    ,cols: [[ //表头		  
	      {field:'Oid', title:'订单编号', width:140}
	      ,{field:'Sname',  title:'购买人', width:80}
	      ,{field:'Ostatus', title:'订单状态', width:120}
		  ,{fixed: 'right', title:'操作',width:80, align:'center', toolbar: '#barDemo'}
	    ]]
		,size:'sm'
	  });
	//监听工具条
		table.on('tool(order)', function(obj){ //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
		    var data = obj.data //获得当前行数据
		    ,layEvent = obj.event; //获得 lay-event 对应的值
		    if(layEvent === 'edit'){
		      //layer.msg('查看操作');		
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