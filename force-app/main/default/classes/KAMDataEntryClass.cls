public without sharing class KAMDataEntryClass {
    public static string currencyCodeNAM = 'USD';
    public static string currencyCodeCanada = 'CAD';
    public static string salesOrgCodeNAM = System.Label.NAM_SalesOrg; //3100
    public static string salesOrgCodeCanada = System.Label.Canada_SalesOrg; //3710
    
    @AuraEnabled
    public static Integer getHiearchySettings(){
        return Integer.valueof(UPL_Settings__c.getInstance().Draft_Record_Per_Page__c);
    }

    @AuraEnabled
    public static CalculateMarkettingYearHelper.MarketingYearWrapper getMarketingYear(String accountId){
        Account a = [SELECT Id, Sales_Org__c, Sales_Org__r.Sales_Org_Code__c FROM Account WHERE Id =: accountId]; 
        return CalculateMarkettingYearHelper.calculateMarketingYear(a.Sales_Org__r.Sales_Org_Code__c);
    }

    @AuraEnabled
    public static List<divWrapper> getDivision(Id accountId){
        List<divWrapper> dWrap = new List<divWrapper>();
        List<DistributorSalesAreaMapping__c> distArea = [SELECT Id,Division__c FROM DistributorSalesAreaMapping__c WHERE Distributor__c=:accountId];
        Set<Id> divSet=new Set<Id>();
        for(DistributorSalesAreaMapping__c dc:distArea){
            divSet.add(dc.Division__c);
        }
        List<Division__c> divreg = [SELECT Id, Division_Code__c, Name FROM Division__c WHERE Id IN:divSet];
        divWrapper dW1 = new divWrapper();
        dW1.divId = null;
        dW1.divLength = 1;
        dW1.divName = '--None--';
        dW1.divCode = '';
        dWrap.add(dW1);            
        if(distArea.size() > 0){
            for(Division__c dd : divreg){
                divWrapper dW = new divWrapper();
                dW.divId = dd.Id;
                dW.divLength = distArea.size();
                dW.divName = dd.Name;
                dW.divCode = dd.Division_Code__c;
                dWrap.add(dW);
            }
        }
        else{
            Account a = [SELECT Id, Division__c, Division__r.Name, Division__r.Division_Code__c FROM Account WHERE Id =: accountId];
            if(a.Division__c != null){
                divWrapper dW = new divWrapper();
                dW.divId = a.Division__c;
                dW.divLength = 1;
                dW.divName = a.Division__r.Name;
                dW.divCode = a.Division__r.Division_Code__c;
                dWrap.add(dW);
            }
        }
        return dWrap;
    }

    @AuraEnabled
    public static SubmitStatusWrapper checkSubmitApproval(Id accountId, String mktYear, String divId){
        SubmitStatusWrapper wrap = new SubmitStatusWrapper();
        Account a = [SELECT Id, Sales_Org__c, Sales_Org__r.Sales_Org_Code__c FROM Account WHERE Id =: accountId]; 
        CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapper = CalculateMarkettingYearHelper.calculateMarketingYear(a.Sales_Org__r.Sales_Org_Code__c);
        Date startDate; Date endDate;
        if(mktYear == 'first'){
            startDate = mktYearWrapper.firstMarketingYearStartDate;
            endDate = mktYearWrapper.firstMarketingYearEndDate;
        }else if(mktYear == 'second'){
            startDate = mktYearWrapper.secondMarketingYearStartDate;
            endDate = mktYearWrapper.secondMarketingYearEndDate;
        } 
        List<Draft_Plan_Header__c> dfHeaderList = [SELECT Id, Status__c FROM Draft_Plan_Header__c WHERE Distributor__c =:accountId 
                                                 AND MKT_Year_Start_Date__c >=: startDate AND MKT_Year_End_Date__c <=: endDate 
                                                 AND Sales_Org__c =: a.Sales_Org__c AND Division__c =: divId LIMIT 1];
        wrap.canNotSubmit = true;
        if( dfHeaderList.size() < 1){
            wrap.canNotSubmit = true;
        }else{
            if(dfHeaderList[0].Status__c == 'Approved' || dfHeaderList[0].Status__c == 'Submitted'){
                wrap.canNotSubmit = true;
            }else if(dfHeaderList[0].Status__c == 'Draft' || dfHeaderList[0].Status__c == 'Rejected'){
                wrap.canNotSubmit = false;
            }
            /*Added for Approval History by GRZ(Nikhil Verma) RITM0478313 03-01-2023-->*/
            List<ProcessInstance> processList = [SELECT ID,(SELECT ID, ToLabel(StepStatus), Comments,  
                                                CreatedDate, Actor.Name, OriginalActor.Name FROM StepsAndWorkitems ORDER BY CreatedDate DESC,IsPending DESC ) 
                                                FROM ProcessInstance WHERE TargetObjectId =:dfHeaderList[0].Id ORDER BY CreatedDate DESC];
            List<ApprovalList> approvalObjList = new List<ApprovalList>();       
            for(ProcessInstance pI:processList){
                for(ProcessInstanceHistory sWI:pI.StepsAndWorkitems){                
                    ApprovalList ahObj = new ApprovalList(); 
                    ahObj.createdDate = sWI.CreatedDate;
                    ahObj.stepStatus = sWI.StepStatus;
                    ahObj.originalActorName = sWI.OriginalActor.Name;
                    ahObj.actorName = sWI.Actor.Name;
                    ahObj.comments = sWI.Comments;
                    approvalObjList.add(ahObj);
                }
            }
            wrap.approvalList = approvalObjList;
            /*****End********Added for Approval History by GRZ(Nikhil Verma) RITM0478313 03-01-2023-->*/
        }
        return wrap;
    }

    @auraenabled
    public static KAMDataEntryWrapper generateWrapper(string accountId,string mktYear,String divId,boolean hist){
        Account a = [SELECT name,Sales_Org__c,Sales_Org__r.Sales_Org_Code__c,SFDC_Distributor_Code__c,SAP_Code__c, Screen_Flow_Value__c FROM account WHERE id = :accountId]; 
        CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapper = CalculateMarkettingYearHelper.calculateMarketingYear(a.Sales_Org__r.Sales_Org_Code__c);
        Integer myear; Date startDate; Date endDate;
        if(mktYear == 'first'){
            myear = mktYearWrapper.firstMarketingYear;
            startDate = mktYearWrapper.firstMarketingYearStartDate;
            endDate = mktYearWrapper.firstMarketingYearEndDate;
        }
        else if(mktYear == 'second'){
            myear = mktYearWrapper.secondMarketingYear;
            startDate = mktYearWrapper.secondMarketingYearStartDate;
            endDate = mktYearWrapper.secondMarketingYearEndDate;
        } 
        Integer curYear = Integer.valueof(myear);
        Integer prevYear = endDate.year()-1;
        List<KAMCategoryWrapper> catLineList=new List<KAMCategoryWrapper>();
        List<KAMDataEntryLineWrapper> totaldataLineList = new List<KAMDataEntryLineWrapper>();
        KAMDataEntryWrapper KAMDEW ;
        List<Sales_Org__c> sorglst = [SELECT Id, Name,Sales_Org_Code__c FROM Sales_Org__c WHERE Sales_Org_Code__c =:a.Sales_Org__r.Sales_Org_Code__c LIMIT 1];
        List<Draft_Plan_Header__c> dfHeaderList=[SELECT Id, Combination_Key__c, Sales_Org__c, Distributor__c,Distributor__r.SAP_Code__c,
                                                MKT_Year_Name__c, MKT_Year_Start_Date__c, MKT_Year_End_Date__c,
                                                Status__c,lastmodifieddate,LastModifiedById,LastModifiedBy.Name FROM Draft_Plan_Header__c where Distributor__c=:accountId 
                                                and MKT_Year_Start_Date__c >=:startDate AND MKT_Year_End_Date__c <=:endDate 
                                                and Sales_Org__c=:sorglst[0].Id and Division__c=:divId Limit 1];
        if(dfHeaderList.size()>0){
            DraftPlanHelper dhelper = new DraftPlanHelper();
            draftPlanWrapper dfWrapper = dhelper.generateDraftWrapper(myear,startDate,endDate,a,divId);
            if(dfHeaderList[0].Status__c == 'Approved' || dfHeaderList[0].Status__c == 'Submitted'){
                //Added by Aashima(Grazitti) INC0454579 28Feb 2023 to bypass null pointer exception
                if(null!=dfWrapper.wrpDraftPlanListCurrentMap){
                    for(String sdf:dfWrapper.wrpDraftPlanListCurrentMap.keyset()){
                    List<KAMDataEntryLineWrapper> dataLineList=new List<KAMDataEntryLineWrapper>();
                    KAMCategoryWrapper kCat = new KAMCategoryWrapper();
                    kCat.prodCategory=sdf;
                    for(Draft_Plan__c dp:dfWrapper.wrpDraftPlanListCurrentMap.get(sdf)){
                        KAMDataEntryLineWrapper ke=new KAMDataEntryLineWrapper();
                        ke.cat=dp.sku__r.Material_Group_5__c;
                        ke.sid=dp.SKU__c;
                        ke.UOM=dp.sku__r.UOM__c;
                        ke.brnd = dp.sku__r.Brand_Name__c;//Added Brand Filter by GRZ(Nikhil Verma) RITM0478313 03-01-2023-->
                        String temp = dp.SKU__r.SKU_Code__c;
                        temp = temp.replaceFirst('^0+','');
                        ke.SkuName=temp +'-'+dp.SKU__r.SKU_Description__c;
                        ke.productPrice=dp.Product_Price__c;
                        ke.eQty=dp.EDI_Quantity_LY__c;
                        ke.eAmt=dp.EDI_Amount_LY__c;
                        ke.iQty=dp.Invoice_Quantity_LY__c;
                        ke.iAmt=dp.Invoice_Amount_LY__c;
                        ke.dQty=dp.Draft_Quantity__c;
                        ke.dAmt=dp.Draft_Amount__c;
                        system.debug('dAmt>>>'+dp.Draft_Amount__c);
                        if(dp.Draft_Amount__c != null && dp.Draft_Amount__c > 0) // created by: Gunnagya for ticket no.: RITM0266323
                        {
                            ke.isProductChecked = true;
                        }else{
                            ke.isProductChecked = false;
                        }
                        ke.dPct=dp.Pct_Of_Prev_Yr__c;
                        ke.dVal=dp.Value_At_Draft__c;
                        ke.dfId=dp.Id;
                        String type;
                        String rcode;
                        List<payoutWrapper>paylist=new List<payoutWrapper>();
                        for(Draft_Plan_Payout__c dpp:dp.Draft_Plan_Payouts__r){
                            payoutWrapper pw=new payoutWrapper();
                            pw.payoutId=dpp.id;
                            pw.draftId=dp.Id;
                            pw.Tier=dpp.Tier__c;
                            pw.threshold=dpp.Threshold_Quantity__c;
                            // pw.quantity=dpp.Qty_as_a_Pct__c;
                            pw.quantity=dpp.Qty_as_Percentage__c;//updated by: Gunnagya for ticket no.: RITM0266323
                            pw.reason=dpp.Reason_Code__c;
                            pw.type=dpp.Payout_Entry_Type__c;
                            type=dpp.Payout_Entry_Type__c;
                            rcode=dpp.Reason_Code__c;
                            pw.del=false;
                            pw.payoutPct = dpp.Payout_Per_Unit_Pct__c;
                            pw.payout = dpp.Payout_Per_Unit__c;
                            paylist.add(pw);
                        }
                        Ke.dfpayList=paylist;
                        ke.payType=type;
                        ke.reasonCode=rcode;
                        ke.expanded=false;
                        dataLineList.add(ke);
                    }
                    totaldataLineList.addAll(dataLineList);
                    kCat.KAMDataline=dataLineList;
                    catLineList.add(kCat);
                }
                }
                
                KAMDEW=new KAMDataEntryWrapper();
                KAMDEW.accountName = dfWrapper.accountName;
                KAMDEW.currentYear=dfWrapper.wrpCurrentYear;
                KAMDEW.previousYear=dfWrapper.wrpPreviousYear;
                if(hist==true){
                    List<KAMDataEntryLineWrapper> histdataLineList = new List<KAMDataEntryLineWrapper>();
                    for(KAMDataEntryLineWrapper ke:totaldataLineList){
                        if(ke.eQty!=null || ke.eAmt!=null || ke.iQty!=null || ke.iAmt!=null || ke.dQty!=null){
                            histdataLineList.add(ke);
                        }
                    }
                    KAMDEW.KAMTotalDataline=histdataLineList;
                }
                else{
                    KAMDEW.KAMTotalDataline=totaldataLineList;
                }
                KAMDEW.KAMCatLine=catLineList;
                KAMDEW.totalEDI=dfWrapper.wrptotalEDI;
                KAMDEW.totalInvoice=dfWrapper.wrptotalInvoice;
                KAMDEW.totalDraft=dfWrapper.wrptotalDraft;
                KAMDEW.totalVal=dfWrapper.wrptotalValueDraft;
                KAMDEW.pctDraft=dfWrapper.wrptotalPctDraft;
                KAMDEW.Approved=true;
                KAMDEW.lastSavedName=dfHeaderList[0].LastModifiedBy.Name;
                DateTime dT =  dfHeaderList[0].LastModifiedDate;
                KAMDEW.lastSavedDate=dt.format('MM-dd-yyyy hh:mm');
                KAMDEW.showLastSaved=true;
                KAMDEW.dfHeadId=dfHeaderList[0].Id;
                KAMDEW.sOrgId=dfHeaderList[0].Sales_Org__c;
                KAMDEW.distSAPCode=dfHeaderList[0].Distributor__r.SAP_Code__c;
                KAMDEW.MKTName=dfHeaderList[0].MKT_Year_Name__c;
                KAMDEW.MKTStart=dfHeaderList[0].MKT_Year_Start_Date__c;
                KAMDEW.MKTEnd=dfHeaderList[0].MKT_Year_End_Date__c;
                KAMDEW.screenFlow = a.Screen_Flow_Value__c;
                system.debug(KAMDEW.totalEDI);  
                return KAMDEW;
            }
            else{
                KAMDataEntryWrapper KAMDEW1=generateFinalWrapper(myear,startDate,endDate,a,sorglst[0],prevYear,curYear,divId,hist);
                id pid=Userinfo.getProfileId();
                List<ObjectPermissions> objectperm = [SELECT Id, SObjectType,PermissionsRead,PermissionsEdit FROM ObjectPermissions WHERE parentid in (select id from permissionset where PermissionSet.Profile.Id=:pid) And SObjectType = 'Draft_Plan_Header__c' LIMIT 1];
                if(objectperm.size() > 0){
                    if(objectperm[0].PermissionsEdit==true){
                        KAMDEW1.Approved = false;
                    }
                    else{
                        KAMDEW1.Approved = true;
                    }
                }
                KAMDEW1.lastSavedName=dfHeaderList[0].LastModifiedBy.Name;
                DateTime dT = dfHeaderList[0].LastModifiedDate;
                KAMDEW1.lastSavedDate=dt.format('MM-dd-yyyy hh:mm');
                KAMDEW1.showLastSaved=true;
                KAMDEW1.dfHeadId=dfHeaderList[0].Id;
                KAMDEW1.MKTName=dfHeaderList[0].MKT_Year_Name__c;
                KAMDEW1.MKTStart=dfHeaderList[0].MKT_Year_Start_Date__c;
                KAMDEW1.MKTEnd=dfHeaderList[0].MKT_Year_End_Date__c;
                KAMDEW1.sOrgId=dfHeaderList[0].Sales_Org__c;
                KAMDEW1.totalDraft=dfWrapper.wrptotalDraft;
                KAMDEW1.screenFlow = a.Screen_Flow_Value__c;
                return KAMDEW1;
            }
        }
        else{
            KAMDataEntryWrapper KAMDEW2 = generateFinalWrapper(myear,startDate,endDate,a,sorglst[0],prevYear,curYear,divId,hist);
            KAMDEW2.showLastSaved = false;
            KAMDEW2.screenFlow = a.Screen_Flow_Value__c;
            Id pid = Userinfo.getProfileId();
            List<ObjectPermissions> objectperm = [SELECT Id, SObjectType,PermissionsRead,PermissionsEdit FROM ObjectPermissions WHERE parentid IN (SELECT Id FROM permissionset WHERE PermissionSet.Profile.Id=:pid) And SObjectType = 'Draft_Plan_Header__c' LIMIT 1];
            if(objectperm.size() > 0){
                if(objectperm[0].PermissionsEdit == true){
                    KAMDEW2.Approved = false;
                }
                else{
                    KAMDEW2.Approved = true;
                }
            }            
            return KAMDEW2;
        }
    }
    
    @AuraEnabled
    public static String submitApproval(Id dhId){
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(dhId);
        req1.setProcessDefinitionNameOrId('NAM_Draft_Plan_Approval_Process');
        try{
            Approval.ProcessResult result = Approval.process(req1);
            return result.getInstanceStatus();
        }
        catch(exception e){
            return e.getMessage();
        }
    }
    
    @auraenabled
    public static resultWrapper createDraftPlan(List<KAMDataEntryLineWrapper> datWrapList, Id accId,Id dfHeaderId,Id SalesOrg,String mktYear,String DSapCode,List<Id> delPayList,String div, String screenFlow){
        //created by: Ishita Kansal - ticket no.: RITM0266323
        //check the screenflow variable and store data at the account level
        if(screenFlow != 'undefined' && screenFlow != '' && null != screenflow){
            Account acnt = new Account();
            acnt.Id = accId;
            acnt.Screen_Flow_Value__c = screenFlow;
            system.debug('**screenFlow' + acnt.Screen_Flow_Value__c);
            update acnt;
        }
        //end of the screenflow setting
     
        //Logic Updated by Priya for RITM0266367
        string accountUniqueId;
        account acc = [select id,name,SAP_Code__c,combination_key__c,recordtype.developername from account where id =:accId ];         
        if(acc.recordtype.developername=='Retailer'){
            accountUniqueId = acc.id;
        }else if(acc.recordtype.developername=='Ship_To'){
            accountUniqueId = acc.combination_key__c;
        }else{
            accountUniqueId = acc.SAP_Code__c;
        }
        Sales_Org__c sorg = [Select id, name,Sales_Org_Code__c from Sales_Org__c where id =:SalesOrg limit 1];
        Division__c divis=[Select id,Division_Code__c from Division__c where id=:div];
        CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapper = CalculateMarkettingYearHelper.calculateMarketingYear(sorg.Sales_Org_Code__c);
        Integer myear;Date startDate; Date endDate;
        if(mktYear == 'first'){
            myear = mktYearWrapper.firstMarketingYear;
            startDate = mktYearWrapper.firstMarketingYearStartDate;
            endDate = mktYearWrapper.firstMarketingYearEndDate;
        }
        else if(mktYear == 'second'){
            myear = mktYearWrapper.secondMarketingYear;
            startDate = mktYearWrapper.secondMarketingYearStartDate;
            endDate = mktYearWrapper.secondMarketingYearEndDate;
        } 
        Map<Id,Id> dskuMAp=new Map<Id,Id>();
        Draft_Plan_Header__c dHead;
        resultWrapper rp=new resultWrapper();
        rp.dHeaderId=dfHeaderId;
        if(dfHeaderId == null){
            system.Debug('create header');
            dHead=new Draft_Plan_Header__c();
            dHead.Distributor__c=accId;
            dHead.MKT_Year_Name__c=String.valueOf(myear);
            dHead.MKT_Year_Start_Date__c=startdate;
            dHead.MKT_Year_End_Date__c=enddate;
            dHead.Division__c=div;
            dHead.Sales_Org__c=SalesOrg;
            dHead.Status__c='Draft';
            dhead.Combination_Key__c=accountUniqueId +divis.Division_Code__c+ String.valueOf(myear);
            if(sorg.Sales_Org_Code__c==salesOrgCodeNAM){
                dhead.CurrencyIsoCode=currencyCodeNAM;
            }
            else if(sorg.Sales_Org_Code__c==salesOrgCodeCanada){
                dhead.CurrencyIsoCode=currencyCodeCanada; 
            }
            insert dHead;
            rp.dHeaderId=dHead.Id;
        }
        
       // Map<Draft_Plan__c,List<Draft_Plan_Payout__c>> dfMAp=new Map<Draft_Plan__c,List<Draft_Plan_Payout__c>>();          //updated by: Gunnagya for ticket no.: RITM0266323
        Map<Id,List<Draft_Plan_Payout__c>> dfSkuMAp=new Map<Id,List<Draft_Plan_Payout__c>>();
        List<Draft_Plan__c> dfList=new List<Draft_Plan__c>();
        List<Id> dfpDelList=new List<Id>();
        Set<Id> allPayoutIds = new Set<Id>(); 
        for(KAMDataEntryLineWrapper kem:datWrapList){
            if(kem.dQty!=null && kem.dAmt!=null){
                Draft_Plan__c dfPlan= new Draft_Plan__c();
                if(kem.dfId!=null){
                    dfPlan.Id=kem.dfId;
                }
                else{
                    if(dHead!=null ){
                        dfPlan.Draft_Plan_Header__c=dHead.id;
                    }else{
                        dfPlan.Draft_Plan_Header__c=dfHeaderId;
                    }
                }
                dfPlan.EDI_Amount_LY__c=kem.eAmt;
                dfPlan.EDI_Quantity_LY__c=kem.eQty;
                dfPlan.Invoice_Amount_LY__c=kem.iAmt;
                dfPlan.Invoice_Quantity_LY__c=kem.iQty;
                dfPlan.Draft_Amount__c=kem.dAmt;//to calc dAmt
                dfPlan.Draft_Quantity__c=kem.dQty;
                dfPlan.Pct_Of_Prev_Yr__c=kem.dPct;
                dfPlan.Value_At_Draft__c=kem.dVal;//to calc dVal
                dfPlan.Distributor__c=accId;
                dfPlan.Sku__c=kem.sid;
                dfPlan.Product_Price__c=kem.productPrice;
                if(sorg.Sales_Org_Code__c==salesOrgCodeNAM){
                    dfPlan.CurrencyIsoCode=currencyCodeNAM;
                }
                else if(sorg.Sales_Org_Code__c==salesOrgCodeCanada){
                    dfPlan.CurrencyIsoCode=currencyCodeCanada; 
                }
                List<Draft_Plan_Payout__c> dfpList=new List<Draft_Plan_Payout__c>();
                if( kem.dfpayList!=null){
                    for(payoutWrapper pw:kem.dfpayList){
                        system.debug('in pw'+pw.Tier);
                        if(pw.threshold!=0 && pw.payout!=0 && pw.del==false){
                            system.debug('hell no del');
                            Draft_Plan_Payout__c dfpayout=new Draft_Plan_Payout__c();
                            if(kem.dfId == pw.draftId && pw.payoutId != null){//updated by: Gunnagya for ticket no.: RITM0266323
                                dfpayout.Id = pw.payoutId;
                                allPayoutIds.add(dfpayout.Id);
                            }
                            dfpayout.Tier__c = pw.Tier;
                            dfpayout.Threshold_Quantity__c = pw.threshold;
                            dfpayout.Payout_Per_Unit__c = pw.payout;
                            dfpayout.Payout_Per_Unit_Pct__c = pw.payoutPct;
                            dfpayout.Payout_Entry_Type__c = kem.payType;
                            dfpayout.Reason_Code__c = kem.reasonCode;
                            if(sorg.Sales_Org_Code__c == salesOrgCodeNAM){
                                dfpayout.CurrencyIsoCode = currencyCodeNAM;
                            }
                            else if(sorg.Sales_Org_Code__c == salesOrgCodeCanada){
                                dfpayout.CurrencyIsoCode = currencyCodeCanada; 
                            }
                            if(kem.dfId != null){
                                dfpayout.Draft_Plan__c = kem.dfId; //updated by: Gunnagya for ticket no.: RITM0266323
                            }
                            dfpList.add(dfpayout);
                        }
                        else if(pw.del==true){
                            dfpDelList.add(pw.payoutId);
                        }
                    }
                }
                dfList.add(dfPlan);
                if(dfpList.size()>0){
                    dfSkuMAp.put(dfPlan.SKU__c,dfpList);
                }
            }
        }
        upsert dfList;
        Map<Draft_Plan__c,Id> finMap=new Map<Draft_Plan__c,Id>();
        for(Draft_Plan__c df:dfList){
            dskuMAp.put(df.SKU__C,df.Id);
            finMap.put(df,df.id);
        }
        rp.draftMap=dskuMAp;
        if(delPayList.size()>0){
            Set<Id> deleteIdSet = new Set<Id>();
            deleteIdSet.addAll(delPayList);
            deleteIdSet.removeAll(allPayoutIds);
            List<Draft_Plan_Payout__c> delList=[SELECT id from Draft_Plan_Payout__c WHERE id IN: deleteIdSet];
            delete delList;
        }
        Map<Draft_Plan__c,Id> dfpMAp=new Map<Draft_Plan__c,Id>();
        List<Draft_Plan_Payout__c> dppList=new List<Draft_Plan_Payout__c>();
        Set<Draft_Plan_Payout__c> dppSet=new Set<Draft_Plan_Payout__c>();
        for(id dg:dfSkuMAp.keyset()){
            for(Draft_Plan_Payout__c dgg:dfSkuMAp.get(dg)){
                system.debug('in last'+dgg.Tier__c);
                dgg.Draft_Plan__c=dskuMAp.get(dg);
                dppSet.add(dgg);
            }
        }
        dppList.AddAll(dppSet);
        map<Id,List<Draft_Plan_Payout__c>> dpayMap=new Map<Id,List<Draft_Plan_Payout__c>>();
        upsert dppList;
        for(Draft_Plan_Payout__c dppay:dppList){
            if(dpayMap.containsKey(dppay.Draft_Plan__c))
            {
                dpayMap.get(dppay.Draft_Plan__c).add(dppay);
            }
            else
            {
                dpayMap.put(dppay.Draft_Plan__c,new List<Draft_Plan_Payout__c>{dppay});//to cehck
            }
        }
        rp.payOutMap=dpayMap;
        Draft_Plan_Header__c dpf=new Draft_Plan_Header__c(Id=rp.dHeaderId);
        update dpf;
        Draft_Plan_Header__c dfpHead=[select id,lastmodifieddate,LastModifiedById,LastModifiedBy.Name from Draft_Plan_Header__c where id=:dpf.Id];
        rp.savedname = dfpHead.LastModifiedBy.Name;
        DateTime dT =  dfpHead.LastModifiedDate;
        rp.saveddate=dT.format('MM-dd-yyyy hh:mm');
        return rp;
    }
    
    public static KAMDataEntryWrapper generateFinalWrapper(Integer myear,date startDate,date endDate,Account a,Sales_Org__c sorg,Integer prevYear,Integer curYear,String divId,boolean hist){
        KAMDataEntryWrapper KAMDEW = new KAMDataEntryWrapper();
        Map<String,List<SKUKamWrapper>> skuMap = new map<String,List<SKUKamWrapper>>();
        Map<Id,List<SKUKamWrapper>> skuIdMap = new map<Id,List<SKUKamWrapper>>();
        List<SKUKamWrapper> skuList = new List<SKUKamWrapper>();
        map<id,Draft_Plan__c> dpwrpMap = new map<Id,Draft_Plan__c>();
        Set<Id> skuIdSet = new Set<Id>();
        List<Id> skuIdList = new List<Id>();
        List<KAMCategoryWrapper> catLineList = new List<KAMCategoryWrapper>();
        date refdate;
        if(startDate > system.today()){
            refdate = startDate;
        }else{
            refdate = system.today(); 
        }
        List<PriceBookMaster__c> pbmList =[SELECT Id, Name, Active__c, CompositeKey__c, EndDate__c, SKUCode__c,SKUCode__r.SKU_Code__c,SKUCode__r.Name,SKUCode__r.UOM__c,SKUCode__r.SKU_Description__c,SKUCode__r.isparent__c,
                                           SKUCode__r.Product_Category__c,SKUCode__r.Material_Group_5__c,SKUCode__r.Brand_Name__c,sales_org__c,startdate__c,Price__c,DistributorCustomerCode__c
                                           FROM PriceBookMaster__c where sales_org__c=:sorg.id AND (DistributorCustomerCode__c=:a.id OR DistributorCustomerCode__c=Null)
                                           AND ((startdate__c<=:startDate AND EndDate__c>=:endDate) 
                                                OR (startdate__c>=:startDate AND startdate__c<=:endDate) OR 
                                                (EndDate__c>=:startDate AND EndDate__c<=:endDate) )AND Division__c=:divId AND SKUCode__r.isparent__c=true ORDER BY SKUCode__r.Product_Category__c];
        Map<String,decimal> pricebookMasterMAp = new map<String,decimal>();
        for(PriceBookMaster__c pm:pbmList){
            pricebookMasterMap.put(pm.SKUCode__r.SKU_Code__c + pm.DistributorCustomerCode__c, pm.Price__c);
        }
        Map<Id,SKUKamWrapper> skuWrapMap =new map<id,SKUKamWrapper>();
        
        for(PriceBookMaster__c pm:pbmList){
            if(!skuWrapMap.containskey(pm.SKUCode__c)){
                SKUKamWrapper skwrp=new SKUKamWrapper();
                skwrp.SKUId = pm.SKUCode__c;
                skwrp.uom = pm.SKUCode__r.UOM__c;
                skwrp.SKUName = pm.SKUCode__r.SKU_Description__c;
                skwrp.SkUCategory = pm.SKUCode__r.Material_Group_5__c;
                skwrp.SkUBrand = pm.SKUCode__r.Brand_Name__c;//Added Brand Filter by GRZ(Nikhil Verma) RITM0478313 03-01-2023-->
                skwrp.SkUCode = pm.SKUCode__r.SKU_Code__c;
                if(pm.DistributorCustomerCode__c != null){
                    skwrp.price = pricebookMasterMap.get(pm.SKUCode__r.SKU_Code__c+pm.DistributorCustomerCode__c);
                }else{
                    skwrp.price=pm.Price__c;
                }
                skuIdSet.add(pm.SKUCode__c);
                skuList.add(skwrp);
                skuWrapMap.put(pm.SKUCode__c,skwrp);   
            }
        }
        skuIdList.addAll(skuIdSet);
        for(SKUKamWrapper skw:skuList){
            if(skuMap.containsKey(skw.SkUCategory)){
                skuMap.get(skw.SkUCategory).add(skw);
            }
            else{
                skuMap.put(skw.SkUCategory,new List<SKUKamWrapper>{skw});
            }
        }        
        account acc = [select id,SAP_Code__c,combination_key__c,recordtype.developername,OwnerId,Screen_Flow_Value__c from account where id = :a.id];
        
        Map<String,Decimal> ediTotalMap = new Map<String,Decimal>();
        Map<String,Decimal> ediAmtMap = new Map<String,Decimal>();
        Map<String,Decimal> invTotalMap = new Map<String,Decimal>();
        Map<String,Decimal> invAmtMap = new Map<String,Decimal>();
        AggregateResult[] aggregatesecSale;
        List<Secondary_Sales_Data__c> secOrderList = new List<Secondary_Sales_Data__c>();
        AggregateResult[] aggregateInvPlan;
        List<Invoice_Line_Item__c> salesOrderLineList = new List<Invoice_Line_Item__c>();
        
        //Logic Updated by Priya for RITM0266367 - Open functinality for Sold-to, Ship-to and retailer account accordingly conditions are met below.
        if(acc.recordtype.developername == 'Distributor'){
            aggregatesecSale = [SELECT Product_Name__r.sku_parent_Code__c skcode,SUM(Product_Quantity__c) ediTotal,SUM(Sales_Amount__c) ediAmt
                                FROM Secondary_Sales_Data__c  where Sold_to_Party__c=:a.id 
                                and Sales_Date__c>=:startDate and Sales_Date__c<=:endDate 
                                and Division__c=:divId
                                GROUP BY Product_Name__r.sku_parent_Code__c];
            secOrderList = [select id,Product_Name__c,Product_Name__r.Name,
                            Product_Quantity__c, Sold_To_Party__r.Name, Sales_Date__c ,Customer_Product_Code__c,Sales_Amount__c
                            from Secondary_Sales_Data__c where Sold_to_Party__c=:a.id 
                            and Sales_Date__c>=:startDate and Sales_Date__c<=:endDate and Product_Name__c IN:skuIdList
                            and Division__c=:divId]; 
        }
        else if(acc.recordtype.developername=='Ship_To'){
            aggregatesecSale = [SELECT Product_Name__r.sku_parent_Code__c skcode,SUM(Product_Quantity__c) ediTotal,SUM(Sales_Amount__c) ediAmt
                                FROM Secondary_Sales_Data__c  where Ship_To_Party__c=:a.id 
                                and Sales_Date__c>=:startDate and Sales_Date__c<=:endDate 
                                and Division__c=:divId
                                GROUP BY Product_Name__r.sku_parent_Code__c];
            secOrderList = [select id,Product_Name__c,Product_Name__r.Name,
                            Product_Quantity__c, Ship_To_Party__r.Name, Sales_Date__c ,Customer_Product_Code__c,Sales_Amount__c
                            from Secondary_Sales_Data__c where Ship_To_Party__c=:a.id 
                            and Sales_Date__c>=:startDate and Sales_Date__c<=:endDate and Product_Name__c IN:skuIdList
                            and Division__c=:divId]; 
        }
        else if(acc.recordtype.developername=='Retailer'){
            aggregatesecSale = [SELECT Product_Name__r.sku_parent_Code__c skcode,SUM(Product_Quantity__c) ediTotal,SUM(Sales_Amount__c) ediAmt
                                FROM Secondary_Sales_Data__c  where Customer_Name__c=:a.id 
                                and Sales_Date__c>=:startDate and Sales_Date__c<=:endDate 
                                and Division__c=:divId and Product_Name__c != NULL AND Product_Name__r.sku_parent_Code__c != null
                                GROUP BY Product_Name__r.sku_parent_Code__c];// RITM0560054 GRZ(Nikhil Verma) 24-05-2023-->
            secOrderList = [select id,Product_Name__c,Product_Name__r.Name,
                            Product_Quantity__c, Customer_Name__r.Name, Sales_Date__c ,Customer_Product_Code__c,Sales_Amount__c
                            from Secondary_Sales_Data__c where Customer_Name__c=:a.id 
                            and Sales_Date__c>=:startDate and Sales_Date__c<=:endDate and Product_Name__c IN:skuIdList
                            and Division__c=:divId]; 
        }
                
        map<String,Secondary_Sales_Data__c> secMap = new map<String,Secondary_Sales_Data__c>();
        for (AggregateResult ar : aggregatesecSale)  {
            String skureg = String.valueof(ar.get('skcode')).replaceFirst('^0+','');
            ediTotalMap.put(skureg,(Decimal)ar.get('ediTotal'));
            ediAmtMap.put(skureg,(Decimal)ar.get('ediAmt'));
        }
        for(Secondary_Sales_Data__c sec:secOrderList){
            secMap.put(sec.Product_Name__c,sec);
        }        
        if(acc.recordtype.developername == 'Ship_To'){
            aggregateInvPlan = [SELECT SKU__r.sku_parent_Code__c skcode,SUM(Quantity__c) invtotal,SUM(Net_Value__c) invAmt
                                FROM Invoice_Line_Item__c where Invoice__r.Ship_To_Party_Account__c=:a.Id and SKU__r.sku_parent_Code__c!=null
                                and Invoice__r.Billing_Date__c>=:startDate and Invoice__r.Billing_Date__c<=:endDate and Invoice__r.Division__c=:divId
                                GROUP BY SKU__r.sku_parent_Code__c];
            salesOrderLineList = [select id,Invoice__c,Invoice__r.Ship_To_Party_Account__c,SKU__c,Quantity__c,Net_Value__c    
                                  from Invoice_Line_Item__c where Invoice__r.Ship_To_Party_Account__c=:a.Id 
                                  and SKU__c In:skuIdList and Invoice__r.Billing_Date__c>=:startDate and Invoice__r.Billing_Date__c<=:endDate and Invoice__r.Division__c=:divId];     
        }
        else {
            aggregateInvPlan = [SELECT SKU__r.sku_parent_Code__c skcode,SUM(Quantity__c) invtotal,SUM(Net_Value__c) invAmt
                                FROM Invoice_Line_Item__c where Invoice__r.Sold_to_Party__c=:a.Id and SKU__r.sku_parent_Code__c!=null
                                and Invoice__r.Billing_Date__c>=:startDate and Invoice__r.Billing_Date__c<=:endDate and Invoice__r.Division__c=:divId
                                GROUP BY SKU__r.sku_parent_Code__c];
            salesOrderLineList = [select id,Invoice__c,Invoice__r.Sold_to_Party__c,SKU__c,Quantity__c,Net_Value__c    
                                  from Invoice_Line_Item__c where Invoice__r.Sold_to_Party__c=:a.Id 
                                  and SKU__c In:skuIdList and Invoice__r.Billing_Date__c>=:startDate and Invoice__r.Billing_Date__c<=:endDate and Invoice__r.Division__c=:divId];
        }
                
        map<String,Invoice_Line_Item__c> saleMap=new map<String,Invoice_Line_Item__c>();
        for (AggregateResult ar : aggregateInvPlan)  {
            String skureg = String.valueof(ar.get('skcode')).replaceFirst('^0+','');
            invTotalMap.put(skureg,(Decimal)ar.get('invtotal'));
            invAmtMap.put(skureg,(Decimal)ar.get('invAmt'));
        }
        for(Invoice_Line_Item__c sal:salesOrderLineList){
            saleMap.put(sal.SKU__c,sal);
            
        }
        List<Draft_Plan__c> draftPlanListCurrent=[SELECT Id,Draft_Plan_Header__r.id,Draft_Plan_Header__r.Distributor__c, Draft_Plan_Header__r.Sales_Org__r.Sales_Org_Code__c, 
                                                  Draft_Plan_Header__r.Status__c, Draft_Plan_Header__r.MKT_Year_End_Date__c, Draft_Plan_Header__r.MKT_Year_Start_Date__c,SKU__c,Draft_Plan_Header__r.MKT_Year_Name__c,
                                                  Product_Price__c, EDI_Quantity_LY__c, EDI_Amount_LY__c, Invoice_Quantity_LY__c, Invoice_Amount_LY__c,
                                                  Draft_Quantity__c, Draft_Amount__c,Pct_Of_Prev_Yr_Target__c,Target_Amount__c,Target_Quantity__c,Target_Updated__c,Value_At_Target__c, Value_At_Draft__c, Pct_Of_Prev_Yr__c,Draft_Plan_Header__r.Combination_Key__c,sku__r.SKU_Code__c,sku__r.Name,sku__r.Product_Category__c ,
                                                  (select id,Payout_Entry_Type__c,Payout_Per_Unit__c,Payout_Per_Unit_Pct__c,Qty_as_a_Pct__c,Qty_as_Percentage__c,Reason_Code__c,Threshold_Quantity__c,
                                                   Tier__c,Value_At_Target__c,draft_plan__c,Lastmodifieddate from Draft_Plan_Payouts__r order by Tier__c) FROM Draft_Plan__c 
                                                  where Draft_Plan_Header__r.Distributor__c=:a.Id and Draft_Plan_Header__r.MKT_Year_Start_Date__c >=:startDate
                                                  AND Draft_Plan_Header__r.MKT_Year_End_Date__c <=:endDate
                                                  AND Draft_Plan_Header__r.Sales_Org__r.Sales_Org_Code__c =:a.Sales_Org__r.Sales_Org_Code__c
                                                  AND SKU__c In:skuIdList order by sku__r.Product_Category__c,SKU__r.Name];        
        for(Draft_Plan__c dp:draftPlanListCurrent){
            dpwrpMap.put(dp.sku__c,dp);
        }
        
        List<KAMDataEntryLineWrapper> totaldataLineList = new List<KAMDataEntryLineWrapper>();
        for(String sk:skuMap.keyset()){
            List<KAMDataEntryLineWrapper> dataLineList=new List<KAMDataEntryLineWrapper>();
            KAMCategoryWrapper kCat = new KAMCategoryWrapper();
            kCat.prodCategory=sk;
            for(SKUKamWrapper skw:skuMap.get(sk)){
                KAMDataEntryLineWrapper ke=new KAMDataEntryLineWrapper();
                ke.cat=skw.SkUCategory;
                ke.brnd = skw.SkUBrand;//Added Brand Filter by GRZ(Nikhil Verma) RITM0478313 03-01-2023-->
                ke.sid=skw.SKUId;
                ke.UOM=skw.uom;
                ke.isProductChecked = false;
                ke.disabledItem = false;
                skw.SkUCode = skw.SkUCode.replaceFirst('^0+','');
                ke.SkuName=skw.SkUCode +'-'+skw.SKUName;
                ke.productPrice=skw.price;
                ke.payType = 'Value';
                if(ediTotalMap.containskey(skw.SkUCode)){
                    ke.eQty = ediTotalMap.get(skw.SkUCode);
                    ke.eAmt = ediAmtMap.get(skw.SkUCode) != null ? ediAmtMap.get(skw.SkUCode) : 0;
                }
                if(invTotalMap.containskey(skw.SkUCode)){
                    ke.iQty = invTotalMap.get(skw.SkUCode);
                    ke.iAmt = invAmtMap.get(skw.SkUCode) != null ? invAmtMap.get(skw.SkUCode) : 0;
                }else{
                    ke.pctDisabled = true;
                }
                if(dpwrpMap.containskey(skw.SKUId)){
                    if(dpwrpMap.get(skw.SKUId).Target_Updated__c==true){
                        ke.dQty=dpwrpMap.get(skw.SKUId).Target_Quantity__c;
                        system.debug('Saved dAmt>>'+ ke.dAmt);
                        if(dpwrpMap.get(skw.SKUId).Target_Amount__c!=null && dpwrpMap.get(skw.SKUId).Target_Amount__c >0.00){
                            ke.dAmt=dpwrpMap.get(skw.SKUId).Target_Amount__c;
                            system.debug('Saved dAmt>>'+ ke.dAmt);
                            if(ke.dAmt != null && ke.dAmt > 0)//updated by: Gunnagya for ticket no.: RITM0266323
                            {
                                ke.isProductChecked = true;
                            }else{
                                ke.isProductChecked = false;
                            }
                        }
                        else{
                            ke.dAmt=0.0;                  }
                            ke.dPct=dpwrpMap.get(skw.SKUId).Pct_Of_Prev_Yr_Target__c;
                            ke.dVal=dpwrpMap.get(skw.SKUId).Value_At_Target__c;
                    }
                    else{
                        ke.dQty=dpwrpMap.get(skw.SKUId).Draft_Quantity__c;
                        if(dpwrpMap.get(skw.SKUId).Draft_Amount__c!=null && dpwrpMap.get(skw.SKUId).Draft_Amount__c>0.00){
                            ke.dAmt=dpwrpMap.get(skw.SKUId).Draft_Amount__c;
                            if(ke.dAmt != null && ke.dAmt > 0) //updated by: Gunnagya for ticket no.: RITM0266323
                            {
                                ke.isProductChecked = true;
                            }else{
                                ke.isProductChecked = false;
                            }
                        }
                        else{
                            ke.dAmt=0.0;                  }
                            ke.dPct=dpwrpMap.get(skw.SKUId).Pct_Of_Prev_Yr__c;
                            ke.dVal=dpwrpMap.get(skw.SKUId).Value_At_Draft__c;
                    }
                    ke.dfId=dpwrpMap.get(skw.SKUId).Id;
                    String type;
                    String rcode;
                    List<payoutWrapper>paylist=new List<payoutWrapper>();
                    for(Draft_Plan_Payout__c dpp:dpwrpMap.get(skw.SKUId).Draft_Plan_Payouts__r){
                        payoutWrapper pw=new payoutWrapper();
                        pw.LastModifiedDate=dpp.LastModifiedDate;//updated by: Gunnagya for ticket no.: RITM0266323
                        pw.payoutId=dpp.id;
                        pw.draftId=dpp.Draft_Plan__c;
                        pw.Tier=dpp.Tier__c;
                        pw.threshold=dpp.Threshold_Quantity__c;
                        pw.quantity=dpp.Qty_as_Percentage__c;//updated by: Gunnagya for ticket no.: RITM0266323
                        pw.reason=dpp.Reason_Code__c;
                        pw.type=dpp.Payout_Entry_Type__c;
                        type=dpp.Payout_Entry_Type__c;
                        rcode=dpp.Reason_Code__c;
                        pw.del=false;
                        pw.payoutPct=dpp.Payout_Per_Unit_Pct__c;
                        pw.payout=dpp.Payout_Per_Unit__c;
                        paylist.add(pw);
                    }
                    if(acc.Screen_Flow_Value__c=='New Flow Screen'){
                        Map<Decimal,payoutWrapper> finalPayoutWrapper=new Map<Decimal,payoutWrapper>();
                        for(payoutWrapper pw:paylist){
                            if(finalPayoutWrapper.containsKey(pw.Tier)){
                                if(finalPayoutWrapper.get(pw.Tier).LastModifiedDate<pw.LastModifiedDate){
                                    finalPayoutWrapper.put(pw.Tier,pw);
                                }
                            }
                            else{
                                finalPayoutWrapper.put(pw.Tier,pw);
                            }
                        }
                        Ke.dfpayList=finalPayoutWrapper.values(); 
                    }
                    else{
                        Ke.dfpayList=paylist;
                    }
                    if(type==Null){
                        type='Value';
                    }
                    ke.payType = type;
                    ke.reasonCode = rcode;
                    ke.expanded = false;
                }
                dataLineList.add(ke);               
            }
            totaldataLineList.addAll(dataLineList);
            kCat.KAMDataline=dataLineList;
            catLineList.add(kCat);
        }
        Decimal tInvoice=0.0;
        Decimal tDraft=0.0;
        Decimal tValueDraft=0.0;
        Decimal tEDI=0.0;
        Decimal tpctDraft=0.0;
        Decimal tRpctDraft=0.0;
        if(totaldataLineList.size()>0){
            for(KAMDataEntryLineWrapper dcal:totaldataLineList){
                if(dcal.iAmt!=null){
                    tInvoice+=dcal.iAmt;
                }
                tDraft=0.0;
                tValueDraft=0.0;
                if(dcal.eAmt!=null){
                    tEDI+=dcal.eAmt;
                }
                tpctDraft=0.0;  
            }
        }
        KAMDEW.accountName = a.name;
        KAMDEW.currentYear=curYear;
        KAMDEW.previousYear=prevYear;
        if(hist==true){
            List<KAMDataEntryLineWrapper> histdataLineList = new List<KAMDataEntryLineWrapper>();
            for(KAMDataEntryLineWrapper ke:totaldataLineList){
                if(ke.eQty!=null || ke.eAmt!=null || ke.iQty!=null || ke.iAmt!=null || ke.dQty!=null){
                    histdataLineList.add(ke);
                }
            }
            KAMDEW.KAMTotalDataline=histdataLineList;
        }
        else{
            KAMDEW.KAMTotalDataline=totaldataLineList;
        }
        KAMDEW.KAMCatLine=catLineList;
        KAMDEW.totalEDI=tEDI;
        KAMDEW.totalInvoice=tInvoice;
        KAMDEW.totalDraft=tDraft;
        KAMDEW.totalVal=tValueDraft;
        KAMDEW.pctDraft=tpctDraft;
        KAMDEW.Approved=false;
        KAMDEW.MKTName=String.valueOf(myear);
        KAMDEW.MKTStart=startDate;
        KAMDEW.MKTEnd=endDate;
        KAMDEW.distSAPCode=a.SAP_Code__c;
        KAMDEW.sOrgId=a.Sales_Org__r.id;
        return KAMDEW;
    }

    @AuraEnabled
    public static Boolean sendEmailMsg(String url, String fileName, String accName){
        Boolean valid = false;
        PageReference pageRef = new PageReference(url);
        Blob body;
        if(Test.isRunningTest()) { 
          body = blob.valueOf('Unit.Test');
        } else {
          body = pageRef.getContent();
        }
        List<String> emailaddress = new List<String>();
        emailaddress.add(UserInfo.getUserEmail());      
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('application/pdf');
        attach.setFileName(fileName + '.pdf');
        attach.setInline(false);
        attach.Body = body;
        List<OrgWideEmailAddress> owa = [SELECT id, DisplayName, Address FROM OrgWideEmailAddress WHERE displayname =: 'Sales Excellence' ];
        if(!owa.isEmpty()){
            String emailBody = 'Hi ' + UserInfo.getName() + ',' + 
            '<p> Please find the attached Draft Plan PDF for ' + accName + '. </p>' +
            '<p>Regards,</p>' + 
            '<p>UPL Sales.</p>' + 
            '<p></p>' + 
            '<p>This is an auto-generated e-mail. Please do not reply.</p>'; 
            String fromAdressId = owa[0].id;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setOrgWideEmailAddressId(fromAdressId);
            mail.setHtmlBody(emailBody);
            mail.setToAddresses(emailaddress);
            mail.setSubject('Draft Plan PDF || ' + accName );
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {mail};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages,false);
            if( results != null ){
                if (results[0].success ){
                    valid = true;
                }else{
                    valid = false;
                    System.debug( 'The email failed to send: ' +  results[0].errors[0].message );
                }
            }else{
                valid = false;
            }
        }    
        return valid;
    }

    // Draft Plan Clone RITM0560054 GRZ(Nikhil Verma) 24-05-2023-->
    @AuraEnabled
    public static Wrapper fetchExistingDraftPlan(String accountId, String mktYear){
        Wrapper wrap = new Wrapper();
        try {
            Account a = [SELECT name,Sales_Org__c,Sales_Org__r.Sales_Org_Code__c,SFDC_Distributor_Code__c,SAP_Code__c, Screen_Flow_Value__c FROM account WHERE id = :accountId]; 
            CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapper = CalculateMarkettingYearHelper.calculateMarketingYear(a.Sales_Org__r.Sales_Org_Code__c);
            Integer myear; Date startDate; Date endDate;
            if(mktYear == 'first'){
                myear = mktYearWrapper.firstMarketingYear;
                startDate = mktYearWrapper.firstMarketingYearStartDate;
                endDate = mktYearWrapper.firstMarketingYearEndDate;
            }
            else if(mktYear == 'second'){
                myear = mktYearWrapper.secondMarketingYear;
                startDate = mktYearWrapper.secondMarketingYearStartDate;
                endDate = mktYearWrapper.secondMarketingYearEndDate;
            } 
            Integer curYear = Integer.valueof(myear);
            Integer prevYear = endDate.year()-1;
            List<Draft_Plan_Header__c> draftPlanList = [SELECT Id,Name,MKT_Year_Name__c,Status__c,Distributor__c,Distributor__r.Name,Owner.Name 
                                                        FROM Draft_Plan_Header__c WHERE Distributor__c !=: accountId AND
                                                        MKT_Year_Start_Date__c >=: startDate AND MKT_Year_End_Date__c <=: endDate 
                                                        AND OwnerId =: UserInfo.getUserId() order by createdDate desc];  
            if(draftPlanList != null && !draftPlanList.isEmpty()){
                wrap.data = draftPlanList;
            }else{
                wrap.success = false;
                wrap.message = 'No existing Draft Plan found.';
            }
        } catch (Exception ex) {
            wrap.success = false;
            wrap.message = 'Please Contact System Administrator.';
        }
        return wrap;
    }

    // Draft Plan Clone RITM0560054 GRZ(Nikhil Verma) 24-05-2023-->
    @AuraEnabled
    public static Wrapper createCloneDraftPlan(String accountId, String cloneDraftId){
        Wrapper wrap = new Wrapper();
        try {
            string accountUniqueId;
            account acc = [select id,name,SAP_Code__c,combination_key__c,recordtype.developername from account where id =:accountId ];         
            if(acc.recordtype.developername=='Retailer'){
                accountUniqueId = acc.id;
            }else if(acc.recordtype.developername=='Ship_To'){
                accountUniqueId = acc.combination_key__c;
            }else{
                accountUniqueId = acc.SAP_Code__c;
            }
            Draft_Plan_Header__c dh = [SELECT  Id,MKT_Year_Name__c,CurrencyIsoCode,MKT_Year_Start_Date__c,MKT_Year_End_Date__c,Division__c,Sales_Org__c,Division__r.Division_Code__c from Draft_Plan_Header__c where Id =: cloneDraftId];
            Draft_Plan_Header__c dHead = new Draft_Plan_Header__c();
            dHead.Distributor__c            = accountId;
            dHead.Status__c                 = 'Draft';
            dHead.MKT_Year_Name__c          = dh.MKT_Year_Name__c;
            dHead.MKT_Year_Start_Date__c    = dh.MKT_Year_Start_Date__c;
            dHead.MKT_Year_End_Date__c      = dh.MKT_Year_End_Date__c;
            dHead.Division__c               = dh.Division__c;
            dHead.Sales_Org__c              = dh.Sales_Org__c;
            dHead.CurrencyIsoCode           = dh.CurrencyIsoCode;
            dhead.Combination_Key__c        = accountUniqueId + dh.Division__r.Division_Code__c + dh.MKT_Year_Name__c;
            insert dHead;
            
            Map<Id,Id> skuToOldPlanIdMap = new Map<Id,Id>();
            List<Draft_Plan__c> dpList = new List<Draft_Plan__c>();
            for(Draft_Plan__c dp : [SELECT Id,EDI_Amount_LY__c,EDI_Quantity_LY__c,Invoice_Amount_LY__c,Invoice_Quantity_LY__c,Draft_Amount__c,Draft_Quantity__c,Pct_Of_Prev_Yr__c,Value_At_Draft__c,Sku__c,Product_Price__c,CurrencyIsoCode FROM Draft_Plan__c WHERE Draft_Plan_Header__c =: cloneDraftId]){
                Draft_Plan__c dfPlan = new Draft_Plan__c();
                dfPlan.Draft_Plan_Header__c     = dHead.Id;
                dfPlan.Distributor__c           = accountId;
                dfPlan.EDI_Amount_LY__c         = dp.EDI_Amount_LY__c;
                dfPlan.EDI_Quantity_LY__c       = dp.EDI_Quantity_LY__c;
                dfPlan.Invoice_Amount_LY__c     = dp.Invoice_Amount_LY__c;
                dfPlan.Invoice_Quantity_LY__c   = dp.Invoice_Quantity_LY__c;
                dfPlan.Draft_Amount__c          = dp.Draft_Amount__c;
                dfPlan.Draft_Quantity__c        = dp.Draft_Quantity__c;
                dfPlan.Pct_Of_Prev_Yr__c        = dp.Pct_Of_Prev_Yr__c;
                dfPlan.Value_At_Draft__c        = dp.Value_At_Draft__c;
                dfPlan.Sku__c                   = dp.Sku__c;
                dfPlan.Product_Price__c         = dp.Product_Price__c;
                dfPlan.CurrencyIsoCode          = dp.CurrencyIsoCode;
                dpList.add(dfPlan);
                skuToOldPlanIdMap.put(dp.Sku__c, dp.Id);       
            }
            insert dpList;

            Map<Id,Id> oldIdToNewMap = new Map<Id,Id>();
            for(Draft_Plan__c dp : dpList){
                oldIdToNewMap.put(skuToOldPlanIdMap.get(dp.Sku__c), dp.Id);
            }

            List<Draft_Plan_Payout__c> dfpList = new List<Draft_Plan_Payout__c>();
            for(Draft_Plan_Payout__c dpp : [SELECT Id,Tier__c,Threshold_Quantity__c,Payout_Per_Unit__c,Payout_Per_Unit_Pct__c,Payout_Entry_Type__c,Reason_Code__c,CurrencyIsoCode,Draft_Plan__c FROM Draft_Plan_Payout__c WHERE Draft_Plan__c IN: skuToOldPlanIdMap.values()]){
                Draft_Plan_Payout__c dfpayout = new Draft_Plan_Payout__c();
                dfpayout.Tier__c                = dpp.Tier__c;
                dfpayout.Threshold_Quantity__c  = dpp.Threshold_Quantity__c;
                dfpayout.Payout_Per_Unit__c     = dpp.Payout_Per_Unit__c;
                dfpayout.Payout_Per_Unit_Pct__c = dpp.Payout_Per_Unit_Pct__c;
                dfpayout.Payout_Entry_Type__c   = dpp.Payout_Entry_Type__c;
                dfpayout.Reason_Code__c         = dpp.Reason_Code__c;
                dfpayout.CurrencyIsoCode        = dpp.CurrencyIsoCode;
                dfpayout.Draft_Plan__c          = oldIdToNewMap.get(dpp.Draft_Plan__c);
                dfpList.add(dfpayout);
            }
            insert dfpList;
        } catch (Exception ex) {
            wrap.success = false;
            wrap.message = ex.getMessage();
        }
        return wrap;
    }

    public class divWrapper {
        @AuraEnabled public Id divId{get;set;}
        @AuraEnabled public Integer divLength{get;set;}
        @AuraEnabled public string divName{get;set;}
        @AuraEnabled public String divCode{get;set;}  
    }

    /*Added for Approval History by GRZ(Nikhil Verma) RITM0478313 03-01-2023-->*/
    public class SubmitStatusWrapper{
        @AuraEnabled public List<ApprovalList> approvalList{get;set;}
        @AuraEnabled public Boolean canNotSubmit{get;set;}
    }

    public class ApprovalList{
        @AuraEnabled public DateTime createdDate{get;set;}
        @AuraEnabled public String stepStatus{get;set;}
        @AuraEnabled public String originalActorName{get;set;}
        @AuraEnabled public String actorName{get;set;}
        @AuraEnabled public String comments{get;set;}
    }
    /*****End *********** Added for Approval History by GRZ(Nikhil Verma) RITM0478313 03-01-2023-->*/

    public class KAMDataEntryWrapper {
        @AuraEnabled public string accountName {get;set;}
        @AuraEnabled public string screenFlow {get;set;}
        @AuraEnabled public Integer currentYear {get;set;}
        @AuraEnabled public Integer previousYear {get;set;}
        @AuraEnabled public Decimal totalEDI{get;set;}
        @AuraEnabled public Decimal totalInvoice{get;set;}
        @AuraEnabled public Decimal totalDraft{get;set;}
        @AuraEnabled public Decimal totalVal{get;set;}
        @AuraEnabled public Decimal pctDraft{get;set;}
        @AuraEnabled public List<KAMCategoryWrapper> KAMCatLine {get;set;}
        @AuraEnabled public List<KAMDataEntryLineWrapper> KAMTotalDataline {get;set;}   
        @AuraEnabled public boolean Approved{get;set;}
        @AuraEnabled public String lastSavedName{get;set;}
        @AuraEnabled public String lastSavedDate{get;set;}
        @AuraEnabled public Boolean showLastSaved{get;set;}
        @AuraEnabled public Id dfHeadId{get;set;}
        @AuraEnabled public Id MKTId{get;set;}
        @AuraEnabled public Id sOrgId{get;set;}
        @AuraEnabled public String distSAPCode{get;set;}
        @AuraEnabled public String MKTName{get;set;}
        @AuraEnabled public date MKTStart{get;set;}
        @AuraEnabled public date MKTEnd{get;set;}
    }

    public class KAMCategoryWrapper {
        @AuraEnabled public string prodCategory {get;set;}
        @AuraEnabled public List<KAMDataEntryLineWrapper> KAMDataline {get;set;}
    }
    
    public class KAMDataEntryLineWrapper {
        @AuraEnabled public String cat {get;set;}
        @AuraEnabled public string SkuName {get;set;}
        @AuraEnabled public string brnd {get;set;}//Added Brand Filter by GRZ(Nikhil Verma) RITM0478313 03-01-2023-->
        @auraenabled public boolean isProductChecked {get;set;}
        @AuraEnabled public boolean disabledItem {get;set;}
        @AuraEnabled public Decimal productPrice {get;set;}
        @AuraEnabled public Decimal eQty {get;set;}
        @AuraEnabled public Decimal iQty {get;set;}
        @AuraEnabled public Decimal eAmt {get;set;}
        @AuraEnabled public Decimal iAmt {get;set;}
        @AuraEnabled public Decimal dQty {get;set;}
        @AuraEnabled public Decimal dAmt {get;set;}
        @AuraEnabled public Decimal dPct {get;set;}
        @AuraEnabled public Decimal dVal {get;set;}
        @AuraEnabled public Id dfId {get;set;}
        @AuraEnabled public id sid{get;set;}
        @AuraEnabled public List<payoutWrapper> dfpayList{get;set;}
        @AuraEnabled public Boolean expanded{get;set;}
        @AuraEnabled public Boolean pctDisabled{get;set;}
        @AuraEnabled public String payType{get;set;}
        @AuraEnabled public String reasonCode{get;set;}
        @AuraEnabled public String UOM{get;set;}
        
    }
    public class SKUKamWrapper {
        @AuraEnabled public id SKUId{get;set;}
        @AuraEnabled public string SKUName{get;set;}
        @AuraEnabled public string SkUCategory{get;set;}
        @AuraEnabled public string SkUBrand{get;set;}//Added Brand Filter by GRZ(Nikhil Verma) RITM0478313 03-01-2023-->
        @AuraEnabled public string SkUCode{get;set;}
        @AuraEnabled public Decimal price{get;set;}
        @AuraEnabled public String uom{get;set;}
    }
    public class payoutWrapper {
        @AuraEnabled public id payoutId{get;set;}
        @AuraEnabled public id draftId{get;set;}
        @AuraEnabled public decimal Tier{get;set;}
        @AuraEnabled public Decimal threshold{get;set;}
        @AuraEnabled public Decimal quantity{get;set;}
        @AuraEnabled public Decimal payout{get;set;}
        @AuraEnabled public Decimal payoutPct{get;set;}
        @AuraEnabled public String reason{get;set;}
        @AuraEnabled public String type{get;set;}
        @AuraEnabled public Boolean del{get;set;}
        @AuraEnabled public DateTime LastModifiedDate{get;set;}
        
    }
    public class resultWrapper {
        @AuraEnabled public id dHeaderId{get;set;}
        @AuraEnabled public List<Id> draftIdList{get;set;}
        @AuraEnabled public Map<Id,Id> draftMap{get;set;}
        @AuraEnabled public Map<Id,List<Draft_Plan_Payout__c>> payOutMap{get;set;}
        @AuraEnabled public string savedname{get;set;}
        @AuraEnabled public String saveddate{get;set;} 
    }

    public class Wrapper {
        @AuraEnabled public Object data     {get;set;}
        @AuraEnabled public String message  {get;set;}
        @AuraEnabled public Boolean success {get;set;}
    
        public Wrapper(){
            this.message = 'Success';
            this.success = true;
        }
    }
}