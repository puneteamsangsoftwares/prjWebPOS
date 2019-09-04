package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.IdClass;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

import com.sanguine.base.model.clsBaseModel;
@Entity
@Table(name = "tblordermaster")
@IdClass(clsPOSOrderMasterModel_ID.class)
@NamedQueries({ @NamedQuery(name = "getAllOrderMaster", 
query = "select m.strOrderCode,m.strOrderDesc" 
		+ "from clsPOSOrderMasterModel m where m.strClientCode=:clientCode "),

		@NamedQuery(name = "getOrderMaster", 
		query = "from clsPOSOrderMasterModel where strAreaCode=:areaCode and strClientCode=:clientCode")})
public class clsPOSOrderMasterModel extends clsBaseModel implements Serializable
{
	private static final long serialVersionUID = 1L;

	public clsPOSOrderMasterModel()
	{
	}

	public clsPOSOrderMasterModel(clsPOSOrderMasterModel_ID objModelID)
	{
		strOrderCode = objModelID.getStrOrderCode();
		strClientCode = objModelID.getStrClientCode();

	}

	@Column(name = "strOrderCode")
	private String strOrderCode;
	
	@Column(name = "strOrderDesc")
	private String strOrderDesc;
	
	@Column(name = "strUserCreated")
	private String strUserCreated;
	
	@Column(name = "strUserEdited")
	private String strUserEdited;
	
	@Column(name = "dteDateCreated")
	private String dteDateCreated;
	
	@Column(name = "dteDateEdited")
	private String dteDateEdited;
	
	@Column(name = "strClientCode")
	private String strClientCode;
	
	@Column(name = "strDataPostFlag")
	private String strDataPostFlag;
	
	@Column(name = "strPOSCode")
	private String strPOSCode;

	public String getStrOrderCode()
	{
		return strOrderCode;
	}

	public void setStrOrderCode(String strOrderCode)
	{
		this.strOrderCode = strOrderCode;
	}

	public String getStrOrderDesc()
	{
		return strOrderDesc;
	}

	public void setStrOrderDesc(String strOrderDesc)
	{
		this.strOrderDesc = strOrderDesc;
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

	public String getStrPOSCode()
	{
		return strPOSCode;
	}

	public void setStrPOSCode(String strPOSCode)
	{
		this.strPOSCode = strPOSCode;
	}

	public static long getSerialversionuid()
	{
		return serialVersionUID;
	}
	
	
	

}
