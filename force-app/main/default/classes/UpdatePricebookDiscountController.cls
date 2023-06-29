public class UpdatePricebookDiscountController {
    @InvocableMethod
    public static void updateStartEndDate(List<String> sPCampaignIds){
        System.debug('invoke class');
        System.debug('sPCampaignIds :- '+sPCampaignIds);
        Map<String,List<String>> campaignIdMap=new Map<String,List<String>>();
        List<PricebookDiscount__c> pbList=new List<PricebookDiscount__c>();
        
        for(PricebookDiscount__c pbObj:[Select id, Spain_Portugal_Campaign__r.Campaign_Id__c from PricebookDiscount__c where Spain_Portugal_Campaign__c!=null]){
            List<String> pbIdList=new List<String>();
            if(!campaignIdMap.containsKey(pbObj.Spain_Portugal_Campaign__r.Campaign_Id__c)){
                pbIdList.add(pbObj.id);
                campaignIdMap.put(pbObj.Spain_Portugal_Campaign__r.Campaign_Id__c,pbIdList);
            }else{
                campaignIdMap.get(pbObj.Spain_Portugal_Campaign__r.Campaign_Id__c).add(pbObj.id);
            } 
        }
        System.debug('campaignIdMap :- '+campaignIdMap);
        
        List<Spain_Portugal_Campaign__c> spCampaignList=[Select id,Start_Date__c,End_Date__c,Campaign_Id__c from Spain_Portugal_Campaign__c where id IN:sPCampaignIds];
        for(Spain_Portugal_Campaign__c spCampaignObj:spCampaignList){
            if(campaignIdMap.containsKey(spCampaignObj.Campaign_Id__c)){
                for(String pbId:campaignIdMap.get(spCampaignObj.Campaign_Id__c)){
                    System.debug('pbId :- '+pbId);
                    PricebookDiscount__c pbObj=new PricebookDiscount__c();
                    pbObj.id=pbId;
                    pbObj.StartDate__c=spCampaignObj.Start_Date__c;
                    pbObj.EndDate__c=spCampaignObj.End_Date__c;
                    pbList.add(pbObj);
                }
            }
        }
        if(pbList.size()>0){
            System.debug('pbList :- '+pbList);
            update pbList;
        }
    }
}