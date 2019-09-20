<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>AREA MASTER</title>
<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/jquery-confirm.min.css"/>"/>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery-confirm.min.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/confirm-prompt.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery.autocomplete.min.js"/>"></script>
		
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
	
var mapAreaCodeName=new Map();
	 $(document).ready(function () 
	 {
		  //$('input#txtAreaName').mlKeyboard({layout: 'en_US'});
		  $("form").submit(function(event){
			  	if($("#txtAreaName").val().trim()=="")
				{
				    confirmDialog("Please Enter Area Name","");
					return false;
				}
			  	else
			  	{
					flg=funCallFormAction();
					return flg;
			  	}
			});
		  
		  
		  $('#txtAreaName').autocomplete({
	 			serviceUrl: '${pageContext.request.contextPath}/getAutoSearchData.html?formname=areaName',  
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
			 
				$('#txtAreaName').blur(function() {
						var code=mapAreaCodeName.get($('#txtAreaName').val());
						if(code!='' && code!=null){
							funSetData(code);	
						}
						
				});
			}); 
	 	 
		
 
	/**
	* Reset  Form
	**/
	function funResetFields()
	{
		$("#txtAreaName").val("");	
		$("#txtAreaCode").val("");
    }
	
	/**
	* Open Help
	**/
	function funHelp(transactionName)
	{	       
       window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
    }
	
	/**
	* Get and Set data from help file and load data Based on Selection Passing Value(Group Code)
	**/
	function funSetData(code)
	{
		$("#txtAreaCode").val(code);
		var searchurl=getContextPath()+"/loadPOSAreaMasterData.html?POSAreaCode="+code;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strAreaCode=='Invalid Code')
			        	{
			        		alert("Invalid Area Code");
			        		$("#txtAreaCode").val('');
			        	}
			        	else
			        	{
				        	$("#txtAreaCode").val(response.strAreaCode);
				        	$("#txtAreaName").val(response.strAreaName);
				        	//$("#txtAreaName").focus();
				        	$("#cmbPOSName").val(response.strPOSName);	
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
				%>confirmDialog('Message !','Data Saved'+ message);<%
			}
		}%>
	});
	
	/**
	*  Check Validation Before Saving Record
	**/
	function funCallFormAction() 
	{
		var flg=true;
		
		var name = $('#txtAreaName').val();
		var code= $('#txtAreaCode').val();
		
		 $.ajax({
		        type: "GET",
		        url: getContextPath()+"/checkAreaName.html?areaName="+name+"&areaCode="+code,
		        async: false,
		        dataType: "text",
		        success: function(response)
		        {
		        	if(response=="false")
	        		{
	        		confirmDialog("Area Name Already Exist!");
	        			$('#txtAreaName').focus();
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
</script>


</head>

<body>
	<div id="formHeading">
		<label>Area Master</label>
	</div>

	<s:form name="AreaForm" method="POST" action="savePOSAreaMaster.html"  class="formoid-default-skyblue" style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:880px;min-width:150px;margin-top:2%;" > 
		<br />
		<br />
		
		 <div class="title" style="margin-left: 25%;">
		 	<div class="row" style="background-color: #fff;margin-bottom:  10px;display: -webkit-box; ">
				<div class="element-input col-lg-6" style="width: 20%; margin-left: 10%"> 
	    			<label class="title">Area Code</label>
	    		</div>
	    		<div class="element-input col-lg-6"  style="width: 30%;"> 
					<s:input class="large" type="text" id="txtAreaCode" path="strAreaCode"  ondblclick="funHelp('POSAreaMaster')" readonly="true" style="width: 100%;"/>
				</div>
			</div>
			
			<div class="row" style="background-color: #fff;margin-bottom:  10px;display: -webkit-box;">
				<div class="element-input col-lg-6" style="width: 20%; margin-left: 10%" >
					<label class="title">Area Name</label>
				</div>
				<div class="element-input col-lg-6"  style="width: 30%;">
					<s:input class="large" type="text" id="txtAreaName" path="strAreaName"   style="width: 100%;"/>
				</div> 
			</div>
				
			<div class="row" style="background-color: #fff;margin-bottom:  10px;display: -webkit-box;">	
				<div class="element-input col-lg-6" style="width: 20%; margin-left: 10%">
						<label class="title">POS Name</label>
				</div>
				<div class="element-input col-lg-6"  style="width: 30%;">
						<s:select id="cmbPOSName" path="strPOSName" items="${posList}"  style="width: 100%;"/>
				</div>
			</div>
			
			 <div class="col-lg-10 col-sm-10 col-xs-10" style="width: 60%;">
	    			<p align="center">
	           		<div class="submit col-lg-4 col-sm-4 col-xs-4"  ><input type="submit" value="SUBMIT" style="margin-top: 30%; margin-left: 60%"/></div>
	         
	           		<div class="submit col-lg-4 col-sm-4 col-xs-4" ><input type="reset" value="RESET" style="margin-top: 30%; margin-left: 70%"onclick="funResetFields()"></div>
	    			</p>
	  		</div>
	   			
		</div>
	</s:form>

</body>
</html>
