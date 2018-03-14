<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>新增食堂</title>
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
	<div style="padding: 15px;">
	  	<blockquote class="layui-elem-quote" style="margin-top:10px;">备餐记录</blockquote>			
		<div style="padding-bottom:5px;">
			<a style="padding-right:10px;">按类别：</a>
			<span class="layui-breadcrumb" lay-separator="|" style="font-size:30px;">
			  <a id="all">不限</a>
			  {{range .map}}
			  <a id="{{.Id}}">{{.Name}}</a>
			  {{end}}
			</span>
		</div>
		<table id="dishList" lay-filter="room"></table>
		<script type="text/html" id="barDemo">
			<a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="edit">详情</a>
			<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
		</script>
		<form class="layui-form layui-form-pane1" action="" onsubmit="javascript:return false;">
		  <div class="layui-form-item">
		    <label class="layui-form-label">备餐份数</label>
		    <div class="layui-input-block">
			<input type="text" name="number" id="number" autocomplete="off" class="layui-input" style="width:50px">
		    </div>
		  </div>
		  <div class="layui-form-item">
		    <div class="layui-input-block">
		      <button class="layui-btn" id="add">确认</button>
		      <button type="reset" class="layui-btn layui-btn-primary">取消</button>
		    </div>
		  </div>
		</form>
	</div>
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
	//批量添加
	$('#add').on('click',function(){
		//layer.msg({{.mname}})		
		var str="";
		var str_img="";
		var str_price="";
		var number=$("#number").val();		
		var checkStatus=table.checkStatus('listReload')
		,data=checkStatus.data;
		if(data.length==0){
			alert("请选择要添加的菜品")
		}else if(number==""){
			alert("请输入备餐份数")
		}else{
			for(var i=0;i<data.length;i++){
				str+=data[i].Name+",";
				str_img+=data[i].DishPicPath+",";
				str_price+=data[i].Price+",";
			}
			layer.confirm('是否添加这'+data.length+'个菜品?',{icon:3,title:'提示'},function(index){
				//window.location.href="/v1/delmultidata?id="+str+"";
				$.ajax({
					type:"POST",
					url:"/v1/restaurant_ready/AddMultiReadyDish",
					data:{
						tid:{{.tid}},
						dname:str,
						mname:{{.mname}},
						number:parseInt(number),
						pic:str_img,
						price:str_price,						
					},
					async:false,
					error:function(request){
						alert("post error")						
					},
					success:function(res){
						if(res.code==200){
							alert("添加成功")	
							//重载表格
							table.reload('listReload', {							  
							});												
						}else{
							alert("添加失败")
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