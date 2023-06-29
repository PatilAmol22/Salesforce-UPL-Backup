trigger ContentDisteventTrigger  on ContentDist__e (after insert) {      
    
    if(trigger.IsAfter && trigger.IsInsert){  
        List<ContentDistribution> cdList=new List<ContentDistribution>();
        System.debug('inside contentdis event trigger');
        for(ContentDist__e contd: Trigger.New){
            ContentDistribution cd=new ContentDistribution();
            cd.ContentVersionId=contd.ContentVersionId__c;
            cd.Name=contd.ContentTitle__c;
            cdList.add(cd);            
        }
        System.debug('cdList==>'+cdList);
        if(!cdList.isEmpty()){
            insert cdList;
        }        
    }    
}