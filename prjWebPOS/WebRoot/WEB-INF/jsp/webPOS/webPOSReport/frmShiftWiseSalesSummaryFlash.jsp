<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>ShiftWise Sales Summary Flash</title>
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

.cell {
	background: inherit;
	border: 0 solid #060006;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	outline: 0 none;
	font-weight: bold;
	padding-left: 0;
	width: 80%
}

.header {
	border: #c0c0c0 1px solid;
	background: #78BEF9;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	font-weight: bold;
	outline: 0 none;
	padding-left: 0;
	width: 100%;
	height: 100%
}
</style>
<script type="text/javascript">

var gEnableShiftYN="${gEnableShiftYN}";
$(document).ready(function() {
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
	alert(message);
<%}
			}%>
	$(document).ajaxStart(function() {
							$("#wait").css("display", "block");
						});
						$(document).ajaxComplete(function() {
							$("#wait").css("display", "none");
						});
						$(function() {
							var POSDate = "${POSDate}"
							var startDate = "${POSDate}";
							var Date = startDate.split(" ");
							var arr = Date[0].split("-");
							Dat = arr[2] + "-" + arr[1] + "-" + arr[0];
							$("#txtFromDate").datepicker({
								dateFormat : 'dd-mm-yy'
							});
							$("#txtFromDate").datepicker('setDate', Dat);
							$("#txtToDate").datepicker({
								dateFormat : 'dd-mm-yy'
							});
							$("#txtToDate").datepicker('setDate', Dat);

							funLoadTableData();

						});
						$("[type='reset']").click(function() {
							location.reload(true);
						});
						$("form").submit(function(event) {
							var table = document.getElementById("tblKDSFlash");
							var rowCount = table.rows.length;
							if (rowCount > 2) {
								$("#txtFromDate").val(fDate);
								$("#txtToDate").val(tDate);
								return true;
							} else {
								alert("Data Not Available");
								return false;
							}
						});
						$("#execute").click(
								function(event) {
									var fromDate = $("#txtFromDate").val();
									var toDate = $("#txtToDate").val();

									if (fromDate.trim() == ''
											&& fromDate.trim().length == 0) {
										alert("Please Enter From Date");
										return false;
									}
									if (toDate.trim() == ''
											&& toDate.trim().length == 0) {
										alert("Please Enter To Date");
										return false;
									}
									if (funDeleteTableAllRows()) {
										if (funCalculateDateDiff(fromDate,
												toDate)) {
											fDate = fromDate;
											tDate = toDate;
											funLoadShiftFlashData();
										}
									}
								});

						/* if (gEnableShiftYN == 'Y') {
							document.getElementById("lblShift").style.visibility = "visible";
							document.getElementById("txtShiftCode").style.visibility = "visible";
						} else {
							document.getElementById("lblShift").style.visibility = "hidden";
							document.getElementById("txtShiftCode").style.visibility = "hidden";

						}
						 */
					});
	function funLoadTableData() {
		funLoadShiftFlashData();

	}
	function funLoadShiftFlashData() {
		var fromDate = $('#txtFromDate').val();
		var toDate = $('#txtToDate').val();
		var ShiftCode=$('#cmbShiftCode').val();
		var posName=$('#cmbPOSName').val();
		var SettleName=$('#cmbSettleName').val();
		var GroupName=$('#cmbGroupName').val();
		var OperationType = $('#cmbOperationType').val();	
		
		var gurl = getContextPath() + "/loadShiftWiseSummaryFlash.html";
		
		
		$.ajax({
			type : "GET",
			data:{  fromDate:fromDate,
					toDate:toDate,
					ShiftCode:ShiftCode,
					posName:posName,
					SettleName:SettleName,
					GroupName:GroupName,
					OperationType:OperationType,
				},
			url : gurl,
			dataType : "json",
			success : function(response) {
				if (response.status =="Not Found") 
				{
					alert("Data Not Found");
				} else 
				{
					//Add Sub Category Headers
					funAddHeaderRow(response.ColHeader);
					
					if(reportType=="Group")
					{
						$.each(response.listArr,function(i,item){
			            	
							funFillTableWith3Col(item[0],item[1],item[2]);
		            	});
					}
					else if(reportType=="SubGroup")
					{
						$.each(response.listArr,function(i,item)
						{
							if(item.length==2)
							{
								funFillTableWith10Col(item[0],item[1],"","","","","","","","",'red');
							}
							else
							{
								funFillTableWith10Col(item[0],item[1],item[2],item[3],item[4],item[5],item[6],item[7],item[8],item[9],'dark gray');
							}
		            	});
					}
					else if(reportType=="Menu Head")
					{
						$.each(response.listArr,function(i,item){
			            	
							funFillTableWith3Col(item[0],item[1],item[2]);
		            	});
					}
					else 
					{
						$.each(response.listArr,function(i,item)
						{
							if(item.length==2)
							{
								funFillTableWith12Col(item[0],item[1],"","","","","","","","","","",'red');
							}
							else
							{
								funFillTableWith12Col(item[0],item[1],item[2],item[3],item[4],item[5],item[6],item[7],item[8],item[9],item[10],item[11],'dark gray');
							}
		            	});
					}
					
					
					funFillTotalData(response.totalList);
				}//Else block Of Response
				
				
			
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
	
	function funDeleteTableAllRows() {
		$('#tblShiftFlashSummary tbody').empty();
		$('#tblTotal tbody').empty();
		var table = document.getElementById("tblShiftFlashSummary");
		var rowCount1 = table.rows.length;
		if (rowCount1 == 0) {
			return true;
		} else {
			return false;
		}
	}
	function funAddHeaderRow(rowData)
 	{
		var table = document.getElementById("tblShiftFlashSummary");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    
	    
		    for(var i=0;i<rowData.length;i++)
		    {
		    	if(i==0){
	    			 row.insertCell(i).innerHTML= "<input type=\"text\" readonly=\"readonly\" class=\"header\" name=\"colRow["+(rowCount)+"].strCol"+(i)+"\" value='"+rowData[i]+"' />";
	    		 } else {
		    			row.insertCell(i).innerHTML= "<input type=\"text\" readonly=\"readonly\" class=\"header\" name=\"colRow["+(rowCount)+"].strCol"+(i)+"\" value='"+rowData[i]+"' />";
		    			
		    		}
				}
		}
	function funCalculateDateDiff(fromDate, toDate) {

		var frmDate = fromDate.split('-');
		var fDate = new Date(frmDate[2], frmDate[1], frmDate[0]);

		var tDate = toDate.split('-');
		var t1Date = new Date(tDate[2], tDate[1], tDate[0]);

		var dateDiff = t1Date - fDate;
		if (dateDiff >= 0) {
			return true;
		} else {
			alert("Please Check From Date And To Date");
			return false
		}
	}
</script>
</head>
<body>
	<div id="formHeading">
		<label>Shift Wise Sales Summary Flash</label>
	</div>
	<s:form name="frmShiftWiseSalesSummaryFlash" method="POST"
		action="frmShiftWiseSalesSummaryFlash.html?saddr=${urlHits}"
		target="_blank" class="formoid-default-skyblue"
		style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;margin-top:2%;">

		<div class="title">

			<div class="row"
				style="background-color: #fff; display: block; margin-bottom: 10px;">
				<div class="element-input col-lg-6" style="width: 8%;">
					<label class="title">POS Name</label>
				</div>
				<div class="element-input col-lg-6" style="width: 15%;">
					<s:select id="cmbPOSName" name="cmbPOSName" path="strPOSName"
						items="${posList}">
					</s:select>
				</div>

				<div class="element-input col-lg-6" style="width: 8%;">
					<label class="title">From Date</label>
				</div>
				<div class="element-input col-lg-6" style="width: 15%;">
					<s:input id="txtFromDate" required="required" path="fromDate"
						pattern="\d{1,2}-\d{1,2}-\d{4}" style="width: 100%;" />

				</div>
				<div class="element-input col-lg-6" style="width: 8%;">
					<label class="title">To Date</label>
				</div>
				<div class="element-input col-lg-6" style="width: 17%;">
					<s:input id="txtToDate" required="required" path="toDate"
						pattern="\d{1,2}-\d{1,2}-\d{4}" style="width: 100%;" />
				</div>
				<div class="element-input col-lg-6" style="width: 8%;">
					<label class="title">Shift Type</label>
				</div>
				<div class="element-input col-lg-6" style="width: 10%;">
					<s:select colspan="3" type="text" items="${shiftList}"
						id="cmbShiftCode" path="strShiftCode" />
				</div>
				<div class="element-input col-lg-6" style="width: 5%;">
					<s:checkbox element="li" id="chkWithDiscount"
						path="strWithDiscount" value="Yes" />

				</div>
				<div class="element-input col-lg-6" style="width: 8%;">
					<label class="title">With Discount</label>
				</div>
			</div>

			<div class="row"
				style="background-color: #fff; display: block; margin-bottom: 10px;">

				<div class="element-input col-lg-6" style="width: 8%;">
					<label class="title">Settlement Name</label>
				</div>
				<div class="element-input col-lg-6" style="width: 15%;">
					<s:select id="cmbSettleName" name="cmbSettleName"
						path="strSettlementName" items="${settlementList}">
					</s:select>
				</div>
				<div class="element-input col-lg-6" style="width: 8%;">
					<label class="title">Operation Type</label>
				</div>
				<div class="element-input col-lg-6" style="width: 15%;">
					<s:select id="cmbOperationType" path="strOperationType">
						<s:option value="All">All</s:option>
						<s:option value="DineIn">DineIn</s:option>
						<s:option value="DirectBiller">DirectBiller</s:option>
						<s:option value="HomeDelivery">HomeDelivery</s:option>
						<s:option value="TakeAway">TakeAway</s:option>

					</s:select>
				</div>
				<div class="element-input col-lg-6" style="width: 8%;">
					<label class="title">Group Name</label>
				</div>
				<div class="element-input col-lg-6" style="width: 15%;">
					<s:select id="cmbGroupName" path="strGroupName"
						items="${groupList}" />
				</div>
				<div class="element-input col-lg-6" style="width: 30%;">
					<input type="button" value="Execute" id="execute" /> <input
						type="submit" value="EXPORT" id="submit" /> <input type="button"
						value="Close" id="close" />
				</div>
			</div>

			<div class="row"
				style="background-color: #fff; display: block; margin-bottom: 10px; margin-left: 0px;">
				<div
					style="border: 1px solid #ccc; display: block; height: 500px; margin: auto; overflow-x: scroll; overflow-y: scroll; width: 100%;">

					<table id="tblShiftFlashSummary"
						style="width: 100%; text-align: center !important;">

						<tbody style="border-top: none; border-bottom: 1px solid #ccc;">
						</tbody>
					</table>


				</div>
			</div>

			<div class="row"
				style="background-color: #fff; display: block; margin-bottom: 10px; margin-left: 0px;">
				<div
					style="border: 1px solid #ccc; display: block; height: 30%; margin: auto; overflow-x: scroll; overflow-y: scroll; width: 100%;">

					<table id="tblTotal"
						style="width: 100%; text-align: left !important; margin-top: 3px; overflow-x: scroll; overflow-y: scroll;">

						<tbody style="border-top: none;">
						</tbody>

					</table>

				</div>
			</div>
			<br />

			<div class="col-lg-10 col-sm-10 col-xs-10"
				style="width: 100%; margin-left: 10%;">

				<p align="center"></p>

			</div>
			<div id="wait"
				style="display: none; width: 60px; height: 60px; border: 0px solid black; position: absolute; top: 50%; left: 50%; padding: 2px;">
				<img
					src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif"
					width="60px" height="60px" />
			</div>

		</div>



	</s:form>

</body>
</html>