package com.sanguine.webpos.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.Table;

import org.hibernate.annotations.CollectionOfElements;
import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;

import com.sanguine.base.model.clsBaseModel;

@Entity
@Table(name="tblonlineorderhd")
@IdClass(clsOnlineOrderModel_ID.class)

public class clsOnlineOrderModelHd extends clsBaseModel implements Serializable{
	private static final long serialVersionUID = 1L;
	public clsOnlineOrderModelHd(){}

	public clsOnlineOrderModelHd(clsOnlineOrderModel_ID objModelID){
		strOrderId = objModelID.getStrOrderId();
		dtOrderDate = objModelID.getDtOrderDate();
		strClientCode = objModelID.getStrClientCode();
	}

	
	@CollectionOfElements(fetch=FetchType.EAGER)
    @JoinTable(name="tblonlineorderdtl" , joinColumns={@JoinColumn(name="dtOrderDate"),@JoinColumn(name="strClientCode"),@JoinColumn(name="strOrderId")})
	@Id
	@AttributeOverrides({
		@AttributeOverride(name="strOrderId",column=@Column(name="strOrderId")),
		@AttributeOverride(name="dtOrderDate",column=@Column(name="dtOrderDate")),
		@AttributeOverride(name="strClientCode",column=@Column(name="strClientCode")),
		
	})
	@Embedded
	@Fetch(FetchMode.SUBSELECT)
	private List<clsOnlineOrderDtlModel> listOnlineOrderDtlModel= new ArrayList<clsOnlineOrderDtlModel>();

	
	@CollectionOfElements(fetch=FetchType.EAGER)
    @JoinTable(name="tblonlineordermodifierdtl" , joinColumns={@JoinColumn(name="dtOrderDate"),@JoinColumn(name="strClientCode"),@JoinColumn(name="strOrderId")})
	@Id
	@AttributeOverrides({
		@AttributeOverride(name="strOrderId",column=@Column(name="strOrderId")),
		@AttributeOverride(name="dtOrderDate",column=@Column(name="dtOrderDate")),
		@AttributeOverride(name="strClientCode",column=@Column(name="strClientCode")),
		
	})
	@Embedded
	@Fetch(FetchMode.SUBSELECT)
	private List<clsOnlineOrderModifierDtlModel> listOnlineOrderModifierDtlModel= new ArrayList<clsOnlineOrderModifierDtlModel>();
	
	

	@CollectionOfElements(fetch=FetchType.EAGER)
    @JoinTable(name="tblonlineordertaxdtl" , joinColumns={@JoinColumn(name="dtOrderDate"),@JoinColumn(name="strClientCode"),@JoinColumn(name="strOrderId")})
	@Id
	@AttributeOverrides({
		
		@AttributeOverride(name="strOrderId",column=@Column(name="strOrderId")),
		@AttributeOverride(name="dtOrderDate",column=@Column(name="dtOrderDate")),
		@AttributeOverride(name="strClientCode",column=@Column(name="strClientCode"))
		
	})
	@Embedded
	@Fetch(FetchMode.SUBSELECT)
	private List<clsOnlineOrderTaxDtl> listOnlineOrderTaxDtl= new ArrayList<clsOnlineOrderTaxDtl>();
	
	
	@CollectionOfElements(fetch=FetchType.EAGER)
    @JoinTable(name="tblonlineordersettlement" , joinColumns={@JoinColumn(name="dtOrderDate"),@JoinColumn(name="strClientCode"),@JoinColumn(name="strOrderId")})
	@Id
	@AttributeOverrides({
		@AttributeOverride(name="dtOrderDate",column=@Column(name="dtOrderDate")),
		@AttributeOverride(name="strOrderId",column=@Column(name="strOrderId")),
		@AttributeOverride(name="strClientCode",column=@Column(name="strClientCode"))
		
		
	})
	@Embedded
	@Fetch(FetchMode.SUBSELECT)
	private List<clsOnlineOrderSettlementDtlModel> listOnlineOrderSettlementDtlModel= new ArrayList<clsOnlineOrderSettlementDtlModel>();
	
	
	@CollectionOfElements(fetch=FetchType.EAGER)
    @JoinTable(name="tblonlineorderdiscdtl" ,joinColumns={@JoinColumn(name="dtOrderDate"),@JoinColumn(name="strClientCode"),@JoinColumn(name="strOrderId")})
	@Id
	@AttributeOverrides({
		@AttributeOverride(name="dtOrderDate",column=@Column(name="dtOrderDate")),
		@AttributeOverride(name="strOrderId",column=@Column(name="strOrderId")),

		@AttributeOverride(name="strClientCode",column=@Column(name="strClientCode")),
		
	})
	@Embedded
	@Fetch(FetchMode.SUBSELECT)
	private List<clsOnlineOrderDiscDtlModel> listOnlineOrderDiscDtlModel= new ArrayList<clsOnlineOrderDiscDtlModel>();
	
	
	
//Variable Declaration
	@Column(name="strOrderId")
	private String strOrderId;

	@Column(name="strbiz_id")
	private String strbiz_id;

	
	@Column(name="strBillNo")
	private String strBillNo;
	
	@Column(name="dtOrderDate")
	private String dtOrderDate;
	
	@Column(name="strClientCode")
	private String strClientCode;

	@Column(name="delivery_datetime")
	private String delivery_datetime;
	
	@Column(name="channel")
	private String channel;
	
	@Column(name="order_state")
	private String order_state;
	
	@Column(name="order_type")
	private String order_type;
	
	@Column(name="state")
	private String state;
	
	@Column(name="discount")
	private double discount;
	
	@Column(name="order_subtotal")
	private double order_subtotal;
	
	@Column(name="order_total")
	private double order_total;
	
	@Column(name="total_external_discount")
	private double total_external_discount;
	
	
	@Column(name="item_level_total_charges")
	private double item_level_total_charges;
	
	@Column(name="item_level_total_taxes")
	private double item_level_total_taxes;
	
	@Column(name="item_taxes")
	private double item_taxes;
	
	@Column(name="order_level_total_charges")
	private double order_level_total_charges;
	
	@Column(name="order_level_total_taxes")
	private double order_level_total_taxes;
	
	@Column(name="total_charges")
	private double total_charges;
	
	@Column(name="total_taxes")
	private double total_taxes;
	
	@Column(name="coupon")
	private String coupon;
	
	@Column(name="instructions")
	private String instructions;
	
	@Column(name="orderMerchant_ref_id")
	private String orderMerchant_ref_id;
	
	
	
	@Column(name="next_state")
	private String next_state;
	
	@Column(name="storeId")
	private String storeId;
	
	@Column(name="storeName")
	private String storeName;
	/*
	 * @Column(name="storeMerchant_ref_id") private String storeMerchant_ref_id;
	 */
	@Column(name="custName")
	private String custName;
	
	@Column(name="custPhone")
	private String custPhone;
	
	@Column(name="custEmail")
	private String custEmail;
	
	@Column(name="custAddr1")
	private String custAddr1;
	
	@Column(name="custAddr2")
	private String custAddr2;
	
	@Column(name="custCity")
	private String custCity;
	
	
	
	
//Setter-Getter Methods
	public String getStrOrderId(){
		return strOrderId;
	}
	public void setStrOrderId(String strOrderId){
		this. strOrderId = (String) setDefaultValue( strOrderId, "NA");
	}

	public String getStrbiz_id(){
		return strbiz_id;
	}
	public void setStrbiz_id(String strbiz_id){
		this. strbiz_id = (String) setDefaultValue( strbiz_id, "NA");
	}

	public String getStrClientCode(){
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode){
		this. strClientCode = (String) setDefaultValue( strClientCode, "NA");
	}

	public String getStrBillNo(){
		return strBillNo;
	}
	public void setStrBillNo(String strBillNo){
		this. strBillNo = (String) setDefaultValue( strBillNo, "NA");
	}


	
	
public String getDtOrderDate()
	{
		return dtOrderDate;
	}

	public void setDtOrderDate(String dtOrderDate)
	{
		this.dtOrderDate = dtOrderDate;
	}

	public String getDelivery_datetime()
	{
		return delivery_datetime;
	}

	public void setDelivery_datetime(String delivery_datetime)
	{
		this.delivery_datetime = delivery_datetime;
	}

	public String getChannel()
	{
		return channel;
	}

	public void setChannel(String channel)
	{
		this.channel = channel;
	}

	public String getOrder_state()
	{
		return order_state;
	}

	public void setOrder_state(String order_state)
	{
		this.order_state = order_state;
	}

	public String getOrder_type()
	{
		return order_type;
	}

	public void setOrder_type(String order_type)
	{
		this.order_type = order_type;
	}

	public String getState()
	{
		return state;
	}

	public void setState(String state)
	{
		this.state = state;
	}

	public double getDiscount()
	{
		return discount;
	}

	public void setDiscount(double discount)
	{
		this.discount = discount;
	}

	public double getOrder_subtotal()
	{
		return order_subtotal;
	}

	public void setOrder_subtotal(double order_subtotal)
	{
		this.order_subtotal = order_subtotal;
	}

	public double getOrder_total()
	{
		return order_total;
	}

	public void setOrder_total(double order_total)
	{
		this.order_total = order_total;
	}

	public double getTotal_external_discount()
	{
		return total_external_discount;
	}

	public void setTotal_external_discount(double total_external_discount)
	{
		this.total_external_discount = total_external_discount;
	}

	public double getItem_level_total_charges()
	{
		return item_level_total_charges;
	}

	public void setItem_level_total_charges(double item_level_total_charges)
	{
		this.item_level_total_charges = item_level_total_charges;
	}

	public double getItem_level_total_taxes()
	{
		return item_level_total_taxes;
	}

	public void setItem_level_total_taxes(double item_level_total_taxes)
	{
		this.item_level_total_taxes = item_level_total_taxes;
	}

	public double getItem_taxes()
	{
		return item_taxes;
	}

	public void setItem_taxes(double item_taxes)
	{
		this.item_taxes = item_taxes;
	}

	public double getOrder_level_total_charges()
	{
		return order_level_total_charges;
	}

	public void setOrder_level_total_charges(double order_level_total_charges)
	{
		this.order_level_total_charges = order_level_total_charges;
	}

	public double getOrder_level_total_taxes()
	{
		return order_level_total_taxes;
	}

	public void setOrder_level_total_taxes(double order_level_total_taxes)
	{
		this.order_level_total_taxes = order_level_total_taxes;
	}

	public double getTotal_charges()
	{
		return total_charges;
	}

	public void setTotal_charges(double total_charges)
	{
		this.total_charges = total_charges;
	}

	public double getTotal_taxes()
	{
		return total_taxes;
	}

	public void setTotal_taxes(double total_taxes)
	{
		this.total_taxes = total_taxes;
	}

	public String getCoupon()
	{
		return coupon;
	}

	public void setCoupon(String coupon)
	{
		this.coupon = coupon;
	}

	public String getInstructions()
	{
		return instructions;
	}

	public void setInstructions(String instructions)
	{
		this.instructions = instructions;
	}

	public String getOrderMerchant_ref_id()
	{
		return orderMerchant_ref_id;
	}

	public void setOrderMerchant_ref_id(String orderMerchant_ref_id)
	{
		this.orderMerchant_ref_id = orderMerchant_ref_id;
	}

	public String getNext_state()
	{
		return next_state;
	}

	public void setNext_state(String next_state)
	{
		this.next_state = next_state;
	}

	public String getStoreId()
	{
		return storeId;
	}

	public void setStoreId(String storeId)
	{
		this.storeId = storeId;
	}

	public String getStoreName()
	{
		return storeName;
	}

	public void setStoreName(String storeName)
	{
		this.storeName = storeName;
	}


	public String getCustName()
	{
		return custName;
	}

	public void setCustName(String custName)
	{
		this.custName = custName;
	}

	public String getCustPhone()
	{
		return custPhone;
	}

	public void setCustPhone(String custPhone)
	{
		this.custPhone = custPhone;
	}

	public String getCustEmail()
	{
		return custEmail;
	}

	public void setCustEmail(String custEmail)
	{
		this.custEmail = custEmail;
	}

	public String getCustAddr1()
	{
		return custAddr1;
	}

	public void setCustAddr1(String custAddr1)
	{
		this.custAddr1 = custAddr1;
	}

	public String getCustAddr2()
	{
		return custAddr2;
	}

	public void setCustAddr2(String custAddr2)
	{
		this.custAddr2 = custAddr2;
	}

	public String getCustCity()
	{
		return custCity;
	}

	public void setCustCity(String custCity)
	{
		this.custCity = custCity;
	}

	//Function to Set Default Values
	
	public List<clsOnlineOrderDtlModel> getListOnlineOrderDtlModel()
	{
		return listOnlineOrderDtlModel;
	}

	public void setListOnlineOrderDtlModel(List<clsOnlineOrderDtlModel> listOnlineOrderDtlModel)
	{
		this.listOnlineOrderDtlModel = listOnlineOrderDtlModel;
	}

	public List<clsOnlineOrderModifierDtlModel> getListOnlineOrderModifierDtlModel()
	{
		return listOnlineOrderModifierDtlModel;
	}

	public void setListOnlineOrderModifierDtlModel(List<clsOnlineOrderModifierDtlModel> listOnlineOrderModifierDtlModel)
	{
		this.listOnlineOrderModifierDtlModel = listOnlineOrderModifierDtlModel;
	}

	public List<clsOnlineOrderTaxDtl> getListOnlineOrderTaxDtl()
	{
		return listOnlineOrderTaxDtl;
	}

	public void setListOnlineOrderTaxDtl(List<clsOnlineOrderTaxDtl> listOnlineOrderTaxDtl)
	{
		this.listOnlineOrderTaxDtl = listOnlineOrderTaxDtl;
	}

	public List<clsOnlineOrderSettlementDtlModel> getListOnlineOrderSettlementDtlModel()
	{
		return listOnlineOrderSettlementDtlModel;
	}

	public void setListOnlineOrderSettlementDtlModel(List<clsOnlineOrderSettlementDtlModel> listOnlineOrderSettlementDtlModel)
	{
		this.listOnlineOrderSettlementDtlModel = listOnlineOrderSettlementDtlModel;
	}

	public List<clsOnlineOrderDiscDtlModel> getListOnlineOrderDiscDtlModel()
	{
		return listOnlineOrderDiscDtlModel;
	}

	public void setListOnlineOrderDiscDtlModel(List<clsOnlineOrderDiscDtlModel> listOnlineOrderDiscDtlModel)
	{
		this.listOnlineOrderDiscDtlModel = listOnlineOrderDiscDtlModel;
	}

}
