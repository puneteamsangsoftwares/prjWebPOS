<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Cost Center Master</title>
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
var fieldName="";
 $(document).ready(function () {
	  $('input#txtCostCenterCode').mlKeyboard({layout: 'en_US'});
	  $('input#txtCostCenterName').mlKeyboard({layout: 'en_US'});
		
	  $('input#txtLabelOnKOT').mlKeyboard({layout: 'en_US'});
	  
	  $("form").submit(function(event){
		  if($("#txtCostCenterName").val().trim()=="")
			{
			  confirmDialog("Please Enter Cost Center Name","");
				return false;
			}
		  if($("#txtCostCenterName").val().length > 20)
			{
			  confirmDialog("Cost Center Name length must be less than 20","");
				return false;
			}
		  else{
			  flg=funCallFormAction();
			  return flg;
		  }
		});

		$("#cmbPrinterPort").val("");
	    $("#cmbSecondaryPrinterPort").val("");
	
	});  
 

 var field;


 	/**
 	* Reset The Cost Center Name TextField
 	**/
 	function funResetFields()
 	{
 		$("#txtPOSCode").focus();	
    }
     
 	
 	
 		/**
 		* Open Help
 		**/
 		function funHelp(transactionName)
 		{	   field= transactionName.split(".") ;
 		
 		transactionName=field[0];
 	       // window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
 	       window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
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
					%>confirmDialog('Message !',"Data Saved \n\n"+ message);<%
				}
			}%>
		});

	//Initialize tab Index or which tab is Active

	function funHelp(transactionName)
	{
		fieldName=transactionName;
 		// window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
       window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
    }
	
	/**
	* Get and Set data from help file and load data Based on Selection Passing Value(Cost Center Code)
	**/
	function funSetData(code)
	{
		$("#txtCostCenterCode").val(code);
		var searchurl=getContextPath()+"/loadCostCenterMasterData.html?POSCostCenterCode="+code;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strCustomerTypeMasterCode=='Invalid Code')
			        	{
			        		alert("Invalid Cost Center Code");
			        		$("#txtCostCenterCode").val('');
			        	}
			        	else
			        	{
				        	$("#txtCostCenterCode").val(response.strCostCenterCode);
				  		    $("#txtCostCenterName").val(response.strCostCenterName);
				        	$("#txtCostCenterName").focus();
				           	$("#txtLabelOnKOT").val(response.strLabelOnKOT);
				           	$("#cmbPrinterPort").val(response.strPrinterPort);
				           	$("#cmbSecondaryPrinterPort").val(response.strSecondaryPrinterPort);
				           	
				           	if(response.strPrintOnBothPrinters=='Y')
			        		{
				        		$("#chkPrintOnBothPrinters").prop('checked',true);
			        		}
				        	
				  		    $("#txtPrimaryPrinterNoOfCopies").val(response.intPrimaryPrinterNoOfCopies);
				  		    $("#txtSecondaryPrinterNoOfCopies").val(response.intSecondaryPrinterNoOfCopies);


				           	
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
	*  Check Validation Before Saving Record
	**/
	function funCallFormAction() 
	{
		var flg=true;
		
// 		if($('#txtCostCenterCode').val()=='')
// 		{
			var costCenterCode = $('#txtCostCenterCode').val();
			var costCenterName = $('#txtCostCenterName').val();
			 $.ajax({
			        type: "GET",
			        url: getContextPath()+"/checkCostCenterName.html?strCostCenterCode="+costCenterCode+"&strCostCenterName="+costCenterName,
			        async: false,
			        dataType: "text",
			        success: function(response)
			        {
			        	if(response=="false")
			        		{
			        			alert("This Cost Center Name is Already Exist!");
			        			$('#txtCostCenterName').focus();
			        			flg= false;
				    		}
			        	
				    	else
				    		{
				    			flg=true;
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
		
		
		
		return flg;
	}
	
	
	
	function funTestPrint(printerval)
	{

		 var searchurl=getContextPath()+"/testPrint.html";
		 $.ajax({
			        type: "POST",
			        data:{ printerval : printerval,
		 	        	
		 			},
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	
			            	        	
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
/* 	Pratiksha 22-04-2019
 */	
 function funTestPrinterStatus() {
		if ($("#cmbPrinterPort").val() == '') {
			alert("Please Select Printer Name.");
			return;
		}

		var PrinterName = $("#cmbPrinterPort").val();
		var searchurl = getContextPath()
				+ "/testPrimaryPrinterStatus.html?PrinterName=" + PrinterName;
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",
			success : function(response) {
				alert(response.Status);
			},
			error : function(e) {
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
 
 function funTestSecondaryPrinterStatus() {
		if ($("#cmbSecondaryPrinterPort").val() == '') {
			alert("Please Select Printer Name.");
			return;
		}

		var PrinterName = $("#cmbSecondaryPrinterPort").val();
		var searchurl = getContextPath()
				+ "/testSecondaryPrinterStatus.html?PrinterName=" + PrinterName;
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",
			success : function(response) {
				alert(response.Status);
			},
			error : function(e) {
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
<body> 

	<div id="formHeading">
	<label>Cost Center Master</label>
	</div>

<br/>

	<s:form name="Cost Center Master" method="POST" action="saveCostCenterMaster.html?saddr=${urlHits}" class="formoid-default-skyblue" style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:880px;min-width:150px;margin-top:2%;" >

		<div class="title" style=" margin-left: 25%;">
		
			<div class="row" style="background-color: #fff;display: -webkit-box;">
				<div class="element-input col-lg-6" style="width: 30%;"> 
    				<label class="title">Cost Center Code</label>
    			</div>
    			<div class="element-input col-lg-6" style="margin-bottom:  10px;width: 30%;"> 
					<s:input class="large" colspan="3" type="text" id="txtCostCenterCode" path="strCostCenterCode"  ondblclick="funHelp('POSCostCenterMaster')" readonly="true"/>
				</div>
			 </div>
			 
			 <div class="row" style="background-color: #fff;display: -webkit-box;">
			 	<div class="element-input col-lg-6" style="width:30%;"> 
    				<label class="title">Cost Center Name</label>
    			</div>
    			<div class="element-input col-lg-6" style="margin-bottom:  10px;width:30%;">
					<s:input class="large" colspan="3" type="text" id="txtCostCenterName" path="strCostCenterName"  />
				</div>
			 </div>
			 
			 <div class="row" style="background-color: #fff; display: -webkit-box;margin-bottom:  10px">
			 	<div class="element-input col-lg-6" style="width: 30%;"> 
    				<label class="title">Primary Printer</label>
    			</div>
    			<div class="element-input col-lg-6" style="width: 30%;" > 
    				<s:select id="cmbPrinterPort" path="strPrinterPort" items="${printerList}" style="height: 10%; width: 100%;"/>
    			</div>
    			<div class="submit col-lg-12">
    				<input id="primaryPrinter" type="button" value="TEST"  onclick="funTestPrimaryPrinterStatus();"/>
				</div>
			 </div>
			 
			<!--  Pratiksha 04-03-2019 -->
			
			  <div class="row" style="background-color: #fff;display: -webkit-box;">
			 	<div class="element-input col-lg-6" style="width:30%;"> 
    				<label class="title">Primary Printer Copies</label>
    			</div>
    			<div class="element-input col-lg-6" style="margin-bottom:  10px;width:30%;">
					<s:input class="large" colspan="3" type="number" id="txtPrimaryPrinterNoOfCopies" path="intPrimaryPrinterNoOfCopies"  />
				</div>
			 </div>
			 
			 <div class="row" style="background-color: #fff; display: -webkit-box;margin-bottom:  10px">
			 	<div class="element-input col-lg-6" style="width: 30%;"> 
    				<label class="title">Secondary Printer</label>
    			</div>
    			<div class="element-input col-lg-6" style="width: 30%;"> 
    				<s:select id="cmbSecondaryPrinterPort" path="strSecondaryPrinterPort" items="${printerList}" style="height: 10%; width: 100%;"/>
    			</div>
    			<div class="element-input col-lg-6">
    				<input id="secondaryPrinter" type="button" value="TEST" onclick="funTestSecondaryPrinterStatus();"/>
			 	</div>
			 </div>
			 			<!--  Pratiksha 04-03-2019 -->
			 
			  <div class="row" style="background-color: #fff;display: -webkit-box;">
			 	<div class="element-input col-lg-6" style="width:30%;"> 
    				<label class="title">Secondary Printer Copies</label>
    			</div>
    			<div class="element-input col-lg-6" style="margin-bottom:  10px;width:30%;">
					<s:input class="large" colspan="3" type="number" id="txtSecondaryPrinterNoOfCopies" path="intSecondaryPrinterNoOfCopies"  />
				</div>
			 </div>
			 <div class="row" style="background-color: #fff; display: -webkit-box;margin-bottom:  10px">
			 	<div class="element-input col-lg-6" style="width: 30%;">
    				<label class="title">Print On Both Printers</label>
    			</div>
    			<div class="element-input col-lg-6" style="width: 20%;" >
					<s:input type="checkbox"  id="chkPrintOnBothPrinters"  path="strPrintOnBothPrinters"></s:input>
				</div>
			 </div>
			 
			 <div class="row" style="background-color: #fff; display: -webkit-box;margin-bottom:  10px">
			 	<div class="element-input col-lg-6" style="width: 30%" > 
    				<label class="title">Label On KOT</label>
    			</div>
    			<div class="element-input col-lg-6" style="width: 30%;" >
					<s:input class="large" colspan="3" type="text" id="txtLabelOnKOT" path="strLabelOnKOT" value="KOT" required="true" />
				</div>
			 </div>
			 
			 <br/>
			 
			 <div class="col-lg-10 col-sm-10 col-xs-10" style="width: 100%;margin-left: 15%;">
     			<p align="center">
            		<div class="submit col-lg-4 col-sm-4 col-xs-4"><input type="submit" value="SUBMIT" style="margin-left: -40%"/></div>
          
            		<div class="submit col-lg-4 col-sm-4 col-xs-4"><input type="reset" value="RESET" onclick="funResetFields()"style="margin-left: -75%"></div>
     			</p>
   			</div>

		</div>
		

<!-- 				<td><label>Print On Both Printers</label></td> -->

	</s:form>
</body>
</html>
