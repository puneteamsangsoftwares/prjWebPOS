<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Counter Master</title>
<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/jquery-confirm.min.css"/>"/>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery-confirm.min.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/confirm-prompt.js"/>"></script>
		
<style>
.ui-autocomplete {
	max-height: 200px;
	overflow-y: auto;
	/* prevent horizontal scrollbar */
	overflow-x: hidden;
	/* add padding to account for vertical scrollbar */
	padding-right: 20px;
}
/* IE 6 doesn't support max-height
 * we use height instead, but this forces the menu to always be this tall
 */
* html .ui-autocomplete {
	height: 200px;
}
</style>
<script type="text/javascript">
	$(document).ready(function() {

		 $('input#txtCounterCode').mlKeyboard({layout: 'en_US'});
		  $('input#txtCounterName').mlKeyboard({layout: 'en_US'});
		 
		  $("form").submit(function(event){
			  if($("#txtCounterName").val().trim()=="")
				{
				  confirmDialog("Please Enter Counter Name","");
					return false;
				}
			  
			  else{
				  flg=funChekTable();
				  return flg;
			  }
			});
		});
	
</script>
<script type="text/javascript">
var field;


	/**
	* Reset The Group Name TextField
	**/
	function funResetFields()
	{
		$("#txtCounterCode").focus();
		
    }
	
	
		
		function funHelp(transactionName)
		{	  
	     
	       window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	    }
		
		

		
		function funSetData(code)
		{
			$("#txtCounterCode").val(code);
			var searchurl=getContextPath()+"/loadCounterMasterData.html?counterCode="+code;		
			 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        async: false,
			        success: function(response)
			        {
			        	if(response.strCounterCode=='Invalid Code')
			        	{
			        		alert("Invalid Group Code");
			        		$("#txtCounterCode").val('');
			        	}
			        	else
			        	{
			        		$("#txtCounterCode").val(response.strCounterCode);
				        	$("#txtCounterName").val(response.strCounterName);
				        	$("#cmbOperational").val(response.strOperational);
				        	$("#cmbUserName").val(response.strUserCode);
				        	$("#cmbPOSName").val(response.strPOSCode);
				        	
				        
				        	
				        	
				        	//fill MenuHead Table
			        		funRemoveTableRows("tblMenuHead");
			        		funLoadMenuHeadDtlDataForUpdate(response.listMenuHeadDtl);
				        	
			        	}
					},
					error: function(jqXHR, exception) {
			            if (jqXHR.status === 0) {
			                alert('Not connect.n Verify Network.');
			            } else if (jqXHR.status == 404) {
			                alert('Requested page not found. [404]');
			            } else if (jqXHR.status == 500) {
			                alert('Internal Server Error [500].');
			            } else if (exception === 'parsererror') {
			                alert('Requested JSON parse failed.');
			            } else if (exception === 'timeout') {
			                alert('Time out error.');
			            } else if (exception === 'abort') {
			                alert('Ajax request aborted.');
			            } else {
			                alert('Uncaught Error.n' + jqXHR.responseText);
			            }		            
			        }
		      });
		}
		


		/**
		* Success Message After Saving Record
		**/
		$(document).ready(function()
		{
			var message='';
			<%if (session.getAttribute("success") != null) 
			{
				if(session.getAttribute("successMessage") != null)
				{%>
					message='<%=session.getAttribute("successMessage").toString()%>';
				    <%
				    session.removeAttribute("successMessage");
				}
				boolean test = ((Boolean) session.getAttribute("success")).booleanValue();
				session.removeAttribute("success");
				if (test) 
				{
					%>confirmDialog('Message !','Data Saved'+message);<%
				}
			}%>
		});

	function funLoadMenuHeadDtlData() {

		var searchurl = getContextPath() + "/loadMenuHeadDtlData.html";
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",

			success : function(response) {
				funRemoveTableRows("tblMenuHead");
				// for (var i in response){		            	
				$.each(response, function(i, item) {

					funfillMenuHeadDtlGrid(item.strMenuHeadCode,
							item.strMenuHeadName, null);

				});

			},

			error : function(jqXHR, exception) {
				if (jqXHR.status === 0) {
					alert('Not connect.n Verify Network.');
				} else if (jqXHR.status == 404) {
					alert('Requested page not found. [404]');
				} else if (jqXHR.status == 500) {
					alert('Internal Server Error [500].');
				} else if (exception === 'parsererror') {
					alert('Requested JSON parse failed.');
				} else if (exception === 'timeout') {
					alert('Time out error.');
				} else if (exception === 'abort') {
					alert('Ajax request aborted.');
				} else {
					alert('Uncaught Error.n' + jqXHR.responseText);
				}
			}
		});
	}

	function funLoadMenuHeadDtlDataForUpdate(list) {

		var searchurl = getContextPath() + "/loadMenuHeadDtlData.html";
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",

			success : function(response) {
				funRemoveTableRows("tblMenuHead");

				$.each(response, function(i, item) {

					funfillMenuHeadDtlGrid(item.strMenuHeadCode,
							item.strMenuHeadName, list);

				});

			},

			error : function(jqXHR, exception) {
				if (jqXHR.status === 0) {
					alert('Not connect.n Verify Network.');
				} else if (jqXHR.status == 404) {
					alert('Requested page not found. [404]');
				} else if (jqXHR.status == 500) {
					alert('Internal Server Error [500].');
				} else if (exception === 'parsererror') {
					alert('Requested JSON parse failed.');
				} else if (exception === 'timeout') {
					alert('Time out error.');
				} else if (exception === 'abort') {
					alert('Ajax request aborted.');
				} else {
					alert('Uncaught Error.n' + jqXHR.responseText);
				}
			}
		});
	}

	function funfillMenuHeadDtlGrid(strMenuHeadCode, strMenuHeadName, list) {
		var flag = false;

		var table = document.getElementById("tblMenuHead");
		var rowCount = table.rows.length;
		var row = table.insertRow(rowCount);

		row.insertCell(0).innerHTML = "<input name=\"listMenuHeadDtl["
				+ (rowCount)
				+ "].strMenuHeadCode\" readonly=\"readonly\" class=\"Box \" size=\"35%\" id=\"txtMenuHeadCode."
				+ (rowCount) + "\" value='" + strMenuHeadCode + "'>";
		row.insertCell(1).innerHTML = "<input name=\"listMenuHeadDtl["
				+ (rowCount)
				+ "].strMenuHeadName\" readonly=\"readonly\" class=\"Box \" size=\"35%\" id=\"txtMenuHeadName."
				+ (rowCount) + "\" value='" + strMenuHeadName + "'>";
		// row.insertCell(2).innerHTML= "<input type=\"checkbox\" name=\"listMenuHeadDtl["+(rowCount)+"].strOperational\" size=\"30%\" id=\"chkOperational."+(rowCount)+"\" value='"+true+"'>";

		$
				.each(
						list,
						function(i, item) {
							if (item.strMenuHeadCode == strMenuHeadCode) {
								flag = true;
								row.insertCell(2).innerHTML = "<input type=\"checkbox\" name=\"listMenuHeadDtl["
										+ (rowCount)
										+ "].strOperational\" size=\"30%\" id=\"chkOperational."
										+ (rowCount)
										+ "\" checked=\"checked\">";

							}

						});
		if (!flag) {
			row.insertCell(2).innerHTML = "<input type=\"checkbox\" name=\"listMenuHeadDtl["
					+ (rowCount)
					+ "].strOperational\" size=\"30%\" id=\"chkOperational."
					+ (rowCount) + "\" value='" + true + "'>";
		}

	}

	function funRemoveTableRows(tableId) {
		var table = document.getElementById(tableId);
		var rowCount = table.rows.length;
		while (rowCount > 0) {
			table.deleteRow(0);
			rowCount--;
		}
	}

	/**
	 *  Check Validation Before Saving Record
	 **/
	function funCallFormAction() {
		var flg = true;

		// 					if($('#txtCounterCode').val()=='')
		// 					{
		var code = $('#txtCounterCode').val();
		var counterName = $('#txtCounterName').val();
		$.ajax({
			type : "GET",
			url : getContextPath() + "/checkCounterName.html?strCounterCode="
					+ counterCode + "&strCounterName=" + counterName,
			async : false,
			dataType : "text",
			success : function(response) {
				if (response == "false") {
					confirmDialog("This Counter Name is Already Exist!","");
					$('#txtCounterName').focus();
					flg = false;
				}

				else {
					flg = true;
				}
			},
			error : function(jqXHR, exception) {
				if (jqXHR.status === 0) {
					alert('Not connect.n Verify Network.');
				} else if (jqXHR.status == 404) {
					alert('Requested page not found. [404]');
				} else if (jqXHR.status == 500) {
					alert('Internal Server Error [500].');
				} else if (exception === 'parsererror') {
					alert('Requested JSON parse failed.');
				} else if (exception === 'timeout') {
					alert('Time out error.');
				} else if (exception === 'abort') {
					alert('Ajax request aborted.');
				} else {
					alert('Uncaught Error.n' + jqXHR.responseText);
				}
			}

		});

		return flg;
	}

	function funChekTable() {
		var flag = false;

		$('#tblMenuHead tr').each(function() {
			var checkbox = $(this).find("input[type='checkbox']");

			if (checkbox.prop("checked")) {
				flag = true;
			}
		});

		if (!flag) {
			confirmDialog("Please select atleast one menu head","");
			return flag;
		}

		flag = funCallFormAction();
		return flag;
	}
</script>
</head>
<body onload="funLoadMenuHeadDtlData()">

	<div id="formHeading">
		<label>CounterMaster</label>
	</div>

	<br />
	<br />

	<s:form name="CounterMaster" method="POST"
		action="savePOSCounterMaster.html?saddr=${urlHits}"
		class="formoid-default-skyblue"
		style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:880px;min-width:150px;margin-top:2%;">
		<div class="title" style="margin-left: 10%;">

			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: -webkit-box;">
				<div class="element-input col-lg-6"
					style="width: 20%; margin-left: 10%">
					<label class="title">Counter Code</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:input class="large" type="text" id="txtCounterCode"
						name="txtCounterCode" path="strCounterCode"
						ondblclick="funHelp('POSCounterMaster')" readonly="true"
						style="width: 100%;" />
				</div>
				<div class="element-input col-lg-6"
					style="width: 20%; margin-left: 10%">
					<label class="title">Counter Name</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:input class="large" type="text" id="txtCounterName"
						name="txtCounterName" path="strCounterName" style="width: 100%;" />
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: -webkit-box;">
				<div class="element-input col-lg-6"
					style="width: 20%; margin-left: 10%">
					<label class="title">Operational</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:select id="cmbOperational" name="cmbOperational"
						path="strOperational">
						<option value="Yes">Yes</option>
						<option value="No">No</option>
					</s:select>
				</div>
				<div class="element-input col-lg-6"
					style="width: 20%; margin-left: 10%">
					<label class="title">UserCode</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:select id="cmbUserName" name="cmbUserName" path="strUserCode"
						items="${userList}" />
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: -webkit-box;">
				<div class="element-input col-lg-6"
					style="width: 20%; margin-left: 10%">
					<label class="title">POS</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:select id="cmbPOSName" name="cmbPOSName" path="strPOSCode"
						items="${posList}" />

				</div>
			</div>
			<div
				style="border: 1px solid #ccc; display: block; height: 400px; margin: auto; margin-top: 2px; overflow-x: hidden; overflow-y: scroll; width: 100%;">

				<table class="scroll"
					style="height: 20px; border: #0F0; width: 100%; font-size: 15px; font-weight: bold;">
					<thead style="background: #2FABE9; color: white;">
						<tr>
							<th style="width: 36.5%">Menu Code</th>
							<th style="width: 36.5%">Menu Name</th>
							<th style="width: 5.5%">Select</th>
						</tr>

					</thead>
				</table>
				<div class="row"
					style="display: block; height: 85%; margin: auto; width: 100%;">
					<table id="tblMenuHead" style="width: 100%;">
						<tbody>
						<col style="width: 40%;">
						<!--  COl1   -->
						<col style="width: 40%">
						<!--  COl2   -->
						<col style="width: 4%;">
						<!--  COl3   -->
						</tbody>
					</table>
				</div>
			</div>
			<%-- <table class="masterTable">
			<tr>
				<td>
					<label>CounterCode</label>
				</td>
				<td>
					<s:input id="txtCounterCode" name="txtCounterCode" path="strCounterCode" ondblclick="funHelp('POSCounterMaster')"/>
				</td>
			
				<td>
					<label>CounterName</label>
				</td>
				<td>
					<s:input id="txtCounterName" name="txtCounterName" path="strCounterName"  />
				</td>
			</tr>
			<tr>
				<td>
					<label>Operational</label>
				</td>
				<td>
				<s:select id="cmbOperational" name="cmbOperational" path="strOperational" >
				    <option value="Yes">Yes</option>
				    <option value="No">No</option>
				</s:select>
				</td>
			
				<td>
					<label>UserCode</label>
				</td>
				<td>
					<s:select id="cmbUserName" name="cmbUserName" path="strUserCode" items="${userList}" />
				</td>
			</tr>
			<tr>
				<td>
					<label>POS</label>
				</td>
				<td>
					<s:select id="cmbPOSName" name="cmbPOSName" path="strPOSCode" items="${posList}" />
				</td>
				<td></td>
				<td></td>
			</tr>
			<tr></tr>
		</table>
		<table border="1" class="myTable" style="width: 80%; margin:auto;" >
										<thead>
										<tr>
											<th style="width:36.5%">Menu Code</th>
											<th style="width:36.5%">Menu Name</th>
											<th style="width:5.5%">Select</th>
										</tr>
										
										</thead>
										</table>
										<div style="background-color: #a4d7ff;border: 1px solid #ccc;display: block; height: 150px;
			    				margin:auto;overflow-x: hidden; overflow-y: scroll;width: 80%;">
									<table id="tblMenuHead" class="transTablex col5-center" style="width: 100%;">
									<tbody>    
											<col style="width:40%;"><!--  COl1   -->
											<col style="width:40%"><!--  COl2   -->
											<col style="width:4%;"><!--  COl3   -->								
									</tbody>							
									</table>
									
						
							</div> --%>
			<br /> <br />

			<p align="center">
				<input type="submit" value="Submit" tabindex="3" /> <input
					type="reset" value="Reset" onclick="funResetFields()" />
			</p>
	</s:form>
</body>
</html>
