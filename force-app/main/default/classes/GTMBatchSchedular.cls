/*******************************************************************************************
* @Name         GTMBatchSchedular
* @Author       Vishal Pawar <vishal.pawar@skinternational.com>
* @Date         05/04/2022
* @Group        SKI
* @Description  This class execute when gtm details not submitted
this batch class calling from Schedular 'GTMSchedular'
*******************************************************************************************/

global class GTMBatchSchedular implements Database.Batchable<sObject>,Database.Stateful {
    
    MAP<String,List<GTM_Details__c>> gtmMap = new MAP<String,List<GTM_Details__c>>();    
    MAP<String,String> emailUserMap = new MAP<String,String>();
    
    List<GTM_Details__c> gtmList {get; set;} 
    List<String> emailtestId ;
    List<String> emailtestIdDist ;
    
    global GTMBatchSchedular(){
        emailtestId = new List<String>();
        emailtestIdDist = new List<String>();
        gtmList =[SELECT Id,GTM_Customer__r.Name,GTM_Customer__c,GTM_Customer__r.Lead_Customer_Ownership__r.Email,
                  GTM_Customer__r.RecordType.Name,GTM_Customer__r.SAP_Code__c,GTM_Customer__r.Lead_Customer__c,GTM_Customer__r.Owner.Email,
                  Name,isSubmitted__c,GTM_Customer__r.Owner.Name,GTM_Customer__r.Lead_Customer_Ownership__r.Name 
                  FROM GTM_Details__c 
                  WHERE isSubmitted__c = false];
        System.debug('gtmList '+gtmList.size());
    }
    
    
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Set<String> emailIdList = new Set<String>();
        
        if(gtmList.size()>0){
            for(GTM_Details__c gtmObj :gtmList){
                if(gtmObj.GTM_Customer__r.RecordType.Name=='Distributor'){
                    emailIdList.add(gtmObj.GTM_Customer__r.Owner.Email);
                    emailUserMap.put(gtmObj.GTM_Customer__r.Owner.Email,gtmObj.GTM_Customer__r.Owner.Name);
                    if(!gtmMap.containsKey(gtmObj.GTM_Customer__r.Owner.Email)){
                        List<GTM_Details__c> gtmTempList = new List<GTM_Details__c>();
                        gtmTempList.add(gtmObj);
                        gtmMap.put(gtmObj.GTM_Customer__r.Owner.Email,gtmTempList);
                        
                    }else{
                        List<GTM_Details__c> prbList = new List<GTM_Details__c>();
                        prbList = gtmMap.get(gtmObj.GTM_Customer__r.Owner.Email); 
                        prbList.add(gtmObj);
                        gtmMap.put(gtmObj.GTM_Customer__r.Owner.Email,prbList);
                        
                    }
                }
                if(gtmObj.GTM_Customer__r.RecordType.Name=='Lead Customer'){
                    emailIdList.add(gtmObj.GTM_Customer__r.Lead_Customer_Ownership__r.Email); 
                    emailUserMap.put(gtmObj.GTM_Customer__r.Lead_Customer_Ownership__r.Email,gtmObj.GTM_Customer__r.Lead_Customer_Ownership__r.Name);
                    if(!gtmMap.containsKey(gtmObj.GTM_Customer__r.Lead_Customer_Ownership__r.Email)){
                        List<GTM_Details__c> gtmTempList = new List<GTM_Details__c>();
                        gtmTempList.add(gtmObj);
                        gtmMap.put(gtmObj.GTM_Customer__r.Lead_Customer_Ownership__r.Email,gtmTempList);
                    }else{
                        List<GTM_Details__c> prbList = new List<GTM_Details__c>();
                        prbList = gtmMap.get(gtmObj.GTM_Customer__r.Lead_Customer_Ownership__r.Email); 
                        prbList.add(gtmObj);
                        gtmMap.put(gtmObj.GTM_Customer__r.Lead_Customer_Ownership__r.Email,prbList);                        
                    }
                    
                }
                
            }
        }//if condiotn check ends
        
        String query = 'SELECT Id,GTM_Customer__r.Name,GTM_Customer__c,GTM_Customer__r.Lead_Customer_Ownership__r.Email, GTM_Customer__r.RecordType.Name,GTM_Customer__r.SAP_Code__c,GTM_Customer__r.Lead_Customer__c,GTM_Customer__r.Owner.Email, Name,isSubmitted__c,GTM_Customer__r.Owner.Name,GTM_Customer__r.Lead_Customer_Ownership__r.Name FROM GTM_Details__c WHERE isSubmitted__c = false';
        return Database.getQueryLocator(query); 
    }
    global void execute(Database.BatchableContext bc, List<sObject> scope){
        for(Sobject scp : scope){
            GTM_Details__c gtmObj = (GTM_Details__c)scp;
            if(gtmObj.GTM_Customer__r.RecordType.Name=='Lead Customer'){
                if(!emailtestId.contains(gtmObj.GTM_Customer__r.Lead_Customer_Ownership__r.Email)){
                    List<GTM_Details__c> gtmdetList = gtmMap.get(gtmObj.GTM_Customer__r.Lead_Customer_Ownership__r.Email);               
                    String body = '' ;
                    body = BodyFormat(gtmdetList,gtmObj.GTM_Customer__r.Lead_Customer_Ownership__r.Email) ;                
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage() ;                
                    String[] toAddresses = new String[] {gtmObj.GTM_Customer__r.Lead_Customer_Ownership__r.Email} ;
                        // String[] toAddresses = new String[] {'vishal.pawar@skinternational.com'} ;                    
                        mail.setToAddresses(toAddresses) ;                
                    mail.setSubject('Pathfinder Notification');                
                    mail.setHtmlBody(body);                
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    emailtestId.add(gtmObj.GTM_Customer__r.Lead_Customer_Ownership__r.Email); 
                }
             }
            if(gtmObj.GTM_Customer__r.RecordType.Name=='Distributor'){
                if(!emailtestIdDist.contains(gtmObj.GTM_Customer__r.Owner.Email)){
                    List<GTM_Details__c> gtmdetList = gtmMap.get(gtmObj.GTM_Customer__r.Owner.Email);
                    String body = '' ;
                    body = BodyFormat(gtmdetList,gtmObj.GTM_Customer__r.Owner.Email); 
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String[] toAddresses = new String[] {gtmObj.GTM_Customer__r.Owner.Email} ;               
                        mail.setToAddresses(toAddresses) ;                
                    mail.setSubject('Pathfinder Notification');                
                    mail.setHtmlBody(body);                
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });      
                    emailtestIdDist.add(gtmObj.GTM_Customer__r.Owner.Email);        
                }
            }
            
            
        }
        
        
    }    
    global void finish(Database.BatchableContext bc){
        
    }  
    
    public String BodyFormat(List<GTM_Details__c> gtDeList,String emailId){
        System.debug('lst size '+gtDeList.size());
        SET<String> strAccName = new SET<String>();
        String str = '' ;
        for(GTM_Details__c gtObj : gtDeList){
            if(gtObj.GTM_Customer__r.RecordType.Name=='Lead Customer'){
                
                strAccName.add(gtObj.GTM_Customer__r.Name+'-'+gtObj.GTM_Customer__r.Lead_Customer__c );                    
            }
            if(gtObj.GTM_Customer__r.RecordType.Name=='Distributor'){
                strAccName.add(gtObj.GTM_Customer__r.Name+'-'+gtObj.GTM_Customer__r.SAP_Code__c);                        
            }
        }
        System.debug('strAccName '+strAccName);
        
        Integer Month = Date.Today().Month();
        //Apr 2022 - March 2023,
        String fiscalYear='';
        if(Month==1 || Month==2 || Month==3 ){
            Date dat = System.today();
            Integer yr = dat.year()-1;
            Integer nextYr = dat.year();  
            fiscalYear ='April '+yr+' - March '+nextYr ;
        }else{
            Date dat = System.today();
            Integer yr = dat.year();
            Integer nextYr = dat.year()+1;  
            fiscalYear ='April '+yr+' - March '+nextYr ;    
        }
        //emailUserMap
        String userName = emailUserMap.get(emailId);
        String emailBody ='Dear '+userName+', <br/><br/>For current financial year '+fiscalYear+', pathfinder details for below lead customers are pending. <br/>Please submit the path finder details at the earliest.<table border="1px;"><tr><th>Lead Code/SAP Code</th><th>Customer Description</th></tr>';
        for(String strs :strAccName){
            List<String> lstAlpha = strs.split('-');
            emailBody+= '<tr><td style="text-align:left">'+lstAlpha[1]+'</td><td style="text-align:left">'+lstAlpha[0]+'</td></tr>';
        }
        emailBody+= '</table><br/><br/>Regards, <br/>Salesforce UPL Administration';
        
        return emailBody;
    }
}