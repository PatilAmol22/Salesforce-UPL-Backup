public class ReprocessOrderRedirect_Controller { 
    public static String SaleOrderId ;

    public ReprocessOrderRedirect_Controller(ApexPages.StandardController controller) {
        
       String soId = controller.getRecord().Id;
        SaleOrderId = soId;
        
        System.debug(' SaleOrderId '+ SaleOrderId);
        /*Sales_Order__c SalesOrderObj = [SELECT Id,Order_Status__c,ErrorMessage__c,SalesOrgCode__c FROM Sales_Order__c WHERE Id = :soId  limit 1];
        List<Sales_Order_Line_Item__c> soliList = new List<Sales_Order_Line_Item__c>();
        List<Sales_Order_Line_Item__c> soliListUodate = new List<Sales_Order_Line_Item__c>();
        soliList = [SELECT Id,Item_Status__c FROM Sales_Order_Line_Item__c WHERE Sale_Order__c =: SalesOrderObj.Id];
        System.debug('soliList.size()---> '+soliList.size());
        System.debug('SalesOrderObj-->'+SalesOrderObj.ErrorMessage__c);
        
        if(SalesOrderObj.SalesOrgCode__c!='5191' && SalesOrderObj.Order_Status__c == 'In Transit' ){
           
           // for (Integer i =0; i < soliList.size(); i++){
            for(Sales_Order_Line_Item__c soliObj:soliList) {
                soliObj.Item_Status__c='Active'; 
                soliListUodate.add(soliObj);
            }
           
            //}
            System.debug('Before SOLi update');
           // update soliList;
            update soliListUodate;
            System.debug('after SOLi update');
            
            SalesOrderObj.Order_Status__c = 'Open';
            SalesOrderObj.ErrorMessage__c = null;
            
            System.debug('Before SO update');
            update SalesOrderObj;
            System.debug('after SO update');
            refreshPage();
          }*/

    }
    
    
    Public void updateSoLineItem(){
       Sales_Order__c SalesOrderObj = [SELECT Id,Order_Status__c,ErrorMessage__c,SalesOrgCode__c FROM Sales_Order__c WHERE Id = :SaleOrderId  limit 1]; 
        System.debug('SalesOrderObj '+SalesOrderObj);
           ///////// below if block only added by vijaylaxmi # CHG0033316
           String ErrorMessage=SalesOrderObj.ErrorMessage__c;
           String searchStr='Could not receive Message';	
            if(ErrorMessage!=null && ErrorMessage.containsIgnoreCase(searchStr))
            {
                // Do nothing 
            }
        	else{
            
        
        
        
        List<Sales_Order_Line_Item__c> soliList = new List<Sales_Order_Line_Item__c>();
        List<Sales_Order_Line_Item__c> soliListUodate = new List<Sales_Order_Line_Item__c>();
        soliList = [SELECT Id,Item_Status__c FROM Sales_Order_Line_Item__c WHERE Sale_Order__c =: SalesOrderObj.Id];
        
         System.debug('soliList.size()---> '+soliList.size());
        System.debug('SalesOrderObj-->'+SalesOrderObj.ErrorMessage__c);
        System.debug('SalesOrderObj.Order_Status__c '+SalesOrderObj.Order_Status__c);
      
      
        
        if((SalesOrderObj.SalesOrgCode__c!='5191' ) && (SalesOrderObj.Order_Status__c == 'In Transit' || SalesOrderObj.Order_Status__c == 'Error in SAP' || SalesOrderObj.Order_Status__c == 'Error from SAP'))
        {
          System.debug('Line 61-->');
           
                
            System.debug('Line 65-->');
            for(Sales_Order_Line_Item__c soliObj:soliList) {
                soliObj.Item_Status__c='Active'; 
                soliListUodate.add(soliObj);
            }
           
            //}
            System.debug('Before SOLi update');
           // update soliList;
            update soliListUodate;
            System.debug('after SOLi update');
            
            SalesOrderObj.Order_Status__c = 'Open';
            SalesOrderObj.ErrorMessage__c = null;
            
            System.debug('Before SO update');
            update SalesOrderObj;
            System.debug('after SO update');
            System.debug('url.getSalesforceBaseUrl().toExternalForm() '+url.getSalesforceBaseUrl().toExternalForm()); 
            //refreshPage();
        }
      }
        
    }
    
    public PageReference refreshPage(){
        PageReference pageRef = new PageReference(url.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Sales_Order__c/'+SaleOrderId+'/view?0.source=alohaHeader');
        pageRef.setRedirect(true);
        System.debug('In re direct');
        return pageRef;
    }
}