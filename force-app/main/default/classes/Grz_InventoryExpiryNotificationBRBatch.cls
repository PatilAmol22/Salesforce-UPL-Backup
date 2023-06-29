/**************************************************************************************************
* Name               : Grz_InventoryExpiryNotificationBRBatch                                                      
* Test Class         : Grz_InventoryExpiryNotificationTest                                               
* Description        : This is schedular batch that will send email alert to brazil community users when a product is about to expire
* Created Date       : 26/08/2022                                                                 
* JIRA               : APPS-1394                                                        
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/
global class Grz_InventoryExpiryNotificationBRBatch implements Database.Batchable<sObject>, Schedulable{
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Boolean doNotExecute = Brazil_Portal_Configuration__c.getOrgDefaults().Bolck_Invenytory_Notification__c;
        if(!doNotExecute){
            Decimal days = Brazil_Portal_Configuration__c.getOrgDefaults().Inventory_Expiration_Days__c;
            Integer expiryDays = days != null ? Integer.valueOf(days) : 0;
            Date todayDate = System.today();
            Date expiryDate = todayDate.addDays(expiryDays);
            String queryString = 'SELECT Id,Report_Date__c,Storage__c,UPL_Sale_Note__c,Name_And_City__c, CNPJ_Client__c,Product_Name__c,Batch__c,Batch_Expiry_Date__c,Current_Balance_Qty__c,Current_Balance_Value__c,AG_Remaining_Days__c FROM Stock_Management__c WHERE Batch_Expiry_Date__c =:expiryDate order by CNPJ_Client__c desc';
            return Database.getQueryLocator(queryString);
        }else{
            String queryString = 'SELECT Id from User LIMIT 0';
            return Database.getQueryLocator(queryString);
        }
    }
    global void execute(Database.BatchableContext bc, List<Stock_Management__c> scope){
        Set<String> taxSet = new Set<String>();
        Map<String, List<Stock_Management__c>> taxNoToStockListMap = new Map<String, List<Stock_Management__c>>();
        for (Stock_Management__c st : scope) {
            taxSet.add(st.CNPJ_Client__c);
            if(!taxNoToStockListMap.containsKey(st.CNPJ_Client__c)){
                taxNoToStockListMap.put(st.CNPJ_Client__c, new List<Stock_Management__c>{st});
            }else{
                List<Stock_Management__c> tempList = taxNoToStockListMap.get(st.CNPJ_Client__c);
                tempList.add(st);
                taxNoToStockListMap.put(st.CNPJ_Client__c, tempList);
            }
        }
        if(taxSet != null && !taxSet.isEmpty()){
            Set<String> accIdSet = new Set<String>();
            Map<string,Set<String>> taxMap = new Map<string,Set<String>>();
            List<Account> accountList = [SELECT Id,Tax_Number_Br_Portal_Filter__c,Parent.Tax_Number_Br_Portal_Filter__c,Sub_Parent_Account__r.Tax_Number_Br_Portal_Filter__c FROM Account WHERE Tax_Number_Br_Portal_Filter__c IN:taxSet AND RecordType.DeveloperName = 'Distributor' AND Sales_Org_Code__c = '5191'];
            for(Account acc : accountList){
                accIdSet.add(acc.Tax_Number_Br_Portal_Filter__c);
                accIdSet.add(acc.Parent.Tax_Number_Br_Portal_Filter__c);
                accIdSet.add(acc.Sub_Parent_Account__r.Tax_Number_Br_Portal_Filter__c);

                Set<string> tempAcId = new Set <string>();
                tempAcId.add(acc.Parent.Tax_Number_Br_Portal_Filter__c);
                tempAcId.add(acc.Sub_Parent_Account__r.Tax_Number_Br_Portal_Filter__c);
                if(!taxMap.containsKey(acc.Tax_Number_Br_Portal_Filter__c)){
                    taxMap.put(acc.Tax_Number_Br_Portal_Filter__c, tempAcId);
                }else{
                    Set<String> tempList = taxMap.get(acc.Tax_Number_Br_Portal_Filter__c);
                    tempList.addAll(tempAcId);
                    taxMap.put(acc.Tax_Number_Br_Portal_Filter__c, tempList);
                }
            }
            map<String,list<user>> userMap = new map<String,list<user>>();
            if(accIdSet != null && !accIdSet.isEmpty()){
                for(User us : [SELECT Id, Email, Name,AccountId,Account.Tax_Number_Br_Portal_Filter__c FROM User WHERE Inventory_Expiry_Notification__c = true AND IsActive = true AND IsPortalEnabled = true AND Account.Tax_Number_Br_Portal_Filter__c IN : accIdSet ]){
                    if(!userMap.containsKey(us.Account.Tax_Number_Br_Portal_Filter__c)){
                        userMap.put(us.Account.Tax_Number_Br_Portal_Filter__c, new List<User>{us});
                    }else{
                        List<User> tempList = userMap.get(us.Account.Tax_Number_Br_Portal_Filter__c);
                        tempList.add(us);
                        userMap.put(us.Account.Tax_Number_Br_Portal_Filter__c, tempList);
                    } 
                }
            }  
            if(taxMap != null && !taxMap.isEmpty()){
                map<String,list<user>> finalUserMap = new map<String,list<user>>();
                for(String accIds : taxMap.keySet()){
                    List<User> usList = new List<User>();
                    for(String ac : taxMap.get(accIds)){
                        if(userMap != null && userMap.containsKey(ac)){
                            if(userMap.get(ac) != null){
                               usList.addAll(userMap.get(ac)); 
                            }
                        }
                    }
                    if(usList != null && !usList.isEmpty()){
                        List<User> tempList = new List<User>();
                        if(finalUserMap.get(accIds) != null){
                            tempList = finalUserMap.get(accIds);
                        }
                        tempList.addAll(usList);
                        finalUserMap.put(accIds, tempList);
                    }
                    if(!finalUserMap.containsKey(accIds)){
                        if(userMap.get(accIds) != null){
                            finalUserMap.put(accIds, userMap.get(accIds));
                        }
                    }else{
                        List<User> tempList = new List<User>();
                        if(finalUserMap.get(accIds) != null){
                            tempList = finalUserMap.get(accIds);
                            if(userMap.get(accIds) != null){
                                tempList.addAll(userMap.get(accIds));
                            }
                            finalUserMap.put(accIds, tempList);
                        }
                    }
                }
                if(taxNoToStockListMap != null && !taxNoToStockListMap.isEmpty()){
                    List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
                    List< OrgWideEmailAddress > orgAddress = [SELECT Id,Address FROM OrgWideEmailAddress WHERE Displayname = 'Sales Excellence'];
                    List<Document> docList = [SELECT Id FROM Document WHERE DeveloperName = 'Brazil_Portal_Notification_Alert_Header_Image' LIMIT 1];
                    String logoUrl = '';
                    if(docList != null && !docList.isEmpty()){
                        logoUrl = System.Url.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id=' + docList[0].Id + '&oid=' + UserInfo.getOrganizationId();
                    }
                    for(String st : finalUserMap.keySet()){
                        for(User usr : finalUserMap.get(st)){
                            if(taxNoToStockListMap.get(st) != null){
                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                mail.setOrgWideEmailAddressId(orgAddress.size() > 0 ? orgAddress[0].Id : null);
                                mail.setSaveAsActivity(false);
                                List<String> emails = new List<String>();
                                emails.add(usr.Email);
                                mail.setToAddresses(emails);
                                mail.setSubject('Portal Sua UPL Informa – Produtos em AG Próximos ao Vencimento');
                                String emailBody = '<img src="' + logoUrl + '" alt="logo" width="100%" height="120" style="display:block;">' +
                                '<p style="padding:5px 0px; background-color:#f47920;"> </p>' +
                                'Olá '  + usr.Name + '!'+ '<br/><br/> '+ 
                                'Alguns produtos que estão em AG estão próximos da data de vencimento. <br/> <br/>' +
                                'Por favor veja a lista abaixo para sua referência: <br/> <br/>' +
                                '<table border="1" style="border-collapse: collapse;">' +
                                    '<thead>' +
                                        '<tr>' + 
                                            '<th align="left">' + 'Armazém' + '</th>' + 
                                            '<th align="left">' + 'Cliente' + '</th>' + 
                                            '<th align="left">' + 'Nome do Produto' + '</th>' +
                                            '<th align="left">' + 'Lote' + '</th>' +
                                            '<th align="left">' + 'Data Validade Lote' + '</th>' +
                                            '<th align="left">' + 'Qtde Saldo Atual' + '</th>' +
                                            '<th align="left">' + 'Valor Saldo Atual (BRL)' + '</th>' +
                                        '</tr>' +
                                    '</thead>' +
                                    '<tbody>';
                                String rowData = '';
                                for(Stock_Management__c stock : taxNoToStockListMap.get(st)){
                                    String prodExpiryDate = grz_SapIntegration.FormattedDateBrazil(stock.Batch_Expiry_Date__c);
                                    rowData = rowData + 
                                    '<tr>' + 
                                        '<td>' + stock.Storage__c + '</td>' + 
                                        '<td>' + stock.Name_And_City__c + '</td>' + 
                                        '<td>' + stock.Product_Name__c + '</td>' +
                                        '<td>' + stock.Batch__c + '</td>' +
                                        '<td>' + prodExpiryDate + '</td>' +
                                        '<td>' + stock.Current_Balance_Qty__c + '</td>' +
                                        '<td>' + stock.Current_Balance_Value__c + '</td>' +
                                    '</tr>';
                                }
                                emailBody = emailBody + rowData +
                                '</tbody>' +
                                '</table> <br/>'+
                                '<p style="color:red; font-weight:bold;">Os dados constantes acima são meras referências e estão sujeitos à confirmação e/ou alteração pela UPL.</p>' +
                                '<p style="text-align:center;"> <a href="https://uconnect.openag.net/uplpartnerportal/s/" target="__blank" style="text-decoration:none;">' +
                                '<button style="cursor:pointer;border:none;background-color:#f47920;padding: 5px 25px;color:#fff;">Acessar o Portal</button></a></p>' +
                                'Atenciosamente,' + '<br/><br/>' + 'UPL' +
                                '<p style="padding:5px 0px; background-color:#f47920;"> </p>';
                                mail.setHtmlBody(emailBody);
                                emailList.add(mail);
                            }
                        }
                    }
                    
                    if( emailList != null && !emailList.isEmpty() ){
                        Messaging.SendEmailResult[] results = Messaging.sendEmail( emailList );
                    }
                }
            }         
        }  
    }
    global void finish(Database.BatchableContext bc){
    }
    
    global void execute(SchedulableContext sc) {
        Grz_InventoryExpiryNotificationBRBatch b = new Grz_InventoryExpiryNotificationBRBatch(); 
        database.executebatch(b);
    }
}