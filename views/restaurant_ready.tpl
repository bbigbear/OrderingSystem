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
          餐厅管理员
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
        <li class="layui-nav-item"><a href="/v1/restaurant_dish?id=<<<.id>>>">菜品库</a></li>
        <li class="layui-nav-item"><a href="/v1/restaurant_ready?id=<<<.id>>>">备餐</a></li>
        <li class="layui-nav-item"><a href="/v1/restaurant_manage?id=<<<.id>>>">管理</a></li>
      </ul>
    </div>
  </div>
  <div class="layui-body">
    <!-- 内容主体区域 -->
    <div style="padding: 15px;">
		<div class="layui-tab layui-tab-card">
		  <ul class="layui-tab-title" lay-filter="demo">
		    <li class="layui-this">备餐</li>
		    <li lay-id="moban">模板</li>
		    <li>备餐记录</li>
		  </ul>
		  <div class="layui-tab-content" style="height: auto;">
		    <div class="layui-tab-item layui-show">
				<blockquote class="layui-elem-quote" style="margin-top:10px;">备餐</blockquote>	
				<form class="layui-form layui-form-pane1" action="" onsubmit="javascript:return false;">
					<div class="layui-form-item">
					    <label class="layui-form-label">*备餐时间：</label>
					    <div class="layui-input-inline" style="width: 120px;">
					        <input type="text" name="date" id="date" autocomplete="off" class="layui-input">		
					    </div>
						<div class="layui-input-inline" style="width: 80px;">
							<select name="timeinterval" id="timeinterval" lay-verType="tips" lay-filter="timeinterval">
					       	  <<<range .time>>>
							  <option value=<<<.Name>>>><<<.Name>>></option>
							  <<<end>>>
					        </select>
						</div>
						<label class="layui-form-label">*营业时间：</label>
					    <div class="layui-input-inline" style="width: 180px;">
							<select name="timeinterval" id="timeinterval" lay-verType="tips" lay-filter="timeinterval">
					       	  <<<range .time>>>
							  <option value=<<<.Time>>>><<<.Time>>></option>
							  <<<end>>>
					        </select>
<!--					        <input type="text" name="time" id="time" autocomplete="off" class="layui-input">		-->
					    </div>
					</div>
					<div class="layui-form-item">
					    <label class="layui-form-label">选择模板：</label>
						<div class="layui-input-inline" style="width: 200px;">
							<select name="tname" id="tname" lay-verType="tips">
					          <<<range .temp>>>
							  <option value=<<<.Name>>>><<<.Name>>></option>
							  <<<end>>>
					        </select>
						</div>					
					</div>
					  <div class="layui-form-item">
					    <div class="layui-input-block">
					      <button class="layui-btn" id="add_ready">备餐</button>
					    </div>
					  </div>
				</form>
			</div>
		    <div class="layui-tab-item">
				<blockquote class="layui-elem-quote" style="margin-top:10px;">预设模板</blockquote>	
				<table id="tempList" lay-filter="temp"></table>
				<script type="text/html" id="barDemo">
					<a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="edit">编辑菜品</a>
					<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
				</script>
				<div>
					<button class="layui-btn" id="add_temp">新增模板</button>
				</div>			
			</div>
		    <div class="layui-tab-item">
				<blockquote class="layui-elem-quote" style="margin-top:10px;">备餐记录</blockquote>	
				<div style="padding-bottom:10px;padding-left:10px;">
					<a style="padding-right:10px;">按类别：</a>
					<span class="layui-breadcrumb" lay-separator="|" style="font-size:30px;">
					  <a id="all">不限</a>
					  <<<range .maps_ti>>>
					  <a id="<<<.Id>>>"><<<.Name>>></a>
					  <<<end>>>
					</span>
					<div class="layui-input-inline" style="width: 150px;margin-left:100px;">
					    <input type="text" name="Stocks" id="date1" autocomplete="off" class="layui-input" placeholder="请输入日期">		
					</div>
				</div>
				
				<div class="layui-collapse">
				<<<range $i,$e:=.maps_ready>>>
				  <div class="layui-colla-item">
					<<<if eq $e.Status "未开始">>>
						<h2 class="layui-colla-title"><<<$e.Date>>>&nbsp;&nbsp;<<<$e.TimeInterval>>>&nbsp;&nbsp;<<<$e.Status>>> <a class="layui-btn layui-btn-normal layui-btn-xs" style="margin-left:100px;" id="<<<$e.Id>>>_undo">撤销</a></h2>	
					<<<else if eq $e.Status "已完成">>>
					    <h2 class="layui-colla-title"><<<$e.Date>>>&nbsp;&nbsp;<<<$e.TimeInterval>>>&nbsp;&nbsp;<<<$e.Status>>> <a class="layui-btn layui-btn-normal layui-btn-xs"  style="margin-left:100px;" id="<<<$e.Id>>>_order">查看订单</a></h2>
					<<<else>>>
					    <h2 class="layui-colla-title"><<<$e.Date>>>&nbsp;&nbsp;<<<$e.TimeInterval>>>&nbsp;&nbsp;<<<$e.Status>>> <a class="layui-btn layui-btn-normal layui-btn-xs"  style="margin-left:100px;" id="<<<$e.Id>>>_order">查看订单<span class="layui-badge-dot layui-bg-red"></span></a></h2>
					<<<end>>>				    			    
					<div class="layui-colla-content">
						<table class="layui-table" lay-size="sm">
						  <colgroup>
						    <col width="150">
						    <col width="200">
						    <col >
						  </colgroup>
						  <thead>							
						    <tr>
						      <th>菜品</th>
						      <th>份数</th>
						      <th>所在分类</th>
						    </tr>							
						  </thead>
						  <tbody>
							<<<range $.maps_rd>>>
								<<<if eq .Tid $e.Tid>>>
							    <tr>
							      <td><<<.Dname>>></td>
							      <td><<<.Number>>></td>
							      <td><<<.Mname>>></td>
							    </tr>
								<<<end>>>
							<<<end>>>						    
						  </tbody>
						</table>
					</div>
				  </div>
				<<<end>>>
				</div>
			</div>
		  </div>
		</div>			
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
<script src="http://cdn.static.runoob.com/libs/jquery/2.1.1/jquery.min.js"></script>
<script src="https://cdn.bootcss.com/jquery-cookie/1.4.1/jquery.cookie.js"></script>
<script src="https://cdn.bootcss.com/Base64/1.0.1/base64.js"></script>
<script>
	//JavaScript代码区域
	layui.use(['element','layer','jquery','table','laydate'], function(){
	  var element = layui.element
		,laydate=layui.laydate
		,layer=layui.layer
		,$=layui.jquery
		,table=layui.table
		,form=layui.form;
	  //layer.msg("你好");
	$(function(){
		if($.cookie('user')!=1){
			window.location.href="/"
		}
	})
	//时间范围
	  var ins1=laydate.render({
	    elem: '#time'
	    ,type: 'time'
	    ,range: true
		,change: function(value, date, endDate){
		    //console.log(value); //得到日期生成的值，如：2017-08-18
		    //console.log(date); //得到日期时间对象：{year: 2017, month: 8, date: 18, hours: 0, minutes: 0, seconds: 0}
		    //console.log(endDate); //得结束的日期时间对象，开启范围选择（range: true）才会返回。对象成员同上。
			if ((date.hours==endDate.hours)&&((endDate.minutes)-(date.minutes))<30){
				//alert("营业区间不小于30分钟")
				//$("#time").attr("value","");
				//document.getElementById("time").value="";	
				ins1.hint("营业区间不小于30分钟");
			}else if((date.hours>endDate.hours)){
				ins1.hint("前一时间不能晚于后一时间");
			}else if((date.hours==endDate.hours)&&(date.minutes>endDate.minutes)){
				ins1.hint("前一时间不能晚于后一时间");
			}else if((date.hours==endDate.hours)&&(date.minutes==endDate.minutes)&&(date.seconds>endDate.seconds)){
				ins1.hint("前一时间不能晚于后一时间");
			}
		}
	  });
	  
	  laydate.render({
	    elem: '#date'
	    ,type: 'date'
		,min: 0 //7天前
  		,max: 7 //7天后
	  });
	
	 laydate.render({
	    elem: '#date1'
	    ,type: 'date'
	  });
	
	//点击备餐
	$('#add_ready').on('click',function(){
		
		if($("#date").val()==""){
			alert("备餐时间不能为空")
		}else if($("#time").val()==""){
			alert("营业时间不能为空")
		}else{
			var data={
			'rid':parseInt(<<<.id>>>),
			'date':$("#date").val(),
			'timeInterval':$("#timeinterval").val(),
			'time':$("#time").val(),
			'tname':$("#tname").val(),
			'status':"未开始",
			};
			$.ajax({
				type:"POST",
				contentType:"application/json;charset=utf-8",
				url:"/v1/restaurant_ready/addready_action",
				data:JSON.stringify(data),
				async:false,
				error:function(request){
					alert("post error")						
				},
				success:function(res){
					if(res.code==200){
						alert("备餐成功")
						window.location.reload();						
					}else{
						alert("备餐失败")
					}						
				}
			});	
		}
			
	});
	
	//点击新增模板
	$('#add_temp').on('click',function(){
		//iframe窗
		layer.open({
		  type: 2,
		  title: '新增模板',
		  //closeBtn: 0, //不显示关闭按钮
		  shadeClose: true,
		  area: ['450px', '150px'],
		 // offset: 'rb', //右下角弹出
		  //time: 2000, //2秒后自动关闭
		  maxmin: true,
		  anim: 2,
		  content: ['/v1/restaurant_ready/addtempready?id=<<<.id>>>','no'], //iframe的url，no代表不显示滚动条
		  cancel: function(index, layero){ 
			  //if(confirm('确定要关闭么')){ //只有当点击confirm框的确定时，该层才会关闭
			    layer.close(index)
				location.reload();
				element.tabChange('demo', 'moban');			
			  //}
			  return false; 
		  },
		});		
		//window.location.href="/v1/restaurant_ready/addtempready?id="+<<<.id>>>;
		//window.location.href="/v1/restaurant_ready/addtemp?id="+<<<.id>>>;
		
	});
	//temp 渲染table
	table.render({
	    elem: '#tempList'
	    ,height: 315
	    ,url: '/v1/restaurant_ready/gettempdata?id=<<<.id>>>' //数据接口
	    //,page: true //开启分页
		,id: 'listReload'
	    ,cols: [[ //表头		  
	      {field:'Name', title:'模板名称', width:200}
		  ,{fixed: 'right', title:'操作',width:200, align:'center', toolbar: '#barDemo'}
	    ]]
	  });			//监听工具条
		table.on('tool(temp)', function(obj){ //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
		    var data = obj.data //获得当前行数据
		    ,layEvent = obj.event; //获得 lay-event 对应的值
		    if(layEvent === 'del'){
		       layer.confirm('真的删除行么', function(index){
		        var jsData={'id':data.Id}
				$.post('/v1/restaurant_ready/deltemp', jsData, function (out) {
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
	    	}else if(layEvent==='edit'){
				 layer.open({
				  type: 2,
				  title: '编辑菜品',
				  //closeBtn: 0, //不显示关闭按钮
				  shadeClose: true,
				  shade: false,
				  area: ['900px', '780px'],
				 // offset: 'rb', //右下角弹出
				  //time: 2000, //2秒后自动关闭
				  maxmin: true,
				  anim: 2,
				  content: ['/v1/restaurant_ready/edittemp?id='+data.Id+"&rid=<<<.id>>>"], //iframe的url，no代表不显示滚动条
				  cancel: function(index, layero){ 
				  //if(confirm('确定要关闭么')){ //只有当点击confirm框的确定时，该层才会关闭
				    layer.close(index)
					//window.location.reload();
					element.tabChange('demo', 'moban');
				  //}
				  	return false; 
				  },
				});
			} 	    
	  });
	//撤销备餐,点击查看订单
	<<<range $i,$e:=.maps_ready>>>
	$('#<<<$e.Id>>>_undo').on('click',function(){
		//layer.msg(<<<$e.Status>>>)		
		//alert("撤销")
		if(confirm('确定要撤销么')){ //只有当点击confirm框的确定时，该层才会关闭
			var jsData={'id':<<<$e.Id>>>}
				$.post('/v1/restaurant_ready/del', jsData, function (out) {
	                if (out.code == 200) {
	                    layer.alert('撤销成功了', {icon: 1},function(index){
	                        layer.close(index);
	                        //table.reload({});
							window.location.reload();
	                    });
	                } else {
	                    layer.msg(out.message)
	                }
	            }, "json");
		}
				
	});
	$('#<<<$e.Id>>>_order').on('click',function(){
		layer.msg(<<<$e.Id>>>)
		layer.open({
		  type: 2,
		  title: '查看订单',
		  //closeBtn: 0, //不显示关闭按钮
		  shadeClose: true,
		  area: ['900px', '700px'],
		 // offset: 'rb', //右下角弹出
		  //time: 2000, //2秒后自动关闭
		  maxmin: true,
		  anim: 2,
		  content: ['/v1/restaurant_ready/getorder?readyid='+<<<$e.Id>>>,'no'], //iframe的url，no代表不显示滚动条
		  cancel: function(index, layero){ 
			 //if(confirm('确定要关闭么')){ //只有当点击confirm框的确定时，该层才会关闭
			    layer.close(index)
				//window.location.reload();				
			  //}
			  return false; 
		  },
		});
	});
	<<<end>>>
	
	
	//ready 渲染table
	table.render({
	    elem: '#readyList'
	    ,height: 315
	    ,url: '/v1/restaurant_ready/getreadydishdata?id=<<<.id>>>' //数据接口
	    //,page: true //开启分页
		,id: 'listReload2'
	    ,cols: [[ //表头		  
	      {field:'Name', title:'模板名称', width:200}
		  ,{fixed: 'right', title:'操作',width:200, align:'center', toolbar: '#barDemo'}
	    ]]
	  });
	
	//form.on('select(timeinterval)', function(data){	  
	 // console.log(data.value); //得到被选中的值
	  //<<<range .maps_ti>>>
		//<<<if eq .Name "">>>
			//console.log(<<<.Time>>>)
		//<<<end>>>
	  //<<<end>>>
	//}); 
	
  });

 

	
	
</script>

</body>
</html>