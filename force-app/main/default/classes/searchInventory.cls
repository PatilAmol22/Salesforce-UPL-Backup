/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* called from Lightning Component 
*
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Manisha Yadav   <myadava1@in.ibm.com>
* @modifiedBy     Manisha Yadav   <myadava1@in.ibm.com>
* @maintainedBy   Manisha Yadav   <myadava1@in.ibm.com>
* @version        1.0
* @created        2020-02-10
* @modified       2020-03-03
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
*                 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/







public without sharing class searchInventory{
 @AuraEnabled
 public static list<sales_org__c> getOrgDetails(){
 //fetch Sales org code from Custom settings
        UPL_Settings__c salesOrgDetails = UPL_Settings__c.getInstance();
        String SalesOrg = salesOrgDetails.SalesOrg__c;
        list<sales_org__c> salesorgId= [SELECT ID  FROM sales_org__c where sales_org_code__c=: SalesOrg];
       return salesorgId;
 }
 @AuraEnabled
 public static list<depot__c> getWH()
    { 
        list<sales_org__c> salesorgId=getOrgDetails();
        list<Depot__c> depot= new list<depot__c>();       
        depot= [Select ID ,Name,depot_code__c from depot__c where SalesOrg__c IN: salesorgId ORDER BY depot_code__c ASC];
        
        
       // depot.sort();
        return depot;        
        
  }
  @AuraEnabled 
  public static list<SKU__c> getbrand()
    { 
        //fetch Sales org code from Custom settings
        list<sales_org__c> salesorgId=getOrgDetails();
        
        list<SKU__c> brand= new list<SKU__c>(); 
        brand= [Select Brand_Name__c from SKU__c  where Sales_Org__c IN: salesorgId AND Brand_Name__c!= '' ORDER BY Brand_Name__c ASC];
        
        List<String> brands= new List<String>();       
        List<SKU__c> brandsreturn= new List<SKU__c>(); 
        for(SKU__c b:brand){
        if(!brands.contains(b.Brand_Name__c)){
        brands.add(b.Brand_Name__c);  
        brandsreturn.add(b); }
        }
        brandsreturn.sort();  
        return brandsreturn;        
        
  }
    @AuraEnabled 
  public static list<SKU__c> getMats()
    { 
        //fetch Sales org code from Custom settings
        list<sales_org__c> salesorgId=getOrgDetails();
        system.debug('Mat-***--');
        list<SKU__c> Mat= new list<SKU__c>(); 
        mat= [Select ID,Name,Sales_Org__c,SKU_code__c from SKU__c  where Sales_Org__c IN: salesorgId AND Name != '' ORDER BY SKU_code__c ASC];
        system.debug('Mat---'+Mat.size());
        List<String> matName= new List<String>();       
        List<String> matSku= new List<String>(); 
        List<SKU__c> matreturn= new List<SKU__c>(); 
        for(SKU__c m:mat){
        if((!matName.contains(m.Name)) || (!matSku.contains(m.SKU_Code__c)) ){
            matName.add(m.Name);
            matSku.add(m.SKU_Code__c);
            SKU__c newSku=new sku__c();
            newSku.id=m.Id;
            newSku.Name=m.Name;
            newSku.Sales_Org__c=m.Sales_Org__c; 
            String sku_code=m.SKU_code__c;
            Integer s= integer.valueOf(sku_code);
            sku_code =String.valueOf(s);
            newSku.SKU_Code__c=sku_code;
            matreturn.add(newSku); }
        }
        //matreturn.sort();  
        return matreturn;        
        
  }
  @AuraEnabled
  public static list<SKU__c> getMaterials(Id BrandName)
    { 
        //fetch Sales org code from Custom settings
        list<sales_org__c> salesorgId=getOrgDetails();
        list<SKU__c> mat= new list<SKU__c>();
        list<SKU__c> brName=[Select brand_name__c from SKU__c where id=:BrandName AND Sales_Org__c IN: salesorgId];
        List <String> BN= new List<String>();
        for(SKU__c s: brName){
            String B=s.brand_name__c;
            BN.add(B);
        }
         
        mat= [Select ID,Name,Sales_Org__c,SKU_Code__c from SKU__c  where Sales_Org__c IN: salesorgId AND Brand_Name__c IN: BN AND Name != '' ORDER BY SKU_code__c  ASC];
        system.debug('Mat---'+Mat.size());
        List<String> mats= new List<String>();       
        List<SKU__c> matreturn= new List<SKU__c>(); 
        /*for(SKU__c m:mat){
        if(!mats.contains(m.Name)){
        mats.add(m.Name);  
        matreturn.add(m); }
        }
        matreturn.sort();
        return matreturn;  */
         List<String> matName= new List<String>();       
        List<String> matSku= new List<String>(); 
        for(SKU__c m:mat){
        if((!matName.contains(m.Name)) || (!matSku.contains(m.SKU_Code__c)) ){
            matName.add(m.Name);
            matSku.add(m.SKU_Code__c);
            SKU__c newSku=new sku__c();
            newSku.id=m.Id;
            newSku.Name=m.Name;
            newSku.Sales_Org__c=m.Sales_Org__c; 
            String sku_code=m.SKU_code__c;
            Integer s= integer.valueOf(sku_code);
            sku_code =String.valueOf(s);
            newSku.SKU_Code__c=sku_code;
            matreturn.add(newSku); }
        }
       // matreturn.sort();  
        return matreturn;         
        
  }
 
   @AuraEnabled
  public static retinventoryDetailsWrapper getInventoryData(String WH,String BR,String MAT){  
  system.debug('WH---'+WH+'BR---'+BR+'SKU---'+MAT);
  list<sales_org__c> salesorgId=getOrgDetails();
  
  Depot__c depot= new depot__c();       
        depot= [Select ID ,Name,depot_code__c from depot__c where Id=: WH AND SalesOrg__c IN:salesorgId];
  
  /*List<Inventory__c> invntLst = new List<Inventory__c>();
  if(String.isBlank(BR)){
      invntLst= [select  Depot__r.depot_code__c,Depot__c,id,SKU_Depot__c,Availability__c,Availability_Date__c,Comments__c,sku_code__c,SKU__r.Name,SKU__r.Brand_Name__c from Inventory__c where Depot__c=: WH AND Sales_Org__c IN:salesorgId];
     
  }else if(String.isBlank(MAT)){
      invntLst= [select  Depot__r.depot_code__c,Depot__c,id,SKU_Depot__c,Availability__c,Availability_Date__c,Comments__c,sku_code__c,SKU__r.Name,SKU__r.Brand_Name__c from Inventory__c where Depot__c=: WH AND SKU__r.Id=: BR AND Sales_Org__c IN:salesorgId ];
      
  } else{
      invntLst= [select  Depot__r.depot_code__c,Depot__c,id,SKU_Depot__c,Availability__c,Availability_Date__c,Comments__c,sku_code__c,SKU__r.Name,SKU__r.Brand_Name__c from Inventory__c where Depot__c=: WH AND SKU__r.Id=: BR AND SKU__c =: MAT AND Sales_Org__c IN:salesorgId];
      
  } */
  
  UPL_Settings__c salesOrgDetails = UPL_Settings__c.getInstance();
        String SalesOrg = salesOrgDetails.SalesOrg__c;
    List<SObject> results = Database.query('SELECT ID  FROM sales_org__c where sales_org_code__c=: SalesOrg');
    Set<Id> resultIds = (new Map<Id,SObject>(results)).keySet();
  /* dynammic query */
   
   String query = 'select  Depot__c,id,SKU_Depot__c,Availability__c,Availability_Date__c,Comments__c,sku_code__c,SKU__r.Name,SKU__r.Brand_Name__c from Inventory__c';//
   query+=' Where '+ 'Sales_Org__c IN: resultIds' +' AND depot__c ='+'\'' +WH+'\'';   
  
  if((!String.isBlank(BR)) && BR!= '' && BR != null ){
      SKU__c BrName=[select Brand_Name__c from SKU__c where Id=:BR];
        query+=' AND SKU__r.Brand_Name__c='+'\'' +BrName.Brand_Name__c+'\'';      
  } 
  if((!String.isBlank(MAT) )&& MAT!='' && MAT!= null){
       query+=' AND '+'SKU__c='+'\''+ MAT+'\'' ;
  } 
  query+=  ' ORDER BY SKU__r.Brand_Name__c ASC';
      list<Inventory__c> invntLst1= Database.query(query); 
       
  
  system.debug('query of the inventory ------'+query);
      //invntLst= Database.query(query); 
        /* end dynammic query */
        List <inventoryDetailsWrapper> invntLstWapper= new List<inventoryDetailsWrapper >();
        List<String> skuLst= new List<String>();
        for(Inventory__c i:invntLst1){
        inventoryDetailsWrapper wr= new inventoryDetailsWrapper();
            wr.brandName= i.SKU__r.Brand_Name__c;
            wr.SKU=i.SKU__r.Name;            
            wr.avail=i.Availability__c;
            system.debug('Avail'+i.Availability__c);
            wr.availDate=i.Availability_Date__c;
            wr.comment=i.Comments__c;
            wr.SKUCode=String.valueOf(Integer.valueOf(i.SKU_code__c));
            wr.warehouse=i.Depot__c;
            wr.id=i.id;
            invntLstWapper.add(wr);
            skuLst.add(i.sku_code__c);
        }
        system.debug('skuLst ------- '+skuLst+'---'+'--Mat--'+MAT+'--BR--'+BR+'salesorgId --'+ salesorgId );
        List<SKU__c> invntSkuData=new List<SKU__c>();
       /* if(String.isBlank(BR))
        invntSkuData=[Select Name, Brand_Name__c,SKU_Code__c from Sku__c where SKU_Code__c NOT IN :skuLst AND Sales_Org__c IN: salesorgId];
        else 
        invntSkuData=[Select Name, Brand_Name__c,SKU_Code__c from Sku__c where SKU_Code__c NOT IN :skuLst AND Sales_Org__c IN: salesorgId AND Id =:BR];
          */
          if(!String.isBlank(BR)){
           SKU__c BrName=[select Brand_Name__c from SKU__c where Id=:BR AND Sales_Org__c IN: salesorgId];
            if(!String.isBlank(MAT)){               
                invntSkuData=[Select Name, Brand_Name__c,SKU_Code__c from Sku__c where SKU_Code__c NOT IN :skuLst AND Sales_Org__c IN: salesorgId AND Brand_Name__c=:BrName.Brand_Name__c AND Id =:MAT ORDER BY Brand_Name__c ASC];
             }else
             invntSkuData=[Select Name, Brand_Name__c,SKU_Code__c from Sku__c where SKU_Code__c NOT IN :skuLst AND Sales_Org__c IN: salesorgId AND Brand_Name__c=:BrName.Brand_Name__c ORDER BY Brand_Name__c ASC];
           }else if(!String.isBlank(MAT)){
                invntSkuData=[Select Name, Brand_Name__c,SKU_Code__c from Sku__c where SKU_Code__c NOT IN :skuLst AND Sales_Org__c IN: salesorgId AND Id =:MAT ORDER BY Brand_Name__c ASC];
           }else {
                invntSkuData=[Select Name, Brand_Name__c,SKU_Code__c from Sku__c where SKU_Code__c NOT IN :skuLst AND Sales_Org__c IN: salesorgId ORDER BY Brand_Name__c ASC];
            }
         
         
          for(SKU__c s:invntSkuData){
            inventoryDetailsWrapper wr= new inventoryDetailsWrapper();
            wr.brandName= s.Brand_Name__c;
            wr.SKU=s.Name;
            //wr.SKUCode=s.SKU_Code__c;
            String result = UserInfo.getLocale();
            if(result=='en_BR'){
            wr.avail='Indisponível';
            }else{wr.avail='Empty';}
            //system.debug('Avail'+i.Availability__c);
            wr.availDate=Date.newInstance(2099,12,31);//31/12/2099;
            wr.SKUCode=String.valueOf(Integer.valueOf(s.SKU_Code__c));
            wr.warehouse= depot.Id;
            invntLstWapper.add(wr);
        }
        
        
        retinventoryDetailsWrapper retdata= new retinventoryDetailsWrapper();
        retdata.inventData =invntLstWapper;
        //retdata.avails=getPickListValuesIntoList();
        
        List<availVals> listval= getPickListValuesIntoList();
        system.debug('listval'+listval);
        retdata.availValsList=listval;
        //checking whether user has write access or not
        id Id = userinfo.getProfileId();
        Profile profileName=[select Name from profile where id = :Id Limit 1];
        if(ProfileName.Name=='System Administrator' || ProfileName.Name=='Brazil System Administrator' || profileName.Name=='Brazil Customer Service User'){        
        //if(Schema.sObjectType.Stock_In_Channel__c.isCreateable() && Schema.sObjectType.Stock_In_Channel_Detail__c.isCreateable()){
                   retdata.writeAccess = true;
         }else{
                retdata.writeAccess = false;
         } 
         system.debug('retData List--'+retdata);   
        return retdata;
  }
  
  /* get PickList value for Availability */
  
  public static List<availVals> getPickListValuesIntoList(){
        List<availVals> pickListValuesList= new List<availVals>();
        
        Schema.DescribeFieldResult fieldResult = Inventory__c.Availability__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            availVals a=new availVals();
        a.Label=pickListVal.getLabel();
        a.val=pickListVal.getValue();
           // pickListValuesList.add(pickListVal.getLabel());
           pickListValuesList.add(a);
            system.debug(pickListVal.getLabel()+'--'+pickListVal.getValue());
        }     
        return pickListValuesList;
    }
  /* Display inventory code */

    @AuraEnabled
    public static String upsertAvailabilityDetails(String Wh,String SKUCode,String Avail,String Id,String Availdte , String comment){
       system.debug('Wh--'+Wh+'SKUCode--'+SKUCode+'Avail--'+Avail+'--Id--'+Id);
       /*if(Avail=='Alto'){ Avail='High';}
       else if(Avail=='Médio'){Avail='Medium';}
       else if(Avail=='Baixo'){Avail='Low';}
       else if(Avail=='Indisponível'){Avail='Empty';}
       else{Avail=Avail;} */
       
        if(SKUCode.length() < 18)
            SKUCode=SKUCode.leftPad(18,'0');
       
       
       UPL_Settings__c salesOrgDetails = UPL_Settings__c.getInstance();
       String SalesOrg = salesOrgDetails.SalesOrg__c;
       
        list<sales_org__c> salesorgId=getOrgDetails();
       depot__c DC=[select depot_code__c from depot__c  where Id=:Wh AND SalesOrg__c IN :salesorgId];
       sku__c sc=[select id from SKU__c where sku_code__c=:SKUCode AND Sales_Org__c IN :salesorgId];
       if(SKUCode.length() < 18)
            SKUCode=SKUCode.leftPad(18,'0');
       String SKDC=SalesOrg+DC.depot_code__c+SKUCode;
       List<Inventory__c> invnt=[Select SKU_Depot__c,Availability_Date__c,depot__r.depot__c,SKU_Code__c from Inventory__c where  Id=:Id AND SKU_Depot__c=:SKDC AND Sales_Org__c IN :salesorgId ];
      if(invnt.size()>0){
       invnt[0].SKU_Depot__c=SKDC;
       invnt[0].Availability__c= Avail;
       if(Availdte != null)      
       invnt[0].Availability_Date__c= Date.valueOf(Availdte) ;
       invnt[0].Comments__c=comment;
       Update invnt;
       return id;
       }else{
           inventory__c newinvnt= new inventory__c();
           //newinvnt.SKU_Code__c=SKUCode;
           newinvnt.depot__c=Wh;
           newinvnt.Availability__c=Avail;
           newinvnt.Availability_Date__c=Date.newInstance(2099,12,31);
           newinvnt.Comments__c=comment;
           newinvnt.SKU_Depot__c=SKDC;
           newinvnt.sku__c=sc.id;
           newinvnt.Sales_Org__c=getOrgDetails()[0].id;
           Upsert newinvnt;
           newinvnt=[select id from inventory__c where SKU_Depot__c=:SKDC AND Sales_Org__c IN :salesorgId ];
           return newinvnt.id;
       }
       
    } 
     @auraenabled
    public static String upsertAvailabilityDateDetails(String Wh,String SKUCode,String Avail,String Id,String Availdte , String comment){
        
       system.debug('Wh*******--'+Wh+'SKUCode--'+SKUCode+'comment--'+comment+'--Id--'+Id+'--Availdte --'+Availdte );
        
        
        list<sales_org__c> salesorgId=getOrgDetails();
        if(SKUCode.length() < 18)
            SKUCode=SKUCode.leftPad(18,'0'); 
        Date availibilityDate;
        if(Availdte != null){
           String[] dts = AvailDte.split('-');
           Integer day=Integer.valueOf(dts[2].replaceAll( '\\s+', ''));
           Integer mnth=Integer.valueOf(dts[1].replaceAll( '\\s+', ''));            
           Integer yr = Integer.valueOf(dts[0].replaceAll( '\\s+', ''));
           availibilityDate= Date.newInstance(yr,mnth,day);
        }
        else{
           availibilityDate = null;
        }
           UPL_Settings__c salesOrgDetails = UPL_Settings__c.getInstance();
           String SalesOrg = salesOrgDetails.SalesOrg__c;
           
            system.debug('wh--'+Wh+'SKUCode--'+SKUCode+'SalesOrg --'+SalesOrg ); 
            depot__c DC=[select depot_code__c from depot__c  where Id=:Wh AND SalesOrg__c IN : salesorgId ];
           sku__c sc=[select id from SKU__c where sku_code__c=:SKUCode AND Sales_Org__c IN : salesorgId  ];
           if(SKUCode.length() < 18)
            SKUCode=SKUCode.leftPad(18,'0');
           String SKDC=SalesOrg+DC.depot_code__c+SKUCode;
           List<Inventory__c> invnt=[Select id,SKU_Depot__c,Availability_Date__c,depot__r.depot__c,SKU_Code__c from Inventory__c where Id=:Id AND SKU_Depot__c=:SKDC AND Sales_Org__c IN : salesorgId];
           if(invnt.size()>0){
           invnt[0].SKU_Depot__c=SKDC;
           invnt[0].Availability__c= Avail;
           invnt[0].Availability_Date__c= availibilityDate;
           invnt[0].Comments__c=comment;
          
           Update invnt;
           return invnt[0].Id;
           }else{
               inventory__c newinvnt= new inventory__c();
               newinvnt.depot__c=Wh;
               newinvnt.Availability__c=Avail;
               newinvnt.Availability_Date__c=Date.newInstance(2099,12,31);
               newinvnt.Comments__c=comment;
               newinvnt.SKU_Depot__c=SKDC;
               newinvnt.sku__c=sc.id;
               newinvnt.Sales_Org__c=getOrgDetails()[0].id;
               Upsert newinvnt;
               newinvnt=[select id from inventory__c where SKU_Depot__c=:SKDC AND Sales_Org__c IN : salesorgId  ];
               return newinvnt.id;
           }
       
        } 
     @auraenabled
    public static String upsertCommentDetails(String Wh,String SKUCode,String Avail,String Id,String Availdte , String comment){
    if(SKUCode.length() < 18)
            SKUCode=SKUCode.leftPad(18,'0');
    list<sales_org__c> salesorgId=getOrgDetails();
       system.debug('Wh--'+Wh+'SKUCode--'+SKUCode+'comment--'+comment+'--Id--'+Id+'--Availdte --'+Availdte+'---Avail---'+Avail );
       UPL_Settings__c salesOrgDetails = UPL_Settings__c.getInstance();
        String SalesOrg = salesOrgDetails.SalesOrg__c;
       depot__c DC=[select depot_code__c from depot__c  where Id=:Wh AND SalesOrg__c IN : salesorgId ];
       sku__c sc=[select id from SKU__c where sku_code__c=:SKUCode AND Sales_Org__c IN : salesorgId ];
       if(SKUCode.length() < 18)
            SKUCode=SKUCode.leftPad(18,'0');
       String SKDC=SalesOrg+DC.depot_code__c+SKUCode;
       List<Inventory__c> invnt=[Select SKU_Depot__c,Availability_Date__c,depot__r.depot__c,SKU_Code__c from Inventory__c where Id=:Id AND  SKU_Depot__c=:SKDC AND Sales_Org__c IN : salesorgId ];
      if(invnt.size()>0){
       invnt[0].SKU_Depot__c=SKDC;
       invnt[0].Availability__c= Avail;
       if(Availdte != null)
       invnt[0].Availability_Date__c= Date.valueOf(Availdte) ;
       invnt[0].Comments__c=comment;
       Update invnt;
       return Id;
       }else{
           inventory__c newinvnt= new inventory__c();
           newinvnt.depot__c=Wh;
           newinvnt.Availability__c=Avail;
           newinvnt.Availability_Date__c=Date.newInstance(2099,12,31); 
           newinvnt.Comments__c=comment;
           newinvnt.SKU_Depot__c=SKDC;
           newinvnt.sku__c=sc.id;
           newinvnt.Sales_Org__c=getOrgDetails()[0].id;
           Upsert newinvnt;
           newinvnt=[select id from inventory__c where SKU_Depot__c=:SKDC AND Sales_Org__c IN : salesorgId ];
           return newinvnt.id;
       }
       
    }
    
    
    
    /* Warppers Code */
    /*Wrapper Class to get SKU with Pagination  
    public class PaginationWrapper {
        
        @AuraEnabled
        public Stock_In_Channel__c invntId{get;set;}        
        @AuraEnabled
        public boolean writeAccess {get;set;}
        @AuraEnabled
        public List<inventoryDetailsWrapper > inventoryDetailsWrapper {get;set;}
        
    } */
    
    public class availVals{
    @AuraEnabled
       public String label{get;set;} 
       @AuraEnabled
       public String val{get;set;} 
    
    }
    //Wrapper for InventoryDetails
    public class retinventoryDetailsWrapper {
        @AuraEnabled
        public List<inventoryDetailsWrapper> inventData {get;set;}        
        @AuraEnabled
       public list<String> avails{get;set;}       
        @AuraEnabled
        public boolean writeAccess {get;set;}
        @AuraEnabled
       public List<availVals> availValsList{get;set;} 
       
    }
    public class inventoryDetailsWrapper {
        
        @AuraEnabled
        public string brandName {get;set;}        
        @AuraEnabled
        public string SKU{get;set;}        
        @AuraEnabled
        public string avail{get;set;}
        @AuraEnabled
        public Date availDate{get;set;}
        @AuraEnabled
        public String comment{get;set;}
        @AuraEnabled
        public ID Id{get;set;}
        @AuraEnabled
        public string SKUCode{get;set;}
        @AuraEnabled
        public string TSKUCode{get;set;}
        @AuraEnabled
        public string warehouse {get;set;}
        @AuraEnabled
       public list<SelectOption> avails{get;set;}    
        
        
    }
    
  
}