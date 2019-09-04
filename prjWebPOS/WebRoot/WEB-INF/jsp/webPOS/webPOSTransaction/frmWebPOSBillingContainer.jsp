
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%-- <script type="text/javascript" src="<spring:url value="/resources/js/Transaction/WebPOSBillSettlement.js "/>"></script> --%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

		<script type="text/javascript" src="<spring:url value="/resources/js/print.min.js"/>"></script>
		<link rel="stylesheet"  href="<spring:url value="/resources/css/print.css"/>" />
		
<title>
</title>

<script type="text/javascript">


var hmGroupMap=new Map();
var hmSubGroupMap=new Map();
var hmItempMap=new Map();
var listBillItem=[];
var finalNetTotal=0.0;
var finalGrandTotal=0.0;
var finalSubTotal=0,finalDiscountAmt=0;
var finalDelCharges=0.0;

var gPopUpToApplyPromotionsOnBill="${gPopUpToApplyPromotionsOnBill}";




/* This space is use to define only global variables 
 * coz form frmWebPOSBillingContainer is use in all billing related forms 
 */

 var gTableNo="";
 var gTableNo="";
 var gTableName="";
 var gWaiterName="";
 var gWaiterNo="";
 var gPAX=0;
 var gLastKOTNo="";
 var gAreaCode="";

var gMobileNo="";
var fieldName;
var selectedRowIndex=0;
var gDebitCardPayment="";
var tblMenuItemDtl_MAX_ROW_SIZE=100;
var tblMenuItemDtl_MAX_COL_SIZE=5;
var itemPriceDtlList=new Array();	
var hmHappyHourItems = new Map();
var gCustomerCode="",gCustomerName="";
var currentDate="";
var currentTime="";
var dayForPricing="",flagPopular="",menucode="",homeDeliveryForTax="N",gTakeAway="No",cmsMemCode="",cmsMemName="";
var arrListHomeDelDetails= new Array();
var arrKOTItemDtlList=new Array();
var arrDirectBilleritems=new Array();
var gCustAddressSelectionForBill="${gCustAddressSelectionForBill}";
var gCMSIntegrationYN="${gCMSIntegrationYN}";
var gCRMInterface="${gCRMInterface}";
var gDelBoyCompulsoryOnDirectBiller="${gDelBoyCompulsoryOnDirectBiller}";
var gRemarksOnTakeAway="${gRemarksOnTakeAway}";
var gNewCustomerForHomeDel=false;
var gTotalBillAmount,gNewCustomerMobileNo;
var gBuildingCodeForHD="",gDeliveryBoyCode="";
var isNCKOT=false;
var ncKot="N",reasonCode="",cmsMemCode="",cmsMemName="",globalTableNo="",globalDebitCardNo="",taxAmt=0,homeDeliveryForTax="N";
var operationType="DineIn",transactionType="Make KOT";
/* operationType must be DineIn,HomeDelivery and TakeAway */
/* transactionType would be Make KOT,Direct Biller,Modify Bill,Make Bill,UnSettle Bill,etc */
var gMenuItemSortingOn="${gMenuItemSortingOn}";
var gSkipPax="${gSkipPax}";
var gSkipWaiter="${gSkipWaiter}";
var gPrintType="${gPrintType}";
var gMultiWaiterSelOnMakeKOT="${gMultiWaiterSelOnMakeKOT}";
var gSelectWaiterFromCardSwipe="${gSelectWaiterFromCardSwipe}";

var gPOSCode="${gPOSCode}";
var gClientCode="${gClientCode}";
var gBillDate="${billDate}";
var fieldName="";


$(document).ready(function() 
{
	/*  var styles = document.styleSheets;
	var href = "";
    for (var i = 0; i < styles.length; i++) 
    {
    	href=styles[i].href;
    	if(href!=null)
    	{
    		href = styles[i].href.split("/");
	        href = href[href.length - 1];
	        
	        alert(href);
	        if(href==="formoid-default-skyblue.css")
	        {
	        	styles[i].disabled = disabled;
	            break;
	        }
    	}	        	 	       
    }
	 */
	
/* 	$('link[rel=stylesheet][href="/resources/newdesign/itemform_files/formoid1/formoid-default-skyblue.css"]').remove(); 

	$('link[href="/resources/newdesign/itemform_files/formoid1/formoid-default-skyblue.css"]').prop('disabled', true); 

	$('link[href="/resources/newdesign/itemform_files/formoid1/formoid-default-skyblue.css"]').remove();  */
	
	
	// $('link[href="/resources/newdesign/itemform_files/formoid1/formoid-default-skyblue.css"]').prop("disabled", true);
	
	/* $('link[href="/resources/newdesign/itemform_files/formoid1/formoid-default-skyblue.css"]').remove(); */
	
	
	$(".tab_content").hide();
	$(".tab_content:first").show();
	$("ul.tabs li").click(function() {
		$("ul.tabs li").removeClass("active");
		$(this).addClass("active");
		$(".tab_content").hide();
		var activeTab = $(this).attr("data-state");
		$("#" + activeTab).fadeIn();
		
	});

	gDayEnd = "${gDayEnd}";  
	gShiftEnd = "${gShiftEnd}";
	if(gShiftEnd=="" && gDayEnd=="N")
	{
		alert("Please Start Day");
		funPOSHome();
	}
	var voucherNo="${voucherNo}";
	if(voucherNo!=''){
		funOpenBillPrint(voucherNo);
	}
});

function funOpenBillPrint(voucherNo){
	//alert(voucherNo);
	var url=window.location.origin+getContextPath()+"/getBillPrint.html?voucherNo="+voucherNo+"#toolbar=1";
	//alert(url);
	 $("#plugin").attr("src", url);
	
	$("#dialog").dialog({
		 	autoOpen: true,
	        maxWidth:600,
	        maxHeight: 500,
	        width: 600,
	        height: 500,
	        modal: true,
	        buttons: {
	            /* "Print": function() {
	                //$(this).dialog("close");
	            	//window.print();  
 					//$("#plugin").print();
 					printJS('plugin', 'html');
	            }, */
	            Cancel: function() {
	                $(this).dialog("close");
	            }
	        },
	        close: function() {
	        }
	});
	
	
	

	//window.open(getContextPath()+"/getBillPrint.html?voucherNo="+voucherNo,"","dialogHeight:500px;dialogWidth:50px;dialogLeft:50px;")
	
	
	//<embed width="100%" height="100%" name="plugin" id="plugin" src="http://localhost:8080/prjWebPOS/getBillPrint.html?voucherNo=P0131947" type="application/pdf" internalinstanceid="62">
	
	//window.showModalDialog(getContextPath()+"/getBillPrint.html?voucherNo="+voucherNo); 
	
	/* var searchurl=getContextPath()+"/getBillPrint.html?voucherNo="+voucherNo;
	$.ajax({
		 type: "GET",
	        url: searchurl,
	        dataType: "json",
	        async: false,
       success: function (response)
       {
    	   var myResponse = eval(response);
    	   window.open('data:application/pdf;base64,' + myResponse.base64EncodedResponse);
    	   
           $("<iframe />") // create an iframe
             // add the source
             .attr('src', 'data:application/pdf;base64,' + myResponse.base64EncodedResponse)
             .appendTo('.modal-body');
           
           
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
	 */
}

function funDoneBtnDirectBiller()
{

	var $rows = $('#tblSettleItemTable').empty();
    document.getElementById("tab1").style.display='none';
	document.getElementById("tab2").style.display='block';
	
	$("#txtDeliveryCharge").val(finalDelCharges);
	
	finalSubTotal=0.00;
	finalDiscountAmt=0.00;
	finalNetTotal=0.00;
	taxTotal=0.00;
	taxAmt=0.00;
	finalGrandTotal=0.00;
	
	 
	 
	 var listItmeDtl=[];	   
	 var hmItempMap=new Map();
	

	var tblBillItemDtl=document.getElementById('tblBillItemDtl');
	var rowCount = tblBillItemDtl.rows.length;
	
	for(var i=0;i<rowCount;i++)
	{
		if(i!=0)
		{
			var itemDiscAmt=0;
			var isModifier=false;
			
			var itemName=tblBillItemDtl.rows[i].cells[0].children[0].value;
			if(itemName.startsWith("-->"))
			{
	    		isModifier=true;
			}
			
			
			var itemQty=tblBillItemDtl.rows[i].cells[1].children[0].value;
			var itemAmt=tblBillItemDtl.rows[i].cells[2].children[0].value;
			var itemCode=tblBillItemDtl.rows[i].cells[3].children[0].value;
			var itemDiscAmt=tblBillItemDtl.rows[i].cells[4].children[0].value;
	 		var groupcode=tblBillItemDtl.rows[i].cells[5].innerHTML;
	 		var subgroupcode=tblBillItemDtl.rows[i].cells[6].innerHTML;
	 		var subgroupName=tblBillItemDtl.rows[i].cells[7].innerHTML;
	 		var groupName=tblBillItemDtl.rows[i].cells[8].innerHTML;
			
	 		var gCode = groupcode.split('value=');
			var strGroupCode=gCode[1].substring(1, (gCode[1].length-2));
			
			var sgCode= subgroupcode.split('value=');
			var strSubGroupCode=sgCode[1].substring(1, (sgCode[1].length-2));
			
			var gName= groupName.split('value=');
			var strGroupName=gName[1].substring(1, (gName[1].length-2));
			
			var sgName= subgroupName.split('value=');
			var strSGName=sgName[1].substring(1, (sgName[1].length-2));
			hmGroupMap.set(strGroupCode, strGroupName); 
			hmSubGroupMap.set(strSubGroupCode, strSGName);
			hmItempMap.set(itemCode,itemName);
			
			
			var singleObj = {}
		    singleObj['itemName'] =itemName;
		    singleObj['quantity'] =itemQty;
		    singleObj['amount'] = itemAmt;
		    singleObj['discountPer'] = 0.0;
		    singleObj['discountAmt'] =0.0;
		    singleObj['strSubGroupCode'] =strSubGroupCode;
		    singleObj['strGroupcode'] =strGroupCode;
		    singleObj['itemCode'] =itemCode;
		    singleObj['rate'] =itemAmt/itemQty;
		    singleObj['isModifier'] =isModifier;
		    
		    listItmeDtl.push(singleObj); 
		    
		}
		
		
	}
	
	/**
	*calculating promotions and filling data to grid for bill print	
	*/
	funCalculatePromotion(listItmeDtl);

	    
	funRefreshSettlementItemGrid();
	
}

function funRefreshSettlementItemGrid()
{
	



    finalNetTotal=finalSubTotal-finalDiscountAmt;
    finalGrandTotal=finalNetTotal;
    funFillTableFooterDtl("","");
	   
    funFillTableFooterDtl(" SubTotal",finalSubTotal);
    funFillTableFooterDtl(" Discount",finalDiscountAmt);
    funFillTableFooterDtl(" NetTotal",finalNetTotal);
    
	var taxTotal= funCalculateTaxForItemTbl();

    finalGrandTotal=taxTotal+finalNetTotal;
    
    funFillTableFooterDtl(" GrandTotal",finalGrandTotal);
    funFillTableFooterDtl(" PaymentMode","");
    
    var discPer=(finalDiscountAmt/finalSubTotal)*100;
    $('#txtDiscountPer').val(discPer);	 
	$('#txtDiscountAmt').val(finalDiscountAmt);  
	    
    $('#txtAmount').val(finalGrandTotal);
 	$('#txtPaidAmount').val(finalGrandTotal);
 	$('#hidSubTotal').val(finalSubTotal);
 	$('#hidDiscountTotal').val(finalDiscountAmt);
 	$('#hidNetTotal').val(finalNetTotal);
 	$('#hidGrandTotal').val(finalGrandTotal);
 	
 	$("#hidTakeAway").val(gTakeAway);
	$("#hidCustomerCode").val(gCustomerCode);
	$("#hidCustomerName").val(gCustomerName);
	
	$("#hidOperationType").val(operationType);
	$("#hidTransactionType").val(transactionType);
	
	$("#hidAreaCode").val(gAreaCode);
	
	$("#hidTableNo").val(gTableNo);
	$("#hidWaiterNo").val(gWaiterNo);
	
}


function funNoPromtionCalculation(listItmeDtl)
{
	listBillItem=[];
	$('#tblmodalDataTable tbody').empty();
	$.each(listItmeDtl,function(i,item)
	{
		funFillSettleTable(item.itemName,item.quantity,item.amount,item.discountPer,item.discountAmt,item.strGroupcode,item.strSubGroupCode,item.itemCode,item.rate);
		funFillModalTable(item.itemName,item.quantity,item.amount);
	});

}

function funFillSettleTable(strItemName,dblQuantity,dblAmount,dblDiscountPer1,dblDiscountAmt1,strGroupCode,strSubGroupCode,strItemCode,dblRate)
{
	var tblSettleItemDtl=document.getElementById('tblSettleItemTable');
	var rowCount = tblSettleItemDtl.rows.length;
	var insertRow = tblSettleItemDtl.insertRow(rowCount);
			     	
    var col1=insertRow.insertCell(0);
    //col1.style.width ='10';
    var col2=insertRow.insertCell(1);
    var col3=insertRow.insertCell(2);
    var col4=insertRow.insertCell(3);
    var col5=insertRow.insertCell(4);
    var col6=insertRow.insertCell(5);
    var col7=insertRow.insertCell(6);
    var col8=insertRow.insertCell(7);
    var col9=insertRow.insertCell(8);
    
    /* col1.style.backgroundColor="lavenderblush";
    col2.style.backgroundColor="lavenderblush";
    col3.style.backgroundColor="lavenderblush"; */
    
    
    
    col1.innerHTML = "<input readonly=\"readonly\" size=\"33px\"  class=\"itemName\" style=\"text-align: left; color:black; height:30px;width:321px;border:none; padding-left:5px;\"   name=\"listOfBillItemDtl["+(rowCount)+"].itemName\" id=\"strItemName."+(rowCount)+"\" value='"+strItemName+"' />";
    col2.innerHTML = "<input readonly=\"readonly\" size=\"6px\"   class=\"itemQty\" style=\"text-align: right; color:black; height:30px;width:76px;border:none;\"  name=\"listOfBillItemDtl["+(rowCount)+"].quantity\" id=\"dblQuantity."+(rowCount)+"\" value='"+dblQuantity+"' />";
    col3.innerHTML = "<input readonly=\"readonly\" size=\"9.5px\"   class=\"itemAmt\" style=\"text-align: right; color:black; height:30px;width:97px;border:none;padding-right:5px;\"  name=\"listOfBillItemDtl["+(rowCount)+"].amount\" id=\"dblAmount."+(rowCount)+"\" value='"+dblAmount+"'/>";
    /* col4.innerHTML = "<input readonly=\"readonly\" size=\"1px\" class=\"discountPer\"     style=\"text-align: right; color:blue; height:20px;background-color:lavenderblush;\"   name=\"listOfBillItemDtl["+(rowCount)+"].discountPer\" id=\"tblDiscountPer."+(rowCount)+"\" value='"+dblDiscountPer1+"' />";
    col5.innerHTML = "<input readonly=\"readonly\" size=\"1px\"   class=\"discountAmt\"  style=\"text-align: right; color:blue; height:20px;background-color:lavenderblush;\"  name=\"listOfBillItemDtl["+(rowCount)+"].discountAmt\" id=\"tblDiscountAmt."+(rowCount-1)+"\" value='"+dblDiscountAmt1+"' />"; */
    col6.innerHTML = "<input type=\"hidden\"  size=\"0px\"   class=\"groupcode\"    name=\"listOfBillItemDtl["+(rowCount)+"].strGroupcode\" id=\"strGroupcode."+(rowCount)+"\" value='"+strGroupCode+"' />";	    
    col7.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"subGroupCode\"  name=\"listOfBillItemDtl["+(rowCount)+"].strSubGroupCode\" id=\"strSubGroupCode."+(rowCount)+"\" value='"+strSubGroupCode+"' />";
   	col8.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"itemCode\"  name=\"listOfBillItemDtl["+(rowCount)+"].itemCode\" id=\"itemCode."+(rowCount)+"\" value='"+strItemCode+"' />";
    col9innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"rate\"  name=\"listOfBillItemDtl["+(rowCount)+"].rate\" id=\"rate."+(rowCount)+"\" value='"+dblRate+"' />";

  //For Calculaing Discount Fill the list with item Dtl
    var singleObj = {}
    singleObj['itemName'] =strItemName;
    singleObj['quantity'] =dblQuantity;
    singleObj['amount'] = dblAmount;
    singleObj['discountPer'] = dblDiscountPer1;
    singleObj['discountAmt'] =dblDiscountAmt1;
    singleObj['strSubGroupCode'] =strSubGroupCode;
    singleObj['strGroupcode'] =strGroupCode;
    singleObj['itemCode'] =strItemCode;
    
    listBillItem.push(singleObj);
    
    finalSubTotal=finalSubTotal+parseFloat(dblAmount);
	finalDiscountAmt=finalDiscountAmt+parseFloat(dblDiscountAmt1);//(itemDiscAmt);
// 			  })	
}

function funCalculatePromotion(listItmeDtl)
{
	
	
	listBillItem=[];
	
	
	var searchurl=getContextPath()+"/promotionCalculate.html?";
	$.ajax({
		 type: "POST",
	        url: searchurl,
	        data : JSON.stringify(listItmeDtl),
	        contentType: 'application/json',
	        async: false,
        success: function (response)
        {
                   if(response.checkPromotion=="Y")
                	 {	
                	   if(gPopUpToApplyPromotionsOnBill=="Y")
                		{
                			var isOk=confirm("Do want to Calculate Promotions for this Bill?");
                			
                			if(isOk)
                			{
                				$.each(response.listOfPromotionItem,function(i,item)
                				{
                    	    		funFillSettleTable(item.strItemName,item.dblQuantity,item.dblAmount,item.dblDiscountPer,item.dblDiscountAmt,item.strGroupCode,item.strSubGroupCode,item.strItemCode,item.dblRate);
                    	    		funFillModalTable(item.itemName,item.quantity,item.amount);
                				});
                			}
                			else
                			{
                				funNoPromtionCalculation(listItmeDtl)                				 	
                			}
                		}
                	   else
                	   {
                			
                			$.each(response.listOfPromotionItem,function(i,item)
                			{
                	    		funFillSettleTable(item.strItemName,item.dblQuantity,item.dblAmount,item.dblDiscountPer,item.dblDiscountAmt,item.strGroupCode,item.strSubGroupCode,item.strItemCode,item.dblRate);
                	    		funFillModalTable(item.itemName,item.quantity,item.amount);
                			});
                			
                		}
        	    	
                	 }
                     else
                     {                	  
                	   funNoPromtionCalculation(listItmeDtl)
                     }
        
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

	function funCalculateTaxForItemTbl()
	{

		var taxTotal=0;
		 var rowCountTax=0;
		var searchurl=getContextPath()+"/funCalculateTaxInSettlement.html?";
		$.ajax({
			 type: "POST",
		        url: searchurl,
		        data : JSON.stringify(listBillItem),
		        contentType: 'application/json',
		        async: false,
	        success: function (response)
	        {
	        	    	$.each(response,function(i,item)
	        	    	{
			        		taxTotal=taxTotal+response[i].taxAmount;
			        		
			        		funFillTableTaxDetials(response[i].taxName,response[i].taxAmount,response[i].taxCode,response[i].taxCalculationType,response[i].taxableAmount ,rowCountTax);
			        		
			        		rowCountTax++;
			        	});
             
	        	    	finalGrandTotal=finalGrandTotal+taxTotal;
	        	    	 $('#hidTaxTotal').val(taxTotal);
	        },
	        error: function(jqXHR, exception)
	        {
	            if (jqXHR.status === 0) 
	            {
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
		return taxTotal;
	}

	
	
      function funFillTableTaxDetials(taxName,taxAmount,taxCode,taxCalculationType,taxableAmount,rowCountTax)
        {
		var tblSettleItemDtl=document.getElementById('tblSettleItemTable');
		var rowCount = tblSettleItemDtl.rows.length;
		var insertRow = tblSettleItemDtl.insertRow(rowCount);
		
	    var col1=insertRow.insertCell(0);
	    var col2=insertRow.insertCell(1);
	    var col3=insertRow.insertCell(2);
	   	var col4=insertRow.insertCell(3);
	    var col5=insertRow.insertCell(4);
	    var col6=insertRow.insertCell(5);
	    var col7=insertRow.insertCell(6);
	    var col8=insertRow.insertCell(7);
	    
	    /* col1.style.backgroundColor="white";
	    col2.style.backgroundColor="#F5F5F5";
	    col3.style.backgroundColor="#F5F5F5"; */
	    
	    col1.innerHTML = "<input readonly=\"readonly\" size=\"41px\"  name=\"  listTaxDtlOnBill["+(rowCountTax)+"].taxName\" id=\"taxName."+(rowCountTax)+"\" style=\"text-align: left; color:black; width:321px;height:30px;border:none; padding-left:5px;\"  value='"+taxName+"' />";
	    col2.innerHTML = "<input readonly=\"readonly\" size=\"6px\"  style=\"text-align: right; color:black; height:30px; border:none;\"   />";
	    col3.innerHTML = "<input readonly=\"readonly\" size=\"9.5px\"  name=\"  listTaxDtlOnBill["+(rowCountTax)+"].taxAmount\" id=\"taxAmount."+(rowCountTax)+"\"  style=\"text-align: right; color:black; width:97px; height:30px;border:none; padding-right:5px;\"  value='"+taxAmount+"'  />";
	    /* col4.innerHTML = "<input readonly=\"readonly\" size=\"1px\"   style=\"text-align: right; color:blue; height:20px;\"  />";
	    col5.innerHTML = "<input readonly=\"readonly\" size=\"1px\"   style=\"text-align: right; color:blue; height:20px;\"  />"; */
	    col6.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"taxCode\"  name=\"listTaxDtlOnBill["+(rowCountTax)+"].taxCode\" id=\"taxCode."+(rowCountTax)+"\" value='"+taxCode+"' />";
	    col7.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"taxCalculationType\"  name=\"listTaxDtlOnBill["+(rowCountTax)+"].taxCalculationType\" id=\"taxCalculationType."+(rowCountTax)+"\" value='"+taxCalculationType+"' />";
	    col8.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"taxableAmount\"  name=\"listTaxDtlOnBill["+(rowCountTax)+"].taxableAmount\" id=\"taxableAmount."+(rowCountTax)+"\" value='"+taxableAmount+"' />";
	   
   }


      
   function funFillTableFooterDtl(column1,column2){
	   

		var tblSettleItemDtl=document.getElementById('tblSettleItemTable');
		var rowCount = tblSettleItemDtl.rows.length;
		var insertRow = tblSettleItemDtl.insertRow(rowCount);
		
	    var col1=insertRow.insertCell(0);
	    var col2=insertRow.insertCell(1);
	    var col3=insertRow.insertCell(2);
	    var col4=insertRow.insertCell(3);
	    var col5=insertRow.insertCell(4);
	    
	    /* col1.style.backgroundColor="#F5F5F5";
	    col2.style.backgroundColor="#F5F5F5";
	    col3.style.backgroundColor="#F5F5F5"; */
	    
	   	var styleLeft="style=\"text-align: left; color:black; height:30px; border:none;\""; 
	    var styleRight="style=\"text-align: right; color:black; height:30px; padding-right:5px;border:none;\"";
	    if(column1=="" && column2=="")
	    {
	    	styleLeft="style=\"text-align: left; color:blue; height:30px; border:none; \" "; 
		    styleRight="style=\"text-align: right; color:blue; height:30px;border:none;\" ";
	    }
	    
	    
	    col1.innerHTML = "<input readonly=\"readonly\" size=\"41px\"  "+styleLeft+" id=\"column1."+(rowCount)+"\" value='"+column1+"'  />";
	    col2.innerHTML = "<input readonly=\"readonly\" size=\"6px\" "+styleLeft+"  />";
	    col3.innerHTML = "<input readonly=\"readonly\" size=\"9.5px\"   "+styleRight+" id=\"column2."+(rowCount)+"\" value='"+column2+"' />";
	   /*  col4.innerHTML = "<input readonly=\"readonly\" size=\"1px\" "+styleRight+"  />";
	    col5.innerHTML = "<input readonly=\"readonly\" size=\"1px\"   "+styleRight+" />"; */
	    
	    
   }

$(document).ready(function()
{
	
	var operationFrom="${operationFrom}";
	
    document.getElementById("tab2").style.display='none';	
    document.getElementById("Bill").style.display='none';	

});

function setTwoNumberDecimal(el) {
    el.value = parseFloat(el.value).toFixed(2);
};



function funFillModalTable(strItemName,dblQuantity,dblAmount)
{
	var tblmodalDataTable=document.getElementById('tblmodalDataTable');
	var rowCount = tblmodalDataTable.rows.length;
	var insertRow = tblmodalDataTable.insertRow(rowCount);
			     	
    var col1=insertRow.insertCell(0);
    var col2=insertRow.insertCell(1);
    var col3=insertRow.insertCell(2);
   	
    col1.innerHTML = "<input readonly=\"readonly\" size=\"33px\" style=\"text-align: left; color:black; height:30px;width:100%;border:none;\"   name=\"listOfBillItemDtl["+(rowCount)+"].itemName\" id=\"strItemName."+(rowCount)+"\" value='"+strItemName+"' />";
    col2.innerHTML = "<input readonly=\"readonly\" size=\"6px\"    style=\"text-align: right; color:black; height:30px;width:100%;border:none;\"  name=\"listOfBillItemDtl["+(rowCount)+"].quantity\" id=\"dblQuantity."+(rowCount)+"\" value='"+dblQuantity+"' />";
    col3.innerHTML = "<input readonly=\"readonly\" size=\"9.5px\"    style=\"text-align: right; color:black; height:30px;width:100%;border:none;padding-right:5px;\"  name=\"listOfBillItemDtl["+(rowCount)+"].amount\" id=\"dblAmount."+(rowCount)+"\" value='"+dblAmount+"'/>";
}


</script>





</head>
<body>

	<s:form name="Billing" method="GET" action=""  style="width: 100%; height: 100%;">	
	
	<br>
	<div id="myModal" class="modal">
		<div class="modal-content" >
			  <div class="modal-header">
			    <span class="close">&times;</span>
			    <h4>Make Items Complimentary</h4>
			  </div>
			  <div class="modal-body" >
			    <table id="modalTable" class=" table" style="border:1px border #ccc; width:100%; height:100px;;">
			    	<thead>
			    	<tr style="border:1px border #ccc;">
			    		<th style="width:65%;">Item Name</th>
			    		<th style="width:17.5%;">Qty</th>
			    		<th style="width:17.5%;">Amount</th>
			    	</tr>
					</thead>    
			    </table>
			    
			    <table id="tblmodalDataTable" class=" table" style="border:0px border #ccc; width:100%; height:100px; margin-top:0px;">
			    	
			    </table>
			  </div>
		</div>
	</div>
		<table>
			<tr>
				<td>
				
				
				
				
				<div id="tab_container" style="width: 100%; height: 100%; overflow:hidden ">
						<ul class="tabs">
							<li id ="DirectBiller" class="active" data-state="tab1" style="display:  none;" ></li>
							<li id ="Bill" data-state="tab2" style="width: 6%; padding-left: 2%">Bill Settlement</li>
						</ul>
						
						<!--This is tab1 which is use to show the main form which we want to show -->
						<!--This depends on the form name which is passed from controller  -->
						<div id="tab1" class="tab_content" style="width: 100%;height: 700px;">
							
							<!-- Include the jsp form in first tab based on the form name which is passed from contoller -->	
													
							<c:choose>
							
						      <c:when test="${formToBeOpen == 'Billing'}">
						     	<jsp:include page="frmBilling.jsp" />
						      </c:when>
						      
						      <c:when test="${formToBeOpen == 'Settle Bill'}">
						     	<jsp:include page="frmSettleBillFrontPage.jsp" />
						      </c:when>
						
						  	  <c:when test="${formToBeOpen == 'Modify Bill'}">
						     	<jsp:include page="frmPOSModifyBill.jsp" />
						      </c:when>
						      
						       <c:when test="${formToBeOpen == 'Bill For Items'}">
						     	<jsp:include page="frmBillForItems.jsp" />
						      </c:when>
						      
						       <c:when test="${formToBeOpen == 'Make Bill'}">
						     	<jsp:include page="frmPOSMakeBill.jsp" />
						      </c:when>
													
						      <c:otherwise>
						      	<jsp:include page="frmBilling.jsp" />
						      </c:otherwise>
						      
						    </c:choose>
																			
			   	 		</div>
			   	 
			   	 
			    <!-- This is a tab2  -->
			    <!-- This tab is use to show only bill settlement window on second tab which is invisible by default -->
			    <div id="tab2" class="tab_content" style="height: 700px; width:100%;">
					
			   			<jsp:include page="frmPOSBillSettlement.jsp" /> 
			   			<%-- <jsp:include page="frmPOSMakeBill.jsp" /> --%>
			    </div>
			    
			    <!-- Modal -->
			    
        <!-- <div id="myBillingModal" class="modal fade" role="dialog">
            <div class="modal-dialog modal-lg">

                Modal content
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Modal Header</h4>
                    </div>
                    <div class="modal-body">

                        <embed src="~/Content/Article List.pdf"
                               frameborder="0" width="100%" height="400px">

                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        </div>
                    </div>

                </div>
            </div>
        </div>
 -->
			    
	<!-- <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		  <div class="modal-dialog">
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">�</button>
		        <h4 class="modal-title" id="myModalLabel">Modal title</h4> 
		      </div>
		      <div class="modal-body">
		        <div style="text-align: center;">
		<iframe src="" 
		style="width:500px; height:500px;" id="ifBillPrint" frameborder="0"></iframe>
		</div>
		      </div>
		      <div class="modal-footer">
		        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
		        <button type="button" class="btn btn-primary">Save changes</button>
		      </div>
		    </div>
		  </div>
		</div> -->
			   
	  <div id="dialog" style="width: 315px; min-height: 100.25px; max-height: 100%; height: 509px;">
	    <!-- <div style="height:100%"> -->
	        <!-- <iframe id="plugin"></iframe> -->
	        <!-- <embed  id="frame" frameborder="0" width="100%" height="400px"> -->
	        <embed width="100%" height="100%" name="plugin" id="plugin"  type="application/pdf" internalinstanceid="100">
	    <!-- </div> -->
	</div>
			    </div>
			    </td>
			   </tr>
			    </table>
			   
			    </s:form>
</body>
</html>