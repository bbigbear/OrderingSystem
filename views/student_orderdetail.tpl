<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<title>智慧校园订餐系统</title>
<link rel="stylesheet" href="/static/css/layui.css">
</head>
<body class="layui-layout-body">
   {{range .map}}
  <div class="layui-row" style="padding-top:20px;">
    <div class="layui-col-xs6">	 
      <form class="layui-form layui-form-pane1">
		<div class="layui-form-item">	
			<div class="layui-input-block">
		      <h2>{{.Rname}}</h2>	 
		    </div>		        
		</div>
		<div class="layui-form-item" style="padding-top:50px;">	
			<div class="layui-input-block">
		      订单状态:{{.Ostatus}}
		    </div>		        
		</div>
		<div class="layui-form-item">
			<div class="layui-input-block">
		      订单编号:{{.Oid}}
		    </div>	    
		</div>	
		<div class="layui-form-item">		
			<div class="layui-input-block">
		      订单类型:{{.Otype}}
		    </div>    
		</div>
		<div class="layui-form-item">		
			<div class="layui-input-block">
		      购买人:{{.Sname}}
		    </div>    
		</div>		
	   <div class="layui-form-item" style="width:330px;padding-left:100px;">
	    <table class="layui-table" id="List">					
		</table>
	   </div>
	  <div class="layui-form-item">
	    <div class="layui-input-block">
	      合计:{{.Total}}元
	    </div>
	  </div>
	</form>
    </div>
    <div class="layui-col-xs6"  style="padding-top:60px;">
      <div class="grid-demo">
	  <ul class="layui-timeline">
		  <li class="layui-timeline-item">
		    <i class="layui-icon layui-timeline-axis">&#xe63f;</i>
		    <div class="layui-timeline-content layui-text">
		      <h3 class="layui-timeline-title">8月18日</h3>
		      <p>已取餐</p>
		    </div>
		  </li>
		  <li class="layui-timeline-item">
		    <i class="layui-icon layui-timeline-axis">&#xe63f;</i>
		    <div class="layui-timeline-content layui-text">
		      <h3 class="layui-timeline-title">{{.Otime}}</h3>
		      <p>已下单</p>		      
		    </div>
		  </li>
		</ul>
	  </div>
    </div>
  </div>
  {{end}}
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
	    elem: '#List'
	    ,height: 130
	    ,url: '/v1/student_orderdetail/getlist?oid={{.oid}}'//数据接口
		,id: 'listReload'		
	    ,cols: [[ //表头	  
	      {field:'Name', title:'菜品', width:120}
		  ,{field:'Num', title:'份数', width:100}
		  ,{field:'Price', title:'单价', width:100}
	    ]]
		,size:'sm'
	  });
  });
		
</script>

</body>
</html>