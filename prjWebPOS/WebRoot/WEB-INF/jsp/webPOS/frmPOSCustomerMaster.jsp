<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Customer Master</title>
<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/jquery-confirm.min.css"/>"/>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery-confirm.min.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/confirm-prompt.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery.autocomplete.min.js"/>"></script>
 <script type="text/javascript">
 	
 
 
 	var fieldName="";
 	var mapCustCodeName=new Map();
 	 $(document).ready(function () {
		$('#txtCustomerName').autocomplete({
 			serviceUrl: '${pageContext.request.contextPath}/getAutoSearchData.html?formname=customerName',  
 			paramName: "searchBy",
 			delimiter: ",",
 		    transformResult: function(response) {
 		    	mapCustCodeName=new Map();
 			return {
 			  //must convert json to javascript object before process
 			  suggestions: $.map($.parseJSON(response), function(item) {
 			       // strValue  strCode
 			        mapCustCodeName.set(item.strValue,item.strCode);
 			      	return { value: item.strValue, data: item.strCode };
 			   })
 			            
 			 };
 			        
 	        }
 		 });
		 
			$('#txtCustomerName').blur(function() {
					var code=mapCustCodeName.get($('#txtCustomerName').val());
					if(code!='' && code!=null){
						funSetDataCustomer(code);	
					}
					
			});
		}); 
 	 
 	
 	 
 	 // Calender Date Picker
 	 $(function() 
 	  {
         $( "#txtAnniversary" ).datepicker();   
         $( "#txtDOB" ).datepicker(); 
         if("${mobileNoForNewCust}"=='NoFound')
         {
        	 
         }
         else
         {
        	 var mobileNo=${mobileNoForNewCust};
        	 $("#txtMobileNo").val(mobileNo);  
         }	 
         
         
         
    }); 
 	 
 
		// Success Message After Saving Record
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
					%>confirmDialog("Data Saved \n\n"+message);<%
				}
				if (session.getAttribute("frmName") != null) 
				{
					if(session.getAttribute("frmName").equals("frmPOSRestaurantBill"))
		            {
						session.removeAttribute("frmName");
		            %>
		            
						funPreviousForm(message);
		           <% }
				}
				
			}%>
			

			  $("form").submit(function(event){
				  if (mobilenumber()) 
				  {				  					  
					  flg=funCallFormAction();
					  return flg;
				  }
			
				  else
				  {
				  return false;
				  }
				  			 
					 
				});
		});
 	
		
		

		
		
		function mobilenumber() 
		{
			var flg=false;
		    if(document.getElementById('txtMobileNo').value != "")
		    {
			   var y = document.getElementById('txtMobileNo').value;
			   if (y.includes(","))
		        {
				   var arrMobileList =y.split(",");
				   for (var cnt = 0; cnt < arrMobileList.length; cnt++)
		            {
					   flg=funCheckMobileNumberValidation(arrMobileList[cnt]);
		            }
		        }
			   else
			   {
				   flg=funCheckMobileNumberValidation(y);
			   }	   
		    }
		    else{
		    	 confirmDialog("Please Check Mobile No.","");
		    	 return flg;
		    }
	      return flg;
	   }
		
		function funCheckMobileNumberValidation(mobileNo) 
		{
			var flg=true;	
			 if(isNaN(mobileNo)||mobileNo.indexOf(" ")!=-1)
		       {
				  confirmDialog("Invalid Mobile No.","");
		          document.getElementById('txtMobileNo').focus();
		          flg=false;
		       }
	
		       if (mobileNo.length>10 || mobileNo.length<10)
		       {
		    	    confirmDialog("Mobile No. should be 10 digit","");
		            document.getElementById('txtMobileNo').focus();
		            flg=false; 
		       }
		       if (!(mobileNo.charAt(0)=="9" || mobileNo.charAt(0)=="8" || mobileNo.charAt(0)=="7"))
		       {
		    	    confirmDialog("Mobile No. should start with 9 ,8 or 7 ","");
		            document.getElementById('txtMobileNo').focus();
		            flg=false;
		       }
		       
			return flg;
		}

 	 
 	 
		 function funCallFormAction() 
			{
				var flg=true;
				
				var strCustCode=$('#txtCustomerCode').val();
				
					var strMobileNo = $('#txtMobileNo').val();
					var searchurl=getContextPath()+"/checkExternalNo.html?strMobileNo="+strMobileNo+"&strCustCode="+strCustCode;
					 $.ajax({
					        type: "GET",
					        url: searchurl,
					        async: false, 
					        dataType: "text",
					        success: function(response)
					        {
					        	if(response=="false")
					        		{
					        		confirmDialog("Hey !! \n\n\nMobile No already exists for another customer !","");
					        			$('#txtExternalCode').focus();
					        			flg= false;
						    		}
						    	else
						    		{
						    			flg=true;
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
				
				
				
				return flg;
			}
 	 
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
 	});
 	
 	
 	
 	
 	
 	function funHelp(transactionName)
 
	{	
 		fieldName=transactionName;
 		// window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
       window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
    }
 	
		
		/**
		* Get and Set data from help file and load data Based on Selection Passing Value(Customer Code)
		**/
		function funSetDataCustomer(code)
		{
			$("#txtCustomerCode").val(code);
			var searchurl=getContextPath()+"/loadPOSCustomerMasterData.html?POSCustomerCode="+code;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strCustomerTypeMasterCode=='Invalid Code')
				        	{
				        		confirmDialog("Invalid Customer  Code","");
				        		$("#txtCustomerCode").val('');
				        	}
				        	else
				        	{
					        	$("#txtCustomerCode").val(response.strCustomerCode);
					        	$("#txtExternalCode").val(response.strExternalCode);
					        	$("#txtMobileNo").val(response.intlongMobileNo);
					        	$("#txtEmailId").val(response.strEmailId);
					        	$("#txtCustomerName").val(response.strCustomerName);
					        	//$("#txtCustomerName").focus();
					        	$("#txtCustomerType").val(response.strCustomerType);
					        	$("#txtDOB").val(response.dteDOB);
					        	$("#txtBuldingCode").val(response.strBuldingCode);
					        	$("#txtArea").val(response.strBuildingName);
					        	$("#txtGender").val(response.strGender);	
					        	$("#txtAnniversary").val(response.dteAnniversary);
					        	$("#txtAddress").val(response.strArea);
					        	$("#txtStreetName").val(response.strStreetName);
					        	$("#txtLandmark").val(response.strLandmark);
					        	$("#txtPinCode").val(response.intPinCode);
					        	$("#strCity").val(response.strCity);
					        	$("#strState").val(response.strState);
					        	$("#txtOfficeBuildingCode").val(response.strOfficeBuildingCode);
					        	$("#txtOfficeBuildingName").val(response.strOfficeBuildingName);
					        	$("#txtOfficeNo").val(response.strOfficeNo);
					        	$("#txtOfficeStreetName").val(response.strOfficeStreetName);
					        	$("#txtOfficeCity").val(response.strOfficeCity);
					        	$("#txtOfficeArea").val(response.strOfficeArea);
					        	$("#txtOfficeState").val(response.strOfficeState);
					        	$("#txtOfficePinCode").val(response.strOfficePinCode);
					        	$("#txtGSTNo").val(response.strGSTNo);
					        	$("#txtTempAddress").val(response.strTempAddress);
					        	$("#txtTempLandmark").val(response.strTempLandmark);
					        	$("#txtTempStreetName").val(response.strTempStreetName);
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
		function funSetDataBuilding(code)
		{
			$("#txtBuldingCode").val(code);
			$("#txtOfficeBuildingCode").val(code);
			var searchurl=getContextPath()+"/loadPOSCustomerAreaMasterData.html?POSCustomerAreaCode="+code;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strCustomerAreaCode=='Invalid Code')
				        	{
				        		confirmDialog("Invalid Building  Code","");
				        		$("#txtBuldingCode").val('');
				        	}
				        	else
				        	{
					        	//$("#txtBuldingCode").val(response.strCustomerAreaCode);
					        	$("#txtArea").val(response.strCustomerAreaName);
					        	
					        	$("#txtOfficeBuildingName").val(response.strCustomerAreaName);
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
	
		
		function funSetData(code)
		{
			
			switch (fieldName)
			{
				case 'POSCustomerMaster':
					funSetDataCustomer(code);						
				break;	
				
				case 'POSCustomerAreaMaster':
					funSetDataBuilding(code);					
				break;
				
					
			}
			
		}
		

		$(function() {
			  $('#staticParent').on('keydown', '#txtMobileNo', function(e){-1!==$.inArray(e.keyCode,[46,8,9,27,13,110,190])||/65|67|86|88/.test(e.keyCode)&&(!0===e.ctrlKey||!0===e.metaKey)||35<=e.keyCode&&40>=e.keyCode||(e.shiftKey||48>e.keyCode||57<e.keyCode)&&(96>e.keyCode||105<e.keyCode)&&e.preventDefault()});
			  $('#staticParent').on('keydown', '#txtExternalCode', function(e){-1!==$.inArray(e.keyCode,[46,8,9,27,13,110,190])||/65|67|86|88/.test(e.keyCode)&&(!0===e.ctrlKey||!0===e.metaKey)||35<=e.keyCode&&40>=e.keyCode||(e.shiftKey||48>e.keyCode||57<e.keyCode)&&(96>e.keyCode||105<e.keyCode)&&e.preventDefault()});
			  $('#staticParent').on('keydown', '#txtPinCode', function(e){-1!==$.inArray(e.keyCode,[46,8,9,27,13,110,190])||/65|67|86|88/.test(e.keyCode)&&(!0===e.ctrlKey||!0===e.metaKey)||35<=e.keyCode&&40>=e.keyCode||(e.shiftKey||48>e.keyCode||57<e.keyCode)&&(96>e.keyCode||105<e.keyCode)&&e.preventDefault()});
			  $('#staticParent').on('keydown', '#txtOfficePinCode', function(e){-1!==$.inArray(e.keyCode,[46,8,9,27,13,110,190])||/65|67|86|88/.test(e.keyCode)&&(!0===e.ctrlKey||!0===e.metaKey)||35<=e.keyCode&&40>=e.keyCode||(e.shiftKey||48>e.keyCode||57<e.keyCode)&&(96>e.keyCode||105<e.keyCode)&&e.preventDefault()});
			})

	function funPreviousForm(value) {
		window.opener.funSetData(value);
		window.close();
	}
			
			
</script>  

</head>
<body>

	<div id="formHeading">
	<label>Customer Master</label>
	</div>
	
	<s:form name="POSCustomerMaster" method="POST" action="savePOSCustomerMaster.html?saddr=${urlHits}" class="formoid-default-skyblue" style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:880px;min-width:150px;margin-top:2%;">
	
		<div id="tab_container" style="height: 500px;">
				<ul class="tabs">
						<li class="active" data-state="tab1" style="width: 15%; padding-left: 4%; height: 25px; border-radius: 4px;">Customer</li>
						<li data-state="tab2" style="width: 15%; padding-left: 5%; height: 25px; border-radius: 4px;">Office</li>
						<li data-state="tab3" style="width: 15%; padding-left: 1%; height: 25px; border-radius: 4px;">Temporary Address</li>
				</ul>
				
			<br /> <br />
			
<!-- 			Start of Tab1 -->
					
			<div id="tab1" class="tab_content">
			
				<div class="title">
			
					<div class="row" style="background-color: #fff; display: -webkit-box;">
						<div class="element-input col-lg-6" style="width: 18%; margin-left:10px;margin-top:5px"> 
	    					<label class="title">Customer Code</label>
	    				</div>
	    				<div class="element-input col-lg-6" style="margin-bottom: 5px;width: 20%;"> 
							<s:input class="large" colspan="3" type="text" id="txtCustomerCode" path="strCustomerCode"  ondblclick="funHelp('POSCustomerMaster')"/>
						</div>
						<div class="element-input col-lg-6" style="width: 15%; margin-left:80px;margin-top:5px"> 
	    					<label class="title">External Code</label>
	    				</div>
	    				<div class="element-input col-lg-6" style="margin-bottom: 5px;width: 20%;"> 
							<s:input class="large" colspan="3" type="text" id="txtExternalCode" path="strExternalCode"  />
						</div>
				 	</div>
				 	
				 	<div class="row" style="background-color: #fff; display: -webkit-box;">
						<div class="element-input col-lg-6" style="width: 18%;margin-left:10px;margin-top:5px" > 
	    					<label class="title">Customer Name</label>
	    				</div>
	    				<div class="element-input col-lg-6" style="margin-bottom: 5px;width: 20%;"> 
							<s:input class="large" colspan="3" type="text" id="txtCustomerName" path="strCustomerName" />
						</div>
						
						<div class="element-input col-lg-6" style="width: 15%; margin-left:80px;margin-top:5px" > 
	    					<label class="title">Gender</label>
	    				</div>
	    				<div class="element-input col-lg-6" style="margin-bottom: 5px;width: 20%;"> 
							<s:select id="txtGender" path="strGender" >
				    			<option selected="selected" value="Female">Female</option>
				    			<option value="Male">Male</option>
			        		</s:select>
						</div>
				 	</div>
				 	
				 	<div class="row" style="background-color: #fff; display: -webkit-box;">
						<div class="element-input col-lg-6" style="width: 18%; margin-left:10px;margin-top:5px"> 
	    					<label class="title">Contact No</label>
	    				</div>
	    				<div class="element-input col-lg-6" style="margin-bottom: 5px;width: 20%;"> 
							<s:input class="large" colspan="3" type="text" id="txtMobileNo" path="intlongMobileNo" />
						</div>
						<div class="element-input col-lg-6" style="width: 15%; margin-left:80px;margin-top:5px"> 
	    					<label class="title">DOB</label>
	    				</div>
	    				<div class="element-input col-lg-6" style="margin-bottom: 5px;width: 20%;"> 
							<s:input colspan="3" type="text" id="txtDOB" path="dteDOB" />
						</div>
				 	</div>
				 	
				 	<div class="row" style="background-color: #fff; display: -webkit-box;">
						<div class="element-input col-lg-6" style="width: 18%; margin-left:10px;margin-top:5px"> 
	    					<label class="title">Customer Type</label>
	    				</div>
	    				<div class="element-input col-lg-6" style="margin-bottom: 5px;width: 20%;"> 
							<s:select id="txtCustomerType" path="strCustomerType" items="${customerType}" />
						</div>
						<div class="element-input col-lg-6" style="width: 15%; margin-left:80px;margin-top:5px"> 
	    					<label class="title">Email Id</label>
	    				</div>
	    				<div class="element-input col-lg-6" style="margin-bottom: 5px;width: 20%;"> 
							<s:input colspan="3" type="text" id="txtEmailId" path="strEmailId" />
						</div>
				 	</div>
				 	
				 	<div class="row" style="background-color: #fff; display: -webkit-box;">
						<div class="element-input col-lg-6" style="width: 18%; margin-left:10px;margin-top:5px"> 
	    					<label class="title">Area</label>
	    				</div>
	    				<div class="element-input col-sm-3" style="margin-bottom: 5px;width: 28%; "> 
							<s:input type="text" id="txtBuldingCode" style="width:50px;" path="strBuldingCode" ondblclick="funHelp('POSCustomerAreaMaster');"  />
							<s:input type="text" id="txtArea" style="width:130px; margin-left:5px;" path="strBuildingName" />
						</div>
						<%-- <div class="element-input col-lg-6" style="margin-left:2px; margin-bottom: 5px;width: 10%;">
							<s:input type="text" id="txtArea" style="width:80px;" path="strBuildingName" />
						</div> --%>
						<div class="element-input col-lg-6" style="width: 15%; margin-left:12px; margin-top:5px ">
	    					<label class="title">Anniversary</label>
	    				</div>
	    				<div class="element-input col-lg-6" style="margin-bottom: 5px;width: 20%; "> 
							<s:input  type="text" id="txtAnniversary" path="dteAnniversary" />
						</div>
				 	</div>
				 	
				 	<div class="row" style="background-color: #fff; display: block; ">
						<div class="element-input col-lg-6" style="width: 18%; margin-left:10px;margin-top:5px; "> 
	    					<label class="title">Address/Flat No.</label>
	    				</div>
	    				<div class="element-input col-lg-6" style="margin-bottom: 5px;width: 25%;"> 
							<s:textarea type="text" id="txtAddress" path="strArea" />
						</div>
						
						<div class="element-input col-lg-6" style="width: 15%;margin-left:35px;margin-top:5px;"> 
	    					<label class="title">Street Name</label>
	    				</div>
	    				<div class="element-input col-lg-6" style="margin-bottom: 5px; margin-left:5px; width: 20%; "> 
							<s:input  type="text" id="txtStreetName" path="strStreetName" />
						</div>
					</div>
					
					<%-- <div class="row" style="background-color: #fff; display: -webkit-box;">
						<div class="element-input col-lg-6" style="width: 18%;margin-left:10px;margin-top:5px"> 
	    					<label class="title">Street Name</label>
	    				</div>
	    				<div class="element-input col-lg-6" style="margin-bottom: 5px;width: 20%;"> 
							<s:input  type="text" id="txtStreetName" path="strStreetName" />
						</div>
				   </div> --%>
				   
				   <div class="row" style="background-color: #fff; display: block; ">
						<div class="element-input col-lg-6" style="width: 18%;margin-left:10px;margin-top:5px"> 
	    					<label class="title">Landmark</label>
	    				</div>
	    				<div class="element-input col-lg-6" style="margin-bottom: 5px;width: 20%;"> 
							<s:input  type="text" id="txtLandmark" path="strLandmark" />
						</div>
						
						<div class="element-input col-lg-6" style="width:15%; margin-left:80px;margin-top:5px; "> 
	    					<label class="title">PinCode</label>
	    				</div>
	    				<div class="element-input col-lg-6" style="margin-bottom: 5px; width:20%"; > 
							<s:input  type="text" class="numeric" id="txtPinCode" path="intPinCode" />
						</div>
				   </div>
				   
				   <%-- <div class="row" style="background-color: #fff; display: block; ">
						<div class="element-input col-lg-6" style="width:15% margin-left:10px;margin-top:5px"> 
	    					<label class="title">PinCode</label>
	    				</div>
	    				<div class="element-input col-lg-6" style="margin-bottom: 5px;width:20%"> 
							<s:input  type="text" class="numeric" id="txtPinCode" path="intPinCode" />
						</div>
				   </div> --%>
				   
				   <div class="row" style="background-color: #fff; display: block; ">
						<div class="element-input col-lg-6" style="width: 15%; margin-left:10px;margin-top:5px;"> 
	    					<label class="title">City</label>
	    				</div>
	    				<div class="element-input col-lg-6" style="margin-bottom: 5px; width: 25%; margin-left:20px; "> 
							<s:select id="txtCity" path="strCity" items="${cityName}" />
						</div>
						
						<div class="element-input col-lg-6"  style="width: 15%; margin-left:40px; margin-top:5px; "> 
	    					<label class="title">State</label>
	    				</div>
	    				<div class="element-input col-lg-6" style="margin-bottom: 5px;width: 25%; margin-left:2px; "> 
							<s:select id="txtState" path="strState" items="${stateName}" />
						</div>
				   </div>
				   
				    <%-- <div class="row" style="background-color: #fff; display: -webkit-box;">
						<div class="element-input col-lg-6"  style="width: 15%; margin-left:10px;margin-top:5px"> 
	    					<label class="title">State</label>
	    				</div>
	    				<div class="element-input col-lg-6" style="margin-bottom: 5px;width: 25%;"> 
							<s:select id="txtState" path="strState" items="${stateName}" />
						</div>
				   </div> --%>
			 	
			   </div>
			   
			</div>
			
<!-- 	   	End of Tab1 -->

<!-- 		Start of Tab2 -->

			<div id="tab2" class="tab_content">
				
					<div class="title">
				
						<div class="row" style="background-color: #fff; display: block; ">
							<div class="element-input col-lg-6" style="width: 15%; margin-left:40px; margin-top:5px;"> 
		    					<label class="title">Building Code</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="margin-bottom: 5px; width: 20%;"> 
								<s:input type="text" id="txtOfficeBuildingCode" path="strOfficeBuildingCode" ondblclick="funHelp('POSCustomerAreaMaster');"/>
								<s:input type="text" id="txtOfficeBuildingName" path="strOfficeBuildingName" />
							</div>
							
							<div class="element-input col-lg-6" style="width: 15%; margin-left:60px; margin-top:5px;"> 
		    					<label class="title">Office No</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="margin-bottom: 5px;width: 20%;"> 
								<s:input class="large" colspan="3" type="text" id="txtOfficeNo" path="strOfficeNo" />
							</div>
					 	</div>
					 	
					 	<div class="row" style="background-color: #fff; display: -webkit-box;">
							<div class="element-input col-lg-6" style="width: 15%;  margin-left:40px; margin-top:5px;"> 
		    					<label class="title">Street Name</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="margin-bottom: 5px;width: 20%;"> 
								<s:input type="text" id="txtOfficeNo" path="strOfficeNo" />
							</div>
							<div class="element-input col-lg-6" style="width: 15%; margin-left:60px;"> 
		    					<label class="title">City</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="margin-bottom: 5px;width: 20%;"> 
								<s:select id="txtOfficeCity" path="strOfficeCity" items="${cityName}" />
							</div>
					 	</div>
					 	
					 	<div class="row" style="background-color: #fff; display: -webkit-box;">
							<div class="element-input col-lg-6" style="width: 15%;  margin-left:40px; margin-top:5px;"> 
		    					<label class="title">Area</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="margin-bottom: 5px; width: 20%;"> 
								<s:input type="text" id="txtOfficeArea" path="strOfficeArea" />
							</div>
							<div class="element-input col-lg-6" style="width: 15%; margin-left:60px; margin-top:5px;"> 
		    					<label class="title">State</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="margin-bottom: 5px;width: 20%;"> 
								<s:select id="txtOfficeState" path="strOfficeState" items="${stateName}" />
							</div>
					 	</div>
					 	
					 	<div class="row" style="background-color: #fff; display: -webkit-box;">
							<div class="element-input col-lg-6" style="width: 15%;  margin-left:40px; margin-top:5px;"> 
		    					<label class="title">GST No.</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="margin-bottom: 5px;width: 20%;"> 
								<s:input  type="text" id="txtGSTNo" path="strGSTNo" />
							</div>
							<div class="element-input col-lg-6" style="width: 15%; margin-left:60px; margin-top:5px;"> 
		    					<label class="title">Pin Code</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="margin-bottom: 5px;width: 20%;"> 
								<s:input  type="text" id="txtOfficePinCode" path="strOfficePinCode" />
							</div>
					 	</div>
					 	
					 </div>
					 	
			 </div>
			 
<!-- 	   	End of Tab2 -->

<!-- 		Start of Tab3 -->

			<div id="tab3" class="tab_content">
				
					<div class="title"> 
				
						<div class="row" style="background-color: #fff; display: block; ">
							<div class="element-input col-lg-6" style="width: 20%; margin-left:10px;margin-top:5px;"> 
		    					<label class="title">Temporary Address</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="margin-bottom: 5px;"> 
								<s:input type="text" id="txtTempAddress" path="strTempAddress" />
							</div>
					 	</div>
					 	
					 	<div class="row" style="background-color: #fff; display: block;">
							<div class="element-input col-lg-6" style="width: 20%; margin-left:10px;margin-top:5px;"> 
		    					<label class="title">Street Name</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="margin-bottom: 5px;"> 
								<s:input type="text" id="txtTempStreetName" path="strTempStreetName" />
							</div>
					 	</div>
					 	
					 	<div class="row" style="background-color: #fff; display: block; ">
							<div class="element-input col-lg-6" style="width: 15%; margin-left:10px;margin-top:5px;"> 
		    					<label class="title">Landmark</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="margin-bottom: 5px; margin-left:42px;"> 
								<s:input type="text" id="txtTempLandmark" path="strTempLandmark" />
							</div>
					 	</div>
					 	
				</div>
				
			  </div>
			  
			  <div class="col-lg-10 col-sm-10 col-xs-10" style="width: 50%; margin-top:30px; margin-left:250px;">
			  		<p align="center">
						<div class="submit col-lg-4 col-sm-4 col-xs-4"><input type="submit" value="SUBMIT" /></div>
						<div class="submit col-lg-4 col-sm-4 col-xs-4"><input type="reset" value="RESET" onclick="funResetFields()"/></div>
					</p>
			  </div>
			
		</div>	
	</s:form>
	
</body>
</html>
