<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>SUBGROUP MASTER</title>
<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/jquery-confirm.min.css"/>"/>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery-confirm.min.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/confirm-prompt.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery.autocomplete.min.js"/>"></script>
<script type="text/javascript">


$(document).ready(function () {
	  //$('input#txtAreaCode').mlKeyboard({layout: 'en_US'});
	  //$('input#txtAreaName').mlKeyboard({layout: 'en_US'});
	  
	  $("form").submit(function(event){
		  if($("#txtSubGroupName").val().trim()=="")
			{
			  confirmDialog("Please Enter Sub Group  Name"," ");
				return false;
			}
		  else{
			  flg=funCallFormAction();
			  return flg;
		  }
		});
	  
	  $('#txtSubGroupName').autocomplete({
			serviceUrl: '${pageContext.request.contextPath}/getAutoSearchData.html?formname=subGroupName',  
			paramName: "searchBy",
			delimiter: ",",
		    transformResult: function(response) {
		    	mapAreaCodeName=new Map();
			return {
			  //must convert json to javascript object before process
			  suggestions: $.map($.parseJSON(response), function(item) {
			       // strValue  strCode
			        mapAreaCodeName.set(item.strValue,item.strCode);
			      	return { value: item.strValue, data: item.strCode };
			   })
			            
			 };
			        
	        }
		 });
		 
			$('#txtSubGroupName').blur(function() {
					var code=mapAreaCodeName.get($('#txtSubGroupName').val());
					if(code!='' && code!=null){
						funSetData(code);	
					}
					
			});
	  
	  
	});

	
	
	
	
	$(document).ready(function () {
		  //$('input#txtSubGroupName').mlKeyboard({layout: 'en_US'});
		  //$('input#txtIncetives').mlKeyboard({layout: 'en_US'});
		}); 

	
	/**
	* Get and Set data from help file and load data Based on Selection Passing Value(User Code)
	**/
	function funSetData(code){
		$("#txtSubGroupCode").val(code);
		var searchurl=getContextPath()+"/loadPOSSubGroupMasterData.html?POSSubGroupCode="+code;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strGCode=='Invalid Code')
			        	{
			        		confirmDialog("Invalid Sub Group Code","");
			        		$("#txtSubGroupCode").val('');
			        	}
			        	else
			        	{
				        	$("#txtSubGroupCode").val(response.strSubGroupCode);
				        	$("#txtSubGroupName").val(response.strSubGroupName);
				        	$("#txtIncentives").val(response.strIncentives);
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
					%>confirmDialog("Data Saved \n\n"+message,"");<%
				}
			}%>
		});
		

		
		
		/**
		*  Check Validation Before Saving Record
		**/
		function funCallFormAction(actionName,object) 
		{
			var flg=true;
			
			if($('#txtSubGroupCode').val()=='')
			{
				var code = $('#txtSubGroupName').val();
				 $.ajax({
				        type: "GET",
				        url: getContextPath()+"/checkSubGroupName.html?SubGroupName="+code,
				        async: false,
				        dataType: "text",
				        success: function(response)
				        {
				        	if(response=="true")
				        		{
				        			confirmDialog("Sub group Name Already Exist!","");
				        			$('#txtSubGroupName').focus();
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
			}
			return flg;
		}


		/**
		* Open Help
		**/
	function funHelp(transactionName)
	{
		fieldName=transactionName;
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	}
</script>

</head>
<body>

	<div id="formHeading">
	<label>Sub Group Master</label>
	</div>

<br/>
<br/>

	<s:form name="POSSubGroupMaster" method="POST" action="savePOSSubGroup.html" class="formoid-default-skyblue" style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:880px;min-width:150px;margin-top:2%;">
		<div class="title">
		
			<div class="row" style="background-color: #fff; margin-left: 25%;display: -webkit-box">
				<div class="element-input col-lg-6" style="width: 20%;"> 
    				<label class="title">Sub Group Code</label>
    			</div>
    			<div class="element-input col-lg-6" style="margin-bottom: 10px;" > 
					<s:input type="text" id="txtSubGroupCode" path="strSubGroupCode" readonly="true" ondblclick="funHelp('POSSubGroupMaster')"/>
				</div>
			 </div>
			 
			 <div class="row" style="background-color: #fff;margin-left: 25%;display: -webkit-box">
				<div class="element-input col-lg-6" style="width: 20%;"> 
    				<label class="title">Sub Group Name</label>
    			</div>
    			<div class="element-input col-lg-6" style="margin-bottom: 10px;" > 
					<s:input type="text" id="txtSubGroupName" path="strSubGroupName" />
				</div>
			 </div>
			 
			 <div class="row" style="background-color: #fff;margin-left: 25%;display: -webkit-box">
				<div class="element-input col-lg-6" style="width: 20%;"> 
    				<label class="title">Group Code</label>
    			</div>
    			<div class="element-input col-lg-6" style="margin-bottom: 10px; width: 24%;" > 
					<s:select id="cmbGroupCode" path="strGroupCode" items="${listGroupName}" >
					</s:select>
				</div>
			 </div>
			 
			 <div class="row" style="background-color: #fff;margin-left: 25%;display: -webkit-box">
				<div class="element-input col-lg-6" style="width: 20%;"> 
    				<label class="title">Incentives</label>
    			</div>
    			<div class="element-input col-lg-6" style="margin-bottom: 10px;" > 
					<s:input type="number" id="txtIncentives" path="strIncentives" value="0.0"/>
				</div>
			 </div>
			 
			 <br/>
			 
			 <div class="col-lg-10 col-sm-10 col-xs-10" style="margin-left: 25%;">
	     			<p align="center">
	            		<div class="submit col-lg-4 col-sm-4 col-xs-4" style="margin-left: 5%"><input type="submit" value="Submit"/></div>
	          
	            		<div class="submit col-lg-4 col-sm-4 col-xs-4" style="margin-left: -13%"><input type="reset" value="Reset" onclick="funResetFields()"></div>
	     			</p>
   			 </div>
			 
		</div>

	</s:form>
</body>
</html>
