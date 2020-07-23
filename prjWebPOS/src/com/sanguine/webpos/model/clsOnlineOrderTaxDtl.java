package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Embeddable;
@Embeddable
public class clsOnlineOrderTaxDtl implements Serializable
{

	private static final long serialVersionUID = 1L;
	public clsOnlineOrderTaxDtl() {}
	
	//private String strOrderId;

	private String strTaxName;

	private double dblTaxRate;

	private double dblTaxAmount;

	//private String strItemCode;

//	private String dtOrderDate;

//Setter-Getter Methods
	/*
	 * public String getStrOrderId(){ return strOrderId; } public void
	 * setStrOrderId(String strOrderId){ this.strOrderId=strOrderId; }
	 */
	public String getStrTaxName(){
		return strTaxName;
	}
	public void setStrTaxName(String strTaxName){
		this.strTaxName=strTaxName;
	}

	public double getDblTaxRate(){
		return dblTaxRate;
	}
	public void setDblTaxRate(double dblTaxRate){
		this.dblTaxRate=dblTaxRate;
	}

	public double getDblTaxAmount(){
		return dblTaxAmount;
	}
	public void setDblTaxAmount(double dblTaxAmount){
		this.dblTaxAmount=dblTaxAmount;
	}
	/*
	 * public String getStrItemCode() { return strItemCode; } public void
	 * setStrItemCode(String strItemCode) { this.strItemCode = strItemCode; }
	 */
	/*
	 * public String getStrClientCode(){ return strClientCode; } public void
	 * setStrClientCode(String strClientCode){ this.strClientCode=strClientCode; }
	 */



}
