@isTest
public class BrazilEnhancedListnewController_Test {
 
    @isTest static void testBarterNewController(){    
       Sales_order__c so = new Sales_order__c();   
       insert so;       
      //AccountNew is the Visualforce page created
       PageReference testPage = Page.BrazilEnhancedListforBarterNew; 
       Test.setCurrentPage(testPage);
       testPage.getParameters().put('Id', String.valueOf(so.Id));
        
       ApexPages.StandardController sc = new  ApexPages.StandardController(so);     
       BrazilEnhancedListforBarterNewController ext = new BrazilEnhancedListforBarterNewController(sc);         
         BrazilEnhancedListforBarterNewController ext1 = new BrazilEnhancedListforBarterNewController();         
       
   } 
        @isTest static void testSDMnewController(){    
       Sales_order__c so = new Sales_order__c();   
       insert so;       
      //AccountNew is the Visualforce page created
       PageReference testPage = Page.BrazilEnhancedListForSDMnew; 
       Test.setCurrentPage(testPage);
       testPage.getParameters().put('Id', String.valueOf(so.Id));
        
       ApexPages.StandardController sc = new  ApexPages.StandardController(so);     
       BrazilEnhancedListForSDMnewController ext = new BrazilEnhancedListForSDMnewController(sc);         
         BrazilEnhancedListForSDMnewController ext1 = new BrazilEnhancedListForSDMnewController();         
       
   }
        @isTest static void testSDNewController(){    
       Sales_order__c so = new Sales_order__c();   
       insert so;       
      //AccountNew is the Visualforce page created
       PageReference testPage = Page.BrazilEnhancedListForSDNew; 
       Test.setCurrentPage(testPage);
       testPage.getParameters().put('Id', String.valueOf(so.Id));
        
       ApexPages.StandardController sc = new  ApexPages.StandardController(so);     
       BrazilEnhancedListForSDNewController ext = new BrazilEnhancedListForSDNewController(sc);         
         BrazilEnhancedListForSDNewController ext1 = new BrazilEnhancedListForSDNewController();         
       
   }
        @isTest static void testSOMNewController(){    
       Sales_order__c so = new Sales_order__c();   
       insert so;       
      //AccountNew is the Visualforce page created
       PageReference testPage = Page.BrazilEnhancedListforSOMNew; 
       Test.setCurrentPage(testPage);
       testPage.getParameters().put('Id', String.valueOf(so.Id));
        
       ApexPages.StandardController sc = new  ApexPages.StandardController(so);     
       BrazilEnhancedListforSOMNewController ext = new BrazilEnhancedListforSOMNewController(sc);         
         BrazilEnhancedListforSOMNewController ext1 = new BrazilEnhancedListforSOMNewController();         
       
   }
  }