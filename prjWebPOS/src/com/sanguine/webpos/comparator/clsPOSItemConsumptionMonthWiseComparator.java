package com.sanguine.webpos.comparator;
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

import com.sanguine.webpos.bean.clsPOSItemConsumptionMonthWiseBean;
/**
 *
 * @author Satyajit
 */

public class clsPOSItemConsumptionMonthWiseComparator implements Comparator<clsPOSItemConsumptionMonthWiseBean>
{
												
    private List<Comparator<clsPOSItemConsumptionMonthWiseBean>> listComparators;

    @SafeVarargs
    public clsPOSItemConsumptionMonthWiseComparator(Comparator<clsPOSItemConsumptionMonthWiseBean>... comparators)
    {
        this.listComparators = Arrays.asList(comparators);
    }

    @Override
    public int compare(clsPOSItemConsumptionMonthWiseBean o1, clsPOSItemConsumptionMonthWiseBean o2)
    {
        for (Comparator<clsPOSItemConsumptionMonthWiseBean> comparator : listComparators)
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
