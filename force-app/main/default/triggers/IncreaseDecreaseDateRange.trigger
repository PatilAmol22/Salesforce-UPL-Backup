trigger IncreaseDecreaseDateRange on Increase_Decrease_Percentage__c (before insert) {
    
    List<Increase_Decrease_Percentage__c>oldList = [SELECT Name, Start_Date__c,Status__c, End_Date__c,CurrencyIsoCode FROM Increase_Decrease_Percentage__c ORDER BY CreatedDate DESC LIMIT 9999];

for(Increase_Decrease_Percentage__c newRecord: (List<Increase_Decrease_Percentage__c>)Trigger.new){
    for(Increase_Decrease_Percentage__c oldData : oldList ) {
        if(newRecord.CurrencyIsoCode == oldData.CurrencyIsoCode && oldData.Status__c != 'Rejected'){
        if(((newRecord.Start_Date__c >= oldData.Start_Date__c && newRecord.Start_Date__c < oldData.End_Date__c) || 
        (newRecord.End_Date__c > oldData.Start_Date__c && newRecord.End_Date__c <= oldData.End_Date__c)))  {

            //your code goes here
            newRecord.addError('Range of Date is duplicate'); 
        }
        }
    }
}


}