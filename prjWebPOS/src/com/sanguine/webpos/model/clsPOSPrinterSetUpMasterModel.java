package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.Table;

import org.hibernate.annotations.NamedQueries;
import org.hibernate.annotations.NamedQuery;

import com.sanguine.base.model.clsBaseModel;

@Entity
@Table(name="tblprintersetupmaster")
@IdClass(clsPOSPrinterSetUpMasterModel_ID.class)
/*@NamedQueries(
		{ @NamedQuery (name="POSPrinterSetUpMaster" 
		, query="select m.strCostCenterCode,m.strCostCenterName from  clsPOSPrinterSetUpMasterModel m where m.strClientCode=:clientCode" ),


		@NamedQuery(name = "getPrinterSetUpMaster", query = "from  clsPOSPrinterSetUpMasterModel where strCostCenterCode=:costCenterCode and strClientCode=:clientCode")}
	)*/

public class clsPOSPrinterSetUpMasterModel extends clsBaseModel implements Serializable{
	private static final long serialVersionUID = 1L;
	public clsPOSPrinterSetUpMasterModel(){}

	public clsPOSPrinterSetUpMasterModel(clsPOSPrinterSetUpMasterModel_ID objModelID){
		strPOSCode = objModelID.getStrPOSCode();
		strAreaCode = objModelID.getStrAreaCode();
		strCostCenterCode = objModelID.getStrCostCenterCode();
		strClientCode = objModelID.getStrClientCode();
	}

	@Id
	@AttributeOverrides({
		 @AttributeOverride(name="strPOSCode",column=@Column(name="strPOSCode")),
         @AttributeOverride(name="strAreaCode",column=@Column(name="strAreaCode")),
         @AttributeOverride(name="strCostCenterCode",column=@Column(name="strCostCenterCode")),
         @AttributeOverride(name="strClientCode",column=@Column(name="strClientCode"))
	})

//Variable Declaration
	@Column(name="strPOSCode")
	private String strPOSCode;

	@Column(name="strAreaCode")
	private String strAreaCode;

	@Column(name="strCostCenterCode")
	private String strCostCenterCode;

	@Column(name="strPrinterType")
	private String strPrinterType;

	@Column(name="strPrimaryPrinterPort")
	private String strPrimaryPrinterPort;

	@Column(name="strSecondaryPrinterPort")
	private String strSecondaryPrinterPort;

	@Column(name="strPrintOnBothPrintersYN")
	private String strPrintOnBothPrintersYN;

	@Column(name="strUserCreated")
	private String strUserCreated;

	@Column(name="strUserEdited")
	private String strUserEdited;

	@Column(name="dteDateCreated")
	private String dteDateCreated;

	@Column(name="dteDateEdited")
	private String dteDateEdited;

	@Column(name="strClientCode")
	private String strClientCode;

	@Column(name="strDataPostFlag")
	private String strDataPostFlag;

//Setter-Getter Methods
	


//Function to Set Default Values
	protected Object setDefaultValue(Object value, Object defaultValue){
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

	public String getStrPOSCode()
	{
		return strPOSCode;
	}

	public void setStrPOSCode(String strPOSCode)
	{
		this.strPOSCode = strPOSCode;
	}

	public String getStrAreaCode()
	{
		return strAreaCode;
	}

	public void setStrAreaCode(String strAreaCode)
	{
		this.strAreaCode = strAreaCode;
	}

	public String getStrCostCenterCode()
	{
		return strCostCenterCode;
	}

	public void setStrCostCenterCode(String strCostCenterCode)
	{
		this.strCostCenterCode = strCostCenterCode;
	}

	public String getStrPrinterType()
	{
		return strPrinterType;
	}

	public void setStrPrinterType(String strPrinterType)
	{
		this.strPrinterType = strPrinterType;
	}

	public String getStrPrimaryPrinterPort()
	{
		return strPrimaryPrinterPort;
	}

	public void setStrPrimaryPrinterPort(String strPrimaryPrinterPort)
	{
		this.strPrimaryPrinterPort = strPrimaryPrinterPort;
	}

	public String getStrSecondaryPrinterPort()
	{
		return strSecondaryPrinterPort;
	}

	public void setStrSecondaryPrinterPort(String strSecondaryPrinterPort)
	{
		this.strSecondaryPrinterPort = strSecondaryPrinterPort;
	}

	public String getStrPrintOnBothPrintersYN()
	{
		return strPrintOnBothPrintersYN;
	}

	public void setStrPrintOnBothPrintersYN(String strPrintOnBothPrintersYN)
	{
		this.strPrintOnBothPrintersYN = strPrintOnBothPrintersYN;
	}

	public String getStrUserCreated()
	{
		return strUserCreated;
	}

	public void setStrUserCreated(String strUserCreated)
	{
		this.strUserCreated = strUserCreated;
	}

	public String getStrUserEdited()
	{
		return strUserEdited;
	}

	public void setStrUserEdited(String strUserEdited)
	{
		this.strUserEdited = strUserEdited;
	}

	public String getDteDateCreated()
	{
		return dteDateCreated;
	}

	public void setDteDateCreated(String dteDateCreated)
	{
		this.dteDateCreated = dteDateCreated;
	}

	public String getDteDateEdited()
	{
		return dteDateEdited;
	}

	public void setDteDateEdited(String dteDateEdited)
	{
		this.dteDateEdited = dteDateEdited;
	}

	public String getStrClientCode()
	{
		return strClientCode;
	}

	public void setStrClientCode(String strClientCode)
	{
		this.strClientCode = strClientCode;
	}

	public String getStrDataPostFlag()
	{
		return strDataPostFlag;
	}

	public void setStrDataPostFlag(String strDataPostFlag)
	{
		this.strDataPostFlag = strDataPostFlag;
	}

	public static long getSerialversionuid()
	{
		return serialVersionUID;
	}

}
