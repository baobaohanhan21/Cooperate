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
var treeData = <%=request.getAttribute("packageDesignTreeJson") %>;

$(function(){
	$('#help_tree').tree({
		checkbox: false,
		animate:true,
		lines:true,
		data: treeData,
		onClick:function(node) {
			if (node.attributes && node.attributes.menuUrl) {
				$('body').layout('panel', 'center').panel('setTitle', node.text);
			} 
		},
		formatter: function(node) {
			return node.text + "-";
		}
	});
});
</script>
</head>
<body class="easyui-layout">
<div style="margin:5px 0 10px 0;">
	</div>
		<div class="easyui-accordion" style="width:1000px;height:600px">
		<div title="数据包信息编辑" data-options="iconCls:'icon-edit'" style="width:100%;height:100px;padding:10px;">
			<div style="margin:5px 0">
			</div>
			<table id="packageEditTable" style="width:800px;">
			<tr>
				<th>
				<label>上游数据包：</label>
				</th>
				<th><select class="easyui-combobox" id="pPackages" data-options="multiple:true, multiline:true" style="width:200px;height:40px">
				</select>
				</th>
				<th>
				<label>数据包负责人：</label>
				</th>
				<th><select class="easyui-combobox"  id="packageDirectors" data-options="multiline:true" style="width:200px;height:40px">
				</select>
				</th>
				<th>
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="savePackageInfo()">保存</a>
				</th>
			</tr>
		</table>
		<div style="margin:5px 0">
		</div>

			<table class="easyui-datagrid" id="packageInfoList_dg" style="width:auto" >
				<thead>
					<tr>
						<th data-options="field:'attributeName'">属性名称</th>
						<th data-options="field:'attributeValue',width:300">属性值</th>
					</tr>
				<thead>
				<tbody>
				</tbody>
			</table>
			<div id="pacakgeInfo_dg_toolbar">
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newPackageAttr()">添加属性</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editPackageAttr()">编辑属性</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" plain="true" onclick="deletePackageAttr()">删除属性</a>
			</div>
			<div id="packageInfo_save_dialog" class="easyui-dialog" style="width:400px;height:280px;padding:10px 20px"
        			closed="true" buttons="#packageInfo_save_dialog_buttons" modal="true">
    				<div class="ftitle">请输入属性信息</div>
   						 <form id="package_info_form" method="post" action="/package/saveAttr">
       						 <div class="fitem">
            					<label>属性名称:</label>
            					<input type="text" name="attributeName" />
        					</div>
        					<div class="fitem">
           						 <label>属性值:</label>
            					<input type="text" name="attributeValue" />
        					</div>
        					<input type="hidden" name="packageId" />
    					</form>
			</div>
			<div id="packageInfo_save_dialog_buttons">
    			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveAttribute()">保存</a>
    			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#packageInfo_save_dialog').dialog('close')">取消</a>
			</div>
		
		</div>
		
		
		<div title="数据包数据项" data-options="iconCls:'icon-ok',href:''" style="padding:10px;">
			<table title="数据项" id="package_data" class="easyui-treegrid"
				   data-options="idField:'id',treeField:'name'"
				   animate="true" rownumbers="true">
				<div id="pacakgeData_dg_toolbar">
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newPackageData()">添加数据项</a>
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editPackageData()">编辑数据项</a>
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" plain="true" onclick="deletePackageData()">删除数据项</a>
				</div>
			<thead>
				<tr>
					<th  data-options="field:'name'" width="100" align="center">属性</th>
					<th  data-options="field:'type'" width="200" align="center">类型</th>
					<th  data-options="field:'value'" width="300" align="center">值</th>
				</tr>
			</thead>
			</table>

			<div id="packageData_dialog" class="easyui-dialog" style="width:400px;height:280px;padding:10px 20px"
				 closed="true" buttons="#packageData_save_dialog_buttons" modal="true">
				<div class="ftitle">请输入属性信息</div>
				<form id="packageData_form" method="post">
					<div id="package_data_name" class="fitem">
						<label>属性:</label>
						<input  type="text" name="name" />
					</div>
					<div id="package_data_type" class="fitem">
						<label>类型:</label>
						<input  type="text" name="type" />
					</div>
					<div id="package_data_value" class="fitem">
						<label>属性值:</label>
						<input  type="text" name="value" />
					</div>
				</form>
			</div>
			<div id="packageData_save_dialog_buttons">
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="savePackageData()">保存</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#packageData_dialog').dialog('close')">取消</a>
			</div>
		</div>
</div>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/package.js">
</script>
<script type="text/javascript">
	var params = getReady();
</script>
</body>
</html>
