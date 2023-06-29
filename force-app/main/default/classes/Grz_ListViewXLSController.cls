/**************************************************************************************************
* Name               : Grz_ListViewXLSController                                                      
* Description        : Controller class for VF Pages to download data in XLS
* Test Class         : Grz_ListViewXLSControllerTest
* Created By         : Javed (Grazitti)                                                                       
**************************************************************************************************/
public without sharing class Grz_ListViewXLSController {
    public List<Customer_Conversion_factor__c> ccfData{ get; set; }
    public List<Market_Variation__c> mvData{ get; set; }
    public List<Sales_District_Cost__c> sdcData{ get; set; }
    public List<Discount_Matrix__c> dmData{ get; set; }
    
    public void Grz_getCCF(){
        try{            
            String query=' SELECT ID,name,Customer_Group__c,Brand_Name__C,Combination_Key__c,Conversion_Factor__c FROM Customer_Conversion_factor__c WHERE Sales_Org__r.Sales_Org_Code__c =\'5191\' ORDER BY createdDate DESC LIMIT 49990 ';
            ccfData = Database.query(query);
        }catch(Exception ex){
            system.debug(ex.getMessage());
        }
    }
    public void Grz_getMV(){
        try{            
            String query=' SELECT ID,name,Market_Variation__c,Combination_Key__c,Region_Code__c,Sales_District__c,Sales_District__r.Name,SKU_Brand__c FROM Market_Variation__c WHERE Sales_Org__r.Sales_Org_Code__c =\'5191\' ORDER BY createdDate DESC LIMIT 49990 ';
            mvData = Database.query(query);
        }catch(Exception ex){
            system.debug(ex.getMessage());
        }
    }
     public void Grz_getSdc(){
        try{            
            String query=' SELECT ID,name,Region__c,Combination_Key__c,Region_Code__c,Region__r.Name,Sales_District_Cost__c FROM Sales_District_Cost__c WHERE Sales_Org__r.Sales_Org_Code__c =\'5191\' ORDER BY createdDate DESC LIMIT 49990 ';
            sdcData = Database.query(query);
        }catch(Exception ex){
            system.debug(ex.getMessage());
        }
    }
     public void Grz_getDM(){
        try{            
            String query=' SELECT ID,name,Brand_Name__c,BU_Manager__c,Combination_key__c,Sales_Director__c,Sales_District_Manager__c,Sales_Person__c FROM Discount_Matrix__c ORDER BY createdDate DESC LIMIT 49990 ';
            dmData = Database.query(query);
        }catch(Exception ex){
            system.debug(ex.getMessage());
        }
    }
}