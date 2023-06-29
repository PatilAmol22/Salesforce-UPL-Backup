/*
Developer: Pranav Dinakaran
Description: Calling External wsdl class for file transfer of csr and complaint
*/
Global class USSharePointFileTransfer{


 
    
    @future(callout=true)
    global static void CallCSRServiceforFileTransfer(String IDCSR){
       String AuthResponse ='';
       String  Result='';
        Monitor_Log__c mg = new Monitor_Log__c();
         CSR__c  csrObj;
        Attachment attachment_Response;
       
        String binaryString ='';
        try{
            csrObj = [select id, name, Account_Name__c,AuthenticationToken__c,Owner.Email,ServiceRequestDateTime__c,RequestStatus__c,RequestNo__c,Approval_Submitted_Date__c,Account_Name__r.UPI_Division__c, Account_Name__r.Name from CSR__c where id =:IDCSR];
            List<Attachment> attachList = new List<Attachment>([select Id, Name, parentID,body FROM Attachment where parentID =:IDCSR limit 1]);
            RecordType rd=[select id, name from RecordType where  SobjectType='Monitor_Log__c' AND DeveloperName='US_REST_Service'];
            mg.RecordTypeId = rd.id;
            mg.Module__c ='CSR calling external SOAP service';
            
                
        
            
            if(attachList.size()>0)
            binaryString = EncodingUtil.base64Encode(attachList[0].body);
               
            // Authenticate to get Token
                // To get all details from Custom settings
                List<SharePointAuthentication__c> slist = SharePointAuthentication__c.getall().values();
                system.debug('Endpoint : '+ slist[0].Endpoint__c);
                system.debug('Endpoint : '+ slist[0].Password__c);
                system.debug('Endpoint : '+ slist[0].UserName__c);
                
                String CustomSettingUsername = slist[0].UserName__c;
                String CustomSettingPassword = slist[0].Password__c;
                
                Blob beforeblob = Blob.valueOf(CustomSettingPassword);
                system.debug('beforeblob ----> '+beforeblob);
                String password = EncodingUtil.base64Encode(beforeblob);
                tempuriOrg_Auth.soap1 sp = new tempuriOrg_Auth.soap1();
                if(! Test.isRunningTest()){
                    AuthResponse = sp.GenerateToken(CustomSettingUsername, password);
                  }
                  else{
                      AuthResponse = '<Message><Token>Tokene123</Token></Message>';
                  }
                system.debug('Auth Result ----> '+AuthResponse);
            //end
           
            
            //If Token Response not null parse token and upload file
             if(AuthResponse != '' && !AuthResponse.contains('Invalid username or password')){
                  String token1 ='';
                   /* Parsing String using STRING Functions       
                     //Parsing token
                     token1  =  AuthResponse.substringBetween('Token');
                     system.debug('Token between------>'+token1);
                     token1 = token1.replace('>','');
                     token1 = token1.replace('</','');
                     token1 = token1.trim();
                     System.debug('Final Token --  ::'+token1);
                     //End
                     */
                     // XML PARSING USING DOM
                     //Xml parser
                         DOM.Document doc = new DOM.Document();
                         doc.load(AuthResponse);    
                         DOM.XMLNode root = doc.getRootElement();                  
                        token1= XMLParser.walkThrough2(root, 'Token');
                         system.debug('Token from XML----> :'+token1);
                      //END                     
                     // Upload File Method         
                     schemasDatacontractOrg200407UpiFil.FileDatawithBase64String  sch =new schemasDatacontractOrg200407UpiFil.FileDatawithBase64String();
                     sch.ConfigrationID     = '1000';
                     sch.BufferData         = binaryString;
                     sch.AccessToken        = String.valueof(token1);
                     sch.Division           = String.valueof(csrObj.Account_Name__r.UPI_Division__c);
                     sch.RequestNo          = String.valueof(csrObj.RequestNo__c);
                     sch.FileName           = String.valueof(attachList[0].Name);
                     sch.DistributorName    = String.valueof(csrObj.Account_Name__r.Name);
                     Date d= system.today();
                  
                        String sMonth = String.valueof(d.month());
                        String sDay = String.valueof(d.day());
                        if(sMonth.length()==1){
                          sMonth = '0' + sMonth;
                        }
                        if(sDay.length()==1){
                          sDay = '0' + sDay;
                        }
                      
                     sch.DateofApproval     = sMonth +'/'+ sDay +'/'+d.year();
                     sch.DateofRequisition  = sMonth +'/'+ sDay +'/'+ d.year();
                     sch.RequisitionerName  = string.valueof(csrobj.Owner.Email);
                    tempuriOrg.soap soap_obj = new tempuriOrg.soap();
                   if(! Test.isRunningTest()){
                    result= soap_obj.UploadFilewithBase64string(sch);
                    }
                    else{
                        result='Success';
                    }
               
                     system.debug('Result from Sharepoint--->'+result);
                     //End
                     if(result!='' && !result.contains('InValid Token') &&  !result.contains('InValid MetaData')){
                             csrobj.RequestStatus__c ='Submitted';
                             csrobj.ServiceRequestDateTime__c = System.now();
                             
                             Update csrobj;
                            
                             mg.Message__c = result;
                             mg.AuthenticationToken__c = AuthResponse;
                             mg.CSR__c =  csrObj.id; 
                             insert mg;
                             
                             attachment_Response = new Attachment();
                             attachment_Response.Body = Blob.valueOf(result);
                             attachment_Response.Name = String.valueOf('ResponseBody.txt');
                             attachment_Response.ParentId = mg.id; 
                             attachment_Response.ContentType ='.txt';
                             insert  attachment_Response;
                            
                         }
                         else{
                             mg.Message__c = result;
                             mg.AuthenticationToken__c = AuthResponse;
                             mg.CSR__c =  csrObj.id; 
                             insert mg;
                             csrobj.RequestStatus__c ='Error';
                             csrobj.ServiceRequestDateTime__c = System.now();
                             Update csrobj;
                         }
                            
                    }
                    else{
                            mg.Message__c = AuthResponse;
                             mg.AuthenticationToken__c = AuthResponse;
                             mg.CSR__c =  csrObj.id; 
                             insert mg;
                             csrobj.RequestStatus__c ='Error';
                             csrobj.ServiceRequestDateTime__c = System.now();
                             Update csrobj;
                    }
                    
                    
                   
                
         }
          catch(Exception e){
          if(csrObj != NULL){
              mg.CSR__c =  csrObj.id; 
              csrobj.RequestStatus__c='Error';
             csrobj.ServiceRequestDateTime__c = System.now();
             Update csrobj;
             }
             mg.Message__c = String.valueof(e.getMessage());
             mg.Line_Number__c = Integer.valueof(e.getLineNumber());
             mg.Stack_Trace__c = String.valueof(e.getStackTraceString());
             mg.Cause__c = String.valueof(e.getCause());
              mg.AuthenticationToken__c = AuthResponse;  
              insert mg;
             
             system.debug('Exception:::::'+e.getMessage());
           
             

          }  
   }
    
   @future(callout=true)
    global static void CallCaseServiceforFileTransfer(String IDCase){
        String Result='';
        String AuthResponse ='';
        Monitor_Log__c mg = new Monitor_Log__c();
        String binaryString ='';
        Case caseObj ;
        Attachment attachment_Response;
        try{
        caseObj= [SELECT Id,  CaseNumber, AccountId, Account.Name,AuthenticationToken__c, Account.UPI_Division__c,Status, TypeofComplaint__c, RequestNo__c FROM Case where id=: IDCase];   
      
        List<Attachment> attachList = new List<Attachment>([select Id, Name, parentID,body FROM Attachment where parentID =:IDCase limit 1]);
        RecordType rd=[select id, name from RecordType where  SobjectType='Monitor_Log__c' AND DeveloperName='US_REST_Service'];
            mg.RecordTypeId = rd.id;
            mg.Module__c ='CASE calling external SOAP service';
           
                
        
            
            if(attachList.size()>0)
            binaryString = EncodingUtil.base64Encode(attachList[0].body);
            system.debug('BinaryString :::'+binaryString); 
             // Authenticate to get Token
            Blob beforeblob = Blob.valueOf('pass#%%^561565215445%$###');
            String password = EncodingUtil.base64Encode(beforeblob);
            tempuriOrg_Auth.soap1 sp = new tempuriOrg_Auth.soap1();
            if(!Test.isRunningTest()){
                AuthResponse = sp.GenerateToken('User1', password);
               }
               else{
                   AuthResponse ='<Message><Token>token123</Token></Message>';
               }
            //End
            
            system.debug('Auth Result ----> '+AuthResponse);
            
            if(AuthResponse != '' && !AuthResponse.contains('Invalid username or password')){ 
                     String token1 ='';
                   /* Parsing String using STRING Functions       
                     //Parsing token
                     token1  =  AuthResponse.substringBetween('Token');
                     system.debug('Token between------>'+token1);
                     token1 = token1.replace('>','');
                     token1 = token1.replace('</','');
                     token1 = token1.trim();
                     System.debug('Final Token --  ::'+token1);
                     //End
                     */
                     // XML PARSING USING DOM
                     //Xml parser
                         DOM.Document doc = new DOM.Document();
                         doc.load(AuthResponse);    
                         DOM.XMLNode root = doc.getRootElement();                  
                        token1= XMLParser.walkThrough2(root, 'Token');
                         system.debug('Token from XML----> :'+token1);
                      //END        
                     //Upload file Method
                     schemasDatacontractOrg200407UpiFil.FileDatawithBase64String  sch =new schemasDatacontractOrg200407UpiFil.FileDatawithBase64String();
                     Date d= system.today();
                     sch.ConfigrationID     = '2000';
                     sch.CaseNumber         = String.valueof(caseObj.CaseNumber);
                     sch.AccessToken        = String.valueof(token1);
                     sch.BufferData         = binaryString;
                     sch.Division           = String.valueof(caseObj.Account.UPI_Division__c);
                     sch.RequestNo          = String.valueof(caseObj.RequestNo__c);
                     sch.FileName           = String.valueof(attachList[0].Name);
                     sch.DistributorName    = String.valueof(caseObj.Account.Name);
                     sch.TypeofComplaint    = String.valueOf(caseObj.TypeofComplaint__c);
                     sch.ResolutionStatus   = String.valueof(caseObj.Status);
                     String sMonth = String.valueof(d.month());
                        String sDay = String.valueof(d.day());
                        if(sMonth.length()==1){
                          sMonth = '0' + sMonth;
                        }
                        if(sDay.length()==1){
                          sDay = '0' + sDay;
                        }
                     sch.DateofOrigin       = sMonth + '/' + sDay + '/' + d.year();
                     
                     tempuriOrg.soap soap_obj = new tempuriOrg.soap();
                     if(! Test.isRunningTest()){
                         result = soap_obj.UploadFilewithBase64string(sch);
                       }
                       else{
                           result ='Success';
                       }
               
                     system.debug('Result from Sharepoint--->'+ result);
                     //End
                     if(result!='' && !result.contains('InValid Token') &&  !result.contains('InValid MetaData')){
                             caseObj.RequestStatus__c = 'Submitted';
                             caseObj.ServiceRequestDateTime__c = System.now();
                             Update caseObj;
                            
                             mg.Message__c = result;
                             mg.AuthenticationToken__c = AuthResponse;
                             mg.Case__c =  caseObj.id;
                             insert mg;
                             
                             attachment_Response = new Attachment();
                             attachment_Response.Body = Blob.valueOf(result);
                             attachment_Response.Name = String.valueOf('ResponseBody.txt');
                             attachment_Response.ParentId = mg.id; 
                             attachment_Response.ContentType ='.txt';
                             insert  attachment_Response;
                             
                         }
                         else{
                             mg.Message__c = result;
                             mg.Case__c =  caseObj.id;
                             mg.AuthenticationToken__c = AuthResponse;
                             insert mg;
                             caseObj.RequestStatus__c='Error';
                             caseObj.ServiceRequestDateTime__c = System.now();
                             Update caseObj;                          
                         }
                             
                            
                    }
                    else{
                        mg.Message__c = AuthResponse;
                         mg.Case__c =  caseObj.id;
                         mg.AuthenticationToken__c = AuthResponse;
                         insert mg;
                         caseObj.RequestStatus__c='Error';
                         caseObj.ServiceRequestDateTime__c = System.now();
                         Update caseObj;
                        }
                    
                
         }
          catch(Exception e){
            if(caseObj != Null){ 
             mg.Case__c =  caseObj.id;
             caseObj.RequestStatus__c='Error';
             caseObj.ServiceRequestDateTime__c = System.now();
             Update caseObj; 
            }
             mg.Message__c = String.valueof(e.getMessage());
             mg.Line_Number__c = Integer.valueof(e.getLineNumber());
             mg.AuthenticationToken__c = AuthResponse;
             mg.Stack_Trace__c = String.valueof(e.getStackTraceString());
             mg.Cause__c = String.valueof(e.getCause());  
             insert mg;
             
             system.debug('Exception:::::'+ e.getMessage());

          }  
   }
 
    
    
  

}