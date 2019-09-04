package com.sanguine.webpos.bean;

public class clsPOSModifierGroupMasterBean
{
	private String strModifierGroupCode;

	private String strModifierGroupName;

	private String strModifierGroupShortName;


	private int strMinItemLimit;

	private String strMaxModifierSelection;

	private String strApplyMaxItemLimit;

	private int strSequenceNo;

	
	private String strOperationType;

	private int intItemMaxLimit;
	private String strApplyMinItemLimit;

	public String getStrModifierGroupCode()
	{
		return strModifierGroupCode;
	}

	public void setStrModifierGroupCode(String strModifierGroupCode)
	{
		this.strModifierGroupCode = strModifierGroupCode;
	}

	public String getStrModifierGroupName()
	{
		return strModifierGroupName;
	}

	public void setStrModifierGroupName(String strModifierGroupName)
	{
		this.strModifierGroupName = strModifierGroupName;
	}

	public String getStrModifierGroupShortName()
	{
		return strModifierGroupShortName;
	}

	public void setStrModifierGroupShortName(String strModifierGroupShortName)
	{
		this.strModifierGroupShortName = strModifierGroupShortName;
	}

	

	public void setStrMaxModifierSelection(String strMaxModifierSelection)
	{
		this.strMaxModifierSelection = strMaxModifierSelection;
	}

	public int getStrSequenceNo()
	{
		return strSequenceNo;
	}

	public void setStrSequenceNo(int strSequenceNo)
	{
		this.strSequenceNo = strSequenceNo;
	}



	public String getStrOperationType()
	{
		return strOperationType;
	}

	public void setStrOperationType(String strOperationType)
	{
		this.strOperationType = strOperationType;
	}

	public String getStrApplyMaxItemLimit()
	{
		return strApplyMaxItemLimit;
	}

	public void setStrApplyMaxItemLimit(String strApplyMaxItemLimit)
	{
		this.strApplyMaxItemLimit = strApplyMaxItemLimit;
	}

	public int getIntItemMaxLimit()
	{
		return intItemMaxLimit;
	}

	public void setIntItemMaxLimit(int intItemMaxLimit)
	{
		this.intItemMaxLimit = intItemMaxLimit;
	}

	

	public int getStrMinItemLimit()
	{
		return strMinItemLimit;
	}

	public void setStrMinItemLimit(int strMinItemLimit)
	{
		this.strMinItemLimit = strMinItemLimit;
	}

	public String getStrMaxModifierSelection()
	{
		return strMaxModifierSelection;
	}

	public String getStrApplyMinItemLimit()
	{
		return strApplyMinItemLimit;
	}

	public void setStrApplyMinItemLimit(String strApplyMinItemLimit)
	{
		this.strApplyMinItemLimit = strApplyMinItemLimit;
	}

}
