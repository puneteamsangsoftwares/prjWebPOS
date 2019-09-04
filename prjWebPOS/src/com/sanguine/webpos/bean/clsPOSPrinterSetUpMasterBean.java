package com.sanguine.webpos.bean;

import java.util.List;

public class clsPOSPrinterSetUpMasterBean{
//Variable Declaration
	private String strPOSCode;

	private String strAreaCode;

	private String strCostCenterCode;

	private String strPrinterType;

	private String strPrimaryPrinterPort;

	private String strSecondaryPrinterPort;

	private String strPrintOnBothPrintersYN;

	private String strUserCreated;

	private String strUserEdited;

	private String dteDateCreated;

	private String dteDateEdited;

	private String strClientCode;

	private String strDataPostFlag;
	
	private String strAreaName;
	
	private String strCostCenterName;
	
	private String strConsolidatedKOTPrinterPort;
	
	
	private List<clsPOSPrinterSetUpMasterBean> listObjPrinterDataBean;


	
	//Setter-Getter Methods

	public List<clsPOSPrinterSetUpMasterBean> getListObjPrinterDataBean()
	{
		return listObjPrinterDataBean;
	}
	public void setListObjPrinterDataBean(List<clsPOSPrinterSetUpMasterBean> listObjPrinterDataBean)
	{
		this.listObjPrinterDataBean = listObjPrinterDataBean;
	}
	private String strPOSName;

	public String getStrConsolidatedKOTPrinterPort()
	{
		return strConsolidatedKOTPrinterPort;
	}
	public void setStrConsolidatedKOTPrinterPort(String strConsolidatedKOTPrinterPort)
	{
		this.strConsolidatedKOTPrinterPort = strConsolidatedKOTPrinterPort;
	}
	public String getStrCostCenterName()
	{
		return strCostCenterName;
	}
	public void setStrCostCenterName(String strCostCenterName)
	{
		this.strCostCenterName = strCostCenterName;
	}
	public String getStrAreaName()
	{
		return strAreaName;
	}
	public void setStrAreaName(String strAreaName)
	{
		this.strAreaName = strAreaName;
	}
	public String getStrPOSName()
	{
		return strPOSName;
	}
	public void setStrPOSName(String strPOSName)
	{
		this.strPOSName = strPOSName;
	}
	
	public String getStrPOSCode(){
		return strPOSCode;
	}
	public void setStrPOSCode(String strPOSCode){
		this.strPOSCode=strPOSCode;
	}

	public String getStrAreaCode(){
		return strAreaCode;
	}
	public void setStrAreaCode(String strAreaCode){
		this.strAreaCode=strAreaCode;
	}

	public String getStrCostCenterCode(){
		return strCostCenterCode;
	}
	public void setStrCostCenterCode(String strCostCenterCode){
		this.strCostCenterCode=strCostCenterCode;
	}

	public String getStrPrinterType(){
		return strPrinterType;
	}
	public void setStrPrinterType(String strPrinterType){
		this.strPrinterType=strPrinterType;
	}

	public String getStrPrimaryPrinterPort(){
		return strPrimaryPrinterPort;
	}
	public void setStrPrimaryPrinterPort(String strPrimaryPrinterPort){
		this.strPrimaryPrinterPort=strPrimaryPrinterPort;
	}

	public String getStrSecondaryPrinterPort(){
		return strSecondaryPrinterPort;
	}
	public void setStrSecondaryPrinterPort(String strSecondaryPrinterPort){
		this.strSecondaryPrinterPort=strSecondaryPrinterPort;
	}

	public String getStrPrintOnBothPrintersYN(){
		return strPrintOnBothPrintersYN;
	}
	public void setStrPrintOnBothPrintersYN(String strPrintOnBothPrintersYN){
		this.strPrintOnBothPrintersYN=strPrintOnBothPrintersYN;
	}

	public String getStrUserCreated(){
		return strUserCreated;
	}
	public void setStrUserCreated(String strUserCreated){
		this.strUserCreated=strUserCreated;
	}

	public String getStrUserEdited(){
		return strUserEdited;
	}
	public void setStrUserEdited(String strUserEdited){
		this.strUserEdited=strUserEdited;
	}

	public String getDteDateCreated(){
		return dteDateCreated;
	}
	public void setDteDateCreated(String dteDateCreated){
		this.dteDateCreated=dteDateCreated;
	}

	public String getDteDateEdited(){
		return dteDateEdited;
	}
	public void setDteDateEdited(String dteDateEdited){
		this.dteDateEdited=dteDateEdited;
	}

	public String getStrClientCode(){
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode){
		this.strClientCode=strClientCode;
	}

	public String getStrDataPostFlag(){
		return strDataPostFlag;
	}
	public void setStrDataPostFlag(String strDataPostFlag){
		this.strDataPostFlag=strDataPostFlag;
	}



}
