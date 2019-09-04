<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>
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
var selectedRowIndex=0;
var field;
	$(document).ready(function() {

    

		 $('input#txtPromoCode').mlKeyboard({layout: 'en_US'});
		  $('input#txtPromotionName').mlKeyboard({layout: 'en_US'});
		  $('input#txtPromoItemName').mlKeyboard({layout: 'en_US'});
		  $('input#txtBuyQty').mlKeyboard({layout: 'en_US'});
		
		  $('input#txtGetItemName').mlKeyboard({layout: 'en_US'});
		
		  $('input#txtGetQty').mlKeyboard({layout: 'en_US'});
		  $('input#txtDiscount').mlKeyboard({layout: 'en_US'});
		  var POSDate="${POSDate}"
		
		  
		  	
			$("#txtFromDate").datepicker({ dateFormat: 'yy-mm-dd' });
			$("#txtFromDate" ).datepicker('setDate', POSDate);
			$("#txtFromDate").datepicker();
			
	        $("#txtToDate").datepicker({ dateFormat: 'yy-mm-dd' });
	        $("#txtToDate" ).datepicker('setDate', POSDate);
	        $("#txtToDate").datepicker();
	          
		$(".tab_content").hide();
		$(".tab_content:first").show();

		$("ul.tabs li").click(function() {
			$("ul.tabs li").removeClass("active");
			$(this).addClass("active");
			$(".tab_content").hide();

			var activeTab = $(this).attr("data-state");
			$("#" + activeTab).fadeIn();
		});
		
		  $("form").submit(function(event){
			  if($("#txtPromotionName").val().trim()=="")
				{
					alert("Please Enter Promotion Name");
					return false;
				}
			  
			 
			  else{
				  flg=funCallFormAction();
				  return flg;
			  } 
			});
		  
		    
		    $("#txtGetItemName").click(function() {
		        if ($("#cmbGetPromoOn").val()=="Item") {
		        	funOpenMenuItemSearch("getItem");
		        }else if ($("#cmbGetPromoOn").val()=="MenuHead") {
		        	funOpenMenuHeadSearch("getMenuHead");
		        }
		    });
			
		  
		    
		    
		    $("#txtPromoItemName").click(function() {
		        if ($("#cmbPromotionOn").val()=="Item") {
		        	funOpenMenuItemSearch("buyItem");
		        }else if ($("#cmbPromotionOn").val()=="MenuHead") {
		        	funOpenMenuHeadSearch("buyMenuHead");
		        }
		        else
		        	{
		        	$("#txtPromoItemName").val("");
		        	$("#txtPromoItemName").focus();
		        	}
		        	});
			
	});



	/**
	* Reset The Group Name TextField
	**/
	function funResetFields()
	{

		location.reload(true); 
    }
	
	
		/**
		* Open Help for Promotion
		**/
		function funHelp(searchName)
		{	  
			 field= searchName ;
				
	       window.open("searchform.html?formname="+searchName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	    }
		/**
		* Open Help for Menu Item
		**/
		
		function funOpenMenuItemSearch(transactionName)
		{
			field=transactionName;
	       	window.open("searchform.html?formname=POSMenuItemMaster&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	    }
		/**
		* Open Help for MenuHead
		**/
		function funOpenMenuHeadSearch(transactionName)
		{
			field=transactionName;
	       	window.open("searchform.html?formname=POSMenuHeadMaster&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	       	
	    }
		/**
		* Get and Set data from help file and load data Based on Selection Passing Value(Code)
		**/
		

		
		function funSetData(code)
		{
			switch(field)
			{
		case 'POSPromotionMaster' : 
			funSetPromotionData(code);
			break;
		case 'buyItem' : 
			funSetItemData(code);
			break;
		case 'buyMenuHead' : 
			funSetMenuHeadCode(code);
			
			break;
		case 'getItem' : 
			funSetItemData(code);
			break;
		case 'getMenuHead' :
			funSetMenuHeadCode(code);
			
			break;
		
		}
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
	alert("Data Saved \n\n" + message);
<%}
			}%>
	});

	/**
	 * Ready Function for Time
	 */
	function funBtnAddOnClick() {

		if (($("#cmbHH").val() == "HH") || ($("#cmbMM").val() == "MM")
				|| ($("#cmbS").val() == "S")) {
			alert("Invalid From Time");

			return false;
		} else if (($("#cmbToHH").val() == "HH")
				|| ($("#cmbToMM").val() == "MM") || ($("#cmbToS").val() == "S")) {
			alert("Invalid To Time");

			return false;
		}

		else {
			funFillTblTime();
		}

	}

	function funSetMenuHeadCode(code) {
		$("#txtMenuHeadCode").val(code);
		var searchurl = getContextPath()
				+ "/loadPOSMenuHeadMasterData.html?POSMenuHeadCode=" + code;
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",
			success : function(response) {
				if (field == "buyMenuHead") {
					$("#txtPromoItemCode").val(response.strMenuHeadCode);
					$("#txtPromoItemName").val(response.strMenuHeadName);
				}
				if (field == "getMenuHead") {
					$("#txtGetItemCode").val(response.strMenuHeadCode);
					$("#txtGetItemName").val(response.strMenuHeadName);
				}
				funFillMenuHeadData(code);
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
	function funSetItemData(code) {

		var searchurl = getContextPath() + "/loadItemCode.html?itemCode="
				+ code;
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",
			async : false,
			success : function(response) {
				if (field == "buyItem") {
					$("#txtPromoItemCode").val(response.strItemCode);
					$("#txtPromoItemName").val(response.strItemName);
				}
				if (field == "getItem") {
					$("#txtGetItemCode").val(response.strItemCode);
					$("#txtGetItemName").val(response.strItemName);
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

	function funFillMenuHeadData(code) {
		if (field == "buyMenuHead") {
			funRemoveTableRows("tblBuyItem");
		}

		else if (field == "getMenuHead") {
			funRemoveTableRows("tblGetItem");
		}
		var searchurl = getContextPath()
				+ "/loadMenuHeadDataForPromotion.html?menuCode=" + code;
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",

			success : function(response) {

				$.each(response, function(i, item) {
					if (field == "buyMenuHead") {

						funfillMenuHeadDtlGrid(item.strItemCode,
								item.strItemName, item.strRate, "tblBuyItem",
								null);
					}

					else if (field == "getMenuHead") {
						funfillMenuHeadDtlGrid(item.strItemCode,
								item.strItemName, item.strRate, "tblGetItem",
								null);
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

	function funSetMenuHeads(type, code, list) {

		var searchurl = getContextPath()
				+ "/loadMenuHeadDataForPromotion.html?menuCode=" + code;
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",

			success : function(response) {

				$.each(response, function(i, item) {
					if (type == "buyMenuHead") {

						funfillMenuHeadDtlGrid(item.strItemCode,
								item.strItemName, item.strRate, "tblBuyItem",
								list);
					}

					else if (type == "getMenuHead") {
						funfillMenuHeadDtlGrid(item.strItemCode,
								item.strItemName, item.strRate, "tblGetItem",
								list);
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

	function funSetPromotionData(code) {
		//funResetFields();
		$("#txtPromoCode").val(code);
		var searchurl = getContextPath()
				+ "/loadPromotionMasterData.html?promoCode=" + code;
		$
				.ajax({
					type : "GET",
					url : searchurl,
					dataType : "json",
					async : false,
					success : function(response) {
						if (response.strPromoCode == 'Invalid Code') {
							alert("Invalid Promo Code");
							$("#txtPromoCode").val('');
						} else {
							$("#txtPromotionName").val(response.strPromoName);
							$("#cmbPOSName").val(response.strPOSCode);
							$("#cmbArea").val(response.strAreaCode);
							$("#txtKOTTimeBound")
									.val(response.longKOTTimeBound);

							var fdate = response.dteFromDate.split(" ");
							$("#txtFromDate").val(fdate[0]);
							var tdate = response.dteToDate.split(" ");
							$("#txtToDate").val(tdate[0]);
							$("#cmbPromotionOn").val(response.strPromotionOn);
							$("#txtPromoItemName").val(
						response.strPromoItemName);

							$("#cmbType").val(response.strType);

							$("#cmbOperator").val(response.strOperator);

							$("#txtBuyQty").val(response.dblBuyQty);
							$("#txtPromoItemCode").val(
									response.strPromoItemCode);
							$("#cmbGetPromoOn").val(response.strGetPromoOn);
							$("#txtGetItemName").val(response.strGetItemName);
							$("#txtGetQty").val(response.dblGetQty);
							$("#cmbDiscountType").val(response.strDiscountType);
							$("#txtDiscount").val(response.dblDiscount);
							$("#txtGetItemCode").val(response.strGetItemCode);

							if (response.strPromotionOn == "MenuHead") {

								funRemoveTableRows("tblBuyItem");
								funSetMenuHeads("buyMenuHead",
										response.strPromoItemCode,
										response.listBuyPromotionDtl);

							}

							if (response.strGetPromoOn == "MenuHead") {

								funRemoveTableRows("tblGetItem");
								funSetMenuHeads("getMenuHead",
										response.strPromoItemCode,
										response.listGetPromotionDtl);
								var table = document
										.getElementById("tblGetItem");
								var rowCount = table.rows.length;

							}

							funRemoveTableRows("tblTime");
							var table = document.getElementById("tblTime");
							$
									.each(
											response.listPromotionDayTimeDtl,
											function(i, item) {
												var row = table.insertRow(i);

												row.insertCell(0).innerHTML = "<input class=\"Box\" name=\"listPromotionDayTimeDtl["
														+ (i)
														+ "].strDay\" size=\"30%\"  id=\"txtDay."
														+ (i)
														+ "\" value='"
														+ item.strDay
														+ "'onclick=\"funGetSelectedRowIndex(this)\"/>";
												row.insertCell(1).innerHTML = "<input class=\"Box\" name=\"listPromotionDayTimeDtl["
														+ (i)
														+ "].tmeFromTime\" size=\"40%\"  id=\"txtFromTime."
														+ (i)
														+ "\" value='"
														+ item.tmeFromTime
														+ "' onclick=\"funGetSelectedRowIndex(this)\"/>";
												row.insertCell(2).innerHTML = "<input class=\"Box\" name=\"listPromotionDayTimeDtl["
														+ (i)
														+ "].tmeToTime\" size=\"40%\"  id=\"txtToTime."
														+ (i)
														+ "\" value='"
														+ item.tmeToTime
														+ "'onclick=\"funGetSelectedRowIndex(this)\"/>";

											});

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

	function funfillMenuHeadDtlGrid(itemCode, itemName, rate, tblId, list) {
		var flag = false;
		var table = document.getElementById(tblId);
		var rowCount = table.rows.length;
		var row = table.insertRow(rowCount);
		if (tblId == "tblBuyItem") {
			row.insertCell(0).innerHTML = "<input type=\"hidden\" name=\"listBuyPromotionDtl["
					+ (rowCount)
					+ "].strItemCode\" class=\"Box \" size=\"1%\" id=\"txtItemCode."
					+ (rowCount) + "\" value='" + itemCode + "'>";
			row.insertCell(1).innerHTML = "<input name=\"listBuyPromotionDtl["
					+ (rowCount)
					+ "].strItemName\" readonly=\"readonly\" class=\"Box \" size=\"30%\" id=\"txtItemName."
					+ (rowCount) + "\" value='" + itemName + "'>";
			row.insertCell(2).innerHTML = "<input name=\"listBuyPromotionDtl["
					+ (rowCount)
					+ "].strRate\" readonly=\"readonly\" class=\"Box \" size=\"39%\" id=\"txtRate."
					+ (rowCount) + "\" value='" + rate + "'>";
			if (null != list) {
				$
						.each(
								list,
								function(i, item) {
									if (item.strItemCode == itemCode) {
										flag = true;
										row.insertCell(3).innerHTML = "<input type=\"checkbox\" name=\"listBuyPromotionDtl["
												+ (rowCount)
												+ "].strApplicableYN\" size=\"30%\" id=\"chkApplicable."
												+ (rowCount)
												+ "\" checked=\"checked\">";
									}
								});
			}
			if (!flag) {
				row.insertCell(3).innerHTML = "<input type=\"checkbox\" name=\"listBuyPromotionDtl["
						+ (rowCount)
						+ "].strApplicableYN\" size=\"30%\" id=\"chkApplicable."
						+ (rowCount) + "\" value='" + true + "'>";
			}
		} else if (tblId == "tblGetItem") {
			row.insertCell(0).innerHTML = "<input type=\"hidden\" name=\"listGetPromotionDtl["
					+ (rowCount)
					+ "].strItemCode\" class=\"Box \" size=\"1%\" id=\"txtItemCode."
					+ (rowCount) + "\" value='" + itemCode + "'>";
			row.insertCell(1).innerHTML = "<input name=\"listGetPromotionDtl["
					+ (rowCount)
					+ "].strItemName\" readonly=\"readonly\" class=\"Box \" size=\"30%\" id=\"txtItemName."
					+ (rowCount) + "\" value='" + itemName + "'>";
			row.insertCell(2).innerHTML = "<input name=\"listGetPromotionDtl["
					+ (rowCount)
					+ "].strRate\" readonly=\"readonly\" class=\"Box \" size=\"39%\" id=\"txtRate."
					+ (rowCount) + "\" value='" + rate + "'>";

			if (null != list) {
				$
						.each(
								list,
								function(i, item) {
									if (item.strItemCode == itemCode) {
										flag = true;
										row.insertCell(3).innerHTML = "<input type=\"checkbox\" name=\"listGetPromotionDtl["
												+ (rowCount)
												+ "].strApplicableYN\" size=\"30%\" id=\"chkApplicable."
												+ (rowCount)
												+ "\" checked=\"checked\">";
									}

								});
			}
			if (!flag) {
				row.insertCell(3).innerHTML = "<input type=\"checkbox\" name=\"listGetPromotionDtl["
						+ (rowCount)
						+ "].strApplicableYN\" size=\"30%\" id=\"chkApplicable."
						+ (rowCount) + "\" value='" + true + "'>";
			}

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

	function funGetSelectedRowIndex(obj) {
		var index = obj.parentNode.parentNode.rowIndex;
		var table = document.getElementById("tblTime");
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

	function funBtnRemoveOnClick() {
		var table = document.getElementById("tblTime");
		table.deleteRow(selectedRowIndex);

	}
	function funFillTblTime() {
		var days = [ 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday',
				'Friday', 'Saturday' ];
		var day = $("#cmbDay").val();
		var HH = $("#cmbHH").val();
		var MM = $("#cmbMM").val();
		var S = $("#cmbS").val();

		var fromTime = HH + ":" + MM + ":" + S;

		var toHH = $("#cmbToHH").val();
		var toMM = $("#cmbToMM").val();
		var toS = $("#cmbToS").val();

		var toTime = toHH + ":" + toMM + ":" + toS;
		var table = document.getElementById("tblTime");

		if (day != "All") {
			if (funCalculateTimeDifference())

			{

				if (funDuplicateRow(day, fromTime, toTime)) {
					var rowCount = table.rows.length;
					var row = table.insertRow(rowCount);

					row.insertCell(0).innerHTML = "<input class=\"Box\" name=\"listPromotionDayTimeDtl["
							+ (rowCount)
							+ "].strDay\" size=\"30%\"  id=\"txtDay."
							+ (rowCount)
							+ "\" value='"
							+ day
							+ "' onclick=\"funGetSelectedRowIndex(this)\"/>";
					row.insertCell(1).innerHTML = "<input class=\"Box\" name=\"listPromotionDayTimeDtl["
							+ (rowCount)
							+ "].tmeFromTime\" size=\"40%\"  id=\"txtFromTime."
							+ (rowCount)
							+ "\" value='"
							+ fromTime
							+ "'  onclick=\"funGetSelectedRowIndex(this)\"/>";
					 row.insertCell(2).innerHTML = "<input class=\"Box\" name=\"listPromotionDayTimeDtl["
							+ (rowCount)
							+ "].tmeToTime\" size=\"40%\"  id=\"txtToTime."
							+ (rowCount)
							+ "\" value='"
							+ toTime
							+ "' onclick=\"funGetSelectedRowIndex(this)\"/>"; 
							

					row.insertCell(3).innerHTML = "<input type=\"checkbox\" name=\"listPromotionDayTimeDtl["
							+ (rowCount)
							+ "].strSelect\" size=\"7%\" id=\"chkOperational."
							+ (rowCount)
							+ "\" value=''"
							+ false
							+ "' onclick=\"funGetSelectedRowIndex(this)\">";

				}
			}
		} else {
			if (funCalculateTimeDifference())

			{
				for (var i = 0; i < 7; i++) {
					if (funDuplicateRow(days[i], fromTime, toTime)) {
						var rowCount = table.rows.length;
						var row = table.insertRow(rowCount);

						row.insertCell(0).innerHTML = "<input class=\"Box\" name=\"listPromotionDayTimeDtl["
								+ (rowCount)
								+ "].strDay\" size=\"30%\"  id=\"txtDay."
								+ (rowCount)
								+ "\" value='"
								+ days[i]
								+ "' onclick=\"funGetSelectedRowIndex(this)\"/>";
						row.insertCell(1).innerHTML = "<input class=\"Box\" name=\"listPromotionDayTimeDtl["
								+ (rowCount)
								+ "].tmeFromTime\" size=\"40%\"  id=\"txtFromTime."
								+ (rowCount)
								+ "\" value='"
								+ fromTime
								+ "' onclick=\"funGetSelectedRowIndex(this)\"/>";
								
								
						 row.insertCell(2).innerHTML = "<input class=\"Box\" name=\"listPromotionDayTimeDtl["
								+ (rowCount)
								+ "].tmeToTime\" size=\"40%\"  id=\"txtToTime."
								+ (rowCount)
								+ "\" value='"
								+ toTime
								+ "' onclick=\"funGetSelectedRowIndex(this)\"/>"; 
						row.insertCell(3).innerHTML = "<input type=\"checkbox\" name=\"listPromotionDayTimeDtl["
								+ (rowCount)
								+ "].strSelect\" size=\"7%\" id=\"chkOperational."
								+ (rowCount)
								+ "\" value=''"
								+ false
								+ "' onclick=\"funGetSelectedRowIndex(this)\">";

					}
				}
			}
		}
	}

	function funCalculateTimeDifference() {
		var HH = parseInt($("#cmbHH").val());
		var MM = parseInt($("#cmbMM").val());

		var toHH = parseInt($("#cmbToHH").val());
		var toMM = parseInt($("#cmbToMM").val());

		if (toHH < HH) {
			alert("from Time must be less than To Time..!! ");
			return false;
		} else if (toHH == HH) {
			if (toMM <= MM) {
				alert("from Time must be less than To Time..!! ");
				return false;
			} else
				return true;
		} else
			return true;
	}
	function funDuplicateRow(day, fromTime, toTime) {

		var table = document.getElementById("tblTime");
		var rowCount = table.rows.length;
		var flag = true;
		if (rowCount > 0) {
			$('#tblTime tr').each(function() {
				if (day == $(this).find('input').val())// `this` is TR DOM element
				{

					if (fromTime == $(this).find('input').val())// `this` is TR DOM element
					{
						if (toTime == $(this).find('input').val())// `this` is TR DOM element
						{
							alert("Already added ");

							flag = false;
						}

					}
				}
			});
		}
		return flag;
	}

	function funCallFormAction() {
		var flg = true;

		var promoItemCode = $('#txtPromoItemCode').val();
		var promoCode = $('#txtPromoCode').val();
		var areaCode = $("#cmbArea").val();
		var posCode = $('#cmbPOSName').val();

		$.ajax({
			type : "GET",
			url : getContextPath()
					+ "/funCheckDuplicateBuyPromoItem.html?promoItemCode="
					+ promoItemCode + "&promoCode=" + promoCode + "&areaCode="
					+ areaCode + "&posCode=" + posCode,
			async : false,
			dataType : "json",
			success : function(response) {
				$('#txtPromoCode').val(response.promoCode);
				if (response.flag == true) {
					alert("Promotion is already defined On Buy Item");
					$('#txtPromoItemName').focus();
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

	function funResetDateTime() {
		funRemoveTableRows("tblTime");

		$("#cmbDay").val("All");
		$("#cmbHH").val("HH");
		$("#cmbMM").val("MM");
		$("#cmbS").val("S");
		$("#cmbAMPM").val("AM");

		$("#cmbToHH").val("HH");
		$("#cmbToMM").val("MM");
		$("#cmbToS").val("S");

		$("#cmbToAMPM").val("AM");
	}
</script>


</head>

<body>
	<div id="formHeading">
		<label>Promotion Master</label>
	</div>




	<s:form name="PromotionForm" method="POST"
		action="savePromotionMaster.html?saddr=${urlHits}"
		class="formoid-default-skyblue"
		style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:100%;min-width:10%;margin-top:1%;">


		<div style="width: 90%; margin-left: 8%;">

			<div class="row"
				style="background-color: #fff; display: block; margin-bottom: 10px; margin-left: 20px; float: left;">
				<div class="element-input col-lg-6"
					style="width: 15%; margin-top: 5px; margin-left: -2%">
					<label class="title">Promotion Code</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 13%; margin-left: -2%">
					<s:input id="txtPromoCode" path="strPromoCode"
						onclick="funHelp('POSPromotionMaster')" readonly="true" />
				</div>


				<div class="element-input col-lg-6"
					style="width: 13%; margin-left: 12%">
					<label class="title">Promotion Name</label>
				</div>
				<div class="element-input col-lg-6" style="width: 15%;">
					<s:input id="txtPromotionName" path="strPromoName"
						style="width: 100%;" />
				</div>

			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: -webkit-box;">
				<div class="element-input col-lg-6"
					style="width: 10%; margin-left: 1%">
					<label class="title">POS Name</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 15%; margin-left: 3%">
					<s:select id="cmbPOSName" path="strPOSCode" items="${posList}"
						style="width: 100%;" />
				</div>

				<div class="element-input col-lg-6"
					style="width: 13%; margin-left: 10%">
					<label class="title">From Date</label>
				</div>
				<div class="element-input col-lg-6" style="width: 15%;">
					<s:input id="txtFromDate" path="dteFromDate" style="width: 100%;" />
				</div>
				<div class="element-input col-lg-6"
					style="width: 15%; margin-left: 5%">
					<label class="title">To Date</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 16%; margin-left: -2%">
					<s:input id="txtToDate" path="dteToDate" style="width: 100%;" />
				</div>
			</div>




			<div class="row"
				style="background-color: #fff; display: -webkit-box;">
				<div class="element-input col-lg-6"
					style="width: 10%; margin-left: 1%">
					<label class="title">Area</label>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 15%; margin-left: 3%">
					<s:select id="cmbArea" path="strAreaCode" items="${areaList}"></s:select>
				</div>


				<div class="element-input col-lg-6"
					style="width: 12%; margin-left: 10%">
					<label class="title">Type</label>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 15%; margin-left: 1%">
					<s:select id="cmbType" path="strType">
						<option value="Limited">Limited</option>
						<option value="Unlimited">Unlimited</option>
					</s:select>

				</div>

				<div class="element-input col-lg-6"
					style="width: 15%; margin-top: 5px; margin-left: 5%">
					<label class="title">KOT Time Bound</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 15%; margin-left: -2%">
					<s:input id="txtKOTTimeBound" path="longKOTTimeBound" />
				</div>
			</div>
		</div>
		<div style="width: 100%; float: left;">


			<div id="tab_container" style="height: 21px;">
				<ul class="tabs">
					<li data-state="tab1"
						style="width: 10%; height: 25px; padding-left: 2%; border-radius: 4px;"
						class="active">Buy</li>
					<li data-state="tab2"
						style="width: 10%; height: 25px; padding-left: 3%; border-radius: 4px;">Get</li>
					<li data-state="tab3" id="t3"
						style="width: 10%; height: 25px; padding-left: 1%; border-radius: 4px;">Day
						& Time</li>
				</ul>

			</div>
		</div>

		<!-- Start of Buy tab
 -->
		<div id="tab1" class="tab_content">


			<div class="column" style="width: 50%;">

				<div class="row" style="margin-bottom: 10px; width: 5%;">

					<div class="element-input col-lg-6"
						style="margin-bottom: 10px; width: 35%;">
						<s:select id="cmbPromotionOn" path="strPromotionOn">
							<option value="Item">Item</option>
							<option value="MenuHead">MenuHead</option>
						</s:select>
					</div>
					<div class="element-input col-lg-6"
						style="width: 10%; margin-left: 2%">
						<s:input type="text" id="txtPromoItemName" path="strPromoItemName"
							ondblClick="funGetSelectedRowIndex(this)" />
					</div>
				</div>

				<div class="row"
					style="background-color: #fff; display: -webkit-box;">

					<div class="element-input col-lg-6"
						style="width: 5%; margin-left: 2%">
						<label class="title">Type</label>
					</div>


					<div class="element-input col-lg-6"
						style="margin-bottom: 10px; width: 18%; margin-left: 12%">
						<s:select id="cmbType" name="cmbType" path="strType">
							<option value="Quantity">Quantity</option>
							<option value="value">value</option>
						</s:select>
					</div>
				</div>

				<div class="row"
					style="background-color: #fff; display: -webkit-box;">
					<div class="element-input col-lg-6"
						style="width: 5%; margin-left: 2%">
						<label class="title">Is</label>
					</div>



					<div class="element-input col-lg-6"
						style="margin-bottom: 10px; width: 30%; margin-left: 12%">
						<s:select id="cmbOperator" name="cmbOperator" path="strOperator"
							style="width:30%;">
							<option value="=">=</option>
							<option value="<">&lt;</option>
							<option value=">">&gt;</option>
						</s:select>
					</div>

					<div class="element-input col-lg-6"
						style="width: 15%; margin-top: 5px; margin-left: -5%">
						<label class="title">Value</label>
					</div>
					<div class="element-input col-lg-6"
						style="width: 15%; margin-left: -2%">
						<s:input type="text" id="txtBuyQty" path="dblBuyQty" />
					</div>

				</div>


			</div>

			<div class="column"
				style="width: 50%; margin left: 170%; height: 200%;">
				<div
					style="border: 1px solid #ccc; display: block; height: 200px; overflow-x: hidden; overflow-y: scroll; width: 100%;">
					<table
						style="width: 100%; background-color:  #2FABE9;color: white border: 1px solid #ccc;">
						<thead>
							<tr>
								<td style="width: 36.5%;">Item Name</td>
								<td style="width: 36.5%;">Rate</td>
								<td style="width: 28%;">Select</td>
							</tr>
						</thead>
					</table>

					<table id="tblBuyItem" style="width: 100%;">
						<tbody style="border-top: none">

						</tbody>
					</table>
				</div>

			</div>




		</div>

		<div id="tab2" class="tab_content">


			<div class="column" style="width: 50%;">

				<div class="row" style="margin-bottom: 10px; width: 10%;">
					<div class="element-input col-lg-6"
						style="margin-bottom: 10px; width: 35%;">
						<s:select id="cmbGetPromoOn" path="strGetPromoOn">
							<option value="Item">Item</option>
							<option value="MenuHead">MenuHead</option>
							<option value="MenuHead">PromoGroup</option>

						</s:select>
					</div>

					<div class="element-input col-lg-6"
						style="width: 15%; margin-left: 2%">
						<s:input type="text" id="txtGetItemName" path="strGetItemName"
							readonly="true" />
					</div>
				</div>



				<div class="row"
					style="background-color: #fff; display: -webkit-box;">
					<div class="element-input col-lg-6"
						style="width: 15%; margin-left: 1%">
						<label class="title">Quantity</label>
					</div>

					<div class="element-input col-lg-6"
						style="width: 30%; margin-left: 4%">
						<s:input class="large" type="text" id="txtGetQty" path="dblGetQty"
							style="width: 100%;" />
					</div>

				</div>
				<div class="row"
					style="background-color: #fff; display: -webkit-box;">
					<div class="element-input col-lg-6"
						style="width: 15%; margin-left: 1%">
						<label class="title">Discount</label>
					</div>

					<!-- 	<div class="row"
						style="width: 15%; margin-top: 5px;">
						<label class="title">Discount</label>
					</div> -->
					<div class="element-input col-lg-6"
						style="width: 15%; margin-left: -2%">
						<s:select id="cmbDiscountType" path="strDiscountType">
							<option value="value">value</option>
							<option value="percent">percent</option>
						</s:select>
					</div>

					<div class="element-input col-lg-6" style="width: 30%;">
						<s:input class="large" type="text" id="txtGetItemCode"
							path="strGetItemCode" style="width: 100%;" />

					</div>

				</div>

			</div>

			<div class="column"
				style="width: 50%; margin left: 170%; height: 100%">
				<div
					style="border: 1px solid #ccc; display: block; overflow-x: hidden; overflow-y: scroll; width: 100%;height: 200px">
					<table
						style="width: 100%; background: #2FABE9; color: white; ; border: 1px solid #ccc;">
						<thead style=" background: #2FABE9;">
							<tr>
								<td style="width: 36.5%; background: #2FABE9;">Item Name</td>
								<td style="width: 36.5%;">Rate</td>
								<td style="width: 28%;">Select</td>
							</tr>
						</thead>
					</table>

					<table id="tblGetItem" style="width: 100%;">
						<tbody style="border-top: none">

						</tbody>
					</table>
				</div>

			</div>




		</div>
		<div id="tab3" class="tab_content">


			<div class="row"
				style="background-color: #fff; display: inline-flex;">



				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 15%;margin-left: 2%">
					<select id="cmbDay" name="cmbDay">

						<option value="All">All</option>
						<option value="Sunday">Sunday</option>
						<option value="Monday">Monday</option>
						<option value="Tuesday">Tuesday</option>
						<option value="Wednesday">Wednesday</option>
						<option value="Thursday">Thursday</option>
						<option value="Friday">Friday</option>
						<option value="Satureday">Saturday</option>

					</select>
				</div>
				<div class="element-input col-lg-6" style="width: 20%; margin-left: 10%">
					<label class="title">From Time</label>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 10%;">
					<s:select id="cmbHH" path="">
						<option value="HH">HH</option>
						<option value="1">1</option>
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
					</s:select>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 10%;">
					<s:select id="cmbMM" path="">
						<option value="MM">MM</option>
						<option value="00">00</option>
						<option value="01">01</option>
						<option value="02">02</option>
						<option value="03">03</option>
						<option value="04">04</option>
						<option value="05">05</option>
						<option value="06">06</option>
						<option value="07">07</option>
						<option value="08">08</option>
						<option value="09">09</option>
						<option value="10">10</option>
						<option value="11">11</option>
						<option value="12">12</option>
						<option value="13">13</option>
						<option value="14">14</option>
						<option value="15">15</option>
						<option value="16">16</option>
						<option value="17">17</option>
						<option value="18">18</option>
						<option value="19">19</option>
						<option value="20">20</option>
						<option value="21">21</option>
						<option value="22">22</option>
						<option value="23">23</option>
						<option value="24">24</option>
						<option value="25">25</option>
						<option value="26">26</option>
						<option value="27">27</option>
						<option value="28">28</option>
						<option value="29">29</option>
						<option value="30">30</option>
						<option value="31">31</option>
						<option value="32">32</option>
						<option value="33">33</option>
						<option value="34">34</option>
						<option value="35">35</option>
						<option value="36">36</option>
						<option value="37">37</option>
						<option value="38">38</option>
						<option value="39">39</option>
						<option value="41">41</option>
						<option value="42">42</option>
						<option value="43">43</option>
						<option value="44">44</option>
						<option value="45">45</option>
						<option value="46">46</option>
						<option value="47">47</option>
						<option value="48">48</option>
						<option value="49">49</option>
						<option value="50">50</option>
						<option value="51">51</option>
						<option value="52">52</option>
						<option value="53">53</option>
						<option value="54">54</option>
						<option value="55">55</option>
						<option value="56">56</option>
						<option value="57">57</option>
						<option value="58">58</option>
						<option value="59">59</option>
					</s:select>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 10%;">
					<s:select id="cmbS" path="">
						<option value="SS">SS</option>
						<option value="00">00</option>
						<option value="01">01</option>
						<option value="02">02</option>
						<option value="03">03</option>
						<option value="04">04</option>
						<option value="05">05</option>
						<option value="06">06</option>
						<option value="07">07</option>
						<option value="08">08</option>
						<option value="09">09</option>
						<option value="10">10</option>
						<option value="11">11</option>
						<option value="12">12</option>
						<option value="13">13</option>
						<option value="14">14</option>
						<option value="15">15</option>
						<option value="16">16</option>
						<option value="17">17</option>
						<option value="18">18</option>
						<option value="19">19</option>
						<option value="20">20</option>
						<option value="21">21</option>
						<option value="22">22</option>
						<option value="23">23</option>
						<option value="24">24</option>
						<option value="25">25</option>
						<option value="26">26</option>
						<option value="27">27</option>
						<option value="28">28</option>
						<option value="29">29</option>
						<option value="30">30</option>
						<option value="31">31</option>
						<option value="32">32</option>
						<option value="33">33</option>
						<option value="34">34</option>
						<option value="35">35</option>
						<option value="36">36</option>
						<option value="37">37</option>
						<option value="38">38</option>
						<option value="39">39</option>
						<option value="41">41</option>
						<option value="42">42</option>
						<option value="43">43</option>
						<option value="44">44</option>
						<option value="45">45</option>
						<option value="46">46</option>
						<option value="47">47</option>
						<option value="48">48</option>
						<option value="49">49</option>
						<option value="50">50</option>
						<option value="51">51</option>
						<option value="52">52</option>
						<option value="53">53</option>
						<option value="54">54</option>
						<option value="55">55</option>
						<option value="56">56</option>
						<option value="57">57</option>
						<option value="58">58</option>
						<option value="59">59</option>
					</s:select>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 10%;">
					<s:select id="cmbAMPM" path="">
						<option value="AM">AM</option>
						<option value="PM">PM</option>
					</s:select>
				</div>



				<div class="element-input col-lg-6" style="width: 20%;margin-left: 2%">
					<label class="title">To Time</label>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 10%;">
					<s:select id="cmbToHH" path="">
						<option value="HH">HH</option>
						<option value="1">1</option>
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
					</s:select>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 10%;">
					<s:select id="cmbToMM" path="">
						<option value="MM">MM</option>
						<option value="00">00</option>
						<option value="01">01</option>
						<option value="02">02</option>
						<option value="03">03</option>
						<option value="04">04</option>
						<option value="05">05</option>
						<option value="06">06</option>
						<option value="07">07</option>
						<option value="08">08</option>
						<option value="09">09</option>
						<option value="10">10</option>
						<option value="11">11</option>
						<option value="12">12</option>
						<option value="13">13</option>
						<option value="14">14</option>
						<option value="15">15</option>
						<option value="16">16</option>
						<option value="17">17</option>
						<option value="18">18</option>
						<option value="19">19</option>
						<option value="20">20</option>
						<option value="21">21</option>
						<option value="22">22</option>
						<option value="23">23</option>
						<option value="24">24</option>
						<option value="25">25</option>
						<option value="26">26</option>
						<option value="27">27</option>
						<option value="28">28</option>
						<option value="29">29</option>
						<option value="30">30</option>
						<option value="31">31</option>
						<option value="32">32</option>
						<option value="33">33</option>
						<option value="34">34</option>
						<option value="35">35</option>
						<option value="36">36</option>
						<option value="37">37</option>
						<option value="38">38</option>
						<option value="39">39</option>
						<option value="41">41</option>
						<option value="42">42</option>
						<option value="43">43</option>
						<option value="44">44</option>
						<option value="45">45</option>
						<option value="46">46</option>
						<option value="47">47</option>
						<option value="48">48</option>
						<option value="49">49</option>
						<option value="50">50</option>
						<option value="51">51</option>
						<option value="52">52</option>
						<option value="53">53</option>
						<option value="54">54</option>
						<option value="55">55</option>
						<option value="56">56</option>
						<option value="57">57</option>
						<option value="58">58</option>
						<option value="59">59</option>
					</s:select>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 10%;">
					<s:select id="cmbToS" path="">
						<option value="MM">SS</option>
						<option value="00">00</option>
						<option value="01">01</option>
						<option value="02">02</option>
						<option value="03">03</option>
						<option value="04">04</option>
						<option value="05">05</option>
						<option value="06">06</option>
						<option value="07">07</option>
						<option value="08">08</option>
						<option value="09">09</option>
						<option value="10">10</option>
						<option value="11">11</option>
						<option value="12">12</option>
						<option value="13">13</option>
						<option value="14">14</option>
						<option value="15">15</option>
						<option value="16">16</option>
						<option value="17">17</option>
						<option value="18">18</option>
						<option value="19">19</option>
						<option value="20">20</option>
						<option value="21">21</option>
						<option value="22">22</option>
						<option value="23">23</option>
						<option value="24">24</option>
						<option value="25">25</option>
						<option value="26">26</option>
						<option value="27">27</option>
						<option value="28">28</option>
						<option value="29">29</option>
						<option value="30">30</option>
						<option value="31">31</option>
						<option value="32">32</option>
						<option value="33">33</option>
						<option value="34">34</option>
						<option value="35">35</option>
						<option value="36">36</option>
						<option value="37">37</option>
						<option value="38">38</option>
						<option value="39">39</option>
						<option value="41">41</option>
						<option value="42">42</option>
						<option value="43">43</option>
						<option value="44">44</option>
						<option value="45">45</option>
						<option value="46">46</option>
						<option value="47">47</option>
						<option value="48">48</option>
						<option value="49">49</option>
						<option value="50">50</option>
						<option value="51">51</option>
						<option value="52">52</option>
						<option value="53">53</option>
						<option value="54">54</option>
						<option value="55">55</option>
						<option value="56">56</option>
						<option value="57">57</option>
						<option value="58">58</option>
						<option value="59">59</option>
					</s:select>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 10%;">
					<s:select id="cmbToAMPM" path="">
						<option value="AM">AM</option>
						<option value="PM">PM</option>
					</s:select>
				</div>
			</div>

			<div class="col-lg-10 col-sm-10 col-xs-10"
				style="width: 60%; margin-left: 12%">
				<p align="center">
				<div class="submit col-lg-4 col-sm-4 col-xs-4">
					<input type="submit" value="ADD"
						style="margin-top: 25%; margin-left: 60%"
						onclick="return funBtnAddOnClick();" />
				</div>
				<div class="submit col-lg-4 col-sm-4 col-xs-4">
					<input type="submit" value="REMOVE"
						style="margin-top: 25%; margin-left: 60%"
						onclick="return funBtnRemoveOnClick();" />
				</div>

				<div class="submit col-lg-4 col-sm-4 col-xs-4">
					<input type="reset" value="RESET"
						style="margin-top: 25%; margin-left: 70%"
						onclick="funResetDateTime()">
				</div>
				</p>
			</div>


			<div
				style="border: 1px solid #ccc; display: block; height: 150px; overflow-x: hidden; overflow-y: scroll; width: 100%;">
				<table
					style="width: 100%; background-color: #fff; border: 1px solid #ccc;">
					<thead>
						<tr>
							<td style="width: 36.5%;">Day</td>
							<td style="width: 36.5%;">From Time</td>
							<td style="width: 28%;">To Time</td>
							<td style="width: 28%;">Select</td>

						</tr>
					</thead>
				</table>

				<table id="tblTime" style="width: 100%;">
					<tbody style="border-top: none">

					</tbody>
				</table>
			</div>



		</div>
		<div class="row" style="background-color: #fff; width: 100%">
			<div class="element-input col-lg-6">
				<label class="title">Promotion Note</label>
			</div>
			<div class="element-input col-lg-6"
				style="margin-bottom: 10px; width: 120%">
				<s:input class="large" colspan="3" type="text" id="txtPromoNote"
					path="strPromoNote" />
			</div>
		</div>

		<div class="col-lg-10 col-sm-10 col-xs-10" style="width: 60%;">
			<p align="center">
			<div class="submit col-lg-4 col-sm-4 col-xs-4">
				<input type="submit" value="SUBMIT"
					style="margin-top: 30%; margin-left: 215%" />
			</div>

			<div class="submit col-lg-4 col-sm-4 col-xs-4">
				<input type="reset" value="RESET"
					style="margin-top: 30%; margin-left: 170%"
					onclick="funResetFields()">
			</div>
			</p>
		</div>

	</s:form>