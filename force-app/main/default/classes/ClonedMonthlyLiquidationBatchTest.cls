@isTest
public class ClonedMonthlyLiquidationBatchTest {
    @isTest
    static void TestmonthlyLiquidationBatch(){
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');   
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String orgId = UserInfo.getOrganizationId();
        String uniqueName = orgId + dateString + randomInt;
        
        
        
        Liquidation_Batch_Filters__c lbf2 = new Liquidation_Batch_Filters__c();
        lbf2.Name = 'Poland';
        lbf2.Sales_Org_Filter__c = 'Sales_Org_Code__c = \'2941\'';
        lbf2.Account_Type_Filter__c ='AccountType__c = \'Sold To Party\'';
        lbf2.Distributor_Filter__c = 'name != \'\'';
        lbf2.Sales_District_Filter__c = 'id != \'\'';
        lbf2.Active__c = true;
        
        insert lbf2;
        
        
        Liquidation_Batch_Filters__c mexicolbf1 = new Liquidation_Batch_Filters__c();
        mexicolbf1.Name = 'Mexico';
        mexicolbf1.Sales_Org_Filter__c = 'Sales_Org_Code__c = \'5100\'';
        mexicolbf1.Account_Type_Filter__c ='AccountType__c = \'Sold To Party\'';
        mexicolbf1.Distributor_Filter__c = 'name != \'\'';
        mexicolbf1.Sales_District_Filter__c = 'id != \'\'';
        mexicolbf1.Active__c = true;
        insert mexicolbf1;
        
        
        Sales_Org__c salesOrgTurkey = new Sales_Org__c(
            Name = 'Turkey',               
            Company_Code__c = '7100',        
            Sales_Org_Code__c = '7110',      
            Description__c = 'Turkey'      
        );
        insert salesOrgTurkey;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt1', 
                          EmailEncodingKey='UTF-8',
                          LastName='Testing',
                          Country = 'Turkey',
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id,                 
                          TimeZoneSidKey='America/Los_Angeles',
                          email = uniqueName + '@test' + orgId + '.org',
                          Username = uniqueName + '@test' + orgId + '.org');
        insert u;
        List<Sales_Org__c> soList=new List<Sales_Org__c>();
        Sales_Org__c salorg = new Sales_Org__c();
        salorg.name = 'Indo1';
        salorg.Sales_Org_Code__c = '6451';
        soList.add(salorg);
        Sales_Org__c salorg1 = new Sales_Org__c();
        salorg1.name = 'Poland';
        salorg1.Sales_Org_Code__c = '2941';
        soList.add(salorg1);      
       
        insert soList;
        
        Sales_Org__c mexicoSalesOrg = new Sales_Org__c();
        mexicoSalesOrg.name = 'Mexico';
        mexicoSalesOrg.Sales_Org_Code__c = '5100';
        insert mexicoSalesOrg;
        
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account a1 = new Account();
        a1.Name = 'Test';
        a1.RecordTypeId = RecordTypeId;
        a1.SAP_Code__c = '12346';
        insert a1;
        
        
        
        Sales_District__c s1 = new Sales_District__c();
        s1.SalesOrg__c = salesOrgTurkey.Id;
        s1.User__c = u.Id;
        s1.Sales_District_Code__c = '4684684';
        insert s1;
        
        List<SKU__c> skuList=new List<SKU__c>();
        SKU__c sku1 = new SKU__c();
        sku1.Active_for_Liquidation__c = true;
        sku1.SKU_Code__c = '123';
        sku1.Sales_Org__c = salorg.Id;
        skuList.add(sku1);
        SKU__c sku11 = new SKU__c();
        sku11.Active_for_Liquidation__c = true;
        sku11.SKU_Code__c = '1231';
        sku11.Sales_Org__c = salorg1.Id;
        skuList.add(sku11);
        insert skuList;
        
        //Mexico
        SKU__c mexicoSKU = new SKU__c();
        mexicoSKU.Active_for_Liquidation__c = true;
        mexicoSKU.SKU_Code__c = '1231';
        mexicoSKU.Sales_Org__c = mexicoSalesOrg.Id;
        insert mexicoSKU;      
        
        
        List<Liquidation_Annual_Plan__c> lapList=new List<Liquidation_Annual_Plan__c>();
        Liquidation_Annual_Plan__c lap1 = new Liquidation_Annual_Plan__c();
        lap1.Fiscal_Start_Date__c = Date.parse('01/04/23');
        lap1.FIscal_Year__c = '2023-2024';
        lap1.Sales_Org__c = salorg.Id;
        
        lapList.add(lap1);
        Liquidation_Annual_Plan__c lap11 = new Liquidation_Annual_Plan__c();
        lap11.Fiscal_Start_Date__c = Date.parse('01/04/23');
        lap11.FIscal_Year__c = '2023-2024';
        lap11.Sales_Org__c = salorg1.Id;
        
        lapList.add(lap11);
		
		//Liquidation_Annual_Plan__c lap3 = new Liquidation_Annual_Plan__c();
        //lap3.Fiscal_Start_Date__c = Date.parse('01/04/23');
        //lap3.FIscal_Year__c = '2023-2024';
        //lap3.Sales_Org__c = mexicoSalesOrg.Id;
        
        //lapList.add(lap3);     
        
        insert lapList;
        
        Liquidation_Annual_Plan__c mexicoLap = new Liquidation_Annual_Plan__c();
        mexicoLap.Fiscal_Start_Date__c = Date.parse('01/04/23');
        mexicoLap.FIscal_Year__c = '2023-2024';
        mexicoLap.Sales_Org__c = mexicoSalesOrg.Id;
        insert mexicoLap;
        
        Shipping_Location__c shp = new 	Shipping_Location__c();
        shp.Active__c=true;
        shp.SAP_Code__c='123456';
        shp.User__c=u.Id;
        insert shp;
        
        Sales_District__c sdc = new Sales_District__c();
        sdc.User__c=u.Id;
        sdc.Name='TestDistrict';
        sdc.Sales_District_Code__c='123456';
        insert sdc;
        
        RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Opening_Inventory2__c' and Name='Multi Country'];
        system.debug('rt--->'+rt);
        List<Opening_Inventory2__c> oiList=new List<Opening_Inventory2__c>();
        
        Opening_Inventory2__c o1 = new Opening_Inventory2__c();
        o1.Liquidation_Annual_Plan__c = lap1.Id;
        o1.Multi_Country_Key__c = '12345';
        o1.RecordTypeId = rt.Id;
        o1.Distributor__c = a1.Id;
        o1.SKU__c = sku1.Id;
        o1.Sent_to_Batch__c = false;
        o1.Sales_District__c=sdc.Id;
        o1.Ship_To_Party__c=shp.Id;
        oiList.add(o1);
        
        Opening_Inventory2__c o11 = new Opening_Inventory2__c();
        o11.Liquidation_Annual_Plan__c = lap11.Id;
        o11.Multi_Country_Key__c = '12345';
        o11.RecordTypeId = rt.Id;
        o11.Distributor__c = a1.Id;
        o11.SKU__c = sku11.Id;
        o11.Sent_to_Batch__c = false;
        o11.Sales_District__c=sdc.Id;
        o11.Ship_To_Party__c=shp.Id;
        oiList.add(o11);
        insert oiList;
        system.debug(o1);
        
        //Mexico
		Opening_Inventory2__c mexicoOpenInv = new Opening_Inventory2__c();
        mexicoOpenInv.Liquidation_Annual_Plan__c = mexicoLap.Id;
        mexicoOpenInv.Multi_Country_Key__c = '12345';
        mexicoOpenInv.RecordTypeId = rt.Id;
        mexicoOpenInv.Distributor__c = a1.Id;
        mexicoOpenInv.SKU__c = mexicoSKU.Id;
        mexicoOpenInv.Sent_to_Batch__c = false;
        mexicoOpenInv.Sales_District__c=sdc.Id;
        mexicoOpenInv.Ship_To_Party__c=shp.Id;
        insert mexicoOpenInv;        
        
        Liquidation2__c l1 = new Liquidation2__c ();
        l1.Month__c = 'Oct';
        l1.Liquidation_Annual_Plan__c = lap1.Id;
        l1.SKU__c = sku1.Id;
        l1.Plan_for_the_next_month__c=0.0;
        insert l1;
        
        Liquidation_Batch_Filters__c lbf1 = new Liquidation_Batch_Filters__c();
        lbf1.Name = 'Indonesia';
        lbf1.Sales_Org_Filter__c = 'Sales_Org_Code__c = \'6451\'';
        lbf1.Account_Type_Filter__c ='AccountType__c = \'Sold To Party\'';
        lbf1.Distributor_Filter__c = 'name != \'\'';
        lbf1.Sales_District_Filter__c = 'id != \'\'';
        lbf1.Active__c = true;
        insert lbf1;
        
        MultiCountry_Liquidation__c montlyliq = new MultiCountry_Liquidation__c();
        montlyliq.Name = 'All Countries';
        montlyliq.Active_Month__c = true;
        montlyliq.Month__c = 'Apr';
        montlyliq.Previous_Month__c = 'Mar';
        insert montlyliq;
        
        MultiCountry_Liquidation__c mexicoMontlyliq = new MultiCountry_Liquidation__c();
        mexicoMontlyliq.Name = 'Mexico';
        mexicoMontlyliq.Active_Month__c = true;
        mexicoMontlyliq.Month__c = 'Apr';
        mexicoMontlyliq.Previous_Month__c = 'Mar';
        insert mexicoMontlyliq;
        
        
        ClonedMonthlyLiquidationBatch sh1 = new ClonedMonthlyLiquidationBatch(); 
          sh1.automationORnot=true;
        
        String a=Database.executeBatch(sh1);
        //  system.debug('a==>'+a);
    }
    
    
    @isTest
    static void TestmonthlyLiquidationBatch1(){
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');   
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String orgId = UserInfo.getOrganizationId();
        String uniqueName = orgId + dateString + randomInt;
        
        
        Liquidation_Batch_Filters__c lbf2 = new Liquidation_Batch_Filters__c();
        lbf2.Name = 'Poland';
        lbf2.Sales_Org_Filter__c = 'Sales_Org_Code__c = \'2941\'';
        lbf2.Account_Type_Filter__c ='AccountType__c = \'Sold To Party\'';
        lbf2.Distributor_Filter__c = 'name != \'\'';
        lbf2.Sales_District_Filter__c = 'id != \'\'';
        lbf2.Active__c = true;
        
        insert lbf2;
        
        
        Liquidation_Batch_Filters__c mexicolbf1 = new Liquidation_Batch_Filters__c();
        mexicolbf1.Name = 'Mexico';
        mexicolbf1.Sales_Org_Filter__c = 'Sales_Org_Code__c = \'5100\'';
        mexicolbf1.Account_Type_Filter__c ='AccountType__c = \'Sold To Party\'';
        mexicolbf1.Distributor_Filter__c = 'name != \'\'';
        mexicolbf1.Sales_District_Filter__c = 'id != \'\'';
        mexicolbf1.Active__c = true;
        insert mexicolbf1;
        
        
        Sales_Org__c salesOrgTurkey = new Sales_Org__c(
            Name = 'Turkey',               
            Company_Code__c = '7100',        
            Sales_Org_Code__c = '7110',      
            Description__c = 'Turkey'      
        );
        insert salesOrgTurkey;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt1', 
                          EmailEncodingKey='UTF-8',
                          LastName='Testing',
                          Country = 'Turkey',
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id,                 
                          TimeZoneSidKey='America/Los_Angeles',
                          email = uniqueName + '@test' + orgId + '.org',
                          Username = uniqueName + '@test' + orgId + '.org');
        insert u;
        
        List<Sales_Org__c> soList=new List<Sales_Org__c>();
        Sales_Org__c salorg = new Sales_Org__c();
        salorg.name = 'Indo1';
        salorg.Sales_Org_Code__c = '6451';
        soList.add(salorg);
        
        Sales_Org__c salorg1 = new Sales_Org__c();
        salorg1.name = 'Poland';
        salorg1.Sales_Org_Code__c = '2941';
        soList.add(salorg1);
        insert soList;
        
        Sales_Org__c mexicoSalesOrg = new Sales_Org__c();
        mexicoSalesOrg.name = 'Mexico';
        mexicoSalesOrg.Sales_Org_Code__c = '5100';
        insert mexicoSalesOrg;
        
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Account a1 = new Account();
        a1.Name = 'Test';
        a1.RecordTypeId = RecordTypeId;
        a1.SAP_Code__c = '12346';
        insert a1;
        
        
        Sales_District__c s1 = new Sales_District__c();
        s1.SalesOrg__c = salesOrgTurkey.Id;
        s1.User__c = u.Id;
        s1.Sales_District_Code__c = '4684684';
        insert s1;
        
        List<SKU__c> skuList=new List<SKU__c>();
        SKU__c sku1 = new SKU__c();
        sku1.Active_for_Liquidation__c = true;
        sku1.SKU_Code__c = '123';
        sku1.Sales_Org__c = soList[0].Id;// salorg.Id;
        skuList.add(sku1);
        
        SKU__c sku11 = new SKU__c();
        sku11.Active_for_Liquidation__c = true;
        sku11.SKU_Code__c = '1231';
        sku11.Sales_Org__c = soList[1].Id; //salorg1.Id;
        skuList.add(sku11);
        insert skuList;
        
        
        SKU__c mexicoSKU = new SKU__c();
        mexicoSKU.Active_for_Liquidation__c = true;
        mexicoSKU.SKU_Code__c = '1231';
        mexicoSKU.Sales_Org__c = mexicoSalesOrg.Id;
        insert mexicoSKU;
        
        
        List<Liquidation_Annual_Plan__c> lapList=new List<Liquidation_Annual_Plan__c>();
        Liquidation_Annual_Plan__c lap1 = new Liquidation_Annual_Plan__c();
        lap1.Fiscal_Start_Date__c = Date.parse('01/04/23');
        lap1.FIscal_Year__c = '2023-2024';
        lap1.Sales_Org__c = soList[0].Id;// salorg.Id;
        
        lapList.add(lap1);
        
        Liquidation_Annual_Plan__c lap11 = new Liquidation_Annual_Plan__c();
        lap11.Fiscal_Start_Date__c = Date.parse('01/04/23');
        lap11.FIscal_Year__c = '2023-2024';
        lap11.Sales_Org__c = soList[1].id; //salorg1.Id;
        
        lapList.add(lap11);
        insert lapList;
        
        Liquidation_Annual_Plan__c mexicoLap = new Liquidation_Annual_Plan__c();
        mexicoLap.Fiscal_Start_Date__c = Date.parse('01/04/23');
        mexicoLap.FIscal_Year__c = '2023-2024';
        mexicoLap.Sales_Org__c = mexicoSalesOrg.Id;
        insert mexicoLap;
        
        Shipping_Location__c shp = new 	Shipping_Location__c();
        shp.Active__c=true;
        shp.SAP_Code__c='123456';
        shp.User__c=u.Id;
        insert shp;
        
        Sales_District__c sdc = new Sales_District__c();
        sdc.User__c=u.Id;
        sdc.Name='TestDistrict';
        sdc.Sales_District_Code__c='123456';
        insert sdc;
        
        RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Opening_Inventory2__c' and Name='Multi Country'];
        system.debug('rt--->'+rt);
        
        List<Opening_Inventory2__c> oiList=new List<Opening_Inventory2__c>();
        Opening_Inventory2__c o1 = new Opening_Inventory2__c();
        o1.Liquidation_Annual_Plan__c = lap1.Id;
        o1.Multi_Country_Key__c = '12345';
        o1.RecordTypeId = rt.Id;
        o1.Distributor__c = a1.Id;
        o1.SKU__c = sku1.Id;
        o1.Sent_to_Batch__c = false;
        o1.Sales_District__c=sdc.Id;
        o1.Ship_To_Party__c=shp.Id;
        
        oiList.add(o1);
        Opening_Inventory2__c o11 = new Opening_Inventory2__c();
        o11.Liquidation_Annual_Plan__c = lap11.Id;
        o11.Multi_Country_Key__c = '12345';
        o11.RecordTypeId = rt.Id;
        o11.Distributor__c = a1.Id;
        o11.SKU__c = sku11.Id;
        o11.Sent_to_Batch__c = false;
        o11.Sales_District__c=sdc.Id;
        o11.Ship_To_Party__c=shp.Id;
        oiList.add(o11);
        insert oiList;
        system.debug(o1);
        
        Opening_Inventory2__c mexicoOpenInv = new Opening_Inventory2__c();
        mexicoOpenInv.Liquidation_Annual_Plan__c = mexicoLap.Id;
        mexicoOpenInv.Multi_Country_Key__c = '12345';
        mexicoOpenInv.RecordTypeId = rt.Id;
        mexicoOpenInv.Distributor__c = a1.Id;
        mexicoOpenInv.SKU__c = mexicoSKU.Id;
        mexicoOpenInv.Sent_to_Batch__c = false;
        mexicoOpenInv.Sales_District__c=sdc.Id;
        mexicoOpenInv.Ship_To_Party__c=shp.Id;
        insert mexicoOpenInv;
        
        Liquidation2__c l1 = new Liquidation2__c ();
        l1.Month__c = 'Oct';
        l1.Liquidation_Annual_Plan__c = lap1.Id;
        l1.SKU__c = sku1.Id;
        l1.Plan_for_the_next_month__c=0.0;
        insert l1;
        
        Liquidation_Batch_Filters__c lbf1 = new Liquidation_Batch_Filters__c();
        lbf1.Name = 'Indonesia';
        lbf1.Sales_Org_Filter__c = 'Sales_Org_Code__c = \'6451\'';
        lbf1.Account_Type_Filter__c ='AccountType__c = \'Sold To Party\'';
        lbf1.Distributor_Filter__c = 'name != \'\'';
        lbf1.Sales_District_Filter__c = 'id != \'\'';
        lbf1.Active__c = true;
        insert lbf1;
        
        
        
        MultiCountry_Liquidation__c montlyliq = new MultiCountry_Liquidation__c();
        montlyliq.Name = 'All Countries';
        montlyliq.Active_Month__c = true;
        montlyliq.Month__c = 'Apr';
        montlyliq.Previous_Month__c = 'Mar';
        insert montlyliq;
        
        MultiCountry_Liquidation__c mexicoMontlyliq = new MultiCountry_Liquidation__c();
        mexicoMontlyliq.Name = 'Mexico';
        mexicoMontlyliq.Active_Month__c = true;
        mexicoMontlyliq.Month__c = 'Apr';
        mexicoMontlyliq.Previous_Month__c = 'Mar';
        insert mexicoMontlyliq;
        
        
        ClonedMonthlyLiquidationBatch sh1 = new ClonedMonthlyLiquidationBatch(); 
        sh1.automationORnot=true;
        
        String a=Database.executeBatch(sh1);
        //  system.debug('a==>'+a);
    }
    
}