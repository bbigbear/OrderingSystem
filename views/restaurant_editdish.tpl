<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>新增菜品</title>
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
{{range .dish_info}}
<form class="layui-form layui-form-pane1" action="" onsubmit="javascript:return false;">
  <div class="layui-form-item">
    <label class="layui-form-label">菜品名称</label>
    <div class="layui-input-block">
<!--     <input type="text" name="title" lay-verify="required|title" required placeholder="标题不超过20个汉字" autocomplete="off" class="layui-input">-->
	  <input type="text" name="Name" id="name" value="{{.Name}}" placeholder="请输入菜品名称" autocomplete="off" class="layui-input">
    </div>
  </div>
  <div class="layui-form-item">
    <div class="layui-inline">
      <label class="layui-form-label">菜品种类</label>
      <div class="layui-input-block">
        <select name="DishType" id="dishType" value="{{.DishType}}" lay-filter="dishType_select">
          {{range .map}}
		    <option value= {{.Name}} > {{.Name}} </option>
		  {{end}}
        </select>
      </div>
    </div>
  </div>
  <div class="layui-form-item">
    <div class="layui-inline">
      <label class="layui-form-label">菜品售价</label>
      <div class="layui-input-inline" style="width: 100px;">
        <input type="text" name="Sell_price" id="sell_price" value="{{.Price}}" placeholder="￥" autocomplete="off" class="layui-input">
      </div>
    </div>
  </div>
  <div class="layui-form-item layui-form-text">
    <label class="layui-form-label">菜品描述</label>
    <div class="layui-input-block">
      <textarea placeholder="请输入内容" class="layui-textarea" name="Detail" id="detail" value="{{.Detail}}"></textarea>
    </div>
  </div>
  <div class="layui-form-item">
	<div class="layui-upload">
	<label class="layui-form-label">菜品照片</label>
	<div class="layui-upload-list" id="demo1">
    	<button class="layui-btn layui-btn-primary" id="test1" style="width:80px;height:80px;"><i class="layui-icon">&#xe654;</i></button>
		<input type="file" name="file" id="file[]" class="layui-upload-file">
	</div>
	</div>
  </div>
  <div class="layui-form-item">
    <div class="layui-input-block">
      <button class="layui-btn" id="add">确认提交</button>
<!--	  <input type="hidden" id="pic_path">-->
      <button type="reset" class="layui-btn layui-btn-primary">取消</button>
    </div>
  </div>
</form>
{{end}}
<br><br><br>


<script src="/static/layui.js"></script>
<!-- <script src="../build/lay/dest/layui.all.js"></script> -->

<script>
layui.use(['form','laydate','upload','jquery','layedit'], function(){
  var form = layui.form
  ,laydate=layui.laydate
  ,upload = layui.upload
  , $ = layui.jquery
  ,layedit=layui.layedit;
  
	//日期
	laydate.render({
		elem:'#time'
		,type: 'datetime'
	});
	    	//初始化
 	$(function(){
		$("#dishType").val({{.t}})
		$("#detail").val({{.d}})
		layedit.build('detail'); 

		var list={{.dp}}.split(',')
		//alert(list[0])
		for(var i=0;i<list.length-1;i++){
			$('#demo1').append('<img src="'+"/"+list[i]+'" id="upload_img_'+i+'" style="width:80px;height:80px;padding-left:10px;">')
			$("#upload_img_"+i).bind('click',function(){             
                $(this).remove();
             });
		}		
		form.render();
	});
	
	//餐厅图片上传
	  var path_src={{.dp}}
	  var uploadList=upload.render({
	    elem: '#test1'
	    ,url: '/v1/put_img'
	    ,multiple: true
		,exts: 'jpg|png|gif|bmp|jpeg'
		,auto:false
	    ,number: 1
	    ,size: 3*1024
		,bindAction: '#add'
		//,field:'myfile'
	    ,choose: function(obj){
	      //预读本地文件示例，不支持ie8
		  //alert(obj);
		  var files = obj.pushFile();
	      obj.preview(function(index, file, result){
	        $('#demo1').append('<img src="'+ result +'" alt="'+ file.name +'" class="layui-upload-img" id="upload_img_'+index+'" style="width:80px;height:80px;padding-left:10px;">')
	      	$("#upload_img_"+index).bind('click',function(){
                path_src="";
				delete files[index];//删除对应的文件
                $(this).remove();
				uploadList.config.elem.next()[0].value = ''; //清空 input file 值，以免删除后出现同名文件不可选			
             });
		});
	    }
	    ,done: function(res){
	      //上传完毕
			//alert("上传完毕")
			console.log(res);
			if (res.code==200){
				path_src=path_src+res.data.src+',';	
			}else{
				layer.msg(res.message);
			}			
	    }
	    ,allDone: function(obj){
	      	//alert(path_src)
			console.log(obj)
			//post json
			uploadForm();						
	    }
	  }); 
	//文本域
	var index=layedit.build('detail',{
		hideTool:['image','face']
	});
	//添加图片
	$('#test1').on('click',function(){
		return false;//禁止form自动提交
	});
	
	
	//复选框
	//var checkbox_src=""
	//form.on('checkbox', function(data){
		//console.log(data);		   
		//if(data.elem.checked==true){		
			//checkbox_src=checkbox_src+data.elem.title+',';	
		//}
	//});
	function uploadForm(){	 		
		var data={
			'id':parseInt({{.id}}),
			'name':$("#name").val(),
			'price':parseFloat($("#sell_price").val()),
			'dishType':$("#dishType").val(),
			'dishPicPath':path_src,
			'detail':layedit.getContent(index),
			};
			$.ajax({
				type:"POST",
				contentType:"application/json;charset=utf-8",
				url:"/v1/restaurant_dish/edit_action",
				data:JSON.stringify(data),
				async:false,
				error:function(request){
					alert("post error")						
				},
				success:function(res){
					if(res.code==200){
						alert("更新成功")
						window.location.reload();						
					}else{
						alert("更新失败")
					}						
				}
			});		
	}
	$('#add').on('click',function(){
	    	
		var len=document.querySelector("input[type=file]").files.length;		
		if (len==0){
			uploadForm();
		}				
		return false;
	});
	
		  
});
</script>

</body>
</html>