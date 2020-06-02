
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    
   	<%-- Started Default Script For Page  --%>
    
		<script type="text/javascript" src="<spring:url value="/resources/js/jQuery.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/jquery-ui.min.js"/>"></script>	
		<script type="text/javascript" src="<spring:url value="/resources/js/validations.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/TreeMenu.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/main.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/jquery.fancytree.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/jquery.numeric.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/jquery.ui-jalert.js"/>"></script>
<%-- 		<script type="text/javascript" src="<spring:url value="/resources/js/pagination.js"/>"></script>
 --%>		<script type="text/javascript" src="<spring:url value="/resources/js/jquery-ui.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/jquery.excelexport.js"/>"></script>
<%-- 		<script type="text/javascript" src="<spring:url value="/resources/js/angular.min.js"/>"></script> --%>
<script type="text/javascript" src="<spring:url value="/resources/js/angular.min.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/angular-cookies.js"/>"></script>
	
	
	<%-- End Default Script For Page  --%>
	
	<%-- Started Default CSS For Page  --%>

	    <link rel="icon" href="${pageContext.request.contextPath}/resources/images/favicon.ico" type="image/x-icon" sizes="16x16">
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	    <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/tree.css"/>" /> 
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/jquery-ui.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/main.css"/>" />
<%-- 	 	<link rel="stylesheet"  href="<spring:url value="/resources/css/pagination.css"/>" />
 --%>	 	<link rel="stylesheet"  href="<spring:url value="/resources/newdesign/vendor/bootstrap/css/bootstrap.min.css"/>" />
 	
 	
 	
 	<%-- End Default CSS For Page  --%>
 	
 	<%--  Started Script and CSS For Select Time in textBox  --%>
	
		<script type="text/javascript" src="<spring:url value="/resources/js/jquery.timepicker.min.js"/>"></script>
	  	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/jquery.timepicker.css"/>" />
	
	<%-- End Script and CSS For Select Time in textBox  --%>
	
 	  
  	<title>Web Stocks</title>
	
	<script type="text/javascript">
	
   	
    $(document).ready(function(){
    	
    	<%-- var posModule = '<%=session.getAttribute("webPOSModuleSelect").toString()%>';
    	var reuqUrl='';
    	if(posModule=='M')
    	{
    		reuqUrl = "frmWebPOSSelectionMaster.html";
    	}
    	if(posModule=='T')
		{
    		reuqUrl = "frmWebPOSSelectionReport.html";
		}
    	if(posModule=='R')
		{
    		reuqUrl = "frmWebPOSSelectionTransection.html";
		}
    	 --%>
    
   });
    
    function funRequestUel()
    {
    	window.location.href = reuqUrl;
    }
   	
   	
	</script>
	
<script  type="text/JavaScript">
document.onkeypress = stopRKey;
function stopRKey(evt) {
              var evt = (evt) ? evt : ((event) ? event : null);
              var node = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
              if (evt.keyCode == 13)  {
                           //disable form submission
                           return false;
              }
}
</script>

<script type="text/javascript">

    	$(function() {
    		
    		var posDate="${gPOSDate}";
    		var clientName="${gCompanyName}"; 
    		
    		funloadClientPhoto();
    		
    		/* var date=posDate.split("-");
    		posDate=date[2]+"-"+date[1]+"-"+date[0];  */
      		$("#lblPOSDate").text(posDate);
    		$("#lblClientName").text(clientName);
      		  		
      		setInterval(function() {
    			var seconds = new Date().getTime() / 1000;
    			var time = new Date(),
      			hours = time.getHours(),
      			min = time.getMinutes(),
      			sec = time.getSeconds(),
      			millSec = time.getMilliseconds(),
     		    millString = millSec.toString().slice(0, -2),
      			day = time.getDay(),
      			ampm = hours >= 12 ? 'PM' : 'AM',
      			month = time.getMonth(),
      			date = time.getDate(),
      			year = time.getFullYear(),
      			monthShortNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
        						   "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    //convert hours from military time and add the am or pm
    //if (hours > 11) $('#ampm').text(ampm);
    	$('#ampm').text(ampm)
    		if (hours > 12) hours = hours % 12;
    		if (hours == 0) hours = 12;

    //add leading zero for min and sec 
    		if (sec <= 9) sec = "0" + sec;
    		if (min <= 9) min = "0" + min;

    	$('#hours').text(hours);
    	$('#min').text(":" + min + ":");
    	$('#sec').text(sec);
    //$("#test").text(day);
    // $('#millSec').text(millString);
    	$('.days:nth-child(' + (day + 1) + ')').addClass('active');
    	$("#month").text(monthShortNames[month]);
    	$('#date').text(date);
    	$('#year').text(year);

  }, 100);

});
    	/* 
    	function funloadClientPhoto()
		{
			var code="All";
			var searchUrl1=getContextPath()+"/loadRestImage.html?guestCode="+code;
			 $.ajax({
			        type: "GET",
			        url: searchUrl1,
			        cache: false
			        
			 });
			$("#memImage").attr('src', searchUrl1);
		}  */
		
		/* $(document).ready(function(){
	    	funloadPropertyImage();
	    	
	    }); */
		
		
		function funloadClientPhoto()
		{
			var code = $("#cmbPosCode").val();			
			var searchUrl1=getContextPath()+"/loadPropertyImage.html?";
			 $.ajax({
			        type: "GET",
			        url: searchUrl1,
			        cache: false
			 });
			$("#memImage").attr('src', searchUrl1);
		}  
	</script>
	
  	</head>
	<body>
			
		<div class="row01" style="background-color: #fff;display: -webkit-box;margin-bottom: -20px;height:18% ;">
		
		    <div class="row"  style="width: 100%;margin-top: 0px;margin-left: 50px;">
				<img  src="../${pageContext.request.contextPath}/resources/newdesign/images/companyLogo.png" title="LOGOUT" Style="width: 15%;height:100%;">
				
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;
				
								<label id="lblClientName" style="margin-top:18px;color:rgba(83,159,225,1);font-family: trebuchet ms, Helvetica, sans-serif;font-weight: 100;font-size: 16px;"> &nbsp;&nbsp; 
              	</label>
              	&nbsp;&nbsp;
              	<img  src="" id="memImage" title="Client Logo" Style="width: 184px;height:54px;margin-top: 8px;">
              	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				
				
				<label id="lblPOSDate" style="margin-top:18px;color:rgba(83,159,225,1);font-family: trebuchet ms, Helvetica, sans-serif;font-weight: 100;font-size: 16px;"> &nbsp;&nbsp; 
              	</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				
              	<label id="time" style="margin-top:18px;color:rgba(83,159,225,1);font-family: trebuchet ms, Helvetica, sans-serif;font-weight: 100;font-size: 16px;"><span id="hours"> </span><span id="min"> </span><span id="sec"> </span></label>
              	&nbsp;&nbsp;&nbsp;&nbsp;
              	<label style="margin-top:18px;color:rgba(83,159,225,1);text-transform: uppercase;">${gUserName}<!-- &nbsp;&nbsp; --></label>
              	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              	<a href="frmWebPOSModuleSelection.html">
						<img  src="../${pageContext.request.contextPath}/resources/newdesign/images/imgChangeModule.png" title="POS Module Selection" Style="width: 40%;margin-top: 20px;">
					</a> 
					
					&nbsp;&nbsp;
					
					<a href="frmWebPOSChangeSelection.html" style="text-decoration:underline ;color: white;" >
						<img  src="../${pageContext.request.contextPath}/resources/newdesign/images/imgChangePOS.png" title="Change POS" Style="width: 40%;margin-top: 20px;" >
					</a>
					
					&nbsp;&nbsp;
              	      	<a href="logout.html" style="text-decoration:underline;color: white;">
						<img  src="../${pageContext.request.contextPath}/resources/newdesign/images/imgLogOut.png" title="LOGOUT" Style="margin-top:8px;width: 45%;">
					</a>
			</div>
			<!-- <div class="" style="color:rgba(83,159,225,1);"> 
              	  
          		 </div>  -->
			
			<div class="col-lg-3 col-md-3 col-sm-2 col-xs-4" id="formname" style="width: 18%;color:rgba(83,159,225,1);margin-top: 18px;margin-left: 50px;font-weight: bold;"> 
              	 
           </div>
           
           <div class="col-lg-3 col-md-3 col-sm-2 col-xs-4" id="formname" style="width: 15%;color:rgba(83,159,225,1);margin-top: 18px;font-weight: bold;">
             	 
           </div>

			
            
            <div class="col-lg-3 col-md-3 col-sm-2 col-xs-4" id="formname" style="width: 7%; color:rgba(83,159,225,1);margin-top: 18px;font-weight: bold;">
             	 <label>${gPOSModuleNameForPrint} <!-- &nbsp;&nbsp; --></label>
           </div>
           
           



			
			
		</div>
		
		<div class="row01" style="background-color: #fff;display: -webkit-box;margin-bottom: -15px;">
		
		<!-- <div  style="width: 22%;margin-top: 10px;margin-left: 57%;">
				<input type="text" class="menusearchTextBox" id="txtSearch" onkeypress="funGetKeyPressSeachFormName(event);" style="height: 27px;width: 85%;margin-top: 12px;" placeholder="Search..."></input>
			</div> -->
         
			
		 <div style="width:200px;margin-top: 10px;margin-bottom: 10px;margin-left: 17%;">
			 
				<div class="element-input col-lg-6" style="max-width: 100%;float: right;">
					
					
					
					&nbsp;&nbsp;
					
					
					&nbsp;&nbsp;
					
           
          
					
				</div>
				
			</div>	
			
		</div>

	</body>
</html>