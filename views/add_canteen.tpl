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
<form class="layui-form layui-form-pane1" action="">
  <div class="layui-form-item">
    <div class="layui-inline">
      <label class="layui-form-label">选择开设的食堂</label>
      <div class="layui-input-block">
        <select name="Classify" id="classify" lay-verType="tips">
          <option value="荤菜">南山第一食堂</option>
          <option value="素菜">南山第二食堂</option>
        </select>
      </div>
    </div>
  </div>
  <div class="layui-form-item">
    <div class="layui-input-block">
      <button class="layui-btn" id="add">确认</button>
<!--	  <input type="hidden" id="pic_path">-->
      <button type="reset" class="layui-btn layui-btn-primary">取消</button>
    </div>
  </div>
</form>

<br><br><br>


<script src="/static/layui.js"></script>
<!-- <script src="../build/lay/dest/layui.all.js"></script> -->

<script>
layui.use(['form','laydate','upload','jquery','layedit','element'], function(){
  var form = layui.form
  ,laydate=layui.laydate
  ,upload = layui.upload
  , $ = layui.jquery
  ,layedit=layui.layedit
  ,element=layui.element;
  

	//时间范围
	  laydate.render({
	    elem: '#test9'
	    ,type: 'time'
	    ,range: true
	  });
	
	//图片上传
	  var path_src=""
	  var uploadList=upload.render({
	    elem: '#test2'
	    ,url: '/v1/put_img'
	    ,multiple: true
		,exts: 'jpg|png|gif|bmp|jpeg'
		,auto:false
	    ,number: 10
	    ,size: 3*1024
		,bindAction: '#add'
		//,field:'myfile'
	    ,choose: function(obj){
	      //预读本地文件示例，不支持ie8
		  //alert(obj);
		  var files = obj.pushFile();
	      obj.preview(function(index, file, result){
	        $('#demo2').append('<img src="'+ result +'" alt="'+ file.name +'" class="layui-upload-img" id="upload_img_'+index+'" style="width:80px;height:80px;padding-left:10px;">')
	      	$("#upload_img_"+index).bind('click',function(){
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
	var index=layedit.build('info',{
		hideTool:['image']
	});
	//添加图片
	$('#test2').on('click',function(){
		return false;//禁止form自动提交
	});
	
	function uploadForm(){
		//alert(path_src)
		var data={
			'name':$("#name").val(),
			'classify':$("#classify").val(),
			'pic_path':path_src,
			'original_price':parseFloat($("#original_price").val()),
			'sell_price':parseFloat($("#sell_price").val()),
			'stocks':parseInt($("#stocks").val()),
			'unit':$("#unit").val(),
			'info':layedit.getContent(index),
			'status':parseInt($("input[name='Status']:checked").val()),
			'time':$("#time").val()
			};
			$.ajax({
				type:"POST",
				contentType:"application/json;charset=utf-8",
				url:"/v1/dish/add_action",
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