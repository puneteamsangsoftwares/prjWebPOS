/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.sanguine.webpos.bean;

import java.util.List;

/**
 *
 * @author Pratiksha
 */
public class clsPOSCounterMasterBean {
	private String strCounterCode;
	private String strCounterName;
	private String strMenuCode;
	private String strMenuName;
	private String strGroupCode;
	private String strGroupName;
	private String strSubGroupCode;
	private String strSubGroupName;
	private double dblRate;
	private double dblQuantity;
	private double dblAmount;
	private String strOperational;
	private String strUserCode;
	private String strPOSCode;
	private String strClientCode;

	
	
	private List<clsPOSMenuHeadBean> getListMenuHeadDtl;

	public clsPOSCounterMasterBean() {
	}

	public String getStrCounterCode() {
		return strCounterCode;
	}

	public void setStrCounterCode(String strCounterCode) {
		this.strCounterCode = strCounterCode;
	}

	public String getStrCounterName() {
		return strCounterName;
	}

	public void setStrCounterName(String strCounterName) {
		this.strCounterName = strCounterName;
	}

	public String getStrMenuCode() {
		return strMenuCode;
	}

	public void setStrMenuCode(String strMenuCode) {
		this.strMenuCode = strMenuCode;
	}

	public String getStrMenuName() {
		return strMenuName;
	}

	public void setStrMenuName(String strMenuName) {
		this.strMenuName = strMenuName;
	}

	public double getDblRate() {
		return dblRate;
	}

	public void setDblRate(double dblRate) {
		this.dblRate = dblRate;
	}

	public double getDblQuantity() {
		return dblQuantity;
	}

	public void setDblQuantity(double dblQuantity) {
		this.dblQuantity = dblQuantity;
	}

	public double getDblAmount() {
		return dblAmount;
	}

	public void setDblAmount(double dblAmount) {
		this.dblAmount = dblAmount;
	}

	public String getStrGroupCode() {
		return strGroupCode;
	}

	public void setStrGroupCode(String strGroupCode) {
		this.strGroupCode = strGroupCode;
	}

	public String getStrGroupName() {
		return strGroupName;
	}

	public void setStrGroupName(String strGroupName) {
		this.strGroupName = strGroupName;
	}

	public String getStrSubGroupCode() {
		return strSubGroupCode;
	}

	public void setStrSubGroupCode(String strSubGroupCode) {
		this.strSubGroupCode = strSubGroupCode;
	}

	public String getStrSubGroupName() {
		return strSubGroupName;
	}

	public void setStrSubGroupName(String strSubGroupName) {
		this.strSubGroupName = strSubGroupName;
	}

	public String getStrOperational()
	{
		return strOperational;
	}

	public void setStrOperational(String strOperational)
	{
		this.strOperational = strOperational;
	}

	public String getStrUserCode()
	{
		return strUserCode;
	}

	public void setStrUserCode(String strUserCode)
	{
		this.strUserCode = strUserCode;
	}

	public String getStrPOSCode()
	{
		return strPOSCode;
	}

	public void setStrPOSCode(String strPOSCode)
	{
		this.strPOSCode = strPOSCode;
	}

	public List<clsPOSMenuHeadBean> getGetListMenuHeadDtl()
	{
		return getListMenuHeadDtl;
	}

	public void setGetListMenuHeadDtl(List<clsPOSMenuHeadBean> getListMenuHeadDtl)
	{
		this.getListMenuHeadDtl = getListMenuHeadDtl;
	}

	public String getStrClientCode()
	{
		return strClientCode;
	}

	public void setStrClientCode(String strClientCode)
	{
		this.strClientCode = strClientCode;
	}

	
}
