<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Customer Area Master</title>
<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/jquery-confirm.min.css"/>"/>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery-confirm.min.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/confirm-prompt.js"/>"></script>
		
<script type="text/javascript">
var fieldName="";
 	 $(document).ready(function () {
	      $('input#txtCustomerAreaCode').mlKeyboard({layout: 'en_US'});
		  $('input#txtCustomerAreaName').mlKeyboard({layout: 'en_US'});
		  $('input#txtcustomerAddress').mlKeyboard({layout: 'en_US'});
		  $('input#txtcustomerHomeDeliveryCharges').mlKeyboard({layout: 'en_US'});
		  $('input#txtcustomerZone').mlKeyboard({layout: 'en_US'});
		  $('input#txtcustomerDeliveryBoyPayOut').mlKeyboard({layout: 'en_US'});
		  $('input#txtcustomerHelperPayOut').mlKeyboard({layout: 'en_US'});
		  $('input#txtAmount').mlKeyboard({layout: 'en_US'});
		  $('input#txtAmount1').mlKeyboard({layout: 'en_US'});
		  $('input#txtDeliveryCharges').mlKeyboard({layout: 'en_US'});
		  
		}); 
 	    	 
		
		//Initialize tab Index or which tab is Active
	  	$(document).ready(function() 
	  	{		
	  		$(".tab_content").hide();
	  		$(".tab_content:first").show();

	  		$("ul.tabs li").click(function() {
	  			$("ul.tabs li").removeClass("active");
	  			$(this).addClass("active");
	  			$(".tab_content").hide();
	  			var activeTab = $(this).attr("data-state");
	  			$("#" + activeTab).fadeIn();
	  		});
	  			
	  		$(document).ajaxStart(function(){
	  		    $("#wait").css("display","block");
	  		});
	  		$(document).ajaxComplete(function(){
	  		   	$("#wait").css("display","none");
	  		});
	  		
	  		 $("form").submit(function(event){
	  			  if($("#txtCustomerAreaName").val().trim()=="")
	  				{
	  				confirmDialog("Please Enter  Area Name","");
	  					return false;
	  				}
	  			  if($("#txtcustomerAddress").val().trim()=="")
	  				{
	  				confirmDialog("Please Enter  Address","");
	  					return false;
	  				}
	  			  if($("#txtcustomerHelperPayOut").val().trim()=="")
				 {
	  				confirmDialog("Enter Helper Pay Charge Charge","");
				 	return false;
				 }
	  			 if($("#txtcustomerHomeDeliveryCharges").val().trim()=="")
				 {
	  				confirmDialog("Enter Delivery Charges","");
					 	return false;
					 }
	  			});
	  		
	  		
	  	});
	
	  	 function funDeleteTableAllRows()
		 {
		 	$('#tbldata tbody').empty();
		 	var table = document.getElementById("tbldata");
		 	var rowCount1 = table.rows.length;
		 	if(rowCount1==0){
		 		return true;
		 	}else{
		 		return false;
		 	}
		 }
	 	function btnRemove_onclick() {

			var table = document.getElementById("tblDiscDtl");
			table.deleteRow(selectedRowIndex);

		}
 	 
 	function funHelp(transactionName)
	{	   
 		fieldName=transactionName;
       // window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
       window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
    }
 	function funAddRow()
	{
 		 
	 
		if(!funCheckNull($("#txtAmount").val(),"From Product"))
		{
			$("#txtAmount").focus();
			return false;
		} 
		
		if(!funCheckNull($("#txtAmount1").val(),"To Product"))
		{
			$("#txtAmount1").focus();
			return false;
		} 
		
		if(!funCheckNull($("#txtDeliveryCharges").val(),"Delivery Charges"))
		{
			$("#txtDeliveryCharges").focus();
			return false;
		} 
		
		if(!funCheckNull($("#txtCustomerType").val(),"Customer Type"))
		{
			$("#txtCustomerType").focus();
			return false;
		}
		
	/* 	if(!funValidateNumeric($("#txtAmount").val()))
		{
			$("#txtAmount").focus();
			return false;
		} */
		
	      var table = document.getElementById("tbldata");
		  var rowCount = table.rows.length;
		  var tblFromAmt="";
		  var tblToAmt="";
		  var tblCustType="";
	    var fromAmount = $("#txtAmount").val();
	    var toAmount = $("#txtAmount1").val();
	    var deliveryCharges = $("#txtDeliveryCharges").val();
	    var customerType = $("#txtCustomerType").val();
	    for(var i=0;i<rowCount;i++)
		{
			 tblFromAmt=table.rows[i].cells[0].children[0].value;
			 tblToAmt=table.rows[i].cells[1].children[0].value;
			 tblCustType=table.rows[i].cells[3].children[0].value;
		}	
	    if(tableDataValidation(tblFromAmt,tblToAmt,tblCustType))
	    {
	    var row = table.insertRow(rowCount); 
	    
		
	
	    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\"  size=\"28%\" name=\"listCustAreaAmount["+(rowCount)+"].dblAmount\" id=\"dblAmount\" value='"+fromAmount+"'>";
	    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\"  size=\"22%\" name=\"listCustAreaAmount["+(rowCount)+"].dblAmount1\" id=\"dblAmount1\" value='"+toAmount+"'>";
	    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"28%\" name=\"listCustAreaAmount["+(rowCount)+"].dblDeliveryCharges\" id=\"dblDeliveryCharges."+(rowCount)+"\" value='"+deliveryCharges+"'>";
	    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"23%\" name=\"listCustAreaAmount["+(rowCount)+"].strCustomerType\" id=\"strCustomerType\" value='"+customerType+"'>";
	    /* row.insertCell(0).innerHTML= "<input name=\"listCustAreaAmount["+(rowCount)+"].dblAmount\" readonly=\"readonly\" class=\"decimal-places-amt\" size=\"15%\" id=\"txtAmount."+(rowCount)+"\" value="+fromAmount+">";		    
	    row.insertCell(1).innerHTML= "<input name=\"listCustAreaAmount["+(rowCount)+"].dblAmount1\" readonly=\"readonly\" class=\"decimal-places-amt\" size=\"30%\" id=\"txtAmount1."+(rowCount)+"\" value='"+toAmount+"'/>";
	    row.insertCell(2).innerHTML= "<input name=\"listCustAreaAmount["+(rowCount)+"].dblDeliveryCharges\" readonly=\"readonly\" class=\"Box\" size=\"30%\" id=\"txtDeliveryCharges."+(rowCount)+"\" value='"+deliveryCharges+"'/>";
	    row.insertCell(3).innerHTML= "<input name=\"listCustAreaAmount["+(rowCount)+"].strCustomerType\" readonly=\"readonly\" class=\"Box\" size=\"30%\" id=\"txtCustomerType."+(rowCount)+"\" value='"+customerType+"'/>"; */
	    row.insertCell(4).innerHTML= '<input type="button" style=\"width: 100%; height: 0%;\" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRow(this)">';
	    //funApplyNumberValidation();
	    //funResetFields();
	    	}
	    return false;
	}
 	function funDeleteRow(obj)
	{
	    var index = obj.parentNode.parentNode.rowIndex;
	    var table = document.getElementById("tbldata");
	    table.deleteRow(index);
	}
	 
		
		/**
		* Get and Set data from help file and load data Based on Selection Passing Value(Group Code)
		**/
		function funSetDataArea(code)
		{
			if(funDeleteTableAllRows())
				{
			$("#txtCustomerAreaCode").val(code);
			var searchurl=getContextPath()+"/loadPOSCustomerAreaMasterData.html?POSCustomerAreaCode="+code;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strCustomerTypeMasterCode=='Invalid Code')
				        	{
				        		alert("Invalid Customer Area Code");
				        		$("#txtCustomerAreaCode").val('');
				        	}
				        	
				        	else
				        	{
					        	$("#txtCustomerAreaCode").val(code);
					        	$("#txtCustomerAreaName").val(response.strCustomerAreaName);
					        	$("#txtCustomerAreaName").focus();
					        	$("#txtcustomerAddress").val(response.strAddress);
					        	$("#txtcustomerHomeDeliveryCharges").val(response.strHomeDeliveryCharges);
					        	$("#txtcustomerZone").val(response.strZone);
					        	$("#txtcustomerDeliveryBoyPayOut").val(response.dblDeliveryBoyPayOut);
					        	$("#txtcustomerHelperPayOut").val(response.strHelperPayOut);
					        	$("#txtAmount").val(response.dblAmount);
					        	$("#txtAmount1").val(response.dblAmount1);
					        	$("#txtDeliveryCharges").val(response.dblDeliveryCharges);
					        	$("#txtCustomerType").val(response.strCustomerType);
					        	
					        	 $.each(response.listCustAreaAmount,function(i,item){
					        	funLoadCustomerDetail(item.dblAmount,item.dblAmount1,item.dblDeliveryCharges,item.strCustomerType)
					        	 })
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
		
		function tableDataValidation(amt,amt1,customerType)
		{
			var flg=true;
			var amount =amt ;
			var amount1 =amt1 ;
			var custType = customerType;
			var fromAmount = $("#txtAmount").val();
		    var toAmount = $("#txtAmount1").val();
		    var deliveryCharges = $("#txtDeliveryCharges").val();
		    var customerType = $("#txtCustomerType").val();	
		   	
			 if(fromAmount<=0.0 ||toAmount<=0.0 ||deliveryCharges<=0.0)
		    	{
				 confirmDialog("Enter value Greater then 0","");
		    	flg=false;
		    	}
			 
			 if(!(amount1<fromAmount && amount1<toAmount) && customerType==custType)
				 {
				 confirmDialog("The Amount is Already Exist","");
			    	flg=false;
				 }
			
		  /*   var table = document.getElementById("tbldata");
			  var rowCount = table.rows.length; */
		  
		/*   $('#tbldata tr').each(function() {
				 var dblAmount=$(this).find("input[class='dblAmount']").val();
				 var dblAmount1=$(this).find("input[class='dblAmount1']").val();
				 //alert("Amount already present");				 
		  });
		   */
		  return flg;

		}
		
		
		function funLoadCustomerDetail(item0,item1,item2,item3)
		{
			var flag=false;
			var table = document.getElementById("tbldata");
			var rowCount = table.rows.length;
			var row = table.insertRow(rowCount);

		     
			      row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"28%\" name=\"listCustAreaAmount["+(rowCount)+"].dblAmount\"  value='"+item0+"'>";
			      row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"22%\"  name=\"listCustAreaAmount["+(rowCount)+"].dblAmount1\"  value='"+item1+"'>";	      	          					        				        				            				        		           	        			
				  row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"28%\" name=\"listCustAreaAmount["+(rowCount)+"].dblDeliveryCharges\"  value='"+item2+"'>";
				  row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"23%\" name=\"listCustAreaAmount["+(rowCount)+"].strCustomerType\" value='"+item3+"'>";
				  row.insertCell(4).innerHTML= '<input type="button" style=\"width: 100%; height: 0%;\" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRow(this)">';	      				
		
		}
		
		function funSetDataZone(code)
		{
			$("#txtcustomerZone").val(code);
			var searchurl=getContextPath()+"/loadPOSZoneMasterData.html?POSZoneCode="+code;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strZoneCode=='Invalid Code')
				        	{
				        		alert("Invalid Zone Code");
				        		$("#txtcustomerZone").val('');
				        	}
				        	else
				        	{
					        	$("#txtcustomerZone").val(response.strZoneCode);
					        
			
					        	
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
				{
					%>confirmDialog("Data Saved \n\n"+ message," ");<%
				}
			}%>
	});

	function funSetData(code) {

		switch (fieldName) {
		case 'POSCustomerAreaMaster':
			funSetDataArea(code);
			break;

		case 'POSZoneMaster':
			funSetDataZone(code);
			break;

		}
	}
</script>

</head>
<body>

	<div id="formHeading">
		<label>Customer Area</label>
	</div>

	<s:form name="customerArea" method="POST"
		action="savePOSCustomerAreaMaster.html?saddr=${urlHits}"
		class="formoid-default-skyblue"
		style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:100%;min-width:50%;margin-top:2%;">

		<div class="title" style="margin-left: 20%;">

			<div id="tab_container" style="height: 50%; overflow: hidden;">
				<ul class="tabs">
					<li data-state="tab1"
						style="width: 10%; padding-left: 2%; margin-left: 10%; height: 10%; border-radius: 4px;"
						class="active">Area Master</li>
					<li data-state="tab2"
						style="width: 13%; padding-left: 1%; height: 10%; border-radius: 4%;">Delivery
						Charges</li>
				</ul>

				<br /> <br />

				<!-- 	Start of Tab 1	 -->

				<div id="tab1" class="tab_content">

					<!-- 		<div id="jquery-script-menu"> -->
					<!-- 		</div> -->

					<div class="title">

						<div class="row"
							style="background-color: #fff; margin-bottom: 5%;">
							<div class="element-input col-lg-6">
								<label class="title">Area Code</label>
							</div>
							<div class="element-input col-lg-6" style="margin-bottom: 5%;">
								<s:input class="large" colspan="3" type="text"
									id="txtCustomerAreaCode" path="strCustomerAreaCode"
									readonly="true" ondblclick="funHelp('POSCustomerAreaMaster')" />
							</div>
						</div>

						<div class="row"
							style="background-color: #fff; margin-bottom: 5%;">
							<div class="element-input col-lg-6">
								<label class="title">Area Name</label>
							</div>
							<div class="element-input col-lg-6" style="margin-bottom: 5%;">
								<s:input class="large" type="text" id="txtCustomerAreaName"
									path="strCustomerAreaName" />
							</div>
						</div>

						<div class="row"
							style="background-color: #fff; margin-bottom: 5%;">
							<div class="element-input col-lg-6">
								<label class="title">Address </label>
							</div>
							<div class="element-input col-lg-6" style="margin-bottom: 5%;">
								<s:input class="large" type="text" id="txtcustomerAddress"
									path="strAddress" />
							</div>
						</div>

						<div class="row"
							style="background-color: #fff; margin-bottom: 5%;">
							<div class="element-input col-lg-6">
								<label class="title">Home Delivery Charges </label>
							</div>
							<div class="element-input col-lg-6" style="margin-bottom: 5%;">
								<s:input class="large" type="number"
									id="txtcustomerHomeDeliveryCharges"
									path="strHomeDeliveryCharges" style="text-align: right;" />
							</div>
						</div>

						<div class="row"
							style="background-color: #fff; margin-bottom: 5%;">
							<div class="element-input col-lg-6">
								<label class="title">Zone </label>
							</div>
							<div class="element-input col-lg-6" style="margin-bottom: 10px;">
								<s:input class="large" type="text" id="txtcustomerZone"
									path="strZone" ondblclick="funHelp('POSZoneMaster')" />
							</div>
						</div>

						<div class="row"
							style="background-color: #fff; margin-bottom: 5%;">
							<div class="element-input col-lg-6">
								<label class="title">Delivery Boy Pay Out </label>
							</div>
							<div class="element-input col-lg-6" style="margin-bottom: 5%;">
								<s:input class="large" type="number"
									id="txtcustomerDeliveryBoyPayOut" path="dblDeliveryBoyPayOut"
									style="text-align: right;" />
							</div>
						</div>

						<div class="row"
							style="background-color: #fff; margin-bottom: 5%;">
							<div class="element-input col-lg-6">
								<label class="title">Helper Pay Out </label>
							</div>
							<div class="element-input col-lg-6" style="margin-bottom: 5%;">
								<s:input class="large" type="number"
									id="txtcustomerHelperPayOut" path="strHelperPayOut"
									style="text-align: right;" />
							</div>
						</div>

					</div>

				</div>

				<!--            End of Tab1 -->

				<!-- 			Start of Tab2 -->

				<div id="tab2" class="tab_content" style="height: 400px">

					<div class="title" style="width: 60%; margin-left: 12%">

						<div class="row"
							style="background-color: #fff; margin-bottom: 5%;">
							<div class="element-input col-lg-6">
								<label class="title">Amount</label>
							</div>
							<div class="element-input col-lg-6">
								<s:input class="large" colspan="3" type="number" id="txtAmount"
									path="dblAmount"
									style="text-align: right; width: 33%;margin-bottom: 5%;" />
								&nbsp;
								<s:input class="large" colspan="3" type="number" id="txtAmount1"
									path="dblAmount1" style="text-align: right; width: 60%;" />
							</div>
						</div>

						<div class="row"
							style="background-color: #fff; margin-bottom: 5%;">
							<div class="element-input col-lg-6">
								<label class="title">Delivery Charges</label>
							</div>
							<div class="element-input col-lg-6" style="margin-bottom: 5%;">
								<s:input class="large" colspan="3" type="number"
									id="txtDeliveryCharges" path="dblDeliveryCharges"
									style="text-align: right;" />
							</div>
						</div>

						<div class="row"
							style="background-color: #fff; margin-bottom: 5%; margin-left: 20%">
							<div class="element-input col-lg-6">
								<label class="title">Customer Type</label>
							</div>
							<div class="element-input col-lg-6" style="margin-bottom: 5%;">
								<s:select id="txtCustomerType" path="strCustomerType"
									items="${customerTypeList}" />
							</div>
						</div>

						<div class="col-lg-10 col-sm-10 col-xs-10" style="width: 100%">
							<div class="submit col-lg-4 col-sm-4 col-xs-4"
								style="margin-left: 18%">
								<input type="Button" value="APPLY" id="btnAdd"
									onclick="funAddRow()" />
							</div>
							<div class="submit col-lg-4 col-sm-4 col-xs-4"
								style="margin-left: -10%">
								<input type="reset" value="RESET" onclick="funResetFields()" />
							</div>
						</div>

					</div>

					<br /> <br /> <br />

					<div class="row"
						style="background-color: #fff; display: -webkit-box; margin-bottom: 5%;">

						<div
							style="border: 1px solid #ccc; display: block; height: 200px; margin: auto; overflow-x: scroll; overflow-y: scroll; width: 60%; margin-left: 7%;margin-bottom: 15%;">
							<table id="tblData1"
								style="width: 100%; background: #2FABE9; color: white;">
								<thead>
									<tr>
										<th style="margin-left: -20%">From Bill Amount</th>
										<th>To Bill Amount</th>
										<th>Delivery Charges</th>
										<th>Customer Type</th>
										<th>Delete</th>
									</tr>
								</thead>
							</table>

							<table id="tbldata"
								style="background-color: #d9edf742; width: 100%; border: 1px solid #ccc;">
								<tbody style="border-top: none;">
								<col style="width: 20%">
								<col style="width: 20%">
								<col style="width: 20%">
								<col style="width: 20%">
								<col style="width: 15%">
								</tbody>
							</table>
						</div>

					</div>

				</div>

				<div class="col-lg-10 col-sm-10 col-xs-10"
					style="width: 70%; margin-left: 20%;margin-bottom: 5%;">
					<p align="center">
					<div class="submit col-lg-4 col-sm-4 col-xs-4">
						<input type="submit" value="SUBMIT" />
					</div>

					<div class="submit col-lg-4 col-sm-4 col-xs-4">
						<input type="reset" value="RESET" onclick="funResetFields() "
							style="margin-left: -30%">
					</div>
					</p>
				</div>
			</div>
		</div>

	</s:form>



</body>
</html>