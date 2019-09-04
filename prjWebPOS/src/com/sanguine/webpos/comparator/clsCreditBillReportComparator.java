package com.sanguine.webpos.comparator;
import com.sanguine.webpos.bean.clsPOSBillDtl;

import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

public class clsCreditBillReportComparator implements Comparator<clsPOSBillDtl>
{

	private List<Comparator<clsPOSBillDtl>> listComparators;
   @SafeVarargs
	public clsCreditBillReportComparator(Comparator<clsPOSBillDtl>... comparators)
    {
        this.listComparators = Arrays.asList(comparators);
    }
	 @Override
	    public int compare(clsPOSBillDtl o1, clsPOSBillDtl o2)
	    {
	        for (Comparator<clsPOSBillDtl> comparator : listComparators)
	        {
	            int result = comparator.compare(o1, o2);
	            if (result != 0)
	            {
	                return result;
	            }
	        }
	        return 0;
	    }
}
