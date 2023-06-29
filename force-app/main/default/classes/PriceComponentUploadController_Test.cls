/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Test Class for PriceComponentUploadController
*
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Anjaneyulu  <aanjaney@in.ibm.com>
* @modifiedBy     Anjaneyulu   <aanjaney@in.ibm.com>
* @maintainedBy   Anjaneyulu   <aanjaney@in.ibm.com>
* @version        1.0
* @created        2020-03-8
* @modified       2020-03-8
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
*                 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/





@isTest
public class PriceComponentUploadController_Test {
    @testSetup static void setup() {
        Region__c re=new Region__c(RegionCode__c='123');
        Region__c re1=new Region__c(RegionCode__c='124');
        Region__c re2=new Region__c(RegionCode__c='125');
        Region__c re3=new Region__c(RegionCode__c='126');
        List<Region__c> regList=new List<Region__c>();
        regList.add(re);
        regList.add(re1);
        regList.add(re2);
        regList.add(re3);
        insert regList;
        
        document doc=new document();
        doc.Name='getDocument';
        doc.FolderId= UserInfo.getUserId();
        insert doc;
        
        Sales_Org__c sol=new  Sales_Org__c(Sales_Org_Code__c = '5191');
        insert sol;
        
        Market_Variation__c MV=new Market_Variation__c();
        MV.SKU_Brand__c = 'Sample';
        MV.Market_Variation__c = 1.2;
        MV.Sales_Org__C = sol.id;
        MV.Combination_Key__c = 'Sample'+ sol.Sales_Org_Code__c;
        insert MV;
        
    }
    
    static testMethod void PCUCTestCall(){
        insert new UPL_Settings__c(Sales_Order_Tracking_URL__c='http://example.com/example/test',Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);
        
        List<Region__c> regList=[select id, RegionCode__c from Region__c];		
        Sales_Org__c sol=[select id,Sales_Org_Code__c from Sales_Org__c limit 1];
        document docs=[select Name,FolderId from document limit 1];
        Market_Variation__c mvc=[select SKU_Brand__c,Market_Variation__c,Sales_Org__C,Combination_Key__c from Market_Variation__c limit 1];
        PriceComponentUploadController.getDocument('getDocument');
        PriceComponentUploadController.sendEmail('No Error','S');
        String regCodeSDC='Sample'+';123;Sample'+'\n'+'Sample'+';546;Sample'+'\n'+'Sample'+';;Sample'+'\n'+'123;2,2';
        PriceComponentUploadController.passFile(regCodeSDC,'SDC');
        
        
        String regCodeMV='sample;123;123'+'\n'+'Sample;RANCONA;123.00';
        String regCodeMV1='sample;123;123,00'+'\n'+'Sample;;123.00';
        String regCodeMV2='sample;123;123'+'\n'+';RANCONA;123.00';
        String regCodeMV3='sample;123;123'+'\n'+'Sample;RANCONA;';
        PriceComponentUploadController.passFile(regCodeMV,'MV');
        PriceComponentUploadController.passFile(regCodeMV1,'MV');
        PriceComponentUploadController.passFile(regCodeMV2,'MV');
        //PriceComponentUploadController.passFile(regCodeMV3,'MV');
        try
        {
            String regCodeDMS='Sample;120;123;123;sample'+'\n'+'Sample;123;123;123;123';
            PriceComponentUploadController.passFile(regCodeDMS,'DM');
        }catch(Exception e)
        {
            System.debug(e);
        }
        
        
        try
        {
            String regCodeDM='Sample;120;123;123;sample'+'\n'+'Sample'+';'+null+';'+null+';'+null+';'+'0';
            String regCodeDM1='Sample;120;123;123;sample'+'\n'+'Sample; '+';'+null+';'+null+';'+'0';
            String regCodeDM2='Sample;120;123;123;sample'+'\n'+'Sample; 120 ,'+';'+null+';'+'0';
             String regCodeDM3='Sample;120;123;123;sample'+'\n'+'Sample;123;123;;';
            PriceComponentUploadController.passFile(regCodeDM,'DM');
            PriceComponentUploadController.passFile(regCodeDM1,'DM');
            PriceComponentUploadController.passFile(regCodeDM2,'DM');
            PriceComponentUploadController.passFile(regCodeDM3,'DM');
        }catch(Exception e)
        {
            System.debug(e);
        }
        try
        {
            String regCode1='Sam;ple'+'\n'+' '+';124563'+';123;1233;12345'+'\n'+' '+'; '+'; ; ; '+'\n'+'Sample2'+';125'+';125;1234;1'+'\n'+'Sample3'+';126'+';126;1234;134'+'\n'+'Sample3'+';126'+'; ;1234;134';
            
            PriceComponentUploadController.passFile(regCode1,'SDC');
        }catch(Exception e)
        {
            System.debug(e);
        }
        try
        {
            String regCodeCCF='Sample'+';124;123'+'\n'+'Sample'+';123;123'+'\n'+';test'+'; '+';234'+'\n'+'Sample'+';123' + '; ';
            String regCodeCCF1='Sample'+';124;123'+'\n'+';test'+'; '+';234';
            PriceComponentUploadController.passFile(regCodeCCF,'CCF');
            PriceComponentUploadController.passFile(regCodeCCF1,'CCF');
        }catch(Exception e)
        {
            System.debug(e);
        }
        
    }
    static testMethod void PCUCTestCall1(){
        insert new UPL_Settings__c(Sales_Order_Tracking_URL__c='http://example.com/example/test',Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);
        
        List<Region__c> regList=[select id, RegionCode__c from Region__c];		
        Sales_Org__c sol=[select id,Sales_Org_Code__c from Sales_Org__c limit 1];
        document docs=[select Name,FolderId from document limit 1];
        Market_Variation__c mvc=[select SKU_Brand__c,Market_Variation__c,Sales_Org__C,Combination_Key__c from Market_Variation__c limit 1];
        
        Discount_Matrix__c  md=new  Discount_Matrix__c ();
        md.Combination_key__c='Sample123';
        insert md;
        String regCodeDMS='Sample;120;123;123;sample'+'\n'+'; ; ; ; ';
        PriceComponentUploadController.passFile(regCodeDMS,'DM');
        
    }
    
      static testMethod void PCUCTestCall2(){
        insert new UPL_Settings__c(Sales_Order_Tracking_URL__c='http://example.com/example/test',Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);
        
        List<Region__c> regList=[select id, RegionCode__c from Region__c];		
        Sales_Org__c sol=[select id,Sales_Org_Code__c from Sales_Org__c limit 1];
        document docs=[select Name,FolderId from document limit 1];
        Market_Variation__c mvc=[select SKU_Brand__c,Market_Variation__c,Sales_Org__C,Combination_Key__c from Market_Variation__c limit 1];
        
        Discount_Matrix__c  md=new  Discount_Matrix__c ();
        md.Combination_key__c='Sample123';
        insert md;
        String regCodeDMS='Sample;120;123;123;sample'+'\n'+'Test;;123 ;123 ;123 ';
        PriceComponentUploadController.passFile(regCodeDMS,'DM');
        
    }
     static testMethod void PCUCTestCall3(){
        insert new UPL_Settings__c(Sales_Order_Tracking_URL__c='http://example.com/example/test',Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);
        
        List<Region__c> regList=[select id, RegionCode__c from Region__c];		
        Sales_Org__c sol=[select id,Sales_Org_Code__c from Sales_Org__c limit 1];
        document docs=[select Name,FolderId from document limit 1];
        Market_Variation__c mvc=[select SKU_Brand__c,Market_Variation__c,Sales_Org__C,Combination_Key__c from Market_Variation__c limit 1];
        
        Discount_Matrix__c  md=new  Discount_Matrix__c ();
        md.Combination_key__c='Sample123';
        insert md;
        String regCodeDMS='Sample;120;123;123;sample'+'\n'+'Test;123; ;123 ;123 ';
        //PriceComponentUploadController.passFile(regCodeDMS,'DM');
        
    }
}