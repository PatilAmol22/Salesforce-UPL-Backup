@isTest
public class US_Case_ReleaseForm_Test {
    
    @isTest
    static void test1(){
        
        SKU__c skuo = new SKU__c();
        skuo.RecordTypeId = Schema.SObjectType.SKU__c.getRecordTypeInfosByName().get('US').getRecordTypeId();
		skuo.Name = 'MANCO';
        skuo.SKU_Code__c = 'sku001';
        skuo.Combination_Key__c = '231324564894531468';
        skuo.isparent__c=true;
        insert skuo;
        Account acc = TestDataFactory.CreateAccount('spCode');
        case caseObj = new Case();
        caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Complaint').getRecordTypeId();
        caseObj.Status = 'Approved';
        caseObj.Pack_Size_SKU__c = skuo.Id;
        caseObj.Total_Volume_Effected__c = 225;
        caseObj.List_Price_of_Complaint_Product_Unit__c = 25;
        caseObj.Units_1__c = 'Ounces';
        caseObj.AccountId=acc.id;
        
        /*Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;*/
        
        Trigger_Settings__c tsObj1 = new Trigger_Settings__c();
        tsObj1.Name = 'CaseTrigger';
        tsObj1.isActive__c = True;
        insert tsObj1;
        insert caseObj;
        case_product__c cp=new case_product__c();
        cp.Replacement_Unit__c=10.0;
        cp.Replacement_Product__c=skuo.id;
        cp.Brand_Pack_Size__c=skuo.id;
        cp.Case__c=caseObj.id;
        insert cp;
       //test.startTest();
        
       // PageReference pageRef = Page.ReleaseNonCalifornia;
        //Test.setCurrentPage(pageRef);
        //pageRef.getParameters().put('acid',acc.id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(caseObj);
        
        US_Case_ReleaseForm ucr = new US_Case_ReleaseForm(sc);
        //ucr.skuName ='ABAMECTIN -- MERLIN  4 x 1 GALLON -- 6020276 -- GAL'; 
        //ucr.offTtype = 'California';
        ucr.caseObjId = caseObj.Id;
        ucr.caseObj2 = caseObj;
        //ucr.CityState='California';
        //ucr.contctName = 'US Contact';
        //ucr.prdctName = 'ABAMECTIN';
        //ucr.ownerName = caseObj.Owner.Name;
        //ucr.ownerTitle = 'Case Owner';
        //ucr.dateOutput = '05/02/2017';
        //ucr.dateOutput1 = '05/03/2018';
        //ucr.contctTitle = 'US contact';
        //ucr.growingSeason = 'Season';
        ////ucr.growingSeasonDt = 'Growing Season DT';
        //ucr.replaceMentofCreditval = 'Replacement_Credit_Volume_in_Units__c';
        //ucr.formatedDt =caseObj.Date_Attained__c;
        //ucr.yourDate = caseObj.Date_Attained__c;//caseObj.Created_Date_Time__c;
        
     //   test.stopTest();
    }    
    
}