global without sharing class RebateServiceHelper {
    @Auraenabled
    public static WrapperContractID getContract(GetContractRequestWrapper req)
    {
         
      try{  
          Set<String> CustomerCode = new Set<String>();//addede
          List<String> lstCustomerCode = new List<String>();
          String InvalidSAPCode = '' ; 
          boolean successcounter= true;//addede
        list<String> contractId = new list<String>();//return List
        GetContractResponseWrapper res;// response wrapper
        WrapperContractID wrap =new WrapperContractID(); 
        String username = UPL_Settings__c.getOrgDefaults().HCI_User_Name__c;
        String password = UPL_Settings__c.getOrgDefaults().HCI_Password__c; 
        String url = UPL_Settings__c.getOrgDefaults().Rebate_Contract_URL__c;
        String sales_Org = UPL_Settings__c.getOrgDefaults().BR_Sales_Org__c;
        Integer timeOut = 120000;
        Http http = new Http();
        HttpRequest request = new HttpRequest();    
        request.setTimeout(timeOut);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        String json = System.JSON.serializePretty(req);
        system.debug('json is '+json);
        request.setBody(json);
        request.setEndpoint(url);        
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' +
        EncodingUtil.base64Encode(headerValue);
        //String authorizationHeader='Basic UzAwMDMyNjMzMTM6QWpAMTIzNDU=';
        request.setHeader('Authorization', authorizationHeader);
        HttpResponse response;
            if(!Test.isRunningTest()){
                response = http.send(request);
            }
            else{
                // Create a fake response
                response = new HttpResponse();
                response.setHeader('Content-Type', 'application/json');
                response.setBody('{"status":"S","contractHeaders":[{"companyCode":"5190","contractNumber":"10","ERDAT":"2019-10-17","customerCode":"0001034136","customerNameAndCity":"SINAGRO PROD AGROP SA-PRIMAVERA DO LESTE","contractTypeCode":"C","contractTypeName":"Cooper UP","regionCode":"BR160","regionName":"BR71503160","salesDirectorCode":"BR7","salesDirectorName":"CULTURAS EXTENSIVAS","salesOfficeCode":"BR15","BEZEI":"BU CERRADO LESTE","salesDistrictCode":"BR1503","salesDistrictName":"GOIANIA","contractStatusCode":"A","contractStatusName":"Ativo","workflowStatusCode":"02","workflowStatusDescription":"Aguardando Metas","contractInitialDate":"2019-04-01","contractFinalDate":"2020-03-31","salesPersonCode":"53000107","salesPersonName":"WAGNER SALAMONI GOMES","curr":"BRL","contractCategoryCode":"","contractCategoryName":"","lastInvoiceDate":"2020-10-17","PMETA":"0.00","DIATR":"0000","DEVPR":"0.00","customerName":"SINAGRO PROD AGROP SA","city":"PRIMAVERA DO LESTE","state":"MT","documentCNP":"04294897000164","STCD2CPF":"","CLVTX":"","growthIndex":"15.00","EXPMM":""}]}');
                response.setStatusCode(200); 
            } 
            system.debug('reached here before converting to response wrapper');
            system.debug('status from webservice '+response.getStatus());
            system.debug('response from webservice is '+response.getBody());
      res= (GetContractResponseWrapper) System.JSON.deserialize(response.getBody(), GetContractResponseWrapper.class);
            //System.debug('res is '+ res.contractHeaders[1].companyCode);
            //System.debug('res in currency is '+ res.contractHeaders[0].curr);
            System.debug('conversion after failure '+ res);
           System.debug('res is '+ res.status);
          if(res.status=='S')
            {
            For(GetContractResponseWrapper.ContractHeaders c: res.contractHeaders)
            {
                CustomerCode.add(c.customerCode);//addede
                system.debug('companyCode'+c.companyCode);
                system.debug('contractNumber'+c.contractNumber);
                system.debug('ERDAT'+c.ERDAT);
                system.debug('customerCode'+c.customerCode);
                system.debug('contractTypeCode'+c.contractTypeCode);
                system.debug('contractTypeName'+c.contractTypeName);
                system.debug('regionCode'+c.regionCode);
                system.debug('regionName'+c.regionName);
                system.debug('salesDirectorCode'+c.salesDirectorCode);
                system.debug('salesDirectorName'+c.salesDirectorName);
                system.debug('salesOfficeCode'+c.salesOfficeCode);
                system.debug('BEZEI'+c.BEZEI);
                system.debug('salesDistrictCode'+c.salesDistrictCode);
                system.debug('salesDistrictName'+c.salesDistrictName);
                system.debug('contractStatusCode'+c.contractStatusCode);
                system.debug('contractStatusName'+c.contractStatusName);
                system.debug('workflowStatusCode'+c.workflowStatusCode);
                system.debug('workflowStatusDescription'+c.workflowStatusDescription);
                system.debug('contractInitialDate'+c.contractInitialDate);
                system.debug('contractFinalDate'+c.contractFinalDate);
                system.debug('salesPersonCode'+c.salesPersonCode);
                system.debug('salesPersonName'+c.salesPersonName);
                system.debug('curr'+c.curr);
                system.debug('contractCategoryCode'+c.contractCategoryCode);
                system.debug('contractCategoryName'+c.contractCategoryName);
                system.debug('lastInvoiceDate'+c.lastInvoiceDate);
                system.debug('customerNameAndCity'+c.customerNameAndCity);
                system.debug('growthIndex'+c.growthIndex);
                
            }
                lstCustomerCode.addAll(CustomerCode) ;//addede
            }
          //addede    
              Map<Id, Account> mapAcc = new Map<Id, Account>([SELECT id, SAP_Code__c FROM Account WHERE SAP_Code__c IN : lstCustomerCode]);
                Map<String, Id> mapSAPCodeAccId = new Map<String, Id>();
                for(Id itemId: mapAcc.keySet()){  
                 mapSAPCodeAccId.put(mapAcc.get(itemId).SAP_Code__c, itemId);
                }
//addede
/*
            //fake response---------------------------------------------------------------------------------------------//
            String tempResponse;
            tempResponse= '{ "status": "error", "contractHeaders": [ { "companyCode": "hello", "contractNumber": "1", "ERDAT": "string", "customerCode": "0001033509", "customerName": "string", "contractTypeCode": "string", "contractTypeName": "string", "KVGR1": "string", "TXGR1": "string", "salesDirectorCode": "string", "salesDirectorName": "string", "salesOfficeCode": "string", "salesOfficeName": "string", "salesDistrictCode": "string", "salesDistrictName": "string", "contractStatusCode": "string", "contractStatusName": "string", "workflowStatusCode": "string", "workflowStatusDescription": "string", "contractInitialDate": "string", "contractFinalDate": "string", "salesPersonCode": "string", "salesPersonName": "string", "currency": "string", "contractCategoryCode": "string", "contractCategoryName": "string", "lastInvoiceDate": "string", "PMETA": 0, "DIATR": "string", "DEVPR": 0, "city": "string", "state": "string", "documentCNPJ": "string", "documentCNPF": "string", "CLVTX": "string", "growthIndex": 0, "EXPMM": "string" },{ "companyCode": "string", "contractNumber": "2", "ERDAT": "string", "customerCode": "string", "customerName": "string", "contractTypeCode": "string", "contractTypeName": "string", "KVGR1": "string", "TXGR1": "string", "salesDirectorCode": "string", "salesDirectorName": "string", "salesOfficeCode": "string", "salesOfficeName": "string", "salesDistrictCode": "string", "salesDistrictName": "string", "contractStatusCode": "string", "contractStatusName": "string", "workflowStatusCode": "string", "workflowStatusDescription": "string", "contractInitialDate": "12/27/2015", "contractFinalDate": "22/27/2015", "salesPersonCode": "string", "salesPersonName": "string", "currency": "string", "contractCategoryCode": "string", "contractCategoryName": "string", "lastInvoiceDate": "string", "PMETA": 0, "DIATR": "string", "DEVPR": 0, "city": "string", "state": "string", "documentCNPJ": "string", "documentCNPF": "string", "CLVTX": "string", "growthIndex": 0, "EXPMM": "string" }] }';
            res= (GetContractResponseWrapper ) System.JSON.deserialize(tempResponse, GetContractResponseWrapper.class);
            System.debug('res is '+ res.contractHeaders[1].companyCode);
            System.debug('res of size is  '+ res.contractHeaders.size());*/
            //---------------- list to upsert in rebate contract------------------------------- //
         
          
          if(res.status=='S')
            {
            if(res.contractHeaders.size()>0)
            {
                list<Rebate_Contract__c> lstToUpsert = new list<Rebate_Contract__c>();
                For(GetContractResponseWrapper.ContractHeaders c: res.contractHeaders)
                {
                    //if(decimal.valueOf(c.contractNumber)>=8)
                    if (mapSAPCodeAccId.get(c.customerCode)!=Null)
                    {
                        if (c.regionCode!='' && c.regionCode!=null  && c.regionCode != 'BR')
                    {
                        System.debug('value of region is '+c.regionCode +'contract number ' +c.contractNumber);
                        Rebate_Contract__c rebContract = new Rebate_Contract__c();
                        rebContract.Name= c.contractNumber;
                        contractId.add(c.contractNumber);
                        rebContract.Start_Date__c= date.valueOf(c.contractInitialDate);
                        rebContract.End_Date__c= date.ValueOf(c.contractFinalDate);
       
                        Territory_Distributor__c tr = new Territory_Distributor__c(TerritoryCode__c=c.regionCode);
                        rebContract.Territory__r= tr;
                    
                        Account acc = new Account(SAP_Code__c=c.customerCode);
                        rebContract.Distributor__r =acc;
                        rebContract.CurrencyIsoCode=c.curr;
                        rebContract.Contract_Date__c=date.valueOf(c.ERDAT);
                        rebContract.Workflow_Status__c=c.workflowStatusDescription; 
                        rebContract.Status_Code__c=c.contractStatusCode;//added later
                        rebContract.Type_Code__c=c.contractTypeCode;//added later
                        rebContract.Workflow_Status_Code__c=c.workflowStatusCode;//added later
                        rebContract.Category_Code__c=c.contractCategoryCode;//added later
                        if(!c.lastInvoiceDate.equals('0000-00-00'))
                        {
                            rebContract.Last_Invoice_Date__c=date.valueOf(c.lastInvoiceDate);
                        }
                        rebContract.EXPMM__c=c.EXPMM;// added for RITM0432971 modified by Javed(Grazitti)  modified date- 30-09-2022
                        rebContract.Growth_Index__c= decimal.valueOf(c.growthIndex);
                        rebContract.Combination_Key__c=sales_Org+c.contractNumber;
                        rebContract.Contract_Date__c= date.valueOf(c.ERDAT);
                        rebContract.Status__c=c.contractStatusName;
                        rebContract.Type__c= c.contractTypeName;
                        rebContract.Category_Name__c=c.contractCategoryName;
                        Sales_Org__c sO= new Sales_Org__c(Sales_Org_Code__c=sales_Org);
                        rebContract.Sales_Org__r= sO;
                        Region__c rC= new Region__c(RegionCode__c=c.salesDistrictCode);
                        rebContract.Region__r=rC;
                        //rebContract.last
                        
                        lstToUpsert.add(rebContract);
                    }
                }
                 //addede
                    else
                    {
                          InvalidSAPCode =''+InvalidSAPCode+' ' + c.contractNumber +'';
                            successcounter=false;
                        
                    }//addede
                }
                system.debug('value is '+lstToUpsert);
                upsert lstToUpsert Combination_Key__c;
                system.debug('list is '+ contractId);
                contractId.sort();
                if (successcounter)
                {
                wrap.status= 'SUCCESS';
                wrap.contIds=contractId;   
                return wrap;
                }
                else
                {               
                    wrap.status= 'Partial';
                  wrap.contIds=contractId;
                    wrap.message=''+System.Label.REB_Contract_Not_Load+''+ InvalidSAPCode;
                  system.debug('message is '+wrap.message);
                    return wrap;
                }
                
            }
                wrap.status= 'SUCCESS';
                wrap.contIds= null;       
                return wrap; //null list 
        }
            else
            {
                wrap.status= 'FAIL';
                wrap.contIds=null;
                return wrap;
            }
      }
        catch(Exception ex)
        {
            String service='Get Contracts';
            //TransactionLogHandler.addTransactionEntryRebate(ex,service);
            WrapperContractID wrap =new WrapperContractID(); 
            System.debug('ex No: '+ex.getLineNumber()+' ex Msg: '+ex.getMessage());
            wrap.status= 'FAIL';
            wrap.contIds=null; 
            return wrap;
        } 
    }
    //added by Gurubaksh Grewal to get sub distributors from SAP 04/04/2023 Ticket:RITM0534476
    @Auraenabled
    public static map<string,object> getDistributors(GetContractRequestWrapper req)
    {        
        system.debug('reqForDis============'+req);
          Set<String> CustomerCode = new Set<String>();//addede
          List<String> lstCustomerCode = new List<String>();
          String InvalidSAPCode = '' ;  
          boolean successcounter= true;//addede
        list<String> contractId = new list<String>();//return List
        GetContractResponseWrapper res;// response wrapper
        WrapperContractID wrap =new WrapperContractID(); 
        String username = UPL_Settings__c.getOrgDefaults().HCI_User_Name__c;
        String password = UPL_Settings__c.getOrgDefaults().HCI_Password__c; 
        String url = UPL_Settings__c.getOrgDefaults().Rebate_Contract_URL__c;
        String sales_Org = UPL_Settings__c.getOrgDefaults().BR_Sales_Org__c;
        Integer timeOut = 120000;
        Http http = new Http();
        HttpRequest request = new HttpRequest();    
        request.setTimeout(timeOut);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        String json = System.JSON.serializePretty(req);
        system.debug('json is '+json);
        request.setBody(json);
        request.setEndpoint(url);        
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' +
        EncodingUtil.base64Encode(headerValue);
        //String authorizationHeader='Basic UzAwMDMyNjMzMTM6QWpAMTIzNDU=';
        request.setHeader('Authorization', authorizationHeader);
        HttpResponse response;
            if(!Test.isRunningTest()){
                response = http.send(request);
            }
            else{
                // Create a fake response
                response = new HttpResponse();
                response.setHeader('Content-Type', 'application/json');
                response.setBody('{"Distibutorlist":{"item":[{"Description":"COOP AGR UNAI LTDA","SAPCode":"0001033619"},{"Description":"COOPERATIVA AGROPECUARIA UNAI LTDA","SAPCode":"0001066082"},{"Description":"COOP AGR UNAI LTDA","SAPCode":"0001073579"}]},"contractHeaders":[{"EXPMM":"","growthIndex":"0.01","CLVTX":"","STCD2CPF":"","documentCNP":"20499489000103","state":"MG","city":"UNAI","customerName":"COOP AGR UNAI LTDA","DEVPR":"0.00","DIATR":"0000","PMETA":"113.21","lastInvoiceDate":"2023-03-20","contractCategoryName":"ACELERA","contractCategoryCode":"CA","curr":"BRL","salesPersonName":"RODRIGO SANCHES GATTO","salesPersonCode":"57001662","contractFinalDate":"2024-03-31","contractInitialDate":"2022-04-01","workflowStatusDescription":"Cartas de Crédito em processo de emissão","workflowStatusCode":"13","contractStatusName":"Ativo","contractStatusCode":"A","salesDistrictName":"TRIANGULO","salesDistrictCode":"BR1501","BEZEI":"BU CENTRO","salesOfficeCode":"BR45","salesDirectorName":"CULTURAS EXTENSIVAS","salesDirectorCode":"BR7","regionName":"BR71501406","regionCode":"BR406","contractTypeName":"Cooper UP","contractTypeCode":"C","customerNameAndCity":"COOP AGR UNAI LTDA-UNAI","customerCode":"0001033619","ERDAT":"2021-11-03","contractNumber":"1013","companyCode":"5190"}],"status":"S"}');
                response.setStatusCode(200); 
            } 
      string res1=response.getBody();
          map<string,object> respMap=(map<string,object>)System.JSON.deserializeUntyped(res1);
          system.debug('respMapSubDist=====>'+System.JSON.serializePretty(respMap));
        
          return respMap;
    
    }
    public static string getGoals(GetGoalsRequestWrapper reqGoals)
    {
        string SKUCodesError = system.label.Rebate_SKU_Error+' \n';//added by Swapnil
        string SKUCodes = system.label.Rebate_SKU_Error+' \n';//added by Swapnil
        try
        {
            //added by diwansh for IBM development 13 april 2020
            Map<id,Rebate_Goal_SKU__c> deleteMap= new map<id,Rebate_Goal_SKU__c>([select id ,Combination_Key__c,SKU_Code__c from Rebate_Goal_SKU__c where Contract__r.name=:reqGoals.contractNumber]); 
            Map<String, Id> mapSKUCodeGoalsId = new Map<String, Id>();
                for(Id itemId: deleteMap.keySet()){
                mapSKUCodeGoalsId.put(deleteMap.get(itemId).Combination_Key__c, itemId);
                }
      //ends
            list<Rebate_Contract_Workflow__c> rebWorkflow = new list<Rebate_Contract_Workflow__c>();
            list<Rebate_Goal_SKU__c> rebGoal = new list<Rebate_Goal_SKU__c>();  
            GetGoalsResponseWrapper resGoals;
            String username = UPL_Settings__c.getOrgDefaults().HCI_User_Name__c;
            String password = UPL_Settings__c.getOrgDefaults().HCI_Password__c; 
            String url = UPL_Settings__c.getOrgDefaults().Rebate_Get_Goals_URL__c;
            String sales_Org = UPL_Settings__c.getOrgDefaults().BR_Sales_Org__c;
            Integer timeOut = 120000;
            //commenting for testing wrapper
        Http http = new Http();
        HttpRequest request = new HttpRequest();    
        request.setTimeout(timeOut);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        String json = System.JSON.serializePretty(reqGoals);
        system.debug('json is '+json);
        request.setBody(json);
        request.setEndpoint(url);        
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' +
        EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        HttpResponse response;
            if(!Test.isRunningTest()){
                response = http.send(request);
            }
            else{
                // Create a fake response
                response = new HttpResponse();
                response.setHeader('Content-Type', 'application/json');
                response.setBody('{"E_NETAOT":"418513.96","E_NETOUT":"0.00","E_PCMMT":"25.00","status":"S","approvalHistory":[{"approverCode":"UPLINTCRM","approverEmail":"swapnil.more@in.ibm.com","approverProfileCode":"03","approverProfileName":"RTV","actionCode":"3","actionDescription":"Inserir dados","comments":"TEST","dateOfApproval":"20191022061539"}],"materials":[{"SKUCode":"6250320","EXTWG":"","MAKTX":"BIOBAC 50 WP (10X1 KG)","productCategory":"B","DEMCLS":"Biossolu\u00e7\u00f5es","volumeLastYear":"0.000","unitPriceLastYear":"0.00","totalValueLastYear":"0.00","volumeCurrentYear":"0.000","unitPriceCurrentYear":"0.00","totalValueCurrentYear":"0.00"}]}');
                response.setStatusCode(200);
            } 
            system.debug('reached here before converting to response wrapper');
            system.debug('status from webservice for goals '+response.getStatus());
            system.debug('response from webservice for goals '+response.getBody());
            resGoals= (GetGoalsResponseWrapper) System.JSON.deserialize(response.getBody(), GetGoalsResponseWrapper.class);
            system.debug('convertion  json is '+resGoals );
            
           
        //  String temporaryResponse= '{ "status": "S", "E_NATAOT":"10", "E_NETOUT":"20","E_PCMMT":"25.00","TE_APROVA":null,"TE_METAS":null , "materials": [ { "skuCode": "000000000006300156", "EXTWG": "string", "MAKTX": "string", "productCategory": "Demais", "DEMCLS": "string", "volumeLastYear": 0, "unitPriceLastYear": 0, "totalValueLastYear": 0, "volumeCurrentYear": 0, "unitPriceCurrentYear": 0, "totalValueCurrentYear": 0 }, { "skuCode": "000000000005250466", "EXTWG": "string", "MAKTX": "string", "productCategory": "Demais", "DEMCLS": "string", "volumeLastYear": 56565, "unitPriceLastYear": 5665, "totalValueLastYear": 5656, "volumeCurrentYear": 56755, "unitPriceCurrentYear": 333, "totalValueCurrentYear": 121 }, { "skuCode": "000000000005251022", "EXTWG": "string", "MAKTX": "string", "productCategory": "Demais", "DEMCLS": "string", "volumeLastYear": 0, "unitPriceLastYear": 144400, "totalValueLastYear": 1000, "volumeCurrentYear": 123, "unitPriceCurrentYear": 321, "totalValueCurrentYear": 111 } ], "approvalHistory": [ { "approverCode": "20011934", "approverEmail": "test@test.com", "approverProfileCode": "12345", "approverProfileName": "rebatetesting", "actionCode": "codeaction", "actionDescription": "i am test description", "comments": "no comments", "dateOfApproval": "2019-04-21" }, { "approverCode": "20011934", "approverEmail": "test@teseeeeet.com", "approverProfileCode": "12345", "approverProfileName": "rebatetesting in progress", "actionCode": "codeactionaction", "actionDescription": "i am test description 2", "comments": "no comments", "dateOfApproval": "2019-04-01" } ] } ';
          //  resGoals= (GetGoalsResponseWrapper) System.JSON.deserialize(temporaryResponse, GetGoalsResponseWrapper.class);
            System.debug('i reached after conversion');
                if(resGoals.status =='S')
                {
                Rebate_Contract__c getID= [Select id ,Combination_Key__c,CurrencyIsoCode,CRM_Status__c from Rebate_Contract__c where name =: reqGoals.contractNumber and Sales_Org__r.Sales_Org_Code__c =:sales_Org limit 1];
                if(getID !=null)
                {
                Rebate_Contract__c rebCon = new Rebate_Contract__c();
                rebCon.id= getID.Id;
                rebCon.Total_Other_Value_LY__c=decimal.valueOF(resGoals.E_NETAOT);
                rebCon.Total_Other_Value__c=decimal.valueOf(resGoals.E_NETOUT);
                rebCon.Last_Goals_Received__c=datetime.now();//error handling
                update rebCon;
                if(resGoals.ApprovalHistory.size()>0)
                {
                list<String> UGDN = new list<String>();

                   // delete [select id from Rebate_Contract_Workflow__c where Contract__r.name =:reqGoals.contractNumber ];
                    
                    //-------------------------------------- for setting up ugn number-------------------------------------//
                    For (GetGoalsResponseWrapper.ApprovalHistory lstUGN: resGoals.ApprovalHistory)
                    {
                        UGDN.add(lstUGN.approverEmail);                        
                    }
                    
                    //Map <id ,User> mapUGN = new MAP<id,User>([Select id ,UGDN_Number__c from User where UGDN_Number__c in : UGDN]);  
                    Map <id ,User> mapUGN = new MAP<id,User>([Select id ,email from User where email in : UGDN]);  
                    Map<String, Id> mapUGNId = new Map<String, Id>();
                     
                    for(Id itemId: mapUGN.keySet())
                    {
                    
                        mapUGNId.put(mapUGN.get(itemId).email, itemId);
                    
                    }
                    
                    
                    //
                    For (GetGoalsResponseWrapper.ApprovalHistory c: resGoals.ApprovalHistory)
                    {
                        Rebate_Contract_Workflow__c rcw = new Rebate_Contract_Workflow__c();
                        rcw.Contract__c =getID.Id ;
                        rcw.CurrencyIsoCode=getID.CurrencyIsoCode;
                        if(mapUGNId.get(c.approverEmail)!=null)
                        rcw.User__c=  mapUGNId.get(c.approverEmail);
                        String s  =c.dateOfApproval;
                        String s1 = s.mid(0, 4);
                        String s2 = s.mid(4, 2);
                        String s3 = s.mid(6, 2);
                        String dateOfApproval= s1+'-'+s2+'-'+s3;
                        System.debug('value is '+s1+ '-'+s2+ '-'+s3);
                        //rcw.Action_Date__c=date.valueOf(dateOfApproval);
                        rcw.Role_Code__c=c.approverProfileCode;
                        rcw.Role_Description__c=c.approverProfileName;
                        rcw.User_Code__c=c.approverCode;
                        if(c.approverEmail.contains('@'))
                        rcw.User_Email__c=c.approverEmail;
                        rcw.Action_Code__c=c.actionCode;
                        rcw.Action_Description__c=c.actionDescription;
                        rcw.New_Approval_Status__c=c.actionDescription;
                        rcw.Approval_Comments__c=c.comments;
                        rebWorkflow.add(rcw);
                        
                    }
                    
                //insert rebWorkflow;
                system.debug('i reached in the end ');
                }
                    //added by Swapnil
                    
                    set<string> SetSKUCodes = new set<string>();
                    if(resGoals.materials.size()>0){
                        for(GetGoalsResponseWrapper.Materials mw : resgoals.Materials)
                        { 
                            SetSKUCodes.add(sales_Org+mw.skuCode.leftPad(18,'0')); 
                        }
                    }
                    system.debug('SetSKUCodes '+SetSKUCodes);
                    Map<Id, SKU__c> mapSKU = new Map<Id, SKU__c>([SELECT id, SKU_Code__c,Combination_Key__c
                                                                  FROM SKU__c 
                                                                  WHERE Combination_Key__c IN : SetSKUCodes]);
                    system.debug('mapSKU '+mapSKU);
                    Map<String, Id> mapSKUCodeAvailable = new Map<String, Id>();
                    for(Id itemId: mapSKU.keySet()){  
                        mapSKUCodeAvailable.put(mapSKU.get(itemId).Combination_Key__c, itemId);
                    }
                   system.debug('mapSKUCodeAvailable '+mapSKUCodeAvailable);
                    integer count = 0;
                    for(GetGoalsResponseWrapper.Materials mw : resgoals.Materials){
                        if (mapSKUCodeAvailable.get(sales_Org+mw.skuCode.leftPad(18,'0'))!=Null){
                            
                        } 
                        else{
                            count = count+1;
                            if(count<=10){
                           SKUCodes = SKUCodes+' '+mw.skuCode;
                            
                            }
                            if(count == 11){ 
                              SKUCodes = SKUCodes+' '+ '\n '+system.label.Rebate_SKU_Error2 ;                              
                            }
                            
                        }
                        }
                    SKUCodes = SKUCodes + '\n '+ system.label.Contact_Sys_Admin;
                     system.debug('SKUCodes '+SKUCodes);
                    //end
                if(resGoals.materials.size()>0)
                {
                    //added by diwansh on 13 april 2020
                    set<id> deleteID = new Set<Id>();
                    deleteId = deleteMap.keySet();
                    //ends
                    for(GetGoalsResponseWrapper.Materials mw : resgoals.Materials)
                    {   
                    mw.skuCode= mw.skuCode.leftPad(18,'0');
                        //added by diwansh on 13 april 2020
                        if (mapSKUCodeGoalsId.get(sales_Org+reqGoals.contractNumber+mw.skuCode)!= null)
                        {
                            System.debug('i reached in delete '+mapSKUCodeGoalsId.get(sales_Org+reqGoals.contractNumber+mw.skuCode)) ;
                            deleteId.remove(mapSKUCodeGoalsId.get(sales_Org+reqGoals.contractNumber+mw.skuCode));
                        }
                        //ends
                    Rebate_Goal_SKU__c rg= new Rebate_Goal_SKU__c();
                        if(mw.skuCode!='000000000006020059')
                            
                        {
                    SKU__c sk = new SKU__c(Combination_Key__c=sales_Org+mw.skuCode);
                    rg.SKU__r=sk;
                        }
                    rg.Combination_Key__c= getID.Combination_Key__c+mw.skuCode;
                    rg.CurrencyIsoCode='';   
                    rg.Contract__c= getID.Id; 
                    rg.Product_Category__c=mw.DEMCLS;
                    rg.Product_Category_Code__c=mw.productCategory;//added later     
                    rg.Volume_LY__c=decimal.valueOf(mw.volumeLastYear);
                    rg.Price_LY__c=decimal.valueOf(mw.unitPriceLastYear);
                    rg.Value_LY__c=decimal.valueOf(mw.totalValueLastYear);
                    if(getID.CRM_Status__c=='New' || getID.CRM_Status__c=='')
                    {
                        rg.Volume__c=decimal.valueOf(mw.volumeCurrentYear);
                        rg.Price__c=decimal.valueOf(mw.unitPriceCurrentYear);
                        rg.Value__c=decimal.valueOf(mw.totalValueCurrentYear);
                    }
                        system.debug('combination key is'+ rg.Combination_Key__c );
                        system.debug('SKU is '+ mw.skuCode);
                    rebGoal.add(rg);
                    }
                    system.debug('above delete'+deleteId);
                    delete [select id from Rebate_Goal_SKU__c where id in :deleteId ];
                    upsert rebGoal Combination_Key__c;
                    system.debug('aa gya ');
                }
                    system.debug('records inserted successfully');
                return 'true';    
            }
                }   
         return 'false';
        }
        catch(Exception ex)
        {
           System.debug('ex No: '+ex.getLineNumber()+' ex Msg: '+ex.getMessage()); 
           String service ='GetGoal';
           //TransactionLogHandler.addTransactionEntryRebate(ex,service);
           if(SKUCodes.equals(SKUCodesError)){  
                  return 'false';   
              }  
              else{  
                  return SKUCodes;  
              } 
        }
    }
    //------------------------------------------new API ----------------------------------//
     public static boolean getApprovalHistory(GetApprovalHistoryRequestWrapper reqApp)
    {
        try
        {
            list<Rebate_Contract_Workflow__c> rebWorkflow = new list<Rebate_Contract_Workflow__c>();    
            GetApprovalHistoryResponseWrapper resApp;
            String username = UPL_Settings__c.getOrgDefaults().HCI_User_Name__c;
            String password = UPL_Settings__c.getOrgDefaults().HCI_Password__c; 
            String url = UPL_Settings__c.getOrgDefaults().Rebate_Get_History_URL__c;
            String sales_Org = UPL_Settings__c.getOrgDefaults().BR_Sales_Org__c;
            Integer timeOut = 120000;
            //commenting for testing wrapper
            Http http = new Http();
            HttpRequest request = new HttpRequest();    
            request.setTimeout(timeOut);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            String json = System.JSON.serializePretty(reqApp);
            system.debug('json is '+json);
            request.setBody(json);
            request.setEndpoint(url);        
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'BASIC ' +
            EncodingUtil.base64Encode(headerValue);
            request.setHeader('Authorization', authorizationHeader);
            HttpResponse response;
            if(!Test.isRunningTest()){
                response = http.send(request);
            }
            else{
                // Create a fake response
                response = new HttpResponse();
                response.setHeader('Content-Type', 'application/json');
                response.setBody('{"E_NETAOT":"418513.96","E_NETOUT":"0.00","E_PCMMT":"25.00","status":"S","approvalHistory":[{"approverCode":"UPLINTCRM","approverEmail":"swapnil.more@in.ibm.com","approverProfileCode":"03","approverProfileName":"RTV","actionCode":"3","actionDescription":"Inserir dados","comments":"TEST","dateOfApproval":"20191022061539"}],"materials":[{"SKUCode":"6250320","EXTWG":"","MAKTX":"BIOBAC 50 WP (10X1 KG)","productCategory":"B","DEMCLS":"Biossolu\u00e7\u00f5es","volumeLastYear":"0.000","unitPriceLastYear":"0.00","totalValueLastYear":"0.00","volumeCurrentYear":"0.000","unitPriceCurrentYear":"0.00","totalValueCurrentYear":"0.00"}]}');
                response.setStatusCode(200);
                }    
                system.debug('reached here before converting to response wrapper');
                system.debug('status from webservice for goals '+response.getStatus());
                system.debug('response from webservice for goals '+response.getBody());
                //String temp = '{"status":"S","approvalHistory":[{"hourOfRecord":"05:53:41","status":"@5B@","statusCode":"02","statusDescription":"Aguardando Metas","profileCode":"03","profileDescription":"RTV","sapUserTransactionCode":"UPLINTCRM","approverEmail":"diwansh.sethi@in.ibm.com","actionCode":"3","actionDescription":"Inserir dados","datetimeOfRecord":"22.10.2019 05:53:41","approvalComments":"TEST"}]}';
                resapp= (GetApprovalHistoryResponseWrapper) System.JSON.deserialize(response.getBody(), GetApprovalHistoryResponseWrapper.class);
                system.debug('convertion  json for approval history is '+resApp);
             
                System.debug('i reached after conversion');
                if(resApp.status =='S')
                {
                Rebate_Contract__c getID= [Select id ,Combination_Key__c,CurrencyIsoCode,CRM_Status__c from Rebate_Contract__c where name =: reqApp.contractNumber and Sales_Org__r.Sales_Org_Code__c =:sales_Org limit 1];
                if(getID !=null)
                {
                if(resApp.ApprovalHistory.size()>0)
                {
                list<String> UGDN = new list<String>();
                
                    delete [select id from Rebate_Contract_Workflow__c where Contract__r.name =:reqApp.contractNumber ];
                    
                    //-------------------------------------- for setting up ugn number-------------------------------------//
                    For (GetApprovalHistoryResponseWrapper.ApprovalHistory lstUGN: resApp.ApprovalHistory)
                    {
                        UGDN.add(lstUGN.approverEmail);                        
                    }
                    
                    //Map <id ,User> mapUGN = new MAP<id,User>([Select id ,UGDN_Number__c from User where UGDN_Number__c in : UGDN]);  
                    Map <id ,User> mapUGN = new MAP<id,User>([Select id ,email from User where email in : UGDN]);  
                    Map<String, Id> mapUGNId = new Map<String, Id>();
                    
                    for(Id itemId: mapUGN.keySet())
                    {
                        mapUGNId.put(mapUGN.get(itemId).email, itemId);
                    }

                    //
                    For (GetApprovalHistoryResponseWrapper.ApprovalHistory c: resApp.ApprovalHistory)
                    {
                        Rebate_Contract_Workflow__c rcw = new Rebate_Contract_Workflow__c();
                        rcw.Contract__c =getID.Id ;
                        rcw.CurrencyIsoCode=getID.CurrencyIsoCode;
                        if(mapUGNId.get(c.approverEmail)!=null)
                        rcw.User__c=  mapUGNId.get(c.approverEmail);
                        /*String s  =c.dateOfApproval;
                        String s1 = s.mid(0, 4);
                        String s2 = s.mid(4, 2);
                        String s3 = s.mid(6, 2);
                        String dateOfApproval= s1+'-'+s2+'-'+s3;
                        System.debug('value is '+s1+ '-'+s2+ '-'+s3);
                        rcw.Action_Date__c=date.valueOf(dateOfApproval);*/
                      if(c.datetimeOfRecord!= null && c.datetimeOfRecord!='')
                      {
                       String s  =c.datetimeOfRecord;
                        list<String> sp = s.split(' ');
                        system.debug('sp is '+sp );
                        String s1 = sp[0].mid(0, 2);
                        String s2 = sp[0].mid(3, 2);
                        String s3 = sp[0].mid(6, 4);
                        String dateOfApproval= s3+'-'+s2+'-'+s1+' '+sp[1];
                        System.debug('value is '+dateOfApproval);
                        rcw.Action_Date__c=Datetime.valueOf(dateOfApproval);
                      } 
                       rcw.Role_Code__c=c.profileCode;
                       rcw.Role_Description__c=c.profileDescription;
                       rcw.User_Code__c=c.sapUserTransactionCode;
                       if(c.approverEmail.contains('@'))
                       rcw.User_Email__c=c.approverEmail;
                       rcw.Action_Code__c=c.actionCode;
                       rcw.Action_Description__c=c.actionDescription;
                       rcw.New_Approval_Status__c=c.statusDescription;
                       rcw.Approval_Comments__c=c.approvalComments;
                       rcw.Status_Code__c=c.statusCode;
                       rebWorkflow.add(rcw);
                        
                    }
                    
                insert rebWorkflow;
                    
                 Rebate_Contract__c rebCon = new Rebate_Contract__c();
                  rebCon.id= getID.Id;
                  rebCon.Last_Approval_History_Received__c  =datetime.now();
                   update rebCon;
                   
                system.debug('i reached in the end ');
                }
                  
               }
                  return true;
                }
            return false;
        }
        
                    
           catch(Exception ex)
       {
           System.debug('ex No: '+ex.getLineNumber()+' ex Msg: '+ex.getMessage()); 
           //TransactionLogHandler.addTransactionEntryRebate(ex,service);
           return false;
       }
       
   } 
                    
                    
    
    
    
   public static boolean SendGoals(SendGoalRequestWrapper sendGoals)
   {
       try{
           
           SendGoalResponseWrapper resUpdate;
           String username = UPL_Settings__c.getOrgDefaults().HCI_User_Name__c;
           String password = UPL_Settings__c.getOrgDefaults().HCI_Password__c;  
           String url = UPL_Settings__c.getOrgDefaults().Rebate_Send_Goals_URL__c;
           Integer timeOut = 120000;
           
           Http http = new Http();
           HttpRequest request = new HttpRequest(); 
           request.setTimeout(timeOut);
           request.setMethod('POST');
           request.setHeader('Content-Type', 'application/json');
           String json = System.JSON.serializePretty(sendGoals);
           system.debug('json is '+json);
           request.setBody(json);
           request.setEndpoint(url);        
           Blob headerValue = Blob.valueOf(username + ':' + password);
           String authorizationHeader = 'BASIC ' +
           EncodingUtil.base64Encode(headerValue);
           request.setHeader('Authorization', authorizationHeader);
           HttpResponse response;
            if(!Test.isRunningTest()){
                response = http.send(request);
                System.debug('response from integration'+response);
            }
            else{
                // Create a fake response
                response = new HttpResponse();
                response.setHeader('Content-Type', 'application/json');
                response.setBody('{"status":"S"}');
                response.setStatusCode(200);
            } 
            system.debug('reached here before converting to response wrapper');
            system.debug('status from webservice for goals '+response.getStatus());
            system.debug('response from webservice for goals '+response.getBody());
           Map <String, Object> objectMap = (Map <String, Object>) system.json.deserializeUntyped( response.getBody());
           String respstatus = String.valueof(objectMap.get('status'));
           system.debug('respstatus====?'+respstatus);
         //  resUpdate=(SendGoalResponseWrapper) System.JSON.deserialize(response.getBody(), SendGoalResponseWrapper.class);  
           system.debug('value after the conversion of get goals '+resUpdate );
         //error handling starts 
           Rebate_Contract__c getID= [Select id,Integration_Approval_Step__c,CRM_Status__c,Approval_Fire__c from Rebate_Contract__c where name =: sendGoals.contractNumber limit 1];
           Rebate_Contract__c rebCon = new Rebate_Contract__c();
               rebCon.id= getID.Id;
               if(sendGoals.Goals == null)
               {
                   rebCon.Last_Approval_Sent__c= datetime.now(); 
               }
               else
               {
                   rebCon.Last_Goals_Sent__c=datetime.now();    
               }
               //error handling ends 

           
           
           if(respstatus == 'S')
           {
               id ProcessDefinition = [select id from processDefinition where developername = 'Rebate_Approval_Processv'][0].ID;
            
            list<ProcessInstance> latestInstance = new list<ProcessInstance>();
            latestInstance = [SELECT Id,processdefinition.name,targetObjectId 
FROM ProcessInstance where targetObjectId = :getID.id and processdefinitionId = :ProcessDefinition order by lastmodifieddate DESC limit 1];
            
            list<ProcessInstanceStep> latestInstanceStep = new list<ProcessInstanceStep>();
            latestInstanceStep = [SELECT Id, ProcessInstanceId, StepStatus, OriginalActorId, 
                        
                                  ActorId,actor.email, Comments, StepNodeId FROM ProcessInstanceStep where ProcessInstanceId = :latestInstance[0].Id order by SystemModstamp  DESC limit 1];

             rebCon.Last_Goals_Sent_Status__c='Success';
             if(latestInstanceStep[0].StepStatus == 'Approved'){
                 
                        //Added For RITM0535972 by Pragati Sharma (Grazitti)
             
                 if(getID.Integration_Approval_Step__c=='1'){
                     rebCon.Integration_Approval_Step__c='2'; 
                     rebCon.CRM_Status__c='In Review';
                     rebCon.Approval_Fire__c=true;
                     rebCon.Status_Value__c='Success';
                     rebCon.Workflow_Status__c='Aguardando Aprovação de Metas Diretor Marketing Operacional';
                 }
                 else      if(getID.Integration_Approval_Step__c=='2'){
                     rebCon.Integration_Approval_Step__c='3';
                     rebCon.CRM_Status__c='In Review';
                     rebCon.Approval_Fire__c=true;
                     rebCon.Status_Value__c='Success';
                      rebCon.Workflow_Status__c='Aguardando Aprovação de Metas CCO';
                 }
                 
                 else      if(getID.Integration_Approval_Step__c=='3'){
                     rebCon.Integration_Approval_Step__c='4'; 
                     rebCon.CRM_Status__c='In Review';
                     rebCon.Approval_Fire__c=true;
                     rebCon.Status_Value__c='Success';
                     rebCon.Workflow_Status__c='Aguard Aprov Metas Diretor de Vendas';
                 }
                 else      if(getID.Integration_Approval_Step__c=='4'){
                     rebCon.Integration_Approval_Step__c='5'; 
                     rebCon.Status_Value__c='Success';
                     
                     
                 }
                  update rebCon;   
                 Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
             req.setComments('');
             req.setObjectId(rebCon.Id);
             Approval.ProcessResult result = Approval.process(req);
             system.debug('result'+result);
             }
     
            
             
             
             
             // error handling code ends
             System.debug('i reached here ');
             return true;
            }
            
            rebCon.Last_Goals_Sent_Status__c='Failure';//error handling
            update rebCon;//error handling
            
            return false;
       }
       catch(Exception ex)
       {
           System.debug('ex No: '+ex.getLineNumber()+' ex Msg: '+ex.getMessage()); 
           String service ='Send Goal';
           //Added For RITM0535972 by Pragati Sharma (Grazitti)
           Rebate_Contract__c getID= [Select id,Integration_Approval_Step__c from Rebate_Contract__c where name =: sendGoals.contractNumber limit 1];
              

            
            Rebate_Contract__c rebCon = new Rebate_Contract__c();
               rebCon.id= getID.Id;
           
             rebCon.CRM_Status__c='In Editing';
             rebCon.Last_Goals_Sent_Status__c='Failure';
           
             //error handling
               update rebCon;
           //TransactionLogHandler.addTransactionEntryRebate(ex,service);
           return false;
       }
       
   } 
    
    public static boolean GetGoalActuals(GetGoalActualsRequestWrapper act)
    {
        try{
            list<Rebate_Goal_Brand__c> rebBrand = new list<Rebate_Goal_Brand__c>(); 
            GetGoalActualsResponseWrapper resBrand;
            String username = UPL_Settings__c.getOrgDefaults().HCI_User_Name__c;
            String password = UPL_Settings__c.getOrgDefaults().HCI_Password__c; 
            String url = UPL_Settings__c.getOrgDefaults().Rebate_Get_Actuals_URL__c;
            String sales_Org = UPL_Settings__c.getOrgDefaults().BR_Sales_Org__c;

            Integer timeOut = 120000;     
            Http http = new Http();
            HttpRequest request = new HttpRequest();    
            request.setTimeout(timeOut);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            String json = System.JSON.serializePretty(act);
            system.debug('json is '+json);
            request.setBody(json);
            request.setEndpoint(url);        
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'BASIC ' +
                EncodingUtil.base64Encode(headerValue);
            request.setHeader('Authorization', authorizationHeader);
            HttpResponse response;
            if(!Test.isRunningTest()){
                response = http.send(request);
            }
            else{
                // Create a fake response
                response = new HttpResponse();
                response.setHeader('Content-Type', 'application/json');
                response.setBody('{"status":"S","goals":[{"productCategoryCode":"D","productCategoryDescription":"Demais","productBrand":"","salesDirectorCode":"","salesOfficeCode":"","salesDistrictCode":"","salesPersonCode":"00000000","currentVolume":"0.000","currenttValue":"0.00","returnsVolume":"0.000","returnsValue":"0.00","atingimentoVolume":"0.00","goalsVolume":"25900.000","goalsValue":"1100861.00","VOLUMRCON":"0.000","VALORRCON":"0.00","VOLUMDCON":"25900.000","VALORDCON":"1100861.00","VLRRNF":"0.00","VLDVNF":"0.00","realVolume":"0.000","realValue":"0.00","XBONUS":"0.00","BONANT":"0.00","BONMET":"0.00","VOLUMAN":"70920.000","VALORAN":"3450092.80"}],"returns":{"actualValue":"6261.40","returnsValue":"0.00"},"goalsXactualXlastYear":{"lastYearValue":"4875970.58","goalsValue":"5954.60","actualValue":"5954.60"},"otherProducts":[{"productCategoryCode":"","productCategoryDescription":"","productBrand":"","salesDirectorCode":"","salesOfficeCode":"","salesDistrictCode":"","salesPersonCode":"00000000","actualVolume":"0.000","actualValue":"0.00","returnsVolume":"0.000","returnsValue":"0.00","atingimentoVolume":"0.00","goalVolume":"0.000","goalValue":"0.00","VOLUMRCON":"0.000","VALORRCON":"0.00","VOLUMDCON":"0.000","VALORDCON":"0.00","VLRRNF":"0.00","VLDVNF":"0.00","realVolume":"0.000","realValue":"0.00","XBONUS":"0.00","BONANT":"0.00","BONMET":"0.00","VOLUMAN":"0.000","VALORAN":"0.00"}],"results":[{"productCategoryCode":"B","productCategoryDescription":"Biossolu\u00e7\u00f5es","goalCurrentYear":"0.00","VALORR":"0.00","VLRRNF":"0.00","VALORD":"0.00","salesValue":"0.00","VLRFAT":"0.00"}]}'); 
                response.setStatusCode(200);
            }
            //String temp='{ "status": "S", "productCategoryGoals": [ { "CLSREB": "Response Testing", "CLSREB_TXT": "Biossoluções", "GRP_PROD": "string", "KVGR2": "string", "VKBUR": "string", "BZIRK": "string", "PERNR": "string", "VOLUMR": 233, "VALORR": 0, "VOLUMD": 90, "VALORD": .4, "VALORA": 222, "VOLUMM": 21, "VALORM": 0, "VOLUMRCON": 0, "VALORRCON": 0, "VOLUMDCON": 0, "VALORDCON": 0, "VLRRNF": 0, "VLDVNF": 0, "VOLNET": 9898, "VLRNET": 24, "XBONUS": 0, "BONANT": 0, "BONMET": 0, "VOLUMAN": 21, "VALORAN": 22 } ], "productCategorySKUGoals": [ { "CLSREB": "string", "CLSREB_TXT": "string", "GRP_PROD": "string", "MATNR": "string", "KVGR2": "string", "VKBUR": "string", "BZIRK": "string", "PERNR": "string", "VOLUMR": 0, "VALORR": 0, "VOLUMD": 0, "VALORD": 0, "VALORA": 0, "VOLUMM": 0, "VALORM": 0, "VOLUMRCON": 0, "VALORRCON": 0, "VOLUMDCON": 0, "VALORDCON": 0, "VLRRNF": 0, "VLDVNF": 0, "VOLNET": 0, "VLRNET": 0, "VOLUMAN": 0, "VALORAN": 0 } ], "productCategorySKUActuals": [ { "CLSREB": "string", "CLSREB_TXT": "string", "GRP_PROD": "string", "DOCNUM": "string", "MATNR": "string", "KVGR2": "string", "VKBUR": "string", "BZIRK": "string", "PERNR": "string", "VOLUMR": 0, "VALORR": 0, "VOLUMD": 0, "VALORD": 0, "IGNOR": "string" } ], "contractLevelReturns": [ { "VALORR": 0, "VALORD": 0 } ], "contractLevelTotals": [ { "VALORANT":2121, "VALOR": 0, "VLRRNF": 0 } ], "otherProductCategoryGoals": [ { "CLSREB": "string", "CLSREB_TXT": "string", "GRP_PROD": "string", "KVGR2": "string", "VKBUR": "string", "BZIRK": "string", "PERNR": "string", "VOLUMR": 0, "VALORR": 0, "VOLUMD": 0, "VALORD": 0, "VALORA": 0, "VOLUMM": 0, "VALORM": 0, "VOLUMRCON": 0, "VALORRCON": 0, "VOLUMDCON": 0, "VALORDCON": 0, "VLRRNF": 0, "VLDVNF": 0, "VOLNET": 0, "VLRNET": 0, "XBONUS": 0, "BONANT": 0, "BONMET": 0, "VOLUMAN": 0, "VALORAN": 0 } ], "productCategoryResults": [ { "CLSREB": "string", "CLSREB_TXT": "string", "VALORM": 8080, "VALORR": 8080, "VLRRNF": 9090, "VALORD": 5050, "VLRACM": 4444, "VLRFAT": 0 } ], "TE_RETURN": [ { "TYPE": "string", "CODIGO": "string", "DESCR": "string", "MESSAGE": "string" } ] }';
            System.debug('i reached before conversion'+ response.getBody());
            resBrand= (GetGoalActualsResponseWrapper) System.JSON.deserialize(response.getBody(), GetGoalActualsResponseWrapper.class);
            
            System.debug('i reached after conversion'+ resBrand);
            if(resBrand.status =='S' && resBrand.Goals.size()>0)
            {
                
                Rebate_Contract__c getID = [Select id ,CurrencyIsoCode,Combination_Key__c,CRM_Status__c from Rebate_Contract__c where name =: act.contractNumber and Sales_Org__r.Sales_Org_Code__c =:sales_Org limit 1];
                if(getID !=null)
                {
                    Rebate_Contract__c rebCon = new Rebate_Contract__c();
                     rebCon.Goal_Value__c=0;
                     rebCon.Actual_Value__c=0;
                    For(GetGoalActualsResponseWrapper.Results  results : resBrand.Results)
                    {                  
                        rebCon.id= getID.Id;
                        rebCon.Goal_Value__c+=decimal.valueOf(results.goalCurrentYear);//
                        rebCon.Actual_Value__c+=decimal.valueOf(results.salesValue);
                        
                    }
                        rebCon.Net_Actual_Value__c=decimal.valueOf(resBrand.returns.actualValue);
                        rebCon.Net_Returns_Value__c=decimal.valueOf(resBrand.returns.returnsValue);
                        rebCon.Actual_Value_LY__c=decimal.valueOf(resBrand.goalsXactualXlastYear.lastYearValue); 
                        rebCon.Last_Actuals_Received__c=datetime.now();//error handling
                        update rebCon;
                    if(resBrand.Goals.size()>0)                        
                    {
                        
                     delete [select id from Rebate_Goal_Brand__c where Contract__r.name =:act.contractNumber];
                        For(GetGoalActualsResponseWrapper.Goals pCGoals : resBrand.Goals)
                        {
    
                            {
                            Rebate_Goal_Brand__c rBrand = new Rebate_Goal_Brand__c();
                            
                            rBrand.Brand_Name__c=pCGoals.productBrand;
                            rBrand.Combination_Key__c=getID.Combination_Key__c + pCGoals.productCategoryCode + '#' + pCGoals.productBrand + '#';
                            rBrand.Contract__c=getID.Id;
                            rBrand.Product_Category__c=pCGoals.productCategoryDescription;
                            rBrand.Product_Category_Code__c= pCGoals.productCategoryCode;//added later   
                            rBrand.CurrencyIsoCode=getID.CurrencyIsoCode;
                            rBrand.Volume_LY__c=decimal.valueOf(pCGoals.VOLUMAN);
                            rBrand.Value_LY__c=decimal.valueOf(pCGoals.VALORAN);
                            rBrand.Volume__c=decimal.valueOf(pCGoals.goalsVolume);
                            rBrand.Value__c=decimal.valueOf(pCGoals.goalsValue);
                            rBrand.Actual_Value__c=decimal.valueOf(pCGoals.currenttValue);
                            rBrand.Actual_Volume__c=decimal.valueOf(pCGoals.currentVolume);
                            rBrand.Returns_Value__c=decimal.valueOf(pCGoals.returnsValue);
                            rBrand.Returns_Volume__c=decimal.valueOf(pCGoals.returnsVolume);
                            rBrand.Attainment_Volume__c=decimal.valueOf(pCGoals.atingimentoVolume);
                            rBrand.Net_Value__c=decimal.valueOf(pCGoals.VALORRCON);//changed values on 16 april 2020
                            rBrand.Net_Volume__c=decimal.valueOf(pCGoals.VOLUMRCON); //changed values on 16 april 2020

                                rebBrand.add(rBrand);
                            }
                            }
                       upsert rebBrand Combination_Key__c;  
                        For(GetGoalActualsResponseWrapper.OtherProducts pCOtherGoals : resBrand.OtherProducts)
                        {
                            
                            {
                                Rebate_Goal_Brand__c rBrand = new Rebate_Goal_Brand__c();
                                
                                rBrand.Brand_Name__c=pCOtherGoals.productBrand;
                                rBrand.Combination_Key__c=getID.Combination_Key__c + pCOtherGoals.productCategoryCode + '#' + pCOtherGoals.productBrand + '#';
                                rBrand.Contract__c=getID.Id;
                                rBrand.Product_Category__c='Outros';
                                rBrand.Product_Category_Code__c= pCOtherGoals.productCategoryCode;//added later   
                                rBrand.CurrencyIsoCode=getID.CurrencyIsoCode;
                                rBrand.Volume_LY__c=decimal.valueOf(pCOtherGoals.VOLUMAN);
                                rBrand.Value_LY__c=decimal.valueOf(pCOtherGoals.VALORAN);
                                rBrand.Volume__c=decimal.valueOf(pCOtherGoals.goalVolume);
                                rBrand.Value__c=decimal.valueOf(pCOtherGoals.goalValue);
                                rBrand.Actual_Value__c=decimal.valueOf(pCOtherGoals.actualValue);
                                rBrand.Actual_Volume__c=decimal.valueOf(pCOtherGoals.actualVolume);
                                rBrand.Returns_Value__c=decimal.valueOf(pCOtherGoals.returnsValue);
                                rBrand.Returns_Volume__c=decimal.valueOf(pCOtherGoals.returnsVolume);
                                rBrand.Attainment_Volume__c=decimal.valueOf(pCOtherGoals.atingimentoVolume);
                                 rBrand.Net_Value__c=decimal.valueOf(pCOtherGoals.VALORRCON);//changed values on 16 april 2020
                                rBrand.Net_Volume__c=decimal.valueOf(pCOtherGoals.VOLUMRCON);//changed values on 16 april 2020
                                rebBrand.add(rBrand);
                            }
                        }
                        upsert rebBrand Combination_Key__c;  
                   
                    }        
                }
             return true;
            }
            else
            {
                return false;
            }
            
        }
   
     catch(Exception ex)
       {
           System.debug('ex No: '+ex.getLineNumber()+' ex Msg: '+ex.getMessage()); 
           String service ='GetGoalActuals';
           //TransactionLogHandler.addTransactionEntryRebate(ex,service);
           return false;
             
       }
       
    }    
    
}