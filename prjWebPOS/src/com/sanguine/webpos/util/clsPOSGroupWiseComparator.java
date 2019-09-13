package com.sanguine.webpos.util;

import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

import com.sanguine.webpos.bean.clsPOSGroupSubGroupWiseSales;


public class clsPOSGroupWiseComparator  implements Comparator<clsPOSGroupSubGroupWiseSales> {

	 private List<Comparator<clsPOSGroupSubGroupWiseSales>> listComparators;

	    @SafeVarargs
	    public clsPOSGroupWiseComparator(Comparator<clsPOSGroupSubGroupWiseSales>... comparators)
	    {
	        this.listComparators = Arrays.asList(comparators);
	    }

	    @Override
	    public int compare(clsPOSGroupSubGroupWiseSales o1, clsPOSGroupSubGroupWiseSales o2)
	    {
	        for (Comparator<clsPOSGroupSubGroupWiseSales> comparator : listComparators)
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
