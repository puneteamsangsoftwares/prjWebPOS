<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width; initial-scale=1">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Counter Master</title>
<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/jquery-confirm.min.css"/>" />
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
var selectedRowIndex=0; 
var fieldName="";
var mapDisCodeName=new Map();
	$(document).ready(function() 
	{
		var POSDate="${gPOSDate}"
		var startDate="${gPOSDate}";
	  	var Date = startDate.split(" ");
		var arr = Date[0].split("-");
			Dat=arr[2]+"-"+arr[1]+"-"+arr[0];	
		$("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy'  });
		$("#txtFromDate" ).datepicker('setDate', Dat);
		
		$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy'  });
		$("#txtToDate" ).datepicker('setDate', Dat);
	 	$("#txtDiscountOnCode").val("All");
	 	$("#txtDiscOnValue").val("All");
	 	
	 //document.getElementById("cmbDiscountOn").disabled=false;
	 
	   /* $("form").submit(function(event){
		  	var table = document.getElementById("tblDiscDtl");
		  	var rowCount = table.rows.length;
		  	if (rowCount <= 0)
          	{
		  		confirmDialog("Please Enter Discount Detail","");
            	return false;
          	}
		 	var fromDate = $("#txtFromDate").val();
		  	var toDate = $("#txtToDate").val();
		  	var frmDate= fromDate.split('-');
			Dat=frmDate[0]+frmDate[1]+frmDate[2];	
			fDate = Dat;

			var tDate= toDate.split('-');
			Dat=tDate[0]+tDate[1]+tDate[2];	
			t1Date =  Dat;
	    	var dateDiff=t1Date-fDate;
			var dateDiff=t1Date-fDate;
				
		  	if (dateDiff < 0)
	        {
			  confirmDialog("Invalid date","");
	            return false;
	        }
		 // document.getElementById("cmbDiscountOn").disabled=false;
		  
	}); */
	
	$('#txtDiscountName').autocomplete({
			serviceUrl: '${pageContext.request.contextPath}/getAutoSearchData.html?formname=discountName',  
			paramName: "searchBy",
			delimiter: ",",
		    transformResult: function(response) {
		    	mapDisCodeName=new Map();
			return {
			  //must convert json to javascript object before process
			  suggestions: $.map($.parseJSON(response), function(item) {
			       // strValue  strCode
			        mapDisCodeName.set(item.strValue,item.strCode);
			      	return { value: item.strValue, data: item.strCode };
			   })
			            
			 };
			        
	        }
		 });
	 
		$('#txtDiscountName').blur(function() {
				var code=mapDisCodeName.get($('#txtDiscountName').val());
				if(code!='' && code!=null){
					funSetData(code);	
				}
				
		});
		
	$("#cmbDiscountOn").change(function () {
		  funFillDiscountOnTypeWise();
		});
	});
	
	function funFillDiscountOnTypeWise()
	{
		if($("#cmbDiscountOn").val()=="All")
		{
			$("#txtDiscountOnCode").val("All");
			$("#txtDiscOnValue").val("All");
		}
		else if($("#cmbDiscountOn").val()=="Item")
		{
			$("#txtDiscountOnCode").val(funHelp('POSMenuItemMaster'));
		}
		else if($("#cmbDiscountOn").val()=="Group")
		{
			$("#txtDiscountOnCode").val(funHelp('POSGroupMaster'));
		}
		else if($("#cmbDiscountOn").val()=="SubGroup")
		{
			$("#txtDiscountOnCode").val(funHelp('POSSubGroupMaster'));
		}
	}
	
</script>
<script type="text/javascript">
var field;

	/**
	* Reset The Group Name TextField
	**/
	
	/* $(function() 
	{		

		$("[type='reset']").click(function(){
		location.reload(true);
		 document.getElementById("cmbDiscountOn").disabled=false;
	});
	});	 */
	
	function funHelp(transactionName) {
		fieldName=transactionName;
		window.open("searchform.html?formname=" + transactionName + "&searchText=", "",
				"dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	}
	
	/**
	* Get and Set data from help file and load data Based on Selection Passing Value(Group Code)
	**/
	
	function funSetData(code){
		var discOn = "";
		switch(fieldName){

			case 'POSDiscountMaster' : 
				funSetDiscMasterDtl(code);
				break;
			case 'POSMenuItemMaster':
				discOn = $("#cmbDiscountOn").val();
				funSetDiscOnChangeDtl(code,discOn);
				break;
			case 'POSGroupMaster':
				discOn = $("#cmbDiscountOn").val();
				funSetDiscOnChangeDtl(code,discOn);
				break;
			case 'POSSubGroupMaster':
				discOn = $("#cmbDiscountOn").val();
				funSetDiscOnChangeDtl(code,discOn);
					break;		
		}
	}
	function funSetDiscOnChangeDtl(code,discOn)
	{
		$("#txtDiscountOnCode").val(code);
		var searchurl=getContextPath()+"/loadPOSDiscountDiscountOnChangeData.html?code="+code+"&discOn="+discOn;
		 $.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strDiscountCode=='Invalid Code')
		        	{
		        		confirmDialog("Invalid Code","");
		        		$("#txtDiscountOnCode").val(''); 
		        	}
		        	else
		        	{
			        	$("#txtDiscountOnCode").val(response.strDiscountCode);
			        	$("#txtDiscOnValue").val(response.strDiscountName);
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

	function funSetDiscMasterDtl(code)
	{
		$("#tblDiscDtl tbody").empty(); 
		$("#txtDiscountCode").val(code);
		var searchurl=getContextPath()+"/loadPOSDiscountMasterData.html?discCode="+code;
		 $.ajax({
	        type: "GET",
	        url: searchurl,
	        dataType: "json",
	        success: function(response)
	        {
	        	if(response.strDiscountCode=='Invalid Code')
	        	{
	        		confirmDialog("Invalid Discount Code","");
	        		$("#txtDiscountCode").val(''); 
	        	}
	        	else
	        	{
	        		if(response.strDineIn=='Y')
		        	{
		        		$("#chkDiningIn").attr('checked', true);
		        	}
		        	else
		        	{
		        		$("#chkDiningIn").attr('unchecked', false);
		        	}
	        		if(response.strHomeDelivery=='Y')
		        	{
		        		$("#chkHomeDelivery").attr('checked', true);
		        	}
		        	else
		        	{
		        		$("#chkHomeDelivery").attr('unchecked', false);
		        	}
	        		if(response.strTakeAway=='Y')
		        	{
		        		$("#chkTakeAway").attr('checked', true);
		        	}
		        	else
		        	{
		        		$("#chkTakeAway").attr('unchecked', false);
		        	}
		        	$("#txtDiscountCode").val(response.strDiscountCode);
		        	$("#txtDiscountName").val(response.strDiscountName);
		        	$("#txtFromDate").val(response.dteFromDate);
		        	$("#txtToDate").val(response.dteToDate);
		        	$("#cmbPOSName").val(response.strPosCode);
		        	$("#cmbDiscountOn").val(response.strDiscountOn);
		        	$("#txtDiscountOnCode").val(response.listDiscountDtl[0].discountReasonCode);
		        	$("#txtDiscOnValue").val(response.listDiscountDtl[0].strDiscoutnName);
		        	$("#txtDiscountValue").val(response.listDiscountDtl[0].discountOnValue);
		        	$("#cmbDiscTye").val(response.listDiscountDtl[0].discountOnType);
		        	//document.getElementById("cmbDiscountOn").disabled=true;
		        	$.each(response.listDiscountDtl, function(i,item)
					{			
			    		funAddRow(item.discountReasonCode,item.strDiscoutnName,item.discountOnType,item.discountOnValue);
			    	});
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
		var message = '';
		<%if (session.getAttribute("success") != null) {
			if (session.getAttribute("successMessage") != null) {%>
				message='<%=session.getAttribute("successMessage").toString()%>';
				<%session.removeAttribute("successMessage");
			}
			boolean test = ((Boolean) session.getAttribute("success")).booleanValue();
			session.removeAttribute("success");
			if (test) {%>
				confirmDialog("Data Saved \n\n" + message, "");
			<%}
		}%>
	});

	function btnAdd_onclick() {
		var discOn = $("#cmbDiscountOn").val();
		var discTye = $("#cmbDiscTye").val();
		var discountOnCode = $("#txtDiscountOnCode").val();
		var discValue = $("#txtDiscountValue").val();
		var discountOnName = $("#txtDiscOnValue").val();
		var e = document.getElementById("cmbDiscTye");
		var str = e.options[e.selectedIndex].text;
		if ($("#txtDiscountName").val() == "") {
			confirmDialog("Please Enter Discount Name", "");
			return false;
		}
		else if (discValue <= 0) {
			confirmDialog("Enter Discount Value", "");
			return false;
		}
		else if (str == "Percentage") 
		{
			if(discValue > 99)
			{
				confirmDialog("Percentage should be less than 99%", "");
			}
			else 
			{
				funAddRow(discountOnCode, discountOnName, discTye, discValue);
				var table = document.getElementById("tblDiscDtl");
				var rowCount = table.rows.length;
				if (rowCount > 0) {
					/* $("#txtDiscountName").val("");
					$("#txtDiscountOnCode").val("");
					$("#txtDiscOnValue").val("");
					$("#txtDiscountValue").val("0.0"); */
				}
			} 
		}
	}

	function funAddRow(discountOnCode, discountOnName, discTye, discValue) {
		var table = document.getElementById("tblDiscDtl");
		var rowCount = table.rows.length;
		var row = table.insertRow(rowCount);

		var discOn = $("#cmbDiscountOn").val();
		var isExists = false;
		for (var i = 0; i < rowCount; i++) {
			var tblDiscOnCode = table.rows[i].cells[0].children[0].value;
			if (discountOnCode == tblDiscOnCode) {
				isExists = true;
				break;
			}
		}
		if (isExists) {
			confirmDialog("Duplicate Discount.", "");
			return;
		}

		var isValid = true;
		for (var i = 0; i < rowCount; i++) {
			var tblDiscOnCode = table.rows[i].cells[0].children[0].value;
			if (tblDiscOnCode == "All") {
				isValid = false;
				break;
			}
		}
		if (!isValid) {
			confirmDialog("Invalid Discount Details.", "");
			return;
		}

		if (rowCount > 0 && discOn == "All") {
			confirmDialog("Invalid Discount Details.", "");
			return;
		}

		row.insertCell(0).innerHTML = "<input type=\"hidden\" class=\"Box\" name=\"listDiscountDtl["
				+ (rowCount)
				+ "].discountReasonCode\" size=\"0%\"  id=\"txtDiscOnCode."
				+ (rowCount)
				+ "\" value='"
				+ discountOnCode
				+ "' onclick=\"funGetSelectedRowIndex(this)\"/>";
		row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" name=\"listDiscountDtl["
				+ (rowCount)
				+ "].strDiscoutnName\" size=\"35%\"  id=\"txtDiscName."
				+ (rowCount)
				+ "\" value='"
				+ discountOnName
				+ "' onclick=\"funGetSelectedRowIndex(this)\"/>";
		row.insertCell(2).innerHTML = "<input class=\"Box\" readonly=\"readonly\" name=\"listDiscountDtl["
				+ (rowCount)
				+ "].discountOnType\" size=\"30%\"  id=\"txtDiscOnType."
				+ (rowCount)
				+ "\" value='"
				+ discTye
				+ "' onclick=\"funGetSelectedRowIndex(this)\"/>";
		row.insertCell(3).innerHTML = "<input class=\"Box\" readonly=\"readonly\" name=\"listDiscountDtl["
				+ (rowCount)
				+ "].discountOnValue\" size=\"16%\"  id=\"txtDiscOnValue."
				+ (rowCount)
				+ "\" value='"
				+ discValue
				+ "' onclick=\"funGetSelectedRowIndex(this)\"/>";

	}
	function funGetSelectedRowIndex(obj) {
		var index = obj.parentNode.parentNode.rowIndex;
		var table = document.getElementById("tblDiscDtl");
		if ((selectedRowIndex > 0) && (index != selectedRowIndex)) {
			if (selectedRowIndex % 2 == 0) {
				row = table.rows[selectedRowIndex];
				row.style.backgroundColor = '#b9def8';
				selectedRowIndex = index;
				row = table.rows[selectedRowIndex];
				row.style.backgroundColor = '#ffd966';
				row.hilite = true;
			} else {
				row = table.rows[selectedRowIndex];
				row.style.backgroundColor = '#b9def8';
				selectedRowIndex = index;
				row = table.rows[selectedRowIndex];
				row.style.backgroundColor = '#ffd966';
				row.hilite = true;
			}

		} 
		else {
			selectedRowIndex = index;
			row = table.rows[selectedRowIndex];
			row.style.backgroundColor = '#ffd966';
			row.hilite = true;
		}
	}

	function btnRemove_onclick() {
		var table = document.getElementById("tblDiscDtl");
		table.deleteRow(selectedRowIndex);
	}

	//Reset Filed after Clicking Reset Button
	function funResetFields() {
		$('#tblDiscDtl tbody').empty();
		$("#chkHomeDelivery").attr('checked', false);
		$("#chkDiningIn").attr('checked', false);
		$("#chkTakeAway").attr('checked', false);
		$("#txtFromDate").val()
		$("#txtToDate").val();
	}
</script>
</head>
<body>

	<div id="formHeading">
		<label>Discount Master</label>
	</div>

	<br />
	<br />

	<s:form name="DiscountMaster" method="POST" action="savePOSDiscountMaster.html?saddr=${urlHits}" class="formoid-default-skyblue"
		style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:99%;min-width:99%;margin-top:1%;">

		<div
			style="width: 90%; height: 100%; border: 0px solid black; margin-left: 8%; margin-right: auto;">

			<div class="row"
				style="background-color: #fff; display: block; margin-bottom: 10px; margin-left: 20px; border: 0px solid black; float: left;">
				<div class="element-input col-lg-6"
					style="width: 15%; margin-top: 5px;">
					<label class="title">Discount Code</label>
				</div>
				<div class="element-input col-lg-6" style="width: 15%;">
					<s:input id="txtDiscountCode" path="strDiscountCode"
						readonly="true" ondblclick="funHelp('POSDiscountMaster')" />
				</div>
				<div class="element-input col-lg-6"
					style="width: 15%; margin-top: 5px; margin-left: 7%;">
					<label class="title">Discount Name</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:input type="text" style="width:70%; margin-left:10px;" id="txtDiscountName"
						path="strDiscountName" />
				</div>
			</div>

			<div class="row"
				style="background-color: #fff; display: block; border: 0px solid black; margin-bottom: 10px; margin-left: 20px;">
				<div class="element-input col-lg-6"
					style="width: 15%; margin-top: 5px;">
					<label class="title">POS</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 15%; border: 0px solid black;">
					<s:select id="cmbPOSName" path="strPosCode" items="${posList}" />
				</div>

				<div class="element-input col-lg-6"
					style="width: 11%; margin-top: 2px; margin-left: 7%">
					<label class="title">Discount On</label>
				</div>

				<div class="element-input col-lg-6"
					style="width: 3%; margin-left: 10px;">
					<s:input type="checkbox" id="chkDiningIn" path="strDineIn"
						checked="checked"></s:input>
				</div>
				<div class="element-input col-lg-6"
					style="width: 10%; margin-top: 2px;">
					<label class="title" style="width: 100%">Dining In</label>
				</div>

				<div class="element-input col-lg-6" style="width: 3%;">
					<s:input type="checkbox" id="chkHomeDelivery"
						path="strHomeDelivery"></s:input>
				</div>
				<div class="element-input col-lg-6"
					style="width: 11%; margin-top: 2px;">
					<label class="title" style="width: 100%">Home Delivery</label>
				</div>

				<div class="element-input col-lg-6" style="width: 3%;">
					<s:input type="checkbox" id="chkTakeAway" path="strTakeAway"></s:input>
				</div>
				<div class="element-input col-lg-6"
					style="width: 10%; margin-top: 2px;">
					<label class="title" style="width: 100%">Take Away</label>
				</div>
			</div>

			<div class="row"
				style="background-color: #fff; display: block; margin-bottom: 10px; margin-left: 20px;">
				<div class="element-input col-lg-6"
					style="width: 15%; margin-top: 5px;">
					<label class="title">From Date</label>
				</div>
				<div class="element-input col-lg-6" style="width: 25%;">
					<s:input id="txtFromDate" required="required" path="dteFromDate"
						pattern="\d{1,2}-\d{1,2}-\d{4}" />
				</div>
				<div class="element-input col-lg-6"
					style="width: 7%; margin-top: 5px;">
					<label class="title">To Date</label>
				</div>
				<div class="element-input col-lg-6" style="width: 25%;">
					<s:input id="txtToDate" required="required" path="dteToDate"
						pattern="\d{1,2}-\d{1,2}-\d{4}" />
				</div>
			</div>

			<div class="row"
				style="background-color: #fff; display: block; margin-bottom: 10px; margin-left: 20px;">
				<div class="element-input col-lg-6"
					style="width: 15%; margin-top: 5px;">
					<label class="title">Discount On</label>
				</div>
				<div class="element-input col-lg-6" style="width: 15%;">
					<s:select id="cmbDiscountOn" path="strDiscountOn">
						<option value="All">All</option>
						<option value="Item">Item</option>
						<option value="Group">Group</option>
						<option value="SubGroup">SubGroup</option>
					</s:select>
				</div>
				<div class="element-input col-lg-6" style="width: 15%;">
					<s:input id="txtDiscountOnCode" required="required"
						path="strDiscountOnCode" readonly="true"
						onclick="funFillDiscountOnTypeWise()" />
				</div>
				<div class="element-input col-lg-6"
					style="width: 15%; margin-left: 35px;">
					<s:input id="txtDiscOnValue" required="required"
						path="strDiscOnValue" readonly="true" />
				</div>
			</div>

			<div class="row"
				style="background-color: #fff; display: block; margin-bottom: 10px; margin-left: 20px;">
				<div class="element-input col-lg-6"
					style="width: 15%; margin-top: 5px;">
					<label class="title">Discount Type</label>
				</div>
				<div class="element-input col-lg-6" style="width: 15%;">
					<s:select id="cmbDiscTye" name="cmbDiscTye" path="strDiscountType">
						<option value="Percentage">Percentage</option>
						<option value="Amount">Amount</option>
					</s:select>

				</div>
				<div class="element-input col-lg-6"
					style="width: 18%; border: 0px solid black;">
					<s:input id="txtDiscountValue" type="number" required="required"
						path="dblDiscountValue" style="text-align: right;" />
				</div>
				<div class="element-input col-lg-6"
					style="width: 11%; margin-right: 5px; border: 0px solid black;">
					<input id="btnAdd" type="button" value="Add"
						onclick="return btnAdd_onclick();" style="width: 100px;">
				</div>
				<div class="element-input col-lg-6"
					style="width: 11%; border: 0px solid black;">
					<input id="btnRemove" type="button" value="Remove"
						onclick="return btnRemove_onclick(); ">
				</div>
			</div>

			<div class="row" style="background-color: #fff; display: block; margin-bottom: 10px;">
				<div style="border: 1px solid #ccc; height: 300px; overflow-x: hidden; overflow-y: scroll; width: 90%; margin-left: 50px;">
					<table
						style="width: 100%; background: #2FABE9; color: white; border: 1px solid #ccc;">
						<thead>
							<tr>
								<th style="width: 40%">Name</th>
								<th style="width: 35%">Discount Type</th>
								<th style="width: 20%">Value</th>
							</tr>
						</thead>
					</table>

					<table id="tblDiscDtl" style="width: 100%;">
						<tbody>

						</tbody>
					</table>

				</div>
			</div>

		</div>

		<div class="col-lg-10 col-sm-10 col-xs-10" style="width: 70%; margin-left: 25%;">
			<p align="center">
				<div class="submit col-lg-4 col-sm-4 col-xs-4" style="width: 20%; margin-left: 15%;">
					<input type="submit" value="Submit" />
				</div>
				<div class="submit col-lg-4 col-sm-4 col-xs-4">
					<input type="reset" value="Reset" onclick="funResetFields();" />
				</div>
			</p>
		</div>

		</div>
	</s:form>
</body>
</html>
