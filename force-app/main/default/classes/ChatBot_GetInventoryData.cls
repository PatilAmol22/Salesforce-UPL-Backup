public class ChatBot_GetInventoryData {
public class PrechatOutput{
    	@InvocableVariable
        public List<String> listOfBrand = new list<string>();
    	@InvocableVariable
    	public boolean isError = false;
    	 
    }
    public class PrechatInput{
        @InvocableVariable
        public String sBrandName;
        @InvocableVariable
        public  string chatkey;
        @InvocableVariable
        public Bot_GetSnapInsPreChatData.DepotInformation tmDepoMapRec;
        
    }
    
    
    @InvocableMethod(label='Get Brand Data')
    public static List<PrechatOutput> getBrandData(List<PrechatInput> inputParameters){
        
        List<PrechatOutput> po=new List<PrechatOutput>();
        PrechatOutput prechatobject=new PrechatOutput();
        //String BrandName=inputParameters[0].sBrandName;
        //TM_Depot_Mapping__c tmDepoName=inputParameters[0].tmDepoMapRec;
                //system.debug('BrandName'+BrandName);
        		//system.debug('Depot code'+tmDepoName.Depot_Code__c);
        String BrandName='';
         Bot_GetSnapInsPreChatData.DepotInformation tmDepoName=new  Bot_GetSnapInsPreChatData.DepotInformation();
         BrandName=inputParameters[0].sBrandName;
         tmDepoName=( Bot_GetSnapInsPreChatData.DepotInformation)inputParameters[0].tmDepoMapRec;
         system.debug('BrandName'+BrandName);
         String sChatKey = inputParameters[0].chatkey;
        String userId ='';
        string countryName='';
            if (sChatKey != null && sChatKey != ''){
            List<LiveChatTranscript> transcripts = [SELECT Id, CaseId,
                                                    ContactId, Username__c,Loggedin_User__c,Loggedin_User__r.username,Loggedin_User__r.name,Loggedin_User__r.Country,FirstName__c,Loggedin_User__r.Show_Inventory__c 
                                                    FROM LiveChatTranscript WHERE ChatKey = :sChatKey limit 1];
            system.debug('transcripts>>--->'+transcripts);
           // InsertPost ip = new InsertPost('1');
       //  ip.geUsertaccount(transcripts[0].Loggedin_User__r.username);
            
            if (transcripts.size()>0){
                userId = transcripts[0].Loggedin_User__c;
                countryName =  transcripts[0].Loggedin_User__r.Country.toLowerCase();
            }
        }
           List<TM_Depot_Mapping__c> tmDepoMapList=new List<TM_Depot_Mapping__c>();
        Map<string,Zone_Depot_Mapping__c> mapoffinalZmDepoMap=new map<String,Zone_Depot_Mapping__c>();
        List<Zone_Depot_Mapping__c> zmDepoMapList=new list<Zone_Depot_Mapping__c>();
        List<Zone_Depot_Mapping__c> rmDepoMapList=new list<Zone_Depot_Mapping__c>();
        List<Zone_Depot_Mapping__c> sbuDepoMapList=new list<Zone_Depot_Mapping__c>();
        //List<UserDepotWrapper> udwList=new List<UserDepotWrapper>();
        List<Zone_Depot_Mapping__c> indonesiaDepoList=new List<Zone_Depot_Mapping__c>();
        List<Zone_Depot_Mapping__c> australiaDepoList=new List<Zone_Depot_Mapping__c>();
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
        
         Boolean isTM=false;
      Boolean isZM=false;
      Boolean isRMSwal=false;
      Boolean isTMSwal=false;
      Boolean isZMSwal=false;
      Boolean isSBU=false;
      
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
      }
            if(isTM){
                 tmDepoMapList=[SELECT Id, Depot__c, Territory_Manager__c, Depot_Name__c,Depot_Code__c FROM TM_Depot_Mapping__c Where Territory_Manager__c =: tmtdList[0].TerritoryManager__c ];
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
              }
         if(isZM==true){
          zmDepoMapList=[SELECT Id, Depot__c, SBU__c, Zone__c, Sales_Org__c, Name,Depot_Code__c,Depot_Name__c,Depot__r.Depot_Code__c,Depot__r.Name FROM Zone_Depot_Mapping__c Where Zone__c =: zmtdList[0].Zone__c];
              for(Zone_Depot_Mapping__c zdm :zmDepoMapList){
                  mapoffinalZmDepoMap.put(zdm.Depot_Name__c,zdm);
              }
          }    
            
             if(sbutdList.size()>0){
              isSBU=true;
          
          }
          
          if(isSBU==true){
              zmDepoMapList=[SELECT Id, Depot__c, SBU__c, Zone__c, Sales_Org__c,Depot_Code__c,Depot_Name__c, Name,Depot__r.Depot_Code__c,Depot__r.Name FROM Zone_Depot_Mapping__c Where SBU__c =:sbutdList[0].SBU__c];
                for( Zone_Depot_Mapping__c zdm :zmDepoMapList){
                  mapoffinalZmDepoMap.put(zdm.Depot_Name__c,zdm);
              }
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
         
        }
        if(isZMSwal==true){
          zmDepoMapList=[SELECT Id, Depot__c, SBU__c, Zone__c, Sales_Org__c,Depot_Code__c,Depot_Name__c, Name,Depot__r.Depot_Code__c,Depot__r.Name FROM Zone_Depot_Mapping__c Where Zone__c =: zmtdListSwal[0].Zone__c];
            for( Zone_Depot_Mapping__c zdm :zmDepoMapList){
                  mapoffinalZmDepoMap.put(zdm.Depot_Name__c,zdm);
              }
        }
        if(rmtdListSwal.size()>0){
          isRMSwal=true;
          
        }
          if(isRMSwal ==true){
              
              zmDepoMapList =[SELECT Id, Depot__c, SBU__c, Zone__c, Sales_Org__c,Depot_Code__c,Depot_Name__c,Region__c, Name,Depot__r.Depot_Code__c,Depot__r.Name FROM Zone_Depot_Mapping__c Where Region__c =: rmtdListSwal[0].Region__c];
              for( Zone_Depot_Mapping__c zdm :zmDepoMapList){
                  mapoffinalZmDepoMap.put(zdm.Depot_Name__c,zdm);
              }
          }
         if(isTMSwal==true){
          tmDepoMapList=[SELECT Id, Depot__c, Territory_Manager__c, Depot_Name__c,Depot_Code__c  FROM TM_Depot_Mapping__c Where Territory_Manager__c =: tmtdListSwal[0].TerritoryManager__c ];
          
        }
      }
      
      If(countryName == 'australia'){
          //isZM = true;
            zmDepoMapList=[SELECT Id, Name, Depot__c, SBU__c, Zone__c,Depot_Code__c,Depot_Name__c, Sales_Org__c FROM Zone_Depot_Mapping__c Where Sales_Org__r.Sales_Org_Code__c='6100' ];
      		  for( Zone_Depot_Mapping__c zdm :zmDepoMapList){
                  mapoffinalZmDepoMap.put(zdm.Depot_Name__c,zdm);
              }
      }
      
      //Divya: 04/06/2021: Added for SCTASK0433277
      If(countryName == 'New Zealand'){
            zmDepoMapList=[SELECT Id, Name, Depot__c, SBU__c, Zone__c,Depot_Code__c,Depot_Name__c, Sales_Org__c FROM Zone_Depot_Mapping__c Where Sales_Org__r.Sales_Org_Code__c='6061' ];
      		  for( Zone_Depot_Mapping__c zdm :zmDepoMapList){
                  mapoffinalZmDepoMap.put(zdm.Depot_Name__c,zdm);
              }
      } //End
      
      If(countryName == 'indonesia'){
          zmDepoMapList=[SELECT Id, Name, Depot__c, SBU__c, Zone__c,Depot_Code__c,Depot_Name__c, Sales_Org__c FROM Zone_Depot_Mapping__c Where Sales_Org__r.Sales_Org_Code__c='6410'];
     	   for( Zone_Depot_Mapping__c zdm :zmDepoMapList){
                  mapoffinalZmDepoMap.put(zdm.Depot_Name__c,zdm);
              }
      }
      
      If(countryName == 'uk'){
           //isZM = true;
            zmDepoMapList=[SELECT Id, Name, Depot__c, SBU__c, Zone__c,Depot_Code__c,Depot_Name__c, Sales_Org__c FROM Zone_Depot_Mapping__c Where Sales_Org__r.Sales_Org_Code__c='2031'];
      		 for( Zone_Depot_Mapping__c zdm :zmDepoMapList){
                  mapoffinalZmDepoMap.put(zdm.Depot_Name__c,zdm);
              }
      }
        
      If(countryName == 'netherlands' || countryName == 'nl'){
           //isZM = true;
            zmDepoMapList=[SELECT Id, Name, Depot__c, SBU__c, Zone__c,Depot_Code__c,Depot_Name__c, Sales_Org__c FROM Zone_Depot_Mapping__c Where Sales_Org__r.Sales_Org_Code__c='2110'];
     		 for( Zone_Depot_Mapping__c zdm :zmDepoMapList){
                  mapoffinalZmDepoMap.put(zdm.Depot_Name__c,zdm);
              }
      }
        
      If(countryName == 'belgium'){
           //isZM = true;
            zmDepoMapList=[SELECT Id, Name, Depot__c, SBU__c, Zone__c,Depot_Code__c,Depot_Name__c, Sales_Org__c FROM Zone_Depot_Mapping__c Where Sales_Org__r.Sales_Org_Code__c='2120'];
      		 for( Zone_Depot_Mapping__c zdm :zmDepoMapList){
                  mapoffinalZmDepoMap.put(zdm.Depot_Name__c,zdm);
              }
      }
        If(countryName == 'luxembourg'){
           //isZM = true;
            zmDepoMapList=[SELECT Id, Name, Depot__c, SBU__c, Zone__c,Depot_Code__c,Depot_Name__c, Sales_Org__c FROM Zone_Depot_Mapping__c Where Sales_Org__r.Sales_Org_Code__c='2120'];
   			 for( Zone_Depot_Mapping__c zdm :zmDepoMapList){
                  mapoffinalZmDepoMap.put(zdm.Depot_Name__c,zdm);
              }
        }
      set<string> depotset = new set<string>();
        if(mapoffinalZmDepoMap.size()> 0){
            for(string key:mapoffinalZmDepoMap.keyset()){
                depotset.add(mapoffinalZmDepoMap.get(key).Depot_Code__c);
            }
        }   
        if(tmDepoMapList.size()> 0){
            for(TM_Depot_Mapping__c tdm :tmDepoMapList){
                depotset.add(tdm.Depot_Code__c);
            }            
        }
     
        List<ZUDL_ZUIC_C03_Q001__x> listOfInventory=new List<ZUDL_ZUIC_C03_Q001__x>();
        
        map<string,ZUDL_ZUIC_C03_Q001__x> mapOfInventoryBrand = new map<string,ZUDL_ZUIC_C03_Q001__x>();
           if(tmDepoName.depotName == 'ALL'){
            listOfInventory=[SELECT Id, BRAND__c, COMP_CODE__c, PLANT_CODE__c, COMP_DESC__c, QTY__c, UOM__c, PLANT_DESC__c FROM ZUDL_ZUIC_C03_Q001__x where PLANT_CODE__c IN :depotset];
           }else{
               listOfInventory=[SELECT Id, BRAND__c, COMP_CODE__c, PLANT_CODE__c, COMP_DESC__c, QTY__c, UOM__c, PLANT_DESC__c FROM ZUDL_ZUIC_C03_Q001__x where PLANT_CODE__c=:tmDepoName.depotCode];
           }
        
        system.debug('listOfInventory'+listOfInventory.size());
        for(ZUDL_ZUIC_C03_Q001__x Inv: listOfInventory){
            if(Inv.BRAND__c.containsIgnoreCase(BrandName)){
                //prechatobject.listOfBrand.add(inv.BRAND__c);
                if(tmDepoName.depotName == 'ALL'){
                    mapOfInventoryBrand.put(Inv.BRAND__c+'ALL',inv);
                }else{
                	mapOfInventoryBrand.put(Inv.BRAND__c+Inv.PLANT_CODE__c,inv);    
                }
                
                
            }
        }
        if(mapOfInventoryBrand.size()>0){
        	for(ZUDL_ZUIC_C03_Q001__x exobj: mapOfInventoryBrand.values()){
                  if(tmDepoName.depotName == 'ALL'){
                  prechatobject.listOfBrand.add(exobj.BRAND__c+'-ALL');
                  }else{
                    prechatobject.listOfBrand.add(exobj.BRAND__c+'-'+exobj.PLANT_CODE__c);
                  }
             	
        	}
        }else{
            prechatobject.isError =true;
        }
        system.debug('keys>>--->'+mapOfInventoryBrand.keyset());
       // prechatobject.listOfBrand=mapOfInventoryBrand.values();
        system.debug('list of Brands >>--->'+prechatobject.listOfBrand);
        po.add(prechatobject);
        //po.listOfBrand=invWrapList;
        return po ;
       
    }
   
}