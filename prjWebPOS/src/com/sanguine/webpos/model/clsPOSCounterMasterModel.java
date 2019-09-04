package com.sanguine.webpos.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

import org.hibernate.annotations.CollectionOfElements;
import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;

import com.sanguine.base.model.clsBaseModel;

@Entity
@Table(name = "tblcounterhd")
@IdClass(clsPOSCounterMasterModel_ID.class)
@NamedQueries({ @NamedQuery(name = "getAllCounterMaster", 
query = "select m.strCounterCode,m.strCounterName,m.strOperational,m.strUserCode,  m.strPOSCode " 
		+ "from clsPOSCounterMasterModel m where m.strClientCode=:clientCode "),

		@NamedQuery(name = "getCounterMaster", 
		query = "from clsPOSCounterMasterModel where strCounterCode=:counterCode and strClientCode=:clientCode")})




public class clsPOSCounterMasterModel extends clsBaseModel implements Serializable
{

    @CollectionOfElements(fetch=FetchType.EAGER)
    @JoinTable(name="tblcounterdtl" , joinColumns={@JoinColumn(name="strClientCode"),@JoinColumn(name="strCounterCode")})
	@Id
	@AttributeOverrides({
		@AttributeOverride(name="strClientCode",column=@Column(name="strClientCode")),
		@AttributeOverride(name="strCounterCode",column=@Column(name="strCounterCode"))
	})
	
	
	
	/*@Id
	@AttributeOverrides({ @AttributeOverride(name = "strClientCode", column = @Column(name = "strClientCode")), @AttributeOverride(name = "strMenuCode", column = @Column(name = "strMenuCode")), })
	@Embedded
	@Fetch(FetchMode.SUBSELECT)
	@CollectionOfElements(fetch = FetchType.EAGER)
	@JoinTable(name = "tblcounterdtl", joinColumns = { @JoinColumn(name = "strClientCode"), @JoinColumn(name = "strMenuCode") })*/
	
	private List<clsPOSCounterDtlModel> listCounterDtlModel= new ArrayList<clsPOSCounterDtlModel>();

	@Column(name = "strCounterCode")
	private String strCounterCode;

	@Column(name = "strCounterName")
	private String strCounterName;

	@Column(name = "strPOSCode")
	private String strPOSCode;

	@Column(name = "strAreaCode")
	private String strAreaCode;

	@Column(name = "strUserCode")
	private String strUserCode;

	@Column(name = "strOperational")
	private String strOperational;

	@Column(name = "strUserCreated")
	private String strUserCreated;

	@Column(name = "strUserEdited")
	private String strUserEdited;

	@Column(name = "dteDateCreated")
	private String dteDateCreated;

	@Column(name = "dteDateEdited")
	private String dteDateEdited;

	@Column(name = "strDataPostFlag")
	private String strDataPostFlag;

	@Column(name = "strClientCode")
	private String strClientCode;

	private static final long serialVersionUID = 1L;
	
	
	

	public clsPOSCounterMasterModel()
	{
	}

	public clsPOSCounterMasterModel(clsPOSCounterMasterModel_ID objModelID)
	    {
	    	strCounterCode = objModelID.getStrCounterCode();
		strClientCode = objModelID.getStrClientCode();
		
	    }

	public String getStrCounterCode()
	{
		return strCounterCode;
	}

	public void setStrCounterCode(String strCounterCode)
	{
		this.strCounterCode = strCounterCode;
	}

	public String getStrCounterName()
	{
		return strCounterName;
	}

	public void setStrCounterName(String strCounterName)
	{
		this.strCounterName = strCounterName;
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

	public String getStrUserCode()
	{
		return strUserCode;
	}

	public void setStrUserCode(String strUserCode)
	{
		this.strUserCode = strUserCode;
	}

	public String getStrOperational()
	{
		return strOperational;
	}

	public void setStrOperational(String strOperational)
	{
		this.strOperational = strOperational;
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

	public String getStrDataPostFlag()
	{
		return strDataPostFlag;
	}

	public void setStrDataPostFlag(String strDataPostFlag)
	{
		this.strDataPostFlag = strDataPostFlag;
	}

	public String getStrClientCode()
	{
		return strClientCode;
	}

	public void setStrClientCode(String strClientCode)
	{
		this.strClientCode = strClientCode;
	}

	public static long getSerialversionuid()
	{
		return serialVersionUID;
	}

	public List<clsPOSCounterDtlModel> getListCounterDtlModel()
	{
		return listCounterDtlModel;
	}

	public void setListCounterDtlModel(List<clsPOSCounterDtlModel> listCounterDtlModel)
	{
		this.listCounterDtlModel = listCounterDtlModel;
	}

}
