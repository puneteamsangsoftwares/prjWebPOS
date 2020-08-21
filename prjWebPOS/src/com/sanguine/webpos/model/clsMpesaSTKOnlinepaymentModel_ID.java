package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
@Embeddable
@SuppressWarnings("serial")

public class clsMpesaSTKOnlinepaymentModel_ID implements Serializable{

//Variable Declaration
	@Column(name="strClientCode")
	private String strClientCode;

	@Column(name="MerchantRequestID")
	private String MerchantRequestID;


	@Column(name="CheckoutRequestID")
	private String CheckoutRequestID;

	@Column(name="MpesaReceiptNumber")
	private String MpesaReceiptNumber;

	public clsMpesaSTKOnlinepaymentModel_ID(){}
	public clsMpesaSTKOnlinepaymentModel_ID(String MerchantRequestID,String CheckoutRequestID,String MpesaReceiptNumber,String strClientCode){
		this.MerchantRequestID=MerchantRequestID;
		this.CheckoutRequestID=CheckoutRequestID;
		this.MpesaReceiptNumber=MpesaReceiptNumber;
		this.strClientCode=strClientCode;
	}

//Setter-Getter Methods
	public String getStrClientCode(){
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode){
		this. strClientCode = strClientCode;
	}


//HashCode and Equals Funtions
	@Override
	public boolean equals(Object obj) {
		clsMpesaSTKOnlinepaymentModel_ID objModelId = (clsMpesaSTKOnlinepaymentModel_ID)obj;
		if(this.MerchantRequestID.equals(objModelId.getMerchantRequestID())&& this.CheckoutRequestID.equals(objModelId.getCheckoutRequestID())&& this.MpesaReceiptNumber.equals(objModelId.getMpesaReceiptNumber())&& this.strClientCode.equals(objModelId.getStrClientCode())){
			return true;
		}
		else{
			return false;
		}
	}

	@Override
	public int hashCode() {
		return this.MerchantRequestID.hashCode()+this.CheckoutRequestID.hashCode()+this.MpesaReceiptNumber.hashCode()+this.strClientCode.hashCode();
	}
	public String getMerchantRequestID()
	{
		return MerchantRequestID;
	}
	public void setMerchantRequestID(String merchantRequestID)
	{
		MerchantRequestID = merchantRequestID;
	}
	public String getCheckoutRequestID()
	{
		return CheckoutRequestID;
	}
	public void setCheckoutRequestID(String checkoutRequestID)
	{
		CheckoutRequestID = checkoutRequestID;
	}
	public String getMpesaReceiptNumber()
	{
		return MpesaReceiptNumber;
	}
	public void setMpesaReceiptNumber(String mpesaReceiptNumber)
	{
		MpesaReceiptNumber = mpesaReceiptNumber;
	}

}
