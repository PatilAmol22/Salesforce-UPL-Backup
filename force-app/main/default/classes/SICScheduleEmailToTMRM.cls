/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This Schedule apex is used for SIC sending reminder email before 5 ans 2 days
*
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Swapnil More   <swapnil.more@in.ibm.com>
* @modifiedBy     Swapnil More   <swapnil.more@in.ibm.com>
* @maintainedBy   Swapnil More   <swapnil.more@in.ibm.com>
* @version        1.0
* @created        2020-07-08
* @modified       2020-07-08
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
*                 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
global class SICScheduleEmailToTMRM implements Schedulable{
    
    global void execute(SchedulableContext ctx) {
        try{
            set<string> setEmailIds = new set<string>(); //set to store all email ids
            list<string> liEmailIds = new list<string>();
            for (Territory_Distributor__c TD : [select TerritoryManager__r.email,Region__r.RegionHead__r.email from Territory_Distributor__c 
                                                where Sales_Org_Code__c = '5191']){// and id = 'a1L0K00000ioFcoUAE'
                                                    if(string.isNotBlank(TD.TerritoryManager__r.email))
                                                        setEmailIds.add(TD.TerritoryManager__r.email);//Email Id of Territory Manager
                                                    if(string.isNotBlank(TD.Region__r.RegionHead__r.email))
                                                        setEmailIds.add(TD.Region__r.RegionHead__r.email);//Email Id of Regional Manager
                                                }
            UPL_Settings__c salesOrgDetailsCC = UPL_Settings__c.getInstance();
            String CompanyCode = string.valueOf(integer.valueOf(salesOrgDetailsCC.Visibility_Date__c));
            liEmailIds.addAll(setEmailIds);
            
            system.debug(liEmailIds.size());
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> ();//List of messages
            integer count = 0;
            for(integer j = 0; j<liEmailIds.size()/100; j++){
                list<string> liEmailIdsSubset = new list<string>();
                for(integer i = count; i< count+99; i++){
                    liEmailIdsSubset.add(liEmailIds[i]);
                }
                System.debug('liEmailIdsSubset>>>'+liEmailIdsSubset);
                Messaging.SingleEmailMessage message = messageFormation(liEmailIdsSubset);
                messages.add(message);
                count = count+100;
            }
            //edited by grazitti on 10th Jan 2022 >>> ticket >>> INC0260310 >>> removed extra for loop
			list<string> liEmailIdsSubset2 = new list<string>();
            for(integer i = count; i<liEmailIds.size(); i++){
                liEmailIdsSubset2.add(liEmailIds[i]);
            }
            
            System.debug('liEmailIdsSubset2>>>'+liEmailIdsSubset2);
            Messaging.SingleEmailMessage message = messageFormation(liEmailIdsSubset2);
            messages.add(message);
            System.debug('messages>>>'+messages);
            System.debug(messages.size());
            
            // grazitti edited code ends here >>> 10th Jan 2022
            
            
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }
        catch(Exception e){
            system.debug('Exception :'+e.getLineNumber()+' '+e.getMessage());
        }
    }
    
    public static Messaging.SingleEmailMessage messageFormation(list<string> liEmailIdsSubset){
        UPL_Settings__c salesOrgDetailsCC = UPL_Settings__c.getInstance();
        String CompanyCode = string.valueOf(integer.valueOf(salesOrgDetailsCC.Visibility_Date__c));
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = liEmailIdsSubset;
        //message.bccaddresses = liEmailIds; //BCC compliance error
        message.optOutPolicy = 'FILTER';
        message.subject = 'Dados de Estoque no Canal – Prazo Próximo do Final';
        string body = 'Prezado(a), \n \n';
        body = body + 'Está é uma mensagem automática gerada pelo sistema para informar que o prazo para inclusão das informações de Estoque no canal deste período se encerra em ';
        body = body+ CompanyCode+'/'+date.today().month()+'/'+date.today().Year()+ ' \n \n';
        body = body + 'Por favor verificar e enviar os dados para aprovação o quanto antes. \n\n';
        body = body + 'Obrigado.';
        message.plainTextBody = body;
        
        return message;
        
    }
    
}