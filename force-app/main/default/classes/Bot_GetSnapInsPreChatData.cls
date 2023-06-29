public without sharing class Bot_GetSnapInsPreChatData {
    public class PrechatOutput{
        @InvocableVariable
        public String sCountryName;
        @InvocableVariable
        public String sUserRole;
        @InvocableVariable
        public String sLoggedUser;
        @InvocableVariable
        public String sLoggedUserName;
        @InvocableVariable
        public List<Bot_GetSnapInsPreChatData.DepotInformation> depoList;
        @InvocableVariable
        public List<Zone_Depot_Mapping__c> zoneDepotList;
        @InvocableVariable
        public Boolean sUserShowInventory;
         @InvocableVariable
        public String sLoggedUserId;
         
    }
    public class PrechatInput{
        @InvocableVariable
        public String sChatKey;
    }
   
     public class DepotInformation{
        public String depotName{get;set;}
        public String depotCode{get;set;}
         public DepotInformation(){
             depotName ='';
             depotCode ='';
         }
    }
    @InvocableMethod(label='Get SnapIns Prechat Data')
    public static List<PrechatOutput> getSnapInsPrechatData(List<PrechatInput> inputParameters)
    {
          
        System.debug('######## Input Parameters: '+inputParameters);
        String userId='';  
        String sChatKey = inputParameters[0].sChatKey;
        
        String sContactId = null;
        List<prechatoutput> outputParameters = new List<prechatoutput>();
        PrechatOutput outputParameter = new PrechatOutput();
        if (sChatKey != null && sChatKey != '')
        {
            List<LiveChatTranscript> transcripts = [SELECT Id, CaseId,
                                                    ContactId, Username__c,Loggedin_User__r.username,Loggedin_User__r.name,Loggedin_User__r.Country,FirstName__c,Loggedin_User__r.Show_Inventory__c 
                                                    FROM LiveChatTranscript WHERE ChatKey = :sChatKey];
            system.debug('transcripts>>--->'+transcripts);
           // InsertPost ip = new InsertPost('1');
       //  ip.geUsertaccount(transcripts[0].Loggedin_User__r.username);
            
            if (transcripts.size()>0)
            {
                outputParameter.sLoggedUser = transcripts[0].Loggedin_User__r.name;
                outputParameter.sCountryName = transcripts[0].Loggedin_User__r.Country;
                system.debug('Country Name--->'+outputParameter.sCountryName);
                outputParameter.sUserShowInventory = transcripts[0].Loggedin_User__r.Show_Inventory__c;
                userId=transcripts[0].Loggedin_User__c;
                outputParameter.sLoggedUserId = transcripts[0].Loggedin_User__c;
                outputParameter.sUserShowInventory = transcripts[0].Loggedin_User__r.Show_Inventory__c;
                outputParameter.sLoggedUserName =  transcripts[0].Loggedin_User__r.username;
            }
        }
        /*New*/
       
      String userRole='';
      Boolean isTM=false;
      Boolean isZM=false;
      Boolean isRMSwal=false;
      Boolean isTMSwal=false;
      Boolean isZMSwal=false;
      Boolean isSBU=false;
      
    //User u = [SELECT Id, LastName, FirstName, Email, Country,Show_Inventory__c,Show_Inventory_Column__c FROM User where id=:userId limit 1];
    
      List<TM_Depot_Mapping__c> tmDepoMapList=new List<TM_Depot_Mapping__c>();
        Map<string,Zone_Depot_Mapping__c> mapoffinalZmDepoMap=new map<String,Zone_Depot_Mapping__c>();
        List<Zone_Depot_Mapping__c> zmDepoMapList=new list<Zone_Depot_Mapping__c>();
        List<Zone_Depot_Mapping__c> rmDepoMapList=new list<Zone_Depot_Mapping__c>();
        List<Zone_Depot_Mapping__c> sbuDepoMapList=new list<Zone_Depot_Mapping__c>();
        //List<UserDepotWrapper> udwList=new List<UserDepotWrapper>();
        List<Zone_Depot_Mapping__c> indonesiaDepoList=new List<Zone_Depot_Mapping__c>();
        List<Zone_Depot_Mapping__c> australiaDepoList=new List<Zone_Depot_Mapping__c>();
        List<Zone_Depot_Mapping__c> newZealandDepoList=new List<Zone_Depot_Mapping__c>();
        List<Zone_Depot_Mapping__c> ukDepoList=new List<Zone_Depot_Mapping__c>();
        List<Zone_Depot_Mapping__c> netherlandsDepoList=new List<Zone_Depot_Mapping__c>();
        List<Zone_Depot_Mapping__c> belgiumDepoList=new List<Zone_Depot_Mapping__c>();
        List<Zone_Depot_Mapping__c> luxembourgDepoList=new List<Zone_Depot_Mapping__c>();
      List<Territory_Distributor__c> rmtdListSwal=new List<Territory_Distributor__c>();
      List<Territory_Distributor__c> zmtdList=new List<Territory_Distributor__c>();
      List<Territory_Distributor__c> tmtdList=new List<Territory_Distributor__c>();
      List<Territory_Distributor__c> zmtdListSwal=new List<Territory_Distributor__c>();
      List<Territory_Distributor__c> tmtdListSwal=new List<Territory_Distributor__c>();
      List<Territory_Distributor__c> sbutdList=new List<Territory_Distributor__c>();
      
      String countryName=outputParameter.sCountryName.toLowerCase();
        system.debug('country Name-->'+countryName);
        
      if(countryName == 'india' || countryName == 'in' ){
      tmtdList=[SELECT Id, Name,TerritoryManager__c,RegionalManager__c,
                               ZonalManager__c,Zonal_Manager_Id__c, SBU__c, Zone__c, SBUHead__c
                               FROM Territory_Distributor__c
                               WHERE Present_in_KEDE__c = true
                               AND Neglected__c = false
                               AND TerritoryCode__c != '#'
                               AND  TerritoryManager__c=:userId
                               AND Sales_Org_Code__c='1000' limit 1];
      
      
      if(tmtdList.size()==0){
        zmtdList=[SELECT Id, Name,TerritoryManager__c,RegionalManager__c,
                               ZonalManager__c, SBU__c,  Zone__c, SBUHead__c
                               FROM Territory_Distributor__c
                               WHERE Present_in_KEDE__c = true
                               AND Neglected__c = false
                               AND TerritoryCode__c != '#'
                               AND  Zonal_Manager_Id__c= :userId
                               AND Sales_Org_Code__c='1000' limit 1];
      }else{
          isTM=true;
          userRole='TM';
      }
      if(zmtdList.size()==0){
          sbutdList=[SELECT Id, Name,TerritoryManager__c,RegionalManager__c,
                               ZonalManager__c,Zonal_Manager_Id__c, SBU__c, Zone__c, SBUHead__c
                               FROM Territory_Distributor__c
                               WHERE Present_in_KEDE__c = true
                               AND Neglected__c = false
                               AND TerritoryCode__c != '#'
                               AND  SBU_Head_Id__c=:userId
                               AND Sales_Org_Code__c='1000' limit 1];
      }else{
          isZM=true;
          userRole='ZM';
      }
          if(isZM==true){
          zmDepoMapList=[SELECT Id, Depot__c, SBU__c, Zone__c, Sales_Org__c, Name,Depot_Code__c,Depot_Name__c,Depot__r.Depot_Code__c,Depot__r.Name FROM Zone_Depot_Mapping__c Where Zone__c =: zmtdList[0].Zone__c];
              for(Zone_Depot_Mapping__c zdm :zmDepoMapList){
                  mapoffinalZmDepoMap.put(zdm.Depot_Name__c,zdm);
              }
          }
          
      if(sbutdList.size()>0){
              isSBU=true;
            userRole='SBU';
          }
          
          if(isSBU==true){
              sbuDepoMapList=[SELECT Id, Depot__c, SBU__c, Zone__c, Sales_Org__c,Depot_Code__c,Depot_Name__c, Name,Depot__r.Depot_Code__c,Depot__r.Name FROM Zone_Depot_Mapping__c Where SBU__c =:sbutdList[0].SBU__c];
                for( Zone_Depot_Mapping__c zdm :sbuDepoMapList){
                  mapoffinalZmDepoMap.put(zdm.Depot_Name__c,zdm);
              }
          }
      
      if(isTM==true){
          tmDepoMapList=[SELECT Id, Depot__c, Territory_Manager__c, Depot_Name__c,Depot_Code__c FROM TM_Depot_Mapping__c Where Territory_Manager__c =: tmtdList[0].TerritoryManager__c ];
      }
      
     }
      
      
      If(countryName == 'swal'){
          tmtdListSwal=[SELECT Id, Name,TerritoryManager__c,RegionalManager__c,
                               ZonalManager__c,Zonal_Manager_Id__c, SBU__c, Zone__c, SBUHead__c
                               FROM Territory_Distributor__c
                               WHERE Present_in_KEDE__c = true
                               AND Neglected__c = false
                               AND TerritoryCode__c != '#'
                               AND  TerritoryManager__c=:userId
                               AND Sales_Org_Code__c='1210' limit 1];
        
          if(tmtdListSwal.size()==0){
            zmtdListSwal=[SELECT Id, Name,TerritoryManager__c,RegionalManager__c,
                               ZonalManager__c, SBU__c,  Zone__c, SBUHead__c
                               FROM Territory_Distributor__c
                               WHERE Present_in_KEDE__c = true
                               AND Neglected__c = false
                               AND TerritoryCode__c != '#'
                               AND  Zonal_Manager_Id__c=: userId
                               AND Sales_Org_Code__c='1210' limit 1];
          }else{
            isTMSwal=true;
            userRole='TM';
          }
          if(zmtdListSwal.size()==0){
            rmtdListSwal=[SELECT Id, Name,TerritoryManager__c,RegionalManager__c,Region__c,
                               ZonalManager__c, SBU__c,  Zone__c, SBUHead__c
                               FROM Territory_Distributor__c
                               WHERE Present_in_KEDE__c = true
                               AND Neglected__c = false
                               AND TerritoryCode__c != '#'
                               AND  Regional_Manager_Id__c=:userId
                               AND Sales_Org_Code__c='1210' limit 1];
        }else{
          isZMSwal=true;
            userRole='ZM';
        }
        if(isZMSwal==true){
          zmDepoMapList=[SELECT Id, Depot__c, SBU__c, Zone__c, Sales_Org__c,Depot_Code__c,Depot_Name__c, Name,Depot__r.Depot_Code__c,Depot__r.Name FROM Zone_Depot_Mapping__c Where Zone__c =: zmtdListSwal[0].Zone__c];
            for( Zone_Depot_Mapping__c zdm :zmDepoMapList){
                  mapoffinalZmDepoMap.put(zdm.Depot_Name__c,zdm);
              }
        }
        if(rmtdListSwal.size()>0){
          isRMSwal=true;
            userRole='RM';
        }
          if(isRMSwal ==true){
              
              rmDepoMapList =[SELECT Id, Depot__c, SBU__c, Zone__c, Sales_Org__c,Depot_Code__c,Depot_Name__c,Region__c, Name,Depot__r.Depot_Code__c,Depot__r.Name FROM Zone_Depot_Mapping__c Where Region__c =: rmtdListSwal[0].Region__c];
              for( Zone_Depot_Mapping__c zdm :rmDepoMapList){
                  mapoffinalZmDepoMap.put(zdm.Depot_Name__c,zdm);
              }
          }
         if(isTMSwal==true){
          tmDepoMapList=[SELECT Id, Depot__c, Territory_Manager__c, Depot_Name__c,Depot_Code__c  FROM TM_Depot_Mapping__c Where Territory_Manager__c =: tmtdListSwal[0].TerritoryManager__c ];
          
        }
      }
      
      If(countryName == 'australia'){
          //isZM = true;
            australiaDepoList=[SELECT Id, Name, Depot__c, SBU__c, Zone__c,Depot_Code__c,Depot_Name__c, Sales_Org__c FROM Zone_Depot_Mapping__c Where Sales_Org__r.Sales_Org_Code__c='6100' ];
            for( Zone_Depot_Mapping__c zdm :australiaDepoList){
                  mapoffinalZmDepoMap.put(zdm.Depot_Name__c,zdm);
              }
      }
      //Divya: 04/06/2021: Added for SCTASK0433277
      If(countryName == 'New Zealand'){
            newZealandDepoList=[SELECT Id, Name, Depot__c, SBU__c, Zone__c,Depot_Code__c,Depot_Name__c, Sales_Org__c FROM Zone_Depot_Mapping__c Where Sales_Org__r.Sales_Org_Code__c='6061' ];
            for( Zone_Depot_Mapping__c zdm :newZealandDepoList){
                  mapoffinalZmDepoMap.put(zdm.Depot_Name__c,zdm);
              }
      } //End
      
      If(countryName == 'indonesia'){
          //isZM = true;
          indonesiaDepoList=[SELECT Id, Name, Depot__c, SBU__c, Zone__c,Depot_Code__c,Depot_Name__c, Sales_Org__c FROM Zone_Depot_Mapping__c Where Sales_Org__r.Sales_Org_Code__c='6410'];
          for( Zone_Depot_Mapping__c zdm :indonesiaDepoList){
                  mapoffinalZmDepoMap.put(zdm.Depot_Name__c,zdm);
              }
      }
      
      If(countryName == 'uk'){
           //isZM = true;
            ukDepoList=[SELECT Id, Name, Depot__c, SBU__c, Zone__c,Depot_Code__c,Depot_Name__c, Sales_Org__c FROM Zone_Depot_Mapping__c Where Sales_Org__r.Sales_Org_Code__c='2031'];
           for( Zone_Depot_Mapping__c zdm :ukDepoList){
                  mapoffinalZmDepoMap.put(zdm.Depot_Name__c,zdm);
              }
      }
        
      If(countryName == 'netherlands' || countryName == 'nl'){
           //isZM = true;
            netherlandsDepoList=[SELECT Id, Name, Depot__c, SBU__c, Zone__c,Depot_Code__c,Depot_Name__c, Sales_Org__c FROM Zone_Depot_Mapping__c Where Sales_Org__r.Sales_Org_Code__c='2110'];
          for( Zone_Depot_Mapping__c zdm :netherlandsDepoList){
                  mapoffinalZmDepoMap.put(zdm.Depot_Name__c,zdm);
              }
      }
        
      If(countryName == 'belgium'){
           //isZM = true;
            belgiumDepoList=[SELECT Id, Name, Depot__c, SBU__c, Zone__c,Depot_Code__c,Depot_Name__c, Sales_Org__c FROM Zone_Depot_Mapping__c Where Sales_Org__r.Sales_Org_Code__c='2120'];
           for( Zone_Depot_Mapping__c zdm :belgiumDepoList){
                  mapoffinalZmDepoMap.put(zdm.Depot_Name__c,zdm);
              }
      }
        If(countryName == 'luxembourg'){
           //isZM = true;
            luxembourgDepoList=[SELECT Id, Name, Depot__c, SBU__c, Zone__c,Depot_Code__c,Depot_Name__c, Sales_Org__c FROM Zone_Depot_Mapping__c Where Sales_Org__r.Sales_Org_Code__c='2120'];
          for( Zone_Depot_Mapping__c zdm :luxembourgDepoList){
                  mapoffinalZmDepoMap.put(zdm.Depot_Name__c,zdm);
              }
        }
      
      
      system.debug('isTM--'+isTM);
      system.debug('isZM--'+isZM);
      system.debug('isRMSwal--'+isRMSwal);
      system.debug('tmDepoMapList--'+tmDepoMapList);
        outputParameter.depoList = new list<Bot_GetSnapInsPreChatData.DepotInformation>();
        
        if(isTM==true || isTMSwal==true){
            
            for(TM_Depot_Mapping__c tmdpMap: tmDepoMapList){
                Bot_GetSnapInsPreChatData.DepotInformation  DepotInfo = new Bot_GetSnapInsPreChatData.DepotInformation();
                DepotInfo.depotName = tmdpMap.Depot_Name__c;
                DepotInfo.depotCode = tmdpMap.Depot_Code__c;
                outputParameter.depoList.add(DepotInfo);
            }
        //outputParameter.depoList=tmDepoMapList;
        }else{
            for(Zone_Depot_Mapping__c zdm :mapoffinalZmDepoMap.values()){
                 Bot_GetSnapInsPreChatData.DepotInformation  DepotInfo = new Bot_GetSnapInsPreChatData.DepotInformation();
                DepotInfo.depotName = zdm.Depot_Name__c;
                DepotInfo.depotCode = zdm.Depot_Code__c;
                outputParameter.depoList.add(DepotInfo);
            }
        }
          Bot_GetSnapInsPreChatData.DepotInformation  DepotInfo1 = new Bot_GetSnapInsPreChatData.DepotInformation();
                DepotInfo1.depotName = 'ALL';
                DepotInfo1.depotCode = 'ALL';
         outputParameter.depoList.add(DepotInfo1);
       /* if(rmtdListSwal.size()>0){
            outputParameter.zoneDepotList=mapoffinalZmDepoMap.values(); 
        }
        if(sbuDepoMapList.size()>0){
            outputParameter.zoneDepotList=mapoffinalZmDepoMap.values();
            system.debug('outputParameter.zoneDepotList-->'+outputParameter.zoneDepotList);
            system.debug('mapoffinalZmDepoMap.values()-->'+mapoffinalZmDepoMap.values());
        }
        if(zmDepoMapList.size()>0){
            outputParameter.zoneDepotList=mapoffinalZmDepoMap.values();    
        }
        if(australiaDepoList.size()>0){
            outputParameter.zoneDepotList=australiaDepoList;    
        }
        if(indonesiaDepoList.size()>0){
            outputParameter.zoneDepotList= indonesiaDepoList;    
        }
        if(ukDepoList.size()>0){
            outputParameter.zoneDepotList=ukDepoList;    
        }
        if(netherlandsDepoList.size()>0){
            outputParameter.zoneDepotList=netherlandsDepoList;    
        }
        if(belgiumDepoList.size()>0){
            outputParameter.zoneDepotList=belgiumDepoList;    
        }
        if(luxembourgDepoList.size()>0){
            outputParameter.zoneDepotList=luxembourgDepoList;    
        }*/
        
        outputParameter.sUserRole =userRole;        
        system.debug('user role-->'+outputParameter.sUserRole);
        outputParameters.add(outputParameter);
      
      return outputParameters;
        
       
    }
    
  
}