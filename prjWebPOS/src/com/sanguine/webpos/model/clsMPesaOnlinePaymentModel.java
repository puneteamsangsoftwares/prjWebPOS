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
@Table(name="tblmpesaonlinepayment")
@IdClass(clsMPesaOnlinePaymentModel_ID.class)

public class clsMPesaOnlinePaymentModel implements Serializable{
	private static final long serialVersionUID = 1L;
	public clsMPesaOnlinePaymentModel(){}

	public clsMPesaOnlinePaymentModel(clsMPesaOnlinePaymentModel_ID objModelID){
		strTransID = objModelID.getStrTransID();
		strBusinessShortCode = objModelID.getStrBusinessShortCode();
	}

	@Id
	@AttributeOverrides({
		@AttributeOverride(name="strTransID",column=@Column(name="strTransID")),
@AttributeOverride(name="strBusinessShortCode",column=@Column(name="strBusinessShortCode"))
	})

//Variable Declaration
	@Column(name="strTransactionType")
	private String strTransactionType;

	@Column(name="strTransID")
	private String strTransID;

	@Column(name="strTransTime")
	private String strTransTime;

	@Column(name="dblTransAmount")
	private double dblTransAmount;

	@Column(name="strBusinessShortCode")
	private String strBusinessShortCode;

	@Column(name="strBillRefNumber")
	private String strBillRefNumber;

	@Column(name="strInvoiceNumber")
	private String strInvoiceNumber;

	@Column(name="strOrgAccountBalance")
	private String strOrgAccountBalance;

	@Column(name="strThirdPartyTransID")
	private String strThirdPartyTransID;

	@Column(name="strMSISDN")
	private String strMSISDN;

	@Column(name="strFirstName")
	private String strFirstName;

	@Column(name="strMiddleName")
	private String strMiddleName;

	@Column(name="strLastName")
	private String strLastName;

//Setter-Getter Methods
	public String getStrTransactionType(){
		return strTransactionType;
	}
	public void setStrTransactionType(String strTransactionType){
		this. strTransactionType = (String) setDefaultValue( strTransactionType, "NA");
	}

	public String getStrTransID(){
		return strTransID;
	}
	public void setStrTransID(String strTransID){
		this. strTransID = (String) setDefaultValue( strTransID, "NA");
	}


	public double getDblTransAmount(){
		return dblTransAmount;
	}
	public void setDblTransAmount(double dblTransAmount){
		this. dblTransAmount = (Double) setDefaultValue( dblTransAmount, "NA");
	}

	public String getStrBusinessShortCode(){
		return strBusinessShortCode;
	}
	public void setStrBusinessShortCode(String strBusinessShortCode){
		this. strBusinessShortCode = (String) setDefaultValue( strBusinessShortCode, "NA");
	}

	public String getStrBillRefNumber(){
		return strBillRefNumber;
	}
	public void setStrBillRefNumber(String strBillRefNumber){
		this. strBillRefNumber = (String) setDefaultValue( strBillRefNumber, "NA");
	}

	public String getStrInvoiceNumber(){
		return strInvoiceNumber;
	}
	public void setStrInvoiceNumber(String strInvoiceNumber){
		this. strInvoiceNumber = (String) setDefaultValue( strInvoiceNumber, "NA");
	}

	public String getStrOrgAccountBalance(){
		return strOrgAccountBalance;
	}
	public void setStrOrgAccountBalance(String strOrgAccountBalance){
		this. strOrgAccountBalance = (String) setDefaultValue( strOrgAccountBalance, "NA");
	}

	public String getStrThirdPartyTransID(){
		return strThirdPartyTransID;
	}
	public void setStrThirdPartyTransID(String strThirdPartyTransID){
		this. strThirdPartyTransID = (String) setDefaultValue( strThirdPartyTransID, "NA");
	}

	public String getStrMSISDN(){
		return strMSISDN;
	}
	public void setStrMSISDN(String strMSISDN){
		this. strMSISDN = (String) setDefaultValue( strMSISDN, "NA");
	}

	public String getStrFirstName(){
		return strFirstName;
	}
	public void setStrFirstName(String strFirstName){
		this. strFirstName = (String) setDefaultValue( strFirstName, "NA");
	}

	public String getStrMiddleName(){
		return strMiddleName;
	}
	public void setStrMiddleName(String strMiddleName){
		this. strMiddleName = (String) setDefaultValue( strMiddleName, "NA");
	}

	public String getStrLastName(){
		return strLastName;
	}
	public void setStrLastName(String strLastName){
		this. strLastName = (String) setDefaultValue( strLastName, "NA");
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

	public String getStrTransTime()
	{
		return strTransTime;
	}

	public void setStrTransTime(String strTransTime)
	{
		this.strTransTime = strTransTime;
	}

}
