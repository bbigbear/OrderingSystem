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
<!--          <img src="../static/img/admin.jpg" class="layui-nav-img">-->
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
        <li class="layui-nav-item"><a href="/v1/student_index?sid=<<<.sid>>>">订餐</a></li>
        <li class="layui-nav-item"><a href="/v1/student_order?sid=<<<.sid>>>">我的订单</a></li>
      </ul>
    </div>
  </div>
  <div class="layui-body">
    <!-- 内容主体区域 -->
    <div style="padding: 15px;">
		<form class="layui-form layui-form-pane1" action="" onsubmit="javascript:return false;">				  
		  <<<range $i,$e:=.mt_info>>>
					<blockquote class="layui-elem-quote"><<<$e.Name>>></blockquote>	
					<div class="layui-form-item">									
					<<<range $.rd_info>>>
						<<<if eq .Mname $e.Name>>>										
							<div class="layui-inline">
<!--							    <label class="layui-form-label"><<<.Dname>>></label>-->
							    <div class="layui-input-inline" style="width:100px;height:100px;">
									<div><img src="/<<<.Pic>>>" id="room_img_'+<<<.Id>>>+'" id="room_img_'+<<<.Id>>>+'" style="width:80px;height:80px;"></div>
									<div><p><span style="font-size: 15px;"><<<.Dname>>></span></p></div>
									<div><p><span style="font-size: 15px;">￥<<<.Price>>></span> <i class="layui-icon" id="<<<.Id>>>" style="font-size: 20px;padding-left:5px;cursor:pointer;">&#xe608;</i></p></div>
							    </div>
							</div>			  
						<<<end>>>									
					<<<end>>>
					</div>
			<<<end>>>
		</form>
		<div class="runtest">
		  <!--<textarea class="site-demo-text" id="testmain">
			layer.open({
			  title: '在线调试'
			  ,content: '可以填写任意的layer代码'
			});     
		  </textarea>-->
			<div class="site-demo-text" id="testmain">
				<div>
					<span class="layui-breadcrumb" lay-separator="|">										  					
						<i class="layui-icon">&#xe640;</i>
						<a id="dish_del">删除</a>
					</span>
				</div>
				<table id="List" lay-filter="bar">				
				</table>
				<script type="text/html" id="barDemo">
				  <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>				  				
				</script>
				<label class="layui-form-label" id="sum">合计:</label>
		  	<a href="javascript:;" class="layui-btn layui-btn-normal" id="btns">确认下单</a>
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
	.site-demo-text{display:block; width: 320px; height: 160px; border: 10px solid #F8F8F8; border-top-width: 0; padding: 10px;line-height:20px; overflow:auto; background-color: #f2f2f2;  font-size:12px; font-family:Courier New;}
	#btns{position: absolute; right: 20px; bottom: 20px;}
</style>

<script src="/static/layui.js"></script>
<script src="http://cdn.static.runoob.com/libs/jquery/2.1.1/jquery.min.js"></script>
<script src="https://cdn.bootcss.com/jquery-cookie/1.4.1/jquery.cookie.js"></script>
<script src="https://cdn.bootcss.com/Base64/1.0.1/base64.js"></script>
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
		if($.cookie('user')!=1){
			window.location.href="/"
		}		
		<<<range .map>>>
			$('#demo').append('<div class="layui-input-inline" style="width:150px;height:150px;"><div><img src="'+"/"+<<<.RoomPicPath>>>+'" id="room_img_'+<<<.Id>>>+'" style="width:100px;height:100px;"></div><div><p><b><<<.Name>>></b></p></div></div>')
			$("#room_img_"+<<<.Id>>>).bind('click',function(){             
                layer.msg(<<<.Id>>>)
             });		
		<<<end>>>
	});
	var sum=0
	//var list_map = new Array();
	var a={"name":"宫保鸡丁","price":1,"num":2,"sum":2}
	//var b={"name":"宫保鸡丁","price":1,"num":2,"sum":2}
	var data = []
	var name_data = []
		
	function jQstringify( obj ) {
		var arr = [];
		$.each( obj, function( key, val ) {
		var next = key + ": ";
		next += $.isPlainObject( val ) ? printObj( val ) : val;
		arr.push( next );
		});
		return "{ " + arr.join( ", " ) + " }";
	};
	//判断是否相同
	function isInArray(arr,value){
	    for(var i = 0; i < arr.length; i++){
	        if(value === arr[i]){
	            return true;
	        }
	    }
	    return false;
	}
	
	<<<range $i,$e:=.mt_info>>>													
			<<<range $.rd_info>>>
				<<<if eq .Mname $e.Name>>>										
					$('#<<<.Id>>>').on('click',function(){						
						//console.log(name_data)
						var dname=<<<.Dname>>>
						var sum=0
						if (isInArray(name_data,dname)){
							console.log("相同")
							for(var i=0;i<data.length;i++){
								if(dname==data[i]["name"]){
									data[i]["num"]+=1
									data[i]["sum"]=data[i]["num"]*data[i]["price"]
								}
								sum+=data[i]["sum"]
							}
							table.reload('listReload',{
								data:data
							});
							console.log(data)
							console.log(sum)
							$("#sum").text("合计:"+sum)	
							return							
						}
						name_data.push(<<<.Dname>>>)
						//console.log(name_data)
						var arr  =
					     {
					         "name" : <<<.Dname>>>,
					         "price" : <<<.Price>>>,
							 "num" : 1,
							 "sum" : <<<.Price>>>
					     }
						//var json = jQstringify(student);
						data.push(arr)
						console.log(data)
						table.reload('listReload',{
							data:data
						});
						//总计
						for(var i=0;i<data.length;i++){
							sum+=data[i]["sum"]
						}	
						console.log(sum)			
						$("#sum").text("合计:"+sum+"元")									
									        
					});
				<<<end>>>									
			<<<end>>>
	<<<end>>>
	//
	//table 渲染
	  table.render({
	    elem: '#List'
		,id: 'listReload'
		,data: a
	    ,cols: [[ //表头
		  {type:'checkbox', fixed: 'left'}
	      ,{field:'name', width:80, title:'商品'}
		  ,{field:'price', width:60, title:'单价'}
	      ,{field:'num', width:60, title:'数量'}
		  ,{field:'sum', width:60, title:'金额'}
		 // ,{fixed:'right', title:'删除', toolbar: '#barDemo'}
	    ]]
		,size:'sm'
	  });
	//监听工具条
	table.on('tool(bar)', function(obj){ //注：tool是工具条 事件名，test是table原始容器的属性 lay-filter="对应的值"
	  var data = obj.data; //获得当前行数据
	  var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
	  var tr = obj.tr; //获得当前行 tr 的DOM对象	 
	  if(layEvent === 'del'){ //删除
	    layer.confirm('真的删除行么', function(index){
	      obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
	      layer.close(index);
	      //向服务端发送删除指令
	    });
	  }
	});
		
	$('#search').on('click',function(){
		//layer.msg("点击搜索按钮");
		 // var cname=$("#cname").val();
		  //var rname=$("#rname").val();
		  //window.location.href="/v1/student_index?cname="+cname+"&rname="+rname;		  		
	});	
	
	//
	$('#btns').on('click',function(){
		//layer.msg("点击下单按钮")
		var str="";
		var str_name="";
		var str_price="";
		var str_num="";
		var checkStatus=table.checkStatus('listReload')
		,data=checkStatus.data;		
		console.log(data)
		if(data.length==0){
			alert("请选择要结账的菜品")
		}else{
			//iframe窗
			for(var i=0;i<data.length;i++){
				str+=JSON.stringify(data[i])+"|";
				str_name+=data[i]["name"]+"|";
				str_price+=data[i]["price"]+"|";
				str_num+=data[i]["num"]+"|";
			}
			console.log("str:"+str)
			//window.location.href="/v1/student_ordersure?data="+str;		
			//str={\"name\":\"青瓜炒肉\",\"price\":4,\"num\":1,\"sum\":4}|
			layer.open({
			  type: 2,
			  title: '订单确认',
			  //closeBtn: 0, //不显示关闭按钮
			  shadeClose: true,
			  area: ['450px', '400px'],
			 // offset: 'rb', //右下角弹出
			  //time: 2000, //2秒后自动关闭
			  maxmin: true,
			  anim: 2,
			  content: ['/v1/student_ordersure?name='+str_name+'&price='+str_price+'&num='+str_num+'&rid='+<<<.id>>>+'&sid='+<<<.sid>>>+'&readyid='+<<<.readyId>>>,'no'], //iframe的url，no代表不显示滚动条
			  cancel: function(index, layero){
				  //if(confirm('确定要关闭么')){ //只有当点击confirm框的确定时，该层才会关闭
				    layer.close(index)				
				  //}
				  return false; 
			  },
			});
		}
		
	});
	//点击删除
	$('#dish_del').on('click',function(){
		//alert("删除")
		var str="";
		var checkStatus=table.checkStatus('listReload')
		,data1=checkStatus.data;		
		console.log(data1)
		if(data1.length==0){
			alert("请选择要删除的菜品")
		}else{
			for(var i=0;i<data1.length;i++){
				//数据剔除
				data.splice(i,1);
				//名字也去除
				name_data.splice(data[i]["name"],1);
			}
			console.log(data)
			layer.confirm('是否删除这'+data1.length+'条数据?',{icon:3,title:'提示'},function(index){								
				table.reload('listReload',{
							data:data
						});
				layer.close(index);
			});			
		}
		return false;
	});
	//悬浮窗口
	var debug = $('#L_layerDebug'), popDebug = function(){
    layer.open({
      type: 1
      ,title: '购物车'
      ,id: 'Lay_layer_debug'
      ,content: $('.runtest')
      ,shade: false
      ,offset: 'rb'
	  ,closeBtn: 0
	  //,maxmin: true
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