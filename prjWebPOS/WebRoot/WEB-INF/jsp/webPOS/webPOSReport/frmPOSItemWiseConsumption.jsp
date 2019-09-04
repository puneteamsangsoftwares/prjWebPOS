<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Bill Report</title>
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
 $(function() 
    			{		
	 var POSDate="${POSDate}"
		    var startDate="${POSDate}";
		  	var Date = startDate.split(" ");
			var arr = Date[0].split("-");
			Dat=arr[2]+"-"+arr[1]+"-"+arr[0];	
			$("#txtFromDate" ).datepicker({ dateFormat: 'dd-mm-yy' });		
			$("#txtFromDate" ).datepicker('setDate', Dat); 
			$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtToDate" ).datepicker('setDate', Dat); 
    				
    			}); 


	/**
	* Reset The Group Name TextField
	**/
	
	
</script>
</head>
<body >
	<div id="formHeading">
		<label> Item Wise Consumption</label>
	</div>
	<s:form name="VoidKOTReport" method="POST" action="rptItemWiseConsumptionReport.html?saddr=${urlHits}" target="_blank" class="formoid-default-skyblue" style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:880px;min-width:150px;margin-top:2%;">


		<br />
		<br />
		<div class="title" style="margin-left: 190px;">
		
			<div class="row" style="background-color: #fff;display: -webkit-box;">
				<div class="element-input col-lg-6" style="width: 17%;" > 
    				<label class="title">POS Name</label>
    			</div>
    			<div class="element-input col-lg-6" style="margin-bottom:  10px;width: 30%"> 
					<s:select id="cmbPOSName" path="strPOSName" items="${posList}" >
				 	</s:select>
				</div>
			</div>
			<div class="row" style="background-color: #fff;display: -webkit-box;">
			 		<div class="element-input col-lg-6" style="width: 17%;"> 
    					<label class="title">From Date</label>
	    			</div>
	    			<div class="element-input col-lg-6" style="margin-bottom:  10px;width: 30%"> 
						<s:input id="txtFromDate" required="required" path="fromDate" pattern="\d{1,2}-\d{1,2}-\d{4}" style="width: 100%;" />
					</div>
		     </div>
			 <div class="row" style="background-color: #fff;display: -webkit-box;">			
			 		<div class="element-input col-lg-6" style="width: 17%;"> 
    					<label class="title">To Date</label>
	    			</div>
	    			<div class="element-input col-lg-6" style="margin-bottom:  10px;width: 30%"> 
						<s:input id="txtToDate" required="required" path="toDate" pattern="\d{1,2}-\d{1,2}-\d{4}" style="width: 100%;"/>
					</div>
			 </div>
			 <div class="row" style="background-color: #fff;display: -webkit-box;">			
			 		<div class="element-input col-lg-6" style="width: 17%;"> 
    					<label class="title">Group Name</label>
	    			</div>
	    			<div class="element-input col-lg-6" style="margin-bottom:  10px;width: 30%"> 
						<s:select id="cmbGroupName" name="cmbGroupName" path="strGroupName" items="${groupList}"/>
					</div>
			 </div>
			 
			 <div class="row" style="background-color: #fff;display: -webkit-box;">
				<div class="element-input col-lg-6" style="width: 17%;" > 
    				<label class="title">Report Type</label>
    			</div>
    			<div class="element-input col-lg-6" style="margin-bottom:  10px;width: 30%"> 
					<s:select id="cmbDocType" path="strDocType">
				    		<s:option value="PDF">PDF</s:option>
				    		<s:option value="XLS">EXCEL</s:option>
				    		
				    </s:select>
				</div>
			</div>
			 
			 <div class="row" style="background-color: #fff;display: -webkit-box;">			
			 		<div class="element-input col-lg-6" style="width: 17%;"> 
    					<label class="title">Print Modifiers</label>
	    			</div>
	    			<div class="element-input col-lg-6" style="margin-bottom:  10px;width: 30%"> 
						<s:select id="cmbPrintModifiers" name="cmbPrintModifiers" path="strOperationType" items="${printModifiers}"/>
					</div>
			 </div>
			 <div class="row" style="background-color: #fff;display: -webkit-box;">			
			 		<div class="element-input col-lg-6" style="width: 17%;"> 
    					<label class="title">Cost Center Name</label>
	    			</div>
	    			<div class="element-input col-lg-6" style="margin-bottom:  10px;width: 30%"> 
						<s:select id="cmbCostCenterName" name="cmbCostCenterName" path="strSGName" items="${costCenterList}"/>
					</div>
			 </div>
			 
			  <div class="row" style="background-color: #fff;display: -webkit-box;">
				<div class="element-input col-lg-6" style="width: 17%;" > 
    				<label class="title">Report By</label>
    			</div>
    			<div class="element-input col-lg-6" style="margin-bottom:  10px;width: 30%"> 
					<s:select id="cmbReportBy" path="strViewBy">
				    		<s:option value="Menu Head">Menu Head</s:option>
				    		<s:option value="POS Wise Cost Center">POS Wise Cost Center</s:option>
				    		<s:option value="Cost Center">Cost Center</s:option>
				    		
				    </s:select>
				</div>
			</div>
			
			</div>
			
		<br />
		<br />
		<div class="col-lg-10 col-sm-10 col-xs-10" style="width: 70%;margin-left: 160px;"> 
			 <p align="center">
				<div class="submit col-lg-4 col-sm-4 col-xs-4"><input type="submit" value="SUBMIT" tabindex="3" /></div>
				<div class="submit col-lg-4 col-sm-4 col-xs-4"><input type="reset" value="CLOSE" onclick="funResetFields()"/></div>
			 </p>
		</div>
	</s:form>

</body>
</html>