public without sharing class ChatBot_LWCComponentController {
    
    /*@AuraEnabled(Cacheable = true)
    public static String getInputOutput(String SAPNumber){
      String SAPNumber1;
      string[] splitted = SAPNumber.split('\\-');
      system.debug('part1:: = ' + splitted[0]);   //Output: theblogreaders
      system.debug('part1:: = ' + splitted[1]);   //Output: salesforce
      SAPNumber1=splitted[1]; 
      SAPNumber1=SAPNumber1.trim();
      SAPNumber1='U'+SAPNumber1; 
      return SAPNumber1;
    }*/
    
/*For Order Status */
    @AuraEnabled(Cacheable = true)
    public static List<OrderStatusWrapper> getOrderStatus(String OrderNumber){
      Date oDate;
      List<Sales_Order__c> soList=new List<Sales_Order__c>();
      List<OrderStatusWrapper> soWrapList=new List<OrderStatusWrapper>();
      soList=[Select Id,Sold_to_Party__r.Name, Order_Date__c,SAP_Order_Number__c,SalesOrgCode__c, Order_Status__c,CurrencyIsoCode,Final_Total_Amont__c FROM Sales_Order__c WHERE SAP_Order_Number__c =: OrderNumber];
      for(Sales_Order__c so:soList){
        OrderStatusWrapper osWrap=new OrderStatusWrapper();
        Decimal Total_Sum=0.00;
        osWrap.CustomerName=so.Sold_to_Party__r.Name;
        oDate=so.Order_Date__c;
        if(so.SalesOrgCode__c == '1000' || so.SalesOrgCode__c=='1210'){
        	osWrap.OrderDate= oDate.day() + '/' + oDate.month() + '/' + oDate.year();
        }else{
            osWrap.OrderDate= oDate.month() + '/' + oDate.day() + '/' + oDate.year();
        }
        osWrap.Status=so.Order_Status__c;
        osWrap.currencyCode=so.CurrencyIsoCode;
        Total_Sum=so.Final_Total_Amont__c;
        osWrap.NetVal=(Total_Sum.format().contains('.')?Total_Sum.format():(Total_Sum.format()+'.00'));
        osWrap.OrderNumber=so.SAP_Order_Number__c;
        soWrapList.add(osWrap);
      }
      return soWrapList;
    }
    public class OrderStatusWrapper {
      @AuraEnabled public String CustomerName{get;set;}
      @AuraEnabled public String currencyCode{get;set;}
      @AuraEnabled public String Status{get;set;}
      @AuraEnabled public String OrderDate{get;set;}
      @AuraEnabled public String NetVal{get;set;}
      @AuraEnabled public String OrderNumber{get;set;}

      OrderStatusWrapper(){
        CustomerName ='';
            currencyCode='';
            Status='';
            OrderDate='';
            NetVal='';
            OrderNumber='';
              }
    }
/*For Customer Order Details */
    @AuraEnabled
    public static List<CustomerOrderDetailWrapper> getCustomerOrderDetails(String OrderNumber){
        Date oDate;
        List<Sales_Order__c> soCustList=new List<Sales_Order__c>();
        List<CustomerOrderDetailWrapper> soCustWrapList=new List<CustomerOrderDetailWrapper>();
        soCustList=[Select Id,Sold_to_Party__r.Name, Name, Order_Date__c, Order_Status__c,SAP_Order_Number__c,SalesOrgCode__c,Final_Total_Amont__c,CurrencyIsoCode FROM Sales_Order__c Where SAP_Order_Number__c=:OrderNumber];
        
        for(Sales_Order__c so:soCustList){
          CustomerOrderDetailWrapper codWrap=new CustomerOrderDetailWrapper();
          Decimal Total_Sum=0.00;
          codWrap.CustomerName=so.Sold_to_Party__r.Name;
          oDate=so.Order_Date__c;
          if(so.SalesOrgCode__c == '1000' || so.SalesOrgCode__c=='1210'){
        	codWrap.OrderDate= oDate.day() + '/' + oDate.month() + '/' + oDate.year();
          }else{
            codWrap.OrderDate= oDate.month() + '/' + oDate.day() + '/' + oDate.year();
          }
          codWrap.Status=so.Order_Status__c;
          Total_Sum=so.Final_Total_Amont__c;
          codWrap.NetVal=(Total_Sum.format().contains('.')?Total_Sum.format():(Total_Sum.format()+'.00'));
          codWrap.OrderNumber=so.SAP_Order_Number__c;
          codWrap.currencyCode=so.CurrencyIsoCode;
          soCustWrapList.add(codWrap);
        }
        return soCustWrapList;
        
    }
    public class CustomerOrderDetailWrapper {
          @AuraEnabled public String CustomerName{get;set;}
          @AuraEnabled public String OrderNumber{get;set;}
          @AuraEnabled public String NetVal{get;set;}
          @AuraEnabled public String Status{get;set;}
          @AuraEnabled public String OrderDate{get;set;}
          @AuraEnabled public String currencyCode{get;set;}
            
          CustomerOrderDetailWrapper(){
              CustomerName ='';
              currencyCode='';
              NetVal='';
              Status='';
              OrderDate='';
              OrderNumber='';
                  
          }
    }

/*For Brand details */
@AuraEnabled(Cacheable = true)
public static List<BrandDetailWrapper> getInventoryDetails(String BrandName,String ChatKey){
BrandDetailWrapper brandWrappertest = new BrandDetailWrapper();
  System.debug('Brand Name'+BrandName);
  String SessionId=ChatKey.trim();
  String userId;
  String countryName;
  Boolean showInventory;
  

  //Splitting Logic
  String BrandName1;
  String plantCode;
  string[] splitted = BrandName.split('\\-');
      system.debug('part1:: = ' + splitted[0]);   
      system.debug('part2:: = ' + splitted[1]);   
      plantCode=splitted[1]; 
      plantCode=plantCode.trim();
      BrandName1=splitted[0];
      BrandName1=BrandName1.trim();
  
  //BrandName='U'+SAPNumber1; 
  List<LiveChatTranscript> transcripts = [SELECT Id,ContactId, Username__c,Loggedin_User__r.username,Loggedin_User__r.name,Loggedin_User__r.Country,FirstName__c,Loggedin_User__r.Show_Inventory__c 
                                                  FROM LiveChatTranscript WHERE ChatKey =: SessionId];
    if (transcripts.size()>0){
              userId=transcripts[0].Loggedin_User__c;
              countryName=transcripts[0].Loggedin_User__r.Country.toLowerCase();
              showInventory=transcripts[0].Loggedin_User__r.Show_Inventory__c;
          }
   //Getting Depot For Respective User
     String userRole='';
      Boolean isTM=false;
      Boolean isZM=false;
      Boolean isRMSwal=false;
      Boolean isTMSwal=false;
      Boolean isZMSwal=false;
      Boolean isSBU=false;
    
      set<String> setOfDepotCode=new set<String>();
     List<TM_Depot_Mapping__c> tmDepoMapList=new List<TM_Depot_Mapping__c>();
      //Map<string,String> mapoffinalZmDepoMap=new map<String,String>();
      List<Zone_Depot_Mapping__c> zmDepoMapList=new list<Zone_Depot_Mapping__c>();
      List<Zone_Depot_Mapping__c> rmDepoMapList=new list<Zone_Depot_Mapping__c>();
      List<Zone_Depot_Mapping__c> sbuDepoMapList=new list<Zone_Depot_Mapping__c>();
      //List<UserDepotWrapper> udwList=new List<UserDepotWrapper>();
      List<Zone_Depot_Mapping__c> indonesiaDepoList=new List<Zone_Depot_Mapping__c>();
      List<Zone_Depot_Mapping__c> australiaDepoList=new List<Zone_Depot_Mapping__c>();
      List<Zone_Depot_Mapping__c> newZealandDepoList=new List<Zone_Depot_Mapping__c>();    //Divya: 04/06/2021: Added for SCTASK0433277
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
            
        }
        
    if(sbutdList.size()>0){
            isSBU=true;
          userRole='SBU';
        }
        
        if(isSBU==true){
            sbuDepoMapList=[SELECT Id, Depot__c, SBU__c, Zone__c, Sales_Org__c,Depot_Code__c,Depot_Name__c, Name,Depot__r.Depot_Code__c,Depot__r.Name FROM Zone_Depot_Mapping__c Where SBU__c =:sbutdList[0].SBU__c];
              
        }
    
    if(isTM==true){
        tmDepoMapList=[SELECT Id, Depot__c, Territory_Manager__c, Depot_Name__c,Depot_Code__c FROM TM_Depot_Mapping__c Where Territory_Manager__c =: tmtdList[0].TerritoryManager__c ];
    }
    }
    
    if(countryName == 'swal'){
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
          
      }
      if(rmtdListSwal.size()>0){
        isRMSwal=true;
          userRole='RM';
      }
        if(isRMSwal ==true){
            
            rmDepoMapList =[SELECT Id, Depot__c, SBU__c, Zone__c, Sales_Org__c,Depot_Code__c,Depot_Name__c,Region__c, Name,Depot__r.Depot_Code__c,Depot__r.Name FROM Zone_Depot_Mapping__c Where Region__c =: rmtdListSwal[0].Region__c];
            
        }
       if(isTMSwal==true){
        tmDepoMapList=[SELECT Id, Depot__c, Territory_Manager__c, Depot_Name__c,Depot_Code__c  FROM TM_Depot_Mapping__c Where Territory_Manager__c =: tmtdListSwal[0].TerritoryManager__c ];
      }

    }
    
    if(countryName == 'australia'){
       australiaDepoList=[SELECT Id, Name, Depot__c, SBU__c, Zone__c,Depot_Code__c,Depot_Name__c, Sales_Org__c FROM Zone_Depot_Mapping__c Where Sales_Org__r.Sales_Org_Code__c='6100'];  
    }
    
    //Divya: 04/06/2021: Added for SCTASK0433277
    if(countryName == 'New Zealand'){
       newZealandDepoList=[SELECT Id, Name, Depot__c, SBU__c, Zone__c,Depot_Code__c,Depot_Name__c, Sales_Org__c FROM Zone_Depot_Mapping__c Where Sales_Org__r.Sales_Org_Code__c='6061'];  
    } //End
    
    if(countryName == 'indonesia'){
      indonesiaDepoList=[SELECT Id, Name, Depot__c, SBU__c, Zone__c,Depot_Code__c,Depot_Name__c, Sales_Org__c FROM Zone_Depot_Mapping__c Where Sales_Org__r.Sales_Org_Code__c='6410'];  
    }
    
    if(countryName == 'uk'){
        ukDepoList=[SELECT Id, Name, Depot__c, SBU__c, Zone__c,Depot_Code__c,Depot_Name__c, Sales_Org__c FROM Zone_Depot_Mapping__c Where Sales_Org__r.Sales_Org_Code__c='2031'];
    }
    
    if(countryName == 'netherlands' || countryName == 'nl' ){
       netherlandsDepoList=[SELECT Id, Name, Depot__c, SBU__c, Zone__c,Depot_Code__c,Depot_Name__c, Sales_Org__c FROM Zone_Depot_Mapping__c Where Sales_Org__r.Sales_Org_Code__c='2110']; 
    }
    
    if(countryName == 'belgium'){
        belgiumDepoList=[SELECT Id, Name, Depot__c, SBU__c, Zone__c,Depot_Code__c,Depot_Name__c, Sales_Org__c FROM Zone_Depot_Mapping__c Where Sales_Org__r.Sales_Org_Code__c='2120'];
    }
    
    if(countryName == 'luxembourg'){
        luxembourgDepoList=[SELECT Id, Name, Depot__c, SBU__c, Zone__c,Depot_Code__c,Depot_Name__c, Sales_Org__c FROM Zone_Depot_Mapping__c Where Sales_Org__r.Sales_Org_Code__c='2120'];
    }
    
    if(isTM==true || isTMSwal==true){
        for(TM_Depot_Mapping__c tdm:tmDepoMapList){
        setOfDepotCode.add(tdm.Depot_Code__c);
        }   
      }
      if(rmtdListSwal.size()>0){
          for(Zone_Depot_Mapping__c zdm:rmDepoMapList){
          setOfDepotCode.add(zdm.Depot_Code__c);
          }
      }
      if(sbuDepoMapList.size()>0){
          for(Zone_Depot_Mapping__c zdm:sbuDepoMapList){
          setOfDepotCode.add(zdm.Depot_Code__c);
          }
      }
      if(zmDepoMapList.size()>0){
         for(Zone_Depot_Mapping__c zdm:zmDepoMapList){
          setOfDepotCode.add(zdm.Depot_Code__c);
          }   
      }
      if(australiaDepoList.size()>0){
          for(Zone_Depot_Mapping__c zdm:australiaDepoList){
          setOfDepotCode.add(zdm.Depot_Code__c);
          }
             
      }
    
     //Divya: 04/06/2021: Added for SCTASK0433277
     if(newZealandDepoList.size()>0){
          for(Zone_Depot_Mapping__c zdm:newZealandDepoList){
          setOfDepotCode.add(zdm.Depot_Code__c);
          }
             
      } //End
      if(indonesiaDepoList.size()>0){
          for(Zone_Depot_Mapping__c zdm:indonesiaDepoList){
          setOfDepotCode.add(zdm.Depot_Code__c);
          }
      }
      if(ukDepoList.size()>0){
          for(Zone_Depot_Mapping__c zdm:ukDepoList){
          setOfDepotCode.add(zdm.Depot_Code__c);
          }   
      }
      if(netherlandsDepoList.size()>0){
          for(Zone_Depot_Mapping__c zdm:netherlandsDepoList){
          setOfDepotCode.add(zdm.Depot_Code__c);
          }  
      }
      if(belgiumDepoList.size()>0){
          for(Zone_Depot_Mapping__c zdm:belgiumDepoList){
          setOfDepotCode.add(zdm.Depot_Code__c);
          }    
      }
      if(luxembourgDepoList.size()>0){
          for(Zone_Depot_Mapping__c zdm:luxembourgDepoList){
          setOfDepotCode.add(zdm.Depot_Code__c);
          }   
      }
    
   //Getting Inventory
  List<ZUDL_ZUIC_C03_Q001__x> brandDataList=new List<ZUDL_ZUIC_C03_Q001__x>();
  List<BrandDetailWrapper> brandWrapperList1 = new List<BrandDetailWrapper> ();
  List<BrandDetailWrapper> brandWrapperList2 = new List<BrandDetailWrapper> ();
  Map<String, BrandDetailWrapper> mapBrandWrap = new Map<String, BrandDetailWrapper>();

  if(plantCode!='ALL'){
    brandDataList=[SELECT Id, BRAND__c, COMP_CODE__c, PLANT_CODE__c, MAT_CODE__c, COMP_DESC__c,MAT_DESC__c, QTY__c, UOM__c, PLANT_DESC__c FROM ZUDL_ZUIC_C03_Q001__x WHERE BRAND__c=:BrandName1 AND PLANT_CODE__c =:plantCode];

      for(ZUDL_ZUIC_C03_Q001__x bWrap:brandDataList){
        
        BrandDetailWrapper brandWrapper1 = new BrandDetailWrapper();
        Decimal Total_Qty=0.00;
        brandWrapper1.BrandName = bWrap.MAT_DESC__c;
        brandWrapper1.SKUcode = bWrap.MAT_CODE__c;
        brandWrapper1.SKUcode=brandWrapper1.SKUcode.replace('U','0');
        brandWrapper1.SKUcode = brandWrapper1.SKUcode.replaceFirst('^0+','');
        if(showInventory==true){
          Total_Qty=bWrap.QTY__c;
          brandWrapper1.Quantity=(Total_Qty.format().contains('.')?Total_Qty.format():(Total_Qty.format()+'.00'));
          //brandWrapper1.Quantity =String.valueOf(bWrap.QTY__c) ;
        }else{
          if(bWrap.QTY__c==0){
            brandWrapper1.Quantity = 'Not Available';
          }else{
            brandWrapper1.Quantity = 'Available';
          }
        }
        brandWrapper1.UOM=bWrap.UOM__c;
        brandWrapper1.DepotCode=bWrap.PLANT_DESC__c;
      brandWrapperList2.add(brandWrapper1);
      } 
  }else{
    brandDataList=[SELECT Id, BRAND__c, COMP_CODE__c, PLANT_CODE__c, MAT_CODE__c, COMP_DESC__c,MAT_DESC__c, QTY__c, UOM__c, PLANT_DESC__c FROM ZUDL_ZUIC_C03_Q001__x WHERE PLANT_CODE__c IN : setOfDepotCode order by PLANT_DESC__c];

        for(ZUDL_ZUIC_C03_Q001__x bWrap:brandDataList){
          if(bWrap.BRAND__c.containsIgnoreCase(BrandName1)){
              BrandDetailWrapper brandWrapper1 = new BrandDetailWrapper();
              Decimal Total_Qty=0.00;
              brandWrapper1.BrandName = bWrap.MAT_DESC__c;
              brandWrapper1.SKUcode = bWrap.MAT_CODE__c;
              brandWrapper1.SKUcode=brandWrapper1.SKUcode.replace('U','0');
              brandWrapper1.SKUcode = brandWrapper1.SKUcode.replaceFirst('^0+','');
                if(showInventory==true){
                  Total_Qty=bWrap.QTY__c;
                  brandWrapper1.Quantity=(Total_Qty.format().contains('.')?Total_Qty.format():(Total_Qty.format()+'.00'));
                  //brandWrapper1.Quantity =String.valueOf(bWrap.QTY__c) ;
                }else{
                  if(bWrap.QTY__c==0){
                    brandWrapper1.Quantity = 'Not Available';
                  }else{
                    brandWrapper1.Quantity = 'Available';
                  }
                }
              brandWrapper1.UOM=bWrap.UOM__c;
              brandWrapper1.DepotCode=bWrap.PLANT_DESC__c;
              brandWrapperList2.add(brandWrapper1);
          }
        } 
  }
return brandWrapperList2;

}
public class BrandDetailWrapper {
  @AuraEnabled public String BrandName{get;set;}
  @AuraEnabled public String SKUcode{get;set;}
  @AuraEnabled public String Quantity{get;set;}
  @AuraEnabled public String UOM{get;set;}
  @AuraEnabled public String DepotCode{get;set;}
  
      BrandDetailWrapper(){
        BrandName ='';
        SKUcode='';
        Quantity='';
        UOM='';
        DepotCode='';

          }
}
    
    
}