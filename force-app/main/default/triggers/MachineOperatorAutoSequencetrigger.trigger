trigger MachineOperatorAutoSequencetrigger on Machine_Operator__c (before insert) {
    if(Trigger.isinsert && Trigger.isBefore){
        Map<string,Auto_Number__c> mapCodes = Auto_Number__c.getAll();  
        Integer sequenceNo = Integer.valueOf(mapCodes.get('MachineOperatorCode').Sequence__c);
        for(Machine_Operator__c obj:Trigger.New){
            sequenceNo++;
            obj.Machine_Operator_Code__c = 'MOC0'+String.valueOf(sequenceNo);
        }
        Auto_Number__c autObj = mapCodes.get('MachineOperatorCode');
        autObj.Sequence__c = String.valueof(sequenceNo);
        update autObj ;
    }
}