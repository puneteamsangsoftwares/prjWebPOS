<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Princing Master</title>
<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/jquery-confirm.min.css"/>"/>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery-confirm.min.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/confirm-prompt.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery.autocomplete.min.js"/>"></script>
<script type="text/javascript">
	var fieldName;
	var mapItemCodeName=new Map();
	$(document).ready(function() {
		
		
	
	  	$("#txtToDate").datepicker({ dateFormat: 'yy-mm-dd' });
		$("#txtToDate" ).datepicker('setDate', 'today');
		$("#txtToDate").datepicker();
		
        $("#txtFromDate").datepicker({ dateFormat: 'yy-mm-dd' });
        $("#txtFromDate" ).datepicker('setDate', 'today');
        $("#txtFromDate").datepicker();
            

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
		  if($("#txtItemName").val().trim()=="")
			{
			  confirmDialog("Please Enter Item Name","");
				return false;
			}
		  if($("#txtCostCenterCode").val().trim()=="")
			{
			  confirmDialog("Please Select Cost Center","");
				return false;
			}
		 
		});
	
	$('#txtItemName').autocomplete({
			serviceUrl: '${pageContext.request.contextPath}/getAutoSearchData.html?formname=itemName',  
			paramName: "searchBy",
			delimiter: ",",
		    transformResult: function(response) {
		    	mapItemCodeName=new Map();
			return {
			  //must convert json to javascript object before process
			  suggestions: $.map($.parseJSON(response), function(item) {
			       // strValue  strCode
			        mapItemCodeName.set(item.strValue,item.strCode);
			      	return { value: item.strValue, data: item.strCode };
			   })
			            
			 };
			        
	        }
		 });
	 
		$('#txtItemName').blur(function() {
				var code=mapItemCodeName.get($('#txtItemName').val());
				if(code!='' && code!=null){
					funSetDataToCreateItemPrice(code);	
				}
				
		});
	
	
});


	
	function funCheckDuplicatePricing()
	{
		var isDuplicate=false;
		
		var itemCode=$("#txtItemCode").val();
		var posCode=$("#txtPosCode").val();
		var areaCode=$("#txtAreaCode").val();
		var hourlyPricing=$("#txtHourlyPricing").prop('checked');
		
		var searchurl=getContextPath()+"/checkDuplicateItemPricing.html?itemCode="+itemCode+"&posCode="+posCode+"&areaCode="+areaCode+"&hourlyPricing="+hourlyPricing+"";
		
		 $.ajax({
		        type: "GET",
		        url: searchurl,
		        async: false,		        
		        dataType: "json",
		        success: function(response)
		        {			        	
		        		if(response)
		        		{
		        			alert("Price Already Created.");
		        			isDuplicate=false;
		        		}
		        		else
		        		{
		        			isDuplicate=true;
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
		 		
		 return isDuplicate;
	}
		
	function funOnSubmitValidation()
	{
		var submit=false;	
		
		var itemCode=$("#txtItemCode").val();
		if(itemCode=="")
		{
			submit=false;
			confirmDialog("Please Select Item Code","");
		}		
		else if(fieldName=="POSMenuItemPricingMaster")
		{
			submit=true;
		}
		else if(fieldName=="POSMenuItemMaster" || $("longPricingId").val()==undefined || $("longPricingId").val()=="")
		{
			var submit2=funCheckDuplicatePricing();
			
			submit=submit2;
		}
		
		return submit;
	}
	
	$(function()
	{
		$("#txtPriceSunday").keydown(function (e)
		{
			if (e.which == 9)
			{
				var priceSunday=$("#txtPriceSunday").val();
				$("#txtPriceMonday").val(priceSunday);				
				$("#txtPriceTuesday").val(priceSunday);
				$("#txtPriceWednesday").val(priceSunday);
				$("#txtPriceThursday").val(priceSunday);
				$("#txtPriceFriday").val(priceSunday);
				$("#txtPriceSaturday").val(priceSunday);
			}
		});
	});
	

	//Apply Validation on Number TextFiled
	function funApplyNumberValidation() 
	{
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
	
	
	
	function funDisableHourlyPricing(flag) 
	{
		$("#txtTimeFrom").prop("disabled", !flag);
		$("#txtTimeTo").prop("disabled", !flag);
		if(flag)
		{
			$('#txtTimeFrom').timepicker('setTime', new Date());
			$('#txtTimeTo').timepicker('setTime', new Date());  
		}
		else
		{
			$("#txtTimeFrom").val("");
			$("#txtTimeTo").val("");
		}
	} 
		
	function funSetCityCode(code)
	{

		$.ajax({
			type : "POST",
			url : getContextPath()+ "/loadWSCityCode.html?docCode=" + code,
			dataType : "json",
			success : function(response)
			{
	        	if(response.strCityCode=='Invalid Code')
	        	{
	        		confirmDialog("Invalid City Code","");
	        		$("#txtCityCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtCityCode").val(code);
		        	$("#txtCityName").val(response.strCityName);
		        	funSetStateCode(response.strStateCode);
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

	//set popular  Y/N
	function funPopularClicked()
	{
		var popularTF=$("#txtPopular").prop('checked');				
	}
	   					
	//set Hourly Pricing  Y/N
	function funHourlyPricingClicked()
	{
		var hourlyPricingYN=$("#txtHourlyPricing").prop('checked');
		
		funDisableHourlyPricing(hourlyPricingYN);
	}

	

	function funSetDataToCreateItemPrice(itemCode)
	{
		$("#txtItemCode").val(itemCode);
		var searchurl=getContextPath()+"/loadDataToCreateItemPrice.html?itemCode="+itemCode;
		 $.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strItemCode=='Invalid Code')
		        	{
		        		confirmDialog("Invalid Item Code Code","");
		        		$("#txtItemCode").val('');
		        	}
		        	else
		        	{
		        	
		        		$("#txtItemCode").val(response.strItemCode);			        	
			        	$("#txtItemName").val(response.strItemName);
			        	
			        	$("#txtItemName").focus();			        				        
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
	
	function funSetDataToUpdateItemPrice(longPricingId)
	{
		
		var searchurl=getContextPath()+"/loadDataToUpdateItemPrice.html?longPricingId="+longPricingId;
		 $.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strItemCode=='Invalid Code')
		        	{
		        		alert("Invalid Item Code Code");
		        		$("#txtItemCode").val('');
		        	}
		        	else
		        	{
		        	
		        		$("#txtItemCode").val(response.strItemCode);			        	
			        	$("#txtItemName").val(response.strItemName);
			        	$("#txtItemName").focus();	
			        	$("#txt").val(response.strItemName);
			        	$("#txtPosCode").val(response.strPosCode);
			        	$("#txtMenuCode").val(response.strMenuCode);
			        	$("#txtSubMenuHeadCode").val(response.strSubMenuHeadCode);
			        	$("#txtAreaCode").val(response.strAreaCode);
			        	$("#txtCostCenterCode").val(response.strCostCenterCode);
			        	$("#txtTextColor").val(response.strTextColor);
			        	$("#txtPopular").prop('checked',response.strPopular);			        	
			        	$("#txtFromDate" ).val(response.dteFromDate);
			        	$("#txtToDate").val(response.dteToDate);
			        	$("#txtHourlyPricing").prop('checked',response.strHourlyPricing);
			        	
			        	if(response.strHourlyPricing)
			        	{
			        		$("#txtTimeFrom").prop("disabled", !response.strHourlyPricing);
				    		$("#txtTimeTo").prop("disabled", !response.strHourlyPricing);
				    						    			
				    		$('#txtTimeFrom').val(response.tmeTimeFrom+":"+response.strAMPMFrom);
			    			$('#txtTimeTo').val(response.tmeTimeTo+":"+response.strAMPMTo);
			        	}
			        	else
			        	{
			        		$("#txtTimeFrom").val("");
			    			$("#txtTimeTo").val("");
			        	}
			        	
			        	$("#txtPriceMonday").val(response.strPriceMonday);				
						$("#txtPriceTuesday").val(response.strPriceTuesday);
						$("#txtPriceWednesday").val(response.strPriceWednesday);
						$("#txtPriceThursday").val(response.strPriceThursday);
						$("#txtPriceFriday").val(response.strPriceFriday);
						$("#txtPriceSaturday").val(response.strPriceSaturday);
						$("#txtPriceSunday").val(response.strPriceSunday);
						$("#longPricingId").val(response.longPricingId);
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
				confirmDialog("Data Saved Successfully\n\n" + message);
<%}
			}%>
	});

	function funSetData(code) {

		switch (fieldName) {

		case 'POSMenuItemMaster':
			funSetDataToCreateItemPrice(code);
			break;

		case 'POSMenuItemPricingMaster':
			funSetDataToUpdateItemPrice(code);
			break;
		}

	}

	function funHelp(transactionName) {
		fieldName = transactionName;
		/* window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;"); */
		window
				.open("searchform.html?formname=" + transactionName
						+ "&searchText=", "",
						"dialoHeight:600px;dialogWidth:600px;dialogLeft:400px;modal:yes");
	}
</script>

</head>
<body>

	<div id="formHeading">
		<label>Pricing Master</label>
	</div>

	<br />
	<br />

	<s:form name="PricingMaster" method="POST"
		action="savePricingMaster.html" class="formoid-default-skyblue"
		style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:100%;min-width:150px;margin-top:2%;">

		<div class="title">

			<div class="row"
				style="background-color: #fff; display: -webkit-box;">
				<div class="element-input col-lg-6"
					style="width: 12%; margin-left: 5%">
					<label class="title">Item Code</label>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 20%; margin-left: -2%">
					<s:input class="large" type="text" id="txtItemCode"
						path="strItemCode" ondblclick="funHelp('POSMenuItemMaster')"
						style="width: 60%;" readonly="true" />
					<s:input type="hidden" id="longPricingId" path="longPricingId" />
					<input id="btnUpdateItemPrice" type="button" value="..."
						onclick="funHelp('POSMenuItemPricingMaster');"
						style="width: 30%; margin-left: 8%" />
				</div>

				<div class="element-input col-lg-6"
					style="width: 12%; margin-left: 0%">
					<label class="title">Item Name</label>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 20%;">
					<s:input class="large" type="text" id="txtItemName"
						path="strItemName"  />
				</div>

				<div class="element-input col-lg-6" style="width: 12%;">
					<label class="title">Item Color</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:select id="txtTextColor" path="strTextColor"
						items="${mapColours}"></s:select>
				</div>
			</div>

			<div class="row"
				style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
				<div class="element-input col-lg-6"
					style="width: 12%; margin-left: 5%">
					<label class="title">POS</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 20%; margin-left: -2%">
					<s:select id="txtPosCode" path="strPosCode" items="${mapPOSName}"></s:select>
				</div>
				<div class="element-input col-lg-6" style="width: 12%;">
					<label class="title">Menu Head</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:select id="txtMenuCode" path="strMenuCode"
						items="${mapMenuHeadName}"></s:select>
				</div>
				<div class="element-input col-lg-6" style="width: 12%;">
					<label class="title">Sub Menu Head</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:select id="txtSubMenuHeadCode" path="strSubMenuHeadCode"
						items="${mapSubMenuHeadName}"></s:select>
				</div>
			</div>

			<div class="row"
				style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
				<div class="element-input col-lg-6"
					style="width: 12%; margin-left: 5%">
					<label class="title">Area</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 20%; margin-left: -2%">
					<s:select id="txtAreaCode" path="strAreaCode"
						items="${mapAreaName}"></s:select>
				</div>

				<div class="element-input col-lg-6" style="width: 14%;">
					<label class="title">Hourly Pricing</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 20%; margin-left: -16px;">
					<s:checkbox id="txtHourlyPricing" path="strHourlyPricing"
						onclick="funHourlyPricingClicked()" />
				</div>
				<%-- <div class="element-input col-lg-6" style="width: 12%;"> 
    				<label class="title">Cost Center</label>
    			</div>
    			<div class="element-input col-lg-6" style="width: 20%;"> 
    				<s:select id="txtCostCenterCode" path="strCostCenterCode" items="${mapCostCenterName}"></s:select>
    			</div> --%>

			</div>

			<div class="row"
				style="background-color: #fff; display: -webkit-box; margin-bottom: 10px; margin-left: 4%">

				<div class="element-input col-lg-6" style="width: 12%;">
					<label class="title">From Date</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 20%; margin-left: -2%">
					<s:input type="text" id="txtFromDate" path="dteFromDate"
						style="width: 100%; " />
				</div>
				<div class="element-input col-lg-6" style="width: 12%;">
					<label class="title">To Date</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:input type="text" id="txtToDate" path="dteToDate"
						style="width: 100%;" />
				</div>
			</div>

			<div class="row"
				style="background-color: #fff; display: -webkit-box; margin-bottom: 10px; margin-left: 4%">

				<div class="element-input col-lg-6" style="width: 12%;">
					<label class="title">From Time</label>
				</div>
				

				 <div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 6%; margin-left: -2%">
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
					style="margin-bottom: 10px; width: 6%;">
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
					style="margin-bottom: 10px; width: 6%;">
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
					style="margin-bottom: 10px; width: 6%;">
					<s:select id="cmbAMPM" path="strAMPMFrom">
						<option value="AM">AM</option>
						<option value="PM">PM</option>
					</s:select>
				</div>


				<div class="element-input col-lg-6" style="width: 12%;margin-left: 20%">
					<label class="title">To Time</label>
				</div>
				
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 6%;">
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
					style="margin-bottom: 10px; width: 6%;">
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
					style="margin-bottom: 10px; width: 6%;">
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
					style="margin-bottom: 10px; width: 6%;">
					<s:select id="cmbToAMPM" path="strAMPMTo">
						<option value="AM">AM</option>
						<option value="PM">PM</option>
					</s:select>
				</div>
			</div>
		</div>

		<div class="row"
			style="background-color: #fff; display: -webkit-box; margin-bottom: 10px; margin-left: 4%">
			<div class="element-input col-lg-6" style="width: 12%;">
				<label class="title">Cost Center</label>
			</div>
			<div class="element-input col-lg-6"
				style="width: 20%; margin-left: -1.5%">
				<s:select id="txtCostCenterCode" path="strCostCenterCode"
					items="${mapCostCenterName}"></s:select>
			</div>
			<div class="element-input col-lg-6"
				style="width: 14%; margin-left: 0%">
				<label class="title">Popular</label>
			</div>
			<div class="element-input col-lg-6"
				style="width: 20%; margin-left: -16px;">
				<s:checkbox id="txtPopular" path="strPopular"
					onclick="funPopularClicked()" />
			</div>
		</div>


		<!-- <div class="row" style="background-color: #fff;display: -webkit-box;margin-bottom: 10px;">
    			<div class="element-input col-lg-6" style="width: 14%;"> 
    				<label class="title">Pricing</label>
    			</div>
    		</div> -->

		<div class="row"
			style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
			<div class="element-input col-lg-6"
				style="width: 14%; margin-left: 3.5%">
				<label class="title">Sunday</label>
			</div>
			<div class="element-input col-lg-6"
				style="width: 10%; margin-left: -50px;">
				<s:input type="number" id="txtPriceSunday" path="strPriceSunday"
					style="text-align: right;width: 100%;" />
			</div>
			<div class="element-input col-lg-6"
				style="width: 7%; margin-left: 3.5%">
				<label class="title">Monday</label>
			</div>
			<div class="element-input col-lg-6"
				style="width: 10%; margin-left: -10px;">
				<s:input type="number" id="txtPriceMonday" path="strPriceMonday"
					style="text-align: right;width: 100%;" />
			</div>
			<div class="element-input col-lg-6"
				style="width: 10%; margin-left: 2%">
				<label class="title">Tuesday</label>
			</div>
			<div class="element-input col-lg-6"
				style="width: 10%; margin-left: -16px;">
				<s:input type="text" id="txtPriceTuesday" path="strPriceTuesday"
					style="text-align: right;width: 100%;" />
			</div>
			<div class="element-input col-lg-6"
				style="width: 10%; margin-left: 2%">

				<label class="title">Wednesday</label>
			</div>
			<div class="element-input col-lg-6"
				style="width: 10%; margin-left: -16px;">
				<s:input type="text" id="txtPriceWednesday" path="strPriceWednesday"
					style="text-align: right;width: 100%;" />
			</div>
		</div>

		<div class="row"
			style="background-color: #fff; display: -webkit-box; margin-bottom: 10px; margin-left: 4.5%">
			<%-- <div class="element-input col-lg-6" style="width: 14%;"> 
    				<label class="title">Wednesday</label>
    			</div>
    			<div class="element-input col-lg-6" style="width: 10%;margin-left: -16px;">
    				<s:input  type="text" id="txtPriceWednesday" path="strPriceWednesday" style="text-align: right;width: 100%;"/>
    			</div> --%>
			<div class="element-input col-lg-6"
				style="width: 14%; margin-left: -0.7%">
				<label class="title">Thursday</label>
			</div>
			<div class="element-input col-lg-6"
				style="width: 10%; margin-left: -46px;">
				<s:input type="number" id="txtPriceThursday" path="strPriceThursday"
					style="text-align: right;width: 100%;" />
			</div>
			<div class="element-input col-lg-6"
				style="width: 6.3%; margin-left: 3.5%">
				<label class="title">Friday</label>
			</div>
			<div class="element-input col-lg-6"
				style="width: 10%; margin-left: -0.2%;">
				<s:input type="number" id="txtPriceFriday" path="strPriceFriday"
					style="text-align: right;width: 100%;" />
			</div>

			<div class="element-input col-lg-6"
				style="width: 10%; margin-left: 2%">
				<label class="title">Saturday</label>
			</div>
			<div class="element-input col-lg-6"
				style="width: 10%; margin-left: -16px;">
				<s:input type="number" id="txtPriceSaturday" path="strPriceSaturday"
					style="text-align: right;width: 100%;" />
			</div>
		</div>

		<%-- <div class="row" style="background-color: #fff;display: -webkit-box;margin-bottom: 10px;">
    			<div class="element-input col-lg-6" style="width: 14%;"> 
    				<label class="title">Saturday</label>
    			</div>
    			<div class="element-input col-lg-6" style="width: 10%;margin-left: -16px;">
    				<s:input  type="text" id="txtPriceSaturday" path="strPriceSaturday" style="text-align: right;width: 100%;"/>
    			</div>
    		</div> --%>

		<div class="col-lg-10 col-sm-10 col-xs-10"
			style="width: 70%; margin-left: 20%;">
			<p align="center">
			<div class="submit col-lg-4 col-sm-4 col-xs-4">
				<input type="submit" value="Submit"
					onclick='return funOnSubmitValidation()' style="margin-left: 83%" />
			</div>

			<div class="submit col-lg-4 col-sm-4 col-xs-4">
				<input type="reset" value="Reset" onclick="funResetFields()"
					style="margin-left: 30%">
			</div>
			</p>
		</div>


		</div>



		

	</s:form>
</body>

<%-- <script type="text/javascript">
	funApplyNumberValidation();
</script> --%>


</html>
