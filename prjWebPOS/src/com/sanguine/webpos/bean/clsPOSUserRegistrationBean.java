package com.sanguine.webpos.bean;

import java.sql.Blob;
import java.util.List;

import javax.persistence.FetchType;
import javax.persistence.OneToMany;

import org.springframework.beans.factory.annotation.Autowired;

public class clsPOSUserRegistrationBean 
{
    private String strUserCode;
	
	private String strUserName;
	
	private String strUserType;
	
	private String dteValidTill;
	
	private String strSuperType;

	private String strPassword;
	
	
	private String strFormName;
	
	private String strModuleName;
	
	private String strModuleType;
	
	private String strPOSAccess;
	
	private String strWaiterNo;
	
	private int intNoOfDaysReportsView;
	
	private String strConfirmPassword;
	
	private String strSelect;
	
	private String strImgUserIconPath;
	
	private String strDataPostFlag;
	
	private String strDebitCardString;
	
	private String strOldUserCode;
	
	
	public String getStrOldUserCode()
	{
		return strOldUserCode;
	}

	public void setStrOldUserCode(String strOldUserCode)
	{
		this.strOldUserCode = strOldUserCode;
	}

	private List<clsPOSMasterBean> listPOSData;

	
	public String getStrDebitCardString()
	{
		return strDebitCardString;
	}

	public void setStrDebitCardString(String strDebitCardString)
	{
		this.strDebitCardString = strDebitCardString;
	}

	public String getStrDataPostFlag()
	{
		return strDataPostFlag;
	}

	public void setStrDataPostFlag(String strDataPostFlag)
	{
		this.strDataPostFlag = strDataPostFlag;
	}

	public List<clsPOSMasterBean> getListPOSData()
	{
		return listPOSData;
	}

	public void setListPOSData(List<clsPOSMasterBean> listPOSData)
	{
		this.listPOSData = listPOSData;
	}

	public String getStrSelect()
	{
		return strSelect;
	}

	public void setStrSelect(String strSelect)
	{
		this.strSelect = strSelect;
	}

	private List<clsPOSUserAccessBean> listMasterForm;

	private List<clsPOSUserAccessBean> listTransactionForm;
	private List<clsPOSUserAccessBean> listReportForm;
	private List<clsPOSUserAccessBean> listUtilitiesForm;
	private List<clsPOSUserAccessBean> listUsersSelectedForms;
	
	
	
	public List<clsPOSUserAccessBean> getListMasterForm() {
		return listMasterForm;
	}

	public void setListMasterForm(List<clsPOSUserAccessBean> listMasterForm) {
		this.listMasterForm = listMasterForm;
	}

	public List<clsPOSUserAccessBean> getListTransactionForm() {
		return listTransactionForm;
	}

	public void setListTransactionForm(List<clsPOSUserAccessBean> listTransactionForm) {
		this.listTransactionForm = listTransactionForm;
	}

	public List<clsPOSUserAccessBean> getListReportForm() {
		return listReportForm;
	}

	public void setListReportForm(List<clsPOSUserAccessBean> listReportForm) {
		this.listReportForm = listReportForm;
	}

	public List<clsPOSUserAccessBean> getListUtilitiesForm() {
		return listUtilitiesForm;
	}

	public void setListUtilitiesForm(List<clsPOSUserAccessBean> listUtilitiesForm) {
		this.listUtilitiesForm = listUtilitiesForm;
	}

	
	public List<clsPOSUserAccessBean> getListUsersSelectedForms() {
		return listUsersSelectedForms;
	}

	public void setListUsersSelectedForms(
			List<clsPOSUserAccessBean> listUsersSelectedForms) {
		this.listUsersSelectedForms = listUsersSelectedForms;
	}

	public String getStrModuleName() 
	{
		return strModuleName;
	}

	public void setStrModuleName(String strModuleName) 
	{
		this.strModuleName = strModuleName;
	}

	public String getStrModuleType() {
		return strModuleType;
	}

	public void setStrModuleType(String strModuleType) {
		this.strModuleType = strModuleType;
	}

	public String getStrFormName() {
		return strFormName;
	}

	public void setStrFormName(String strFormName) {
		this.strFormName = strFormName;
	}

	/*
	public Blob getImgUserIcon()
	{
		return imgUserIcon;
	}

	public void setImgUserIcon(Blob imgUserIcon)
	{
		this.imgUserIcon = imgUserIcon;
	}*/

	public String getStrPassword() {
		return strPassword;
	}

	public void setStrPassword(String strPassword) {
		this.strPassword = strPassword;
	}

	public String getStrUserCode() {
		return strUserCode;
	}

	public void setStrUserCode(String strUserCode) {
		this.strUserCode = strUserCode;
	}

	public String getStrUserName() {
		return strUserName;
	}

	public void setStrUserName(String strUserName) {
		this.strUserName = strUserName;
	}
	public String getStrUserType() {
		return strUserType;
	}

	public void setStrUserType(String strUserType) {
		this.strUserType = strUserType;
	}

	public String getStrSuperType()
	{
		return strSuperType;
	}

	public void setStrSuperType(String strSuperType)
	{
		this.strSuperType = strSuperType;
	}

	public String getStrPOSAccess()
	{
		return strPOSAccess;
	}

	public void setStrPOSAccess(String strPOSAccess)
	{
		this.strPOSAccess = strPOSAccess;
	}

	public String getStrWaiterNo()
	{
		return strWaiterNo;
	}

	public void setStrWaiterNo(String strWaiterNo)
	{
		this.strWaiterNo = strWaiterNo;
	}

	public String getDteValidTill()
	{
		return dteValidTill;
	}

	public void setDteValidTill(String dteValidTill)
	{
		this.dteValidTill = dteValidTill;
	}

	public String getStrConfirmPassword()
	{
		return strConfirmPassword;
	}

	public void setStrConfirmPassword(String strConfirmPassword)
	{
		this.strConfirmPassword = strConfirmPassword;
	}

	public int getIntNoOfDaysReportsView()
	{
		return intNoOfDaysReportsView;
	}

	public void setIntNoOfDaysReportsView(int intNoOfDaysReportsView)
	{
		this.intNoOfDaysReportsView = intNoOfDaysReportsView;
	}

	public String getStrImgUserIconPath()
	{
		return strImgUserIconPath;
	}

	public void setStrImgUserIconPath(String strImgUserIconPath)
	{
		this.strImgUserIconPath = strImgUserIconPath;
	}

	
	
}
