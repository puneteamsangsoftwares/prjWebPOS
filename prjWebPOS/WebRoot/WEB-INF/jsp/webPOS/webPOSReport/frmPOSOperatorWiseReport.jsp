<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>


<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>GROUP MASTER</title>
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
	 var gEnableShiftYN="${gEnableShiftYN}";
	 var POSDate="${POSDate}"
		    var startDate="${POSDate}";
		  	var Date = startDate.split(" ");
			var arr = Date[0].split("-");
			Dat=arr[2]+"-"+arr[1]+"-"+arr[0];	
    				$("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
    				$("#txtFromDate" ).datepicker('setDate', Dat);
    				$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
    				$("#txtToDate" ).datepicker('setDate', Dat);
    				if(gEnableShiftYN=='Y')
    				{
    					document.getElementById("lblShift").style.visibility = "visible"; 
    					document.getElementById("txtShiftCode").style.visibility = "visible"; 
    				}
    				else
    				{
    					document.getElementById("lblShift").style.visibility = "hidden";
    					document.getElementById("txtShiftCode").style.visibility = "hidden"; 
    					
    				}
    			}); 

 $("form").submit(function(event){
	 var fromDate = $("#txtFromDate").val();
		var toDate = $("#txtToDate").val();

	 var frmDate= fromDate.split('-');
	    var fDate = new Date(frmDate[2],frmDate[1],frmDate[0]);
	    
	    var tDate= toDate.split('-');
	    var t1Date = new Date(tDate[2],tDate[1],tDate[0]);

 	var dateDiff=t1Date-fDate;
		 if (dateDiff >= 0 ) 
		 {
      	return true;
      }else{
     	 alert("Please Check From Date And To Date");
     	 return false
      }
	});
	/**
	* Reset The Group Name TextField
	**/
	
	function funSetDate()
	{
		
		var searchurl=getContextPath()+"/getPOSDate.html";
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	/* var dateTime=response.POSDate;
			        	var date=dateTime.split(" ");
			        	$("#txtFromDate").val(date[0]);
			        	$("#txtToDate").val(date[0]); */
			        	
			        	var date = new Date(response.POSDate);
			        var	dateTime=date.getDate()  + '-' + (date.getMonth() + 1)+ '-' +  date.getFullYear();
			        var posDate=dateTime.split(" ");
			        $("#txtFromDate").val(posDate[0]);
		        	$("#txtToDate").val(posDate[0]);
		        	
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

<body>
	<div id="formHeading">
		<label>Operator Wise Report</label>
	</div>
	<s:form name="POSPOSOperatorWiseReport" method="POST" action="rptPOSOperatorWiseReport.html?saddr=${urlHits}" target="_blank" class="formoid-default-skyblue" style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:880px;min-width:150px;margin-top:2%;">

		<br />
		
		<div class="title" >
				
					<div class="row" style="background-color: #fff; display: block; margin-bottom: 10px; margin-left: 10%;">
							<div class="element-input col-lg-6" style="width: 20%;"> 
		    					<label class="title">POS Name</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="width: 20%;"> 
		    					<s:select id="cmbPOSName" name="cmbPOSName" path="strPOSName" items="${posList}" />
		    				</div>
		    		</div>
		    		
		    		<div class="row" style="background-color: #fff; display: block; margin-bottom: 10px; margin-left: 10%;">
							<div class="element-input col-lg-6" style="width: 20%;"> 
		    					<label class="title">From Date</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="width: 20%;"> 
								<s:input  id="txtFromDate" required="required" path="fromDate" pattern="\d{1,2}-\d{1,2}-\d{4}" style="width: 100%;"/>
							</div>
							<div class="element-input col-lg-6" style="width: 20%;"> 
		    					<label class="title">To Date</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="width: 20%;"> 
								<s:input id="txtToDate" required="required" path="toDate" pattern="\d{1,2}-\d{1,2}-\d{4}"  style="width: 100%;"/>	
							</div>
					 </div>
					 
					 <div class="row" style="background-color: #fff; display: block; margin-bottom: 10px; margin-left: 10%;">
							<div class="element-input col-lg-6" style="width: 20%;"> 
		    					<label class="title">Report Type</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="width: 20%;"> 
		    					<s:select id="cmbDocType" path="strDocType" >
				    				<s:option value="PDF">PDF</s:option>
				    				<s:option value="XLS">EXCEL</s:option>
				    			</s:select>
		    				</div>
		    				<div class="element-input col-lg-6" style="width: 20%;"> 
		    					<label class="title">User Name</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="width: 20%;"> 
		    					<s:select id="cmbUserName" name="cmbUserName" path="strSGName" items="${userList}" />
		    				</div>
		    		</div>
		    		<div class="row" style="background-color: #fff; display: block; margin-bottom: 10px; margin-left: 10%;">
							<div class="element-input col-lg-6" style="width: 20%;"> 
		    					<label class="title">Settlement Type</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="width: 20%;"> 
		    					<s:select id="cmbSettlementType" name="cmbSettlementType" path="strReportType" items="${settlementList}" />
		    				</div>
		    		</div>
		    		 <div class="row" style="background-color: #fff;display:block;margin-left: 10%">			
			 		<div class="element-input col-lg-6" style="width: 17%;"> 
    					<label id="lblShift" style="display: inline-block; width: 100px">Shift 
						</label>
	    			</div>
	    			<div class="element-input col-lg-6" style="margin-bottom:  10px;width: 20%;margin-left: 3%"> 
						<s:select colspan="3" type="text" items="${shiftList}"
								id="txtShiftCode" path="strShiftCode"  />
					
					</div>
			 </div>  
		    		
		    		<br/>
		    		<br/>
		    		
		    		<div class="col-lg-10 col-sm-10 col-xs-10" style="width: 70%; margin-left: 25%;">
					  		<p align="center">
								<div class="submit col-lg-4 col-sm-4 col-xs-4"><input type="submit" value="SUBMIT"/></div>
								<div class="submit col-lg-4 col-sm-4 col-xs-4"><input type="reset" value="RESET" onclick="funResetFields()"/></div>
							</p>
			  		  </div>
		 </div>


	</s:form>

</body>
</html>