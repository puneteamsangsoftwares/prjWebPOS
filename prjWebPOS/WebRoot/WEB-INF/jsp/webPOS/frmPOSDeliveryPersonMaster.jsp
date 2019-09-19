<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Delivery Person Master</title>
<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/jquery-confirm.min.css"/>"/>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery-confirm.min.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/confirm-prompt.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery.autocomplete.min.js"/>"></script>
<script type="text/javascript">

    var mapDPCodeName=new Map();
	$(document).ready(function() 
		{
		 $('input#txtTableNo').mlKeyboard({layout: 'en_US'});
		  $('input#txtTableName').mlKeyboard({layout: 'en_US'});
		  $('input#txtPaxNo').mlKeyboard({layout: 'en_US'});
		  
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
			  if($("#txtDPName").val().trim()=="")
				{
				  confirmDialog("Please Enter Delivery Boy Name","");
					return false;
				}
			 
			 
			  else{
				  flg=funCallFormAction();
				  return flg;
			  }
			});
		    var table = document.getElementById("tblDeliveryCharges");
		    var rowCount = table.rows.length;
		  if(rowCount<0)
		  		document.getElementById("btnRemove").disabled = true;  
		  
		  $('#txtDPName').autocomplete({
	 			serviceUrl: '${pageContext.request.contextPath}/getAutoSearchData.html?formname=deliveryBoyName',  
	 			paramName: "searchBy",
	 			delimiter: ",",
	 		    transformResult: function(response) {
	 		    	mapDPCodeName=new Map();
	 			return {
	 			  //must convert json to javascript object before process
	 			  suggestions: $.map($.parseJSON(response), function(item) {
	 			       // strValue  strCode
	 			        mapDPCodeName.set(item.strValue,item.strCode);
	 			      	return { value: item.strValue, data: item.strCode };
	 			   })
	 			            
	 			 };
	 			        
	 	        }
	 		 });
			 
				$('#txtDPName').blur(function() {
						var code=mapDPCodeName.get($('#txtDPName').val());
						if(code!='' && code!=null){
							funSetData(code);
						}
						
				});
		  
	});
	
	 
</script>
<script type="text/javascript">

var selectedRowIndex=0;
var areaCode, areaName;
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
			}%>
		});
	
	var fieldName;

	

	function funSetData(code){

		switch(fieldName){

			case 'POSDeliveryBoyMaster' : 
				funSetDeliveryBoyDtl(code);
				break;
			case 'POSCustomerAreaMaster':
			funSetCustomerArea(code);
				break;
		}
	}

	function funSetCustomerArea(code)
	{
		$("#txtAreaCode").val(code);
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
			        		$("#txtAreaCode").val('');
			        	}
			        	else
			        	{
			        		
				        	areaCode=code;
				        	areaName=response.strCustomerAreaName;
				        	
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
	
	function funSetDeliveryBoyDtl(code){

			$("#txtDPCode").val(code);
			var searchurl=getContextPath()+"/loadPOSDeliveryBoyMasterData.html?dpCode="+code;		
			 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strTableNo=='Invalid Code')
			        	{
			        		alert("Invalid Delivery Boy Code");
			        		$("#txtDPCode").val('');
			        	}
			        	else
			        	{
				        	$("#txtDPName").val(response.strDPName);
				        	
				        	$("#cmbOperational").val(response.strOperational);
				        	$("#txtAreaCode").val(response.strAreaCode);
				        	$("#txtPayOut").val(response.dblIncentives);
				        	$("#txtDPName").focus();
				        	funRemoveTableRows();
					    	$.each(response.listDeliveryBoyCharges, function(i,item)
							{		
					    		funAddRow1(item.strAreaCode,item.strAreaName,item.dblIncentives);
					    	});
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


	function funHelp(transactionName)
	{
		fieldName=transactionName;
		  window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	}
	
	function btnAdd_onclick() 
	{
		
		
			if($("#txtAreaCode").val()=="") 
		    {
				confirmDialog("Please select Area","");
		   		
		       	return false;
			}
			else if($("#txtPayOut").val()=="")
		    {
				confirmDialog("Please Enter Incentive","");
		   		
		       	return false;
			}
			else
			{
				funAddRow();
			}
		
	}
	
	function btnRemove_onclick() 
	{
		
		
		var table = document.getElementById("tblDeliveryCharges");
	    table.deleteRow(selectedRowIndex);
		
	}

	
	function funAddRow() 
	{
		var incentives=$("#txtPayOut").val();
	    var table = document.getElementById("tblDeliveryCharges");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	   
	    if(funDuplicateArea(areaCode))
	    {
	    row.insertCell(0).innerHTML= "<input class=\"Box\"  readonly=\"readonly\" name=\"listDeliveryBoyCharges["+(rowCount)+"].strAreaCode\" size=\"22%\"  id=\"txtAreaCode."+(rowCount)+"\" value='"+areaCode+"' onclick=\"funGetSelectedRowIndex(this)\"/>";
	    row.insertCell(1).innerHTML= "<input class=\"Box\"  readonly=\"readonly\" name=\"listDeliveryBoyCharges["+(rowCount)+"].strAreaName\" size=\"40%\"  id=\"txtAreaName."+(rowCount)+"\" value='"+areaName+"' onclick=\"funGetSelectedRowIndex(this)\"/>";
	    row.insertCell(2).innerHTML= "<input class=\"Box\"  readonly=\"readonly\" name=\"listDeliveryBoyCharges["+(rowCount)+"].dblIncentives\" size=\"30%\"  id=\"txtIncentives."+(rowCount)+"\" value='"+incentives+"' onclick=\"funGetSelectedRowIndex(this)\"/>";
	    }	
	}


	function funAddRow1(areaCode,areaName,incentive)
	{		    		    
	    var table = document.getElementById("tblDeliveryCharges");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    	
	    
	   
	    row.insertCell(0).innerHTML= "<input  readonly=\"readonly\" class=\"Box\" name=\"listDeliveryBoyCharges["+(rowCount)+"].strAreaCode\" size=\"25%\"  id=\"txtAreaCode."+(rowCount)+"\" value='"+areaCode+"' onclick=\"funGetSelectedRowIndex(this)\"/>";
	    row.insertCell(1).innerHTML= "<input  readonly=\"readonly\" class=\"Box\" name=\"listDeliveryBoyCharges["+(rowCount)+"].strAreaName\" size=\"30%\"  id=\"txAareaName."+(rowCount)+"\" value='"+areaName+"' onclick=\"funGetSelectedRowIndex(this)\"/>";	    	    
	    row.insertCell(2).innerHTML= "<input  readonly=\"readonly\" class=\"Box\" name=\"listDeliveryBoyCharges["+(rowCount)+"].dblIncentives\" size=\"30%\"  id=\"txtToTime."+(rowCount)+"\" value='"+incentive+"' onclick=\"funGetSelectedRowIndex(this)\"/>";
	    
	}

	 function funRemoveTableRows()
		{
			var table = document.getElementById("tblDeliveryCharges");
			var rowCount = table.rows.length;
			while(rowCount>0)
			{
				table.deleteRow(0);
				rowCount--;
			}
		}
	//Check Duplicate Product in grid
	function funDuplicateArea(areaCode)
	{
	    var table = document.getElementById("tblDeliveryCharges");
	    var rowCount = table.rows.length;
	    var flag=true;
	    if(rowCount > 0)
    	{
		    $('#tblDeliveryCharges tr').each(function()
		    {
			    if(areaCode==$(this).find('input').val())// `this` is TR DOM element
				{
			    	alert("Already added "+ areaCode);
			    	funResetFields();
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
	
	function funCallFormAction() 
		{
			var flg=true;
			var name = $('#txtDPName').val();
			var code= $('#txtDPCode').val();
			
	
				 $.ajax({
				        type: "GET",
				        url: getContextPath()+"/checkDPName.html?name="+name+"&code="+code,
				        async: false,
				        dataType: "text",
				        success: function(response)
				        {
				        	if(response=="false")
				        		{
				        			alert("Delivery Boy Name Already Exist!");
				        			$('#txtDPName').focus();
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
	<label>Delivery Boy Master</label>
	</div>

<br/>
<br/>
	<s:form name="savePOSDeliveryBoyMaster" method="POST" action="savePOSDeliveryBoyMaster.html?saddr=${urlHits}" class="formoid-default-skyblue" style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:100%;min-width:50%;margin-top:2%;">	
	
	<div class="title" style="margin-left: 15%;">
		<div id="tab_container" style="overflow: hidden;">
				<ul class="tabs">
						<li class="active" data-state="tab1" style="width: 10%; padding-left: 2%;margin-left: 10%; height: 25px; border-radius: 4px;">Delivery Boy</li>
						<li data-state="tab2" style="width: 10%; padding-left: 1%; height: 25px; border-radius: 4px;">Delivery Charges</li>						
				</ul> 
				
					<br /> <br />
					
			<div id="tab1" class="tab_content">
				
				<div class="title">
			
				<div class="row" style="background-color: #fff;">
					<div class="element-input col-lg-6" > 
    					<label class="title">Delivery Boy Code</label>
    				</div>
    				<div class="element-input col-lg-6" style="margin-bottom: 10px;"> 
						<s:input class="large" colspan="3" type="text" id="txtDPCode" path="strDPCode" readonly="true" ondblclick="funHelp('POSDeliveryBoyMaster')"/>
					</div>
			 	</div>
			 	<div class="row" style="background-color: #fff;">
					<div class="element-input col-lg-6" > 
    					<label class="title">Delivery Boy Name</label>
    				</div>
    				<div class="element-input col-lg-6" style="margin-bottom: 10px;"> 
						<s:input class="large" colspan="3" type="text" id="txtDPName" path="strDPName"  />
					</div>
			 	</div>
			 	<div class="row" style="background-color: #fff;">
					<div class="element-input col-lg-6" > 
    					<label class="title">Operational</label>
    				</div>
    				<div class="element-input col-lg-6" style="margin-bottom: 10px;"> 
						<s:select id="cmbOperational" path="strOperational" >
							<option value="Y">Yes</option>
					    	<option value="N">No</option>
					    </s:select>
					</div>
			 	</div>
			 	
			 	</div>
			 	
			</div>
			
<!-- 		End of Tab1 -->
			
<!-- 		Start of Tab2 -->
			
	<div id="tab2" class="tab_content">
				
		<div class="title" style=" margin-left: 15%;">
			
				<div class="row" style="background-color: #fff;">
					<div class="element-input col-lg-6" style="width: 50%;" > 
    					<label class="title">Area Code</label>
    				</div>
    				<div class="element-input col-lg-6" style="margin-bottom: 10px; "> 
						<input class="large" colspan="3" type="text" id="txtAreaCode"  readonly="readonly"  ondblclick="funHelp('POSCustomerAreaMaster')"/>
					</div>
			 	</div>
			 	
			 	<div class="row" style="background-color: #fff;">
					<div class="element-input col-lg-6" > 
    					<label class="title">Pay Out</label>
    				</div>
    				<div class="element-input col-lg-6" style="margin-bottom: 10%;"> 
						<input class="large" colspan="3" type="text" id="txtPayOut" style="text-align: right;"/>
					</div>
			 	</div>
			 	
			 	<div class="col-lg-10 col-sm-10 col-xs-10" style="width: 70%;margin-left: 10%;">
			 			<div class="submit col-lg-4 col-sm-4 col-xs-4">
							<input type="Button" value="ADD" id="btnAdd" onclick="return btnAdd_onclick();" />
						</div>
						<div class="submit col-lg-4 col-sm-4 col-xs-4" style="margin-left: -15%;">
							<input type="button" value="REMOVE" onclick="return btnRemove_onclick();" />
						</div>
						<div class="submit col-lg-4 col-sm-4 col-xs-4" style="margin-left: -15%;">
							<input type="reset" value="RESET" onclick="funResetFields()"/>
						</div>
				</div>
					
		</div>
				
						<br/><br/>
						
		 <div class="row" style="background-color: #fff; display: -webkit-box; margin-bottom: 10px; margin-left:5%;">
		 
			 <div style="border: 1px solid #ccc; display: block; height: 150px; overflow-x: hidden; overflow-y: scroll; width: 50%;margin-left: 10%">
						
						<table style="width: 100%;background: #2FABE9; color: white;border: 1px solid #ccc;">
	    					<thead>
	        					<tr>
	            					<th style="width:17%;">Area Code</th>
	            					<th style="width:19%;">Area Name</th>
	            					<th style="width:20%;">Incentives</th>
	        					</tr>	
	    					</thead>
	    				</table>
	    		
	    				<table id="tblDeliveryCharges" style="width: 100%;border: 1px solid #ccc;">
	    					<tbody style="border-top: none">				
						
							</tbody>
	    				</table>
	    				
   	 		 </div>	
   	 		 
   	 	 </div>
				
	</div>
	
<!-- 	End of Tab2 -->
			
</div>
		
		
		<br />
		<div class="col-lg-4 col-sm-4 col-xs-4" style="width: 100%;">
     			<p align="center">
<!--             		<div class="submit col-lg-4 col-sm-4 col-xs-4"><input type="submit" value="SUBMIT" style="margin-left: 100%"/></div>
 -->                      		<div class="submit col-lg-6 col-sm-6 col-xs-6"><input type="submit" value="SUBMIT" style="margin-left: 60%" onclick="funResetFields()" ></div>
          
            		<div class="submit col-lg-5 col-sm-5 col-xs-5"><input type="reset" value="RESET" style="margin-left: -25%" onclick="funResetFields()" ></div>
     			</p>
   		</div>
   		
   	</div>
		

		
	</s:form>
</body>
</html>
