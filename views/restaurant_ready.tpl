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
        <li class="layui-nav-item"><a href="/v1/restaurant_dish">菜品库</a></li>
        <li class="layui-nav-item"><a href="/v1/restaurant_ready">备餐</a></li>
        <li class="layui-nav-item"><a href="/v1/restaurant_manage">管理</a></li>
      </ul>
    </div>
  </div>
  <div class="layui-body">
    <!-- 内容主体区域 -->
    <div style="padding: 15px;">
		<div class="layui-tab layui-tab-card">
		  <ul class="layui-tab-title">
		    <li class="layui-this">备餐</li>
		    <li>模板</li>
		    <li>备餐记录</li>
		  </ul>
		  <div class="layui-tab-content" style="height: 500px;">
		    <div class="layui-tab-item layui-show">
				<blockquote class="layui-elem-quote" style="margin-top:10px;">备餐</blockquote>	
				<form class="layui-form layui-form-pane1" action="" onsubmit="javascript:return false;">
					<div class="layui-form-item">
					    <label class="layui-form-label">备餐时间：</label>
					    <div class="layui-input-inline" style="width: 120px;">
					        <input type="text" name="Stocks" id="date" autocomplete="off" class="layui-input">		
					    </div>
						<div class="layui-input-inline" style="width: 80px;">
							<select name="Unit" id="unit" lay-verType="tips">
					          <option value="早餐">早餐</option>
					          <option value="晚餐">晚餐</option>
					        </select>
						</div>
						<label class="layui-form-label">营业时间：</label>
					    <div class="layui-input-inline" style="width: 150px;">
					        <input type="text" name="Stocks" id="time" autocomplete="off" class="layui-input">		
					    </div>
					</div>
					<div class="layui-form-item">
					    <label class="layui-form-label">选择模板：</label>
						<div class="layui-input-inline" style="width: 200px;">
							<select name="Unit" id="unit" lay-verType="tips">
					          <option value="早餐">早餐</option>
					          <option value="晚餐">晚餐</option>
					        </select>
						</div>					
					</div>
					  <div class="layui-form-item">
					    <div class="layui-input-block">
					      <button class="layui-btn" id="add_time">备餐</button>
					    </div>
					  </div>
				</form>
			</div>
		    <div class="layui-tab-item">
				<blockquote class="layui-elem-quote" style="margin-top:10px;">预设模板</blockquote>	
				<table class="layui-table">
				  <colgroup>
				    <col width="150">
				    <col >
				  </colgroup>
				  <thead>
				    <tr>
				      <th>模板名称</th>
				      <th>操作</th>
				    </tr> 
				  </thead>
				  <tbody>
				    <tr>
				      <td>一周内模板</td>
				      <td>编辑|删除</td>
				    </tr>
				  </tbody>
				</table>
				<div>
					<button class="layui-btn" id="add_time">新增模板</button>
				</div>			
			</div>
		    <div class="layui-tab-item">
				<blockquote class="layui-elem-quote" style="margin-top:10px;">备餐记录</blockquote>	
				<div style="padding-bottom:10px;padding-left:10px;">
					<a style="padding-right:10px;">按类别：</a>
					<span class="layui-breadcrumb" lay-separator="|" style="font-size:30px;">
					  <a href="">不限</a>
					  <a href="">凉菜</a>
					  <a href="">热菜</a>
					</span>
					<div class="layui-input-inline" style="width: 150px;margin-left:100px;">
					    <input type="text" name="Stocks" id="date1" autocomplete="off" class="layui-input" placeholder="请输入日期">		
					</div>
				</div>
				<div class="layui-collapse">
				  <div class="layui-colla-item">
				    <h2 class="layui-colla-title">杜甫</h2>
				    <div class="layui-colla-content layui-show">内容区域</div>
				  </div>
				  <div class="layui-colla-item">
				    <h2 class="layui-colla-title">李清照</h2>
				    <div class="layui-colla-content">内容区域</div>
				  </div>
				  <div class="layui-colla-item">
				    <h2 class="layui-colla-title">鲁迅</h2>
				    <div class="layui-colla-content">内容区域</div>
				  </div>
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
	//时间范围
	  laydate.render({
	    elem: '#time'
	    ,type: 'time'
	    ,range: true
	  });
	  
	  laydate.render({
	    elem: '#date'
	    ,type: 'date'
	  });
	
	 laydate.render({
	    elem: '#date1'
	    ,type: 'date'
	  });
	
	//自动加载
	$(function(){
		//layer.msg({{.campus}});
		if({{.campus}}!=""){
			//layer.msg({{.campus}});
			$("#campus").val({{.campus}});
			//$("select[name=campus_select]").val({{.campus}});
			form.render('select');	
		}				
	});
	
	$('#addCanteen').on('click',function(){
		//layer.msg("点击添加按钮");
		//获取校区
		var cp=$("#campus").val();
		//iframe窗
		layer.open({
		  type: 2,
		  title: '新增食堂',
		  //closeBtn: 0, //不显示关闭按钮
		  shadeClose: true,
		  area: ['450px', '150px'],
		 // offset: 'rb', //右下角弹出
		  //time: 2000, //2秒后自动关闭
		  maxmin: true,
		  anim: 2,
		  content: ['/v1/canteen/add?campus='+cp,'no'], //iframe的url，no代表不显示滚动条
		  cancel: function(index, layero){ 
			  if(confirm('确定要关闭么')){ //只有当点击confirm框的确定时，该层才会关闭
			    layer.close(index)
				window.location.reload();				
			  }
			  return false; 
		  },
		});
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
  });

	
	
</script>

</body>
</html>