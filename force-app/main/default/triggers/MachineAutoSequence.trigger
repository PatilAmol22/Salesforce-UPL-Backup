trigger MachineAutoSequence on Machine__c (before insert) {
    if(Trigger.isinsert && Trigger.isBefore){
        Map<string,Auto_Number__c> mapCodes = Auto_Number__c.getAll();  
        Integer sequenceNo = Integer.valueOf(mapCodes.get('MachineCode').Sequence__c);
        for(Machine__c obj:Trigger.New){
            sequenceNo++;
            obj.Machine_Code__c = 'MC0'+String.valueOf(sequenceNo);
        }
        Auto_Number__c autObj = mapCodes.get('MachineCode');
        autObj.Sequence__c = String.valueof(sequenceNo);
        update autObj ;
    }
}