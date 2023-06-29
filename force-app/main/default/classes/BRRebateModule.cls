public without sharing class BRRebateModule {
    public static boolean inFutureContext = false; 
    @Auraenabled
    public static rebateContractWrapper getContract(string startDatestring, string enddatestring){
        date startDate;
        date endDate;
        
        if(!string.isblank(startDatestring) && !string.isblank(enddatestring)){
            startDate = Date.valueOf(startDatestring);
            endDate = Date.valueOf(enddatestring);
        }
        else{
            startDate = [Select startDate From Period Where type = 'YEAR' and StartDate = LAST_FISCAL_YEAR].startdate;
            endDate = [Select EndDate From Period Where type = 'YEAR' and StartDate = THIS_FISCAL_YEAR].EndDate;    
        }
        
        //setting attributes
        map<id, distributor> mapDist = new map<id, distributor>();
        string UserId = UserInfo.getUserId().substring(0,15);
        map<id, salesRep> mapSR = new map<id, salesRep>();
        map<id, region> mapR = new map<id, region>();
        map<id, Director> mapD = new map<id, Director>();
        map<id, BU> mapB = new map<id, BU>();
        
        string UserType ;
        string DistributorCode ;
        string SalesRepCode; 
        string RegionCode; 
        string ZonalCode ;
        string SBUCode ;
        string LoggedInUserProfile ;//Added on 21/04/2020 --> To fetch Logged in User Profile
        
        user  u = [select Contact.accountId,IsPortalEnabled, profile.Name from user where id = :UserId][0];
        LoggedInUserProfile = u.profile.Name;//Added on 21/04/2020 --> To fetch Logged in User Profile
        //checking whether user is community user or not
        if(u.IsPortalEnabled){
            
            account a = [select SAP_Code__c from account where id = :u.Contact.accountId];   
            UserType = 'Distributor';
            DistributorCode = a.SAP_Code__c;
            SalesRepCode = '';
            RegionCode = ''; 
            ZonalCode = '' ;
            SBUCode = '';
            
            
            for(Customer_and_Region_Mapping__c CRM : [select Customer_Name__c,CustomerCode__c,CustomerRegion__r.Zone__r.name,CustomerRegion__r.Zone__c,CustomerRegion__r.SBU__r.name,CustomerRegion__r.SBU__r.Brazil_SBU_Name__c,CustomerRegion__r.SBU__c,CustomerRegion__r.region__r.name,CustomerRegion__r.region__c, CustomerName_Formula_Field__c,TerritoryManager__c, CustomerRegion__r.TerritoryManager__r.name,CustomerRegion__r.name,CustomerRegion__c from Customer_and_Region_Mapping__c where Customer_Name__c = :a.Id]){ //or SalesOfficeManagerID__c =:UserId or SalesDistrictManagerID__c = :UserId)
                distributor dst = new distributor();
                dst.name = CRM.CustomerName_Formula_Field__c;
                dst.Id = CRM.Customer_Name__c;
                dst.customerCode = CRM.CustomerCode__c;
                if(!mapDist.containskey(dst.id)){
                    mapDist.put(dst.id,dst);
                }
                
                salesRep SR = new salesRep();
                SR.name = CRM.CustomerRegion__r.TerritoryManager__r.name;
                SR.ID = CRM.TerritoryManager__c;
                if(!mapSR.containskey(SR.id)){
                    mapSR.put(SR.id,SR);
                }
                
                
                region r = new region();
                r.name = CRM.CustomerRegion__r.region__r.name;
                r.Id = CRM.CustomerRegion__r.region__c;
                if(!mapR.containskey(r.id)){
                    mapR.put(r.id,r);
                }
                
                Director d = new Director();
                //d.name = CRM.CustomerRegion__r.SBU__r.name;
                d.name = CRM.CustomerRegion__r.SBU__r.Brazil_SBU_Name__c;
                d.Id = CRM.CustomerRegion__r.SBU__c;
                dst.customerCode = CRM.CustomerCode__c;
                if(!mapD.containskey(d.id)){
                    mapD.put(d.id,d);
                }
                
                BU B = new BU();
                B.name = CRM.CustomerRegion__r.Zone__r.name;
                B.Id = CRM.CustomerRegion__r.Zone__c;
                if(!mapB.containskey(b.id)){
                    mapB.put(B.id,B);
                }
                
                
                
            }
            
        }
        else{
            //Added On 21-04-2020: To show all fiter Variables to Admins
            list<Customer_and_Region_Mapping__c> liCRM = [select CustomerCode__c,Customer_Name__c,
                                                          CustomerRegion__r.Zone__r.name,
                                                          CustomerRegion__r.Zone__c,
                                                          CustomerRegion__r.SBU__r.name,
                                                          CustomerRegion__r.SBU__r.Brazil_SBU_Name__c,
                                                          CustomerRegion__r.SBU__c,
                                                          CustomerRegion__r.region__r.name,
                                                          CustomerRegion__r.region__c, 
                                                          CustomerName_Formula_Field__c,
                                                          TerritoryManager__c, 
                                                          CustomerRegion__r.TerritoryManager__r.name,
                                                          CustomerRegion__r.name,
                                                          CustomerRegion__c 
                                                          from Customer_and_Region_Mapping__c 
                                                          where (TerritoryManager__c = : UserId 
                                                                 or SalesOfficeManagerID__c =:UserId 
                                                                 or SalesDistrictManagerID__c = :UserId 
                                                                 or SalesDirectorID__c = :UserId)];
            if(liCRM.size()>0){
                for(Customer_and_Region_Mapping__c CRM : [select CustomerCode__c,Customer_Name__c,
                                                          CustomerRegion__r.Zone__r.name,
                                                          CustomerRegion__r.Zone__c,
                                                          CustomerRegion__r.SBU__r.name,
                                                          CustomerRegion__r.SBU__r.Brazil_SBU_Name__c,
                                                          CustomerRegion__r.SBU__c,
                                                          CustomerRegion__r.region__r.name,
                                                          CustomerRegion__r.region__c, 
                                                          CustomerName_Formula_Field__c,
                                                          TerritoryManager__c, 
                                                          CustomerRegion__r.TerritoryManager__r.name,
                                                          CustomerRegion__r.name,CustomerRegion__c 
                                                          from Customer_and_Region_Mapping__c 
                                                          where (TerritoryManager__c = : UserId or 
                                                                 SalesOfficeManagerID__c =:UserId or 
                                                                 SalesDistrictManagerID__c = :UserId or 
                                                                 SalesDirectorID__c = :UserId)
                                                          ORDER BY CustomerName_Formula_Field__c ASC]){ //or SalesOfficeManagerID__c =:UserId or SalesDistrictManagerID__c = :UserId)
                                                              distributor dst = new distributor();
                                                              dst.name = CRM.CustomerName_Formula_Field__c;
                                                              dst.Id = CRM.Customer_Name__c;
                                                              if(!mapDist.containskey(dst.Id)){
                                                                  mapDist.put(dst.id,dst);
                                                              }
                                                          }
                for(Customer_and_Region_Mapping__c CRM : [select CustomerCode__c,Customer_Name__c,
                                                          CustomerRegion__r.Zone__r.name,
                                                          CustomerRegion__r.Zone__c,
                                                          CustomerRegion__r.SBU__r.name,
                                                          CustomerRegion__r.SBU__r.Brazil_SBU_Name__c,
                                                          CustomerRegion__r.SBU__c,
                                                          CustomerRegion__r.region__r.name,
                                                          CustomerRegion__r.region__c, 
                                                          CustomerName_Formula_Field__c,
                                                          TerritoryManager__c, 
                                                          CustomerRegion__r.TerritoryManager__r.name,
                                                          CustomerRegion__r.name,CustomerRegion__c 
                                                          from Customer_and_Region_Mapping__c 
                                                          where (TerritoryManager__c = : UserId or 
                                                                 SalesOfficeManagerID__c =:UserId or 
                                                                 SalesDistrictManagerID__c = :UserId or 
                                                                 SalesDirectorID__c = :UserId)
                                                          ORDER BY CustomerRegion__r.TerritoryManager__r.name ASC]){
                                                              if(string.isNotBlank(CRM.CustomerRegion__r.TerritoryManager__r.name)){                                          
                                                                  salesRep SR = new salesRep();
                                                                  SR.name = CRM.CustomerRegion__r.TerritoryManager__r.name;
                                                                  SR.ID = CRM.TerritoryManager__c;
                                                                  if(!mapSR.containskey(SR.id)){
                                                                      mapSR.put(SR.id,SR);
                                                                  }
                                                              }
                                                          }
                for(Customer_and_Region_Mapping__c CRM : [select CustomerCode__c,Customer_Name__c,
                                                          CustomerRegion__r.Zone__r.name,
                                                          CustomerRegion__r.Zone__c,
                                                          CustomerRegion__r.SBU__r.name,
                                                          CustomerRegion__r.SBU__r.Brazil_SBU_Name__c,
                                                          CustomerRegion__r.SBU__c,
                                                          CustomerRegion__r.region__r.name,
                                                          CustomerRegion__r.region__c, 
                                                          CustomerName_Formula_Field__c,
                                                          TerritoryManager__c, 
                                                          CustomerRegion__r.TerritoryManager__r.name,
                                                          CustomerRegion__r.name,CustomerRegion__c 
                                                          from Customer_and_Region_Mapping__c 
                                                          where (TerritoryManager__c = : UserId or 
                                                                 SalesOfficeManagerID__c =:UserId or 
                                                                 SalesDistrictManagerID__c = :UserId or 
                                                                 SalesDirectorID__c = :UserId)
                                                          ORDER BY CustomerRegion__r.region__r.name ASC]){
                                                              region r = new region();
                                                              r.name = CRM.CustomerRegion__r.region__r.name;
                                                              r.Id = CRM.CustomerRegion__r.region__c;
                                                              if(!mapR.containskey(r.id)){
                                                                  mapR.put(r.id,r);
                                                              }
                                                          }
                for(Customer_and_Region_Mapping__c CRM : [select CustomerCode__c,Customer_Name__c,
                                                          CustomerRegion__r.Zone__r.name,
                                                          CustomerRegion__r.Zone__c,
                                                          CustomerRegion__r.SBU__r.name,
                                                          CustomerRegion__r.SBU__r.Brazil_SBU_Name__c,
                                                          CustomerRegion__r.SBU__c,
                                                          CustomerRegion__r.region__r.name,
                                                          CustomerRegion__r.region__c, 
                                                          CustomerName_Formula_Field__c,
                                                          TerritoryManager__c, 
                                                          CustomerRegion__r.TerritoryManager__r.name,
                                                          CustomerRegion__r.name,CustomerRegion__c 
                                                          from Customer_and_Region_Mapping__c 
                                                          where (TerritoryManager__c = : UserId or 
                                                                 SalesOfficeManagerID__c =:UserId or 
                                                                 SalesDistrictManagerID__c = :UserId or 
                                                                 SalesDirectorID__c = :UserId)
                                                          ORDER BY CustomerRegion__r.SBU__r.Brazil_SBU_Name__c ASC]){
                                                              Director d = new Director();
                                                              //d.name = CRM.CustomerRegion__r.SBU__r.name;
                                                              d.name = CRM.CustomerRegion__r.SBU__r.Brazil_SBU_Name__c;
                                                              d.Id = CRM.CustomerRegion__r.SBU__c;
                                                              if(!mapD.containskey(d.id)){
                                                                  mapD.put(d.id,d);
                                                              }
                                                          }
                for(Customer_and_Region_Mapping__c CRM : [select CustomerCode__c,Customer_Name__c,
                                                          CustomerRegion__r.Zone__r.name,
                                                          CustomerRegion__r.Zone__c,
                                                          CustomerRegion__r.SBU__r.name,
                                                          CustomerRegion__r.SBU__r.Brazil_SBU_Name__c,
                                                          CustomerRegion__r.SBU__c,
                                                          CustomerRegion__r.region__r.name,
                                                          CustomerRegion__r.region__c, 
                                                          CustomerName_Formula_Field__c,
                                                          TerritoryManager__c, 
                                                          CustomerRegion__r.TerritoryManager__r.name,
                                                          CustomerRegion__r.name,CustomerRegion__c 
                                                          from Customer_and_Region_Mapping__c 
                                                          where (TerritoryManager__c = : UserId or 
                                                                 SalesOfficeManagerID__c =:UserId or 
                                                                 SalesDistrictManagerID__c = :UserId or 
                                                                 SalesDirectorID__c = :UserId)
                                                          ORDER BY CustomerRegion__r.Zone__r.name ASC]){
                                                              BU B = new BU();
                                                              B.name = CRM.CustomerRegion__r.Zone__r.name;
                                                              B.Id = CRM.CustomerRegion__r.Zone__c;
                                                              if(!mapB.containskey(B.id)){
                                                                  mapB.put(B.id,B);
                                                              }
                                                          }
            }
            else{
                //Added On 21-04-2020: Checking Admin Profiles 
                if(u.profile.name == 'Brazil Rebate Admin' ||
                   u.profile.name == 'Brazil System Administrator' ||
                   u.profile.name == 'System Administrator' ||
                   u.profile.name == 'Brazil Customer Service Manager' ||
                   u.profile.name == 'Brazil Customer Service User' ||
                   u.profile.name == 'Brazil Regional Head'){ //INCTASK0286695: Sayan given access for the Region Heads
                       for(Territory_Distributor__c CRM : [select TerritoryManager__c, 
                                                           TerritoryManager__r.name 
                                                           from Territory_Distributor__c
                                                           where Sales_Org_Code__c = '5191'
                                                           order by TerritoryManager__r.name ASC]){ //or SalesOfficeManagerID__c =:UserId or SalesDistrictManagerID__c = :UserId)
                                                               /*distributor dst = new distributor();
dst.name = CRM.CustomerName_Formula_Field__c;
dst.Id = CRM.Customer_Name__c;
if(!mapDist.containskey(dst.Id)){
mapDist.put(dst.id,dst);
}*/
                                                               if(string.isNotBlank(CRM.TerritoryManager__r.name)){
                                                                   salesRep SR = new salesRep();                           
                                                                   SR.name = CRM.TerritoryManager__r.name;
                                                                   SR.ID = CRM.TerritoryManager__c;
                                                                   if(!mapSR.containskey(SR.id)){
                                                                       mapSR.put(SR.id,SR);
                                                                   }
                                                               }
                                                           }//end for loop
                       for(Territory_Distributor__c CRM : [select region__r.name,
                                                           region__c 
                                                           from Territory_Distributor__c
                                                           where Sales_Org_Code__c = '5191'
                                                           order by region__r.name ASC]){
                                                               region r = new region();
                                                               r.name = CRM.region__r.name;
                                                               r.Id = CRM.region__c;
                                                               if(!mapR.containskey(r.id)){
                                                                   mapR.put(r.id,r);
                                                               }
                                                           }//end for loop
                       for(Territory_Distributor__c CRM : [select 
                                                           SBU__r.Brazil_SBU_Name__c,
                                                           SBU__c 
                                                           from Territory_Distributor__c
                                                           where Sales_Org_Code__c = '5191'
                                                           Order by SBU__r.Brazil_SBU_Name__c ASC]){
                                                               Director d = new Director();
                                                               //d.name = CRM.CustomerRegion__r.SBU__r.name;
                                                               if(string.isNotBlank(CRM.SBU__r.Brazil_SBU_Name__c)){
                                                                   d.name = CRM.SBU__r.Brazil_SBU_Name__c;
                                                                   d.Id = CRM.SBU__c;
                                                                   if(!mapD.containskey(d.id)){
                                                                       mapD.put(d.id,d);
                                                                   }
                                                               }
                                                           }//end for loop
                       for(Territory_Distributor__c CRM : [select Zone__r.name,Zone__c
                                                           from Territory_Distributor__c
                                                           where Sales_Org_Code__c = '5191'
                                                           Order by Zone__r.name ASC]){
                                                               BU B = new BU();
                                                               B.name = CRM.Zone__r.name;
                                                               B.Id = CRM.Zone__c;
                                                               if(!mapB.containskey(B.id)){
                                                                   mapB.put(B.id,B);
                                                                   
                                                               }
                                                               
                                                           }
                   }
                
            }
            //for sales Rep  
            for(Customer_and_Region_Mapping__c CRM : [select Customer_Name__c,CustomerRegion__r.TM_Code__c,CustomerRegion__r.region__r.name,CustomerRegion__r.region__c, CustomerName_Formula_Field__c,TerritoryManager__c, CustomerRegion__r.TerritoryManager__r.name,CustomerRegion__r.name,CustomerRegion__c from Customer_and_Region_Mapping__c where TerritoryManager__c = : UserId limit 1]){ //or SalesOfficeManagerID__c =:UserId or SalesDistrictManagerID__c = :UserId)
                
                UserType = 'Sales Rep';
                DistributorCode = '';
                SalesRepCode = CRM.CustomerRegion__r.TM_Code__c;
                RegionCode = ''; 
                ZonalCode = '' ;
                SBUCode = '';
            }
            
            //for Regional Manager  
            for(Customer_and_Region_Mapping__c CRM : [select Customer_Name__c,CustomerRegion__r.Zone_Code__c,CustomerRegion__r.Region_Code__c,CustomerRegion__r.region__r.name,CustomerRegion__r.region__c, CustomerName_Formula_Field__c,TerritoryManager__c, CustomerRegion__r.TerritoryManager__r.name,CustomerRegion__r.name,CustomerRegion__c from Customer_and_Region_Mapping__c where SalesDistrictManagerID__c = : UserId limit 1]){ //or SalesOfficeManagerID__c =:UserId or SalesDistrictManagerID__c = :UserId)
                
                UserType = 'Manager';
                DistributorCode = '';
                SalesRepCode = '';
                RegionCode = ''; //CRM.CustomerRegion__r.Region_Code__c
                ZonalCode = CRM.CustomerRegion__r.Region_Code__c ;
                SBUCode = '';
            }
            
            //for Zonal Manager  
            for(Customer_and_Region_Mapping__c CRM : [select Customer_Name__c,CustomerRegion__r.Zone_Code__c,CustomerRegion__r.Region_Code__c,CustomerRegion__r.region__r.name,CustomerRegion__r.region__c, CustomerName_Formula_Field__c,TerritoryManager__c, CustomerRegion__r.TerritoryManager__r.name,CustomerRegion__r.name,CustomerRegion__c from Customer_and_Region_Mapping__c where SalesOfficeManagerID__c = : UserId limit 1]){ //or SalesOfficeManagerID__c =:UserId or SalesDistrictManagerID__c = :UserId)
                
                UserType = 'Manager';
                DistributorCode = '';
                SalesRepCode = '';
                RegionCode = CRM.CustomerRegion__r.Zone_Code__c; //'' 
                ZonalCode = '' ;//CRM.CustomerRegion__r.Zone_Code__c
                SBUCode = '';
            }
            
            //for SBU Manager  
            for(Customer_and_Region_Mapping__c CRM : [select Customer_Name__c,CustomerRegion__r.SBU_Code__c,CustomerRegion__r.region__r.name,CustomerRegion__r.region__c, CustomerName_Formula_Field__c,TerritoryManager__c, CustomerRegion__r.TerritoryManager__r.name,CustomerRegion__r.name,CustomerRegion__c from Customer_and_Region_Mapping__c where SalesDirectorID__c = : UserId limit 1]){ //or SalesOfficeManagerID__c =:UserId or SalesDistrictManagerID__c = :UserId)
                
                UserType = 'Manager';
                DistributorCode = '';
                SalesRepCode = '';
                RegionCode = ''; 
                ZonalCode = '' ;
                SBUCode = CRM.CustomerRegion__r.SBU_Code__c;
            }
        }
        
        
        
        //calling SAP Interface
        list<string> ContractIds = new list<string>();
        WrapperContractID wrap = new WrapperContractID();
        //Added On 21-04-2020: Call getContract API in case user is authorised 
        if(string.isNotBlank(UserType) ||
           u.profile.name == 'Brazil Rebate Admin' ||
           u.profile.name == 'Brazil System Administrator' ||
           u.profile.name == 'System Administrator' ||
           u.profile.name == 'Brazil Customer Service Manager' ||
           u.profile.name == 'Brazil Customer Service User'  ||
           u.profile.name == 'Brazil Regional Head'){ //INCTASK0286695: Sayan given access for the Region Heads
               
               GetContractRequestWrapper req= new GetContractRequestWrapper();
               req.companyCode='5190';
               req.contractInitialDate=startDate.year()+'-'+startDate.month()+'-'+startDate.day();
               req.contractFinalDate=endDate.year()+'-'+endDate.month()+'-'+endDate.day();
               req.initialCustomerCode = DistributorCode;
               req.initialSalesPersonCode = SalesRepCode;
               req.initialSalesOfficeCode = RegionCode;
               req.initialSalesDistrictCode = ZonalCode;
               req.initialSalesDirectorCode = SBUCode;
               wrap = RebateServiceHelper.getContract(req);
               //list<string> ContractIds = new list<string>();
               ContractIds = wrap.contIds;
           }
        /* list<string> ContractIds = new list<string>();
ContractIds.add('26');
system.debug('wrap status'+ContractIds);*/
        
        //if(wrap.status == 'SUCCESS'){
        System.debug('ContractIds>>>>'+ContractIds);
        list<rebateContract> liRebateConts = new list<rebateContract>(); //Territory__r.region__c,Territory__r.region__r.name,
        list<rebate_Contract__c> liRebateContract = new list<rebate_Contract__c>();
        //ContractIds.sort();
        
        if(ContractIds != null)
            liRebateContract= [SELECT Id,Type_Code__c,Distributor_Accepted__c,Distributor_Acceptance_Date__c,Distributor_Reviewer__r.name,Growth_Rate__c,Distributor__r.SAP_Code__c,Territory__r.SBU__r.name,Territory__r.SBU__r.Brazil_SBU_Name__c,Territory__r.Zone__r.name,Territory__r.Zone__c,Territory__r.SBU__c,Total_Type_Value__c,Total_Value_LY__c,Total_Value__c,Total_Other_Value_LY__c,Total_Other_Value__c,Total_Type_Value_LY__c,Territory__r.TerritoryManager__c,Contract_Date__c,CurrencyIsoCode,Sales_Rep__c,Name,Territory__r.region__c,Territory__r.region__r.name, Start_Date__c,Distributor__r.name,Region__r.name, End_Date__c, Combination_Key__c, Sales_Org__c, Distributor__c, Territory__c, Region__c, Category_Name__c, Status__c, Type__c, Workflow_Status__c, Last_Invoice_Date__c, Growth_Index__c, CRM_Status__c, Territory_Manager__c, Regional_Manager__c, Zonal_Manager__c, SBU_Head__c, Marketing_Director__c FROM Rebate_Contract__c where name = :ContractIds order by Contract_Number_Formula__c DESC];//name //Start_Date__c >= :startDate and End_Date__c <= :endDate
        
        //added on 21-04-2020 - to extract distributor
        //if(mapDist.size()==0){
        if(u.profile.name == 'Brazil Rebate Admin' ||
           u.profile.name == 'Brazil System Administrator' ||
           u.profile.name == 'System Administrator' ||
           u.profile.name == 'Brazil Customer Service Manager' ||
           u.profile.name == 'Brazil Customer Service User' ||
           u.profile.name == 'Brazil Regional Head'){ //INCTASK0286695: Sayan given access for the Region Heads
               //Added on 23-04-2020: Created new list to sort Rebate Contracts       
               list<rebate_Contract__c> sortedliRebateContract = [SELECT Id,Type_Code__c,Distributor_Accepted__c,Distributor_Acceptance_Date__c,Distributor_Reviewer__r.name,Growth_Rate__c,Distributor__r.SAP_Code__c,Territory__r.SBU__r.name,Territory__r.SBU__r.Brazil_SBU_Name__c,Territory__r.Zone__r.name,Territory__r.Zone__c,Territory__r.SBU__c,Total_Type_Value__c,Total_Value_LY__c,Total_Value__c,Total_Other_Value_LY__c,Total_Other_Value__c,Total_Type_Value_LY__c,Territory__r.TerritoryManager__c,Contract_Date__c,CurrencyIsoCode,Sales_Rep__c,Name,Territory__r.region__c,Territory__r.region__r.name, Start_Date__c,Distributor__r.name,Region__r.name, End_Date__c, Combination_Key__c, Sales_Org__c, Distributor__c, Territory__c, Region__c, Category_Name__c, Status__c, Type__c, Workflow_Status__c, Last_Invoice_Date__c, Growth_Index__c, CRM_Status__c, Territory_Manager__c, Regional_Manager__c, Zonal_Manager__c, SBU_Head__c, Marketing_Director__c FROM Rebate_Contract__c where name = :ContractIds order by Distributor__r.name ASC];   
               for(rebate_Contract__c rc: sortedliRebateContract){//liRebateContract
                   distributor dst = new distributor();
                   dst.name = rc.Distributor__r.name;
                   dst.Id = rc.Distributor__c;
                   if(!mapDist.containskey(dst.Id)){
                       mapDist.put(dst.id,dst); 
                   }
               }
           }
        //end
        
        
        for(rebate_Contract__c rc: liRebateContract){
            rebateContract rCont = new rebateContract();
            rCont.Contract = rc.Name;
            rCont.Distributor = rc.Distributor__r.name;
            rCont.DistributorId = rc.Distributor__c;
            rCont.DistributorCode = rc.Distributor__r.SAP_Code__c;
            rCont.DistributorCodeAndName = rc.Distributor__r.SAP_Code__c+ ' - '+rc.Distributor__r.name;
            rCont.color = '';
            rCont.element = '';
            rCont.Category_Name = rc.Category_Name__c;
            rCont.CRMStatus = rc.CRM_Status__c;
            rCont.Status = rc.Workflow_Status__c;
            rCont.Type = rc.Type__c;
            rCont.Branch = rc.Territory__r.region__r.name;
            rCont.BranchId = rc.Territory__r.region__c;
            //rCont.Director = rc.Territory__r.SBU__r.name;
            rCont.Director = rc.Territory__r.SBU__r.Brazil_SBU_Name__c;
            rCont.DirectorId = rc.Territory__r.SBU__c;
            
            rCont.BU = rc.Territory__r.Zone__r.name;
            rCont.BUId = rc.Territory__r.Zone__c;
            //system.debug(rc.Territory__c);
            if(!string.isblank(rc.Territory__r.TerritoryManager__c))
                rCont.salesRep = string.valueOf(rc.Territory__r.TerritoryManager__c).substring(0,15);
            rCont.CTC = rc.Sales_Rep__c;
            rCont.Initial_date = string.valueOf(rc.Start_Date__c);
            rCont.Final_date = string.valueOf(rc.End_Date__c);
            rCont.Contract_date = string.valueOf(rc.Contract_Date__c);
            rCont.pStatus = rc.Status__c;
            rCont.curr = rc.CurrencyIsoCode;
            rCont.ContractId = rc.Id;
            rCont.TotalTypeValue = rc.Total_Type_Value__c;
            rCont.TotalTypeValueLY  = rc.Total_Type_Value_LY__c;
            rCont.TotalOtherValue  = rc.Total_Other_Value__c;
            rCont.TotalOtherValueLY  = rc.Total_Other_Value_LY__c;
            rCont.TotalValue  = rc.Total_Value__c;
            rCont.TotalValueLY  = rc.Total_Value_LY__c;
            rCont.GrowthRate = rc.Growth_Rate__c;
            rCont.GrowthIndex = rc.Growth_Index__c;
            rCont.TerritoryId = rc.Territory__c;
            rCont.ContractTypeCode = rc.Type_Code__c;
            //if(rc.Type_Code__c == 'L' ||  rc.Workflow_Status__c != 'Em Acompanhamento' ){ //rc.CRM_Status__c != 'Approved' ||
            // changing the if condition   for  RITM0439917  18-10-2022  GRZ(Javed Ahmed) 
            if( rc.Workflow_Status__c == 'Em Acompanhamento' && (rc.Type_Code__c == 'U' || rc.Type_Code__c == 'C') ){ // rc.Type_Code__c == 'L' || rc.CRM_Status__c != 'Approved' 
                rCont.isDisabled = false;   
            }
            else{
                rCont.isDisabled = true;
            }
            /*  start  add below code for RITM0564631 GRZ(Javed Ahmed) 01-06-2023 */
            if(rc.Workflow_Status__c == 'Cartas de Crédito em processo de emissão'){
                rCont.isStatusDisabled = false;
            }else{
                rCont.isStatusDisabled = true;
            }
            /*  end  add above code for RITM0564631 GRZ(Javed Ahmed) 01-06-2023 */
            rCont.DistAccepted = rc.Distributor_Accepted__c;
            rCont.DistAccDate = string.valueOf(rc.Distributor_Acceptance_Date__c);
            rCont.DistReviewName = rc.Distributor_Reviewer__r.name;
            liRebateConts.add(rCont);
        }
        
        
        rebateContractWrapper wrapper = new rebateContractWrapper();
        wrapper.liRebateContracts = liRebateConts;
        wrapper.liDistributor = mapDist.values();
        wrapper.liDirector = mapD.values();
        wrapper.liSalesRep = mapSR.values();
        wrapper.liRegion = mapR.values();
        wrapper.liBU = mapB.values();
        wrapper.liWFStatus = picklistValues('Rebate_Contract__c','Workflow_Status__c');
        wrapper.liType = picklistValues('Rebate_Contract__c','Type__c');
        wrapper.liCategory = picklistValues('Rebate_Contract__c','Category_Name__c');
        wrapper.UserType = UserType;
        wrapper.DistributorCode = DistributorCode;
        wrapper.SalesRepCode = SalesRepCode;
        wrapper.RegionCode = RegionCode;
        wrapper.ZonalCode = ZonalCode;
        wrapper.SBUCode = SBUCode;
        wrapper.startDate = string.valueOf(startDate);
        wrapper.endDate = string.valueOf(endDate);
        wrapper.status = wrap.status;
        wrapper.messsage = wrap.message;  
        wrapper.LoggedInUserProfile = LoggedInUserProfile;//Added on 21/04/2020 --> To fetch Logged in User Profile
        system.debug('wrapper'+wrapper.messsage);
        
        system.debug('getContracts=====================>'+JSON.serializePretty(wrapper));
        return wrapper;
        
    }
    
    /*
*************************************************************************************************************
* Below method is issed to get the picklist value.
*************************************************************************************************************
*/
    public static list<String> picklistValues(String objectName, String fieldName) {
        list<String> values = new list<String>{};
            
            List<Schema.DescribeSobjectResult> results = Schema.describeSObjects(new List<String>{objectName});
        
        for(Schema.DescribeSobjectResult res : results) {
            for (Schema.PicklistEntry entry : res.fields.getMap().get(fieldName).getDescribe().getPicklistValues()) {
                if (entry.isActive()) {
                    values.add(entry.getValue());
                }
            }
        }
        values.sort();//added on 23/04/2020 : sorting Picklist  values
        return values;
    }
    
    public class rebateContractWrapper{
        @AuraEnabled
        public List<rebateContract> liRebateContracts {get;set;}
        @AuraEnabled
        public list<distributor> liDistributor {get;set;}
        @AuraEnabled
        public list<Director> liDirector {get;set;}
        @AuraEnabled
        public List<salesRep> liSalesRep {get;set;}
        @AuraEnabled
        public list<region> liRegion {get;set;}
        @AuraEnabled
        public list<BU> liBU {get;set;}
        @AuraEnabled
        public List<string> liWFStatus {get;set;}
        @AuraEnabled
        public List<string> liCategory {get;set;}
        @AuraEnabled
        public List<string> liType {get;set;}
        @AuraEnabled
        public string UserType {get;set;}
        @AuraEnabled
        public string DistributorCode {get;set;}
        @AuraEnabled
        public string SalesRepCode {get;set;}
        @AuraEnabled
        public string RegionCode {get;set;}
        @AuraEnabled
        public string ZonalCode {get;set;}
        @AuraEnabled
        public string SBUCode {get;set;}
        @AuraEnabled
        public string startDate {get;set;}
        @AuraEnabled
        public string endDate {get;set;}
        @AuraEnabled
        public string status {get;set;}
        @AuraEnabled
        public string messsage {get;set;}
        @AuraEnabled
        public string LoggedInUserProfile {get;set;} //Added on 21/04/2020 --> To fetch Logged in User Profile
    }
    
    public class rebateContract {
        
        @AuraEnabled
        public string Contract {get;set;}
        
        @AuraEnabled
        public string Distributor {get;set;}
        @AuraEnabled
        public string DistributorId {get;set;}
        @AuraEnabled
        public string DistributorCode {get;set;}
        @AuraEnabled
        public string DistributorCodeAndName {get;set;}
        
        @AuraEnabled
        public string Director {get;set;}
        @AuraEnabled
        public string DirectorId {get;set;}
        
        @AuraEnabled
        public string BU {get;set;}
        @AuraEnabled
        public string BUId {get;set;}
        
        @AuraEnabled
        public string color {get;set;}
        @AuraEnabled
        public string element {get;set;}
        @AuraEnabled
        public string Status {get;set;}
        
        @AuraEnabled
        public string CRMStatus {get;set;}
        
        @AuraEnabled
        public string Type {get;set;}
        @AuraEnabled
        public string Branch {get;set;}
        @AuraEnabled
        public string BranchId {get;set;}
        
        @AuraEnabled
        public string CTC {get;set;}
        @AuraEnabled
        public string Initial_date {get;set;}
        @AuraEnabled
        public string Final_date {get;set;}
        @AuraEnabled
        public string Contract_date {get;set;}
        @AuraEnabled
        public string salesRep {get;set;}
        @AuraEnabled
        public string Category_Name {get;set;}
        @AuraEnabled
        public string curr {get;set;}
        @AuraEnabled
        public string ContractId {get;set;}
        @AuraEnabled
        public string pStatus {get;set;}
        @AuraEnabled
        public decimal TotalTypeValue {get;set;}
        @AuraEnabled
        public decimal TotalTypeValueLY {get;set;}
        @AuraEnabled
        public decimal TotalOtherValue {get;set;}
        @AuraEnabled
        public decimal TotalOtherValueLY {get;set;}
        @AuraEnabled
        public decimal TotalValue {get;set;}
        @AuraEnabled
        public decimal TotalValueLY {get;set;}
        
        @AuraEnabled
        public decimal GrowthIndex {get;set;}
        @AuraEnabled
        public decimal GrowthRate {get;set;}
        
        @AuraEnabled
        public string TerritoryId {get;set;}
        
        @AuraEnabled
        public string ContractTypeCode {get;set;}
        @AuraEnabled
        public boolean isDisabled {get;set;}
        @AuraEnabled
        public boolean isStatusDisabled {get;set;}// add this for RITM0564631 GRZ(Javed Ahmed) 01-06-2023 
        @AuraEnabled
        public boolean DistAccepted {get;set;}
        @AuraEnabled
        public string DistAccDate {get;set;}
        @AuraEnabled
        public string DistReviewName {get;set;}
        
    }
    
    public class distributor{
        @AuraEnabled
        public string name {get;set;}
        
        @AuraEnabled
        public string Id {get;set;}
        @AuraEnabled
        public string customerCode {get;set;}
    }
    
    public class salesRep{
        @AuraEnabled
        public string name {get;set;}
        
        @AuraEnabled
        public string Id {get;set;}
    }
    
    public class region{
        @AuraEnabled
        public string name {get;set;}
        
        @AuraEnabled
        public string Id {get;set;}
    }
    
    public class Director{
        @AuraEnabled
        public string name {get;set;}
        
        @AuraEnabled
        public string Id {get;set;}
    }
    
    public class BU{
        @AuraEnabled
        public string name {get;set;}
        
        @AuraEnabled
        public string Id {get;set;}
    }
    
    @Auraenabled
    public static list<goalDetailsWrapper> getGoals(rebateContract rC){
        system.debug('value of RC is '+ rC);
        //calling getGoal API
        GetGoalsRequestWrapper reqGoals= new GetGoalsRequestWrapper();
        reqGoals.companyCode='5190';
        system.debug(rC.Contract);
        reqGoals.contractNumber=rC.Contract;
        string status = RebateServiceHelper.getGoals(reqGoals);
        system.debug('status'+status);
        //system.debug('status'+RebateServiceHelper.getGoals(reqGoals));
        //added by diwansh 8 nov 2019 
        /*GetApprovalHistoryRequestWrapper reqApp = new GetApprovalHistoryRequestWrapper();
reqApp.companyCode='5190';
reqApp.contractNumber='12';
status=RebateServiceHelper.getApprovalHistory(reqApp);
*/
        //ends
        
        list<goalDetailsWrapper> liGoalWrapper = new list<goalDetailsWrapper>();
        
        Rebate_Contract__c RCC = [select id,Total_Other_Value_LY__c,
                                  Total_Other_Value__c ,Total_Type_Value_LY__c,
                                  Total_Type_Value__c,Total_Value_LY__c,Total_Value__c
                                  from Rebate_Contract__c 
                                  where name=:rC.Contract];
        decimal SumVolumeLY=0.00;
        decimal SumVolume=0.00;
        for (Rebate_Goal_SKU__c RGSKU: [select id,Product_Category__c,Volume_LY__c,Price_LY__c,Value_LY__c,Volume__c,Price__c,Value__c,Actual_Value__c,Contract__r.name,SKU__c,SKU__r.SKU_Code__c,SKU__r.Name,Actual_Volume__c,  Brand_Name__c from Rebate_Goal_SKU__c where Contract__r.name = :rC.Contract ORDER BY Product_Category__c, SKU__r.SKU_Code__c]){
            if(string.isNotBlank(string.valueOf(RGSKU.Value_LY__c)))
                SumVolumeLY +=  RGSKU.Value_LY__c;
            if(string.isNotBlank(string.valueOf(RGSKU.Value__c)))
                SumVolume += RGSKU.Value__c;
            
        }
        RCC.Total_Type_Value_LY__c = SumVolumeLY;
        RCC.Total_Type_Value__c = SumVolume;
        if(RCC.Total_Other_Value_LY__c == null){
            RCC.Total_Value_LY__c = 0.0+SumVolumeLY;
        }
        else{
            RCC.Total_Value_LY__c = RCC.Total_Other_Value_LY__c+SumVolumeLY;
        }
        if(RCC.Total_Other_Value__c == null){
            RCC.Total_Value__c = 0.0+SumVolume;
        }
        else{
            RCC.Total_Value__c = RCC.Total_Other_Value__c+SumVolume;
        }
        system.debug('RCC.Total_Value__c before==>'+RCC.Total_Value__c);
        //RCC.Total_Value__c=RCC.Total_Value__c.setScale(2);
        //  system.debug('RCC.Total_Value__c after==>'+RCC.Total_Value__c);
        update RCC;
        
        
        for (Rebate_Goal_SKU__c RGSKU: [select id,Product_Category__c,Volume_LY__c,
                                        Price_LY__c,Value_LY__c,Volume__c,Price__c,
                                        Value__c,Actual_Value__c,Contract__r.name,
                                        SKU__c,SKU__r.SKU_Code__c,SKU__r.Name,
                                        Actual_Volume__c,  Brand_Name__c from Rebate_Goal_SKU__c where Contract__c = :rC.ContractId]){//add sales org in where condition
                                            goalDetailsWrapper goalWrapper = new goalDetailsWrapper();
                                            goalWrapper.Id = RGSKU.Id;
                                            if(RGSKU.SKU__r.SKU_Code__c != null)
                                                goalWrapper.code = RGSKU.SKU__r.SKU_Code__c.replaceFirst( '^0+', ''); 
                                            else
                                                goalWrapper.code = RGSKU.SKU__r.SKU_Code__c;    
                                            goalWrapper.ProductGroup = RGSKU.Brand_Name__c;
                                            goalWrapper.product_category= RGSKU.Product_Category__c;
                                            goalWrapper.Product = RGSKU.SKU__r.Name;
                                            goalWrapper.Volume2018 = RGSKU.Volume_LY__c;
                                            goalWrapper.Price2018=RGSKU.Price_LY__c;
                                            goalWrapper.Amount2018 = RGSKU.Value_LY__c;
                                            goalWrapper.VolumeGoal = RGSKU.Volume__c;
                                            goalWrapper.AmountGoal = RGSKU.Price__c ;
                                            if((string.isblank(string.valueOf(RGSKU.Value__c))))
                                                goalWrapper.Goal_Billing = RGSKU.Value__c;
                                            else
                                                goalWrapper.Goal_Billing = RGSKU.Volume__c*RGSKU.Price__c;
                                            
                                            goalWrapper.response_service = status;
                                            goalWrapper.TotalTypeValue = RCC.Total_Type_Value__c;
                                            goalWrapper.TotalTypeValueLY = RCC.Total_Type_Value_LY__c;
                                            goalWrapper.TotalOtherValue = RCC.Total_Other_Value__c;
                                            goalWrapper.TotalOtherValueLY = RCC.Total_Other_Value_LY__c;
                                            goalWrapper.TotalValue = RCC.Total_Value__c;
                                            goalWrapper.TotalValueLY = RCC.Total_Value_LY__c;
                                            
                                            liGoalWrapper.add(goalWrapper);
                                            
                                        }
        if(liGoalWrapper.size()==0){
            goalDetailsWrapper goalWrapper = new goalDetailsWrapper();
            goalWrapper.response_service = status;
            goalWrapper.TotalTypeValue = RCC.Total_Type_Value__c;
            goalWrapper.TotalTypeValueLY = RCC.Total_Type_Value_LY__c;
            goalWrapper.TotalOtherValue = RCC.Total_Other_Value__c;
            goalWrapper.TotalOtherValueLY = RCC.Total_Other_Value_LY__c;
            goalWrapper.TotalValue = RCC.Total_Value__c;
            goalWrapper.TotalValueLY = RCC.Total_Value_LY__c;
            liGoalWrapper.add(goalWrapper); 
        }
        //added by Gurubaksh Grewal to get sub distributors on component load 04/04/2023 Ticket:RITM0534476 
        BRRebateModule1.pushSubDistributors(rC.ContractId);
        
        return liGoalWrapper;
        
    }
    
    @Auraenabled
    public static string getlatestContractStatus(string ContractIds){
        rebate_contract__c liRebateContract= [SELECT Id,CRM_Status__c,Workflow_Status__c,Territory_Manager__c, Regional_Manager__c, Zonal_Manager__c, SBU_Head__c, Marketing_Director__c FROM Rebate_Contract__c where name = :ContractIds]; //Start_Date__c >= :startDate and End_Date__c <= :endDate
        return liRebateContract.CRM_Status__c;
    }
    
    @Auraenabled
    public static string updateGoals(list<goalDetailsWrapper> liGD, rebateContract rC){
        
        system.debug(rC.TotalOtherValue);
        list<Rebate_Goal_SKU__c> liRGSKU = new list<Rebate_Goal_SKU__c>();
        for (goalDetailsWrapper GD: liGD){
            Rebate_Goal_SKU__c RGSKU = new Rebate_Goal_SKU__c(); 
            RGSKU.id = GD.Id;
            RGSKU.Value__c = GD.Goal_Billing;
            RGSKU.Price__c  = GD.AmountGoal;
            RGSKU.Volume__c  = GD.VolumeGoal; 
            liRGSKU.add(RGSKU);
        }
        system.debug(liRGSKU);
        If (!liRGSKU.isEmpty()&& liRGSKU!=null)
            update liRGSKU;
        
        //update total values
        Rebate_Contract__c Rcont = new Rebate_Contract__c();
        Rcont.Id = rC.ContractId;
        Rcont.Total_Type_Value__c = rC.TotalTypeValue;
        Rcont.Total_Other_Value__c = rC.TotalOtherValue;
        Rcont.Total_Value__c = rC.TotalValue;
        if((rc.TotalValueLY != 0 && rc.TotalValue!=0) && (rc.TotalValueLY != null && rc.TotalValue!=null)){
            Rcont.Growth_Rate__c = ((rc.TotalValue - rc.TotalValueLY) / rc.TotalValueLY)*100;
        }
        
        if(rC.CRMStatus == 'New' || string.isBlank(rC.CRMStatus))
            Rcont.CRM_Status__c = 'In Editing';
        if(Rcont!=null)
            update Rcont;
        
        return System.Label.REB_Message_Success_Save;
    }
    
    @Auraenabled
    public static string  updateAndSubmitGoals(list<goalDetailsWrapper> liGD, rebateContract rC){
        
        //calling API
        System.debug('Rebate Contract '+ rC);
        SendGoalRequestWrapper send= new SendGoalRequestWrapper();
        send.actionCode= '3';
        send.I_NETOUT=string.valueOf(rC.TotalOtherValue);
        send.userRole='03';
        //send.I_ACAOR = '3';
        //send.I_PERFL = '03';
        send.companyCode='5190';
        send.contractNumber=rC.Contract;//rC.Contract
        send.approverEmail= userInfo.getUserEmail();
        send.I_ENVIAR='X'; //send.I_ENVIAR='3';
        send.comments='';
        list<SendGoalRequestWrapper.Item> lstToSend = new list<SendGoalRequestWrapper.Item>();
        //list<SendGoalRequestWrapper.Goals> lstToSend = new list<SendGoalRequestWrapper.Goals>();
        for (Rebate_Goal_SKU__c RGSKU: [select id,Name,SKU_Code__c,Product_Category__c,Volume_LY__c,Price_LY__c,Value_LY__c,Volume__c,Price__c,Value__c,Actual_Value__c,Contract__r.name,SKU__c,SKU__r.SKU_Code__c,SKU__r.Name,Actual_Volume__c,  Brand_Name__c from Rebate_Goal_SKU__c where Contract__c = :rC.ContractId ]){
            //SendGoalRequestWrapper.Goals lst = new SendGoalRequestWrapper.Goals();
            SendGoalRequestWrapper.Item lst = new SendGoalRequestWrapper.Item();
            lst.skuCode=RGSKU.SKU_Code__c;
            lst.volume=string.valueOf(RGSKU.Volume__c);
            lst.unitPrice=string.valueOf(RGSKU.Price__c);
            lstToSend.add(lst);
        }
        SendGoalRequestWrapper.goals gItem= new SendGoalRequestWrapper.goals();
        gItem.item= lstToSend;
        //send.goals=lstToSend;
        send.goals=gItem;
        boolean temp = false;
        //If Growth Rate >= Growth Index only that time future method call get happend INC0368882
        Rebate_Contract__c RCCTemp =  [select EXPMM__c,Growth_Rate__c,Growth_Index__c,Total_Value_LY__c from rebate_Contract__c where id = :rC.ContractId];
        if(RCCTemp.EXPMM__c == 'X' || RCCTemp.Growth_Rate__c >= RCCTemp.Growth_Index__c){ // add RCCTemp.EXPMM__c=='X' for RITM0432971 modified by Javed(Grazitti) modified date- 30-09-2022
            temp=RebateServiceHelper.SendGoals(send);
            system.debug('temp is'+ temp );
        }
        //update Last Sent Approval Step
        if(temp){
            Rebate_Contract__c RCC = [select id, Name,Last_Sent_Appoval_Step__c,Total_Other_Value__c,Last_Approval_Step__c,CurrencyIsoCode from Rebate_Contract__c where name = :rC.Contract limit 1];
            RCC.Last_Sent_Appoval_Step__c  = 0;
            Update RCC;
        }
        
        
        //saving records
        //updateGoals(liGD, rC) ; commented by swapnil
        
        Territory_Distributor__c TD = [select id,TerritoryManager__c,Regional_Manager_Id__c,Zonal_Manager_Id__c,SBU_Head_Id__c from Territory_Distributor__c where id = :rc.TerritoryId];
        Rebate_Contract__c Rcont = new Rebate_Contract__c();
        Rcont.Territory_Manager__c = TD.TerritoryManager__c;
        Rcont.Regional_Manager__c = TD.Regional_Manager_Id__c;
        Rcont.Zonal_Manager__c = TD.Zonal_Manager_Id__c;
        Rcont.SBU_Head__c = TD.SBU_Head_Id__c;
        
        UPL_Settings__c enddate = UPL_Settings__c.getInstance();
        user MarketingDirector = [select id from user where email = :enddate.Marketing_Director_Email__c limit 1];
        Rcont.Marketing_Director__c = MarketingDirector.Id; 
        Rcont.Id = rC.ContractId;
        update Rcont;
        
        rebate_Contract__c rC_new  = [select EXPMM__c, Growth_Rate__c,Growth_Index__c,Total_Value_LY__c from rebate_Contract__c where id = :rc.ContractId][0];
        if( rC_new.EXPMM__c == 'X' || rC_new.Growth_Rate__c >=rC_new.Growth_Index__c || (rC_new.Growth_Rate__c == null && rC_new.Total_Value_LY__c == 0)){
            //calling approval process
            // add RCCTemp.EXPMM__c=='X' for RITM0432971 modified by Javed(Grazitti) modified date- 30-09-2022
            try{
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('');
                req.setObjectId(rC_new.Id);
                Approval.ProcessResult result = Approval.process(req);
                system.debug('result'+result);
                //return 'Successfully Submitted for Approval';
                return System.Label.REB_Message_Success_Approval;
            }
            catch (exception e){
                //return 'Already Submitted for Approval';
                return e.getMessage();
                
            }
            
            
        }
        else{
            return System.Label.REB_Message_Growth;
        }
        
    }
    
    @Auraenabled
    public static string  sendGoals(list<goalDetailsWrapper> liGD, rebateContract rC){
        try{
            //calling API
            SendGoalRequestWrapper send= new SendGoalRequestWrapper();
            send.actionCode= '3';
            send.I_NETOUT=string.valueOf(rC.TotalOtherValue);
            send.userRole='03';
            //send.I_ACAOR = '3';
            //send.I_PERFL = '03';
            send.companyCode='5190';
            send.contractNumber=rC.Contract;//rC.Contract
            send.approverEmail= userInfo.getUserEmail();
            send.I_ENVIAR='X'; //send.I_ENVIAR='3';
            send.comments='';
            list<SendGoalRequestWrapper.Item> lstToSend = new list<SendGoalRequestWrapper.Item>();
            //list<SendGoalRequestWrapper.Goals> lstToSend = new list<SendGoalRequestWrapper.Goals>();
            for (Rebate_Goal_SKU__c RGSKU: [select id,Name,SKU_Code__c,Product_Category__c,Volume_LY__c,Price_LY__c,Value_LY__c,Volume__c,Price__c,Value__c,Actual_Value__c,Contract__r.name,SKU__c,SKU__r.SKU_Code__c,SKU__r.Name,Actual_Volume__c,  Brand_Name__c from Rebate_Goal_SKU__c where Contract__c = :rC.ContractId ]){
                //SendGoalRequestWrapper.Goals lst = new SendGoalRequestWrapper.Goals();
                SendGoalRequestWrapper.Item lst = new SendGoalRequestWrapper.Item();
                lst.skuCode=RGSKU.SKU_Code__c;
                lst.volume=string.valueOf(RGSKU.Volume__c);
                lst.unitPrice=string.valueOf(RGSKU.Price__c);
                lstToSend.add(lst);
            }
            SendGoalRequestWrapper.goals gItem= new SendGoalRequestWrapper.goals();
            gItem.item= lstToSend;
            //send.goals=lstToSend;
            send.goals=gItem;
            boolean temp;
            temp=RebateServiceHelper.SendGoals(send);
            system.debug('temp is'+ temp );
            if(temp){
                Rebate_Contract__c RCC = [select id, Name,Last_Sent_Appoval_Step__c,Total_Other_Value__c,Last_Approval_Step__c,CurrencyIsoCode from Rebate_Contract__c where name = :rC.Contract limit 1];
                RCC.Last_Sent_Appoval_Step__c  = 0;
                Update RCC;
            }
            return System.Label.REB;
        }
        catch (exception e){
            //return 'Already Submitted for Approval';
            return e.getMessage();
            
        }
        
    }
    
    @InvocableMethod
    public static void SyncApproval(list<ID> ContractId) {
        
        if(!inFutureContext){
           
            //Change by Swaranjeet(Grazitti) APPS-4793- Brazil (Rebate mass approval)
            if(ContractId.size()>1){
                  System.debug('--ContractId size-----------'+ContractId.size());
                for(ID cont: ContractId){
                    System.debug('------cont-----------'+cont);
                    Grz_RebateContractMassApprovalBatch batchJob = new Grz_RebateContractMassApprovalBatch(new List<ID> {cont});
                    Id batchJobId = Database.executeBatch(batchJob, 1);
                    System.debug('------batchJobId-----------'+batchJobId);
                    inFutureContext = true; 
                    
                }
                
                
            }
            else{
               futureUpdateHistoryCallout(ContractId);
            	inFutureContext = true; 
            }
             
        }
        
        
    }
    @future(callout=true)
public static void futureUpdateHistoryCallout(list<ID> ContractId)
{   
     	System.debug('-----ContractId-----------'+ContractId);
          Rebate_Contract__c RC = [select id, Last_Sent_Appoval_Step__c,Name,Total_Other_Value__c,Last_Approval_Step__c,CurrencyIsoCode from Rebate_Contract__c where id = :ContractId limit 1];        

    if(RC.Last_Sent_Appoval_Step__c < RC.Last_Approval_Step__c -1 ){
        boolean temp;
        integer stepDiff = integer.valueOf(RC.Last_Approval_Step__c - RC.Last_Sent_Appoval_Step__c );
        id ProcessDefinition = [select id from processDefinition where developername = 'Rebate_Approval_Processv'][0].ID;
        if(!ContractId.isEmpty()){
            list<ProcessInstance> latestInstance = new list<ProcessInstance>();
            latestInstance = [SELECT Id,processdefinition.name,targetObjectId 
                              FROM ProcessInstance where targetObjectId = :ContractId[0] and processdefinitionId = :ProcessDefinition order by lastmodifieddate DESC limit 1];
            latestInstance.sort();
            //
            integer i =  integer.valueof(RC.Last_Sent_Appoval_Step__c +1);
            list<ProcessInstanceStep> latestInstanceStep = new list<ProcessInstanceStep>();
            latestInstanceStep = [SELECT Id, ProcessInstanceId, StepStatus, OriginalActorId, 
                                  ActorId,actor.email, Comments, StepNodeId FROM ProcessInstanceStep where ProcessInstanceId = :latestInstance order by SystemModstamp  DESC limit :stepDiff];
            latestInstanceStep.sort();    
            for(ProcessInstanceStep PI: latestInstanceStep) {
                
                SendGoalRequestWrapper send= new SendGoalRequestWrapper();
                if(PI.StepStatus == 'Rejected')
                    send.actionCode= '2';
                else
                    send.actionCode= '1';    
                send.I_NETOUT=string.valueOf(rC.Total_Other_Value__c);
                if(i ==1)
                    send.userRole='04'; 
                else if(i ==2)
                    send.userRole='11';
                else if(i ==3)
                    send.userRole='05';
                else if(i==4) // Added for Marketing Director Role
                    send.userRole='15';
                else
                    send.userRole='12';
                send.companyCode='5190';
                send.contractNumber=rC.Name;//rC.Contract
                send.approverEmail= PI.Actor.email;
                send.I_ENVIAR='';
                send.comments=PI.Comments;
                //list<SendGoalRequestWrapper.Goals> lstToSend = new list<SendGoalRequestWrapper.Goals>();
                list<SendGoalRequestWrapper.Item> lstToSend = new list<SendGoalRequestWrapper.Item>();
                
                SendGoalRequestWrapper.goals gItem= new SendGoalRequestWrapper.goals();
                gItem.item = lstToSend;
                //send.goals=lstToSend;
                
                temp=RebateServiceHelper.SendGoals(send);
                system.debug('temp is'+ temp );
                system.debug('i'+ i++ );
                
            }  
            
            
        }
        //update Last Sent Approval Step
        if(temp){
            RC.Last_Sent_Appoval_Step__c  = RC.Last_Approval_Step__c;
            Update RC;
        }
    }
    else{ 
        
        id ProcessDefinition = [select id from processDefinition where developername = 'Rebate_Approval_Processv'][0].ID;
        
        if(!ContractId.isEmpty()){
            
            list<ProcessInstance> latestInstance = new list<ProcessInstance>();
            latestInstance = [SELECT Id,processdefinition.name,targetObjectId 
                              FROM ProcessInstance where targetObjectId = :ContractId[0] and processdefinitionId = :ProcessDefinition order by lastmodifieddate DESC limit 1];
            
            list<ProcessInstanceStep> latestInstanceStep = new list<ProcessInstanceStep>();
            latestInstanceStep = [SELECT Id, ProcessInstanceId, StepStatus, OriginalActorId, 
                                  ActorId,actor.email, Comments, StepNodeId FROM ProcessInstanceStep where ProcessInstanceId = :latestInstance[0].Id order by SystemModstamp  DESC limit 1];
            
            
            //calling API
            SendGoalRequestWrapper send= new SendGoalRequestWrapper();
            if(latestInstanceStep[0].StepStatus == 'Rejected')
                send.actionCode= '2';
            else
                send.actionCode= '1';    
            send.I_NETOUT=string.valueOf(rC.Total_Other_Value__c);
            if(RC.Last_Approval_Step__c ==1)
                send.userRole='04'; 
            else if(RC.Last_Approval_Step__c ==2)
                send.userRole='11';
            else if(RC.Last_Approval_Step__c ==3)
                send.userRole='05';
            else if(RC.Last_Approval_Step__c ==4)// Rebate Marketing Director role
                send.userRole='15';
            else
                send.userRole='12';
            send.companyCode='5190';
            send.contractNumber=rC.Name;//rC.Contract
            send.approverEmail= latestInstanceStep[0].Actor.email;
            send.I_ENVIAR='';
            send.comments=latestInstanceStep[0].Comments;
            //list<SendGoalRequestWrapper.Goals> lstToSend = new list<SendGoalRequestWrapper.Goals>();
            list<SendGoalRequestWrapper.Item> lstToSend = new list<SendGoalRequestWrapper.Item>();
            
            for (Rebate_Goal_SKU__c RGSKU: [select id,Name,SKU_Code__c,Product_Category__c,Volume_LY__c,Price_LY__c,Value_LY__c,Volume__c,Price__c,Value__c,Actual_Value__c,Contract__r.name,SKU__c,SKU__r.SKU_Code__c,SKU__r.Name,Actual_Volume__c,  Brand_Name__c from Rebate_Goal_SKU__c where Contract__c = :ContractId[0] ]){
                //SendGoalRequestWrapper.Goals lst = new SendGoalRequestWrapper.Goals();
                SendGoalRequestWrapper.Item lst = new SendGoalRequestWrapper.Item();
                lst.skuCode=RGSKU.SKU_Code__c;
                lst.volume=string.valueOf(RGSKU.Volume__c);
                lst.unitPrice=string.valueOf(RGSKU.Price__c);
                lstToSend.add(lst);
            }
            
            SendGoalRequestWrapper.goals gItem= new SendGoalRequestWrapper.goals();
            gItem.item = lstToSend;
            //send.goals=lstToSend;
            boolean temp;
            temp=RebateServiceHelper.SendGoals(send);
            system.debug('temp is'+ temp );
            //update Last Sent Approval Step
            if(temp){
                RC.Last_Sent_Appoval_Step__c  = RC.Last_Approval_Step__c;
                Update RC;
            }
        }
        
        
        /*Rebate_Contract_Workflow__c RCW = new Rebate_Contract_Workflow__c();
RCW.CurrencyIsoCode = RC.CurrencyIsoCode;
RCW.Contract__c = RC.Id;
RCW.Action_Date__c = date.today();
RCW.Role_Code__c = '03';
RCW.Role_Description__c = 'RTV';
RCW.Action_Code__c = '3';
RCW.Action_Description__c = 'Insert Goals';
RCW.Approval_Comments__c = latestInstanceStep[0].Comments;
RCW.User__c = latestInstanceStep[0].ActorId;
RCW.User_Email__c = latestInstanceStep[0].Actor.email;
RCW.ApprovalHistoryId__c = latestInstanceStep[0].Id;
upsert RCW ApprovalHistoryId__c;*/
        //insert RCW; 
        
        
        
    }
        
    
  

                 }
                 
    
    
      
    
    
    
    
    
    public class goalDetailsWrapper {
        
        @AuraEnabled
        public string code {get;set;}
        @AuraEnabled
        public string Id {get;set;}
        @AuraEnabled
        public string ProductGroup {get;set;}
        
        @AuraEnabled
        public string Product {get;set;}
        @AuraEnabled
        public decimal Volume2018 {get;set;}
        @AuraEnabled
        public decimal Price2018 {get;set;}
        @AuraEnabled
        public decimal Amount2018 {get;set;}
        @AuraEnabled
        public decimal VolumeGoal {get;set;}
        @AuraEnabled
        public decimal AmountGoal {get;set;}
        @AuraEnabled
        public decimal Goal_Billing {get;set;}
        @AuraEnabled
        public string product_category {get;set;}
        
        @AuraEnabled
        public string response_service {get;set;}
        //updated by Swapnil 
        @AuraEnabled
        public decimal TotalTypeValue {get;set;}
        @AuraEnabled
        public decimal TotalTypeValueLY {get;set;}
        @AuraEnabled
        public decimal TotalOtherValue {get;set;}
        @AuraEnabled
        public decimal TotalOtherValueLY {get;set;}
        @AuraEnabled
        public decimal TotalValue {get;set;}
        @AuraEnabled
        public decimal TotalValueLY {get;set;}
        
        
        
    }
    
    @Auraenabled
    public static list<goalHistoryWrapper> getHistoryGoals(rebateContract rC){
        //API call
        GetApprovalHistoryRequestWrapper reqApp = new GetApprovalHistoryRequestWrapper();
        reqApp.companyCode='5190';//put this value using custom setting
        reqApp.contractNumber=rC.Contract; // here contract number will come 
        Boolean response;
        response= RebateServiceHelper.getApprovalHistory(reqApp);
        
        
        list<goalHistoryWrapper> liwrapper = new list<goalHistoryWrapper>();
        
        for (Rebate_Contract_Workflow__c RCW: [select Action_Date__c,createddate,New_Approval_Status__c,Role_Description__c,User_Email__c,Action_Description__c,Approval_Comments__c from Rebate_Contract_Workflow__c where Contract__c = :rC.ContractId order by createddate desc]){
            goalHistoryWrapper wrapper = new goalHistoryWrapper();
            wrapper.Date_history = string.valueOf(RCW.Action_Date__c);
            wrapper.Responsible = RCW.Role_Description__c;
            wrapper.User = RCW.User_Email__c;
            wrapper.Action = RCW.Action_Description__c;
            wrapper.New_approval_Status = RCW.New_Approval_Status__c;
            wrapper.Justification = RCW.Approval_Comments__c;
            liwrapper.add(wrapper);
            
        }
        
        return  liwrapper;
    }
    
    
    public class goalHistoryWrapper {
        
        @AuraEnabled
        public string Date_history {get;set;}        
        @AuraEnabled
        public string Responsible {get;set;}        
        @AuraEnabled
        public string User {get;set;}        
        @AuraEnabled
        public string Action {get;set;}
        @AuraEnabled
        public string New_approval_Status {get;set;}
        @AuraEnabled
        public string Justification {get;set;}
        
    }
    
    @AuraEnabled
    public static goalvsActualCalculations getgoalvsActualCalculations(rebateContract rContract){
        
        String companyCode= UPL_Settings__c.getOrgDefaults().Company_Code__c;
        String sales_Org = UPL_Settings__c.getOrgDefaults().BR_Sales_Org__c;
        goalvsActualCalculations GAWrapper = new goalvsActualCalculations();
        GetGoalActualsRequestWrapper act= new GetGoalActualsRequestWrapper();
        act.companyCode=companyCode;
        act.contractNumber=rContract.Contract;
        Boolean response;
        response=RebateServiceHelper.GetGoalActuals(act);
        if(!response){
            GAWrapper.responseService=false;
            return GAWrapper;
        }
        actualData cyActualData = new actualData();
        goalData cygoalData = new goalData();
        GrowthAnalysisVSPreviousYear GAVSPY = new GrowthAnalysisVSPreviousYear();
        For(Rebate_Contract__c rebCon : [Select id, Attainment__c,Goal_Value__c,Actual_Value__c,Actual_Value_LY__c,Net_Actual_Value__c,Net_Returns_Value__c,Deviation__c,Growth__c from Rebate_Contract__c where Name=:rContract.Contract and Sales_Org__r.Sales_Org_Code__c =:sales_Org limit 1])
        {
            
            /*cygoalData.GoalsCY = 542105.60;
cygoalData.ActualCY = 461384.20;
cygoalData.Attainment = 85.11;
*/
            
            cygoalData.GoalsCY = rebCon.Goal_Value__c;
            cygoalData.ActualCY = rebCon.Actual_Value__c;
            cygoalData.Attainment = rebCon.Attainment__c;
            
            
            
            /*cyActualData.Real = 556027.48;
cyActualData.Returns = 27797.64;
cyActualData.PercntReturns = 05.00;
*/
            cyActualData.Real =rebCon.Net_Actual_Value__c ;
            cyActualData.Returns =rebCon.Net_Returns_Value__c ;
            cyActualData.PercntReturns =rebCon.Deviation__c;
            
            
            GAVSPY.Actual_TY_Label = 'Actual 2017';
            GAVSPY.Actual_LY_Label = 'Actual 2018';
            /*GAVSPY.Actual_TY = 489272.98;
GAVSPY.Actual_LY = 461384.20;
GAVSPY.Growth = 05.70;*/
            
            
            GAVSPY.Actual_TY = rebCon.Actual_Value__c;
            GAVSPY.Actual_LY = rebCon.Actual_Value_LY__c;
            GAVSPY.Growth = rebCon.Growth__c;
            
        }
        GAWrapper.goalData = cygoalData;
        GAWrapper.actualData = cyActualData;
        GAWrapper.responseService=true;
        
        GAWrapper.GrowthAnalysisVSPreviousYear = GAVSPY;
        //bd setup
        OtherProduct Op = new OtherProduct();
        Op.Goals_Volume = 0;
        Op.Goals_Value = 0;
        Op.Real_Volume = 0;
        Op.Real_Value = 0;
        op.Returns_Volume = 0;
        Op.Returns_Value = 0;
        Map <String,TotalPamProduct> mapTotalCategory = new Map <String,TotalPamProduct>();
        list<Rebate_Goal_Brand__c> rebBrand = new list<Rebate_Goal_Brand__c>([SELECT Actual_Value__c,Actual_Volume__c,Attainment_Volume__c,Brand_Name__c,Product_Category__c ,Name,Net_Value__c,Net_Volume__c,Returns_Value__c,Returns_Volume__c,Total_Actual_Value__c,Total_Returns_Value__c,Value_LY__c,Value__c,Volume_LY__c,Volume__c FROM Rebate_Goal_Brand__c where Contract__r.name =:rContract.Contract and Contract__r.Sales_Org__r.Sales_Org_Code__c=:sales_Org]);
        for(Rebate_Goal_Brand__c rB: rebBrand)
        {
            if(rB.Product_Category__c !='outros'){
                system.debug('reached 1');
                mapTotalCategory.put(rB.Product_Category__c,null);
            }
            if(rB.Product_Category__c == 'outros')
            {
                Op.Goals_Volume += rB.Volume__c;
                Op.Goals_Value +=rB.Value__c ;
                Op.Real_Volume +=rB.Actual_Volume__c ;
                Op.Real_Value += rB.Actual_Value__c; 
                op.Returns_Volume +=rB.Returns_Volume__c ;
                Op.Returns_Value += rB.Returns_Value__c;
                
            }
            
        }
        //
        
        
        //
        /*
list<PamProduct> LiPP = new list<PamProduct>();

set<String> proCategories = new set<string>();

List<String> lstProcategories=new List<String>();
for (integer i=0;i<10;i++){
PamProduct p = new PamProduct();
p.Product_Category='Premium';//added by diwansh 
p.Product_Group = 'APPLAUD';
p.Goals_Volume = 600.00;
p.Goals_Value = 25338.00;
p.Real_Volume = 10.00;
p.Real_Value = 10.00;
p.Returns_Volume = 10.00;
p.Returns_Value = 10.00;
p.Reach_Volume_Percnt = 10.00;
p.Reach_Real_Volume = 10.00;
p.Reach_Real_Value = 10.00;
LiPP.add(p);
proCategories.add(p.Product_Category);
if(p.Product_Category !='Demais'){
system.debug('reached 1');
mapTotalCategory.put(p.Product_Category,null);
}
}
//added by diwansh sethi 
for (integer i=0;i<2;i++){
PamProduct p = new PamProduct();
p.Product_Category='Estratégicos';//added by diwansh 
p.Product_Group = 'APPLAUD';
p.Goals_Volume = 600.00;
p.Goals_Value = 25338.00;
p.Real_Volume = 10.00;
p.Real_Value = 10.00;
p.Returns_Volume = 10.00;
p.Returns_Value = 10.00;
p.Reach_Volume_Percnt = 10.00;
p.Reach_Real_Volume = 10.00;
p.Reach_Real_Value = 10.00;
LiPP.add(p);
proCategories.add(p.Product_Category);
if(p.Product_Category !='Demais'){
system.debug('reached 2');
mapTotalCategory.put(p.Product_Category,null);}
}

//added by diwansh sethi 
for (integer i=0;i<3;i++){
PamProduct p = new PamProduct();
p.Product_Category='Biossoluções';//added by diwansh 
p.Product_Group = 'APPLAUD';
p.Goals_Volume = 600.00;
p.Goals_Value = 25338.00;
p.Real_Volume = 10.00;
p.Real_Value = 10.00;
p.Returns_Volume = 10.00;
p.Returns_Value = 10.00;
p.Reach_Volume_Percnt = 10.00;
p.Reach_Real_Volume = 10.00;
p.Reach_Real_Value = 10.00;
LiPP.add(p);
proCategories.add(p.Product_Category);
if(p.Product_Category !='Demais'){
system.debug('reached 2');
mapTotalCategory.put(p.Product_Category,null);}
}
//addedby diwansh
for (integer i=0;i<4;i++){
PamProduct p = new PamProduct();
p.Product_Category='Biossoluções';//added by diwansh 
p.Product_Group = 'APPLAUD';
p.Goals_Volume = 60.00;
p.Goals_Value = 40.00;
p.Real_Volume = 10.00;
p.Real_Value = 10.00;
p.Returns_Volume = 10.00;
p.Returns_Value = 10.00;
p.Reach_Volume_Percnt = 10.00;
p.Reach_Real_Volume = 10.00;
p.Reach_Real_Value = 10.00;
LiPP.add(p);
proCategories.add(p.Product_Category);
if(!(p.Product_Category =='Demais')){ 
mapTotalCategory.put(p.Product_Category,null);
}
}
lstProcategories.addAll(proCategories);// added by diwansh 
db comments */
        
        
        TotalPamProduct TotalPPCal = new TotalPamProduct();
        TotalPPCal.Goals_Volume = 0;
        TotalPPCal.Goals_Value = 0;
        TotalPPCal.Real_Volume = 0;
        TotalPPCal.Real_Value = 0;
        TotalPPCal.Returns_Volume = 0;
        TotalPPCal.Returns_Value = 0;
        TotalPPCal.Reach_Volume_Percnt = 0;
        TotalPPCal.Reach_Real_Volume = 0;
        TotalPPCal.Reach_Real_Value = 0;
        
        for(Rebate_Goal_Brand__c rB : rebBrand){
            if(!(rB.Product_Category__c =='outros')){
                TotalPPCal.Goals_Volume += rB.Volume__c;
                TotalPPCal.Goals_Value +=rb.Value__c;
                TotalPPCal.Real_Volume += rB.Actual_Volume__c;
                TotalPPCal.Real_Value += rB.Actual_Value__c;
                TotalPPCal.Returns_Volume += rB.Returns_Volume__c;
                TotalPPCal.Returns_Value += rB.Returns_Value__c;
                TotalPPCal.Reach_Volume_Percnt +=rB.Attainment_Volume__c;
                TotalPPCal.Reach_Real_Volume += rB.Net_Volume__c;
                TotalPPCal.Reach_Real_Value += rB.Net_Value__c;
            }
        }
        
        For(Rebate_Goal_Brand__c rB: rebBrand){
            if(mapTotalCategory.containsKey(rB.Product_Category__c))
            {
                TotalPamProduct Total = new TotalPamProduct();
                
                Total = mapTotalCategory.get(rB.Product_Category__c);
                if(Total ==null){
                    Total = new TotalPamProduct();            
                    Total.Goals_Volume = 0;
                    Total.Goals_Value = 0;
                    Total.Real_Volume = 0;
                    Total.Real_Value = 0;
                    Total.Returns_Volume = 0;
                    Total.Returns_Value = 0;
                    Total.Reach_Volume_Percnt = 0;
                    Total.Reach_Real_Volume = 0;
                    Total.Reach_Real_Value = 0;         
                }
                Total.Goals_Volume += rB.Volume__c;
                Total.Goals_Value +=rb.Value__c;
                Total.Real_Volume += rB.Actual_Volume__c;
                Total.Real_Value += rB.Actual_Value__c;
                Total.Returns_Volume += rB.Returns_Volume__c;
                Total.Returns_Value += rB.Returns_Value__c;
                Total.Reach_Volume_Percnt +=rB.Attainment_Volume__c;
                Total.Reach_Real_Volume += rB.Net_Volume__c;
                Total.Reach_Real_Value += rB.Net_Value__c;
                //if(p.Product_Category!='Demais')
                mapTotalCategory.put(rB.Product_Category__c,Total);
            }     
        }
        
        
        /*for(PamProduct p : LiPP){
if(!(p.Product_Category =='Demais')){
TotalPPCal.Goals_Volume += p.Goals_Volume;
TotalPPCal.Goals_Value += p.Goals_Value;
TotalPPCal.Real_Volume += p.Real_Volume;
TotalPPCal.Real_Value += p.Real_Value;
TotalPPCal.Returns_Volume += p.Returns_Volume;
TotalPPCal.Returns_Value += p.Returns_Value;
TotalPPCal.Reach_Volume_Percnt += p.Reach_Volume_Percnt;
TotalPPCal.Reach_Real_Volume += p.Reach_Real_Volume;
TotalPPCal.Reach_Real_Value += p.Reach_Real_Value;
}
} db comment*/
        //added by diwansh  
        /* db comment
for(PamProduct p : LiPP){
if(mapTotalCategory.containsKey(p.Product_Category))
{
TotalPamProduct Total = new TotalPamProduct();

Total = mapTotalCategory.get(p.Product_Category);
if(Total ==null){
Total = new TotalPamProduct();            
Total.Goals_Volume = 0;
Total.Goals_Value = 0;
Total.Real_Volume = 0;
Total.Real_Value = 0;
Total.Returns_Volume = 0;
Total.Returns_Value = 0;
Total.Reach_Volume_Percnt = 0;
Total.Reach_Real_Volume = 0;
Total.Reach_Real_Value = 0;         
}
Total.Goals_Volume += p.Goals_Volume;
Total.Goals_Value += p.Goals_Value;
Total.Real_Volume += p.Real_Volume;
Total.Real_Value += p.Real_Value;
Total.Returns_Volume += p.Returns_Volume;
Total.Returns_Value += p.Returns_Value;
Total.Reach_Volume_Percnt += p.Reach_Volume_Percnt;
Total.Reach_Real_Volume += p.Reach_Real_Volume;
Total.Reach_Real_Value += p.Reach_Real_Value;
//if(p.Product_Category!='Demais')
mapTotalCategory.put(p.Product_Category,Total);
}     
} db ends */
        for (String key : mapTotalCategory.keySet())
        {
            system.debug('map value is '+ key + 'values is ' +mapTotalCategory.get(key));
        }
        
        /* db comment
OtherProduct Op = new OtherProduct();
Op.Goals_Volume = 600.00;
Op.Goals_Value = 25338.00;
Op.Real_Volume = 10.00;
Op.Real_Value = 10.00;
op.Returns_Volume = 10.00;
Op.Returns_Value = 10.00;
db comment*/
        Total TotalProduct = new Total();
        TotalProduct.Goals_Volume = op.Goals_Volume+TotalPPCal.Goals_Volume;
        TotalProduct.Goals_Value = op.Goals_Value+TotalPPCal.Goals_Value;
        TotalProduct.Real_Volume = op.Real_Volume+TotalPPCal.Real_Volume;
        TotalProduct.Real_Value = op.Real_Value+TotalPPCal.Real_Value;
        TotalProduct.Returns_Volume = op.Returns_Volume+TotalPPCal.Returns_Volume;
        TotalProduct.Returns_Value = op.Returns_Value+TotalPPCal.Returns_Value;
        
        GAWrapper.OtherProduct = Op;      
        GAWrapper.TotalPP = TotalPPCal;  
        //db GAWrapper.liPamProduct=LiPP;
        GAWrapper.TotalP = TotalProduct; 
        //db GAWrapper.categories=lstProcategories;//added by diwansh
        GAWrapper.Mymap= mapTotalCategory;
        GAWrapper.liRebGoal= rebBrand;
        return GAWrapper;
        
        
    }
    
    
    public class goalData {
        
        @AuraEnabled
        public decimal GoalsCY {get;set;}        
        @AuraEnabled
        public decimal ActualCY {get;set;}        
        @AuraEnabled
        public decimal Attainment {get;set;} 
        
    }
    
    
    
    public class actualData {
        
        @AuraEnabled
        public decimal Real {get;set;}        
        @AuraEnabled
        public decimal Returns {get;set;}        
        @AuraEnabled
        public decimal PercntReturns {get;set;} 
        
    }
    
    public class PamProduct {
        //added by diwansh
        @AuraEnabled
        public string Product_Category {get;set;} 
        //ends
        @AuraEnabled
        public string Product_Group {get;set;}        
        @AuraEnabled
        public decimal Goals_Volume {get;set;}        
        @AuraEnabled
        public decimal Goals_Value {get;set;}
        @AuraEnabled
        public decimal Real_Volume {get;set;}
        @AuraEnabled
        public decimal Real_Value {get;set;}
        @AuraEnabled
        public decimal Returns_Volume {get;set;}
        @AuraEnabled
        public decimal Returns_Value {get;set;}
        @AuraEnabled
        public decimal Reach_Volume_Percnt {get;set;}
        @AuraEnabled
        public decimal Reach_Real_Volume  {get;set;}
        @AuraEnabled
        public decimal Reach_Real_Value  {get;set;}
        
        
        
        
    }
    
    public class TotalPamProduct {
        
        
        @AuraEnabled
        public decimal Goals_Volume {get;set;}        
        @AuraEnabled
        public decimal Goals_Value {get;set;}
        @AuraEnabled
        public decimal Real_Volume {get;set;}
        @AuraEnabled
        public decimal Real_Value {get;set;}
        @AuraEnabled
        public decimal Returns_Volume {get;set;}
        @AuraEnabled
        public decimal Returns_Value {get;set;}
        @AuraEnabled
        public decimal Reach_Volume_Percnt {get;set;}
        @AuraEnabled
        public decimal Reach_Real_Volume  {get;set;}
        @AuraEnabled
        public decimal Reach_Real_Value  {get;set;}
        
        
        
        
    }
    
    public class OtherProduct {
        
        
        @AuraEnabled
        public decimal Goals_Volume {get;set;}        
        @AuraEnabled
        public decimal Goals_Value {get;set;}
        @AuraEnabled
        public decimal Real_Volume {get;set;}
        @AuraEnabled
        public decimal Real_Value {get;set;}
        @AuraEnabled
        public decimal Returns_Volume {get;set;}
        @AuraEnabled
        public decimal Returns_Value {get;set;}
        
        
    }
    
    public class Total {
        
        
        @AuraEnabled
        public decimal Goals_Volume {get;set;}        
        @AuraEnabled
        public decimal Goals_Value {get;set;}
        @AuraEnabled
        public decimal Real_Volume {get;set;}
        @AuraEnabled
        public decimal Real_Value {get;set;}
        @AuraEnabled
        public decimal Returns_Volume {get;set;}
        @AuraEnabled
        public decimal Returns_Value {get;set;}
        
        
    }
    
    public class GrowthAnalysisVSPreviousYear{
        @AuraEnabled
        public string Actual_TY_Label {get;set;}
        @AuraEnabled
        public string Actual_LY_Label {get;set;}
        @AuraEnabled
        public decimal Actual_TY {get;set;}
        @AuraEnabled
        public decimal Actual_LY {get;set;}
        @AuraEnabled
        public decimal Growth {get;set;}
    }
    
    public class goalvsActualCalculations{
        
        @AuraEnabled
        public boolean responseService{get;set;}
        @AuraEnabled
        public List<Rebate_Goal_Brand__c> liRebGoal{get;set;}
        @AuraEnabled
        public list<string> categories{get;set;}
        @AuraEnabled
        public goalData goalData{get;set;}
        @AuraEnabled
        public actualData actualData{get;set;}
        @AuraEnabled
        public List<PamProduct> liPamProduct{get;set;}
        @AuraEnabled
        public OtherProduct OtherProduct{get;set;}
        @AuraEnabled
        public GrowthAnalysisVSPreviousYear GrowthAnalysisVSPreviousYear{get;set;}
        @AuraEnabled
        public TotalPamProduct TotalPP{get;set;}
        @AuraEnabled
        public Map<String,TotalPamProduct> Mymap = new Map<String,TotalPamProduct>();//added by diwansh 
        
        
        @AuraEnabled
        public Total TotalP{get;set;}
        
    }
    /* 
@AuraEnabled
public static list<String> getProductCategory()
{
list<string> lstPC= new list<string>();

lstPC= picklistValues('Rebate_Goal_SKU__c','Product_Category__c');
return lstPC;
}*/
    
    
    @Auraenabled
    public static rebateContract UpdateDistributorAcceptance(rebateContract rC){
        
        Rebate_Contract__c Rcont = new Rebate_Contract__c();
        Rcont.Id = rC.ContractId;
        Rcont.Distributor_Accepted__c = true;
        Rcont.Distributor_Acceptance_Date__c = system.now();
        Rcont.Distributor_Reviewer__c = userinfo.getUserId();
        update Rcont;
        
        rC.DistAccepted = true;
        rC.DistAccDate = string.valueOf(system.now());
        rC.DistReviewName = userinfo.getFirstName()+' '+userinfo.getLastName();
        return rC;
        
        
    }
    
    //Ticket APPS-5297 Created By:-Gunnagya Nijhawan 1/06/2023
    //Start
    
    @AuraEnabled
    public static String pdfAction(Id ContractId1)
    {
        
        PageReference rebateurl;
        System.debug('contractId:--- ' + ContractId1);
        rebateurl = Page.PrintRebateForm;
        system.debug('rebateurl>>'+rebateurl.getUrl());
        List<Rebate_Contract__c> rebateContract = [select id, Name from Rebate_Contract__c where id =: ContractId1];
        String contractName;
        if(!rebateContract.isEmpty())
        {
            Rebate_Contract__c contract = rebateContract[0];
            contractName = contract.Name;
            System.debug('contractName: ' + contractName);
        }
        System.debug('contractName: ' + contractName);
        String baseUrl= System.Label.Rebate_Terms_vf_page_base_url;
        rebateurl.getParameters().put('contractId',contractName);
        system.debug('rebateurl + baseUrl>>>'+baseUrl+rebateurl.getUrl());
        PageReference savepage = new PageReference(baseUrl+rebateurl.getUrl());
        //	PageReference savepage = baseUrl+rebateurl;
        // PageReference savepage = new PageReference('https://upl--uat--c.sandbox.vf.force.com/apex/printrebateform?contractId=1510');
        system.debug('savepage>>'+savepage);
        Blob pdfBlob;
           if(!test.isRunningTest()){
       		pdfBlob = savepage.getContentAsPDF();
    	}else
        {
     		 pdfBlob = blob.valueof('TEST');
   		 }
       // Blob pdfBlob = savepage.getContentAsPDF();
        
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
        conVer.PathOnClient = 'RebateTerm'+contractName+'.pdf'; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = 'RebateTerm'+contractName; // Display name of the files
        conVer.VersionData = pdfBlob; // converting your binary string to Blog
        insert conVer;    //Insert ContentVersion
        
        system.debug('inserted conVer');
        // First get the Content Document Id from ContentVersion Object
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        //create ContentDocumentLink  record 
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = ContractId1; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
        conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
        conDocLink.shareType = 'V';
        insert conDocLink;
        system.debug('conDocLink.Id>>'+conDocLink.Id);
        
        List<ContentDocumentLink> temp = [select id,ContentDocumentId from ContentDocumentLink where Id =:conDocLink.Id];
        Id doc = temp[0].id;
        SendContract(ContractId1,conVer.id);
        system.debug('conDocLink.Id>>>'+doc);
        
        system.debug('inserted attachmentS');
        return 'Success';
        
        
    }
    
    public static void SendContract(Id ContractId,Id conVer) {
        
        
        List<Rebate_Contract__c> rebateContract = [select id, Name,Type__c,Category_Name__c from Rebate_Contract__c where id =: ContractId];
        String rebateType = rebateContract[0].Type__c;
        String rebateCategory =  rebateContract[0].Category_Name__c;
        system.debug('rebateType>>'+rebateType);
        system.debug('rebateCategory>>'+rebateCategory);
        if(rebateType =='Cooper Up')
        {		
            if(rebateCategory=='SUPER ELITE')
            {
                Map<String,echosign_dev1.AgreementTemplateVariable> agreementTemplateVariables = new Map<String,echosign_dev1.AgreementTemplateVariable>();
                agreementTemplateVariables.put('SuperElite',new echosign_dev1.AgreementTemplateVariable('SuperElite',conVer));
                
                
                Id agreementId=echosign_dev1.AgreementTemplateService.load(System.Label.SuperElite,ContractId,agreementTemplateVariables);
            }
            else if(rebateCategory!='SUPER ELITE')
            {
                Map<String,echosign_dev1.AgreementTemplateVariable> agreementTemplateVariables = new Map<String,echosign_dev1.AgreementTemplateVariable>();
                agreementTemplateVariables.put('CooperUp',new echosign_dev1.AgreementTemplateVariable('CooperUp',conVer));
                
                
                Id agreementId=echosign_dev1.AgreementTemplateService.load(System.Label.CooperUp,ContractId,agreementTemplateVariables);       
            }             
            
            
        }
        else if(rebateType =='UP LÍDER')
        {
            if(rebateCategory=='SUPER CLASS')
            {
                Map<String,echosign_dev1.AgreementTemplateVariable> agreementTemplateVariables = new Map<String,echosign_dev1.AgreementTemplateVariable>();
                agreementTemplateVariables.put('SuperClassUPLIDER',new echosign_dev1.AgreementTemplateVariable('SuperClassUPLIDER',conVer));
                
                
                Id agreementId=echosign_dev1.AgreementTemplateService.load(System.Label.SuperClassUPLIDER,ContractId,agreementTemplateVariables);
            }
            else if(rebateCategory!='SUPER CLASS')
            {
                Map<String,echosign_dev1.AgreementTemplateVariable> agreementTemplateVariables = new Map<String,echosign_dev1.AgreementTemplateVariable>();
                agreementTemplateVariables.put('UpLider',new echosign_dev1.AgreementTemplateVariable('UpLider',conVer));
                
                
                Id agreementId=echosign_dev1.AgreementTemplateService.load(System.Label.UpLider,ContractId,agreementTemplateVariables);
            }
            
        }  
        //} 
        //catch (Exception e) {
        //    system.debug('Not Sent>>'+JSON.serializePretty(e.getMessage()));
        //}  
        
        
        //Id agreementId=echosign_dev1.AgreementTemplateService.load('a9I0l000000BBEIEA4',doc);
        //System.debug('Finished>>'+agreementId);
        
        
        
        
    }
    //End
    
    
    
}