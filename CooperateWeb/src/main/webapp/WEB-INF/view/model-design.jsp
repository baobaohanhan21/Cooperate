<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>模型策划平台</title>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/resources/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/resources/easyui/themes/icon.css">
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/easyui/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/easyui/locale/easyui-lang-zh_CN.js"></script>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/resources/style/main.css">
<script type="text/javascript">
var treeData = <%=request.getAttribute("catalogTreeJson") %>;

$(function(){
	$('#help_tree').tree({
		checkbox: false,
		animate:true,
		lines:true,
		data: treeData,
		onClick:function(node) {
			var tree=$(this).tree;
			if (node.attributes.type==3)) {
				$('#show_win').panel('refresh','<%=request.getContextPath() %>/page/packageDesign');
				$('body').layout('panel', 'center').panel('setTitle', node.text);
			} 
		},
		formatter: function(node) {
			return node.text + "-";
		}
	});
	$('#show_win').panel({
				fit:true,
				border:false,
				noheader:false
	});
});
</script>
</head>
<body class="easyui-layout">

<div data-options="region:'north'" style="height:50px;overflow:hidden;">
  <h1>模型策划平台</h1>
  <div id="login_user_info">欢迎你：${currentUser.userName}. <a href="<%=request.getContextPath() %>/logout">退出</a></div>
</div>


<div data-options="region:'west',split:true,title:'导航窗口',iconCls:'icon-help'" style="width:248px;padding:5px; text-align:left;">
	<div id="rolelist_dg_toolbar">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newCatalog()">添加</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editCatalog()">修改</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="destroyCatalog()">删除</a>
</div>
<div id="catalog_save_dialog" class="easyui-dialog" style="width:400px;height:280px;padding:10px 20px"
		closed="true" buttons="#catalog_save_dialog_buttons" modal="true">
	<div class="ftitle">输入目录节点的信息</div>
	<form id="catalog_info_form" method="post">
		<div class="fitem">
			<label>节点名称：</label>
			<input type="text" name="catalogName">
		</div>
		<div class="fitem">
			<label>类       别：</label>
			<select name="catalogType" id="catalogList1">
			<option value="0" selected>数据库分类</option>
			<option value="1" >数据库</option> 
			</select>
		</div>
		<div class="fitem">
			<label >备      注：</label>
			<input type="text" name="remark" />
		</div>
	</form>
	<div id="catalog_info_form">
		<div class="fitem">
		<label>节点名称：</label>
			<input type="text" name="nodeName" required="true"/>
		</div>
		<div id="parentListType0" class="fitem" type="category">
			<label>类       别：</label>
			<select class="easyui-combobox" name="catalogType"  id="catalogList">
			<option value="0" selected>主模型分类</option>
			<option value="1" >主模型</option> 
			</select>
		</div>
		<%--<div id="parentListType1" class="fitem" type="category">--%>
			<%--<label>类       别：</label>--%>
			<%--<select class="easyui-combobox" name="catalogType"  id="catalogList1">--%>
				<%--<option value="1" selected>主模型</option>--%>
				<%--<option value="2" >数据包分类</option>--%>
			<%--</select>--%>
		<%--</div>--%>
		<div id="parentListType2" class="fitem" type="category">
			<label>类       别：</label>
			<select class="easyui-combobox" name="catalogType" id="catalogList2">
			<option value="2" selected>数据包分类</option>
			<option value="3" >数据包</option> 
			</select>
		</div>
	</div>
	<div id="#catalog_save_dialog_buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveCatalog()">保存</a>
    	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#catalog_save_dialog').dialog('close')">取消</a>
	</div>
</div>
	<ul id="help_tree" class="easyui-tree"></ul>
</div>
<div data-options="region:'center'" title="主窗口" style=" padding:10px; text-align:left;">
  <div id="show_win"></div>
</div>

<script>
setInterval(function() {
	var url = '<%=request.getContextPath() %>/checkSession';
	$.get(url, function(result) {
		if (! result.successful) {
			window.location.href="<%=request.getContextPath() %>";
		}
	}, 'json');
}, 60000);
</script>
<script type="text/javascript">
//记录当前选中的节点id
	var catalogId;
	$('#help_tree').tree({
		onSelect: function (node) {
			catalogId = node.attributes.id;
		}
	});
</script>
<script type="text/javascript" charset="UTF-8">
var UrlConfig={
		catalogAdd:'<%=request.getContextPath()%>/catalog/add',
		catalogUpdate:'<%=request.getContextPath()%>/catalog/update',
		catalogDelete:'<%=request.getContextPath()%>/catalog/delete',
		catalogList:'<%=request.getContextPath()%>/catalog/list',
		catalogTree:'<%=request.getContextPath()%>/catalog/tree',
	attributeList:'<%=request.getContextPath() %>/packageInfo/attributeList',
	attributeAdd:'<%=request.getContextPath() %>/packageInfo/attributeAdd',
	attributeUpdate:'<%=request.getContextPath() %>/packageInfo/attributeUpdate',
	attributeDelete:'<%=request.getContextPath() %>/packageInfo/attributeDelete',
	pakcageList:'<%=request.getContextPath() %>/packageInfo/pacakgeList',
	userList:'<%=request.getContextPath() %>/user/list'
};
var url;
function newCatalog(){
	var node=$('#help_tree').tree('getSelected');
	$(".fitem[type='category']").hide();
	if(node){
		var listType = node.attributes.type;
		switch (listType){
			case 0:$("#parentListType0").show();
				break;
			case 1:$("#parentListType2").show();
				break;
			case 2:$("#parentListType2").show();
				break;
			case 3:alert("不能向数据包添加子节点");
				return;
		}
		$('#catalog_save_dialog').dialog('open').dialog('setTitle','添加目录');
		$('#catalog_info_form').form('clear');
		url=UrlConfig.catalogAdd;
	}else{
		if(!isTreeEmpty())
			alert("请选择节点");
		else{
			$("#parentListType0").show();
			$('#catalog_save_dialog').dialog('open').dialog('setTitle','添加目录');
			$('#catalog_info_form').form('clear');
			url=UrlConfig.catalogAdd;
		}
	}
}

function isTreeEmpty(){
	var root = $('#help_tree').tree('getRoot');
	return root == null;
}

function editCatalog(){
	var node=$('#help_tree').tree('getSelected');
	if(node){
		$("input[name='nodeName']").prop('value',node.attributes.name);
		$('#parentListType2').hide();
		$('#parentListType0').hide();
		$('#catalog_save_dialog').dialog('open').dialog('setTitle','编辑目录');

//		if(node.attributes.type == 0){
//			$('#catalog_info_form').form('load',node);
//		}else if(node.attributes.type==1 || node.attributes.type ==2){
//			$('#catalog_save_dialog').dialog('open').dialog('setTitle','编辑目录');
//			$('#catalog_info_form').form('load',node);
//		}else{
//		}
		url=UrlConfig.catalogUpdate;
	}else{
		if(!isTreeEmpty())
			alert("请选择节点");
		alert("请添加节点");
	}
}

function saveCatalog(){
	var node=$('#help_tree').tree('getSelected');
	var name=$("input[name='nodeName']")[0].value;
	var pid;

	//空树 创建根节点
	if(node == null)
		pid = 0;
	else
		pid = node.attributes.id;

	if(url==UrlConfig.catalogAdd) {
		var type = $(".fitem[type='category'][style!='display: none;'] .combo-value")[0].value;
	}
	else if(url == UrlConfig.catalogUpdate) {
		var type = node.attributes.type;
	}
	var data={name:name,parentId:pid,type:type};
	if(url == UrlConfig.catalogUpdate) {
		data.id = node.attributes.id;
	}
	$.get(url,data,
	function(result){
		result = eval(result);
		if(result.successful){
			$('#catalog_save_dialog').dialog('close');			//$('#help_tree').tree('reload');
			reload();
			$.messager.show({title:'操作结果',msg:'操作成功'});
		}else{
			$.messager.show({title:'操作结果',msg:result.msg});
		}
	});

}

function destroyCatalog(){
	var node=$('#help_tree').tree('getSelected');
	if(node){
		if($('#help_tree').tree('isLeaf', node.target)) {
			$.messager.confirm('Confirm', '请确认是否删除该节点？', function (n) {
				if (n) {
					$.post(UrlConfig.catalogDelete, {catalogId: node.attributes.id}, function (result) {
						$.messager.show({title: '操作结果', msg: '操作成功'});
						reload();
					})
				}
			});
		}else{
			alert("请从叶子节点开始删除");
		}
	}else{
		if(!isTreeEmpty())
			alert("请选择节点");
		alert("请添加节点");
	}
}
	function reload(){
		var newData;
		$.get('/catalog/tree',{},function(result){
			newData = eval(result);
			$("#help_tree").tree({
				data:newData
				})
		});
	}
</script>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/package.js"></script>
</body>
</html>
