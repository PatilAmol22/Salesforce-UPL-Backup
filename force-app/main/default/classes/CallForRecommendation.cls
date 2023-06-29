public class CallForRecommendation {
    
    //start
    @AuraEnabled 
    public static Map<String, List<String>> getDependentMap(sObject objDetail, string contrfieldApiName,string depfieldApiName,string depfieldApiNameDU) {
        String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        //String dependentFieldDU	= depfieldApiNameDU.toLowerCase();
        
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        
        Schema.sObjectType objType = objDetail.getSObjectType();
        if (objType==null){
            return objResults;
        }
        
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
            return objResults;     
        }
        
        Schema.SObjectField theField = objFieldMap.get(dependentField);
        Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
        
        List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
        List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
        List<String> controllingValues = new List<String>();
        
        for (Schema.PicklistEntry ple : contrEntries) {
            String label = ple.getLabel();
            objResults.put(label, new List<String>());
            controllingValues.add(label);
        }
        
        for (PicklistEntryWrapper plew : depEntries) {
            String label = plew.label;
            String validForBits = base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                String bit = validForBits.mid(i, 1);
                if (bit == '1') {
                    objResults.get(controllingValues.get(i)).add(label);
                }
            }
        }
        return objResults;
    }
    
    public static String decimalToBinary(Integer val) {
        String bits = '';
        while (val > 0) {
            Integer remainder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }
    
    public static String base64ToBits(String validFor) {
        if (String.isEmpty(validFor)) return '';
        
        String validForBits = '';
        
        for (Integer i = 0; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, 1);
            Integer val = base64Chars.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            validForBits += bits;
        }
        
        return validForBits;
    }
    
    private static final String base64Chars = '' +
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
        'abcdefghijklmnopqrstuvwxyz' +
        '0123456789+/';
    
    
    private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) {
        return (List<PicklistEntryWrapper>)
            JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
    }
    
    public class PicklistEntryWrapper{
        public String active {get;set;}
        public String defaultValue {get;set;}
        public String label {get;set;}
        public String value {get;set;}
        public String validFor {get;set;}
        public PicklistEntryWrapper(){            
        }
        
    }
    
    
    //end
    
    @AuraEnabled
    public static String subject(Id taskrec){
        Task t = [SELECT ID,Subject FROM Task WHERE ID =: taskrec];
     	return t.Subject;
    }
    
    
    
    
    
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        List < String > allOpts = new list < String > ();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        
        allOpts.sort();
        return allOpts;
    }
    
    
    
    @AuraEnabled
    public static List < String > getselectOptions1(sObject objObject, string fld) {
        List < String > allOpts = new list < String > ();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        allOpts.sort();
        return allOpts;
    }
    
    @AuraEnabled
    public static Call__c setViewStat(String Empanelment, List<String> Disease, List<String> Insect, String Pgr, String Weed, Boolean PestInfection, Date PestInfectionObservedDate)
    {
        
        String diseaseString ='';
        if(Disease.size()>0 && Disease != null){
            for(String s : Disease){
                diseaseString += (s + ';');
            }
        }
        String insectString ='';
        if(Insect.size()>0 && Insect != null){
            for(String st : Insect){
                insectString += (st + ';');
            }
        }
        
        Call__c createCall = new Call__c(Empanelment__c = Empanelment, PGR__c = Pgr,Disease__c = diseaseString ,Insect__c = insectString,
                                         Weed__c = Weed, PestInfestation__c = PestInfection, PestInfestationDate__c = PestInfectionObservedDate, isRecommendation__c = true);
        try{
			insert createCall;            
        }catch(Exception e){
            System.debug('An exception occurred: ' + e.getMessage());
		}
            
        System.debug('createCall == '+createCall);
        return createCall;
        
    }
    
    @AuraEnabled
    public static List<Recommendations__c> createRecommendation(string callId, List<String> productname, List<String> productdosage,List<String> productdosageunit){
        List<Recommendations__c> recObj = new List<Recommendations__c>();
        List<Id> recIds = new List<Id>();
        
        if(productname.size()>0 && productdosage.size()>0 && productdosageunit.size()>0){
            for(Integer i = 0; i<productname.size(); i++){
                if(productname[i] != null && productname[i] != '' && productdosage[i] != null && productdosageunit[i] != null ){
                    Recommendations__c createRecommendation = new Recommendations__c( Call__c = callId, Product__c = productname[i] , Dosage__c = productdosage[i] ,
                                                                                     DosageUnit__c = productdosageunit[i] );
                    recObj.add(createRecommendation);
                }
                /*else
{
System.debug('In here---@AuraEnabled inside for');
}
*/
            }
            try{
            insert recObj;    
            }
            catch(Exception e)
            {
                 System.debug('An exception occurred when creating recommendations: ' + e.getMessage());
            }
            
        }
        /*
else{
System.debug('In here---@AuraEnabled inside else');
}
*/
        return recObj;
    }
    
    @AuraEnabled
    public static void saveRecommendation(list<Recommendations__c> lirec){
        
        Recommendations__c r1 = [SELECT ID,Call__c FROM Recommendations__c WHERE ID =: lirec[0].Id];
        System.debug('call-'+r1.Call__c);
        //Call__c c1 = [Select Id,isRecommendation,Name FROM Call__c WHERE Id =: r1.Call__c];
        Call__c c1 = [SELECT ID FROM Call__c WHERE ID =: r1.Call__c];
        c1.isRecommendation__c = false;
        update c1;
        
        
        
        for (Recommendations__c rec:lirec){
            //system.debug('abc'+rec.ResonForNotBuying__c );
            rec.FollowUpCompleted__c = true;
            //rec.Call__r.isRecommendation__c = false;
            //rec.Call__r.Followup_Open__c = false;
             if(rec.Product__c == rec.NameProductBought__c){
                rec.CorrectProductBought__c = true;
            }
        }
        update lirec;
        //return lirec;
    }   
    @AuraEnabled
    public static List<ProductRecommendation__mdt> getRecommendations(String Empanelment, List<String> Disease, List<String> Insect, String Pgr, String Weed,Boolean PestInfection, Date PestInfectionObservedDate, String State, String Crop, Date DateOfSowing){
        
        String diseaseString ='';
        if(Disease.size()>0 && Disease != null){
            for(String s : Disease){
                diseaseString += (s + ';');
            }
        }
        String insectString ='';
        if(Insect.size()>0 && Insect != null){
            for(String st : Insect){
                insectString += (st + ';');
            }
        }
        
        Date todayDate = date.today();
        Integer sow =   DateOfSowing.daysBetween(todayDate);
        System.debug('intsow==' +sow);                             
        List<ProductRecommendation__mdt> rangePrm = new List<ProductRecommendation__mdt>();
        
        List<ProductRecommendation__mdt> prm = new List<ProductRecommendation__mdt>();
        prm = [SELECT Id,Pest__c, Product__c,Dosage_Unit__c, Pest_Type__c, Dosage__c,MinDay__c, MaxDay__c FROM ProductRecommendation__mdt WHERE Crop__c =: Crop AND Zone__c =: State];
        //AND MinDay__c <= sow AND MaxDay__c >= sow]
        //13
        for(ProductRecommendation__mdt p : prm){
            //35
            if(p.MinDay__c <= sow && p.MaxDay__c >= sow)
            {
                //Pest__c ----Soil Pest(Disease), Growth Promoters(PGR), Pre Imergent(Weed), Sucking Pest(Insect) 
                if(p.Pest__c == Pgr){
                    rangePrm.add(p);  
                }
                if(p.Pest__c == Weed){
                    rangePrm.add(p);  
                }
                if(diseaseString.contains(p.Pest__c)){
                    rangePrm.add(p);  
                }
                if(insectString.contains(p.Pest__c)){
                    rangePrm.add(p);  
                }
            }
        }
        System.debug('rangerange - ' +rangePrm);
        return rangePrm;
    }
    
    
    @AuraEnabled
    public static map<string,list<Recommendations__c>> mapCRController(string empanelmentId){
        system.debug(empanelmentId);
        map<string,list<Recommendations__c>> MapCallRecomm = new map<string,list<Recommendations__c>>();
        
        for (call__c c: [SELECT Id,  Name , Empanelment__C,createddate,(SELECT Id,name, Call__c, Empanelment__c, Farmer__c, UseCropArea__c, 
                                                                        If_No_Reason__c, IfProductBought__c, ResonForNotBuying__c, 
                                                                        ReasonOthers__c, CorrectProductBought__c, DateProductBought__c, 
                                                                        CorrectDateProductBought__c, RetailerName__c, 
                                                                        SelfBoughtOrUsed__c, ProductForm__c, CorrectProductForm__c, 
                                                                        PackColour__c, CorrectFlagColour__c, PackArtWork__c, 
                                                                        UsedEntireCropArea__c, SatisfactionLevel__c, 
                                                                        OtherReasonNotUsedEntireCropArea__c, PossiblePurchaseDate__c, 
                                                                        PossibleApplicationDate__c, Product__c, DosageUnit__c, 
                                                                        Days_From_Sowing__c, NameProductBought__c, 
                                                                        Dosage__c FROM Interactions__r) FROM call__c where Empanelment__C = :empanelmentId order by Createddate desc])
        {
            MapCallRecomm.put(c.id, c.Interactions__r);
        }
        system.debug('MAPOFCALLANDRECOMMENDATION  =  '+MapCallRecomm);
        return MapCallRecomm;
    }
    
    @AuraEnabled
    public static Empanelment__c empanelValues(string empanelmentId){
        system.debug('emp 0 emp 0 '+empanelmentId);
        Empanelment__c empc = new Empanelment__c();
        try{
        empc = [SELECT Id,CultivatedArea__c, SowingDate__c, CultivatedCrop__c,Farmer__r.Village__pr.State__c  FROM Empanelment__c WHERE Id =: empanelmentId ];
            System.debug('empc = '+empc);
        }
        catch(SObjectException se){
            System.debug('The following exception has occurred: ' + se.getMessage());
             
        }
       return empc;
    }
}