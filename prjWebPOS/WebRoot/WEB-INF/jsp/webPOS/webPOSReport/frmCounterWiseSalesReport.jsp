<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Counter Wise Sales Report</title>
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


 $(function() 
    			{	
					var POSDate="${gPOSDate}"
				    var startDate="${gPOSDate}";
				  	var Date = startDate.split(" ");
					var arr = Date[0].split("-");
					Dat=arr[2]+"-"+arr[1]+"-"+arr[0];	
					$("#txtFromDate" ).datepicker({ dateFormat: 'dd-mm-yy' });		
					$("#txtFromDate" ).datepicker('setDate', Dat); 
					$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
					$("#txtToDate" ).datepicker('setDate', Dat);  
			
    			}); 


	
</script>


</head>
<body >
	<div id="formHeading">
		<label>Counter Wise Sales Report</label>
	</div>
	<s:form name="frmPOSCounterWiseSalesReport" method="POST" 
			class="formoid-default-skyblue"
			style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:880px;min-width:100%;margin-top:0%;"
	
	action="rptCounterWiseSalesReportReport.html?saddr=${urlHits}" target="_blank">
		<br />
		<br />
		
				<div class="title" style="margin-left: 35%; width: 50%">
				<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: block; width: 50%">
				<div class="element-input col-lg-6">
					<label class="title">POS Name</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 50%; margin-left: -10%">
					<s:select id="cmbPOSName" name="cmbPOSName" path="strPOSName"
						items="${posList}"></s:select>
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: block; width: 50%">
				<div class="element-input col-lg-6">
					<label class="title">From Date</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 50%; margin-left: -10%">
					<s:input id="txtFromDate" required="required" path="fromDate"
						pattern="\d{1,2}-\d{1,2}-\d{4}" />
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: block; width: 50%">
				<div class="element-input col-lg-6">
					<label class="title">To Date</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 50%; margin-left: -10%">
					<s:input id="txtToDate" required="required" path="toDate"
						pattern="\d{1,2}-\d{1,2}-\d{4}" />
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: block; width: 50%">
				<div class="element-input col-lg-6">
					<label class="title">Report Type</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 50%; margin-left: -10%">
					<s:select id="cmbDocType" path="strDocType">
						<s:option value="PDF">PDF</s:option>
						<s:option value="XLS">EXCEL</s:option>
					</s:select>
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: block; width: 50%">
				<div class="element-input col-lg-6">
					<label class="title">Select Type</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 50%; margin-left: -10%">
					<s:select id="cmbSelectType" path="strType">
				    		<s:option value="Menu Wise">Menu Wise</s:option>
				    		<s:option value="Group Wise">Group Wise</s:option>
				    		<s:option value="SubGroup Wise">SubGroup Wise</s:option>
				    	</s:select>
				</div>
			</div>
			
		</div>
		<%-- <table class="masterTable">

			<tr>
				<td width="30%">&emsp;&ensp;&emsp;&ensp;
				<label>POS Name</label></td>
				<td><s:select id="cmbPOSName" name="cmbPOSName" path="strPOSName" cssClass="BoxW124px" items="${posList}" >
				</s:select></td>
				<td></td>
				<!-- <td></td> -->
			</tr>
			<tr>
				<td>&emsp;&ensp;&emsp;&ensp;
				<label>From Date</label></td>
				<td><s:input id="txtFromDate" required="required" path="fromDate" pattern="\d{1,2}-\d{1,2}-\d{4}" cssClass="calenderTextBox"/>
				</td><td><label>To Date</label>&emsp;&ensp;
				<s:input id="txtToDate" required="required" path="toDate" pattern="\d{1,2}-\d{1,2}-\d{4}" cssClass="calenderTextBox"/></td>
			
			</tr>
			<tr>
					<td>&emsp;&ensp;&emsp;&ensp;
					<label>Report Type</label></td>
					<td >
						<s:select id="cmbDocType" path="strDocType" cssClass="BoxW124px">
				    		<s:option value="PDF">PDF</s:option>
				    		<s:option value="XLS">EXCEL</s:option>
				    	</s:select>
					</td>
					<td></td>
					
				</tr>
			
			<tr>
					<td>&emsp;&ensp;&emsp;&ensp;
					<label>Select Type</label></td>
					<td >
						<s:select id="cmbSelectType" path="strType" cssClass="BoxW124px">
				    		<s:option value="Menu Wise">Menu Wise</s:option>
				    		<s:option value="Group Wise">Group Wise</s:option>
				    		<s:option value="SubGroup Wise">SubGroup Wise</s:option>
				    	</s:select>
					</td>
					<td></td>
				
				</tr>	
			<tr>
			</tr>
		</table> --%>
		<br />
		<br />
		<p align="center">
			<input type="submit" value="Submit" tabindex="3" /> 
			<input type="reset" value="Reset"  onclick="funResetFields()"/>
		</p>
	</s:form>

</body>

</html>