/*
* Name: BatchPricelistCommunication
* Created On: 30 July 2018
* Author: Azhar Shaikh (azhar.shaikh@skinternational.com)
* Description: Batch Class used for sending email with attachments of pdf and csv to community users.
*/
global class BatchPricelistCommunication implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    public String query ='';
    List<String> acntlist{get;set;}
    PageReference pr = null;
    PageReference pr2 =null;
    public String salesorgCode = '';
    String DistributorRecordTypeId ='';
    String rowHeader ='', finalStr ='';
    List<User> userList;
    String comm_id='PartnerCommunity Distributor Profile';
    //IndiaPricelistCommunicationController cont = new IndiaPricelistCommunicationController(acnt.Id);
    global Database.QueryLocator start(Database.BatchableContext BC){
        userList = new List<User>();
        salesorgCode = '1000';
        DistributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        System.debug('DistributorRecordTypeId ---------- '+DistributorRecordTypeId);
        
        /*for(User user:[SELECT Id, Name, AccountId, isPortalEnabled, IsActive, ContactId,UserRole.name,Profile.Name,
                                 Show_Inventory__c, Show_Credit_Limit__c, EnableDepot__c,
                                 Show_Inventory_Column__c, Show_InTransit__c, Show_InTransit_Values__c
                                 FROM User where Profile.Name='PartnerCommunity Distributor Profile' And AccountId!=null And Email!=null]){
                                     
                                 comm_id = user.AccountId;
                                 System.debug('comm_id :--- '+comm_id);
                                
        						}
        
            
        query = 'SELECT Id,  Name, Email__c  FROM Account where Id =\''+comm_id+'\' AND email__c!= null';*/
        // query for distributor account where record type id is equals to distributor record id  
        /*query = 'SELECT Id, Name, Email__c ' ;
        query +='FROM Account where Sales_Org_Code__c =: salesorgCode';
        query +=' AND recordtypeid =: DistributorRecordTypeId';
        query +=' AND email__c!= null  Limit 5';*/
       
        query = 'SELECT Id, Name, Email__c, (SELECT Email FROM Users) FROM Account WHERE id IN (SELECT AccountId FROM User where Profile.Name=\''+comm_id+'\' And AccountId!=null And Email!=null)';
        System.debug('query ---------- '+query);
        return Database.getQueryLocator(query);
        
    }    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        // calling url of pdf vf page
        //System.debug('scope');
        rowHeader = 'Product Description, Material Code, Case Size, MRP per Unit, Billing Price, Placement scheme, Channel Margin,Credit Net Price, GST, Net Price after Invoice Discounts Including GST, Suggested Retailer Price \n';
        finalStr = rowHeader;
        System.debug('scope :- '+scope.size());
        Blob body;
        Blob body2;
        acntlist = new List<String>();
        for(Account acnt : scope){
            System.debug('acount Id :------------------ '+acnt);
            // Account id for testing data
            //String idStr = '0010k000002TXLN';
			//IndiaPricelistCommunicationUIController controller = new IndiaPricelistCommunicationUIController(idStr,'batch');
            
            // Account id for original distributor data
            IndiaPricelistCommunicationUIController controller = new IndiaPricelistCommunicationUIController(acnt.Id,'batch');
            for(IndiaPricelistCommunicationUIController.SKUDetails skudetails: controller.skuDetailsList){
                String invDPer = skudetails.invoiceDiscountPercent +'%';
                System.debug('invDPer :- '+invDPer);
                String speDPer = skudetails.specialDiscoutPercent +'%';
                System.debug('speDPer :- '+speDPer);
                String gstStr = skudetails.GST +'%';
                String colStr = skudetails.brandName + ',' + skudetails.skuCode + ',' +skudetails.packSize +',' +skudetails.price +','+skudetails.price + ','+ invDPer + ',' + speDPer + ',' + skudetails.netRateEntered + ','  + gstStr + ',' + skudetails.netpriceinvoicediscountgst + ','+skudetails.suggestedretailerprice +'\n';
                finalStr = finalStr + colStr;
            }
            
            acntlist.clear();    
            pr = new PageReference('/apex/PdfPricelistCommunication');
            pr2 = new PageReference('/apex/PdfPriceListCommunicationDistributors?acid='+acnt.Id);
            
            
            pr.getParameters().put('id',acnt.Id); 
            //pr2.getParameters().put('acid',acnt.Id);
            
            for(User userObj:acnt.Users){
                acntlist.add(userObj.Email);
                
            }
            //acntlist.add('azhar.shaikh@skinternational.com');
            
            try{ 
                if(Test.isRunningTest()){
                    body =  blob.valueOf('Unit.Test');
                    body2= blob.valueOf('Unit2.Test');
                }else{
                    body =  pr.getContent();
                    body2 =  pr2.getContent();
                }
                
                Messaging.EmailFileAttachment attachPdf = new Messaging.EmailFileAttachment();
                Messaging.EmailFileAttachment attachPdfDistributors = new Messaging.EmailFileAttachment();
                Messaging.EmailFileAttachment attachCsv = new Messaging.EmailFileAttachment();
                
                // Attachment for pdf
                attachPdf.setContentType('application/pdf');
                attachPdf.setInline(false);
                attachPdf.setFileName('circular_ Ahmedabad.pdf');
                attachPdf.Body = body;
                
                // Attachment for pdf Distributors
                attachPdfDistributors.setContentType('application/pdf');
                attachPdfDistributors.setInline(false);
                attachPdfDistributors.setFileName('PriceList_Communication_Distributors.pdf');
                attachPdfDistributors.Body = body2;
                
                // Attachment for csv 
                Blob csvblb= Blob.valueOf(finalStr);
                attachCsv.setFileName('Pricelistcommunication.csv');
                attachCsv.setBody(csvblb);
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(acntlist);
               	mail.setSubject('Upl India Pricelist Communication');
                mail.setSaveAsActivity(false);
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attachPdf,attachPdfDistributors,attachCsv}); //attachPdfDistributors
                mail.setPlainTextBody('The batch Apex job completed');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                
            }catch(VisualforceException  e){
                body = Blob.valueOf('Some Text');
            } 
            
        }
    }    
    global void finish(Database.BatchableContext BC){
        
    }
    
}