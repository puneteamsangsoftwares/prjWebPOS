<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Customer History Flash</title>
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

.cell {
	background: inherit;
	border: 0 solid #060006;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	outline: 0 none;
	padding-left: 0;
	width: 115px
}

.header {
	background: inherit;
	border: 0 solid #060006;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	font-weight: bold;
	outline: 0 none;
	padding-left: 0;
	width: 60px
}
</style>
<script type="text/javascript">

	var activeTab="";
	var txtVal="";
	var reportType="";
	var foundChar="N";
	
	$(document).ready(function() {
		
		var POSDate="${gPOSDate}"
		var startDate="${gPOSDate}";
	  	var Date = startDate.split(" ");
		var arr = Date[0].split("-");
		Dat=arr[2]+"-"+arr[1]+"-"+arr[0];	
		$("#txtdteFromDate").datepicker({ dateFormat: 'dd-mm-yy'  });
		$("#txtdteFromDate" ).datepicker('setDate', Dat);
		$("#txtdteFromDate").datepicker();
		$("#txtdteToDate").datepicker({ dateFormat: 'dd-mm-yy'  });
		$("#txtdteToDate" ).datepicker('setDate', Dat);
		
		$(".tab_content").hide();
		$(".tab_content:first").show();
		
		
		

		$("ul.tabs li").click(function() {
			$("ul.tabs li").removeClass("active");
			$(this).addClass("active");
			$(".tab_content").hide();

			 activeTab = $(this).attr("data-state");
			
			$("#" + activeTab).fadeIn();
			
			var selectedTab;
		var reportType;
			var fromDate=$("#txtdteFromDate").val();
	    	var toDate=$("#txtdteToDate").val();
			
	    	
	    	//alert($("#txtTabName").val());
			
 	    	$("#txtTabName").val(activeTab);
 	    	
 	    	$("#txtTabName").val();
			
	    	

		});
		
		

	//Execute Button
		$("#execute").click(function(event){
			

			var fromDte=$("#txtdteFromDate").val();
			var Date = fromDte.split(" ");
			var arr = Date[0].split("-");
			Dat=arr[2]+"-"+arr[1]+"-"+arr[0];
			fromDate = Dat;
	    	var toDte=$("#txtdteToDate").val();
	    	var Date = toDte.split(" ");
			var arr = Date[0].split("-");
			Dat=arr[2]+"-"+arr[1]+"-"+arr[0];
			toDate = Dat;

	    	txtVal=activeTab;

				
				if(txtVal=="tab2")
				{

					selectedTab="Top Spenders";
					reportType=$('#cmbAmount :selected').text();
					
					funFillCustomerWiseTables(selectedTab,reportType,fromDate,toDate);

				}
				else if(txtVal=="tab3")
				{
					selectedTab="Non Spenders";
					reportType="Non Spenders";

					funFillCustomerWiseTables(selectedTab,reportType,fromDate,toDate);
				}
				else
					{
					selectedTab="Customer Wise";
					reportType=$('#cmbReportType :selected').text();
					if ($("#txtCustCode").val().length == 0) 
					{
	                    funFillCustomerWiseTables(selectedTab,reportType,fromDate,toDate);
	                }
					else
					{	
						selectedTab="Customer Wise";
						reportType=$('#cmbReportType :selected').text();
						
						funFillCustomerWiseTables(selectedTab,reportType,fromDate,toDate);
					}
				}
			 });
	});
	
	function funGetDate(type)
	{
		if(type=="fromDate")
		{
		
		$("#txtdteFromDate").datepicker({ dateFormat: 'yy-mm-dd' });
		$("#txtdteFromDate" ).datepicker('setDate', 'today');
		$("#txtdteFromDate").datepicker();
		
		}
		else
		{
			$("#txtdteToDate").datepicker({ dateFormat: 'yy-mm-dd' });
			$("#txtdteToDate" ).datepicker('setDate', 'today');
			$("#txtdteToDate").datepicker();
		}	
	}
	
	
/**
		* Open Help
		**/
		function funHelp(transactionName)
		{	       
	       window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	   		  selectedTab="Customer Wise";
				reportType=$('#cmbReportType :selected').text();
	       var fromDate=$("#txtdteFromDate").val();
	    	var toDate=$("#txtdteToDate").val();
	    	
	       if (reportType=="Item Wise") 
	       {
	    	  
				funFillCustomerWiseTables(selectedTab,reportType,fromDate,toDate);
	        } 
	        else 
	        {
	           
	            funFillCustomerWiseTables(selectedTab,reportType,fromDate,toDate);
	        }
	    }	
	
	
function funOnLoad()
{

	document.all[ 'divTopSpenders' ].style.display = 'block';
	document.all[ 'divNonSpenders' ].style.display = 'block';
}
function funFillCustomerWiseTables(selectedTab,reportType,fromDate,toDate)
{
	var custCode;
	var custName;
	var posName=$('#cmbPOSName').val();
	
	if(selectedTab=="Customer Wise")
	{
	 custCode=$("#txtCustCode").val();
	 custName=$("#txtCustName").val();
	}
	else if(selectedTab=="Top Spenders")
	{
		custCode=$("#cmbAmount").val();
		custName=$("#txtAmount").val();
	}	
	else if(selectedTab=="Non Spenders")
	{
		custCode="";
		custName="";
	}
	var searchurl=getContextPath()+"/loadFunFillAllTables.html";
	 $.ajax({
		        type: "POST",
		        data:{ reportType : reportType,
	 	        	fromDate:fromDate,
	 	 			toDate:toDate,
	 	 			selectedTab : selectedTab,
	 	 			custCode : custCode,
	 	 			custName : custName,
	 	 			posName : posName,
	 			},
		        url: searchurl,
		        dataType: "json",
		        async:false,
		        success: function(response)
		        {
		        	var cmbName=response.strCmbName;
		        	var strTabName=response.strTabName;
		        	if(strTabName=="Customer Wise")
		        	{	
		        	if(cmbName=="Item Wise")
	        		{
		        		document.all[ 'divBillWise' ].style.display = 'none';
 			    		document.all[ 'divItemWise' ].style.display = 'block';
 			    		funRemoveTableRows("tblItemWise");
 			    		funRemoveTableRows("tblTotalItem");
	 			    	$.each(response.ListOfHeader, function(i, item) 
	 					{
	 						funFillHeaderItemTable(item.BillNo,item.BillDate,item.ItemName,item.Quantity,item.Amount);
	 					});
			        	$.each(response.CustomerWiseTblData, function(i, item) 
			        	{
			        		funFillCustomerWiseItemTable(item.strBillNo,item.dteBillDate,item.strItemName,item.dblQuantity,item.dblAmount);
			        	});
			        	$.each(response.TotalTblData, function(i, item) 
					    {
					        funFillTotalItemTable(item.Total,item.totAmt);
					    });
		        	
		        	}
		        	else
		        	{
		        		document.all[ 'divBillWise' ].style.display = 'block';
 			    		document.all[ 'divItemWise' ].style.display = 'none';
 			    		funRemoveTableRows("tblBillWise");
 			    		funRemoveTableRows("tblTotalBillWise");
 			    		$.each(response.ListOfHeader, function(i, item) 
 						{
 			    			if(custCode == "")
 			    			{
 			    				funFillHeaderCustBillTable(item.BillNumber,item.BillDate,item.BillTime,item.BillAmount,item.ContactNo
 			        					,item.Name);
 			    			}
 			    			else
 			    			{
 			    				funFillHeaderBillTable(item.BillNo,item.BillDate,item.BillTime,item.POSName,item.PayMode,
 		 				        		item.SubTotal,item.DiscPer,item.DiscAmt,item.TaxAmt,item.SalesAmt
 		 				        		,item.Remark,item.Tip,item.DiscRemarks,item.Reason);  
 			    			}
 				        	  			
 						});
 			    		$.each(response.CustomerWiseTblData, function(i, item) 
		    		    {
 			    			if(custCode == "")
 			    			{
 			    				funFillCustWiseTable(item.strBillNo,item.dteBillDate,item.dteDateCreated,item.dblGrandTotal,item.longMobileNo,item.strCustomerName);
 			    			}
 			    			else
 			    			{
 			    				funFillCustomerWiseTable(item.billNo,item.dteBillDate,item.dteDateCreated,item.posName,item.settelmentDesc,
 						        		item.subTotal,item.discountPercentage,item.discountAmount,item.taxAmount,item.settlementAmt
 						        		,item.remark,item.tipAmount,item.discountRemark,item.reason);
 			    			}
 			    			
		    		    });
		        		$.each(response.TotalTblData, function(i, item) 
				    	{
				        	if(custCode == "")
				        	{
				        		funFillTotalBillCustWiseTable(item.Total,item.TotalGrandTotal);
				        	}
				        	else
				        	{
				        		funFillTotalBillWiseTable(item.Total,item.totalSubTotal,item.blank,item.totalDiscAmt,item.totalTaxAmt,item.totalSettleAmt,item.totalTipAmt);
				        	}
		        			
				    	});
		        	}
		        	}
		        	else if(strTabName=="Non Spenders")
		        	{
		        		funRemoveTableRows("tblNonSpenders");
		        		$.each(response.NonSpendersTblData, function(i, item) 
		    		    {		
		        		funFillNonSpendersTable(item.longMobileNo,item.strCustomerName,item.dteBillDate)	;
		    		    });
		        	}	
		        	else
		        	{
		        		funRemoveTableRows("tblTopSpenders");
		        		funRemoveTableRows("tblTotalTopSpenders");
		        		$.each(response.TopSpendersTblData, function(i, item) 
		    		    {   		
		        		funFillTopSpendersTable(item.LongMobileNo,item.StrCustomerName,item.strBillNo,item.dblGrandTotal);
		    		    });
		        		$.each(response.TotalTblData, function(i, item) 
					    {
					        funFillTotalTopSpendersTable(item.Total,item.totalSettleAmt);			
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
function funRemoveTableRows(tableId)
{
	var table = document.getElementById(tableId);
	var rowCount = table.rows.length;
	while(rowCount>0)
	{
		table.deleteRow(0);
		rowCount--;
	}
}
function funFillCustomerWiseTable(billNo,billDate,dblDateCreated,posName,settelmentDesc,dblSubTotal,dblDiscountPer,dblDiscountAmt,dblTaxAmt,dblSettlementAmt,
								strRemark,dblTipAmount,strDiscountRemark,strReasonName)
{
	var table = document.getElementById("tblBillWise");
	var rowCount = table.rows.length;
	var row = table.insertRow(rowCount);

	row.insertCell(0).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].billNo\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"12%\" id=\"txtKOTNo."+(rowCount)+"\" value='"+billNo+"'  >";
	row.insertCell(1).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].billDate\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"11%\" id=\"txtTime."+(rowCount)+"\" value='"+billDate+"' >";
	row.insertCell(2).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].dblDateCreated\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"11%\" id=\"txtWaiterName."+(rowCount)+"\" value='"+dblDateCreated+"' >";
	row.insertCell(3).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].posName\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"15%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+posName+"' >";
	row.insertCell(4).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].settelmentDesc\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"15%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+settelmentDesc+"' >";
	row.insertCell(5).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].dblSubTotal\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"28%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+dblSubTotal+"' >";
	row.insertCell(6).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].dblDiscountPer\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"28%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+dblDiscountPer+"' >";
	row.insertCell(7).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].dblDiscountAmt\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"28%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+dblDiscountAmt+"' >";
	row.insertCell(8).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].dblTaxAmt\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"28%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+dblTaxAmt+"' >";
	row.insertCell(9).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].dblSettlementAmt\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"28%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+dblSettlementAmt+"' >";
	row.insertCell(10).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].strRemark\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"28%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+strRemark+"' >";
	row.insertCell(11).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].dblTipAmount\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"28%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+dblTipAmount+"' >";
	row.insertCell(12).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].strDiscountRemark\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"28%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+strDiscountRemark+"' >";
	row.insertCell(13).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].strReasonName\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"28%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+strReasonName+"' >";
		
}

function funFillCustWiseTable(strBillNo,dteBillDate,dteDateCreated,dblGrandTotal,longMobileNo,strCustomerName)
{
	var table = document.getElementById("tblBillWise");
	var rowCount = table.rows.length;
	var row = table.insertRow(rowCount);
	
	row.insertCell(0).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].strBillNo\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"12%\" id=\"txtKOTNo."+(rowCount)+"\" value='"+strBillNo+"'  >";
	row.insertCell(1).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].dteBillDate\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"11%\" id=\"txtTime."+(rowCount)+"\" value='"+dteBillDate+"' >";
	row.insertCell(2).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].dteDateCreated\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"11%\" id=\"txtWaiterName."+(rowCount)+"\" value='"+dteDateCreated+"' >";
	row.insertCell(3).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].dblGrandTotal\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"15%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+dblGrandTotal+"' >";
	row.insertCell(4).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].longMobileNo\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"15%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+longMobileNo+"' >";
	row.insertCell(5).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].strCustomerName\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"15%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+strCustomerName+"' >";
	
}

function funFillCustomerWiseItemTable(billNo,billDate,itemName,dblQuantity,dblAmount)
{
	var table = document.getElementById("tblItemWise");
	var rowCount = table.rows.length;
	var row = table.insertRow(rowCount);
	
	row.insertCell(0).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].billNo\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"12%\" id=\"txtKOTNo."+(rowCount)+"\" value='"+billNo+"'  >";
	row.insertCell(1).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].billDate\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"11%\" id=\"txtTime."+(rowCount)+"\" value='"+billDate+"' >";
	row.insertCell(2).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].itemName\" readonly=\"readonly\" class=\"Box \" size=\"40%\" id=\"txtTime."+(rowCount)+"\" value='"+itemName+"' >";
	row.insertCell(3).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].dblQuantity\" readonly=\"readonly\" class=\"Box \" size=\"12%\" id=\"txtitemName."+(rowCount)+"\" value='"+dblQuantity+"' >";
	row.insertCell(4).innerHTML= "<input name=\"CustomerWiseTblData["+(rowCount)+"].dblAmount\" readonly=\"readonly\" class=\"Box \" size=\"12%\" id=\"txtdblQuantity."+(rowCount)+"\" value='"+dblAmount+"' >";
	
}

function funFillNonSpendersTable(longMobileNo,strCustomerName,dteBillDate)
{
	var table = document.getElementById("tblNonSpenders");
	var rowCount = table.rows.length;
	var row = table.insertRow(rowCount);

	row.insertCell(0).innerHTML= "<input name=\"NonSpendersTblData["+(rowCount)+"].longMobileNo\" readonly=\"readonly\" style=\"text-align: center\" class=\"Box \" size=\"30%\" id=\"txtlongMobileNo."+(rowCount)+"\" value='"+longMobileNo+"'  >";
	row.insertCell(1).innerHTML= "<input name=\"NonSpendersTblData["+(rowCount)+"].strCustomerName\" readonly=\"readonly\" class=\"Box \" size=\"40%\" id=\"txtstrCustomerName."+(rowCount)+"\" value='"+strCustomerName+"' >";
	row.insertCell(2).innerHTML= "<input name=\"NonSpendersTblData["+(rowCount)+"].dteBillDate\" style=\"text-align: center;\" readonly=\"readonly\" class=\"Box \" size=\"30%\" id=\"txtdteBillDate."+(rowCount)+"\" value='"+dteBillDate+"' >";

}

function funFillTopSpendersTable(LongMobileNo,StrCustomerName,strBillNo,dblGrandTotal)
{
	var table = document.getElementById("tblTopSpenders");
	var rowCount = table.rows.length;
	var row = table.insertRow(rowCount);

	row.insertCell(0).innerHTML= "<input name=\"TopSpendersTblData["+(rowCount)+"].LongMobileNo\" readonly=\"readonly\" style=\"text-align: center\" class=\"Box \" size=\"20%\" id=\"txtLongMobileNo."+(rowCount)+"\" value='"+LongMobileNo+"'  >";
	row.insertCell(1).innerHTML= "<input name=\"TopSpendersTblData["+(rowCount)+"].StrCustomerName\" readonly=\"readonly\" class=\"Box \" size=\"40%\" id=\"txtStrCustomerName."+(rowCount)+"\" value='"+StrCustomerName+"' >";
	row.insertCell(2).innerHTML= "<input name=\"TopSpendersTblData["+(rowCount)+"].strBillNo\" readonly=\"readonly\" style=\"text-align: right\" class=\"Box \" size=\"12%\" id=\"txtstrBillNo."+(rowCount)+"\" value='"+strBillNo+"' >";
	row.insertCell(3).innerHTML= "<input name=\"TopSpendersTblData["+(rowCount)+"].dblGrandTotal\" readonly=\"readonly\" style=\"text-align: right\" class=\"Box \" size=\"40%\" id=\"txtdblGrandTotal."+(rowCount)+"\" value='"+dblGrandTotal+"' >";	  
}

function funFillTotalItemTable(Total,totAmt)
{
	var table = document.getElementById("tblTotalItem");
	var rowCount = table.rows.length;
	var row = table.insertRow(rowCount);

	row.insertCell(0).innerHTML= "<input name=\"TotalTblData["+(rowCount)+"].Total\" readonly=\"readonly\" class=\"Box \" size=\"98%\" id=\"txtTotal."+(rowCount)+"\" value='"+Total+"'  >";
	row.insertCell(1).innerHTML= "<input name=\"TotalTblData["+(rowCount)+"].totAmt\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"10px \" id=\"txttotAmt."+(rowCount)+"\" value='"+totAmt+"' >";
	
}

function funFillTotalTopSpendersTable(Total,totalSettleAmt)
{
	var table = document.getElementById("tblTotalTopSpenders");
	var rowCount = table.rows.length;
	var row = table.insertRow(rowCount);

	row.insertCell(0).innerHTML= "<input name=\"TotalTblData["+(rowCount)+"].Total\" readonly=\"readonly\" class=\"Box \" size=\"12%\" id=\"txtTotal."+(rowCount)+"\" value='"+Total+"'  >";
	row.insertCell(1).innerHTML= "<input name=\"TotalTblData["+(rowCount)+"].totalSettleAmt\" readonly=\"readonly\" style=\"text-align: right\" class=\"Box \" size=\"12%\" id=\"txttotalSettleAmt."+(rowCount)+"\" value='"+totalSettleAmt+"' >";
	
}

function funFillTotalBillCustWiseTable(Total,TotalGrandTotal)
{
	var table = document.getElementById("tblTotalBillWise");
	var rowCount = table.rows.length;
	var row = table.insertRow(rowCount);

	row.insertCell(0).innerHTML= "<input name=\"TotalTblData["+(rowCount)+"].Total\" readonly=\"readonly\" class=\"Box \" size=\"12%\" id=\"Total."+(rowCount)+"\" value='"+Total+"'  >";
	row.insertCell(1).innerHTML= "<input name=\"TotalTblData["+(rowCount)+"].TotalGrandTotal\" readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\"TotalGrandTotal."+(rowCount)+"\" value='"+TotalGrandTotal+"' >";
} 

function funFillTotalBillWiseTable(Total,totalSubTotal,blank,totalDiscAmt,totalTaxAmt,totalSettleAmt,totalTipAmt)
{
	var table = document.getElementById("tblTotalBillWise");
	var rowCount = table.rows.length;
	var row = table.insertRow(rowCount);

	row.insertCell(0).innerHTML= "<input name=\"TotalTblData["+(rowCount)+"].Total\" readonly=\"readonly\" class=\"Box \" size=\"75%\" id=\"Total."+(rowCount)+"\" value='"+Total+"'  >";
	row.insertCell(1).innerHTML= "<input name=\"TotalTblData["+(rowCount)+"].totalSubTotal\" readonly=\"readonly\" class=\"Box \" size=\"11%\" id=\"TotalGrandTotal."+(rowCount)+"\" value='"+totalSubTotal+"' >";
	row.insertCell(2).innerHTML= "<input name=\"TotalTblData["+(rowCount)+"].blank\" readonly=\"readonly\" class=\"Box \" size=\"11%\" id=\"TotalGrandTotal."+(rowCount)+"\" value='"+blank+"' >";
	row.insertCell(3).innerHTML= "<input name=\"TotalTblData["+(rowCount)+"].totalDiscAmt\" readonly=\"readonly\" class=\"Box \" size=\"11%\" id=\"TotalGrandTotal."+(rowCount)+"\" value='"+totalDiscAmt+"' >";
	row.insertCell(4).innerHTML= "<input name=\"TotalTblData["+(rowCount)+"].totalTaxAmt\" readonly=\"readonly\" class=\"Box \" size=\"11%\" id=\"TotalGrandTotal."+(rowCount)+"\" value='"+totalTaxAmt+"' >";
	row.insertCell(5).innerHTML= "<input name=\"TotalTblData["+(rowCount)+"].totalSettleAmt\" readonly=\"readonly\" class=\"Box \" size=\"11%\" id=\"TotalGrandTotal."+(rowCount)+"\" value='"+totalSettleAmt+"' >";
	row.insertCell(6).innerHTML= "<input name=\"TotalTblData["+(rowCount)+"].totalTipAmt\" readonly=\"readonly\" class=\"Box \" size=\"11%\" id=\"TotalGrandTotal."+(rowCount)+"\" value='"+totalTipAmt+"' >";
	
} 

function funFillHeaderItemTable(BillNo,BillDate,ItemName,Quantity,Amount)
{
	var table = document.getElementById("tblItemWise");
	var rowCount = table.rows.length;
	var row = table.insertRow(rowCount);
	
	row.insertCell(0).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].BillNo\" readonly=\"readonly\" style=\"text-align: center\"class=\"Box \" size=\"12%\" id=\"txtKOTNo."+(rowCount)+"\" value='"+BillNo+"'  >";
	row.insertCell(1).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].BillDate\" readonly=\"readonly\" style=\"text-align: center\"class=\"Box \" size=\"12%\" id=\"txtKOTNo."+(rowCount)+"\" value='"+BillDate+"'  >";
	row.insertCell(2).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].ItemName\" readonly=\"readonly\" class=\"Box \" size=\"40%\" id=\"txtTime."+(rowCount)+"\" value='"+ItemName+"' >";
	row.insertCell(3).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].Quantity\" readonly=\"readonly\" class=\"Box \" size=\"12%\" id=\"txtitemName."+(rowCount)+"\" value='"+Quantity+"' >";
	row.insertCell(4).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].Amount\" readonly=\"readonly\" class=\"Box \" size=\"12%\" id=\"txtdblQuantity."+(rowCount)+"\" value='"+Amount+"' >";
		
}

function funFillHeaderBillTable(BillNo,BillDate,BillTime,POSName,PayMode,SubTotal,DiscPer,DiscAmt,TaxAmt,SalesAmt
		,Remark,Tip,DiscRemarks,Reason)
{
	var table = document.getElementById("tblBillWise");
	var rowCount = table.rows.length;
	var row = table.insertRow(rowCount);
	
	row.insertCell(0).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].BillNo\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"12%\" id=\"txtKOTNo."+(rowCount)+"\" value='"+BillNo+"'  >";
	row.insertCell(1).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].BillDate\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"11%\" id=\"txtTime."+(rowCount)+"\" value='"+BillDate+"' >";
	row.insertCell(2).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].BillTime\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"11%\" id=\"txtWaiterName."+(rowCount)+"\" value='"+BillTime+"' >";
	row.insertCell(3).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].POSName\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"15%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+POSName+"' >";
	row.insertCell(4).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].PayMode\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"15%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+PayMode+"' >";
	row.insertCell(5).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].SubTotal\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"28%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+SubTotal+"' >";
	row.insertCell(6).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].DiscPer\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"11%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+DiscPer+"' >";
	row.insertCell(7).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].DiscAmt\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"11%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+DiscAmt+"' >";
	row.insertCell(8).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].TaxAmt\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"11%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+TaxAmt+"' >";
	row.insertCell(9).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].SalesAmt\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"11%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+SalesAmt+"' >";
	row.insertCell(10).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].Remark\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"15%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+Remark+"' >";
	row.insertCell(11).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].Tip\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"11%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+Tip+"' >";
	row.insertCell(12).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].DiscRemarks\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"15%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+DiscRemarks+"' >";
	row.insertCell(13).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].Reason\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"11%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+Reason+"' >";
	 	
}

function funFillHeaderCustBillTable(BillNumber,BillDate,BillTime,BillAmount,ContactNo,Name)
{
	var table = document.getElementById("tblBillWise");
	var rowCount = table.rows.length;
	var row = table.insertRow(rowCount);
	
	row.insertCell(0).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].BillNumber\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"12%\" id=\"txtKOTNo."+(rowCount)+"\" value='"+BillNumber+"'  >";
	row.insertCell(1).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].BillDate\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"15%\" id=\"txtTime."+(rowCount)+"\" value='"+BillDate+"' >";
	row.insertCell(2).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].BillTime\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"15%\" id=\"txtWaiterName."+(rowCount)+"\" value='"+BillTime+"' >";
	row.insertCell(3).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].BillAmount\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"15%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+BillAmount+"' >";
	row.insertCell(4).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].ContactNo\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"15%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+ContactNo+"' >";
	row.insertCell(5).innerHTML= "<input name=\"ListOfHeader["+(rowCount)+"].Name\" readonly=\"readonly\" style=\"text-align: left\" class=\"Box \" size=\"35%\" id=\"txtdblSettlementAmt."+(rowCount)+"\" value='"+Name+"' >";
	 	
}


/**
* Get and Set data from help file and load data Based on Selection Passing Value(Customer Code)
**/
function funSetData(code,cusCode,cusName)
{
	$("#txtCustCode").val(cusCode);
	var searchurl=getContextPath()+"/loadPOSCustomerMasterDtl.html";
	 $.ajax({
		        type: "POST",
		        url: searchurl,
		        dataType: "json",
		        data : {
		        	code:code,
		        },
		        success: function(response)
		        {
		        	if(response.strCustomerTypeMasterCode=='Invalid Code')
		        	{
		        		alert("Invalid Customer  Code");
		        		$("#txtCustCode").val('');
		        	}
		        	else
		        	{
		        		$.each(response.CustomerData, function(i, item) 
				    	{		
		        			$("#txtCustCode").val(item.customerCode);//strCustomerCode
				        	$("#txtCustName").val(item.strCustomerName);//strCustomerName
				        	$("#txtCustName").focus(); 
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



function handle(e){
	
	
    if(e.keyCode === 13){
        e.preventDefault(); // Ensure it is only this code that rusn
         
    
        selectedTab="Top Spenders";
        var fromDate=$("#txtdteFromDate").val();
    	var toDate=$("#txtdteToDate").val();
		reportType=$('#cmbAmount :selected').text();
		
		funFillCustomerWiseTables(selectedTab,reportType,fromDate,toDate);
    }
    
}


function isNumber(evt) {
    evt = (evt) ? evt : window.event;
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
    	//alert("Pleasse Enter Number");
        return false;
    }
    else{
    	  if(evt.keyCode === 13){
    		  evt.preventDefault(); // Ensure it is only this code that rusn
    	         
    	     //   alert("Enter was pressed was presses");
    	        selectedTab="Top Spenders";
    	        var fromDate=$("#txtdteFromDate").val();
    	    	var toDate=$("#txtdteToDate").val();
    			reportType=$('#cmbAmount :selected').text();
    			
    			funFillCustomerWiseTables(selectedTab,reportType,fromDate,toDate);
    	    }
    	
    }
    return true;
}

function funResetFields()
{
	$('#tblNonSpenders tbody').empty();
	$('#tblTotalBillWise tbody').empty();
	$('#tblBillWise tbody').empty();
	$('#tblItemWise tbody').empty();
	$('#tblTotalItem tbody').empty();
	$('#tblTopSpenders tbody').empty();
	$('#tblTotalTopSpenders tbody').empty();
	document.getElementById("txtCustCode").value=""; 
	document.getElementById("txtCustName").value=""; 
}

function funClose()
{
	window.close();
	
}


</script>
<script type="text/javascript">
	 
</script>


</head>

<body onload="funOnLoad()">

	<div id="formHeading">
		<label>Customer History Flash</label>
	</div>
	<s:form name="POSCustomerWiseHistoryFlash" method="POST"
		action="rptPOSCustomerHistoryFlash.html?saddr=${urlHits}"
		class="formoid-default-skyblue"
		style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:880px;min-width:150px;margin-top:0%;"
		target="_blank">
		<br />
		<div class="title">
			<div class="row"
				style="background-color: #fff; display: -webkit-box; margin-bottom: 10px; margin-left: -20%">
				<div class="element-input col-lg-6" style="width: 15%;">
					<label class="title">POS Name</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:select id="cmbPOSName" name="cmbPOSName" path="strPOSName"
						items="${posList}">
					</s:select>
				</div>
				<div class="element-input col-lg-6" style="width: 15%;">
					<label class="title">From Date</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:input id="txtdteFromDate" name="txtdteFromDate"
						path="dteFromDate" />
				</div>
				<div class="element-input col-lg-6" style="width: 15%;">
					<label class="title">To Date</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:input id="txtdteToDate" name="txtdteToDate" path="dteToDate" />
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<input id="execute" type="button" value="Execute" />
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<input type="submit" onclick="onClickExport()" value="Export" />
				</div>
			</div>
			<div>
				<div id="tab_container" style="height: 80%; overflow: hidden;">
					<ul class="tabs">
						<li class="active" data-state="tab1"
							style="width: 20%; padding-left: 1%; height: 25px; border-radius: 4px;">Customer
							Wise</li>
						<li data-state="tab2"
							style="width: 20%; padding-left: 1%; height: 25px; border-radius: 4px;">Top
							Spenders</li>
						<li data-state="tab3"
							style="width: 20%; padding-left: 1%; height: 25px; border-radius: 4px;">Non
							Spenders</li>
					</ul>
					<br /> <br />
					<!--  Start of  Customer Wise-->
					<div id="tab1" class="tab_content">
						<div class="row"
							style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
							<div class="element-input col-lg-6" style="width: 18%;">
								<label class="title">Customer Code</label>
							</div>
							<div class="element-input col-lg-6" style="width: 0%;">
								<s:input type="text" id="txtCustCode" path="strCustCode"
									ondblclick="funHelp('POSCustomerMaster');" />
							</div>

							<div class="element-input col-lg-6" style="width: 1%;margin-left: 10%">
								<s:input colspan="3" type="text" id="txtCustName"
									path="strCustName" />
							</div>
							<div class="element-input col-lg-6" style="width: 15%;margin-left: 20%">
								<label class="title">Report Type</label>
							</div>
							<div class="element-input col-lg-6" style="width: 20%;">
								<s:select id="cmbReportType" name="cmbReportType"
									path="strReportType" items="${mapReportType}"
									 />
							</div>
						</div>
						<div id="divBillWise" class="col-sm-9"
							style="width: 100%; height: 580px; display: block; background-color: #fff;">
							<table class="scroll"
								style="height: 20px; border: #0F0; width: 100%; font-size: 14px; font-weight: bold;">
								<thead style="background-color: #85cdffe6;">
									<tr>
								<thead style="background-color: #85cdffe6;">
									<tr>
										<!-- <th style="width: 40%; background-color: #a4d7ff">Customer
											Name</th>
										<th style="width: 12%;">No. Of Bills</th>
										<th style="width: 40%">Sales Amount</th> -->
									</tr>

								</thead>
								</tr>
								</thead>
							</table>

							<div class="row"
								style="display: block; height: 85%; margin: auto; border: 1px solid #ccc; overflow-x: hidden; overflow-y: scroll; width: 100%;">
								<table id="tblBillWise"
										style="width: 100%;">
										<tbody>
										<col style="width: 14%;">
										<!--  COl1   -->
										<col style="width: 14%">
										<!--  COl2   -->
										<col style="width: 15%">
										<!--  COl3   -->
										<col style="width: 11%">
										<!--  COl4  -->
										<col style="width: 13%">
										<!--  COl5   -->
										<col style="width: 15%">
										<!--  COl6   -->
										<col style="width: 14%">
										<!--  COl7   -->
										<col style="width: 13%">
										<!--  COl8   -->
										<col style="width: 15%">
										<!--  COl9   -->
										<col style="width: 15%">
										<!--  COl10   -->
										</tbody>
									</table>
							</div>
							<div class=""
								style="width: 100%; height: 60px; overflow-x: hidden; overflow-y: hidden; display: block;">
								<table
									style="height: 20px; border: #0F0; width: 100%; font-size: 13px; font-weight: bold;">
									<tr bgcolor="a4d7ff">
										<td width="30%"></td>
										<th style="width: 12%"></th>
										<th style="width: 12%">Sub Total</th>
										<th style="width: 12%">Disc</th>
										<th style="width: 12%">Total Tax</th>
										<th style="width: 12%">Sales Amount</th>
										<th style="width: 12%">Tip Amount</th>


									</tr>
								</table>
								<div
									style="border: 1px solid #ccc; display: block; height: 20px; margin: auto; width: 99.80%;">
									<table class="scroll" id="tblTotalTopSpenders"
										style="width: 100%; height: 50%; border: #0F0; table-layout: fixed;"
										class="transTablex col11-center">
										<tbody>
										<col style="width: 12%;">
										<!--  COl1   -->
										<col style="width: 12%">
										<!--  COl2   -->
										<col style="width: 12%;">
										<!--  COl1   -->
										<col style="width: 12%">
										<!--  COl2   -->
										<col style="width: 12%;">


										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
					<!--End of Customer Wise-->
					<div id="tab2" class="tab_content">
						<div class="row"
							style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
							<div class="element-input col-lg-6" style="width: 15%;">
								<label class="title">Amount</label>
							</div>
							<div class="element-input col-lg-6" style="width: 20%;">
								<s:select id="cmbAmount" name="cmbAmount" path="strAmount"
									items="${mapAmount}" />
							</div>
							<div class="element-input col-lg-6" style="width: 20%;">
								<s:input type="text" id="txtAmount" name="txtAmount"
									path="strAmt" onkeypress="return isNumber(event)" />
							</div>

						</div>
						<div id="divTopSpenders" class="col-sm-9"
							style="width: 100%; height: 580px; display: block; background-color: #fff;">
							<table class="scroll"
								style="height: 20px; border: #0F0; width: 100%; font-size: 14px; font-weight: bold;">
								<thead style="background-color: #85cdffe6;">
									<tr>
								<thead style="background-color: #85cdffe6;">
									<tr>
										<th style="width: 20%">Mobile Number</th>
										<th style="width: 40%">Customer Name</th>
										<th style="width: 12%">No. Of Bills</th>
										<th style="width: 40%">Sales Amount</th>
									</tr>

								</thead>
								</tr>
								</thead>
							</table>

							<div class="row"
								style="display: block; height: 85%; margin: auto; border: 1px solid #ccc; overflow-x: hidden; overflow-y: scroll; width: 100%;">
								<table class="scroll" id="tblTopSpenders"
									style="width: 100%; border: #0F0;">
									<tbody>
									<tbody>
									<col style="width: 20%;">
									<!--  COl1   -->
									<col style="width: 41%">
									<!--  COl2   -->
									<col style="width: 12%">
									<!--  COl3   -->
									<col style="width: 40%">
									<!--  COl3   -->
									</tbody>
									</tbody>
								</table>
							</div>
							<div class=""
								style="width: 100%; height: 60px; overflow-x: hidden; overflow-y: hidden; display: block;">
								<table
									style="height: 20px; border: #0F0; width: 100%; font-size: 13px; font-weight: bold;">
									<tr bgcolor="a4d7ff">
										<td width="30%"></td>
										<th style="width: 12%"></th>
										<th style="width: 12%">Sales Amount</th>

									</tr>
								</table>
								<div
									style="border: 1px solid #ccc; display: block; height: 20px; margin: auto; width: 99.80%;">
									<table class="scroll" id="tblTotalTopSpenders"
										style="width: 100%; height: 50%; border: #0F0; table-layout: fixed;"
										class="transTablex col11-center">
										<tbody>
										<col style="width: 12%;">
										<!--  COl1   -->
										<col style="width: 12%">
										<!--  COl2   -->

										</tbody>
									</table>
								</div>
							</div>
						</div>

						<br />

					</div>
					<div id="tab3" class="tab_content">

						<div id="divNonSpenders" class="col-sm-9"
							style="width: 100%; height: 580px; display: block; background-color: #fff;">
							<table class="scroll"
								style="height: 20px; border: #0F0; width: 100%; font-size: 14px; font-weight: bold;">
								<thead style="background-color: #85cdffe6;">
									<tr>
								<thead style="background-color: #85cdffe6;">
									<tr>

										<th style="width: 30%">Mobile Number</th>
										<th style="width: 40%">Customer Name</th>
										<th style="width: 30%">Last Transaction Date</th>
									</tr>

								</thead>
								</tr>
								</thead>
							</table>

							<div class="row"
								style="display: block; height: 85%; margin: auto; border: 1px solid #ccc; overflow-x: hidden; overflow-y: scroll; width: 100%;">
								<table class="scroll" id="tblNonSpenders"
									style="width: 100%; border: #0F0;">
									<tbody>
									<tbody>
									<col style="width: 20%;">
									<!--  COl1   -->
									<col style="width: 41%">
									<!--  COl2   --dy>
										<col style="width: 30%;">
										<!--  COl1   -->
									<col style="width: 41%">
									<!--  COl2   -->
									<col style="width: 30%">
									<!--  COl3   -->
									</tbody>
								</table>
							</div>

						</div>

					</div>
					<!-- End Of TopSpenders-->



				</div>
			</div>
		</div>
	</s:form>

</body>
</html>