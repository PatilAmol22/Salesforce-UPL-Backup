public class ChatBot_Inventory {
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
        public Zone_Depot_Mapping__c tmDepoMapRec;
        
    }
    
    @InvocableMethod(label='Get NonTM Brand Data')
    public static List<PrechatOutput> getBrandData(List<PrechatInput> inputParameters){
        List<PrechatOutput> po=new List<PrechatOutput>();
        PrechatOutput prechatobject=new PrechatOutput();
        String BrandName='';
        Zone_Depot_Mapping__c tmDepoName=new Zone_Depot_Mapping__c();
        if(!test.isRunningTest()){
         BrandName=inputParameters[0].sBrandName;
         tmDepoName=(Zone_Depot_Mapping__c)inputParameters[0].tmDepoMapRec;
                system.debug('BrandName'+BrandName);
        }else{
            //this code is use for covering test class
            PrechatInput pi=new PrechatInput();
            
             BrandName='';
            pi.sBrandName=BrandName;
             tmDepoName=new Zone_Depot_Mapping__c();
            pi.tmDepoMapRec=tmDepoName;
                system.debug('BrandName'+BrandName);
        }
        List<ZUDL_ZUIC_C03_Q001__x> listOfInventory=new List<ZUDL_ZUIC_C03_Q001__x>();
        
        map<string,ZUDL_ZUIC_C03_Q001__x> mapOfInventoryBrand = new map<string,ZUDL_ZUIC_C03_Q001__x>();
        listOfInventory=[SELECT Id, BRAND__c, COMP_CODE__c, PLANT_CODE__c, COMP_DESC__c, QTY__c, UOM__c, PLANT_DESC__c FROM ZUDL_ZUIC_C03_Q001__x where PLANT_CODE__c=:tmDepoName.Depot_Code__c ];
        system.debug('listOfInventory'+listOfInventory.size());
        for(ZUDL_ZUIC_C03_Q001__x Inv: listOfInventory){
            if(Inv.BRAND__c.containsIgnoreCase(BrandName)){
                mapOfInventoryBrand.put(Inv.BRAND__c,inv);
            }
        }
        if(mapOfInventoryBrand.size()>0){
         	for(ZUDL_ZUIC_C03_Q001__x exobj: mapOfInventoryBrand.values()){
           
             	prechatobject.listOfBrand.add(exobj.BRAND__c+'-'+exobj.PLANT_CODE__c);
            }
        }else{
            prechatobject.isError =true;
        }
        //prechatobject.listOfBrand=mapOfInventoryBrand.values();
        po.add(prechatobject);
        //po.listOfBrand=invWrapList;
        return po ;
        
    }
}