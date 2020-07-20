<%@ page import="java.util.LinkedList"%>
<%@ page import="java.util.List"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Material Dash</title>
  <!-- javascript code ends here -->
  
   <!-- plugins:css -->
  <link rel="stylesheet" href="../${pageContext.request.contextPath}/resources/newdesign/assets/vendors/mdi/css/materialdesignicons.min.css">
  <link rel="stylesheet" href="../${pageContext.request.contextPath}/resources/newdesign/assets/vendors/css/vendor.bundle.base.css">
  <!-- endinject -->
  <!-- Plugin css for this page -->
  <link rel="stylesheet" href="../${pageContext.request.contextPath}/resources/newdesign/assets/vendors/flag-icon-css/css/flag-icon.min.css">
  <link rel="stylesheet" href="../${pageContext.request.contextPath}/resources/newdesign/assets/vendors/jvectormap/jquery-jvectormap.css">
  <!-- End plugin css for this page -->
  <!-- Layout styles -->
  <link rel="stylesheet" href="../${pageContext.request.contextPath}/resources/newdesign/assets/css/demo/style.css">
  <!-- End layout styles -->
  <link rel="shortcut icon" href="../${pageContext.request.contextPath}/resources/newdesign/assets/images/favicon.png" /> 

<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>

  <style type="text/css">
    .body-wrapper .main-wrapper .page-wrapper .content-wrapper {  padding: 16px 10px;}
    span.price{font-size: 14px;text-align: right;display: block;color:#2180c3;}
    h5.tablehead2{ font-size: 12px !important;font-weight: 500;line-height: 1.5;width: 90%;}
    .mdc-card .info-card4{width: 110px;}
    .mdc-card.info-card {padding: 2px 10px;}
    .mdc-card .info-card4:hover{background: #40a6ee;} 
    .mdc-card.info-card3 {margin-bottom: 0px;}
    .mdc-text-field--outlined .mdc-text-field__input{padding: 7px !important;}
    .mdc-text-field--with-leading-icon.mdc-text-field--outlined .mdc-floating-label{left: 12px;top: 10px;font-size: 13px;}
    .mdc-card.info-card{padding: 0px 9px;}
    .body-wrapper .main-wrapper .page-wrapper .content-wrapper{padding: 1px 10px;}
    .mdc-top-app-bar .mdc-top-app-bar__section-right .menu-profile button .user-name{color: #399be2;}
    .mdc-top-app-bar .mdc-top-app-bar__section-right .menu-profile button .date{color: #399be2;font-weight: normal;}
    .img:hover{background: #e4e1e161;}
  </style>
  
  
<script type="text/javascript">

function funPopularItemButtonClicked(objButton)
{
	var $rows = $('#tblMenuItemDtl').empty();
	var tblMenuItemDtl=document.getElementById('tblMenuItemDtl');
	var selctedCode=objButton.id;
	flagPopular="Popular";
	funFillTopButtonList(flagPopular);
	var jsonArrForPopularItems=${command.jsonArrForPopularItems};	
	var rowCount = tblMenuItemDtl.rows.length;	
	itemPriceDtlList=new Array();
	var insertCol=0;
	var insertTR=tblMenuItemDtl.insertRow();
	var index=0;
	$.each(jsonArrForPopularItems, function(i, obj) 
	{									
											
			if(insertCol<tblMenuItemDtl_MAX_COL_SIZE)
			{
				index=rowCount*4+insertCol;
				var col=insertTR.insertCell(insertCol);
				
				col.innerHTML = "<td  ><input type=\"button\" id='"+obj.strItemCode+"' value='"+obj.strItemName+"'    style=\"width: 110px;height: 60px; white-space:normal;font-size: 11px; \"  onclick=\"funMenuItemClicked(this,"+index+")\" class=\"btn btn-primary \" /></td>";
				col.style.padding = "1px";
				
				insertCol++;
			}
			else
			{		
				rowCount++;
				insertTR=tblMenuItemDtl.insertRow();									
				insertCol=0;
				index=rowCount*4+insertCol;				
				var col=insertTR.insertCell(insertCol);
				
				col.innerHTML = "<td><input type=\"button\" id='"+obj.strItemCode+"' value='"+obj.strItemName+"'    style=\"width: 110px;height: 60px; white-space:normal;font-size: 11px; \"  onclick=\"funMenuItemClicked(this,"+index+")\" class=\"btn btn-primary \" /></td>";
				col.style.padding = "1px";
				
				insertCol++;
			}	
			itemPriceDtlList[index]=obj;
		
	});
}


</script>
  
</head>
<body>
<script src="../assets/js/preloader.js"></script>
<div class="body-wrapper">
   <div class="main-wrapper mdc-drawer-app-content">
      <!-- partial:partials/_navbar.html -->
    <header class="mdc-top-app-bar">
        <div class="mdc-top-app-bar__row">
          <div class="mdc-top-app-bar__section mdc-top-app-bar__section--align-start">
            <button class="material-icons mdc-top-app-bar__navigation-icon mdc-icon-button sidebar-toggler">menu</button>
            <span class="mdc-top-app-bar__title"><img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/sanguinelogo.jpg" style="height: 46px;width: 135px;"></span>
          </div>
          <div class="mdc-top-app-bar__section mdc-top-app-bar__section--align-start">
              <button class="mdc-button mdc-menu-button" style="margin-right: 59px;">
                <span class="d-flex align-items-center">
                  <span class="clent-name">Ninety degrees</span>
                </span>
              </button>             
            <span class="mdc-top-app-bar__title"><img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/90degrees.jpg" style="height: 58px;"></span>
          </div>
          <div class="mdc-top-app-bar__section mdc-top-app-bar__section--align-end mdc-top-app-bar__section-right">
            <div class="menu-button-container menu-profile d-none d-md-block">
              <button class="mdc-button mdc-menu-button">
                <span class="d-flex align-items-center">
                  <span class="user-name">Sumit1</span>
                </span>
              </button>
            </div>
              <div class="menu-button-container menu-profile d-none d-md-block">
                <button class="mdc-button mdc-menu-button">
                  <span class="d-flex align-items-center">
                  <span class="date">12-02-2020</span>
                  </span>
                </button>
              </div>
              <div class="divider d-none d-md-block"></div>
              <div class="menu-button-container">
			           <button class="mdc-button mdc-menu-button">
                   <i class="mdi mdi-home"></i>
                 </button>
              </div>
          </div>
        </div>
    </header>
      <!-- partial -->
    <div class="page-wrapper mdc-toolbar-fixed-adjust">
      <main class="content-wrapper">
		    <table width="100%" border="0">
			   <tr width="100%">
              <td width="18%" style="vertical-align: top;padding-top: 5px;">
                <table width="100%">
                  <tr>  
                    <td width="70%">
                       <div class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon search-text-field d-none d-md-flex" style="background: #fff;">
                         <input class="mdc-text-field__input" id="text-field-hero-input">
                          <div class="mdc-notched-outline">
                           <div class="mdc-notched-outline__leading"></div>
                            <div class="mdc-notched-outline__notch">
                              <label for="text-field-hero-input" class="mdc-floating-label">Search Tables</label>
                            </div>
                            <div class="mdc-notched-outline__trailing"></div>
                          </div>
                        </div>
                      </td> 
                      <td width="30%">
                       <div class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon search-text-field d-none d-md-flex" style="background: #fff;">
                         <input class="mdc-text-field__input" id="text-field-hero-input">
                          <div class="mdc-notched-outline">
                           <div class="mdc-notched-outline__leading"></div>
                            <div class="mdc-notched-outline__notch">
                              <label for="text-field-hero-input" class="mdc-floating-label">Pax</label>
                            </div>
                            <div class="mdc-notched-outline__trailing"></div>
                          </div>
                        </div>
                      </td>
                  </tr>
                </table>
                <table width="100%" class="mdc-card info-card3">
                  <tr>        
                    <td align="center" class="img">
                       <img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/icon-dinein.png" border="0"> 
                       <h5 class="tablehead" nowrap>Dine in</h5> 
                    </td>   
                    <td align="center" class="img">
                       <img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/icon-homedelivery.png" border="0"> 
                       <h5 class="tablehead" nowrap>Home</h5>
                    </td>
                    <td align="center" class="img">
                       <img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/icons8.png" border="0"> 
                       <h5 class="tablehead" nowrap>Take Away</h5> 
                    </td>             
                    </tr>
                  </table>  
                  
                  <%-- <div id="divArea" style="border: 1px solid rgb(204, 204, 204);height: 35px;overflow: hidden;width: 680px;display: block; margin-top:0px;" >																	
								<div class="row" style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 25%; "> 
				    					<input  type="text" style="width: 150px;" id="Customer"  class="searchTextBox jQKeyboard form-control" placeholder="Select customer..."  ondblclick="funHelp('POSCustomerMaster')"/>
				    				</div>
			    					<div class="element-input col-lg-6" style="width: 25%;"> 
				    					<label id="customerName"> <!-- vinayak padalkar --></label>
				    				</div>
			    				 <div class="element-input col-lg-6" style="width: 20%;"> 
				    					<label>Area :</label> <!-- <label id="txtAreaName"> All</label> -->
				    				</div>
			    					<div class="element-input col-lg-6" style="width: 25%;"> 
										<s:select id="txtAreaName" items="${areaList}" path="" onchange="funShowTables()"  ></s:select>
									</div>
			    			</div>
                </div> --%>
              
                <table width="100%" class="mdc-card info-card3">
                  <tr>        
                    <td class="bs-example">
                    <c:set var="sizeOfArea" value="${fn:length(command.jsonArrForArea)}"></c:set>
					<c:set var="areaCount" value="${0}"></c:set>
										  
                  <%--   <% 
					for(int k=0;k<5;k++) 
					{
					%> --%>
					<c:if test="${areaCount lt sizeOfArea}">
                      <div class="accordion" >
                        <div class="card">
                            <div class="card-header" id="headingOne">
                                <h2 class="mb-0">
                                    <i class="fa fa-plus"></i><button type="button"  id="${command.jsonArrForArea[areaCount].strAreaCode}" value="${command.jsonArrForArea[areaCount].strAreaName}" class="btn btn-link" data-toggle="collapse" data-target="#collapseOne" ></button>
                                    <%-- <i class="fa fa-plus"></i><input type="button" id="${areaList}" value="${areaList}"  class="btn btn-link" data-toggle="collapse" data-target="#collapseOne"></input> --%>
                                    <%-- <button id="txtAreaName"  type="button" class="btn btn-link" data-toggle="collapse" data-target="#collapseOne"><i class="fa fa-plus"></i>${areaList}</button>   --%>         
                                </h2>
                            </div>
                              <div id="collapseOne" class="collapse" aria-labelledby="headingOne" data-parent="#accordionExample">
                                <div class="card-body">
                               
                                   <p>ITtem 1 <a href="https://www.tutorialrepublic.com/html-tutorial/" target="_blank">Learn more.</a></p>
                                </div>
                            </div>
                        </div>
                        </div>
                        <c:set var="areaCount" value="${areaCount +1}"></c:set>
					    </c:if>	
                       
                        <%-- <%
						}
						%> --%>
						
                      </td>             
                    </tr>
                  </table>  
                  </td>  
              <td width="40%" style="vertical-align: top;">
                <table width="100%" class="mdc-card info-card">
                    <tr>
                      <td width="50%">
                         <h5 class="tablehead" nowrap>Categorys</h5>
                      </td>
                      <td width="50%">
                        <div class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon search-text-field d-none d-md-flex" style="background: #fff;border-radius: 6px;">
                         <input class="mdc-text-field__input" id="text-field-hero-input">
                          <label for="text-field-hero-input" class="mdc-floating-label">Search Category</label>
                        </div>
                       </td>
                      </tr>
                </table>  
                <div id="divMenuHeadDtl" style="border: 1px solid rgb(204, 204, 204);height: 120px;overflow: auto;width: 630px;display: block; margin-top:0px;" >									
				<table width="100%" class="mdc-card info-card3" id="tblMenuHeadDtl" > <!-- class="table table-striped table-bordered table-hover" -->
									 <tr>
									 <td><input type="button" id="PopularItem" value="POPULAR" onclick="funPopularItemButtonClicked(this)" style="width: 100px;height: 35px; white-space: normal;border-style:none;text-align:center ;" class="mdc-card info-card4"/></td>
									 </tr>
									 <c:set var="sizeOfmenu" value="${fn:length(command.jsonArrForDirectBillerMenuHeads)}"></c:set>
									 <c:set var="menuCount" value="${0}"></c:set>
									 
									  <c:forEach var="objMenuHeadDtl" items="${command.jsonArrForDirectBillerMenuHeads}"  varStatus="varMenuHeadStatus">																																		
												<tr>
												<% 
												for(int k=0;k<5;k++) 
												{
												%>	
												
												<c:if test="${menuCount lt sizeOfmenu}">
													<td  style="padding: 3px;" >
														<input type="button"  id="${command.jsonArrForDirectBillerMenuHeads[menuCount].strMenuCode}" value="${command.jsonArrForDirectBillerMenuHeads[menuCount].strMenuName}"    style="width: 100px;height: 35px; white-space: normal;border-style:none;text-align:center ;" class="mdc-card info-card4" onclick="funMenuHeadButtonClicked(this)"/>
													</td>
												<c:set var="menuCount" value="${menuCount +1}"></c:set>
												</c:if>																						 													
																
													
												<%
												}
												%>										
											   </tr>																																
										</c:forEach>									   				   									   									   							
				 </table>
				 </div> 
							
                 <table width="100%" class="mdc-card info-card">
                    <tr>
                      <td width="30%">
                          <h5 class="tablehead" nowrap style="color: #fff;">Items</h5>
                      </td>
                      <td width="20%">
                        <div class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon search-text-field d-none   d-md-flex" style="background: #fff;width:90%;border-radius: 6px;">
                          <input class="mdc-text-field__input" id="text-field-hero-input">
                          <label for="text-field-hero-input" class="mdc-floating-label">Search Items</label>
                        </div> 
                      </td>
                      <td width="10%">
                          <div class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon search-text-field d-none  d-md-flex" style="background: #fff;width:90%;border-radius: 6px;">
                            <input class="mdc-text-field__input" id="text-field-hero-input">
                            <label for="text-field-hero-input" class="mdc-floating-label">QTY</label>
                          </div> 
                      </td>
                      <td width="10%">
                        <a href="javascript:void(0)" class="mdc-button mdc-button--raised mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;border-radius: 6px;">
                          ADD
                        </a>

                      </td>
                      </tr>
                </table>
                
                
               <table width="100%" class="mdc-card info-card3">       
                        <tr>              
                          <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td>
                             <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td>
                            <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td>
                            <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td>
                            <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td>           
                       </tr> 
                       <tr>
                          <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td>
                            <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td>
                            <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td>
                            <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td>
                            <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td>           
                       </tr> 
                       
                       <tr>
                          <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td>
                            <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td>
                            <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td>
                            <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td> 
                            <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td>          
                       </tr> 
                       <tr>
                            <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td>
                            <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td>
                            <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td>
                            <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td>
                            <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td>           
                       </tr> 
                       <tr>
                            <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td>
                            <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td>
                            <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td>
                            <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td>
                            <td class="mdc-card info-card4">
                             <h5 class="tablehead2" nowrap>Long island ice tea</h5> 
                             <span class="price">299/-</span> 
                            </td>           
                       </tr>
                  </table> 
              </td>
              <td width="7%" style="vertical-align: top;">
                 <table width="100%" class="mdc-card info-card3" >
                   <tr>
                      <td width="33%">
                        <h5 class="tablehead" nowrap style="color: #399be2;font-weight: 600;">Table No:12</h5>
                      </td>
                      <td width="33%">
                        <h5 class="tablehead" nowrap style="color: #399be2;font-weight: 600;">00:00</h5>
                      </td>
                      <td width="33%">
                        <h5 class="tablehead" nowrap style="color: #399be2;font-weight: 600;">Total: 3431</h5>
                      </td>
                   </tr>
                 </table>
                 <table width="100%" class="mdc-card info-card3">
                    <tr>
                      <td width="20%">
                        <h5 class="tablehead" nowrap style="font-weight: 600;">KOT:5263</h5>
                      </td>
                      <td width="30%">
                        <h5 class="tablehead" nowrap style="font-weight: 600;">Time:00:00</h5>
                      </td>
                      <td width="2%">
                        <a href="javascript:void(0)" class="mdc-button mdc-button--raised mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px; border-radius: 6px;">
                          REPRINT
                        </a>
                      </td>

                    <tr class="trcolor">            
                      <td width="65%" colspan="2">
                        <h5 class="tablehead" nowrap>Item 1</h5> 
                      </td>
                      <td width="15%">
                        <h5 class="tablehead" nowrap align="right">2364</h5>
                      </td>
                    </tr> 
                    <tr class="trcolor">            
                      <td width="65%" colspan="2">
                        <h5 class="tablehead" nowrap>Item 1</h5> 
                      </td>
                      <td width="15%">
                        <h5 class="tablehead" nowrap align="right">2364</h5>
                      </td>
                    </tr>
                    <tr class="trcolor">            
                      <td width="65"% colspan="2">
                        <h5 class="tablehead" nowrap>Item 1</h5> 
                      </td>
                      <td width="15%">
                        <h5 class="tablehead" nowrap align="right">2364</h5>
                      </td>
                    </tr>
                    <tr class="trcolor">            
                      <td width="65%" colspan="2">
                        <h5 class="tablehead" nowrap>Item 1</h5> 
                      </td>
                      <td width="15%">
                        <h5 class="tablehead" nowrap align="right">2364</h5>
                      </td>
                    </tr>
                    <tr class="trcolor">            
                      <td width="65%" colspan="2">
                        <h5 class="tablehead" nowrap>Item 1</h5> 
                      </td>
                      <td width="15%">
                        <h5 class="tablehead" nowrap align="right">2364</h5>
                      </td>
                    </tr>
                    <tr class="trcolor">            
                      <td width="65%" colspan="2">
                        <h5 class="tablehead" nowrap>Item 1</h5> 
                      </td>
                      <td width="15%">
                        <h5 class="tablehead" nowrap align="right">2364</h5>
                      </td>
                    </tr>
                    <tr class="trcolor">            
                      <td width="65%" colspan="2">
                        <h5 class="tablehead" nowrap>Item 1</h5> 
                      </td>
                      <td width="15%">
                        <h5 class="tablehead" nowrap align="right">2364</h5>
                      </td>
                    </tr>
                    <tr class="trcolor">            
                      <td width="65%" colspan="2">
                        <h5 class="tablehead" nowrap>Item 1</h5> 
                      </td>
                      <td width="15%">
                        <h5 class="tablehead" nowrap align="right">2364</h5>
                      </td>
                    </tr>
                    <tr class="trcolor">            
                      <td width="65%" colspan="2">
                        <h5 class="tablehead" nowrap>Item 1</h5> 
                      </td>
                      <td width="15%">
                        <h5 class="tablehead" nowrap align="right">2364</h5>
                      </td>
                    </tr>
                    <tr>            
                      <td width="65%" height="100">
                        
                      </td>
                      <td width="15%">
                        
                      </td>
                      <td width="15%">
                        
                      </td>
                    </tr> 
                    
                    <tr class="trcolor">            
                      <td width="65%" colspan="2">
                        <h5 class="tablehead" nowrap>Asahi</h5> 
                      </td>
                      
                      <td width="15%">
                        <h5 class="tablehead" nowrap align="right">2364</h5>
                      </td>
                    </tr>
                    <tr class="trcolorred">           
                      <td width="65%" colspan="2">
                        <h5 class="tablehead" nowrap>Discount</h5> 
                      </td>
                      
                      <td width="15%">
                        <h5 class="tablehead" nowrap align="right">100</h5>
                      </td>
                    </tr>
                    <tr class="trcolor">            
                      <td width="65%" colspan="2">
                        <h5 class="tablehead" nowrap>Net Total</h5> 
                      </td>
                      
                      <td width="15%">
                        <h5 class="tablehead" nowrap align="right">2343</h5>
                      </td>
                    </tr>
                    <tr class="trcolor">            
                      <td width="65%" colspan="2">
                        <h5 class="tablehead" nowrap>Asahi</h5> 
                      </td>
                      
                      <td width="15%">
                        <h5 class="tablehead" nowrap align="right">2364</h5>
                      </td>
                    </tr>
                    <tr class="trcolor">            
                      <td width="65%" colspan="2">
                        <h5 class="tablehead" nowrap>VAT @ 5% (LIQUOR)</h5> 
                      </td>
                      
                      <td width="15%">
                        <h5 class="tablehead" nowrap align="right">8773</h5>
                      </td>
                    </tr>
                    <tr class="trcolor">            
                      <td width="65%" colspan="2">
                        <h5 class="tablehead" nowrap>GRAND TOTAL</h5> 
                      </td>
                      
                      <td width="15%">
                        <h5 class="tablehead" nowrap align="right">9837</h5>
                      </td>
                    </tr>
                    <tr class="trcolor">            
                      <td width="65%" colspan="2">
                        <h5 class="tablehead" nowrap>PAYMENT MODE</h5> 
                      </td>
                      
                      <td width="15%">
                        <h5 class="tablehead" nowrap align="right">CASH</h5>
                      </td>
                    </tr> 
                 </table>          
              </td>
              <td width="10%" style="vertical-align: top;">
                 <table width="100%" class="mdc-card info-card3">
                    <tr width="100%">
                       <td align="center" class="img">
                          <img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/icon-kot.png" border="0" height="50px" width="50px"> 
                          <h5 class="tablehead" nowrap>KOT</h5> 
                      </td>
                    </tr>
                     <tr width="100%">
                       <td align="center" class="img">
                          <img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/icon-bill.png" border="0" height="50px" width="50px"> 
                          <h5 class="tablehead" nowrap>BILL</h5> 
                      </td>
                    </tr>
                     <tr width="100%">
                       <td align="center" class="img">
                          <img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/icon-settle.png" border="0" height="50px" width="50px"> 
                          <h5 class="tablehead" nowrap>SETTLE</h5> 
                      </td>
                    </tr>
                     <tr width="100%">
                       <td align="center" class="img">
                          <img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/icon-waiter.png" border="0" height="50px" width="50px"> 
                          <h5 class="tablehead" nowrap>WAITER</h5> 
                      </td>
                    </tr>
                     <tr width="100%">
                       <td align="center" class="img">
                          <img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/icon-HO.png" border="0" height="50px" width="50px"> 
                          <h5 class="tablehead" nowrap>HO</h5> 
                      </td>
                    </tr>                    
                    <tr width="100%">
                       <td align="center" class="img">
                          <img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/icon-customer.png" border="0" height="50px" width="50px"> 
                          <h5 class="tablehead" nowrap>CUST</h5> 
                      </td>
                    </tr>
                     <tr width="100%">
                       <td align="center" class="img">
                          <img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/icons-done.png" border="0" height="50px" width="50px"> 
                          <h5 class="tablehead" nowrap>DONE</h5> 
                      </td>
                    </tr>
                     <tr width="100%">
                       <td align="center" class="img">
                          <img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/icon-more.png" border="0" height="50px" width="50px"> 
                          <h5 class="tablehead" nowrap>OTHER</h5> 
                      </td>
                    </tr>
                  </table>
              </td>
          </tr>
		    </table>   
      </main>
     </div>
    </div>
  </div>

  <!-- plugins:js -->
  <script src="../assets/vendors/js/vendor.bundle.base.js"></script>
  <!-- endinject -->
  <!-- Plugin js for this page-->
  <script src="../assets/vendors/chartjs/Chart.min.js"></script>
  <script src="../assets/vendors/jvectormap/jquery-jvectormap.min.js"></script>
  <script src="../assets/vendors/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
  <!-- End plugin js for this page-->
  <!-- inject:js -->
  <script src="../assets/js/material.js"></script>
  <script src="../assets/js/misc.js"></script>
  <!-- endinject -->
  <!-- Custom js for this page-->
  <script src="../assets/js/dashboard.js"></script>
  <!-- End custom js for this page-->
</body>
</html> 