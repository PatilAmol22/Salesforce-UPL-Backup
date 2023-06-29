/*
Class to Deactive Price Book For Brazil
Created by: Pragati Sharma
Test Class:TestClassForJavaScriptClass
*/

public class JavaScriptClass {
    public List<Price_Book__c> getIDs{get;set;}
    public String accIds{get;set;}
     public  static List<Id> IDS = new List<Id>();
    public  static Boolean initialised=false;
    
    public static ApexPages.StandardSetController setRFQ;
   
    
   public JavaScriptClass(ApexPages.StandardSetController controller){
       setRFQ=controller;
        getIDs = controller.getSelected();
        accIds = '';  
        System.debug('Get Selected'+getIDs);
        for(Price_Book__c acc : getIDs){
            IDS.add(acc.Id);
        }
       if(IDS!=null && !IDS.isEmpty()){
           initialised=true;
       }
     
    }
       
    public static void setActiveDeactive() {  
 
           set<id> priceBookIDS = new set<id>();
        System.debug('setRFQ.getSelected() == '+setRFQ.getSelected());
      for(Sobject acc : setRFQ.getSelected()){
            priceBookIDS.add(acc.Id);
        }
        System.debug('eneterd in setactiva'+priceBookIDS);
      
        List<Price_Book__c> pbList=new List<Price_Book__c>();
         
        pbList=[Select id,isActive__c,Status__c from Price_Book__c where Id in:priceBookIDS];
        try{  
            For(Price_Book__c pb:pbList){
                pb.isActive__c = false;  
                pb.Status__c= 'Canceled';     
            }
            if(pbList!=null && !pbList.isEmpty()){
                update pbList;  
            }
             
        } 
        catch(DmlException e){  
            System.debug('Exception occured ... '+e);    
        }  
         
        
    }  

}