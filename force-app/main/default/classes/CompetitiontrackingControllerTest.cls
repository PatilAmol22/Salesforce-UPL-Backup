/*
* Class Name - CompetitiontrackingControllerTest
* Created Date - 14th JUNE, 2022
* Author - Taruni/Abhinay
* Description - Created for testing CompetitiontrackingController class. 
* */


@isTest
public class CompetitiontrackingControllerTest {
    // inserting company
    @isTest
    public static void createCompany()
    {
        Company__c com =new Company__c();
        com.Name='ACTION';
        com.Company_Code__c='222';
            
        insert com;
        
        Company__c c =new Company__c();
        Company__c cc =new Company__c();
        cc.Name='test';
        cc.Company_Code__c='333';
        c=CompetitiontrackingController.createCompanyRecord(cc);
        Test.startTest();
      	 try
      	{
       	 Company__c errorRelease = CompetitiontrackingController.createCompanyRecord(c);
      	}
     	 catch(exception e)
         {
		}     
        Test.stopTest();
    }
    // inserting brand
    @isTest
    private static void createbrand()
    {
            Company__c com =new Company__c();
            com.Name='ACTION';
            insert com;
            
            Brand__c b = new Brand__c();
            Brand__c br = new Brand__c();
            br.Name='Abhinay';
            br.Company__c = com.Id;
            //insert br;
            b=CompetitiontrackingController.createBrandRecord(br,com.id);
        	Test.startTest();
             try
            {
             Brand__c errorRelease = CompetitiontrackingController.createBrandRecord(b,com.id);
            }
             catch(exception e)
             {
            }     
            Test.stopTest();
    } 
    // inserting Formulation
    @isTest
    public static void createFormulation()
    {
        Company__c com =new Company__c();
            com.Name='ACTION';
            com.Company_Code__c='222';
        insert com; 
        Brand__c br = new Brand__c();
            br.Name='Abhinay';
            br.Company__c = com.Id;
        insert br;
               
        Formulation__c f = new Formulation__c();
        Formulation__c fr = new Formulation__c();
        
        fr.Name='testkvp';
        fr.Formulation_Code__c ='444';
        
        f=CompetitiontrackingController.createFormulationRecord(fr,br.id);
        Test.startTest();
             try
            {
             Formulation__c errorRelease = CompetitiontrackingController.createFormulationRecord(f,br.id);
            }
             catch(exception e)
             {
            }     
         Test.stopTest();
    }
    // inserting PackSize
    @isTest
    public static void createPackSize()
    {
        Company__c com =new Company__c();
        com.Name='ACTION';
        com.Company_Code__c='222';
        insert com;    
    
        Pack_Size__c p =new Pack_Size__c();
        Pack_Size__c pp =new Pack_Size__c();
        pp.Name='100';
        
        p=CompetitiontrackingController.createPackSizeRecord(pp); 
        Test.startTest();
             try
            {
             Pack_Size__c errorRelease = CompetitiontrackingController.createPackSizeRecord(p);
            }
             catch(exception e)
             {
            }     
         Test.stopTest();
}
    // inserting Pest
    @isTest
    public static void createPest()
    {
        Company__c com =new Company__c();
        com.Name='ACTION';
        com.Company_Code__c='222';
        insert com;    
    
        Pest__c p =new Pest__c();
        Pest__c ps =new Pest__c();
        ps.Name='test';
        
        p=CompetitiontrackingController.createPestRecord(ps); 
        Test.startTest();
             try
            {
             Pest__c errorRelease = CompetitiontrackingController.createPestRecord(p);
            }
             catch(exception e)
             {
            }     
         Test.stopTest();
    }
    // inserting Crop
    @isTest
    public static void createCrop()
    {
        Company__c com =new Company__c();
        com.Name='ACTION';
        com.Company_Code__c='222';
        insert com;    
    
       Crop__c cr =new Crop__c();
        Crop__c crs =new Crop__c();
        
        cr=CompetitiontrackingController.createCropRecord(crs);
        Test.startTest();
             try
            {
             Crop__c errorRelease = CompetitiontrackingController.createCropRecord(cr);
            }
             catch(exception e)
             {
            }     
         Test.stopTest();
    }
    // inserting AI
    @isTest
    public static void createAI()
    {
        Company__c com =new Company__c();
        com.Name='ACTION';
        com.Company_Code__c='222';
        insert com;    
    
       Active_Ingredient__c a =new Active_Ingredient__c();
       Active_Ingredient__c ai =new Active_Ingredient__c();
        
       a=CompetitiontrackingController.createAIRecord(ai); 
       Test.startTest();
             try
            {
             Active_Ingredient__c errorRelease = CompetitiontrackingController.createAIRecord(a);
            }
             catch(exception e)
             {
            }     
       Test.stopTest();
    }
     // inserting family
    @isTest
    private static void createfamily()
    {
            Brand__c br = new Brand__c();
            br.Name='Abhinay';
            insert br;
            
            Family__c fam = new Family__c();
            Family__c fami = new Family__c();
            fami.Name='Abhinay';
            fami.Brand__c = br.Id;
            fam=CompetitiontrackingController.createFamilyRecord(fami,br.id);
        	Test.startTest();
                 try
                {
                 Family__c errorRelease = CompetitiontrackingController.createFamilyRecord(fam,br.id);
                }
                 catch(exception e)
                 {
                }     
       		Test.stopTest();
    } 
    // inserting market
    @isTest
    private static void createmarket()
    {
            Brand__c br = new Brand__c();
            br.Name='Abhinay';
            insert br;
            
            Market__c mar = new Market__c();
            Market__c mark = new Market__c();
            mark.Name='Abhinay';
            mark.Brand__c = br.Id;
            mar=CompetitiontrackingController.createMarketRecord(mark,br.id);
        	Test.startTest();
                 try
                {
                 Market__c errorRelease = CompetitiontrackingController.createMarketRecord(mar,br.id);
                }
                 catch(exception e)
                 {
                }     
           Test.stopTest();
    } 
    // inserting Competitortracking
    @isTest
    public static void createCompetitortracking()
    {
        Company__c com =new Company__c();
            com.Name='ACTION';
        insert com;
            
        Brand__c br = new Brand__c();
            br.Name='Abhinay';
            br.Company__c = com.Id;
        insert br;
        
        Formulation__c fr = new Formulation__c();
            fr.Name='testkvp';
            fr.Formulation_Code__c ='444';
        insert fr;       
        
        Competitor_Price__c ct =new Competitor_Price__c();
        Competitor_Price__c cp =new Competitor_Price__c();
        cp.Company__c=com.id;
        cp.Brand__c=br.id;
        cp.Formulation__c=fr.id;
    
        ct = CompetitiontrackingController.saveCompetitorDataApex(cp);
        Test.startTest();
                 try
                {
                 Competitor_Price__c errorRelease = CompetitiontrackingController.saveCompetitorDataApex(ct);
                }
                 catch(exception e)
                 {
                }     
         Test.stopTest();

    }
    // inserting PriceScheme
    @isTest
    public static void createPriceScheme()
    {
        List<Price_Scheme_Detail__c> pslist = new List<Price_Scheme_Detail__c>();
        List<Price_Scheme_Detail__c> pricescheme = new List<Price_Scheme_Detail__c>();
            
        Pack_Size__c pp =new Pack_Size__c();
            pp.Name='100';
        insert pp;
        
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body to be insert in test class for testing the'); 
            
            ContentVersion contentVersion_1 = new ContentVersion(
                Title='SampleTitle', 
                PathOnClient ='SampleTitle.jpg',
                VersionData = bodyBlob, 
                origin = 'H'
                
            );
            insert contentVersion_1;
            ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                     FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
            
            ContentDocumentLink contentlink = new ContentDocumentLink();
            contentlink.LinkedEntityId = pp.id;
            contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
            contentlink.ShareType = 'V';
            insert contentlink;
        
        Price_Scheme_Detail__c price = new Price_Scheme_Detail__c();
            price.Pack_Size__c = pp.id;
            price.Distributor_Price_with_RPD__c = 5.0;
            price.Content_Documents_Id__c=contentlink.contentdocumentid;
        insert price;
        pslist.add(price);
        
        Company__c com =new Company__c();
            com.Name='ACTION';
        insert com;
            
        Brand__c br = new Brand__c();
            br.Name='Abhinay';
            br.Company__c = com.Id;
        insert br;
        
        Formulation__c fr = new Formulation__c();
            fr.Name='testkvp';
            fr.Formulation_Code__c ='444';
        insert fr;       
        
        Competitor_Price__c ct =new Competitor_Price__c();
        Competitor_Price__c cp =new Competitor_Price__c();
        cp.Company__c=com.id;
        cp.Brand__c=br.id;
        cp.Formulation__c=fr.id;
        insert cp;
        
        //pricescheme = CompetitiontrackingController.savePriceSchemeDataApex(pslist,cp.id);
        Test.startTest();
                 try
                {
                 List<Price_Scheme_Detail__c> errorRelease = CompetitiontrackingController.savePriceSchemeDataApex(pslist,cp.id);
                }
                 catch(exception e)
                 {
                }     
         Test.stopTest();
    }

    @isTest
    public static void createUpdateClaim()
    {
        List<Update_Label_Claim__c> upList = new List<Update_Label_Claim__c>();
        List<Update_Label_Claim__c> updateList = new List<Update_Label_Claim__c>();
        
        Company__c com =new Company__c();
            com.Name='ACTION';
        insert com;
            
        Brand__c br = new Brand__c();
            br.Name='Abhinay';
            br.Company__c = com.Id;
        insert br;
        
        Formulation__c fr = new Formulation__c();
            fr.Name='testkvp';
            fr.Formulation_Code__c ='444';
        insert fr;       
        
        Competitor_Price__c ct =new Competitor_Price__c();
        Competitor_Price__c cp =new Competitor_Price__c();
        cp.Company__c=com.id;
        cp.Brand__c=br.id;
        cp.Formulation__c=fr.id;
        insert cp;
        
        Update_Label_Claim__c updateclaim = new Update_Label_Claim__c();
            updateclaim.No_of_applications__c = 2;
        insert updateclaim;
        upList = CompetitiontrackingController.saveUpdateLabelClaimDataApex(updateList,cp.id);
        updateList.add(updateclaim);
        Test.startTest();
                 try
                {
                 List<Update_Label_Claim__c> errorRelease = CompetitiontrackingController.saveUpdateLabelClaimDataApex(updateList,cp.id);
                }
                 catch(exception e)
                 {
                }     
         Test.stopTest();
    }
}