package com.sanguine.webpos.bean;

public class clsHourlyItemWiseReportBean
{
	 String strHourTime;
	    String strItemName;
	    Double dblQuantity;
	    Double dblAmount;
		public String getStrHourTime()
		{
			return strHourTime;
		}
		public void setStrHourTime(String strHourTime)
		{
			this.strHourTime = strHourTime;
		}
		public String getStrItemName()
		{
			return strItemName;
		}
		public void setStrItemName(String strItemName)
		{
			this.strItemName = strItemName;
		}
		public Double getDblQuantity()
		{
			return dblQuantity;
		}
		public void setDblQuantity(Double dblQuantity)
		{
			this.dblQuantity = dblQuantity;
		}
		public Double getDblAmount()
		{
			return dblAmount;
		}
		public void setDblAmount(Double dblAmount)
		{
			this.dblAmount = dblAmount;
		}
	    
}
