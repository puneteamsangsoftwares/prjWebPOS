package com.sanguine.webpos.bean;

public class clsPOSGetPromotionItemDtl
{
	  private String itemCode;
	    
	    private double getPromoItemQty;
	    
	    private double totalItemQty;
	    
	    private double totalAmount;
	    
	    private double   DblGetQty;
	    private double   DblDiscount;
	  private String  StrPromoItemCode;
	  private String  StrDiscountType;
	  private String strPromotionOn;
	    

	    public String getItemCode() {
	        return itemCode;
	    }

	    public void setItemCode(String itemCode) {
	        this.itemCode = itemCode;
	    }

	    public double getGetPromoItemQty() {
	        return getPromoItemQty;
	    }

	    public void setGetPromoItemQty(double getPromoItemQty) {
	        this.getPromoItemQty = getPromoItemQty;
	    }

	    public double getTotalItemQty() {
	        return totalItemQty;
	    }

	    public void setTotalItemQty(double totalItemQty) {
	        this.totalItemQty = totalItemQty;
	    }

	    public double getTotalAmount() {
	        return totalAmount;
	    }

	    public void setTotalAmount(double totalAmount) {
	        this.totalAmount = totalAmount;
	    }

		public double getDblGetQty()
		{
			return DblGetQty;
		}

		public void setDblGetQty(double dblGetQty)
		{
			DblGetQty = dblGetQty;
		}

		public double getDblDiscount()
		{
			return DblDiscount;
		}

		public void setDblDiscount(double dblDiscount)
		{
			DblDiscount = dblDiscount;
		}

		public String getStrPromoItemCode()
		{
			return StrPromoItemCode;
		}

		public void setStrPromoItemCode(String strPromoItemCode)
		{
			StrPromoItemCode = strPromoItemCode;
		}

		public String getStrDiscountType()
		{
			return StrDiscountType;
		}

		public void setStrDiscountType(String strDiscountType)
		{
			StrDiscountType = strDiscountType;
		}

		public String getStrPromotionOn()
		{
			return strPromotionOn;
		}

		public void setStrPromotionOn(String strPromotionOn)
		{
			this.strPromotionOn = strPromotionOn;
		}

}
