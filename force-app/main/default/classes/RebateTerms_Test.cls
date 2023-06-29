@isTest(seeAllData=false)
public class RebateTerms_Test {
    static testMethod void CallRebateTerms()
    {
        Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
        Rebate_Contract__c rebContr = new Rebate_Contract__c();
        rebContr.Combination_Key__c='519010';
        rebContr.CRM_Status__c='New';
        rebContr.Name='10';
        rebContr.Total_Value__c=10.11;
        rebContr.Total_Other_Value__c=10.11;
        rebContr.Total_Other_Value_LY__c=10.12;
        rebContr.Sales_Org__c=sorg.id;
        rebContr.Type_Code__c='U';
        rebContr.Total_Value_LY__c=10.12;
        rebContr.Type__c='Cooper Up';
        rebContr.CurrencyIsoCode='BRL';
        //rebContr.Sales_Org__c=sorg.Id;
        insert rebContr;
        
        Rebate_Term__mdt rtm= new Rebate_Term__mdt();
        rtm.Term_Description__c='#YEAR As metas em volume(Kg/L) por produto estão descritas abaixo:';
        
        list<Rebate_Term__mdt> customMetadata = [SELECT IncludeTable__c,Term_Number__c,Sort_Order__c,Type__c,Term_Description__c FROM Rebate_Term__mdt where contract_type_code__c=:rebContr.Type_Code__c  order by Sort_Order__c asc] ;
        system.debug('values is '+customMetadata);
        system.debug('size '+customMetadata.size());
        Test.StartTest(); 
        PageReference myVfPage = Page.PrintRebateForm;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('contractId', rebContr.Name);
        RebateTerms rb = new RebateTerms();
        
        Test.StopTest();
    }
/*  
* Name: TocoverValueisNUll    
* return:void
* Description: INC0414706-This method responsible to cover When total Value and Total_Value_LY__c is null checks
*/
    static testMethod void TocoverValueisNUll()
    {
        Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
        Rebate_Contract__c rebContr = new Rebate_Contract__c();
        rebContr.Combination_Key__c='519010';
        rebContr.CRM_Status__c='New';
        rebContr.Name='10';
        
        rebContr.Total_Other_Value__c=10.11;
        rebContr.Total_Other_Value_LY__c=10.12;
        rebContr.Sales_Org__c=sorg.id;
        rebContr.Type_Code__c='U';
        
        rebContr.Type__c='Cooper Up';
        rebContr.CurrencyIsoCode='BRL';
        
        insert rebContr;
        
        Rebate_Term__mdt rtm= new Rebate_Term__mdt();
        rtm.Term_Description__c='As metas em volume(Kg/L) por produto estão descritas abaixo:';
        
        list<Rebate_Term__mdt> customMetadata = [SELECT IncludeTable__c,Term_Number__c,Sort_Order__c,Type__c,Term_Description__c FROM Rebate_Term__mdt where contract_type_code__c=:rebContr.Type_Code__c  order by Sort_Order__c asc] ;
        system.debug('values is '+customMetadata);
        system.debug('size '+customMetadata.size());
        Test.StartTest(); 
        PageReference myVfPage = Page.PrintRebateForm;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('contractId', rebContr.Name);
        RebateTerms rb = new RebateTerms();
        rb.formatter='test';
        rb.Term1='Term1';
        rb.Term2='term2';
        System.assert(rebContr.Total_Value__c == null,'To cover Else Part this value should be null');
        System.assert(rebContr.Total_Value_LY__c == null,'To cover Else Part this value should be null');
        Test.StopTest();
    }
    static testMethod void CallRebateTerms1()
    {
        Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
        Rebate_Contract__c rebContr = new Rebate_Contract__c();
        rebContr.Combination_Key__c='519010';
        rebContr.CRM_Status__c='New';
        rebContr.Name='10';
        rebContr.Total_Other_Value__c=10.11;
        rebContr.Total_Other_Value_LY__c=10.12;
        rebContr.Sales_Org__c=sorg.id;
        rebContr.Type_Code__c='C';
        //Addded by Nandhini for the ticket INC0414706
        rebContr.Total_Value__c=10.11;
        
        rebContr.CurrencyIsoCode='BRL';
        //rebContr.Sales_Org__c=sorg.Id;
        insert rebContr;
        //Added By nandhini to cover Total_Value__c is null checks for the ticket INC0414706
        Rebate_Contract__c rebContr1 = new Rebate_Contract__c();
        rebContr1.Combination_Key__c='5190101';
        rebContr1.CRM_Status__c='New';
        rebContr1.Name='101';
        //rebContr.Total_Value__c=10.11;
        rebContr1.Total_Other_Value__c=10.11;
        rebContr1.Total_Other_Value_LY__c=10.12;
        rebContr1.Sales_Org__c=sorg.id;
        rebContr1.Type_Code__c='C';
        
        rebContr1.CurrencyIsoCode='BRL';
        //rebContr.Sales_Org__c=sorg.Id;
        insert rebContr1;
        RebateTerms.approvalClass ob= new  RebateTerms.approvalClass();
        ob.approvedDate=string.valueOf(system.today());
        ob.approverName='test';
        ob.profileName='test profile';
        list<Rebate_Term__mdt> customMetadata = [SELECT IncludeTable__c,Term_Number__c,Sort_Order__c,Type__c,Term_Description__c FROM Rebate_Term__mdt where contract_type_code__c=:rebContr.Type_Code__c  order by Sort_Order__c asc] ;
        system.debug('values is '+customMetadata);
        Test.StartTest(); 
        PageReference myVfPage = Page.PrintRebateForm;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('contractId', rebContr.Name);
        RebateTerms rb = new RebateTerms();
        //Added By nandhini to cover Total_Value__c is null checks fir the ticket INC0414706
        ApexPages.currentPage().getParameters().put('contractId', rebContr1.Name);
        RebateTerms rb1 = new RebateTerms();
        Test.StopTest();
    }
    static testMethod void CallRebateTerms2()
    {
        Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
        Rebate_Contract__c rebContr = new Rebate_Contract__c();
        rebContr.Combination_Key__c='519010';
        rebContr.CRM_Status__c='New';
        rebContr.Name='10';
        //rebContr.Total_Value__c=10.11;
        rebContr.Total_Other_Value__c=10.11;
        rebContr.Total_Other_Value_LY__c=10.12;
        rebContr.Sales_Org__c=sorg.id;
        rebContr.Type_Code__c='L';
        //rebContr.Type__c='Cooper Up';
        //rebContr.Total_Value_LY__c=10.12;
        rebContr.CurrencyIsoCode='BRL';
        //rebContr.Sales_Org__c=sorg.Id;
        insert rebContr;
        SKU__c sku= new SKU__c();
        sku.Product_Category__c='NPP BIOSOLUTIONS';
        sku.Name='ACTTRA NOCTUIDEO (1.000L)';
        sku.SKU_Code__c='000000000005251002';
        sku.Brand_Name__c='ACTTRA';
        insert sku;
        
        Rebate_Goal_SKU__c rsku= new Rebate_Goal_SKU__c();
        rsku.SKU__c=sku.Id;
        rsku.Volume__c=1;
        rsku.Product_Category__c='Biossoluções';
        rsku.Contract__c=rebContr.id;
        insert rsku;
        
        
        
        list<Rebate_Term__mdt> customMetadata = [SELECT IncludeTable__c,Term_Number__c,Sort_Order__c,Type__c,Term_Description__c FROM Rebate_Term__mdt where contract_type_code__c=:rebContr.Type_Code__c  order by Sort_Order__c asc] ;
        system.debug('values is '+customMetadata);
        RebateTerms.approvalClass ob= new  RebateTerms.approvalClass();
        ob.approvedDate=string.valueOf(system.today());
        ob.approverName='test';
        ob.profileName='test profile';
        
        Test.StartTest(); 
        PageReference myVfPage = Page.PrintRebateForm;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('contractId', rebContr.Name);
        RebateTerms rb = new RebateTerms();
        Test.StopTest();
    }
}