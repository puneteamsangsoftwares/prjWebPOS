<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Gift Master</title>
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

$(document).ready(function () {
	  $('input#txtGiftVoucherCode').mlKeyboard({layout: 'en_US'});
	  $('input#txtGiftVoucherName').mlKeyboard({layout: 'en_US'});
	  
	  $("form").submit(function(event){
		  if($("#txtGiftVoucherName").val().trim()=="")
			{
				alert("Please Enter Gift Voucher Name");
				return false;
			}
		  else{
			  flg=funCallFormAction();
			  return flg;
		  }
		});
	  
	  
	  
	  
	  var gEnableShiftYN="${gEnableShiftYN}";
		var POSDate="${gPOSDate}";
 		 var startDate="${gPOSDate}";
	  	var Date = startDate.split(" ");
		var arr = Date[0].split("-");
		Dat=arr[2]+"-"+arr[1]+"-"+arr[0];	
	 			$("#txtValidForm" ).datepicker({ dateFormat: 'dd-mm-yy' });		
		$("#txtValidForm" ).datepicker('setDate', Dat); 
		$("#txtValidTo").datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtValidTo" ).datepicker('setDate', Dat);  
		
		
	}); 
/**
* Open Help
**/
function funHelp(transactionName)
{	       
   window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
}



	/**
	* Reset  Form
	**/
	function funResetFields()
	{
		$("#txtGiftVoucherName").focus();
		
    }
	
	/**
	* Get and Set data from help file and load data Based on Selection Passing Value(Gift Voucher Code)
	**/
	function funSetData(code)
	{
		$("#txtGiftVoucherCode").val(code);
		var searchurl=getContextPath()+"/loadPOSGiftVoucherMasterData.html?POSGiftVoucherCode="+code;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strGiftVoucherCode=='Invalid Code')
			        	{
			        		alert("Invalid Gift Voucher Code");
			        		$("#txtGiftVoucherCode").val('');
			        	}
			        	else
			        	{
				        	$("#txtGiftVoucherCode").val(response.strGiftVoucherCode);
				        	$("#txtGiftVoucherName").val(response.strGiftVoucherName);
				        	$("#txtSeries").val(response.strGiftVoucherSeries);
				        	$("#txtGiftValue").val(response.strGiftVoucherValueType);
				        	$("#cmbGiftVoucher").val(response.strVoucherValue);
							$("#txtTotalfGiftVouchersName").val(response.intTotalGiftVouchers);
							$("#txtStartNo").val(response.intGiftVoucherStartNo);
				        	$("#txtEndNo").val(response.intGiftVoucherEndNo);
				        	$("#txtValidForm").val(response.dteValidFrom);
							$("#txtValidForm").val(response.dteValidFrom);
				        	$("#txtValidTo").val(response.dteValidTo);

				        	$("#txtgiftVoucherName").focus();
				        	
				        	
				        	//$("#cmbPOSName").val(response.strPOSName);
				        	
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
	 * Success Message After Saving Record
	 **/
	$(document)
			.ready(
					function() {
						var message = '';
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
	 *  Check Validation Before Saving Record
	 **/

	function funCallFormAction() {
		var flg = true;

		var name = $('#txtGiftVoucherName').val();
		var code = $('#txtGiftVoucherCode').val();

		$.ajax({
			type : "GET",
			url : getContextPath()
					+ "/checkGiftVoucherName.html?giftVoucherName=" + name
					+ "&giftVoucherCode=" + code,
			async : false,
			dataType : "text",
			success : function(response) {
				if (response == "false") {
					alert("GiftVoucher Name Already Exist!");
					$('#txtGiftVoucherName').focus();
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

	function funHelp(transactionName)

	{
		fieldName = transactionName;
		// window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
		window.open("searchform.html?formname=" + transactionName
				+ "&searchText=", "",
				"dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	}
</script>
</head>

<body>
	<div id="formHeading">
		<label>Gift Voucher</label>
	</div>
	<s:form name="GiftVoucherForm" method="POST"
		action="savePOSGiftVoucherMaster.html" class="formoid-default-skyblue"
		style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:100%;min-width:150px;margin-top:2%;">

		<br />
		<br />

		<div class="title" style="margin-left: 5%;">

			<div class="row"
				style="background-color: #fff; display: -webkit-box;">
				<div class="element-input col-lg-6" style="width: 20%;">
					<label class="title">Gift Voucher Code </label>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 15%;">
					<s:input class="large" colspan="3" type="text"
						id="txtGiftVoucherCode" path="strGiftVoucherCode"
						ondblclick="funHelp('POSGiftVoucherMaster')" readonly="true" />
				</div>
			</div>

			<div class="row"
				style="background-color: #fff; display: -webkit-box;">
				<div class="element-input col-lg-6" style="width: 20%;">
					<label class="title">Gift Voucher Name</label>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 15%;">
					<s:input class="large" colspan="3" type="text"
						id="txtGiftVoucherName" path="strGiftVoucherName" />
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; display: -webkit-box;">

				<div class="element-input col-lg-6" style="width: 20%;">
					<label class="title">Series Code</label>
				</div>
				<div class="element-input col-lg-6" style="width: 15%;">
					<s:input class="large" colspan="3" type="text" id="txtSeries"
						path="strGiftVoucherSeries"
						style="margin-bottom:  10px; width: 100%;" />
				</div>
				<div class="element-input col-lg-6" style="width: 10%;">
					<label class="title">Start No</label>
				</div>
				<div class="element-input col-lg-6" style="width: 10%;">
					<s:input class="large" colspan="3" type="text" id="txtStartNo"
						path="intGiftVoucherStartNo"
						style="margin-bottom:  10px; width: 100%;" />
				</div>
				<div class="element-input col-lg-6" style="width: 10%;">
					<label class="title">End No</label>
				</div>
				<div class="element-input col-lg-6" style="width: 10%;">
					<s:input class="large" colspan="3" type="text" id="txtEndNo"
						path="intGiftVoucherEndNo" style="height: 10%; width: 100%;" />
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; display: -webkit-box;">
				<div class="element-input col-lg-6" style="width: 20%;">
					<label class="title">No of Voucher</label>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 15%;">
					<s:input class="large" colspan="3" type="text"
						id="txtTotalfGiftVouchersName" path="intTotalGiftVouchers"
						style="height: 10%; width: 100%;" />
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; display: -webkit-box;">
				<div class="element-input col-lg-6" style="width: 20%;">
					<label class="title">Gift Voucher Value</label>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 15%;">
					<s:select id="cmbGiftVoucher" name="cmbGiftVoucher"
						path="strVoucherValue">
						<option value="Value">Percentage</option>
						<option value="Discount%">Amount</option>
					</s:select>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 30%;">
					<s:input tid="txtGiftValue" required="required"
						path="strGiftVoucherValueType" />
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; display: -webkit-box;">
				<div class="element-input col-lg-6" style="width: 20%;">
					<label class="title">Valid From</label>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 15%;">
					<s:input id="txtValidForm" path="dteValidFrom"
						pattern="\d{1,2}-\d{1,2}-\d{4}" />
				</div>
				<div class="element-input col-lg-6" style="width: 8%;">
					<label class="title">Valid To</label>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 15%;">
					<s:input id="txtValidTo" required="required" path="dteValidTo"
						pattern="\d{1,2}-\d{1,2}-\d{4}" />
				</div>
			</div>
			<br />

			<div class="col-lg-10 col-sm-10 col-xs-10"
				style="width: 100%; margin-left: 15%;">
				<p align="center">
				<div class="submit col-lg-4 col-sm-4 col-xs-4">
					<input type="submit" value="SUBMIT" style="margin-left: -40%" />
				</div>

				<div class="submit col-lg-4 col-sm-4 col-xs-4">
					<input type="reset" value="RESET" onclick="funResetFields()"
						style="margin-left: -75%">
				</div>
				</p>
			</div>

		</div>





	</s:form>

</body>
</html>