package com.sanguine.webpos.model;

import javax.persistence.Column;

public class clsPromotionDayTimeDtlHdModel
{
	@Column(name = "strDays")
	private String strDays;
	
	@Column(name = "strDataPostFlag")
	private String strDataPostFlag;

	
	@Column(name = "tmeFromTime")
	private String tmeFromTime;

	@Column(name = "tmeToTime")
	private String tmeToTime;

	

	public String getStrDays()
	{
		return strDays;
	}

	public void setStrDays(String strDays)
	{
		this.strDays = strDays;
	}

	public String getStrDataPostFlag()
	{
		return strDataPostFlag;
	}

	public void setStrDataPostFlag(String strDataPostFlag)
	{
		this.strDataPostFlag = strDataPostFlag;
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
	
	
}
