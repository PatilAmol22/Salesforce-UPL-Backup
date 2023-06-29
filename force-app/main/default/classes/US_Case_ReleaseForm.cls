public class US_Case_ReleaseForm{

    // Obj var declaration
    public Case caseObj {get;set;}
    public Case caseObj2 {get;set;}
    
   
    // String var declaration
  /*  public String skuName {get;set;}
    public string offTtype {get;set;}
    
    public String CityState {get;set;}
    public String prdctName {get;set;}
    public string contctName {get;set;}
    public string ownerName {get;set;}
    public string ownerTitle {get;set;}
    public String dateOutput {get;set;}
    public String dateOutput1 {get;set;}
    public string contctTitle {get;set;}
    public string growingSeason {get;set;}
    public string growingSeasonDt {get;set;}
    public String replaceMentofCreditval {get;set;}*/
    public String caseObjId {get;set;}
    public Double repUnit{get;set;}
    public String repProd{get;set;}
    public String ProdName{get;set;}
    public Double cashpay{get;set;}
    public boolean offPart{get;set;}
     // list var declaration
    public List<Case> lstOfCase {get;set;}
    public List<Case_product__c> lstOfCaseprod {get;set;}
    
    public boolean cal{get;set;}
   
    // Date var declaration
   /* public Date formatedDt {get;set;}
    public DateTime yourDate {get;set;}
    public DateTime todayDate {get;set;}*/
    public date compdate{get;set;}
    // Constructor
    public US_Case_ReleaseForm(ApexPages.StandardController Controller) { 
    
    
    
        try{
            offPart=false;
        caseObj = (Case)Controller.getRecord();
        caseObjId = caseObj.Id ;
        //todayDate = System.today();
        //dateOutput1 = todayDate.format('dd-MM-yyyy');
        
        lstOfCase = new List<Case>();
        
        lstOfCase = [select id,owner.Title, account.Name,CaseNumber,
                        Account.BillingCity,Contact.Name,Contact.Title,
                        Account.BillingState,Account.BillingPostalCode,Account.State__r.State_Code__c,
                        owner.Name, Account.BillingCountry,
                        Release_Form_Type__c,Account.county__c,Account.Division__r.name,
                        Replacement_Credit_Volume_in_Units__c,
                        Zip__c,Account.Phone,Account.email__c,Officer_Partner__c,
                        Complaint_Form_Completed_Date__c,Account.BillingAddress,
                        Growing_Season__c,Growing_Season_Date__c,
                        Account.BillingStreet,Pack_Size_SKU__c,Cash_Credit_Payout__c,
                        Pack_Size_SKU__r.Name,Performance__c,Date_Complaint_Taken__c,owner.firstname,owner.lastname
                        from case
                        where Id =:caseObjId ];
        
        if(lstOfCase.size()>0){
            
            lstOfCaseprod=[select id,name,Replacement_Unit__c,Replacement_Product__c,Replacement_Product__r.name,Brand_Pack_Size__c,Brand_Pack_Size__r.name from case_product__c where Case__c=:lstOfCase[0].id];
            if(lstOfCaseprod.size()>0){
            repUnit=lstOfCaseprod[0].Replacement_Unit__c;
            repProd=lstOfCaseprod[0].Replacement_Product__r.name;
                ProdName=lstOfCaseprod[0].Brand_Pack_Size__r.name;
                lstOfCaseprod.remove(0);
                }
            cashpay=lstOfCase[0].Cash_Credit_Payout__c;
            compdate=lstOfCase[0].Date_Complaint_Taken__c;
            //CityState =  lstOfCase[0].Account.BillingCity+', '+lstOfCase[0].Account.BillingState;
            //skuName = lstOfCase[0].Pack_Size_SKU__r.Name;
            system.debug(lstOfCase[0].Account.BillingState +'check canada');
            
            if(lstOfCase[0].Account.State__r.State_Code__c=='CA' || lstOfCase[0].Account.BillingState.contains('California')){cal=true;}
            
            else{cal=false;}
            
            if(lstOfCase[0].Complaint_Form_Completed_Date__c != null){
            
                //yourDate = lstOfCase[0].Complaint_Form_Completed_Date__c;
                //dateOutput = yourDate.format('dd-MM-yyyy');
            }
            
            /*contctName = lstOfCase[0].Contact.Name;
            contctTitle = lstOfCase[0].Contact.Title;
            offTtype = lstOfCase[0].Officer_Partner__c;
            growingSeason = lstOfCase[0].Growing_Season__c;
            growingSeasonDt = String.valueOf(lstOfCase[0].Growing_Season_Date__c);
            replaceMentofCreditval = String.valueof(lstOfCase[0].Replacement_Credit_Volume_in_Units__c);
            ownerName  =  lstOfCase[0].Owner.Name;
            ownerTitle =  lstOfCase[0].Owner.Title;*/
        }
      }catch(Exception ex){
      
          System.debug('Error==>'+ex);
          System.debug('Error==>'+ex.getLineNumber());
      }     
    }
}