/**************************************************************************************************
* Name               : Grz_SalesOrderNotificationBrazil                                                      
* Test Class         : Grz_SalesOrderNotificationBrazilTest                                                     
* Description        : This class is invoked from Grz_SalesOrderNotificationBrazil Flow to send notification to portal user if Invoice_Status__c changes
* Created Date       : 26/08/2022                                                                 
* JIRA               : APPS-1394                                                        
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/ 
public with sharing class Grz_SalesOrderNotificationBrazil {
    @InvocableMethod(label='Get Sales Order' description='To get All sales Order Records')
    public static void getSalesOrder(list<string> salesOrderId){
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>(); 
        map<id,list<user>> accIdToUserListMap = new map<id,list<user>>();
        Set<Id> accIdSet = new Set<Id>();
        Map<Id,Set<Id>> accIdToIdMap = new Map<Id,Set<Id>>();
        try {
            list<string> orderTypes= new list<string>();
             List<String> allStatus= new  List<String>();
            if(!test.isRunningTest()){
             allStatus = Brazil_Portal_Configuration__c.getOrgDefaults().Portal_Sales_Order_Type__c.split('\n');
            }else{
                allStatus.add('VENDA NORMAL');
            }
            for(String st : allStatus){
                orderTypes.add(st.trim());
            }
            List<Sales_Order__c> salesOrderList = [SELECT Id,Name,Sold_to_Party__c,Sold_to_Party__r.ParentId,Sold_to_Party__r.Sub_Parent_Account__c,Sold_to_Party__r.Name,Invoice_Status__c,Total_Value_Brazil__c,SalesOrderNumber_Brazil__c,CreatedDate,(SELECT Id, Brazil_Product__c,Quantity__c,UnitValue__c FROM Sales_Order_Line_Item__r) FROM Sales_Order__c WHERE Id IN:salesOrderId AND Type_of_Order__c IN: orderTypes];
            for(sales_order__c s: salesOrderList){
                accIdSet.add(s.Sold_to_Party__c);
                accIdSet.add(s.Sold_to_Party__r.ParentId);
                accIdSet.add(s.Sold_to_Party__r.Sub_Parent_Account__c);
                
                Set<Id> tempAcId = new Set <Id>();
                tempAcId.add(s.Sold_to_Party__r.ParentId);
                tempAcId.add(s.Sold_to_Party__r.Sub_Parent_Account__c);
                if(!accIdToIdMap.containsKey(s.Sold_to_Party__c)){
                    accIdToIdMap.put(s.Sold_to_Party__c, tempAcId);
                }else{
                    Set<Id> tempList = accIdToIdMap.get(s.Sold_to_Party__c);
                    tempList.addAll(tempAcId);
                    accIdToIdMap.put(s.Sold_to_Party__c, tempList);
                }
            }
            if( accIdSet != null && !accIdSet.isEmpty()){
                for(User us:[SELECT Id,Email,Name,accountId,Sales_Order_Notification__c,Profile.Name FROM User WHERE Sales_Order_Notification__c=true AND accountId in:accIdSet AND IsActive = true AND IsPortalEnabled = true]){
                    if(!accIdToUserListMap.containsKey(us.accountId)){
                        accIdToUserListMap.put(us.accountId, new List<User>{us});
                    }else{
                        List<User> tempList = accIdToUserListMap.get(us.accountId);
                        tempList.add(us);
                        accIdToUserListMap.put(us.accountId, tempList);
                    } 
                }
            }
            map<id,list<user>> finalUserMap = new map<id,list<user>>();
            for(Id accIds : accIdToIdMap.keySet()){
                List<User> usList = new List<User>();
                for(Id ac : accIdToIdMap.get(accIds)){
                    if(accIdToUserListMap != null && accIdToUserListMap.containsKey(ac)){
                        if(accIdToUserListMap.get(ac) != null){
                           usList.addAll(accIdToUserListMap.get(ac)); 
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
                    if(accIdToUserListMap.get(accIds) != null){
                        finalUserMap.put(accIds, accIdToUserListMap.get(accIds));
                    }
                }else{
                    List<User> tempList = new List<User>();
                    if(finalUserMap.get(accIds) != null){
                        tempList = finalUserMap.get(accIds);
                        if(accIdToUserListMap.get(accIds) != null){
                            tempList.addAll(accIdToUserListMap.get(accIds));
                        }
                        finalUserMap.put(accIds, tempList);
                    }
                }
            }
            if(finalUserMap != null && !finalUserMap.isEmpty()){
                List< OrgWideEmailAddress > orgAddress = [SELECT Id,Address FROM OrgWideEmailAddress WHERE Displayname = 'Sales Excellence'];
                List<Document> docList = [SELECT Id FROM Document WHERE DeveloperName = 'Brazil_Portal_Notification_Alert_Header_Image' LIMIT 1];
                String logoUrl = '';
                if(docList != null && !docList.isEmpty()){
                    logoUrl = System.Url.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id=' + docList[0].Id + '&oid=' + UserInfo.getOrganizationId();
                }
                for(sales_order__c so : salesOrderList){
                    if(finalUserMap.containsKey(so.Sold_to_Party__c) &&  finalUserMap.get(so.Sold_to_Party__c) != null){
                        String orderStatus = '';
                        String orderDate = grz_SapIntegration.FormattedDateBrazil(so.CreatedDate);
                        String orderTotal;
                        if (so.Total_Value_Brazil__c != null){
                            orderTotal = grz_SapIntegration.currencyBrazil(so.Total_Value_Brazil__c);
                        }
                        if (so.Invoice_Status__c == null || so.Invoice_Status__c == 'Pedido em Análise' || so.Invoice_Status__c == 'Crédito Bloqueado' || so.Invoice_Status__c == 'Crédito Liberado'){
                            orderStatus = 'Pedido em Processamento';
                        } else if (so.Invoice_Status__c == 'Faturado' || so.Invoice_Status__c == 'Faturado Parcial'){
                            orderStatus = 'Pedido Faturado';
                        } else{
                            orderStatus = so.Invoice_Status__c;
                        }
                        for(User u : finalUserMap.get(so.Sold_to_Party__c)){
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            mail.setOrgWideEmailAddressId(orgAddress.size() > 0 ? orgAddress[0].Id : null);
                            mail.setSaveAsActivity(false);
                            List<String> emails = new List<String>();
                            emails.add(u.Email);
                            mail.setToAddresses(emails);
                            mail.setSubject('Portal Sua UPL Informa – Pedido ' + so.SalesOrderNumber_Brazil__c + ' Teve Uma Atualização de Status');
                            String emailBody = '<img src="' + logoUrl + '" alt="logo" width="100%" height="120" style="display:block;">' +
                            '<p style="padding:5px 0px; background-color:#f47920;"> </p>' +
                            'Olá '  + u.Name + '!'+ '<br/><br/> '+ 
                            'O pedido ' + so.SalesOrderNumber_Brazil__c + ' está com um novo status: <b>' + orderStatus + '</b><br/> <br/>' +
                            '<b>Detalhes do Pedido</b> <br/> <br/>' +
                            'Pedido realizado em ' + orderDate + '<br/> <br/>' +
                            '<table border="1" style="border-collapse: collapse;">' +
                            '<thead>' +
                                '<tr>' + 
                                    '<th align="left">' + 'Cliente' + '</th>' + 
                                    '<th align="left">' + 'Nome do Produto' + '</th>' + 
                                    '<th align="left">' + 'Quantidade' + '</th>' +
                                    '<th align="left">' + 'Preço Unitário' + '</th>' +
                                '</tr>' +
                            '</thead>' +
                            '<tbody>';
                            String rowData = '';
                            for(Sales_Order_Line_Item__c soli : so.Sales_Order_Line_Item__r){
                                String qunty = soli.Quantity__c != null ? grz_SapIntegration.currencyBrazil(soli.Quantity__c) : '0';
                                String unitValue = soli.UnitValue__c != null ? grz_SapIntegration.currencyBrazil(soli.UnitValue__c) : '0';
                                rowData = rowData + 
                                '<tr>' + 
                                    '<td>' + so.Sold_to_Party__r.Name + '</td>' + 
                                    '<td>' + soli.Brazil_Product__c + '</td>' + 
                                    '<td>' + qunty + '</td>' +
                                    '<td>' + unitValue + '</td>' +
                                '</tr>';
                            }
                            emailBody = emailBody + rowData +
                            '</tbody>' +
                            '</table>'+
                            '<p>Valor total do Pedido: R$ ' + orderTotal + '</p>' +
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
        } catch (Exception ex) {
            system.debug('Exception Grz_SalesOrderNotificationBrazil => ' + ex.getLineNumber()+ '==>' + ex.getCause() + '==>' + ex.getMessage());
        } 
    }
}