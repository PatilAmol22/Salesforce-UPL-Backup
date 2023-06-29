@isTest 
public class SpainPortugalUploadCsvFileCtrl_Test {
    public static String[] csvFileLines;
    public static Blob csvFileBody;
    public Id UpdateAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();    
    static testmethod void testMassupload(){
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Iberia').getRecordTypeId();  
        
        
        
        Distribution_Channel__c dcObj = new Distribution_Channel__c(
            Name = 'Depot',                     // Distribution Channel Name
            Distribution_Channel_Code__c = '20'  // Distribution Channel Code
        );
        insert dcObj;
        
        Division__c divObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert divObj;
        
        Sales_Org__c salesOrgobj = new Sales_Org__c(
            Name = 'Spain',              // Sales Org Name
          Sales_Org_Code__c = '2510'   // Sales Org Code
       );
        insert salesOrgobj;
        
        Account accobj = new Account(
            Name = 'Pal',// Account Name
            Email__c = '*abascunana@agricolabascunana.com',                 // Email
            Depot_Code__c = 'ES01',                                         // Depot Code
            //Order_Block__c = false,                                         // Order Block
            //Payment_Terms__c = '0101',
            
            //Is_Fixed_Rate_Available_Italy__c = false,                       // Is Fixed Rate Available
            Sales_Org__c = salesOrgobj.Id,                               // Sales Org
            //Tax_Number_1__c = '04517426L',                                  // Tax Number 1
            Account_Type__c = 'Sold To Party',
            Phone ='1234567890', // Account Type
            Division__c = divObj.Id,                                // Division Name
            Distribution_Channel__c = dcObj.Id,                    // Distribution Channel
            RecordTypeId = accRecordTypeId,                                     // Account Record Type
            Last_Name__c = 'ANGEL BASCUÑANA NO',           // Last Name
            Billing_Street_1__c = 'CTRA. VALENCIA KM. 86,3'
            //Country__c= 'Other'				// Billing Street 1
           
                                               
        );
        insert accobj;
        
        
        SpainPortugalUploadCsvFileController.fieldWrapper ordWrapper = new SpainPortugalUploadCsvFileController.fieldWrapper();
        ordWrapper.SalesOrgCode = '2510';
		ordWrapper.DistributionChannel = '20';
		ordWrapper.Division = '10';
		ordWrapper.Opportunity = '706506';
		ordWrapper.CurrencyIsoCode = 'EUR';
		ordWrapper.Name = 'SK';
		ordWrapper.Street = 'DSP Road';
		ordWrapper.PostalCode = '231234';
		ordWrapper.City = 'Dadar';
		ordWrapper.Province = 'ABC';
		ordWrapper.Country = 'Spain';
		ordWrapper.Email = 'Pal23@gmail.com';
		ordWrapper.Phone = '7876765645';
		ordWrapper.Kind = 'Retailer';
		ordWrapper.ProductsConsumed='BN2746CN0104FC0026$BN2949CN0193FC0087';
		ordWrapper.Priority = 'High';
		ordWrapper.Comments = 'Test CSV';
        ordWrapper.SAPCode = '1018191';
		ordWrapper.RelationshipProfile = 'B2B';
		ordWrapper.MarketSalesProfile = 'Retailer';
		ordWrapper.ClassicalClassification = 'Gold';
		ordWrapper.MarketAccessibility = '0% - 5%';
		ordWrapper.SAPCustomerCode = '1018191';
		ordWrapper.Crop = 'CC004';
		ordWrapper.CropHa = 123;
        ordWrapper.CropFocus = 'Algodon';
        
        
        
        String body='[SalesOrgCode,DistributionChannel,Division,CurrencyIsoCode,Name,Street,PostalCode,City,Province,Country,Email,Phone,Kind,Priority,Comments\r\n]';
        body+='2510,20,10,706506,EUR,SKI,DSP Road,231234,Dadar,ABC,Spain,Pal23@gmail.com,7876765645,Retailer,BN2746CN0104FC0026$BN2747CN0104FC0026,High,Test CSV\r\n';
        body+='2510,20,10,706506,EUR,SKI,DSP Road,231234,Dadar,ABC,Spain,Pal24@gmail.com,7876765645,Retailer,BN2746CN0104FC0026$BN2747CN0104FC0026,High,Test CSV\r\n';
        Test.startTest();
        csvFileBody = Blob.valueOf(body);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n'); 
        SpainPortugalUploadCsvFileController importData = new SpainPortugalUploadCsvFileController();
        List<SpainPortugalUploadCsvFileController.fieldWrapper> ordItemWrapperList = new List<SpainPortugalUploadCsvFileController.fieldWrapper>();
        ordItemWrapperList.add(ordWrapper);
        SpainPortugalUploadCsvFileController.updateCSVData('Insert Prospect Account', JSON.serialize(ordItemWrapperList));
        SpainPortugalUploadCsvFileController.updateCSVData('Update Customer Segmentation', JSON.serialize(ordItemWrapperList));
        SpainPortugalUploadCsvFileController.updateCSVData('Insert Farmer Account', JSON.serialize(ordItemWrapperList));
        
        
        
        Test.stopTest();
        
        
    }
    
}