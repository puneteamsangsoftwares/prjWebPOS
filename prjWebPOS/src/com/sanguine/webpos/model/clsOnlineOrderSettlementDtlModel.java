package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Embeddable;
@Embeddable
public class clsOnlineOrderSettlementDtlModel implements Serializable
{

	private static final long serialVersionUID = 1L;

	public clsOnlineOrderSettlementDtlModel() {}
	

	//private String strOrderId;

	private String strSettlementName;

	private double dblSettlementAmt;

	//private String strClientCode;

	private String srvr_trx_id;

	//private String dtOrderDate;

//Setter-Getter Methods
	
	public String getStrSettlementName(){
		return strSettlementName;
	}
	public void setStrSettlementName(String strSettlementName){
		this.strSettlementName=strSettlementName;
	}

	public double getDblSettlementAmt(){
		return dblSettlementAmt;
	}
	public void setDblSettlementAmt(double dblSettlementAmt){
		this.dblSettlementAmt=dblSettlementAmt;
	}

	public String getSrvr_trx_id()
	{
		return srvr_trx_id;
	}
	public void setSrvr_trx_id(String srvr_trx_id)
	{
		this.srvr_trx_id = srvr_trx_id;
	}
	



}
