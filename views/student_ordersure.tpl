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
<form class="layui-form layui-form-pane1">
	<div class="layui-form-item">
	    <span class="layui-breadcrumb" lay-separator="-">
		  <a href="">选购菜品</a>
		  <a style="font-size:18px;"><cite>结算</cite></a>
		  <a href="">线下取餐</a>		 
		</span>
	</div>	
  <div class="layui-form-item">
    <table class="layui-table" id="List">					
	</table>
    <!--<table class="layui-table" lay-filter="demo" lay-data="{id: 'idTest'}">
	  <thead>
	    <tr>
	      <th lay-data="{field:'name', width:100}">菜品</th>
	      <th lay-data="{field:'num', width:100}">份数</th>
	      <th lay-data="{field:'price'}">单价</th>
	    </tr> 
	  </thead>
	</table>-->
  </div>
  <div class="layui-form-item">
    <div class="layui-input-block">
      <label class="layui-form-label" id="sum">合计:</label>
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

  //获取url中的参数
        function getUrlParam(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
            var r = window.location.search.substr(1).match(reg);  //匹配目标参数
            if (r != null) return  decodeURIComponent(r[2]); return null; //返回参数值
        }		   
	//初始化
 	$(function(){
		var l=[]
		//var data =getUrlParam('data')
		var price =getUrlParam('price');
		var name =getUrlParam('name');
		var num =getUrlParam('num');
		var sum=0;
		var a=[{"name":"宫保鸡丁","price":1,"num":2,"sum":2}]
		var list= price.split('|');
		var list1= name.split('|');
		var list2= num.split('|');
		//data=data.replace(/\"/g,"%22");
    	//console.log("data:"+JSON.parse(list[0]))
		for(var i=0;i<list.length-1;i++){
				//l.push(JSON.parse(list[i]));
				//l.push(list[i]);
				var arr  =
					     {
					         "name" : list1[i],
					         "price" : list[i],
							 "num":list2[i],
					     }
						//var json = jQstringify(student);
				l.push(arr)
				
			}
		  console.log("l:"+l)
		  table.render({
		    elem: '#List'
			,id: 'listReload'
			,data: l
		    ,cols: [[ //表头
		      {field:'name', width:80, title:'商品'}
			  ,{field:'price', width:60, title:'单价'}
		      ,{field:'num', width:60, title:'数量'}
		    ]]
			,size:'sm'
		  });
		 //总计
			for(var i=0;i<l.length;i++){
				sum+=list[i]*list2[i]
			}	
			console.log(sum)			
			$("#sum").text("合计:"+sum+"元")
		
	});
	//var a=[{"name":"宫保鸡丁","price":1,"num":2,"sum":2}]
	
 
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
	
});
</script>

</body>
</html>