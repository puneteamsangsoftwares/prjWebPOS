package com.sanguine.webpos.printing;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.sanguine.base.service.intfBaseService;

@Controller
public class clsPOSJasperGenerator
{
	@Autowired
	intfBaseService objBaseService;

	@Autowired
	clsPOSJasperFormat1ForBill objJasper1;

	@Autowired
	clsPOSJasperFormat2ForBill objJasper2;

	@Autowired
	clsPOSJasperFormat3ForBill objJasper3;

	@Autowired
	clsPOSJasperFormat4ForBill objJasper4;

	@Autowired
	clsPOSJasperFormat5ForBill objJasper5;

	@Autowired
	clsPOSJasperFormat7ForBill objJasper7;

	@Autowired
	clsPOSJasperFormat8ForBill objJasper8;

	@Autowired
	clsPOSJasperFormat6ForBill objJasper6;

	@Autowired
	clsPOSJasperFormat11ForBill objJasper11;

	StringBuilder sql = new StringBuilder();

	@RequestMapping(value="/getBillPrint",method=RequestMethod.GET)
	public void funCallBillPrint(@RequestParam("voucherNo")String vaoucherNo,HttpServletRequest request,HttpServletResponse response){
		
		try{
			String clientCode = request.getSession().getAttribute("gClientCode").toString();
			String posCode = request.getSession().getAttribute("loginPOS").toString();
			String userCode = request.getSession().getAttribute("gUserCode").toString();
			String posDate = request.getSession().getAttribute("gPOSDate").toString().split(" ")[0];
			
			response=funGenerateBill(vaoucherNo, "N", "DirectBiller",posCode,  posDate, clientCode, "",true,response);
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		//return vaoucherNo;
	}
	
	public HttpServletResponse funGenerateBill(String billNo, String reprint, String transactionType, String posCode, String strBillDate, String clientCode, String strBillPrinterPort, boolean isOriginal,HttpServletResponse response) throws Exception
	{
		String billFormat = "";
		sql.setLength(0);
		sql.append("select a.strBillFormatType,a.strMultipleBillPrinting from tblsetup a where a.strClientCode='"+clientCode+"' and a.strPOSCode='"+posCode+"'; ");
		List list = objBaseService.funGetList(sql, "sql");
		if (list.size() > 0)
		{
			for (int i = 0; i < list.size(); i++)
			{
				Object[] obj = (Object[]) list.get(i);
				billFormat = obj[0].toString();
				reprint = obj[1].toString();
			}
		}
		switch (billFormat)
		{
			case "Jasper 1":
				objJasper1.funGenerateBill(billNo, reprint, transactionType, posCode, strBillDate, clientCode, strBillPrinterPort, false);
				break;
			case "Jasper 2":
				objJasper2.funGenerateBill(billNo, reprint, transactionType, posCode, strBillDate, clientCode, strBillPrinterPort, false);
				break;
	
			case "Jasper 3":
				objJasper3.funGenerateBill(billNo, reprint, transactionType, posCode, strBillDate, clientCode, strBillPrinterPort, false);
				break;
	
			case "Jasper 4":
				objJasper4.funGenerateBill(billNo, reprint, transactionType, posCode, strBillDate, clientCode, strBillPrinterPort, false);
				break;
	
			case "Jasper 5":
				response=objJasper5.funGenerateBill(billNo, reprint, transactionType, posCode, strBillDate, clientCode, strBillPrinterPort, false,response);
				break;
	
			case "Jasper 6":
	
				objJasper6.funGenerateBill(billNo, reprint, transactionType, posCode, strBillDate, clientCode, strBillPrinterPort, false);
				break;
	
			case "Jasper 7":
				objJasper7.funGenerateBill(billNo, reprint, transactionType, posCode, strBillDate, clientCode, strBillPrinterPort, false);
				break;
	
			case "Jasper 11":
				objJasper11.funGenerateBill(billNo, reprint, transactionType, posCode, strBillDate, clientCode, strBillPrinterPort, false);
				break;
		}
		return response;	
	}
}
