public with sharing class Grz_AdminPanelVfController {
    public list<Grz_AdminPanel.ResultStored> ResultStored{get;set;}
    public Map<String,map<String,List<Grz_AdminPanel.ResultStored>>> finalPdgMap{get;set;}
    public Grz_AdminPanel.PdfHeaderDetails HeadersPdf{get;set;}
    public String DateToday{get;set;}
    public Map<String,Integer> CombineRow{get;set;}
    public String pdfFooter{get;set;}
    public Map<String,String> ProdDesBraces{get;set;}
    public Map<String,String> BrandProdMap{get;set;}
    public class My2Exception extends Exception {}
    public void Grz_AdminPanelData() {
        String sbu='';
        String SelectedZones='';
        String startDate='';
        String endDate='';
        String monthSel='';
        String yearSel='';
        String CustomerType='';
        String StartDateFiscalYear = '';
        if(Test.isRunningTest()){
            list<sbu__c> s = [select id,name from sbu__c];
            sbu=s[0].name;
            SelectedZones='Punjab';
            startDate=String.valueOf(date.today());
            endDate=String.valueOf(date.today());
            CustomerType='49';
            List<Period> fiscalYearList = [Select Type, StartDate, EndDate, Number, FiscalYearSettings.PeriodId From Period Where Type='Year' and startDate <= TODAY and endDate >= TODAY limit 1];
            Integer curFiscYear = fiscalYearList[0].StartDate.year();
            StartDateFiscalYear = String.valueOf(curFiscYear)+'-04-01';
        }
        else{
            sbu = ApexPages.currentPage().getParameters().get('sbu');
            SelectedZones = ApexPages.currentPage().getParameters().get('SelectedZones');
            if(SelectedZones.contains('rep_()_rep')){
                SelectedZones = SelectedZones.replaceAll('rep_\\(\\)_rep', '&');
            }
            startDate = ApexPages.currentPage().getParameters().get('startDate');
            endDate = ApexPages.currentPage().getParameters().get('endDate');
            CustomerType = ApexPages.currentPage().getParameters().get('Customer');
            StartDateFiscalYear = ApexPages.currentPage().getParameters().get('StartDateFiscalYear');
        }
        String SignatureDocumentId;
        List<Document> Doc = [select id from Document where DeveloperName = 'Admin_Panel_PDF_Signature' limit 1];
        if(Doc.size() > 0){
            SignatureDocumentId = Doc[0].id;
        }
        Grz_AdminPanel.FinalRes wrapData = Grz_AdminPanel.GetPriceBook(SelectedZones, StartDateFiscalYear, endDate,'','',true,CustomerType,sbu);
        Grz_AdminPanel.PdfHeaderDetails Header = Grz_AdminPanel.HeaderDet(sbu,SelectedZones, startDate, endDate,CustomerType);
      
        ResultStored = wrapData.Resuts;
        
        set<String> product = new set<String>();
        set<String> productIndication = new set<String>();
        Map<String,String> Description = new Map<String,String> ();
        Map<String,String> BrandProdMapNew= new Map<String,String> ();
        for(Grz_AdminPanel.ResultStored Mapping : ResultStored) {
            if(Mapping.ProductName != null  && (!Description.containsKey(Mapping.ProductName))){
                Description.put(Mapping.ProductName+'&*&'+Mapping.ProductIndicationType+'&*&'+Mapping.ProdectDescriptionFooter, Mapping.ProdectDescriptionFooter);
                BrandProdMapNew.put(Mapping.ProductName+'&*&'+Mapping.ProductIndicationType+'&*&'+Mapping.ProdectDescriptionFooter,Mapping.ProductName);
            }
            product.add(Mapping.ProductName+'&*&'+Mapping.ProductIndicationType+'&*&'+Mapping.ProdectDescriptionFooter);
            if(Mapping.ProductIndicationType != null ){
                productIndication.add(Mapping.ProductIndicationType);
            }
        }
        ProdDesBraces = Description;
        BrandProdMap=BrandProdMapNew;
        product.remove(null);
        productIndication.remove(null);
        
        Map<String,set<String>> NameInd = new Map<String,set<String>>();
        for(String ProductInd : productIndication){
            set<String> ll = new set<String>();
            for(Grz_AdminPanel.ResultStored ch : ResultStored){
                if(ch.ProductIndicationType != null || ProductInd != null){
                    if(ProductInd.equals(ch.ProductIndicationType)){
                        ll.add(ch.ProductName+'&*&'+ch.ProductIndicationType+'&*&'+ch.ProdectDescriptionFooter);
                    }}
            }
            NameInd.put(ProductInd, ll);
        }
        
        
        Map<String, List<Grz_AdminPanel.ResultStored>> MapListRecWithName = new Map<String, List<Grz_AdminPanel.ResultStored>>();
        Map<String,Integer> Rowspan = new Map<String,Integer>();
        for(String Products : product){
            String brandName=Products.split('&*&')[0];
            
            String portfolioName=Products.split('&*&')[2];
            String techName=Products.split('&*&')[4];
            
            List<Grz_AdminPanel.ResultStored> NameRes = new List<Grz_AdminPanel.ResultStored>();
            for(Grz_AdminPanel.ResultStored ch : ResultStored){
                if(ch.ProductName != null){
                    if(brandName.equals(ch.ProductName) && portfolioName.equals(ch.ProductIndicationType) && techName.equals(ch.ProdectDescriptionFooter)){
                        NameRes.add(ch);
                    }
                }
            }
            
            Rowspan.put(Products , NameRes.size());
            MapListRecWithName.put(Products ,NameRes);
            
        }
        
        CombineRow= Rowspan;
      
        Map<String,map<String,List<Grz_AdminPanel.ResultStored>>> fnl = new map<String,Map<String,List<Grz_AdminPanel.ResultStored>>>();
        for(String pp : NameInd.keyset()){
            set<String> PortfolioProduct = NameInd.get(pp);
            Map<String,List<Grz_AdminPanel.ResultStored>> dumy = new Map<String,List<Grz_AdminPanel.ResultStored>>();
            for(String m : NameInd.get(pp)){
                for(String ss: MapListRecWithName.keySet()){
                    if(ss.equals(m) && PortfolioProduct.contains(ss)){
                        dumy.put(ss, MapListRecWithName.get(ss));
                    }
                }
            }
            fnl.put(pp,dumy);
        }
        
        finalPdgMap = fnl;
        HeadersPdf = Header;
        DateToday = Datetime.now().format('MMMM dd,yyyy');
        List<Period> fiscalYearList = [Select Type, StartDate, EndDate, Number, FiscalYearSettings.PeriodId From Period Where Type='Year' and startDate <= TODAY and endDate >= TODAY limit 1];
        
        List<EmailTemplate> p =[Select Id,body,HtmlValue from EmailTemplate where developername = 'Admin_Panel_Footer_Details' limit 1];
        Integer Fy = fiscalYearList[0].StartDate.year();
        if(p.size() > 0){
            pdfFooter=p[0].HtmlValue.replace('[FiscalYear]',String.valueOf(Fy)+'-'+String.valueOf(Fy+1).substring(2,4)).replace('[SignatureId]',SignatureDocumentId);
        }
        
    }
    
    
    @AuraEnabled
    public static void SendMail(String Url,String Zones, String StartDate, String EndDate, String Sbu,String Circular,String CircularDetail,String CirForMail,Map<String,String> DistEmails){
       PageReference pageRef = new PageReference(Url);
        Blob body;
        
        try {
            if(Test.isRunningTest()){
                body=BLOB.valueOf('test');
            }
            else{
                body = pageRef.getContent();
            }
        }catch (Exception e) {
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.');
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            User cUserInfo= grz_SapIntegration.GetUserInfo();
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.ClassName__c = className;
            storeError.MethodName__c = methodName;
            storeError.Exception_Message__c = e.getMessage();
            storeError.Account__c = cUserInfo.accountId;
            insert storeError;
        }
        
        EmailTemplate p =[Select Id,body,HtmlValue,subject from EmailTemplate where developername =: 'Admin_Panel_PDF_Template' limit 1];
        String Html = p.HtmlValue;
        Html = Html.replace('[EmailBody]', CirForMail);
        
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('application/pdf');
        attach.setFileName('Prices_Statement.pdf');
        attach.setInline(false);
        attach.Body = body;
        String fromAdressId;
        List<OrgWideEmailAddress> owa = [select id, DisplayName, Address from OrgWideEmailAddress where displayname =: 'Sales Excellence' ];
        if(!owa.isEmpty())
        fromAdressId = owa[0].id;
        try{
            Admin_Panel__c AP = new Admin_Panel__c();
            AP.Name = Circular;
            AP.Circular_Detail__c= CircularDetail;
            AP.sbu__c = Sbu;
            AP.Email_Sent__c = true;
            AP.Start_Date__c = date.valueOf(StartDate);
            AP.End_Date__c = date.valueOf(EndDate);
            AP.Zones__c = Zones;
            AP.Send_Date__c = date.today();
            insert AP;
            ContentVersion cv = new ContentVersion();
            cv.Title = 'Prices Statement';
            cv.PathOnClient = 'Prices_Statement.pdf';
            cv.VersionData = body;
            Insert cv;
            Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = AP.Id;
            cdl.ContentDocumentId = conDocId;
            cdl.shareType = 'I';
            cdl.Visibility = 'AllUsers';
            Insert cdl;
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setOrgWideEmailAddressId(fromAdressId);
            List<String> toList=new List<String>();
            List<String> ErrorList=new List<String>();
            for(String s:DistEmails.keyset()){
                String emailVar = DistEmails.get(s);
                if(emailVar == 'null' || emailVar == ''){
                    ErrorList.add(s+'-'+emailVar);
                }
                else if(checkEmail(emailVar)==true){
                    toList.add(emailVar);
                }else{
                    ErrorList.add(s+'-'+emailVar);
                }
            }
            if(ErrorList.size()>0){
                User cUserInfo= grz_SapIntegration.GetUserInfo();
                Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
                storeError.ClassName__c = 'Grz_AdminPanelVfController';
                storeError.MethodName__c = 'SendMail';
                storeError.Exception_Message__c = 'Account With Invalid Emails';
                storeError.ErrorEmails__c = ErrorList.toString();
                storeError.Account__c = cUserInfo.accountId;
                insert storeError;
            }
            mail.setHtmlBody(Html);
            mail.setToAddresses(toList);
            mail.setSubject(p.subject);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {mail};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages,false);
            
        }catch (Exception e) {
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.');
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            User cUserInfo= grz_SapIntegration.GetUserInfo();
            Partner_Portal_Logs__c storeError = new Partner_Portal_Logs__c();
            storeError.ClassName__c = className;
            storeError.MethodName__c = methodName;
            storeError.Exception_Message__c = e.getMessage();
            storeError.Account__c = cUserInfo.accountId;
            storeError.Error_Message_Code__C = CircularDetail;
            insert storeError;
        }
        
    }
    
    public class PdfHeaderDetails {
        @auraenabled public String TodayMonth {get; set;}
        @auraenabled public String ZonalCode {get; set;}
        @auraenabled public String Sbu {get; set;}
        @auraenabled public String TodayDate {get; set;}
        @auraenabled public String Zone {get; set;}
        @auraenabled public String StartDate {get; set;}
        @auraenabled public String EndDate {get; set;}
        
    }
    
    public static Boolean checkEmail (String semail) {
        String InputString = semail;
        String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
        Pattern MyPattern = Pattern.compile(emailRegex);
        
        Matcher MyMatcher = MyPattern.matcher(InputString);
        
        if (!MyMatcher.matches()) {
            return FALSE;
        }
        else {
            return TRUE;
        }
    }
    
}