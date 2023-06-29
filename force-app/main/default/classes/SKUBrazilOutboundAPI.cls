/* Name: SKUBrazilOutboundAPI
/Author: Wipro
/Description: on Sales Order View this API will Call & will update line item data (SKU, Billed Quantity and Unbilled Quantity)
/Brazil Price2Win Phase 2 User Story: SO-006
*/

public class SKUBrazilOutboundAPI {
    //@future(callout=true)
    Public static void SKUUpdate(String soId,datetime fromdate,datetime todate){
        
        String username = UPL_Settings__c.getOrgDefaults().Price2Win_Oauth_Username__c;
        String password = UPL_Settings__c.getOrgDefaults().Price2Win_Oauth_Passward__c; 
        String tokenacessurl = UPL_Settings__c.getOrgDefaults().Token_Access_Endpoint_Price2Win__c;
        String orderstatus = UPL_Settings__c.getOrgDefaults().Price2Win_StatusOrdemVendas_Endpoint__c;
        wrapOauthResponse wrapOauthResponseObj;
        string oathRes;
        
        sales_order__c so = [select id,Valid_From__c,SAP_Order_Number__c,DivisionCode__c,Valid_To__c,Type_of_Order__c,SalesOrgCode__c,DistributionChannelCode__c from sales_order__c where id=:soId];
        
        RequestBody reqBody=new RequestBody();
        // reqBody.SAP_Order_Number = Integer.valueof(so.SAP_Order_Number__c);
        if(fromdate == null&& todate == null){
            reqBody.SAP_Order_Number =so.SAP_Order_Number__c;
            reqBody.Valid_From = null;
            reqBody.Valid_To = null; 
        }else{
            reqBody.SAP_Order_Number = null;
            reqBody.Valid_From = fromdate;
            reqBody.Valid_To = todate; 
        }
        
        //reqBody.Type_of_Order = so.Type_of_Order__c;
        //reqBody.SalesOrgCode = so.SalesOrgCode__c;
        //reqBody.DistributionChannelCode = so.DistributionChannelCode__c;
        //reqBody.DivisionCode = so.DivisionCode__c;
        
        reqBody.Type_of_Order = '';
        reqBody.SalesOrgCode = '';
        reqBody.DistributionChannelCode = '';
        reqBody.DivisionCode ='';
        
        system.debug('JSON.serialize(reqBody)'+JSON.serialize(reqBody));
        
        Http http = new Http();            
        HttpRequest req1 = new HttpRequest();
        req1.setMethod('POST');
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req1.setHeader('Authorization', 'Basic ' +EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password)));
        req1.setEndpoint(tokenacessurl);
        
        HttpResponse response=new HttpResponse(); 
        if(!Test.isRunningTest()){
            response = http.send(req1);
        }
        else{
            response.setBody('{"access_token": "9937fe13fc1c182ec316273870c5b1d","token_type": "Bearer","expires_in": 1800,"scope": ""}');
        }
        oathRes = response.getBody();
        system.debug('oathRes'+oathRes);
        system.debug('response from webservice is '+response.getBody());
        wrapOauthResponseObj= (wrapOauthResponse) System.JSON.deserialize(oathRes, wrapOauthResponse.class);
        
        req1.setEndpoint(orderstatus);
        req1.setMethod('POST');
        req1.setHeader('Content-Type', 'application/json');
        req1.setHeader('Authorization', 'Bearer ' +wrapOauthResponseObj.access_token);
        system.debug('Test');
        req1.setBody(JSON.serialize(reqBody));
        system.debug('JSON.serialize(reqBody)'+JSON.serialize(reqBody));
        
        req1.setTimeout(50000);
        //System.debug(req1);
        HttpResponse result=new HttpResponse(); 
        if(!Test.isRunningTest()){
            result= http.send(req1);
        }
        else{
            result.setBody('{"OrderList":{"SAP_Order_Number":"7009242324","lineItems":[{"Item_Number":"000010","Brazil_Sales_Document_Item_Orig":"000020","SKU_Code":"000000000006031310","SKU_Description":"BIOZYME T.F. (12X1 L)_BRA","SAP_Rejection_Code":"03","SAP_Rejection_Description":"Too expensive","Brazil_Usage_Indicator":"B26","Unit_Price":"100.0","SAP_Billing_Date":"2022-10-25","Unit_of_Measure":"L","Quantity":"12.0","Quantity_Billed":"0.0","Quantity_Ballance":"12.0"},{"Item_Number":"000020","Brazil_Sales_Document_Item_Orig":"000000","SKU_Code":"000000000005250121","SKU_Description":"SELECT 240 EC 1X20L","SAP_Rejection_Code":"03","SAP_Rejection_Description":"Too expensive","Brazil_Usage_Indicator":"B26","Unit_Price":"100.0","SAP_Billing_Date":"2022-10-25","Unit_of_Measure":"L","Quantity":"20.0","Quantity_Billed":"0.0","Quantity_Ballance":"20.0"}]},"Error":"","Return":{"Type":"S","Message_Text":"Função processada com sucesso."}}');
            result.setStatusCode(200);
        }
        //System.debug('result.getBody()=='+result.getBody());
        String errormsg1;
        System.debug(result.getStatusCode());
        string res11= result.getBody().replace('"Type":', '"oType":').replace('"Return"', '"ReturnData"');
        // system.debug('Response:'+res11);
        
        if(result.getStatusCode()==200)
        {
            string res1= result.getBody().replace('"Type":', '"oType":').replace('"Return"', '"ReturnData"');
            system.debug('res1'+res1);
            map<string,List<lineItem>> sapmap = new map<string,List<lineItem>>();
            set<string> skucode = new set<string>();
            map<string,id> skumap = new map<string,id>();
            list<String> sapList = new List<String>();
            List<Sales_Order_Line_Item__c> SLIList;
            List<Sales_Order_Line_Item__c> newlineitemslst = new List<Sales_Order_Line_Item__c>();
            if(fromdate == null&& todate == null){
                ResponseWrapper responseObj = (ResponseWrapper)JSON.deserialize(res1, ResponseWrapper.class);
                system.debug('responseObj'+responseObj);
                OrderItem oi = responseObj.OrderList;
                // List<lineItem> items = oi.lineItems;
                system.debug('oi.lineItems'+oi.lineItems);
                for(lineItem items:oi.lineItems){
                    skucode.add(items.SKU_Code);
                }
                system.debug('skucode'+skucode);
                for(SKU__c sku: [select id,SKU_Code__c from SKU__c where SKU_Code__c in:skucode AND Sales_Org_Code__c = '5191']){ // Added sales org check for INC0429511 GRZ(Nikhil Verma) 27-12-2022
                    skumap.put(sku.SKU_Code__c,sku.id); 
                }
                system.debug('skumap'+skumap);
                system.debug('oi'+oi);
                string SAPOrderNumber = string.valueof(oi.SAP_Order_Number);
                system.debug('SAPOrderNumber'+SAPOrderNumber);
                /* SLIList= [select id,SAP_Order_Number__c,Item_Number__c,Product_Category__c,PriceBookDetail__c,MaterialPlantRelation__c,
MaterialPlantRelation__r.Material_Ledger_Cost__c,LedgerCostUSD__c,UnitValueWithInterest__c,Freight__c,UnitValue__c,Tax__c,
PriceBookDetail__r.Minimum_Price_U__c,Recommended_price__c,DDS_Grade__c,Culture__r.Culture_Desc__c,Culture__c,DateofFAT__c,Days__c
from Sales_Order_Line_Item__c where SAP_Order_Number__c  =:SAPOrderNumber];
*/
                
                SLIList= [SELECT ID,SAP_Order_Number__c,Customer_Conversion_Factor__c,round__c,Sale_Order__r.Price_Book__r.CreatedDate,Sale_Order__r.Kit_Order__c,
                          Item_Category__c,Kit_Item_Number__c,Kit_Product__c,Kit_SKU__c,Kit_SKU__r.SKU_Description__c,Kit_SKU__r.Name, Sale_Order__c, DateofFAT__c, 
                          SKU_Name__c, Discount__c, Tax__c, Freight__c,SKU_Name__r.SKU_Description__c,SKU_Name__r.Product_Name__c, Time_in_months__c, Days__c, 
                          Flag__c, MO_Item_No__c,Cogs_Info__c, Recommended_price__c, DDS_Grade__c,UnitValue__c,Product_Category__c, InterestRate__c, 
                          ProductReplacementMargin__c, Net_Price__c,MinValue__c,Quantity__c, UnitValuewithInterest__c, Culture__r.Culture_Desc__c,BudgetPrice__c,
                          Product_Replacement_Margin_Unit_Price__c,ProductLedgerMargin__c, Approval_Flag__c, Culture__c, Item_Number__c,Budget_Value_Margin__c,
                          PriceBookDetail__c, CurrencyIsoCode, Sales_Org__c, Sales_Order_Line_Item__c, MaterialPlantRelation__c, TotalValueWithoutInterest__c, 
                          Sales_Order_Line_Item__r.Item_Number__c,MaterialPlantRelation__r.Material_Ledger_Cost__c,ExchangeRate__c, SKU_Name__r.Name,
                          TotalValueWithInterest__c,multipleOf__c,CreatedDate,LedgerCostUSD__c,PriceBookDetail__r.Price_book__r.Currency__c,
                          MaterialPlantRelation__r.Replacement_Cost__c,ExchangeRate__r.ExchangeRate__c,PriceBookDetail__r.Unit_Price__c, 
                          PriceBookDetail__r.Unit_Price_R__c, PriceBookDetail__r.Unit_Price_U__c,PriceBookDetail__r.CreatedDate, SKU_Name__r.Brand_Name__c, 
                          PriceBookDetail__r.Minimum_Price_R__c,PriceBookDetail__r.Price_Book__r.Apply_Minimum_Price__c,PriceBookDetail__r.Minimum_Price_U__c, 
                          PriceBookDetail__r.Price_Book__r.Interest_Date__c,Product_PO_item_number__c,Unit_Price_R__c,Tax_Amount_Without_Interest__c,
                          Freight_Amount_Without_Interest__c,Punctuality_Discount_WI_Calculated__c,TotalReplacementCost__c,
                          Discount_Considering_Barter_Discount__c,SelloutPrice__c,Contribution_Margin__c FROM Sales_Order_Line_Item__c where Sale_Order__c =:soId]; //SAP_Order_Number__c  =:SAPOrderNumber];
                
                
                map<Decimal,Sales_Order_Line_Item__c> SFlineItemsMAP = new map<Decimal,Sales_Order_Line_Item__c>();
                for(Sales_Order_Line_Item__c items:SLIList){
                    SFlineItemsMAP.put(items.Item_Number__c, items);
                }
                system.debug('SFlineItemsMAP'+SFlineItemsMAP);
                for(Sales_Order_Line_Item__c sli:SLIList){
                    // if(string.valueof(oi.SAP_Order_Number)==sli.SAP_Order_Number__c){
                    for(lineItem li:oi.lineItems){
                        if(sli.Item_Number__c==li.Item_Number){
                            //sku code using map
                            system.debug('sli.Item_Number__c'+sli.Item_Number__c);
                            sli.SKU_Name__c = skumap.get(li.SKU_Code);
                            system.debug('sli.SKU_Name__c'+sli.SKU_Name__c);
                            // sli. = li.SKU_Description
                            //Rejection_Code__c lookup with (Rejection Status)
                            if(  string.isNotBlank(li.SAP_Rejection_Code) || string.isNotEmpty(li.SAP_Rejection_Code)){
                                //  sli.Rejection_Code__c = li.SAP_Rejection_Code;
                                // sli.Cancellation_Reason__c = li.SAP_Rejection_Code;
                                // sli.Rejection_Description__c = li.SAP_Rejection_Description;
                                sli.Item_Status__c = 'Inactive';
                                system.debug('Test11');
                            }
                            else{
                                sli.Cancellation_Reason__c = null;
                                sli.Item_Status__c = 'Active';
                            }
                            //sli.Rejection_Description__c = li.SAP_Rejection_Description;
                            //sli.DateofFAT__c = li.SAP_Billing_Date; //date of fat
                            sli.UOM__c = li.Unit_of_Measure;  //UOM__C
                            sli.Quantity__c = li.Quantity;
                            sli.Quantity_Billed__c = li.Quantity_Billed;
                            sli.Unbilled_Quatity__c = li.Quantity_Ballance;
                            sli.Brazil_Usage_Indicator__c = li.Brazil_Usage_Indicator ;
                            sli.Brazil_Sales_Document_Item_Orig__c = li.Brazil_Sales_Document_Item_Orig ;
                            sli.Unit_Price__c = li.Unit_Price ;
                            system.debug('TestSagar123');
                        }
                    }
                }
                update SLIList;
                for(lineItem itms:oi.lineItems){
                    if(itms.Brazil_Sales_Document_Item_Orig != 000000 && !SFlineItemsMAP.containskey(itms.Item_Number)){   ////Added by Butesh(Grazitti) for INC0451225 25Feb23
                        if(SFlineItemsMAP.containskey(itms.Brazil_Sales_Document_Item_Orig)){  ////Added by Butesh(Grazitti) for INC0451225 14Mar23
                        Sales_Order_Line_Item__c SFClonedItems = SFlineItemsMAP.get(itms.Brazil_Sales_Document_Item_Orig);
                        system.debug('SFlineItemsMAP.get(itms.Brazil_Sales_Document_Item_Orig)'+SFlineItemsMAP.get(itms.Brazil_Sales_Document_Item_Orig));
                        system.debug('SFClonedItems'+SFClonedItems);
                        //Sales_Order_Line_Item__c newitems = SFClonedItems.clone(false, true, false, false);
                        Sales_Order_Line_Item__c newitems = new Sales_Order_Line_Item__c();
                        if(!Test.isRunningTest()){
                            newitems = SFClonedItems.clone();
                        }
                        newitems.Sale_Order__c = so.id;
                        newitems.UOM__c = itms.Unit_of_Measure;  
                        newitems.Quantity__c = itms.Quantity;
                        newitems.Quantity_Billed__c = itms.Quantity_Billed;
                        newitems.Unbilled_Quatity__c = itms.Quantity_Ballance;
                        newitems.Brazil_Usage_Indicator__c = itms.Brazil_Usage_Indicator ;
                        newitems.Brazil_Sales_Document_Item_Orig__c = itms.Brazil_Sales_Document_Item_Orig ;
                        newitems.Unit_Price__c = itms.Unit_Price ;
                        newitems.UnitValue__c = itms.Unit_Price ;
                        
                        newitems.SKU_Name__c = skumap.get(itms.SKU_Code);
                        newitems.Item_Number__c = itms.Item_Number;
                        /*newitems.Product_Category__c = SFClonedItems.Product_Category__c;
newitems.PriceBookDetail__c = SFClonedItems.PriceBookDetail__c;
newitems.MaterialPlantRelation__c = SFClonedItems.MaterialPlantRelation__c  ;
newitems.UnitValueWithInterest__c = SFClonedItems.UnitValueWithInterest__c;
newitems.Freight__c = SFClonedItems.Freight__c;
newitems.UnitValue__c = SFClonedItems.UnitValue__c;
newitems.Tax__c = SFClonedItems.Tax__c;
// newitems.UnitValue__c = SFClonedItems.UnitValue__c;
newitems.Recommended_price__c = SFClonedItems.Recommended_price__c;
newitems.DDS_Grade__c = SFClonedItems.DDS_Grade__c;
newitems.Culture__c = SFClonedItems.Culture__c;
newitems.DateofFAT__c = SFClonedItems.DateofFAT__c;
newitems.Days__c = SFClonedItems.Days__c;*/
                        
                        
                        newitems.Item_Status__c = 'Active';
                        if(string.isNotBlank(itms.SAP_Rejection_Code) || string.isNotEmpty(itms.SAP_Rejection_Code)){
                            newitems.Cancellation_Reason__c = itms.SAP_Rejection_Code;
                            newitems.Item_Status__c = 'Inactive';
                        }
                        
                        newlineitemslst.add(newitems);
                    }
                }
                }
                system.debug('newlineitemslst'+newlineitemslst.size());
                
            }else{
                ResponseWrapper2 responseObj = (ResponseWrapper2)JSON.deserialize(res1, ResponseWrapper2.class);
                for(OrderItem oi:responseObj.OrderList){
                    sapList.add(string.valueof(oi.SAP_Order_Number));
                    //sapmap.put(oi.SAP_Order_Number,itemList);
                }
                SLIList= [select id,SAP_Order_Number__c,Item_Number__c from Sales_Order_Line_Item__c where SAP_Order_Number__c in :sapList];
                for(OrderItem oi:responseObj.OrderList){
                    for(Sales_Order_Line_Item__c sli:SLIList){
                        if(string.valueof(oi.SAP_Order_Number)==sli.SAP_Order_Number__c){
                            for(lineItem li:oi.lineItems){
                                if(sli.Item_Number__c==li.Item_Number){
                                    SKU__c sku = new SKU__c(SKU_Code__c=li.SKU_Code);
                                    sli.SKU_Name__r = sku;
                                    sli.Rejection_Code__c = li.SAP_Rejection_Code;
                                    //sli.Rejection_Description__c = li.SAP_Rejection_Description;
                                    //sli.SKU_Code__c = li.SAP_Billing_Date;
                                    //sli.SKU_Code__c = li.Unit_of_Measure;
                                    sli.Quantity__c = li.Quantity;
                                    sli.Quantity_Billed__c = li.Quantity_Billed;
                                    sli.Unbilled_Quatity__c = li.Quantity_Ballance;
                                    sli.Brazil_Usage_Indicator__c = li.Brazil_Usage_Indicator ;
                                    sli.Brazil_Sales_Document_Item_Orig__c = li.Brazil_Sales_Document_Item_Orig ;
                                    sli.Unit_Price__c = li.Unit_Price ;
                                }
                            }
                        }
                    }
                }
            }
            system.debug('newlineitemslst'+newlineitemslst.size());
            if(!Test.isRunningTest()){
                Database.insert(newlineitemslst);
            }
        }else{
            
        }
        
    }
    public class ResponseWrapper{
        //  public List<OrderItem> OrderList;
        public OrderItem OrderList;
        public string Error{get;set;}
        public ReturnData ReturnData;
        //  public ResponseWrapper(){
        //      OrderList = new List<OrderItem>();
        //  }
        
    }
    public class ResponseWrapper2{
        public List<OrderItem> OrderList;
        //public OrderItem OrderList;
        public string Error{get;set;}
        public ReturnData ReturnData;
        public ResponseWrapper2(){
            OrderList = new List<OrderItem>();
        }
        
    }
    
    public class ReturnData{
        public string oType {get;set;}
        public string Message_Text {get;set;}
        
    }
    public class RequestBody{
        public string SAP_Order_Number{get;set;}
        public datetime Valid_From{get;set;}
        public datetime Valid_To{get;set;}
        public string Type_of_Order{get;set;}
        public string SalesOrgCode{get;set;}
        public string DistributionChannelCode{get;set;}
        public string DivisionCode{get;set;}
    }
    public class OrderItem{
        public string SAP_Order_Number{get;set;}
        public List<lineItem> lineItems;
        public OrderItem(){
            lineItems = new List<lineItem>();
        }
    }
    public class lineItem{
        public integer Item_Number{get;set;}
        public string SKU_Code{get;set;}
        public string SKU_Description{get;set;}
        public string SAP_Rejection_Code{get;set;}
        public string SAP_Rejection_Description{get;set;}
        public string SAP_Billing_Date{get;set;}
        public string Unit_of_Measure{get;set;}
        public decimal Quantity{get;set;}
        public decimal Quantity_Billed{get;set;}
        public decimal Quantity_Ballance{get;set;}
        public string Brazil_Usage_Indicator{get;set;}
        public Decimal Unit_Price{get;set;}
        public Decimal Brazil_Sales_Document_Item_Orig{get;set;}
    }
    public class wrapOauthResponse{
        @AuraEnabled
        public String access_token{get;set;}
        @AuraEnabled
        public String token_type{get;set;}
        @AuraEnabled
        public String expires_in{get;set;}
        @AuraEnabled
        public String scope{get;set;}  
        
        public wrapOauthResponse(){
            access_token='';
            token_type='';
            expires_in='';  
            scope='';    
        }
    }
    
}