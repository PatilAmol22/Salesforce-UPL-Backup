public without sharing class OrderSummary {

    public List<Sales_Order__c> SOList{get;set;}
    //public WrapOS OSmain{get;set;} 
    public List<WrapOS> WrapList {get;set;}
    public string countryName {get;set;}
    public Boolean isChild {get;set;}
    public string parentAccountName {get;set;}
    public string parentSAPCode {get;set;}
    public string childAccountName {get;set;}
    public string childSAPCode {get;set;}

    public OrderSummary(){
        
        SOList=new List<Sales_Order__c>();
        String PONo=ApexPages.CurrentPage().getParameters().get('PONo');
        String DateFrom=ApexPages.CurrentPage().getParameters().get('DateFrom');
        String DateTo=ApexPages.CurrentPage().getParameters().get('DateTo');
        String AccId=ApexPages.CurrentPage().getParameters().get('AccId');
        String Status=ApexPages.CurrentPage().getParameters().get('Status');
        String Product=ApexPages.CurrentPage().getParameters().get('Product');
        String SKUDesc=ApexPages.CurrentPage().getParameters().get('SKUDesc');
        String SONo=ApexPages.CurrentPage().getParameters().get('SONo');
        String SalesOrg=ApexPages.CurrentPage().getParameters().get('SalesOrg');
        String Country=ApexPages.CurrentPage().getParameters().get('Country');
        String SON=ApexPages.CurrentPage().getParameters().get('SON');

        id userId = UserInfo.getUserId();
        User u = [select id, contactId, accountId, Account.Name, Account.SAP_Code__c, Country from User where id = : userId];
        String userAccountId = u.accountId;
            if(userAccountId==AccId){
                isChild = false;            
            }else{
                isChild = true;                
                parentAccountName = u.Account.Name;
                parentSAPCode = u.Account.SAP_Code__c;
            }
        
        String query='';
        if(Country=='Japan'){
            if(AccId.length()>18){
                AccId = AccId;
            }else{
                AccId = '\''+AccId+'\'';
            }
            query='SELECT Id,SKU_Code__c,SKU_Description__c,UOM__c,Price__c,Distributor_Discount__c,Campaign_Discount__c,Line_Discount__c,Volume_Discount__c,Quantity__c,CurrencyIsoCode,Net_Price__c,SKU_Name__r.Product_Name__r.Name,Sale_Order__r.Id,Sale_Order__r.Name,Sale_Order__r.OrderQuantity__c,Sale_Order__r.SAP_Order_Number__c,Sale_Order__r.Order_Date__c,Sale_Order__r.PONumber__c,Sale_Order__r.CurrencyIsoCode,Sale_Order__r.Total_Amount__c,Sale_Order__r.Net_Amount__c,Sale_Order__r.Inco_Term_1__c,toLabel(Sale_Order__r.Order_Status__c),Sale_Order__r.Sold_To_Party__r.Name,Sale_Order__r.Sold_To_Party__r.SAP_Code__c,Sale_Order__r.Shipping_Location_Name__c FROM Sales_Order_Line_Item__c where Sale_Order__r.Sold_To_Party__c IN ('+AccId+')';
            query+=' AND Sale_Order__r.Order_Type_lk__r.Name='+'\''+'ZJWH'+'\'';
        }else{
            query='SELECT Id,SKU_Code__c,SKU_Description__c,UOM__c,Price__c,Distributor_Discount__c,Campaign_Discount__c,Line_Discount__c,Volume_Discount__c,Quantity__c,CurrencyIsoCode,Net_Price__c,SKU_Name__r.Product_Name__r.Name,Sale_Order__r.Id,Sale_Order__r.Name,Sale_Order__r.OrderQuantity__c,Sale_Order__r.SAP_Order_Number__c,Sale_Order__r.Order_Date__c,Sale_Order__r.PONumber__c,Sale_Order__r.CurrencyIsoCode,Sale_Order__r.Total_Amount__c,Sale_Order__r.Net_Amount__c,Sale_Order__r.Inco_Term_1__c,toLabel(Sale_Order__r.Order_Status__c),Sale_Order__r.Sold_To_Party__r.Name,Sale_Order__r.Sold_To_Party__r.SAP_Code__c FROM Sales_Order_Line_Item__c where Sale_Order__r.Sold_To_Party__c='+'\''+AccId+'\'';
        }
        
        //RITM0511197
         if(Country=='Colombia'){
         query+=' AND SAP_Order_Number__c!=\'\'';
         }

        if(PONo!=''){
            query+=' AND Sale_Order__r.PONumber__c='+'\''+PONo+'\'';
        }
        if(SONo!=''){
            query+=' AND Sale_Order__r.SAP_Order_Number__c='+'\''+SONo+'\'';
        }
        if(DateFrom!=''){
            query+=' AND Sale_Order__r.Order_Date__c >= '+DateFrom;
        }
        if(DateTo!=''){
            query+=' AND Sale_Order__r.Order_Date__c <= '+DateTo;
        }
        if(Status!=''){
            query+=' AND Sale_Order__r.Order_Status__c='+'\''+Status+'\'';
        }
        if(Product!=''){
            
             query+=' AND SKU_Name__r.SKU_Description__c='+'\''+Product+'\'';
            
        }
        if(SON!=''){
            query+=' AND Sale_Order__r.Name='+'\''+SON+'\'';
        }
        if(Country=='Japan'){
            query+=' AND Sale_Order__r.Order_Date__c = LAST_N_DAYS:730 order by CreatedDate desc';
        }else{
            query+=' order by CreatedDate desc';
        }
        
        System.debug(query);
        System.debug(Country);
        countryName=Country;

        List<Sales_Order_Line_Item__c> SOLIList=new List<Sales_Order_Line_Item__c>();
        SOLIList=Database.query(query);
        Map<Id,Sales_Order__c> somap=new Map<Id,Sales_Order__c>();
        for(Sales_Order_Line_Item__c s : SOLIList){
            somap.put(s.Sale_Order__r.Id,s.Sale_Order__r);
        }

        Map<Integer, String> turkeyDates = new Map<Integer, String>();
                turkeyDates.put(1, 'Oca');
                turkeyDates.put(2, 'şub');
                turkeyDates.put(3, 'Mar');
                turkeyDates.put(4, 'Nis');
                turkeyDates.put(5, 'May');
                turkeyDates.put(6, 'Haz');
                turkeyDates.put(7, 'Tem');
                turkeyDates.put(8, 'Ağu');
                turkeyDates.put(9, 'Eyl');
                turkeyDates.put(10, 'Eki');
                turkeyDates.put(11, 'Kas');
                turkeyDates.put(12, 'Ara');
        WrapList =new List<WrapOS>();
        Map<Id,WrapOS> japanSalesOrderMap=new Map<Id,WrapOS>();
        if(u.Country=='Japan'){
            for(Sales_Order_Line_Item__c sli : SOLIList){
                if(japanSalesOrderMap.containsKey(sli.Sale_Order__r.Id)){
                    WrapOS wrap = japanSalesOrderMap.get(sli.Sale_Order__r.Id);
                    wrap.SKUDesc = wrap.SKUDesc +' , '+sli.SKU_Description__c;
                    japanSalesOrderMap.put(sli.Sale_Order__r.Id,wrap);
                }else{
                    WrapOS wrap = new WrapOS();
                    wrap.SalesOrderNo='\''+sli.Sale_Order__r.Name+'\'';
                    DateTime dt = DateTime.newInstance(sli.Sale_Order__r.Order_Date__c.year(), sli.Sale_Order__r.Order_Date__c.month(),sli.Sale_Order__r.Order_Date__c.day());
                    String dateStr = dt.format('yyyy/MM/dd');
                    wrap.OrderDate=dateStr;
                    wrap.POOrderNo=sli.Sale_Order__r.PONumber__c;
                    wrap.Quantity=sli.Sale_Order__r.OrderQuantity__c;
                    wrap.TotalAmount=(sli.Sale_Order__r.Total_Amount__c).setScale(2);
                    wrap.Status=sli.Sale_Order__r.Order_Status__c;
                    wrap.IncoTerm=sli.Sale_Order__r.Inco_Term_1__c;
                    wrap.SKUDesc=sli.SKU_Description__c;
                    wrap.childAccountName=sli.Sale_Order__r.Sold_To_Party__r.Name;
                    wrap.childSAPCode=sli.Sale_Order__r.Sold_To_Party__r.SAP_Code__c;
                    wrap.shipToPartyName=sli.Sale_Order__r.Shipping_Location_Name__c;
                    japanSalesOrderMap.put(sli.Sale_Order__r.Id,wrap);
                }
            }
            WrapList = japanSalesOrderMap.values();
        }else{
            for(Sales_Order__c s : somap.values()){
                WrapOS OSmain=new WrapOS();
                OSmain.SalesOrderNo='\''+s.Name+'\'';
                if(s.SAP_Order_Number__c!=null){
                    OSmain.SAPOrderNo=s.SAP_Order_Number__c;
                }
                if(s.Order_Date__c!=null && Country=='Turkey'){
                    OSmain.OrderDate=String.valueOf(s.Order_Date__c.Day())+'-'+turkeyDates.get(s.Order_Date__c.Month())+'-'+String.valueOf(s.Order_Date__c.Year());
                }else if(s.Order_Date__c!=null && Country=='Japan'){
                    DateTime dt = DateTime.newInstance(s.Order_Date__c.year(), s.Order_Date__c.month(),s.Order_Date__c.day());
                    String dateStr = dt.format('yyyy/MM/dd');
                    OSmain.OrderDate=dateStr;
                }else if(s.Order_Date__c!=null){
                    OSmain.OrderDate=String.valueOf(s.Order_Date__c.Day())+'-'+String.valueOf(s.Order_Date__c.Month())+'-'+String.valueOf(s.Order_Date__c.Year());
                }
                if(s.PONumber__c!=null){
                    OSmain.POOrderNo=s.PONumber__c;
                }     
                if(s.OrderQuantity__c!=0){       
                    OSmain.Quantity=s.OrderQuantity__c;
                }
                if(Country=='Colombia'){
                    OSmain.TotalAmount=s.Net_Amount__c.setScale(2);
                }else{
                    If(s.Total_Amount__c!=0){
                        if(Country=='Japan'){
                            OSmain.TotalAmount=(s.Total_Amount__c).setScale(2);
                        }else{
                            OSmain.TotalAmount=s.Total_Amount__c.setScale(2);
                            OSmain.TotalAmountWithComma=String.valueOf(s.Total_Amount__c.setScale(2)).replace('.',',');
                        }                 
                    }
                }
                If(s.Order_Status__c!=null){
                    //OSmain.Status=s.Order_Status__c.replace('ł','l').replace('ęś','es').replace('ą','a');
                    OSmain.Status=s.Order_Status__c;
                }
                If(s.Inco_Term_1__c!=null){
                    //OSmain.Status=s.Order_Status__c.replace('ł','l').replace('ęś','es').replace('ą','a');
                    OSmain.IncoTerm=s.Inco_Term_1__c;
                }
                
                WrapList.add(OSmain);
            }
        }
        //SOList=somap.values();
    }

    @AuraEnabled(cacheable = true)
    public static List<Sales_Order__c> fetchSalesOrder(String SOLIquery,String recordId){
        id userId = UserInfo.getUserId();
        System.debug(userId);
        User u = [select id, contactId, accountId, Country from User where id = : userId];
        SOLIquery+=' where Sale_Order__c='+'\''+recordId+'\''; 
        System.debug(SOLIquery);
        List<Sales_Order_Line_Item__c> LineItems=new List<Sales_Order_Line_Item__c>();
        LineItems=Database.query(SOLIquery);
        System.debug('LineItems---'+LineItems);
        Map<Id,Sales_Order__c> salesOrders=new Map<Id,Sales_Order__c>();
        for(Sales_Order_Line_Item__c s : LineItems){
            if(u.Country=='Colombia' && s.Sale_Order__r.Net_Amount__c!=null){
                s.Sale_Order__r.Total_Amount__c = s.Sale_Order__r.Net_Amount__c.setScale(3);              
            }else{
                s.Sale_Order__r.Total_Amount__c = s.Sale_Order__r.Total_Amount__c.setScale(3);
            }

            salesOrders.put(s.Sale_Order__r.Id,s.Sale_Order__r);
        }
        List<Sales_Order__c> soList=salesOrders.values();
        if(u.Country=='Japan'){
            for(Sales_Order__c s : soList){
                s.ReloadPaymentTerms__c='';
                s.SAP_Order_Number__c='';
                for(Sales_Order_Line_Item__c sli : LineItems){
                    if(s.Name==sli.Sale_Order__r.Name){
                        if(s.ReloadPaymentTerms__c==''){
                            s.ReloadPaymentTerms__c = sli.SKU_Description__c;
                        }else{
                            s.ReloadPaymentTerms__c = s.ReloadPaymentTerms__c +' , '+sli.SKU_Description__c;
                        }
                    }
                    if(sli.Invoice_Reflection_Code__c!=null){
                        s.SAP_Order_Number__c = sli.Invoice_Reflection_Code__c;                        
                    }               
                }
                s.Total_Amount__c = (s.Total_Amount__c).setScale(3);
                 
            }
        }
        System.debug('soList---'+soList);
        return soList;

    }

    @AuraEnabled(cacheable = true)
    public static List<Sales_Order_Line_Item__c> fetchLineItem(String SOLIquery,String recordId){
        id userId = UserInfo.getUserId();
        User u = [select id, contactId, accountId, Country from User where id = : userId];
        SOLIquery+=' where Sale_Order__c='+'\''+recordId+'\'';
        System.debug(SOLIquery);
        List<Sales_Order_Line_Item__c> LineItemList=new List<Sales_Order_Line_Item__c>();
        LineItemList=Database.query(SOLIquery);
        if(u.Country=='Japan'){
            for(Sales_Order_Line_Item__c lineItem : LineItemList){
                if((lineItem.SKU_Code__c=='000000000006290128' || lineItem.SKU_Code__c=='000000000005291289') && lineItem.Item_Status__c=='Completely processed'){
                    lineItem.Net_Price__c = null;
                    lineItem.Special_Discount__c = null;
                }else{
                    if(lineItem.Net_Price__c!=null){
                        Decimal netPrice = lineItem.Net_Price__c * lineItem.Quantity__c;
                        lineItem.Net_Price__c = netPrice;
                    }
                    if(lineItem.Special_Discount__c!=null){
                        Decimal discount = lineItem.Special_Discount__c * lineItem.Quantity__c;
                        lineItem.Special_Discount__c = discount;
                    }   
                }
                              
            }
        }
        return LineItemList;
    }

    @AuraEnabled(cacheable = true)
    public static List<WrapAS> fetchAccountSummary(Id recordId){
        id userId = UserInfo.getUserId();
        User u = [select id, contactId, accountId, Country from User where id = : userId];
        List<WrapAS> WrapASList = new List<WrapAS>();

            List<Sales_Order__c> accDetails = [SELECT Id, Sold_To_Party__c, Sold_To_Party__r.Name, Sold_To_Party__r.SAP_Code__c, Shipping_Location_Name__c, Shipping_Location_Code__c FROM Sales_Order__c WHERE Id=:recordId];
            String accId = accDetails[0].Sold_To_Party__c;
            List<Account> aList = [SELECT Id, Name, SAP_Code__c FROM Account WHERE Id=:accId];
        
            List<Credit_Info__c> ciList = [SELECT id, name,Distributor__c,distributor__r.name,distributor__r.SAP_Code__c,  
                                       Credit_Limit__c,Balance_Limit__c,Used_Limit__c,  
                                       Internal_Limit__c, Sum_Open_Item__c, DAYS_ARREARS__c     
                                       FROM Credit_Info__c  
                                       WHERE Distributor__c =:accId LIMIT 1];

            List<Outstanding_Ageing__c> oagList = [SELECT id, OutstandingTotalGreaterthan90__c, Net_Outstanding__c  
                                                FROM Outstanding_Ageing__c   
                                                WHERE Customer_Code__c =:accId LIMIT 1];        
                 
        WrapAS ASDetails = new WrapAS(); 
        if(u.Country=='Japan'){
            ASDetails.CustomerName=accDetails[0].Sold_To_Party__r.Name; 
            ASDetails.SAPCode=accDetails[0].Sold_To_Party__r.SAP_Code__c;
            ASDetails.ShippingLocationName=accDetails[0].Shipping_Location_Name__c; 
            ASDetails.ShippingLocationCode=accDetails[0].Shipping_Location_Code__c;
        }else{
            ASDetails.CustomerName=ciList[0].distributor__r.name; 
            ASDetails.SAPCode=ciList[0].distributor__r.SAP_Code__c;
            ASDetails.CreditLimit=ciList[0].Credit_Limit__c;
            ASDetails.UsedLimit =ciList[0].Used_Limit__c;
            ASDetails.BalanceLimit =ciList[0].Balance_Limit__c;
            ASDetails.InternalLimit =ciList[0].Internal_Limit__c;
            ASDetails.Outstanding =oagList[0].Net_Outstanding__c;
        }        
        WrapASList.add(ASDetails);
        return WrapASList;
    }

    @AuraEnabled(cacheable = true)
    public static List<Parent_Child_Mapping__c> findChildAccounts(){
        id userId = UserInfo.getUserId();
        User u = [select id, contactId, accountId, Country from User where id = : userId];
        List<Parent_Child_Mapping__c> childList = new List<Parent_Child_Mapping__c>();    
        childList = [select Parent_Account__c, Child_Account__c, Child_Account__r.Name, Active__c from Parent_Child_Mapping__c where Parent_Account__c=:u.accountId and Active__c=True];        
        return childList;
    }


    @AuraEnabled(cacheable = true)
    public static List<Sales_Order__c> searchOrder(String query){
        id userId = UserInfo.getUserId();
        System.debug(userId);
        User u = [select id, contactId, accountId, Country from User where id = : userId];
        System.debug(query);
        String rejected='Rejected';
        //Integer psize = Integer.valueOf(pageSize);
        //Integer pnumber = Integer.valueOf(pageNumber)-1;  
        if(Test.isRunningTest()){
        query+=' where SAP_Order_Number__c!=\'\'';
        }
        else{
        if(u.Country=='Colombia'){
         query+=' AND SAP_Order_Number__c!=\'\'';
         }
         }
        if(u.Country=='Japan' && !Test.isRunningTest()){
            query+=' AND Sale_Order__r.Order_Date__c = LAST_N_DAYS:730 AND Sale_Order__r.Order_Status__c !=:rejected order by CreatedDate desc';
        }else{
            query+=' order by CreatedDate desc';
        }      
        List<Sales_Order_Line_Item__c> soli= new List<Sales_Order_Line_Item__c>();
        soli=Database.query(query);
        
        Map<Id,Sales_Order__c> salesOrderMap=new Map<Id,Sales_Order__c>();
        for(Sales_Order_Line_Item__c s : soli){
            if(u.Country=='Colombia' && s.Sale_Order__r.Net_Amount__c!=null){
                s.Sale_Order__r.Total_Amount__c = s.Sale_Order__r.Net_Amount__c.setScale(3);
            }else{
                s.Sale_Order__r.Total_Amount__c = s.Sale_Order__r.Total_Amount__c.setScale(3);
                if(u.Country=='Japan')
                {
                s.Sale_Order__r.SAP_Order_Number__c='';
                }
            }            
            salesOrderMap.put(s.Sale_Order__r.Id,s.Sale_Order__r);
        }
        
        List<Sales_Order__c> salesOrder=salesOrderMap.values();
        Map<Id,Sales_Order__c> japanSalesOrderMap=new Map<Id,Sales_Order__c>();
        if(u.Country=='Japan'){
            for(Sales_Order_Line_Item__c sli : soli){          
                if(japanSalesOrderMap.containsKey(sli.Sale_Order__r.Id)){
                    Sales_Order__c order = japanSalesOrderMap.get(sli.Sale_Order__r.Id);
                    order.ReloadPaymentTerms__c = order.ReloadPaymentTerms__c +' , '+sli.SKU_Description__c;                    
                    japanSalesOrderMap.put(sli.Sale_Order__r.Id,order);
                }else{
                    sli.Sale_Order__r.ReloadPaymentTerms__c = sli.SKU_Description__c;                    
                    japanSalesOrderMap.put(sli.Sale_Order__r.Id,sli.Sale_Order__r);                    
                }
                
                if(sli.Invoice_Reflection_Code__c!=null){
                    sli.Sale_Order__r.SAP_Order_Number__c = sli.Invoice_Reflection_Code__c;                        
                }
            }
            salesOrder = japanSalesOrderMap.values();
            
        }

        return salesOrder;
    }

    @AuraEnabled(cacheable = true)
    public static List<String> searchProduct(String accountId){
        if(accountId.length()>18){
            accountId = accountId;
        }else{
            accountId = '\''+accountId+'\'';
        }
        System.debug(accountId);
        id userId = UserInfo.getUserId();
        System.debug(userId);
        User u = [select id, contactId, accountId, Country from User where id = : userId];
        String AccId = u.accountId;
        String query = 'SELECT Id,SKU_Name__r.Product_Name__r.Name,SKU_Name__r.Product_Name__c,SKU_Name__r.SKU_Description__c FROM Sales_Order_Line_Item__c where Sale_Order__r.Sold_To_Party__c IN (' +accountId+ ')';
        if(u.Country=='Japan'){
            query+=' AND Sale_Order__r.Order_Date__c = LAST_N_DAYS:730 order by SKU_Name__r.SKU_Description__c asc';
        }else{
            query+='order by SKU_Name__r.SKU_Description__c asc';
        }
        System.debug(query);
        List<Sales_Order_Line_Item__c> product=[SELECT Id,SKU_Name__r.Product_Name__r.Name,SKU_Name__r.Product_Name__c,SKU_Name__r.SKU_Description__c FROM Sales_Order_Line_Item__c where Sale_Order__r.Sold_To_Party__c IN (:accountId) order by SKU_Name__r.SKU_Description__c asc]; 
        product=Database.query(query);
        List<String> productname=new List<String>();
        for(Sales_Order_Line_Item__c s : product){
            String pname='';      
            pname=s.SKU_Name__r.SKU_Description__c;                 
            productname.add(pname);
        }
        return productname;
    }

    @AuraEnabled(cacheable = true)
    public static List<user> fetchUser(){
        id userId = UserInfo.getUserId();
        System.debug(userId);
        //List<Id> accountId = new List<Id>();
        List<user> u = [select id, Name, contactId, accountId, account.SAP_Code__c from User where id = : userId];
        //accountId.add(u.accountId);
        return u;
    }

    @AuraEnabled(cacheable = true)
    public static Community_Configuration__c getCommunityConfiguration(){
        id userId = UserInfo.getUserId();
        User user = [select id, Name, contactId, accountId, Country from User where id = : userId];
        System.debug(user.accountId);
        Community_Configuration__c config=new Community_Configuration__c();
        config=[SELECT Id, Name, Country__c, Sales_Order_Line_Item_SOQL__c, SO_Header_Column__c, SOLI_Column__c, Sales_Org__c FROM Community_Configuration__c where RecordType.Name='Order Summary' and Country__c=:user.Country];
        System.debug('Configuration Data---'+config);
        return config;
    }

    @AuraEnabled
    public static Community_Url_Configuration__c getCummunityURL(){
        Community_Url_Configuration__c commnityurl=[SELECT Id, Name, URL__c FROM Community_Url_Configuration__c WHERE  Name ='Distributors Community URL' limit 1];
        return commnityurl;
    }

    public class WrapOS{
        public List<Sales_Order__c> soWrapList{get;set;}
        public String SalesOrderNo {get;set;}
        public String SAPOrderNo {get;set;}
        public String OrderDate {get;set;}
        public String POOrderNo {get;set;}
        public Decimal Quantity {get;set;}
        public Decimal TotalAmount {get;set;}
        public String TotalAmountWithComma {get;set;}
        public String Status {get;set;}
        public String IncoTerm {get;set;}
        public String SKUDesc {get;set;}
        public String childAccountName {get;set;}
        public String childSAPCode {get;set;}
        public String shipToPartyName {get;set;}
        public WrapOs(){
            SalesOrderNo = '';
            SAPOrderNo = '';
            OrderDate = '';
            POOrderNo = '';
            Quantity = 0;
            TotalAmount = 0;
            TotalAmountWithComma = '';
            Status = '';
            IncoTerm = '';
            SKUDesc = '';
            childAccountName = '';
            childSAPCode = '';
            shipToPartyName='';
            soWrapList=new List<Sales_Order__c>();
        }
    }

    public class WrapAS{
        @AuraEnabled
        public String CustomerName {get;set;}
        @AuraEnabled
        public String SAPCode {get;set;}
        @AuraEnabled
        public String ShippingLocationName {get;set;}
        @AuraEnabled
        public String ShippingLocationCode {get;set;}
        @AuraEnabled
        public Decimal CreditLimit {get;set;}
        @AuraEnabled
        public Decimal UsedLimit {get;set;}
        @AuraEnabled
        public Decimal BalanceLimit {get;set;}
        @AuraEnabled
        public Decimal InternalLimit {get;set;}
        @AuraEnabled
        public Decimal Outstanding {get;set;}
        public WrapAs(){
            CustomerName = '';
            SAPCode = '';
            ShippingLocationName = '';
            ShippingLocationCode = '';
            CreditLimit = 0;
            UsedLimit = 0;
            BalanceLimit = 0;
            InternalLimit = 0;
            Outstanding = 0;
        }
    }



}