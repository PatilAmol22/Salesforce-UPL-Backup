@isTest
public class PreventDuplicateRecordHandlerTest {
   @isTest
    
    Private static void  beforeInsertCombinationKeyTest(){
        
        Sales_District__c scObj = new  Sales_District__c(Name = 'new york', Sales_District_Code__c='2092');
    
        SKU__c skuObj = new SKU__c(Name='JK peanut', SKU_Code__c='1234', Combination_Key__c ='abcd12');


        Brazil_Region_SKU_Combination__c brskuOb = new Brazil_Region_SKU_Combination__c(Availability__c = 'yes',
                                                                                        Date__c=system.today(), 
                                                                                        Sales_District__c = scObj.Id,
                                                                                       SKU__c = skuObj.Id);
        
         insert brskuOb;
        
          /*   Sales_District__c scObj2 = new  Sales_District__c(Name = 'Malaysia', Sales_District_Code__c='4006');
        
             Brazil_Region_SKU_Combination__c brskuOb2 = [Select Id, Name, Date__c, Sales_District__c, SKU__c from Brazil_Region_SKU_Combination__c 
                                                     where Name = 'REGIONAL TRIÂNGULO' Limit 1];
            brskuOb2.Sales_District__c = scObj2.Id;       */
        
        //Sales_District__c scObj2 = new  Sales_District__c(Name = 'Malaysia', Sales_District_Code__c='4006');
        
        //SKU__c skuObj2 = new SKU__c(Name='JK peanut', SKU_Code__c='1234', Combination_Key__c ='abcd34');   
        
      /*  Brazil_Region_SKU_Combination__c brskuOb1 = new Brazil_Region_SKU_Combination__c(Availability__c = 'yes',
                                                                                        Date__c=system.today(), 
                                                                                        Sales_District__c = scObj.Id,
                                                                                       SKU__c = skuObj.Id);
          insert brskuOb1;  
        
       
           
        Brazil_Region_SKU_Combination__c brskuOb2 = new Brazil_Region_SKU_Combination__c(Availability__c = 'yes',
                                                                                        Date__c=system.today(), 
                                                                                        Sales_District__c = scObj.Id,
                                                                                       SKU__c = skuObj.Id);
        insert brskuOb2;   */  
        
        
       
        
    }           
    
    
       @isTest
    
        Private static void  beforeUpdateCombinationKeyTest(){
        
        Sales_District__c scObj = new  Sales_District__c(Name = 'washington', Sales_District_Code__c='2012');

        SKU__c skuObj = new SKU__c(Name='JK fact', SKU_Code__c='567891', Combination_Key__c ='ghjk23');


        Brazil_Region_SKU_Combination__c brskuOb = new Brazil_Region_SKU_Combination__c(Availability__c = 'yes',
                                                                                        Date__c=system.today(), 
                                                                                        Sales_District__c = scObj.Id,
                                                                                       SKU__c = skuObj.Id);
        
        insert brskuOb;
        
        //Sales_District__c sdObj2 = [Select Id, Name, Sales_District_Code__c from Sales_District__c where Id = 'a8D1m0000008STIEA2'];
      /*   Sales_District__c scObj2 = new  Sales_District__c(Name = 'Malaysia', Sales_District_Code__c='4006');
        
        Brazil_Region_SKU_Combination__c brskuOb2 = [Select Id, Name, Date__c, Sales_District__c, SKU__c from Brazil_Region_SKU_Combination__c 
                                                     where Name = 'REGIONAL TRIÂNGULO' Limit 1];
        brskuOb2.Sales_District__c = scObj2.Id; */
        Sales_District__c scObj2 = new  Sales_District__c(Name = 'madrid', Sales_District_Code__c='4006');
        SKU__c skuObj2 = new SKU__c(Name='JK peanut', SKU_Code__c='1234', Combination_Key__c ='abcd34');   
        
        brskuOb.Sales_District__c = scObj2.Id;
        brskuOb.SKU__c = skuObj2.Id;                            
        update brskuOb;  
        
         Sales_District__c scObj3 = new  Sales_District__c(Name = 'california', Sales_District_Code__c='4007');
        SKU__c skuObj3 = new SKU__c(Name='caroni', SKU_Code__c='9834', Combination_Key__c ='fhdj23'); 
        brskuOb.Sales_District__c = scObj3.Id;
        brskuOb.SKU__c = skuObj3.Id;  
        update brskuOb;  
            
           /* Brazil_Region_SKU_Combination__c brskuOb11 = [Select Id, Name, Combination_Key__c, Sales_District__c, SKU__c from  Brazil_Region_SKU_Combination__c
                                                         where id =: brskuOb.Id];
            brskuOb11.Sales_District__c = scObj3.Id;
        brskuOb11.SKU__c = skuObj3.Id;  
        update brskuOb11;   */
              
    }
    
}