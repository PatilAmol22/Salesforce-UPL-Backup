@RestResource(urlmapping = '/accountdetails/')
global without sharing class GetAccountDetails {
    @HttpPost
    global static void postRequestValue(){
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String jsonBody=req.requestBody.toString();
        JSONParser parser=JSON.createParser(jsonBody);
        String fieldName,fieldValue,phone,callid;
        while(parser.nextToken()!=null)
        {
            if(parser.getCurrentToken()!=JSONToken.END_OBJECT)
            {
                fieldName=parser.getCurrentName();
                fieldValue=parser.getText();
                if(fieldName!=fieldValue)
                {
                    if(fieldName=='Phone')
                    {
                        phone=fieldValue;
                    }
                    else if(fieldName=='Call Id')
                    {
                        callid=fieldValue;
                    }
                }
                
            }
        }
        String newPhone='%'+phone;
        List<Genesys_Details__c> genDetLst=new List<Genesys_Details__c>();
        List<Account> regisAccLst=new List<Account>();
        List<Account> langAccLst=new List<Account>();
        //List<String> phoneLst=setPhoneNumbers(phone);
        //List<Account> accLst=new List<Account>();
        List<Account> accLst=[select id,name,StateName__c,State__pc,
                              Preferred_Language__pc,Language__c,recordType.name,Abusive_Caller__c,KYC_Status__c,Registration_Status__pc,Retailer_Registration_Status__c from Account where Mobile__c like :newPhone or PersonMobilePhone like :newPhone];//mobile__c
        //List<List<sObject>> soslQueryResult=search.query('FIND \''+phone+'\' IN PHONE FIELDS RETURNING Account (id,name,Preferred_Language__pc,Language__c,Abusive_Caller__c,KYC_Status__c,Call_Id__c)');
        //List<Account> accLst=(List<Account>)soslQueryResult[0];
        //Village__pc,Village__c,Village_Pin_Code__pc,Village_Postal_Code__c,District__pc,District__c,State__pc,State__c,Tehsil__pc,Tehsil__c,State_Language__pc,
        //List<Account> accLst=new List<Account>();
        String stateNameVal1='';
        String stateNameVal2='';
        String finalStateName='';
        String promoFlag='No';
        JSONGenerator bodyBuilder = JSON.createGenerator(false);
        bodyBuilder.writeStartObject();
        bodyBuilder.writeFieldName('Accounts');
        bodyBuilder.writeStartArray();
        if(accLst.size()>0)
        {
            
            for(Account eachAcc:accLst)
            {
                Genesys_Details__c eachGenDet=new Genesys_Details__c();
                String regStatus=eachAcc.Registration_Status__pc!=null?eachAcc.Registration_Status__pc:eachAcc.Retailer_Registration_Status__c!=null?eachAcc.Retailer_Registration_Status__c:'';
                String lang=eachAcc.Preferred_Language__pc!=null?eachAcc.Preferred_Language__pc:eachAcc.Language__c!=null?eachAcc.Language__c:'';
                if(String.isNotBlank(lang) && regStatus.contains('Fully Registered'))
                {
                    regisAccLst.add(eachAcc);
                    stateNameVal1=eachAcc.State__pc!=null?eachAcc.State__pc:eachAcc.StateName__c!=null?eachAcc.StateName__c:stateNameVal1;
                }
                if(String.isNotBlank(lang))
                {
                    langAccLst.add(eachAcc);
                    stateNameVal2=eachAcc.State__pc!=null?eachAcc.State__pc:eachAcc.StateName__c!=null?eachAcc.StateName__c:stateNameVal2;
                }
                eachGenDet.Account__c=eachAcc.id;
                eachGenDet.Call_Id__c=callid;
                genDetLst.add(eachGenDet);
            }
            finalStateName=stateNameVal1!=''?stateNameVal1:stateNameVal2!=''?stateNameVal2:'';
            List<State__c> stateLst=new List<State__c>();
            if(String.isNotEmpty(finalStateName))
            {
                stateLst=[select id,Name,Offer_Promotion_Available__c from State__c where Name=:finalStateName and Country__c='India'];
            }
            if(stateLst.size()>0)
            {
                if(stateLst[0].Offer_Promotion_Available__c==true)
                {
                    promoFlag='Yes';
                }
            }
            
            if(regisAccLst.size()>0)
            {
                for(Account eachAcc:regisAccLst)
                {
                    String lang=eachAcc.Preferred_Language__pc!=null?eachAcc.Preferred_Language__pc:eachAcc.Language__c!=null?eachAcc.Language__c:'';
                    
                    bodyBuilder.writeStartObject();
                    bodyBuilder.writeStringField('Id', String.valueOf(eachAcc.id));
                    bodyBuilder.writeStringField('Name', eachAcc.name);
                    bodyBuilder.writeStringField('Phone', phone);
                    bodyBuilder.writeStringField('PreferredLanguage', lang);
                    //bodyBuilder.writeStringField('RecordType', eachAcc.recordType.name );
                    bodyBuilder.writeBooleanField('AbusiveFlag', eachAcc.Abusive_Caller__c);
                    String kyc=eachAcc.KYC_Status__c!=null?eachAcc.KYC_Status__c:eachAcc.KYC_Status__c!=null?eachAcc.KYC_Status__c:'';
                    bodyBuilder.writeStringField('KYCStatus', kyc);
                    bodyBuilder.writeStringField('PromoFlag', promoFlag);
                    bodyBuilder.writeEndObject();
                }
                
            }
            else if(langAccLst.size()>0)
            {
                for(Account eachAcc:langAccLst)
                {
                    String lang=eachAcc.Preferred_Language__pc!=null?eachAcc.Preferred_Language__pc:eachAcc.Language__c!=null?eachAcc.Language__c:'';
                    
                    bodyBuilder.writeStartObject();
                    bodyBuilder.writeStringField('Id', String.valueOf(eachAcc.id));
                    bodyBuilder.writeStringField('Name', eachAcc.name);
                    bodyBuilder.writeStringField('Phone', phone);
                    bodyBuilder.writeStringField('PreferredLanguage', lang);
                    //bodyBuilder.writeStringField('RecordType', eachAcc.recordType.name );
                    bodyBuilder.writeBooleanField('AbusiveFlag', eachAcc.Abusive_Caller__c);
                    String kyc=eachAcc.KYC_Status__c!=null?eachAcc.KYC_Status__c:eachAcc.KYC_Status__c!=null?eachAcc.KYC_Status__c:'';
                    bodyBuilder.writeStringField('KYCStatus', kyc);
                    bodyBuilder.writeStringField('PromoFlag', promoFlag);
                    bodyBuilder.writeEndObject();
                }
            }
            
        }
        bodyBuilder.writeEndArray();
        bodyBuilder.writeEndObject();
        res.responseBody=Blob.valueOf(bodyBuilder.getAsString());
        if(callid!=null && callid!='' && genDetLst.size()>0)
        {
            insert genDetLst;
        }
        
        
        
    }
    
    /*public static List<String> setPhoneNumbers(String phoneVal)
{
List<String> phoneLst=new List<String>();
String p1='91'+phoneVal;
String p2='+91'+phoneVal;
phoneLst.add(p1);
phoneLst.add(p2);
phoneLst.add(phoneVal);
return phoneLst;
}*/
}