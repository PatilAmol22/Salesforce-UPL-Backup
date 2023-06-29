global class KYCSChedular Implements Schedulable {
    
    public List<KYC__c> lstKyc = new List<KYC__c>();
    global void execute(SchedulableContext sc)
    {
        KYCBatch btc = new KYCBatch();
        Database.executeBatch(btc,1); 
    }
    
}