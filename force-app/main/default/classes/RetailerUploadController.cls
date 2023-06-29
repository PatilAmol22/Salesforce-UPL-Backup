public class RetailerUploadController{
    @AuraEnabled
    public static String getDocument()
	{
        List<document> DocumentList = new List<document>(); 
        String Templatefile = '/servlet/servlet.FileDownload?file=';
        String newTemplatefile;
        DocumentList = [select Name from document where Name = 'Retailer Upload Template'];
        if(DocumentList.size()>0){
            newTemplatefile = Templatefile+DocumentList[0].Id;
            system.debug('checktemplate '+newTemplatefile);
        }
        return newTemplatefile;
    }
    public class returnWrapper 
    {
        @AuraEnabled
        public List<errorWrapper> eList{get;set;}
        @AuraEnabled
        public String returnValue{get;set;}
        @AuraEnabled
        public String err{get;set;}
        @AuraEnabled
        public String succ{get;set;}
        @AuraEnabled
        public String sub{get;set;}
        @AuraEnabled
        public String mailBody{get;set;}
        
        
        
    }
	public class errorWrapper 
	{
        @AuraEnabled
        public String salesorg {get;set;}
        @AuraEnabled
        public String name {get;set;}
       @AuraEnabled
        public string phone{get;set;}
        @AuraEnabled
        public string email{get;set;}
        @AuraEnabled
        public string ebid {get;set;}
        @AuraEnabled
        public String parentid {get;set;}
        @AuraEnabled
        public String street1 {get;set;}
		@AuraEnabled
        public String street2 {get;set;}
        @AuraEnabled
        public String street3 {get;set;} 
        @AuraEnabled
        public String city {get;set;} 
        @AuraEnabled
        public String zip {get;set;} 
        @AuraEnabled
        public String state {get;set;} 
        @AuraEnabled
        public String country {get;set;}
        @AuraEnabled
        public String rType {get;set;}
		@AuraEnabled
        public String reason {get;set;}
    }
	
    @AuraEnabled
    public static returnWrapper passFileAura(String file)
    {
         try
        {
        String returnValue;
        String[] csvFileLines;
            list<String> csv= new list<string>();
            system.debug('file::'+file);
            SplitString splitObj = new SplitString(); 
        List<String> csvData = new List<String>();
        csvData = splitObj.safeSplit(file, '\n');
            Integer divideCsv = 0;
     
        if((csvData.size()-1)<=5000){
            divideCsv = (csvData.size()-1);
        }
        else if((csvData.size()-1)<=10000){
            divideCsv = (csvData.size()-1)/2;
        }
        else if((csvData.size()-1)<=15000){
            divideCsv = (csvData.size()-1)/3;
        }
        else if((csvData.size()-1)<=20000){
            divideCsv = (csvData.size()-1)/4;
        }
        else{
            divideCsv = (csvData.size()-1)/5;
        }
        system.debug('divide csv is '+ divideCsv);
        
        List<String> csvAttachment = new List<String>();
        //list<String> csv  = new list<String>();
                
        String header = csvData[0].replaceAll('\u0009','').trim();   
        for(Integer j=1; j <csvData.size(); j++){
            
            csvAttachment.add(csvData[j].replaceAll('\u0009','').trim());
            
            if(j==divideCsv){
                String csvs='';
                csvs= String.join(csvAttachment, '\r\n');
                csvs+='\r\n';
                csv.add(csvs);
                csvAttachment.clear();
            }
            else if(j==divideCsv*2){
                String csvs='';
                csvs = String.join(csvAttachment, '\r\n');
                csvs+='\r\n';
                csv.add(csvs);
                csvAttachment.clear();
            }
            else if(j==csvData.size()-1){
                String csvs='';
                csvs = String.join(csvAttachment, '\r\n');
                csvs+='\r\n';
                csv.add(csvs);
              
                csvAttachment.clear();
            }    
    }
             //csv= FileUtilitySalesData.processAttachment(email.binaryAttachments[i].filename, email.fromAddress, emailSubject, email.binaryAttachments[i].body);
			//FileUtilitySalesData.processSalesData(csvFile);
			List<List<String>> combinedCSV = new List<List<String>>();
returnWrapper ret=new returnWrapper();
            for(String cc:csv){
        csvFileLines = cc.split('\n');
                if (csvFileLines.size()<=200 && csv.size()==1){
                     ret=passFile(file);
            if(!ret.returnvalue.contains('success')){
                List<Messaging.Emailfileattachment> efaList = new List<Messaging.Emailfileattachment>();
			Messaging.EmailFileAttachment csvsuccessAttc = new Messaging.EmailFileAttachment();
                if(ret.succ!=null){
				blob csvsuccessBlob = Blob.valueOf(ret.succ);
				string csvsuccessname= 'RetailerSuccess.csv';
				csvsuccessAttc.setFileName(csvsuccessname);
				csvsuccessAttc.setBody(csvsuccessBlob);
				efaList.add(csvsuccessAttc);
                }
				String loggedInUser= UserInfo.getUserEmail();
				system.debug('email value is '+ loggedInUser);
				
				Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                if(ret.err!=null){
				blob csvBlob = Blob.valueOf(ret.err);
				string csvname= 'RetailerError.csv';
				csvAttc.setFileName(csvname);
				csvAttc.setBody(csvBlob);
				efaList.add(csvAttc);
                }
				Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
				String[] toAddresses = new list<string> {loggedInUser};
					String subject =Label.RU_email_Subject;
				email.setSubject(ret.sub);
				email.setToAddresses( toAddresses );
				email.setPlainTextBody(ret.mailbody);
				email.setFileAttachments(efaList);
				Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }
            
				//return ret;
                }
                else{
                    ret.returnValue='InBatch';
                system.debug('hello'+csvFileLines.size());
                RetailerUploadBatch batch = new RetailerUploadBatch(cc); 
			database.executeBatch(batch,200);
                  
                }
                
            
             
        }
       return ret;  
            
            
      
            
				//return ret;
        
     }
        Catch(exception e)
        {
            System.debug('ex No: '+e.getLineNumber()+'The following exception has occurred: ' + e.getMessage());
            returnWrapper ret=new returnWrapper();
            ret.returnValue='error';
            return ret;
        } 
            
    }
    
    
	
    @AuraEnabled
    public static returnWrapper passFile(String file)
    {
        returnWrapper ret=new returnWrapper();
        try
        {
            
			list<errorWrapper> errorList= new list<errorWrapper>();
            list<String> csvFileLines= new list<String>();
            Map<String,Id> sorMap=new Map<String,Id>();
			Map<Integer,boolean> validRecord= new map<Integer,boolean>();    
			//String[] csvFileLines;
            String[] newCsvFileLines;
			Integer k=1;
			Integer j=0;
			List<Account> AccountList = new List<Account>();
			set<String> lstEBIDCode = new set<String>();
            List<String> EBIDCodeList = new List<String>();
			List<string> inputvalues = new list<string>();
			newCsvFileLines = file.split('\n');
			system.debug('csvFileLines-------'+newCsvFileLines);
           for(String csvLine :newCsvFileLines){
                String prevLine = csvLine;
Integer startIndex;
Integer endIndex;

while(csvLine.indexOf('"') > -1){

    if(startIndex == null){
        startIndex = csvLine.indexOf('"');
        csvLine = csvLine.substring(0, startIndex) + ':quotes:' + csvLine.substring(startIndex+1, csvLine.length());
    }else{
        if(endIndex == null){
            endIndex = csvLine.indexOf('"');
            csvLine = csvLine.substring(0, endIndex) + ':quotes:' + csvLine.substring(endIndex+1, csvLine.length());
        }
    }
    
    if(startIndex != null && endIndex != null){
        String sub = csvLine.substring(startIndex, endIndex);
        sub = sub.replaceAll(',', ':comma:');
        csvLine = csvLine.substring(0, startIndex) + sub + csvLine.substring(endIndex, csvLine.length());
        startIndex = null;
        endIndex = null;
    }
}

System.debug('prevLine:::'+prevLine);
System.debug('csvLine:::'+csvLine);
/*String csvslpit='';
           List<String>  csList=  csvLine.split(',');
for(Integer i=0;i<csList.size();i++){
    //csvslpit='';
 	csList[i]=csList[i].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
  //System.debug('column::'+column);
    if(i==0){
        csvslpit=csList[i];
    }
    else {
    csvslpit=csvslpit+','+csList[i];
    }
    if(i==csList.size()-1){
        csvslpit=csvslpit+'\n';
    }
    system.debug(csvslpit+csvslpit);
    
}
               System.debug('csvLine:::'+csvLine);*/
               csvFileLines.add(csvLine);
               
            }
            system.debug(csvFileLines+'csvFileLines');
			for (j=1;j<csvFileLines.size();j++)
			{                    
                
				inputvalues = csvFileLines[j].split(',');
                system.debug('inputvalues'+inputvalues[4]);
                system.debug(inputvalues.size()+'test'+inputvalues);
                lstEBIDCode.add(inputvalues[4].trim());
                
            }    
            EBIDCodeList.addAll(lstEBIDCode);
            system.debug('EBIDCodeList'+EBIDCodeList);
			Map<Id, Account> mapAcc = new Map<Id, Account>([SELECT id, Sold_To_Party__c , SAP_Code__c,ship_to_party_sap_code__c,combination_key__c, OwnerId,EBID__c FROM Account WHERE EBID__c IN : EBIDCodeList]);
			Map<String, Id> mapAccId = new Map<String, Id>();
            for(Id itemId: mapAcc.keySet())
            {
                system.debug('in'+mapAcc.get(itemId).EBID__c+itemId);
				mapAccId.put(mapAcc.get(itemId).EBID__c, itemId);
                }
            
            //SalesOrgCode__c sorg = SalesOrgCode__c.getValues('NAM'); 
			//String SalesOrgCode=sorg.Code__c; 
			//String SalesOrgCode='3100';
            //System.debug('Code'+SalesOrgCode);
            
			List<Sales_Org__c> sorglst = [Select id, name,Sales_Org_Code__c from Sales_Org__c];
            for(Sales_Org__c s:sorglst){
                sorMap.put(s.Sales_Org_Code__c,s.id);
            }
            system.debug('**sor'+sorMap);
			for (j=1;j<csvFileLines.size();j++)
            {                    
				String counter='0';
				inputvalues = csvFileLines[j].split(',');
				errorWrapper err = new errorWrapper();
				err.reason='';
                 system.debug(inputvalues[12]+'**enter');             
				if (inputvalues[12]==null || inputvalues[12]=='' || inputvalues[12]==' ' || sorMap.get(inputvalues[12].trim())==null)
				{
					validRecord.put(j,false);
					system.debug('Salesorg null'+ validRecord.get(j));
					err.name=inputvalues[0].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                    err.phone=inputvalues[2];
                    //err.email= inputvalues[0];
					err.email = inputvalues[1];
					err.ebid= inputvalues[3];
					err.parentid= inputvalues[4];
					err.street1= inputvalues[5].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
					err.street2=inputvalues[6].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                    err.street3=inputvalues[7].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                    err.city=inputvalues[8];
                    err.zip=inputvalues[9];
                    err.state=inputvalues[10];
                    err.country=inputvalues[11];
                    err.salesorg=inputvalues[12];
                    err.rType=inputvalues[13];
					err.reason= err.reason+' Sales org code is required or does not exist in system';
					counter='1';  
				}   
				if (inputvalues[0]==null || inputvalues[0]=='')
				{
					validRecord.put(j,false);
					system.debug('Account name null'+ validRecord.get(j));
					err.name=inputvalues[0].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                    err.phone=inputvalues[2];
                    //err.email= inputvalues[0];
					err.email = inputvalues[1];
					err.ebid= inputvalues[3];
					err.parentid= inputvalues[4];
					err.street1= inputvalues[5].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
					err.street2=inputvalues[6].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                    err.street3=inputvalues[7].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                    err.city=inputvalues[8];
                    err.zip=inputvalues[9];
                    err.state=inputvalues[10];
                    err.country=inputvalues[11];
                    err.salesorg=inputvalues[12];
                    err.rType=inputvalues[13];
					err.reason= err.reason+' Account Name is required';
					counter='1';  
				}
				
				if(inputvalues[1] == null || inputvalues[1] =='')
				{
					validRecord.put(j,false);
					err.name=inputvalues[0].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                    err.phone=inputvalues[2];
                    //err.email= inputvalues[0];
					err.email = inputvalues[1];
					err.ebid= inputvalues[3];
					err.parentid= inputvalues[4];
					err.street1= inputvalues[5].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
					err.street2=inputvalues[6].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                    err.street3=inputvalues[7].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                    err.city=inputvalues[8];
                    err.zip=inputvalues[9];
                    err.state=inputvalues[10];
                    err.country=inputvalues[11];
                    err.salesorg=inputvalues[12];
                    err.rType=inputvalues[13];
					err.reason= err.reason+' Email is required';
					counter='1';  
				}
				if(inputvalues[2] == null || inputvalues[2] =='')
				{
					validRecord.put(j,false);
					err.name=inputvalues[0].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                    err.phone=inputvalues[2];
                    //err.email= inputvalues[0];
					err.email = inputvalues[1];
					err.ebid= inputvalues[3];
					err.parentid= inputvalues[4];
					err.street1= inputvalues[5].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
					err.street2=inputvalues[6].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                    err.street3=inputvalues[7].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                    err.city=inputvalues[8];
                    err.zip=inputvalues[9];
                    err.state=inputvalues[10];
                    err.country=inputvalues[11];
                    err.salesorg=inputvalues[12];
                    err.rType=inputvalues[13];
					err.reason= err.reason+' Phone is required';
					counter='1';  
				}
                if(inputvalues[3] == null || inputvalues[3] =='')
				{
					validRecord.put(j,false);
					err.name=inputvalues[0].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                    err.phone=inputvalues[2];
                    //err.email= inputvalues[0];
					err.email = inputvalues[1];
					err.ebid= inputvalues[3];
					err.parentid= inputvalues[4];
					err.street1= inputvalues[5].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
					err.street2=inputvalues[6].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                    err.street3=inputvalues[7].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                    err.city=inputvalues[8];
                    err.zip=inputvalues[9];
                    err.state=inputvalues[10];
                    err.country=inputvalues[11];
                    err.salesorg=inputvalues[12];
                    err.rType=inputvalues[13];
					err.reason= err.reason+' EBID is required';
					counter='1';  
				}
				if(inputvalues[4] == null || inputvalues[4] =='' || mapAccId.get(inputvalues[4])==null)
				{
                    system.debug(mapAccId.get(inputvalues[4]));
					validRecord.put(j,false);
					err.name=inputvalues[0].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                    err.phone=inputvalues[2];
                    //err.email= inputvalues[0];
					err.email = inputvalues[1];
					err.ebid= inputvalues[3];
					err.parentid= inputvalues[4];
					err.street1= inputvalues[5].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
					err.street2=inputvalues[6].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                    err.street3=inputvalues[7].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                    err.city=inputvalues[8];
                    err.zip=inputvalues[9];
                    err.state=inputvalues[10];
                    err.country=inputvalues[11];
                    err.salesorg=inputvalues[12];
                    err.rType=inputvalues[13];
                    if(inputvalues[4] == null || inputvalues[4] =='' ){
					err.reason= err.reason+' Parent Ship to is required';
                    }
                    else if(mapAccId.get(inputvalues[4])==null){
					err.reason= err.reason+' Parent Account does not exist';
                    }
					counter='1';  
				}
                //system.debug('inputvalues[12]==null '+inputvalues[12] );
                 
				if(counter=='1')
				{
					errorList.add(err);
					k = k+1;
				}
                else if (counter =='0')
                {
                    validRecord.put(j,true); 
					Account AccDataObj = new Account() ;
					
                    String ParentAccount = mapAccId.get(inputvalues[4]);
                    //ParentAccount='0011e000001wLhBAAU';
					AccDataObj.Name=inputvalues[0].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
					AccDataObj.Phone=inputvalues[2];
					AccDataObj.Email__c=inputvalues[1];
					AccDataObj.EBID__c = inputvalues[3];
                    AccDataObj.EBID_Key__c='RTL'+inputvalues[3];
					AccDataObj.ParentId = Id.valueOf(ParentAccount);
					AccDataObj.Billing_Street_1__c =inputvalues[5].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
					AccDataObj.Billing_Street_2__c = inputvalues[6].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
					AccDataObj.Billing_Street_3__c = inputvalues[7].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                    AccDataObj.BillingStreet=inputvalues[5].replaceAll(':quotes:', '').replaceAll(':comma:', ',')+inputvalues[6].replaceAll(':quotes:', '').replaceAll(':comma:', ',')+inputvalues[7].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
					AccDataObj.BillingCity	 =inputvalues[8];
					AccDataObj.BillingPostalCode = inputvalues[9];
                    Id RetailerRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();
					AccDataObj.RecordtypeId =RetailerRecTypeId;
                    AccDataObj.BillingState =inputvalues[10]; 
                    if(inputvalues[13]!=null && inputvalues[13] ==''){
                    AccDataObj.Retailer_Type__c=inputvalues[13];
                    }
                    else{
                         AccDataObj.Retailer_Type__c='Linked';

                    }
                    AccDataObj.BillingCountry = inputvalues[11]; 
                    String a=inputvalues[12].trim();
                    system.debug('a'+a);
                    system.debug('**sor'+sorMap.get(a)+inputvalues[12]+a);
                    AccDataObj.Sales_Org__c = sorMap.get(a);				
					AccountList.add(AccDataObj); 
                }                    
            }
                
			list<string> successstring= new list<string>();
            Integer successCounter=0; 
			String excepstring='';
            if(AccountList.size()>0)
            {
                Schema.SObjectField ftoken = Account.Fields.EBID_Key__c;

				Database.UpsertResult[] SSUplResult = Database.upsert(AccountList,ftoken,false);
				system.debug('value is SSUplResult '+SSUplResult);
				for(Integer i=0;i<SSUplResult.size();i++)
				{List<Database.Error> errors = SSUplResult[i].getErrors();
  for(Database.Error theError:Errors) {
    excepstring+=theError.getMessage();
      // It's a required field missing error, so state that...
  }
                
                    system.debug('error messages'+SSUplResult.get(i).isSuccess());
                    if(!SSUplResult.get(i).isSuccess()){//only look at failures, or NOT Successes
						k = k+1;
                        //errorWrapper err = new errorWrapper();
                        //excepstring+=SSUplResult.get(i).Message()+' ';
                    }
					else if(SSUplResult.get(i).isSuccess())
					{
                        String succ= String.valueOf(SSUplResult.get(i).getId());
                        successCounter=successCounter+1;
                        successstring.add(succ);                      
                    }
             	}
            }
			if (errorList.size()>0)
            {
                
				//List<Messaging.Emailfileattachment> efaList = new List<Messaging.Emailfileattachment>();
				
				//csv generator code for error 
				string header = 'Account Name,Phone,Email,EBID,Parent ship to,Street1,Street2,Street3,City,Zip Code,Country,Salesorg,Retailer Type,Reason \n';
				string finalstr=header; 
				for(errorWrapper a: errorList)
				{
                    system.debug(a.reason);
					string recordString = '"'+a.Name+'","'+a.Phone+'","'+a.Email+'","'+a.EBID+'","'+a.ParentId +'","'+a.Street1+'","'+a.Street2+'","'+a.Street3+'","'+a.City+'","'+a.Zip+'","'+a.country+'","'+a.salesorg+'","'+a.rType+'","'+a.reason +'" \n';
                    finalstr = finalstr +recordString;
                    
				}
                    
				//csv for success
				string successheader= 'RecordId \n';
				string finalSuccessHeader=successheader;
				for (string success: successstring)
				{
					String tempString =success+'\n'; 
                    finalSuccessHeader = finalSuccessHeader +tempString;
                    
					//finalSuccessHeader= finalSuccessHeader+tempString;
				}//ends
				system.debug('jval'+j);
				j=j-k;
                Integer part=csvFileLines.size()-1;
				if(j == 0)
				{
                    ret.returnValue='NoSuccess';
                ret.eList=errorList;
                    ret.err=finalstr;
                    ret.succ=finalSuccessHeader;
                    ret.sub=Label.RU_email_Subject;
                    ret.mailbody=Label.SIC_email_Text;
                    system.debug('NoSuccess');
                return ret;
					
					//return ('NoSuccess');
				}
				
				system.debug('PartialSuccess'+j);
				//return ('PartialSuccess:'+j +'out of '+ part );
                ret.returnValue='PartialSuccess:'+j +'out of '+ part;
                ret.eList=errorList;
                    ret.err=finalstr;
                    ret.succ=finalSuccessHeader;
                    ret.sub=Label.RU_email_Subject;
                    ret.mailbody=Label.SIC_email_Text;
                    system.debug('PartialSuccess');
                return ret;
                
            }
            else if(successCounter==AccountList.size())
			{
                //csv for success
				string successheader= 'RecordId \n';
				string finalSuccessHeader=successheader;
				for (string success: successstring)
				{
					String tempString =success+'\n'; 
                    finalSuccessHeader = finalSuccessHeader +tempString;
                    
					//finalSuccessHeader= finalSuccessHeader+tempString;
				}
				String recordsupdated= String.valueOf(successCounter); 
                ret.returnValue='success:'+recordsupdated;
                //ret.eList=errorList;
                    //ret.err=finalstr;
                    ret.succ=finalSuccessHeader;
                    //ret.sub=Label.RU_email_Subject;
                    //ret.mailbody=Label.SIC_email_Text;
                    System.debug('success:'+recordsupdated);
                return ret;
				
			//	return ('success:'+recordsupdated);
				//return errorList;
            }
            else{
                ret.returnValue='error';
                //ret.eList=errorList;
                    //ret.err=finalstr;
                    //ret.succ=finalSuccessHeader;
                    ret.sub='Exception in data upload';
                    ret.mailbody='Exception occurred in loading the file . The following errors occured ' + excepstring+' Please contact system adminsitrator for further information.';
                        
                    System.debug('err:');
                return ret;
            }
        
        }
        catch(Exception e)
        {
            ret.returnValue='error';
                //ret.eList=errorList;
                    //ret.err=finalstr;
                    //ret.succ=finalSuccessHeader;
                    ret.sub='Exception in data upload';
                    ret.mailbody='Exception occurred in loading the file error is ' + 'ex No: '+e.getLineNumber()+'The following exception has occurred: ' + e.getMessage();
                    System.debug('err:');
                return ret;
          /*  List<errorwrapper> errorList=new List<errorwrapper>();
            System.debug('ex No: '+e.getLineNumber()+'The following exception has occurred: ' + e.getMessage());
            List<Messaging.Emailfileattachment> efaList = new List<Messaging.Emailfileattachment>();
            String loggedInUser= UserInfo.getUserEmail();
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
			String[] toAddresses = new list<string> {loggedInUser};
			String subject =Label.SSF_email_Subject;
			email.setSubject('Exception in data upload');
			email.setToAddresses( toAddresses );
			email.setPlainTextBody('Exception occurred in loading the file error is ' + 'ex No: '+e.getLineNumber()+'The following exception has occurred: ' + e.getMessage());
				email.setFileAttachments(efaList);
				Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
*/
            //return errorList;
        }
    }
}