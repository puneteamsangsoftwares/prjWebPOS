<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Menu Item</title>
<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/jquery-confirm.min.css"/>"/>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery-confirm.min.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/confirm-prompt.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery.autocomplete.min.js"/>"></script>
<script type="text/javascript">
	var fieldName;
	var mapMenuCodeName=new Map();
	$(document).ready(function () {
		
		$(".tab_content").hide();
		$(".tab_content:first").show();

		$("ul.tabs li").click(function() {
			$("ul.tabs li").removeClass("active");
			$(this).addClass("active");
			$(".tab_content").hide();
			activeTab = $(this).attr("data-state");
			$("#" + activeTab).fadeIn();
		
		});
		
		$("#txtFromDate").datepicker({ dateFormat: 'yy-mm-dd' });
		$("#txtFromDate" ).datepicker('setDate', 'today');
		$("#txtFromDate").datepicker();
		
        $("#txtToDate").datepicker({ dateFormat: 'yy-mm-dd' });
        $("#txtToDate" ).datepicker('setDate', 'today');
        $("#txtToDate").datepicker();
		
		  $("form").submit(function(event){
			  if($("#txtItemName").val().trim()=="")
				{
				  confirmDialog("Please Enter Item Name","");
					return false;
				}
			  else{
				  flg=funCallFormAction();
				  return flg;
			  }
			});
		
		 // $('input#txtItemName').mlKeyboard({layout: 'en_US'});
		  $('input#txtShortName').mlKeyboard({layout: 'en_US'});
		  $('input#txtPurchaseRate').mlKeyboard({layout: 'en_US'});
		  $('input#txtSalePrice').mlKeyboard({layout: 'en_US'});
		  $('input#txtMinLevel').mlKeyboard({layout: 'en_US'});
		  $('input#txtItemDetails').mlKeyboard({layout: 'en_US'});
		  $('input#txtMaxLevel').mlKeyboard({layout: 'en_US'});
		  $('textarea#txtItemDetails').mlKeyboard({layout: 'en_US'});
		  
		  $('#txtItemName').autocomplete({
	 			serviceUrl: '${pageContext.request.contextPath}/getAutoSearchData.html?formname=menuItemName',  
	 			paramName: "searchBy",
	 			delimiter: ",",
	 		    transformResult: function(response) {
	 		    	mapMenuCodeName=new Map();
	 			return {
	 			  //must convert json to javascript object before process
	 			  suggestions: $.map($.parseJSON(response), function(item) {
	 			       // strValue  strCode
	 			        mapMenuCodeName.set(item.strValue,item.strCode);
	 			      	return { value: item.strValue, data: item.strCode };
	 			   })
	 			            
	 			 };
	 			        
	 	        }
	 		 });
			 
				$('#txtItemName').blur(function() {
						var code=mapMenuCodeName.get($('#txtItemName').val());
						if(code!='' && code!=null){
							funSetItemCode(code);	
						}
						
				});
		}); 

	function funSetData(code){

		switch(fieldName){

			case 'POSMenuItemMaster' : 
				funSetItemCode(code);
				break;
			case 'MenuItemForRecipeChild' :
				funSetRawItemData(code);
				break;
		}
	}


	function funSetItemCode(code)
	{
		$("#txtItemCode").val(code);
		var searchurl=getContextPath()+"/loadItemCode.html?itemCode="+code;
		 $.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strItemCode=='Invalid Code')
		        	{
		        		confirmDialog("Invalid Item Code ","");
		        		$("#txtItemCode").val('');
		        	}
		        	else
		        	{
		        		
		        		$("#txtReceipeItemCode").val(response.strItemCode);
		        		$("#strReceipeItemName").text(response.strItemName);
		        		
		        		$("#txtItemCode").val(response.strItemCode);
			        	$("#txtExternalCode").val(response.strExternalCode);
			        	$("#txtItemName").val(response.strItemName);
			        	$("#txtItemName").focus();
			        	$("#txtShortName").val(response.strShortName);
			        	if(response.strRawMaterial=='Y')
			        	{
			        		$("#chkRawMaterial").attr('checked', true);
			        	}
			        	else
			        	{
			        		$("#chkRawMaterial").attr('unchecked', false);
			        	}
			        	if(response.strItemForSale=='Y')
			        	{
			        		$("#chkItemForSale").attr('checked', true);
			        	}
			        	else
			        	{
			        		$("#chkItemForSale").attr('unchecked', false);
			        	}
			        	
			        	$("#txtItemType").val(response.strItemType);
			        	$("#txtSubGroupCode").val(response.strSubGroupCode);
			        	$("#txtTaxIndicator").val(response.strTaxIndicator);
			        	$("#txtPurchaseRate").val(response.dblPurchaseRate);
			        	$("#txtRevenueHead").val(response.strRevenueHead);
			        	$("#txtSalePrice").val(response.dblSalePrice);
			        	$("txtTargetMissTimeMin").val(response.tmeTargetMiss);
			        	$("#txtMinLevel").val(response.dblMinLevel);
			        	$("#txtProcTimeMin").val(response.intProcTimeMin);
			        	$("#txtMaxLevel").val(response.dblMaxLevel);
			        	$("#txtUOM").val(response.strUOM);
			        	if(response.strStockInEnable=='Y')
			        	{
			        		$("#chkStockInEnable").attr('checked', true);
			        	}
			        	else
			        	{
			        		$("#chkStockInEnable").attr('unchecked', false);
			        	}
			         	if(response.strOpenItem=='Y')
			        	{
			        		$("#chkOpenItem").attr('checked', true);
			        	}
			        	else
			        	{
			        		$("#chkOpenItem").attr('unchecked', false);
			        	}
			        	if(response.strItemWiseKOTYN=='Y')
			        	{
			        		$("#chkItemWiseKOTYN").attr('checked', true);
			        	}
			        	else
			        	{
			        		$("#chkItemWiseKOTYN").attr('unchecked', false);
			        	}
			        	
			        	if(response.strDiscountApply=='Y')
			        	{
			        		$("#chkDiscountApply").attr('checked', true);
			        	}
			        	else
			        	{
			        		$("#chkDiscountApply").attr('unchecked', false);
			        	}
			        	if(response.strOperationalYN=='Y')
			        	{
			        		$("#chkOperationalYN").attr('checked', true);
			        	}
			        	else
			        	{
			        		$("#chkOperationalYN").attr('unchecked', false);
			        	}
			        	

			        	$("#cmbRecipeUOM").val(response.strRecipeUOM);
			        	$("#txtReceivedConversion").val(response.dblReceivedConversion);
			        	$("#txtRecipeConversion").val(response.dblRecipeConversion);
			        	$("#txtHSNNo").val(response.strHSNNo);

			        	$("#txtItemDetails").val(response.strItemDetails);
			        	$("#txtProcDay").val(response.intProcDay);
			        	
			        	funLoadRecipeData(response.strItemCode);
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
	
	function funSetRawItemData(code){

		$("#txtChildItemName").val(code);
		var searchurl=getContextPath()+"/loadItemCode.html?itemCode="+code;
		 $.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strItemCode=='Invalid Code')
		        	{
		        		confirmDialog("Invalid Item Code ","");
		        		$("#txtChildItemName").val('');
		        	}
		        	else
		        	{
		        		$("#strReceipeChildItemName").text(response.strItemName);
		        		$("#strReceipeChildItemUOM").text(response.strRecipeUOM);
		        		
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


	function funLoadRecipeData(itemCode){
		
		var searchurl=getContextPath()+"/loadRecipeData.html?itemCode="+code;
		 $.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strItemCode=='Invalid Code')
		        	{
		        		confirmDialog("Invalid Item Code ","");
		        		$("#txtChildItemName").val('');
		        	}
		        	else
		        	{
		        		$("#strReceipeChildItemName").text(response.strItemName);
		        		$("#strReceipeChildItemUOM").text(response.strRecipeUOM);
		        		
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

	function funHelp(transactionName)
	{
		fieldName=transactionName;
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
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
					confirmDialog("Data Saved \n\n"+ message,"");
				<%}
			}%>
	});

	function funCallFormAction(actionName, object) {
		var flg = true;

		/* if($('#txtItemCode').val()=='')
		{ */
		var name = $('#txtItemName').val();
		var code = $('#txtItemCode').val();

		$.ajax({
			type : "GET",
			url : getContextPath() + "/checkItemName.html?itemCode=" + code
					+ "&itemName=" + name,
			async : false,
			dataType : "text",
			success : function(response) {
				if (response == "false") {
					confirmDialog("Item Name Already Exist!","");
					$('#txtItemName').focus();
					flg = false;
				} else {
					flg = true;
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

		return flg;
	}
		
		
	function btnAdd_onclick() 
	{
		var qty=$("#txtQuantity").val();
		
			if($("#txtReceipeItemCode").val()=="") 
		    {
				alert("Please select Menu Item");
		   		
		       	return false;
			}
			else if($("#txtChildItemName").val()=="")
		    {
				alert("Please Select Child Item!");
		       	return false;
			}
			else if(qty=="")
			{
				alert("Please Check Quantity !");
		       	return false;
				
			}else if(qty<=0)
			{
				alert("Please Check Quantity !");
		       	return false;
			}
			else
			{
				funAddRow();
			}
		
	}
	
/* 	function btnRemove_onclick() 
	{
		
		
		var table = document.getElementById("tblRecipedetails");
	    table.deleteRow(selectedRowIndex);
		
	}
 */
	
	function funAddRow() 
	{
		var quantity=$("#txtQuantity").val();
	    var table = document.getElementById("tblRecipedetails");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    var childMenuCode=$("#txtChildItemName").val();
	    var childMenuName=$("#strReceipeChildItemName").text();
	    var childUOM=$("#strReceipeChildItemUOM").text();
	    if(funDuplicateItem(childMenuCode))
	    {
		    row.insertCell(0).innerHTML= "<input class=\"Box\" name=\"listChildItemDtl["+(rowCount)+"].strChildItemCode\" size=\"30%\"  id=\"txtItemCode."+(rowCount)+"\" value='"+childMenuCode+"' \"/>";
		    row.insertCell(1).innerHTML= "<input class=\"Box\" name=\"listChildItemDtl["+(rowCount)+"].strItemName\" size=\"40%\"  id=\"txtItemName."+(rowCount)+"\" value='"+childMenuName+"' \"/>";
		    row.insertCell(2).innerHTML= "<input class=\"Box\" name=\"listChildItemDtl["+(rowCount)+"].dblQuantity\" size=\"30%\"  id=\"txtQty."+(rowCount)+"\" value='"+quantity+"'\"/>";
		    row.insertCell(3).innerHTML= "<input class=\"Box\"  size=\"10%\"  id=\"childUOM."+(rowCount)+"\" value='"+childUOM+"' \"/>";
		    row.insertCell(4).innerHTML= '<input type="button" class="deletebutton" value = "Del" onClick="Javacsript:funDeleteRow(this)">';	
	    }	
	    
	   
	}

 	function funDeleteRow(obj)
	{
		 var index = obj.parentNode.parentNode.rowIndex;
	     var table = document.getElementById("tblRecipedetails");
	     table.deleteRow(index);
		
	}
 	
	//Check Duplicate Product in grid
	function funDuplicateItem(itemCode)
	{
	    var table = document.getElementById("tblRecipedetails");
	    var rowCount = table.rows.length;
	    var flag=true;
	    if(rowCount > 0)
    	{
		    $('#tblRecipedetails tr').each(function()
		    {
			    if(itemCode==$(this).find('input').val())// `this` is TR DOM element
				{
			    	alert("Already added "+ itemCode);
			    	
    				flag=false;
				}
			});
	    }
	    return flag;
	}
	
	function funGetSelectedRowIndex(obj)
	{
		 var index = obj.parentNode.parentNode.rowIndex;
		 var table = document.getElementById("tblDeliveryCharges");
		 if((selectedRowIndex>0) && (index!=selectedRowIndex))
		 {
			 if(selectedRowIndex%2==0)
			 {
				 row = table.rows[selectedRowIndex];
				 row.style.backgroundColor='#A3D0F7';
				 selectedRowIndex=index;
				 row = table.rows[selectedRowIndex];
				 row.style.backgroundColor='#ffd966';
				 row.hilite = true;
			 }
			 else
			 {
				 row = table.rows[selectedRowIndex];
				 row.style.backgroundColor='#C0E4FF';
				 selectedRowIndex=index;
				 row = table.rows[selectedRowIndex];
				 row.style.backgroundColor='#ffd966';
				 row.hilite = true;
	         }
			
		 }
		 else
		 {
			 selectedRowIndex=index;
			 row = table.rows[selectedRowIndex];
			 row.style.backgroundColor='#ffd966';
			 row.hilite = true;
		 }
		 
		
	}
	
</script>

</head>
<body>

	<div id="formHeading">
		<label>Menu Item Master</label>
	</div>

	<s:form name="menuItemMaster" method="POST"
		action="saveMenuItemMaster.html?saddr=${urlHits}"
		class="formoid-default-skyblue"
		style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:880px;min-width:150px;margin-top:2%;">

<div id="tab_container" style="height: 405px; overflow: inherit;">
				<ul class="tabs">
					<li data-state="tab1" style="width: 20%; height: 25px; padding-left: 2%;border-radius: 4px;" class="active" >General</li>
					<li data-state="tab2" style="width: 20%; height: 25px; padding-left: 3%; border-radius: 4px;">Recipe</li>
					
				</ul>
							
							
				<!-- Menu Head Master Tab Start -->
				
			<div id="tab1" class="tab_content" style="height: 350px">
			<br/> <br/>
			<div class="title" style="margin-left: 50px;">
				<div class="row"
					style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
					<div class="element-input col-lg-6" style="width: 20%;">
						<label class="title" style="width: 100%">Item Code</label>
					</div>
					<div class="element-input col-lg-6" style="width: 20%;">
						<s:input class="large" colspan="3" type="text" id="txtItemCode" readonly="true"
							path="strItemCode" ondblclick="funHelp('POSMenuItemMaster');"
							style="width: 100%" />
					</div>
					<div class="element-input col-lg-6" style="width: 20%;">
						<label class="title" style="width: 100%">External Code</label>
					</div>
					<div class="element-input col-lg-6" style="width: 20%;">
						<s:input class="large" colspan="3" type="text" id="txtExternalCode"
							path="strExternalCode" style="width: 100%" />
					</div>
				</div>
	
				<div class="row"
					style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
					<div class="element-input col-lg-6" style="width: 20%;">
						<label class="title" style="width: 100%">Item Name</label>
					</div>
					<div class="element-input col-lg-6" style="width: 60%;">
						<s:input class="large" colspan="3" type="text" id="txtItemName"
							path="strItemName" style="width: 100%" />
					</div>
				</div>
	
				<div class="row"
					style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
					<div class="element-input col-lg-6" style="width: 20%;">
						<label class="title" style="width: 100%">Short Name</label>
					</div>
					<div class="element-input col-lg-6" style="width: 20%;">
						<s:input class="large" colspan="3" type="text" id="txtShortName"
							path="strShortName" style="width: 100%" />
					</div>
					<div class="element-input col-lg-6" style="width: 15%;">
						<label class="title" style="width: 100%">Raw Material</label>
					</div>
					<div class="element-input col-lg-6" style="width: 5%;">
						<s:input type="checkbox" id="chkRawMaterial" path="strRawMaterial"></s:input>
					</div>
					<div class="element-input col-lg-6" style="width: 15%;">
						<label class="title" style="width: 100%">Item For Sale</label>
					</div>
					<div class="element-input col-lg-6" style="width: 5%;">
						<s:input type="checkbox" id="chkItemForSale" path="strItemForSale"></s:input>
					</div>
					<div class="element-input col-lg-6" style="width: 15%;">
						<label class="title" style="width: 100%">Operational</label>
					</div>
					<div class="element-input col-lg-6" style="width: 5%;">
						<s:input type="checkbox" id="chkOperationalYN" path="strOperationalYN"></s:input>
					</div>
				</div>
	
				<div class="row"
					style="background-color: #fff; display: -webkit-box;">
					<div class="element-input col-lg-6" style="width: 20%;">
						<label class="title">Item Type</label>
					</div>
					<div class="element-input col-lg-6"
						style="margin-bottom: 10px; width: 20%;">
						<s:select id="txtItemType" path="strItemType">
							<option selected="selected" value="">Select</option>
							<option value="Food">Food</option>
							<option value="Liquor">Liquor</option>
							<option value="Retail">Retail</option>
						</s:select>
					</div>
					<div class="element-input col-lg-6" style="width: 20%;">
						<label class="title">Sub Group Code</label>
					</div>
					<div class="element-input col-lg-6"
						style="margin-bottom: 10px; width: 20%;">
						<s:select id="txtSubGroupCode" path="strSubGroupCode"
							items="${subGroup}"></s:select>
					</div>
				</div>
	
				<div class="row"
					style="background-color: #fff; display: -webkit-box;">
					<div class="element-input col-lg-6" style="width: 20%;">
						<label class="title">Tax Indicator</label>
					</div>
					<div class="element-input col-lg-6"
						style="margin-bottom: 10px; width: 20%;">
						<s:select id="txtTaxIndicator" path="strItemType">
							<option selected="selected" value=""></option>
							<option value="A">A</option>
							<option value="B">B</option>
							<option value="C">C</option>
							<option value="D">D</option>
							<option value="E">E</option>
							<option value="F">F</option>
							<option value="G">G</option>
							<option value="H">H</option>
							<option value="I">I</option>
							<option value="J">J</option>
							<option value="K">K</option>
							<option value="L">L</option>
							<option value="M">M</option>
							<option value="N">N</option>
							<option value="O">O</option>
							<option value="P">P</option>
							<option value="Q">Q</option>
							<option value="R">R</option>
							<option value="S">S</option>
							<option value="T">T</option>
							<option value="U">U</option>
							<option value="V">V</option>
							<option value="W">W</option>
							<option value="X">X</option>
							<option value="Y">Y</option>
							<option value="Z">Z</option>
						</s:select>
					</div>
					<div class="element-input col-lg-6" style="width: 20%;">
						<label class="title">Purchase Rate</label>
					</div>
					<div class="element-input col-lg-6"
						style="margin-bottom: 10px; width: 20%;">
						<s:input id="txtSalePrice" path="dblSalePrice" type="number"
							min="0" step="1" style="text-align: right;width: 100%;" />
					</div>
				</div>
	
				<div class="row"
					style="background-color: #fff; display: -webkit-box;">
					<div class="element-input col-lg-6" style="width: 20%;">
						<label class="title">Revenue Head</label>
					</div>
					<div class="element-input col-lg-6"
						style="margin-bottom: 10px; width: 20%;">
						<s:select id="txtRevenueHead" path="strRevenueHead">
							<option selected="selected" value=""></option>
							<option value="FOOD">FOOD</option>
							<option value="BEVERAGES">BEVERAGES</option>
							<option value="TOBBACO">TOBBACO</option>
							<option value="CONFECTIONARY">CONFECTIONARY</option>
							<option value="MILD">MILD</option>
							<option value="LIQUORS">LIQUORS</option>
							<option value="FERMENTATED">FERMENTATED</option>
							<option value="LIQUOR">DMFL</option>
							<option value="TOBBACO">IMPORTED</option>
							<option value="CONFECTIONARY">BITTER/LIQUOR</option>
							<option value="MILD">OTHER/MISC</option>
							<option value=WINES>WINES</option>
						</s:select>
					</div>
					<div class="element-input col-lg-6" style="width: 20%;">
						<label class="title" style="width: 100%">Target Missed Time</label>
					</div>
					<div class="element-input col-lg-6" style="width: 20%;">
						<s:select id="txtTargetMissTimeMin" path="tmeTargetMiss"
							items="${ProcessTime}">
						</s:select>
						<label> Minutes</label>
					</div>
	
				</div>
	
				<div class="row"
					style="background-color: #fff; display: -webkit-box;">
					<div class="element-input col-lg-6" style="width: 20%;">
						<label class="title">Sale Price</label>
					</div>
					<div class="element-input col-lg-6"
						style="margin-bottom: 10px; width: 20%;">
						<s:input id="txtSalePrice" path="dblSalePrice" type="number"
							min="0" step="1" style="text-align: right;width: 100%;" />
					</div>
					<div class="element-input col-lg-6" style="width: 20%;">
						<label class="title">Processing Day</label>
					</div>
					<div class="element-input col-lg-6"
						style="margin-bottom: 10px; width: 20%;">
						<s:select id="txtProcDay" path="intProcDay">
							<option selected="selected" value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="5">5</option>
							<option value="6">6</option>
							<option value="7">7</option>
							<option value="8">8</option>
							<option value="9">9</option>
							<option value="10">10</option>
							<option value="11">11</option>
							<option value="12">12</option>
							<option value="13">13</option>
							<option value="14">14</option>
							<option value="15">15</option>
						</s:select>
					</div>
				</div>
	
				<div class="row"
					style="background-color: #fff; display: -webkit-box; margin-bottom: 10px">
					<div class="element-input col-lg-6" style="width: 20%;">
						<label class="title" style="width: 100%">Minimum Level</label>
					</div>
					<div class="element-input col-lg-6" style="width: 20%;">
						<s:input id="txtMinLevel" path="dblMinLevel" type="number" min="0"
							step="1" style="text-align: right;width: 100%;" />
					</div>
					<div class="element-input col-lg-6" style="width: 20%;">
						<label class="title" style="width: 100%">Processing Time</label>
					</div>
					<div class="element-input col-lg-6" style="width: 20%;">
						<s:select id="txtProcTimeMin" path="intProcTimeMin"
							items="${ProcessTime}">
						</s:select>
						<label> Minutes</label>
	
					</div>
	
	
				</div>
	
				<div class="row"
					style="background-color: #fff; display: -webkit-box; margin-bottom: 10px">
					<div class="element-input col-lg-6" style="width: 20%;">
						<label class="title" style="width: 100%">Maximum Level</label>
					</div>
					<div class="element-input col-lg-6" style="width: 20%;">
						<s:input id="txtMaxLevel" path="dblMaxLevel" type="number" min="0"
							step="1" style="text-align: right;width: 100%;" />
					</div>
					<div class="element-input col-lg-6" style="width: 20%;">
						<label class="title" style="width: 100%">Stock In Enable</label>
					</div>
					<div class="element-input col-lg-6" style="width: 20%;">
						<s:input type="checkbox" id="chkStockInEnable" path="strOpenItem"></s:input>
					</div>
				</div>
	
				<div class="row"
					style="background-color: #fff; display: -webkit-box; margin-bottom: 10px">
					<div class="element-input col-lg-6" style="width: 20%;">
						<label class="title" style="width: 100%">Open Item</label>
					</div>
					<div class="element-input col-lg-6" style="width: 20%;">
						<s:input type="checkbox" id="chkOpenItem" path="strOpenItem"></s:input>
					</div>
					<div class="element-input col-lg-6" style="width: 20%;">
						<label class="title" style="width: 100%">Item Wise KOT YN</label>
					</div>
					<div class="element-input col-lg-6" style="width: 5%;">
						<s:input type="checkbox" id="chkItemWiseKOTYN"
							path="strItemWiseKOTYN"></s:input>
					</div>
					<div class="element-input col-lg-6" style="width: 14%;">
						<label class="title" style="width: 100%">No Discount</label>
					</div>
					<div class="element-input col-lg-6" style="width: 5%;">
						<s:input type="checkbox" id="chkDiscountApply"
							path="strDiscountApply"></s:input>
					</div>
				</div>
	
				<div class="row"
					style="background-color: #fff; display: -webkit-box; margin-bottom: 10px">
					<div class="element-input col-lg-6" style="width: 20%;">
						<label class="title">Received UOM</label>
					</div>
					<div class="element-input col-lg-6"
						style="margin-bottom: 10px; width: 20%;">
						<s:select id="txtUOM" path="strUOM">
							<option selected="selected" value=""></option>
							<option value="Gram">Gram</option>
							<option value="Kg">Kg</option>
							<option value="Unit">Unit</option>
						</s:select>
					</div>
					<div class="element-textarea col-lg-6" style="width: 20%;">
						<label class="title">Item Details</label>
					</div>
					<div class="element-input col-lg-6" style="width: 20%;">
						<s:textarea id="txtItemDetails" path="strItemDetails"
							name="textarea" style="min-width: 150px; min-height: 50px;" />
					</div>
				</div>
				<div class="row"
					style="background-color: #fff; display: -webkit-box; margin-bottom: 10px">
					<div class="element-input col-lg-6" style="width: 20%;">
						<label class="title">Receipe UOM</label>
					</div>
					<div class="element-input col-lg-6"
						style="margin-bottom: 10px; width: 20%;">
						<s:select id="cmbRecipeUOM" path="strRecipeUOM">
							<option selected="selected" value=""></option>
	
							<option value="Gram">Gram</option>
							<option value="Kg">Kg</option>
							<option value="Unit">Unit</option>
						</s:select>
					</div>
					<div class="element-textarea col-lg-6" style="width: 20%;">
						<label class="title">Received Conversion</label>
					</div>
					<div class="element-input col-lg-6" style="width: 20%;">
						<s:input type="text" id="txtReceivedConversion"
							path="dblReceivedConversion" min="0" step="1"></s:input>
					</div>
	
				</div>
				
				<div class="row"
					style="background-color: #fff; display: -webkit-box;">
					<div class="element-input col-lg-6" style="width: 20%;">
						<label class="title">Recipe Conversion</label>
					</div>
					<div class="element-input col-lg-6"
						style="margin-bottom: 10px; width: 20%;">
						<s:input id="txtRecipeConversion" path="dblRecipeConversion" type="number"
							min="0" step="1" style="text-align: right;width: 100%;" />
					</div>
					<div class="element-input col-lg-6" style="width: 20%;">
						<label class="title">HSN No</label>
					</div>
					<div class="element-input col-lg-6"
						style="margin-bottom: 10px; width: 20%;">
						<s:input type="text" id="txtHSNNo"
							path="strHSNNo"></s:input>
							
					</div>
				</div>
	
			</div>
			
			<div class="col-lg-10 col-sm-10 col-xs-10"
			style="width: 70%; margin-left: 25%;">
			<p align="center">
				<div class="submit col-lg-4 col-sm-4 col-xs-4">
					<input type="submit" value="Submit" />
				</div>
	
				<div class="submit col-lg-4 col-sm-4 col-xs-4">
					<input type="reset" value="Reset" onclick="funResetFields()">
				</div>
				</p>
		</div>
			</div>
			
			
			<div id="tab2" class="tab_content" style="height: 350px">
			<br><br>
				<div class="title">
					
					<div class="row"
						style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
						<div class="element-input col-lg-6" style="width: 20%;">
							<label class="title" style="width: 100%">Recipe Code</label>
						</div>
						<div class="element-input col-lg-6" style="width: 20%;">
							<s:input id="txtRecipeCode" path="strRecipeCode"
						cssClass="searchTextBox jQKeyboard form-control" readonly="true" onclick="funHelp('POSRecipeMaster')" />
						</div>
						<div class="element-input col-lg-6" style="width: 20%;">
							<label class="title" style="width: 100%">Menu Item </label>
						</div>
						<div class="element-input col-lg-6" style="width: 20%;">
							<s:input class="large" colspan="3" type="text" id="txtReceipeItemCode"
								path="strReceipeItemCode" style="width: 100%" />
						</div>
						<div class="element-input col-lg-6" style="width: 20%;">
							<label id="strReceipeItemName" readonly="true" /> 
						</div>
					</div>
					
					<div class="row" style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
					
						
						<div class="element-input col-lg-6" style="width: 20%;">
						<label>From Date</label>
						</div>
						<div class="element-input col-lg-6" style="width: 20%;">
							<s:input id="txtFromDate" required="required"
									path="dteFromDate" 
									cssClass="calenderTextBox" />
						</div>

						<div class="element-input col-lg-6" style="width: 20%;">
						<label>To Date</label></div>
						<div class="element-input col-lg-6" style="width: 20%;">
						<s:input id="txtToDate" required="required" path="dteToDate"
								cssClass="calenderTextBox" />
								</div>
 		
					</div>
					
					<div class="row" style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
					
					<div class="element-input col-lg-6" style="width: 20%;">
						<label>Child Item Name</label>	
					</div>
					<div class="element-input col-lg-6" style="width: 20%;">
					<input  type="text" id="txtChildItemName" 
						name="txtChildItemName" 
						 class="longTextBox jQKeyboard form-control" 
						 ondblclick="funHelp('MenuItemForRecipeChild')" />
					</div>
					<div class="element-input col-lg-6" style="width: 20%;">
						<label id="strReceipeChildItemName" readonly="true" /> 
					</div>
				</div>
			
			<div class="row" style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
			
			<div class="element-input col-lg-6" style="width: 20%;">
			
				<label>Quantity</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
				<input  type="number" id="txtQuantity" 
						name="txtQuantity"  value=0
						 class="longTextBox jQKeyboard form-control"  /> 
				
			</div>
			<div class="element-input col-lg-6" style="width: 20%;">
						<label id="strReceipeChildItemUOM" readonly="true" /> 
					</div>
			</div>
			
			<div class="row" style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
			
				<div class="element-input col-lg-6" style="width: 20%;">
					<input id="btnAdd" type="button" class="form_button" value="Add" onclick="return btnAdd_onclick();"/>
				</div>
				
				<div class="element-input col-lg-6" style="width: 20%;">
					<input id="btnRemove" type="button" class="form_button" value="Remove" onclick="return btnRemove_onclick();"></input>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<input type="reset" value="Reset" class="form_button" onclick="funResetFields()"/>
				</div>
				
			</div>
			
			
			<div class="container" style="background-color: #fff; height: 300px;width: 1400px;">
				<div class="col-xs-6">
	
					<div  id="tableLoad">
						<table class="scroll" id="table2"
							style="width: 100%; border: 1px solid #ccc;">
							<thead style="background: #2FABE9; color: white;">
								<tr>
									<th>Item Code</th>
									<th>Item Name</th>
									<th>Quantity</th>
									<th>UOM</th>
									<th>Delete</th>
								</tr>
							</thead>
						</table>
	
						<table id="tblRecipedetails" class="scroll"
							style="width: 100%; border: 1px solid #ccc;">
							<tbody style="border-top: none">
	
							</tbody>
	
						</table>
					</div>
				</div>
			</div>
				
				</div>
			</div>
			</div>
		


	</s:form>

</body>
</html>
