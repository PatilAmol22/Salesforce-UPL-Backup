public with sharing class AdminAccountKYCController {

    public transient Map<String,KYCWrapper> kycDetailsMap {get;set;}
    public Boolean showSpinner {get;set;}
    public String salesOrg {get;set;}
    public String sbu_Id {get;set;}
    public String zone_Id {get;set;}
    public String rgn_Id {get;set;}
    public String ter_Id {get;set;}
    public String isKyc_done {get;set;}
    public String Sales_Org {get;set;}
    public list<SBU__c> listSBU ;
    public list<Zone__c> listZone ;
    public list<Region__c> listRegion ;
    public list<Territory_Distributor__c> listTerritory {get;set;}
    public transient String kycSet{get;set;}
    public String kycId {get;set;} 
    public KYC__c KycObject {get;set;} 
    public Integer totCount ;

    public Integer green_min {get;set;}
    public Integer red_max {get;set;}
    public Integer yel_min {get;set;}
    public Integer yel_max {get;set;}
    public Integer panGreen_min {get;set;}
    public Integer panRed_max {get;set;}
    public Integer panYel_min {get;set;}
    public Integer panYel_max {get;set;}
    public Integer gstGreen_min {get;set;}
    public Integer gstRed_max {get;set;}
    public Integer gstYel_min {get;set;}
    public Integer gstYel_max {get;set;}
    public Integer banGreen_min {get;set;}
    public Integer banRed_max {get;set;}
    public Integer banYel_min {get;set;}
    public Integer banYel_max {get;set;}
    public Integer passGreen_min {get;set;}
    public Integer passRed_max {get;set;}
    public Integer passYel_min {get;set;}
    public Integer passYel_max {get;set;}

    public transient Map<String,SBU__c> mapListSBU {get;Set;}
    public transient Map<String,Territory_Distributor__c> mapListTer {get;Set;}
    public transient Map<String,Region__c> mapListReg {get;Set;}
    public transient Map<String,Zone__c> mapListZone {get;Set;}
   

    public AdminAccountKYCController(){

        Sales_Org = '1000';     // .....SET BY DEFAULT, CHANGE IT ON COUNTRY SELECTION...
        showSpinner = false;
        mapListSBU = new Map<String,SBU__c>();
        mapListTer = new Map<String,Territory_Distributor__c>();
        mapListReg = new Map<String,Region__c>();
        mapListZone = new Map<String,Zone__c>();
        kycSet='';
        kycId='';
        KycObject = new KYC__c();
        listSBU =new list<SBU__c>();
        listZone =new list<Zone__c>();
        listRegion = new list<Region__c>();
        listTerritory =new list<Territory_Distributor__c>();
        totCount = 0;
        green_min = 90;
        red_max = 59;
        yel_min = 60;
        yel_max = 89;
        panGreen_min = 90;
        panRed_max = 59;
        panYel_min = 60;
        panYel_max = 89;
        gstGreen_min = 90;
        gstRed_max = 59;
        gstYel_min = 60;
        gstYel_max = 89;
        banGreen_min = 90;
        banRed_max = 59;
        banYel_min = 60;
        banYel_max = 89;
        passGreen_min = 90;
        passRed_max = 59;
        passYel_min = 60;
        passYel_max = 89;

        List<String> gList = new List<String>();
        List<String> rList = new List<String>();
        List<String> yList = new List<String>();
        List<String> panGList = new List<String>();
        List<String> panRList = new List<String>();
        List<String> panYList = new List<String>();
        List<String> gstGList = new List<String>();
        List<String> gstRList = new List<String>();
        List<String> gstYList = new List<String>();
        List<String> banGList = new List<String>();
        List<String> banRList = new List<String>();
        List<String> banYList = new List<String>();
        List<String> passGList = new List<String>();
        List<String> passRList = new List<String>();
        List<String> passYList = new List<String>();


        List<KYC_Configuration__mdt> kycSetting = [SELECT Id, Label, QualifiedApiName, Red_Range__c, Orange_Range__c, Green_Range__c FROM KYC_Configuration__mdt];
            
            for(KYC_Configuration__mdt mdt : kycSetting){
                if(mdt.QualifiedApiName == 'GST'){
                    gstGList = mdt.Green_Range__c.split('-');
                    gstRList = mdt.Red_Range__c.split('-');
                    gstYList = mdt.Orange_Range__c.split('-');

                }
                else if(mdt.QualifiedApiName == 'Overall_Score'){
                    gList = mdt.Green_Range__c.split('-');
                    rList = mdt.Red_Range__c.split('-');
                    yList = mdt.Orange_Range__c.split('-');
                }
                else if(mdt.QualifiedApiName == 'PAN_Card'){
                    panGList = mdt.Green_Range__c.split('-');
                    panRList = mdt.Red_Range__c.split('-');
                    panYList = mdt.Orange_Range__c.split('-');

                }
                else if(mdt.QualifiedApiName == 'Passport'){
                    passGList = mdt.Green_Range__c.split('-');
                    passRList = mdt.Red_Range__c.split('-');
                    passYList = mdt.Orange_Range__c.split('-');
                }
                else if(mdt.QualifiedApiName == 'Account_Number'){
                    banGList = mdt.Green_Range__c.split('-');
                    banRList = mdt.Red_Range__c.split('-');
                    banYList = mdt.Orange_Range__c.split('-');
                }
               // List<String> gList = kycSetting.Green_Range__c.split('-');
              //  List<String> rList = kycSetting.Red_Range__c.split('-');
              //  List<String> yList = kycSetting.Yellow_Range__c.split('-');
            }

            if(gList.size()>0){
                green_min = Integer.valueOf(gList[0].trim());
            }
            if(rList.size()>0){
                red_max = Integer.valueOf(rList[1].trim());
            }
            if(yList.size()>0){
                yel_min = Integer.valueOf(yList[0].trim());
                yel_max = Integer.valueOf(yList[1].trim());
            }

            if(panGList.size()>0){
                panGreen_min = Integer.valueOf(panGList[0].trim());
            }
            if(panRList.size()>0){
                panRed_max = Integer.valueOf(panRList[1].trim());
            }
            if(panYList.size()>0){
                panYel_min = Integer.valueOf(panYList[0].trim());
                panYel_max = Integer.valueOf(panYList[1].trim());
            }

            if(gstGList.size()>0){
                gstGreen_min = Integer.valueOf(gstGList[0].trim());
            }
            if(gstRList.size()>0){
                gstRed_max = Integer.valueOf(gstRList[1].trim());
            }
            if(gstYList.size()>0){
                gstYel_min = Integer.valueOf(gstYList[0].trim());
                gstYel_max = Integer.valueOf(gstYList[1].trim());
            }

            if(banGList.size()>0){
                banGreen_min = Integer.valueOf(banGList[0].trim());
            }
            if(banRList.size()>0){
                banRed_max = Integer.valueOf(banRList[1].trim());
            }
            if(banYList.size()>0){
                banYel_min = Integer.valueOf(banYList[0].trim());
                banYel_max = Integer.valueOf(banYList[1].trim());
            }

            if(passGList.size()>0){
                passGreen_min = Integer.valueOf(passGList[0].trim());
            }
            if(passRList.size()>0){
                passRed_max = Integer.valueOf(passRList[1].trim());
            }
            if(passYList.size()>0){
                passYel_min = Integer.valueOf(passYList[0].trim());
                passYel_max = Integer.valueOf(passYList[1].trim());
            }
           
            System.debug('Green List'+gList);
            System.debug('Green 1 -'+gList[1].trim());
       
    }
     public void fetchCountryData(){
        mapListSBU = new Map<String,SBU__c>();
        mapListTer = new Map<String,Territory_Distributor__c>();
        mapListReg = new Map<String,Region__c>();
        mapListZone = new Map<String,Zone__c>();
       // Sales_Org = salesOrg;

        System.debug('Sales_Org ---> '+Sales_Org);

        try{
        Id salesOrgId = [SELECT Id, Sales_Org_Code__c FROM Sales_Org__c where Sales_Org_Code__c  = :salesOrg][0].Id;
        System.debug(salesOrgId);


        if(salesOrg == '1000'){ 
            for(SBU__c sbu: [SELECT Id, SalesOrg__c, Name FROM SBU__c where SalesOrg__c  =:salesOrgId]){
                if(!mapListSBU.containsKey(sbu.Id)){
                    mapListSBU.put(sbu.Id,sbu);
                }
            }
            System.debug('mapListSBU----> '+mapListSBU);

            Set<String> sbuIdSet = new Set<String>();
            sbuIdSet = mapListSBU.keySet();
            System.debug('sbuIdSet----> '+sbuIdSet.size());
            System.debug('sbuIdSet----> '+sbuIdSet);
        }
          
            for(Zone__c  zone:[SELECT Id,Name,SalesOrg__c FROM Zone__c WHERE  SalesOrg__c =: salesOrgId]){
                
              if(!mapListZone.containsKey(zone.Id)){
                    mapListZone.put(zone.Id,zone);
              }
            }
         
        

        System.debug('mapListZone----> '+mapListZone);

        if(salesOrg == '1210'){ 
            for(Region__c  reg: [SELECT Id,Name,SalesOrg__c FROM Region__c WHERE  SalesOrg__c =: salesOrgId]){
                
                if(!mapListReg.containsKey(reg.Id)){
                  mapListReg.put(reg.Id,reg); 
                }
            }
        }

        System.debug('mapListReg----> '+mapListReg);
        
            for(Territory_Distributor__c ter : [SELECT Id,Name,SalesOrg__c FROM Territory_Distributor__c WHERE SalesOrg__c =: salesOrgId]){
                
                if(!mapListTer.containsKey(ter.Id)){
                    mapListTer.put(ter.Id,ter);  
                }
            }
        

         System.debug('mapListTer----> '+mapListTer);
            
        }
        catch(Exception e){
            System.debug('Exception Details ----> '+e.getStackTraceString());
            System.debug('Exception at line  ----> '+e.getLineNumber());
            System.debug('Exception ----> '+e);
        } 

/*
        listSBU = new list<SBU__c>();
        listZone =new list<Zone__c>();
        listRegion = new list<Region__c>();
        system.debug('salesOrg>>--->'+salesOrg);
        listTerritory =new list<Territory_Distributor__c>();
        if(!String.isEmpty(salesOrg)){
            listSBU = [SELECT Id,Name,SalesOrg__c FROM SBU__c WHERE SalesOrg__r.Sales_Org_Code__c =: salesOrg];
            listZone = [SELECT Id,Name,SalesOrg__c FROM Zone__c WHERE SalesOrg__r.Sales_Org_Code__c  =: salesOrg];
            if(SalesOrg=='1210'){
                listRegion = [SELECT Id,Name,SalesOrg__c FROM Region__c WHERE SalesOrg__r.Sales_Org_Code__c  =: salesOrg];
            }
            listTerritory = [SELECT Id,Name,SalesOrg__c FROM Territory_Distributor__c WHERE SalesOrg__r.Sales_Org_Code__c =: salesOrg];  
            system.debug('listSBU>>--->'+listSBU);      
        }*/
       
    }

    public void getKYCDetailsList(){

        System.debug('getKYCDetailsList method called...');
        System.debug('salesOrg '+salesOrg);
        System.debug('sbu_Id '+sbu_Id);
        System.debug('zone_Id '+zone_Id);
        System.debug('rgn_Id '+rgn_Id);
        System.debug('ter_Id '+ter_Id);
        System.debug('isKyc_done '+isKyc_done);
        //System.debug('length Rgn ----. '+ rgn_Id.length());

        kycDetailsMap = new Map<String,KYCWrapper>();
        KYCWrapper kycWrap;
        KYCDetails kycDetails;
        List<KYCDetails> detailsList = new List<KYCDetails>();
        List<KYC__c> kycList = new List<KYC__c>();
      
        String dateFormat='dd/MM/yyyy';
        String mainQuery='';
        String sbuQuery='';
        String zoneQuery='';
        String rgnQuery='';
        String terQuery='';
        String isKycQuery='';
        Boolean flag = false;
        totCount = 0;
        try{
            

        mainQuery='SELECT Id, Name, RecordTypeId, RecordType.Name, LastModifiedDate, KYC_Last_Updated_Date_Time__c, Kyc_status__c, Confidence_score__c, KYC_Integration_Status__c, Account__c, Account__r.Name, Account__r.KYC_Confidence_score__c, Territory__c, Territory__r.Name, Territory__r.Region__r.Name,Territory__r.SBU__r.Name, Territory__r.Zone__r.Name  FROM KYC__c where Id!=null AND Territory__r.Sales_Org_Code__c=:salesOrg ';
        sbuQuery=' AND Territory__r.SBU__c=:sbu_Id ';
        
        if(sbu_Id !='None' && sbu_Id.length()>0){
            mainQuery = mainQuery+sbuQuery;
        }

        if(zone_Id !=null && zone_Id.length()>0){
            Set<String> zoneIdSet = new Set<String>();
            List<String> zoneList = zone_Id.split(',');
            
            for(String id : zoneList){
                zoneIdSet.add(id);
            }
            zoneQuery=' AND Territory__r.Zone__c IN : zoneIdSet ';
            mainQuery = mainQuery+zoneQuery;
        }

        if(rgn_Id !=null && rgn_Id.length()>0){
            Set<String> rgnIdSet = new Set<String>();
            List<String> rgnList = rgn_Id.split(',');
            
            for(String id : rgnList){
                rgnIdSet.add(id);
            }
            rgnQuery=' AND Territory__r.Region__c IN :rgnIdSet ';
            mainQuery = mainQuery+rgnQuery;
        }

        if(ter_Id !=null && ter_Id.length()>0){
            Set<String> terIdSet = new Set<String>();
            List<String> terList = ter_Id.split(',');
            
            for(String id : terList){
                terIdSet.add(id);
            }
            System.debug('terIdSet '+terIdSet);
            terQuery=' AND Territory__c IN :terIdSet ';
            mainQuery = mainQuery+terQuery;
        }

        if(isKyc_done !=null && isKyc_done.length()>0){
            Set<String> stsSet = new Set<String>();
            List<String> stsList = isKyc_done.split(',');
            
            for(String sts : stsList){
                stsSet.add(sts);
            }
            System.debug('stsSet '+stsSet);
            isKycQuery=' AND  Kyc_status__c IN :stsSet ';
            mainQuery = mainQuery+isKycQuery;
        }

        mainQuery = mainQuery+'order by Account__c DESC';

        System.debug('Main Query ----. '+ mainQuery);

        kycList=Database.query(mainQuery);

         System.debug('AdminAccountKYCController contructor...kycList--: '+kycList);  

         for(KYC__c kyc:kycList){

             kycWrap = new KYCWrapper();
             kycDetails = new KYCDetails();
             
             kycWrap.acc_id = kyc.Account__c;
             kycWrap.acc_name = kyc.Account__r.Name;
             kycWrap.sbu = kyc.Territory__r.SBU__r.Name;
             kycWrap.zone = kyc.Territory__r.Zone__r.Name;
             kycWrap.region = kyc.Territory__r.Region__r.Name;
             kycWrap.territory = kyc.Territory__r.Name;
             kycWrap.overAllScore = String.valueOf(kyc.Account__r.KYC_Confidence_score__c);
             
             System.debug('kyc_flag ----. '+ kycWrap.kyc_flag);
             kycDetails.kyc_id = kyc.Id;
             kycDetails.conf_score = String.valueOf(kyc.Confidence_score__c);

             if(kyc.KYC_Last_Updated_Date_Time__c != null){
                 Datetime dt = kyc.KYC_Last_Updated_Date_Time__c; 
                 kycDetails.mod_Date = dt.format(dateFormat);
             }
             
             kycDetails.rcrdTp_Id = kyc.RecordTypeId;
             kycDetails.rcrdTp_name = kyc.RecordType.Name; 
             kycDetails.acc_id = kyc.Account__c; 
             kycDetails.kyc_status =  kyc.KYC_Integration_Status__c;  
             kycDetails.status = kyc.Kyc_status__c;
             
            /* if(kyc.KYC_Integration_Status__c.trim() == 'In Progress' || kyc.KYC_Integration_Status__c.trim() == 'Partially Completed' || kyc.KYC_Integration_Status__c.trim() == 'Submitted for KYC' || kyc.KYC_Integration_Status__c.trim() == 'NA'){
                 kycDetails.kyc_flag2 = true;
             }
             else{
                  totCount = totCount+1;
                 kycDetails.kyc_flag2 = false;
             }*/
             

             if(kyc.RecordType.Name == 'PAN Card'){
                 kycDetails.kGreen_min = panGreen_min;
                 kycDetails.kRed_max = panRed_max;
                 kycDetails.kYel_min = panYel_min;
                 kycDetails.kYel_max = panYel_max;
             }
             else if(kyc.RecordType.Name == 'Gst'){
                 kycDetails.kGreen_min = gstGreen_min;
                 kycDetails.kRed_max = gstRed_max;
                 kycDetails.kYel_min = gstYel_min;
                 kycDetails.kYel_max = gstYel_max;
             }
             else if(kyc.RecordType.Name == 'Passport'){
                 kycDetails.kGreen_min = passGreen_min;
                 kycDetails.kRed_max = passRed_max;
                 kycDetails.kYel_min = passYel_min;
                 kycDetails.kYel_max = passYel_max;
             }
             else if(kyc.RecordType.Name == 'Bank Account'){
                 kycDetails.kGreen_min = banGreen_min;
                 kycDetails.kRed_max = banRed_max;
                 kycDetails.kYel_min = banYel_min;
                 kycDetails.kYel_max = banYel_max;
             }
             System.debug('kyc_status ----. '+ kycDetails.kyc_status);

             if(kycDetailsMap.containsKey(kyc.Account__c)){

                detailsList = new List<KYCDetails>();

               /* for(Integer i=1; i<=9; i++){
                  detailsList.add(new KYCDetails());    

                }*/

                detailsList =  kycDetailsMap.get(kyc.Account__c).kycDetails;

                if(kycDetails.rcrdTp_name == 'PAN Card'){
                    detailsList.set(0,kycDetails);
                }
                else if(kycDetails.rcrdTp_name == 'Gst'){
                    detailsList.set(1,kycDetails);
                }
                else if(kycDetails.rcrdTp_name == 'Passport'){
                    detailsList.set(2,kycDetails);
                }
                else if(kycDetails.rcrdTp_name == 'Bank Account'){
                    detailsList.set(3,kycDetails);
                }
              /*  else if(kycDetails.rcrdTp_name == 'IFSC Code'){
                    detailsList.set(4,kycDetails);
                }*/
                else if(kycDetails.rcrdTp_name == 'Email'){
                    detailsList.set(4,kycDetails);
                }
                else if(kycDetails.rcrdTp_name == 'Driving License'){
                    detailsList.set(5,kycDetails);
                }
                else if(kycDetails.rcrdTp_name == 'Voter ID'){
                    detailsList.set(6,kycDetails);
                }
                else if(kycDetails.rcrdTp_name == 'FSSAI'){
                    detailsList.set(7,kycDetails);
                }
                else if(kycDetails.rcrdTp_name == 'FDA'){
                    detailsList.set(8,kycDetails);
                }
               /* else if(kycDetails.rcrdTp_name == 'OCR'){
                    detailsList.set(10,kycDetails);
                }*/
                
                kycWrap.kycDetails = detailsList;

              /*  if(flag == false){
                    if(kyc.KYC_Integration_Status__c == 'In Progress' || kyc.KYC_Integration_Status__c == 'Partially Completed' || kyc.KYC_Integration_Status__c == 'Submitted for KYC' || kyc.KYC_Integration_Status__c == 'NA'){
                    kycWrap.kyc_flag = true;
                    flag = true;
                    }
                    else{
                        kycWrap.kyc_flag = false;
                        flag = false;
                    }
                }
                else{
                        kycWrap.kyc_flag = true;
                        
                    }*/

                kycDetailsMap.put(kyc.Account__c, kycWrap);
                System.debug('Inside  If block kycWrap--: '+kycWrap.kyc_flag); 
                System.debug('Inside MAp if block--: '+kycDetailsMap); 
             }
             else{

                 flag= false;

                detailsList = new List<KYCDetails>();

                for(Integer i=1; i<=9; i++){
                  detailsList.add(new KYCDetails());    

                }

                if(kycDetails.rcrdTp_name == 'PAN Card'){
                    detailsList.set(0,kycDetails);
                }
                else if(kycDetails.rcrdTp_name == 'Gst'){
                    detailsList.set(1,kycDetails);
                }
                else if(kycDetails.rcrdTp_name == 'Passport'){
                    detailsList.set(2,kycDetails);
                }
                else if(kycDetails.rcrdTp_name == 'Bank Account'){
                    detailsList.set(3,kycDetails);
                }
               /* else if(kycDetails.rcrdTp_name == 'IFSC Code'){
                    detailsList.set(4,kycDetails);
                }*/ 
                else if(kycDetails.rcrdTp_name == 'Email'){
                    detailsList.set(4,kycDetails);
                }
                else if(kycDetails.rcrdTp_name == 'Driving License'){
                    detailsList.set(5,kycDetails);
                }
                else if(kycDetails.rcrdTp_name == 'Voter ID'){
                    detailsList.set(6,kycDetails);
                }
                else if(kycDetails.rcrdTp_name == 'FSSAI'){
                    detailsList.set(7,kycDetails);
                }
                else if(kycDetails.rcrdTp_name == 'FDA'){
                    detailsList.set(8,kycDetails);
                }
              /*  else if(kycDetails.rcrdTp_name == 'OCR'){
                    detailsList.set(10,kycDetails);
                }*/
                
                kycWrap.kycDetails = detailsList;

              /*  if(flag == false){
                    if(kyc.KYC_Integration_Status__c == 'In Progress' || kyc.KYC_Integration_Status__c == 'Partially Completed' || kyc.KYC_Integration_Status__c == 'Submitted for KYC' || kyc.KYC_Integration_Status__c == 'NA'){
                    kycWrap.kyc_flag = true;
                    flag = true;
                    }
                    else{
                        kycWrap.kyc_flag = false;
                        flag = false;
                    }
                }
                else{
                        kycWrap.kyc_flag = true;
                        
                    }*/

                kycDetailsMap.put(kyc.Account__c, kycWrap);
                System.debug('Inside  else block kycWrap--: '+kycWrap.kyc_flag); 
                System.debug('Inside MAp else block--: '+kycDetailsMap); 
             }

           /*  System.debug('Account Name--: '+kyc.Account__r.Name); 
             System.debug('Territory Name--: '+kyc.Territory__r.Name); 
             System.debug('Zone Name--: '+kyc.Territory__r.Zone__r.Name); 
             System.debug('Region Name--: '+kyc.Territory__r.Region__r.Name); */

         }     
        System.debug('Map........--: '+kycDetailsMap);
         System.debug('Total Count........--: '+totCount);
        }
        catch(Exception e){
            System.debug('Exception........--: '+e.getStackTraceString());
            
        }
    
    }

    public void runKYC(){
        System.debug('runKYC called...');
        System.debug('kycIdSet...... :- '+ kycSet);
       
        List<String> res = kycSet.split(',');
        
        List<KYC__C> kycList = new List<KYC__c>();
        KYC__C kycObj =null;
        
        if(res.size()>0){

            for(String id : res){
                System.debug('kycId...... :- '+ id);
                if(id.length()>0){
                    kycObj = new KYC__c();
                    kycObj.Id = id;
                    kycObj.KYC_Integration_Status__c = 'Submitted for KYC';

                    kycList.add(kycObj);
                    System.debug('kycListSize...... :- '+ kycList.size());
                }
            }
            System.debug('kycListSize..**.... :- '+ kycList.size());

            if(kycList.size()>0){
                try {
                    update kycList;
                    /*KYCScheduledDispatcher kycScheDi = new KYCScheduledDispatcher();
                    kycScheDi.execute(null);*/
                    KYCAPIIntegrationBatch kycbatch=new KYCAPIIntegrationBatch();
                    Database.executeBatch(kycbatch,1);
                    
                } catch (Exception e) {
                    System.debug('Exception in update. :- '+ e.getLineNumber());
                    System.debug('Exception in update. :- '+ e.getStackTraceString());
                    System.debug('Exception in update. :- '+ e);
                }
                
            }

        }
      
    }

    public void getKYCDetails(){
        System.debug('getKYCDetails called ....');
        System.debug('kycId ....: '+kycId);
        KycObject = new KYC__c();

        if(kycId !='' || kycId != null){

            KycObject =[SELECT Id, IsDeleted, Name, CurrencyIsoCode, RecordTypeId,RecordType.Name, CreatedDate, 
                        CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Account__c, Kyc_status__c, 
                        Confidence_score__c, Result__c, Input__c, Email_ID__c, KYC_Last_Updated_Date_Time__c, KYC_By__c, 
                        Request_JSON__c, Respone_JSON__c, Consent__c, Request_Id__c, Status_Code__c, Email__c, 
                        email_resp_accept_all__c, email_resp_disposable__c, email_resp_email__c, email_resp_mx_records__c, 
                        email_resp_regexp__c, email_resp_result__c, email_resp_smtp_check__c, email_resp_webmail__c, 
                        PAN_Number__c, pan_resp_name__c, dl_no__c, dl_dob__c, dl_resp_name__c, dl_resp_dob__c, 
                        dl_resp_Issue_Date__c, dl_resp_blood_group__c, dl_resp_father_husband_name__c, dl_resp_address__c, 
                        dl_resp_cov_issue_date__c, dl_resp_cov__c, dl_resp_validity_non_transport__c, 
                        dl_resp_validity_transport__c, vi_req_epic_no__c, vi_resp_ps_lat_long__c, vi_resp_rln_name_v1__c, 
                        vi_resp_rln_name_v2__c, vi_resp_rln_name_v3__c, vi_resp_part_no__c, vi_resp_rln_type__c, 
                        vi_resp_section_no__c, vi_resp_vid__c, vi_resp_name_v1__c, vi_resp_rln_name__c, vi_resp_district__c, 
                        vi_resp_last_update__c, vi_resp_state__c, vi_resp_ac_no__c, vi_resp_house_no__c, vi_resp_ps_name__c, 
                        vi_resp_pc_name__c, vi_resp_slno_inpart__c, vi_resp_name__c, vi_resp_part_name__c, vi_resp_st_code__c, 
                        vi_resp_gender__c, vi_resp_age__c, vi_resp_ac_name__c, vi_resp_epic_no__c, vi_resp_name_v3__c, 
                        vi_resp_name_v2__c, vi_resp_dob__c, psp_resp_dob__c, psp_resp_doe__c, psp_resp_gender__c, psp_passport_no__c, 
                        psp_resp_type__c, psp_resp_country__c, psp_resp_placeOfIssue__c, psp_resp_placeOfBirth__c, mob_mobile_no__c, 
                        mob_resp_message__c, fssai_reg_no__c, fssai_resp_status__c, fssai_resp_lic_type__c, fssai_resp_lic_no__c, 
                        fssai_resp_firm_name__c, fssai_resp_address__c, ban_ifsc__c, ban_account_number__c, ban_resp_bankTxnStatus__c, 
                        ban_resp_account_number__c, ban_resp_ifsc__c, ban_resp_account_name__c, ban_resp_bank_response__c, 
                        ifsc_ifsc_code__c, ifsc_resp_city__c, ifsc_resp_district__c, ifsc_resp_ifsc__c, ifsc_resp_micr__c, 
                        ifsc_resp_state__c, ifsc_resp_contact__c, ifsc_resp_branch__c, ifsc_resp_address__c, ifsc_resp_bank__c, 
                        fda_licence_no__c, fda_state__c, fda_resp_store_name__c, fda_resp_contact_number__c, fda_resp_license_detail__c, 
                        fda_resp_name__c, fda_resp_address__c, ma_name1__c, ma_name2__c, psp_resp_given_name__c, psp_resp_last_name__c, 
                        ma_resp_score__c, ma_resp_result__c, gst_gstin__c, API_Count__c, OCR_verified__c, ma_type__c, ma_preset__c, 
                        gst_resp_mbr__c, gst_resp_canFlag__c, gst_resp_pradr__c, gst_resp_tradeNam__c, gst_resp_lstupdt__c, 
                        gst_resp_contacted__c, gst_resp_rgdt__c, gst_resp_stjCd__c, gst_resp_stj__c, gst_resp_ctjCd__c, gst_resp_ppr__c, 
                        gst_resp_dty__c, gst_resp_cmpRt__c, gst_resp_cxdt__c, gst_resp_ctb__c, gst_resp_sts__c, gst_resp_gstin__c, 
                        gst_resp_lgnm__c, gst_resp_nba__c, gst_resp_adadr__c, gst_resp_ctj__c, Distributor_Document__c, API_Count_Name__c, 
                        res_kyc_int_datetime__c, req_kyc_int_datetime__c, Territory__c, Total_Api_Count__c, KYC_Integration_Status__c, 
                        First_Name__c, Last_Name__c, DOB__c, API_Count_OCR__c, ocr_pan_resp_father__c, ocr_pan_resp_date__c, 
                        ocr_pan_resp_dateofIssue__c, ban_name__c FROM KYC__c WHERE Id=:kycId];

        }

        System.debug('KycObject ....: '+KycObject);
        
    }
    
    public void onSBUChangeFun(){
        System.debug('onSBUChangeFun called ....');
        System.debug('SBU ID....: '+sbu_Id);
        System.debug('Sales_Org...: '+Sales_Org);
        
         
        
        if(sbu_ID != 'None' || sbu_ID != '' || sbu_ID != null){
          
            mapListTer = new Map<String,Territory_Distributor__c>();
            mapListReg = new Map<String,Region__c>();
            mapListZone = new Map<String,Zone__c>();
            
            for(Zone__c  zone:[SELECT Id,Name,SalesOrg__c FROM Zone__c WHERE  SBUCode__c =: sbu_Id]){
                
              if(!mapListZone.containsKey(zone.Id)){
                    mapListZone.put(zone.Id,zone);
              }
            }
            
            if(Sales_Org == '1210'){
                for(Region__c  reg: [SELECT Id,Name,SalesOrg__c FROM Region__c WHERE  SBU__c =: sbu_Id]){
                    
                    if(!mapListReg.containsKey(reg.Id)){
                      mapListReg.put(reg.Id,reg); 
                    }
                }
            }
            
            for(Territory_Distributor__c ter : [SELECT Id,Name,SalesOrg__c FROM Territory_Distributor__c WHERE SBU__c =: sbu_Id]){
                
                if(!mapListTer.containsKey(ter.Id)){
                    mapListTer.put(ter.Id,ter);  
                }
            }
            
            
        }
        
    } 
    
    public void onZoneChangeFun(){
        System.debug('onZoneChangeFun called ....');
        System.debug('Zone ID....: '+zone_Id);
        System.debug('Sales_Org...: '+Sales_Org);
        
        if(zone_Id.length()>0){
        if(zone_Id != 'None' || zone_Id != '' || zone_Id != null){
            
            Set<String> zoneIdSet = new Set<String>();
            List<String> zoneList = zone_Id.split(',');
            
            for(String id : zoneList){
                zoneIdSet.add(id);
            }
          
            mapListTer = new Map<String,Territory_Distributor__c>();
            mapListReg = new Map<String,Region__c>();
            
            if(Sales_Org == '1210'){
                for(Region__c  reg: [SELECT Id,Name,SalesOrg__c FROM Region__c WHERE  Zone__c IN: zoneIdSet]){
                    
                    if(!mapListReg.containsKey(reg.Id)){
                      mapListReg.put(reg.Id,reg); 
                    }
                }
            }
            
            for(Territory_Distributor__c ter : [SELECT Id,Name,SalesOrg__c FROM Territory_Distributor__c WHERE Zone__c IN: zoneIdSet]){
                
                if(!mapListTer.containsKey(ter.Id)){
                    mapListTer.put(ter.Id,ter);  
                }
            }
        }
       }
    }
    
    public void onRegChangeFun(){
        System.debug('onRegChangeFun called ....');
        System.debug('Rgn ID....: '+rgn_Id);
        System.debug('Sales_Org...: '+Sales_Org);
        
        if(rgn_Id.length()>0){
        if(rgn_Id != 'None' || rgn_Id != '' || rgn_Id != null){
            
            Set<String> rgnIdSet = new Set<String>();
            List<String> rgnList = rgn_Id.split(',');
            
            for(String id : rgnList){
                rgnIdSet.add(id);
            }
                      
            mapListTer = new Map<String,Territory_Distributor__c>();
            
            for(Territory_Distributor__c ter : [SELECT Id,Name,SalesOrg__c FROM Territory_Distributor__c WHERE Region__c IN: rgnIdSet]){
                
                if(!mapListTer.containsKey(ter.Id)){
                    mapListTer.put(ter.Id,ter);  
                }
            }
        }
       }
    }


   /* public PageReference getZoneandTerritory(){
        listZone =new list<Zone__c>();
        listRegion = new list<Region__c>();
        listTerritory =new list<Territory_Distributor__c>();
        if(!String.isEmpty(salesOrg)){
            listZone = [SELECT Id,Name,SalesOrg__c FROM Zone__c WHERE SalesOrg__r.Sales_Org_Code__c  =: salesOrg AND SBUCode__c IN:listSbuId];
            if(SalesOrg=='1210'){
                listRegion = [SELECT Id,Name,SalesOrg__c FROM Region__c WHERE SalesOrg__r.Sales_Org_Code__c  =: salesOrg AND SBU__c IN:listSbuId];
            }
            listTerritory = [SELECT Id,Name,SalesOrg__c FROM Territory_Distributor__c WHERE SalesOrg__r.Sales_Org_Code__c =: salesOrg AND SBU__c IN:listSbuId];        
        }
     return null;
    }*/

    public class KYCDetails {
        public Id kyc_id {get;set;}
        public String conf_score {get;set;}
        public String mod_Date {get;set;}
        public String rcrdTp_Id {get;set;}
        public String rcrdTp_name {get;set;} 
        public Id acc_id {get;set;}
        public String kyc_status {get;set;}
        public String status {get;set;}
        public Integer kGreen_min {get;set;}
        public Integer kRed_max {get;set;}
        public Integer kYel_min {get;set;}
        public Integer kYel_max {get;set;}
        public Boolean kyc_flag2 {get;set;}

        Datetime expected = Datetime.newInstance(2019, 05, 16);
        
        public KYCDetails(){
            this.kyc_id=null;
            this.conf_score='00';
            this.mod_Date='';
            this.rcrdTp_Id='';
            this.rcrdTp_name='';
            this.acc_id=null;
            this.kyc_status='';
            this.status='';
            this.kGreen_min = 80;
            this.kRed_max = 29;
            this.kYel_min = 30;
            this.kYel_max = 79;
            this.kyc_flag2 = false;
        }
    }

    public class KYCWrapper {
        public Id acc_id {get;set;}
        public String acc_name {get;set;}
        public String zone {get;set;}
        public String region {get;set;}
        public String sbu {get;set;}
        public String territory {get;set;}
        public List<KYCDetails> kycDetails {get;set;}
        public String overAllScore {get;set;}
        public Boolean kyc_flag {get;set;}

        public KYCWrapper(){
            this.acc_id=null;
            this.acc_name='';
            this.zone='';
            this.region='';
            this.sbu='';
            this.territory='';
            this.kycDetails = new List<KYCDetails>();
            this.overAllScore = '0';
            this.kyc_flag = false;
        }


    }

}