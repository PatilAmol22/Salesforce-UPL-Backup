/*
* Name: BrazilOrderPushService
* Created On: 23 October 2017
* Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com)
* Description: Wrapper Class for Brazil Order Push to HANA Service using REST API.
* Supporting Class: BrazilPushSalesOrderService_Test (Test Class)
*/
public class BrazilPushSalesOrderService{
    public cls_ImportHeaders ImportHeaders;
    public cls_Tables Tables;
    
    public class cls_ImportHeaders {
        public cls_ORDER_HEADER_IN ORDER_HEADER_IN;
    }
    
    public class cls_ORDER_HEADER_IN {
        public String SAP_USER; //20004518
        public String DOC_TYPE; //ZORB
        public Integer SALES_ORG;   //5191
        public Integer DISTR_CHAN;  //20
        public String DIVISION;    //10
        public String SALES_OFF;    //BR20
        public String PURCH_DATE;   //2017-06-21
        public String REF_1;    //000000025886
        public String SALES_DIST;   //BR2006
        public String INCOTERMS1;   //CFR
        public String INCOTERMS2;   //.
        public String PMNTTRMS; //0014
        public String CT_VALID_F;   //2017-06-22
        public String CT_VALID_T;   //2018-03-31
        public String CUST_GRP1;    //229
        public String CUST_GRP2;    //BR2
        public String PURCH_NO_C;   //899990
        public String SD_DOC_CAT;   //C
        public String DOC_DATE; //2017-09-25
        public String PYMT_METH;    //Q
        public String CURRENCY_VALUE;   //BRL
        public String FIX_VAL_DY;   //2018-03-20
        public String PO_METHOD;   //OVPT
        
    }
    
    public class cls_Tables {
        public cls_ORDER_CONDITIONS_IN ORDER_CONDITIONS_IN;
        public cls_ORDER_ITEMS_IN ORDER_ITEMS_IN;
        public cls_ORDER_PARTNERS ORDER_PARTNERS;
        public cls_ORDER_TEXT ORDER_TEXT;
    }
    
    public class cls_ORDER_CONDITIONS_IN {
        public cls_row_conditions[] row_conditions;
    }
    
    public class cls_row_conditions {
        public String ITM_NUMBER;   //000000
        public String COND_TYPE;    //ZBRD
        public String COND_VALUE;   //0.000000000
        public String CURRENCY_VALUE;   //USD
    }
    
    public class cls_ORDER_ITEMS_IN {
        public cls_row_items[] row_items;
    }
    
    public class cls_row_items {
        public String ITM_NUMBER;   //000010
        public String MATERIAL; //000000000006250007
        public String BILL_DATE;    //2017-06-27
        public String PLANT;    //BR05
        public Decimal TARGET_QTY;  //90
        public String TARGET_QU;    //L
        public String PO_DAT_S; //2017-06-27
        public String USAGE_IND;    //B01
        public String PO_ITM_NO; //123   //Deeksha :SCTASK0216504
        public Decimal HG_LV_ITEM; //Modified by Deeksha for kit selling Project
        public String ITEM_CATEG;//Modified by Deeksha for kit selling Project
    }
    
    public class cls_ORDER_PARTNERS {
        public cls_row_partners[] row_partners;
    }
    
    public class cls_row_partners {
        public String PARTN_ROLE;   //AG
        public String PARTN_NUMB;   //0001033267
    }
    
    public class cls_ORDER_TEXT {
        public cls_row_text[] row_text;
    }
    
    public class cls_row_text {
        public String ITM_NUMBER;   //000000
        public String TEXT_ID;  //0001
        public String LANGU;    //P
        public String TEXT_LINE;    //xyz
    }
    
    public static BrazilPushSalesOrderService parse(String json){
        return (BrazilPushSalesOrderService) System.JSON.deserialize(json, BrazilPushSalesOrderService.class);
    }
}