<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>数据包操作平台</title>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/resources/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/resources/easyui/themes/icon.css">
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/easyui/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/easyui/locale/easyui-lang-zh_CN.js"></script>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/resources/style/main.css">
<script type="text/javascript">
var treeData = <%=request.getAttribute("catalogTreeJson") %>;
function show_table(list,message,node_id){
	var table = document.getElementById("show_table");
	var toolline = document.createElement("tr");
	var td1_tool = document.createElement("td");
	var td2_tool = document.createElement("td");
	var td3_tool = document.createElement("td");
	td1_tool.innerHTML = "<a href=\"#\" class=\"easyui-linkbutton\" iconCls=\"icon-add\" plain=\"true\" onclick=\"create("+node_id+")\">创建草稿</a> ";
	td2_tool.innerHTML = "<a href=\"#\" class=\"easyui-linkbutton\" iconCls=\"icon-save\" plain=\"true\" onclick=\"save("+node_id+")\">提交草稿</a>";
	toolline.appendChild(td1_tool);
	toolline.appendChild(td2_tool);
	toolline.appendChild(td3_tool);
	table.appendChild(toolline);
	var tr_head = document.createElement("tr");
	var th1_new = document.createElement("th");
	var th2_new = document.createElement("th");
	var th3_new = document.createElement("th");
	th1_new.innerHTML = "数据包名称";
	th2_new.innerHTML = "版本号";
	th3_new.innerHTML = "提交时间";
	tr_head.appendChild(th1_new);
	tr_head.appendChild(th2_new);
	tr_head.appendChild(th3_new);
	table.appendChild(tr_head);
	for(var i=0;i<list.length;i++){
		var tr_new = document.createElement("tr");
		var td1_new = document.createElement("td");
		var td2_new = document.createElement("td");
		var td3_new = document.createElement("td");
		var a = document.createElement("a");
		a.setAttribute("href","#");
		var the_id = list[i].id;
		var versionId = list[i].versionId;
		if(versionId==0){
			a.setAttribute("onclick","edit_caogao("+node_id+","+the_id+")");
			td2_new.innerHTML = "草稿";
			td3_new.innerHTML = "未提交";
		}else{
			a.setAttribute("onclick","showVersionData("+the_id+","+node_id+","+versionId+")");	
			td2_new.innerHTML = versionId;
			td3_new.innerHTML = message.split("#")[i+1];
		}
		a.innerHTML = message.split("#")[0];
		td1_new.appendChild(a);
		tr_new.appendChild(td1_new);
		tr_new.appendChild(td2_new);
		tr_new.appendChild(td3_new);
		table.appendChild(tr_new);
	}
	table.style.display = "";
	addTab("版本列表");
}

function show_version_table(data_info_list,data_value_list){
	var data_catalog_list = [];
	var data_leaf_list = [];
	var catalog_count = 0;
	var leaf_count = 0;
	for(var i=0;i<data_info_list.length;i++){
		if(data_info_list[i].type==0){
			data_catalog_list[catalog_count] = data_info_list[i];
			catalog_count ++;
		}else{
			data_leaf_list[leaf_count] = data_info_list[i];
			leaf_count ++;
		}
	}
	info_value_map = {};
	for(var x=0;x<leaf_count;x++){
		var leaf = data_leaf_list[x];
		for(var y=0;y<data_value_list.length;y++){
			var value = data_value_list[y];
			if(value.dataInfoId==leaf.id){
				info_value_map[leaf.name] = value.value;
			}
		}
	}
	type_name_map = [];
	type_name_map[0] = "数据项分类";
	type_name_map[1] = "浮点数";
	type_name_map[2] = "文本";
	type_name_map[3] = "附件";
	var table = document.getElementById('show_table');
	table.style.display = "";
	for(var j=0;j<catalog_count;j++){
		var tr_new = document.createElement("tr");
		var th1_new = document.createElement("th");
		var th2_new = document.createElement("th");
		var th3_new = document.createElement("th");
		th1_new.innerHTML = data_catalog_list[j].name;
		tr_new.appendChild(th1_new);
		tr_new.appendChild(th2_new);
		tr_new.appendChild(th3_new);
		table.appendChild(tr_new);
		for(var k=0;k<leaf_count;k++){
			var data_leaf = data_leaf_list[k];
			if(data_leaf.parentId==data_catalog_list[j].id){
				var tr2_new = document.createElement("tr");
				var td1_new = document.createElement("td");
				var td2_new = document.createElement("td");
				var td3_new = document.createElement("td");
				td1_new.innerHTML = data_leaf.name;
				td2_new.innerHTML = type_name_map[data_leaf.type];
				td3_new.innerHTML = info_value_map[data_leaf.name];
				tr2_new.appendChild(td1_new);
				tr2_new.appendChild(td2_new);
				tr2_new.appendChild(td3_new);
				table.appendChild(tr2_new);
			} 
		}
	}	
}

function clear_table(){
	document.getElementById('show_table').innerHTML = "";	
}

function showVersionData(version_id,package_id,versionId){
	var params = {};
	params['version_id'] = version_id;
	params['package_id'] = package_id;
	$.ajax({
		type:"post",
		data:params,
		url:'<%=request.getContextPath() %>/haha',
		success:function(result){
			//do with result.list1 and result.list2
			var data_info_list = result.list1;
			var data_value_list = result.list2;
			clear_table();
			show_version_table(data_info_list,data_value_list);
			addTab("版本信息"+versionId);
		}
	});
}

$(function(){
	$('#help_tree').tree({
		checkbox: false,
		animate:true,
		lines:true,
		data: treeData,
		onClick:function(node) {
			var tree=$(this).tree;
			if (node.attributes && tree('isLeaf',node.target)) {
				//$('#show_win').panel();
				//$('body').layout('panel', 'center').panel('setTitle', node.text);
				//show(node.id);
				$.ajax({
					type:"post",
					data:"package_id=" + node.id,
					url:'<%=request.getContextPath() %>/hehe',
					success:function(result){
						//$('#show_win').html(result.msg);
						//$('#show_win').html(result.message);
						var list = result.list1;
						clear_table();
						show_table(list,result.message,node.id);
						 
					}
				});
			}
		},
		formatter: function(node) {
			return node.text + "-";
		}
	});
	
	//$('#show_win').panel({
	//			fit:true,
	//			border:false,
	//			noheader:false
	//});
});

setInterval(function() {
	var url = '<%=request.getContextPath() %>/checkMessage';
	$.get(url, function(result) {
		if (result.successful) {
			showMessage(result.message);
		}
	}, 'json');
}, 60000);

function showMessage(message){
	$.messager.show({
		title:'新消息',
		msg:message,
		timeout:0,
		showType:'slide'
	});
}

var index = 0;
function addTab(title){
	if($('#tt').tabs('exists',title)){
		$('#tt').tabs('select',title);
	}else{
		index ++;
		var content = "<table id=\""+index+"\" width=\"600\" border=\"0\" cellspacing=\"1\">"+document.getElementById('show_table').innerHTML+"</table>";
		$('#tt').tabs('add',{
			title:title,
			content:content,
			closable:true
		});
	}
}

function create(package_id){
	$.ajax({
		type:'post',
		data:'package_id='+package_id,
		url:'<%=request.getContextPath() %>/getDependency',
		success:function(result){
			var up_packages = result.list2;
			var up_versions = result.list1;
			clear_dialog();
			show_dialog(up_packages,up_versions,package_id);
		}
	});	
}

function clear_dialog(){
	document.getElementById("new_pv_table").innerHTML = "";
}

function show_dialog(up_packages,up_versions,package_id){
	var table = document.getElementById("new_pv_table");
	var first_tr = document.createElement("tr");
	var first_td = document.createElement("td");
	first_td.setAttribute("colspan","2");
	first_td.innerHTML = "请选择新建草稿的依赖数据包版本：";
	first_tr.appendChild(first_td);
	table.appendChild(first_tr);
	var count = 0;
	for(var i=0;i<up_packages.length;i++){
		var ptr_new = document.createElement("tr");
		var ptd1_new = document.createElement("td");
		ptd1_new.innerHTML = up_packages[i].name;
		ptr_new.appendChild(ptd1_new);
		table.appendChild(ptr_new);
		var inner_count = 0;
		for(var j=count;j<up_versions.length&&up_versions[j].packageId==up_packages[i].id;j++){
			var vtr_new = document.createElement("tr");
			var vtd1_new = document.createElement("td");
			var vtd2_new = document.createElement("td");
			vtd2_new.innerHTML = "<input type=\"radio\" name=\""+i+"\" value=\""+up_versions[j].id+"\" />"+up_packages[i].name+"_版本"+up_versions[j].versionId;
			vtr_new.appendChild(vtd1_new);
			vtr_new.appendChild(vtd2_new);
			table.appendChild(vtr_new);
			inner_count ++;
		}
		count += inner_count;
	}
	var ok_button = document.createElement("a");
	ok_button.setAttribute('href',"#");
	ok_button.setAttribute('class',"easyui-linkbutton");
	ok_button.setAttribute('data-options',"toggle:true");
	ok_button.setAttribute('onclick',"submit_checkbox("+up_packages.length+","+package_id+")");
	ok_button.innerHTML = "保存";
	table.appendChild(ok_button);
	$('#w').window('open');	
}


function submit_checkbox(length,package_id){
	var s = "";
	for(var i=0;i<length;i++){
		var obj = document.getElementsByName(i);
		for(var k=0;k<obj.length;k++){
			if(obj[k].checked){
				s += ","+obj[k].value;        //注意数据存放格式
			}
		}
		
	}
	//存草稿，约定一个标识，区分草稿和实际版本。
    //package_id
    //version_id=0标识草稿，看看dataOperateImpl的实现,要改
    //parent_id=s
    //ajax
    $.ajax({
    	url:'<%=request.getContextPath()%>/submit_caogao',
    	data:'package_id='+package_id+'&parent_id='+s,
    	type:'post',
    	success:function(result){
    		var new_tr = document.createElement("tr");
    		var new_td1 = document.createElement("td");
    		var new_td2 = document.createElement("td");
    		var new_td3 = document.createElement("td");
    		var ms = result.message.split(",")[0];
    		var version_id = Number(result.message.split(",")[1]);
    		new_td1.innerHTML = "<a href=\"#\" onclick=\"edit_caogao("+package_id+","+version_id+")\" >"+ms+"</a>";
    		new_td2.innerHTML = "草稿";
    		new_td3.innerHTML = "未提交";
    		new_tr.appendChild(new_td1);
    		new_tr.appendChild(new_td2);
    		new_tr.appendChild(new_td3);
    		var table = document.getElementById("1");
    		table.appendChild(new_tr);
    		$('#w').window('close');
    	}
    });
}

function edit_caogao(package_id,version_id){
	var table = document.getElementById("show_table");
	$.ajax({
		url:'<%=request.getContextPath()%>/edit_caogao',
		data:'package_id='+package_id+'&version_id='+version_id,
		type:'post',
		success:function(result){
			var data_info_list = result.list1;
			var data_value_list = result.list2;
			clear_table();
			show_caogao_table(data_info_list,data_value_list);
			addTab("编辑草稿");
		}
	});
}

function show_caogao_table(data_info_list,data_value_list){
	var data_catalog_list = [];
	var data_leaf_list = [];
	var catalog_count = 0;
	var leaf_count = 0;
	for(var i=0;i<data_info_list.length;i++){
		if(data_info_list[i].type==0){
			data_catalog_list[catalog_count] = data_info_list[i];
			catalog_count ++;
		}else{
			data_leaf_list[leaf_count] = data_info_list[i];
			leaf_count ++;
		}
	}
	info_value_map = {};
	for(var x=0;x<leaf_count;x++){
		var leaf = data_leaf_list[x];
		for(var y=0;y<data_value_list.length;y++){
			var value = data_value_list[y];
			if(value.dataInfoId==leaf.id){
				info_value_map[leaf.name] = value.value;
			}
		}
	}
	type_name_map = [];
	type_name_map[0] = "数据项分类";
	type_name_map[1] = "浮点数";
	type_name_map[2] = "文本";
	type_name_map[3] = "附件";
	var table = document.getElementById('show_table');
	table.style.display = "";
	for(var j=0;j<catalog_count;j++){
		var tr_new = document.createElement("tr");
		var th1_new = document.createElement("th");
		var th2_new = document.createElement("th");
		var th3_new = document.createElement("th");
		th1_new.innerHTML = data_catalog_list[j].name;
		tr_new.appendChild(th1_new);
		tr_new.appendChild(th2_new);
		tr_new.appendChild(th3_new);
		table.appendChild(tr_new);
		for(var k=0;k<leaf_count;k++){
			var data_leaf = data_leaf_list[k];
			if(data_leaf.parentId==data_catalog_list[j].id){
				var tr2_new = document.createElement("tr");
				var td1_new = document.createElement("td");
				var td2_new = document.createElement("td");
				var td3_new = document.createElement("td");
				td1_new.innerHTML = data_leaf.name;
				td2_new.innerHTML = type_name_map[data_leaf.type];
				td3_new.innerHTML = "<input id=\"text"+k+"\" type=\"text\" value=\""+info_value_map[data_leaf.name]+"\" onfocus=\"Onfocus("+k+")\"></input>";
				tr2_new.appendChild(td1_new);
				tr2_new.appendChild(td2_new);
				tr2_new.appendChild(td3_new);
				table.appendChild(tr2_new);
			} 
		}
	}
	var tr_last = document.createElement("tr");
	var td_last = document.createElement("td");
	var ok_button = document.createElement("a");
	ok_button.setAttribute('href',"#");
	ok_button.setAttribute('class',"easyui-linkbutton");
	ok_button.setAttribute('data-options',"toggle:true");
	list = "";
	var package_id = data_leaf_list[0].packageId;
	for(var x=0;x<k;x++){
		list += "#"+ data_leaf_list[x].id;
	}
	ok_button.setAttribute('onclick',"updateCaogao("+k+",'"+list+"',"+package_id+")");
	ok_button.innerHTML = "保存";
	td_last.appendChild(ok_button);
	tr_last.appendChild(td_last);
	table.appendChild(tr_last);
}

function Onfocus(k){
	document.getElementById("text"+k).value = "";
}

function updateCaogao(k,list,package_id){
	var input = "";
	for(var i=0;i<k;i++){
		input += "#"+document.getElementById("text"+i).value;
	}
	$.ajax({
		data:'input='+input+'&data_info='+list+'&package_id='+package_id,
		type:'post',
		url:'<%=request.getContextPath()%>/update_caogao',
		success:function(result){
			//to tab1
			$('#tt').tabs('close',"编辑草稿");
			$('#tt').tabs('select',"版本列表");
		}
	});
	
}

function save(package_id){
	$.ajax({
		url:'<%=request.getContextPath()%>/commit_caogao',
		data:'package_id='+package_id,
		type:'post',
		success:function(result){
			var list = result.list1;
			table = document.getElementById("1");
			for(var i=list.length+1;i>1;i--){
				table.deleteRow(i);
			}
			show_table2(list,result.message,package_id);
			$('#tt').tabs('select',"版本列表");
		}
	});	
}

function show_table2(list,message,node_id){
	var table = document.getElementById("1");
	for(var i=0;i<list.length;i++){
		var tr_new = document.createElement("tr");
		var td1_new = document.createElement("td");
		var td2_new = document.createElement("td");
		var td3_new = document.createElement("td");
		var a = document.createElement("a");
		a.setAttribute("href","#");
		var the_id = list[i].id;
		var versionId = list[i].versionId;
		a.setAttribute("onclick","showVersionData("+the_id+","+node_id+","+versionId+")");	
		td2_new.innerHTML = versionId;
		td3_new.innerHTML = message.split("#")[i+1];
		a.innerHTML = message.split("#")[0];
		td1_new.appendChild(a);
		tr_new.appendChild(td1_new);
		tr_new.appendChild(td2_new);
		tr_new.appendChild(td3_new);
		table.appendChild(tr_new);
	}
	
}

Date.prototype.Format = function(fmt) 
{  
  var o = { 
    "M+" : this.getMonth()+1,                 //月份 
    "d+" : this.getDate(),                    //日 
    "h+" : this.getHours(),                   //小时 
    "m+" : this.getMinutes(),                 //分 
    "s+" : this.getSeconds(),                 //秒 
    "q+" : Math.floor((this.getMonth()+3)/3), //季度 
    "S"  : this.getMilliseconds()             //毫秒 
  }; 
  if(/(y+)/.test(fmt)) 
    fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length)); 
  for(var k in o) 
    if(new RegExp("("+ k +")").test(fmt)) 
  fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length))); 
  return fmt; 
}

</script>
<body class="easyui-layout">
<div data-options="region:'north'" style="height:50px;overflow:hidden;">
  <h1>数据包操作平台</h1>
  <div id="login_user_info">欢迎你：${currentUser.userName}. <a href="<%=request.getContextPath() %>/logout">退出</a></div>
</div>
<div data-options="region:'west',split:true,title:'导航窗口',iconCls:'icon-help'" style="width:248px;padding:5px; text-align:left;">
	<ul id="help_tree" class="easyui-tree"></ul>
</div>
<div id="tt" class="easyui-tabs" data-options="region:'center'" style=" padding:10px; text-align:left;">
</div>	
<div id="show_win" title="start">
<table id="show_table" width="600" border="0" cellspacing="1" style="display:none">
		<tr id="table_head">
			<th><strong>数据包名称</strong></th>
			<th><strong>版本号</strong></th>
			<th><strong>提交时间</strong></th>
		</tr>
</table>
</div>
<div id="w" class="easyui-window" title="新建草稿" data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:600px;height:400px;padding:10px;">
	<form id="new_pv" method="post" action="<%=request.getContextPath()%>/do_with_new_pv">
		<table id="new_pv_table" cellpadding="5">
		</table>
	</form>
</div>
</body>
</html>