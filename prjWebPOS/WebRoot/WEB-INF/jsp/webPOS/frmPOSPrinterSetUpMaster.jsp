<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>
<script type="text/javascript">
	var fieldName;
	var selectedRowIndex=0;
	
	function funSetData(code){

		switch(fieldName){

		}
	}
	var posCode,areaCode,costCenterCode,printerData;
	var count=1;
	var mapCheckedData = new Map();	
	var mapCheckedData1 = new Map();	

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
						%>alert("Data Saved \n\n"+message);<%
					}
				}%>
			});
	function funAddRow() 
	{
		posCode = document.getElementById("cmbPOSName").value; 
				
		areaCode = document.getElementById("cmbAreaName").value;
		costCenterCode =document.getElementById("cmbCostCenterName").value;
		/*  document.getElementById("cmbPrimaryPrinterName").value;
		document.getElementById("cmbSecondaryPrinterName").value;
		  */
		
		
		var posName = $('#cmbPOSName').find(":selected").text();
		var areaName = $('#cmbAreaName').find(":selected").text();
		var centerName = $('#cmbCostCenterName').find(":selected").text();
		var primaryPrinterName =$('#cmbPrimaryPrinterName').find(":selected").text();
		var secondaryPrinterName = $('#cmbSecondaryPrinterName').find(":selected").text();
		printerData=posName+","+areaName+","+centerName+","+primaryPrinterName+","+secondaryPrinterName;
		
		if(mapCheckedData1.has(printerData)){
			alert("Printer Allready Set");
			return;
		}
		else
	   {
			
			/* mapCheckedData.set(count,count); */
			mapCheckedData1.set(printerData,printerData);
			count++;
			funfillPrinterSetupTable(posName ,areaName ,centerName, primaryPrinterName, secondaryPrinterName);
			
		
	   }
		

	}
	
	
	function funfillPrinterSetupTable(posName ,areaName ,centerName, primaryPrinterName, secondaryPrinterName)
	{
		
		var flag=false;
		var table = document.getElementById("tblPrinterSetup");
		var rowCount = table.rows.length;
		var row = table.insertRow(rowCount);
		 

		row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  name=\"listObjPrinterDataBean["+(rowCount)+"].strPOSName\"  size=\"20%\" id=\"field1 \" style=\"text-align:left;font-size: 13px; \" value='"+posName+"' onclick=\"funGetSelectedRowIndex(this)\" />";  
	    row.insertCell(1).innerHTML= "<input readonly=\"readonly\"  class=\"Box \"  name=\"listObjPrinterDataBean["+(rowCount)+"].strAreaName\"  size=\"20%\" id=\"field2\" style=\"text-align:left;font-size: 13px; \" value='"+areaName+"' onclick=\"funGetSelectedRowIndex(this)\" />";  
	    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box \"   name=\"listObjPrinterDataBean["+(rowCount)+"].strCostCenterName\"  size=\"20%\" id=\"field3 \" style=\"text-align:left; font-size: 13px;\" value='"+centerName+"' onclick=\"funGetSelectedRowIndex(this)\"  />";  
	    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  name=\"listObjPrinterDataBean["+(rowCount)+"].strPrimaryPrinterPort\"  size=\"30%\" id=\"field4 \" style=\"text-align:left; font-size: 13px; \" value='"+primaryPrinterName+"' onclick=\"funGetSelectedRowIndex(this)\"  />";  
	    row.insertCell(4).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  name=\"listObjPrinterDataBean["+(rowCount)+"].strSecondaryPrinterPort\"  size=\"30%\" id=\"field5 \" style=\"text-align:left; font-size: 13px;\" value='"+secondaryPrinterName+"' onclick=\"funGetSelectedRowIndex(this)\" />";  
	    row.insertCell(5).innerHTML= "<input type=\"checkbox\"  name=\"listObjPrinterDataBean["+(rowCount)+"].strPrintOnBothPrintersYN\"  size=\"50%\" id=\"chkstrPrintOnBothPrintersYN\" value=\"Tick\" >";
	 
		  row.insertCell(6).innerHTML= "<input type=\"hidden\" name=\"listObjPrinterDataBean["+(rowCount)+"].strPOSCode\" readonly=\"readonly\" class=\"Box \" id=\"field7 \"  size=\"0%\" value='"+posCode+"'>";
		  row.insertCell(7).innerHTML= "<input type=\"hidden\" name=\"listObjPrinterDataBean["+(rowCount)+"].strAreaCode\" readonly=\"readonly\" class=\"Box \" id=\"field8 \"  size=\"0%\" value='"+areaCode+"'>";
		  row.insertCell(8).innerHTML= "<input type=\"hidden\" name=\"listObjPrinterDataBean["+(rowCount)+"].strCostCenterCode\" readonly=\"readonly\" class=\"Box \" id=\"field9 \"  size=\"0%\" value='"+costCenterCode+"'>";

		 /*  private String strPOSCode;

			private String strAreaCode;

			private String strCostCenterCode;
	    */
	    
	}
	var  index;
	var selectedRowList=new Array();
	var num=1;
	function funGetSelectedRowIndex(obj)
	{
		
	
		 var table = document.getElementById("tblPrinterSetup");
		 index = obj.parentNode.parentNode.rowIndex;
		 
		 if(selectedRowIndex==index)
		 {
			 if(selectedRowIndex!=index)
			 {
				 row = table.rows[index];
				 row.style.backgroundColor='#FFFFF';
				 row.hilite = true;
			 }
			 else
			 {
				 row = table.rows[index];
				 row.style.backgroundColor='#C0E4FF';
				 row.hilite = true;
			 }
		 }
		 else
		 {
			 selectedRowIndex=index;
			 row = table.rows[index];
			 row.style.backgroundColor='#C0E4FF';
			 row.hilite = true;
		 }
		 /* selectedRowList[num]=index+1 */
		 
		 /* num++; */ 
	}	 
	
	//Pratiksha
	
	function btnRemove_onclick() {

		var table = document.getElementById("tblPrinterSetup");
		table.deleteRow(selectedRowIndex);

	}
	

		 

    
     function funResetFields() {
    	 
    	 $("#cmbPOSName").val(" ");
    	 $("#cmbAreaName").val(" ");
    	 $("#cmbCostCenterName").val(" ");
    	 $("#cmbPrimaryPrinterName").val(" ");
    	 $("#cmbSecondaryPrinterName").val(" ");
    	 $("#tblPrinterSetup tbody").empty();
    	 
    }	


     function funTestPrinterStatus() {
 		if ($("#cmbPrimaryPrinterName").val() == '') {
 			alert("Please Select Printer Name.");
 			return;
 		}

 		var PrinterName = $("#cmbPrimaryPrinterName").val();
 		var searchurl = getContextPath()
 				+ "/testPriPrinterStatus.html?PrinterName=" + PrinterName;
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
 function funHelp(transactionName)
	{
		fieldName=transactionName;
		window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
 
 //Pratiksha
 function funTestPrinterClicked() {
		
	 var CostCenterName = $('#cmbCostCenterName').find(":selected").text();
		
		var PrinterName = $('#cmbConsolidatedKOTPrinter').find(":selected").text();
		funHelp1(PrinterName,CostCenterName);
		
		

	}

	function funHelp1(PrinterName, CostCenterName) {
window.open("frmTestPrinter.html?PrinterName="
	+ PrinterName+"&CostCenterName="+CostCenterName,"","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
} 

</script>

</head>
<body>



	<div id="formHeading">
		<label>Printer SetUp Master</label>
	</div>
	<br />
	<s:form name="POSPrinterSetUpMaster" method="POST"
		action="savePOSPrinterSetUpMaster.html?saddr=${urlHits}"
		target="_blank" class="formoid-default-skyblue"
		style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:90%;min-width:25%;">
		<div class="title">

			<div class="row"
				style="background-color: #fff; display: block; margin-bottom: 2%;">
				<div class="element-input col-lg-3 col-sm-3 col-xs-3"
					style="width: 13%; margin-top: 7px">
					<label class="title">POS Name</label>
				</div>
				<div class="element-input  col-lg-3 col-sm-3 col-xs-3"
					style="width: 15%;">
					<s:select id="cmbPOSName" name="cmbPOSName" path="strPOSName"
						items="${posList}">
					</s:select>
				</div>
				<div class="element-input col-lg-3 col-sm-3 col-xs-3"
					style="width: 9%; margin-left: 3%; margin-top: 7px">
					<label class="title">Area</label>
				</div>
				<div class="element-input  col-lg-3 col-sm-3 col-xs-3"
					style="width: 15%;">
					<s:select id="cmbAreaName" name="cmbAreaName" path="strAreaName"
						items="${areaList}">
					</s:select>
				</div>
				<div class="element-input col-lg-3 col-sm-3 col-xs-3"
					style="width: 10%; margin-left: 3%; margin-top: 7px">
					<label class="title">Cost Center</label>
				</div>
				<div class="element-input  col-lg-3 col-sm-3 col-xs-3"
					style="width: 15%;">
					<s:select id="cmbCostCenterName" name="cmbCostCenterName"
						path="strCostCenterName" items="${costCenterList}">
					</s:select>
				</div>

			</div>

			<div class="row"
				style="background-color: #fff; display: block; margin-bottom: 2%;">
				<div class="element-input col-lg-3 col-sm-3 col-xs-3"
					style="width: 13%; margin-top: 7px">
					<label class="title">Primary Printer</label>
				</div>
				<div class="element-input  col-lg-3 col-sm-3 col-xs-3"
					style="width: 15%;">
					<s:select id="cmbPrimaryPrinterName" name="cmbPrimaryPrinterName"
						path="strPrimaryPrinterPort" items="${printerList}">
					</s:select>
				</div>
				<div class="element-input col-lg-6" style="width: 30%;">
					<%-- <s:input class="large" type="text" id="txtAreaCode"
						
						readonly="true" style="width: 100%;" /> --%>
				</div>
				<div class="submit col-lg-4 col-sm-4 col-xs-4"
					style="width: 10%; margin-left: -27%;">
					<input type="button" value="Test" id="Test"
						onclick="funTestPrinterClicked();" />
				</div>
			</div>

			<div class="row"
				style="background-color: #fff; display: block; margin-bottom: 0%; margin-top: 7px">
				<div class="element-input col-lg-3 col-sm-3 col-xs-3"
					style="width: 13%;">
					<label class="title">Secondary Printer</label>
				</div>
				<div class="element-input  col-lg-3 col-sm-3 col-xs-3"
					style="width: 15%;">
					<s:select id="cmbSecondaryPrinterName"
						name="cmbSecondaryPrinterName" path="strSecondaryPrinterPort"
						items="${printerList}">
					</s:select>
				</div>
				<div class="submit col-lg-4 col-sm-4 col-xs-4"
					style="width: 10%; margin-left: 3%;">
					<input type="button" value="Test" id="Test"  onclick="funTestPrinterClicked();"/>
				</div>
				<div class="submit col-lg-4 col-sm-4 col-xs-4"
					style="width: 10%; margin-left: 40%;">
					<input type="button" value="Add" id="Add" onclick="funAddRow()" />
				</div>
			</div>





			<!-- 		    		<div class="row" style="background-color: #fff; display: block; margin-bottom: 10px; margin-left: 0px;">
 -->
			<div
				style="border: 1px solid #ccc; display: block; height: 500px; margin: auto; margin-top: 2px; overflow-x: hidden; overflow-y: scroll; width: 100%;">

				<table class="scroll"
					style="height: 20px; border: #0F0; width: 100%; font-size: 15px; font-weight: bold;">
					<thead style="background: #2FABE9; color: white;">
						<tr>
							<td width="3%">POS</td>
							<td align="left" width="3%">Area</td>
							<td align="left" width="4%">Cost Center</td>
							<td align="left" width="5%">Primary Printer</td>
							<td align="left" width="4%">Secondary Printer</td>
							<td align="left" width="5%">Print On Both Printers</td>
						</tr>
					</thead>

				</table>
				<div class="row"
					style="display: block; height: 85%; margin: auto; width: 100%;">
					<table class="scroll" id="tblPrinterSetup"
						style="width: 100%; border: #0F0;">
						<tbody>
						<col style="width: 5%">
						<col style="width: 13.8%">
						<col style="width: 13%">
						<col style="width: 21.8%">
						<col style="width: 25%">
						<col style="width: 15%">


						</tbody>
					</table>
				</div>
			</div>




			<!-- </div> -->

			<br />

			<div class="row"
				style="background-color: #fff; display: block; margin: auto;">
				<div class="element-input col-lg-3 col-sm-3 col-xs-3"
					style="width: 18%; margin-top: 7px">
					<label class="title">Consolidated KOT Printer</label>
				</div>
				<div class="element-input  col-lg-3 col-sm-3 col-xs-3"
					style="width: 15%;">
					<s:select id="cmbConsolidatedKOTPrinter" name="cmbConsolidatedKOTPrinter"
						path="strConsolidatedKOTPrinterPort" items="${printerList}">
					</s:select>
				</div>
				<div class="submit col-lg-4 col-sm-4 col-xs-4" style="width: 10%;">
					<input type="button" value="Test" id="Test"  onclick="funTestPrinterClicked();" />
				</div>
				<div class="submit col-lg-4 col-sm-4 col-xs-4"
					style="width: 10%; margin-left: 25%;">
					<input type="submit" value="Save" id="Save" />
				</div>
				<div class="submit col-lg-4 col-sm-4 col-xs-4" style="width: 10%;">
					<input type="button" value="Remove" id="Remove"
					onclick="return btnRemove_onclick(); " />
				</div>
				<div class="submit col-lg-4 col-sm-4 col-xs-4" style="width: 10%;">
					<input type="button" value="Reset" id="reset"
						onclick="funResetFields()" />
				</div>
			</div>

			<s:input type="hidden" id="chkstrPrintOnBothPrintersYN"
				name="chkstrPrintOnBothPrintersYN" path="strPrintOnBothPrintersYN" />

		</div>


	</s:form>
</body>
</html>
