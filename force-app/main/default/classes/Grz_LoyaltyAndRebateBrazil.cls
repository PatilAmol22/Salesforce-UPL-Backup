/**************************************************************************************************
* Name               : Grz_LoyaltyAndRebateBrazil                                                      
* Description        : Controller for grz_LoyaltyAndRebateBrazil component
* Created Date       : 10/02/2022                                                                
* Created By         : Grazitti Interactive                                                                    
* -------------------------------------------------------------------------------------------------
* VERSION  AUTHOR           DATE            COMMENTS                                                    
* 1.0      Nikhil Verma     10/02/2022      Initial Draft.                                              
**************************************************************************************************/

public with sharing class Grz_LoyaltyAndRebateBrazil {
    /******************************************************************************************************
    * @Description        : Function to get Contract Date and Filter picklist data                     
    * @Return             : rebateContractWrapper                                                                         
    *******************************************************************************************************/
    @AuraEnabled(cacheable=true)
    public static rebateContractWrapper getContractDate(){
        date startDate;
        date endDate;
        startDate = [Select startDate From Period Where type = 'YEAR' and StartDate = THIS_FISCAL_YEAR].startdate;
        endDate = [Select EndDate From Period Where type = 'YEAR' and StartDate = THIS_FISCAL_YEAR].EndDate;            
        map<id, distributor> mapDist = new map<id, distributor>();
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
        string LoggedInUserProfile ;
        string UserId = UserInfo.getUserId().substring(0,15);
        user  u = [select Contact.accountId,IsPortalEnabled, profile.Name,Account.Customer_Group__c from user where id = :UserId][0];
        Id accId = u.Contact.accountId;
        String groupCstr = u.Account.Customer_Group__c;
        Set<Id> accIds = new Set<Id>();
            if(!String.isEmpty(groupCstr)){
                for(Account ac : [SELECT Id FROM Account where Customer_Group__c =:groupCstr AND ParentId =:accId]){
                    accIds.add(ac.Id);
                }
            }
        accIds.add(accId);
        LoggedInUserProfile = u.profile.Name;
        list<rebateContract> liRebateConts = new list<rebateContract>();
        rebateContractWrapper wrapper = new rebateContractWrapper();
        if(accId != null){
            wrapper.isInternal = false;
            /*system.debug('Inside external User ==>');
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
            }*/     

            // Update Workflow condition for RITM0449029 GRZ(Nikhil Verma) 01-11-2022
            String workflowStatus = 'Em Acompanhamento';
            String query = 'SELECT Id,Type_Code__c,Distributor_Accepted__c,Distributor_Acceptance_Date__c,Distributor_Reviewer__r.name,Growth_Rate__c,Distributor__r.SAP_Code__c,Territory__r.SBU__r.name,Territory__r.SBU__r.Brazil_SBU_Name__c,Territory__r.Zone__r.name,Territory__r.Zone__c,Territory__r.SBU__c,Total_Type_Value__c,Total_Value_LY__c,Total_Value__c,Total_Other_Value_LY__c,Total_Other_Value__c,Total_Type_Value_LY__c,Territory__r.TerritoryManager__c,Contract_Date__c,CurrencyIsoCode,Sales_Rep__c,Name,Territory__r.region__c,Territory__r.region__r.name, Start_Date__c,Distributor__r.name,Region__r.name, End_Date__c, Combination_Key__c, Sales_Org__c, Distributor__c, Territory__c, Region__c, Category_Name__c, Status__c, Type__c, Workflow_Status__c, Last_Invoice_Date__c, Growth_Index__c, CRM_Status__c, Territory_Manager__c, Regional_Manager__c, Zonal_Manager__c, SBU_Head__c, Marketing_Director__c FROM Rebate_Contract__c where Distributor__c =: accIds AND Start_Date__c >=: startDate AND Workflow_Status__c =: workflowStatus';
            list<rebate_Contract__c> liRebateContract = Database.query(query); 
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
                if(rc.Workflow_Status__c != null){
                    /*if(rc.Workflow_Status__c.toUppercase() == 'CONTRATO PENDENTE' || rc.Workflow_Status__c.toUppercase() == 'AGUARDANDO METAS' || rc.Workflow_Status__c.toUppercase() == 'AGUARDANDO APROVAÇÃO DE METAS' || rc.Workflow_Status__c.toUppercase() == 'EM ACOMPANHAMENTO'){
                        rCont.Status = 'EM ACOMPANHAMENTO';
                    }
                    else if
                    (
                        rc.Workflow_Status__c.toUppercase() == 'AGUARDANDO INÍCIO DE APURAÇÃO' || rc.Workflow_Status__c.toUppercase() == 'AGUARDANDO CRÉDITO E COBRANÇA' || rc.Workflow_Status__c.toUppercase() == 'AGUARDANDO FINALIZAÇÃO APURAÇÃO' || rc.Workflow_Status__c.toUppercase() == 'AGUARDANDO APROVAÇÃO COORDENAÇÃO'
                        || rc.Workflow_Status__c.toUppercase() == 'AGUARDANDO APROVAÇÃO GERENTE ACESSO AO MERCADO' || rc.Workflow_Status__c.toUppercase() == 'AGUARDANDO APROVAÇÃO DIRETOR MARKETING OPERACIONAL' || rc.Workflow_Status__c.toUppercase() == 'AGUARDANDO APROVAÇÃO CCO' || rc.Workflow_Status__c.toUppercase() == 'AGUARDANDO APROVAÇÃO CFO' || rc.Workflow_Status__c.toUppercase() == 'AGUARDANDO EMISSÃO DE CARTA DE CRÉDITO'
                    )
                    {
                        rCont.Status = 'EM APURAÇÃO';
                    }else{
                        rCont.Status = rc.Workflow_Status__c.toUppercase();
                    }*/
                    rCont.Status = rc.Workflow_Status__c.toUppercase();
                }
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
                if(rc.Start_Date__c != null){
                    rCont.Initial_date =  String.valueOf(rc.Start_Date__c);
                }
                if(rc.End_Date__c != null){
                    rCont.Final_date = String.valueOf(rc.End_Date__c);
                }
                if(rc.Contract_Date__c != null){
                    rCont.Contract_date = grz_SapIntegration.FormattedDateBrazil(rc.Contract_Date__c);
                }
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
                //if(rc.Type_Code__c == 'L' ||  rc.Workflow_Status__c != 'Em Acompanhamento'){ //rc.CRM_Status__c != 'Approved' ||
                if(rc.Type_Code__c == 'L' || rc.CRM_Status__c != 'Approved' ){ //|| rc.Workflow_Status__c == 'Em Acompanhamento'
                    rCont.isActive = true;  
                    //rCont.isActive = false;   
                }
                else{
                    rCont.isActive = false;
                    //rCont.isActive = true; 
                }
                
                rCont.DistAccepted = rc.Distributor_Accepted__c;
                rCont.DistAccDate = string.valueOf(rc.Distributor_Acceptance_Date__c);
                rCont.DistReviewName = rc.Distributor_Reviewer__r.name;
                liRebateConts.add(rCont);
            }
        }
        else{
            wrapper.isInternal = true;
            //To show all fiter Variables to Admins
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
                if(u.profile.name == 'Brazil Rebate Admin' ||
                   u.profile.name == 'Brazil System Administrator' ||
                   u.profile.name == 'System Administrator' ||
                   u.profile.name == 'Brazil Customer Service Manager' ||
                   u.profile.name == 'Brazil Customer Service User' ||
                   u.profile.name == 'Brazil Regional Head'){ 
                       for(Territory_Distributor__c CRM : [select TerritoryManager__c, 
                                                           TerritoryManager__r.name 
                                                           from Territory_Distributor__c
                                                           where Sales_Org_Code__c = '5191'
                                                           order by TerritoryManager__r.name ASC]){
                                                              
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
                list<rebate_Contract__c> sortedliRebateContract = [SELECT Id,Type_Code__c,Distributor_Accepted__c,Distributor_Acceptance_Date__c,Distributor_Reviewer__r.name,Growth_Rate__c,Distributor__r.SAP_Code__c,Territory__r.SBU__r.name,Territory__r.SBU__r.Brazil_SBU_Name__c,Territory__r.Zone__r.name,Territory__r.Zone__c,Territory__r.SBU__c,Total_Type_Value__c,Total_Value_LY__c,Total_Value__c,Total_Other_Value_LY__c,Total_Other_Value__c,Total_Type_Value_LY__c,Territory__r.TerritoryManager__c,Contract_Date__c,CurrencyIsoCode,Sales_Rep__c,Name,Territory__r.region__c,Territory__r.region__r.name, Start_Date__c,Distributor__r.name,Region__r.name, End_Date__c, Combination_Key__c, Sales_Org__c, Distributor__c, Territory__c, Region__c, Category_Name__c, Status__c, Type__c, Workflow_Status__c, Last_Invoice_Date__c, Growth_Index__c, CRM_Status__c, Territory_Manager__c, Regional_Manager__c, Zonal_Manager__c, SBU_Head__c, Marketing_Director__c FROM Rebate_Contract__c order by Distributor__r.name ASC];   
               for(rebate_Contract__c rc: sortedliRebateContract){//liRebateContract
                   distributor dst = new distributor();
                   dst.name = rc.Distributor__r.name;
                   dst.Id = rc.Distributor__c;
                   if(!mapDist.containskey(dst.Id)){
                       mapDist.put(dst.id,dst); 
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
        
        if(wrapper.isInternal){
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
            wrapper.LoggedInUserProfile = LoggedInUserProfile;
            wrapper.startDate = string.valueOf(startDate);
            wrapper.endDate = string.valueOf(endDate);
        }else{
            wrapper.liRebateContracts = liRebateConts; 
        }
        system.debug('wrapper'+wrapper);
        return wrapper;
    }
    /******************************************************************************************************
    * @Description        : Function to get Picklist Values                     
    * @Params             : String => sObject, String fieldName
    * @Return             : list<String>                                                                         
    *******************************************************************************************************/
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
        values.sort();
        return values;
    }
    /******************************************************************************************************
    * @Description        : Function to get ContractData                    
    * @Return             : rebateContractWrapper                                                                         
    *******************************************************************************************************/
    @AuraEnabled(cacheable=true)
    public static rebateContractWrapper getContractData(
        string startDatestring, 
        string enddatestring,
        string directorsId,
        string buId,
        string regionalId,
        string ctcId,
        string distributorId,
        string typeStr,
        string classificationStr,
        string statusStr,
        Decimal pageNumber, 
        Decimal pageSize){
        Date startDate = Date.valueOf(startDatestring);
        Date endDate = Date.valueOf(enddatestring);
        Integer pSize;
        if(pageSize!=null && pageSize!=0.0){
            pSize = (Integer)pageSize;    
        }else{
            pSize=10;  
        } 
        Integer pNumber = (Integer)pageNumber;
        Integer offset = (pNumber - 1) * pSize;
        string LoggedInUserProfile ;
        string UserId = UserInfo.getUserId().substring(0,15);
        user  u = [select Contact.accountId,IsPortalEnabled, profile.Name from user where id = :UserId][0];
        Id accId = u.Contact.accountId;
        LoggedInUserProfile = u.profile.Name;
        String countQuery= 'Select Count() from rebate_Contract__c';
        String query = 'SELECT Id,Type_Code__c,Distributor_Accepted__c,Distributor_Acceptance_Date__c,Distributor_Reviewer__r.name,Growth_Rate__c,Distributor__r.SAP_Code__c,Territory__r.SBU__r.name,Territory__r.SBU__r.Brazil_SBU_Name__c,Territory__r.Zone__r.name,Territory__r.Zone__c,Territory__r.SBU__c,Total_Type_Value__c,Total_Value_LY__c,Total_Value__c,Total_Other_Value_LY__c,Total_Other_Value__c,Total_Type_Value_LY__c,Territory__r.TerritoryManager__c,Contract_Date__c,CurrencyIsoCode,Sales_Rep__c,Name,Territory__r.region__c,Territory__r.region__r.name, Start_Date__c,Distributor__r.name,Region__r.name, End_Date__c, Combination_Key__c, Sales_Org__c, Distributor__c, Territory__c, Region__c, Category_Name__c, Status__c, Type__c, Workflow_Status__c, Last_Invoice_Date__c, Growth_Index__c, CRM_Status__c, Territory_Manager__c, Regional_Manager__c, Zonal_Manager__c, SBU_Head__c, Marketing_Director__c FROM Rebate_Contract__c';
        String filter ='';
        if(accId != null){
            filter += ' where Distributor__c =: accId ';
        }else{
            filter += ' where Contract_Date__c >=: startDate and Contract_Date__c <=: endDate';
        }
        if (!string.IsBlank(directorsId)) {
            if(directorsId != 'All'){
                filter += filter.contains('where') ? ' and' : ' where';
                filter += ' Territory__r.SBU__c =:directorsId';
            }
        } 
        if (!string.IsBlank(buId)) {
            if(buId != 'All'){
                filter += filter.contains('where') ? ' and' : ' where';
                filter += ' Territory__r.Zone__c =:buId';
            }
        } 
        if (!string.IsBlank(regionalId)) {
            if(regionalId != 'All'){
                filter += filter.contains('where') ? ' and' : ' where';
                filter += ' Territory__r.region__c =:regionalId';
            }
        } 
        if (!string.IsBlank(ctcId)) {
            if(ctcId != 'All'){
                filter += filter.contains('where') ? ' and' : ' where';
                filter += ' Territory__r.TerritoryManager__c =:ctcId';
            }
        } 
        if (!string.IsBlank(distributorId)) {
            if(distributorId != 'All'){
                filter += filter.contains('where') ? ' and' : ' where';
                filter += ' Distributor__c =:distributorId';
            }
        } 
        if (!string.IsBlank(typeStr)) {
            if(typeStr != 'All'){
                filter += filter.contains('where') ? ' and' : ' where';
                filter += ' Type__c =:typeStr';
            }
        } 
        if (!string.IsBlank(classificationStr)) {
            if(classificationStr != 'All'){
                filter += filter.contains('where') ? ' and' : ' where';
                filter += ' Category_Name__c like \'%' +classificationStr+ '%\'';
            }
        } 
        if (!string.IsBlank(statusStr)) {
            if(statusStr != 'All'){
                filter += filter.contains('where') ? ' and' : ' where';
                filter += ' Workflow_Status__c like \'%' +statusStr+ '%\'';
            }
        } 
        query += filter;
        countQuery += filter;
        query += ' LIMIT :pSize OFFSET :offset';
        System.debug('Query====>'+query);
        list<rebate_Contract__c> liRebateContract = Database.query(query);  
        Integer totalRecords =Database.countQuery(countQuery);
        rebateContractWrapper wrapper = new rebateContractWrapper();
        Integer recordEnd = pSize * pNumber;
        wrapper.pageSize = pSize;
        wrapper.pageNumber = pNumber;
        wrapper.recordStart = offset + 1;
        wrapper.totalRecords = totalRecords;
        wrapper.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        list<rebateContract> liRebateConts = new list<rebateContract>(); //Territory__r.region__c,Territory__r.region__r.name, 
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
            if(rc.Start_Date__c != null){
                rCont.Initial_date =  String.valueOf(rc.Start_Date__c);
            }
            if(rc.End_Date__c != null){
                rCont.Final_date = String.valueOf(rc.End_Date__c);
            }
            if(rc.Contract_Date__c != null){
                rCont.Contract_date = grz_SapIntegration.FormattedDateBrazil(rc.Contract_Date__c);
            }
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
            //if(rc.Type_Code__c == 'L' ||  rc.Workflow_Status__c != 'Em Acompanhamento'){ //rc.CRM_Status__c != 'Approved' ||
            if(rc.Type_Code__c == 'L' || rc.CRM_Status__c != 'Approved' ){ //|| rc.Workflow_Status__c == 'Em Acompanhamento'
                rCont.isActive = true;  
                //rCont.isActive = false;   
            }
            else{
                rCont.isActive = false;
                //rCont.isActive = true; 
            }
            
            rCont.DistAccepted = rc.Distributor_Accepted__c;
            rCont.DistAccDate = string.valueOf(rc.Distributor_Acceptance_Date__c);
            rCont.DistReviewName = rc.Distributor_Reviewer__r.name;
            liRebateConts.add(rCont);
        }
        wrapper.liRebateContracts = liRebateConts; 
        wrapper.LoggedInUserProfile = LoggedInUserProfile;
        system.debug('wrapper'+wrapper);
        return wrapper;
    }
    /******************************************************************************************************
    * @Description        : Function to get ContractDetails    
    * @Params             : String => urlapex               
    * @Return             : rebateContractWrapper                                                                         
    *******************************************************************************************************/
    @AuraEnabled(cacheable=true)
    public static rebateContractWrapper getContractDetails(String urlapex){
        Id id = UserInfo.getUserId(); // getting current user info
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name,Account.Customer_Group__c FROM User where Id =: id];
        String accountId = user[0].AccountId;
        String groupCstr = user[0].Account.Customer_Group__c;
        Set<Id> accIds = new Set<Id>();
            if(!String.isEmpty(groupCstr)){
                for(Account ac : [SELECT Id FROM Account where Customer_Group__c =:groupCstr AND (ParentId =:accountId OR Sub_Parent_Account__c =: accountId)]){
                    accIds.add(ac.Id);
                }
            }
        accIds.add(accountId);
        String query = 'SELECT Id,(SELECT Id, Actual_Value__c,Actual_Volume__c,Attainment_Volume__c,Brand_Name__c,Product_Category__c ,Name,Net_Value__c,Net_Volume__c,Returns_Value__c,Returns_Volume__c,Total_Actual_Value__c,Total_Returns_Value__c,Value_LY__c,Value__c,Volume_LY__c,Volume__c FROM Rebate_Goal_Brand__r),Attainment__c,Goal_Value__c,Actual_Value__c,Actual_Value_LY__c,Net_Actual_Value__c,Net_Returns_Value__c,Deviation__c,Growth__c,Type_Code__c,Distributor_Accepted__c,Distributor_Acceptance_Date__c,Distributor_Reviewer__r.name,Growth_Rate__c,Distributor__r.SAP_Code__c,Territory__r.SBU__r.name,Territory__r.SBU__r.Brazil_SBU_Name__c,Territory__r.Zone__r.name,Territory__r.Zone__c,Territory__r.SBU__c,Total_Type_Value__c,Total_Value_LY__c,Total_Value__c,Total_Other_Value_LY__c,Total_Other_Value__c,Total_Type_Value_LY__c,Territory__r.TerritoryManager__c,Contract_Date__c,CurrencyIsoCode,Sales_Rep__c,Name,Territory__r.region__c,Territory__r.region__r.name, Start_Date__c,Distributor__r.name,Region__r.name, End_Date__c, Combination_Key__c, Sales_Org__c, Distributor__c, Territory__c, Region__c, Category_Name__c, Status__c, Type__c, Workflow_Status__c, Last_Invoice_Date__c, Growth_Index__c, CRM_Status__c, Territory_Manager__c, Regional_Manager__c, Zonal_Manager__c, SBU_Head__c, Marketing_Director__c FROM Rebate_Contract__c';
        query += ' where Id =: urlapex ';
        if(!String.isEmpty(accountId)) {
            if(!query.contains('where')){
                query +=  ' where Distributor__c IN: accIds';
            }else{
                query += ' and Distributor__c IN: accIds';
            }     
        }
        list<rebate_Contract__c> liRebateContract = Database.query(query);
        list<Rebate_Goal_Brand__c> rebBrand = new list<Rebate_Goal_Brand__c>();
        list<rebateContract> liRebateConts = new list<rebateContract>(); 
        rebateContractWrapper wrapper = new rebateContractWrapper();
        for(rebate_Contract__c rc: liRebateContract){
            rebBrand.addAll(rc.Rebate_Goal_Brand__r);
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
            if(rc.Start_Date__c != null){
                rCont.Initial_date =  String.valueOf(rc.Start_Date__c);
            }
            if(rc.End_Date__c != null){
                rCont.Final_date = String.valueOf(rc.End_Date__c);
            }
            if(rc.Contract_Date__c != null){
                rCont.Contract_date = grz_SapIntegration.FormattedDateBrazil(rc.Contract_Date__c);
            }
            rCont.pStatus = rc.Status__c;
            rCont.curr = rc.CurrencyIsoCode;
            rCont.ContractId = rc.Id;
            rCont.TerritoryId = rc.Territory__c;
            rCont.ContractTypeCode = rc.Type_Code__c;
            //if(rc.Type_Code__c == 'L' ||  rc.Workflow_Status__c != 'Em Acompanhamento'){ //rc.CRM_Status__c != 'Approved' ||
            if(rc.Type_Code__c == 'L' || rc.CRM_Status__c != 'Approved' ){ //|| rc.Workflow_Status__c == 'Em Acompanhamento'
                rCont.isActive = true;  
                //rCont.isActive = false;   
            }
            else{
                rCont.isActive = false;
                //rCont.isActive = true; 
            }
            
            rCont.DistAccepted = rc.Distributor_Accepted__c;
            rCont.DistAccDate = string.valueOf(rc.Distributor_Acceptance_Date__c);
            rCont.DistReviewName = rc.Distributor_Reviewer__r.name;

            if(rc.Goal_Value__c != null){
                rCont.GoalsL = rc.Goal_Value__c.setScale(0);
            }
            if(rc.Actual_Value__c != null){
                rCont.ActualL = rc.Actual_Value__c.setScale(0);
            }
            if(rc.Attainment__c != null){
                rCont.Attainment = rc.Attainment__c.setScale(0);
            }
            if(rc.Net_Actual_Value__c != null){
                rCont.Real =rc.Net_Actual_Value__c.setScale(0) ;
            }
            if(rc.Net_Returns_Value__c != null){
                rCont.Returns =rc.Net_Returns_Value__c.setScale(0) ;
            }
            if(rc.Deviation__c != null){
                rCont.PercntReturns =rc.Deviation__c;
            }
            if(rc.Actual_Value__c != null){
                rCont.Actual_RL = rc.Actual_Value__c.setScale(0);
            }
            if(rc.Actual_Value_LY__c != null){
                rCont.Actual_RR = rc.Actual_Value_LY__c.setScale(0);
            }
            if(rc.Growth__c != null){
                rCont.Growth = rc.Growth__c.setScale(0);
            }
            liRebateConts.add(rCont);
        }
        OtherProduct Op = new OtherProduct();
        Op.Goals_Volume = 0;
        Op.Goals_Value = 0;
        Op.Real_Volume = 0;
        Op.Real_Value = 0;
        op.Returns_Volume = 0;
        Op.Returns_Value = 0;
        Map <String,List<Rebate_Goal_Brand__c>> mapCategory = new Map <String,List<Rebate_Goal_Brand__c>>();
        for(Rebate_Goal_Brand__c rB: rebBrand){
            if(rB.Product_Category__c !='outros'){
                if (!mapCategory.containsKey(rB.Product_Category__c)){
                    mapCategory.put(rB.Product_Category__c, new List<Rebate_Goal_Brand__c>{rB});
                } else{
                    List<Rebate_Goal_Brand__c> tempList = mapCategory.get(rB.Product_Category__c);
                    tempList.add(rB);
                    mapCategory.put(rB.Product_Category__c, tempList);
                }
            }else if(rB.Product_Category__c == 'outros'){
                Op.Goals_Volume += rB.Volume__c;
                Op.Goals_Value +=rB.Value__c ;
                Op.Real_Volume +=rB.Actual_Volume__c ;
                Op.Real_Value += rB.Actual_Value__c; 
                op.Returns_Volume +=rB.Returns_Volume__c ;
                Op.Returns_Value += rB.Returns_Value__c; 
            }
        }
        List<rebateContractWrapper> prodList = new List<rebateContractWrapper>();
        for(String prod : mapCategory.keySet()){
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
            rebateContractWrapper Parent = new rebateContractWrapper();
            List<rebateContractWrapper> childlist   = new List<rebateContractWrapper>();
            Parent.productName = prod;
            for(Rebate_Goal_Brand__c rB: mapCategory.get(prod)){
                rebateContractWrapper childitem = new rebateContractWrapper();
                childitem.brandName = rB.Brand_Name__c;
                childitem.Goals_Volume = (rB.Volume__c).setScale(0);
                childitem.Goals_Value = (rB.Value__c).setScale(0);
                childitem.Real_Volume = (rB.Actual_Volume__c).setScale(0);
                childitem.Real_Value = (rB.Actual_Value__c).setScale(0);
                childitem.Returns_Volume = (rB.Returns_Volume__c).setScale(0);
                childitem.Returns_Value = (rB.Returns_Value__c).setScale(0);
                childitem.Reach_Volume_Percnt = rB.Attainment_Volume__c;
                childitem.Reach_Real_Volume = (rB.Net_Volume__c).setScale(0);
                childitem.Reach_Real_Value = (rB.Net_Value__c).setScale(0);

                TotalPPCal.Goals_Volume += rB.Volume__c;
                TotalPPCal.Goals_Value +=rb.Value__c;
                TotalPPCal.Real_Volume += rB.Actual_Volume__c;
                TotalPPCal.Real_Value += rB.Actual_Value__c;
                TotalPPCal.Returns_Volume += rB.Returns_Volume__c;
                TotalPPCal.Returns_Value += rB.Returns_Value__c;
                TotalPPCal.Reach_Volume_Percnt +=rB.Attainment_Volume__c;
                TotalPPCal.Reach_Real_Volume += rB.Net_Volume__c;
                TotalPPCal.Reach_Real_Value += rB.Net_Value__c;

                childlist.add(childitem);
            }
            Parent.children = childlist;
            Parent.TGoals_Volume = (TotalPPCal.Goals_Volume).setScale(0);
            Parent.TGoals_Value = (TotalPPCal.Goals_Value).setScale(0);
            Parent.TReal_Volume = (TotalPPCal.Real_Volume).setScale(0);
            Parent.TReal_Value = (TotalPPCal.Real_Value).setScale(0);
            Parent.TReturns_Volume = (TotalPPCal.Returns_Volume).setScale(0);
            Parent.TReturns_Value = (TotalPPCal.Returns_Value).setScale(0);
            Parent.TReach_Volume_Percnt = (TotalPPCal.Reach_Volume_Percnt).setScale(0);
            Parent.TReach_Real_Volume = (TotalPPCal.Reach_Real_Volume).setScale(0);
            Parent.TReach_Real_Value = (TotalPPCal.Reach_Real_Value).setScale(0);
            prodList.add(Parent);
        }
        Decimal DcGoals_Volume = 0;
        Decimal DcGoals_Value = 0;
        Decimal DcReal_Volume = 0;
        Decimal DcReal_Value = 0;
        Decimal DcReturns_Volume = 0;
        Decimal DcReturns_Value = 0;

        for(rebateContractWrapper rc : prodList){
            DcGoals_Volume += rc.TGoals_Volume;
            DcGoals_Value +=rc.TGoals_Value;
            DcReal_Volume += rc.TReal_Volume;
            DcReal_Value += rc.TReal_Value;
            DcReturns_Volume += rc.TReturns_Volume;
            DcReturns_Value += rc.TReturns_Value;
        }
        Total TotalProduct = new Total();
        TotalProduct.Goals_Volume = (op.Goals_Volume + DcGoals_Volume).setScale(0);
        TotalProduct.Goals_Value = (op.Goals_Value + DcGoals_Value).setScale(0);
        TotalProduct.Real_Volume = (op.Real_Volume + DcReal_Volume).setScale(0);
        TotalProduct.Real_Value = (op.Real_Value + DcReal_Value).setScale(0);
        TotalProduct.Returns_Volume = (op.Returns_Volume + DcReturns_Volume).setScale(0);
        TotalProduct.Returns_Value = (op.Returns_Value + DcReturns_Value).setScale(0);

        wrapper.liRebateContracts = liRebateConts; // Rebate Contract Detail Data
        wrapper.prodData = prodList; //Product Full Data
        wrapper.OtherProductCal = Op; // Other Order
        wrapper.TotalCal = TotalProduct; // Final Total
        return wrapper;
    }
    /******************************************************************************************************
    * @Description        : Wrapper Class              
    * @Return             : rebateContractWrapper                                                                         
    *******************************************************************************************************/
    public class rebateContractWrapper{
        @AuraEnabled public Boolean isInternal {get;set;}
        @AuraEnabled public Integer pageSize {get;set;}
        @AuraEnabled public Integer pageNumber {get;set;}
        @AuraEnabled public Integer totalRecords {get;set;}
        @AuraEnabled public Integer recordStart {get;set;}
        @AuraEnabled public Integer recordEnd {get;set;}
        @AuraEnabled public List<rebateContract> liRebateContracts {get;set;}
        @AuraEnabled public list<distributor> liDistributor {get;set;}
        @AuraEnabled public list<Director> liDirector {get;set;}
        @AuraEnabled public List<salesRep> liSalesRep {get;set;}
        @AuraEnabled public list<region> liRegion {get;set;}
        @AuraEnabled public list<BU> liBU {get;set;}
        @AuraEnabled public List<string> liWFStatus {get;set;}
        @AuraEnabled public List<string> liCategory {get;set;}
        @AuraEnabled public List<string> liType {get;set;}
        @AuraEnabled public string UserType {get;set;}
        @AuraEnabled public string DistributorCode {get;set;}
        @AuraEnabled public string SalesRepCode {get;set;}
        @AuraEnabled public string RegionCode {get;set;}
        @AuraEnabled public string ZonalCode {get;set;}
        @AuraEnabled public string SBUCode {get;set;}
        @AuraEnabled public string startDate {get;set;}
        @AuraEnabled public string endDate {get;set;}
        @AuraEnabled public string status {get;set;}
        @AuraEnabled public string messsage {get;set;}
        @AuraEnabled public string LoggedInUserProfile {get;set;}

        @AuraEnabled public OtherProduct OtherProductCal {get;set;}
        @AuraEnabled public Total TotalCal {get;set;}

        @AuraEnabled public String productName {get;set;}

        @AuraEnabled public List<rebateContractWrapper> children {get;set;}
        @AuraEnabled public List<rebateContractWrapper> prodData {get;set;}

        @AuraEnabled public decimal Goals_Volume {get;set;}        
        @AuraEnabled public decimal Goals_Value {get;set;}
        @AuraEnabled public decimal Real_Volume {get;set;}
        @AuraEnabled public decimal Real_Value {get;set;}
        @AuraEnabled public decimal Returns_Volume {get;set;}
        @AuraEnabled public decimal Returns_Value {get;set;}
        @AuraEnabled public decimal Reach_Volume_Percnt {get;set;}
        @AuraEnabled public decimal Reach_Real_Volume  {get;set;}
        @AuraEnabled public decimal Reach_Real_Value  {get;set;}
        @AuraEnabled public String brandName  {get;set;}

        @AuraEnabled public decimal TGoals_Volume {get;set;}        
        @AuraEnabled public decimal TGoals_Value {get;set;}
        @AuraEnabled public decimal TReal_Volume {get;set;}
        @AuraEnabled public decimal TReal_Value {get;set;}
        @AuraEnabled public decimal TReturns_Volume {get;set;}
        @AuraEnabled public decimal TReturns_Value {get;set;}
        @AuraEnabled public decimal TReach_Volume_Percnt {get;set;}
        @AuraEnabled public decimal TReach_Real_Volume  {get;set;}
        @AuraEnabled public decimal TReach_Real_Value  {get;set;}
    }
    public class OtherProduct { 
        @AuraEnabled public decimal Goals_Volume {get;set;}        
        @AuraEnabled public decimal Goals_Value {get;set;}
        @AuraEnabled public decimal Real_Volume {get;set;}
        @AuraEnabled public decimal Real_Value {get;set;}
        @AuraEnabled public decimal Returns_Volume {get;set;}
        @AuraEnabled public decimal Returns_Value {get;set;}  
    }
    public class TotalPamProduct {
        @AuraEnabled public decimal Goals_Volume {get;set;}        
        @AuraEnabled public decimal Goals_Value {get;set;}
        @AuraEnabled public decimal Real_Volume {get;set;}
        @AuraEnabled public decimal Real_Value {get;set;}
        @AuraEnabled public decimal Returns_Volume {get;set;}
        @AuraEnabled public decimal Returns_Value {get;set;}
        @AuraEnabled public decimal Reach_Volume_Percnt {get;set;}
        @AuraEnabled public decimal Reach_Real_Volume  {get;set;}
        @AuraEnabled public decimal Reach_Real_Value  {get;set;}
        
    }
    public class Total {
        @AuraEnabled public decimal Goals_Volume {get;set;}        
        @AuraEnabled public decimal Goals_Value {get;set;}
        @AuraEnabled public decimal Real_Volume {get;set;}
        @AuraEnabled public decimal Real_Value {get;set;}
        @AuraEnabled public decimal Returns_Volume {get;set;}
        @AuraEnabled public decimal Returns_Value {get;set;}  
    }
    
    public class rebateContract {
        @AuraEnabled public string Contract {get;set;}
        @AuraEnabled public string Distributor {get;set;}
        @AuraEnabled public string DistributorId {get;set;}
        @AuraEnabled public string DistributorCode {get;set;}
        @AuraEnabled public string DistributorCodeAndName {get;set;}
        @AuraEnabled public string Director {get;set;}
        @AuraEnabled public string DirectorId {get;set;}
        @AuraEnabled public string BU {get;set;}
        @AuraEnabled public string BUId {get;set;}
        @AuraEnabled public string color {get;set;}
        @AuraEnabled public string element {get;set;}
        @AuraEnabled public string Status {get;set;}
        @AuraEnabled public string CRMStatus {get;set;}
        @AuraEnabled public string Type {get;set;}
        @AuraEnabled public string Branch {get;set;}
        @AuraEnabled public string BranchId {get;set;}
        @AuraEnabled public string CTC {get;set;}
        @AuraEnabled public string Initial_date {get;set;}
        @AuraEnabled public string Final_date {get;set;}
        @AuraEnabled public string Contract_date {get;set;}
        @AuraEnabled public string salesRep {get;set;}
        @AuraEnabled public string Category_Name {get;set;}
        @AuraEnabled public string curr {get;set;}
        @AuraEnabled public string ContractId {get;set;}
        @AuraEnabled public string pStatus {get;set;}
        @AuraEnabled public decimal TotalTypeValue {get;set;}
        @AuraEnabled public decimal TotalTypeValueLY {get;set;}
        @AuraEnabled public decimal TotalOtherValue {get;set;}
        @AuraEnabled public decimal TotalOtherValueLY {get;set;}
        @AuraEnabled public decimal TotalValue {get;set;}
        @AuraEnabled public decimal TotalValueLY {get;set;}
        @AuraEnabled public decimal GrowthIndex {get;set;}
        @AuraEnabled public decimal GrowthRate {get;set;}
        @AuraEnabled public string TerritoryId {get;set;}
        @AuraEnabled public string ContractTypeCode {get;set;}
        @AuraEnabled public boolean isActive {get;set;}
        @AuraEnabled public boolean DistAccepted {get;set;}
        @AuraEnabled public string DistAccDate {get;set;}
        @AuraEnabled public string DistReviewName {get;set;}
        @AuraEnabled public Decimal GoalsL {get;set;}
        @AuraEnabled public Decimal ActualL {get;set;}
        @AuraEnabled public Decimal Attainment {get;set;}
        @AuraEnabled public Decimal Real {get;set;}
        @AuraEnabled public Decimal Returns {get;set;}
        @AuraEnabled public Decimal PercntReturns {get;set;}
        @AuraEnabled public Decimal Actual_RL {get;set;}
        @AuraEnabled public Decimal Actual_RR {get;set;}
        @AuraEnabled public Decimal Growth {get;set;}
    }
    
    public class distributor{
        @AuraEnabled public string name {get;set;}
        @AuraEnabled public string Id {get;set;}
        
        @AuraEnabled public string customerCode {get;set;}
    }
    
    public class salesRep{
        @AuraEnabled public string name {get;set;}
        @AuraEnabled public string Id {get;set;}
    }
    
    public class region{
        @AuraEnabled public string name {get;set;}
        @AuraEnabled public string Id {get;set;}
    }
    
    public class Director{
        @AuraEnabled public string name {get;set;}
        @AuraEnabled public string Id {get;set;}
    }
    
    public class BU{
        @AuraEnabled public string name {get;set;}
        @AuraEnabled public string Id {get;set;}
    }    

}