<%@ page import="java.util.LinkedList"%>
<%@ page import="java.util.List"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>  

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Material Dash</title>
  <!-- javascript code ends here -->
  
   <!-- plugins:css -->
  <link rel="stylesheet" href="../${pageContext.request.contextPath}/resources/newdesign/assets/vendors/mdi/css/materialdesignicons.min.css">
  <link rel="stylesheet" href="../${pageContext.request.contextPath}/resources/newdesign/assets/vendors/css/vendor.bundle.base.css">
  <!-- endinject -->
  <!-- Plugin css for this page -->
  <link rel="stylesheet" href="../${pageContext.request.contextPath}/resources/newdesign/assets/vendors/flag-icon-css/css/flag-icon.min.css">
  <link rel="stylesheet" href="../${pageContext.request.contextPath}/resources/newdesign/assets/vendors/jvectormap/jquery-jvectormap.css">
  <!-- End plugin css for this page -->
  <!-- Layout styles -->
  <link rel="stylesheet" href="../${pageContext.request.contextPath}/resources/newdesign/assets/css/demo/style.css">
  <!-- End layout styles -->
  <link rel="shortcut icon" href="../${pageContext.request.contextPath}/resources/newdesign/assets/images/favicon.png" /> 

<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>

  <style type="text/css">
    .body-wrapper .main-wrapper .page-wrapper .content-wrapper {  padding: 16px 10px;}
    span.price{font-size: 14px;text-align: right;display: block;color:#2180c3;}
    h5.tablehead2{ font-size: 12px !important;font-weight: 500;line-height: 1.5;width: 90%;}
    .mdc-card .info-card4{width: 110px;}
    .mdc-card.info-card {padding: 2px 10px;}
    .mdc-card .info-card4:hover{background: #40a6ee;} 
    .mdc-card.info-card3 {margin-bottom: 0px;}
    .mdc-text-field--outlined .mdc-text-field__input{padding: 7px !important;}
    .mdc-text-field--with-leading-icon.mdc-text-field--outlined .mdc-floating-label{left: 12px;top: 10px;font-size: 13px;}
    .mdc-card.info-card{padding: 0px 9px;}
    .body-wrapper .main-wrapper .page-wrapper .content-wrapper{padding: 1px 10px;}
    .mdc-top-app-bar .mdc-top-app-bar__section-right .menu-profile button .user-name{color: #399be2;}
    .mdc-top-app-bar .mdc-top-app-bar__section-right .menu-profile button .date{color: #399be2;font-weight: normal;}
    .img:hover{background: #e4e1e161;}
  </style>
  
  
<script type="text/javascript">


var objMenuItemButton;
var objIndex;
var NumPadDialogFor,itemCode;	
var itemChangeQtySelected, itemPrice;

//start PLU Search funactionality
$(document).ready(function()
{
	funloadClientPhoto();
	var posDate="${gPOSDate}";
		$("#lblPOSDate").text(posDate);
	 // Get the input field
/* 	var input = document.getElementById("Customer");

	// Execute a function when the user releases a key on the keyboard
	input.addEventListener("keyup", function(event)
	{
	  // Cancel the default action, if needed
	  event.preventDefault();
	  // Number 13 is the "Enter" key on the keyboard
	  if (event.keyCode === 35) 
	  {
		  funCustomerBtnClicked();
	  }
	}); 
	
 */	
	if(gMultiWaiterSelOnMakeKOT=="")
	{
		gMultiWaiterSelOnMakeKOT="N";
	}
	 
	$("#txtItemSearch").keyup(function()
			{
				if(operationType=="DineIn"){
					if($("#txtTableNo").text()!='' && $("#txtWaiterName").text()!='' && $("#txtPaxNo").text()!='')
					{
						funFillGridData1($(this).val());
					}else{
						funFillGridData1($(this).val());
						//searchTable($(this).val(),$('#tblMenuHeadDtl'));
					}
				}else{
					funFillGridData1($(this).val());
				}
				
			});
	
	//for category search
	$("#txtCategorySearch").keyup(function()
			{
				if(operationType=="DineIn"){
					if($("#txtTableNo").text()!='' && $("#txtWaiterName").text()!='' && $("#txtPaxNo").text()!='')
					{
						funFillGridData2($(this).val());
					}else{
						funFillGridData2($(this).val());
						//searchTable($(this).val(),$('#tblMenuHeadDtl'));
					}
				}else{
					funFillGridData2($(this).val());
				}
				
			});
	
	//for category search
	$("#txtCategorySearch").keyup(function()
			{
				if(operationType=="DineIn"){
					if($("#txtTableNo").text()!='' && $("#txtWaiterName").text()!='' && $("#txtPaxNo").text()!='')
					{
						funFillGridData2($(this).val());
					}else{
						funFillGridData2($(this).val());
						//searchTable($(this).val(),$('#tblMenuHeadDtl'));
					}
				}else{
					funFillGridData2($(this).val());
				}
				
			});
	
			// document.getElementById("divItemDtl").style.display='block';
			// document.getElementById("divPLU").style.display='none';
			 
			/*  document.getElementById("divBillItemDtl").style.display='block';
			 document.getElementById("divTotalDtl").style.display='block';
			 
			 document.getElementById("divTopButtonDtl").style.display='block';
			 document.getElementById("divMenuHeadDtl").style.display='block';
		 */
			if(operationType=="DineIn")
			{
				funDineInButtonClicked();
			}
			
			
			
		});
		
		/* function searchTable(inputVal)
		{
			
			var table = $('#tblMenuItemDtl');
			table.find('tr').each(function(index, row)
					{
						var allCells = $(row).find('td');
						if(allCells.length > 0)
						{
							var found = false;
							allCells.each(function(index, td)
							{
								var regExp = new RegExp(inputVal, 'i');
								if(regExp.test($(td).find('input').val()))
								{
									found = true;
									return false;
								}
							});
							if(found == true)$(row).show();else $(row).hide();
						}
					});;
		}
		 *///end PLU Search funactionality		
		
		
		
		
		/*
		*make bill button clicked
		*///tblsetup
		function funMakeBillClicked()
		{
			var $rows = $('#tblSettleItemTable').empty();
			var tblBillItemDtl=document.getElementById('tblOldKOTItemDtl');
			var rowCount = tblBillItemDtl.rows.length;	
			if (globalTableNo.trim().length == 0)
	        {
	           alert( "Please Select Table");
	            return;
	        }
			
			/* if(gSkipWaiter!="Y")
			{
				if ($("#txtWaiterName").text().trim().length==0)
		        {
					alert("Please select Waiter");
		            return;
		        }
			} */
			
			if (rowCount == 1)
	        {
	           alert("Please select Items");
	           return;
	        }
			else
			{
				if (funCheckKOTSave())
	        	{
			    	$("#hidTakeAway").val(gTakeAway);
			        funMakeBillBtnKOT(ncKot,gTakeAway,globalDebitCardNo,cmsMemCode,cmsMemName,reasonCode,homeDeliveryForTax,arrListHomeDelDetails);
			    }
	        	else
	        	{
	            	alert("Please Save KOt First");
	            	return;
	        	}	
			}
	    }
		
		function funMakeBillBtnKOT(ncKot,gTakeAway,globalDebitCardNo,cmsMemCode,cmsMemName,reasonCode,homeDeliveryForTax,arrListHomeDelDetails)
		{
			document.getElementById("tab2").style.display='block';		
		    document.getElementById("tab1").style.display='none';	
		    
		    hmSettlemetnOptions=new Map();
		    
		    finalSubTotal=0.00;
			finalDiscountAmt=0.00;
			finalNetTotal=0.00;
			taxTotal=0.00;
			taxAmt=0.00;
			finalGrandTotal=0.00;
			
			$("#tableNameForDisplay").text("Table No : "+gTableName);
		    
		    var listItmeDtl=[];
		    var mergeduplicateItm = new Map();
		    
			var tblBillItemDtl=document.getElementById('tblOldKOTItemDtl');
			var rowCount = tblBillItemDtl.rows.length;
			
			var tableNo=gTableNo;
			var paxNo=$("#txtPaxNo").text();
			var waiterNo=gWaiterNo;
			
			var kotNo="";
			for(var i=0;i<rowCount;i++)
			{
				var itemName=tblBillItemDtl.rows[i].cells[0].children[0].value;
				if(itemName.startsWith("KT"))
				{
					kotNo=itemName.split(" ")[0].trim();
					
					continue;
				}
				
				var itemCode=tblBillItemDtl.rows[i].cells[3].children[0].value;
				var itemQty=tblBillItemDtl.rows[i].cells[1].children[0].value;
				var itemAmt=tblBillItemDtl.rows[i].cells[2].children[0].value;
				var itemSeqNo=tblBillItemDtl.rows[i].cells[4].children[0].value;
				var itemDiscAmt=0;
				var isModifier=false;
				
			    if(!(itemQty==" "))
			    {
			    	if(itemName.startsWith("-->"))
					{
			    		isModifier=true;
					}
			    	
			    	 if (mergeduplicateItm.has(itemCode))
				     {
			        	  var prevAddedObj=mergeduplicateItm.get(itemCode);
			        	  var prevQty=prevAddedObj["quantity"];
			        	  var prevAmt=prevAddedObj["amount"];
			        	  
				    	  itemQty=parseFloat(itemQty)+parseFloat(prevQty);
				    	  itemAmt=parseFloat(itemAmt)+parseFloat(prevAmt);
				    		
				    	  $.each(listItmeDtl, function(i, oldListObj) 
						  {	
					    		  if(itemCode==oldListObj.itemCode)
					    		  {
					    			  oldListObj["quantity"]=itemQty;
					    			  oldListObj['amount'] = itemAmt;
					    			  oldListObj['rate'] =itemAmt/itemQty;
					    			  prevAddedObj["quantity"]=itemQty;
					    			  prevAddedObj['amount'] = itemAmt;
					    			  prevAddedObj['rate'] =itemAmt/itemQty;  
							    }
						  });
				      }
			          else
			          {
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
						    
						    singleObj['tableNo'] =tableNo;
						    singleObj['PaxNo'] =paxNo;
						    singleObj['kotNo'] =kotNo;
						    singleObj['WaiterNo'] =waiterNo;
						    singleObj['isModifier'] =isModifier;
						    singleObj['dblCompQty'] =0.0;

						    listItmeDtl.push(singleObj);
							mergeduplicateItm.set(itemCode,singleObj);
				      }
				}	
			}
			
			/**
			*calculating promotions and filling data to grid for bill print	
			*/
			funCalculatePromotion(listItmeDtl);
			
			funRefreshSettlementItemGrid();
			
		}
		
		
		
		
		
		function funCheckKOTSave()
		{
//	 		var kotNo=$("#txtKOTNo").val();
//	 		var flg = false;
//	 		var searchurl=getContextPath()+"/funCheckKOTSave.html?strKOTNo="+kotNo;
//	 		 $.ajax({
//	 			        type: "GET",
//	 			        url: searchurl,
//	 			        dataType: "json",
//	 			        async: false,
//	 			        success: function(response)
//	 			        {
				        	
//	 			        	if(response.flag)
//	 			        		return true;
//	 			        	if(!response.savedKOT)
//	 			        		return false;
//	 			        	else
//	 			        		return true;
				        	
//	 					},
//	 					error: function(jqXHR, exception) {
//	 			            if (jqXHR.status === 0) {
//	 			                alert('Not connect.n Verify Network.');
//	 			            } else if (jqXHR.status == 404) {
//	 			                alert('Requested page not found. [404]');
//	 			            } else if (jqXHR.status == 500) {
//	 			                alert('Internal Server Error [500].');
//	 			            } else if (exception === 'parsererror') {
//	 			                alert('Requested JSON parse failed.');
//	 			            } else if (exception === 'timeout') {
//	 			                alert('Time out error.');
//	 			            } else if (exception === 'abort') {
//	 			                alert('Ajax request aborted.');
//	 			            } else {
//	 			                alert('Uncaught Error.n' + jqXHR.responseText);
//	 			            }		            
//	 			        }
//	 		      });

			return true;
		}
		
		
		function funNCKOTClicked()
		{
			var tblMenuItemDtl=document.getElementById('tblBillItemDtl');
			var ncKOTButton=document.getElementById('NC KOT');
			var rowCount = tblMenuItemDtl.rows.length;	
			if (rowCount > 1)
	        {					
				if(isNCKOT)
				{
					isNCKOT=false;
					$(ncKOTButton).removeClass("active");
	        	}
				else
				{	        				   
				    isNCKOT=true;			    
				    $(ncKOTButton).addClass("active");
		        }
	        }
			else
			{	
				alert("KOT Not Present.");
	            return;
	        }					
		}


		function funPLUItemData()
		{
			funRemoveTableRows("tblItems");
			
			document.getElementById("divTopButtonDtl").style.display='none';
			document.getElementById("divItemDtl").style.display='none';
			document.getElementById("divPLU").style.display='block';
			var table = document.getElementById("tblItems");
			var cntIndex = 0;
			var jsonArrForMenuItemPricing=${command.jsonArrForDirectBillerMenuItemPricing};	
			var index=0;
	 	    itemPriceDtlList=new Array();
			$.each(jsonArrForMenuItemPricing, function(i, obj) 
			{
				rowCount = table.rows.length;
				row = table.insertRow(rowCount);
				var itemName=obj.strItemName.replace(/&#x00A;/g," ");
				row.insertCell(0).innerHTML = "<input type=\"text\" readonly=\"readonly\" id='"
					+ itemName
					+ "' name='"
					+ itemName
					+ "' style=\"border:0px solid black;  width:100%;\"  value='"
					+ itemName + "' onclick=\"funMenuItemClicked(this,"+index+")\"/>";
				itemPriceDtlList[index]=obj;	
				index++;
			});		

		}
		
		
		function funChekCardDtl(tableNo)
		{		
			var searchurl=getContextPath()+"/funChekCardDtl.html?strTableNo="+tableNo;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.flag)
				        		{
				        		$("#txtCardBalance").text(response.cardBalnce);
				        		$("#txtDeditCardBalance").text(response.cardBalnce);
				        		if(response.balAmt > response.kotAmt)
				        			{
				        				$("#txtCardBalance").style.backgroundColor = "#ff0d0d";
				        			}
				        		else
				        			$("#txtCardBalance").style.backgroundColor = "#ff0d0d";
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
			while(rowCount>1)
			{
				table.deleteRow(1);
				rowCount--;
			}
		}
		
		
		
		
		
		function funWaiterClicked(objWaiterButton)
		{
			$("#txtItemSearch").val('');
			var $rows = $('#tblMenuItemDtl').empty();
			var tblMenuItemDtl=document.getElementById('tblMenuItemDtl');
			var selctedWaiterCode=objWaiterButton.id;
			var jsonArrForWaiterDtl=${command.jsonArrForWaiterDtl};
			
			$.each(jsonArrForWaiterDtl, function(i, obj) 
			{									
				if(obj.strWaiterNo==selctedWaiterCode)
				{									
					$("#txtWaiterName").text(obj.strWShortName);	
					gWaiterNo=obj.strWaiterNo;			
					gWaiterName=obj.strWShortName;
				}
			});
			
			if(gSkipPax=="Y")
			{
				funShowMenuHead();
			}
			else
			{
				var pax=document.getElementById("txtPaxNo");
				funChangePAX(pax);
				funShowMenuHead();
			}
		}
		
		
		
		
		
		
		

		function funCheckDebitCardString(debitCardNo)
		{		
			var searchurl=getContextPath()+"/funCheckDebitCardString.html?debitCardNo="+debitCardNo;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.waiterNo.trim().length>0)
				        		{
				        		var waiterInfo=response.waiterNo.split("#");
				        		$("#txtWaiterName").text(waiterInfo[1]);	
								$("#txtWaiterNo").text(waiterInfo[0]);	
				        		
								//document.all["divPaxNo"].style.display = 'block';
				        		
				        		if(gSkipPax!="Y")
				        			{
				        				if(parseInt($("#txtPaxNo").text().trim()) != 0)
				        				 {
				        					funShowMenuHead();
				        					
				                         }
				        				else
				        					$("#txtPaxNo").focus();
				        			}
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
		
		
		
		function funCustomerHistoryBtnClicked()
		{
			 if (gCustomerCode.trim().length==0)
	         {
	        	 alert("Select Customer!");
	             return;
	         }
			 else
			 {
					window.open("frmCustomerHistory.html?strCustCode="+gCustomerCode+"","","dialogHeight:450px;dialogWidth:500px;dialogLeft:400px;");
			 }
		}
		
		$('input[data-list]').each(function () {
			  var availableTags = $('#' + $(this).attr("data-list")).find('option').map(function () {
			    return this.value;
			  }).get();

			  $(this).autocomplete({
			    source: availableTags
			  }).on('focus', function () {
			    $(this).autocomplete('search', ' ');
			  }).on('search', function () {
			    if ($(this).val() === '') {
			      $(this).autocomplete('search', ' ');
			    }
			  });
			});
		
		function funAddCustomerHistory(arr,total)
		{
			$("#txtTotal").val(total);		
			for(var j=0;j<arr.length;j++)
			{
				var itmDtl=arr[j].split("#");
				
				var tblBillItemDtl=document.getElementById('tblBillItemDtl');
				
				var rowCount = tblBillItemDtl.rows.length;
				var insertRow = tblBillItemDtl.insertRow(rowCount);
						
			    var col1=insertRow.insertCell(0);
			    var col2=insertRow.insertCell(1);
			    var col3=insertRow.insertCell(2);
			    var col4=insertRow.insertCell(3);
			    var col5=insertRow.insertCell(4);
			   
			    col1.innerHTML = "<input readonly=\"readonly\" size=\"32px\"  class=\"itemName\"    style=\"text-align: left; color:blue; width:220px;\"   name=\"listItemsDtlInBill["+(rowCount)+"].itemName\" id=\"itemName."+(rowCount)+"\" value='"+itmDtl[1]+"' onclick=\"funGetSelectedRowIndex(this)\"/>";
			    col2.innerHTML = "<input readonly=\"readonly\" size=\"3.5px\"   class=\"itemQty\"      style=\"text-align: right; color:blue;\"  name=\"listItemsDtlInBill["+(rowCount)+"].quantity\" id=\"quantity."+(rowCount)+"\" value='"+parseFloat(itmDtl[2])+"' onclick=\"funChangeQty(this)\"/>";
			    col3.innerHTML = "<input readonly=\"readonly\" size=\"4px\"   class=\"itemAmt\"      style=\"text-align: right; color:blue;\"  name=\"listItemsDtlInBill["+(rowCount)+"].amount\" id=\"amount."+(rowCount)+"\" value='"+itmDtl[3]+"'/>";
			    col4.innerHTML = "<input readonly=\"readonly\" size=\"10px\" class=\"itemCode\"     style=\"text-align: left; color:blue;\"   name=\"listItemsDtlInBill["+(rowCount)+"].itemCode\" id=\"itemCode."+(rowCount)+"\" value='"+itmDtl[0]+"' />";
			    col5.innerHTML = "<input readonly=\"readonly\" size=\"9px\"   class=\"itemDiscAmt\"  style=\"text-align: right; color:blue;\"  name=\"listItemsDtlInBill["+(rowCount)+"].strSerialNo\" id=\"strSerialNo."+(rowCount-1)+"\" value='"+rowCount+"' />";
			    	
			}
		}
		
		
		function funValidateForDoneButton()
		{
			gAreaCode=$("#txtAreaName").val();
			if (gDebitCardPayment=="Yes")
		    {
		    	if (gCheckDebitCardBalanceOnTrans=="Y")
		        {
		        	if (!isNCKOT)
		            {
		            	if ($("#txtCardBalance").text().length==0)
		                {
		                	var debitCardBalance = parseFloat($("#txtCardBalance").text());
		                    if (parseFloat($("#txtTotal").val()) > debitCardBalance)
		                    {
		                    	alert("Insufficient Balance on Card!!!");
		                        return;
		                    }
						}
					}
				}
		    }
			if (homeDeliveryForTax=="Y")
	        {
	        	if (gCustomerCode.trim().length==0)
	            {
	            	alert("Select Customer for Home Delivery!!!");
	                return;
	            }
	        }
			if (gCMSIntegrationYN=="Y")
		    {
		    	if (gClientCode!="074.001")
		        {
		        	if (cmsMemberCode.trim().length == 0)
		            {
	                	alert("Please Select Member!!!");
	                    return;
					}
				}
			}
			else if (!(gCustomerCode.trim().length==0 && homeDeliveryForTax=="Y"))
	        {
	            var totalBillAmount = 0.00;
			 	if ($("#txtTotal").val().trim().length > 0)
	       		{
				 	totalBillAmount = parseFloat($("#txtTotal").val());
	     		}
	            if (!gNewCustomerForHomeDel)
	            {
	            	delCharges=funGetDeliveryCharges(gBuildingCodeForHD, totalBillAmount, gCustomerCode);
	            }
	            if (gDelBoyCompulsoryOnDirectBiller=="Y")
	            {
	                if (gDeliveryBoyCode == "")
	                {
	                    alert( "Please Assign Delivery Boy");
	                    return;
	                }
	            }
	        }
			else if (gRemarksOnTakeAway=="Y")
	        {
	            if (gTakeAway=="Yes" && gCustomerCode.trim().length==0 )
	            {
	                alert("Select Customer For Take Away!!!");
	                return;
	            }
	        }
			 
			var tblBillItemDtl=document.getElementById('tblBillItemDtl');				
			var rowCount = tblBillItemDtl.rows.length;
				 
			if(operationType=="DineIn")
			{
				if(rowCount <= 2)
				{
					alert("No item to save.");
					return;
				}
				ncKot = "N";
				if (isNCKOT) //NC KOT
		    	{
		        	ncKot = "Y";
		          	globalDebitCardNo = "";
		       	}
				var total=$("#txtTotal").val();
				
		        funDoneBtnKOT(ncKot,gTakeAway,globalDebitCardNo,cmsMemCode,cmsMemCode,reasonCode,homeDeliveryForTax,arrListHomeDelDetails,total);
			}
			else if(operationType=="HomeDelivery")
			{
				if(rowCount <= 1)
				{
					alert("No item to save.");
					return;
				}
				
				if (arrDirectBilleritems.length > 0)
				{ 
					if (gCustomerCode.trim().length == 0)
			        {
			           alert("Please select the customer");
			           return;
			        }
					funCheckHomeDelStatus();
					
					funDoneBtnDirectBiller();
				}
				else
				{
					 alert("Please select items");
		        	return;
				}
			}
			else if(operationType=="TakeAway")
			{
				if(rowCount <= 1)
				{
					alert("No item to save.");
					return;
				}
				if (arrDirectBilleritems.length > 0)
				{
					funDoneBtnDirectBiller();
				}
				else
				{
					 alert("Please select items");
		        	return;
				}
			}
		}
		
	function funOpenKOTPrint(areaCode,tableNo,kotNo){
		
		 funDineInButtonClicked();
		
		 var url=window.location.origin+getContextPath()+"/showKOTfile.html?tableNo="+tableNo+"&kotNo="+kotNo+"&areaCode="+areaCode;
		//alert(url);
		 $("#plugin").attr("src", url);
		 $("#dialog").dialog({
			 	autoOpen: false,
		        maxWidth:600,
		        maxHeight: 500,
		        width: 600,
		        height: 500,
		        modal: false,
		        buttons: {
		            /* "Print": function() {
		            	
	 					printJS('plugin', 'html');
		            }, */
		            Cancel: function() {
		                $(this).dialog("destroy");
		                $('#dialog').dialog('destroy');
		            }
		        },
		        close: function() {
		        	 $(this).dialog("destroy");
		        }
			});
		 
		 $("#dialog").dialog('open');
		}
	
	
	
		//Done button for Make KOT
		function funDoneBtnKOT(ncKot,gTakeAway,globalDebitCardNo,cmsMemCode,cmsMemName,reasonCode,homeDeliveryForTax,arrListHomeDelDetails,total)
	    {
			var listItmeDtl=[];
			var tblBillItemDtl=document.getElementById('tblBillItemDtl');
			var rowCount = tblBillItemDtl.rows.length;
			for(var i=2;i<rowCount;i++)
			{
				var itemName=tblBillItemDtl.rows[i].cells[0].children[0].value;
				var itemQty=tblBillItemDtl.rows[i].cells[1].children[0].value;
				
				if(itemQty!="0" )
				{
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
					
					var tableNo=gTableNo;
					var PaxNo=$("#txtPaxNo").text();
					var kotNo=$("#txtKOTNo").text();
					var WaiterNo=gWaiterNo;
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
				    
				    singleObj['tableNo'] =tableNo;
				    if(PaxNo==''){
				    	PaxNo=0;
				    }
				    singleObj['PaxNo'] =PaxNo;
				    singleObj['kotNo'] =kotNo;
				    singleObj['WaiterNo'] =WaiterNo;
				    listItmeDtl.push(singleObj);
					finalSubTotal=finalSubTotal+parseFloat(itemAmt);
					finalDiscountAmt=finalDiscountAmt+parseFloat(0);//(itemDiscAmt);				
				}				
			}
			
			var custcode=$("#customerCode").val();
			var custName=$("#customerName").val();
	   		/* var custName=$("#customerName").text(); */
	   		//Error while on click done button  
	   		if(custcode==null || custName==null){
	   			custcode="";
	   			custName="";
	   		}
	   		var dblTaxAmt = $("#txtTotal").val();
			var searchurl=getContextPath()+"/saveKOT.html?ncKot="+ncKot+"&takeAway="+gTakeAway+"&globalDebitCardNo="+globalDebitCardNo+"&cmsMemCode="+cmsMemCode+"&cmsMemName="+cmsMemName+"&reasonCode="+reasonCode+"&homeDeliveryForTax="+homeDeliveryForTax+
					"&arrListHomeDelDetails="+arrListHomeDelDetails+"&total="+total+"&custCode="+custcode+"&custName="+custName+"&dblTaxAmt="+dblTaxAmt;
			$.ajax({
				type: "POST",
			    url: searchurl,
			    data : JSON.stringify(listItmeDtl),
			    contentType: 'application/json',
			    async: false,
		        success: function (response)
		        {
		        	if(response=="true")
		        	{
		        		alert("KOT Save Successfully. KOT NO: "+ $("#txtKOTNo").text());
			        	if(gMultiWaiterSelOnMakeKOT=="")
			    		{
			    			gMultiWaiterSelOnMakeKOT="N";
			    		}
			    		
			    		/* $("#txtItemSearch").keyup(function()
			    		{
	    					searchTable($(this).val());
			    		}); */
			    		 /* document.getElementById("divItemDtl").style.display='block';
			    		// document.getElementById("divPLU").style.display='none';
			    		 
			    		 document.getElementById("divBillItemDtl").style.display='block';
			    		 document.getElementById("divTotalDtl").style.display='block';
			    		 
			    		 document.getElementById("divTopButtonDtl").style.display='block';
			    		 document.getElementById("divMenuHeadDtl").style.display='block'; */
			    		 
			    		funRemoveTableRows("tblBillItemDtl");
						$('#tblOldKOTItemDtl').empty();
						funOpenKOTPrint(gAreaCode,gTableNo,$('#txtKOTNo').text());
						location.reload();
		        	}
		        	else
		        	{	        		
		        		 alert("KOT Not Save ");
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
		
		
		function funGetDeliveryCharges(buildingCode, totalBillAmount, gCustomerCode)
		{
			var searchurl=getContextPath()+"/funCalculateDeliveryChages.html?buildingCode="+buildingCode+"&totalBillAmount="+totalBillAmount+"&gCustomerCode="+gCustomerCode;
			var delCharges=0;  
			$.ajax({
				 type: "POST",
				        url: searchurl,
				        dataType: "json",
				        async: false,
				        success: function(response)
				        {
				        	delCharges=response;
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
			return delCharges;
			
		}
		
		//show tables
		//<td style="padding: 5px;"><input type="button" id="${command.jsonArrForTableDtl[itemCounter].strTableNo}"  value="${command.jsonArrForTableDtl[itemCounter].strTableName}" style=" width: 100px; height: 100px; white-space: normal;" class="btn btn-primary "  onclick="funTableNoClicked(this,${itemCounter})"  /></td>	
		function funShowTables()
		{
			
			var $rows = $('#tblMenuItemDtl').empty();
			//var $rows = $('#tblMenuHeadDtl').empty();
			//var $rows = $('#tblTopButtonDtl').empty();
			
			var tblMenuItemDtl=document.getElementById('tblMenuItemDtl');
					
			var insertCol=0;
			var insertTR=tblMenuItemDtl.insertRow();
			
			var jsonArrForTableDtl=${command.jsonArrForTableDtl};	
			var areaCode=$("#txtAreaName").val();
			gAreaCode=$("#txtAreaName").val();
			
			
			var searchurl=getContextPath()+"/funLoadTablesForMakeKOT.html?clientCode="+gClientCode+"&posCode="+gPOSCode+"&areaCode="+areaCode;

			var delCharges=0;  
			$.ajax({
				 type: "GET",
				        url: searchurl,
				        dataType: "json",
				        async: false,
				        success: function(response)
				        {
				        	$.each(response, function(i, obj) 
				        	{
				        		//removed border-radius: 40px;
				        		var style=" width: 110px;height: 60px; white-space: normal;   ";
				        		
				        		var cssClass="btn btn-primary";
				        		
				        		
				        		//removed border:5px solid #a94442; border-radius: 40px; 
				    			if(obj.strStatus=="Occupied")
				    			{
				    				style=" width: 110px;height: 60px; white-space: normal;  ";
				    				cssClass="btn btn-danger";
				    			}
				    			
				    			//removed border:5px solid #2ba5cc; border-radius: 40px; 
				    			if(obj.strStatus=="Billed")
				    			{				
				    				style=" width: 110px;height: 60px; white-space: normal; ";
				    				cssClass="btn btn-info";
				    			}
				    			
				    			//removed border:5px solid #2ba5cc; border-radius: 40px; 
				    			if(obj.strStatus=="Reserve")
				    			{				
				    				style=" width: 110px;height: 60px; white-space: normal; ";
				    				cssClass="btn btn-warning";
				    			}
				    			
				    			if(insertCol<tblMenuItemDtl_MAX_COL_SIZE)
				    			{
				    				var col=insertTR.insertCell(insertCol);
				    				col.innerHTML = "<td><input type=\"button\" id="+obj.strTableNo+" value='"+obj.strTableName+"'    style='"+style+"'  onclick=\"funTableNoClicked(this,"+i+")\" class='"+cssClass+"' /></td>";
				    				col.style.padding = "1px";
				    				insertCol++;
				    			}
				    			else
				    			{					
				    				insertTR=tblMenuItemDtl.insertRow();									
				    				insertCol=0;
				    				var col=insertTR.insertCell(insertCol);
				    				col.innerHTML = "<td><input type=\"button\" id="+obj.strTableNo+" value='"+obj.strTableName+"'   style='"+style+"'   onclick=\"funTableNoClicked(this,"+i+")\" class='"+cssClass+"' /></td>";
				    				col.style.padding = "1px";
				    				insertCol++;
				    			}
				        	});
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
		
		
		//show waiters
		function funAddWaiterDtl()
		{
			
			//var $rows = $('#tblMenuItemDtl').empty();
			//var $rows = $('#tblMenuHeadDtl').empty();
		///	var $rows = $('#tblTopButtonDtl').empty();
			
			var tblMenuItemDtl=document.getElementById('tblMenuItemDtl');
					
			var insertCol=0;
			var insertTR=tblMenuItemDtl.insertRow();
			
			var jsonArrForWaiterDtl=${command.jsonArrForWaiterDtl};	
			
			$.each(jsonArrForWaiterDtl, function(i, obj) 
			{	
				//removed border-top-right-radius: 40px;border-top-left-radius: 40px;
				var style="width: 110px;height: 60px;white-space: normal; "
				
				if(insertCol<tblMenuItemDtl_MAX_COL_SIZE)
				{
					var col=insertTR.insertCell(insertCol);
					col.innerHTML = "<td><input type=\"button\" id="+obj.strWaiterNo+" value='"+obj.strWShortName+"'  style='"+style+"'     onclick=\"funWaiterClicked(this)\" class=\"btn btn-primary\" /></td>";
					col.style.padding = "1px";
					insertCol++;
				}
				else
				{					
					insertTR=tblMenuItemDtl.insertRow();									
					insertCol=0;
					var col=insertTR.insertCell(insertCol);
					col.innerHTML = "<td><input type=\"button\" id="+obj.strWaiterNo+" value='"+obj.strWShortName+"'    style='"+style+"'  onclick=\"funWaiterClicked(this)\" class=\"btn btn-primary\" /></td>";
					col.style.padding = "1px";
					insertCol++;
				}							
				  
			});
		}
		
		 function funShowMenuHead()
		{
			 	////funDisplayPLUButton(true);
			 
				var jsonArrForMenuHeads=${command.jsonArrForMenuHeads};	
			
				 //document.getElementById("divMenuHeadDtl").style.display='block';
				 
				/*  $.each(jsonArrForMenuHeads, function(i, obj) 
				{	
					funAddMenuHeadData(obj.strMenuCode,obj.strMenuName);
				}); */
				
				//funAddMenuHeadData(jsonArrForMenuHeads);
				
				funLoadPopularItems();
		}
		 
		 

		function funAddMenuHeadData(jsonArrForMenuHeads)
		{
				var table = document.getElementById("tblMenuHeadDtl");
					
				rowCount = table.rows.length;
				
				var menuHeadRows=parseInt(jsonArrForMenuHeads.length/6);
				var lastMenuColumn=jsonArrForMenuHeads.length % 6 ;
				
				//menuHeadsize=menuHeadsize.split('.')[0];
				var menuIndex=0;
				var style="\"width: 110px; height: 35px; white-space: normal;\""; //
				for(k=0;k<menuHeadRows;k++){
						
						row = table.insertRow(rowCount);
						var col1=row.insertCell(0);
						var col2=row.insertCell(1);
						var col3=row.insertCell(2);
						var col4=row.insertCell(3);
						var col5=row.insertCell(4);
						var col6=row.insertCell(5);
						
						if(rowCount==0)
						{
							col1.style.padding = "1px";
							col1.innerHTML= "<td><input readonly=\"readonly\" id='PopularItem' value='POPULAR'  data-toggle=\"tooltip\" data-placement=\"top\" title='POPULAR ITEM' style="+style+" onclick=\"funLoadPopularItems()\" class=\"mdc-card info-card4\" /></td>";
							menuIndex=menuIndex-1;
						}else{
							
							col1.style.padding = "1px";
							col1.innerHTML= "<td ><input readonly=\"readonly\" id="+jsonArrForMenuHeads[menuIndex].strMenuCode+" value='"+jsonArrForMenuHeads[menuIndex].strMenuName+"'  data-toggle=\"tooltip\" data-placement=\"top\" title='"+jsonArrForMenuHeads[menuIndex].strMenuName+"'  style="+style+"  class=\"mdc-card info-card4\" /></td>";
								
						} 
						
						
						col2.style.padding = "1px";
						col2.innerHTML= "<td ><input readonly=\"readonly\" id="+jsonArrForMenuHeads[menuIndex+1].strMenuCode+" value='"+jsonArrForMenuHeads[menuIndex+1].strMenuName+"'  data-toggle=\"tooltip\" data-placement=\"top\" title='"+jsonArrForMenuHeads[menuIndex+1].strMenuName+"'   style="+style+"  onclick=\"funMenuHeadButtonClicked(this)\"  class=\"mdc-card info-card4\" /></td>";
						
						col3.style.padding = "1px";
						col3.innerHTML= "<td ><input readonly=\"readonly\" id="+jsonArrForMenuHeads[menuIndex+2].strMenuCode+" value='"+jsonArrForMenuHeads[menuIndex+2].strMenuName+"'  data-toggle=\"tooltip\" data-placement=\"top\" title='"+jsonArrForMenuHeads[menuIndex+2].strMenuName+"'   style="+style+"  onclick=\"funMenuHeadButtonClicked(this)\"  class=\"mdc-card info-card4\" /></td>";
						
						col4.style.padding = "1px";
						col4.innerHTML= "<td ><input readonly=\"readonly\" id="+jsonArrForMenuHeads[menuIndex+3].strMenuCode+" value='"+jsonArrForMenuHeads[menuIndex+3].strMenuName+"'  data-toggle=\"tooltip\" data-placement=\"top\" title='"+jsonArrForMenuHeads[menuIndex+3].strMenuName+"'   style="+style+"  onclick=\"funMenuHeadButtonClicked(this)\"  class=\"mdc-card info-card4\" /></td>";
						
						col5.style.padding = "1px";
						col5.innerHTML= "<td ><input readonly=\"readonly\" id="+jsonArrForMenuHeads[menuIndex+4].strMenuCode+" value='"+jsonArrForMenuHeads[menuIndex+4].strMenuName+"'  data-toggle=\"tooltip\" data-placement=\"top\" title='"+jsonArrForMenuHeads[menuIndex+4].strMenuName+"'   style="+style+"  onclick=\"funMenuHeadButtonClicked(this)\"  class=\"mdc-card info-card4\" /></td>";
					
						col6.style.padding = "1px";
						col6.innerHTML= "<td ><input readonly=\"readonly\" id="+jsonArrForMenuHeads[menuIndex+5].strMenuCode+" value='"+jsonArrForMenuHeads[menuIndex+5].strMenuName+"'  data-toggle=\"tooltip\" data-placement=\"top\" title='"+jsonArrForMenuHeads[menuIndex+5].strMenuName+"'   style="+style+"  onclick=\"funMenuHeadButtonClicked(this)\"  class=\"mdc-card info-card4\" /></td>";
						
						menuIndex=menuIndex+6;
						rowCount++;
					}
				
				if(lastMenuColumn>0){
					row = table.insertRow(rowCount);
					for(k=0;k<lastMenuColumn;k++){
						
						var col1=row.insertCell(k);
						col1.style.padding = "1px";
						col1.innerHTML= "<td ><input readonly=\"readonly\" id="+jsonArrForMenuHeads[(menuHeadRows*6)+k].strMenuCode+" value='"+jsonArrForMenuHeads[(menuHeadRows*6)+k].strMenuName+"'  data-toggle=\"tooltip\" data-placement=\"top\" title='"+jsonArrForMenuHeads[(menuHeadRows*6)+k].strMenuName+"'   style="+style+"  onclick=\"funMenuHeadButtonClicked(this)\"  class=\"mdc-card info-card4\" /></td>";
						
					}
				}
				
		}
		
		function funLoadPopularItems()
		{		
			var searchurl=getContextPath()+"/funLoadPopularItems.html";
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {	
				        	funAddPopularItemsData(response.PopularItems);
				        	
				        	if(gMenuItemSortingOn!="NA")
				        	{
				        		flagPopular="Popular";
				        	
				        		//funFillTopButtonList(flagPopular);
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
		
		function funAddPopularItemsData(popularItems)
		{
			var $rows = $('#tblMenuItemDtl').empty();
			var tblMenuItemDtl=document.getElementById('tblMenuItemDtl');
			var rowCount = tblMenuItemDtl.rows.length;	
			itemPriceDtlList=new Array();
			var insertCol=0;
			var insertTR=tblMenuItemDtl.insertRow();
			var index=0;
			$.each(popularItems, function(i, obj) 
			{									
					if(insertCol<tblMenuItemDtl_MAX_COL_SIZE)
					{
						index=rowCount*4+insertCol;
						var col=insertTR.insertCell(insertCol);
						col.innerHTML = "<td><input type=\"button\" id="+obj.strItemCode+" value='"+obj.strItemName+"'    style=\"width: 110px;height: 60px; white-space:normal;font-size: 11px;\"  onclick=\"funMenuItemClicked(this,"+index+")\" class=\"mdc-card info-card4\" /></td>";
						col.style.padding = "1px";
						
						insertCol++;
					}
					else
					{	
						rowCount++;	 		
						insertTR=tblMenuItemDtl.insertRow();									
						insertCol=0;
						index=rowCount*4+insertCol;				
						var col=insertTR.insertCell(insertCol);
						col.innerHTML = "<td><input type=\"button\" id="+obj.strItemCode+" value='"+obj.strItemName+"'    style=\"width: 110px;height: 60px; white-space: normal;font-size: 11px;\"  onclick=\"funMenuItemClicked(this,"+index+")\" class=\"mdc-card info-card4\" /></td>";
						col.style.padding = "1px";
						
						insertCol++;
					}							
					itemPriceDtlList[index]=obj;
				  
			});
		} 

		function funCheckHomeDelivery(tableNo)
		{		
			if(arrKOTItemDtlList.length==0)
				funRemoveTableRows("tblBillItemDtl");
			
			var searchurl=getContextPath()+"/funCheckHomeDelivery.html?strTableNo="+tableNo;
			$.ajax({
						type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.flag)
				        	{
				        		//$("#customerName").text(response.strCustomerName);
				        		$("#customerName").val(response.strCustomerName);
				        		homeDeliveryForTax = "Y";
			        			arrListHomeDelDetails[0]=response.strCustomerCode;
			        			arrListHomeDelDetails[1]=response.strCustomerName;
			        			arrListHomeDelDetails[2]=response.strBuldingCode;
			        			arrListHomeDelDetails[3]="Home Delivery";
			        			arrListHomeDelDetails[4]=response.strDelBoyCode;
			        			arrListHomeDelDetails[5]=response.strDPName;
				        	}
				        	else
				        	{
				        		//$("#customerName").text("");
				        		//$("#customerName").val("");
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
		

		
		function funChekTableDtl(tableNo)
		{		
			var $rows =$('#tblOldKOTItemDtl').empty();
				
			var searchurl=getContextPath()+"/funChekCustomerDtl.html?strTableNo="+tableNo;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.flag)
				        	{
				        		$("#txtPaxNo").text(response.intPaxNo);
				        		
				        		if(response.strCustomerCode!=null)
				        		{
				        			gCustomerCode=response.strCustomerCode;
				        			gCustomerName=response.strCustomerName;
				        			
				        			//$("#customerName").text(gCustomerName);
				        			$("#customerName").val(gCustomerName);
					        		$("#customerCode").val(gCustomerCode);
					    			
				        			funSetCustomerDataForHD(response.strCustomerCode);
				        			
				        			//alert("funChekTableDtl Cust Code = "+gCustomerCode+" Cust Name = "+gCustomerName+" Flag= "+gCMSIntegrationYN);
				        		}
				        		if(response.strHomeDelivery=="Yes")
			        			{
				        			 homeDeliveryForTax = "Y";
				        			 arrListHomeDelDetails[0]=response.strCustomerCode;
				        			 arrListHomeDelDetails[1]=response.strCustomerName;
				        			 arrListHomeDelDetails[2]="Home Delivery";
				        			 arrListHomeDelDetails[3]="";
				        			 arrListHomeDelDetails[4]="";
			        			}
				        		else
				        			homeDeliveryForTax = "N";
				        		
				        		funChekCardDtl(tableNo);
				        		funFillOldKOTItems(tableNo);
				        		if(gMultiWaiterSelOnMakeKOT=="Y")
			        			{
				        			if(gSelectWaiterFromCardSwipe=="Y" && response.posConfigSelectWaiterFromCardSwipe=="true")
				        			{
					        			 var card = prompt("please Swipe The Card", "");
					        			 funCheckDebitCardString(card);
					        		}
				        			else
				        			{
				        				if(response.waiterNo=="all")
					        			{
				        					funAddWaiterDtl();			        					
					        			}
				        				else
				        				{
				        					var jsonArrForWaiterDtl=${command.jsonArrForWaiterDtl};	
				        					$.each(jsonArrForWaiterDtl, function(i, obj) 
				        					{									
				        						if(obj.strWaiterNo==response.strWaiterNo)
				        						{
				        							$("#txtWaiterName").text(obj.strWShortName);	
				        							$("#txtWaiterNo").text(obj.strWaiterNo);
				        							
				        							gWaiterNo=obj.strWaiterNo;
				        							gWaiterName=obj.strWShortName;
				        						}
				        					});	
				        				}
				        			}
			        			}
				        		else
	        					{
		        					 var jsonArrForWaiterDtl=${command.jsonArrForWaiterDtl};	
		        					$.each(jsonArrForWaiterDtl, function(i, obj) 
		        					{									
		        						if(obj.strWaiterNo==response.strWaiterNo)
		        						{
		        							$("#txtWaiterName").text(obj.strWShortName);	
		        							$("#txtWaiterNo").text(obj.strWaiterNo);
		        							
		        							gWaiterNo=obj.strWaiterNo;
		        							gWaiterName=obj.strWShortName;
		        						}
		        					});
		        					funShowMenuHead();
		        					funCheckHomeDelivery(tableNo);
	        					}
				        	}			        		
				        	else if(gSkipWaiter=="Y" && gSkipPax=="Y")
				        	{
				        		funShowMenuHead();
				        	}
				        	else if(gSkipWaiter=="Y")
				        	{
				        		document.all["tblPaxNo"].style.display = 'block';
				        	}
				        	else
				        	{
				        		funAddWaiterDtl();
				        	}
				        	
				        	gAreaCode=response.AreaCode;
				        	$("#txtAreaName").val(response.AreaCode);
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
		
		
		
		function funCustomerMaster(strMobNo)
		{
			fieldName="NewCustomer";
			<%session.setAttribute("frmName", "frmPOSRestaurantBill");%>
			window.open("frmPOSCustomerMaster.html?intlongMobileNo="+strMobNo,"","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
		}
		
		function funSetCustomerDataForHD(code)
		{
			code=code.trim();
			var searchurl=getContextPath()+"/loadPOSCustomerMasterData.html?POSCustomerCode="+code;
			$.ajax({
					type: "GET",
					url: searchurl,
					dataType: "json",
					success: function(response)
					{
						gCustomerCode=response.strCustomerCode;
					    gCustomerName=response.strCustomerName;
					        	
					    //$("#customerName").text(gCustomerName);
					    $("#customerName").val(gCustomerName);
					    $("#customerCode").val(gCustomerCode);
					    $("#custMobileNo").val(response.intlongMobileNo);
					        					        	
					    //alert("funSetCustomerDataForHD Cust Code = "+gCustomerCode+" Cust Name = "+gCustomerName);
					    
					    funSetHomeDeliveryData(response.strCustomerCode,response.strCustomerName,response.strBuldingCode,"","");
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
		
		
		
		function funChekReservation(tableNo)
		{		
			var searchurl=getContextPath()+"/funChekReservation.html?strTableNo="+tableNo;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.flag)
				        	{
				        		$("#customerName").val(response.strCustomerName);
				        		//$("#customerName").text(response.strCustomerName);
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
		
		
		
		/*
		* when Dine In Table Selected 
		*/
		function funTableNoClicked(objTable,objIndex)
		{
			$("#txtItemSearch").val('');
			var tableNo=objTable.id;
			var tableName=objTable.value;
			
			var jsonArrForTableDtl=${command.jsonArrForTableDtl};	
			var objselectedTableDtl;
			$.each(jsonArrForTableDtl, function(i, obj) 
					{									
						if(obj.strTableNo==tableNo)
						{
							objselectedTableDtl=obj;	
						}
					});
					
			
			$("#txtTableNo").text(tableName);
			gTableNo=tableNo;
			gTableName=tableName;
			globalTableNo=tableNo;
			
			$("#txtAreaName").val(objselectedTableDtl.strAreaCode);
			var areaCode=$("#txtAreaName").val();
			gAreaCode=$("#txtAreaName").val();
			
			//$("#txtPaxNo").text(objselectedTableDtl.intPaxNo);
			 if(gSkipWaiter!="Y")
			{
				if ($("#txtWaiterName").text().trim().length==0)
		        {
					alert("Please select Waiter");
		            return;
		        }
			}
			
			
			funChekTableDtl(tableNo);
			funChekReservation(tableNo);
			funFillMapWithHappyHourItems();
		}
		
		function funResetDineInFields()
		{
			$("#txtTableNo").text("");	
			$("#txtWaiterNo").text("");
			$("#txtWaiterName").text("");
			$("#txtPaxNo").text("");
			$("#txtKOTNo").text("");
			$("#txtTotal").val("0");
			
			gTableNo="";
			gTableNo="";
			gTableName="";
			gWaiterName="";
			gPAX=0;
			gLastKOTNo="";
			
			homeDeliveryForTax="N";
			
			 funDisplayDoneButton(false);
			 funDisplayMakeBillButton(false);
			 var ncKOTButton=document.getElementById('NC KOT');
			 isNCKOT=false;
			 $(ncKOTButton).removeClass("active");
		}		
		
		
		function funTakeAwayBtnClicked()
		{
			//document.getElementById("divBillItemDtl").style.height = "710px";
			//document.getElementById("divDineInDetail").style.display='none';
			var tblBillItemDtl = document.getElementById("tblBillItemDtl");
			var tblOldKOTItemDtl=document.getElementById('tblOldKOTItemDtl');
			
			var rowCount = tblBillItemDtl.rows.length;
			if(rowCount>1)
			{
				if(confirm("Do you want to save order?"))
				{
					return;
				}
				else
				{
					funRemoveTableRows("tblBillItemDtl");
					$('#tblOldKOTItemDtl').empty();
				}
			}
			else
			{
				funRemoveTableRows("tblBillItemDtl");
				$('#tblOldKOTItemDtl').empty();
			}
			
			var objDnieInButton=document.getElementById("Dine In");
			var objHomeDeliveryButton=document.getElementById("Home Delivery");
			var objTakeAwayButton=document.getElementById("Take Away");
			
			var isActive=$(objTakeAwayButton).hasClass("active");
			
			$(objTakeAwayButton).addClass("active");		
			$(objDnieInButton).removeClass("active");
			$(objHomeDeliveryButton).removeClass("active");
			
			operationType="TakeAway";
			transactionType="Direct Biller";
			
			 homeDeliveryForTax = "N";		 		
			 gTakeAway="Yes";
			 
			 //funDisplayPLUButton(false);
			 funDisplayDoneButton(false);
			 funDisplayMakeBillButton(false);
			 //funDisplayPLUButton(false);
				
			//load menuheads
			var $rows = $('#tblMenuItemDtl').empty();
			funShowMenuHead();	
				
				
			
		}
		

		
		function funDineInButtonClicked()
		{	
			funOnCloseBtnClick();
			var tblBillItemDtl = document.getElementById("tblBillItemDtl");
			var tblOldKOTItemDtl=document.getElementById('tblOldKOTItemDtl');
			
			var rowCount = tblBillItemDtl.rows.length;
			if(rowCount>1)
			{
				if(confirm("Do you want to save order?"))
				{
					return;
				}
				else
				{
					funRemoveTableRows("tblBillItemDtl");
					$('#tblOldKOTItemDtl').empty();
				}
			}
			else
			{
				funRemoveTableRows("tblBillItemDtl");
				$('#tblOldKOTItemDtl').empty();
			}		
			
			
			var objDnieInButton=document.getElementById("Dine In");
			var objHomeDeliveryButton=document.getElementById("Home Delivery");
			var objTakeAwayButton=document.getElementById("Take Away");
			
			var isActive=$(objDnieInButton).hasClass("active");
					
			
			$(objDnieInButton).addClass("active");		
			$(objHomeDeliveryButton).removeClass("active");
			$(objTakeAwayButton).removeClass("active");
			
			operationType="DineIn";
			transactionType="Make KOT";
			
			 homeDeliveryForTax = "N";		 		
			 gTakeAway="No";
			
			funResetDineInFields();
			
		//	funShowTables();
			
		}
		
		function funHomeBtnclicked()
		{
			var loginPOS="${loginPOS}";
		
			if (arrKOTItemDtlList.length > 0)
	        {
	           if(confirm( "Do you want to end Transaction?"))
	        	   window.location ="frmGetPOSSelection.html?strPosCode="+loginPOS;
			else
	            return;
	        } 
	        else
	        {
	        	window.location ="frmGetPOSSelection.html?strPosCode="+loginPOS;
	        }	
	    }
		
		
		/**
		* Sets the home delivery datda 
		*/	
		function funClearDineInData()
		{
			funResetDineInFields();
			
			
			/* $('#tblBillItemDtl').empty(); */
			funRemoveTableRows("tblBillItemDtl");
			
			$('#tblOldKOTItemDtl').empty();
		}
		
		
		function funHomeDeliveryBtnClicked()
		{
			document.getElementById("divBillItemDtl").style.height = "710px";
			document.getElementById("divDineInDetail").style.display='none';
			var tblBillItemDtl = document.getElementById("tblBillItemDtl");
			var tblOldKOTItemDtl=document.getElementById('tblOldKOTItemDtl');
			
			var rowCount = tblBillItemDtl.rows.length;
			if(rowCount>1)
			{
				if(confirm("Do you want to save order?"))
				{
					return;
				}
				else
				{
					funClearDineInData();
				}
			}
			else
			{
				funClearDineInData();
			}		
			
			var objDnieInButton=document.getElementById("Dine In");
			var objHomeDeliveryButton=document.getElementById("Home Delivery");
			var objTakeAwayButton=document.getElementById("Take Away");
			
			var isActive=$(objHomeDeliveryButton).hasClass("active");
			
			$(objHomeDeliveryButton).addClass("active");
			
			$(objDnieInButton).removeClass("active");
			$(objTakeAwayButton).removeClass("active");
			
			operationType="HomeDelivery";
			transactionType="Direct Biller";
			
			//funDisplayPLUButton(false);
			funDisplayDoneButton(false);
			funDisplayMakeBillButton(false);
			//funDisplayPLUButton(false);
			
			
			//load menuheads
			var $rows = $('#tblMenuItemDtl').empty();
			
			funShowMenuHead();
		}
		function funCheckHomeDelStatus()
		{
			homeDeliveryForTax = "Y";

			operationType="HomeDelivery";
			
	        
	        arrListHomeDelDetails[0]=gCustomerCode;
	        arrListHomeDelDetails[1]=gCustomerName;
	        arrListHomeDelDetails[2]=gBuildingCodeForHD;
	        arrListHomeDelDetails[3]="Home Delivery";
	        arrListHomeDelDetails[4]="";
	        arrListHomeDelDetails[5]="";
	        
	        
			if(gTakeAway=="Yes")
			{
			    gTakeAway="No";
			}
			
			
			if(gCustAddressSelectionForBill=="Y")
			{
			 	window.open("frmHomeDeliveryAddress.html?strMobNo="+gMobileNo+"","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
			} 
		}
		

		
		function funCustomerBtnClicked()
		{
			var custMbNo = prompt("Enter Mobile No", "");
			$("#custMobileNo").val(custMbNo);
			
			if(gCMSIntegrationYN=="Y")
			{
				funChekCMSCustomerDtl();
			}
			else
	        {
	            funNewCustomerButtonPressed();
	        }
		}
		
		
		function funNewCustomerButtonPressed()
		{
			var strMobNo = $("#custMobileNo").val();
			if(strMobNo.length >0 )
			{
				if (gCRMInterface=="SQY")
			    {
					funCallWebService(strMobNo);
			    }
				else if (gCRMInterface=="PMAM")
			    {
					funSetCustMobileNo(strMobNo);
					$("#hidCustMobileNo").val(strMobNo);
				}
				else
			    {			
					if(strMobNo.length>0)
					{
						funSetCustMobileNo(strMobNo);
					}
				} 
			 }
			 else
			 {
				 $("#custMobileNo").val("");
				 //$("#customerName").text("");
				 $("#customerName").val("");
			 }
		}

		function  funSetCustMobileNo(strMobNo)
		{
			gMobileNo=strMobNo;
		
			if (strMobNo.length == 0)
	        {
				funHelp1('POSCustomerMaster');
	        }
			else
			{
				funCheckCustomer(strMobNo);
			}
		}
		
		
		
		function funCheckCustomer(strMobNo)
		{
			var totalBillAmount = 0.00;
			if ($("#txtTotal").val().trim().length > 0)
	        {
				totalBillAmount = parseFloat($("#txtTotal").val());
	        }	
			var searchurl=getContextPath()+"/funCheckCustomer.html?strMobNo="+strMobNo;
			$.ajax({
						type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	//$("#customerName").text("");
				        	$("#customerName").val("");
				        	$("#custMobileNo").val("");
				        	
				        	 if (response.flag)
				             {
				        		 gCustomerCode=response.strCustomerCode;
				        		 gCustomerName=response.strCustomerName;			        		 
				        		 gBuildingCodeForHD= response.strBuldingCode;
				        		 
				        		 //$("#customerName").text(gCustomerName);
				        		 $("#customerName").val(gCustomerName);
				        		 $("#customerCode").val(gCustomerCode);
				        		 $("#custMobileNo").val(response.longMobileNo);
				        		 
				        		 //alert("funCheckCustomer Cust Code = "+gCustomerCode+" Cust Name = "+gCustomerName);
				             }	
				        	 else
				        	 {
				        		 gNewCustomerForHomeDel = true;
			                     gTotalBillAmount = totalBillAmount;
			                     gNewCustomerMobileNo =gMobileNo;
				        	
			                     funCustomerMaster(strMobNo);
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
		
		
		function funCallWebService(strMobNo)
		{
			var searchurl=getContextPath()+"/funCallWebService.html?strMobNo="+strMobNo;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	 if (null != response.code)
				             {
				                 if (parseInt(response.code) == 323)
				                 {
				                     alert("Discount Request Expired! Please ask the customer to regenerate discount request!");
				                     return 0;
				                 }
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

		
		function funChekCMSCustomerDtl()
		{		
			var searchurl=getContextPath()+"/funChekCMSCustomerDtl.html?strTableNo="+globalTableNo;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        async: false,
				        success: function(response)
				        {
				        	if(response.flag)
				        	{
					        	if(response.dblAmount<1)
					        		funGetCMSMemberCode();
					        	else
					        	{
					        		cmsMemCode=response.strCustomerCode;
					        		cmsMemName=response.strCustomerName;
					        	}
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
		
		
		function funGetCMSMemberCode()
		{
			 var strCustomerCode = prompt("Enter Member Code", "");
			 if(strCustomerCode.trim().length>0)
				 {
				 var searchurl=getContextPath()+"/funCheckMemeberBalance.html?strCustomerCode="+strCustomerCode;
				 $.ajax({
					        type: "GET",
					        url: searchurl,
					        dataType: "json",
					        success: function(response)
					        {
					        	if(response.flag)
					        	{
					        		 if (response.memberInfo.split("#")[4].trim().equals("Y"))
					                 {
					                     alert("Member is blocked");
					                     return;
					                 }
					                 else
					                 {
					                     cmsMemCode = response.memberInfo.split("#")[0];
					                     cmsMemName = response.memberInfo.split("#")[1];
					                     
					                     //$("#customerName").text(cmsMemName);
					                     $("#customerName").val(cmsMemName);
								         gCustomerCode=cmsMemCode;
								         gCustomerName=cmsMemName;
					                     
					                     
					                     var creditLimit = parseFloat(response.memberInfo.split("#")[2]);
										var totalAmt;
					                     if ($("#txtTotal").val().trim().length > 0)
					                     {
					                         totalAmt = $("#txtTotal").val();
					                     }
					                     if (creditLimit < totalAmt)
					                     {
					                      alert("Credit Limit is " + creditLimit);
					                     }
					                 }
					        	
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
		}
		
		
		//Apply Validation on Number TextFiled
		function funApplyNumberValidation() {
			$(".numeric").numeric();
			$(".integer").numeric(false, function() {
				alert("Integers only");
				this.value = "";
				this.focus();
			});
			$(".positive").numeric({
				negative : false
			}, function() {
				alert("No negative values");
				this.value = "";
				this.focus();
			});
			$(".positive-integer").numeric({
				decimal : false,
				negative : false
			}, function() {
				alert("Positive integers only");
				this.value = "";
				this.focus();
			});
			$(".decimal-places").numeric({
				decimalPlaces : maxQuantityDecimalPlaceLimit,
				negative : false
			});
			$(".decimal-places-amt").numeric({
				decimalPlaces : maxAmountDecimalPlaceLimit,
				negative : false
			});
		}
		
		
		//function to update item which is alredy order item (duplicate)
			function funUpdateTableBillItemDtlFor(objMenuItemPricingDtl,price,qty)
		{
			$('#tblBillItemDtl tbody tr').each(function () 
			{
				//'td:nth-child(4)' for itemcode 
			    $('td:nth-child(4)', this).each(function () 
			    {	     
			     	var element=$(this).html();	
			        	
			       	var itemCode=$(element).attr("value");
			       	if(itemCode==objMenuItemPricingDtl.strItemCode)
			       	{
			       	 	var rowIndex = this.parentNode.rowIndex;					
			    	 	var colIndex = 2; /* this.cellIndex; *///for qty
			    	 	
			    	 	var oldQty = $(this.parentNode).find(".itemQty").val(); 
			    	 	var oldAmt= $(this.parentNode).find(".itemAmt").val(); 
					
			    	 	var rate=parseFloat(oldAmt)/parseFloat(oldQty);
			    	 	
			    	 	    	 
			    	 	var newQty=parseFloat(oldQty)+parseFloat(qty);
			    	 	
			    	 	var newAmt=parseFloat(rate)*parseFloat(newQty);
			    	 	
			    	 	$(this.parentNode).find(".itemQty").val(parseFloat(newQty)); 
			    	 	$(this.parentNode).find(".itemAmt").val(parseFloat(newAmt));
			    	 			       		
			       	}		        			        
			     });		
			});	
		}
		
		
		//function to to check is alredy order item (duplicate)
		function funIsAlreadyOrderedItem(objMenuItemPricingDtl)
		{		
			var isOrdered=false;
			$('#tblBillItemDtl tbody tr').each(function () 
			{
				//'td:nth-child(4)' for itemcode 
			    $('td:nth-child(4)', this).each(function () 
			    {	     
			     	var element=$(this).html();	
			        	
			       	var itemCode=$(element).attr("value");
			       	if(itemCode==objMenuItemPricingDtl.strItemCode)
			       	{		       	 
			       		isOrdered=true;
			       	}		        			        
			     });						
			});	
			
			return isOrdered;
			
		}
		
		

		
		function funHelp1(transactionName)
		{
			fieldName=transactionName;
			window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
		}
		
		

			function funSetDeliveryBoy(code)
			{
				code=code.trim();
				var searchurl=getContextPath()+"/loadPOSDeliveryBoyMasterData.html?dpCode="+code;
				 $.ajax({
					        type: "GET",
					        url: searchurl,
					        dataType: "json",
					        success: function(response)
					        {
					        	arrListHomeDelDetails[4]=code;//4 del person code
					            arrListHomeDelDetails[5]=response.strDPName;//5 del person name
					            gDeliveryBoyCode=code;
					        	document.all["lblDpName"].style.display = 'block';
					        	$("#dpName").text(response.strDPName);
					        	$("#hidDeliveryBoyCode").val(response.strDPCode);
					        	$("#hidDeliveryBoyName").val(response.strDPName);
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

			function funSetHomeDeliveryData(custCode, custName, buildingCode, delPersonCode, delPersonName)
		    {
		        arrListHomeDelDetails.length=0;
		        arrListHomeDelDetails[0]=custCode;//0 cust code
		        arrListHomeDelDetails[1]=custName;//1 cust name
		        arrListHomeDelDetails[2]=buildingCode;//2 building code
		        arrListHomeDelDetails[3]="Home Delivery";//3 home delivery
		        arrListHomeDelDetails[4]=delPersonCode;//4 del person code
		        arrListHomeDelDetails[5]=delPersonName;//5 del person name
		    }
			
			function funFillMapWithHappyHourItems()
			{		
				var searchurl=getContextPath()+"/funFillMapWithHappyHourItems.html";
				$.ajax({
					        type: "GET",
					        url: searchurl,
					        dataType: "json",
					        async:false,
					        success: function(response)
					        {
					        	for(var i=0;i<response.ItemPriceDtl.length;i++)
				        		{
					        		hmHappyHourItems[response.ItemCode[i]] = response.ItemPriceDtl[i];
				        		}
					        	gDebitCardPayment=response.gDebitCardPayment;
					        	currentDate=response.CurrentDate;
					        	currentTime=response.CurrentTime;
					        	dayForPricing=response.DayForPricing;
					        	
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
		
		
			function funFillKOTTimeDtl(rowCount,kotNo)
			{		
				var currentTime = new Date();
				var kotTime=currentTime.getHours()+":"+currentTime.getMinutes()+":"+currentTime.getSeconds();
				
				var insertRow = tblBillItemDtl.insertRow(rowCount);
			
			    var col1=insertRow.insertCell(0);
			    var col2=insertRow.insertCell(1);
			    var col3=insertRow.insertCell(2);
			    var col4=insertRow.insertCell(3);
			    var col5=insertRow.insertCell(4);
			    var col6=insertRow.insertCell(5);
			    var col7=insertRow.insertCell(6);
			    var col8=insertRow.insertCell(7);
			    var col9=insertRow.insertCell(8);
			    var col10=insertRow.insertCell(9);
			    var col11=insertRow.insertCell(10);
			    var col12=insertRow.insertCell(11);
			    var col13=insertRow.insertCell(12);
			    
			    col1.innerHTML = "<input readonly=\"readonly\" size=\"32px\"   class=\"itemName\"   style=\"text-align: left; color:blue;\"     id=\"strItemName."+(rowCount)+"\" value='"+kotNo+"           "+kotTime+"' />";
			    col2.innerHTML = "<input readonly=\"readonly\" size=\"3.5px\"   class=\"itemQty\"      style=\"text-align: left; color:blue;\"  id=\"dblQuantity."+(rowCount)+"\" value=' '/>";
			    col3.innerHTML = "<input type=\"hidden\"  size=\"0px\"   class=\"itemAmt\"     id=\"dblAmount."+(rowCount)+"\" value='' />";
			    col4.innerHTML = "<input type=\"hidden\"  size=\"0px\" class=\"itemCode\"      id=\"strItemCode."+(rowCount)+"\" value='' />";
			    col5.innerHTML = "<input type=\"hidden\"  size=\"0px\"   class=\"itemDiscAmt\"    id=\"strSerialNo."+(rowCount)+"\" value='' />";
			    col6.innerHTML = "<input type=\"hidden\"  size=\"0px\"   class=\"groupcode\"   name=\"listItemsDtlInBill["+(rowCount)+"].strGroupcode\" id=\"strGroupcode."+(rowCount-1)+"\" value='' />";	    
			    col7.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"subgroupcode\"  name=\"listItemsDtlInBill["+(rowCount)+"].strSubGroupCode\" id=\"strSubGroupCode."+(rowCount)+"\" value='' />";
			    col8.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"subGroupName\"  name=\"listItemsDtlInBill["+(rowCount)+"].strSubGroupName\" id=\"strSubGroupName."+(rowCount)+"\" value='' />";
			    col9.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"groupName\"  name=\"listItemsDtlInBill["+(rowCount)+"].strGroupName\" id=\"strGroupName."+(rowCount)+"\" value='' />";	    
			    col10.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"tableNo\"  name=\"listItemsDtlInBill["+(rowCount)+"].tableNo\" id=\"tableNo."+(rowCount)+"\" value='"+tableNo+"' />";
			    col11.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"paxNo\"  name=\"listItemsDtlInBill["+(rowCount)+"].paxNo\" id=\"paxNo."+(rowCount)+"\" value='' />";
			    col12.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"KOTNo\"  name=\"listItemsDtlInBill["+(rowCount)+"].KOTNo\" id=\"KOTNo."+(rowCount)+"\" value='' />";
			    col13.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"waiterNo\"  name=\"listItemsDtlInBill["+(rowCount)+"].waiterNo\" id=\"waiterNo."+(rowCount)+"\" value='' />";
			     
			}
		
			
		
		function funFillTableBillItemDtl(objMenuItemPricingDtl,price,qty)
		{	
			var itemName=objMenuItemPricingDtl.strItemName.replace(/&#x00A;/g," ");
			var tblBillItemDtl=document.getElementById('tblBillItemDtl');
			var rowCount = tblBillItemDtl.rows.length;
			
			if(operationType=="DineIn")
			{
				var kotNo= $('#txtKOTNo').text();
			    var PaxNo= $('#txtPaxNo').text();
			    var tableNo = $('#txtTableNo').text();
			    var WaiterNo = $('#txtWaiterNo').text();
			   
			    if(rowCount==1)
				{
					funFillKOTTimeDtl(rowCount,kotNo);
					rowCount++;
				}
			    else
			    {
					var currentTime = new Date();
					var kotTime=currentTime.getHours()+":"+currentTime.getMinutes()+":"+currentTime.getSeconds();
					var i=1;
				}
			}
			
			var insertRow = tblBillItemDtl.insertRow(rowCount);
					
		    var col1=insertRow.insertCell(0);
		    var col2=insertRow.insertCell(1);
		    var col3=insertRow.insertCell(2);
		    var col4=insertRow.insertCell(3);
		    var col5=insertRow.insertCell(4);
		    var col6=insertRow.insertCell(5);
		    var col7=insertRow.insertCell(6);
		    var col8=insertRow.insertCell(7);
		    var col9=insertRow.insertCell(8);
		    var amount=parseFloat(qty)*price;
		    
		    col1.innerHTML = "<input readonly=\"readonly\" size=\"32px\"  class=\"itemName\"    style=\"text-align: left; color:blue;  \"   name=\"listItemsDtlInBill["+(rowCount)+"].itemName\" id=\"itemName."+(rowCount)+"\" value='"+itemName+"' onclick=\"funGetSelectedRowIndex(this)\"/>";
		    col2.innerHTML = "<input readonly=\"readonly\" size=\"3.5px\"   class=\"itemQty\"      style=\"text-align: right; color:blue;  \"  name=\"listItemsDtlInBill["+(rowCount)+"].quantity\" id=\"quantity."+(rowCount)+"\" value='"+parseFloat(qty)+"' onclick=\"funChangeQty(this)\"/>";
		    col3.innerHTML = "<input readonly=\"readonly\" size=\"4px\"   class=\"itemAmt\"      style=\"text-align: right; color:blue;  \" class=\"longTextBox jQKeyboard form-control\" name=\"listItemsDtlInBill["+(rowCount)+"].amount\" id=\"amount."+(rowCount)+"\" value='"+amount+"'/>";
		    col4.innerHTML = "<input type=\"hidden\"  size=\"0px\" class=\"itemCode\"      name=\"listItemsDtlInBill["+(rowCount)+"].itemCode\" id=\"itemCode."+(rowCount)+"\" value='"+objMenuItemPricingDtl.strItemCode+"' />";
		    col5.innerHTML = "<input type=\"hidden\"  size=\"0px\"   class=\"itemDiscAmt\"   name=\"listItemsDtlInBill["+(rowCount)+"].strSerialNo\" id=\"strSerialNo."+(rowCount-1)+"\" value='"+rowCount+"' />";
		    col6.innerHTML = "<input type=\"hidden\"  size=\"0px\"   class=\"groupcode\"   name=\"listItemsDtlInBill["+(rowCount)+"].strGroupcode\" id=\"strGroupcode."+(rowCount-1)+"\" value='"+objMenuItemPricingDtl.strGroupcode+"' />";	    
		    col7.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"subgroupcode\"  name=\"listItemsDtlInBill["+(rowCount)+"].strSubGroupCode\" id=\"strSubGroupCode."+(rowCount)+"\" value='"+objMenuItemPricingDtl.strSubGroupCode+"' />";
		    col8.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"subGroupName\"  name=\"listItemsDtlInBill["+(rowCount)+"].strSubGroupName\" id=\"strSubGroupName."+(rowCount)+"\" value='"+objMenuItemPricingDtl.strSubGroupName+"' />";
		    col9.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"groupName\"  name=\"listItemsDtlInBill["+(rowCount)+"].strGroupName\" id=\"strGroupName."+(rowCount)+"\" value='"+objMenuItemPricingDtl.strGroupName+"' />";
		      
		}
		
		
		function funAddModifierTableBillItemDtl(objMenuItemPricingDtl,itemCode)
		{	
			funFillKOTList();
			deleteTableRows();
			var tblBillItemDtl=document.getElementById('tblBillItemDtl');
			var rowCount = tblBillItemDtl.rows.length;
			var insertRow = tblBillItemDtl.insertRow(rowCount);
			var code=itemCode+"!"+objMenuItemPricingDtl.strModifierCode;
		    var col1=insertRow.insertCell(0);
		    var col2=insertRow.insertCell(1);
		    var col3=insertRow.insertCell(2);
		    var col4=insertRow.insertCell(3);
		    var col5=insertRow.insertCell(4);
		    var col6=insertRow.insertCell(5);
		    var col7=insertRow.insertCell(6);
		    var col8=insertRow.insertCell(7);
		    var col9=insertRow.insertCell(8);
		    
		    col1.innerHTML = "<input readonly=\"readonly\" size=\"32px\"  class=\"itemName\"    style=\"text-align: left; color:blue;\"   name=\"listItemsDtlInBill["+(rowCount)+"].listModifierDtl["+(rowCount)+"].modifierDescription\" id=\"strItemName."+(rowCount)+"\" value='"+objMenuItemPricingDtl.strModifierName+"' />";
		    col2.innerHTML = "<input readonly=\"readonly\" size=\"3.5px\"   class=\"itemQty\"      style=\"text-align: right; color:blue;\"  name=\"listItemsDtlInBill["+(rowCount)+"].listModifierDtl["+(rowCount)+"].quantity\" id=\"dblQuantity."+(rowCount)+"\" value='"+objMenuItemPricingDtl.dblQty+"' />";
		    col3.innerHTML = "<input readonly=\"readonly\" size=\"4px\"   class=\"itemAmt\"      style=\"text-align: right; color:blue;\"  name=\"listItemsDtlInBill["+(rowCount)+"].listModifierDtl["+(rowCount)+"].amount\" id=\"dblAmount."+(rowCount)+"\" value='"+objMenuItemPricingDtl.dblRate+"' />";
		    col4.innerHTML = "<input type=\"hidden\" size=\"10px\" class=\"itemCode\"     style=\"text-align: left; color:blue;\"   name=\"listItemsDtlInBill["+(rowCount)+"].listModifierDtl["+(rowCount)+"].modifierCode\" id=\"strItemCode."+(rowCount)+"\" value='"+code+"' />";
		    col5.innerHTML = "<input type=\"hidden\" size=\"9px\"   class=\"itemDiscAmt\"  style=\"text-align: right; color:blue;\"  name=\"listItemsDtlInBill["+(rowCount)+"].listModifierDtl["+(rowCount)+"].strSerialNo\" id=\"strSerialNo."+(rowCount-1)+"\" value='"+rowCount+"' />";
		    col6.innerHTML = "<input type=\"hidden\"  size=\"0px\"   class=\"groupcode\"  style=\"text-align: right; color:blue;\"  name=\"listItemsDtlInBill["+(rowCount)+"].strGroupcode\" id=\"strGroupcode."+(rowCount-1)+"\" value='"+objMenuItemPricingDtl.strGroupcode+"' />";	    
		    col7.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"subGroupCode\"  name=\"listItemsDtlInBill["+(rowCount)+"].strSubGroupCode\" id=\"strSubGroupCode."+(rowCount-1)+"\" value='"+objMenuItemPricingDtl.strSubGroupCode+"' />";
		    col8.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"subGroupName\"  name=\"listItemsDtlInBill["+(rowCount)+"].strSubGroupName\" id=\"strSubGroupName."+(rowCount)+"\" value='"+objMenuItemPricingDtl.strSubGroupName+"' />";
		    col9.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"groupName\"  name=\"listItemsDtlInBill["+(rowCount)+"].strGroupName\" id=\"strGroupName."+(rowCount)+"\" value='"+objMenuItemPricingDtl.strGroupName+"' />";
		    
			for(var i=selectedRowIndex+1;i<kotListForModifier.length;i++)
			{
				var rowCount = tblBillItemDtl.rows.length;
				var insertRow = tblBillItemDtl.insertRow(rowCount);
				var data=kotListForModifier[i];
					
				var col1=insertRow.insertCell(0);
				var col2=insertRow.insertCell(1);
				var col3=insertRow.insertCell(2);
				var col4=insertRow.insertCell(3);
				var col5=insertRow.insertCell(4);
				var col6=insertRow.insertCell(5);
				var col7=insertRow.insertCell(6);
				var col8=insertRow.insertCell(7);
				var col9=insertRow.insertCell(8);
				    
				col1.innerHTML = "<input readonly=\"readonly\" size=\"32px\"  class=\"itemName\"    style=\"text-align: left; color:blue;background-color:lavenderblush;\"   name=\"listItemsDtlInBill["+(rowCount)+"].listModifierDtl["+(rowCount)+"].modifierDescription\" id=\"strItemName."+(rowCount)+"\" value='"+data[0]+"' onclick=\"funGetSelectedRowIndex(this)\"/>";
				col2.innerHTML = "<input readonly=\"readonly\" size=\"3.5px\"   class=\"itemQty\"      style=\"text-align: right; color:blue;background-color:lavenderblush;\"  name=\"listItemsDtlInBill["+(rowCount)+"].listModifierDtl["+(rowCount)+"].quantity\" id=\"dblQuantity."+(rowCount)+"\" value='"+data[1]+"' onclick=\"funChangeQty(this)\"/>";
				col3.innerHTML = "<input readonly=\"readonly\" size=\"4px\"   class=\"itemAmt\"      style=\"text-align: right; color:blue;background-color:lavenderblush;\"  name=\"listItemsDtlInBill["+(rowCount)+"].listModifierDtl["+(rowCount)+"].amount\" id=\"dblAmount."+(rowCount)+"\" value='"+data[2]+"' />";
				col4.innerHTML = "<input type=\"hidden\" size=\"10px\" class=\"itemCode\"     style=\"text-align: left; color:blue;background-color:lavenderblush;\"   name=\"listItemsDtlInBill["+(rowCount)+"].listModifierDtl["+(rowCount)+"].modifierCode\" id=\"strItemCode."+(rowCount)+"\" value='"+data[3]+"' />";
				col5.innerHTML = "<input type=\"hidden\" size=\"9px\"   class=\"itemDiscAmt\"  style=\"text-align: right; color:blue;background-color:lavenderblush;\"  name=\"listItemsDtlInBill["+(rowCount)+"].listModifierDtl["+(rowCount)+"].strSerialNo\" id=\"strSerialNo."+(rowCount-1)+"\" value='"+rowCount+"' />";
				col6.innerHTML = "<input type=\"hidden\"  size=\"0px\"   class=\"groupcode\"  style=\"text-align: right; color:blue;background-color:lavenderblush;\"  name=\"listItemsDtlInBill["+(rowCount)+"].strGroupcode\" id=\"strGroupcode."+(rowCount-1)+"\" value='"+data[5]+"' />";	    
				col7.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"subGroupCode\"  name=\"listItemsDtlInBill["+(rowCount)+"].strSubGroupCode\" id=\"strSubGroupCode."+(rowCount-1)+"\" value='"+data[6]+"' />";
				col8.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"subGroupName\"  name=\"listItemsDtlInBill["+(rowCount)+"].strSubGroupName\" id=\"strSubGroupName."+(rowCount)+"\" value='"+data[7]+"' />";
				col9.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"groupName\"  name=\"listItemsDtlInBill["+(rowCount)+"].strGroupName\" id=\"strGroupName."+(rowCount)+"\" value='"+data[8]+"' />";	    
			}
		}
		
		
		function funFillOldKOTItemDtl(objMenuItemPricingDtl)
		{		
			var tblBillItemDtl=document.getElementById('tblOldKOTItemDtl');
			
			var rowCount = tblBillItemDtl.rows.length;
			var insertRow = tblBillItemDtl.insertRow(rowCount);
			
		    var kotNo= $('#txtKOTNo').text();
			var PaxNo= $('#txtPaxNo').text();
			var tableNo = $('#txtTableNo').text();
			var WaiterNo = $('#txtWaiterNo').text();	
			
		    var col1=insertRow.insertCell(0);
		    var col2=insertRow.insertCell(1);
		    var col3=insertRow.insertCell(2);
		    var col4=insertRow.insertCell(3);
		    var col5=insertRow.insertCell(4);
		    var col6=insertRow.insertCell(5);
		    var col7=insertRow.insertCell(6);
		    var col8=insertRow.insertCell(7);
		    var col9=insertRow.insertCell(8);
		    var col10=insertRow.insertCell(9);
		    var col11=insertRow.insertCell(10);
		    var col12=insertRow.insertCell(11);
		    var col13=insertRow.insertCell(12);
		    
		    col1.innerHTML = "<input readonly=\"readonly\" size=\"32px\"   class=\"itemName\"   style=\"text-align: left;\"    id=\"strItemName."+(rowCount)+"\" value='"+objMenuItemPricingDtl.strItemName+"' />";
		    col2.innerHTML = "<input readonly=\"readonly\" size=\"3.5px\"   class=\"itemQty\"      style=\"text-align: right;\"   id=\"dblQuantity."+(rowCount)+"\" value='"+objMenuItemPricingDtl.dblItemQuantity+"'/>";
		    col3.innerHTML = "<input readonly=\"readonly\" size=\"4px\"   class=\"itemAmt\"      style=\"text-align: right;\"  id=\"dblAmount."+(rowCount)+"\" value='"+objMenuItemPricingDtl.dblAmount+"' />";
		    col4.innerHTML = "<input type=\"hidden\"  size=\"0px\" class=\"itemCode\"     style=\"text-align: left;\"  id=\"strItemCode."+(rowCount)+"\" value='"+objMenuItemPricingDtl.strItemCode+"' />";
		    col5.innerHTML = "<input type=\"hidden\"  size=\"0px\"   class=\"itemDiscAmt\"  style=\"text-align: right;\"  id=\"strSerialNo."+(rowCount)+"\" value='"+objMenuItemPricingDtl.strSerialNo+"'/>";
		    col6.innerHTML = "<input type=\"hidden\"  size=\"0px\"   class=\"groupcode\"  style=\"text-align: right; color:blue;\"  name=\"listItemsDtlInBill["+(rowCount)+"].strGroupcode\" id=\"strGroupcode."+(rowCount-1)+"\" value='"+objMenuItemPricingDtl.strGroupcode+"' />";	    
		    col7.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"subgroupcode\"  name=\"listItemsDtlInBill["+(rowCount)+"].strSubGroupCode\" id=\"strSubGroupCode."+(rowCount)+"\" value='"+objMenuItemPricingDtl.strSubGroupCode+"' />";
		    col8.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"subGroupName\"  name=\"listItemsDtlInBill["+(rowCount)+"].strSubGroupName\" id=\"strSubGroupName."+(rowCount)+"\" value='"+objMenuItemPricingDtl.strSubGroupName+"' />";
		    col9.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"groupName\"  name=\"listItemsDtlInBill["+(rowCount)+"].strGroupName\" id=\"strGroupName."+(rowCount)+"\" value='"+objMenuItemPricingDtl.strGroupName+"' />";
		    col10.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"tableNo\"  name=\"listItemsDtlInBill["+(rowCount)+"].tableNo\" id=\"tableNo."+(rowCount)+"\" value='"+tableNo+"' />";
		    col11.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"paxNo\"  name=\"listItemsDtlInBill["+(rowCount)+"].paxNo\" id=\"paxNo."+(rowCount)+"\" value='"+PaxNo+"' />";
		    col12.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"KOTNo\"  name=\"listItemsDtlInBill["+(rowCount)+"].KOTNo\" id=\"KOTNo."+(rowCount)+"\" value='"+kotNo+"' />";
		    col13.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"waiterNo\"  name=\"listItemsDtlInBill["+(rowCount)+"].waiterNo\" id=\"waiterNo."+(rowCount)+"\" value='"+WaiterNo+"' />";
		       
		}
		
		
		function funFillOldKOTTimeDtl(objMenuItemPricingDtl)
		{		
			var tblBillItemDtl=document.getElementById('tblOldKOTItemDtl');
			
			var rowCount = tblBillItemDtl.rows.length;
			var insertRow = tblBillItemDtl.insertRow(rowCount);
			var kotNo= $('#txtKOTNo').text();
			var PaxNo= $('#txtPaxNo').text();
			var tableNo = $('#txtTableNo').text();
			var WaiterNo = $('#txtWaiterNo').text();
		    var col1=insertRow.insertCell(0);
		    var col2=insertRow.insertCell(1);
		    var col3=insertRow.insertCell(2);
		    var col4=insertRow.insertCell(3);
		    var col5=insertRow.insertCell(4);
		    var col6=insertRow.insertCell(5);
		    var col7=insertRow.insertCell(6);
		    var col8=insertRow.insertCell(7);
		    var col9=insertRow.insertCell(8);
		    var col10=insertRow.insertCell(9);
		    var col11=insertRow.insertCell(10);
		    var col12=insertRow.insertCell(11);
		    var col13=insertRow.insertCell(12);
		    
		    col1.innerHTML = "<input readonly=\"readonly\" size=\"32px\"   class=\"itemName\"   style=\"text-align: left; \"    id=\"strItemName."+(rowCount)+"\" value='"+objMenuItemPricingDtl.kotNo+"           "+objMenuItemPricingDtl.kotTime+"' />";
		    col2.innerHTML = "<input readonly=\"readonly\" size=\"3.5px\"   class=\"itemQty\"      style=\"text-align: right;\"  id=\"dblQuantity."+(rowCount)+"\" value=' '/>";
		    col3.innerHTML = "<input readonly=\"readonly\" size=\"4px\"   class=\"itemAmt\"      style=\"text-align: right;\" id=\"dblAmount."+(rowCount)+"\" value='' />";
		    col4.innerHTML = "<input type=\"hidden\"  size=\"0px\" class=\"itemCode\"     style=\"text-align: left;\" id=\"strItemCode."+(rowCount)+"\" value='' />";
		    col5.innerHTML = "<input type=\"hidden\"  size=\"0px\"   class=\"itemDiscAmt\"  style=\"text-align: right;\"  id=\"strSerialNo."+(rowCount)+"\" value='' />";
		    col6.innerHTML = "<input type=\"hidden\"  size=\"0px\"   class=\"groupcode\"  style=\"text-align: right; color:blue;\"  name=\"listItemsDtlInBill["+(rowCount)+"].strGroupcode\" id=\"strGroupcode."+(rowCount-1)+"\" value='' />";	    
		    col7.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"subgroupcode\"  name=\"listItemsDtlInBill["+(rowCount)+"].strSubGroupCode\" id=\"strSubGroupCode."+(rowCount)+"\" value='' />";
		    col8.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"subGroupName\"  name=\"listItemsDtlInBill["+(rowCount)+"].strSubGroupName\" id=\"strSubGroupName."+(rowCount)+"\" value='' />";
		    col9.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"groupName\"  name=\"listItemsDtlInBill["+(rowCount)+"].strGroupName\" id=\"strGroupName."+(rowCount)+"\" value='' />";	    
		    col10.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"tableNo\"  name=\"listItemsDtlInBill["+(rowCount)+"].tableNo\" id=\"tableNo."+(rowCount)+"\" value='"+tableNo+"' />";
		    col11.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"paxNo\"  name=\"listItemsDtlInBill["+(rowCount)+"].paxNo\" id=\"paxNo."+(rowCount)+"\" value='' />";
		    col12.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"KOTNo\"  name=\"listItemsDtlInBill["+(rowCount)+"].KOTNo\" id=\"KOTNo."+(rowCount)+"\" value='' />";
		    col13.innerHTML = "<input type=\"hidden\" size=\"0px\"   class=\"waiterNo\"  name=\"listItemsDtlInBill["+(rowCount)+"].waiterNo\" id=\"waiterNo."+(rowCount)+"\" value='' />";
		      
		}
		
		
		
		function funFillOldKOTItems(tableNo)
		{		
			if(arrKOTItemDtlList.length==0)
				funRemoveTableRows("tblBillItemDtl");
			
			var searchurl=getContextPath()+"/funFillOldKOTItems.html?strTableNo="+tableNo;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.flag)
				        	{
				        			$.each(response.OldKOTTimeDtl, function(j, item) 
				        			{
				        				funFillOldKOTTimeDtl(item);
				        			
				        	 			$.each(response.OldKOTItems, function(i, obj) 
				        				{									
				        					if(item.kotNo==obj.strKOTNo)
				        						funFillOldKOTItemDtl(obj);
				        		
				        				});
				        			});
				        		$("#txtTotal").val(response.Total);
				        	
				        		funDisplayMakeBillButton(true);
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
		
		
		
		
		function funGenerateKOTNo()
		{
			var searchurl=getContextPath()+"/funGenerateKOTNo.html";
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        async:false,
				        success: function(response)
				        {	
				        	$("#txtKOTNo").text(response.strKOTNo);
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
		
		
		function funGetQuantity(dblQty){
			
			var qty=prompt("Enter Quantity",dblQty );
			if(qty!=null){
				if(!/^[0-9]+$/.test(qty)){
					qty=funGetQuantity(1);
				}else if(qty<1 ){
					qty=funGetQuantity(1);
				}
			}
			
			return qty;
		}
		
		function funOpenNumPadDialog(){
			document.getElementById("numpadValue").click();
		}

		function funCloseDialog(numpadValue){
			if(numpadValue=='' || numpadValue== null){
				return false;
			}else
			{
				numpadValue=parseFloat(numpadValue);
				if(numpadValue>0){
					if(NumPadDialogFor=='menuItem'){
						if(itemPrice==0){
							// easy_numpad_close();
							funOpenNumPadDialogForItemPrice(numpadValue);
						}else{
							funMenuItemClicked1(objMenuItemButton,objIndex,numpadValue,itemPrice);
						}
						
					}else if(NumPadDialogFor=='itemPrice'){
						funMenuItemClicked1(objMenuItemButton,objIndex,itemChangeQtySelected,numpadValue);
					}else if(NumPadDialogFor=='changeQty'){
						funChgQtyBtnClicked1(numpadValue);	
					}else if(NumPadDialogFor=='ChangeItemQty'){
						funChangeQty1(itemChangeQtySelected,numpadValue);	
					}else if(NumPadDialogFor=='modiferItem'){
						funFreeFlowModifierClicked1(objMenuItemButton,objIndex,itemCode,numpadValue);
					}else if(NumPadDialogFor=='pax'){
						funChangePAX1(objIndex,numpadValue);
					}
					else
					{}
				}else{
					return false;
				}	
			}
		}

		function funOpenNumPadDialogForItemPrice(numpadValue){
			itemChangeQtySelected=numpadValue; //store input value of quantity in variable 
			NumPadDialogFor='itemPrice';
			$("#numpadValue").val('Enter Item Price');
			funOpenNumPadDialog();
		}
		function funGetAmount(dblAmount){
			var amt=prompt("Enter Amount",dblAmount);
			if(amt!=null){
				if(!/^[0-9]+$/.test(amt)){
					amt=funGetAmount(0);
				}else if(amt<1 ){
					amt=funGetAmount(0);
				}	
			}
			
			return amt;
		}
		
		function funMenuItemClicked(objMenuItemButton1,objIndex1)
		{
			objMenuItemButton=objMenuItemButton1;
			objIndex=objIndex1;
			
			funFillMapWithHappyHourItems();
			itemPriceDtlList=${command.jsonArrForDirectBillerMenuItemPricing};
			var objMenuItemPricingDtl=itemPriceDtlList[objIndex];
			itemPrice = funGetFinalPrice(objMenuItemPricingDtl);
			
			if(openItemQtyNumpad){
				NumPadDialogFor='menuItem';
				$("#numpadValue").val('Enter Quantity');
				funOpenNumPadDialog();
			}else{
				if(itemPrice==0){
					itemChangeQtySelected=1; //default item quantity  
					NumPadDialogFor='itemPrice';
					$("#numpadValue").val("Enter Price");
					funOpenNumPadDialog();
						
				}else{
					funMenuItemClicked1(objMenuItemButton1,objIndex1,1,itemPrice);
				}
				
			}
			
			//funMenuItemClicked1(objMenuItemButton,objIndex);
		}
		
		function funMenuItemClicked1(objMenuItemButton,objIndex,numpadValue,itemPrice)
		{	
			$("#txtItemSearch").val("");
			
			funFillMapWithHappyHourItems();
		
			var objMenuItemPricingDtl=itemPriceDtlList[objIndex];
			
			var price = funGetFinalPrice(objMenuItemPricingDtl);
			
			var isOrdered=funIsAlreadyOrderedItem(objMenuItemPricingDtl);
			var qty=numpadValue;
			
			
			if(price==0.00)
			{
				 price = funGetFinalPrice(objMenuItemPricingDtl);
				
				 price = itemPrice; //prompt("Enter Price", 0);
			} 
			if(qty==null || price==null)
			{
				 	return false;
			}
			if(isOrdered)
			{
				funUpdateTableBillItemDtlFor(objMenuItemPricingDtl,price,qty);	
			}
			else			
			{
				var tblBillItemDtl=document.getElementById('tblBillItemDtl');
				var rowCount = tblBillItemDtl.rows.length;
				
				if(operationType=="DineIn")
				{
					if(rowCount==1)
					{
						funGenerateKOTNo();
						
						var tblOldKOTItemDtl=document.getElementById('tblOldKOTItemDtl');
						var oldKOTRowCount = tblOldKOTItemDtl.rows.length;
						
						if(oldKOTRowCount==0)
						{
							funDisplayNCKOTButton(true);						
						}
						funDisplayDoneButton(true);
						funDisplayMakeBillButton(false);
					}
					
					funFillTableBillItemDtl(objMenuItemPricingDtl,price,qty);	
				}
				else if(operationType=="HomeDelivery")
				{
					if(rowCount==1)
					{
						funDisplayDoneButton(true);
					}
					funFillTableBillItemDtl(objMenuItemPricingDtl,price,qty);
				}
				else if(operationType=="TakeAway")
				{
					if(rowCount==1)
					{
						funDisplayDoneButton(true);
					}
					funFillTableBillItemDtl(objMenuItemPricingDtl,price,qty);
				}
				
				
			} 
			
			funFillKOTList();
			funCalculateTax();
		}
		
		//disply/hide Done Button button
		function funDisplayDoneButton(hideORDisplay)
		{
			var doneButton=document.getElementById('Done');
			if(hideORDisplay)
			{		
				//doneButton.style.display="block";
			}
			else
			{
				//doneButton.style.display="none";
			}
				
		}
		
		//disply/hide PLU Button button
		function funDisplayPLUButton(hideORDisplay)
		{
			var pluButton=document.getElementById('PLU');
			if(hideORDisplay)
			{		
				//pluButton.style.display="block";
			}
			else
			{
				//pluButton.style.display="none";
			}			
		}
		
		//disply/hide Make Bill Button button
		function funDisplayMakeBillButton(hideORDisplay)
			{
				var makeBillButton=document.getElementById('Make Bill');
				if(hideORDisplay)
				{		
					////makeBillButton.style.display="block";
				}
				else
				{
		//			makeBillButton.style.display="none";
				}			
			}	
			
		
		//disply/hide NC KOT button
			function funDisplayNCKOTButton(hideORDisplay)
			{
				var ncKOTButton=document.getElementById('NC KOT');
				if(hideORDisplay)
				{		
					//ncKOTButton.style.display="block";
				}
				else
				{
				//	ncKOTButton.style.display="none";
				}
					
			}
		
		//function on popular item button click
		function funPopularItemButtonClicked(objButton)
		{
			var $rows = $('#tblMenuItemDtl').empty();
			var tblMenuItemDtl=document.getElementById('tblMenuItemDtl');
			var selctedCode=objButton.id;
			flagPopular="Popular";
			//funFillTopButtonList(flagPopular);
			var jsonArrForPopularItems=${command.jsonArrForPopularItems};	
			var rowCount = tblMenuItemDtl.rows.length;	
			itemPriceDtlList=new Array();
			var insertCol=0;
			var insertTR=tblMenuItemDtl.insertRow();
			var index=0;
			$.each(jsonArrForPopularItems, function(i, obj) 
			{									
													
					if(insertCol<tblMenuItemDtl_MAX_COL_SIZE)
					{
						index=rowCount*4+insertCol;
						var col=insertTR.insertCell(insertCol);
						
						col.innerHTML = "<td  ><input type=\"button\" id='"+obj.strItemCode+"' value='"+obj.strItemName+"'    style=\"width: 110px;height: 60px; white-space:normal;font-size: 11px; \"  onclick=\"funMenuItemClicked(this,"+index+")\" class=\"btn btn-primary \" /></td>";
						col.style.padding = "1px";
						
						insertCol++;
					}
					else
					{		
						rowCount++;
						insertTR=tblMenuItemDtl.insertRow();									
						insertCol=0;
						index=rowCount*4+insertCol;				
						var col=insertTR.insertCell(insertCol);
						
						col.innerHTML = "<td><input type=\"button\" id='"+obj.strItemCode+"' value='"+obj.strItemName+"'    style=\"width: 110px;height: 60px; white-space:normal;font-size: 11px; \"  onclick=\"funMenuItemClicked(this,"+index+")\" class=\"btn btn-primary \" /></td>";
						col.style.padding = "1px";
						
						insertCol++;
					}	
					itemPriceDtlList[index]=obj;
				
			});
		}
		
		//function on menu Head cliked
		
		function funMenuHeadButtonClicked(objMenuHeadButton)
		{
			var $rows = $('#tblMenuItemDtl').empty();
			
			
			var tblMenuItemDtl=document.getElementById('tblMenuItemDtl');
			var selctedMenuHeadCode=objMenuHeadButton.id;
			flagPopular="menuhead";
		//	funFillTopButtonList(selctedMenuHeadCode);
			var jsonArrForMenuItemPricing=${command.jsonArrForDirectBillerMenuItemPricing};	
			var rowCount = tblMenuItemDtl.rows.length;	
			itemPriceDtlList=new Array();
			var insertCol=0;
			var insertTR=tblMenuItemDtl.insertRow();
			var index=0;
			$.each(jsonArrForMenuItemPricing, function(i, obj) 
			{									
				if(obj.strMenuCode==selctedMenuHeadCode)
				{									
					if(insertCol<tblMenuItemDtl_MAX_COL_SIZE)
					{
						index=rowCount*tblMenuItemDtl_MAX_COL_SIZE+insertCol;
						var col=insertTR.insertCell(insertCol);
						var tmpprice=Math.round(obj.strPriceMonday);
						col.innerHTML = "<td><input type=\"button\" id='"+obj.strItemCode+"' value='"+obj.strItemName+"'  data-toggle=\"tooltip\" data-placement=\"top\" title='"+tmpprice+"'  style=\"width: 110px;height: 60px; white-space:normal;font-size: 11px; \"  onclick=\"funMenuItemClicked(this,"+index+")\" class=\"mdc-card info-card4 \" /></td>";
						 //readonly=\"readonly\"
						
						//col.innerHTML = "<td><div><input readonly=\"readonly\" id='"+obj.strItemCode+"' value='"+obj.strItemName+"'    style=\"width: 110px;height: 60px; white-space:normal;font-size: 11px; \"  onclick=\"funMenuItemClicked(this,"+index+")\" /><font style=\"color: #000000e0; font-size: 13px;\" class=\"dont-break-out\">"+tmpprice+"</font></div></td>";
						col.style.padding = "1px";
						insertCol++;
					}
					else
					{		
						rowCount++;
						insertTR=tblMenuItemDtl.insertRow();									
						insertCol=0;
						index=rowCount*tblMenuItemDtl_MAX_COL_SIZE+insertCol;
						var tmpprice=Math.round(obj.strPriceMonday);
						
						var col=insertTR.insertCell(insertCol);
						col.innerHTML = "<td><input type=\"button\" id='"+obj.strItemCode+"' value='"+obj.strItemName+"'  data-toggle=\"tooltip\" data-placement=\"top\" title='"+tmpprice+"'    style=\"width: 110px;height: 60px; white-space: normal;font-size: 11px;\"  onclick=\"funMenuItemClicked(this,"+index+")\" class=\"mdc-card info-card4\" /></td>";
						col.style.padding = "1px";
						insertCol++;
					}	
					itemPriceDtlList[index]=obj;
				}
			});
		}
		
		
		
		function funFillTopButtonList(menuHeadCode)
		{		
			menucode=menuHeadCode;
			var searchurl=getContextPath()+"/funFillTopButtonList.html?menuHeadCode="+menuHeadCode;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {	
				        	funAddTopButtonData(response.topButtonList);
				        	
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
		
		 function funAddTopButtonData(topButtonList)
		{
			var $rows = $('#tblTopButtonDtl').empty();
			var tblTopButtonDtl=document.getElementById('tblTopButtonDtl');
			var insertCol=0;
			var insertTR=tblTopButtonDtl.insertRow();
			
			$.each(topButtonList, function(i, obj) 
			{		
						var col=insertTR.insertCell(insertCol);
						col.style.padding = "1px";
						col.innerHTML = "<td><input type=\"button\" id="+obj.strCode+" value='"+obj.strName+"'    style=\"width: 90px;height: 30px; white-space: normal;\"  data-toggle=\"tooltip\" data-placement=\"top\"  title='"+obj.strName+"' onclick=\"funTopButtonClicked(this)\" class=\"btn  btn-info\" /></td>";
						/* col.style.paddingBottom = "5px"; */
						insertCol++; 
			});
		}
		 
		function funTopButtonClicked(objMenuHeadButton)
		{
			
			var $rows = $('#tblMenuItemDtl').empty();
			var tblMenuItemDtl=document.getElementById('tblMenuItemDtl');
			
			var selctedMenuHeadCode=objMenuHeadButton.id;
		
			itemPriceDtlList=new Array();
			var searchurl=getContextPath()+"/funFillitemsSubMenuWise.html";
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        data:{ strMenuCode:menucode,
				        	flag:flagPopular,
				        	selectedButtonCode:selctedMenuHeadCode,
						},
				        dataType: "json",
				        success: function(response)
				        {	
				        
				        var rowCount = tblMenuItemDtl.rows.length;	
						
						var insertCol=0;
						var insertTR=tblMenuItemDtl.insertRow();
						var index=0;
				    		$.each(response.SubMenuWiseItemList, function(i, obj) 
				    		{									
				    												
				    				if(insertCol<tblMenuItemDtl_MAX_COL_SIZE)
				    				{
				    					index=rowCount*4+insertCol;
				    					var col=insertTR.insertCell(insertCol);
				    					col.innerHTML = "<td  ><input type=\"button\" id='"+obj.strItemCode+"' value='"+obj.strItemName+"'    style=\"width: 110px;height: 60px; white-space:normal;font-size: 11px;\"  onclick=\"funMenuItemClicked(this,"+index+")\" class=\"btn btn-primary\"/></td>";
				    					col.style.padding = "1px";
				    					insertCol++;
				    				}
				    				else
				    				{		
				    					rowCount++;	 		
				    					insertTR=tblMenuItemDtl.insertRow();									
				    					insertCol=0;
				    					index=rowCount*4+insertCol;				
				    					var col=insertTR.insertCell(insertCol);
				    					col.innerHTML = "<td  ><input type=\"button\" id='"+obj.strItemCode+"' value='"+obj.strItemName+"'    style=\"width: 110px;height: 60px; white-space: normal;font-size: 11px;\"  onclick=\"funMenuItemClicked(this,"+index+")\" class=\"btn btn-primary\" /></td>";
				    					col.style.padding = "1px";
				    					insertCol++;
				    				}							
				    			
				    				itemPriceDtlList[index]=obj;
				    			  
				    		});
				        	
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
			
		
		/* function funAddPopularItemsData()
		{
			funFillTopButtonList("Popular");
			var jsonArrForPopularItems=${command.jsonArrForPopularItems};	
			itemPriceDtlList=new Array();
			
			$.each(jsonArrForPopularItems, function(i, obj) 
			{									
					itemPriceDtlList[i]=obj;
			});
		} */
		
		function deleteTableRows()
		{
			var table = document.getElementById("tblBillItemDtl");
			var rowCount = table.rows.length;
			while(rowCount>selectedRowIndex+1)
			{
				table.deleteRow(selectedRowIndex+1);
				rowCount--;
			}
		}
		var kotListForModifier = new Array();

		
		function funFillKOTList()
		{
			var i=0;
			
			kotListForModifier = new Array();
			arrKOTItemDtlList = new Array();
			$('#tblBillItemDtl tr').each(function() 
			{
				 var code=$(this).find("input[class='itemCode']").val();
				
				 var itemName=$(this).find("input[class='itemName']").val();
				 var itemQty=$(this).find("input[class='itemQty']").val();
				 var itemAmt=$(this).find("input[class='itemAmt']").val();
				 var itemCode=$(this).find("input[class='itemCode']").val();
				 var itemDiscAmt=$(this).find("input[class='itemDiscAmt']").val();
				 var itemGroup=$(this).find("input[class='groupcode']").val();
				 var itemsubGroup=$(this).find("input[class='subGroupCode']").val(); 
				 var itemsubGroupName=$(this).find("input[class='subGroupName']").val(); 
				 var itemGroupName=$(this).find("input[class='groupName']").val(); 
				 var itemDetail=code+"!"+itemName+"#"+itemAmt+"#"+itemQty+"#"+itemDiscAmt;
				 code=code+"_"+itemName+"_"+itemAmt+"_"+itemQty+"_"+itemDiscAmt;
				 
				var data=new Array();
				data[0]=itemName;  
				data[1]=itemQty;
				data[2]=itemAmt;
				data[3]=itemCode;
				data[4]=itemDiscAmt;
				data[5]=itemGroup;
				data[6]=itemsubGroup;
				data[7]=itemsubGroupName;
				data[8]=itemGroupName;
				kotListForModifier[i]=data; 
				    	
				if(i > 0)
			    {
					arrKOTItemDtlList[i-1]=code;
					arrDirectBilleritems[i-1]=code;
			    }
				i++;
			});
		} 
		
		
		
		function funCalculateTax()
		{		
				
				var searchurl=getContextPath()+"/funCalculateTax.html?arrKOTItemDtlList="+arrKOTItemDtlList;
				 $.ajax({
					        type: "POST",
					        url: searchurl,
					        dataType: "json",
					        success: function(response)
					        {	
					        	$("#txtTotal").val(response);
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
			
			function CalculateDateDiff(fromDate,toDate) {
				
				var frmDate= fromDate.split('-');
			    var fDate = new Date(frmDate[0],frmDate[1],frmDate[2]);
			    
			    var tDate= toDate.split('-');
			    var t1Date = new Date(tDate[0],tDate[1],tDate[2]);

		    	var dateDiff=t1Date-fDate;
		  		
		        	 return dateDiff;
		        
			}
			
		function  funGetFinalPrice( ob)
	    {
	        var Price = 0.00;
	        var fromTime = ob.tmeTimeFrom;
	        var toTime = ob.tmeTimeTo;
	        var fromAMPM = ob.strAMPMFrom;
	        var toAMPM = ob.strAMPMTo;
	        var hourlyPricing = ob.strHourlyPricing;
			var strItemCode=ob.strItemCode;
	        if (hmHappyHourItems.has(strItemCode))
	        {
	            var obHappyHourItem = hmHappyHourItems.get(ob.strItemCode);
	            fromTime = obHappyHourItem.tmeTimeFrom;
	            toTime = obHappyHourItem.tmeTimeTo;
	            fromAMPM = obHappyHourItem.strAMPMFrom;
	            toAMPM = obHappyHourItem.strAMPMTo;

	            var spFromTime = fromTime.split(":");
	            var spToTime = toTime.split(":");
	            var fromHour = parseInt(spFromTime[0]);
	            var fromMin = parseInt(spFromTime[1]);
	            if (fromAMPM=="PM")
	            {
	                fromHour += 12;
	            }
	            var toHour = parseInt(spToTime[0]);
	            var toMin = parseInt(spToTime[1]);
	            if (toAMPM=="PM")
	            {
	                toHour += 12;
	            }
				var spCurrTime = currentTime.split(" ");
	            var spCurrentTime = spCurrTime[0].split(":");

	            var currHour = parseInt(spCurrentTime[0]);
	            var currMin = parseInt(spCurrentTime[1]);
	            var currDate = currentDate;
	            currDate = currDate + " " + currHour + ":" + currMin + ":00";

	            //2014-09-09 23:35:00
	            var fromDate = currentDate;
	            var toDate = currentDate();
	            fromDate = fromDate + " " + fromHour + ":" + fromMin + ":00";
	            toDate = toDate + " " + toHour + ":" + toMin + ":00";

	            var diff1 = CalculateDateDiff(fromDate, currDate);
	            var diff2 = CalculateDateDiff(currDate, toDate);
	            if (diff1 > 0 && diff2 > 0)
	            {
	                switch (dayForPricing)
	                {
	                    case "strPriceMonday":
	                        Price = obHappyHourItem.strPriceMonday;
	                        break;

	                    case "strPriceTuesday":
	                        Price = obHappyHourItem.strPriceTuesday;
	                        break;

	                    case "strPriceWednesday":
	                        Price = obHappyHourItem.strPriceWednesday;
	                        break;

	                    case "strPriceThursday":
	                        Price = obHappyHourItem.strPriceThursday;
	                        break;

	                    case "strPriceFriday":
	                        Price = obHappyHourItem.strPriceFriday;
	                        break;

	                    case "strPriceSaturday":
	                        Price = obHappyHourItem.strPriceSaturday;
	                        break;

	                    case "strPriceSunday":
	                        Price = obHappyHourItem.strPriceSunday;
	                        break;
	                }
	            }
	            else
	            {
	                switch (dayForPricing)
	                {
	                    case "strPriceMonday":
	                        Price = ob.strPriceMonday;
	                        break;

	                    case "strPriceTuesday":
	                        Price = ob.strPriceTuesday;
	                        break;

	                    case "strPriceWednesday":
	                        Price = ob.strPriceWednesday;
	                        break;

	                    case "strPriceThursday":
	                        Price = ob.strPriceThursday;
	                        break;

	                    case "strPriceFriday":
	                        Price = ob.strPriceFriday;
	                        break;

	                    case "strPriceSaturday":
	                        Price = ob.strPriceSaturday;
	                        break;

	                    case "strPriceSunday":
	                        Price = ob.strPriceSunday;
	                        break;
	                }
	            }
	        }
	        else
	        {
	            switch (dayForPricing)
	            {
	                case "strPriceMonday":
	                    Price = ob.strPriceMonday;
	                    break;

	                case "strPriceTuesday":
	                    Price = ob.strPriceTuesday;
	                    break;

	                case "strPriceWednesday":
	                    Price = ob.strPriceWednesday;
	                    break;

	                case "strPriceThursday":
	                    Price = ob.strPriceThursday;
	                    break;

	                case "strPriceFriday":
	                    Price = ob.strPriceFriday;
	                    break;

	                case "strPriceSaturday":
	                    Price = ob.strPriceSaturday;
	                    break;

	                case "strPriceSunday":
	                    Price = ob.strPriceSunday;
	                    break;
	            }
	        }

	        return Price;
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
				{%>	
					alert("Data Save successfully\n\n"+message);
				<%}
			}%>

		});
		
		
		function funDeleteBtnClicked()
		{
			var table = document.getElementById("tblBillItemDtl");			
			var v=tblBillItemDtl.rows[selectedRowIndex].cells[0].children[0];
			//row.style.backgroundColor='#ffd966';
			if(v.style.backgroundColor == "lavenderblush")
			{
				table.deleteRow(selectedRowIndex);
				var rowCount = table.rows.length;
				
				for(i=selectedRowIndex;i<rowCount;i++)
				{
					if(tblBillItemDtl.rows[i].cells[0].children[0].value.startsWith("-->"))
					{
						table.deleteRow(i);
						
						rowCount = table.rows.length;
					}
					else
					{
						break;
					}
				}
				document.getElementById("txtTotal").value="";
				funFillKOTList();
			}
			else
			{
				alert("Please select item.");	
			}
			
			selectedRowIndex=-1;
		}
		function funChgQtyBtnClicked()
		{
			if(selectedRowIndex>0)
			{
				 if(openItemQtyNumpad){
					 NumPadDialogFor='changeQty';
					 $("#numpadValue").val('Enter Quantity');
					 funOpenNumPadDialog();	 
				 }else{
					 funChgQtyBtnClicked1(1);
				 }
				
				
			}else{
				alert("Please Select Item ");
			}
			  
		}
		
		function funChgQtyBtnClicked1(numpadValue){
			var table = document.getElementById("tblBillItemDtl");
			var rowCount = table.rows.length;
			var iteCode=table.rows[selectedRowIndex].cells[1].innerHTML;
		  
		 	var codeArr = iteCode.split('value=');
		    var code=codeArr[1].split('onclick=');
		    var oldQty=code[0].substring(1, (code[0].length-2));
		    var rate=(tblBillItemDtl.rows[selectedRowIndex].cells[2].children[0].value)/(tblBillItemDtl.rows[selectedRowIndex].cells[1].children[0].value);
		    var qty=numpadValue; 
		   
		    //parseFloat(prompt("Enter Quantity", oldQty));
		  //$("#dblQuantity."+selectedRowIndex).val(qty);
//			    table.rows[selectedRowIndex].cells[1].innerHTML = "<input readonly=\"readonly\" size=\"3.5px\"   class=\"itemQty\"      style=\"text-align: right; color:blue;\"  name=\"listOfMakeKOTBillItemDtl["+(selectedRowIndex)+"].dblQuantity\" id=\"dblQuantity."+(selectedRowIndex)+"\" value='"+qty+"' onclick=\"funChangeQty(this)\"/>";
		  if(qty!=null && qty!=NaN && parseInt(qty)>0)
		  {
		    document.getElementById("quantity."+(selectedRowIndex)).value=qty;
		  
			  var itemAmt=qty*rate;
			  document.getElementById("amount."+(selectedRowIndex)).value=itemAmt;
			  funFillKOTList();
			  funCalculateTax();
		  }
		  else
			  return false;
		}

		function funGetSelectedRowIndex(obj)
		{
			 var index = obj.parentNode.parentNode.rowIndex;
			 var table = document.getElementById("tblBillItemDtl");
			 if((selectedRowIndex>0) && (index!=selectedRowIndex))
			 {
				
					 row = table.rows[selectedRowIndex];
					 row.style.backgroundColor='#C0E4FF';
					 selectedRowIndex=index;
					 row = table.rows[selectedRowIndex];
					 row.style.backgroundColor='#fd4de6';
					// row.childNodes[0].childNodes[0].style.color='#fd4de6';
					 row.hilite = true;
		         
				
			 }
			 else
			 {
				 selectedRowIndex=index;
				 row = table.rows[selectedRowIndex];
				 row.style.backgroundColor='#fd4de6';
				// row.childNodes[0].childNodes[0].style.color='#fd4de6';
				 row.hilite = true;
			 }
			 
			  var iteCode=table.rows[selectedRowIndex].cells[3].innerHTML;
			  
			  var codeArr = iteCode.split('value=');
			  var code=codeArr[1].split('onclick=');
			  var itemCode=code[0].substring(1, (code[0].length-2));
				funFillTopModifierButtonList(itemCode);
				funLoadModifiers(itemCode);
		}
		
		function funChangePAX(obj)
		{
			NumPadDialogFor="pax";
			objIndex=obj;
			$("#numpadValue").val('Enter PAX');
			funOpenNumPadDialog();
		}
		
		function funChangePAX1(obj,numpadValue)
		{
			//var text=$("#txtPaxNo").text();;
			
			 var paxNo=numpadValue;
			 if(paxNo!=null)
			 {
				  
				  if(!/^[0-9]+$/.test(paxNo)){
					  funChangePAX(obj);
					  
				  }else if(paxNo>100 || paxNo == 0)
				  {
					  
					  funChangePAX(obj);
					  /* var nextPaxNo=paxNo;
					  if(nextPaxNo==null)
						  return false;
					  else
					  {
						  obj.text=nextPaxNo;
						  $("#txtPaxNo").text(nextPaxNo);
					  }
					   */
				  }
				  else{
					  obj.text=paxNo;
					  $("#txtPaxNo").text(paxNo);  
				  }
				  
			 }
			/*  else
			 {			 
				  var paxNo=numpadValue;
				  if(paxNo!=null)
				  {
					  if(paxNo == 0)
					  {
						  var secondPaxNo = prompt("Enter PAX more than zero");
					  }
					  obj.text=secondPaxNo;
					  $("#txtPaxNo").text(secondPaxNo);
				  } 
				  else
					  $("#txtPaxNo").text(1);
			 } */
			 /* obj.text=paxNo;
			 $("#txtPaxNo").text(paxNo); */
		}
		
		function funChangeQty(obj)
		{
			if(openItemQtyNumpad){
				itemChangeQtySelected=obj;
				NumPadDialogFor='ChangeItemQty';
				$("#numpadValue").val('Enter Quantity');
				funOpenNumPadDialog();
			}else{
				funChangeQty1(obj,1);
			}
			
			
		}

		function funChangeQty1(obj,numpadValue){
			
			 var index = obj.parentNode.parentNode.rowIndex;
			 var table = document.getElementById("tblBillItemDtl");
			 if((selectedRowIndex >0 ) && (index!=selectedRowIndex))
			 {
					 row = table.rows[selectedRowIndex];
					 row.style.backgroundColor='#C0E4FF';
					 selectedRowIndex=index;
					 row = table.rows[selectedRowIndex];
					 row.style.backgroundColor='#ffd966';
					 row.hilite = true;
			 }
			 else
			 {
				 selectedRowIndex=index;
				 row = table.rows[selectedRowIndex];
				 row.style.backgroundColor='#ffd966';
				 row.hilite = true;
			 }
			 
			  var iteCode=table.rows[selectedRowIndex].cells[3].innerHTML;
			  var rate=(tblBillItemDtl.rows[selectedRowIndex].cells[2].children[0].value)/(tblBillItemDtl.rows[selectedRowIndex].cells[1].children[0].value);
			  var codeArr = iteCode.split('value=');
			  var code=codeArr[1].split('onclick=');
			  var itemCode=code[0].substring(1, (code[0].length-2));
			  
			  var qty=numpadValue;//funGetQuantity(obj.value);  //prompt("Enter Quantity", obj.value);
			  if(qty!=null)
			  {
				  obj.value=qty;
				  var itemAmt=qty*rate;
				  document.getElementById("amount."+(selectedRowIndex)).value=itemAmt;
				  funFillKOTList();
				  funCalculateTax();
			  }
			  else
			  {
				  return false;
			  }
			
		}
		
		
		function funLoadModifiers(itemCode)
		{		
			var searchurl=getContextPath()+"/funLoadModifiers.html?itemCode="+itemCode;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {	
				        	funAddModifiersData(response.Modifiers,itemCode);
				        
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
		
		function funAddModifiersData(Modifiers,itemCode)
		{
			var $rows = $('#tblMenuItemDtl').empty();
			var tblMenuItemDtl=document.getElementById('tblMenuItemDtl');
			var rowCount = tblMenuItemDtl.rows.length;	
			
			var insertCol=0;
			var insertTR=tblMenuItemDtl.insertRow();
			var colmn=insertTR.insertCell(insertCol);
			
				colmn.innerHTML = "<td ><input type=\"button\" id=\"M99\" value='Free Flow Modofier' style=\"width: 100px;height: 100px; white-space:normal;\"  onclick=\"funFreeFlowModifierClicked(this,"+index+",'"+itemCode+"')\" class=\"btn btn-primary\" /></td>";
				insertCol++;
			var index=0;
			var item=itemCode;
			itemPriceDtlList=new Array();
			$.each(Modifiers, function(i, obj) 
			{					
				var name=obj.strModifierName.split(">");
					if(insertCol<tblMenuItemDtl_MAX_COL_SIZE)
					{
						index=rowCount*4+insertCol;
						var col=insertTR.insertCell(insertCol);
						
					//	col.innerHTML = "<td><input type=\"button\" id="+obj.strModifierCode+" value="+obj.strModifierName+"    style=\"width: 100px;height: 100px; white-space:normal;\"  onclick=\"funMenuItemClicked(this,"+index+")\" /></td>";
						col.innerHTML = "<td  ><input type=\"button\" id="+obj.strModifierCode+" value='-->"+name[1]+"' style=\"width: 100px;height: 50px; white-space:normal;font-size: 11px;\"  onclick=\"funModifierClicked(this,"+index+",'"+itemCode+"')\" class=\"btn btn-primary\"/></td>";
						
						
						insertCol++;
					}
					else
					{		rowCount++;	 		
						insertTR=tblMenuItemDtl.insertRow();									
						insertCol=0;
						index=rowCount*4+insertCol;				
						var col=insertTR.insertCell(insertCol);
						//col.innerHTML = "<td><input type=\"button\" id="+obj.strModifierCode+" value="+obj.strModifierName+"    style=\"width: 100px;height: 100px; white-space: normal;\"  onclick=\"funMenuItemClicked(this,"+index+")\" /></td>";
						
						col.innerHTML = "<td  ><input type=\"button\" id="+obj.strModifierCode+" value='-->"+name[1]+"'    style=\"width: 100px;height: 50px; white-space: normal;font-size: 11px;\"  onclick=\"funModifierClicked(this,"+index+",'"+itemCode+"')\" class=\"btn btn-primary\"/></td>";
						
						insertCol++;
					}							
					itemPriceDtlList[index]=obj;
			});
		}
		function funModifierClicked(objMenuItemButton,objIndex,itemCode)
		{							

			var objMenuItemPricingDtl=itemPriceDtlList[objIndex];
			
		
				funAddModifierTableBillItemDtl(objMenuItemPricingDtl,itemCode);	
			
			funFillKOTList();
			funCalculateTax();
		}
		
		function funFreeFlowModifierClicked(objMenuItemButton1,objIndex1,itemCode)
		{
			if(openItemQtyNumpad){
				objMenuItemButton=objMenuItemButton1;
				objIndex=objIndex1;
				itemCode=itemCode1;
				NumPadDialogFor='modiferItem';
				$("#numpadValue").val('Enter Quantity');
				funOpenNumPadDialog();
			}
			else{
				funFreeFlowModifierClicked1(objMenuItemButton,objIndex,itemCode,1);
			}
			
		}
		
		function funFreeFlowModifierClicked1(objMenuItemButton,objIndex,itemCode,numPadValue)
		{
			var itmName=prompt("Enter Modifier Name", "");
			if(itmName.trim().length>0)
				{
					itmName="-->"+itmName;
					var qty=numPadValue;
					var amt=funGetAmount(0);
					if(amt!=null){
						amt=parseFloat(amt);
					}else{
						false;
					}
					var jObj={
							strModifierName:itmName,
							dblQty:qty,
							dblRate:amt,
							strModifierCode:"M99",
							};
					funAddModifierTableBillItemDtl(jObj,itemCode);
					funFillKOTList();
					funCalculateTax();
				}
		}
		
		function funFillTopModifierButtonList(itemCode)
		{		
			
			var searchurl=getContextPath()+"/funFillTopModifierButtonList.html?itemCode="+itemCode;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {	
				        	funAddTopModifierButtonData(response.topButtonModifier);
				        	
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
		
		function funAddTopModifierButtonData(topButtonList)
		{
			var $rows = $('#tblTopButtonDtl').empty();
			var tblTopButtonDtl=document.getElementById('tblTopButtonDtl');
			var insertCol=0;
			var insertTR=tblTopButtonDtl.insertRow();
			
			$.each(topButtonList, function(i, obj) 
			{		
						var col=insertTR.insertCell(insertCol);
						col.style.padding = "1px";
						col.innerHTML = "<td><input type=\"button\" id="+obj.strModifierGroupCode+" value="+obj.strModifierGroupShortName+"    style=\"width: 90px;height: 30px; white-space: normal;\"  onclick=\"funTopButtonClicked(this)\" class=\"btn  btn-info\" /></td>";
						
						insertCol++; 
			});
		}
				
		function funMoveSelectedRow(objThisBtn)
		{		
			
			
			var tblBillItemDtl=document.getElementById('tblBillItemDtl');
			var rowCount = tblBillItemDtl.rows.length;
			var value=objThisBtn.value;
			
			for(i=0;i<rowCount;i++)
			{
				var v=tblBillItemDtl.rows[i].cells[0].children[0];
				
				v.style.border="";
			}
			
			if(operationType=="DineIn")
			{
				
				if(value=="Up")
				{
					selectedRowIndex=selectedRowIndex-1;
				}
				else//Down
				{
					selectedRowIndex=selectedRowIndex+1;
				}
				
				if(selectedRowIndex < 2 || selectedRowIndex >= rowCount)
				{
					selectedRowIndex=2;
				}
				
				
				var row = tblBillItemDtl.rows[selectedRowIndex];
				
				var v=tblBillItemDtl.rows[selectedRowIndex].cells[0].children[0];
				
				v.style.border="2px solid green"; 
								
			}
			else//Home Delivery,Take Away
			{
				if(selectedRowIndex < 1)
				{
					selectedRowIndex=1;
				}
				if(selectedRowIndex > rowCount)
				{
					selectedRowIndex = rowCount-1 ;
				}
				
				
				if(rowCount > 1 )
				{
					selectedRowIndex
				}
			}
		}
		
		function funOnCloseBtnClick()
		{
			/* document.getElementById("divTopButtonDtl").style.display='block';
			document.getElementById("divItemDtl").style.display='block';
			document.getElementById("divPLU").style.display='none'; */
		}
		
		
		
		
		
		//Footer btn click
		
			function funFooterButtonClicked(objFooterButton)
			{
				switch(objFooterButton.id)
				{
					case "Dine In":
						funDineInButtonClicked();
						break;
					
					case "FIRE_KOT":
			 			funValidateForDoneButton();
						break;
						
					case "Done":
			 			funValidateForDoneButton();
						break;
						
					case "Home Delivery":
						funHomeDeliveryBtnClicked();
						break;
						
					case "Customer":
						funCustomerBtnClicked();
						break;
						
					case "Delivery Boy":
						funHelp1('POSDeliveryBoyMaster');
						break;
						
					case "Take Away":
						funTakeAwayBtnClicked();
						break;
						
					case "Home":
						funHomeBtnclicked();
						break;
						
					case "Customer History" :
						funCustomerHistoryBtnClicked();	
						break;
						
					case "PLU" :
						funPLUItemData();
						break;
						
					case "NC KOT":
						funNCKOTClicked();
						break;
						
					case "Make Bill":
						funMakeBillClicked();
						break;
						
				    case "Waiter":
					   funWaiterHelp('POSWaiterMaster');
					   break;
					
				}
			}

		function funFillGridData(itemName)
		{
			if(itemName==''){
				itemName=$("#txtItemSearch").val();
			}
			if(operationType=="DineIn"){
				if($("#txtTableNo").text()!='' && $("#txtWaiterName").text()!='' && $("#txtPaxNo").text()!=''){
					funFillGridData1(itemName);
				}
			}else{
				funFillGridData1(itemName);
			}
		}
	function funFillGridData1(itemName)
	{
		
		var $rows = $('#tblMenuItemDtl').empty();
		var tblMenuItemDtl=document.getElementById('tblMenuItemDtl');
		flagPopular="menuhead";
		var jsonArrForMenuItemPricing=${command.jsonArrForDirectBillerMenuItemPricing};	
		var rowCount = tblMenuItemDtl.rows.length;	
		itemPriceDtlList=new Array();
		var insertCol=0;
		var insertTR=tblMenuItemDtl.insertRow();
		var index=0;
		$.each(jsonArrForMenuItemPricing, function(i, obj) 
		{		
			if(obj.strItemName.toLowerCase().includes(itemName.toLowerCase())){
				
				if(insertCol<tblMenuItemDtl_MAX_COL_SIZE)
				{
					index=rowCount*tblMenuItemDtl_MAX_COL_SIZE+insertCol;
					var col=insertTR.insertCell(insertCol);
					var tmpprice=Math.round(obj.strPriceMonday);
					col.innerHTML = "<td><input type=\"button\" id='"+obj.strItemCode+"' value='"+obj.strItemName+"'  data-toggle=\"tooltip\" data-placement=\"top\" title='"+tmpprice+"'  style=\"width: 110px;height: 60px; white-space:normal;font-size: 11px; \"  onclick=\"funMenuItemClicked(this,"+index+")\" class=\"btn btn-primary \" /></td>";
					col.style.padding = "1px";
					insertCol++;
				}
				else
				{		
					rowCount++;
					insertTR=tblMenuItemDtl.insertRow();									
					insertCol=0;
					index=rowCount*tblMenuItemDtl_MAX_COL_SIZE+insertCol;
					var tmpprice=Math.round(obj.strPriceMonday);
					
					var col=insertTR.insertCell(insertCol);
					col.innerHTML = "<td><input type=\"button\" id='"+obj.strItemCode+"' value='"+obj.strItemName+"'  data-toggle=\"tooltip\" data-placement=\"top\" title='"+tmpprice+"'    style=\"width: 110px;height: 60px; white-space: normal;font-size: 11px;\"  onclick=\"funMenuItemClicked(this,"+index+")\" class=\"btn btn-primary\" /></td>";
					col.style.padding = "1px";
					insertCol++;
				}	
				itemPriceDtlList[index]=obj;
			}			
		});	
	}
	
	function funFillGridData2(itemName)
	{
		
		var $rows = $('#tblMenuHeadDtl').empty();
		var tblMenuItemDtl=document.getElementById('tblMenuHeadDtl');
		flagPopular="menuhead";
		var jsonArrForMenuItemPricing=${command.jsonArrForDirectBillerMenuHeads};	
		var rowCount = tblMenuItemDtl.rows.length;	
		itemPriceDtlList=new Array();
		var insertCol=0;
		var insertTR=tblMenuItemDtl.insertRow();
		var index=0;
		$.each(jsonArrForMenuItemPricing, function(i, obj) 
		{		
			if(obj.strMenuName.toLowerCase().includes(itemName.toLowerCase())){
				
				if(insertCol<tblMenuItemDtl_MAX_COL_SIZE)
				{
					index=rowCount*tblMenuItemDtl_MAX_COL_SIZE+insertCol;
					var col=insertTR.insertCell(insertCol);
					var tmpprice=Math.round(obj.strPriceMonday);
					col.innerHTML = "<td><input type=\"button\" id='"+obj.strMenuCode+"' value='"+obj.strMenuName+"'  data-toggle=\"tooltip\" data-placement=\"top\" title='"+tmpprice+"'  style=\"width: 110px;height: 60px; white-space:normal;font-size: 11px; \"  onclick=\"funMenuItemClicked(this,"+index+")\" class=\"mdc-card info-card4 \" /></td>";
					col.style.padding = "1px";
					insertCol++;
				}
				else
				{		
					rowCount++;
					insertTR=tblMenuItemDtl.insertRow();									
					insertCol=0;
					index=rowCount*tblMenuItemDtl_MAX_COL_SIZE+insertCol;
					var tmpprice=Math.round(obj.strPriceMonday);
					
					var col=insertTR.insertCell(insertCol);
					col.innerHTML = "<td><input type=\"button\" id='"+obj.strMenuCode+"' value='"+obj.strMenuName+"'  data-toggle=\"tooltip\" data-placement=\"top\" title='"+tmpprice+"'    style=\"width: 110px;height: 60px; white-space: normal;font-size: 11px;\"  onclick=\"funMenuItemClicked(this,"+index+")\" class=\"mdc-card info-card4\" /></td>";
					col.style.padding = "1px";
					insertCol++;
				}	
				itemPriceDtlList[index]=obj;
			}
		});	
	}	
	
	function funFillGridData3(itemName)
	{		
		var jsonArrForMenuItemPricing=${command.jsonArrForDirectBillerMenuHeads};
		var $rows = $('#tblMenuHeadDtl').empty();
		var tblMenuItemDtl=document.getElementById('tblMenuHeadDtl');
		flagPopular="menuhead";
			
		var rowCount = tblMenuItemDtl.rows.length;	
		itemPriceDtlList=new Array();
		var insertCol=0;
		var insertTR=tblMenuItemDtl.insertRow();
		var index=0;
		$.each(jsonArrForMenuItemPricing, function(i, obj) 
		{		
			if(obj.strMenuName.toLowerCase().includes(itemName.toLowerCase())){
				
				if(insertCol<tblMenuItemDtl_MAX_COL_SIZE)
				{
					index=rowCount*tblMenuItemDtl_MAX_COL_SIZE+insertCol;
					var col=insertTR.insertCell(insertCol);
					var tmpprice=Math.round(obj.strPriceMonday);
					col.innerHTML = "<td><input type=\"button\" id='"+obj.strMenuCode+"' value='"+obj.strMenuName+"'  data-toggle=\"tooltip\" data-placement=\"top\" title='"+tmpprice+"'  style=\"width: 110px;height: 60px; white-space:normal;font-size: 11px; \"  onclick=\"funMenuItemClicked(this,"+index+")\" class=\"mdc-card info-card4 \" /></td>";
					col.style.padding = "1px";
					insertCol++;
				}
				else
				{		
					rowCount++;
					insertTR=tblMenuItemDtl.insertRow();									
					insertCol=0;
					index=rowCount*tblMenuItemDtl_MAX_COL_SIZE+insertCol;
					var tmpprice=Math.round(obj.strPriceMonday);
					
					var col=insertTR.insertCell(insertCol);
					col.innerHTML = "<td><input type=\"button\" id='"+obj.strMenuCode+"' value='"+obj.strMenuName+"'  data-toggle=\"tooltip\" data-placement=\"top\" title='"+tmpprice+"'    style=\"width: 110px;height: 60px; white-space: normal;font-size: 11px;\"  onclick=\"funMenuItemClicked(this,"+index+")\" class=\"mdc-card info-card4\" /></td>";
					col.style.padding = "1px";
					insertCol++;
				}	
				itemPriceDtlList[index]=obj;
			}
		});	
	}
	

	function funPOSHome()
   	{
    	var posCode='<%=session.getAttribute("loginPOS").toString()%>';
    	window.location.href=getContextPath()+"/frmGetPOSSelection.html?strPosCode="+posCode;
   	}
	

	function funWaiterHelp(transactionName)
	{
		fieldName=transactionName;
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	function funTableHelp(transactionName)
	{
		fieldName=transactionName;
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	
	function funloadClientPhoto()
	{
		var code = $("#cmbPosCode").val();			
		var searchUrl1=getContextPath()+"/loadPropertyImage.html?";
		 $.ajax({
		        type: "GET",
		        url: searchUrl1,
		        cache: false
		 });
		$("#memImage").attr('src', searchUrl1);
	} 
		
	
	function funSetData(code){

		switch(fieldName){

			case 'POSWaiterMaster' : 
				funSetWaiterNo(code);
				break;
		}
	}


	function funSetWaiterNo(code){

		$("#txtWaiterNo").val(code);
		var searchurl=getContextPath()+"/loadPOSWaiterMasterData.html?POSWaiterCode="+code;		
		 $.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strWaiterNo=='Invalid Code')
		        	{
		        		confirmDialog("Invalid Group Code");
		        		$("#txtWaiterNo").val('');
		        	}
		        	else
		        	{
			        	
			        	$("#txtWShortName").val(response.strWShortName);
			        	$("#txtWFullName").val(response.strWFullName);
			        	$("#txtDebitCardString").val(response.strWaiterName);
			        	$("#txtWShortName").focus();
			        	if(response.strOperational=='Y')
		        		{
			        		$("#chkOperational").prop('checked',true);
		        		}
			        	
			        	$("#txtDebitCardString").val(response.strDebitCardString);
			        	$("#txtPOSCode").val(response.strPOSCode);
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
</script>
  
</head>
<body>
<script src="../assets/js/preloader.js"></script>
<div class="body-wrapper">
   <div class="main-wrapper mdc-drawer-app-content">
      <!-- partial:partials/_navbar.html -->
    <header class="mdc-top-app-bar">
        <div class="mdc-top-app-bar__row">
          <div class="mdc-top-app-bar__section mdc-top-app-bar__section--align-start">
            <button class="material-icons mdc-top-app-bar__navigation-icon mdc-icon-button sidebar-toggler">menu</button>
            <span class="mdc-top-app-bar__title"><img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/sanguinelogo.jpg" style="height: 46px;width: 135px;"></span>
          </div>
          <div class="mdc-top-app-bar__section mdc-top-app-bar__section--align-start">
              <button class="mdc-button mdc-menu-button" style="margin-right: 59px;">
                <span class="d-flex align-items-center">
                  <span class="clent-name">${gCompanyName}</span>
                </span>
              </button>             
            <span class="mdc-top-app-bar__title"><img src="" id="memImage" Style="width: 184px;height:54px;margin-top: 8px;"></span>
          </div>
          
          <div class="menu-button-container menu-profile d-none d-md-block">
              <!-- <label id="customerName">Cust Name</label> -->
              <input readonly="readonly" id="customerName"></input>
              <input readonly="readonly" id="custMobileNo"></input>
              <input type="hidden" id="customerCode"></input>
              
          </div>
          
          <div class="mdc-top-app-bar__section mdc-top-app-bar__section--align-end mdc-top-app-bar__section-right">
            <div class="menu-button-container menu-profile d-none d-md-block">
              <button class="mdc-button mdc-menu-button">
                <span class="d-flex align-items-center">
                 <%--  <span class="user-name">Sumit1</span> --%>
                 <label style="margin-top:18px;color:rgba(31 35 38);text-transform: uppercase;font-size: 16px;">${gUserName}<!-- &nbsp;&nbsp; --></label>
                </span>
              </button>
            </div>
        
              <div class="menu-button-container menu-profile d-none d-md-block">
                <button class="mdc-button mdc-menu-button">
                  <span class="d-flex align-items-center">
                 <%--  <span class="date">12-02-2020</span> --%>
                  <label id="lblPOSDate" style="margin-top:18px;color:rgba(83,159,225,1);font-family: trebuchet ms, Helvetica, sans-serif;font-weight: 100;font-size: 16px;"> &nbsp;&nbsp;</label>
                  </span>
                </button>
              </div>
              <div class="divider d-none d-md-block"></div>
              <div class="menu-button-container">
			           <button class="mdc-button mdc-menu-button" onclick="funPOSHome()">
                    <i class="mdi mdi-home"></i>                    
                 </button>
              </div>
          </div>
        </div>
    </header>
      <!-- partial -->
    <div class="page-wrapper mdc-toolbar-fixed-adjust">
      <main class="content-wrapper">
		    <table width="100%" border="0">
			   <tr width="100%">
              <td width="18%" style="vertical-align: top;padding-top: 5px;">
                
                
                <table width="100%" class="mdc-card info-card3">
                  <tr>   
                    <td align="center" class="img" id="Dine In" onclick="funFooterButtonClicked(this)">
                       <img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/icon-dinein.png" border="0"> 
                       <h5 class="tablehead" nowrap>Dine in</h5> 
                    </td>   
                    <td align="center" class="img" id="Home Delivery" onclick="funFooterButtonClicked(this)">
                       <img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/icon-homedelivery.png" border="0"> 
                       <h5 class="tablehead" nowrap>Home</h5>
                    </td>
                    <td align="center" class="img" id="Take Away" onclick="funFooterButtonClicked(this)">
                       <img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/icons8.png" border="0"> 
                       <h5 class="tablehead" nowrap>Take Away</h5> 
                    </td>             
                    </tr>
                  </table>
                
                
                <table width="100%">
                  <tr>  
                    <td width="70%">
                       <div class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon search-text-field d-none d-md-flex" style="background: #fff;">
                         <input class="mdc-text-field__input" id="text-field-hero-input">
                          <div class="mdc-notched-outline">
                           <div class="mdc-notched-outline__leading"></div>
                            <div class="mdc-notched-outline__notch">
                              <label for="text-field-hero-input" class="mdc-floating-label"  ondblclick="funTableHelp('POSTableMaster')">Search Tables</label>
                            </div>
                            <div class="mdc-notched-outline__trailing"></div>
                          </div>
                        </div>
                      </td> 
                      <td width="30%">
                       <div class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon search-text-field d-none d-md-flex" style="background: #fff;">
                         <input class="mdc-text-field__input" id="text-field-hero-input">
                          <div class="mdc-notched-outline">
                           <div class="mdc-notched-outline__leading"></div>
                            <div class="mdc-notched-outline__notch">
                              <label for="text-field-hero-input" class="mdc-floating-label">Pax</label>
                            </div>
                            <div class="mdc-notched-outline__trailing"></div>
                          </div>
                        </div>
                      </td>
                  </tr>
                </table>
                  
                  
                  <%-- <div id="divArea" style="border: 1px solid rgb(204, 204, 204);height: 35px;overflow: hidden;width: 680px;display: block; margin-top:0px;" >																	
								<div class="row" style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 25%; "> 
				    					<input  type="text" style="width: 150px;" id="Customer"  class="searchTextBox jQKeyboard form-control" placeholder="Select customer..."  ondblclick="funHelp('POSCustomerMaster')"/>
				    				</div>
			    					<div class="element-input col-lg-6" style="width: 25%;"> 
				    					<label id="customerName"> <!-- vinayak padalkar --></label>
				    				</div>
			    				 <div class="element-input col-lg-6" style="width: 20%;"> 
				    					<label>Area :</label> <!-- <label id="txtAreaName"> All</label> -->
				    				</div>
			    					<div class="element-input col-lg-6" style="width: 25%;"> 
										<s:select id="txtAreaName" items="${areaList}" path="" onchange="funShowTables()"  ></s:select>
									</div>
			    			</div>
                </div> --%>
              
              
               <table width="100%" class="mdc-card info-card3">
                  <tr>        
                    <td class="bs-example">
                      <div class="accordion" id="accordionExample">
       					<c:set var="areaCount" value="${0}"></c:set>
       					<c:forEach var="objAreaDtl" items="${command.jsonArrForArea}"  varStatus="varAreaStatus">																																		
						
						 <div class="card">
                            <div class="card-header" id="headingOne">
                                <h2 class="mb-0">
                                    <i class="fa fa-plus"></i>
                                   <input type="button"  id="${command.jsonArrForArea[areaCount].strAreaCode}" value="${command.jsonArrForArea[areaCount].strAreaName}"    class="btn btn-link" data-toggle="collapse" data-target="#collapseOne${areaCount}"  />
  				                </h2>
                                
                            </div>
                            <div id="collapseOne${areaCount}" class="collapse" aria-labelledby="headingOne" data-parent="#accordionExample">
                           <!--   <table id="tblMenuItemDtl"> --> 
                             <table >
                            <c:set var= "arrtable" value="${command.jsonArrForArea[areaCount].tables}"></c:set>
                            <c:set var="sizeOfTables" value="${fn:length(arrtable)}"></c:set>									   
							<c:set var="itemCounter" value="${0}"></c:set>							
									
                            <c:forEach var="objtableDtl" items="${arrtable}"  varStatus="vartableStatus">
                            				<tr>
                            					<%
													for(int x=0; x<4; x++)
													{
												%>														
														<c:if test="${itemCounter lt sizeOfTables}">																																		
															<td>
														<div class="card-body" style="padding: 0.25rem;">
															<c:set var="tableCode" value="${arrtable[itemCounter].strTableName}"></c:set>
															<c:choose>
																<c:when test="${arrtable[itemCounter].strStatus == 'Normal'}">
																	<input type="button" id="${arrtable[itemCounter].strTableNo}"  value="${arrtable[itemCounter].strTableName}" style="width: 60px; height: 30px; white-space: normal;border-radius: 30px;" class="btn btn-primary"  onclick="funTableNoClicked(this,${itemCounter})"  />
																</c:when>
																<c:when test="${arrtable[itemCounter].strStatus == 'Occupied'}">
																	<input type="button" id="${arrtable[itemCounter].strTableNo}"  value="${arrtable[itemCounter].strTableName}" style="width: 60px; height: 30px; white-space: normal;border-radius: 30px;" class="btn btn-danger"  onclick="funTableNoClicked(this,${itemCounter})"  />
																</c:when>
																<c:when test="${arrtable[itemCounter].strStatus == 'Billed'}">
																	<input type="button" id="${arrtable[itemCounter].strTableNo}"  value="${arrtable[itemCounter].strTableName}" style="width: 60px; height: 30px; white-space: normal;border-radius: 30px;" class="btn btn-info"  onclick="funTableNoClicked(this,${itemCounter})"  />
																</c:when>
															</c:choose>
							
															 
															 
														</div>	
															</td>																																																			
														<c:set var="itemCounter" value="${itemCounter +1}"></c:set>
														</c:if>													
												<% 
												}
												%>
							</tr>
                            </c:forEach>
                            </table>
                        </div>
                        <c:set var="areaCount" value="${areaCount + 1}"></c:set>
                        </div>
						</c:forEach>
                       
                        </div>
                      </td>             
                    </tr>
                  </table>  
               
                  </td>  
              <td width="40%" style="vertical-align: top;">
                <table width="100%" class="mdc-card info-card">
                    <tr>
                      <td width="10%">
                         <h5 class="tablehead" nowrap>Categories</h5>
                      </td>
                      <td width="50%">
                        <div class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon search-text-field d-none d-md-flex" style="background: #fff;border-radius: 6px;">
                         <input type="text" id="txtCategorySearch" path="" class="mdc-text-field__input" cssClass="searchTextBox jQKeyboard form-control">
                          <label for="text-field-hero-input" class="mdc-floating-label">Search Category</label>
                        </div>
                       </td>
                      </tr>
                </table>  
                <div id="divMenuHeadDtl" style="border: 1px solid rgb(204, 204, 204);height: 120px;overflow: auto;width: 680px;display: block; margin-top:0px;" >									
				<table width="100%" class="mdc-card info-card3" id="tblMenuHeadDtl" > <!-- class="table table-striped table-bordered table-hover" -->
									 <tr>
									 <td><input type="button" id="PopularItem" value="POPULAR" onclick="funPopularItemButtonClicked(this)" style="width: 100px;height: 35px; white-space: normal;border-style:none;text-align:center ;" class="mdc-card info-card4"/></td>
									 </tr>
									 <c:set var="sizeOfmenu" value="${fn:length(command.jsonArrForDirectBillerMenuHeads)}"></c:set>
									 <c:set var="menuCount" value="${0}"></c:set>
									 
									  <c:forEach var="objMenuHeadDtl" items="${command.jsonArrForDirectBillerMenuHeads}"  varStatus="varMenuHeadStatus">																																		
												<tr>
												<% 
												for(int k=0;k<5;k++) 
												{
												%>	
												
												<c:if test="${menuCount lt sizeOfmenu}">
													<td  style="padding: 3px;" >
														<input type="button"  id="${command.jsonArrForDirectBillerMenuHeads[menuCount].strMenuCode}" value="${command.jsonArrForDirectBillerMenuHeads[menuCount].strMenuName}"    style="width: 100px;height: 35px; white-space: normal;border-style:none;text-align:center ;" class="mdc-card info-card4" onclick="funMenuHeadButtonClicked(this)"/>
													</td>
												<c:set var="menuCount" value="${menuCount +1}"></c:set>
												</c:if>																						 													
																
													
												<%
												}
												%>										
											   </tr>																																
										</c:forEach>									   				   									   									   							
				 </table>
				 </div> 
							
                 <table width="100%" class="mdc-card info-card">
                    <tr>
                      <td width="10%">
                          <h5 class="tablehead" nowrap style="color: #fff;">Items</h5>
                      </td>
                      <td width="30%">
                        <div class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon search-text-field d-none   d-md-flex" style="background: #fff;width:90%;border-radius: 6px;">
                          <%-- <s:input type="text"  id="txtItemSearch" path="" cssStyle="mdc-text-field__input"  onclick="funFillGridData('')" /> --%>
                          <input type="text" id="txtItemSearch" path=""  class="mdc-text-field__input"  cssClass="searchTextBox jQKeyboard form-control" onclick="funFillGridData('')" >   <!-- onclick="funFillGridData('') -->
                          <label for="txtItemSearch" class="mdc-floating-label">Search Items</label>
                           
                        </div> 
                      </td>
                      <td width="10%">
                          <div class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon search-text-field d-none  d-md-flex" style="background: #fff;width:90%;border-radius: 6px;">
                            <input class="mdc-text-field__input" id="text-field-hero-input">
                            <label for="text-field-hero-input" class="mdc-floating-label">QTY</label>
                          </div> 
                      </td>
                      <td width="10%">
                        <a href="javascript:void(0)" class="mdc-button mdc-button--raised mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;border-radius: 6px;">
                          ADD
                        </a>

                      </td>
                      </tr>
                </table>
                
                
			<div id="divItemDtl" style="height: 465px;overflow: auto;width: 680px;display: block;" >
				
				<table width="100%" class="mdc-card info-card3" id="tblMenuItemDtl">
            		<c:set var="sizeOfItem" value="${fn:length(command.jsonArrForDirectBillerMenuItemPricing)}"></c:set>
					<c:set var="itemCount" value="${0}"></c:set>
						<c:forEach var="objItemDtl" items="${command.jsonArrForDirectBillerMenuItemPricing}"  varStatus="varMenuHeadStatus">																																		
						<tr>
							<% 
							for(int k=0;k<5;k++) 
							{
							%>
							<c:if test="${itemCount lt sizeOfItem}">
								<td class="mdc-card info-card4" style="height:80px;"  >
								<h5 class="tablehead2" nowrap>
									<input type="button"  id="${command.jsonArrForDirectBillerMenuItemPricing[itemCount].strItemCode}" value="${command.jsonArrForDirectBillerMenuItemPricing[itemCount].strItemName}"    style="white-space: normal;background: transparent;border-style:none;" onclick="funMenuItemClicked(this,${itemCount}) "/> 
								</h5>
								<span class="price">
								<fmt:formatNumber type = "number" maxFractionDigits = "2" value = "${command.jsonArrForDirectBillerMenuItemPricing[itemCount].strPriceMonday}" />
									/-
								</span>
								</td>
									<c:set var="itemCount" value="${itemCount +1}"></c:set>
							</c:if>	
							<%
							}
							%>										
						</tr>																																
						</c:forEach>	       
                  </table> 
             
             </div>
              </td>
              <td width="7%" style="vertical-align: top;">
                 <table width="100%" class="mdc-card info-card3" >
                   <tr>
                      <td width="33%">
                        <h5 class="tablehead" nowrap style="color: #399be2;font-weight: 600;">Table No: 
                        <label id="txtTableNo" class="tablehead"></label>
                         </h5>
                      </td>
                      <td width="33%">
                        <h5 class="tablehead" nowrap style="color: #399be2;font-weight:600;">00:00</h5>
                      </td>
                      <td width="33%">
                        <h5 class="tablehead" nowrap style="color: #399be2;font-weight: 600;">Total:    
                        <input  disabled type="text"  id="txtTotal" style="color: #399be2;font-weight: 600;    height: 26px;border: none;" />
                         </h5>
                      </td>
                   </tr>
                 </table>
                 
                  <table width="100%" class="mdc-card info-card3">
                  <tr><td style="display: none;">
	                 
					 <label id="txtWaiterName" style="width: 100%;text-align: center;" class="btn-link"></label>
					 <label  id="txtPaxNo" style="width: 100%;text-align: center;" class="btn-link" >1</label> <!-- onclick="funChangePAX(this)" -->
					 <label id="txtAreaName" style="width: 100%;text-align: center;" class="btn-link"></label>
					 
				</td>
				</tr>
				</table>
				
                 <table width="100%" class="mdc-card info-card3">
                    <tr>
                      <td width="20%">
                        <h5 class="tablehead" nowrap style="font-weight: 600;">KOT:<label id="txtKOTNo" style="width: 100%;text-align: center;" class="btn-link"></label></h5>
                      </td>
                      <td width="30%">
                        <h5 class="tablehead" nowrap style="font-weight: 600;">Time:00:00</h5>
                      </td>
                      <td width="2%">
                        <a href="javascript:void(0)" class="mdc-button mdc-button--raised mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px; border-radius: 6px;">
                          REPRINT
                        </a>
                      </td>
					</tr>
					</table>

<!-- Item Table -->					
				<table width="100%" class="mdc-card info-card3" id="tblBillItemDtl">
                     <tr class="trcolor">
                      <td width="55%" colspan="1">
                        <h5 class="tablehead" nowrap>Item Name</h5> 
                      </td>
                      <td width="10%">
                        <h5 class="tablehead" nowrap align="right">Qty</h5>
                      </td>
                      <td width="10%">
                        <h5 class="tablehead" nowrap align="right">Amt</h5>
                      </td>
                    </tr>
                    
                </table>
                
                <table id="tblOldKOTItemDtl" >
				</table>
                   
                <table>
                    <tr>            
                      <td width="65%" height="100">
                        
                      </td>
                      <td width="15%">
                        
                      </td>
                      <td width="15%">
                        
                      </td>
                    </tr> 
                    
              </table>          
              </td>
              <td width="10%" style="vertical-align: top;">
                 <table width="100%" class="mdc-card info-card3">
                    <tr width="100%">
                       <td align="center" class="img" id="FIRE_KOT" onclick="funFooterButtonClicked(this)">
                          <img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/icon-kot.png" border="0" height="50px" width="50px"> 
                          <h5 class="tablehead" nowrap>KOT</h5> 
                      </td>
                    </tr>
                     <tr width="100%">
                       <td align="center" class="img" id="Make Bill" onclick="funFooterButtonClicked(this)">
                          <img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/icon-bill.png" border="0" height="50px" width="50px"> 
                          <h5 class="tablehead" nowrap>BILL</h5> 
                      </td>
                    </tr>
                     <tr width="100%">
                       <td align="center" class="img" id="Settle" onclick="funFooterButtonClicked(this)">
                          <img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/icon-settle.png" border="0" height="50px" width="50px"> 
                          <h5 class="tablehead" nowrap>SETTLE</h5> 
                      </td>
                    </tr>
                     <tr width="100%">
                       <td align="center" class="img" id="Waiter" onclick="funFooterButtonClicked(this)">
                          <img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/icon-waiter.png" border="0" height="50px" width="50px"> 
                          <h5 class="tablehead" nowrap>WAITER</h5> 
                      </td>
                    </tr>
                     <tr width="100%">
                       <td align="center" class="img" id="HO" onclick="funFooterButtonClicked(this)">
                          <img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/icon-HO.png" border="0" height="50px" width="50px"> 
                          <h5 class="tablehead" nowrap>HO</h5> 
                      </td>
                    </tr>                    
                    <tr width="100%">
                       <td align="center" class="img" id="Customer" onclick="funFooterButtonClicked(this)">
                          <img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/icon-customer.png" border="0" height="50px" width="50px"> 
                          <h5 class="tablehead" nowrap>CUSTOMER</h5> 
                      </td>
                    </tr>
                     <tr width="100%">
                       <td align="center" class="img" id="Done" onclick="funFooterButtonClicked(this)">
                          <img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/icons-done.png" border="0" height="50px" width="50px"> 
                          <h5 class="tablehead" nowrap>DONE</h5> 
                      </td>
                    </tr>
                     <tr width="100%">
                       <td align="center" class="img" id="Done" onclick="funFooterButtonClicked(this)">
                          <img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/icon-more.png" border="0" height="50px" width="50px"> 
                          <h5 class="tablehead" nowrap>OTHER</h5> 
                      </td>
                    </tr>
                  </table>
              </td>
          </tr>
		    </table>   
      </main>
     </div>
    </div>
  </div>

  <!-- plugins:js -->
  <script src="../assets/vendors/js/vendor.bundle.base.js"></script>
  <!-- endinject -->
  <!-- Plugin js for this page-->
  <script src="../assets/vendors/chartjs/Chart.min.js"></script>
  <script src="../assets/vendors/jvectormap/jquery-jvectormap.min.js"></script>
  <script src="../assets/vendors/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
  <!-- End plugin js for this page-->
  <!-- inject:js -->
  <script src="../assets/js/material.js"></script>
  <script src="../assets/js/misc.js"></script>
  <!-- endinject -->
  <!-- Custom js for this page-->
  <script src="../assets/js/dashboard.js"></script>
  <!-- End custom js for this page-->
</body>
</html> 