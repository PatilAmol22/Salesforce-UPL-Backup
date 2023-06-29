/*
     Author: Aarzoo Arora/Rasika
     Name: CustomlookupControllerUplTest
     Description : this class is used for CompetitionTrackingLwc component
    */




@isTest
public class CustomlookupControllerUplTest {
    @isTest
    public static void CompanyTest()
    {
        Company__c com = new Company__c();
            com.name = 'Test Data';
        insert com;
        CustomlookupControllerUpl.companySearchHandlerApex(com.Name, 'Company__c');
        CustomlookupControllerUpl.companySearchHandlerApex('', 'Company__c');
    }
    @isTest
    public static void BrandTest()
    {
        Company__c com = new Company__c();
            com.name='Test Data';
        insert com;
        Brand__c br = new Brand__c();
            br.Name = 'Test';
            br.Company__c=com.Id;
        insert br;    
      
        CustomlookupControllerUpl.brandSearchHandlerApex(br.Name, 'Brand__c',br.Company__c); 
        CustomlookupControllerUpl.brandSearchHandlerApex(br.Name, 'Brand__c','');
    }
    @isTest
    public static void FormulationTest()
    {
        Brand__c br = new Brand__c();
            br.Name = 'Test';
        insert br;
        
        Formulation__c form = new Formulation__c();
            form.Brand__c = br.Id;
            form.Name = 'Test';
        insert form;
        List<BrandFormulation__c> bdforList = new List<BrandFormulation__c>();
        BrandFormulation__c bdfor = new BrandFormulation__c();
            bdfor.Brand__c = br.id;
            bdfor.Formulation__c = form.id;
        insert bdfor;
        bdforList.add(bdfor);
        CustomlookupControllerUpl.formulationSearchHandlerApex(form.Name, 'BrandFormulation__c',form.Brand__c);
        
        List<BrandFormulation__c> bdLstElse = new List<BrandFormulation__c>();
       /* BrandFormulation__c bdfr = new BrandFormulation__c();
            bdfr.Brand__c = br.id;
            bdfr.Formulation__c = form.id;
        insert bdfr;*/
        //bdforList.add(bdfor);
        CustomlookupControllerUpl.formulationSearchHandlerApex(form.Name, 'BrandFormulation__c',form.Brand__c);
    }
    @isTest
    public static void FormulationTest2()
    {
        Brand__c br = new Brand__c();
            br.Name = 'Test';
        insert br;

        Brand__c br2 = new Brand__c();
            br2.Name = 'Test';
        insert br2;
        
        Formulation__c form = new Formulation__c();
            form.Brand__c = br.Id;
            form.Name = 'Test';
        insert form;
        
        List<BrandFormulation__c> bdforList = new List<BrandFormulation__c>();
        BrandFormulation__c bdfor = new BrandFormulation__c();
            bdfor.Brand__c = br.id;
            bdfor.Formulation__c = form.id;
        insert bdfor;
        //bdforList.add(bdfor);
        CustomlookupControllerUpl.formulationSearchHandlerApex(form.Name, 'BrandFormulation__c', br2.id);
    }
    
    @isTest
    public static void FamilyTest()
    {
        Brand__c br = new Brand__c();
            br.Name = 'Test';
        insert br;
        
        Family__c fam = new Family__c();
            fam.Brand__c = br.Id;
            fam.Name = 'Test';
        insert fam;
        CustomlookupControllerUpl.familySearchHandlerApex(fam.Name, 'BrandFamily__c',fam.Brand__c);
        CustomlookupControllerUpl.familySearchHandlerApex(fam.Name, 'BrandFamily__c','');
    }
     @isTest
    public static void MarketTest()
    {
        Brand__c br = new Brand__c();
            br.Name = 'T';
        insert br;
        
        Market__c mar = new Market__c();
            mar.Brand__c = br.Id;
            mar.Name = 'Test';
        insert mar;
        CustomlookupControllerUpl.marketSearchHandlerApex(mar.Name, 'BrandMarket__c',mar.Brand__c);
        CustomlookupControllerUpl.marketSearchHandlerApex(mar.Name, 'BrandMarket__c','');
    }
       
    @isTest
    public static void PacksizeTest()
    {
        Pack_Size__c pk = new Pack_Size__c();
            pk.Name = '100';
        insert pk;
        
        CustomlookupControllerUpl.searchPackSizeRecordsApex(pk.Name, 'Pack_Size__c');
        CustomlookupControllerUpl.searchPackSizeRecordsApex('', 'Pack_Size__c');
    }
    @isTest
    public static void CropTest()
    {
        Crop__c cp = new Crop__c();
            cp.Name = 'Data';
        insert cp;
        
        CustomlookupControllerUpl.cropSearchHandlerApex(cp.Name, 'Crop__c');
        CustomlookupControllerUpl.cropSearchHandlerApex('', 'Crop__c');
    }
    @isTest
    public static void PestTest()
    {
        Pest__c pst = new Pest__c();
            pst.Name = 'Data';
        insert pst;
        CustomlookupControllerUpl.pestSearchHandlerApex(pst.Name, 'Pest__c'); 
        CustomlookupControllerUpl.pestSearchHandlerApex('', 'Pest__c');
    }
    @isTest
    public static void AITest()
    {
        Active_Ingredient__c AI =new Active_Ingredient__c();
            AI.Name = 'Data';
        insert AI;
        CustomlookupControllerUpl.aISearchHandlerApex(AI.Name, 'Active_Ingredient__c');
        CustomlookupControllerUpl.aISearchHandlerApex('', 'Active_Ingredient__c'); 
    }
}