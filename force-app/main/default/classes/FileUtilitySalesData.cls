public class FileUtilitySalesData {
    
    public static list<String> processAttachment(String fileName, String fromAddress, String emailSubject, Blob body){
        
        SplitString splitObj = new SplitString(); 
        List<String> csvData = new List<String>();
        csvData = splitObj.safeSplit(body.toString(), '\n');
      
        //system.debug('size is '+ csvData.size());
        
        //Calculate number of rows & number of splits to be performed on the csv
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
        //system.debug('divide csv is '+ divideCsv);
        
        List<String> csvAttachment = new List<String>();
        list<String> csv  = new list<String>();
                
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
        return csv;
    }
    
    public static list<SalesDataReadandPopulateBatch.errorWrapper> processSalesData(String csv)
    {
        list<SalesDataReadandPopulateBatch.errorWrapper> lstwr = new list<SalesDataReadandPopulateBatch.errorWrapper>();
        String []filelines;
        list<Sales_Data__c> lstData = new list<Sales_Data__c>();
        List<String> lstCustomerCode = new List<String>();
        List<String> lstSKU = new List<String>();
        filelines=csv.split('\n');  
        List<string> inputvalues = new list<string>();
        list<string> errorCSVList = new List<String>();
        
        SalesOrgCode__c sorg = SalesOrgCode__c.getValues('France'); 
        String SalesOrgCode=sorg.Code__c; 
        Integer paddingsapcode= integer.valueof(sorg.PaddingSAPCode__c);
        Integer paddingsku= integer.valueof(sorg.PaddingSKU__c);
        Set<String> CustomerCode = new Set<String>();  
        Set<String> SKU = new Set<String>(); 
        //system.debug('value is '+ filelines.size());
        //system.debug('value issssss '+ filelines);
        for (Integer i=0;i<(filelines.size()-1);i++)
        {
            inputvalues = filelines[i].split(',');
            //system.debug('value is columns '+ inputvalues.size());
            //system.debug('input is '+ inputvalues);
            inputvalues[0]= inputvalues[0].leftPad(paddingsapcode,'0');
            inputvalues[1]= inputvalues[1].leftPad(paddingsku,'0');
            //system.debug('leftpad is '+inputvalues[2] +''+inputvalues[1]);
            CustomerCode.add(inputvalues[0]);
            SKU.add(inputvalues[1]); 
        }
        lstCustomerCode.addAll(CustomerCode);
        lstSKU.addAll(SKU);
        
        //System.debug('lstCustomerCode is '+ lstCustomerCode);
        Map<Id, Account> mapAcc = new Map<Id, Account>([SELECT id, SAP_Code__c,OwnerId FROM Account WHERE SAP_Code__c IN : lstCustomerCode AND Sales_Org_Code__c=:SalesOrgCode__c.getValues('France').Code__c ]);
        //system.debug('mapAcc->'+mapAcc);
        Map<String, Id> mapSAPCodeAccId = new Map<String, Id>();
        Map<String, Id> mapAccOwnId = new Map<String, Id>();
        for(Id itemId: mapAcc.keySet()){
            mapSAPCodeAccId.put(mapAcc.get(itemId).SAP_Code__c, itemId);
            mapAccOwnId.put(mapAcc.get(itemId).SAP_Code__c, mapAcc.get(itemId).OwnerId);
        }
        Map<Id, SKU__c> mapSKU = new Map<Id, SKU__c>([SELECT id, SKU_Code__c FROM SKU__c WHERE SKU_Code__c IN : lstSKU AND Sales_Org_Code__c=:SalesOrgCode__c.getValues('France').Code__c ]);
        Map<String, Id> mapSKUId = new Map<String, Id>();
        for(Id itemId: mapSKU.keySet()){
            mapSKUId.put(mapSKU.get(itemId).SKU_Code__c, itemId);
            
        }
        
        for (Integer i=0;i<(filelines.size()-1);i++)
        {
            String counter='0';
            SalesDataReadandPopulateBatch.errorWrapper wrr = new SalesDataReadandPopulateBatch.errorWrapper();
            wrr.reason='';
            inputvalues = filelines[i].split(',');
            inputvalues[0]= inputvalues[0].leftPad(paddingsapcode,'0');
            inputvalues[1]= inputvalues[1].leftPad(paddingsku,'0');
            //system.debug('input values 0->'+inputvalues[0]);
            if (mapSAPCodeAccId.get(inputvalues[0])== null ||inputvalues[0]==null || inputvalues[0]=='')
            {
              wrr.reason='Invalid Customer Code';
              wrr.customerID=inputvalues[0];
              wrr.SKUID=inputvalues[1]; 
                counter='1';
            }
            if (mapSKUId.get(inputvalues[1])== null ||inputvalues[1]==null || inputvalues[1]=='')
            {
              wrr.reason=wrr.reason +' Invalid SKU Code';
              wrr.customerID=inputvalues[0];
              wrr.SKUID=inputvalues[1];    
            counter='1';
            }
            if (counter=='1')
            {
             lstwr.add(wrr);   
            }else
            {
            
                Sales_Data__c data = new Sales_Data__c();
                data.SKU__c= mapSKUId.get(inputvalues[1]);
                data.Combination_Key__c=SalesOrgCode+inputvalues[0]+inputvalues[1]; 
                data.Customer__c = mapSAPCodeAccId.get(inputvalues[0]);
                data.Quantity_Sold_Current_Campaign__c=Decimal.valueOf(inputvalues[5]);
                data.Quantity_Sold_Last_Fiscal_Year__c=Decimal.valueOf(inputvalues[6]);
                data.Quantity_Sold_Last_Campaign__c=Decimal.valueOf(inputvalues[4]);
                String testVolume= inputvalues[7].trim();
                //system.debug('value of 7 is '+testVolume);
                data.Quantity_Sold_Current_Fiscal_Year__c=Decimal.valueOf(testVolume);
                data.OwnerId=Id.valueOf(mapAccOwnId.get(inputvalues[0]));
                String s  =inputvalues[3];
                String s1 = s.mid(0, 4);
                String s2 = s.mid(4, 2);
                String s3 = s.mid(6, 2);
                String Formatteddate= s1+'-'+s2+'-'+s3;
                data.Last_Calculated_Date__c=Date.valueOf(Formatteddate);
                lstData.add(data);
            }
            }
        //upsert lstData Combination_Key__c;
        Database.UpsertResult[] sDataUpload=  Database.upsert(lstData,Sales_Data__c.Combination_Key__c,false);
         for(Integer i=0;i<sDataUpload.size();i++){
                    if (!sDataUpload[i].isSuccess()){
                        Database.Error[] errs = sDataUpload[i].getErrors();
                        errorCSVList.add(String.valueOf(lstData[i].get('Customer__c'))+','+ String.valueOf(lstData[i].get('SKU__c')) +','+ String.valueOf(lstData[i].get('Combination_Key__c')) +','+errs[0].getMessage());
                    }   
         }
        //system.debug('debug main is '+errorCSVList );
        //system.debug('successfull uploaded');
        return lstwr;
    }
    
    
    public static list<SalesDataReadandPopulateBatch.errorWrapper> processSalesDataShipTo(String csv)
    {
        list<SalesDataReadandPopulateBatch.errorWrapper> lstwr = new list<SalesDataReadandPopulateBatch.errorWrapper>();
        String []filelines;
        list<Sales_Data__c> lstData = new list<Sales_Data__c>();
        List<String> lstCustomerCode = new List<String>();
        List<String> lstSKU = new List<String>();
        filelines=csv.split('\n');  
        List<string> inputvalues = new list<string>();
        list<string> errorCSVList = new List<String>();
        
        SalesOrgCode__c sorg = SalesOrgCode__c.getValues('France'); 
        String SalesOrgCode=sorg.Code__c; 
        Integer paddingsapcode= integer.valueof(sorg.PaddingSAPCode__c);
        Integer paddingsku= integer.valueof(sorg.PaddingSKU__c);
        Set<String> CustomerCode = new Set<String>();  
        Set<String> SKU = new Set<String>(); 
        //system.debug('value is '+ filelines.size());
        //system.debug('value issssss '+ filelines);
        for (Integer i=0;i<(filelines.size()-1);i++)
        {
            inputvalues = filelines[i].split(',');
            system.debug('value is columns '+ inputvalues.size());
            system.debug('input is '+ inputvalues);
            inputvalues[0]= inputvalues[0].leftPad(paddingsapcode,'0');
            inputvalues[1]= inputvalues[1].leftPad(paddingsapcode,'0');
            inputvalues[2]= inputvalues[2].leftPad(paddingsku,'0');
            //system.debug('leftpad is '+inputvalues[2] +''+inputvalues[1]);
            CustomerCode.add(inputvalues[0]+inputvalues[1]);
            SKU.add(inputvalues[2]); 
        }
        lstCustomerCode.addAll(CustomerCode);
        lstSKU.addAll(SKU);
        
        //System.debug('lstCustomerCode is '+ lstCustomerCode);
        Map<Id, Account> mapAcc = new Map<Id, Account>([SELECT id, SAP_Code__c,OwnerId,combination_key__c FROM Account WHERE combination_key__c IN : lstCustomerCode AND Sales_Org_Code__c=:SalesOrgCode__c.getValues('France').Code__c ]);
        Map<String, Id> mapSAPCodeAccId = new Map<String, Id>();
        Map<String, Id> mapAccOwnId = new Map<String, Id>();
        for(Id itemId: mapAcc.keySet()){
            mapSAPCodeAccId.put(mapAcc.get(itemId).combination_key__c, itemId);
            mapAccOwnId.put(mapAcc.get(itemId).combination_key__c, mapAcc.get(itemId).OwnerId);
        }
        Map<Id, SKU__c> mapSKU = new Map<Id, SKU__c>([SELECT id, SKU_Code__c FROM SKU__c WHERE SKU_Code__c IN : lstSKU AND Sales_Org_Code__c=:SalesOrgCode__c.getValues('France').Code__c ]);
        Map<String, Id> mapSKUId = new Map<String, Id>();
        for(Id itemId: mapSKU.keySet()){
            mapSKUId.put(mapSKU.get(itemId).SKU_Code__c, itemId);
            
        }
        
        for (Integer i=0;i<(filelines.size()-1);i++)
        {
            String counter='0';
            SalesDataReadandPopulateBatch.errorWrapper wrr = new SalesDataReadandPopulateBatch.errorWrapper();
            wrr.reason='';
            inputvalues = filelines[i].split(',');
            inputvalues[0]= inputvalues[0].leftPad(paddingsapcode,'0');
            inputvalues[1]= inputvalues[1].leftPad(paddingsapcode,'0');
            inputvalues[2]= inputvalues[2].leftPad(paddingsku,'0');
            if (mapSAPCodeAccId.get(inputvalues[0]+inputvalues[1])== null ||(inputvalues[0]+inputvalues[1])==null || (inputvalues[0]+inputvalues[1])=='')
            {
              wrr.reason='Invalid Customer Code';
              wrr.customerID=inputvalues[0]+inputvalues[1];
              wrr.SKUID=inputvalues[2]; 
                counter='1';
            }
            if (mapSKUId.get(inputvalues[2])== null ||inputvalues[2]==null || inputvalues[2]=='')
            {
              wrr.reason=wrr.reason +' Invalid SKU Code';
              wrr.customerID=inputvalues[0]+inputvalues[1];
              wrr.SKUID=inputvalues[2];    
            counter='1';
            }
            if (counter=='1')
            {
             lstwr.add(wrr);   
            }else
            {
            
                Sales_Data__c data = new Sales_Data__c();
                data.SKU__c= mapSKUId.get(inputvalues[2]);
                data.Combination_Key__c=SalesOrgCode+inputvalues[0]+inputvalues[1]+inputvalues[2]; 
                data.Customer__c = mapSAPCodeAccId.get(inputvalues[0]+inputvalues[1]);
                data.Quantity_Sold_Current_Campaign__c=Decimal.valueOf(inputvalues[6]);
                data.Quantity_Sold_Last_Fiscal_Year__c=Decimal.valueOf(inputvalues[7]);
                data.Quantity_Sold_Last_Campaign__c=Decimal.valueOf(inputvalues[5]);
                String testVolume= inputvalues[8].trim();
                system.debug('value of 7 is '+testVolume);
                data.Quantity_Sold_Current_Fiscal_Year__c=Decimal.valueOf(testVolume);
                data.OwnerId=Id.valueOf(mapAccOwnId.get(inputvalues[0]+inputvalues[1]));
                String s  =inputvalues[4];
                String s1 = s.mid(0, 4);
                String s2 = s.mid(4, 2);
                String s3 = s.mid(6, 2);
                String Formatteddate= s1+'-'+s2+'-'+s3;
                data.Last_Calculated_Date__c=Date.valueOf(Formatteddate);
                lstData.add(data);
            }
            }
        //upsert lstData Combination_Key__c;
        Database.UpsertResult[] sDataUpload=  Database.upsert(lstData,Sales_Data__c.Combination_Key__c,false);
         for(Integer i=0;i<sDataUpload.size();i++){
                    if (!sDataUpload[i].isSuccess()){
                        Database.Error[] errs = sDataUpload[i].getErrors();
                        errorCSVList.add(String.valueOf(lstData[i].get('Customer__c'))+','+ String.valueOf(lstData[i].get('SKU__c')) +','+ String.valueOf(lstData[i].get('Combination_Key__c')) +','+errs[0].getMessage());
                    }   
         }
        system.debug('debug main is '+errorCSVList);
        system.debug('successfull uploaded');
        return lstwr;
    }
    
        
}