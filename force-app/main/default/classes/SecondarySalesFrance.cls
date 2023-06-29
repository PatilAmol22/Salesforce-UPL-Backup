//03 Feb 2019: Daraksha S: Created class to build secondary sales upload logic, Invoked by SecondarySalesFrance lightning component

public without sharing class SecondarySalesFrance 
{
    @AuraEnabled
    public static String getDocument()
	{
        List<document> DocumentList = new List<document>(); 
        String Templatefile = '/servlet/servlet.FileDownload?file=';
        String newTemplatefile;
        DocumentList = [select Name from document where Name = 'Secondary_Sales_Template_France'];
        if(DocumentList.size()>0){
            newTemplatefile = Templatefile+DocumentList[0].Id;
            system.debug('checktemplate '+newTemplatefile);
        }
        return newTemplatefile;
    }
    
	public class errorWrapper 
	{
        @AuraEnabled
        public Integer recordno {get;set;}
       //added on 30 april 
        @AuraEnabled
        public string SAPSoldTo{get;set;}
        @AuraEnabled
        public string SAPShipTo{get;set;}
        @AuraEnabled
        //added on 30 april 
        public string productcode {get;set;}
        @AuraEnabled
        public String custprodcode {get;set;}
        @AuraEnabled
        public String monval {get;set;}
		@AuraEnabled
        public String yrval {get;set;}
        @AuraEnabled
        public String quantity {get;set;}    
		@AuraEnabled
        public String reason {get;set;}
    }
	
    @AuraEnabled
    public static String passFileAura(String file)
    {
         try
        {
        String returnValue;
        String[] csvFileLines;
        csvFileLines = file.split('\n');
        if (csvFileLines.size()>2000)
        {
            SecondarySalesFranceBatch batch = new SecondarySalesFranceBatch(file); 
			database.executeBatch(batch,2000);
            returnValue='InBatch';
            return returnValue;
        }
        else
        {
            String result=passFile(file);
            returnValue=result;
            return returnValue;
        }
     }
        Catch(exception e)
        {
            System.debug('ex No: '+e.getLineNumber()+'The following exception has occurred: ' + e.getMessage());
            return 'error';
        } 
            
    }
    
    
	
    @AuraEnabled
    public static String passFile(String file)
    {
        try
        {
			list<errorWrapper> errorList= new list<errorWrapper>();
			Map<Integer,boolean> validRecord= new map<Integer,boolean>();    
			String[] csvFileLines;
			Integer k=1;
			Integer j=0;
			List<Secondary_Sales_Data__c> SSDatalist = new List<Secondary_Sales_Data__c>();
			//List<String> lstShipCode = new List<String>();
			List<String> lstCustCode = new List<String>();
			List<String> lstSKU = new List<String>();
			List<string> inputvalues = new list<string>();
			csvFileLines = file.split('\n');
			system.debug('csvFileLines-------'+csvFileLines);
           
			for (j=1;j<csvFileLines.size();j++)
			{                    
				inputvalues = csvFileLines[j].split(',');
                inputvalues[0]=inputvalues[0].trim();//added by diwansh on 16 april 2020
                inputvalues[1]=inputvalues[1].trim();//added by diwansh on 16 april 2020
				inputvalues[2]=inputvalues[2].trim();
                if(inputvalues[0].length() < 10)
			    inputvalues[0]=inputvalues[0].leftPad(10,'0');
                //added on 30 april 2020
                if(inputvalues[1].length() < 10)
					inputvalues[1]=inputvalues[1].leftPad(10,'0');
                
				if(inputvalues[2].length() < 18)
			    inputvalues[2]=inputvalues[2].leftPad(18,'0');
				system.debug('leftpad is '+inputvalues[0] +' '+inputvalues[1]+' '+inputvalues[2]+ '' +inputvalues[3]);
				//lstShipCode.add(inputvalues[0]);
                lstCustCode.add(inputvalues[0]+inputvalues[1]);
				lstSKU.add(inputvalues[2]);
            }
                
			//System.debug('lstShipCode is '+ lstShipCode);
			//System.debug('lstSKU is '+ lstSKU);
		    //System.debug('customer code is '+ lstCustCode);
            /*
			Map<Id, Shipping_Location__c> mapShipLoc = new Map<Id, 	Shipping_Location__c>([SELECT id, SAP_Code__c, Sold_To_Party_SAP_Code__c FROM Shipping_Location__c WHERE SAP_Code__c IN : lstShipCode]);
			Map<String, Id> mapShipId = new Map<String, Id>();
            Map<String, String> mapShipAcc = new Map<String, String>();
            System.debug('mapShipLoc ' + mapShipLoc);
			for(Id itemId: mapShipLoc.keySet())
            {
                lstCustCode.add(mapShipLoc.get(itemId).Sold_To_Party_SAP_Code__c);
                mapShipId.put(mapShipLoc.get(itemId).SAP_Code__c, itemId);
                mapShipAcc.put(mapShipLoc.get(itemId).SAP_Code__c, mapShipLoc.get(itemId).Sold_To_Party_SAP_Code__c);
            }
		 */		
			Map<Id, Account> mapAcc = new Map<Id, Account>([SELECT id, Sold_To_Party__c , SAP_Code__c,ship_to_party_sap_code__c,combination_key__c, OwnerId FROM Account WHERE combination_key__c IN : lstCustCode]);
			Map<String, Id> mapAccId = new Map<String, Id>();
            Map<String, Id> mapSoldToAccId = new Map<String, Id>();
            Map<String, Id> mapAccOwnId = new Map<String, Id>();
			System.debug('mapAcc ' + mapAcc);
			for(Id itemId: mapAcc.keySet())
            {
				mapAccId.put(mapAcc.get(itemId).combination_key__c, itemId);
                mapSoldToAccId.put(mapAcc.get(itemId).combination_key__c, mapAcc.get(itemId).Sold_To_Party__c);
                mapAccOwnId.put(mapAcc.get(itemId).combination_key__c, mapAcc.get(itemId).OwnerId);
            }
        	//System.debug('mapAccId ' + mapAccId);
            //System.debug('mapSoldToAccId ' + mapSoldToAccId);
            //System.debug('mapAccOwnId ' + mapAccOwnId);
            //map for sku 
			Map<Id, SKU__c> mapSKU = new Map<Id, SKU__c>([SELECT id, SKU_Code__c FROM SKU__c WHERE SKU_Code__c IN : lstSKU]);
			Map<String, Id> mapSKUId = new Map<String, Id>();
			for(Id itemId: mapSKU.keySet())
				mapSKUId.put(mapSKU.get(itemId).SKU_Code__c, itemId);
		
			//System.debug('mapSKU:' +mapSKU);
			//System.debug('mapSKUId ' + mapSKUId);		
            
            SalesOrgCode__c sorg = SalesOrgCode__c.getValues('France'); 
			String SalesOrgCode=sorg.Code__c; 
            System.debug('Code'+SalesOrgCode);
			List<Sales_Org__c> sorglst = [Select id, name,Sales_Org_Code__c from Sales_Org__c where Sales_Org_Code__c =: SalesOrgCode limit 1];
			for (j=1;j<csvFileLines.size();j++)
            {                    
				String counter='0';
				inputvalues = csvFileLines[j].split(',');
				if(inputvalues[0].length() < 10)
					inputvalues[0]=inputvalues[0].leftPad(10,'0');
                if(inputvalues[1].length() < 10)
					inputvalues[1]=inputvalues[1].leftPad(10,'0');
				if(inputvalues[2].length() < 18)
					inputvalues[2]=inputvalues[2].leftPad(18,'0');
								
				// new validations 
				errorWrapper err = new errorWrapper();
				err.reason='';
                                
				if (mapAccId.get(inputvalues[0]+inputvalues[1]) == null ||(inputvalues[0]+inputvalues[1]) ==null || (inputvalues[0]+inputvalues[1])=='')
				{
					validRecord.put(j,false);
					//system.debug('map value is Ship Code'+ validRecord.get(j));
					err.SAPSoldTo=inputvalues[0];
                    err.SAPShipTo=inputvalues[1];
                    //err.customercode= inputvalues[0];
					err.productcode = inputvalues[2];
					err.custprodcode= inputvalues[3];
					err.monval= inputvalues[4];
					err.yrval= inputvalues[5];
					err.quantity=inputvalues[6].trim();
					err.reason= err.reason+' Invalid combination of Sold to and Ship to code';
					counter='1';  
				}
				if (mapSKUId.get(inputvalues[2]) == null || inputvalues[2] == null || inputvalues[2]=='')
				{
					validRecord.put(j,false);
					system.debug('map value is sku'+ validRecord.get(j));
					err.SAPSoldTo=inputvalues[0];
                    err.SAPShipTo=inputvalues[1];
                    //err.customercode= inputvalues[0];
					err.productcode = inputvalues[2];
					err.custprodcode= inputvalues[3];
					err.monval= inputvalues[4];
					err.yrval= inputvalues[5];
					err.quantity=inputvalues[6].trim();
					err.reason= err.reason+' Invalid Product Code';
					counter='1';  
				}
				if (inputvalues[3]==null || inputvalues[3]=='')
				{
					validRecord.put(j,false);
					//system.debug('map value is customer product code'+ validRecord.get(j));
					err.SAPSoldTo=inputvalues[0];
                    err.SAPShipTo=inputvalues[1];
                    //err.customercode= inputvalues[0];
					err.productcode = inputvalues[2];
					err.custprodcode= inputvalues[3];
					err.monval= inputvalues[4];
					err.yrval= inputvalues[5];
					err.quantity=inputvalues[6].trim();
					err.reason= err.reason+' Invalid Customer Product Code';
					counter='1';  
				}
				
				if(!inputvalues[4].isNumeric() || inputvalues[4] == null || inputvalues[4] =='' || Integer.valueOf(inputvalues[4]) > 12 || Integer.valueOf(inputvalues[4]) == 0)
				{
					validRecord.put(j,false);
					//system.debug('map value is monval'+ validRecord.get(j));
					err.SAPSoldTo=inputvalues[0];
                    err.SAPShipTo=inputvalues[1];
                    //err.customercode= inputvalues[0];
					err.productcode = inputvalues[2];
					err.custprodcode= inputvalues[3];
					err.monval= inputvalues[4];
					err.yrval= inputvalues[5];
					err.quantity=inputvalues[6].trim();
					err.reason= err.reason+' Invalid Month';
					counter='1';  
				}
				
				if(!inputvalues[5].isNumeric() || inputvalues[5] == null || inputvalues[5] =='')
				{
					validRecord.put(j,false);
					//system.debug('map value is yrval'+ validRecord.get(j));
					err.SAPSoldTo=inputvalues[0];
                    err.SAPShipTo=inputvalues[1];
                    //err.customercode= inputvalues[0];
					err.productcode = inputvalues[2];
					err.custprodcode= inputvalues[3];
					err.monval= inputvalues[4];
					err.yrval= inputvalues[5];
					err.quantity=inputvalues[6].trim();
					err.reason= err.reason+' Invalid Year';
					counter='1';  
				}
				
				inputvalues[6]=inputvalues[6].trim();
				if(inputvalues[6] == null || inputvalues[6] =='')
				{
					validRecord.put(j,false);
					//system.debug('map value is quantity'+ validRecord.get(j));
                    err.SAPSoldTo=inputvalues[0];
                    err.SAPShipTo=inputvalues[1];
                    //err.customercode= inputvalues[0];
					err.productcode = inputvalues[2];
					err.custprodcode= inputvalues[3];
					err.monval= inputvalues[4];
					err.yrval= inputvalues[5];
					err.quantity=inputvalues[6].trim();
					err.reason= err.reason+' Invalid Quantity';
					counter='1';  
				}
                    
				if(counter=='1')
				{
					errorList.add(err);
					k = k+1;
				}
                else if (counter =='0')
                {
                    validRecord.put(j,true); 
					Secondary_Sales_Data__c SSDataObj = new Secondary_Sales_Data__c() ;
					
                    String custcode,custownerid,soldtoparty;
					//String custcode = mapAccId.get(inputvalues[0]) ;
					String cust = mapAccId.get(inputvalues[0]+inputvalues[1]);
                    //system.debug('cust is '+ cust);
                   //commented by diwansh  String cust = mapShipAcc.get(inputvalues[0]) ;
                    if(!String.isempty(cust))
                    {
                    	custcode = mapAccId.get(inputvalues[0]+inputvalues[1]) ;
                    	custownerid = mapAccOwnId.get(inputvalues[0]+inputvalues[1]) ;
                        soldtoparty= mapSoldToAccId.get(inputvalues[0]+inputvalues[1]);
                    }
                   // String ShipId = mapShipId.get(inputvalues[0]) ;
					String SKUVal = mapSKUId.get(inputvalues[2]) ;
                    
					if(!String.isempty(custcode))
						SSDataObj.Customer_Name__c = Id.valueOf(custcode);
                    //if(!String.isempty(ShipId))
						//SSDataObj.Shipping_Location__c = Id.valueOf(ShipId);
                    if(!String.isempty(custownerid))
						SSDataObj.OwnerId = Id.valueOf(custownerid);
					if(!String.isempty(SKUVal))
						SSDataObj.Product_Name__c = Id.valueOf(SKUVal); 
					SSDataObj.Customer_Product_Code__c = inputvalues[3];
					SSDataObj.Product_Quantity__c = Integer.valueOf(inputvalues[6]);
                    if (soldtoparty!=null)
                    SSDataObj.Sold_To_Party__c = Id.valueOf(soldtoparty);
					//System.debug('Date'+inputvalues[3] + inputvalues[4]);
					String dateval='';
                    
                    if(inputvalues[5].length() == 2)
						dateval = '01/'+inputvalues[4]+'/'+'20'+inputvalues[5];
					else
						dateval = '01/'+inputvalues[4]+'/'+inputvalues[5];
						
                    //System.debug('Date'+dateval);
					SSDataObj.Month__c = inputvalues[4];
					SSDataObj.Year__c = inputvalues[5]; 
                    String dat;
                    dat= dateval.replace('/','');
                    
                    //List<Sales_Org__c> sorglst = [Select id, name,Sales_Org_Code__c from Sales_Org__c where Sales_Org_Code__c =: SalesOrgCode limit 1];
                    if(!sorglst.isEmpty())
                    SSDataObj.Sales_Org__c = sorglst[0].id;
					SSDataObj.Combination_Key__c = inputvalues[0] + '' + inputvalues[1] + ''+ inputvalues[2] + ''+dat; 				
					SSDatalist.add(SSDataObj); 
                }                    
            }
                
			for(errorWrapper er: errorList)
			{
				//System.debug('value of errors is '+er);
			}

            list<string> successstring= new list<string>();
            Integer successCounter=0; 
			
            if(SSDatalist.size()>0)
            {
				Database.UpsertResult[] SSUplResult = Database.upsert(SSDatalist,Secondary_Sales_Data__c.Combination_Key__c,false);
				system.debug('value is SSUplResult '+SSUplResult);
				for(Integer i=0;i<SSUplResult.size();i++)
				{
                    system.debug('error messages'+SSUplResult.get(i).isSuccess());
					if(!SSUplResult.get(i).isSuccess())//only look at failures, or NOT Successes
						k = k+1;
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
				List<Messaging.Emailfileattachment> efaList = new List<Messaging.Emailfileattachment>();
				
				//csv generator code for error 
				string header = 'SAP sold-to,SAP Ship-to,Product Code,Customer Product Code,Month(In Number),Year,Quantity,Reason \n';
				string finalstr = header ;
				for(errorWrapper a: errorList)
				{
					string recordString = '"'+a.SAPSoldTo+'","'+a.SAPShipTo+'","'+a.productcode+'","'+a.custprodcode+'","'+a.monval +'","'+a.yrval+'","'+a.quantity+'","'+a.reason +'" \n';
					finalstr = finalstr +recordString;
				}
                    
				//csv for success
				string successheader= 'RecordId \n';
				string finalSuccessHeader= successheader;
				for (string success: successstring)
				{
					String tempString =success+'\n'; 
					finalSuccessHeader= finalSuccessHeader+tempString;
				}//ends
				
				Messaging.EmailFileAttachment csvsuccessAttc = new Messaging.EmailFileAttachment();
				blob csvsuccessBlob = Blob.valueOf(finalSuccessHeader);
				string csvsuccessname= 'Success.csv';
				csvsuccessAttc.setFileName(csvsuccessname);
				csvsuccessAttc.setBody(csvsuccessBlob);
				efaList.add(csvsuccessAttc);
				
				String loggedInUser= UserInfo.getUserEmail();
				system.debug('email value is '+ loggedInUser);
				
				Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
				blob csvBlob = Blob.valueOf(finalstr);
				string csvname= 'error.csv';
				csvAttc.setFileName(csvname);
				csvAttc.setBody(csvBlob);
				efaList.add(csvAttc);
				Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
				String[] toAddresses = new list<string> {loggedInUser};
					String subject =Label.SSF_email_Subject;
				email.setSubject(subject);
				email.setToAddresses( toAddresses );
				email.setPlainTextBody(Label.SIC_email_Text);
				email.setFileAttachments(efaList);
				Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
				j=j-k;
				if(j == 0)
				{
					system.debug('NoSuccess');
					return ('NoSuccess');
				}
				
				system.debug('PartialSuccess'+j);
				return ('PartialSuccess:'+j);
            }
           	else
			{
				String recordsupdated= String.valueOf(successCounter);  
				System.debug('success:'+recordsupdated);
				return ('success:'+recordsupdated);
            }
        }
        catch(Exception e)
        {
            System.debug('ex No: '+e.getLineNumber()+'The following exception has occurred: ' + e.getMessage());
            //added by diwansh 
            
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

            return 'error';
        }
    }
}