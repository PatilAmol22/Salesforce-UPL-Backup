//Created By : Himanshu Mehta
//Description : Class for displaying data in marque tag

public class MyCustomController{
    public List<Information_Blast__c> lstInfoBlast{get;set;}
    public Information_Blast__c a{get;set;}
    
    // Defining constructor
    public MyCustomController() {
        lstInfoBlast = [select Information_1__c, Information_2__c, Information_3__c, Information_4__c,
                        Information_5__c, Information_6__c, Information_7__c, Information_8__c, Information_9__c,
                        Information_10__c,Information_11__c,Information_12__c,Information_13__c,Information_14__c,
                        Information_15__c  
                        from Information_Blast__c 
                        order by createddate desc];
        
        if(lstInfoBlast.isEmpty()){
            a = new Information_Blast__c();
            a.Information_1__c = 'No Information to display';
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Information to display'));
        }
        else{
            a = lstInfoBlast[0];
        }
        System.debug('====Information Blast====='+lstInfoBlast );
    }
    
}