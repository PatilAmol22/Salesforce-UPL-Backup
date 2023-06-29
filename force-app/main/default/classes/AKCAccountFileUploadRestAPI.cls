@RestResource(urlMapping='/AKCFileUpload/v1/*')
global class AKCAccountFileUploadRestAPI {
    
    
    @HttpPost
    global static void attachDoc(){
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        
        String fName = req.params.get('FileName');
        String recordTypeName = req.params.get('RecordTypeName');
        system.debug('recordTypeName>>--->'+recordTypeName);
        Blob postContent = req.requestBody; 
        
        //Pass FileName & Blob to File Utility for File Splitting
        processData(postContent,recordTypeName);
        
    }
    
    public static void processData(blob csvfileBody,String recordTypeName){
        List<Account> insertAccount = new List<Account>();
        List<String> errorCSVList = new List<String>();
        List<String> successCSVList = new List<String>();
        Map<String,String> prod_codeMap=new Map<String,String>();
        Map<String,String> csvProCodeMap=new Map<String,String>();
        List<String> procodeList=new List<String>();
        List<String> stateNames =new List<String>();
        List<String> villageNames =new List<String>();
        //Vijaylaxmi
        
        List<String> pincodes =new List<String>();
        //Vijaylaxmi
        
        try{
            List<String> csvData = new List<String>();
            String strCSVFile = csvfileBody.toString();
            csvData  = strCSVFile.split('\r\n');
            String row = '';
            System.debug('recordTypeName : '+recordTypeName);
            //Id recordID = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
            Id recordID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
            successCSVList.add('Record ID,'+csvData[0]);
            errorCSVList.add(csvData[0]+',Error Description');
            List<Promotional_Product__c> proList1=[SELECT Id, Product_Name__r.Product_Code__c FROM Promotional_Product__c];
            for(Promotional_Product__c prod:proList1){
                prod_codeMap.put(prod.Product_Name__r.Product_Code__c,prod.Id);
                csvProCodeMap.put(prod.Product_Name__r.Product_Code__c,prod.Product_Name__r.Product_Code__c);
            }
            if(recordTypeName=='AKC_Retailer'){
            for(Integer i=1;i<csvData.size();i++){
                try{
                    List<String> csvLineItem = new List<String>();
                    row = csvData[i];
                    csvLineItem = csvData[i].split(',');
                    Account acnt=new Account();
                    acnt.ByPassVR_apex__c=True;
                    for(Integer j=0;j<csvLineItem.size();j++){
                        System.debug(''+csvLineItem[j]);
                        if(j==0){
                            if(String.isNotBlank(csvLineItem[j])){
                                
                                acnt.Name = csvLineItem[0]+' '+csvLineItem[1];
                                acnt.First_Name__c = csvLineItem[j];
                            }
                        }
                        else if(j==1){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.Last_Name__c = csvLineItem[j];
                            }
                        }
                        else if(j==2){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.Mobile__c = csvLineItem[j];
                            }
                        }
                        else if(j==3){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.Capacity__c = csvLineItem[j];
                            }
                        }
                        else if(j==4){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.Other_Capacity__c = csvLineItem[j];
                            }
                        }
                        else if(j==5){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.Town__c = csvLineItem[j];
                                //acnt.TownName__r = new Town__c(Town_Code__c = csvLineItem[j]);
                            }
                        }
                        else if(j==6){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.VillageName__c = csvLineItem[j];
                                //acnt.Village__r = new Village__c(Name = csvLineItem[j]);
                            }
                        }
                        else if(j==7){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.Address1__c = csvLineItem[j];
                            }
                        }
                        else if(j==8){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.Distributor_Name__c = csvLineItem[j];
                            }
                        }
                        
                    }
                    if(recordID!=null){
                        acnt.RecordTypeId=recordID;
                    }
                    insertAccount.add(acnt);
                    System.debug('insertAccount size : '+insertAccount.size());
                    System.debug('insertAccount : '+insertAccount);
                }catch(Exception e){
                    errorCSVList.add(row+','+e.getMessage());
                }
                
            }
           }
           if(recordTypeName=='SWAL_Retailer'){
            for(Integer i=1;i<csvData.size();i++){
                try{
                    List<String> csvLineItem = new List<String>();
                    row = csvData[i];
                    csvLineItem = csvData[i].split(',');
                    Account acnt=new Account();
                    acnt.ByPassVR_apex__c=True;
                    for(Integer j=0;j<csvLineItem.size();j++){
                        System.debug(''+csvLineItem[j]);
                        if(j==0){
                            if(String.isNotBlank(csvLineItem[j])){
                                
                                acnt.Name = csvLineItem[0]+' '+csvLineItem[1];
                                acnt.First_Name__c = csvLineItem[j];
                            }
                        }
                        else if(j==1){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.Last_Name__c = csvLineItem[j];
                            }
                        }
                        else if(j==2){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.Mobile__c = csvLineItem[j];
                            }
                        }
                        else if(j==3){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.Capacity__c = csvLineItem[j];
                            }
                        }
                        else if(j==4){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.Other_Capacity__c = csvLineItem[j];
                            }
                        }
                        else if(j==5){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.Town__c = csvLineItem[j];
                                //acnt.TownName__r = new Town__c(Town_Code__c = csvLineItem[j]);
                            }
                        }
                        else if(j==6){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.VillageName__c = csvLineItem[j];
                                //acnt.Village__r = new Village__c(Name = csvLineItem[j]);
                            }
                        }
                        else if(j==7){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.Address1__c = csvLineItem[j];
                            }
                        }
                        else if(j==8){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.Distributor_Name__c = csvLineItem[j];
                            }
                        }
                        else if(j==9){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.Email__c = csvLineItem[j];
                            }
                        }
                        
                    }
                    if(recordID!=null){
                        acnt.RecordTypeId=recordID;
                    }
                    insertAccount.add(acnt);
                    System.debug('insertAccount size : '+insertAccount.size());
                    System.debug('insertAccount : '+insertAccount);
                }catch(Exception e){
                    errorCSVList.add(row+','+e.getMessage());
                }
                
            }
           }
            if(recordTypeName=='PreRegistered_Farmer'){
            for(Integer i=1;i<csvData.size();i++){
                try{
                    System.debug('recordID: '+recordID);
                    List<String> csvLineItem = new List<String>();
                    row = csvData[i];
                    csvLineItem = csvData[i].split(',');

                    Account acnt=new Account();
                    System.debug('csvLineItem : '+csvLineItem);
                    for(Integer j=0;j<csvLineItem.size();j++){
                        System.debug(''+csvLineItem[j]);
                        if(j==0){
                            if(String.isNotBlank(csvLineItem[j])){
                                
                                //acnt.Name = csvLineItem[0]+' '+csvLineItem[1];
                                acnt.FirstName = csvLineItem[j];
                            }
                        }
                        else if(j==1){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.LastName = csvLineItem[j];
                            }
                        }
                        else if(j==2){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.PersonMobilePhone = csvLineItem[j];
                            }
                        }
                        else if(j==3){
                             if(String.isNotBlank(csvLineItem[j])){
                                stateNames.add(csvLineItem[j]);
                            }else{
                                errorCSVList.add(row+', State is blank');
                            }
                            }
                          /*  else if(j==3){
                             if(String.isNotBlank(csvLineItem[j])){
                                acnt.StateName__c =csvLineItem[j];
                        }
                        }*/
                        else if(j==4){
                             if(String.isNotBlank(csvLineItem[j])){
                                villageNames.add(csvLineItem[j]);
                            }else{
                                errorCSVList.add(row+', Village is blank');
                            }
                        }
                         else if(j==5){
                             if(String.isNotBlank(csvLineItem[j])){
                                acnt.Tehsil__c=csvLineItem[j];
                            }
                        }
                        else if(j==6){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.ZIP_Code__c =csvLineItem[j];
                            }
                        }
                        else if(j==7){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.District__c =csvLineItem[j];
                            }
                        }
                        else if(j==8){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.Preferred_Language__pc =csvLineItem[j];
                            }
                        }
                    }
                 /*   String keyValue='';
                    boolean isTrue=false;
                    for(String strkey2:procodeList){
                        if(prod_codeMap.get(strkey2)!=null){
                            isTrue=true;
                            keyValue=prod_codeMap.get(strkey2); 
                        }else {
                            isTrue=false;
                        }
                        System.debug('isTrue : '+isTrue);
                        if(isTrue==true){
                            acnt.Promotional_Product__c=keyValue;
                        } 
                    }
                    */
                    if(recordID!=null){
                        acnt.RecordTypeId=recordID;
                    }
                    insertAccount.add(acnt);
                    System.debug('insertAccount size : '+insertAccount.size());
                    System.debug('insertAccount : '+insertAccount);
                     System.debug('insertAccount : '+insertAccount[0].Id);
                }catch(Exception e){
                    errorCSVList.add(row+','+e.getMessage());
                }
                
            }

                List<State__c>   statesList    = [Select id,name from State__c where name IN:stateNames];
                List<Village__c> villagesList  = [Select id,name from Village__c where name IN:villageNames];
                Map<String,Id> statesMap   = new Map<String,Id>();
                Map<String,Id> villagesMap = new Map<String,Id>();
                for(State__c st:statesList){
                    statesMap.put(st.name, st.Id);
                }
                for(Village__c vlg:villagesList){
                    villagesMap.put(vlg.name,vlg.Id);
                }
                for(Integer i=0;i<insertAccount.size();i++){
                    Account act = insertAccount.get(i);
                    Id stateId  = statesMap.get(stateNames[i]);
                    Id villageId= villagesMap.get(villageNames[i]);
                        if(stateId!=null){
                            act.State__c=stateId ;
                        } 
                    if(villageId!=null){
                        act.Village__c = villageId;
                    }
                }
                }
              //  =================== added by Srikanth for RITM0302706 Start
              
                          if(recordTypeName=='F3_C3_Sales_Team'){
            for(Integer i=1;i<csvData.size();i++){
                try{
                    System.debug('recordID: '+recordID);
                    List<String> csvLineItem = new List<String>();
                    row = csvData[i];
                    csvLineItem = csvData[i].split(',');

                    Account acnt=new Account();
                    System.debug('csvLineItem : '+csvLineItem);
                    for(Integer j=0;j<csvLineItem.size();j++){
                        System.debug(''+csvLineItem[j]);
                        if(j==0){
                            if(String.isNotBlank(csvLineItem[j])){
                                
                                //acnt.Name = csvLineItem[0]+' '+csvLineItem[1];
                                acnt.Name = csvLineItem[j];
                            }
                        }
                        else if(j==1){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.Mobile__c = csvLineItem[j];
                            }
                        }
                        else if(j==2){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.Email__c = csvLineItem[j];
                            }
                        }
                        else if(j==3){
                             if(String.isNotBlank(csvLineItem[j])){
                               // stateNames.add(csvLineItem[j]);
                               acnt.StateName__c = csvLineItem[j];
                               
                            }else{
                                errorCSVList.add(row+', State is blank');
                            }
                            }
                          /*  else if(j==4){
                             if(String.isNotBlank(csvLineItem[j])){
                                acnt.StateName__c =csvLineItem[j];
                        }
                        }*/
                        else if(j==4){
                             if(String.isNotBlank(csvLineItem[j])){
                                villageNames.add(csvLineItem[j]);
                                acnt.VillageName__c=csvLineItem[j];
                            }else{
                                errorCSVList.add(row+', Village is blank');
                            }
                        }
                         else if(j==5){
                             if(String.isNotBlank(csvLineItem[j])){
                                acnt.Customer_Type__c=csvLineItem[j];
                            }
                        }
                        else if(j==6){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.ZIP_Code__c =csvLineItem[j];
                                //Vijaylaxmi
                                pincodes.add(csvLineItem[j]);
                            }
                        }
                        else if(j==7){
                            if(String.isNotBlank(csvLineItem[j])){
                                acnt.District__c =csvLineItem[j];
                            }
                        }
                        else if(j==8){
                             if(String.isNotBlank(csvLineItem[j])){
                                acnt.Tehsil__c=csvLineItem[j];
                            }
                        }
                        else if(j==9){
                             if(String.isNotBlank(csvLineItem[j])){
                                acnt.Language__c=csvLineItem[j];
                            }
                        }
                    }
                 /*   String keyValue='';
                    boolean isTrue=false;
                    for(String strkey2:procodeList){
                        if(prod_codeMap.get(strkey2)!=null){
                            isTrue=true;
                            keyValue=prod_codeMap.get(strkey2); 
                        }else {
                            isTrue=false;
                        }
                        System.debug('isTrue : '+isTrue);
                        if(isTrue==true){
                            acnt.Promotional_Product__c=keyValue;
                        } 
                    }
                    */
                    if(recordID!=null){
                        acnt.RecordTypeId=recordID;
                    }
                    insertAccount.add(acnt);
                    System.debug('insertAccount size : '+insertAccount.size());
                    System.debug('insertAccount : '+insertAccount);
                     System.debug('insertAccount : '+insertAccount[0].Id);
                }catch(Exception e){
                    errorCSVList.add(row+','+e.getMessage());
                }
                
            }

             //   List<State__c>   statesList    = [Select id,name from State__c where name IN:stateNames];
              //  List<Village__c> villagesList  = [Select id,name from Village__c where name IN:villageNames];
               system.debug('##########IN:pincodes'+pincodes);
                 List<Village__c> villagesList  = [Select id,name,Postal_Code__c from Village__c where name IN:villageNames and Postal_Code__c IN:pincodes  ];
                    system.debug('##########villagesList'+villagesList);
                Map<String,Id> statesMap   = new Map<String,Id>();
                Map<String,Id> villagesMap = new Map<String,Id>();
                /*for(State__c st:statesList){
                    statesMap.put(st.name, st.Id);
                }*/
                for(Village__c vlg:villagesList){
                    villagesMap.put(vlg.name,vlg.Id);
                }
                for(Integer i=0;i<insertAccount.size();i++){
                    Account act = insertAccount.get(i);
                   // Id stateId  = statesMap.get(stateNames[i]);
                    Id villageId= villagesMap.get(villageNames[i]);
                       /* if(stateId!=null){
                            act.State__c=stateId ;
                        } */
                    if(villageId!=null){
                        act.Village__c = villageId;
                    }
                }
                }
               // Srikanth Changes end  ===================
               
            if(insertAccount.size()>0){
                Database.SaveResult[] sr = Database.insert(insertAccount, false);
                System.debug('sr : '+sr);
                System.debug('sr.size(): '+sr.size());
                for(Integer i=0;i<sr.size();i++){ 
                    if (sr[i].isSuccess()) {
                        
                        successCSVList.add(insertAccount[i].get('Id')+','+csvData[i+1]);
                    }
                   else {
                        Database.Error[] errs = sr[i].getErrors();
                        errorCSVList.add(csvData[i+1]+','+errs[0].getMessage());
                    }
                }
                system.debug('success csvList==='+successCSVList);
                system.debug('err csvList==='+errorCSVList.size());
                system.debug('err csvList==='+errorCSVList);
                sendEmail(String.join(successCSVList, '\r\n'), String.join(errorCSVList, '\r\n'), successCSVList.size(), errorCSVList.size());
            }
            
        }catch(Exception e){
            System.debug('Error message : '+e.getMessage());
        }    
    }
    
    //Method to Notify User with Success/Error Files after Upload
    public static void sendEmail(String successFile, String errorFile, Integer successCount, Integer errorCount){
        system.debug('successFile : '+successFile);
        system.debug('errorFile : '+errorFile);
        system.debug('successCount : '+successCount);
        system.debug('errorCount : '+errorCount);
        try{
            Messaging.EmailFileAttachment successAttach = new Messaging.EmailFileAttachment();
            successAttach.setContentType('application/csv');
            successAttach.setFileName('Success.csv');
            successAttach.setInline(false);
            successAttach.Body = Blob.valueOf(successFile);
            Messaging.EmailFileAttachment errorAttach = new Messaging.EmailFileAttachment();
            errorAttach.setContentType('application/csv');
            errorAttach.setFileName('Error.csv');
            errorAttach.setInline(false);
            errorAttach.Body = Blob.valueOf(errorFile);
            
            DateTime d = Date.Today() ;
            String dateString =  d.format('dd/MM/yyyy') ;
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setToAddresses(new String[] { UserInfo.getUserEmail()});
            mail.setSubject('AKC Account Upload Status');
            mail.setHtmlBody('Dear User,<br /><br />Please find attached files generated in SFDC while uploading the Account Data<br /><br />Date: '+dateString+'<br /><br />No. of error records: '+(errorCount-1)+'<br /><br />Regards,<br/>UPL Salesforce Administrator<br />');
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { successAttach, errorAttach}); 
            
            // Send the email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
           }catch(Exception ex){
               system.debug('ex : '+ex.getStackTraceString());
           }
    }
}