global class CaseUpdateServiceNAM implements Messaging.InboundEmailHandler{
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        try
        {
            List<List<String>> combinedCSV = new List<List<String>>();
            list<String> csv= new list<string>();
            String emailSubject = email.Subject; 
            emailSubject = emailSubject.substring(emailSubject.indexOf(':') + 1);
            System.debug('emailSubject:'+emailSubject);
            if (email.binaryAttachments != null && email.binaryAttachments.size() > 0 ) {
                for (Integer i = 0 ; i < email.binaryAttachments.size() ; i++) {
                    if(email.binaryAttachments[i].filename.endsWith('.txt')||email.binaryAttachments[i].filename.endsWith('.csv')){
                        csv= FileUtilitySalesData.processAttachment(email.binaryAttachments[i].filename, email.fromAddress, emailSubject, email.binaryAttachments[i].body);
                        combinedCSV.add(csv);
                    }
                }
            }
            //for text files
            if (email.TextAttachments != null && email.TextAttachments.size() > 0) {
                for (Integer i = 0 ; i < email.TextAttachments.size() ; i++) {
                    if(email.TextAttachments[i].filename.endsWith('.txt')||email.TextAttachments[i].filename.endsWith('.csv')){
                        csv= FileUtilitySalesData.processAttachment(email.TextAttachments[i].filename, email.fromAddress, emailSubject, Blob.valueOf(email.TextAttachments[i].body));
                    }
                }
            }
            system.debug('csv size is '+ csv.size());
            Integer columncount;
            list<errorWrapper> finalerrorList = new list<errorWrapper>();
            for(Integer i= 0;i<combinedCSV.size();i++)
            {
                for (Integer j= 0 ;j<combinedCSV[i].size();j++)
                {
                    list<String> lst = new list<String>();
                    lst=combinedCSV[i];
                    system.debug('lst::'+lst);
                    list<string> column= new list<string>();
                    column= lst[j].split('\r\n');
                    system.debug('lst[j]::'+lst[j]);
                    system.debug('email.fromAddress::'+email.fromAddress);
                    list<errorWrapper> errlist = CaseUpdateServiceNAM.processData(lst[j]);
                    system.debug('errlist::'+errlist);
                    finalerrorList.addAll(errlist);
                }
            }
            if (finalerrorList.size()>0){
                List<Messaging.Emailfileattachment> efaList = new List<Messaging.Emailfileattachment>();
                
                string header = 'Case Number, SAP Doc Number, Error Reason \n';
                string finalstr = header ;
                for(errorWrapper err: finalerrorList)
                {
                    string recordString = '"'+err.casenumber+'","'+err.sapdocno+'","'+err.reason+'" \n';
                    finalstr = finalstr +recordString;
                }
                
                Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                blob csvBlob = Blob.valueOf(finalstr);
                string csvname= 'CaseUpdateError.csv';
                csvAttc.setFileName(csvname);
                csvAttc.setBody(csvBlob);
                efaList.add(csvAttc);
                Messaging.SingleEmailMessage emailsend =new Messaging.SingleEmailMessage();
                String[] toAddresses = new list<string> {email.fromAddress};
                    String subject ='CaseUpdateError';
                emailsend.setSubject(subject);
                emailsend.setToAddresses( toAddresses );
                emailsend.setPlainTextBody('Attached records could not be updated. Error messages are listed.');
                emailsend.setFileAttachments(efaList);
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailsend});
            }
            return result;
        }  
        catch(Exception ex){
            System.debug('Line No: '+ex.getLineNumber()+' Message: '+ex.getMessage()+' Cause: '+ex.getCause());
        }
        
        System.debug('result: '+result);
        return result;
    }
    
    public static list<errorWrapper> processData(String csv)
    {
        String []filelines;
        list<Case> listData = new list<Case>();
        list<errorWrapper> errorList= new list<errorWrapper>();
        List<String> caseNumberList = New List<String>();
        filelines=csv.split('\n');  
        List<string> inputvalues = new list<string>();
        list<string> errorCSVList = new List<String>();
        
        Set<String> caseNumber = new Set<String>();  
        for (Integer i=0;i<(filelines.size()-1);i++)
        {
            inputvalues = filelines[i].split(',');
            system.debug('value is columns '+ inputvalues.size());
            system.debug('input is '+ inputvalues);
            caseNumber.add(inputvalues[0].trim());
        }
        caseNumberList.addAll(caseNumber);
        
        //System.debug('lstCustomerCode is '+ lstCustomerCode);
        Map<Id, Case> mapCase = new Map<Id, Case>([SELECT id, CaseNumber FROM Case WHERE CaseNumber IN : caseNumberList]);
        Map<String, Id> mapcasenumber = new Map<String, Id>();
        for(Id itemId: mapCase.keySet()){
            mapcasenumber.put(mapCase.get(itemId).CaseNumber, itemId);
        }
        for (Integer i=0;i<(filelines.size()-1);i++)
        {
            String counter='0';
            errorWrapper errorw = new errorWrapper();
            errorw.reason='';
            inputvalues = filelines[i].split(',');
            if (mapcasenumber.get(inputvalues[0].trim())== null ||inputvalues[0]==null || inputvalues[0]=='')
            {
                errorw.reason='Invalid Case Number';
                errorw.casenumber=inputvalues[0];
                errorw.sapdocno=inputvalues[1]; 
                counter='1';
            }
            if (counter=='1')
            {
                errorList.add(errorw);   
            }else if (counter =='0')
            {
                Case caseupdate = new Case();
                caseupdate.Id = mapcasenumber.get(inputvalues[0].trim());
                caseupdate.SAP_Doc_Number__c=inputvalues[1].trim();
                caseupdate.Status='Executed in SAP';
                listData.add(caseupdate); 
            }       
        }
        
        Database.UpsertResult[] sDataUpload=  Database.upsert(listData,Case.Id,false);
        for(Case caseObject : listData){
            caseObject.Status = 'Closed';
        }
        
        Database.UpsertResult[] sDataUploadFinal=  Database.upsert(listData,Case.Id,false);
        for(Integer i=0;i<sDataUploadFinal.size();i++){
            if (!sDataUploadFinal.get(i).isSuccess()){
                Database.Error err = sDataUploadFinal.get(i).getErrors().get(0);
                errorWrapper errorw = new errorWrapper();
                errorw.reason=err.getMessage();
                errorList.add(errorw);
                System.debug('Error - '+err.getMessage() + '\nStatus Code : '+err.getStatusCode()+'\n Fields : '+err.getFields());
            }
        }
        //system.debug('debug main is '+errorCSVList );
        system.debug('successfull uploaded');
        //Logic to update CSR records price book
        List<Case> csrList = [select id, recordtype.name,AccountId,Account.SAP_Code__c,Account.sales_org__r.sales_org_code__c,Pack_Size_SKU__c,(select id,Name, Distributor_Rebate__c,Brand_Pack_Size__c,Brand_Pack_Size__r.name,Brand_Pack_Size__r.SKU_Code__c, Effective_End_Date__c, Effective_Start_Date__c, Grower_Rebate_All_In__c, 
                                                                                                                            IPP__c, IPP_Offer__c, Proposed_List_Price_Unit__c, Proposed_Payment_Term__c, PLN__c, Off_Invoice_Discount_Pct__c,Brand_Pack_Size__r.Distribution_Channel__r.Distribution_Channel_Code__c,Brand_Pack_Size__r.Division__c, Brand_Pack_Size__r.Division__r.Division_Code__c,
                                                                                                                            Retailer_Rebate_All_In__c from Case_Products__r) from case where recordtype.name = 'CSR' and id IN: listData and Id IN (SELECT case__c FROM case_product__c)];
        List<CaseDetailsWrapper> cdList = new List<CaseDetailsWrapper>();
        List<Id> skuIdList = new List<Id>();
        if(csrList.size() > 0){
            for(Case cobject : csrList){
                if(cobject.Case_Products__r != null && cobject.Case_Products__r.size() >0){
                    for(Case_Product__c cprod : cobject.Case_Products__r){
                        CaseDetailsWrapper cdWrapper = new CaseDetailsWrapper();
                        cdWrapper.account = cobject.AccountId;
                        cdWrapper.sku = cprod.Brand_Pack_Size__c;
                        cdWrapper.sapCode = cobject.Account.SAP_Code__c;
                        cdWrapper.distChannel = cprod.Brand_Pack_Size__r.Distribution_Channel__r.Distribution_Channel_Code__c;
                        cdWrapper.division = cprod.Brand_Pack_Size__r.Division__r.Division_Code__c;
                        cdWrapper.divisionId = cprod.Brand_Pack_Size__r.Division__c;
                        cdWrapper.sapCode = cobject.Account.SAP_Code__c;
                        cdWrapper.skuCode = cprod.Brand_Pack_Size__r.SKU_Code__c;
                        skuIdList.add(cprod.Brand_Pack_Size__c);
                        cdWrapper.startDate = cprod.Effective_Start_Date__c;
                        cdWrapper.endDate = cprod.Effective_End_Date__c;
                        cdWrapper.salesOrg = cobject.Account.sales_org__r.sales_org_code__c;
                        cdWrapper.salesOrgId = cobject.Account.sales_org__c;
                        cdWrapper.distributorRebate = cprod.Distributor_Rebate__c;
                        cdWrapper.growerRebateAllIn = cprod.Grower_Rebate_All_In__c;
                        cdWrapper.IPP = cprod.IPP__c;
                        cdWrapper.proposedListPrice = cprod.Proposed_List_Price_Unit__c;
                        cdWrapper.proposedPaymentTerm = cprod.Proposed_Payment_Term__c;
                        cdWrapper.PLN = cprod.PLN__c;
                        cdWrapper.reatilerRebateAllIn = cprod.Retailer_Rebate_All_In__c;
                        cdList.add(cdWrapper);
                    }
                }
            }
        }
        CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapperNAM = CalculateMarkettingYearHelper.calculateYearWithoutVisibility('3100');
        Integer myearNAM = mktYearWrapperNAM.firstMarketingYear;
        Date startDateNAM = mktYearWrapperNAM.firstMarketingYearStartDate;
        Date endDateNAM = mktYearWrapperNAM.firstMarketingYearEndDate;
        
        CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapperCAD = CalculateMarkettingYearHelper.calculateYearWithoutVisibility('3710');
        Integer myearCAD= mktYearWrapperCAD.firstMarketingYear;
        Date startDateCAD = mktYearWrapperCAD.firstMarketingYearStartDate;
        Date endDateCAD = mktYearWrapperCAD.firstMarketingYearEndDate;
        
        List<String> SalesOrgCodeList = new List<String>{'3100','3710'};
            List<PriceBookMaster__c> pbmListNAM = [SELECT Id, Name, EndDate__c,Division__r.Division_Code__c,Division__c, SKUCode__c,SKUCode__r.SKU_Code__c,SKUCode__r.Name,sales_org__c,Sales_Org__r.Sales_Org_Code__c, StartDate__c,
                                                   Price__c,DistributorCustomerCode__c,Distributor_Custom_Incentive__c,Grower_Incentive__c,IPP__c, MaxPrice__c,Pmnt_Term__c, PLN__c, Off_Invoice_Discount__c, Retailer_Incentive__c
                                                   FROM PriceBookMaster__c where Sales_Org__r.Sales_Org_Code__c ='3100' 
                                                   and StartDate__c>=:startDateNAM and EndDate__c<=:endDateNAM and SKUCode__c IN:skuIdList];
        
        List<PriceBookMaster__c> pbmListCAD = [SELECT Id, Name, EndDate__c,Division__r.Division_Code__c,Division__c, SKUCode__c,SKUCode__r.SKU_Code__c,SKUCode__r.Name,sales_org__c,Sales_Org__r.Sales_Org_Code__c, startdate__c,
                                               Price__c,DistributorCustomerCode__c,Distributor_Custom_Incentive__c,Grower_Incentive__c,IPP__c, MaxPrice__c,Pmnt_Term__c, PLN__c, Off_Invoice_Discount__c, Retailer_Incentive__c
                                               FROM PriceBookMaster__c where Sales_Org__r.Sales_Org_Code__c ='3710' 
                                               and startdate__c>=:startDateCAD and EndDate__c<=:endDateCAD and SKUCode__c IN:skuIdList];
        
        Map<String,PriceBookMaster__c> pbmNAMMap =new map<String,PriceBookMaster__c>();
        for(PriceBookMaster__c pm:pbmListNAM){
            pbmNAMMap.put(pm.SKUCode__c+'-'+pm.DistributorCustomerCode__c+'-'+pm.Division__r.Division_Code__c,pm);
        }
        Map<String,PriceBookMaster__c> pbmCADMap =new map<String,PriceBookMaster__c>();
        for(PriceBookMaster__c pm:pbmListCAD){
            pbmCADMap.put(pm.SKUCode__c+'-'+pm.DistributorCustomerCode__c+'-'+pm.Division__r.Division_Code__c,pm);
        }
        List<PriceBookMaster__c> pbmListToUpdate = new List<PriceBookMaster__c>();
        for(CaseDetailsWrapper caseDet : cdList){
            if(caseDet.salesOrg == '3100' && pbmNAMMap.containsKey(caseDet.sku+'-'+caseDet.account+'-'+caseDet.division)){
                Date todate = system.today();
                PriceBookMaster__c newPBM = new PriceBookMaster__c();
                PriceBookMaster__c pbmToUpdate = pbmNAMMap.get(caseDet.sku+'-'+caseDet.account+'-'+caseDet.division);
                if((pbmToUpdate.StartDate__c<= todate && todate <= pbmToUpdate.EndDate__c) && 
                   (
                       (pbmToUpdate.StartDate__c<= caseDet.startDate && caseDet.startDate <= pbmToUpdate.EndDate__c ) || 
                       (pbmToUpdate.StartDate__c<= caseDet.endDate && caseDet.endDate <= pbmToUpdate.EndDate__c ) || 
                       (caseDet.startDate < pbmToUpdate.StartDate__c && caseDet.endDate > pbmToUpdate.EndDate__c )
                   )
                  ){
                      pbmToUpdate = pbmUpdate(caseDet,pbmToUpdate);
                      newPBM.EndDate__c = pbmToUpdate.EndDate__c;
                      pbmToUpdate.EndDate__c = todate;
                      newPBM = pbmUpdate(caseDet,newPBM);
                      newPBM.StartDate__c = todate+1;
                      newPBM.Sales_Org__c = caseDet.salesOrgId;
                      newPBM.DistributorCustomerCode__c = caseDet.account;
                      newPBM.SKUCode__c = caseDet.sku;
                      newPBM.Division__c = caseDet.divisionId;
                      Datetime dt = Datetime.newInstance(newPBM.StartDate__c.year(), newPBM.StartDate__c.month(),newPBM.StartDate__c.day());
                      String dateString = dt.format('dd-MM-yyyy');
                      newPBM.CompositeKey__c = dateString+caseDet.division+caseDet.salesOrg+caseDet.skuCode+caseDet.sapCode;
                      pbmListToUpdate.add(pbmToUpdate);
                      pbmListToUpdate.add(newPBM);
                  }
                else if(
                    (pbmToUpdate.StartDate__c<= todate && todate <= pbmToUpdate.EndDate__c) && 
                    (caseDet.startDate > pbmToUpdate.EndDate__c)
                ){
                    newPBM = pbmUpdate(caseDet,newPBM);
                    newPBM.StartDate__c = caseDet.startDate;
                    newPBM.EndDate__c = caseDet.endDate;
                    newPBM.Sales_Org__c = caseDet.salesOrgId;
                    newPBM.DistributorCustomerCode__c = caseDet.account;
                    newPBM.SKUCode__c = caseDet.sku;
                    newPBM.Division__c = caseDet.divisionId;
                    Datetime dt = Datetime.newInstance(newPBM.StartDate__c.year(), newPBM.StartDate__c.month(),newPBM.StartDate__c.day());
                    String dateString = dt.format('dd-MM-yyyy');
                    newPBM.CompositeKey__c = dateString+caseDet.division+caseDet.salesOrg+caseDet.skuCode+caseDet.sapCode;
                    pbmListToUpdate.add(newPBM);
                }
                
            }
            else if(caseDet.salesOrg == '3710' && pbmCADMap.containsKey(caseDet.sku+'-'+caseDet.account+'-'+caseDet.division)){
                Date todate = system.today();
                PriceBookMaster__c newPBM = new PriceBookMaster__c();
                PriceBookMaster__c pbmToUpdate = pbmCADMap.get(caseDet.sku+'-'+caseDet.account+'-'+caseDet.division);
                if((pbmToUpdate.StartDate__c<= todate && todate <= pbmToUpdate.EndDate__c) && 
                   (
                       (pbmToUpdate.StartDate__c<= caseDet.startDate && caseDet.startDate <= pbmToUpdate.EndDate__c ) || 
                       (pbmToUpdate.StartDate__c<= caseDet.endDate && caseDet.endDate <= pbmToUpdate.EndDate__c ) || 
                       (caseDet.startDate < pbmToUpdate.StartDate__c && caseDet.endDate > pbmToUpdate.EndDate__c )
                   )
                  ){
                      pbmToUpdate = pbmUpdate(caseDet,pbmToUpdate);
                      pbmToUpdate.EndDate__c = todate;
                      newPBM = pbmUpdate(caseDet,newPBM);
                      newPBM.StartDate__c = todate+1;
                      newPBM.EndDate__c = caseDet.endDate;
                      newPBM.Sales_Org__c = caseDet.salesOrgId;
                      newPBM.DistributorCustomerCode__c = caseDet.account;
                      newPBM.SKUCode__c = caseDet.sku;
                      newPBM.Division__c = caseDet.divisionId;
                      Datetime dt = Datetime.newInstance(newPBM.StartDate__c.year(), newPBM.StartDate__c.month(),newPBM.StartDate__c.day());
                      String dateString = dt.format('dd-MM-yyyy');
                      newPBM.CompositeKey__c = dateString+caseDet.division+caseDet.salesOrg+caseDet.skuCode+caseDet.sapCode;
                      pbmListToUpdate.add(pbmToUpdate);
                      pbmListToUpdate.add(newPBM);
                  }
                else if(
                    (pbmToUpdate.StartDate__c<= todate && todate <= pbmToUpdate.EndDate__c) && 
                    (caseDet.startDate > pbmToUpdate.EndDate__c)
                ){
                    newPBM = pbmUpdate(caseDet,newPBM);
                    newPBM.StartDate__c = caseDet.startDate;
                    newPBM.EndDate__c = caseDet.endDate;
                    newPBM.Sales_Org__c = caseDet.salesOrgId;
                    newPBM.DistributorCustomerCode__c = caseDet.account;
                    newPBM.SKUCode__c = caseDet.sku;
                    newPBM.Division__c = caseDet.divisionId;
                    Datetime dt = Datetime.newInstance(newPBM.StartDate__c.year(), newPBM.StartDate__c.month(),newPBM.StartDate__c.day());
                    String dateString = dt.format('dd-MM-yyyy');
                    newPBM.CompositeKey__c = dateString+caseDet.division+caseDet.salesOrg+caseDet.skuCode+caseDet.sapCode;
                    pbmListToUpdate.add(newPBM);
                }
            }
             else if(
                 	(caseDet.salesOrg == '3710' || caseDet.salesOrg == '3100') && 
                 	(!pbmCADMap.containsKey(caseDet.sku+'-'+caseDet.account+'-'+caseDet.division) && !pbmNAMMap.containsKey(caseDet.sku+'-'+caseDet.account+'-'+caseDet.division))
             ){
                Date todate = system.today();
                PriceBookMaster__c newPBM = new PriceBookMaster__c();
                if(todate >= caseDet.startDate){
                      newPBM = pbmUpdate(caseDet,newPBM);
                      newPBM.StartDate__c = todate+1;
                      newPBM.EndDate__c = caseDet.endDate;
                      newPBM.Sales_Org__c = caseDet.salesOrgId;
                      newPBM.DistributorCustomerCode__c = caseDet.account;
                      newPBM.SKUCode__c = caseDet.sku;
                      newPBM.Division__c = caseDet.divisionId;
                      Datetime dt = Datetime.newInstance(newPBM.StartDate__c.year(), newPBM.StartDate__c.month(),newPBM.StartDate__c.day());
                      String dateString = dt.format('dd-MM-yyyy');
                      newPBM.CompositeKey__c = dateString+caseDet.division+caseDet.salesOrg+caseDet.skuCode+caseDet.sapCode;
                      pbmListToUpdate.add(newPBM);
                  }
                else if(todate < caseDet.startDate){
                    newPBM = pbmUpdate(caseDet,newPBM);
                    newPBM.StartDate__c = caseDet.startDate;
                    newPBM.EndDate__c = caseDet.endDate;
                    newPBM.Sales_Org__c = caseDet.salesOrgId;
                    newPBM.DistributorCustomerCode__c = caseDet.account;
                    newPBM.SKUCode__c = caseDet.sku;
                    newPBM.Division__c = caseDet.divisionId;
                    Datetime dt = Datetime.newInstance(newPBM.StartDate__c.year(), newPBM.StartDate__c.month(),newPBM.StartDate__c.day());
                    String dateString = dt.format('dd-MM-yyyy');
                    newPBM.CompositeKey__c = dateString+caseDet.division+caseDet.salesOrg+caseDet.skuCode+caseDet.sapCode;
                    pbmListToUpdate.add(newPBM);
                }
            }
            
        }
        upsert pbmListToUpdate;
        //Logic to update CSR records price book ends
        
        return errorList;
    }
    
    public static PriceBookMaster__c pbmUpdate(CaseDetailsWrapper caseDet,PriceBookMaster__c pbm){
        pbm.Distributor_Custom_Incentive__c = caseDet.distributorRebate;
        pbm.Grower_Incentive__c = caseDet.growerRebateAllIn;
        pbm.IPP__c = caseDet.IPP;
        pbm.Price__c = caseDet.proposedListPrice;
        pbm.Pmnt_Term__c = caseDet.proposedPaymentTerm;
        pbm.PLN__c = caseDet.PLN;
        pbm.Retailer_Incentive__c = caseDet.reatilerRebateAllIn;
        return pbm;
    }
    public class errorWrapper {
        public string casenumber;
        public String sapdocno;
        public String reason;    
    }
    
    public class CaseDetailsWrapper{
        public string sapCode;
        public string distChannel;
        public string account;
        public String sku;
        public String skuCode;
        public String salesOrg;
        public String salesOrgId;
        public String division;
        public String divisionId;
        public Date startDate; 
        public Date endDate;
        public Decimal distributorRebate;
        public Decimal growerRebateAllIn;
        public Boolean IPP;
        public Decimal proposedListPrice;
        public String proposedPaymentTerm; 
        public Decimal PLN;
        public Decimal reatilerRebateAllIn;
    }
}