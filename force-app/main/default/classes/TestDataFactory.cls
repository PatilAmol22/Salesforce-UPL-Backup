//Created by 23-10-2019 
//Created By IBM
//Diwansh Sethi  

public class TestDataFactory {
    
    public static Account CreateAccount(String sapcode)
    {
              Id RecordTypeIdContact = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        	  Account accObj = new Account(
              Name = 'Swapnil More',
              Last_Name__c = 'More',      
              recordtypeid=RecordTypeIdContact,                
              OwnersetbyProcess__c = true,                          
              Photograph__c = false,  
              Security_cheque_scan__c = false,                      
              Copy_of_PesticideSeed_License__c = false,             
              GST_Certificate__c = false,                           
              CopyofPartnershipfirmcompanyHUFPro__c = false,        
              Signed_business_policy__c = false,                    
              One_Blank_Letter_Pad_for_address_proof_o__c = false,  
              Order_Block__c = false,                               
              Status__c = 'Active',                                 
              Zone__c = 'Pune',                                     
              Cust_Group__c = '189',                                
              Territory_Code__c = '189',                            
              ApprovedbyRegionalManager__c = false,                 
              ApprovedbyZonalHead__c = false,
              ApprovalStatus__c = 'Draft',
              SAP_Code__c=sapcode
        );
        insert accObj;
		return accObj;        
        
        
    }
    
    public static Document CreateDocument()
    {
        
        Document d = new Document();
        d.Name= 'Stock In Channel UPL Inventory Upload Template';
        d.FolderId=[select id from folder where name = 'Shared Documents'].id;
        insert d;
        return d;
    }
    
    public static SKU__c CreateSKU(String skucode,Sales_Org__c sorg,String combinationKey )
    {
        SKU__c sk = new SKU__c();
        sk.SKU_Code__c=skucode;
        sk.Sales_Org__c=sorg.ID;
        sk.Combination_Key__c =combinationKey ;
        insert sk;
        return sk;
    }
    
    public static User CreateUser()
    {
        userrole  usrole = new userrole();
        usrole.Name ='Customer User';
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'System Administrator'];
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'swapnil.more@in.ibm.com';                             
        sobj1.ProfileId  = p.ID;                                                     
        sobj1.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='More';
        sobj1.CommunityNickname = 'zonalExe1222 Di'; 
        sobj1.TimeZoneSidKey = 'America/Sao_Paulo'; 
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        sobj1.UserRoleId=usrole.id;
        insert sobj1;
        return sobj1;
        
    }
    public static Sales_Org__c CreateSalesOrg()
    {
    	Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Brazil';
        sorg.Description__c='Brazil';
        sorg.Sales_Org_Code__c='5191';
        insert sorg;
       return sorg;
    }
    
    public static Zone__c CreateZone()
    {
    	Zone__c zn = new Zone__c();
        zn.Name='BU CERRADO LESTE';
        zn.ZoneCode__c='BR15';
        insert zn;
        return zn;
    }
    public static Territory_Distributor__c CreateTerritory(Zone__c zn,User usr,Sales_Org__c sorg)
    {
       Territory_Distributor__c tr = new Territory_Distributor__c();
        tr.SalesOrg__c =sorg.id;
        tr.TerritoryManager__c=usr.Id;
        tr.TerritoryCode__c='BR160';//added while create rebate 
        tr.Zone__c=zn.Id;
        insert tr;
        return tr;
        
    }
    
    public static Stock_In_Channel__c CreateStockInChannel(Account acc,String CombinationKey,String Year)
    {
        Stock_In_Channel__c sic = new Stock_In_Channel__c();
        sic.Channel__c=acc.id;
        sic.Year__c=Year;
        sic.Combination_Key__c=CombinationKey+acc.SAP_Code__c;
        insert sic;
        return sic;
        
    }
     public static Case CreateCase(Account accId)	
    {	
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();	
        Case caseObj = new Case();	
        caseObj.recordtypeid = RecordTypeIdCase;	
        caseObj.AccountId = accId.Id;	
        insert caseObj;	
        return caseObj;        	
        	
        	
    }
    public static Sales_Org__c CreateSalesOrgCode()	
    {	
        Sales_Org__c sorg =new Sales_Org__c();	
        sorg.Name='US';	
        sorg.Description__c='US';	
        sorg.Sales_Org_Code__c='3100';	
        insert sorg;	
       return sorg;	
    }	
    public static Sales_Org__c CreateSalesOrgCodeCanada()	
    {	
        Sales_Org__c sorg =new Sales_Org__c();	
        sorg.Name='Canada';	
        sorg.Description__c='Canada';	
        sorg.Sales_Org_Code__c='3710';	
        insert sorg;	
       return sorg;	
    }
    public static Region__c CreateRegion(Sales_Org__c sorg,String regcode)	
    {	
    Region__c reg=new Region__c();	
        reg.RegionCode__c=regcode;	
        reg.Name='4100';	
        reg.SalesOrg__c=sorg.Id;	
        insert reg;	
        return reg;	
    }
    public static Draft_Plan_Header__c CreatedfHeader(Sales_Org__c sorg,Account acc,CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapper){	
    Draft_Plan_Header__c dh=new Draft_Plan_Header__c();	
    dh.Sales_Org__c=sorg.Id;	
    dh.Distributor__c=acc.id;	
    //dh.Version__c=1;	
    dh.Status__c='Draft';	
    //dh.Marketing_Year__c=mkt.Id;	
   /* dh.MKT_Year_End_Date__c=system.today().addyears(1);	
    dh.MKT_Year_Name__c=String.valueof(system.today().year());	
    dh.MKT_Year_Start_Date__c=system.today();*/	
        dh.MKT_Year_End_Date__c=mktYearWrapper.firstMarketingYearEndDate;	
        dh.MKT_Year_Name__c=String.valueOf(mktYearWrapper.firstMarketingYear);	
        dh.MKT_Year_Start_Date__c=mktYearWrapper.firstMarketingYearStartDate;	
    insert dh;	
    return dh;	
    }
    public static Draft_Plan__c CreatedfPlan(Sales_Org__c sorg,Account acc,Draft_Plan_Header__c dh,sku__c sku,String comb){	
    Draft_Plan__c df=new Draft_Plan__c();	
    //df.Combination_Key__c=comb;	
    df.Draft_Amount__c=1000;	
    //df.Draft_Plan_Version__c=1;	
    df.Draft_Quantity__c=100;	
    df.Value_At_Draft__c=1500;	
    df.EDI_Amount_LY__c=800;	
    df.EDI_Quantity_LY__c=100;	
    df.Invoice_Amount_LY__c=1300;	
    df.Invoice_Quantity_LY__c=200;	
    df.Pct_Of_Prev_Yr__c=10;	
    df.Product_Price__c=200;	
    df.Distributor__c=acc.id;	
    df.SKU__c=sku.id;	
    df.Draft_Plan_Header__c=dh.Id;	
    //df.Marketing_Year_Start_Date__c=system.today();	
    insert df;	
    return df;	
}
    public static Draft_Plan_Payout__c CreatedfPay(Draft_Plan__c df){	
    Draft_Plan_Payout__c dpp = new Draft_Plan_Payout__c();	
    dpp.Draft_Plan__c=df.id;	
    dpp.Payout_Entry_Type__c='value';	
    dpp.Payout_Per_Unit__c=100;	
    dpp.Tier__c=1;	
    dpp.Threshold_Quantity__c=1;	
    dpp.Qty_as_a_Pct__c=10;	
    dpp.Reason_Code__c='NA';	
    insert dpp;	
    return dpp;}	
    public static PriceBookMaster__c CreatePbm(Sku__c sku,Account acc,Sales_Org__c sorg,CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapper){	
         PriceBookMaster__c pbm = new PriceBookMaster__c();	
        pbm.SKUCode__c=sku.Id;	
        pbm.Price__c=1000;	
        pbm.CompositeKey__c='test123';	
        pbm.StartDate__c=mktYearWrapper.firstMarketingYearStartDate;	
        pbm.Active__c=true;	
        pbm.EndDate__c=mktYearWrapper.firstMarketingYearEndDate;	
        pbm.DistributorCustomerCode__c=acc.id;	
        pbm.Sales_Org__c=sorg.Id;	
        insert pbm;	
        return pbm;	
    }
    public static Secondary_Sales_Data__c CreateSec(Sku__c sku,Account acc,Sales_Org__c sorg,CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapper){	
    Secondary_Sales_Data__c sec=new Secondary_Sales_Data__c();	
        sec.Product_Name__c=sku.id;	
        sec.Product_Quantity__c=500;	
        sec.Sales_Amount__c=1500;	
        sec.Sold_to_Party__c=acc.id;	
        sec.Year__c=String.valueOf(mktYearWrapper.firstMarketingYearStartDate.year());	
        sec.Month__c=String.valueOf(mktYearWrapper.firstMarketingYearStartDate.month());	
        sec.Product_Name__c=sku.Id;	
        sec.Sales_Org__c=sorg.id;	
            //sec.Sales_Date__c=mktYearWrapper.firstMarketingYearStartDate;	
        insert sec;	
    return sec;	
}
    public static Invoice__c CreateInv(Account acc,Sales_Org__c sorg,CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapper){	
    Invoice__c inv=new Invoice__c();	
        inv.Billing_Date__c=mktYearWrapper.firstMarketingYearStartDate;	
        inv.Sold_To_Party__c=acc.id;	
        inv.Sales_Org__c=sorg.Id;	
        insert inv;	
    return inv;	
}	
                public static Invoice_Line_Item__c CreateInvLine(Sku__c sku,Invoice__c inv){	
    Invoice_Line_Item__c invLine=new Invoice_Line_Item__c();	
        invLine.Invoice__c=inv.Id;	
        invLine.Quantity__c=100;	
        invLine.Net_Value__c=1900;	
        invLine.SKU__c=sku.id;	
        insert invLine;	
    return invLine;	
}
    public static Draft_Plan_Region__c CreatedfRegion(Region__c reg,sku__c sku,CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapper,id div){	
    Draft_Plan_Region__c dpr=new Draft_Plan_Region__c();	
        dpr.Combination_Key__c='test13';	
        dpr.EDI_Quantity_LLY__c=120;	
        dpr.EDI_Quantity_LY__c=121;	
        dpr.Invoice_Quantity_LY__c=130;	
        dpr.Region__c=reg.Id;	
        dpr.SKU__c=sku.id;	
        dpr.MKT_Year_Start_Date__c=mktYearWrapper.firstMarketingYearStartDate;	
        dpr.MKT_Year_End_Date__c=mktYearWrapper.firstMarketingYearEndDate;	
        dpr.MKT_Year_Name__c=String.valueOf(mktYearWrapper.firstMarketingYear);	
        dpr.Draft_Quantity__c=1000;	
        dpr.Division__c=div;	
        insert dpr;	
        return dpr;	
    }
    public static User CreateFranceUser()
    {
        userrole  usrole = new userrole();
        usrole.Name ='Customer User';
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Technical Manager France'];
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'swapnil.more@in.ibm.com';                             
        sobj1.ProfileId  = p.ID;                                                     
        sobj1.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='More';
        sobj1.CommunityNickname = 'zonalExe1222 Di'; 
        sobj1.TimeZoneSidKey = 'America/Sao_Paulo'; 
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        sobj1.UserRoleId=usrole.id;
        insert sobj1;
        return sobj1;
        
    }
}