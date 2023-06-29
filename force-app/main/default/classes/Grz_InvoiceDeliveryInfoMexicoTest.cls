@isTest
public class Grz_InvoiceDeliveryInfoMexicoTest {
    
	Public  static testmethod void testgetInvoiceDelivery(){
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        Test.stopTest();
        Grz_InvoiceDeliveryInfoMexico.getInvoiceDelivery('6050285064');
        Grz_InvoiceDeliveryInfoMexico.InvoiceInfo info = new Grz_InvoiceDeliveryInfoMexico.InvoiceInfo();
        info.DateDelivery = '15/06/2021';
        info.Extension = 'pdf';
        info.FileBase64 = 'JVBERi0xLjQKJdP0zOE';
        info.IdRemission = '6050285064';
        info.Status = 'Entregado';
    }
    
    Public  static testmethod void testgetMexicoInvoicePDF(){
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        Test.stopTest();
        Grz_InvoiceDeliveryInfoMexico.getMexicoInvoicePDF('2110842611');
        Grz_InvoiceDeliveryInfoMexico.Item item = new Grz_InvoiceDeliveryInfoMexico.Item();
        item.Bukrs = 'Test123';
        item.Refdoc = '2110842611';
        item.Base64 = 'werdfghjloyuiy';
        Grz_InvoiceDeliveryInfoMexico.InvoiceInfo info = new Grz_InvoiceDeliveryInfoMexico.InvoiceInfo();
        info.DateDelivery = '15/06/2021';
        Grz_InvoiceDeliveryInfoMexico.ResultWrapper rw = new Grz_InvoiceDeliveryInfoMexico.ResultWrapper();
        rw.DataRemission = info;
    }
}