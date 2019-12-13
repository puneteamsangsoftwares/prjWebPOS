<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>

	<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/newdesign/bootstrap/css/bootstrap.min.css"/>"/>
	
	<%-- <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/newdesign/css/font.css"/>"/> --%>
	<%-- <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/newdesign/css/styles.css"/>"/> --%>
	<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/newdesign/itemform_files/formoid1/formoid-default-skyblue.css" />"/>
	<!-- Fibotalk Script start --> 
	<script type='text/javascript'>!function(t,e,a,c,r,n){t._ft_=t._ft_||{},t._ft_.rcl='0efa4b70a77b23';var s=e.createElement('script');s.src='https://cdn.fibotalk.com/widget.js',s.async=1,s.type='text/javascript';var f=e.getElementsByTagName('script')[0];f.parentNode.insertBefore(s,f)}(window,document);</script>
 	<!-- Fibotalk Script ends -->
	
	
	
<style type="text/css">
#tblNotify tr:hover
{
	background-color: #72BEFC;
	
}
</style>
<script type="text/javascript">




   	
    function funPOSHome()
   	{
    	var posCode='<%=session.getAttribute("loginPOS").toString()%>';
    	window.location.href=getContextPath()+"/frmGetPOSSelection.html?strPosCode="+posCode;
   	}
   	
    function getContextPath() 
    {
    	return window.location.pathname.substring(0, window.location.pathname.indexOf("/",2));
    }
	</script>
	
	<script type="text/javascript">
    	$(function() {
    		
			var posDate="${gPOSDate}";
    		
    		var date=posDate.split("-");
    		posDate=date[2]+"-"+date[1]+"-"+date[0];
      		$("#lblPOSDate").text(posDate);
      		
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
	</script>
	
	
</head>
<body>


	<div class="row" style="background-color: #fff;display: -webkit-box; margin-right: 0%; margin-left: 0%;">
		
		    <div class="element-input col-lg-6" style="width: 15%;margin-top: 5px;margin-left: 20px;">
				<div id="clientlogo"><img src="../${pageContext.request.contextPath}/resources/newdesign/images/companyLogo.png" style="height: 34px;"" id="clientimg" ></div>
			</div>
	
			
			<div class="col-lg-3 col-md-3 col-sm-2 col-xs-4" style="width: 20%;color:rgba(83,159,225,1);margin-top: 10px;"> 
              	<label style="font-family: trebuchet ms, Helvetica, sans-serif;font-weight: 100;font-size: 16px;"> ${gPOSName} &nbsp;&nbsp; 
               	</label>  
           </div>
           
           <div class="col-lg-3 col-md-3 col-sm-2 col-xs-4" style="width: 15%;color:rgba(83,159,225,1);margin-top: 10px;">
             	 <label style="font-family: trebuchet ms, Helvetica, sans-serif;font-weight: 100;font-size: 16px;">${gUserName} &nbsp;&nbsp;</label>
           </div>

			<div class="col-lg-3 col-md-3 col-sm-2 col-xs-4" style="width: 12%;color:rgba(83,159,225,1);margin-top: 10px;"> 
              	<label id="lblPOSDate" style="font-family: trebuchet ms, Helvetica, sans-serif;font-weight: 100;font-size: 16px;"> &nbsp;&nbsp; 
              	</label>  
           </div>
           
           <div class="col-lg-3 col-md-3 col-sm-2 col-xs-4" style="width: 10%;color:rgba(83,159,225,1);margin-top: 10px;">
                 <label id="time" style="font-family: trebuchet ms, Helvetica, sans-serif;font-weight: 100;font-size: 16px;"><span id="hours"> </span><span id="min"> </span><span id="sec"> </span></label>
           </div> 
           
           <div class="col-lg-5 col-md-5 col-sm-7 col-xs-5" id="buttons" style="width: 15%;margin-top: 5px;">
                <div id="hdrbtn">
                    	<a href="#" onclick="funPOSHome()"><img src="../${pageContext.request.contextPath}/resources/newdesign/images/arrows (2).png" id="return"></a>
				</div>
			</div>
			
	 </div>

	
<hr style="border: 1px solid #ccc;margin-top: 15px;margin-bottom: 0px;">
</body>
</html>

