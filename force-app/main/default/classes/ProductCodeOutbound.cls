public class ProductCodeOutbound {
    @InvocableMethod(label='Sales Order')
    public static void SendSalesOrder(List<String> sorderid){
        Productmethod(sorderid);
    }
    @future(callout =true)
    public static void Productmethod(List<String> sorderid){
        cwbtool__ErrorLog__c error;
        //Salesorder sorder = new Salesorder();
       // try{ 
            Sales_Order__c so =[Select id,Name,Sales_Director_Code__c,Created_DateTime__c,Sales_Office__c,CurrencyIsoCode,Price_Book__r.USD_Rate__c, 
                                Sold_to_Party__c, Sold_to_Party__r.Name, Sold_to_Party__r.Price_Conversion_Group__c,Price_Book__r.CurrencyIsoCode 
                                from Sales_Order__c where id =:sorderid.get(0)];
            
            List<Sales_Order_Line_Item__c> soit =[Select id,SKU_Code__c,SKU_Description__c,Quantity__c,TotalValueWithInterest__c,TotalValueWithoutInterest__c,
                                                  TotalReplacementCost__c,Product_Replacement_Margin_Unit_Price__c,Unit_Price_U__c,
                                                  PriceBookDetail__r.Unit_Price_U__c,PriceBookDetail__r.Unit_Price_R__c,
                                                  SKU_Name__r.Brand_Name__c,DDS_Grade__c,Recommended_price__c from Sales_Order_Line_Item__c where Sale_Order__c =:sorderid];
            ExchangeRate__c	 exrate= [SELECT Id, ExchangeRate__c, Createddate 
                                                  FROM ExchangeRate__c  where FromCurrency__c = 'USD' AND ToCurrency__c = 'BRL' 
                                                  Order BY Createddate DESC limit 1];
        decimal exrate1=exrate.ExchangeRate__c;
        
        List<salesorder> soList = new List<Salesorder>();
            string totalreq;
            string sCurrencyCode = so.Price_Book__r.CurrencyIsoCode;
            String fxrate= string.valueOf(so.Price_Book__r.USD_Rate__c);
          decimal fxratedec = so.Price_Book__r.USD_Rate__c;
            string fxrateheader =  '{"FX_Rate":'+fxrate+'}';
            for(Sales_Order_Line_Item__c soitem:soit)
            {salesorder sorder = new Salesorder();
             System.debug(so);
             sorder.Numero_do_Pedido=so.Name;
             sorder.Management=so.Sales_Director_Code__c;
             sorder.Mes_do_pedido=string.ValueOf(so.Created_DateTime__c);
             sorder.Business_Unit=so.Sales_Office__c;
             sorder.Customer_Group=so.Sold_to_Party__r.Price_Conversion_Group__c;
             sorder.Customer=so.Sold_to_Party__r.Name;
             sorder.Brand=soitem.SKU_Name__r.Brand_Name__c;
             sorder.Prod_Code=integer.ValueOf(soitem.SKU_Code__c);
             sorder.Product_Description=soitem.SKU_Description__c;
             sorder.Quantity=integer.ValueOf(soitem.Quantity__c);
             sorder.Order_Sales_FV_USD=soitem.TotalValueWithoutInterest__c;
              if(sCurrencyCode == 'BRL') {
             	sorder.Order_Total_Cogs_USD=(soitem.TotalReplacementCost__c / exrate1);
                  sorder.Order_Gross_Margin_PV_USD=(soitem.Product_Replacement_Margin_Unit_Price__c * soitem.TotalValueWithoutInterest__c / (fxratedec * 100));
              }
             else{
             	sorder.Order_Total_Cogs_USD=soitem.TotalReplacementCost__c;
                 sorder.Order_Gross_Margin_PV_USD=(soitem.Product_Replacement_Margin_Unit_Price__c * soitem.TotalValueWithoutInterest__c /100);
             }
             
             if(sCurrencyCode == 'USD') {
                sorder.Price_List_Sales_FV_USD=(soitem.PriceBookDetail__r.Unit_Price_U__c)*(soitem.Quantity__c);
             }
             else{
                sorder.Price_List_Sales_FV_USD=(soitem.PriceBookDetail__r.Unit_Price_R__c)*(soitem.Quantity__c);
             }
             sorder.Currency1=so.CurrencyIsoCode; 
             soList.add(sorder);
            }
            System.debug(soList);
            System.debug(JSON.serialize(soList));
            Http http = new Http();              
            HttpRequest req1 = new HttpRequest();
            req1.setHeader('Content-Type','application/json');
            req1.setHeader('X-Requested-With','XMLHttpRequest');
            req1.setEndpoint('callout:Product_Credentials');
            string srsoi = JSON.serialize(soList);
            srsoi = srsoi.replaceAll('Numero_do_Pedido', 'Número do Pedido');
            srsoi = srsoi.replaceAll('Mes_do_pedido', 'Mês do pedido');
            srsoi = srsoi.replaceAll('Business_Unit', 'Business Unit');
            srsoi = srsoi.replaceAll('Customer_Group', 'Customer Group');
            srsoi = srsoi.replaceAll('Prod_Code', 'Prod Code');
            srsoi = srsoi.replaceAll('Product_Description', 'Product Description');
            srsoi = srsoi.replaceAll('Order_Sales_FV_USD', 'Order Sales FV');
            srsoi = srsoi.replaceAll('Order_Total_Cogs_USD', 'Order Total Cogs');
            srsoi = srsoi.replaceAll('Order_Gross_Margin_PV_USD', 'Order Gross Margin FV');
            srsoi = srsoi.replaceAll('Price_List_Sales_FV_USD', 'Price List Sales FV');
            srsoi = srsoi.replaceAll('Currency1', 'Currency');
            system.debug(srsoi);
            totalreq = '[' + fxrateheader + ',' + srsoi + ']';
            req1.setBody(totalreq);
            req1.setMethod('POST');
            req1.setTimeout(15000);
            System.debug(req1);
            
            HttpResponse result= http.send(req1);
            result.getStatusCode();
            System.debug('result.getBody()=='+result.getBody());
            System.debug(result.getStatusCode());
            //string resBody=result.getBody();
           // resBody = resBody.replaceAll('Prod Code', 'Prod_Code');
           // resBody = resBody.replaceAll('Recommended price', 'Recommended_price');
           // resBody = resBody.replaceAll('DDS Grade', 'DDS_Grade');
            String errormsg1;
            errormsg1='';
                if(result.getStatusCode()==200)
                {
                   // try{
                        List<ResWrapper> responseObj = (List<ResWrapper>)JSON.deserialize(result.getBody(), List<ResWrapper>.class);
                        //List<ResWrapper> responseObj = (List<ResWrapper>)System.JSON.deserialize(resBody, List<ResWrapper>.class);
                        System.debug('responseObj = '+responseObj);
                        // for(Sales_Order_Line_Item__c soitem:soit)
                             integer count = 0;
                for(Sales_Order_Line_Item__c soitem:soit)
                {	
                    soitem.Recommended_price__c=responseObj[count].Recommended_price;
                    soitem.Recommended_price__c=soitem.Recommended_price__c.setScale(2);
                    soitem.DDS_Grade__c=responseObj[count].DDS_Grade;
                    count = count + 1;
                } 
                        /*{   
                        for(ResWrapper resitem:responseObj){
                            System.debug('Prod_Code = '+resitem.Prod_Code);
                            System.debug('SKU_Code__c = '+integer.ValueOf(soitem.SKU_Code__c));
                            if(resitem.Prod_Code == integer.ValueOf(soitem.SKU_Code__c)){
                                soitem.Recommended_price__c=resitem.Recommended_price;
                                soitem.DDS_Grade__c=resitem.DDS_Grade;
                            }
                            errormsg1=errormsg1+resitem.sErrMsg+'\n';
                        }
                        }*/
                             
                    
                        if(soit.size()>0){
                            update soit;
                        } 
                        system.debug(responseObj);
                        cwbtool__ErrorLog__c ic = new cwbtool__ErrorLog__c();
                        ic.cwbtool__ErrorType__c='Sales Order Details';
                        ic.cwbtool__Message__c=errormsg1;
                        ic.cwbtool__StackTrace__c=result.getBody();
                        
                        insert ic; 
                    /* }
                    catch(Exception e1)
                    {
                        System.debug(e1.getMessage());  
                    } */
                }
                else{
                    /* List<ResWrapper> responseObj = (List<ResWrapper>) JSON.deserialize(result.getBody(), List<ResWrapper>.class);
                    //soitem.Recommended_price__c=responseObj.Recommended_price;
                    for(ResWrapper resitem:responseObj){
                        errormsg1=errormsg1+resitem.sErrMsg+'\n';
                    } */
                    cwbtool__ErrorLog__c ic = new cwbtool__ErrorLog__c();
                    ic.cwbtool__ErrorType__c='Sales Order Details';
                    ic.cwbtool__Message__c=errormsg1;
                    ic.cwbtool__StackTrace__c=result.getBody();
                    insert ic;
                }
           /* }
            
        
        catch(Exception e)
        {
            cwbtool__ErrorLog__c ic = new cwbtool__ErrorLog__c();
            ic.cwbtool__ErrorType__c='Sales Order Failed Details';
            ic.cwbtool__Message__c=e.getMessage();
            insert ic; 
            System.debug(e.getMessage());
        } */
    }
    
    
    public class Salesorder{
        @AuraEnabled public string Numero_do_Pedido{get;set;}
        @AuraEnabled public string Management{get;set;}
        @AuraEnabled public string Mes_do_pedido{get;set;}
        @AuraEnabled public string Business_Unit{get;set;}
        @AuraEnabled public string Customer_Group{get;set;}
        @AuraEnabled public string Customer{get;set;}
        @AuraEnabled public string Brand{get;set;}
        @AuraEnabled public integer Prod_Code{get;set;}
        @AuraEnabled public string Product_Description{get;set;}
        @AuraEnabled public integer Quantity{get;set;}
        @AuraEnabled public double Order_Sales_FV_USD{get;set;}
        @AuraEnabled public double Order_Total_Cogs_USD{get;set;}
        @AuraEnabled public double Order_Gross_Margin_PV_USD{get;set;}
        @AuraEnabled public double Price_List_Sales_FV_USD{get;set;}
        @AuraEnabled public string Currency1{get;set;}
    }
    public class ResWrapper{
        public Integer Prod_Code{get;set;}
        public decimal Recommended_price{get;set;}
        public String DDS_Grade{get;set;}
        public String sErrMsg;
        public String result;  
    }
     /*   public class SalesOrderItem {
        
        @AuraEnabled public String productId;
        @AuraEnabled public String productCode;
        @AuraEnabled public String orderItemId;
        @AuraEnabled public String priceBookDetailId;
        @AuraEnabled public String skuCategory;
        @AuraEnabled public String UOM;
        @AuraEnabled public String productName;
        @AuraEnabled public Decimal qty;
        @AuraEnabled public Decimal inventory;
        @AuraEnabled public Decimal listValue;
        @AuraEnabled public Decimal minValue;
        @AuraEnabled public Decimal unitValue;//final prices
        @AuraEnabled public Decimal unitCost;
        @AuraEnabled public Decimal budgetValue;
        @AuraEnabled public Decimal discount;
        @AuraEnabled public Decimal discount_percent;
        @AuraEnabled public Decimal profit;
        @AuraEnabled public String typeOfBusiness;
        @AuraEnabled public Decimal netSales;
        @AuraEnabled public Decimal netPrice;
        @AuraEnabled public Decimal margin;
        @AuraEnabled public Decimal netMargin;
        @AuraEnabled public String resultByMargin;
        @AuraEnabled public String resultByPrice;
        @AuraEnabled public Decimal totalSales;
        @AuraEnabled public Decimal grossProfit;
        @AuraEnabled public Decimal grossMargin;
        @AuraEnabled public Decimal businessImpact;
        @AuraEnabled public Decimal totalDiscount;
        @AuraEnabled public Decimal maxPrice;
        @AuraEnabled public String oiCurrency;
        @AuraEnabled public String brand;
        @AuraEnabled public Decimal replacementMargin;
        @AuraEnabled public Decimal ledgerMargin;
        @AuraEnabled public Decimal unitValueWithInterest;
        @AuraEnabled public Decimal totalValue;
        @AuraEnabled public Decimal totalValueWithInterest;
        @AuraEnabled public Decimal interestRate;
        @AuraEnabled public Decimal days;
        @AuraEnabled public Decimal timeInMonths;
        @AuraEnabled public Decimal multipleOf;
        @AuraEnabled public String cultureDesc;
        @AuraEnabled public String flag;
        @AuraEnabled public Decimal itemNo;
        @AuraEnabled public Decimal moItemNo;
        @AuraEnabled public Boolean isMO;
        @AuraEnabled public Date deliveryDate;
        @AuraEnabled public String deliveryAddress;
        public SalesOrderItem(){
            UOM = 'N/A';
            isMO = false;
            itemNo = 0;
            moItemNo = 0;
            productId = '';
            productCode = '';
            orderItemId = '';
            priceBookDetailId = '';
            productName = '';
            maxPrice = 0;
            unitCost =0;
           // fatDate = '';
            qty = 0;
            discount = 0;
            discount_percent = 0;
            profit = 0;
            netSales = 0;
            netPrice = 0;
            margin = 0;
            netMargin = 0;
            unitValueWithInterest = 0;
            totalValueWithInterest = 0;
            totalValue = 0;
            interestRate = 0;
            days = 0;
            cultureDesc = '';
            deliveryAddress = '';
            deliveryDate = Date.today();
            oiCurrency = 'USD';
        }
        }*/
}