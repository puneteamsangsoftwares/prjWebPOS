<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page session="True" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html >
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/newdesign/css/hover.css"/>"/>  
    <!-- Load data to paginate -->
    <link rel="stylesheet" href="<spring:url value="/resources/css/pagination.css"/>" />
    <title>Web POS</title>
  
    <script type="text/javascript" src="<spring:url value="/resources/js/pagination.js"/>"></script>
        
	
    <style>
	    .dont-break-out {
			overflow-wrap: break-word;
		  	word-wrap: break-word;
	  }
    </style>
    <script src="<spring:url value="/resources/newdesign/js/jquery.sliphover.js"/>"/></script>
     <script type="text/javascript">
     
     var formSerachlist;

     $(document).on('keyup',function(evt) {
			if ($("#txtSearch").is(':focus')) {
			    if (evt.keyCode == 27 ) {
			    	$('#txtSearch').val('');
			    	funFormTextSeach('');
			    }if( evt.keyCode==8)
			    	{
			    		var serchtxt = $('#txtSearch').val();
			    		funFormTextSeach(serchtxt);
			    	}
			}
		});
     
     $(document).ready(function()
    	    	{
    	    	 formSerachlist=${formSerachlist};
    	    	 
    	    	 $("#txtSearch").focus();
    	     	 showTable();
    	    	});
    	     
    		 function funFormTextSeach(txtFormName)
    			{
    				var searchurl=getContextPath()+"/mainMenuSearchFormName.html?fromNameText="+txtFormName;
    				 $.ajax({
    					        type: "GET",
    					        url: searchurl,
    					        dataType: "json",
    					        success: function(response)
    					        {
    					        	formSerachlist =response;
    					        	showTable();
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

    			function getContextPath() 
    		   	{
    			  	return window.location.pathname.substring(0, window.location.pathname.indexOf("/",2));
    			}
    			
    			
    		 
    		function funGetKeyPressSeachFormName(event)
    		 {
    			 var serchtxt=$('#txtSearch').val();
    			 var key = event.keyCode;
    			 funFormTextSeach(serchtxt);
    			 
    		 }

//      $(document).ready(function()
//     	{
//     	 $("#txtSearch").focus();
//      	 showTable();
//     	});
     
     
//     var formName =${formSerachlist};
//     formSerachlist =formName;
// 	angular.module("webPOSApp", []).controller("menuSearchCtrl",function($scope) {
// 			$scope.forms = formName;
// 	});
	

    
	function showTable()
	{
		var optInit = getOptionsFromForm();
	    $("#Pagination").pagination(formSerachlist.length, optInit);	
	   
	}

	var items_per_page = 40;
	function getOptionsFromForm()
	{
	    var opt = {callback: pageselectCallback};
		opt['items_per_page'] = items_per_page;
		opt['num_display_entries'] = 40;
		opt['num_edge_entries'] = 3;
		opt['prev_text'] = "Prev";
		opt['next_text'] = "Next";
	    return opt;
	}
	
	function pageselectCallback(page_index, jq)
	{
	    // Get number of elements per pagionation page from form
	    var max_elem = Math.min((page_index+1) * items_per_page, formSerachlist.length);
	    var newcontent="";
	    var rowCount=0;
	   
	    newcontent = "<div class=\"MaineMenuContentent\" >"
	    	// Iterate through a selection of the content and build an HTML string
		    for(var i=page_index*items_per_page;i<max_elem;i++)
		    {
		    	var requestMapping=formSerachlist[i].strRequestMapping+"?saddr=1";
		    	
		    	if(requestMapping!="undefined?saddr=1"){
		    	
		    	var srcImg="../${pageContext.request.contextPath}/resources/images/"+formSerachlist[i].strImgName;
		    	
		    	var formTitle=formSerachlist[i].strShortName;
		    	
		    	newcontent += "<a href="+requestMapping+" class=\"button  btnLightBlue hvr-shutter-in-vertical hvr-grow\" style=\"margin: 1%;  width: 113px; height: 123px; \"><img id=\"Desktop\" src="+srcImg+" title='"+formTitle+"' style=\"width: 60.5%; margin-top: 15%; margin-left: 20%;\" >";
		    	newcontent += "<div style=\"width:80%; margin-left:5%; margin-right:10%; height:40%;  \"><font style=\"color: #000000e0; font-size: 13px;\" class=\"dont-break-out\">"+formTitle+"</font></div> </a>";
		    } 
		    	
		   } 
		    newcontent += '</div>';
		    $('#Searchresult').html(newcontent);
		    return false;
		
	}
	
    </script> 

   
  </head>
  
	<body >
	
	
	<div id="Searchresult" style="width: 90%; overflow-x: hidden; overflow-y: hidden;  margin-left:  auto;"></div> 
					<hr style="border: 1px solid #ccc; margin-top: 0rem; ">
		<div id="Pagination" class="pagination" style="width: 55%; margin-left: auto;" >
			
<!-- 		<div id="Searchresult" ng-repeat="eachform in forms | filter:searchKeyword"  style="width: 90%; overflow-x: hidden; overflow-y: hidden;  margin-left:  auto;"></div>  -->
<!-- 					<hr style="border: 1px solid #ccc;"><br/> -->
<!-- 		<div id="Pagination" class="pagination" style="width: 750px; margin-left: auto;" > -->
			
		</div>

	</body>
	
	
</html>