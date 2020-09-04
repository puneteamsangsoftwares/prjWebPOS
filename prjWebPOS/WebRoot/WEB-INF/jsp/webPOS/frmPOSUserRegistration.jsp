<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>


<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>USER MASTER</title>
<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/jquery-confirm.min.css"/>"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
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
.right-inner-addon i {
    position: absolute;
    right: 21px;
    top: 4px;
    pointer-events: none;
    font-size: 1.8em;
}
.right-inner-addon {
    position: relative;
}

</style>
<script type="text/javascript">


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
				boolean test = ((Boolean) session.getAttribute("success"))
						.booleanValue();
				session.removeAttribute("success");
				if (test) {%>
				confirmDialog("Data Saved \n\n" + message);
<%}
			}%>
			funLoadData();
	});


	$(document).ready(
			function() {

				$("#txtValidTill").datepicker({
					dateFormat : 'dd-mm-yy'
				});
				$("#txtValidTill").datepicker('setDate', 'today');
				$("#txtValidTill").datepicker();

				$('#clientImage').attr(
						'src',
						getContextPath()
								+ "/resources/images/imgClientImage.jpg");

				$(".tab_content").hide();
				$(".tab_content:first").show();

				$("ul.tabs li").click(function() {
					$("ul.tabs li").removeClass("active");
					$(this).addClass("active");
					$(".tab_content").hide();

					var activeTab = $(this).attr("data-state");
					$("#" + activeTab).fadeIn();
				});

				$("form").submit(function(event) {
					if ($("#txtUserName").val().trim() == "") {
						confirmDialog("Please Enter User Name","");
						return false;
					}
					if ($("#txtUserCode").val().trim() == "sanguine") {
						confirmDialog("User Code Not Allowed");
						return false;

					}

					if ($("#txtintNoOfDaysReportsView").val().trim() == "") {
						confirmDialog("Enter The Number To View The Reports","");
						return false;
					}
					if($("#txtPassword").val().trim()==''){
						
						confirmDialog("Password field is blank !!!");
						return false;
					}
					if(! $("#txtPassword").val().trim()==$("#txtConfirmPassword").val().trim())
					{
						confirmDialog("Password and Confirm Password must match !!!");
						return false;
					}
					else {
						flg = funPOSValidate();
						return flg;
					}

				});
				//$("#txtValidTill").datepicker();

			});

	//Pratiksha POS VAlidation
	function funPOSValidate() {
		var flag = false;
		$('#tblPOSDet tr').each(function() {
			var checkbox = $(this).find("input[type='checkbox']");
			if (checkbox.prop("checked")) {
				flag = true;
			}
		});

		if (!flag) {
			confirmDialog("Please select atleast one Group Code","");
			return flag;
		}
		return flag;

	}

	var userType;
	/*On form Load It Reset form :Ritesh 22 Nov 2014*/
	$(document).ready(function() {
		/* $('input#txtUserCode').mlKeyboard({
			layout : 'en_US'
		}); */

		$(".tab_content").hide();
		$(".tab_content:first").show();

		$("ul.tabs li").click(function() {
			$("ul.tabs li").removeClass("active");
			$(this).addClass("active");
			$(".tab_content").hide();

			var activeTab = $(this).attr("data-state");
			$("#" + activeTab).fadeIn();
		});
	});

	/**
	 * Open Help
	 **/
	function funHelp(transactionName) {
		fieldName = transactionName;

		window.open("searchform.html?formname=" + transactionName
				+ "&searchText=", "",
				"dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");

	}

	//Pratiksha
	function funLoadPOSData() {
		var searchurl = getContextPath() + "/loadPOSDetails.html";
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",

			success : function(response) {
				funRemoveProductRows("tblPOSDet");
				$.each(response, function(i, item) {
					funfillPOSDetail(response[i].strPosCode,
							response[i].strPosName,response[i].strApplicableYN);

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
	//Pratiksha
	function funfillPOSDetail(strPosCode, strPosName,strApplicableYN) {
		var table = document.getElementById("tblPOSDet");
		var rowCount = table.rows.length;
		var row = table.insertRow(rowCount);

		row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" margin-left=\"-80px\" size=\"5%\" name=\"listPOSData["+ (rowCount)+ "].strPosCode\" id=\"strPosCode."+ (rowCount)+ "\" value='" + strPosCode + "'>";
		row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" margin-left=\"-60px\" size=\"12%\" name=\"listPOSData["+ (rowCount)+ "].strPosName\" id=\"strPosName."+ (rowCount)+ "\" value='" + strPosName + "'>";
		row.insertCell(2).innerHTML = "<input type=\"checkbox\" name=\"listPOSData["+ (rowCount)+ "].strApplicableYN\" size=\"30%\" id=\"chkPOS."+ (rowCount) + "\" value='" + strApplicableYN + "'>";

	}

	function funGetSelectedRowIndex(obj) {
		var index = obj.parentNode.parentNode.rowIndex;
		var table = document.getElementById("tblPOSDet");
		if ((selectedRowIndex > 0) && (index != selectedRowIndex)) {
			if (selectedRowIndex % 2 == 0) {
				row = table.rows[selectedRowIndex];
				row.style.backgroundColor = '#A3D0F7';
				selectedRowIndex = index;
				row = table.rows[selectedRowIndex];
				row.style.backgroundColor = '#ffd966';
				row.hilite = true;
			} else {
				row = table.rows[selectedRowIndex];
				row.style.backgroundColor = '#C0E4FF';
				selectedRowIndex = index;
				row = table.rows[selectedRowIndex];
				row.style.backgroundColor = '#ffd966';
				row.hilite = true;
			}

		} else {
			selectedRowIndex = index;
			row = table.rows[selectedRowIndex];
			row.style.backgroundColor = '#ffd966';
			row.hilite = true;
		}

	}
	/**
	 * Get and Set data from help file and load data Based on Selection Passing Value( UserCode)
	 **/

	function funSetData(code) {
		switch (fieldName) {

		case 'POSUserRegistration':
			funUserSetData(code);
			break;
		}
	}
	function funUserSetData(code) {
		$("#txtUserCode").val(code);
		$("#txtOldUserCode").val(code);//sava old user name
		var searchurl = getContextPath()
				+ "/loadUserMasterData.html?strUserCode=" + code;
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",
			success : function(response) {
				if (response.strUserCode == 'Invalid Code') {
					alert("Invalid User Code");
					$("#txtUserCode").val('');

				} else {
					$("#txtUserName").val(response.strUserName);

					if (response.strSuperType == 'Super') {
						$("#chkSuperType").prop('checked', true);
					} else {
						$("#chkSuperType").prop('checked', false);
					}

					$("#cmbWaiterNo").val(response.strWaiterNo);
					$("#txtPassword").val(response.strPassword);
					$("#txtConfirmPassword").val(response.strPassword);
					$("#txtintNoOfDaysReportsView").val(
							response.intNoOfDaysReportsView);

					$("#txtValidTill").val(response.dteValidTill);
					//funcheckPOS(response.strPOSAccess);

					if (response.strSuperType == 'Super') {
						var table = document.getElementById("tblMastersTab");
						var rowCount = table.rows.length;
						$.each(table.rows, function(j, row) {

							var id = 'chkMasterGrantApplicable.' + j;
							document.getElementById(id).checked = true;

						});

						table = document.getElementById("tblUtilitiesTab");
						rowCount = table.rows.length;
						$.each(table.rows, function(j, row) {
							var id = 'chkUtilitiesGrantApplicable.' + j;
							document.getElementById(id).checked = "checked";
						});

						table = document.getElementById("tblTransactionsTab");
						rowCount = table.rows.length;
						$.each(table.rows, function(j, row) {
							var id = 'chkGrantApplicable.' + j;
							document.getElementById(id).checked = "checked";
							id = 'chkTLAApplicable.' + j;
							document.getElementById(id).checked = "checked";
							id = 'chkEnableAditing.' + j;
							document.getElementById(id).checked = "checked";
						});

						table = document.getElementById("tblReportsTab");
						rowCount = table.rows.length;
						$.each(table.rows, function(j, row) {
							var id = 'chkReportGrantApplicable.' + j;
							document.getElementById(id).checked = "checked";
						});

					} else {
						funLoadUserModuleTableData(code);
					}
					funcheckPOS(response.strPOSAccess);

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

	}

	//Pratiksha 20-02-2019
	function funcheckPOS(list) {
		var flag = false;
		var table = document.getElementById("tblPOSDet");
		var rowCount = table.rows.length;
		var row = table.insertRow(rowCount);

		$.each(table.rows, function(j, row) {

			document.getElementById("chkPOS." + j).checked = false;

			var pos = row.cells[0].children[0].value;
			var posData = new Array();
			var posData = list.split(',');
			var i;

			for (i = 0; i < posData.length; i++) {
				if (posData[i] == pos) {
					document.getElementById("chkPOS." + j).checked = true;
				}

			}
		});

	}

/* 	function funLoadUserModuleTableData() {
		var table = document.getElementById("tblMastersTab");
		var rowCount = table.rows.length;
		$.each(table.rows, function(j, row) {
			var id = 'chkMasterGrantApplicable.' + j;
			document.getElementById(id).checked = false;
		});

		table = document.getElementById("tblUtilitiesTab");
		rowCount = table.rows.length;
		$.each(table.rows, function(j, row) {
			var id = 'chkUtilitiesGrantApplicable.' + j;
			document.getElementById(id).checked = false;
		});

		table = document.getElementById("tblTransactionsTab");
		rowCount = table.rows.length;
		$.each(table.rows, function(j, row) {
			var id = 'chkGrantApplicable.' + j;
			document.getElementById(id).checked = false;
			id = 'chkTLAApplicable.' + j;
			document.getElementById(id).checked = false;
			id = 'chkEnableAditing.' + j;
			document.getElementById(id).checked = false;
		});

		table = document.getElementById("tblReportsTab");
		rowCount = table.rows.length;
		$.each(table.rows, function(j, row) {
			var id = 'chkReportGrantApplicable.' + j;
			document.getElementById(id).checked = false;
		});

	}
 */
 
	function funLoadData() {

		funLoadPOSData();
		funLoadTableData("M", "tblMastersTab");
		funLoadTableData("T", "tblTransactionsTab");
		funLoadTableData("U", "tblUtilitiesTab");
		funLoadTableData("R", "tblReportsTab");

	}
	/**
	 * Reset  Form
	 **/
	function funResetFields() {
		$("#txtUserName").focus();

	}

	function funLoadTableData(moduleType, tableName) {
		var searchurl = getContextPath()
				+ "/loadMasterModuleData.html?strModuleType=" + moduleType;
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",

			success : function(response) {
				funRemoveTableRows(tableName);
				$.each(response, function(i, item) {
					if (moduleType == "T") {
						funfillTransactionTableDetail(item.strModuleName,
								item.strModuleType);
					} else {
						funfillTableDetail(item.strModuleName,
								item.strModuleType, tableName);
					}
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

	//Remove Table data when pass a table ID as parameter
	function funRemoveProductRows(tableName) {
		var table = document.getElementById(tableName);
		var rowCount = table.rows.length;
		while (rowCount > 0) {
			table.deleteRow(0);
			rowCount--;
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
	//Pratiksha
	function funShowImagePreview(input) {

		if (input.files && input.files[0]) {
			var filerdr = new FileReader();
			filerdr.onload = function(e) {
				$('#clientImage').attr('src', e.target.result);
			}
			filerdr.readAsDataURL(input.files[0]);

		}
	}
	function funfillTableDetail(strModuleName, strModuleType, tableName) {
		var table = document.getElementById(tableName);
		var rowCount = table.rows.length;
		var row = table.insertRow(rowCount);

		if (strModuleType == "M") {
			row.insertCell(0).innerHTML = "<input name=\"listMasterForm["+ (rowCount)+ "].strFormName\" size=\"35%\" margin-left=\"10px\" readonly=\"readonly\" class=\"Box \" id=\"txtMasterFormName."+ (rowCount) + "\" value='" + strModuleName + "'>";
			row.insertCell(1).innerHTML = "<input type=\"checkbox\" name=\"listMasterForm["+ (rowCount)+ "].strGrant\" size=\"30%\" margin-left=\"20px\" id=\"chkMasterGrantApplicable."+ (rowCount) + "\" value='" + true + "'>";
		} else if (strModuleType == "R") {
			row.insertCell(0).innerHTML = "<input name=\"listReportForm["+ (rowCount)+ "].strFormName\" size=\"35%\"margin-left=\"10px\" readonly=\"readonly\" class=\"Box \" id=\"txtReportFormName."+ (rowCount) + "\" value='" + strModuleName + "'>";
			row.insertCell(1).innerHTML = "<input type=\"checkbox\" name=\"listReportForm["+ (rowCount)+ "].strGrant\" size=\"30%\" margin-left=\"10px\" id=\"chkReportGrantApplicable."+ (rowCount) + "\" value='" + true + "'>";
		} else if (strModuleType == "U") {
			row.insertCell(0).innerHTML = "<input name=\"listUtilitiesForm["+ (rowCount)+ "].strFormName\" size=\"35%\" margin-left=\"10px\" readonly=\"readonly\" class=\"Box \" id=\"txtUtilitiesFormName."+ (rowCount) + "\" value='" + strModuleName + "'>";
			row.insertCell(1).innerHTML = "<input type=\"checkbox\" name=\"listUtilitiesForm["+ (rowCount)+ "].strGrant\" size=\"30%\" margin-left=\"10px\" id=\"chkUtilitiesGrantApplicable."+ (rowCount) + "\" value='" + true + "'>";
		}
	}

	function funfillTransactionTableDetail(strModuleName, strModuleType) {
		var table = document.getElementById("tblTransactionsTab");
		var rowCount = table.rows.length;
		var row = table.insertRow(rowCount);

		row.insertCell(0).innerHTML = "<input name=\"listTransactionForm["+ (rowCount)+ "].strFormName\" size=\"35%\"  readonly=\"readonly\" class=\"Box \" id=\"txtTransactionFormName."+ (rowCount) + "\" value='" + strModuleName + "'>";
		row.insertCell(1).innerHTML = "<input type=\"checkbox\" name=\"listTransactionForm["+ (rowCount)+ "].strGrant\" size=\"60%\" margin-left=\"-5px\" id=\"chkGrantApplicable."+ (rowCount) + "\" value='" + true + "'>";
		row.insertCell(2).innerHTML = "<input type=\"checkbox\" name=\"listTransactionForm["+ (rowCount)+ "].strTLA\" size=\"30%\" margin-left=\"10px\" id=\"chkTLAApplicable."+ (rowCount) + "\" value='" + true + "'>";
		row.insertCell(3).innerHTML = "<input type=\"checkbox\" name=\"listTransactionForm["+ (rowCount)+ "].strAuditing\" size=\"30%\"margin-left=\"10px\" id=\"chkEnableAditing."+ (rowCount) + "\" value='" + true + "'>";
	}
	
	var check = function() {
		  if (document.getElementById('txtPassword').value ==
		    document.getElementById('txtConfirmPassword').value) {
		    document.getElementById('message').style.color = 'green';
		    document.getElementById('message').innerHTML = 'Matched';
		  } else {
		    document.getElementById('message').style.color = 'red';
		    document.getElementById('message').innerHTML = 'Not Matching';
		  }
		}
	
	function funLoadUserModuleTableData(code)
	{
		var searchurl=getContextPath()+"/loadUsersModuleData.html?userCode="+code;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        
			        success: function (response) 
			        {
						//$("#txtUserName").val(response.strUserName);
						//$("#txtUserType").val(response.strUserType);
						$.each(response.listUsersSelectedForms,function(i,item)
						{
							var table = document.getElementById("tblMastersTab");
							$.each(table.rows,function(j,row)
							{
				        		if( document.getElementById('txtMasterFormName.'+j).value==item.strFormName)
				        			{
				        			  if(item.strGrant=='true')
						        		{
				        				  var id='chkMasterGrantApplicable.'+j;
					        			  document.getElementById(id).checked="checked";
						        		}
				        			}	            				            	
				        	}); 
							
							table = document.getElementById("tblTransactionsTab");
							$.each(table.rows,function(j,row)
							{
				        		if( document.getElementById('txtTransactionFormName.'+j).value==item.strFormName)
				        			{
				        			  if(item.strGrant=='true')
						        		{
				        				  var id='chkGrantApplicable.'+j;
					        			  document.getElementById(id).checked="checked";
						        		}
				        			  if(item.strTLA=='true')
						        		{
				        				  var id='chkTLAApplicable.'+j;
					        			  document.getElementById(id).checked="checked";
						        		}
				        			  if(item.strAuditing=='true')
						        		{
				        				  var id='chkEnableAditing.'+j;
					        			  document.getElementById(id).checked="checked";
						        		}
				        			}	            				            	
				        	}); 
							
							table = document.getElementById("tblReportsTab");
							$.each(table.rows,function(j,row)
							{
				        		if( document.getElementById('txtReportFormName.'+j).value==item.strFormName)
				        			{
				        			  if(item.strGrant=='true')
						        		{
				        				  var id='chkReportGrantApplicable.'+j;
					        			  document.getElementById(id).checked="checked";
						        		}
				        			}	            				            	
				        	}); 
							
							table = document.getElementById("tblUtilitiesTab");
							$.each(table.rows,function(j,row)
							{
				        		if( document.getElementById('txtUtilitiesFormName.'+j).value==item.strFormName)
				        			{
				        			  if(item.strGrant=='true')
						        		{
				        				  var id='chkUtilitiesGrantApplicable.'+j;
					        			  document.getElementById(id).checked="checked";
						        		}
				        			}	            				            	
				        	}); 
							
							
						});
			        },
			            
			      
			        error: function(jqXHR, exception)
			        {
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
</script>

</head>

<body onload="funLoadData()">
	<div id="formHeading">
		<label>User Registration</label>
	</div>
	<s:form name="UserRegistrationForm" method="POST"
		action="savePOSUserRegistrationMaster.html?saddr=${urlHits}"
		enctype="multipart/form-data" class="formoid-default-skyblue"
		style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:100%;min-width:150px;margin-top:2%;">
		<div class="column" style="width: 42%; margin-left: 7%;">
			<div class="row"
				style="background-color: #fff; display: -webkit-box;">
				<div class="element-input col-lg-6" style="width: 30%;">
					<label class="title">User Code</label>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 40%;">
					<s:input class="large" colspan="3" type="text" id="txtUserCode"
						path="strUserCode" ondblclick="funHelp('POSUserRegistration')"
						 />
				</div>
			</div>

			<div class="row"
				style="background-color: #fff; display: -webkit-box;">
				<div class="element-input col-lg-6" style="width: 30%;">
					<label class="title">Name</label>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 40%;">
					<s:input class="large" colspan="3" type="text" id="txtUserName"
						path="strUserName" />
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<label class="title">Super User</label>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 30%; margin-left: -5%">
					<s:checkbox id="chkSuperType" path="strSuperType"
						style="width: 20%" value="Super" />
				</div>
			</div>

			<div class="row right-inner-addon" 
				style="background-color: #fff; display: -webkit-box;">
				<div class="element-input col-lg-6" style="width: 30%;">
					<label class="title">Valid Till</label>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 40%;">
					<s:input class="large" colspan="3" type="text" id="txtValidTill"
						path="dteValidTill" /><i class="fa fa-calendar"></i>
				</div>
			</div>

			<div class="row"
				style="background-color: #fff; display: -webkit-box;">
				<div class="element-input col-lg-6" style="width: 30%;">
					<label class="title">Password</label>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 40%;">
					<s:input class="large" colspan="3" type="password" id="txtPassword"
						path="strPassword" onkeyup='check();' />
				</div>
			</div>

			<div class="row"
				style="background-color: #fff; display: -webkit-box;">
				<div class="element-input col-lg-6" style="width: 30%;">
					<label class="title">Confirm Password</label>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 40%;">
					<s:input class="large" colspan="3" type="password"
						id="txtConfirmPassword" path="strConfirmPassword" onkeyup='check();'/>
						  <span id='message'></span>
						
				</div>
			</div>

			<div class="row"
				style="background-color: #fff; display: -webkit-box; margin-bottom: 10px; margin-left: 0px;">

				<div
					style="border: 1px solid #ccc; display: block; height: 150px; overflow-x: scroll; overflow-y: scroll; width: 65%;">

					<table
						style="width: 100%; overflow: scroll; background: #2FABE9; color: white;">
						<thead>
							<tr>
								<td style="border-right: 1px solid black; width: 11.4%">POS
									Code</td>
								<td style="border-right: 1px solid black; width: 12%">POS
									Name</td>
								<td style="border-right: 1px solid black; width: 10%">Select</td>

							</tr>
						</thead>
					</table>

					<table id="tblPOSDet" class="scroll" style="width: 100%;">
						<tbody style="border-top: none">

						</tbody>

					</table>
				</div>

			</div>
			<div class="row" style="background-color: #fff;">
				<div class="element-input col-lg-6">
					<label class="title">Waiter </label>
				</div>
				<div class="element-input col-lg-6" style="margin-bottom: 10px;"
					style="width: 20%;">
					<s:select id="cmbWaiterNo" colspan="3" type="text"
						path="strWaiterNo" readonly="true" style="width: 150%;"
						items="${waiterList}" />
				</div>
			</div>

			<div class="row" style="background-color: #fff;">
				<div class="element-input col-lg-6">
					<label class="title">User Image </label>
				</div>
				<div class="element-input col-lg-6" style="margin-bottom: 10px;"
					style="width: 20%;">
					<s:input class="large" colspan="3" type="text" id="txtWaiterNo"
						path="strWaiterNo" readonly="true" style="width: 150%;" />
				</div>
			</div>
			<table class="masterTable" style="width: 90px;">
				<!-- <tr style="width: 90px;">
						<td><img id="clientImage" src="" width="100px" height="100px"
							alt="Client Image" /></td>
					</tr> -->
				<tr>
					<td>
						<div>
							<input style="width: 80px;" id="companyLogo" name="companyLogo"
								type="file" accept="image/png"
								onchange="funShowImagePreview(this);" />
						</div>
					</td>
				</tr>
			</table>


			<div class="row"
				style="background-color: #fff; display: -webkit-box;">
				<div class="element-input col-lg-6" style="width: 30%;">
					<label class="title">No. of Days Report View</label>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 40%;">
					<s:input class="large" colspan="3" type="text"
						id="txtintNoOfDaysReportsView" path="intNoOfDaysReportsView" />
				</div>
			</div>

		</div>
		<div class="column" style="margin-left: 8%; width: 40%;">
			<!-- style="margin-left: 200px; width: 400px" -->
			<div id="tab_container" style="height: 200%; overflow: hidden;">

				<ul class="tabs">
					<li class="active" data-state="tab1"
						style="width: 20%; padding-left: 4%; height: 25px; border-radius: 4px; background-color: #2FABE9">Masters</li>
					<li data-state="tab2"
						style="width: 20%; padding-left: 3%; height: 25px; border-radius: 4px; background-color: #2FABE9">Transaction</li>
					<li data-state="tab3"
						style="width: 20%; padding-left: 4%; height: 25px; border-radius: 4px; background-color: #2FABE9">Utilities</li>
					<li data-state="tab4"
						style="width: 20%; padding-left: 4%; height: 25px; border-radius: 4px; background-color: #2FABE9">Reports</li>
				</ul>

				<br /> <br />
				<div id="tab1" class="tab_content">

					<div class="row"
						style="background-color: #fff; display: -webkit-box;">

						<div
							style="border: 1px solid #ccc; display: block; height: 430px; overflow-x: hidden; overflow-y: scroll; width: 100%; margin-left: 3%;">

							<table
								style="width: 100%; background-color: #2FABE9; color: white;">
								<thead style="border: 1px">
									<tr>
										<td style="border: 1px solid #ccc; width: 80%;">Module
											Name</td>
										<td style="border: 1px solid #ccc; width: 80%;">Grant</td>
									</tr>
								</thead>
							</table>

							<table id="tblMastersTab" style="width: 100%;">
								<tbody style="border-top: none">

								</tbody>
							</table>

						</div>

					</div>

				</div>

				<!-- End of Tab1 -->
				<div id="tab2" class="tab_content">

					<div class="row"
						style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">

						<div
							style="border: 1px solid #ccc; display: block; height: 430px; overflow-x: hidden; overflow-y: scroll; width: 100%; margin-left: 3%;">

							<table
								style="width: 100%; background-color: #2FABE9; color: white">
								<thead>
									<tr>
										<td style="width: 10%; border: 1px solid #ccc;">Module
											Name</td>
										<td style="width: 1%; border: 1px solid #ccc;">Grant</td>
										<td style="width: 4%; border: 1px solid #ccc;">Transaction
											Level Authentication</td>
										<td style="width: 2%; border: 1px solid #ccc;">Enable
											Auditing</td>
									</tr>
								</thead>
							</table>

							<table id="tblTransactionsTab" style="width: 100%;">
								<tbody style="border-top: none">
								<col style="width: 34%">
								<col style="width: 6%">
								<col style="width: 20%">
								<col style="width: 10%">
								</tbody>
							</table>

						</div>

					</div>

				</div>
				<div id="tab3" class="tab_content">

					<div class="row"
						style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">

						<div
							style="border: 1px solid #ccc; display: block; height: 430px; overflow-x: hidden; overflow-y: scroll; width: 100%; margin-left: 3%;">

							<table
								style="width: 100%; background-color: #2FABE9; color: white">
								<thead>
									<tr>
										<td style="width: 92%; border: 1px solid #ccc;">Module
											Name</td>
										<td>Grant</td>
									</tr>
								</thead>
							</table>

							<table id="tblUtilitiesTab" style="width: 100%;">
								<tbody style="border-top: none">

								</tbody>
							</table>

						</div>

					</div>

				</div>

				<!-- End of Tab3 -->

				<!-- Start of Tab4 -->

				<div id="tab4" class="tab_content">

					<div class="row"
						style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">

						<div
							style="border: 1px solid #ccc; display: block; height: 430px; overflow-x: hidden; overflow-y: scroll; width: 100%; margin-left: 3%;">

							<table
								style="width: 100%; background-color: #2FABE9; color: white">
								<thead>
									<tr>
										<td style="width: 92%; border: 1px solid #ccc;">Module
											Name</td>
										<td>Grant</td>
									</tr>
								</thead>
							</table>

							<table id="tblReportsTab" style="width: 100%;">
								<tbody style="border-top: none">
								</tbody>
							</table>

						</div>
					</div>
				</div>

				<!-- End of Tab4 -->
				<br />
				<div class="col-lg-10 col-sm-10 col-xs-10"
					style="width: 100%; margin-left: 20%;">

					<p align="center">
					<div class="submit col-lg-4 col-sm-4 col-xs-4">
						<input type="SUBMIT" value="SAVE" style="margin-left: -60px" />
					</div>

					<div class="submit col-lg-4 col-sm-4 col-xs-4">
						<input type="Reset" value="RESET" style="margin-left: -70px"
							onclick="funResetFields()" />
					</div>
					<div class="submit col-lg-4 col-sm-4 col-xs-4">
						<input type="button" value="CLOSE" style="margin-left: -80px" onclick="funPOSHome()"/>
					</div>
					</p>
				</div>
			</div>
		</div>
		</div>



<s:hidden path="strOldUserCode" id="txtOldUserCode" />


	</s:form>

</body>
</html>