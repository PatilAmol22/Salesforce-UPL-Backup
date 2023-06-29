@isTest
public class Brazil_priceBook_Test {
    
    private Static Division__c div ;
    private Static Price_Book__c priceBookObj;
    private Static Sales_Org__c sorg;
    private Static Region__c region;
    private Static Region__c region1 ;
    private Static SKU__c skuRecord;
    private Static SKU__c skuRec2;
    public static User u ;
    
    static void Init(){
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                     LocaleSidKey='en_US', ProfileId = p.Id,
                     TimeZoneSidKey='America/Los_Angeles',
                     UserName=uniqueUserName);
        insert u;
        Brazil_priceBook brzObj = new Brazil_priceBook(); 
        
        div = new Division__c(
            Name = 'Agro Formulation',
            Division_Code__c = '10'
        );
        insert div;
        
        priceBookObj = new Price_Book__c(
            Name = 'LISTA ABRIL ZARTAN - REGIONAL TRIANGULO - PRAZO AGOSTO 2017',
            Division__c = div.id,                                           
            Valid_From__c = system.today(),
            Expiry_Date__c = system.today()
        );
        insert priceBookObj;
        
        sorg = new Sales_Org__c();
        sorg.Name='Brazil';
        sorg.Sales_Org_Code__c='5191';
        insert sorg;
        
        region = new Region__c();
        region.Name='MATO GROSSO DO SUL';
        region.RegionCode__c= 'BR1010';
        region.SalesOrg__c = sorg.Id;
        
        insert region;
        
        region1 = new Region__c();
        region1.Name='ARROZ';
        region1.RegionCode__c= 'BR2006';
        region1.SalesOrg__c = sorg.Id;
        
        insert region1;
        
        skuRecord = new SKU__c(
            Name = 'TdsetRevorf',                                // SKU Name
            SKU_Code__c = '000000000006302802',                      // SKU Code
            SKU_Description__c = 'MANZATE 800WP 25KG PAPER BAG_BR',  // SKU Description
            UOM__c = 'KG',
            Division__c = div.Id,                                    // Division
            Sales_Org__c = sorg.Id,                              // Sales Org
            Multiple_of__c = 25.00,                                  // Multiple Of
            Combination_Key__c = '519110000000000006302802',         // Combination Key
            Active__c = true                                         // Active
        );
        
        insert skuRecord;
        
        
        skuRec2= new SKU__c(
            Name = 'ikasd',                     // SKU Name
            SKU_Code__c = '000000000006250151',             // SKU Code
            SKU_Description__c = 'JHGDU5UR',                // SKU Description
            UOM__c = 'KG',                                  // UOM
            Division__c = div.Id,                                    // Division
            Sales_Org__c = sorg.Id,                // Sales Org
            Multiple_of__c = 0.00,                          // Multiple Of
            Combination_Key__c = '5191000000000006250151',  // Combination Key
            Active__c = true                               // Active
        );
        insert skuRec2;
    } 
    static testMethod void testName() {
        
           
            
            
            
            Init();
         System.runAs(u) {
        
            Brazil_priceBook.wrapperForAll obj = new  Brazil_priceBook.wrapperForAll();
            System.debug('priceBookObj-->'+priceBookObj.id);        
            Brazil_priceBook.getPriceBookRecord(priceBookObj.id);
            
            Brazil_priceBook.getCurrency();
            Brazil_priceBook.getListViews();
            Brazil_priceBook.getSalesDistrict();
            Brazil_priceBook.getDefaultDivision();
            Brazil_priceBook.getDivision();
            Brazil_priceBook.getSku(div.id);        
            
            List< Brazil_priceBook.wrapperForProductSku> lstOfWrapSku = new  List< Brazil_priceBook.wrapperForProductSku>();
            Brazil_priceBook.wrapperForProductSku wrapObjForSku = new Brazil_priceBook.wrapperForProductSku();
            
            wrapObjForSku.id =  skuRecord.Id;
            wrapObjForSku.skuId = skuRecord.Id;
            wrapObjForSku.Name = skuRecord.Name;
            wrapObjForSku.SkuDes = skuRecord.SKU_Description__c;
            wrapObjForSku.minPrice = 10.00;
            wrapObjForSku.unitPrice = 15.00;
            wrapObjForSku.monthlyIntRate = 0;
            wrapObjForSku.exchangeRate = 0;
            lstOfWrapSku.add(wrapObjForSku);
            String serlizeStr = JSON.serialize(lstOfWrapSku);  
            
            
            
            List<Brazil_priceBook.wrapperForSalesDistrict> lstOfWrapSalesDt = new  List<Brazil_priceBook.wrapperForSalesDistrict>();
            Brazil_priceBook.wrapperForSalesDistrict wrapObjForSalesDist = new Brazil_priceBook.wrapperForSalesDistrict();
            Brazil_priceBook ob = new Brazil_priceBook();
            
            
            wrapObjForSalesDist.Id = region.id;
            wrapObjForSalesDist.sdtId = region.id;
            wrapObjForSku.Name = region.Name;
            wrapObjForSalesDist.SDCode = region.RegionCode__c;
            lstOfWrapSalesDt.add(wrapObjForSalesDist);
            String serlizeStr1 = JSON.serialize(lstOfWrapSalesDt);
            
            String validfrmDate = String.valueOf(System.today());
            String expiryfrm =  String.valueOf(System.today());
            String currencyName = 'Only BRL';
            
            //String arrOfSales,Price_Book__c priceBookAsObj,String serlizeStr1,String validfrm,String expiryfrm,String currencyName
            Brazil_priceBook.savePriceBookapex(serlizeStr,priceBookObj,serlizeStr1,validfrmDate,expiryfrm,currencyName);
            // String clonePriceBookapex(String arrOfSales,Price_Book__c priceBookAsObj,String skuList,String validfrm,String expiryfrm,String currencyName,String divName)
            String divisionName = priceBookObj.Division__c;
            String currencyName1 = 'Only BRL';
            Brazil_priceBook.clonePriceBookapex(serlizeStr,priceBookObj,serlizeStr1,validfrmDate,expiryfrm,currencyName1,divisionName);   
            
            Price_Book__c pbk = new Price_Book__c(
                Name = 'LISTA ABRIL ZARTAN - REGIONAL TRIANGULO - PRAZO AGOSTO 2017',
                Division__c = div.id,                                           
                Valid_From__c = system.today(),
                Expiry_Date__c = system.today()
            );
            // insert pbk;
            
            String currencyName2 = 'Both';
            Brazil_priceBook.savePriceBookapex(serlizeStr,pbk,serlizeStr1,validfrmDate,expiryfrm,currencyName2);
            
        }
    }
    static testMethod void testName1() {
        Init();
        System.runAs(u) {
            
            
            Brazil_priceBook.wrapperForAll obj = new  Brazil_priceBook.wrapperForAll();
            System.debug('priceBookObj-->'+priceBookObj.id);        
            Brazil_priceBook.getPriceBookRecord(priceBookObj.id);
            
            Brazil_priceBook.getCurrency();
            Brazil_priceBook.getListViews();
            Brazil_priceBook.getSalesDistrict();
            Brazil_priceBook.getDefaultDivision();
            Brazil_priceBook.getDivision();
            Brazil_priceBook.getSku(div.id);        
            
            List< Brazil_priceBook.wrapperForProductSku> lstOfWrapSku = new  List< Brazil_priceBook.wrapperForProductSku>();
            Brazil_priceBook.wrapperForProductSku wrapObjForSku = new Brazil_priceBook.wrapperForProductSku();
            Brazil_priceBook.wrapperForProductSku wrapObjForSku1 = new Brazil_priceBook.wrapperForProductSku();
            wrapObjForSku.id =  skuRecord.Id;
            wrapObjForSku.skuId = skuRecord.Id;
            wrapObjForSku.Name = skuRecord.Name;
            wrapObjForSku.SkuDes = skuRecord.SKU_Description__c;
            wrapObjForSku.minPrice = 10.00;
            wrapObjForSku.unitPrice = 15.00;
            wrapObjForSku.monthlyIntRate = 0;
            wrapObjForSku.exchangeRate = 0;
            lstOfWrapSku.add(wrapObjForSku);
            
            wrapObjForSku1.id =  skuRec2.Id;
            wrapObjForSku1.skuId = skuRec2.Id;
            wrapObjForSku1.Name = skuRec2.Name;
            wrapObjForSku1.SkuDes = skuRec2.SKU_Description__c;
            wrapObjForSku1.minPrice = 10.00;
            wrapObjForSku1.unitPrice = 15.00;
            wrapObjForSku1.monthlyIntRate = 0;
            wrapObjForSku1.exchangeRate = 0;
            lstOfWrapSku.add(wrapObjForSku1);
            
            String serlizeStr = JSON.serialize(lstOfWrapSku);  
            
            List<Brazil_priceBook.wrapperForSalesDistrict> lstOfWrapSalesDt = new  List<Brazil_priceBook.wrapperForSalesDistrict>();
            Brazil_priceBook.wrapperForSalesDistrict wrapObjForSalesDist = new Brazil_priceBook.wrapperForSalesDistrict();
            Brazil_priceBook.wrapperForSalesDistrict wrapObjForSalesDist1 = new Brazil_priceBook.wrapperForSalesDistrict();
            wrapObjForSalesDist.Id = region.id;
            wrapObjForSalesDist.sdtId = region.id;
            wrapObjForSalesDist.Name = region.Name;
            wrapObjForSalesDist.SDCode = region.RegionCode__c;
            lstOfWrapSalesDt.add(wrapObjForSalesDist);
            
            wrapObjForSalesDist1.Id = region1.id;
            wrapObjForSalesDist1.sdtId = region1.id;
            wrapObjForSalesDist1.Name = region1.Name;
            wrapObjForSalesDist1.SDCode = region1.RegionCode__c;
            lstOfWrapSalesDt.add(wrapObjForSalesDist);
            
            String serlizeStr1 = JSON.serialize(lstOfWrapSalesDt);
            
            
            Price_Book__c pbk = new Price_Book__c(
                Name = 'LISTA ABRIL ZARTAN - REGIONAL TRIANGULO - PRAZO AGOSTO 2017',
                Division__c = div.id,                                           
                Valid_From__c = system.today(),
                Expiry_Date__c = system.today()
            );
            // insert pbk;
            
            String validfrmDate = String.valueOf(System.today());
            String expiryfrm =  String.valueOf(System.today());
            
            
            String currencyName = 'Only BRL';
            Brazil_priceBook.savePriceBookapex(serlizeStr,pbk,serlizeStr1,validfrmDate,expiryfrm,currencyName);
            
            String divisionName = priceBookObj.Division__c;
            String currencyName1 = 'Only USD';
            Brazil_priceBook.clonePriceBookapex(serlizeStr,priceBookObj,serlizeStr1,validfrmDate,expiryfrm,currencyName1,divisionName); 
            
            
            String currencyName2 = 'Both';
            Brazil_priceBook.savePriceBookapex(serlizeStr,pbk,serlizeStr1,validfrmDate,expiryfrm,currencyName2);
            
        }        
    }
    
    static testMethod void testName2() {
        Init();
        System.runAs(u) {
            
            
            Brazil_priceBook.wrapperForAll obj = new  Brazil_priceBook.wrapperForAll();
            System.debug('priceBookObj-->'+priceBookObj.id);        
            Brazil_priceBook.getPriceBookRecord(priceBookObj.id);
            
            Brazil_priceBook.getCurrency();
            Brazil_priceBook.getListViews();
            Brazil_priceBook.getSalesDistrict();
            Brazil_priceBook.getDefaultDivision();
            Brazil_priceBook.getDivision();
            Brazil_priceBook.getSku(div.id);        
            
            List< Brazil_priceBook.wrapperForProductSku> lstOfWrapSku = new  List< Brazil_priceBook.wrapperForProductSku>();
            Brazil_priceBook.wrapperForProductSku wrapObjForSku = new Brazil_priceBook.wrapperForProductSku();
            Brazil_priceBook.wrapperForProductSku wrapObjForSku1 = new Brazil_priceBook.wrapperForProductSku();
            wrapObjForSku.id =  skuRecord.Id;
            wrapObjForSku.skuId = skuRecord.Id;
            wrapObjForSku.Name = skuRecord.Name;
            wrapObjForSku.SkuDes = skuRecord.SKU_Description__c;
            wrapObjForSku.minPrice = 10.00;
            wrapObjForSku.unitPrice = 15.00;
            wrapObjForSku.monthlyIntRate = 0;
            wrapObjForSku.exchangeRate = 0;
            lstOfWrapSku.add(wrapObjForSku);
            
            wrapObjForSku1.id =  skuRec2.Id;
            wrapObjForSku1.skuId = skuRec2.Id;
            wrapObjForSku1.Name = skuRec2.Name;
            wrapObjForSku1.SkuDes = skuRec2.SKU_Description__c;
            wrapObjForSku1.minPrice = 10.00;
            wrapObjForSku1.unitPrice = 15.00;
            wrapObjForSku1.monthlyIntRate = 0;
            wrapObjForSku1.exchangeRate = 0;
            lstOfWrapSku.add(wrapObjForSku1);
            
            String serlizeStr = JSON.serialize(lstOfWrapSku);  
            
            List<Brazil_priceBook.wrapperForSalesDistrict> lstOfWrapSalesDt = new  List<Brazil_priceBook.wrapperForSalesDistrict>();
            Brazil_priceBook.wrapperForSalesDistrict wrapObjForSalesDist = new Brazil_priceBook.wrapperForSalesDistrict();
            Brazil_priceBook.wrapperForSalesDistrict wrapObjForSalesDist1 = new Brazil_priceBook.wrapperForSalesDistrict();
            wrapObjForSalesDist.Id = region.id;
            wrapObjForSalesDist.sdtId = region.id;
            wrapObjForSalesDist.Name = region.Name;
            wrapObjForSalesDist.SDCode = region.RegionCode__c;
            lstOfWrapSalesDt.add(wrapObjForSalesDist);
            
            wrapObjForSalesDist1.Id = region1.id;
            wrapObjForSalesDist1.sdtId = region1.id;
            wrapObjForSalesDist1.Name = region1.Name;
            wrapObjForSalesDist1.SDCode = region1.RegionCode__c;
            lstOfWrapSalesDt.add(wrapObjForSalesDist);
            
            String serlizeStr1 = JSON.serialize(lstOfWrapSalesDt);
            
            
            Price_Book__c pbk = new Price_Book__c(
                Name = 'LISTA ABRIL ZARTAN - REGIONAL TRIANGULO - PRAZO AGOSTO 2017',
                Division__c = div.id,                                           
                Valid_From__c = system.today(),
                Expiry_Date__c = system.today()
            );
            // insert pbk;
            
            String validfrmDate = String.valueOf(System.today());
            String expiryfrm =  String.valueOf(System.today());
            
            /*
String currencyName = 'Only BRL';
Brazil_priceBook.savePriceBookapex(serlizeStr,pbk,serlizeStr1,validfrmDate,expiryfrm,currencyName);

String divisionName = priceBookObj.Division__c;
String currencyName1 = 'Only USD';
Brazil_priceBook.clonePriceBookapex(serlizeStr,priceBookObj,serlizeStr1,validfrmDate,expiryfrm,currencyName1,divisionName); 


String currencyName2 = 'Both';
Brazil_priceBook.savePriceBookapex(serlizeStr,pbk,serlizeStr1,validfrmDate,expiryfrm,currencyName2);
*/
            
            String divisionName = priceBookObj.Division__c;
            String currencyName1 = 'Both';
            Brazil_priceBook.clonePriceBookapex(serlizeStr,priceBookObj,serlizeStr1,validfrmDate,expiryfrm,currencyName1,divisionName); 
            
        } 
    }
}