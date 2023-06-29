public without sharing class AccountLedger {

     
    public WrapperAccountLedgerMain WrapALMain{get;set;}
    public String fromDate{get;set;}
    public String toDate{get;set;}
    public Date currentDate{get;set;}
    public String rDate{get;set;}
    public String fDate{get;set;}
    public String tDate{get;set;}
    public List<Community_Configuration__c> ccList{get;set;}
    //public String resUrl {get;set;}

    public AccountLedger(){
    
        WrapALMain = new WrapperAccountLedgerMain();
        
        List<WrapperAccountLedger> wrapALList=new List<WrapperAccountLedger>();
        String PostingDateFrom=ApexPages.CurrentPage().getParameters().get('DateFrom');
        String PostingDateTo=ApexPages.CurrentPage().getParameters().get('DateTo');
        String UserAccountId=ApexPages.CurrentPage().getParameters().get('AccId');
        String CurrentMonth=ApexPages.CurrentPage().getParameters().get('Month');
        String ReportDate=ApexPages.CurrentPage().getParameters().get('reportDate');
        String fromDate_pe=ApexPages.CurrentPage().getParameters().get('fDate');
        String toDate_pe=ApexPages.CurrentPage().getParameters().get('tDate');
        ccList = new List<Community_Configuration__c>();

        fromDate=PostingDateFrom;
        toDate=PostingDateTo;
        currentDate=system.Today();
        rDate=String.valueOf(system.Today().Day())+'/'+String.valueOf(system.Today().Month())+'/'+String.valueOf(system.Today().Year());
        fDate=PostingDateFrom.split('-')[2]+'/'+PostingDateFrom.split('-')[1]+'/'+PostingDateFrom.split('-')[0];
        tDate=PostingDateTo.split('-')[2]+'/'+PostingDateTo.split('-')[1]+'/'+PostingDateTo.split('-')[0];

        system.debug('PostingDateFrom-->'+PostingDateFrom);
        system.debug('PostingDateTo-->'+PostingDateTo);
        system.debug('UserAccountId-->'+UserAccountId);
        system.debug('CurrentMonth-->'+CurrentMonth);
        String query = '';
        Decimal totalDebit=0.00;
        Decimal totalcredit=0.00;
        Decimal OpeningBalance=0.00;
        Decimal RunningBalance=0.00;
        String RunningBalance1='';
        Decimal dummy_wCreditAmount=0.00;
        String recordId = '';
        String CommunityRole ='';
        String salesOrg ='';
        String countryName ='';
        String mValue='';

        Integer cMonth=Integer.valueOf(CurrentMonth);
        Map<Integer,String>MonthValueMap=new Map<Integer,String>();
       MonthValueMap.put(4,'012');
       MonthValueMap.put(5,'001');
       MonthValueMap.put(6,'002');
       MonthValueMap.put(7,'003');
       MonthValueMap.put(8,'004');
       MonthValueMap.put(9,'005');
       MonthValueMap.put(10,'006');
       MonthValueMap.put(11,'007');
       MonthValueMap.put(12,'008');
       MonthValueMap.put(1,'009');
       MonthValueMap.put(2,'010');
       MonthValueMap.put(3,'011');

        // Integer currentMonthVal=MonthValueMap.get(cMonth);
        // mValue=String.valueOf(currentMonthVal-1);
        mValue=MonthValueMap.get(cMonth);

        List<Account> customerList=new List<Account>();
        customerList=[SELECT Id, Name, SAP_Code__c, CurrencyIsoCode FROM Account where id=:UserAccountId];
        for(Account acc:customerList){
            WrapALMain.mCustomerName=acc.Name;
            WrapALMain.mCustomerCode=acc.SAP_Code__c;
            WrapALMain.mCurrency=acc.CurrencyIsoCode;
        }
       

        user u = [select id, Name, contactId, Country, accountId, UserName, Community_Role__c, TimeZoneSidKey, Account.Sales_Org_Code__c, Account.Sales_Org_Country__c from User where id = : UserInfo.getUserId()];
        recordId = u.AccountId;
        salesOrg = u.Account.Sales_Org_Code__c;
        //countryName =u.Account.Sales_Org_Country__c;
        countryName =u.Country;
        CommunityRole= u.Community_Role__c;

        
        /*List<Community_Configuration__c> forCheckList = new List<Community_Configuration__c>();
        
        forCheckList = [Select Id from Community_Configuration__c
                        WHERE Distributor_Name__c=:recordId];
        
        if(forCheckList.size()>0){*/
            System.debug('Inside Account record');
            ccList =[Select Id,Name,Company_Name__c,Company_Address__c,Company_Contact_Number__c,
                        Company_Logo__c
                        FROM Community_Configuration__c
                        Where (Distributor_Name__c =:recordId OR Visible_To_All__c = true) 
                        AND RecordType.Name='General Setting'
                        AND Community_User_Role__c =:CommunityRole 
                        AND Active__c=true 
                        AND Country__c=:countryName];
        /*}else{
            System.debug('record not found in community configuartion for Account ');
            ccList =[Select Id,Name,Company_Name__c,Company_Address__c,Company_Contact_Number__c,
                        Company_Logo__c
                        FROM Community_Configuration__c
                        Where Sales_Org__c =:salesOrg
                        AND Country__c=:countryName
                        AND RecordType.Name='General Setting'
                        AND Community_User_Role__c =:CommunityRole
                        AND Active__c=true ];
        }*/
        
        
        //resUrl = accountImageURL(ccList[0].Company_Logo__c);
        
        //System.debug('ccList EEEE resUrl '+resUrl);

        Community_Configuration__c comConfig=new Community_Configuration__c();
        if(!test.isRunningTest()){
            comConfig =[SELECT id,Show_Running_Balance__c FROM Community_Configuration__c WHERE Country__c =:u.Country AND RecordType.Name='General Setting' AND Community_User_Role__c=:CommunityRole limit 1];
        }else{
            comConfig =[SELECT id,Show_Running_Balance__c FROM Community_Configuration__c limit 1];
        }

        List<Periodical_Closing_Balance__c>pcbList=new List<Periodical_Closing_Balance__c>();
       pcbList=[SELECT Name, Id, Month__c, Closing_Balance__c, Credit__c, Debit__c, Year__c FROM Periodical_Closing_Balance__c where Month__c=:mValue AND Distributor__c=:UserAccountId limit 1];
       for(Periodical_Closing_Balance__c pcb:pcbList){
        WrapALMain.mOpeningBalance=pcb.Closing_Balance__c.format();
        OpeningBalance=pcb.Closing_Balance__c;
        system.debug('pcb.Closing_Balance__c '+pcb.Closing_Balance__c);
       }

       List<CustomerTransaction__c> ctList=new List<CustomerTransaction__c>();
        if(!String.isBlank(PostingDateFrom) && !String.isBlank(PostingDateTo)){ 
            query = 'select Id,DocType__c,DocNumber__c,PostingDate__c,Reference__c,Head_Text__c,CurrencyIsoCode,Amount__c,Status__c from CustomerTransaction__c where Customer__c= \''+UserAccountId+'\' AND PostingDate__c >= '+PostingDateFrom+' AND PostingDate__c <= '+PostingDateTo+' order by PostingDate__c asc';
            ctList = Database.query(query);
        }
        RunningBalance=OpeningBalance;
        RunningBalance1=String.valueOf(RunningBalance);
        system.debug('rBal-->'+RunningBalance1);

        WrapperAccountLedger wal=new WrapperAccountLedger();
        if(RunningBalance1.contains('-')){
            wal.wDocHeaderText=System.Label.Opening_Balance;
            wal.wCreditAmount=String.valueOf(RunningBalance.format());
        }else{
            wal.wDocHeaderText=System.Label.Opening_Balance;
            wal.wDebitAmount=String.valueOf(RunningBalance.format());
        }
        wrapALList.add(wal);

        for(CustomerTransaction__c ct:ctList){
            WrapperAccountLedger WrapAL = new WrapperAccountLedger();
            WrapAL.wPostDate=String.valueOf(ct.PostingDate__c);
            WrapAL.wDocType=ct.DocType__c;
            WrapAL.wDocNo=ct.DocNumber__c;
            WrapAL.wReference=ct.Reference__c;
            WrapAL.wDocHeaderText=ct.Head_Text__c;
            
            if(ct.Status__c=='S'){
                RunningBalance=RunningBalance+ct.Amount__c;
                WrapAL.wDebitAmount=ct.Amount__c.format();
                totalDebit=totalDebit+ct.Amount__c;
                WrapAL.wRunningBalance=RunningBalance.format();
            }else if(ct.Status__c=='H'){
                Decimal creAmt=ct.Amount__c;
                WrapAL.wCreditAmount=creAmt.format().remove('-');
                System.debug('Amt-->'+ct.Amount__c);
                RunningBalance=RunningBalance-math.abs(ct.Amount__c*(-1));
                totalcredit=totalcredit+math.abs(ct.Amount__c*(-1));
                WrapAL.wRunningBalance=RunningBalance.format().remove('-');
            }
            wrapALList.add(WrapAL);

        }
        WrapperAccountLedger wal1=new WrapperAccountLedger();
        if(RunningBalance1.contains('-')){
            wal1.wDocHeaderText=System.Label.Closing_Balance;
            wal1.wCreditAmount=String.valueOf(RunningBalance.format());
        }else{
            wal1.wDocHeaderText=System.Label.Closing_Balance;
            wal1.wDebitAmount=String.valueOf(RunningBalance.format());
        }
        wrapALList.add(wal1);

        WrapALMain.mTotalCreditAmount=math.abs(totalcredit).format();
        WrapALMain.mToalDebitAmount=totalDebit.format();
        WrapALMain.mToBalance=RunningBalance.format().remove('-');
        WrapALMain.mClosingBalance=RunningBalance.format();
        WrapALMain.showRunningBal=comConfig.Show_Running_Balance__c;
        WrapALMain.mWrapperAccountLedgerList=wrapALList;
    }


    @AuraEnabled(cacheable = true)
    public static List<user> fetchUser(){
        id userId = UserInfo.getUserId();
        System.debug(userId);
        List<user> u = new List<User>();
        u = [select id, Name, contactId, accountId, Country from User where id = : userId];
        return u;
    }

    @AuraEnabled(cacheable = true)
    public static List<Community_Url_Configuration__c> fetchURL(){
        
        List<Community_Url_Configuration__c> url = new List<Community_Url_Configuration__c>();
        url = [SELECT Id, Name, URL__c FROM Community_Url_Configuration__c WHERE  Name ='Distributors Community URL' Limit 1];
        return url;
    }

    @AuraEnabled(cacheable = true)
    public static List<Community_Configuration__c> fetchCommunityObj(){
        id userId = UserInfo.getUserId();
        System.debug(userId);
        List<Community_Configuration__c> comConfig = new List<Community_Configuration__c>();
        
        User u = [select id, Name, contactId, accountId,Country from User where id = : userId];

        comConfig =[SELECT id,Show_Running_Balance__c FROM Community_Configuration__c WHERE Country__c =:u.Country AND RecordType.Name='Account Summary' limit 1];
        return comConfig;
    }

    
    @AuraEnabled(cacheable = true)
    public static WrapperAccountLedgerMain getALData(String PostingDateFrom,String PostingDateTo,String uId,String currentMonth){
        System.debug('uId'+uId);
        System.debug('PostingDateFrom'+PostingDateFrom);
        System.debug('PostingDateTo'+PostingDateTo);
        String query = '';
        Integer cMonth=Integer.valueOf(currentMonth);
        System.debug('cMonth'+cMonth);
        Decimal totalDebit=0.00;
        Decimal totalcredit=0.00;
        Decimal OpeningBalance=0.00;
        Decimal RunningBalance=0.00;
        String RunningBalance1='';
        //Boolean showRuniingBalance=showRunningBal;
        String recordId = '';
        String CommunityRole ='';
        String salesOrg ='';
        String countryName ='';
        String mValue='';

        user u = [select id, Name, contactId, Country, accountId, UserName, Community_Role__c, TimeZoneSidKey, Account.Sales_Org_Code__c, Account.Sales_Org_Country__c from User where id = : UserInfo.getUserId()];
        recordId = u.AccountId;
        salesOrg = u.Account.Sales_Org_Code__c;
        //countryName =u.Account.Sales_Org_Country__c;
        countryName =u.Country;
        CommunityRole= u.Community_Role__c;

        List<Community_Configuration__c> ccList1 = new List<Community_Configuration__c>();
        List<Community_Configuration__c> forCheckList = new List<Community_Configuration__c>();
        
        /*forCheckList = [Select Id from Community_Configuration__c
                        WHERE Distributor_Name__c=:recordId];
        
        if(forCheckList.size()>0){*/
            System.debug('Inside Account record');
            ccList1 =[Select Id,Name,Company_Name__c,Company_Address__c,Company_Contact_Number__c,
                        Company_Logo__c
                        FROM Community_Configuration__c
                        Where (Distributor_Name__c =:recordId OR Visible_To_All__c = true) 
                        AND RecordType.Name='General Setting'
                        AND Community_User_Role__c =:CommunityRole 
                        AND Active__c=true 
                        AND Country__c=:countryName];
        /*}else{
            System.debug('record not found in community configuartion for Account ');
            ccList1 =[Select Id,Name,Company_Name__c,Company_Address__c,Company_Contact_Number__c,
                     Company_Logo__c
                     FROM Community_Configuration__c
                     Where Sales_Org__c =:salesOrg
                     AND Country__c=:countryName
                     AND RecordType.Name='General Setting'
                     AND Community_User_Role__c =:CommunityRole
                     AND Active__c=true ];
        }*/
        
        
        // resUrl = accountImageURL(ccList[0].Company_Logo__c);
        
        // System.debug('ccList EEEE resUrl '+resUrl);

        Community_Configuration__c comConfig=new Community_Configuration__c();
        if(!test.isRunningTest()){
            comConfig =[SELECT id,Show_Running_Balance__c FROM Community_Configuration__c WHERE Country__c =:u.Country AND RecordType.Name='General Setting' AND Community_User_Role__c=:CommunityRole limit 1];
        }else{
            comConfig =[SELECT id,Show_Running_Balance__c FROM Community_Configuration__c limit 1];
        }

        WrapperAccountLedgerMain walObj=new WrapperAccountLedgerMain();
       Map<Integer,String>MonthValueMap=new Map<Integer,String>();
       MonthValueMap.put(4,'012');
       MonthValueMap.put(5,'001');
       MonthValueMap.put(6,'002');
       MonthValueMap.put(7,'003');
       MonthValueMap.put(8,'004');
       MonthValueMap.put(9,'005');
       MonthValueMap.put(10,'006');
       MonthValueMap.put(11,'007');
       MonthValueMap.put(12,'008');
       MonthValueMap.put(1,'009');
       MonthValueMap.put(2,'010');
       MonthValueMap.put(3,'011');

       mValue=MonthValueMap.get(cMonth);
       /*System.debug('currentMonthVal'+currentMonthVal);
       mValue=String.valueOf(currentMonthVal-1);*/

       List<Account> customerList=new List<Account>();
       customerList=[SELECT Id, Name, SAP_Code__c, CurrencyIsoCode FROM Account where id=:uId];
       for(Account acc:customerList){
        walObj.mCustomerName=acc.Name;
        walObj.mCustomerCode=acc.SAP_Code__c;
        walObj.mCurrency=acc.CurrencyIsoCode;
       }
       
        List<WrapperAccountLedger>walList=new List<WrapperAccountLedger>();

       List<Periodical_Closing_Balance__c>pcbList=new List<Periodical_Closing_Balance__c>();
       pcbList=[SELECT Name, Id, Month__c, Closing_Balance__c, Credit__c, Debit__c, Year__c FROM Periodical_Closing_Balance__c where Month__c=:mValue AND Distributor__c=:uId limit 1];
       
       if(pcbList.size() != 0){
        for(Periodical_Closing_Balance__c pcb:pcbList){
            walObj.mOpeningBalance=pcb.Closing_Balance__c.format();
            OpeningBalance=pcb.Closing_Balance__c;
            system.debug('pcb.Closing_Balance__c '+pcb.Closing_Balance__c);
           }
       }else{
        walObj.mOpeningBalance='0';
        OpeningBalance=0;
       }

       List<CustomerTransaction__c> ctList=new List<CustomerTransaction__c>();
        if(!String.isBlank(PostingDateFrom) && !String.isBlank(PostingDateTo)){ 
            query = 'select Id,DocType__c,DocNumber__c,PostingDate__c,Reference__c,Head_Text__c,CurrencyIsoCode,Amount__c,Status__c from CustomerTransaction__c where Customer__c= \''+uId+'\' AND PostingDate__c >= '+PostingDateFrom+' AND PostingDate__c <= '+PostingDateTo+' order by PostingDate__c asc';
            ctList = Database.query(query);
        }
        RunningBalance=OpeningBalance;
        RunningBalance1=String.valueOf(RunningBalance);
        system.debug('rBal-->'+RunningBalance1);
        /*new*/
        WrapperAccountLedger wal=new WrapperAccountLedger();
        if(RunningBalance1.contains('-')){
            wal.wDocHeaderText=System.Label.Opening_Balance;
            wal.wCreditAmount=String.valueOf(RunningBalance.format());
        }else{
            wal.wDocHeaderText=System.Label.Opening_Balance;
            wal.wDebitAmount=String.valueOf(RunningBalance.format());
        }
        walList.add(wal);
        
        for(CustomerTransaction__c ct:ctList){
            WrapperAccountLedger wrapperObj=new WrapperAccountLedger();
            wrapperObj.wPostDate=String.valueOf(ct.PostingDate__c);
            wrapperObj.wDocType=ct.DocType__c;
            wrapperObj.wDocNo=ct.DocNumber__c;
            wrapperObj.wReference=ct.Reference__c;
            wrapperObj.wDocHeaderText=ct.Head_Text__c;
            
            if(ct.Status__c=='S'){
                RunningBalance=RunningBalance+ct.Amount__c;
                wrapperObj.wDebitAmount=ct.Amount__c.format();
                totalDebit=totalDebit+ct.Amount__c;
                wrapperObj.wRunningBalance=RunningBalance.format();
            }else if(ct.Status__c=='H'){
                Decimal creAmt=ct.Amount__c;
                System.debug('Amt-->'+ct.Amount__c);
                wrapperObj.wCreditAmount=creAmt.format().remove('-');
                RunningBalance=RunningBalance-math.abs(ct.Amount__c*(-1));
                totalcredit=totalcredit+math.abs(ct.Amount__c*(-1));
                wrapperObj.wRunningBalance=RunningBalance.format().remove('-');
            }
            walList.add(wrapperObj);

        }
        /*new*/
        WrapperAccountLedger wal1=new WrapperAccountLedger();
        if(RunningBalance1.contains('-')){
            wal1.wDocHeaderText=System.Label.Closing_Balance;
            wal1.wCreditAmount=String.valueOf(RunningBalance.format());
        }else{
            wal1.wDocHeaderText=System.Label.Closing_Balance;
            wal1.wDebitAmount=String.valueOf(RunningBalance.format());
        }
        walList.add(wal1);

        walObj.mTotalCreditAmount=math.abs(totalcredit).format();
        walObj.mToalDebitAmount=totalDebit.format();
        walObj.mToBalance=RunningBalance.format().remove('-');
        walObj.mClosingBalance=RunningBalance.format();
        walObj.showRunningBal=comConfig.Show_Running_Balance__c;
        walObj.mWrapperAccountLedgerList=walList;
        System.debug('walObj'+walObj);
        return walObj;
    }

    public class WrapperAccountLedger{
            @AuraEnabled
            public String wPostDate{get;set;}
            @AuraEnabled
            public String wDocType{get;set;}
            @AuraEnabled
            public String wDocNo{get;set;}
            @AuraEnabled
            public String wReference{get;set;}
            @AuraEnabled
            public String wDocHeaderText{get;set;}
            @AuraEnabled
            public String wDebitAmount{get;set;}
            @AuraEnabled
            public String wCreditAmount{get;set;}
            @AuraEnabled
            public String wRunningBalance{get;set;}
            
    
            public WrapperAccountLedger()
            {
                wPostDate='';
                wDocType='';
                wDocNo='';
                wReference='';
                wDocHeaderText='';
                wDebitAmount='';
                wCreditAmount='';
                wRunningBalance='';
                
            }
        }

        public class WrapperAccountLedgerMain{
            @AuraEnabled
            public String mOpeningBalance{get;set;}
            @AuraEnabled
            public String mToBalance{get;set;}
            @AuraEnabled
            public String mClosingBalance{get;set;}
            @AuraEnabled
            public String mToalDebitAmount{get;set;}
            @AuraEnabled
            public String mTotalCreditAmount{get;set;}
            @AuraEnabled
            public List<WrapperAccountLedger> mWrapperAccountLedgerList{get;set;}
            @AuraEnabled
            public Boolean showRunningBal{get;set;}
            @AuraEnabled
            public String mCustomerName{get;set;}
            @AuraEnabled
            public String mCustomerCode{get;set;}
            @AuraEnabled
            public String mCurrency{get;set;}
            
            

            WrapperAccountLedgerMain(){
                mOpeningBalance='';
                mToBalance='';
                mClosingBalance='';
                mToalDebitAmount='';
                mTotalCreditAmount='';
                mWrapperAccountLedgerList=new List<WrapperAccountLedger>();
                showRunningBal=false;
                mCustomerName='';
                mCustomerCode='';
                mCurrency='';
            }
        } 
    
}