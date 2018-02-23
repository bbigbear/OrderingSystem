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
    <!-- 头部区域（可配合layui已有的水平导航） -->
    <!--<ul class="layui-nav layui-layout-left">
      <li class="layui-nav-item"><a href="">个人中心</a></li>
      <li class="layui-nav-item"><a href="">内容管理</a></li>
      <li class="layui-nav-item"><a href="">统计报表</a></li>
	  <li class="layui-nav-item"><a href="">客服管理</a></li>
      <li class="layui-nav-item">
        <a href="javascript:;">系统管理</a>
        <dl class="layui-nav-child">
          <dd><a href="">邮件管理</a></dd>
          <dd><a href="">消息管理</a></dd>
          <dd><a href="">授权管理</a></dd>
        </dl>
      </li>
    </ul>-->
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
        <li class="layui-nav-item"><a href="/v1/canteen">食堂管理</a></li>
        <li class="layui-nav-item"><a href="/v1/dining_room">餐厅管理</a></li>
        <li class="layui-nav-item"><a href="/v1/dining_time">供应时段</a></li>
      </ul>
    </div>
  </div>
  <div class="layui-body">
    <!-- 内容主体区域 -->
    <div style="padding: 15px;">
		<blockquote class="layui-elem-quote">校区选择</blockquote>
		<div style="padding: 15px;height:50px;">
			<select name="city" lay-verify="" style="height:30px;width:200px;">
			  <option value="010">雁塔校区</option>
			  <option value="021">南</option>
			  <option value="0571">西</option>
			  <option value="0571">北</option>
			</select> 
		</div>		
		<blockquote class="layui-elem-quote">食堂开设</blockquote>
		<div style="padding: 15px;">
		    <button class="layui-btn">
			  南山第一食堂 <i class="layui-icon">&#x1006;</i>
			</button>
			<button class="layui-btn layui-btn-primary" id="test2"><i class="layui-icon">&#xe654;</i></button>
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
	layui.use(['element','layer','jquery','table'], function(){
	  var element = layui.element
		,layer=layui.layer
		,$=layui.jquery
		,table=layui.table;
	  //layer.msg("你好");
	$('#add').on('click',function(){
		//layer.msg("点击添加按钮");
		//iframe窗
		layer.open({
		  type: 2,
		  title: '新增菜品',
		  //closeBtn: 0, //不显示关闭按钮
		  shadeClose: true,
		  shade: false,
		  area: ['893px', '600px'],
		 // offset: 'rb', //右下角弹出
		  //time: 2000, //2秒后自动关闭
		  maxmin: true,
		  anim: 2,
		  content: ['/v1/dish/add_show'], //iframe的url，no代表不显示滚动条
		  cancel: function(index, layero){ 
		  if(confirm('确定要关闭么')){ //只有当点击confirm框的确定时，该层才会关闭
		    layer.close(index)
			//window.parent.location.reload();
			//重载表格
			table.reload('listReload', {});
		  }
		  return false; 
		  },
		});
	});
	
	  //table 渲染
	  table.render({
	    elem: '#saleList'
	    ,height: 315
	    ,url: '/v1/getdata?status=1' //数据接口
	    ,page: true //开启分页
		,id: 'listReload'
	    ,cols: [[ //表头
		  {type:'checkbox', fixed: 'left'}
	      ,{field:'Id', title:'ID', width:60, sort: true, fixed: true}
	      ,{field:'Name',  title:'菜品名称', width:120}
	      ,{field:'Classify', title:'菜品分类', width:120, sort: true}
		  ,{field: 'Pic_path', title: '菜品图片', width:'11%'
			,templet:function(d){
				var list=d.Pic_path.split(',')
				//alert(list.length)
				if(list.length!=1){
					for(var i=0;i<list.length-1;i++){
						return '<img src="'+'/'+list[i]+'">'				
					}
				}else{
					return ""	
				}						
			}}
	      //,{field:'Pic_path', title:'菜品图片', width:120}
	      ,{field:'Sell_price', title:'菜品售价￥', width:100}
	      ,{field:'Stocks', title:'菜品库存', width:100, sort: true}
	      ,{field:'Stocks', title:'总销量', width:100}
	      ,{field:'Time', title:'创建时间',  width:150, sort: true}
		  ,{fixed: 'right', title:'操作',width:200, align:'center', toolbar: '#barDemo'}
	    ]]
	  });
		//点击仓库中 查询按钮
	  	var $ = layui.$, active = {
            reload: function(){
                table.reload('listReload', {
                    where: {
                        name: $('#soldFor_name').val(),
						sell_price: $('#soldFor_price').val(),
                    }
                });
            }
        };	
		$('#soldFor_search').on('click', function(){
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
			return false;
        });
		//点击销售中按钮
		var $ = layui.$, active2 = {
            reload: function(){
                table.reload('listReload2', {
                    where: {
                        name: $('#soldIn_name').val(),
						sell_price: $('#soldIn_price').val(),
                    }
                });
            }
        };	
		$('#soldIn_search').on('click', function(){
            var type = $(this).data('type');
            active2[type] ? active2[type].call(this) : '';
			return false;
        });
		//点击售罄中按钮
		var $ = layui.$, active3 = {
            reload: function(){
                table.reload('listReload3', {
                    where: {
                        name: $('#soldOut_name').val(),
						sell_price: $('#soldOut_price').val(),
                    }
                });
            }
        };	
		$('#soldOut_search').on('click', function(){
            var type = $(this).data('type');
            active3[type] ? active3[type].call(this) : '';
			return false;
        });
		//监听工具条
		table.on('tool(sale)', function(obj){ //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
		    var data = obj.data //获得当前行数据
		    ,layEvent = obj.event; //获得 lay-event 对应的值
		    if(layEvent === 'detail'){
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
			  content: ['/v1/dish/show?id='+data.Id], //iframe的url，no代表不显示滚动条
			  cancel: function(index, layero){ 
			  if(confirm('确定要关闭么')){ //只有当点击confirm框的确定时，该层才会关闭
			    layer.close(index)
			  }
			  return false; 
			  },
		});
	    } else if(layEvent === 'del'){
	      layer.confirm('真的删除行么', function(index){
	        var jsData={'id':data.Id}
			$.post('/v1/deldata', jsData, function (out) {
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
	    } else if(layEvent === 'edit'){
	      layer.msg('编辑操作');
		  layer.open({
			  type: 2,
			  title: '编辑菜品',
			  //closeBtn: 0, //不显示关闭按钮
			  shadeClose: true,
			  shade: false,
			  area: ['893px', '600px'],
			 // offset: 'rb', //右下角弹出
			  //time: 2000, //2秒后自动关闭
			  maxmin: true,
			  anim: 2,
			  content: ['/v1/dish/edit_show?id='+data.Id], //iframe的url，no代表不显示滚动条
			  cancel: function(index, layero){ 
			  if(confirm('确定要关闭么')){ //只有当点击confirm框的确定时，该层才会关闭
			    layer.close(index)
			  }
			  return false; 
			  },
		});					  
	    }else if(layEvent=='sold'){
			
		}else if(layEvent=='soldout'){
			
		}
	  });
	//切换tab
	 	element.on('tab(docDemoTabBrief)', function(data){
    	layer.msg('切到到:'+ this.innerHTML);
		if(data.index==2){
			// table.reload('listReload', {
   //                  where: {
   //                      name: $('#dish_name').val(),
			// 			sell_price: $('#dish_price').val(),
			// 			stauts:0,
   //                  }
   //              });
			 //table 渲染
		  table.render({
		    elem: '#saleList2'
		    ,height: 315
		    ,url: '/v1/getdata?status=0' //数据接口
		    ,page: true //开启分页
			,id: 'listReload2'
		    ,cols: [[ //表头
			  {type:'checkbox', fixed: 'left'}
		      ,{field:'Id', title:'ID', width:60, sort: true, fixed: true}
		      ,{field:'Name',  title:'菜品名称', width:120}
		      ,{field:'Classify', title:'菜品分类', width:120, sort: true}
			  ,{field: 'Pic_path', title: '菜品图片', width:'11%'
				,templet:function(d){
					var list=d.Pic_path.split(',')
					//alert(list.length)
					if(list.length!=1){
						for(var i=0;i<list.length-1;i++){
							return '<img src="'+'/'+list[i]+'">'				
						}
					}else{
						return ""	
					}			
				}}
		      //,{field:'Pic_path', title:'菜品图片', width:120}
		      ,{field:'Sell_price', title:'菜品售价￥', width:100}
		      ,{field:'Stocks', title:'菜品库存', width:100, sort: true}
		      ,{field:'Stocks', title:'总销量', width:100}
		      ,{field:'Time', title:'创建时间',  width:150, sort: true}
			  ,{fixed: 'right', title:'操作',width:200, align:'center', toolbar: '#barDemo2'}
		    ]]
		  });
		}
		if(data.index==3){
			layer.msg('切到到:'+ this.innerHTML)
			 //table 渲染
		  table.render({
		    elem: '#saleList3'
		    ,height: 315
		    ,url: '/v1/getdata?status=2' //数据接口
		    ,page: true //开启分页
			,id: 'listReload3'
		    ,cols: [[ //表头
			  {type:'checkbox', fixed: 'left'}
		      ,{field:'Id', title:'ID', width:60, sort: true, fixed: true}
		      ,{field:'Name',  title:'菜品名称', width:120}
		      ,{field:'Classify', title:'菜品分类', width:120, sort: true}
			  ,{field: 'Pic_path', title: '菜品图片', width:'11%'
				,templet:function(d){
					var list=d.Pic_path.split(',')
					//alert(list.length)
					if(list.length!=1){
						for(var i=0;i<list.length-1;i++){
							return '<img src="'+'/'+list[i]+'">'				
						}
					}else{
						return ""
					}						
				}}
		      //,{field:'Pic_path', title:'菜品图片', width:120}
		      ,{field:'Sell_price', title:'菜品售价￥', width:100}
		      ,{field:'Stocks', title:'菜品库存', width:100, sort: true}
		      ,{field:'Stocks', title:'总销量', width:100}
		      ,{field:'Time', title:'创建时间',  width:150, sort: true}
			  ,{fixed: 'right', title:'操作',width:200, align:'center', toolbar: '#barDemo'}
		    ]]
		  });
		}
	});	
	//soldout del
	$('#soldout_del').on('click',function(){				
		var str="";
		var checkStatus=table.checkStatus('listReload3')
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
					url:"/v1/delmultidata",
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
							table.reload('listReload3', {							  
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