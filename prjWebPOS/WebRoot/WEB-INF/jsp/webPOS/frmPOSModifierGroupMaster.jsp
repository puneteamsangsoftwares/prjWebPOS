<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Modifier Group Master</title>
<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/jquery-confirm.min.css"/>"/>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery-confirm.min.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/confirm-prompt.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery.autocomplete.min.js"/>"></script>
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
/*On form Load It Reset form :Ritesh 22 Nov 2014*/

var mapModGrpCodeName=new Map();
 $(document).ready(function () {
	 // $('input#txtModifierGroupName').mlKeyboard({layout: 'en_US'});
	  
	  $("form").submit(function(event){
		  if($("#txtModifierGroupName").val().trim()=="")
			{
			  confirmDialog("Please Enter Modifier group Name","");
				return false;
			}
		  else{
			  flg=funCallFormAction();
			  return flg;
		  }
		});
	  
	  $('#txtModifierGroupName').autocomplete({
			serviceUrl: '${pageContext.request.contextPath}/getAutoSearchData.html?formname=modGrpName',  
			paramName: "searchBy",
			delimiter: ",",
		    transformResult: function(response) {
		    	mapModGrpCodeName=new Map();
			return {
			  //must convert json to javascript object before process
			  suggestions: $.map($.parseJSON(response), function(item) {
			       // strValue  strCode
			        mapModGrpCodeName.set(item.strValue,item.strCode);
			      	return { value: item.strValue, data: item.strCode };
			   })
			            
			 };
			        
	        }
		 });
		 
			$('#txtModifierGroupName').blur(function() {
					var code=mapModGrpCodeName.get($('#txtModifierGroupName').val());
					if(code!='' && code!=null){
						 funSetData(code);	
					}
					
			});
	}); 


	/**
	* Reset The TextField
	**/
	function funResetFields()
	{
		$("#txtGroupName").focus();
		$("#txtOperationType").val('N');
   }
	
	
		/**
		* Open Help
		**/
		function funHelp(transactionName)
		{	       
	       // window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	       window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	    }
		
		
		/**
		* Get and Set data from help file and load data Based on Selection Passing Value(Group Code)
		**/
		
		function funGetItemCode(value) {
			window.opener.funSetData(value);
			window.close();
		}
		function funSetData(code)
		{
			$("#txtGroupCode").val(code);
			var searchurl=getContextPath()+"/loadPOSModifierGroupMasterData.html?POSModifierGPCode="+code;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strGCode=='Invalid Code')
				        	{
				        		confirmDialog("Invalid Group Code","");
				        		$("#txtModifierGroupCode").val('');
				        	}
				        	else
				        	{
				               	$("#txtModifierGroupCode").val(response.strModifierGroupCode);
					        	$("#txtModifierGroupName").val(response.strModifierGroupName);
					        	$("#txtModifierGroupName").focus();
					        	$("#txtModifierGroupShortName").val(response.strModifierGroupName);
					        	$("#cmbOperational").val(response.strOperationType);
					        	$("#cmbMinModifierSelection").val(response.strApplyMinItemLimit);
					        	$("#txtMinItemLimit").val(response.strMinItemLimit);
					        	$("#cmbMaxModifierSelection").val(response.strApplyMaxItemLimit);
					        	$("#txtMaxItemLimit").val(response.intItemMaxLimit);
					        	$("#cmbSequenceNo").val(response.strSequenceNo);		        						        	
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
			<%if (session.getAttribute("success") != null) {
				if (session.getAttribute("successMessage") != null) {%>
					message='<%=session.getAttribute("successMessage").toString()%>';
					<%session.removeAttribute("successMessage");
				}
				boolean test = ((Boolean) session.getAttribute("success")).booleanValue();
				session.removeAttribute("success");
				if (test) {%>
					confirmDialog("Data Saved \n\n"+ message,"");
				<%}
			}%>
	});

	function funCallFormAction(actionName, object) {
		var flg = true;

		var name = $('#txtModifierGroupName').val();
		var code = $('#txtModifierGroupCode').val();
		$.ajax({
			type : "GET",
			url : getContextPath() + "/checkModGrpName.html?groupName=" + name
					+ "&groupCode" + code,
			async : false,
			dataType : "text",
			success : function(response) {
				if (response == "false") {
					confirmDialog("Group Name Already Exist!","");
					$('#txtModifierGroupName').focus();
					flg = false;
				} else {
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
</script>




</head>
<body >
	<div id="formHeading">
		<label>Modifier Group Master</label>
	</div>
	<s:form name="ModgrpForm" method="POST"
		action="saveModifierGroupMaster.html?saddr=${urlHits}"
		class="formoid-default-skyblue"
		style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:100%;min-width:50%;margin-top:2%;">

		<div class="title" style="margin-left: 25%;">
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: -webkit-box;">
				<div class="element-input col-lg-6"
					style="width: 20%; margin-left: 10%">
					<label class="title">Modifier Group Code</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:input class="large" type="text" id="txtModifierGroupCode"
						path="strModifierGroupCode"
						ondblclick="funHelp('POSModifierGroupMaster')" readonly="true"
						style="width: 100%;" />
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: -webkit-box;">
				<div class="element-input col-lg-6"
					style="width: 20%; margin-left: 10%">
					<label class="title">Modifier Group Name</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:input class="large" type="text" id="txtModifierGroupName"
						name="txtModifierGroupName" path="strModifierGroupName"
						style="width: 100%;" />
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: -webkit-box;">
				<div class="element-input col-lg-6"
					style="width: 20%; margin-left: 10%">
					<label class="title">Modifier Group Short Name </label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:input class="large" type="text" id="txtModifierGroupShortName"
						path="strModifierGroupShortName" style="width: 100%;" />
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: -webkit-box;">
				<div class="element-input col-lg-6"
					style="width: 20%; margin-left: 10%">
					<label class="title">Apply MIN. Modifier Selection </label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:select id="cmbMinModifierSelection"
						path="strApplyMinItemLimit">
						<option selected="selected" value="Y">Yes</option>
						<option value="N">No</option>
					</s:select>
				</div>
				<div class="element-input col-lg-6" style="width: 30%;">
					<s:input id="txtMinItemLimit" path="strMinItemLimit" />
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: -webkit-box;">
				<div class="element-input col-lg-6"
					style="width: 20%; margin-left: 10%">
					<label class="title">Apply MAX. Modifier Selection</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:select id="cmbMaxModifierSelection"
						path="strApplyMaxItemLimit">
						<option selected="selected" value="Y">Yes</option>
						<option value="N">No</option>
					</s:select>
				</div>
				<div class="element-input col-lg-6" style="width: 30%;">
				<s:input id="txtItemMaxLimit" path="intItemMaxLimit" />
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: -webkit-box;">
				<div class="element-input col-lg-6"
					style="width: 20%; margin-left: 10%">
					<label class="title">Sequence No. </label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:select id="cmbSequenceNo" items="${listSeqNo}"
						path="strSequenceNo">
						</s:select>
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: -webkit-box;">
				<div class="element-input col-lg-6"
					style="width: 20%; margin-left: 10%">
					<label class="title">Operational</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:select id="cmbOperational"
						path="strOperationType" >
						<option selected="selected" value="YES">Yes</option>
						<option value="NO">NO</option>
					</s:select>
				</div>
				
			</div>
		</div>
	
		<br />
		<br />
		<p align="center">
			<input type="submit" value="Submit" tabindex="3" style=" margin-left: -5%;" /> <input
				type="reset" value="Reset" onclick="funResetFields()" />
		</p>
	</s:form>

</body>
</html>