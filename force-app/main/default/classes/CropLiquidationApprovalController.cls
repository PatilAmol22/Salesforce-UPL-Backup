global without sharing class CropLiquidationApprovalController {

    public List<Crop__c> cropNListvf {get;set;}
    public string TerritoryIds{get;set;}
    public string cropFY{get;set;}
    public string cropMonth{get;set;}
    public List<Product2> productsList{get;set;}
    public map<string,list<Crop_Liquidation__c>> productCropmap{get;set;}
    public String recordIdTotupdate{get;set;}
    public String prodIdTotupdate {get;set;}
    public String valueToupdate {get;set;}
   // public String isSubmittedCropLiqui {get;set;}
    public list<Liquidation_Annual_Plan__c> laplan= new list<Liquidation_Annual_Plan__c>();
    public list<Liquidation2__c> liquil = new list<Liquidation2__c>();
    public list<Crop_Liquidation__c> cropList = new list<Crop_Liquidation__c>();
    public List<String> liquidationIds = new List<String>();
    public List<String> productIds = new List<String>();
    public List<Crop_Liquidation__c> cropLiqList = new List<Crop_Liquidation__c>();
    
    public CropLiquidationApprovalController(){
       cropNListvf = new List<Crop__c>();
       TerritoryIds=ApexPages.CurrentPage().getParameters().get('tId');
       cropFY=ApexPages.CurrentPage().getParameters().get('fy');
       cropMonth=ApexPages.CurrentPage().getParameters().get('m');
       
       //isSubmittedCropLiqui=ApexPages.CurrentPage().getParameters().get('isSubmittedCropLiqui');
       //system.debug('## isSubmittedCropLiqui : ' +isSubmittedCropLiqui); 
       productsList = new List<Product2>();
       productCropmap = new map<string,list<Crop_Liquidation__c>>();
    }
    public void defaultMethod(){
        system.debug('## TerritoryId : ' +TerritoryIds);
       system.debug('## cropFY : ' +cropFY);
       system.debug('## cropMonth : ' +cropMonth);
        cropNListvf = [Select Id,Name FROM Crop__c 
                              WHERE Active_for_Crop_Liquidation__c = true
                              AND Active__c = true 
                              AND Type__c ='Crop'
                              ORDER BY LastModifiedDate ASC];
   
           laplan= [SELECT Id,Name, Fiscal_Year__c, Territory_Name__c
                                           FROM Liquidation_Annual_Plan__c where Territory_Name__c =:TerritoryIds and FIscal_Year__c=:cropFY limit 1];
        
        system.debug('## cropNListvf : ' +cropNListvf);
        system.debug('## laplan : ' +laplan);
        
        if(laplan!=null && laplan.size()>0 ){
            liquil = [select Product_Code__c,Brand_Name_India__c,Product__r.Name,Territory__c,Month__c,
                      Liquidation_Annual_Plan__r.Sales_Org__c,Liquidation_YTD_Trade__c,Product__c
                      from Liquidation2__c where Liquidation_Annual_Plan__c=:laplan[0].id 
                      AND Territory__c=:TerritoryIds
                      AND Month__c=:cropMonth AND Fixed_YTD_Sales__c>0 /*Liquidation_YTD_Trade__c>0*/ ];
                }
        system.debug('**Liquidation : ' +liquil);
        
        if(liquil!=null && liquil.size()>0){
        for(Liquidation2__c liqudaobj:liquil){
            liquidationIds.add(liqudaobj.Id); 
            productIds.add(liqudaobj.Product__c);           
        }
        }
        
        if(productIds!=null && productIds.size()>0 ){
                productsList = [SELECT Id,Name, product_code__C,Active_For_Liquidation__c, 
                               Sales_Org_Code__c,
                               IsActive 
                               FROM Product2 
                               WHERE IsActive = true  
                               AND Active_For_Liquidation__c= true
                               AND Id IN:productIds];             
            }
        System.debug('** in product list '+productsList);
        
    if(liquidationIds.size()>0 && productIds.size()>0 ){
      cropList = [select id, name, Product_Name__c, Liquidation_YTD_Trade__c,Crop__c,Liquidation__r.Product__c,Liquidation__r.Product_Code__c,
                  Crop__r.name, Liquidation_Value__c FROM Crop_Liquidation__c where Liquidation__c IN :liquidationIds 
                  and Liquidation__r.Product__c IN : productIds order by Liquidation__r.Product__c, Crop__r.LastModifiedDate ASC ];
        }
        
        if(cropList!=null && cropList.size()>0){
        for (Crop_Liquidation__c cplist:cropList){
            if(productCropmap.containsKey(cplist.Liquidation__r.Product__c)){
                cropLiqList.add(cplist);
                productCropmap.put(cplist.Liquidation__r.Product__c,cropLiqList);
            }
            else{
                cropLiqList = new List<Crop_Liquidation__c>();
                cropLiqList.add(cplist);
                productCropmap.put(cplist.Liquidation__r.Product__c,cropLiqList);
            }
        }  
            
        }          
    }

     public void updateSingleRecordForCropLiquidations(){
        
       try{
            TradeSalesIndiaCropLiquidation tradeSalesObj = new TradeSalesIndiaCropLiquidation();            
                tradeSalesObj.updateSingleRecordForCropLiquidationIndia(recordIdTotupdate, prodIdTotupdate, valueToupdate); 
        }
        catch(Exception ex){
            System.debug('Error Massage '+ex.getMessage());
            System.debug('Error Line '+ex.getLineNumber());
        } 
     }

  
}