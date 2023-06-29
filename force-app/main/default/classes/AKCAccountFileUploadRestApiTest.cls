@isTest
public class AKCAccountFileUploadRestApiTest {
        public static testMethod void method(){
        
        String body = 'First Name,Last Name,Mobile,Promotional Product code,Birthdate\r\n';
        body+='Ketan, test,9876554120,70407,1995-05-02\r\n';
        body+='Ganesh, test,9876554120,74400,1995-05-02\r\n';
        
        AKCAccountFileUploadRestAPI.processData(Blob.valueOf(body),'PreRegistered_Farmer');
        AKCAccountFileUploadRestAPI.sendEmail(body, body, 10, 10);
        
        /*body = 'First Name,Last Name,Mobile,Type,Capacity, Other Capacity,Distributor Code,Distributor Name,Town,Village\r\n';
        body+='XYZ,Shaikh,9899988452,Retailer,Proprietor,,,.,.,\r\n';
        body+='SDM,Shaikh,9785624142,Retailer,Proprietor,,,.,.,\r\n';*/
        
        body = 'First Name,Last Name,Mobile,Capacity, Other Capacity,Town,Village,Distributor Name\r\n';
        body+='XYZ,Shaikh,9899988452,Manager,,Nashik,,TestName\r\n';
        body+='SDM,Shaikh,9785624142,Manager,,Nashik,,TestName\r\n';
        AKCAccountFileUploadRestAPI.processData(Blob.valueOf(body),'AKC_Retailer');
        AKCAccountFileUploadRestAPI.sendEmail(body, body, 10, 10);
        
        body = 'First Name,Last Name,Mobile,Capacity, Other Capacity,Town,Village,Distributor Name,Email\r\n';
        body+='XYZ,Shaikh,9899988452,Manager,,Nashik,,TestName,abc@gmail.com\r\n';
        body+='SDM,Shaikh,9785624142,Manager,,Nashik,,TestName,abc@gmail.com\r\n';
        AKCAccountFileUploadRestAPI.processData(Blob.valueOf(body),'SWAL_Retailer');
        AKCAccountFileUploadRestAPI.sendEmail(body, body, 10, 10);
        
      // Added by Srikanth RITM0302706      
        body = 'Account Name,Mobile number,Email ID ,State,Village,Customer Type,Pincode,district,Tehsil';
        body+='XYZ,9899988452,xyz@gmail.com,,Madhya Pradesh,Sirpan,Sales team,461775,Hoshangabad,Pipariya\r\n';
        body+='XYZ,9899988452,xyz@gmail.com,,Madhya Pradesh,Sirpan,Sales team,461775,Hoshangabad,Pipariya\r\n';
        AKCAccountFileUploadRestAPI.processData(Blob.valueOf(body),'F3_C3_Sales_Team');
        
    }
    

}