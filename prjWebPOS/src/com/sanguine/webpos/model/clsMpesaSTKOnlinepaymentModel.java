package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.Table;

@Entity
@Table(name="tblmpesastkonlinepayment")
@IdClass(clsMpesaSTKOnlinepaymentModel_ID.class)

public class clsMpesaSTKOnlinepaymentModel implements Serializable{
	private static final long serialVersionUID = 1L;
	public clsMpesaSTKOnlinepaymentModel(){}

	public clsMpesaSTKOnlinepaymentModel(clsMpesaSTKOnlinepaymentModel_ID objModelID){
		MerchantRequestID = objModelID.getMerchantRequestID();
		CheckoutRequestID = objModelID.getCheckoutRequestID();
		MpesaReceiptNumber = objModelID.getMpesaReceiptNumber();
		strClientCode = objModelID.getStrClientCode();
	}

	@Id
	@AttributeOverrides({
		@AttributeOverride(name="MerchantRequestID",column=@Column(name="MerchantRequestID")),
@AttributeOverride(name="CheckoutRequestID",column=@Column(name="CheckoutRequestID")),
@AttributeOverride(name="MpesaReceiptNumber",column=@Column(name="MpesaReceiptNumber")),
@AttributeOverride(name="strClientCode",column=@Column(name="strClientCode"))
	})

//Variable Declaration
	@Column(name="MerchantRequestID")
	private String MerchantRequestID;

	@Column(name="CheckoutRequestID")
	private String CheckoutRequestID;

	@Column(name="ResultCode")
	private int ResultCode;

	@Column(name="ResultDesc")
	private String ResultDesc;

	@Column(name="Amount")
	private double Amount;

	@Column(name="MpesaReceiptNumber")
	private String MpesaReceiptNumber;

	@Column(name="TransactionDate")
	private String TransactionDate;

	@Column(name="PhoneNumber")
	private String PhoneNumber;

	@Column(name="Balance")
	private String Balance;

	@Column(name="strClientCode")
	private String strClientCode;

//Setter-Getter Methods
	public String getStrClientCode(){
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode){
		this. strClientCode = (String) setDefaultValue( strClientCode, "NA");
	}


//Function to Set Default Values
	private Object setDefaultValue(Object value, Object defaultValue){
		if(value !=null && (value instanceof String && value.toString().length()>0)){
			return value;
		}
		else if(value !=null && (value instanceof Double && value.toString().length()>0)){
			return value;
		}
		else if(value !=null && (value instanceof Integer && value.toString().length()>0)){
			return value;
		}
		else if(value !=null && (value instanceof Long && value.toString().length()>0)){
			return value;
		}
		else{
			return defaultValue;
		}
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

	public int getResultCode()
	{
		return ResultCode;
	}

	public void setResultCode(int resultCode)
	{
		ResultCode = resultCode;
	}

	public String getResultDesc()
	{
		return ResultDesc;
	}

	public void setResultDesc(String resultDesc)
	{
		ResultDesc = resultDesc;
	}

	public double getAmount()
	{
		return Amount;
	}

	public void setAmount(double amount)
	{
		Amount = amount;
	}

	public String getMpesaReceiptNumber()
	{
		return MpesaReceiptNumber;
	}

	public void setMpesaReceiptNumber(String mpesaReceiptNumber)
	{
		MpesaReceiptNumber = mpesaReceiptNumber;
	}

	public String getTransactionDate()
	{
		return TransactionDate;
	}

	public void setTransactionDate(String transactionDate)
	{
		TransactionDate = transactionDate;
	}

	public String getPhoneNumber()
	{
		return PhoneNumber;
	}

	public void setPhoneNumber(String phoneNumber)
	{
		PhoneNumber = phoneNumber;
	}

	public String getBalance()
	{
		return Balance;
	}

	public void setBalance(String balance)
	{
		Balance = balance;
	}

}
