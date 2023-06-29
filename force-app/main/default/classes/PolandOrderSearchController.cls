public with sharing class PolandOrderSearchController {

    @AuraEnabled
    public static OrderWrapper getOrderData(Decimal pageNumber, Decimal pageSize, String skuId, String strt_dt, String end_dt) {
        OrderWrapper objDT =  new OrderWrapper();  
        try{ 
            Integer pSize = (Integer)pageSize;
            Integer pNumber = (Integer)pageNumber;
        // Date st_Date;
        // Date ed_Date;
            String query = 'SELECT COUNT() FROM Sales_Order_Line_Item__c WHERE Sale_Order__c != null AND Sales_Org_Code__c=\''+ 2941+'\' AND Division__r.Division_Code__c IN (\''+ 10+'\',\''+ 60+'\') AND Distribution_Channel__r.Distribution_Channel_Code__c = \''+ 20+'\' ';
            String query2 = 'SELECT Id, Sale_Order__c, Sale_Order__r.Name, Sale_Order__r.SAP_Order_Number__c, SKU_Name__c, SKU_Description__c, Sale_Order__r.Order_Approval_Date__c, SKU_Code__c, Quantity__c FROM Sales_Order_Line_Item__c WHERE Sale_Order__c != null  AND Sales_Org_Code__c=\''+ 2941+'\' AND Division__r.Division_Code__c IN (\''+ 10+'\',\''+ 60+'\') AND Distribution_Channel__r.Distribution_Channel_Code__c = \''+ 20+'\'';
            System.debug('skuId 1 - '+ skuId);
            System.debug('strt_dt 1 - '+ strt_dt);
            System.debug('end_dt 1 - '+ end_dt);

            if(skuId.trim().length()>0){
                query = query + ' AND SKU_Name__c = \''+ skuId+'\' ';
                query2 = query2 + ' AND SKU_Name__c = \''+ skuId+'\' ';
            }

            if(strt_dt.trim().length()>0){
            //st_Date = Date.valueof(strt_dt);
            query = query + ' AND Sale_Order__r.Order_Approval_Date__c >='+ strt_dt;
            query2 = query2 + ' AND Sale_Order__r.Order_Approval_Date__c >='+ strt_dt;
            }

            if(end_dt.trim().length()>0){
            // ed_Date = Date.valueof(end_dt);
            query = query + ' AND Sale_Order__r.Order_Approval_Date__c <='+ end_dt;
            query2 = query2 + ' AND Sale_Order__r.Order_Approval_Date__c <='+ end_dt;
            }
        
            //Offset for SOQL
            Integer offset = (pNumber - 1) * pSize;

            query2 = query2 + ' LIMIT  '+pSize+ ' OFFSET '+offset;
            
            System.debug('Qurey 1 - '+ query);
            System.debug('Qurey 2 - '+ query2);
            //Total Records
            Integer totalRecords = Database.countQuery(query);
            /* [SELECT COUNT() FROM Sales_Order_Line_Item__c WHERE Sale_Order__c != null
                                    Sale_Order__r.Order_Approval_Date__c<= ]; */
            Integer recordEnd = pSize * pNumber;
    
            //Instance of Wrapper Class
            
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            objDT.orderList = Database.query(query2);
                            /* [SELECT Id, Sale_Order__c, Sale_Order__r.Name, Sale_Order__r.SAP_Order_Number__c, 
                            SKU_Name__c, SKU_Description__c, Sale_Order__r.Order_Approval_Date__c, SKU_Code__c, 
                            Quantity__c FROM Sales_Order_Line_Item__c LIMIT :pSize OFFSET :offset]; */
                            //[SELECT Id, Name, Phone, Email FROM Contact ORDER BY Name LIMIT :pSize OFFSET :offset];
        }
        catch(Exception ex){
            System.debug('Exception in getOrderData method : ' + ex);
            System.debug('Exception is : ' + ex);
            System.debug('Exception is : ' + ex.getLineNumber());
            return objDT;
        }                  
        return objDT;
    }

    @AuraEnabled
    public static List<OrderLineItemWrapper> getOrderDataToDownload(String skuId, String strt_dt, String end_dt) {
        List<OrderLineItemWrapper> ordrItemList = new List<OrderLineItemWrapper>(); 
        try{
            String query2 = 'SELECT Id, Sale_Order__c, Sale_Order__r.Name, Sale_Order__r.SAP_Order_Number__c, SKU_Name__c, SKU_Description__c, Sale_Order__r.Order_Approval_Date__c, SKU_Code__c, Quantity__c FROM Sales_Order_Line_Item__c WHERE Sale_Order__c != null AND Sales_Org_Code__c=\''+ 2941+'\' AND Division__r.Division_Code__c IN (\''+ 10+'\',\''+ 60+'\') AND Distribution_Channel__r.Distribution_Channel_Code__c = \''+ 20+'\' ';
            System.debug('skuId 1 - '+ skuId);
            System.debug('strt_dt 1 - '+ strt_dt);
            System.debug('end_dt 1 - '+ end_dt);

            if(skuId.trim().length()>0){
                query2 = query2 + ' AND SKU_Name__c = \''+ skuId+'\' ';
            }

            if(strt_dt.trim().length()>0){
            query2 = query2 + ' AND Sale_Order__r.Order_Approval_Date__c >='+ strt_dt;
            }

            if(end_dt.trim().length()>0){
            query2 = query2 + ' AND Sale_Order__r.Order_Approval_Date__c <='+ end_dt;
            }    

            query2 = query2 + ' LIMIT 500 '; // remove this.
            System.debug('Qurey 2 - '+ query2);

            List<Sales_Order_Line_Item__c> soiList = new List<Sales_Order_Line_Item__c>();
            soiList = Database.query(query2);

            if(soiList.size()>0){
                for(Sales_Order_Line_Item__c soi : soiList){
                    OrderLineItemWrapper olWrap = new OrderLineItemWrapper();
                    olWrap.Id = soi.Id;
                    olWrap.Name = '';
                    olWrap.Sales_Order_Number = soi.Sale_Order__r.Name;

                    if(soi.Sale_Order__r.SAP_Order_Number__c != null){
                        olWrap.SAP_Number = soi.Sale_Order__r.SAP_Order_Number__c;
                    }

                    if(soi.SKU_Code__c != null){
                        olWrap.SKU_Code = soi.SKU_Code__c;
                    }
                    
                    if(soi.SKU_Description__c != null){
                        olWrap.SKU_Description = soi.SKU_Description__c;
                    }

                    if(soi.Sale_Order__r.Order_Approval_Date__c != null){
                        olWrap.Date_Of_Approval = string.valueOf(soi.Sale_Order__r.Order_Approval_Date__c);
                    }

                    olWrap.Ordered_Quantity = soi.Quantity__c;

                    ordrItemList.add(olWrap);
                }
            }

        }
        catch(Exception ex){
            System.debug('Exception in getOrderDataToDownload method : ' + ex);
            System.debug('Exception is : ' + ex);
            System.debug('Exception is : ' + ex.getLineNumber());
            return ordrItemList;
        }
                        
        return ordrItemList;
    }

    //Wrapper Class 
    public class OrderLineItemWrapper {
        
        @AuraEnabled public String Id;
        @AuraEnabled public String Name;
        @AuraEnabled public String Sales_Order_Number;
        @AuraEnabled public String SAP_Number;
        @AuraEnabled public String SKU_Code;
        @AuraEnabled public String SKU_Description;
        @AuraEnabled public String Date_Of_Approval;
        @AuraEnabled public Decimal Ordered_Quantity;

        public OrderLineItemWrapper(){
            Id = '';
            Name = '';
            Sales_Order_Number = '';
            SAP_Number = '';
            SKU_Code = '';
            SKU_Description = '';
            Date_Of_Approval = '';
            Ordered_Quantity = 0.0;

        }

    }
    
    //Wrapper Class 
    public class OrderWrapper {
        @AuraEnabled
        public Integer pageSize {get;set;}
        @AuraEnabled
        public Integer pageNumber {get;set;}
        @AuraEnabled
        public Integer totalRecords {get;set;}
        @AuraEnabled
        public Integer recordStart {get;set;}
        @AuraEnabled
        public Integer recordEnd {get;set;}
        @AuraEnabled
        public List<Sales_Order_Line_Item__c> orderList {get;set;}
    }
}