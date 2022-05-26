<%--suppress JSDeprecatedSymbols --%>
<%@page  pageEncoding="UTF-8"%>
<html>
<head>
	<link href="static/easyui/themes/default/easyui.css" rel="stylesheet" type="text/css">
	<link href="static/easyui/themes/icon.css" rel="stylesheet" type="text/css">
	<script src="static/jquery-1.8.min.js"></script>
	<script src="static/easyui/jquery.easyui.min.js"></script>
	<script src="static/easyui/locale/easyui-lang-zh_CN.js"></script>
	<style>
	</style>
	<title>测试</title>
</head>
<body>
	<div id="toolbar">
		<label>姓名:</label>
		<input id="queryName" style="width: 120px;">
		<a onclick="grid();" href="#" class="easyui-linkbutton" iconCls="icon-search">查询</a>　
		<a onclick="open_ins()" href="#" class="easyui-linkbutton" iconCls="icon-add">添加</a>
		<a onclick="open_upd()" href="#" class="easyui-linkbutton" iconCls="icon-edit">修改</a>
		<a onclick="batchDel();" href="#" class="easyui-linkbutton" iconCls="icon-remove">删除</a>
	</div>
	<table id="grid" ></table>
	<div id="menu" class="easyui-menu" style="width:120px;">
		<div data-options="name:'open_upd(row)', iconCls:'icon-edit'">修改</div>
		<div data-options="name:'del(row)', iconCls:'icon-remove'">删除</div>
	</div>
	
	<div id="upd-win" class="easyui-window" data-options="title:'信息',iconCls:'icon-save',closed:true" style="width:550px; top:60px; padding:5px; line-height: 175%;">
		 <input id="id" value="" type="hidden">
		姓名:  <input id="name" value="" style="width:260px"><br>
		生日:  <input id="birthDay" value="" class="easyui-datebox" style="width:260px"><br>
		性别:  <select id="sex" style="width:260px">
				<option  value="1">男</option>
				<option value="2">女</option>
			</select><br>
		所属部门:  <select id="departName" style="width:260px">
					<option  value="部门1">部门1</option>
					<option value="部门2">部门2</option>
					<option value="部门3">部门3</option>
			  </select><br>
		<a id="upd-ok-btn" href="##" class="easyui-linkbutton" style="margin-left:170px" data-options="iconCls:'icon-ok'">提　交</a>
		<a onclick="$('#upd-win').window('close');" href="#" class="easyui-linkbutton" style="margin-left:50px" data-options="iconCls:'icon-cancel'">关　闭</a>
	</div>
	
	
<script>

function grid() {
	$("#grid").datagrid({url: "grid", queryParams: {name: $("#queryName").val()}, pageNumber: 1});
}

$("#grid").datagrid({
	toolbar: "#toolbar", nowrap: true, fit: true, rownumbers: true, striped: true, singleSelect: false,
	pagination: true, pageList: [5,10,20],
	columns: [[ 
		{checkbox: true},
		{field:"id", title:"编号",align:"left"},
		{field:"name", title:"姓名",align:"left"},
		{field:"birthDay",title:"生日",align:"left"},
		{field:"sex", title:"性别",align:"left",formatter: function(value,row,index) {
                if (value == 1) {
                    return '男';
                } else {
                    return '女';
                }
            }},
		{field:"departName", title:"所属部门",align:"left"}
	]],
	onRowContextMenu: function(e, rowIndex, row) {
		e.preventDefault();
		$("#menu").menu({onClick: function(item) {eval(item.name);}}).menu("show", {left: e.pageX-2, top: e.pageY-2});
	},
	onDblClickRow: function(rowIndex, row) {
		open_upd(row);
	}
});


setTimeout("grid()",100);


function open_ins() {
	$("#id").val('');
	$("#name").val('');
	$("#birthDay").datebox('setValue', '');
	$("#sex").val('1');
	$("#departName").val('1');
	$("#upd-ok-btn")[0].onclick = function(){ins();};
	$("#upd-win").window("setTitle","添加").window("open");
}

function ins() {
	var name = $("#name").val();
	if(!name){
		alert("请输入姓名!");
		return;
	}
	var prm = {
		name: $("#name").val(),
		birthDay: $("#birthDay").datebox('getValue'),
		sex: $("#sex").val(),
		departName: $("#departName").val(),
	};
	$.ajax({type:"post", url: "ins", data: prm, dataType:"json", success:function(res) {
		if(res.code==0) {alert("发生错误: "+res.msg);return;}
		$.messager.show({title: "提示", msg: "新增成功", timeout: 2000, showType: 'slide'});
		$("#grid").datagrid("reload");
		$("#upd-win").window("close");
	}});
}

function open_upd(row) {
    console.log(row);
	if(row==null) {
		row = $("#grid").datagrid("getChecked");
        console.log(row);
		if(row==null) {alert("请先点击选择行!"); return;}
		console.log(row.length)
		if(row.length > 1) {alert("请选择一行!"); return;}
	}
    $("#id").val(row.id);
    $("#name").val(row.name);
    $("#birthDay").datebox('setValue', row.birthDay);
    $("#sex").val(row.sex);
    $("#departName").val(row.departName);
	$("#upd-win").window("setTitle","修改").window("open");
	$("#upd-ok-btn")[0].onclick = function(){upd();};
}

function upd() {
    console.log($("#id").val());

	var prm = {
		id: $('#id').val(),
		name: $("#name").val(),
		birthDay: $("#birthDay").datebox('getValue'),
		sex: $('#sex').val(),
		departName: $('#departName').val()
	};

	$.ajax({type:"post", url: "upd", data: prm, dataType:"json", success:function(res) {
		if(res.code==0) {alert("发生错误: "+res.msg);return;}
		$.messager.show({title: "提示", msg: "修改成功", timeout: 2000, showType: 'slide'});
		$("#grid").datagrid("reload");
		$("#upd-win").window("close");
	}});
}

function del(row) {
	if(row==null) {
		row = $("#grid").datagrid("getSelected");
		if(row==null) {alert("请先点击选择行!"); return;}
		if(row.length > 1) {alert("请选择一行!"); return;}
	}
	if(!confirm("确认删除编号 "+row.id+' 姓名'+row.name+"吗？")) return;
	$.ajax({type:"post", url:"del", data: {id: row.id}, dataType:"json", success: function(res) {
		if(res.code==0) {alert("发生错误: "+res.msg);return;}
		$.messager.show({title: "提示", msg: "删除成功", timeout: 2000, showType: 'slide'});
		$("#grid").datagrid("reload");
	}});
}

function batchDel() {
	var rows = $("#grid").datagrid("getChecked");
	if(rows==null) {alert("请先点击选择行!"); return;}
	$.messager.confirm('确认对话框', '当前选中：'+rows.length+'行吗?', function(r){
	    if (r){
	    	$.messager.progress();
	    	var ids = new Array();
	    	$.each(rows, function(index, item){
	    		ids.push(item.id);
	    	});   
	    	$.ajax({type:"post", url:"batchDel", data: {ids: ids},
	    		dataType:"json", 
	    		success: function(res) {
			    	$.messager.progress('close');
			    	grid();
		    		$.messager.alert('提示','删除成功','info');
	    	},error: function(res) {
		    	$.messager.progress('close');
		    	grid();
	    		$.messager.alert('提示',"操作失败，请重试",'info');
	    	}});
	    }
	}); 
}


</script>
</body>
</html>
