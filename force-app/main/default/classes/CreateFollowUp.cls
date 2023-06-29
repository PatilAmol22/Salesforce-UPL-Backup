public class CreateFollowUp {
    
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
    public static List<Recommendations__c> createFollowUp(String[] recommendationId,Boolean buyProduct,String reasonForNot,String otherReasonDetails,
                                                    String whichProduct, Date whenProduct, String whichRetailer, String broughtYourself,
                                                   String formProduct, String colorProduct, String artworkProduct, Boolean entireArea,
                                                   Integer acreArea, String resultSatisfied, String ifNoReason, String noDetails, Date possibleBuy,
                                                   Date possibleApply )
    {
       
        system.debug('here in cfollowup');
        List<Recommendations__c> upsertRecoList = new List<Recommendations__c>(); 
        List<Recommendations__c> recoList = [SELECT Id,Product__c FROM Recommendations__c where Id =: recommendationId];
        for(Recommendations__c reco: recoList){
        reco.IfProductBought__c = buyProduct;
        reco.ResonForNotBuying__c = reasonForNot;
        reco.ReasonOthers__c = otherReasonDetails;
        reco.NameProductBought__c = whichProduct;
        reco.DateProductBought__c = whenProduct;
        reco.RetailerName__c = whichRetailer;
        reco.SelfBoughtOrUsed__c = broughtYourself;
        reco.ProductForm__c = formProduct;
        reco.PackColour__c = colorProduct;
        reco.PackArtWork__c = artworkProduct;
        reco.UsedEntireCropArea__c = entireArea;
        //reco.UsedCropArea__c = acreArea;
        reco.UseCropArea__c = acreArea;
        reco.SatisfactionLevel__c = resultSatisfied;
        //reco.ReasonNotUsedEntireCropArea__c = ifNoReason;
        reco.If_No_Reason__c = ifNoReason;
        reco.OtherReasonNotUsedEntireCropArea__c = noDetails;
        reco.PossiblePurchaseDate__c = possibleBuy;
        reco.PossibleApplicationDate__c = possibleApply;
            
        upsertRecoList.add(reco);

            
        }
        upsert upsertRecoList;
        return upsertRecoList;
        
    }
    
    
    
}