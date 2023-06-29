@isTest
public class OfflineLineItem_Test{
    
     /* 
        -----------------------------
        Developer Name - Pravin J.
        Created Date -  21/09/2017
        Last Modified Date - -------
        Description - class created for
        Mobile Development Purpose
        ------------------------------
    */
    
    
    public OfflineLineItem_Test(){
        System.debug('--Constructor Calling--');    
    }  
     
    private static testMethod void test1(){
    
        test.startTest();
        
        /*
                String body = 'Sales Org,Distribution Channel ,Division,Depot Code,Currency,SKU Code,UOM,Min Price,List Price,Start Date,End Date\r\n';
                body+='5631,10,10,AR13,USD,6070001,LTS,2.80,3,01.04.2017,31.03.2018\r\n';
                body+='5631,10,10,AR13,USD,6070041,LTS,2.80,3,01.04.2017,31.03.2018\r\n';
                
                FileUploadRESTAPI.processData(Blob.valueOf(body));
                FileUploadRESTAPI.sendEmail(body, body, 10, 10);
        
        */
       
        OfflineLineItem obj = new  OfflineLineItem();
        
        test.stopTest();
    
    }
}