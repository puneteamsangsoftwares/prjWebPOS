package com.sanguine.webpos.bean;

public class clsPOSTaxCalculationBean {

	
	  private String taxCode;
	    private String taxName;
	    private String taxCalculationType;
	    private double taxableAmount;
	    private double taxAmount;
	    private String strPOSCode;
	    private String strPOSName;
	    private double dblGrandTotal;
	    private String strTaxDesc;
	    private String dteBillDate;
	    private String strBillNo;
	    
	    private String strTaxOnTaxCode;
	    
	    private String isTaxOnTax;
	    
	    private String strTOTOnSubTotal;
	    
		public String getTaxCode() {
			return taxCode;
		}
		public void setTaxCode(String taxCode) {
			this.taxCode = taxCode;
		}
		public String getTaxName() {
			return taxName;
		}
		public void setTaxName(String taxName) {
			this.taxName = taxName;
		}
		public String getTaxCalculationType() {
			return taxCalculationType;
		}
		public void setTaxCalculationType(String taxCalculationType) {
			this.taxCalculationType = taxCalculationType;
		}
		public double getTaxableAmount() {
			return taxableAmount;
		}
		public void setTaxableAmount(double taxableAmount) {
			this.taxableAmount = taxableAmount;
		}
		public double getTaxAmount() {
			return taxAmount;
		}
		public void setTaxAmount(double taxAmount) {
			this.taxAmount = taxAmount;
		}
		public String getStrPOSCode() {
			return strPOSCode;
		}
		public void setStrPOSCode(String strPOSCode) {
			this.strPOSCode = strPOSCode;
		}
		public String getStrPOSName() {
			return strPOSName;
		}
		public void setStrPOSName(String strPOSName) {
			this.strPOSName = strPOSName;
		}
		public double getDblGrandTotal() {
			return dblGrandTotal;
		}
		public void setDblGrandTotal(double dblGrandTotal) {
			this.dblGrandTotal = dblGrandTotal;
		}
		public String getStrTaxDesc() {
			return strTaxDesc;
		}
		public void setStrTaxDesc(String strTaxDesc) {
			this.strTaxDesc = strTaxDesc;
		}
		public String getDteBillDate() {
			return dteBillDate;
		}
		public void setDteBillDate(String dteBillDate) {
			this.dteBillDate = dteBillDate;
		}
		public String getStrBillNo() {
			return strBillNo;
		}
		public void setStrBillNo(String strBillNo) {
			this.strBillNo = strBillNo;
		}
		public String getStrTaxOnTaxCode()
		{
			return strTaxOnTaxCode;
		}
		public void setStrTaxOnTaxCode(String strTaxOnTaxCode)
		{
			this.strTaxOnTaxCode = strTaxOnTaxCode;
		}
		public String getIsTaxOnTax()
		{
			return isTaxOnTax;
		}
		public void setIsTaxOnTax(String isTaxOnTax)
		{
			this.isTaxOnTax = isTaxOnTax;
		}
		public String getStrTOTOnSubTotal()
		{
			return strTOTOnSubTotal;
		}
		public void setStrTOTOnSubTotal(String strTOTOnSubTotal)
		{
			this.strTOTOnSubTotal = strTOTOnSubTotal;
		}
	    
	    
}
