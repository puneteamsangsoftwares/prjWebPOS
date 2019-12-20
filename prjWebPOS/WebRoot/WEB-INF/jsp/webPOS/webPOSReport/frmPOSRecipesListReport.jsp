<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Recipes List </title>
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

var fieldName;
/**
 * Reset Textfield
 */
function funResetFields()
{
	$("#txtItemCode").val('');
}
/**
 * Open help windows
 */
function funHelp(transactionName)
{
	fieldName=transactionName;
//	 window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	 window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
}
/**
 * Set Data after selecting form Help windows
 */
function funSetData(code)
{
	$("#txtItemCode").val(code);
}


function funGetGroupData()
{
	var searchUrl = getContextPath() + "/loadAllGroupData.html";
	
	$.ajax({
		type : "GET",
		url : searchUrl,
		dataType : "json",
		beforeSend : function(){
			 $("#wait").css("display","block");
	    },
		success : function(response) {
			funRemRows("tblGroup");
			$.each(response, function(i,item)
	 		{
				funfillGroupGrid(response[i].strGroupCode,response[i].strGroupName);
			});
			funGroupChkOnClick();
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
 * Filling Group data in Grid
 */
function funfillGroupGrid(strGroupCode,strGroupName)
{
	
	 	var table = document.getElementById("tblGroup");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    
	    row.insertCell(0).innerHTML= "<input id=\"cbGSel."+(rowCount)+"\" type=\"checkbox\" class=\"GCheckBoxClass\" checked=\"checked\" onclick=\"funGroupChkOnClick()\"/>";
	    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" id=\"strGCode."+(rowCount)+"\" value='"+strGroupCode+"' >";
	    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"50%\" id=\"strGName."+(rowCount)+"\" value='"+strGroupName+"' >";
}

/**
 * After Select Group Data get the SubGroup Data
**/
function funGroupChkOnClick()
{
	var table = document.getElementById("tblGroup");
    var rowCount = table.rows.length;  
    var strGCodes="";
    for(no=0;no<rowCount;no++)
    {
        if(document.all("cbGSel."+no).checked==true)
        	{
        		if(strGCodes.length>0)
        			{
        				strGCodes=strGCodes+","+document.all("strGCode."+no).value;
        			}
        		else
        			{
        			strGCodes=document.all("strGCode."+no).value;
        			}
        	}
    }
    funGetSubGroupData(strGCodes);
}

/**
 * Getting SubGroup Based on Group Code Passing Value(Group Code)
**/
function funGetSubGroupData(strGCodes)
{
	strCodes = strGCodes.split(",");
	var count=0;
	funRemRows("tblSubGroup");
	for (ci = 0; ci < strCodes.length; ci++) 
	 {
		var searchUrl = getContextPath() + "/loadSubGroupCombo.html?code="+ strCodes[ci];
		$.ajax({
			type : "GET",
			url : searchUrl,
			dataType : "json",
			beforeSend : function(){
				 $("#wait").css("display","block");
		    },
		    complete: function(){
		    	 $("#wait").css("display","none");
		    },
			success : function(response)
			{
				
				$.each(response, function(i,item)
				 		{
							funfillSubGroup(response[i].strSubGroupCode,response[i].strSubGroupName);
						});
				
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

/**
 * Filling SubGroup data in grid
**/
function funfillSubGroup(strSGCode,strSGName) 
{
	var table = document.getElementById("tblSubGroup");
    var rowCount = table.rows.length;
    var row = table.insertRow(rowCount);
    
    row.insertCell(0).innerHTML= "<input id=\"cbSGSel."+(rowCount)+"\" type=\"checkbox\" checked=\"checked\" name=\"SubGroupthemes\" value='"+strSGCode+"' class=\"SGCheckBoxClass\" />";
    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" id=\"strSGCode."+(rowCount)+"\" value='"+strSGCode+"' >";
    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"50%\" id=\"strSGName."+(rowCount)+"\" value='"+strSGName+"' >";
}

    /**
     * Remove All Row from Table Passing Value(Table Id)
    **/
	function funRemRows(tableName) 
	{
		var table = document.getElementById(tableName);
		var rowCount = table.rows.length;
		while(rowCount>0)
		{
			table.deleteRow(0);
			rowCount--;
		}
	}
	
	/**
	 * Select All Group, SubGroup
	**/
	 $(document).ready(function () 
		{
			$("#chkSGALL").click(function () {
			    $(".SGCheckBoxClass").prop('checked', $(this).prop('checked'));
			});
			
			$("#chkGALL").click(function () 
			{
			    $(".GCheckBoxClass").prop('checked', $(this).prop('checked'));
			    funGroupChkOnClick();
			});
			
			funGetGroupData();

			
		});
	 
	 /**
	  * Checking Validation when user Click On Submit Button
     **/
function btnSubmit_OnClick() 
{	
 var strSubGroupCode="";
 $('input[name="SubGroupthemes"]:checked').each(function() {
	 if(strSubGroupCode.length>0)
		 {
		 	strSubGroupCode=strSubGroupCode+","+this.value;
		 }
		 else
		 {
			 strSubGroupCode=this.value;
		 }
	});
 $("#hidSubCodes").val(strSubGroupCode);
 return true;
}
	 
	 $(document).ready(function()
	    		{
	    	var tablename='';
	    			$('#searchGrp').keyup(function()
	    			{
	    				tablename='#tblGroup';
	    				searchTable($(this).val(),tablename);
	    			});
	    			$('#searchSGrp').keyup(function()
	    	    			{
	    						tablename='#tblSubGroup';
	    	    				searchTable($(this).val(),tablename);
	    	    			});
	    		});

			    /**
				 * Function for Searching in Table Passing value(inputvalue and Table Id) 
				 */
	    		function searchTable(inputVal,tablename)
	    		{
	    			var table = $(tablename);
	    			table.find('tr').each(function(index, row)
	    			{
	    				var allCells = $(row).find('td');
	    				if(allCells.length > 0)
	    				{
	    					var found = false;
	    					allCells.each(function(index, td)
	    					{
	    						var regExp = new RegExp(inputVal, 'i');
	    						if(regExp.test($(td).find('input').val()))
	    						{
	    							found = true;
	    							return false;
	    						}
	    					});
	    					if(found == true)$(row).show();else $(row).hide();
	    				}
	    			});
	    		}
	    
	 
	 /**
	   * Reset from
	 **/
	 function funResetFields()
		{
			location.reload(true); 
		}

</script>


</head>
<body >
	<div id="formHeading">
		<label>Recipe List Report</label>
	</div>
	<s:form name="POSRecipeListReportForm" method="GET" action="rptPOSRecipeList.html?saddr=${urlHits}" target="_blank" class="formoid-default-skyblue" style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:880px;min-width:150px;margin-top:2%;">

		<br />
		<br />
		<div class="title" style="margin-left: 30%;">
		
			<div class="row" style="background-color: #fff;display: block;">
				<div class="element-input col-lg-6" style="width: 20%;margin-top:1.5% " > 
    				<label class="title">POS Name</label>
    			</div>
    			<div class="element-input col-lg-6" style="margin-bottom:  10px;width: 30%"> 
					<s:select id="cmbPOSName" path="strPOSName" items="${posList}" >
				 	</s:select>
				</div>
			</div>	
			 <div class="row" style="background-color: #fff;display: block;">
			 		<div class="element-input col-lg-6" style="width: 20%;margin-top:1.5%"> 
    					<label class="title">Item Code</label>
	    			</div>
	    			<div class="element-input col-lg-6" style="margin-bottom:  10px;width: 30%">
		    			<s:input id="txtItemCode" path="strItemCode" ondblclick="funHelp('POSMenuItemMaster')" cssClass="searchTextBox" cssStyle="width:150px;background-position: 136px 4px;"/> 
						
					</div>
			</div>
			
		 </div>
		
		<table class="masterTable">
		
		<tr>
		<td width="49%">Group&nbsp;&nbsp;&nbsp;
			<input type="text"  style="width: 50%;background-position: 240px 2px;" 
			id="searchGrp" placeholder="Type to search" Class="searchTextBox">
		 </td>
		 <td width="49%">Sub Group&nbsp;&nbsp;&nbsp;&nbsp;
		  		 <input type="text" id="searchSGrp" 
		  		 style="width: 50%;background-position: 240px 2px;" 
		  		 Class="searchTextBox" placeholder="Type to search">
		 </td>
		  </tr>
			<tr></tr>
			<tr>
				<td style="padding: 0 !important;">
						<div
							style="background-color: #a4d7ff; border: 1px solid #ccc; display: block; height: 150px; overflow-x: hidden; overflow-y: scroll;">
							<table id="" class="display"
								style="width: 100%; border-collapse: separate;">
								<tbody>
									<tr bgcolor="#72BEFC">
										<td width="15%"><input type="checkbox" id="chkGALL"
											checked="checked" onclick="funCheckUncheck()" />Select</td>
										<td width="20%">Group Code</td>
										<td width="65%">Group Name</td>

									</tr>
								</tbody>
							</table>
							<table id="tblGroup" class="masterTable"
								style="width: 100%; border-collapse: separate;">
								<tbody>
									<tr bgcolor="#72BEFC">
										<td width="15%"></td>
										<td width="20%"></td>
										<td width="65%"></td>

									</tr>
								</tbody>
							</table>
						</div>
						</td>
						<td style="padding: 0 !important;">
						<div
							style="background-color: #a4d7ff; border: 1px solid #ccc; display: block; height: 150px; overflow-x: hidden; overflow-y: scroll;">

							<table id="" class="masterTable"
								style="width: 100%; border-collapse: separate;">
								<tbody>
									<tr bgcolor="#72BEFC">
										<td width="15%"><input type="checkbox" id="chkSGALL"
											checked="checked" onclick="funCheckUncheckSubGroup()" />Select</td>
										<td width="25%">Sub Group Code</td>
										<td width="65%">Sub Group Name</td>

									</tr>
								</tbody>
							</table>
							<table id="tblSubGroup" class="masterTable"
								style="width: 100%; border-collapse: separate;">
								<tbody>
									<tr bgcolor="#72BEFC">
										<td width="15%"></td>
										<td width="25%"></td>
										<td width="65%"></td>

									</tr>
								</tbody>
							</table>
						</div>
				</td>
			</tr>
		</table>
	
		<br />
		<br />
		<div class="col-lg-10 col-sm-10 col-xs-10" style="width: 70%;margin-left: 242px;"> 
			 <p align="center">
				<div class="submit col-lg-4 col-sm-4 col-xs-6"><input type="submit" value="Submit" tabindex="3" onclick = "return btnSubmit_OnClick()" /></div>
				<div class="submit col-lg-4 col-sm-4 col-xs-4"style="margin-left:-8%"><input type="button" value="Close" onclick="funPOSHome()"/></div>
			 </p>
		</div>
		<s:input type="hidden" id="hidSubCodes" path="strSGCode"></s:input>
		
	</s:form>

</body>

</html>