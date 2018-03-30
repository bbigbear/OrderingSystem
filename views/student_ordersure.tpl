<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>订单确认</title>
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
<form class="layui-form layui-form-pane1" action="">
	<div class="layui-form-item">
	    <span class="layui-breadcrumb" lay-separator="-">
		  <a href="">选购菜品</a>
		  <a style="font-size:18px;"><cite>结算</cite></a>
		  <a href="">线下取餐</a>		 
		</span>
	</div>	
  <div class="layui-form-item">
    <table lay-filter="demo">
	  <thead>
	    <tr>
	      <th lay-data="{field:'dish', width:100}">菜品</th>
	      <th lay-data="{field:'num', width:100}">份数</th>
	      <th lay-data="{field:'price'}">单价</th>
	    </tr> 
	  </thead>
	  <tbody>
	    <tr>
	      <td>宫保鸡丁</td>
	      <td>1</td>
	      <td>￥10</td>
	    </tr>
	  </tbody>
	</table>
  </div>
  <div class="layui-form-item">
    <div class="layui-input-block">
      <label class="layui-form-label">合计:</label>
    </div>
  </div>
  <div class="layui-form-item">
    <div class="layui-input-block">
      <button class="layui-btn" id="add">确认下单</button>
<!--	  <input type="hidden" id="pic_path">-->
      <button type="reset" class="layui-btn layui-btn-primary">取消</button>
    </div>
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
  
	$('#add').on('click',function(){
		var data={
			'campusName':{{.campus_name}},
			'name':$("#name").val()
			};
		console.log(data)
		$.ajax({
			type:"POST",
			contentType:"application/json;charset=utf-8",
			url:"/v1/canteen/add_action",
			data:JSON.stringify(data),
			async:false,
			error:function(request){
				alert("post error")						
			},
			success:function(res){
				if(res.code==200){
					alert("新增成功")
					window.location.reload();					
				}else{
					alert("新增失败")
				}						
			}
		});
		return false;
	});
	//转换静态表格
	table.init('demo', {
	  height: 120 //设置高度
	  ,limit: 10 //注意：请务必确保 limit 参数（默认：10）是与你服务端限定的数据条数一致
	  //支持所有基础参数
	});
});
</script>

</body>
</html>