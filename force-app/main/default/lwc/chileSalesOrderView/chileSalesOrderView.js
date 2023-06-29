import { LightningElement,api,track,wire } from 'lwc';
import getSalesOrderDetails from "@salesforce/apex/SalesOrderDetails.getSalesOrderDetails";
import getSOLIDetails from "@salesforce/apex/SalesOrderDetails.getSOLIDetails";
import getLastApproverComment from '@salesforce/apex/SalesOrderDetails.getLastApproverComment';
import Sales_Order_Number from '@salesforce/label/c.Sales_Order_Number';
import Distributor_Name from '@salesforce/label/c.Distributor_Name';
import Total_Order_Value from '@salesforce/label/c.Total_Order_Value';
import Order_Status from '@salesforce/label/c.Order_Status';
import Payment_Term from '@salesforce/label/c.Payment_Term';
import Order_Type from '@salesforce/label/c.Order_Type';
import Remarks from '@salesforce/label/c.Remarks';
import Last_Approver_Comment from '@salesforce/label/c.Last_Approver_Comment';
import MG_Desc from '@salesforce/label/c.MG_Desc';
import Brand_Name from '@salesforce/label/c.Brand_Name';
import SKU_Description from '@salesforce/label/c.SKU_Description';
import Min_Price_Ltr_Kg from '@salesforce/label/c.Min_Price_Ltr_Kg';
import List_Price_Ltr_Kg from '@salesforce/label/c.List_Price_Ltr_Kg';
import Base_UOM from '@salesforce/label/c.Base_UOM';
import Base_UOM_Qty from '@salesforce/label/c.Base_UOM_Qty';
import Currency from '@salesforce/label/c.Currency';
import Net_Price from '@salesforce/label/c.Net_Price';
import Overall_Margin from '@salesforce/label/c.Overall_Margin';
import Near_Expiry_Exception_SKU from '@salesforce/label/c.Near_Expiry_Exception_SKU';
import Promotion_Free_goods_Bonification from '@salesforce/label/c.Promotion_Free_goods_Bonification';
import Contribution_Margin from '@salesforce/label/c.Contribution_Margin';
import Final_Price from '@salesforce/label/c.Final_Price';
import Max_Price from '@salesforce/label/c.Max_Price';
import PLN_Price from '@salesforce/label/c.PLN_Price';
import Quantity from '@salesforce/label/c.Quantity';
import SKU_Code from '@salesforce/label/c.SKU_Code';
import Reason from '@salesforce/label/c.Reason';
import Payment_Method from '@salesforce/label/c.Payment_Method';
import Inco_Term from '@salesforce/label/c.Inco_Term';





//CR#174 -Chile Margin Block Edit Order- SKI- Satish Tiware -  03/12/2022  Here 



export default class ChileSalesOrderView extends LightningElement {


    @api recordId;
    @track salesOrderData={SalesOrderNo:'',DistributorName:'',TotalAmount:'',
                           OrderStatus:'',PaymentTerm:'',OrderType:'',Remark:'',
                          ShippingLoc:'',PaymentMethod:'',IncoTerm:'',DiscountPer:'',
                          GrossMarginPer:'',IsPaymentTerm:'',SentForLatam:'',SentForCCO:'',
                          Currency:''};
    @track soliData;
    @track marginLevel;
		@track overAllMargine;
    @track lastApproverComment;
		@track isCOO;
    @track Promo;
    @track reason='';



    label={
      Sales_Order_Number:Sales_Order_Number,
      Distributor_Name:Distributor_Name,
      Total_Order_Value:Total_Order_Value,
      Overall_Margin:Overall_Margin,
      Order_Status:Order_Status,
      Payment_Term:Payment_Term,
      Order_Type:Order_Type,
      Remarks:Remarks,
      Last_Approver_Comment:Last_Approver_Comment,
      MG_Desc:MG_Desc,
      Brand_Name:Brand_Name,
      SKU_Description:SKU_Description,
      Min_Price_Ltr_Kg:Min_Price_Ltr_Kg,
      List_Price_Ltr_Kg:List_Price_Ltr_Kg,
      Base_UOM:Base_UOM,
      Base_UOM_Qty:Base_UOM_Qty,
      Currency:Currency,
      Net_Price:Net_Price,
      Near_Expiry_Exception_SKU:Near_Expiry_Exception_SKU,
      Promotion_Free_goods_Bonification:Promotion_Free_goods_Bonification,
      Contribution_Margin:Contribution_Margin,
      Final_Price:Final_Price,
      Max_Price:Max_Price,
      PLN_Price:PLN_Price,
      Quantity:Quantity,
      SKU_Code:SKU_Code,
      Reason:Reason,
      Payment_Method:Payment_Method,
      Inco_Term:Inco_Term
    }


 

    connectedCallback() {
      

     getSalesOrderDetails({recordId:this.recordId}
      ).then((result)=> {
        console.log('SalesorderData ',JSON.stringify(result));
        let txt ='';

          if (result.Discount_Percentage__c>=5 && result.Discount_Percentage__c<=10){
          txt = txt + ' Discount,'
          }
          if(result.Is_payment_Term_Changed__c){
          txt = txt + ' Payment Term,'
          }
          if(result.Gross_Margin_Percent__c>=20){
            txt = txt + ' Gross Margin,'
          }
          if(result.Sent_for_Latam_Director__c || result.Sent_for_CCO__c){
            txt = txt + ' Margin Block,'
          }

          console.log(' ## text value ',txt);
   
        this.reason = txt.slice(0, -1);

        


        this.salesOrderData = JSON.parse(JSON.stringify(result));
        this.salesOrderData.SalesOrderNo=result.Name;
        this.salesOrderData.DistributorName=result.Sold_to_Party__r.Name;
        this.salesOrderData.TotalAmount=Number(result.Total_Amount__c).toFixed(2);
        this.salesOrderData.OrderStatus=result.Order_Status__c;
        this.salesOrderData.PaymentTerm=result.Payment_Term__r?.Payment_Term__c;
        this.salesOrderData.OrderType=result.OrderTypeCode__c;
        this.salesOrderData.Remark = result.Remarks_Long__c;
        this.salesOrderData.ShippingLoc=result.Ship_To_Party__r?.Location_Name__c;
        console.log('Shipping Location',result.Ship_To_Party__r?.Location_Name__c);
        this.salesOrderData.PaymentMethod=result.PaymentMethod__r?.Description__c;
        this.salesOrderData.IncoTerm=result.Inco_Term_Mexico__c;
        this.salesOrderData.DiscountPer=result.Discount_Percentage__c;
        this.salesOrderData.GrossMarginPer=result.Gross_Margin_Percent__c;
        this.salesOrderData.IsPaymentTerm=result.Is_payment_Term_Changed__c;
        this.salesOrderData.SentForLatam=result.Sent_for_Latam_Director__c;
        this.salesOrderData.SentForCCO=result.Sent_for_CCO__c;
        this.salesOrderData.Currency=result.CurrencyISOCode;

      })
      .catch(error=>{
        console.log('Error occure ',error);
      });


      getSOLIDetails({recordId:this.recordId}
        ).then((result)=> {
          console.log('SoliData ',JSON.stringify(result));
          this.soliData = result.wrpaSaleOrder;
					this.overAllMargine =result.overAllMargin;
          this.marginLevel =result.marginBlockLevel;
					console.log('result.isCOO ',result.isCOO);
					this.isCOO =result.isCOO;
          this.Promo =result.PromoGood;
          console.log('Promo',this.Promo);
          
          console.log('Soli Data',this.soliData);
          
          
        })
        .catch(error=>{
          console.log('Error occure ',error);
        });

        getLastApproverComment({recordId:this.recordId}
          ).then((result)=> {
            console.log('Comment ',JSON.stringify(result));
            this.lastApproverComment = result;

            // this.lastApproverComment.Comment=result.Comments;
            // console.log('fsasdfd',this.lastApproverComment.Comment);
          })
          .catch(error=>{
            console.log('Error occure ',error);
          });

    }
}
//CR#174 -Chile Margin Block Edit Order- SKI- Satish Tiware -  03/12/2022 End Here