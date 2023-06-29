@isTest
public class DistributorShipmentDataController_Test {
    
    @TestSetup
    static void makeData(){
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
    	Account a = new Account();
        a.Name = 'test_acc';
        a.Email__c= 'email@example.com';
        a.RecordTypeId = recordTypeId;
        a.SAP_Code__c = '00001';
        a.CurrencyIsoCode = 'USD';
        insert a;
        
        SKU__c sku1 = new SKU__c();
        sku1.Name = 'a1C0k000000idgd';
        sku1.SKU_Description__c = 'test sku';
        sku1.SKU_Code__c = '000000000005290244';
        sku1.CurrencyIsoCode = 'INR';
        sku1.Combination_Key__c = '67311010000000000005290244';
        insert sku1;

        Zone__c zone1 = new Zone__c();
        zone1.Name = 'Tokyo';
        zone1.ZoneCode__c = 'JP03';
        insert zone1;
		
        Region__c region1=new Region__c();
        region1.Name = 'ABC';
        region1.RegionCode__c = '12345';
        insert region1;
            
        Ex_Distributor_Shipment_Data__c eds = new Ex_Distributor_Shipment_Data__c();
        //eds.Area_in_Ex_Distributor_s_Customer__c= region1.Id;
        eds.Distributors_Area__c =region1.Id;
        eds.Distributor_s_Office__c=zone1.Id;
        eds.Material__c=sku1.Id;
        eds.Distributor__c=a.Id;
        eds.Chemical_IPM__c='';
        //eds.Sales_Office_of_Ex_Distributor__c='';
        //eds.Area_Name__c='';
        //eds.Sales_Office_Name__c='';
        eds.UPL_FY__c='';
        eds.Calendar_Year__c='';
        eds.Month__c='';
        //eds.Distributor_Name__c='';
        //eds.Distributor_Office_Name__c='';
        eds.Region_in_Ex_Distributor_s_Customer__c='';
        eds.District_in_Ex_Distributor_s_Customer__c='';
        eds.Customer_Category__c='';
        eds.JA_Area_Name__c='';
        //eds.Material_Name__c='';
        //eds.Single_Pack_Size__c='';
        eds.Volume__c=10;
        eds.Pesticidal_Year__c='';
        eds.Price_per_single_bottle_bag__c=10;
        eds.Amount_JPY__c=100;
        eds.Order_Type__c='';
        //eds.Material_Code__c='';
        eds.Customer_Address__c='';
        eds.IPM_NEW__c='';
        eds.Single_bottle_bag_number_in_Case__c=10;
        
        insert eds;
        
        EnglishSalesTeamChatbotSetting__c chatsetting = new EnglishSalesTeamChatbotSetting__c(Name = 'Eisenstein Connected App Setting',
         ConsumerKey__c ='3MVG959Nd8JMmavRSwlR5Gb2jnSckER71LcEIUP6TkU6c5.84TFYWEByi8.FZYj8ZXJ',
         End_Point__c ='email@test.com',
         siteBase__c='https://test.salesforce.com');
         insert chatsetting;
    }

    static testmethod void testGetTotalRecordcount(){
        DistributorShipmentDataController.getTotalRecCount('','','','','','');
        DistributorShipmentDataController.getTotalRecCount('test','','','','','');
        DistributorShipmentDataController.getTotalRecCount('test','','','','','5');
        DistributorShipmentDataController.getTotalRecCount('test','','','','2018','');
        DistributorShipmentDataController.getTotalRecCount('test','','','','2018','5');
        DistributorShipmentDataController.getTotalRecCount('','t123','','','','');
        DistributorShipmentDataController.getTotalRecCount('','t123','','','','5');
        DistributorShipmentDataController.getTotalRecCount('','t123','','','2018','');
        DistributorShipmentDataController.getTotalRecCount('','t123','','','2018','5');
        DistributorShipmentDataController.getTotalRecCount('','','000000000005290244','','','');
        DistributorShipmentDataController.getTotalRecCount('','','000000000005290244','','','5');
        DistributorShipmentDataController.getTotalRecCount('','','000000000005290244','','2018','');
        DistributorShipmentDataController.getTotalRecCount('','','000000000005290244','','2018','5');
        DistributorShipmentDataController.getTotalRecCount('','t123','000000000005290244','','2018','5');
        DistributorShipmentDataController.getTotalRecCount('','','','test sku','','');
        DistributorShipmentDataController.getTotalRecCount('','','','test sku','','5');
        DistributorShipmentDataController.getTotalRecCount('','','','test sku','2018','');
        DistributorShipmentDataController.getTotalRecCount('','','','test sku','2018','5');
        DistributorShipmentDataController.getTotalRecCount('test','','','test sku','2018','5');
        DistributorShipmentDataController.getTotalRecCount('','','','','2018','');
        DistributorShipmentDataController.getTotalRecCount('','','','','','5');
        DistributorShipmentDataController.getDistributorShipmentData('5','5','','','','','','','5');
        DistributorShipmentDataController.getDistributorShipmentData('5','5','name','code','mname','mcode','year','month','5');
        DistributorShipmentDataController.getDistributorShipmentData('5','5','test','','','','','5','5');
        DistributorShipmentDataController.getDistributorShipmentData('5','5','test','','','','2018','','5');
        DistributorShipmentDataController.getDistributorShipmentData('5','5','test','','','','2018','5','5');
        DistributorShipmentDataController.getDistributorShipmentData('5','5','','t123','','','','5','5');
        DistributorShipmentDataController.getDistributorShipmentData('5','5','','t123','','','2018','','5');
        DistributorShipmentDataController.getDistributorShipmentData('5','5','','t123','','','2018','5','5');
        DistributorShipmentDataController.getDistributorShipmentData('5','5','','t123','000000000005290244','','','5','5');
        DistributorShipmentDataController.getDistributorShipmentData('5','5','','t123','000000000005290244','','2018','','5');
        DistributorShipmentDataController.getDistributorShipmentData('5','5','','t123','000000000005290244','','2018','5','5');
		DistributorShipmentDataController.getDistributorShipmentData('5','5','','t123','','test sku','','5','5');
        DistributorShipmentDataController.getDistributorShipmentData('5','5','','t123','','test sku','2018','','5');
        DistributorShipmentDataController.getDistributorShipmentData('5','5','','t123','','test sku','2018','5','5');
        DistributorShipmentDataController.getDistributorShipmentData('5','5','test','','','test sku','2018','5','5');
        DistributorShipmentDataController.getDistributorShipmentData('5','5','','','','','2018','5','5');
        DistributorShipmentDataController.getDistributorShipmentData('5','5','test','','','','','','5');
        DistributorShipmentDataController.getDistributorShipmentData('5','5','','t123','','','','','5');
        DistributorShipmentDataController.getDistributorShipmentData('5','5','','','000000000005290244','','','','5');
        DistributorShipmentDataController.getDistributorShipmentData('5','5','','','','test sku','','','5');
        DistributorShipmentDataController.getDistributorShipmentData('5','5','','','','','2018','','5');
        DistributorShipmentDataController.getDistributorShipmentData('5','5','','','','','','5','5');
		DistributorShipmentDataController.getMonthList();
        DistributorShipmentDataController.getFiscalYearList();
        
       
    }
}