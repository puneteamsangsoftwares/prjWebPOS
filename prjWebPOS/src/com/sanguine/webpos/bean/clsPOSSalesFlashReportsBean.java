package com.sanguine.webpos.bean;

import java.util.Comparator;

public class clsPOSSalesFlashReportsBean
{

	private String strField1;

	private String strField2;

	private String strField3;

	private String strField4;

	private String strField5;

	private String strField6;

	private String strField7;

	private String strField8;

	private String strField9;

	private String strField10;

	private String strField11;

	private String strField12;

	private String strField13;

	private String strField14;

	private String strField15;

	private String strField16;

	private String strField17;
	private String strField18;
	private String strField19;
	private String strField20;
	private String strField21;

	private String strField22; 
	private double strField23; 
	private String totalDiscAmt;

	private String totalSubTotal;

	private String totalTaxAmt;

	private String totalSettleAmt;

	private String totalTipAmt;

	private String totalQuantity;

	private String totalAmount;
	private String totalAdvAmt;

	private String totalRoundOffAmt;

	private String totalPAX;

	private int seqNo;
	
	private String mobileNo;
	
	private String dob;
	
	private String noOfBills;
	
	

	public String getNoOfBills()
	{
		return noOfBills;
	}

	public void setNoOfBills(String noOfBills)
	{
		this.noOfBills = noOfBills;
	}

	public String getMobileNo()
	{
		return mobileNo;
	}

	public void setMobileNo(String mobileNo)
	{
		this.mobileNo = mobileNo;
	}

	public String getDob()
	{
		return dob;
	}

	public void setDob(String dob)
	{
		this.dob = dob;
	}

	public String getStrField1()
	{
		return strField1;
	}

	public void setStrField1(String strField1)
	{
		this.strField1 = strField1;
	}

	public String getStrField2()
	{
		return strField2;
	}

	public void setStrField2(String strField2)
	{
		this.strField2 = strField2;
	}

	public String getStrField3()
	{
		return strField3;
	}

	public void setStrField3(String string)
	{
		this.strField3 = string;
	}

	public String getStrField4()
	{
		return strField4;
	}

	public void setStrField4(String strField4)
	{
		this.strField4 = strField4;
	}

	public String getStrField5()
	{
		return strField5;
	}

	public void setStrField5(String strField5)
	{
		this.strField5 = strField5;
	}

	public String getStrField6()
	{
		return strField6;
	}

	public void setStrField6(String strField6)
	{
		this.strField6 = strField6;
	}

	public String getStrField7()
	{
		return strField7;
	}

	public int getSeqNo()
	{
		return seqNo;
	}

	public void setSeqNo(int seqNo)
	{
		this.seqNo = seqNo;
	}

	public static Comparator<clsPOSSalesFlashReportsBean> getComparatorSalesFlashColumnDtl()
	{
		return comparatorSalesFlashColumnDtl;
	}

	public static void setComparatorSalesFlashColumnDtl(Comparator<clsPOSSalesFlashReportsBean> comparatorSalesFlashColumnDtl)
	{
		clsPOSSalesFlashReportsBean.comparatorSalesFlashColumnDtl = comparatorSalesFlashColumnDtl;
	}

	public void setStrField7(String strField7)
	{
		this.strField7 = strField7;
	}

	public String getStrField8()
	{
		return strField8;
	}

	public void setStrField8(String strField8)
	{
		this.strField8 = strField8;
	}

	public String getStrField9()
	{
		return strField9;
	}

	public void setStrField9(String strField9)
	{
		this.strField9 = strField9;
	}

	public String getStrField10()
	{
		return strField10;
	}

	public void setStrField10(String strField10)
	{
		this.strField10 = strField10;
	}

	public String getStrField11()
	{
		return strField11;
	}

	public void setStrField11(String strField11)
	{
		this.strField11 = strField11;
	}

	public String getStrField12()
	{
		return strField12;
	}

	public void setStrField12(String strField12)
	{
		this.strField12 = strField12;
	}

	public String getStrField13()
	{
		return strField13;
	}

	public void setStrField13(String strField13)
	{
		this.strField13 = strField13;
	}

	public String getStrField14()
	{
		return strField14;
	}

	public void setStrField14(String strField14)
	{
		this.strField14 = strField14;
	}

	public String getStrField15()
	{
		return strField15;
	}

	public void setStrField15(String strField15)
	{
		this.strField15 = strField15;
	}

	public String getStrField16()
	{
		return strField16;
	}

	public void setStrField16(String strField16)
	{
		this.strField16 = strField16;
	}

	public String getStrField17()
	{
		return strField17;
	}

	public void setStrField17(String strField17)
	{
		this.strField17 = strField17;
	}

	public static Comparator<clsPOSSalesFlashReportsBean> comparatorSalesFlashColumnDtl = new Comparator<clsPOSSalesFlashReportsBean>()
	{
		public int compare(clsPOSSalesFlashReportsBean s1, clsPOSSalesFlashReportsBean s2)
		{
			int seqNo1 = s1.getSeqNo();
			int seqNo2 = s2.getSeqNo();

			if (seqNo1 == seqNo2)
			{
				return 0;
			}
			else if (seqNo1 < seqNo2)
			{
				return 1;
			}
			else
			{
				return -1;
			}
		}
	};

	public String getTotalDiscAmt()
	{
		return totalDiscAmt;
	}

	public void setTotalDiscAmt(String totalDiscAmt)
	{
		this.totalDiscAmt = totalDiscAmt;
	}

	public String getTotalSubTotal()
	{
		return totalSubTotal;
	}

	public void setTotalSubTotal(String totalSubTotal)
	{
		this.totalSubTotal = totalSubTotal;
	}

	public String getTotalTaxAmt()
	{
		return totalTaxAmt;
	}

	public void setTotalTaxAmt(String totalTaxAmt)
	{
		this.totalTaxAmt = totalTaxAmt;
	}

	public String getTotalSettleAmt()
	{
		return totalSettleAmt;
	}

	public void setTotalSettleAmt(String totalSettleAmt)
	{
		this.totalSettleAmt = totalSettleAmt;
	}

	public String getTotalTipAmt()
	{
		return totalTipAmt;
	}

	public void setTotalTipAmt(String totalTipAmt)
	{
		this.totalTipAmt = totalTipAmt;
	}

	public String getTotalQuantity()
	{
		return totalQuantity;
	}

	public void setTotalQuantity(String totalQuantity)
	{
		this.totalQuantity = totalQuantity;
	}

	public String getTotalAmount()
	{
		return totalAmount;
	}

	public void setTotalAmount(String totalAmount)
	{
		this.totalAmount = totalAmount;
	}

	public String getTotalAdvAmt()
	{
		return totalAdvAmt;
	}

	public void setTotalAdvAmt(String totalAdvAmt)
	{
		this.totalAdvAmt = totalAdvAmt;
	}

	public String getTotalRoundOffAmt()
	{
		return totalRoundOffAmt;
	}

	public void setTotalRoundOffAmt(String totalRoundOffAmt)
	{
		this.totalRoundOffAmt = totalRoundOffAmt;
	}

	public String getTotalPAX()
	{
		return totalPAX;
	}

	public void setTotalPAX(String totalPAX)
	{
		this.totalPAX = totalPAX;
	}

	public String getStrField18()
	{
		return strField18;
	}

	public void setStrField18(String strField18)
	{
		this.strField18 = strField18;
	}

	public String getStrField19()
	{
		return strField19;
	}

	public void setStrField19(String strField19)
	{
		this.strField19 = strField19;
	}

	public String getStrField20()
	{
		return strField20;
	}

	public void setStrField20(String strField20)
	{
		this.strField20 = strField20;
	}

	public String getStrField21()
	{
		return strField21;
	}

	public void setStrField21(String strField21)
	{
		this.strField21 = strField21;
	}

	public String getStrField22()
	{
		return strField22;
	}

	public void setStrField22(String string)
	{
		this.strField22 = string;
	}

	public double getStrField23()
	{
		return strField23;
	}

	public void setStrField23(double strField23)
	{
		this.strField23 = strField23;
	}

	
	
	
}
