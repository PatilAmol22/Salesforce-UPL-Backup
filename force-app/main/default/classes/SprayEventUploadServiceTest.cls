@isTest
public class SprayEventUploadServiceTest {
    static testMethod void Method(){
        List<SprayEventUploadService.SprayEventDetails> sprayList = new List<SprayEventUploadService.SprayEventDetails>();
        SprayEventUploadService.SprayEventDetails sprayObj = new SprayEventUploadService.SprayEventDetails();
        sprayObj.farmerCode  = 'test' ;
        sprayObj.cropCode  = 'test' ;
        sprayObj.acerage  = '' ;
        sprayObj.product1  = 'test' ;
        sprayObj.product1Quantity  = '20' ;
        sprayObj.machineCode  = '' ;
        sprayObj.machineOperatorCode  = '' ;
        sprayObj.amountCollected  = '2000' ;
        sprayObj.geolocation_Latitude  = '15.65654' ;
        sprayObj.geolocation_Longitude  = '12.531656' ;
        sprayObj.caseNumber  = '20000' ;
        sprayObj.product2  = 'test' ;
        sprayObj.product2Quantity  = '2000' ;
        sprayObj.product3  = 'test' ;
        sprayObj.product3Quantity  = '2000' ;
        sprayObj.product4  = 'test' ;
        sprayObj.product4Quantity  = '2000' ;
        sprayObj.eventPhoto  = '' ;
        sprayObj.eventVideo  = '' ;
        sprayObj.wrmsFarmerCode  = '' ; 
        sprayObj.wrmsId  = '' ; 
        sprayList.add(sprayObj);
        
        sprayList.add(sprayObj);
        SprayEventUploadService.uploadSprayEvent(sprayList);
    }
}