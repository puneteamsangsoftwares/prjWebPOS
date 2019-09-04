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
@Table(name = "tblpromotionmaster")
@IdClass(clsPOSPromationMasterModel_ID.class)
@NamedQueries({ @NamedQuery(name = "getAllPromotionMaster", query = "select m.strPromoCode,m.strPromoName,m.strPromotionOn " + "from clsPOSPromationMasterHdModel m where m.strClientCode=:clientCode"),

@NamedQuery(name = "getPromotionMaster", query = "from clsPOSPromationMasterHdModel where strPromoCode=:promoCode and strClientCode=:clientCode") })
public class clsPOSPromationMasterHdModel extends clsBaseModel implements Serializable
{

	private static final long serialVersionUID = 1L;

	public clsPOSPromationMasterHdModel()
	{

		// TODO Auto-generated constructor stub
	}

	public clsPOSPromationMasterHdModel(clsPOSPromationMasterModel_ID objModelID)
	{
		strPromoCode = objModelID.getStrPromoCode();
		strClientCode = objModelID.getStrClientCode();
	}
	
	@Id
	@AttributeOverrides({ @AttributeOverride(name = "strClientCode", column = @Column(name = "strClientCode")), @AttributeOverride(name = "StrPromoCode", column = @Column(name = "strPromoCode")), })
	@Embedded
	@Fetch(FetchMode.SUBSELECT)
	List<clsBuyPromotionDtlHdModel> listBuyPromotionDtl = new ArrayList<clsBuyPromotionDtlHdModel>();
	@CollectionOfElements(fetch = FetchType.EAGER)
	@JoinTable(name = "tblbuypromotiondtl", joinColumns = { @JoinColumn(name = "strClientCode"), @JoinColumn(name = "strPromoCode") })
	
	@Id
	@AttributeOverrides({ @AttributeOverride(name = "strClientCode", column = @Column(name = "strClientCode")), @AttributeOverride(name = "strPromoCode", column = @Column(name = "StrPromoCode")), })
	@Embedded
	@Fetch(FetchMode.SUBSELECT)
	List<clsGetPromotionDtlHdModel> listGetPromotionDtl = new ArrayList<clsGetPromotionDtlHdModel>();
	@CollectionOfElements(fetch = FetchType.EAGER)
	@JoinTable(name = "tblpromotiondtl", joinColumns = { @JoinColumn(name = "strClientCode"), @JoinColumn(name = "strPromoCode") })
	
	
	@Id
	@AttributeOverrides({ @AttributeOverride(name = "strClientCode", column = @Column(name = "strClientCode")), @AttributeOverride(name = "strPromoCode", column = @Column(name = "StrPromoCode")), })
	@Embedded
	@Fetch(FetchMode.SUBSELECT)
	List<clsPromotionDayTimeDtlHdModel> listPromotionDayTimeDtl = new ArrayList<clsPromotionDayTimeDtlHdModel>();
	@CollectionOfElements(fetch = FetchType.EAGER)
	@JoinTable(name = "tblpromotiondaytimedtl", joinColumns = { @JoinColumn(name = "strClientCode"), @JoinColumn(name = "strPromoCode") })
	@Id
	@AttributeOverrides({ @AttributeOverride(name = "strClientCode", column = @Column(name = "strClientCode")), @AttributeOverride(name = "strPromoCode", column = @Column(name = "StrPromoCode")), })
	
	
	@Column(name = "strPromoCode")
	private String strPromoCode;

	@Column(name = "strPromoName")
	private String strPromoName;

	@Column(name = "strPromotionOn")
	private String strPromotionOn;

	@Column(name = "strPromoItemCode")
	private String strPromoItemCode;

	@Column(name = "strOperator")
	private String strOperator;

	@Column(name = "dblBuyQty")
	private double dblBuyQty;

	@Column(name = "dteFromDate")
	private String dteFromDate;

	@Column(name = "dteToDate")
	private String dteToDate;

	@Column(name = "tmeFromTime")
	private String tmeFromTime;

	@Column(name = "tmeToTime")
	private String tmeToTime;

	@Column(name = "strDays")
	private String strDays;

	@Column(name = "strType")
	private String strType;

	@Column(name = "strPromoNote")
	private String strPromoNote;

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

	@Column(name = "strGetItemCode")
	private String strGetItemCode;

	@Column(name = "strGetPromoOn")
	private String strGetPromoOn;

	@Column(name = "strAreaCode")
	private String strAreaCode;
	
	@Column(name = "longKOTTimeBound")
	private long longKOTTimeBound;



	public List<clsBuyPromotionDtlHdModel> getListBuyPromotionDtl()
	{
		return listBuyPromotionDtl;
	}

	public void setListBuyPromotionDtl(List<clsBuyPromotionDtlHdModel> listBuyPromotionDtl)
	{
		this.listBuyPromotionDtl = listBuyPromotionDtl;
	}

	public List<clsGetPromotionDtlHdModel> getListGetPromotionDtl()
	{
		return listGetPromotionDtl;
	}

	public void setListGetPromotionDtl(List<clsGetPromotionDtlHdModel> listGetPromotionDtl)
	{
		this.listGetPromotionDtl = listGetPromotionDtl;
	}

	public List<clsPromotionDayTimeDtlHdModel> getListPromotionDayTimeDtl()
	{
		return listPromotionDayTimeDtl;
	}

	public void setListPromotionDayTimeDtl(List<clsPromotionDayTimeDtlHdModel> listPromotionDayTimeDtl)
	{
		this.listPromotionDayTimeDtl = listPromotionDayTimeDtl;
	}

	public String getStrPromoCode()
	{
		return strPromoCode;
	}

	public void setStrPromoCode(String strPromoCode)
	{
		this.strPromoCode = strPromoCode;
	}

	public String getStrPromoName()
	{
		return strPromoName;
	}

	public void setStrPromoName(String strPromoName)
	{
		this.strPromoName = strPromoName;
	}

	public String getStrPromotionOn()
	{
		return strPromotionOn;
	}

	public void setStrPromotionOn(String strPromotionOn)
	{
		this.strPromotionOn = strPromotionOn;
	}

	public String getStrPromoItemCode()
	{
		return strPromoItemCode;
	}

	public void setStrPromoItemCode(String strPromoItemCode)
	{
		this.strPromoItemCode = strPromoItemCode;
	}

	public String getStrOperator()
	{
		return strOperator;
	}

	public void setStrOperator(String strOperator)
	{
		this.strOperator = strOperator;
	}

	public double getDblBuyQty()
	{
		return dblBuyQty;
	}

	public void setDblBuyQty(double dblBuyQty)
	{
		this.dblBuyQty = dblBuyQty;
	}

	public String getDteFromDate()
	{
		return dteFromDate;
	}

	public void setDteFromDate(String dteFromDate)
	{
		this.dteFromDate = dteFromDate;
	}

	public String getDteToDate()
	{
		return dteToDate;
	}

	public void setDteToDate(String dteToDate)
	{
		this.dteToDate = dteToDate;
	}

	public String getTmeFromTime()
	{
		return tmeFromTime;
	}

	public void setTmeFromTime(String tmeFromTime)
	{
		this.tmeFromTime = tmeFromTime;
	}

	public String getTmeToTime()
	{
		return tmeToTime;
	}

	public void setTmeToTime(String tmeToTime)
	{
		this.tmeToTime = tmeToTime;
	}

	public String getStrDays()
	{
		return strDays;
	}

	public void setStrDays(String strDays)
	{
		this.strDays = strDays;
	}

	public String getStrType()
	{
		return strType;
	}

	public void setStrType(String strType)
	{
		this.strType = strType;
	}

	public String getStrPromoNote()
	{
		return strPromoNote;
	}

	public void setStrPromoNote(String strPromoNote)
	{
		this.strPromoNote = strPromoNote;
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

	public String getStrGetItemCode()
	{
		return strGetItemCode;
	}

	public void setStrGetItemCode(String strGetItemCode)
	{
		this.strGetItemCode = strGetItemCode;
	}

	public String getStrGetPromoOn()
	{
		return strGetPromoOn;
	}

	public void setStrGetPromoOn(String strGetPromoOn)
	{
		this.strGetPromoOn = strGetPromoOn;
	}

	public String getStrAreaCode()
	{
		return strAreaCode;
	}

	public void setStrAreaCode(String strAreaCode)
	{
		this.strAreaCode = strAreaCode;
	}

	public static long getSerialversionuid()
	{
		return serialVersionUID;
	}

	public long getLongKOTTimeBound()
	{
		return longKOTTimeBound;
	}

	public void setLongKOTTimeBound(long longKOTTimeBound)
	{
		this.longKOTTimeBound = longKOTTimeBound;
	}

}
