<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
    <%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Menu Head</title>
<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/jquery-confirm.min.css"/>"/>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery-confirm.min.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/confirm-prompt.js"/>"></script>
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

//for Tabs

var fieldName,searchForm,selectedRowIndex=0;
var activeTab="";
//Initialize tab Index or which tab is Active
$(document).ready(function() 
{		
	$(".tab_content").hide();
	$(".tab_content:first").show();

	$("ul.tabs li").click(function() {
		$("ul.tabs li").removeClass("active");
		$(this).addClass("active");
		$(".tab_content").hide();
		activeTab = $(this).attr("data-state");
		$("#" + activeTab).fadeIn();
	
	});
		
	$(document).ajaxStart(function(){
	    $("#wait").css("display","block");
	});
	$(document).ajaxComplete(function(){
	   	$("#wait").css("display","none");
	});
	
	 $("form").submit(function(event)
	 {
		 var txtVal=activeTab;
		 if(txtVal=="tab1")
		 {	 
		 if(($("#txtMenuHeadName").val().trim()==""))
		  {
			 confirmDialog("Please Enter Menu Head Name","");
				return false;
		  }
		  }
		 else if(txtVal=="tab2")
		 {
			 if(($("#txtSubMenuHeadName").val().trim()==""))
			  {
				 confirmDialog("Please Enter Sub Menu Head Name","");
					return false;
			  } 
			 else
			{
				 flg= funForSubMenuHeadValidation();
				 return flg;
			}	 
	   	 }
			 
		  if(txtVal=="tab3")
		  {
			funForSubMenuHeadValidation();
			  flg=funCallFormAction();
			  return flg;
		  }
		  else
			{
			  flg=funCallFormAction();
			  return flg;
			}	  
		 
		 
		});
});

/*On form Load It Reset form :Ritesh 22 Nov 2014*/
$(document).ready(function () {
	
	$('input#txtMenuHeadCode').mlKeyboard({layout: 'en_US'});
	$('input#txtMenuHeadName').mlKeyboard({layout: 'en_US'});
	$('input#txtSubMenuHeadCode').mlKeyboard({layout: 'en_US'});
	$('input#txtSubMenuHeadName').mlKeyboard({layout: 'en_US'});
	$('input#txtSubMenuHeadName').mlKeyboard({layout: 'en_US'});
	$('input#strSubMenuHeadShortName').mlKeyboard({layout: 'en_US'});
	
   $("#txtMenuHeadName").focus();
   //$("#tab3").click(function funSetTable());
    $("#t3").on("click", function(){
       $("#tableLoad").load(funLoadMenuHeadData());
     }); 
   
   }); 


/**
* Reset The Group Name TextField
**/
function funResetFields()
{
	$("#txtMenuHeadName").focus();
	$("#cmbOperational").val('N');
}

function funForSubMenuHeadValidation()
{
	var flg=true;
		if($("#txtSubMenuHeadName").val().trim() != "")
		{
		if($("#txtSubMenuHeadShortName").val().trim()=="")
		{
			confirmDialog("Please Enter Short Name For Sub Menu","");
				return false; 
		}	 
		if($("#txtMenuHeadCodeInSub").val().trim()=="")
		{
			confirmDialog("Please Enter Menu Head Name","");
				return false; 
		}
		flg=false;
		}
	
}

function funMoveSelectedRow(count)
{
	if(count==1)
		{
			if (selectedRowIndex == 0)
			{
				//do nothing
			}
			else
			{
			  var table = document.getElementById("tblMenuDet");
			  var menuHeadCode=table.rows[selectedRowIndex].cells[1].innerHTML;
			  var menuHeadName=table.rows[selectedRowIndex].cells[2].innerHTML; 
			  var menuHeadCode1=table.rows[selectedRowIndex-1].cells[1].innerHTML;
			  var menuHeadName1=table.rows[selectedRowIndex-1].cells[2].innerHTML; 
			  funMoveRowUp(menuHeadCode,menuHeadName,selectedRowIndex,menuHeadCode1,menuHeadName1);
			}
			
		}
		else
		{
			var table = document.getElementById("tblMenuDet");
			var rowCount = table.rows.length;
			if(rowCount>0)
			{
				var table = document.getElementById("tblMenuDet");
				var menuHeadCode=table.rows[selectedRowIndex].cells[1].innerHTML;
				var menuHeadName=table.rows[selectedRowIndex].cells[2].innerHTML; 
				var menuHeadCode1=table.rows[selectedRowIndex+1].cells[1].innerHTML;
				var menuHeadName1=table.rows[selectedRowIndex+1].cells[2].innerHTML; 
				funMoveRowDown(menuHeadCode,menuHeadName,selectedRowIndex,menuHeadCode1,menuHeadName1);
			}
			
		}
}


function funGetSelectedRowIndex(obj)
{
	 var index = obj.parentNode.parentNode.rowIndex;
	 var table = document.getElementById("tblMenuDet");
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


function funLoadMenuHeadData()
{

	var searchurl=getContextPath()+"/loadMenuHeadData.html";
	 $.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        
		        success: function (response) {
		        	funRemoveProductRows();
		           // for (var i in response){		            	
		            	$.each(response,function(i,item){
		            	
		            		funfillMenuDetail(response[i].sequenceNo,response[i].strMenuHeadCode,response[i].strMenuHeadName);
		            	});
		    
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

function funfillMenuDetail(strSequenceNo,strMenuHeadCode,strMenuHeadName)
{
	var table = document.getElementById("tblMenuDet");
	var rowCount = table.rows.length;
	var row = table.insertRow(rowCount);
	var i=1;
	var seqNo = parseInt(strSequenceNo)+i;
      row.insertCell(0).innerHTML= "<input name=\"listMenuMasterDtl["+(rowCount)+"].sequenceNo\" readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\""+(rowCount)+"\" value='"+seqNo+"' onclick=\"funGetSelectedRowIndex(this)\"/>";
	  row.insertCell(1).innerHTML= "<input name=\"listMenuMasterDtl["+(rowCount)+"].strMenuHeadCode\" readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\"txtMenuHeadCode."+(rowCount)+"\" value='"+strMenuHeadCode+"'onclick=\"funGetSelectedRowIndex(this)\"/>";
	  row.insertCell(2).innerHTML= "<input name=\"listMenuMasterDtl["+(rowCount)+"].strMenuHeadName\" readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\"txtMenuHeadName."+(rowCount)+"\" value='"+strMenuHeadName+"' onclick=\"funGetSelectedRowIndex(this)\"/>";
	
}


function funMoveRowUp(strMenuHeadCode,strMenuHeadName,rowCount,strMenuHeadCode1,strMenuHeadName1)
{
	var table = document.getElementById("tblMenuDet");
    table.deleteRow(rowCount);
    var row = table.insertRow(rowCount-1);
    row = table.rows[rowCount-1];
	
	var codeArr = strMenuHeadCode.split('value=');
	var code=codeArr[1].split('onclick=');
	var menuCode=code[0].substring(1, (code[0].length-2));
	var nameArr = strMenuHeadName.split('value=');
	var name=nameArr[1].split('onclick=');
	var menuName=name[0].substring(1, (name[0].length-2));
	
// 	listMenuMasterDtl[row].strMenuHeadName=menuName;
// 	listMenuMasterDtl[row].strMenuHeadCode=menuCode;
	
	  row.insertCell(0).innerHTML= "<input name=\ readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\""+(rowCount)+"\" value='"+(rowCount)+"' onclick=\"funGetSelectedRowIndex(this)\"/>";
	  row.insertCell(1).innerHTML= "<input name=\ readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\"txtMenuHeadCode."+(rowCount)+"\" value='"+menuCode+"'onclick=\"funGetSelectedRowIndex(this)\"/>";
	  row.insertCell(2).innerHTML= "<input name=\ readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\"txtMenuHeadName."+(rowCount)+"\" value='"+menuName+"' onclick=\"funGetSelectedRowIndex(this)\"/>";
	  row = table.rows[rowCount-1];
	  row.style.backgroundColor='#ffd966';
	  selectedRowIndex=rowCount-1;
	    
	 var nextcodeArr = strMenuHeadCode1.split('value=');
     var nextcode=nextcodeArr[1].split('onclick=');
	 var nextmenuCode=nextcode[0].substring(1, (nextcode[0].length-2));
	 var nextnameArr = strMenuHeadName1.split('value=');
	 var nextname=nextnameArr[1].split('onclick=');
	 var nextmenuName=nextname[0].substring(1, (nextname[0].length-2));  
	 var row1 = table.insertRow(rowCount+1);
	 
	  row1.insertCell(0).innerHTML= "<input name=\ readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\""+(rowCount+1)+"\" value='"+(rowCount+1)+"' onclick=\"funGetSelectedRowIndex(this)\"/>";
	  row1.insertCell(1).innerHTML= "<input name=\ readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\"txtMenuHeadCode."+(rowCount)+"\" value='"+nextmenuCode+"'onclick=\"funGetSelectedRowIndex(this)\"/>";
	  row1.insertCell(2).innerHTML= "<input name=\ readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\"txtMenuHeadName."+(rowCount)+"\" value='"+nextmenuName+"' onclick=\"funGetSelectedRowIndex(this)\"/>";
	  table.deleteRow(rowCount);
}



function funMoveRowDown(strMenuHeadCode,strMenuHeadName,rowCount,strMenuHeadCode1,strMenuHeadName1)
{
	var table = document.getElementById("tblMenuDet");
    table.deleteRow(rowCount);
    var row = table.insertRow(rowCount+1);
    row = table.rows[rowCount+1];
	
	var codeArr = strMenuHeadCode.split('value=');
	var code=codeArr[1].split('onclick=');
	var menuCode=code[0].substring(1, (code[0].length-2));
	var nameArr = strMenuHeadName.split('value=');
	var name=nameArr[1].split('onclick=');
	var menuName=name[0].substring(1, (name[0].length-2));
	
	  row.insertCell(0).innerHTML= "<input name=\ readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\""+(rowCount+2)+"\" value='"+(rowCount+2)+"' onclick=\"funGetSelectedRowIndex(this)\"/>";
	  row.insertCell(1).innerHTML= "<input name=\ readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\"txtMenuHeadCode."+(rowCount)+"\" value='"+menuCode+"'onclick=\"funGetSelectedRowIndex(this)\"/>";
	  row.insertCell(2).innerHTML= "<input name=\ readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\"txtMenuHeadName."+(rowCount)+"\" value='"+menuName+"' onclick=\"funGetSelectedRowIndex(this)\"/>";
	  row = table.rows[rowCount+1];
	  row.style.backgroundColor='#ffd966';
	  selectedRowIndex=rowCount+1;
	  
	var nextcodeArr = strMenuHeadCode1.split('value=');
    var nextcode=nextcodeArr[1].split('onclick=');
	var nextmenuCode=nextcode[0].substring(1, (nextcode[0].length-2));
	var nextnameArr = strMenuHeadName1.split('value=');
	var nextname=nextnameArr[1].split('onclick=');
	var nextmenuName=nextname[0].substring(1, (nextname[0].length-2));  
	var row1 = table.insertRow(rowCount);
	 
	  row1.insertCell(0).innerHTML= "<input name=\"listMenuMasterDtl["+(rowCount)+"].sequenceNo\" readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\""+(rowCount+1)+"\" value='"+(rowCount+1)+"' onclick=\"funGetSelectedRowIndex(this)\"/>";
	  row1.insertCell(1).innerHTML= "<input name=\"listMenuMasterDtl["+(rowCount)+"].strMenuHeadCode\" readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\"txtMenuHeadCode."+(rowCount)+"\" value='"+nextmenuCode+"'onclick=\"funGetSelectedRowIndex(this)\"/>";
	  row1.insertCell(2).innerHTML= "<input name=\"listMenuMasterDtl["+(rowCount)+"].strMenuHeadName\" readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\"txtMenuHeadName."+(rowCount)+"\" value='"+nextmenuName+"' onclick=\"funGetSelectedRowIndex(this)\"/>";
	  table.deleteRow(rowCount+1);
	  
}

//Remove Table data when pass a table ID as parameter
function funRemoveProductRows()
		{
			var table = document.getElementById("tblMenuDet");
			var rowCount = table.rows.length;
			while(rowCount>0)
			{
				table.deleteRow(0);
				rowCount--;
			}
		}

	/**
	* Open Help
	**/
	function funHelp(transactionName)
	{	    
		searchForm=transactionName;
       // window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
       window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
    }
	
	/**
	* Get and Set data from help file and load data Based on Selection Passing Value(Group Code)
	**/
	function funSetData(code)
	{
		switch (searchForm)
		{
		case 'POSMenuHeadMaster':
	    	funSetMenuHeadCode(code);
			break;
	        
	    case 'POSSubMenuHeadMaster':			    	
	    	funSetSubMenuHeadCode(code)
	        break;
	        
		}
	}
		
	function funSetSubMenuHeadCode(code)
	{
		$("#txtSubMenuHeadCode").val(code);
		var searchurl=getContextPath()+"/loadPOSSubMenuHeadMasterData.html?POSSubMenuHeadCode="+code;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strSubMenuHeadCode=='Invalid Code')
			        	{
			        		confirmDialog("Invalid Sub Menu Code","");
			        		$("#txtSubMenuHeadCode").val('');
			        	}
			        	else
			        	{
			        		
			        		$("#txtSubMenuHeadCode").val(response.strSubMenuHeadCode);
				        	$("#txtSubMenuHeadName").val(response.strSubMenuHeadName);
				        	$("#txtSubMenuHeadName").focus();
				        	$("#txtMenuHeadCodeInSub").val(response.strMenuHeadCode);
				        	$("#txtSubMenuHeadShortName").val(response.strSubMenuHeadShortName);
				        	$("#cmbSubMenuOperational").val(response.strSubMenuOperational);
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
	function funSetMenuHeadCode(code)
	{
		$("#txtMenuHeadCode").val(code);
		var searchurl=getContextPath()+"/loadPOSMenuHeadMasterData.html?POSMenuHeadCode="+code;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strMenuHeadCode=='Invalid Code')
			        	{
			        		confirmDialog("Invalid Menu Code","");
			        		$("#txtMenuHeadCode").val('');
			        		
			        	}
			        	else
			        	{
			        		$("#txtMenuHeadCodeInSub").val(response.strMenuHeadCode);
				        	$("#txtMenuHeadCode").val(response.strMenuHeadCode);
				        	$("#txtMenuHeadName").val(response.strMenuHeadName);
				        	$("#txtMenuHeadName").focus();
				        	$("#cmbOperational").val(response.strOperational);
				        	$("#txtMenuHeadCodeInSub").val(response.strMenuHeadCode);
				        	
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
		
		 if($('#txtMenuHeadName').val()!='')
		{ 
			var menuName = $('#txtMenuHeadName').val();
			var code= $('#txtMenuHeadCode').val();
			var checkUrl =getContextPath()+"/checkMenuName.html?menuName="+menuName+"&menuCode="+code;
			 $.ajax({
			        type: "GET",
			        url: checkUrl,
			        async: false,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response==false)
			        		{
			        			alert("Menu Name Already Exist!");
			        			$('#txtMenuHeadName').focus();
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
		 if($('#txtSubMenuHeadName').val()!='')
		{ 
			var code = $('#txtSubMenuHeadCode').val();
			var name= $('#txtSubMenuHeadName').val();
			 $.ajax({
			        type: "GET",
			        url: getContextPath()+"/checkSubMenuName.html?subMenuName="+name+"&subMenuCode="+code,
			        async: false,
			        dataType: "text",
			        success: function(response)
			        {
			        	if(response==false)
			        		{
			        			alert("Sub Menu Name Already Exist!");
			        			$('#txtSubMenuHeadName').focus();
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

</script>
</head>
<body>

<div id="formHeading">
		<label>Menu Head Master</label>
	</div>


	<s:form name="MenuHead" method="POST" action="saveMenuHeadMaster.html" class="formoid-default-skyblue" style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:880px;min-width:150px;margin-top:2%;">
		<br> 
		<br>
	<div style="margin-left: 190px;">
		<div id="tab_container" style="height: 405px; overflow: inherit;">
				<ul class="tabs">
					<li data-state="tab1" style="width: 20%; height: 25px; padding-left: 2%;border-radius: 4px;" class="active" >Menu Head Master</li>
					<li data-state="tab2" style="width: 20%; height: 25px; padding-left: 3%; border-radius: 4px;">Sub Menu Head</li>
					<li data-state="tab3" id="t3" style="width: 20%; height: 25px; padding-left: 1%; border-radius: 4px;">Menu Head Sequence</li>
				</ul>
							
							
				<!-- Menu Head Master Tab Start -->
				
			<div id="tab1" class="tab_content" style="height: 350px">
				
	<br><br>		
					
			<div class="title">
			
				<div class="row" style="background-color: #fff;">
					<div class="element-input col-lg-6" > 
    					<label class="title">Menu Head Code</label>
    				</div>
    				<div class="element-input col-lg-6" style="margin-bottom: 10px;"> 
						<s:input class="large" colspan="3" type="text" id="txtMenuHeadCode" readonly="true" path="strMenuHeadCode"  ondblclick="funHelp('POSMenuHeadMaster')"/>
					</div>
			 	</div>
			 	
			 	<div class="row" style="background-color: #fff;">
					<div class="element-input col-lg-6" > 
    					<label class="title">Menu Head Name</label>
    				</div>
    				<div class="element-input col-lg-6" style="margin-bottom: 10px;"> 
						<s:input class="large" colspan="3" type="text" id="txtMenuHeadName" path="strMenuHeadName" />
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
		
		<!-- Menu Head Master Tab End -->
				
				<!--Sub Menu Head Master Tab Start -->
				
			<div id="tab2" class="tab_content" style="height: 350px">

<br><br>
			<div class="title">
			
				<div class="row" style="background-color: #fff;">
					<div class="element-input col-lg-6" > 
    					<label class="title">Sub Menu Head Code</label>
    				</div>
    				<div class="element-input col-lg-6" style="margin-bottom: 10px;"> 
						<s:input class="large" colspan="3" type="text" id="txtSubMenuHeadCode" readonly="true" path="strSubMenuHeadCode"  ondblclick="funHelp('POSSubMenuHeadMaster')"/>
					</div>
			 	</div>
			 	<div class="row" style="background-color: #fff;">
					<div class="element-input col-lg-6" > 
    					<label class="title">Sub Menu Head Name</label>
    				</div>
    				<div class="element-input col-lg-6" style="margin-bottom: 10px;"> 
						<s:input class="large" colspan="3" type="text" id="txtSubMenuHeadName" path="strSubMenuHeadName" onblur="funForSubMenuHeadValidation()"/>
					</div>
			 	</div>
			 	<div class="row" style="background-color: #fff;">
					<div class="element-input col-lg-6" > 
    					<label class="title">Sub Menu Head Short Name</label>
    				</div>
    				<div class="element-input col-lg-6" style="margin-bottom: 10px;"> 
						<s:input class="large" colspan="3" type="text" id="txtSubMenuHeadShortName" path="strSubMenuHeadShortName" />
					</div>
			 	</div>
			 	<div class="row" style="background-color: #fff;">
					<div class="element-input col-lg-6" > 
    					<label class="title">Menu Head Code</label>
    				</div>
    				<div class="element-input col-lg-6" style="margin-bottom: 10px;"> 
						<s:input class="large" colspan="3" type="text" id="txtMenuHeadCodeInSub" path="strMenuHeadCodeInSub" readonly="true" ondblclick="funHelp('POSMenuHeadMaster')"/>
					</div>
			 	</div>
			 	<div class="row" style="background-color: #fff;">
					<div class="element-input col-lg-6" > 
    					<label class="title">Operational</label>
    				</div>
    				<div class="element-input col-lg-6" style="margin-bottom: 10px;"> 
						<s:select id="cmbSubMenuOperational" path="strSubMenuOperational" >
							<option value="Y">Yes</option>
					    	<option value="N">No</option>
					    </s:select>
					</div>
			 	</div>
			 	
			 </div>
		
			</div>
			
			<!--Sub Menu Head Master Tab End -->
				
				<!-- Menu Head Sequence Tab Start -->
				
				
	<div id="tab3" class="tab_content" style="height: 350px " onload="funLoadMenuHeadData()">
	
	<br><br>
	
		 <div class="container" style="background-color: #fff; width: 100%;">
		 	<div class="col-xs-4" style="margin-left: 0%; width: 88%;">
      	 		<div id="tableLoad">	
			
					<table class="scroll" style="width: 70%;border: 1px solid #ccc;"" >
    					<thead style="background: #2FABE9; color: white;">
        					<tr> 
            					<th>Sequence No.</th>
            					<th style="width: 27%;">Menu Head</th>
            					<th>CodeMenu Head Name</th>
        					</tr>	
    					</thead>
    				</table>
    		
    				<table class="scroll" id="tblMenuDet" style="width: 70%;border: 1px solid #ccc;"">
    					<tbody style="border-top: none">				
					
						</tbody>
    				</table>
    				
    			</div>
   	 		 </div>	
   	 		 &nbsp; &nbsp; &nbsp;
   	 		 <br/><br/><br/><br/><br/><br/><br/><br>
   	 		 
			<div style="margin-left: 110px;">
	 			<img  src="../${pageContext.request.contextPath}/resources/images/imgMoveUp.png" onclick="funMoveSelectedRow(1)">
				<img  src="../${pageContext.request.contextPath}/resources/images/imgMoveDown.png" onclick="funMoveSelectedRow(0)">
			</div>
		 </div>	
	 </div>
		 
			<div id="wait" style="display:none;width:60px;height:60px;border:0px solid black;position:absolute;top:45%;left:45%;padding:2px;">
				<img src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif" width="60px" height="60px" />
			</div>
   	 	 
			<div class="col-lg-10 col-sm-10 col-xs-10" style="width: 100%;">
     			<p align="center">
            		<div class="submit col-lg-4 col-sm-4 col-xs-4"><input type="submit" value="Submit" style="margin-left: 10%;"/></div>
          
            		<div class="submit col-lg-4 col-sm-4 col-xs-4"  style="margin-left: -10%;"><input type="reset" value="Reset" onclick="funResetFields()"></div>
     			</p>
   			</div>
   
   </div>
  </div>

			 </s:form>
</body>
</html>