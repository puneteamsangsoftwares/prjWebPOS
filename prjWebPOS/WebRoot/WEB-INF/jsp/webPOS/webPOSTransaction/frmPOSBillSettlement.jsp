<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>

<!--   <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge"> -->

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
<title>BILL SETTLEMENT</title>
 <!-- <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
 <link rel="stylesheet" href="/resources/demos/style.css">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
  -->
  <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
 <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>

<script type="text/javascript" src="<spring:url value="/resources/js/jquery.min.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/bootstrap.min.js.js"/>"></script>

<script type="text/javascript">


		var operationFrom="${operationFrom}";
		var balanceAmount=0,paidAmount=0.00,refundAmount=0,loyalityPoints=0;
		var settleType = "",debitCardNo = "";
		var takeAwayRemarks = "";
		var custAddType = "Home";
		var homeDelivery = "N";
		var tableNo = "${TableNo}" ,voucherNo="";
		var gCRMInterface="${gCRMInterface}",gSearchItemClicked=false;
		var cmsMemberCreditLimit,cmsMemberBalance;
		var cmsStopCredit;
		var discountRemarks = "";
		var couponCode = "";
		var flgApplyPromoOnBill="",flgGiftVoucherOK=false,flgEnterBtnPressed=false;
		var popUpOnPromoBill="${gPopUpToApplyPromotionsOnBill}";
		var settleName="",settlementCode="",billPrintOnSettlement="",settelmentDesc="";
		var dblSettlementAmount=0,currencyRate;
		var settlementName="",customerCodeForCredit="";
		var amountBox="";
		var giftVoucherSeriesCode="", giftVoucherCode="";
		var settleMode="",multSettle="";
		var hmSettlemetnOptions=new Map();
		var arrObjReasonCode ="";//${listReasonCode};
		var arrObjReasonName ="";//${listReasonName};
        var checkSetteType="";
        var rowCountSettle=0,totalItemRow=0;
		  var listOfDicountItem=[];

		var disCount=0;
		var totalDiscAmt=0;
		 
		 var disountType="Total";
		
		$(document).ready(function(){
			settleName="Cash";
			
// 			 if(operationFrom=="directBiller")
// 			 {
				 funSetProperty();
				 funVisibleDeliveryCharges('block');
				 funSetDate();
				 document.getElementById("lblTip").style.display='block';
				 document.getElementById("txtTip").style.display='block';
				 //
				 document.getElementById("divSettlementButtons").style.display='block';
				 document.getElementById("divAmt").style.display='block';
				 
				 
				 
				 //${command.jsonArrForSettleButtons}
				/*  if (!objListSettle.getStrSettelmentType().equals("Debit Card"))
		            {
		                procSettlementBtnClick(objListSettle);
		               
		                funSettleOptionSelected('${objSettleButtons.strSettelmentDesc}','${objSettleButtons.strSettelmentType}',
								'${objSettleButtons.strSettelmentCode}','${objSettleButtons.dblConvertionRatio}','${objSettleButtons.strBillPrintOnSettlement}')"
		                funSettleOptionSelected(settleNametmp,settleTypetmp,settlementCodetmp,currencyRatetmp,billPrintOnSettlementtmp)
		            } */
//  			 }
				 /* modal.style.display = "none";
				 funModalOperate(); */
		});
		
		function loadofBillSettlemntTab()
		{
			 funSetProperty();
			
			 funVisibleDeliveryCharges('block');
			 funSetDate();
			 document.getElementById("lblTip").style.display='none';
			 document.getElementById("txtTip").style.display='none';
			
		}
		
		function funPrintButtonClicked(printButton)
		{					    		     
		    $("form").submit();		      	
		}
		
		
		function funSettleButtonClicked(printButton)
		{					    		     
		    $("form").submit();		      	
		}
		
	function funSetProperty()
	{
		 
		  settlementName="other";
		  cmsStopCredit="N";
		  cmsMemberCreditLimit = 0;
		  cmsMemberBalance=0;
		 if (gCRMInterface=="PMAM"){
			 document.getElementById("btnGetOffer").style.display='block';
         }
         else{
			 document.getElementById("btnGetOffer").style.display='none';

         }
		 funSetDefaultRadioBtnForDiscount();
		 
		 document.getElementById("divCustomer").style.display='none';
		 document.getElementById("divRemarks").style.display='none';
		 document.all["divCard"].style.display='none';
		 document.all["divPaymentMode"].style.display = 'none';
		 document.getElementById("divScrTaxTable").style.display='none';
	
         document.getElementById("divTblSettlement").style.display='none';
         document.getElementById("divCheque").style.display='none';
        // document.getElementById("divAmt").style.display='none';
         document.getElementById("divCoupen").style.display='none';
         document.getElementById("divGiftVoucher").style.display='none';
         
         document.getElementById("divRoomSettlement").style.display='none';
         document.getElementById("divJioMoneySettlement").style.display='none';
        
        
//          document.getElementById("txtPaidAmount").focus();
        // txtPaidAmt.setFocusable(true);
         flgGiftVoucherOK=false;
        
        
       
	}
	function funSetBillingSettlement(isDirectBiller){
		  var objPOSSettelementOptions='${cashSettlement}';
		  var arr=objPOSSettelementOptions.split(',');
				 if(arr[1]=="Cash"){
					 
					funSettleOptionSelected(arr[0],arr[1],arr[2],arr[3],arr[4]);
				 }
				 
				if(isDirectBiller=='N')
				{
					 document.getElementById("btnOpenBillItems").style.display='none';
					 $("#btnPrint").val("Settle");
					
				}
				 
	}
	function funNumpadButtonClicked(ObjNumPadBtn)
	{
		//alert(ObjNumPadBtn.value);
		var newValue="";
		if(ObjNumPadBtn.value=="BackSpace")
		{
			var oldValue=$('#txtPaidAmount').val();
			var len=oldValue.length;
			newValue=oldValue.substring(0,len-1);
			$("#txtPaidAmount").val(newValue);
		}
		else if(ObjNumPadBtn.value=="Enter")
		{
			
		}
		else{
			var oldValue=$('#txtDeliveryCharge').val();
			newValue=oldValue+""+ObjNumPadBtn.value;
			$("#txtDeliveryCharge").val(newValue);
		}
	}

	function funSettleOptionSelected(settleNametmp,settleTypetmp,settlementCodetmp,currencyRatetmp,billPrintOnSettlementtmp)
	{
			settleName=settleNametmp;
			settelmentDesc=settleName;
			settleType=settleTypetmp;
			settlementCode=settlementCodetmp;
			currencyRate=currencyRatetmp;
			billPrintOnSettlement=billPrintOnSettlementtmp;
			document.all["divPaymentMode"].style.display = 'block';
			document.getElementById("lblPayMentMode").innerText="PayMent Mode : "+settleType;
		   	dblSettlementAmount = 0.00;
		   	balanceAmount=$("#txtAmount").val();
           //settlementCode//use while calculating tax for settlement
            dblSettlementAmount = Math.round(balanceAmount);
            dblSettlementAmount = dblSettlementAmount * currencyRate;
            dblSettlementAmount = Math.round(dblSettlementAmount);
           
        switch (settleType)
        {
            case "Loyality Points":
	                settlementName = "others";
	                amountBox = "PaidAmount";
	                settleMode = true;
	                document.getElementById("divRemarks").style.display='none';
	                document.getElementById("divCustomer").style.display='none';
	               // document.getElementById("lblcard").style.display='none';
	                document.all["lblCard"].style.display='none';
	                document.getElementById("lblCardBalance").style.display='none';
	                document.getElementById("divAmt").style.display='block';
	                document.getElementById("divCoupen").style.display='none';
	                document.getElementById("divGiftVoucher").style.display='none';
	                document.getElementById("divCard").style.display='none';
	                document.getElementById("divCheque").style.display='none';
	              
	                $("#txtPaidAmount").val(dblSettlementAmount);
	                $("#txtAmount").val(dblSettlementAmount);
	                //flgComplementarySettle = false;
	                document.getElementById("lblTip").style.display='none';
	                document.getElementById("txtTip").style.display='none';
	                document.getElementById("divRoomSettlement").style.display='none';
	                document.getElementById("divJioMoneySettlement").style.display='none';
	              
	                break;
	                
	            case "Cash":
	                settlementName = "others";
	                amountBox = "PaidAmount";
	                settleMode = true;
	               
	                document.getElementById("divCustomer").style.display='none';
	                document.all["lblCard"].style.display='none';
	                document.all["lblCardBalance"].style.display='none';
	              //  document.getElementById("lblCardBalance").style.display='none';
	                document.getElementById("divAmt").style.display='block';
	                document.getElementById("divCoupen").style.display='none';
	                document.getElementById("divGiftVoucher").style.display='none';
	                document.getElementById("divCard").style.display='none';
	                document.getElementById("divCheque").style.display='none';
	            
	                $("#txtPaidAmount").val(dblSettlementAmount);
	                $("#txtAmount").val(dblSettlementAmount);
	                //flgComplementarySettle = false;
	                document.getElementById("lblTip").style.display='none';
	                document.getElementById("txtTip").style.display='none';
	                document.getElementById("divRoomSettlement").style.display='none';
	                document.getElementById("divJioMoneySettlement").style.display='none';
	                
	                document.getElementById("divRemarks").style.display='block';
	               // PanelRemaks.setLocation(PanelCheque.getLocation());//document.all["lblCard"].style.display='none';
	           //     document.getElementById("divRemarks").style.top='345px';
	            //    document.getElementById("divRemarks").style.left='415px';
	                $("#txtRemark").focus();
	                //document.getElementById("txtRemark").focus();
	               
	              //flgComplementarySettle = false;
	                break;
	
	            case "Credit Card":
	                settlementName = "others";
	                amountBox = "PaidAmount";
	                settleMode = true;
	                document.getElementById("divCustomer").style.display='none';
	                document.all["lblCard"].style.display='none';
	                document.all["lblCardBalance"].style.display='none';
	                document.getElementById("divAmt").style.display='block';
	                document.getElementById("divCoupen").style.display='none';
	                document.getElementById("divGiftVoucher").style.display='none';
	                document.getElementById("divCard").style.display='block';
	                document.getElementById("divCheque").style.display='none';
	                $("#txtPaidAmount").val(dblSettlementAmount);
	                $("#txtAmount").val(dblSettlementAmount);
	                //flgComplementarySettle = false;
	                document.getElementById("lblTip").style.display='block';
	                document.getElementById("txtTip").style.display='block';
	                document.getElementById("divRoomSettlement").style.display='none';
	                document.getElementById("divJioMoneySettlement").style.display='none';
	                document.getElementById("divRemarks").style.display='block';
	              //  document.getElementById("divCard").style.top='350px';
	             //   document.getElementById("divCard").style.left='415px';
	                $("#txtRemark").focus();
	             //   document.getElementById("divRemarks").style.top=' 425px';
	             //   document.getElementById("divRemarks").style.left='415px';
	              break;
	
	            case "Coupon":
	                settlementName = "others";
	                amountBox = "CouponAmount";
	                settleMode = true;
	                document.getElementById("divCustomer").style.display='none';
	                document.all["lblCard"].style.display='none';
	                document.all["lblCardBalance"].style.display='none';
	                document.getElementById("divAmt").style.display='none';
	                document.getElementById("divCoupen").style.display='true';
	                document.getElementById("divGiftVoucher").style.display='none';
	                document.getElementById("divCard").style.display='none';
	                document.getElementById("divCheque").style.display='none';
	                $("#txtPaidAmount").val(dblSettlementAmount);
	                $("#txtAmount").val(dblSettlementAmount);
	                //flgComplementarySettle = false;
	                document.getElementById("lblTip").style.display='none';
	                document.getElementById("txtTip").style.display='none';
	                document.getElementById("divRoomSettlement").style.display='none';
	                document.getElementById("divJioMoneySettlement").style.display='none';
	                document.getElementById("divRemarks").style.display='none';
	               // document.getElementById("divCoupen").style.top='145px';
	               // document.getElementById("divCoupen").style.left='415px';
	                break;
	
	            case "Cheque":
	                settlementName = "others";
	                amountBox = "PaidAmount";
	                settleMode = true;
	                document.getElementById("divCustomer").style.display='none';
	                document.all["lblCard"].style.display='none';
	                document.all["lblCardBalance"].style.display='none';
	                document.getElementById("divAmt").style.display='block';
	                document.getElementById("divCoupen").style.display='none';
	                document.getElementById("divGiftVoucher").style.display='none';
	                document.getElementById("divCard").style.display='none';
	                document.getElementById("divCheque").style.display='block';
	                $("#txtPaidAmount").val(dblSettlementAmount);
	                $("#txtAmount").val(dblSettlementAmount);
	                //flgComplementarySettle = false;
	                document.getElementById("lblTip").style.display='none';
	                document.getElementById("txtTip").style.display='none';
	                document.getElementById("divRoomSettlement").style.display='none';
	                document.getElementById("divJioMoneySettlement").style.display='none';
	                document.getElementById("divRemarks").style.display='none';
	              //  document.getElementById("divCoupen").style.top='145px';
	             //   document.getElementById("divCoupen").style.left='415px';
	              
	                break;
	
	            case "Gift Voucher":
	                settlementName = "Gift voucher";
	                amountBox = "PaidAmount";
	                settleMode = true;
	                
	                document.getElementById("divCustomer").style.display='none';
	                document.all["lblCard"].style.display='none';
	                document.all["lblCardBalance"].style.display='none';
	                document.getElementById("divAmt").style.display='block';
	                document.getElementById("divCoupen").style.display='none';
	                document.getElementById("divGiftVoucher").style.display='block';
	                document.getElementById("divCard").style.display='none';
	                document.getElementById("divCheque").style.display='block';
	                $("#txtPaidAmount").val(dblSettlementAmount);
	                $("#txtAmount").val(dblSettlementAmount);
	                //flgComplementarySettle = false;
	                document.getElementById("lblTip").style.display='none';
	                document.getElementById("txtTip").style.display='none';
	                document.getElementById("divRoomSettlement").style.display='none';
	                document.getElementById("divJioMoneySettlement").style.display='none';
	                document.getElementById("divRemarks").style.display='none';
	            //    document.getElementById("divGiftVoucher").style.top='145px';
	              //  document.getElementById("divGiftVoucher").style.left='415px';
	                break;
	                

                case "Complementary":
                	settlementName = "Complementry";
                    amountBox = "PaidAmount";
                    settleMode = true;
                    $("#txtRemarks").focus();
                    document.getElementById("divCustomer").style.display='none';
	                document.all["lblCard"].style.display='none';
	                document.all["lblCardBalance"].style.display='none';
	                document.getElementById("divAmt").style.display='none';
	                document.getElementById("divCoupen").style.display='none';
	                document.getElementById("divGiftVoucher").style.display='none';
	                document.getElementById("divCard").style.display='none';
	                document.getElementById("divCheque").style.display='none';
	                $("#txtPaidAmount").val(dblSettlementAmount);
	                $("#txtAmount").val(dblSettlementAmount);
	                //flgComplementarySettle = false;
	                document.getElementById("lblTip").style.display='none';
	                document.getElementById("txtTip").style.display='none';
	                document.getElementById("divRoomSettlement").style.display='none';
	                document.getElementById("divJioMoneySettlement").style.display='none';
	                document.getElementById("divRemarks").style.display='block';
	            //    document.getElementById("divRemarks").style.top='225px';
	           //     document.getElementById("divRemarks").style.left='415px';
                   break;

                case "Credit":
                	//funHelp('POSCustomerMaster');
                	settlementName = "Credit";
                    amountBox = "PaidAmount";
                   // objUtility.funCallForSearchForm("CustomerMaster");
                   // new frmSearchFormDialog(this, true).setVisible(true);
                    //funOpenCustomerMaster();

                     if (gSearchItemClicked)
                    {
                       // Object[] data = clsGlobalVarClass.gArrListSearchData.toArray();
                    
                       /*  lblCreditCustCode.setText(data[0].toString());
                        customerCodeForCredit = lblCreditCustCode.getText();
                        txtCoupenAmt.setText(String.valueOf(dblSettlementAmount));
                        hidCustomerName.setText(data[1].toString()); */
                        gSearchItemClicked = false;
                    } 
                    
                    document.getElementById("divCustomer").style.display='block';
                 //   document.getElementById("divCustomer").style.top='205px';
	              //  document.getElementById("divCustomer").style.left='415px';
	               
	                document.all["lblCard"].style.display='none';
	                document.all["lblCardBalance"].style.display='none';
	                document.getElementById("divAmt").style.display='none';
	                document.getElementById("divCoupen").style.display='none';
	                document.getElementById("divGiftVoucher").style.display='none';
	                document.getElementById("divCard").style.display='none';
	                document.getElementById("divCheque").style.display='none';
	                $("#txtPaidAmount").val(dblSettlementAmount);
	                $("#txtAmount").val(dblSettlementAmount);
	                //flgComplementarySettle = false;
	                document.getElementById("lblTip").style.display='none';
	                document.getElementById("txtTip").style.display='none';
	                document.getElementById("divRoomSettlement").style.display='none';
	                document.getElementById("divJioMoneySettlement").style.display='none';
	                document.getElementById("divRemarks").style.display='block';
	         //       document.getElementById("divRemarks").style.top='245px';
	         //       document.getElementById("divRemarks").style.left='415px';
	                $("#txtRemark").focus();
                    break;
	                
                    
                 case "Debit Card":
                	document.getElementById("divRoomSettlement").style.display='none';
 	                document.getElementById("divJioMoneySettlement").style.display='none';
 	                document.getElementById("divGiftVoucher").style.display='none';
 	                document.getElementById("divRemarks").style.display='none';
    	            document.getElementById("divAmt").style.display='none';
	                document.getElementById("divCoupen").style.display='none';
	                document.getElementById("divCard").style.display='none';
	                document.getElementById("divCheque").style.display='none';
	                $("#txtPaidAmount").val(dblSettlementAmount);
	                $("#txtAmount").val(dblSettlementAmount);
	                document.getElementById("lblTip").style.display='none';
	                document.getElementById("txtTip").style.display='none';
                   /*
                    if (tableNo!="")  // For KOT
                    {
                        debitCardNo = funCardNo();
                        if (debitCardNo=="")
                        {
                           // new frmSwipCardPopUp(this).setVisible(true);
                            if (debitCardNo != null)
                            {
                                ResultSet rsDebitCardNo = clsGlobalVarClass.dbMysql.executeResultSet("select strCardNo from tbldebitcardmaster where strCardString='" + debitCardNo + "'");
                                if (rsDebitCardNo.next())
                                {
                                    debitCardNo = rsDebitCardNo.getString(1);
                                }
                                rsDebitCardNo.close();
                            }
                        }
                        if (!debitCardNo.isEmpty())
                        {
                            clsUtility objUtility = new clsUtility();
                            //double debitCardBalance = objUtility.funGetDebitCardBalance(debitCardNo);
                            double debitCardBalance = objUtility.funGetDebitCardBalanceWithoutLiveBills(clsGlobalVarClass.gDebitCardNo, tableNo);

                            if (objUtility.funGetDebitCardStatus(debitCardNo, "CardNo").equalsIgnoreCase("Card is Not Active"))
                            {
                                new frmOkPopUp(null, "This Card is not Activated ", "Warning", 1).setVisible(true);
                            }
                            else if (debitCardBalance < 0)
                            {
                                new frmOkPopUp(null, "Card Balance is Negative", "Warning", 1).setVisible(true);
                            }
                            else
                            {
                                lblcard.setVisible(true);
                                chkJioNotification.setSelected(false);
                                lblCardBalance.setVisible(true);
                                lblCardBalance.setText(String.valueOf(debitCardBalance));
                                amountBox = "PaidAmount";
                                settlementName = "others";
                                settleMode = true;
                                panelAmt.setVisible(true);
                                PanelGiftVoucher.setVisible(false);
                                PanelJioMoneySettlement.setVisible(false);
                                txtAmount.setText(String.valueOf(dblSettlementAmount));
                                if (dblSettlementAmount > debitCardBalance)
                                {
                                    txtPaidAmt.setText(String.valueOf(debitCardBalance));
                                    lblCardBalance.setBackground(Color.red);
                                }
                                else
                                {
                                    txtPaidAmt.setText(String.valueOf(dblSettlementAmount));
                                    lblCardBalance.setBackground(Color.yellow);
                                }
                            }
                        }
                    }
                    else // For Direct Biller
                    {
                        if (null == clsGlobalVarClass.gDebitCardNo || clsGlobalVarClass.gDebitCardNo.trim().isEmpty())
                        {
                            new frmSwipCardPopUp(this).setVisible(true);
                        }
                        if (clsGlobalVarClass.gDebitCardNo != null && !clsGlobalVarClass.gDebitCardNo.trim().isEmpty())
                        {
                            clsUtility objUtility = new clsUtility();
                            ResultSet rsDebitCardNo = clsGlobalVarClass.dbMysql.executeResultSet("select strCardNo from tbldebitcardmaster where strCardString='" + clsGlobalVarClass.gDebitCardNo + "'");
                            if (rsDebitCardNo.next())
                            {
                                debitCardNo = rsDebitCardNo.getString(1);
                                //double debitCardBalance = objUtility.funGetDebitCardBalance(debitCardNo);
                                double debitCardBalance = objUtility.funGetDebitCardBalanceWithoutLiveBills(clsGlobalVarClass.gDebitCardNo, tableNo);

                                if (objUtility.funGetDebitCardStatus(debitCardNo, "CardNo").equalsIgnoreCase("Card is Not Active"))
                                {
                                    new frmOkPopUp(null, "This Card is not Activated ", "Warning", 1).setVisible(true);
                                }
                                else if (debitCardBalance < 0)
                                {
                                    new frmOkPopUp(null, "Card Balance is Negative", "Warning", 1).setVisible(true);
                                }
                                else
                                {
                                    lblcard.setVisible(true);
                                    lblCardBalance.setVisible(true);
                                    chkJioNotification.setSelected(false);
                                    lblCardBalance.setText(String.valueOf(debitCardBalance));
                                    amountBox = "PaidAmount";
                                    settlementName = "others";
                                    settleMode = true;
                                    panelAmt.setVisible(true);
                                    PanelGiftVoucher.setVisible(false);
                                    PanelJioMoneySettlement.setVisible(false);
                                    txtAmount.setText(String.valueOf(dblSettlementAmount));
                                    if (dblSettlementAmount > debitCardBalance)
                                    {
                                        txtPaidAmt.setText(String.valueOf(debitCardBalance));
                                        lblCardBalance.setBackground(Color.red);
                                    }
                                    else
                                    {
                                        txtPaidAmt.setText(String.valueOf(dblSettlementAmount));
                                        lblCardBalance.setBackground(Color.yellow);
                                    }
                                }
                            }
                            rsDebitCardNo.close();
                        }
                        PanelCard.setLocation(PointCheque);
                    }
                    */
                    //flgComplementarySettle = false;
                    break; 
/* 
                case "Member":

                    if (clsGlobalVarClass.gCMSIntegrationYN)
                    {
                        cmsMemberCreditLimit = 0;
                        if (custCode.trim().length() == 0)
                        {
                            JOptionPane.showMessageDialog(this, "Member is Not Selected for This Bill!!!");
                            return 0;
                        }
                        else
                        {
                            if (clsGlobalVarClass.gCMSIntegrationYN)
                            {
                                //String memberInfo=funCheckMemeberBalance(custCode);
                                clsUtility objUtility = new clsUtility();
                                String memberInfo = objUtility.funCheckMemeberBalance(custCode);
                                if (memberInfo.equals("no data"))
                                {
                                    JOptionPane.showMessageDialog(null, "Member Not Found!!!");
                                }
                                else
                                {
                                    String[] spMemberInfo = memberInfo.split("#");
                                    double balance = Double.parseDouble(spMemberInfo[2]);
                                    cmsMemberBalance = Double.parseDouble(spMemberInfo[3]);
                                    String info = spMemberInfo[0] + "#" + spMemberInfo[1] + "#" + balance;
                                    txtAreaRemark.setText(info);
                                    cmsMemberCreditLimit = Double.parseDouble(spMemberInfo[3]);
                                    cmsStopCredit = spMemberInfo[6];
                                }
                            }
                        }
                    }
                    settlementName = "Member";
                    amountBox = "PaidAmount";
                    settleMode = true;
                    PanelRemaks.setLocation(PanelCheque.getLocation());
                    PanelRemaks.setVisible(true);
                    panelCustomer.setVisible(false);
                    txtRemark.requestFocus();
                    lblcard.setVisible(false);
                    lblCardBalance.setVisible(false);
                    panelAmt.setVisible(true);
                    PanelCoupen.setVisible(false);
                    PanelGiftVoucher.setVisible(false);
                    PanelCard.setVisible(false);
                    chkJioNotification.setSelected(false);
                    PanelCheque.setVisible(false);
                    txtPaidAmt.setText(String.valueOf(dblSettlementAmount));
                    txtAmount.setText(String.valueOf(dblSettlementAmount));
                    //flgComplementarySettle = false;
                    lblTipAmount.setVisible(false);
                    txtTip.setVisible(false);
                    panelRoomSettlement.setVisible(false);
                    PanelJioMoneySettlement.setVisible(false);
                    txtJioDestination.setVisible(false);
                    lblJioDestination.setVisible(false);
                    lblJioDestination.setText("");
                    break; */

             /*    case "Room":

                    clsInvokeDataFromSanguineERPModules objSangERP = new clsInvokeDataFromSanguineERPModules();
                    List<clsGuestRoomDtl> listOfGuestRoomDtl = objSangERP.funGetGuestRoomDtl();
                    new frmSearchFormDialog("Guest Room Detail", listOfGuestRoomDtl, this, true).setVisible(true);
                    objSangERP = null;
                    //funOpenCustomerMaster();

                    if (clsGlobalVarClass.gSearchItemClicked)
                    {
                        Object[] data = clsGlobalVarClass.gArrListSearchData.toArray();
                        txtGuestName.setText(data[0].toString());//guestName
                        txtRoomNo.setText(data[2].toString());//roomNo                        
                        txtFolioNo.setText(data[3].toString());//folioNo                                                
                        txtGuestCode.setText(data[4].toString());//guestCode                                                
                        clsGlobalVarClass.gSearchItemClicked = false;
                    }

                    PanelCoupen.setVisible(false);
                    panelCustomer.setVisible(false);
                    PanelRemaks.setVisible(false);
                    lblcard.setVisible(false);
                    lblCardBalance.setVisible(false);
                    panelAmt.setVisible(false);
                    PanelGiftVoucher.setVisible(false);
                    PanelCard.setVisible(false);
                    PanelCheque.setVisible(false);
                    settlementName = "Room";
                    amountBox = "PaidAmount";
                    settleMode = true;
                    chkJioNotification.setSelected(false);
                    lblTipAmount.setVisible(false);
                    txtTip.setVisible(false);
                    lblCreditCustCode.setVisible(false);
                    PanelJioMoneySettlement.setVisible(false);
                    panelRoomSettlement.setLocation(panelDiscount.getLocation());
                    panelRoomSettlement.setVisible(true);
                    txtJioDestination.setVisible(false);
                    lblJioDestination.setVisible(false);
                    lblJioDestination.setText("");

                    break; */

                case "JioMoney":

                	
                	 settlementName = "JioMoney";
                     amountBox = "PaidAmount";
                     settleMode = true;
                    $("#txtRemark").focus();
                   
	                document.all["lblCard"].style.display='none';
	                document.all["lblCardBalance"].style.display='none';
	              
	                $("#txtPaidAmount").val(dblSettlementAmount);
	                $("#txtAmount").val(dblSettlementAmount);
	                //flgComplementarySettle = false;
	                document.getElementById("divRoomSettlement").style.display='none';
                    document.getElementById("btnCheckStatus").style.display='none';
                    document.getElementById("divJioMoneySettlement").style.display='block';
                    if (settleName.equals("JM Code"))
                    {
                    	//$("#lblJioMoneyCode").val("Scan/Enter Code");
                    	document.getElementById("lblJioMoneyCode").innerText="Scan/Enter Code";
                    	$("#lblJioDestination").val("");
                    	$("#txtJioDestination").val("");
                    	
                    	document.getElementById("lblJioMoneySendNotific").style.display='none';
    	                document.getElementById("chkJioNotific").style.display='none';
    	                document.getElementById("txtJioDestination").style.display='none';
                    }
                    else
                    {
                    	document.getElementById("lblJioMoneyCode").innerText="SMS/Email";
                    	document.getElementById("lblJioMoneyCode").style.display='block';
                    	document.getElementById("txtJioDestination").style.display='block';
                    	$("#txtJioDestination").val("");
                    	$("#chkJioNotific").attr('checked', true);
                       
                    }
                    document.getElementById("divAmt").style.display='block';
	                document.getElementById("divCoupen").style.display='none';
	                document.getElementById("divRemarks").style.display='none';
	                document.getElementById("divGiftVoucher").style.display='none';
	                document.getElementById("divCard").style.display='none';
	                document.getElementById("divCheque").style.display='none';
	                document.getElementById("divCustomer").style.display='none';
	                document.getElementById("lblTip").style.display='none';
	                document.getElementById("txtTip").style.display='none';
	               
                    document.getElementById("divDiscount").style.display='none';
	         //       document.getElementById("divJioMoneySettlement").style.top='150px';
	          //      document.getElementById("divJioMoneySettlement").style.left='740px';
	                       

                    break;
                
                case "Online Payment":
                    settlementName = "Online Payment";
                    amountBox = "PaidAmount";
                    settleMode = true;
                    $("#txtRemark").focus();
                    document.getElementById("divCustomer").style.display='none';
	                document.all["lblCard"].style.display='none';
	                document.all["lblCardBalance"].style.display='none';
	                document.getElementById("divAmt").style.display='block';
	                document.getElementById("divCoupen").style.display='none';
	                document.getElementById("divGiftVoucher").style.display='none';
	                document.getElementById("divCard").style.display='none';
	                document.getElementById("divCheque").style.display='none';
	                $("#txtPaidAmount").val(dblSettlementAmount);
	                $("#txtAmount").val(dblSettlementAmount);
	                //flgComplementarySettle = false;
	                document.getElementById("lblTip").style.display='none';
	                document.getElementById("txtTip").style.display='none';
	                document.getElementById("divRoomSettlement").style.display='none';
	                document.getElementById("divJioMoneySettlement").style.display='none';
	                document.getElementById("divRemarks").style.display='block';
	          //      document.getElementById("divRemarks").style.top='145px';
	           //     document.getElementById("divRemarks").style.left='415px';
                  
                    break;
                
        }
        
        $("#hidSettlemnetType").val(settleType);
	}
	function funHelp(transactionName)
	{	      
		fieldName=transactionName;
       window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
    }

	function funSetData(code)
	{
		
		  
		switch(fieldName)
		{
			case "POSCustomerMaster":
				
				 if(operationFrom=="directBiller" || operationFrom=="MakeKOT" )
				 {
					 funSetCustomerDataForHD(code);
				 }
				 else
				 {
					 funGetCustomerData(code);
						
			  		    $("#lblCreditCustCode").val(code);
					    customerCodeForCredit = code;
					    $("#txtCoupenAmt").val(dblSettlementAmount);
					 
				 }
						
			break;
			
			
		case "NewCustomer":
			funSetCustomerDataForHD(code);
			break;
			
			
		case "POSDeliveryBoyMaster":
			funSetDeliveryBoy(code);
			break;
			
			
		case "POSTableMaster":
			funTxtTableSearchClicked(code);
			break;
			
			
		case "POSWaiterMaster":
			funTxtWaiterClicked(code);
			break;
			
			
// 		case "POSCustomerMaster":
// 			funSetCustomerDataForHD(code);
// 			break;
// 		case "NewCustomer":
// 			funSetCustomerDataForHD(code);
// 			break;
// 		case "POSDeliveryBoyMaster":
// 			funSetDeliveryBoy(code);
// 			break;
			
		};
    }
	function funGetCustomerData(code)
	{
	 code=code.trim();
		var searchurl=getContextPath()+"/loadPOSCustomerMasterData.html?POSCustomerCode="+code;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	$("#hidCustomerName").val(response.strCustomerName);
			        	$("#hidCustomerCode").val(response.strCustomerCode); 
			        	//gCustomerCode=response.strCustomerCode;
			        	$("#lblCreditCustCode").val(code);
			        	//$("#hidCustomerName").val(response.strCustomerName);
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

	function funSetDefaultRadioBtnForDiscount()
    {
		$('input#rdbAll').prop('checked', true);
	    document.all["cmbItemCategary"].style.display = 'none';
    }
	 function funVisibleDeliveryCharges(flag)
    {
		 document.all["lblDelCharge"].style.display = flag;
		 document.all["txtDeliveryCharge"].style.display = flag;
		 document.all["btnApplyDeliveryCharge"].style.display = flag;
		 document.all["lblDelBoyname"].style.display = flag;
		 $("#txtDeliveryCharge").val('0.00');
       /*  lblDelBoyName.setVisible(flag);
        txtDeliveryCharges.setText("0.00"); */
    }
	
	 function funSetDate()
	 {
		 $("#dteCheque" ).datepicker('setDate', 'today');
		 $("#dteExpiry" ).datepicker('setDate', 'today');
		 
	 }

	 function funEnterButtonClicked()
	 {
		 
		    if ($("#txtPaidAmount").val().length==0)
	        {
	            paidAmount = 0.00;
	        }
	        else
	        {
	            paidAmount =parseFloat($("#txtPaidAmount").val());
	        }
	        if (paidAmount == 0.00 && finalGrandTotal != 0.00)
	        {
	        	alert("Please Enter Amount");
	        	
	        	return;
	        }
	        
	        
	        var txtPaidAmount=parseFloat($("#txtPaidAmount").val());
	        if(txtPaidAmount==0)
	        {
	        	alert("Bill Amount is Zero");
	        	
	        	return;
	        }
	        
	        if (settleType=="Debit Card")
	        {

	                var cardBal =parseFloat($("#lblCardBalance").val());
	                if (cardBal < paidAmount)
	                {
	                	alert("Insufficient Amount in Card");
	                	
	                	return;
	                }

	        }
	        
	        
	        if(settleType=="")
	        {
	        	alert("Please Select Settelment Mode");
	        	return;
	        }
	      

	        	if(settleType!="")
	        	{
		            switch (settleType)
		            {
		                 case "Cash":
		                	if (hmSettlemetnOptions.has(settleName))
		                    {
		                		var arrSettleOptions=[];
		                		arrSettleOptions = hmSettlemetnOptions.get(settleName);
		                        var tempPaidAmt = parseFloat(arrSettleOptions[3]);
		                        tempPaidAmt = tempPaidAmt + paidAmount;
		                        arrSettleOptions[3]=tempPaidAmt;
		                        arrSettleOptions[5]=refundAmount;
		                     
		                        hmSettlemetnOptions.set(settleName, arrSettleOptions); 
		                    }
		                    else
		                    {
		                    	var arrSettleOptions=[];
		                    	 arrSettleOptions.push(settleName);
		                    	 arrSettleOptions.push(settlementCode);
		                    	 arrSettleOptions.push(dblSettlementAmount);
		                    	 arrSettleOptions.push(paidAmount);
		                    	 arrSettleOptions.push(finalGrandTotal);
		                    	 arrSettleOptions.push(refundAmount);
		                    	 arrSettleOptions.push(settelmentDesc);
		                    	 arrSettleOptions.push(settleType);
		                    	 arrSettleOptions.push("");
		                    	 arrSettleOptions.push("");
		                    	 arrSettleOptions.push("");
		                    	 arrSettleOptions.push("");
		                		
		                		 
		                        hmSettlemetnOptions.set(settleName,arrSettleOptions);   // settlementCode, dblSettlementAmount, paidAmount, "", settleName, "", "", finalGrandTotal, refundAmount, "", getStrSettelmentDesc(), getStrSettelmentType()));
		                      
		                    }
		                	break; 
		                	
		                 case "Credit Card":
		                     if (""==$("#txtPaidAmount").val())
		                     {
		                    	 alert("Please Enter Amount");
		                    	 return;
		                     }
		                     if ($("#txtPaidAmount").val() < 0)
		                     {
		                    	 alert("Invalid paid amount");
		                    	 return;
		                 	 }
		                     if ("${gCreditCardSlipNo}"=="Y")
		                     {
		                         if ($("#txtCardName").val().length <= 0)
		                         {
		                        	 prompt("Please Enter Slip No");
		                           	 $("#txtCardName").focus();
		                             return;
		                         }
		                     }
		                     var objCreditCardExpDate = $("#dteExpiry").val();
		                     var expiryDate = "";
		                     if ("${gCreditCardExpiryDate}"=="Y")
		                     {
		                         if (objCreditCardExpDate == null)
		                         {
		        
		                        	 alert("Please Select Expiry Date");
		                        	return;
		                         }
		                         else
		                         {
		                             expiryDate = objCreditCardExpDate;
		                         }
		                     }
		                     if (hmSettlemetnOptions.has(settleName))
		                     {
		                    		var arrSettleOptions=new Array();
			                		arrSettleOptions = hmSettlemetnOptions.get(settleName);
			                        var tempPaidAmt = arrSettleOptions[3];
			                        tempPaidAmt = tempPaidAmt + paidAmount;
			                        arrSettleOptions[3]=tempPaidAmt;
			                        arrSettleOptions[5]=refundAmount;
			                        arrSettleOptions[9]=$("#txtCardName").val();
			                        hmSettlemetnOptions.set(settleName, arrSettleOptions); 
		                    	
		                     }
		                     else
		                     {
		                    	 var arrSettleOptions=new Array();
		                    	 arrSettleOptions[0]=settleName;
		                		 arrSettleOptions[1]=settlementCode;
		                		 arrSettleOptions[2]=dblSettlementAmount;
		                		 arrSettleOptions[3]=paidAmount;
		                		 arrSettleOptions[4]=finalGrandTotal;
		                		 arrSettleOptions[5]=refundAmount;
		                		 arrSettleOptions[6]=settelmentDesc;
		                		 arrSettleOptions[7]=settleType;
		                		 arrSettleOptions[8]=expiryDate;
		                		 arrSettleOptions[9]=$("#txtCardName").val();
		                		 arrSettleOptions[10]="";
		                		 arrSettleOptions[11]="";
		                		 
		                         hmSettlemetnOptions.set(settleName,arrSettleOptions);
		                    }
		                     break;
		                	
		                 case "Coupon":
	
		                     paidAmount =$("#txtCoupenAmt").val();
		                     if ($("#txtCoupenAmt").length <= 0)
		                     {
		                    	 alert("Please Enter Amount");
		                       //  new frmOkPopUp(null, "Please Enter Amount", "Warning", 1).setVisible(true);
		                         return;
		                     }
		                     if (paidAmount < 0)
		                     {
		                    	 alert("Invalid paid amount");
		                         //new frmOkPopUp(null, "Invalid paid amount", "Warning", 1).setVisible(true);
		                         return;
		                     }
		                     if ($("#txtCoupenAmt").val()=="")
		                     {
		                    	 alert("Please Enter Remark");
		                         //new frmOkPopUp(null, "Please Enter Remark", "Warning", 1).setVisible(true);
		                         return;
		                     }
		                     else
		                     {
		                         if (hmSettlemetnOptions.has(settleName))
		                         {
		                        	 	var arrSettleOptions=new Array();
				                		arrSettleOptions = hmSettlemetnOptions.get(settleName);
				                        var tempPaidAmt = arrSettleOptions[3];
				                        tempPaidAmt = tempPaidAmt + paidAmount;
				                        arrSettleOptions[3]=tempPaidAmt;
				                        arrSettleOptions[5]=refundAmount;
				                        hmSettlemetnOptions.set(settleName, arrSettleOptions); 
				                 }
		                         else
		                         {
		                        	 var arrSettleOptions=new Array();
			                    	 arrSettleOptions[0]=settleName;
			                		 arrSettleOptions[1]=settlementCode;
			                		 arrSettleOptions[2]=dblSettlementAmount;
			                		 arrSettleOptions[3]=paidAmount;
			                		 arrSettleOptions[4]=finalGrandTotal;
			                		 arrSettleOptions[5]=refundAmount;
			                		 arrSettleOptions[6]=settelmentDesc;
			                		 arrSettleOptions[7]=settleType;
			                		 arrSettleOptions[8]="";
			                		 arrSettleOptions[9]="";
			                		 arrSettleOptions[10]="";
			                		 arrSettleOptions[11]="";
			                         hmSettlemetnOptions.set(settleName,arrSettleOptions);
		                        	 
		                             //_balanceAmount = fun_get_BalanceAmount(_balanceAmount, _paidAmount, settleType);
		                         }
		                     }
		                     break;
		                     
		                 case "Cheque":
	
		                     break;
	
		                 case "Gift Voucher":
		                     if (!flgGiftVoucherOK)
		                     {
		                    	 alert("Press OK button on Gift Voucher");
		                         return;
		                     }
							  if (hmSettlemetnOptions.has(settleName))
		                     {
		                    	 	var arrSettleOptions=new Array();
			                		arrSettleOptions = hmSettlemetnOptions.get(settleName);
			                        var tempPaidAmt = arrSettleOptions[3];
			                        tempPaidAmt = tempPaidAmt + paidAmount;
			                        arrSettleOptions[3]=tempPaidAmt;
			                        arrSettleOptions[5]=refundAmount;
			                        hmSettlemetnOptions.set(settleName, arrSettleOptions); 
			                 }
		                     else
		                     {
		                    	 var arrSettleOptions=new Array();
		                    	 arrSettleOptions[0]=settleName;
		                		 arrSettleOptions[1]=settlementCode;
		                		 arrSettleOptions[2]=dblSettlementAmount;
		                		 arrSettleOptions[3]=paidAmount;
		                		 arrSettleOptions[4]=finalGrandTotal;
		                		 arrSettleOptions[5]=refundAmount;
		                		 arrSettleOptions[6]=settelmentDesc;
		                		 arrSettleOptions[7]=settleType;
		                		 arrSettleOptions[8]="";
		                		 arrSettleOptions[9]="";
		                		 arrSettleOptions[10]="";
		                		 arrSettleOptions[11]=giftVoucherSeriesCode+""+giftVoucherCode;
		                		 
		                		 hmSettlemetnOptions.set(settleName, arrSettleOptions);
		                     }
		                     break;
	
		                 case "Complementary":
	
		                     if (hmSettlemetnOptions.size > 0)
		                     {
		                    	 alert("Coplimentary Settlement is Not Allowed In MultiSettlement!!!");
		                         return;
		                     }
		                     if ($("#txtRemarks").val().length == 0)
		                     {
		                    	 alert("Please Enter Remarks");
		                         return;
		                     }
		                     /* if (arrObjReasonCode.length==0) 
		                     {
		                    	 alert("No complementary reasons are created");
		                         return;
		                     }
		                     else
		                     {
		                         var selectedReason= prompt("Please Select Reason?",arrObjReasonName);
		                        if (null == selectedReason)
		                         {
		                             alert("Please Select Reason");
		                             return;
		                         }
		                         else
		                         {
		                              for (var cntReason = 0; cntReason < arrObjReasonCode.length; cntReason++)
		                             {
		                                 if (arrObjReasonName[cntReason]==selectedReason)
		                                 {
		                                     selectedReasonCode = arrObjReasonName[cntReason];
		                                     break;
		                                 }
		                             } 
		                             refundAmount = 0.00;
		                             balanceAmount = 0.00;
		                             
		                             var arrSettleOptions=new Array();
			                    	 arrSettleOptions[0]=settleName;
			                		 arrSettleOptions[1]=settlementCode;
			                		 arrSettleOptions[2]=dblSettlementAmount;
			                		 arrSettleOptions[3]=paidAmount;
			                		 arrSettleOptions[4]=finalGrandTotal;
			                		 arrSettleOptions[5]=refundAmount;
			                		 arrSettleOptions[6]=settelmentDesc;
			                		 arrSettleOptions[7]=settleType;
			                		 arrSettleOptions[8]=expiryDate;
			                		 arrSettleOptions[9]="";
			                		 arrSettleOptions[10]=$("#txtRemark").val();
			                		 arrSettleOptions[11]="";
			                		 
			                         hmSettlemetnOptions.set(settleName,arrSettleOptions);
			                         
		                         } 
		                     } */
		                     
		                     
		                     refundAmount = 0.00;
                             balanceAmount = 0.00;
                             
                             var arrSettleOptions=new Array();
	                    	 arrSettleOptions[0]=settleName;
	                		 arrSettleOptions[1]=settlementCode;
	                		 arrSettleOptions[2]=dblSettlementAmount;
	                		 arrSettleOptions[3]=paidAmount;
	                		 arrSettleOptions[4]=finalGrandTotal;
	                		 arrSettleOptions[5]=refundAmount;
	                		 arrSettleOptions[6]=settelmentDesc;
	                		 arrSettleOptions[7]=settleType;
	                		 arrSettleOptions[8]=expiryDate;
	                		 arrSettleOptions[9]="";
	                		 arrSettleOptions[10]=$("#txtRemarks").val();
	                		 arrSettleOptions[11]="";
	                		 
	                         hmSettlemetnOptions.set(settleName,arrSettleOptions);
		                     
		                     
		                     break;
		                     
		                 case "Credit":
	                         // this code is commented b'coz of if settlement= credit & then customer selected 
	                         // after clicked on Enter btn customer name not set in Customer TextBox
// 		                     if (gCustomerCode=="")
							 if(hidCustomerName=="")
		                     {
		                    	 alert("Please Select Customer!!!");
		                         return;
		                     }
	
		                     if (hmSettlemetnOptions.has(settleName))
		                     {
		                    		var arrSettleOptions=new Array();
			                		arrSettleOptions = hmSettlemetnOptions.get(settleName);
			                        var tempPaidAmt = arrSettleOptions[3];
			                        tempPaidAmt = tempPaidAmt + paidAmount;
			                        arrSettleOptions[3]=tempPaidAmt;
			                        arrSettleOptions[5]=refundAmount;
			                        hmSettlemetnOptions.set(settleName, arrSettleOptions); 
		                     }
		                     else
		                     {
		                    	 var arrSettleOptions=new Array();
		                    	 arrSettleOptions[0]=settleName;
		                		 arrSettleOptions[1]=settlementCode;
		                		 arrSettleOptions[2]=dblSettlementAmount;
		                		 arrSettleOptions[3]=paidAmount;
		                		 arrSettleOptions[4]=finalGrandTotal;
		                		 arrSettleOptions[5]=refundAmount;
		                		 arrSettleOptions[6]=settelmentDesc;
		                		 arrSettleOptions[7]=settleType;
		                		 arrSettleOptions[8]="";
		                		 arrSettleOptions[9]="";
		                		 arrSettleOptions[10]="";
		                		 arrSettleOptions[11]="";
		                		
		                		 hmSettlemetnOptions.set(settleName,arrSettleOptions);
		                       }
		                     break;
	
		                 case "Debit Card":
		                     if (hmSettlemetnOptions.has(settleName))
		                     {
		                    	 	var arrSettleOptions=new Array();
			                		arrSettleOptions = hmSettlemetnOptions.get(settleName);
			                        var tempPaidAmt = arrSettleOptions[3];
			                        tempPaidAmt = tempPaidAmt + paidAmount;
			                        arrSettleOptions[3]=tempPaidAmt;
			                        arrSettleOptions[5]=refundAmount;
			                        hmSettlemetnOptions.set(settleName, arrSettleOptions); 
			                  
		                     }
		                     else
		                     {
		                    	 var arrSettleOptions=new Array();
		                    	 arrSettleOptions[0]=settleName;
		                		 arrSettleOptions[1]=settlementCode;
		                		 arrSettleOptions[2]=dblSettlementAmount;
		                		 arrSettleOptions[3]=paidAmount;
		                		 arrSettleOptions[4]=finalGrandTotal;
		                		 arrSettleOptions[5]=refundAmount;
		                		 arrSettleOptions[6]=settelmentDesc;
		                		 arrSettleOptions[7]=settleType;
		                		 arrSettleOptions[8]="";
		                		 arrSettleOptions[9]="";
		                		 arrSettleOptions[10]="";
		                		 arrSettleOptions[11]="";
		                		
		                		 hmSettlemetnOptions.set(settleName,arrSettleOptions);
		                     }
		                     break;
		                 case "Loyality Points":
		                	 var flgResult=funCheckPointsAgainstCustome();
		                     if (flgResult)
		                     {
		                         if (hmSettlemetnOptions.has(settleName))
		                         {
		                        	 	var arrSettleOptions=new Array();
				                		arrSettleOptions = hmSettlemetnOptions.get(settleName);
				                        var tempPaidAmt = arrSettleOptions[3];
				                        tempPaidAmt = tempPaidAmt + paidAmount;
				                        arrSettleOptions[3]=tempPaidAmt;
				                        arrSettleOptions[5]=refundAmount;
				                        hmSettlemetnOptions.set(settleName, arrSettleOptions); 
		                        
		                         }
		                         else
		                         {
		                        	 var arrSettleOptions=new Array();
			                    	 arrSettleOptions[0]=settleName;
			                		 arrSettleOptions[1]=settlementCode;
			                		 arrSettleOptions[2]=dblSettlementAmount;
			                		 arrSettleOptions[3]=paidAmount;
			                		 arrSettleOptions[4]=finalGrandTotal;
			                		 arrSettleOptions[5]=refundAmount;
			                		 arrSettleOptions[6]=settelmentDesc;
			                		 arrSettleOptions[7]=settleType;
			                		 arrSettleOptions[8]="";
			                		 arrSettleOptions[9]="";
			                		 arrSettleOptions[10]="";
			                		 arrSettleOptions[11]="";
			                		
			                		 hmSettlemetnOptions.set(settleName,arrSettleOptions);
		                         }
		                     }
		                     else
		                     {
		                         return;
		                     }
		                     break;
	
		                 case "Member":
		                     if (cmsStopCredit=="Y")
		                     {
		                    	 alert("Credit Facility Is Stopped For This Member!!!");
		                     }
		                     else if (cmsMemberCreditLimit > 0)
		                     {
		                         if (cmsMemberBalance < dblSettlementAmount)
		                         {
		                             alert("Credit Limit Exceeds, Balance Credit: " + cmsMemberBalance+"");
		                        	 return;
		                         }
		                         if (paidAmount <= cmsMemberBalance)
		                         {
		                             cmsMemberBalance = 0;
		                             if (hmSettlemetnOptions.has(settleName))
		                             {
		                            	 	var arrSettleOptions=new Array();
					                		arrSettleOptions = hmSettlemetnOptions.get(settleName);
					                        var tempPaidAmt = arrSettleOptions[3];
					                        tempPaidAmt = tempPaidAmt + paidAmount;
					                        arrSettleOptions[3]=tempPaidAmt;
					                        arrSettleOptions[5]=refundAmount;
					                        hmSettlemetnOptions.set(settleName, arrSettleOptions); 
		                             }
		                             else
		                             {
		                            	 var arrSettleOptions=new Array();
				                    	 arrSettleOptions[0]=settleName;
				                		 arrSettleOptions[1]=settlementCode;
				                		 arrSettleOptions[2]=dblSettlementAmount;
				                		 arrSettleOptions[3]=paidAmount;
				                		 arrSettleOptions[4]=finalGrandTotal;
				                		 arrSettleOptions[5]=refundAmount;
				                		 arrSettleOptions[6]=settelmentDesc;
				                		 arrSettleOptions[7]=settleType;
				                		 arrSettleOptions[8]="";
				                		 arrSettleOptions[9]="";
				                		 arrSettleOptions[10]="";
				                		 arrSettleOptions[11]="";
				                		 hmSettlemetnOptions.set(settleName, arrSettleOptions);
				                	 }
		                         }
		                     }
		                     else
		                     {
		                         cmsMemberBalance = 0;
		                         if (hmSettlemetnOptions.has(settleName))
		                         {
		                        	 	var arrSettleOptions=new Array();
				                		arrSettleOptions = hmSettlemetnOptions.get(settleName);
				                        var tempPaidAmt = arrSettleOptions[3];
				                        tempPaidAmt = tempPaidAmt + paidAmount;
				                        arrSettleOptions[3]=tempPaidAmt;
				                        arrSettleOptions[5]=refundAmount;
				                        hmSettlemetnOptions.set(settleName, arrSettleOptions); 
				                }
		                         else
		                         {
		                        	 
		                        	 var arrSettleOptions=new Array();
			                    	 arrSettleOptions[0]=settleName;
			                		 arrSettleOptions[1]=settlementCode;
			                		 arrSettleOptions[2]=dblSettlementAmount;
			                		 arrSettleOptions[3]=paidAmount;
			                		 arrSettleOptions[4]=finalGrandTotal;
			                		 arrSettleOptions[5]=refundAmount;
			                		 arrSettleOptions[6]=settelmentDesc;
			                		 arrSettleOptions[7]=settleType;
			                		 arrSettleOptions[8]="";
			                		 arrSettleOptions[9]="";
			                		 arrSettleOptions[10]="";
			                		 arrSettleOptions[11]="";
			                		 hmSettlemetnOptions.set(settleName, arrSettleOptions);
			                	 }
		                     }
		                     break;
		                     
		                 case "Room":
		                     if (hmSettlemetnOptions.has(settleName))
		                     {
		                    	 	var arrSettleOptions=new Array();
			                		arrSettleOptions = hmSettlemetnOptions.get(settleName);
			                        var tempPaidAmt = arrSettleOptions[3];
			                        tempPaidAmt = tempPaidAmt + paidAmount;
			                        arrSettleOptions[3]=tempPaidAmt;
			                        arrSettleOptions[5]=refundAmount;
			                        hmSettlemetnOptions.set(settleName, arrSettleOptions); 
		                     }
		                     else
		                     {
		                    	 
		                    	 var arrSettleOptions=new Array();
		                    	 arrSettleOptions[0]=settleName;
		                		 arrSettleOptions[1]=settlementCode;
		                		 arrSettleOptions[2]=dblSettlementAmount;
		                		 arrSettleOptions[3]=paidAmount;
		                		 arrSettleOptions[4]=finalGrandTotal;
		                		 arrSettleOptions[5]=refundAmount;
		                		 arrSettleOptions[6]=settelmentDesc;
		                		 arrSettleOptions[7]=settleType;
		                		 arrSettleOptions[8]=$("#txtFolioNo").val(); //assign for temprary
		                		 arrSettleOptions[9]=$("#txtRoomNo").val();
		                		 arrSettleOptions[10]="";
		                		 arrSettleOptions[11]=$("#txtGuestCode").val();
		                		 hmSettlemetnOptions.set(settleName, arrSettleOptions);
		                	       
		                     }
		                     break;
	
	
		                 case "JioMoney":
	
		                     if (hmSettlemetnOptions.has(settleName))
		                     {
		                    	 	var arrSettleOptions=new Array();
			                		arrSettleOptions = hmSettlemetnOptions.get(settleName);
			                        var tempPaidAmt = arrSettleOptions[3];
			                        tempPaidAmt = tempPaidAmt + paidAmount;
			                        arrSettleOptions[3]=tempPaidAmt;
			                        arrSettleOptions[5]=refundAmount;
			                        hmSettlemetnOptions.set(settleName, arrSettleOptions); 
			                 }
		                     else
		                     {
		                    	 var arrSettleOptions=new Array();
		                    	 arrSettleOptions[0]=settleName;
		                		 arrSettleOptions[1]=settlementCode;
		                		 arrSettleOptions[2]=dblSettlementAmount;
		                		 arrSettleOptions[3]=paidAmount;
		                		 arrSettleOptions[4]=finalGrandTotal;
		                		 arrSettleOptions[5]=refundAmount;
		                		 arrSettleOptions[6]=settelmentDesc;
		                		 arrSettleOptions[7]=settleType;
		                		 arrSettleOptions[8]="";
		                		 arrSettleOptions[9]="";
		                		 arrSettleOptions[10]="";
		                		 arrSettleOptions[11]="";
		                		 hmSettlemetnOptions.set(settleName, arrSettleOptions);
		                   }
		                     break;
		                     
		                 case "Online Payment":
		                     if (hmSettlemetnOptions.has(settleName))
		                     {
		                    		var arrSettleOptions=new Array();
			                		arrSettleOptions = hmSettlemetnOptions.get(settleName);
			                        var tempPaidAmt = arrSettleOptions[3];
			                        tempPaidAmt = tempPaidAmt + paidAmount;
			                        arrSettleOptions[3]=tempPaidAmt;
			                        arrSettleOptions[5]=refundAmount;
			                        hmSettlemetnOptions.set(settleName, arrSettleOptions); 
			                 }
		                     else
		                     {
		                    	 var arrSettleOptions=new Array();
		                    	 arrSettleOptions[0]=settleName;
		                		 arrSettleOptions[1]=settlementCode;
		                		 arrSettleOptions[2]=dblSettlementAmount;
		                		 arrSettleOptions[3]=paidAmount;
		                		 arrSettleOptions[4]=finalGrandTotal;
		                		 arrSettleOptions[5]=refundAmount;
		                		 arrSettleOptions[6]=settelmentDesc;
		                		 arrSettleOptions[7]=settleType;
		                		 arrSettleOptions[8]="";
		                		 arrSettleOptions[9]="";
		                		 arrSettleOptions[10]="";
		                		 arrSettleOptions[11]="";
		                		 hmSettlemetnOptions.set(settleName, arrSettleOptions);
		                	 }
		                     break;
	            }
	            
	            balanceAmount=$('#txtAmount').val()-$('#txtPaidAmount').val();
	         

	        
	        flgEnterBtnPressed=true;
	        funSettlementDtlFill(); 	//for refresh item table
		}
}
	 
	function funSettlementDtlFill()
	 {
  
		if(hmSettlemetnOptions.size>0){
			
			var tblSettleItemDtl=document.getElementById('tblSettleItemTable');
			var rowCount = tblSettleItemDtl.rows.length;
			//totalItemRow is total item row count
		    while((totalItemRow+1) < rowCount){
		    	rowCount=rowCount-1;
		    	tblSettleItemDtl.deleteRow(rowCount);
		    }
			/* if(checkSetteType=="Balance")
			{
			   tblSettleItemDtl.deleteRow(rowCount-1);
				rowCount--;
			} */
		
			var arrSettleOptions=new Array();
			var iterator1=hmSettlemetnOptions.values();
			for(var k =0;k<hmSettlemetnOptions.size;k++){
				
				var arrSettleOptions=iterator1.next().value;
				
				var insertRow = tblSettleItemDtl.insertRow(rowCount);
				var col1=insertRow.insertCell(0);
			    var col2=insertRow.insertCell(1);
			    var col3=insertRow.insertCell(2);
			    var col4=insertRow.insertCell(3);
			    var col5=insertRow.insertCell(4); 
			    var col6=insertRow.insertCell(5);
			    var col7=insertRow.insertCell(6);
			    var col8=insertRow.insertCell(7);
			    
			    var remark="";//  $('#txtRemark').val();
	            var dteExpiryDate=  "";//$('#dteExpiryDate').val();
	            
	           
	            //arrSettleOptions=hmSettlemetnOptions.get(settleName);
	            
			    col1.innerHTML = "<input readonly=\"readonly\"  size=\"25px\" style=\"text-align:left;border:none;\" name=\"listSettlementDtlOnBill["+(rowCountSettle)+"].strSettelmentDesc\" id=\"strSettelmentDesc."+(rowCountSettle)+"\" value='"+arrSettleOptions[0]+"' />"; //settleName
			    /* col2.innerHTML = "<input readonly=\"readonly\"  style=\"text-align: right; color:blue; height:20px; border:none;\"  />"; */
			    col3.innerHTML = "<input readonly=\"readonly\"  size=\"20px\" style=\"text-align: right; color:black; height:30px;border:none;padding-right:20px;width:70px;\"  name=\"listSettlementDtlOnBill["+(rowCountSettle)+"].dblPaidAmt\" id=\"dblPaidAmt."+(rowCountSettle)+"\" value='"+arrSettleOptions[3]+"'/>"; //paid Amt
			    /*col4.innerHTML = "<input readonly=\"readonly\"  size=\"1px\"      style=\"text-align: right; color:blue; height:20px;\"  />";
			    col5.innerHTML = "<input readonly=\"readonly\"  size=\"1px\"      style=\"text-align: right; color:blue; height:20px;\"  />"; */
			    col5.innerHTML = "<input type=\"hidden\" style=\"text-align: right; color:blue; height:20px;\"  name=\"listSettlementDtlOnBill["+(rowCountSettle)+"].strSettelmentCode\" id=\"strSettelmentCode."+(rowCountSettle)+"\" value='"+arrSettleOptions[1]+"' />"; //code
			    col6.innerHTML = "<input type=\"hidden\" style=\"text-align: right; color:blue; height:20px;\"  name=\"listSettlementDtlOnBill["+(rowCountSettle)+"].strSettelmentType\" id=\"strSettelmentType."+(rowCountSettle)+"\" value='"+arrSettleOptions[7]+"' />"; //type
			    col7.innerHTML = "<input type=\"hidden\" style=\"text-align: right; color:blue; height:20px;\"   name=\"listSettlementDtlOnBill["+(rowCountSettle)+"].dblSettlementAmt\" id=\"dblSettlementAmt."+(rowCountSettle)+"\" value="+arrSettleOptions[2]+" />"; //settl amt
			    col8.innerHTML = "<input type=\"hidden\" style=\"text-align: right; color:blue; height:20px;\"  name=\"listSettlementDtlOnBill["+(rowCountSettle)+"].dblRefundAmt\" id=\"dblRefundAmt."+(rowCountSettle)+"\" value="+arrSettleOptions[5]+" />";   //refund amt
			    
			    rowCountSettle++;
			    rowCount++;
			}
			
				//alert(iterator1.next().value);
			
			
		    document.getElementById("divRemarks").style.display='block';
		    document.getElementById("divAmt").style.display='block';
		    
		    funFillBalanceAmt();
		    
		    
		}
		
			
		    
    }

		function funFillBalanceAmt()
		{
		    var tblSettleItemDtl=document.getElementById('tblSettleItemTable');
			var rowCount = tblSettleItemDtl.rows.length;
			var insertRow = tblSettleItemDtl.insertRow(rowCount);
			var col1=insertRow.insertCell(0);
		    var col2=insertRow.insertCell(1);
		    var col3=insertRow.insertCell(2);
		    var col4=insertRow.insertCell(3);
		    var col5=insertRow.insertCell(4);
		    var col6=insertRow.insertCell(5);
		    var col7=insertRow.insertCell(6);
		    var col8=insertRow.insertCell(7);
		    
		    
		    col1.innerHTML = "<input readonly=\"readonly\"  size=\"30px\"   style=\"text-align: left; color:black; height:30px;border:none;width=200px;\"   value='Balance Amount' />";
		    /* col2.innerHTML = "<input readonly=\"readonly\"        style=\"text-align: right; color:blue; height:20px;\"  />"; */
		    col3.innerHTML = "<input readonly=\"readonly\"  size=\"20px\"    style=\"text-align: right; color:blue; height:30px;border:none;padding-right:20px;width:70px;\"  value='"+balanceAmount+"' />";
		   /*  col4.innerHTML = "<input readonly=\"readonly\" />";
		    col5.innerHTML = "<input readonly=\"readonly\"/>"; */
		    
		    $('#txtAmount').val(balanceAmount);
		    $('#txtPaidAmount').val(balanceAmount);
		    
		    checkSetteType="Balance";
		}



	function funRemoveProductRows()
	{
		var table = document.getElementById("tblSettleItemTable");
		var rowCount = table.rows.length;
		while(rowCount>0)
		{
			table.deleteRow(0);
			rowCount--;
		}
	}

	function funSubGroupDiscClicked()
	{
		disountType="";
		disountType="subGroup";
		 document.all["cmbItemCategary"].style.display = 'block';
		 
// 		 var element="${listSubGroupName}";
// 		 var subGroupcode="${listSubGroupCode}";
// 		 var tempCode=subGroupcode.substring(1,subGroupcode.length-1);
// 		 subGroupcode=tempCode.split(",");
		 
// 		 var tmp=element.substring(1,element.length-1)
// 		 element=tmp.split(",");
// 			var html = '';
			
// 			   hmSettlemetnOptions.forEach(function(value, key) {
//        	hmGroupMap.set(strGroupCode, strGroupName); 
// 				hmSubGroupMap.set(strSubGroupCode, strSGName);
// 			for(var cnt=0;cnt<element.length;cnt++)
// 			{
// 					html += '<option value="' + subGroupcode[cnt] + '" >' + element[cnt]
// 							+ '</option>';
// 			}
				var html = '';
			hmSubGroupMap.forEach(function(value, key) {
				html += '<option value="' + key + '" >' + value
						+ '</option>';
			   });
	
			$('#cmbItemCategary').html(html);
			
		
	}
	function funGroupDiscClicked()
	{
		disountType="";
		disountType="group";
		 document.all["cmbItemCategary"].style.display = 'block';
// 		 var element="${listGroupName}";
		
// 		 var groupcode="${listGroupCode}";
// 		 var tempCode=groupcode.substring(1,groupcode.length-1);
// 		 groupcode=tempCode.split(",");
		 
		 
		
// 		 var tmp=element.substring(1,element.length-1)
// 		 element=tmp.split(",");
// 			var html = '';
// 			for(var cnt=0;cnt<element.length;cnt++)
// 			{
// 					html += '<option value="'+groupcode[cnt]+'" >' +element[cnt]
// 							+ '</option>';
// 			}
	var html = '';
			hmGroupMap.forEach(function(value, key) {
				html += '<option value="' + key + '" >' + value
						+ '</option>';
			   });
			$('#cmbItemCategary').html(html);
		
	}
	function funItemDiscClicked()
	{
		disountType="";
		disountType="item";
		 document.all["cmbItemCategary"].style.display = 'block';
// 		 var element="${listItemName}";
// 		 var itemcode="${listItemCode}";
// 		 var tempCode=itemcode.substring(1,itemcode.length-1);
// 		 itemcode=tempCode.split(",");
		
// 		 var tmp=element.substring(1,element.length-1)
// 		 element=tmp.split(",");
// 			var html = '';
// 			for(var cnt=0;cnt<element.length;cnt++)
// 			{
// 					html += '<option value="' + itemcode[cnt] + '" >' + element[cnt]
// 							+ '</option>';
// 			}
	var html = '';
	 hmItempMap.forEach(function(value, key) {
				html += '<option value="' + key + '" >' + value
						+ '</option>';
			   });
			$('#cmbItemCategary').html(html);
	}
	function funTotalDiscClicked()
	{
		disountType="";
		disountType="Total"; 
		document.all["cmbItemCategary"].style.display = 'none';
		 
	}
	function funCardNo()
	{
		var retDebitCardNo="";
		var searchurl=getContextPath()+"/funGetDebitCardNo.html?voucherNo="+voucherNo+"&tableNo="+tableNo;
		$.ajax({
			type:"GET",
		 	url: searchurl,
	        dataType: "json",
	        async : false,
	        success: function (response){
	        	retDebitCardNo=response.retDebitCardNo;
	        	debitCardNo =response.retDebitCardString;
	        	
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
		
		return retDebitCardNo;
	}
	function funCheckPointsAgainstCustomer()
	{
		var totalLoyalityPoints = 0.00, totalReedemedPoints = 0.00;
		var flgResult=false;
		var txtPaidAmt=$("#txtPaidAmount").val();
		var customerMobile="${customerMobile}";
		var searchurl=getContextPath()+"/funCheckPointsAgainstCustomer.html?CRMInterface="+gCRMInterface+"&customerMobile="+customerMobile+"&voucherNo="+voucherNo+"&txtPaidAmt="+txtPaidAmt;
		$.ajax({
			type:"GET",
		 	url: searchurl,
	        dataType: "json",
	        async : false,
	        success: function (response){
	        	totalLoyalityPoints=response.totalLoyalityPoints;
	        	totalReedemedPoints=response.totalReedemedPoints;
	        	 
	        	if (txtPaidAmt <= totalLoyalityPoints)
                 {
                     flgResult = true;
                     loyalityPoints = txtPaidAmt;
                 }
                 else
                 {
                	 alert("Your total Loyality points are "+totalLoyalityPoints+" ")
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
		
		return flgResult;
	}
// 	  function funGetTotalPaidAmount()
// 	    {
// 	        var totalPaidAmt = 0.00;
// 	        var arr=new Array();
// 	        if(hmSettlemetnOptions.size>0)
//         	{
//         		hmSettlemetnOptions.forEach(function (item, key, mapObj) 
//         		{
//         			arr=item;
//     	       		if ("Complementary"==(arr[6]))
//     	            {
//     	                totalPaidAmt = finalGrandTotal;
//     	                break;
//     	            }
//     	            totalPaidAmt =totalPaidAmt + arr[3];
//         		});
//         	}
// 	        return totalPaidAmt;
// 	    }
	  
	  
	  function funBackButtonClicked(backButton)
	  {
		  
		  $('#txtDiscountPer').val('0.00');
		  $('#txtDiscountAmt').val('0.00');
	
		  listOfDicountItem=[];
		  listOfCompItem=[];
		  listBillItem=[];
		  disountType="";
		  document.getElementById("tab2").style.display='none';		
		  document.getElementById("tab1").style.display='block';  
		  hmSettlemetnOptions=new Map();
	  }
	  
	  
	  
	  function funSaveBtnClicked()
	  {
		   listOfDicountItem=[];

		  if(balanceAmount ===''){
			  alert("Balance is not zero.");
		  		 return false;
		  	}
		  else if(balanceAmount>0)
		  	{
		  		 alert("Balance is not zero.");
		  		 return false;
		  	}
		   if(operationType=="DineIn" && transactionType=="Make KOT" )
			 {
			 
				    var tableName=gTableName;
					var yes=confirm("Do you want to generate bill for table : "+tableName);
					if(yes)
					{
						document.frmBillSettlement.action = "actionBillSettlementKOT.html";
						document.frmBillSettlement.method = "POST";
					    document.frmBillSettlement.submit();
					}
					else
					{
						 return false;
					}		 		   
			 }
			 else if(operationType=="DineIn" && transactionType=="Make Bill" )
			 {
				 
				    var tableName=gTableName;
					var yes=confirm("Do you want to generate bill for table : "+tableName);
					if(yes)
					{
						document.frmBillSettlement.action = "actionBillSettlementKOT.html";
						document.frmBillSettlement.method = "POST";
					    document.frmBillSettlement.submit();
					}
					else
					{
						 return false;
					}		 		   
			 } 
				 
			 else  if(operationType=="HomeDelivery" && transactionType=="Direct Biller")
			 {
				 
                 $("#hidIsSettleBill").val("N");				 
                 document.frmBillSettlement.action = "actionBillSettlement.html";
		    	 document.frmBillSettlement.method = "POST";
				 document.frmBillSettlement.submit();
		     }
			 else  if(operationType=="TakeAway" && transactionType=="Direct Biller")
			 {
				 
                 $("#hidIsSettleBill").val("N");				 
		    	 document.frmBillSettlement.action = "actionBillSettlement.html";
		    	 document.frmBillSettlement.method = "POST";
				 document.frmBillSettlement.submit();
		     }
			 else  if(transactionType=="Modify Bill")
			 {
				 
				 
		    	 document.frmBillSettlement.action = "actionModifyBill.html";
		    	 document.frmBillSettlement.method = "POST";
				 document.frmBillSettlement.submit();
		     }
			 else if(operationType=="DineIn" && transactionType=="Bill For Items")
			 {				 
					var yes=confirm("Do you want to generate bill for items?");
					if(yes)
					{
						
						 
						 
						document.frmBillSettlement.action = "actionForBillForItems.html";
						
					    document.frmBillSettlement.submit();
					}
					else
					{
						 return false;
					}		 		   
			 }
			 else if((operationType=="DineIn" || operationType=="HomeDelivery" || operationType=="TakeAway" ) && transactionType=="Settle Bill" )
			 {
			 
				 	var billNo=$("#hidBillNo").val();
				 	
					var yes=confirm("Do you want to settle bill : "+billNo);
					if(yes)
					{
						document.frmBillSettlement.action = "actionBillSettle.html";
						document.frmBillSettlement.method = "POST";
					    document.frmBillSettlement.submit();
					}
					else
					{
						 return false;
					}		 		   
			 }
			 
	    }
	  
	  
	  
	  function funClickedSettleBtnForDirectBiller()
	  {

             $("#hidIsSettleBill").val("Y");				 

	    	 document.frmBillSettlement.action = "actionBillSettlement.html";
	    	 document.frmBillSettlement.method = "POST";
			 document.frmBillSettlement.submit();

	  }
	  /*  TEst  */
	  
	  /**
	 * Success Message After Saving Record
	 **/
	$(document)
			.ready(
					function() {
						var message = '';
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
					%>alert("Data Saved \n\n"+message);
					
					<%
				}
			}%>
		});
	  
	  
	  
	  
	  
	$("#btnOKReason").click(function()
	{
		
		funDiscOkClicked();
	});

	  
	  
// 	///Click on OK Button of Discount
function funDiscOkForReason()
{
	    if($('#txtDiscountPer').val()>0)	
		{
		$('#myModalReason').modal('show');
	    var strReason=$("#cmbReason").val();
		}
	
}
function funDiscOkClicked()
{ 
	
	

	// var rematk=promptDialog("Enter Remark","");
	 //var reason=  promptComboDialog("Select Reason","");
	 var strRemark =prompt("Enter Remark", "");
				
    var strReason=$("#cmbReason").val();
	 
	 
	var discOnType="Total";
	var discOnValue="Total";
  	var discGroup=disountType;
	var totamt = 0.00;
	var listOfDiscApplicableItems=[];

		 //Totlal Radio button is Selected
		  if(discGroup=='Total')
	      {
			  discOnType="Total";
			  discOnValue="Total";

			  $.each(listBillItem,function(i,obj)
			  { 
				
	        	    var singleObj = {}
	        	    
	        	    singleObj['itemCode'] = obj.itemCode;
	        	    singleObj['itemName'] = obj.itemName;
	        	    singleObj['quantity'] = obj.quantity;
	        	    singleObj['amount'] = obj.amount;
	        	    singleObj['discountPer'] = obj.discountPer;
	        	    singleObj['discountAmt'] = obj.discountAmt;
	        	    
	        	    
	        	    listOfDiscApplicableItems.push(singleObj);
				        	
			   })
	      }
		//Item  is Selected
		  if(discGroup=='item')
		  {
			  discOnType="Item";			  			  
			  
 			   $.each(listBillItem,function(i,obj)
		        { 
			
			      if($('#cmbItemCategary').val()==obj.itemCode)
			      {
			    	  
			      
			    	discOnValue= obj.itemName;
			    	  
	        	    var singleObj = {}
	        	    
	        	    singleObj['itemCode'] = obj.itemCode;
	        	    singleObj['itemName'] = obj.itemName;
	        	    singleObj['quantity'] = obj.quantity;
	        	    singleObj['amount'] = obj.amount;
	        	    singleObj['discountPer'] = obj.discountPer;
	        	    singleObj['discountAmt'] = obj.discountAmt;
	        	    
	        	    listOfDiscApplicableItems.push(singleObj);
			      }
		       })
		  }
		
		//Group is Selected
		
		  if(discGroup=='group')
		  {  

			  discOnType="Group";		
			  			  
			  
			  var groupcode=$('#cmbItemCategary option:selected').val();
			  var groupName=$('#cmbItemCategary option:selected').text();
			  
			  
			  $.each(listBillItem, function(i, obj) 
			  {
				  if(groupcode==obj.strGroupcode)
				  {
			       	    
					  discOnValue=groupName;
					  
					  var singleObj = {}
			       	    
			       	 singleObj['itemCode'] = obj.itemCode;
			       	    singleObj['itemName'] = obj.itemName;
			       	    singleObj['quantity'] = obj.quantity;
			       	    singleObj['amount'] = obj.amount;
			       	    singleObj['discountPer'] = obj.discountPer;
			       	    singleObj['discountAmt'] = obj.discountAmt;
			       	    
			       	    listOfDiscApplicableItems.push(singleObj);
				  } 
		      })
		  }
		
// 		//SubGroup is Selected
			
		  if(discGroup=='subGroup')
		  {
			  discOnType="SubGroup";		
			  
			  
			  
			  var subgroupcode=$('#cmbItemCategary  option:selected').val();
			  var subGroupName=$('#cmbItemCategary  option:selected').text();
			  
			  
			  $.each(listBillItem, function(i, obj) 
			  {
			      if(subgroupcode==obj.strSubGroupCode)
			      {
	        	   
			    	  discOnValue=subGroupName;
			    	  
			    	  var singleObj = {}
	        	    
	        	    singleObj['itemCode'] = obj.itemCode;
	        	    singleObj['itemName'] = obj.itemName;
	        	    singleObj['quantity'] = obj.quantity;
	        	    singleObj['amount'] = obj.amount;
	        	    singleObj['discountPer'] = obj.discountPer;
	        	    singleObj['discountAmt'] = obj.discountAmt;
	        	    
	        	    listOfDiscApplicableItems.push(singleObj);
	        	    
			      }
		       })
		  }
	
		  var perDisc=$('#txtDiscountPer').val();
		  
		  var amtDisc= $('#txtDiscountAmt').val();
		  

		  
		  var checkTaxTotal=0;
		  var dblTaxTotal=0;
		  
		  totalDiscAmt=0;
		  
		  var dblDiscountOnAmt= getTotalAmt(listOfDiscApplicableItems) ;
		  
		  if(amtDisc>0)
		  {
			  //perDisc=(amtDisc/dblDiscountOnAmt)*100;
			  
			 $('#txtDiscountPer').val(perDisc);
		  }
		  
		  
		  
		  
		  $.each(listOfDiscApplicableItems, function(i, obj) 
		  {
			 
				 var discPer=perDisc;
				 var discAmt = obj.amount * (perDisc / 100);
				 
				 totalDiscAmt=totalDiscAmt+discAmt;
				 
				 	             
			     var singleObj = {}
			     
			     singleObj['itemCode'] = obj.itemCode;
		   	     singleObj['itemName'] = obj.itemName;
		   	     singleObj['quantity'] = obj.quantity;
		   	     singleObj['amount'] = obj.amount;
		   	     singleObj['discountPer'] = discPer;
		   	     singleObj['discountAmt'] = discAmt;
		   	 	
		   	     listOfDicountItem.push(singleObj);
			 
 		  });
		  
		//  $("#txtDiscountAmt").val(totalDiscAmt);
		  
		 	 
		  var listItmeDtl=[];	   
		  
		  hmItempMap=new Map();	
			 
			 $.each(listBillItem,function(i,obj)
			 { 

	        	    hmItempMap.set(obj.itemCode,obj.itemName);
	        	    
	        	    var discAmt=0,discPer=0;
	        	    
	        	    $.each(listOfDicountItem,function(i,objDiscItem)
	        		{
	        	    	if(obj.itemCode==objDiscItem.itemCode)
	        	    	{
	        	    		discAmt=objDiscItem.discountAmt;
	        	    		discPer=objDiscItem.discountPer;
	        	    	}
	        		})
					
	        	    var singleObj = {}
	        	    
				    singleObj['itemName'] =obj.itemName;
				    singleObj['quantity'] =obj.quantity; 
				    singleObj['amount'] = obj.amount;
				    singleObj['discountPer'] = discPer;
	        	    singleObj['discountAmt'] = discAmt;				    
				    singleObj['itemCode'] = obj.itemCode;
				    singleObj['rate'] =obj.dblRate;
				    singleObj['strSubGroupCode'] =obj.strSubGroupCode;
				    singleObj['strGroupcode'] =obj.strGroupcode;
				    singleObj['dblCompQty'] ='0';

				    
				    
				    listItmeDtl.push(singleObj);
				        	
			 })		  
			 
		 var totalamount=getTotalAmt(listBillItem) ;
			 
			var oTable = document.getElementById('tblSettleItemTable');
			var rowLength = oTable.rows.length;
			
			var $rows = $('#tblSettleItemTable').empty();
			listBillItem=[];
			

			
			finalSubTotal=0.00;
			finalDiscountAmt=0.00;
			finalNetTotal=0.00;
			taxTotal=0.00;
			taxAmt=0.00;
			finalGrandTotal=0.00;	
	
			 
		
			 
		/**
		*calculating promotions and filling data to grid for bill print	
		*/
		funNoPromtionCalculation(listItmeDtl);
	
		    
		funRefreshSettlementItemGrid();	
			
			
			
			
			
			
			


        var tblFillDisountList=document.getElementById('tblFillDisountList');
		var rowCount = tblFillDisountList.rows.length;
		var insertRow = tblFillDisountList.insertRow(rowCount);
			
	    var col1=insertRow.insertCell(0);
	    var col2=insertRow.insertCell(1);
	    var col3=insertRow.insertCell(2);
	    var col4=insertRow.insertCell(3);
	    var col5=insertRow.insertCell(4);
	    var col6=insertRow.insertCell(5);
	    var col7=insertRow.insertCell(6);
	    
		  var per= $("#txtDiscountPer").val();
		  var amt=totalDiscAmt;

	  
	    col1.innerHTML = "<input type=\"hidden\"  name=\"listDiscountDtlOnBill["+(disCount)+"].discountPer\" id=\"discountPer."+(disCount)+"\" value='"+per+"' />" ;;
 	    col2.innerHTML =  "<input type=\"hidden\"  name=\"listDiscountDtlOnBill["+(disCount)+"].discountAmt\" id=\"discountAmt."+(disCount)+"\" value='"+amt+"' />";
 	    col3.innerHTML =  "<input type=\"hidden\"  name=\"listDiscountDtlOnBill["+(disCount)+"].discountOnAmt\" id=\"discountOnAmt."+(disCount)+"\" value='"+dblDiscountOnAmt+"' />";
 	    col4.innerHTML = "<input type=\"hidden\"  name=\"listDiscountDtlOnBill["+(disCount)+"].discountOnType\" id=\"discountOnType."+(disCount)+"\" value='"+discOnType+"' />";
	    col5.innerHTML = "<input type=\"hidden\"  name=\"listDiscountDtlOnBill["+(disCount)+"].discountOnValue\" id=\"discountOnValue."+(disCount)+"\" value='"+discOnValue+"' />";
 	    col6.innerHTML = "<input type=\"hidden\"  name=\"listDiscountDtlOnBill["+(disCount)+"].discountReasonCode\" id=\"discountReasonCode."+(disCount)+"\" value='"+strReason+"' />";	    
 	    col7.innerHTML =  "<input type=\"hidden\"  name=\"listDiscountDtlOnBill["+(disCount)+"].discountRemarks\" id=\"discountRemarks."+(disCount)+"\" value='"+strRemark+"' />";
 	    
     		
 	    disCount++;
     		
			
 	  }
	  
	 function  getTotalAmt(listOfDiscApplicableItems) 
	 {
	        var totalDiscOnAmt = 0.00;
	        $.each(listOfDiscApplicableItems, function(i, obj) 
		  {	
	            totalDiscOnAmt += parseFloat(obj.amount);
	        });
	        return totalDiscOnAmt;
	 }
	 
	 
	 function funDiscPerFocusOut(objThis)
	 {
		if(objThis.value<=0)
		{
			objThis.value="0.00"; 
		}
		
	 }
	 
	 function funDiscAmtFocusOut(objThis)
	 {
		if(objThis.value<=0)
		{
			objThis.value="0.00"; 
		}
		
	 }

	 
	 function funTaxOnDisc()
	 {
		 var listOfItemwithDisc=[];
			var oTable = document.getElementById('tblSettleItemTable');
			var rowLength = oTable.rows.length;
			for (var i = 0; i < listBillItem.length; i++)
			{
				var singleObj = {};
			
			    singleObj['itemName'] =oTable.rows[i].cells[0].children[0].value;
			    singleObj['quantity'] =oTable.rows[i].cells[1].children[0].value;
			    singleObj['amount'] = oTable.rows[i].cells[2].children[0].value;
			    /* singleObj['discountPer'] = oTable.rows[i].cells[3].children[0].value;
			    singleObj['discountAmt'] =oTable.rows[i].cells[4].children[0].value; */
			    var oCells = oTable.rows.item(i).cells[8].innerHTML;	
				var btnBackground=oCells.split('value=');
			    
				singleObj['itemCode']=btnBackground[1].substring(1, (btnBackground[1].length-2));
			    listOfItemwithDisc.push(singleObj);
			}
			funCalculateTaxOndiscount(listOfItemwithDisc);
	 
	 }
		function funCalculateTaxOndiscount(listBillItem)
		{
			
			var taxTotal=0;
			var rowCountTax=0;
			var searchurl=getContextPath()+"/funCalculateTaxInSettlement.html?operationTypeForTax="+operationType;
			$.ajax({
				 type: "POST",
			        url: searchurl,
			        data : JSON.stringify(listBillItem),
			        contentType: 'application/json',
			        async: false,
		        success: function (response){
		        	    	$.each(response,function(i,item){
				        		taxTotal=taxTotal+response[i].taxAmount;
				        		funFillTaxTable(response[i].taxName,response[i].taxAmount,response[i].taxCode,response[i].taxCalculationType,response[i].taxableAmount ,rowCountTax);
				        		rowCountTax++;
				        	});
	             
		        	    	finalGrandTotal=finalGrandTotal+taxTotal;
		        	    	 $('#hidTaxTotal').val(taxTotal);
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
			return taxTotal;
		}
		
		
		function funFillTaxTable(taxName,taxAmount,taxCode,taxCalculationType,taxableAmount,rowCountTax){
			
			
			 document.getElementById("taxName."+rowCountTax).value=taxName;
			 document.getElementById("taxAmount."+rowCountTax).value=taxName;
			 document.getElementById("taxCode."+rowCountTax).value=taxName;
			 document.getElementById("taxableAmount."+rowCountTax).value=taxName;
			 document.getElementById("taxCalculationType."+rowCountTax).value=taxName;

		}
		
		
	 function funModalOperation(objModal)
		{
			/* var tblmodalDataTable=document.getElementById('tblmodalDataTable');
			var rowCount = tblmodalDataTable.rows.length; */
			var modal = document.getElementById('mySecModal');
			/* var span = document.getElementsByClassName("close")[0]; */
			modal.style.display = "block";
			
			/* span.onclick = function() {
				  modal.style.display = "none";
				  funResetBlankTable(tblmodalDataTable);
				}
			
			window.onclick = function(event) {
				  if (event.target == modal) {
				    modal.style.display = "none";
				  }
				} */
		}
		 
		function funModalOperate(objModal)
		{
			var modal2 = document.getElementById('mySecModal');
			var span = document.getElementsByClassName("close")[0];
			modal2.style.display = "block";
			
			
			span.onclick = function() {
				  modal2.style.display = "none";
			}
			
			/* var url="D:\\setup\\eclipse\\Bill\\Bill_P0109204__2019-01-13_SANGUINE.pdf";
			$(".modal-body").html('<iframe width="100%" height="100%" frameborder="0" scrolling="no" allowtransparency="true" src="'+url+'"></iframe>'); */
			
		}
		function funOpenBillItemButtonClicked()
		{
		    $('#myModalShowBillItems').modal('show');
	
		}
		

	
 </script>
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
</head>
<body>

<%-- <script src="../${pageContext.request.contextPath}/resources/newdesign/assets/js/preloader.js"></script>  --%>
  <s:form  name="frmBillSettlement"  method="GET"   action="" style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:100%;min-width:25%;margin-left: 2%; height: 700px;" >
  
  <div class="body-wrapper" style="margin-top: -15px;">
    <!-- partial:partials/_sidebar.html -->
    <%-- <aside class="mdc-drawer mdc-drawer--dismissible mdc-drawer--open">
      
      <div class="mdc-drawer__content">
        <div class="user-info">
          <p class="name">Sumeet1</p>
          <p class="email">sumeet@zbot.com</p>
        </div>
        <div class="mdc-list-group">
          <nav class="mdc-list mdc-drawer-menu">
            <div class="mdc-list-item mdc-drawer-item">
              <a class="mdc-drawer-link" href="index.html">
                <i class="material-icons mdc-list-item__start-detail mdc-drawer-item-icon" aria-hidden="true">home</i>
                Dashboard
              </a>
            </div>
            <div class="mdc-list-item mdc-drawer-item">
              <a class="mdc-drawer-link" href="pages/forms/basic-forms.html">
                <i class="material-icons mdc-list-item__start-detail mdc-drawer-item-icon" aria-hidden="true">track_changes</i>
                Forms
              </a>
            </div>
            <div class="mdc-list-item mdc-drawer-item">
              <a class="mdc-expansion-panel-link" href="#" data-toggle="expansionPanel" data-target="ui-sub-menu">
                <i class="material-icons mdc-list-item__start-detail mdc-drawer-item-icon" aria-hidden="true">dashboard</i>
                UI Features
                <i class="mdc-drawer-arrow material-icons">chevron_right</i>
              </a>
              <div class="mdc-expansion-panel" id="ui-sub-menu">
                <nav class="mdc-list mdc-drawer-submenu">
                  <div class="mdc-list-item mdc-drawer-item">
                    <a class="mdc-drawer-link" href="pages/ui-features/buttons.html">
                      Buttons
                    </a>
                  </div>
                  <div class="mdc-list-item mdc-drawer-item">
                    <a class="mdc-drawer-link" href="pages/ui-features/typography.html">
                      Typography
                    </a>
                  </div>
                </nav>
              </div>
            </div>
            <div class="mdc-list-item mdc-drawer-item">
              <a class="mdc-drawer-link" href="pages/tables/basic-tables.html">
                <i class="material-icons mdc-list-item__start-detail mdc-drawer-item-icon" aria-hidden="true">grid_on</i>
                Tables
              </a>
            </div>
            <div class="mdc-list-item mdc-drawer-item">
              <a class="mdc-drawer-link" href="pages/charts/chartjs.html">
                <i class="material-icons mdc-list-item__start-detail mdc-drawer-item-icon" aria-hidden="true">pie_chart_outlined</i>
                Charts
              </a>
            </div>
            <div class="mdc-list-item mdc-drawer-item">
              <a class="mdc-expansion-panel-link" href="#" data-toggle="expansionPanel" data-target="sample-page-submenu">
                <i class="material-icons mdc-list-item__start-detail mdc-drawer-item-icon" aria-hidden="true">pages</i>
                Sample Pages
                <i class="mdc-drawer-arrow material-icons">chevron_right</i>
              </a>
              <div class="mdc-expansion-panel" id="sample-page-submenu">
                <nav class="mdc-list mdc-drawer-submenu">
                  <div class="mdc-list-item mdc-drawer-item">
                    <a class="mdc-drawer-link" href="pages/samples/blank-page.html">
                      Blank Page
                    </a>
                  </div>
                  <div class="mdc-list-item mdc-drawer-item">
                    <a class="mdc-drawer-link" href="pages/samples/403.html">
                      403
                    </a>
                  </div>
                  <div class="mdc-list-item mdc-drawer-item">
                    <a class="mdc-drawer-link" href="pages/samples/404.html">
                      404
                    </a>
                  </div>
                  <div class="mdc-list-item mdc-drawer-item">
                    <a class="mdc-drawer-link" href="pages/samples/500.html">
                      500
                    </a>
                  </div>
                  <div class="mdc-list-item mdc-drawer-item">
                    <a class="mdc-drawer-link" href="pages/samples/505.html">
                      505
                    </a>
                  </div>
                  <div class="mdc-list-item mdc-drawer-item">
                    <a class="mdc-drawer-link" href="pages/samples/login.html">
                      Login
                    </a>
                  </div>
                  <div class="mdc-list-item mdc-drawer-item">
                    <a class="mdc-drawer-link" href="pages/samples/register.html">
                      Register
                    </a>
                  </div>
                </nav>
              </div>
            </div>
            <div class="mdc-list-item mdc-drawer-item">
              <a class="mdc-drawer-link" href="https://www.bootstrapdash.com/demo/material-admin-free/jquery/documentation/documentation.html" target="_blank">
                <i class="material-icons mdc-list-item__start-detail mdc-drawer-item-icon" aria-hidden="true">description</i>
                Documentation
              </a>
            </div>
          </nav>
        </div>
        <div class="profile-actions">
          <a href="javascript:;">Settings</a>
          <span class="divider"></span>
          <a href="javascript:;">Logout</a>
        </div>
        <!--div class="mdc-card premium-card">
          <div class="d-flex align-items-center">
            <div class="mdc-card icon-card box-shadow-0">
              <i class="mdi mdi-shield-outline"></i>
            </div>
            <div>
              <p class="mt-0 mb-1 ml-2 font-weight-bold tx-12">Material Dash</p>
              <p class="mt-0 mb-0 ml-2 tx-10">Pro available</p>
            </div>
          </div>
          <p class="tx-8 mt-3 mb-1">More elements. More Pages.</p>
          <p class="tx-8 mb-3">Starting from $25.</p>
          <a href="https://www.bootstrapdash.com/product/material-design-admin-template/" target="_blank">
						<span class="mdc-button mdc-button--raised mdc-button--white">Upgrade to Pro</span>
					</a>
        </div-->
      </div>
    </aside> --%>
    <!-- partial -->
    <div class="main-wrapper mdc-drawer-app-content">
      <!-- partial:partials/_navbar.html -->
      <header class="mdc-top-app-bar">
        <div class="mdc-top-app-bar__row">
          <div class="mdc-top-app-bar__section mdc-top-app-bar__section--align-start" style="margin-top: 30px;">
            <button class="material-icons mdc-top-app-bar__navigation-icon mdc-icon-button sidebar-toggler">menu</button>
            <span class="mdc-top-app-bar__title"><img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/sanguinelogo.jpg"></span>
            <div class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon search-text-field d-none d-md-flex">
              <i class="material-icons mdc-text-field__icon">search</i>
              <input class="mdc-text-field__input" id="text-field-hero-input">
              <div class="mdc-notched-outline">
                <div class="mdc-notched-outline__leading"></div>
                <div class="mdc-notched-outline__notch">
                  <label for="text-field-hero-input" class="mdc-floating-label">Search..</label>
                </div>
                <div class="mdc-notched-outline__trailing"></div>
              </div>
            </div>
          </div>
          <div class="mdc-top-app-bar__section mdc-top-app-bar__section--align-end mdc-top-app-bar__section-right">
            <div class="menu-button-container menu-profile d-none d-md-block">
              <button class="mdc-button mdc-menu-button">
                <span class="d-flex align-items-center">
                  <span class="figure">
                    <img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/faces/face1.jpg" alt="user" class="user">
                  </span>
                  <span class="user-name">Sumit1</span>
                </span>
              </button>
              <div class="mdc-menu mdc-menu-surface" tabindex="-1">
                <ul class="mdc-list" role="menu" aria-hidden="true" aria-orientation="vertical">
                  <li class="mdc-list-item" role="menuitem">
                    <div class="item-thumbnail item-thumbnail-icon-only">
                      <i class="mdi mdi-account-edit-outline text-primary"></i>
                    </div>
                    <div class="item-content d-flex align-items-start flex-column justify-content-center">
                      <h6 class="item-subject font-weight-normal">Edit profile</h6>
                    </div>
                  </li>
                  <li class="mdc-list-item" role="menuitem">
                    <div class="item-thumbnail item-thumbnail-icon-only">
                      <i class="mdi mdi-settings-outline text-primary"></i>                      
                    </div>
                    <div class="item-content d-flex align-items-start flex-column justify-content-center">
                      <h6 class="item-subject font-weight-normal">Logout</h6>
                    </div>
                  </li>
                </ul>
              </div>
            </div>
            <div class="divider d-none d-md-block"></div>
            
            <div class="menu-button-container">
			
              <button class="mdc-button mdc-menu-button">
                <i class="mdi mdi-home"></i>
               
              </button>
              <div class="mdc-menu mdc-menu-surface" tabindex="-1">
                <h6 class="title"><i class="mdi mdi-email-outline mr-2 tx-16"></i> Messages</h6>
                <ul class="mdc-list" role="menu" aria-hidden="true" aria-orientation="vertical">
                  <li class="mdc-list-item" role="menuitem">
                    <div class="item-thumbnail">
                      <img src="../assets/images/faces/face4.jpg" alt="user">
                    </div>
                    <div class="item-content d-flex align-items-start flex-column justify-content-center">
                      <h6 class="item-subject font-weight-normal">Mark send you a message</h6>
                      <small class="text-muted"> 1 Minutes ago </small>
                    </div>
                  </li>
                  <li class="mdc-list-item" role="menuitem">
                    <div class="item-thumbnail">
                      <img src="../assets/images/faces/face2.jpg" alt="user">
                    </div>
                    <div class="item-content d-flex align-items-start flex-column justify-content-center">
                      <h6 class="item-subject font-weight-normal">Cregh send you a message</h6>
                      <small class="text-muted"> 15 Minutes ago </small>
                    </div>
                  </li>
                  <li class="mdc-list-item" role="menuitem">
                    <div class="item-thumbnail">
                      <img src="../assets/images/faces/face3.jpg" alt="user">
                    </div>
                    <div class="item-content d-flex align-items-start flex-column justify-content-center">
                      <h6 class="item-subject font-weight-normal">Profile picture updated</h6>
                      <small class="text-muted"> 18 Minutes ago </small>
                    </div>
                  </li>                
                </ul>
              </div>
            </div>
            <div class="menu-button-container">
			
              <button class="mdc-button mdc-menu-button">
                <i class="mdi mdi-bell"></i>
                <span class="count-indicator">
                  <span class="count">3</span>
                </span>
              </button>
              <div class="mdc-menu mdc-menu-surface" tabindex="-1">
                <h6 class="title"><i class="mdi mdi-email-outline mr-2 tx-16"></i> Messages</h6>
                <ul class="mdc-list" role="menu" aria-hidden="true" aria-orientation="vertical">
                  <li class="mdc-list-item" role="menuitem">
                    <div class="item-thumbnail">
                      <img src="../assets/images/faces/face4.jpg" alt="user">
                    </div>
                    <div class="item-content d-flex align-items-start flex-column justify-content-center">
                      <h6 class="item-subject font-weight-normal">Mark send you a message</h6>
                      <small class="text-muted"> 1 Minutes ago </small>
                    </div>
                  </li>
                  <li class="mdc-list-item" role="menuitem">
                    <div class="item-thumbnail">
                      <img src="../assets/images/faces/face2.jpg" alt="user">
                    </div>
                    <div class="item-content d-flex align-items-start flex-column justify-content-center">
                      <h6 class="item-subject font-weight-normal">Cregh send you a message</h6>
                      <small class="text-muted"> 15 Minutes ago </small>
                    </div>
                  </li>
                  <li class="mdc-list-item" role="menuitem">
                    <div class="item-thumbnail">
                      <img src="../assets/images/faces/face3.jpg" alt="user">
                    </div>
                    <div class="item-content d-flex align-items-start flex-column justify-content-center">
                      <h6 class="item-subject font-weight-normal">Profile picture updated</h6>
                      <small class="text-muted"> 18 Minutes ago </small>
                    </div>
                  </li>                
                </ul>
              </div>
            </div>
            <div class="menu-button-container d-none d-md-block">
              <button class="mdc-button mdc-menu-button">
                <i class="mdi mdi-arrow-down-bold-box"></i>
              </button>
              <div class="mdc-menu mdc-menu-surface" tabindex="-1">
                <ul class="mdc-list" role="menu" aria-hidden="true" aria-orientation="vertical">
                  <li class="mdc-list-item" role="menuitem">
                    <div class="item-thumbnail item-thumbnail-icon-only">
                      <i class="mdi mdi-lock-outline text-primary"></i>
                    </div>
                    <div class="item-content d-flex align-items-start flex-column justify-content-center">
                      <h6 class="item-subject font-weight-normal">Lock screen</h6>
                    </div>
                  </li>
                  <li class="mdc-list-item" role="menuitem">
                    <div class="item-thumbnail item-thumbnail-icon-only">
                      <i class="mdi mdi-logout-variant text-primary"></i>                      
                    </div>
                    <div class="item-content d-flex align-items-start flex-column justify-content-center">
                      <h6 class="item-subject font-weight-normal">Logout</h6>
                    </div>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </header>
      <!-- partial -->
      <div class="page-wrapper mdc-toolbar-fixed-adjust">
        <main class="content-wrapper">
		<table width="100%" border="0">
			<tr width="100%">
			<td width="25%">
			
			<div id="divOrder" >
				<table width="97%" class="mdc-card info-card">
						<tbody><tr>
							<td width="50%">
								<h5 id="billNoForDisplay" class="tablehead" nowrap="">Bill No: ${billNo}</h5> 
							</td>
							
							<td width="50%">
								<h5 id="tableNameForDisplay" class="tablehead" nowrap="">Table No: ${gTableName}</h5>
							</td>
							
						</tr>
					</tbody></table>
				
				
				<table id="tblSettleItemTableHead" style="width: 100%; height:40px; border-collapse: collapse;overflow: auto;
										font-size: 10px;font-weight: bold;">
						<tbody><tr>
							<td width="86.5%">
								<h5 class="tablehead" nowrap="">Description</h5> 
							</td>
							
							<td width="50%">
								<h5 class="tablehead" nowrap="">Qty</h5>
							</td>
							
							<td width="50%">
								<h5 class="tablehead" nowrap align="right">Amount</h5>
							</td>
							
						</tr>
					</tbody></table>
					
						<table id="tblSettleItemTable" style=" height:400px;border-collapse: collapse;overflow: auto;
									font-size: 14px;">
						</table>
			</div>
					
			</td>
			<td width="100%">
			
			  <div id="divSettlement" >
				<div id="divSettlementButtons" style="text-align: right; height:50px; overflow-x: auto; overflow-y: auto; width: 100%;">
					 	<table id="tblSettlementButtons"  cellpadding="0" cellspacing="2"  >				 																																	
								<tr>							
									<c:forEach var="objSettleButtons" items="${command.jsonArrForSettleButtons}"  varStatus="varSettleButtons">
											<td style="padding-right: 3px;">
												<input  type="button" id="${objSettleButtons.strSettelmentDesc}"  value="${objSettleButtons.strSettelmentDesc}" tabindex="${varSettleButtons.getIndex()}"  style="width: 100px;height: 30px; white-space: normal;"   onclick="funSettleOptionSelected('${objSettleButtons.strSettelmentDesc}','${objSettleButtons.strSettelmentType}','${objSettleButtons.strSettelmentCode}','${objSettleButtons.dblConvertionRatio}','${objSettleButtons.strBillPrintOnSettlement}')" class="btn btn-outline-secondary"/>
											</td>
									</c:forEach>																						
							    </tr>																																				 									   				   									   									   						
						</table>			
			 	</div>
			 	</div> 
			 	
			<table width="100%" class="mdc-card info-card2">
					 	<%-- <tr>
							<td align="center">
								<table width="95%" class="mdc-card info-card4">
									<tr>
										<td align="center">
											<img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/cashicon.png" border="0"> 
										</td>
										
										
									</tr>
									<tr align="center">
										<td>
											<h5 class="tablehead" nowrap>Cash</h5> 
										</td>						
									</tr>
								</table>
							</td>
							<td align="center">
								<table width="95%" class="mdc-card info-card4">
									<tr>
										<td align="center">
											<img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/cashicon.png" border="0"> 
										</td>
										
										
									</tr>
									<tr align="center">
										<td>
											<h5 class="tablehead" nowrap>Cash</h5> 
										</td>						
									</tr>
								</table>
							</td>
							<td align="center">
								<table width="95%" class="mdc-card info-card4">
									<tr>
										<td align="center">
											<img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/cashicon.png" border="0"> 
										</td>
										
										
									</tr>
									<tr align="center">
										<td>
											<h5 class="tablehead" nowrap>Cash</h5> 
										</td>						
									</tr>
								</table>
							</td>
							<td align="center">
								<table width="95%" class="mdc-card info-card4">
									<tr>
										<td align="center">
											<img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/cashicon.png" border="0"> 
										</td>
										
										
									</tr>
									<tr align="center">
										<td>
											<h5 class="tablehead" nowrap>Cash</h5> 
										</td>						
									</tr>
								</table>
							</td>
							<td align="center">
								<table width="95%" class="mdc-card info-card4">
									<tr>
										<td align="center">
											<img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/cashicon.png" border="0"> 
										</td>
										
										
									</tr>
									<tr align="center">
										<td>
											<h5 class="tablehead" nowrap>Cash</h5> 
										</td>						
									</tr>
								</table>
							</td>
							<td align="center">
								<table width="95%" class="mdc-card info-card4">
									<tr>
										<td align="center">
											<img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/cashicon.png" border="0"> 
										</td>
										
										
									</tr>
									<tr align="center">
										<td>
											<h5 class="tablehead" nowrap>Cash</h5> 
										</td>						
									</tr>
								</table>
							</td>
						</tr>  --%>
						<tr>
							<td colspan="6" width="100%">
							<table width="100%" border="0">
								
								<!-- div for payment mode  -->
							 	<tr>
							 	<div id="divPaymentMode" class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon search-text-field d-none d-md-flex" >
							 		<label id="lblPayMentMode" style=" display: inline-block;width: 100%;text-align: left;">Payment Mode </label>
							 	</div>
							 	</tr>
								<tr>
									<td width="15%">
										<h5 class="tablehead" nowrap>Bill Amount</h5>
									</td>
									<td width="20%">
										<div class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon search-text-field d-none d-md-flex">
										  <input class="mdc-text-field__input" id="txtAmount">
											  <div class="mdc-notched-outline mdc-notched-outline--upgraded">
												<div class="mdc-notched-outline__leading"></div>
												<div class="mdc-notched-outline__notch" style="">
												  <label for="text-field-hero-input" style=""></label>
												</div>
												<div class="mdc-notched-outline__trailing"></div>
											  </div>
										</div>
									</td>
									<td width="2%">
										
									</td>
									
									<td width="22%">
										<h5 class="tablehead" nowrap></h5>
									</td>
									<td width="25%">
										<h5 class="tablehead" nowrap>Discount %</h5>
									</td>
									<td width="30%">
										<div class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon search-text-field d-none d-md-flex">
										  <input class="mdc-text-field__input" id="txtDiscountPer" name="dblDiscountPer" onfocusout="funDiscPerFocusOut(this)" value="0.00" onfocus="this.value=''">
											  <div class="mdc-notched-outline mdc-notched-outline--upgraded">
												<div class="mdc-notched-outline__leading"></div>
												<div class="mdc-notched-outline__notch" style="">
												  <label for="text-field-hero-input" style=""></label>
												</div>
												<div class="mdc-notched-outline__trailing"></div>
											  </div>
										</div>
									</td>
									<td width="2%">
										
									</td>
								</tr>
								<tr>
									<td width="15%">
										<h5 class="tablehead" nowrap>Paid Amount</h5>
									</td>
									<td width="20%">
										<div class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon search-text-field d-none d-md-flex">
										  <input class="mdc-text-field__input" id="txtPaidAmount">
											  <div class="mdc-notched-outline mdc-notched-outline--upgraded">
												<div class="mdc-notched-outline__leading"></div>
												<div class="mdc-notched-outline__notch" style="">
												  <label for="text-field-hero-input" style=""></label>
												</div>
												<div class="mdc-notched-outline__trailing"></div>
											  </div>
										</div>
									</td>
									<td width="2%">
										
									</td>
									
									<td width="22%">
										<h5 class="tablehead" nowrap></h5>
									</td>
									<td width="15%">
										<h5 class="tablehead" nowrap>Discount Amt</h5>
									</td>
									<td width="30%">
										<div class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon search-text-field d-none d-md-flex">
										  <input class="mdc-text-field__input" id="txtDiscountAmt" name="dblDiscountAmt" onfocusout="funDiscAmtFocusOut(this)" value="0.00" onfocus="this.value=''">
											  <div class="mdc-notched-outline mdc-notched-outline--upgraded">
												<div class="mdc-notched-outline__leading"></div>
												<div class="mdc-notched-outline__notch" style="">
												  <label for="text-field-hero-input" style=""></label>
												</div>
												<div class="mdc-notched-outline__trailing"></div>
											  </div>
										</div>
									</td>
									<td width="2%">
										<!-- <a href="javascript:void(0)" class="mdc-button mdc-button--raised mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
										  OK
										</a> -->
										<input type="button" id="btnDiscOk" value="OK" onclick="funDiscOkForReason(this)" class="mdc-button mdc-button--raised mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
									</td>
								</tr>
								<tr>
									<td width="15%">
										<h5 class="tablehead" nowrap>Balance</h5>
									</td>
									<td width="20%">
										<div class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon search-text-field d-none d-md-flex">
										  <input class="mdc-text-field__input" id="txtBalance">
											  <div class="mdc-notched-outline mdc-notched-outline--upgraded">
												<div class="mdc-notched-outline__leading"></div>
												<div class="mdc-notched-outline__notch" style="">
												  <label for="text-field-hero-input" style=""></label>
												</div>
												<div class="mdc-notched-outline__trailing"></div>
											  </div>
										</div>
									</td>
									
									<td width="67%" colspan="4" align="right">
										<table>
											<tr>
												<td><h5 class="tablehead" nowrap><input type="radio"  id="strDisountOn" name="strDisountOn" onclick="funSubGroupDiscClicked()" value="SubGroup">
										<label>Sub Group</label></h5>
												</td>
												<td>
										<h5 class="tablehead" nowrap><input type="radio" id="strDisountOn" name="strDisountOn" onclick="funGroupDiscClicked()" value="Group">
										<label>Item</label></h5>
												</td>
												<td>
										<h5 class="tablehead" nowrap><input type="radio" id="strDisountOn" name="strDisountOn" onclick="funItemDiscClicked()" value="Item">
										<label>Group</label></h5>
												</td>
												<td>
										<h5 class="tablehead" nowrap><input type="radio"  id="strDisountOn" name="strDisountOn" onclick="funTotalDiscClicked()" checked="checked" value="Total">
										<label>Total</label></h5>
												</td>
											</tr>
										</table>
										
									</td>

								</tr>
								<tr>
									<td width="15%">
										<h5 class="tablehead" nowrap>Card Balance</h5>
									</td>
									<td width="20%">
										<div class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon search-text-field d-none d-md-flex">
										  <!-- <input class="mdc-text-field__input" id="text-field-hero-input"> -->
										   <label id="lblCardBalance" class="mdc-text-field__input"></label>
											  <div class="mdc-notched-outline mdc-notched-outline--upgraded">
												<div class="mdc-notched-outline__leading"></div>
												<div class="mdc-notched-outline__notch" style="">
												  <label for="text-field-hero-input" style=""></label>
												</div>
												<div class="mdc-notched-outline__trailing"></div>
											  </div>
										</div>
									</td>
								
									<td width="67%" colspan="4" align="right">
										<table width="94%">
											<tr>
												<td><h5 class="tablehead" style="white-space:nowrap" align="right">Manual Bil No.</h5></td>
												<td width="20%">
														<div class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon search-text-field d-none d-md-flex">
														  <input class="mdc-text-field__input" id="txtManualBillNo">
															  <div class="mdc-notched-outline mdc-notched-outline--upgraded">
																<div class="mdc-notched-outline__leading"></div>
																<div class="mdc-notched-outline__notch" style="">
																  <label for="text-field-hero-input" style=""></label>
																</div>
																<div class="mdc-notched-outline__trailing"></div>
															  </div>
														</div>
												</td>
												<td><h5 class="tablehead" align="right" >Tip</h5></td>
												<td width="10%">
														<div class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon search-text-field d-none d-md-flex">
														  <input class="mdc-text-field__input" id="txtTip">
															  <div class="mdc-notched-outline mdc-notched-outline--upgraded">
																<div class="mdc-notched-outline__leading"></div>
																<div class="mdc-notched-outline__notch" style="">
																  <label for="text-field-hero-input" style=""></label>
																</div>
																<div class="mdc-notched-outline__trailing"></div>
															  </div>
														</div>
												</td>
												<td><h5 class="tablehead" style="white-space:nowrap" align="right">Del Charges</h5></td>
												<td width="10%">
													<div class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon search-text-field d-none d-md-flex">
														  <input class="mdc-text-field__input" id="txtDeliveryCharge" name="dblDeliveryCharges">
															  <div class="mdc-notched-outline mdc-notched-outline--upgraded">
																<div class="mdc-notched-outline__leading"></div>
																<div class="mdc-notched-outline__notch" style="">
																  <label for="text-field-hero-input" style=""></label>
																</div>
																<div class="mdc-notched-outline__trailing"></div>
															  </div>
														</div>
												</td>
											</tr>
										</table>
										
										
									</td>
									
									<td width="2%">
										<!-- <a href="javascript:void(0)" class="mdc-button mdc-button--raised mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
										  OK
										</a> -->
										<input type="button" id="btnApplyDeliveryCharge" value="OK" onclick="funbtnApplyDeliveryChargeClicked(this)" class="mdc-button mdc-button--raised mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
									</td>
								</tr>
								<tr>
									<td colspan="6" height="25">
									</td>
								</tr>
								<tr>
									<td width="15%">
										<h5 class="tablehead" nowrap>Voucher Name</h5>
									</td>
									<td width="20%">
										<div class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon search-text-field d-none d-md-flex">
										  <input class="mdc-text-field__input" id="txtVoucherSeries">
											  <div class="mdc-notched-outline mdc-notched-outline--upgraded">
												<div class="mdc-notched-outline__leading"></div>
												<div class="mdc-notched-outline__notch" style="">
												  <label for="text-field-hero-input" style=""></label>
												</div>
												<div class="mdc-notched-outline__trailing"></div>
											  </div>
										</div>
									</td>
									<td width="2%">
										
									</td>
									
									<td width="22%">
										<h5 class="tablehead" nowrap></h5>
									</td>
									<td width="15%">
										
									</td>
									<td width="30%">
										
									</td>
									<td width="2%">
										
									</td>
								</tr>
								<tr>
									<td width="15%">
										<h5 class="tablehead" nowrap>Cheque No.</h5>
									</td>
									<td width="20%">
										<div class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon search-text-field d-none d-md-flex">
										  <input class="mdc-text-field__input" id="txtSeriesNo">
											  <div class="mdc-notched-outline mdc-notched-outline--upgraded">
												<div class="mdc-notched-outline__leading"></div>
												<div class="mdc-notched-outline__notch" style="">
												  <label for="text-field-hero-input" style=""></label>
												</div>
												<div class="mdc-notched-outline__trailing"></div>
											  </div>
										</div>
									</td>
									<td width="2%">
										<!-- <a href="javascript:void(0)" class="mdc-button mdc-button--raised mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
										  OK
										</a> -->
										<input type="button" id="btnGiftVoucherOk" value="OK" onclick="funGiftVoucherOkClicked(this)" class="mdc-button mdc-button--raised mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
									</td>
									
									<td width="22%">
										<h5 class="tablehead" nowrap></h5>
									</td>
									<td width="15%">
										
									</td>
									<td width="30%">
										
									</td>
									<td width="2%">
										
									</td>
								</tr>								
							</td>
						</tr>						
					</table>
					
					<table width="100%" border="0">
						<td width="70%" valign="bottom">
							
							<table width="80%">
								<td>
								<a href="#" id="btnBack"  onclick="funBackButtonClicked(this)"><img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/backbt.png"></a>
								</td>
								<td>
								<a href="#" id="btnPrint"  onclick="return funSaveBtnClicked()"><img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/printbt.png"></a>
								</td>
								<td>
								<a href="#" id="btnSettle"  onclick="funClickedSettleBtnForDirectBiller()"><img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/settlebillbt.png"></a>
								</td>
								<td>
								<a href="#" id="btnOpenBillItems"  onclick="funOpenBillItemButtonClicked(this)"><img src="../${pageContext.request.contextPath}/resources/newdesign/assets/images/showbillbt.png"></a>
								</td>
							</table>
						
						</td>
						<td width="30%">
							<table width="100%">
								<tr>
										<td width="2%">
											<!-- <a href="javascript:void(0)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
											  7
											</a> -->
											<input type="button" id="btn7" value="7" onclick="funNumpadButtonClicked(this)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
										</td>
										<td width="2%">
											<!-- <a href="javascript:void(0)" class="mdc-buttongrey  mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
											  8
											</a> -->
											<input type="button" id="btn8" value="8" onclick="funNumpadButtonClicked(this)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
										</td>
										<td width="2%">
											<!-- <a href="javascript:void(0)" class="mdc-buttongrey  mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
											  9
											</a> -->
											<input type="button" id="btn9" value="9" onclick="funNumpadButtonClicked(this)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
										</td>
										<td width="2%">
											<!-- <a href="javascript:void(0)" class="mdc-buttongrey  mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
											  C
											</a> -->
											<input type="button" id="btnc" value="c" onclick="funNumpadButtonClicked(this)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
										</td>
										<td width="2%">
											<!-- <a href="javascript:void(0)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
											  10
											</a> -->
											<input type="button" id="btn10" value="10" onclick="funNumpadButtonClicked(this)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
										</td>
								</tr>
								<tr>
										<td width="2%">
											<!-- <a href="javascript:void(0)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
											  4
											</a> -->
											<input type="button" id="btn4" value="4" onclick="funNumpadButtonClicked(this)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
										</td>
										<td width="2%">
											<!-- <a href="javascript:void(0)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
											  5
											</a> -->
											<input type="button" id="btn5" value="5" onclick="funNumpadButtonClicked(this)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
										</td>
										<td width="2%">
											<!-- <a href="javascript:void(0)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
											  6
											</a> -->
											<input type="button" id="btn6" value="6" onclick="funNumpadButtonClicked(this)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
										</td>
										<td width="2%">
											<!-- <a href="javascript:void(0)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
											  0
											</a> -->
											<input type="button" id="btn0" value="0" onclick="funNumpadButtonClicked(this)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
										</td>
										<td width="2%">
											<!-- <a href="javascript:void(0)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
											  20
											</a> -->
											<input type="button" id="btn20" value="20" onclick="funNumpadButtonClicked(this)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
										</td>
								</tr>
								<tr>
										<td width="2%">
											<!-- <a href="javascript:void(0)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
											  1
											</a> -->
											<input type="button" id="btn1" value="1" onclick="funNumpadButtonClicked(this)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
										</td>
										<td width="2%">
											<!-- <a href="javascript:void(0)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
											  2
											</a> -->
											<input type="button" id="btn2" value="2" onclick="funNumpadButtonClicked(this)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
										</td>
										<td width="2%">
											<!-- <a href="javascript:void(0)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
											  3
											</a> -->
											<input type="button" id="btn3" value="3" onclick="funNumpadButtonClicked(this)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
										</td>
										<td width="2%">
											<!-- <a href="javascript:void(0)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
											  00
											</a> -->
											<input type="button" id="btn00" value="00" onclick="funNumpadButtonClicked(this)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
										</td>
										<td width="2%">
											<!-- <a href="javascript:void(0)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
											  100
											</a> -->
											<input type="button" id="btn100" value="100" onclick="funNumpadButtonClicked(this)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
										</td>
								</tr>
								<tr>
										<td width="2%">
											<!-- <a href="javascript:void(0)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
											  . 	
											</a> -->
											<input type="button" id="btnDot" value="." onclick="funNumpadButtonClicked(this)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
										</td>
										<td width="2%">
											<!-- <a href="javascript:void(0)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
											  x
											</a>
											<input type="button" id="btnBackSpace" value="X" onclick="funNumpadButtonClicked(this)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
-->										</td>
										<td width="4%" colspan="2">
											<!-- <a href="javascript:void(0)" class="mdc-button2 mdc-button--raised mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
											  e n t e r
											</a> -->
											<input type="button" id="btnEnter" value="Enter" onclick="funNumpadButtonClicked(this)" class="mdc-button2 mdc-button--raised mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
										</td>
										
										<td width="2%">
											<!-- <a href="javascript:void(0)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
											  500
											</a> -->
											<input type="button" id="btn500" value="500" onclick="funNumpadButtonClicked(this)" class="mdc-buttongrey mdc-ripple-upgraded" style="--mdc-ripple-fg-size:38px; --mdc-ripple-fg-scale:2.19553; --mdc-ripple-fg-translate-start:4.28125px, 4px; --mdc-ripple-fg-translate-end:13px, -1px;">
										</td>
								</tr>
							</table>
						</td>
					</table>
					
			   </td>
			</tr>
			
		</table>
	</main>
        
      </div>
    </div>
  </div>
  <%-- <!-- plugins:js -->
  <script src="../${pageContext.request.contextPath}/resources/newdesign/assets/vendors/js/vendor.bundle.base.js"></script>
  <!-- endinject -->
  <!-- Plugin js for this page-->
  <script src="../${pageContext.request.contextPath}/resources/newdesign/assets/vendors/chartjs/Chart.min.js"></script>
  <script src="../${pageContext.request.contextPath}/resources/newdesign/assets/vendors/jvectormap/jquery-jvectormap.min.js"></script>
  <script src="../${pageContext.request.contextPath}/resources/newdesign/assets/vendors/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
  <!-- End plugin js for this page-->
  <!-- inject:js -->
  <script src="../${pageContext.request.contextPath}/resources/newdesign/assets/js/material.js"></script>
  <script src="../${pageContext.request.contextPath}/resources/newdesign/assets/js/misc.js"></script>
  <!-- endinject -->
  <!-- Custom js for this page-->
  <script src="../${pageContext.request.contextPath}/resources/newdesign/assets/js/dashboard.js"></script>
  <!-- End custom js for this page--> --%>
 
<div class="easy-get" style="display: none">
		 			 <input type="text" id="numpadValue" class="easy-put" />
		 			 </div>

</div>
<div id="divFillDisountList" style=" height:0px;width:0px; display:none;" >
	<table id="tblFillDisountList" class="transTable">
					</table>
</div>

                <s:hidden id="hidSubTotal" path="dblSubTotal"/>
		 		<s:hidden id="hidDiscountTotal" path="dblDicountTotal"/>
		 		<s:hidden id="hidNetTotal" path="dblNetTotal"/>
		 		<s:hidden id="hidGrandTotal" path="dblGrandTotal"/>
		 		<s:hidden id="hidRefund" path="dblRefund"/>
		 	    <s:hidden id="hidTaxTotal" path="dblTotalTaxAmt"/>
 		 		<s:hidden id="hidSettlemnetType" path="strSettlementType"/> 
 		 		<s:hidden id="hidBalanceAmt" path=""/> 
 		 		
 		 		
 		 		<s:hidden id="hidCustMobileNo" path="custMobileNo"/>
		 		<s:hidden id="hidCustomerCode" path="strCustomerCode"/>
		 		<s:hidden id="hidCustomerName" path="customerName"/>
		 		<s:hidden id="hidOperationType" path="operationType"/>
		 		<s:hidden id="hidTransactionType" path="transactionType"/>
		 		<s:hidden id="hidTakeAway" path="takeAway"/>
		 		<s:hidden id="hidDeliveryBoyCode" path="strDeliveryBoyCode"/>
		 		<s:hidden id="hidDeliveryBoyName" path="strDeliveryBoyName"/>
		 		<s:hidden id="hidTableNo" path="strTableNo"/>
				<s:hidden id="hidWaiterNo" path="strWaiter"/>
				<s:hidden id="hidAreaCode" path="strAreaCode"   />
				<s:hidden id="hidBillNo" path="strBillNo"   />
				<s:hidden id="hidIsSettleBill" path="isSettleBill"   />
				
				
				
				

</s:form>


</body>
</html>