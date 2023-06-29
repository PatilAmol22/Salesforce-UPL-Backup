@isTest(SeeAllData = True)
 public class tempuriOrgTest{
     public static testmethod void  testMethod1(){
         schemasDatacontractOrg200407UpiFil.FileDatawithBase64String  sch =new schemasDatacontractOrg200407UpiFil.FileDatawithBase64String();
        String Test ='Test';
         sch.ConfigrationID     = '1000';
         sch.BufferData         = Test;
         sch.AccessToken        = Test;
         sch.Division           = Test;
         sch.RequestNo          = Test;
         sch.FileName           = Test;
         sch.DistributorName    = Test;
         sch.RequisitionerName  = Test;
         tempuriOrg te = new tempuriOrg();
         tempuriOrg.UploadFilewithBase64stringResponse_element objResp = new tempuriOrg.UploadFilewithBase64stringResponse_element();
         objResp.UploadFilewithBase64stringResult ='test';
         objResp.UploadFilewithBase64stringResult_type_info.add('test');
         objResp.apex_schema_type_info.add('test');
         objResp.field_order_type_info.add('test'); 
         tempuriOrg.soap obj = new tempuriOrg.soap();
         obj.UploadFilewithBase64string(sch);
         schemasMicrosoftCom200310Serializat  sobj= new schemasMicrosoftCom200310Serializat ();
     }
 }