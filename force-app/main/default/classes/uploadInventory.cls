/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* called from Lightning Component 
*
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Manisha Yadav   <myadava1@in.ibm.com>
* @modifiedBy     Manisha Yadav   <myadava1@in.ibm.com>
* @maintainedBy   Manisha Yadav   <myadava1@in.ibm.com>
* @version        1.0
* @created        2020-02-03
* @modified       2020-03-03
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
*                 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

public without sharing class uploadInventory{
 
 @AuraEnabled
    public static String getDocument()
  {
       
        List<document> DocumentList = new List<document>(); 
        String Templatefile = '/servlet/servlet.FileDownload?file=';
        String newTemplatefile;
        DocumentList = [select Name from document where Name = 'Modelo de upload de inventário'];
        if(DocumentList.size()>0){
            newTemplatefile = Templatefile+DocumentList[0].Id;
            system.debug('checktemplate '+newTemplatefile);
        }
        return newTemplatefile;
    }
 
 
 public class errorWrapper {
       @AuraEnabled
        public Integer recordno {get;set;}
        @AuraEnabled
        public string wareHouseCode {get;set;}
        @AuraEnabled
        public string SKUCode {get;set;}
        @AuraEnabled
        public String avail {get;set;}
        @AuraEnabled
        public String cmnt {get;set;}
        @AuraEnabled
        public String availdte {get;set;}
           
        @AuraEnabled
        public String reason {get;set;}
    }
 
 
 
 
 
 
 @AuraEnabled
     public static String passFile(String File)
{
    try{
        UPL_Settings__c salesOrgDetails = UPL_Settings__c.getInstance();
        String SalesOrg = salesOrgDetails.SalesOrg__c;
        system.debug('SalesOrg---'+SalesOrg);
        sales_org__c salesorgId= [SELECT ID  FROM sales_org__c where sales_org_code__c=: SalesOrg];
         Integer errorCounter=0;
      list<errorWrapper> errorList= new list<errorWrapper>();
      Map<Integer,boolean> validRecord= new map<Integer,boolean>();    
      List<String>  csvFileLines= new List<String>();
      Integer k=1;
      Integer j=0;
      map<String,Inventory__c> invntDatalist = new map<String,Inventory__c>();
      List<String> lstDepotCode = new List<String>();
      List<String> lstSKU = new List<String>();
      List<string> inputvalues = new list<string>();
      system.debug('File-----------------'+File);      
      csvFileLines = (file.split('\n'));  
        for (j=1;j<csvFileLines.size();j++){                    
            inputvalues = csvFileLines[j].split(',');
            inputvalues[0]=inputvalues[0].replaceAll( '\\s+', '');
            inputvalues[1]=inputvalues[1].replaceAll( '\\s+', '');
            lstDepotCode.add(inputvalues[0]);
            if(inputvalues[1].length() < 18)
            inputvalues[1]=inputvalues[1].leftPad(18,'0');
            lstSKU.add(inputvalues[1]);
        }
      System.debug('lstDepotCode is '+ lstDepotCode);
      System.debug('lstSKU is '+ lstSKU);
      Map<Id, Depot__c> mapDepot = new Map<Id, Depot__c>([SELECT id, Depot_Code__c FROM Depot__c WHERE Depot_Code__c IN : lstDepotCode AND SalesOrg__c =: salesorgId.ID]);
      Map<String, Id> mapDepotId = new Map<String, Id>();
      System.debug('mapDepot ' + mapDepot);
      for(Id itemId: mapDepot.keySet())
        mapDepotId.put(mapDepot.get(itemId).Depot_Code__c, itemId);
      
      System.debug('mapDepotId ' + mapDepotId);
           //map for sku 
      Map<Id, SKU__c> mapSKU = new Map<Id, SKU__c>([SELECT id, SKU_Code__c FROM SKU__c WHERE SKU_Code__c IN : lstSKU AND Sales_Org__c =:salesorgId.ID]);
      Map<String, Id> mapSKUId = new Map<String, Id>();
      for(Id itemId: mapSKU.keySet())
        mapSKUId.put(mapSKU.get(itemId).SKU_Code__c, itemId);

      System.debug('mapSKU:' +mapSKU);
      System.debug('mapSKUId ' + mapSKUId);
      
      
      /* rpocessing file data and putting it in respective fields to upload in salesforce inventory object*/
      for(j=1;j<csvFileLines.size();j++){ 
        String counter='0';
        inputvalues = csvFileLines[j].split(',');
         system.debug('before---'+inputvalues[2]);
        
        inputvalues[0]=inputvalues[0].replaceAll( '\\s+', '');
        inputvalues[1]=inputvalues[1].replaceAll( '\\s+', '');
        inputvalues[2]=inputvalues[2].replaceAll( '\\s+', '');
        inputvalues[4]=inputvalues[4].replaceAll( '\\s+', '');
          /* validation for accents in availability */
          if(inputvalues[2]=='Medio'){inputvalues[2]='Médio';}
          if(inputvalues[2]=='Indisponivel'){inputvalues[2]='Indisponível';}
          
            
        if(inputvalues[1].length() < 18)
          inputvalues[1]=inputvalues[1].leftPad(18,'0');  
        // Below are the validations 
        errorWrapper err = new errorWrapper();
        err.reason='';
        system.debug('i am above validation');
        
        if (mapDepotId.get(inputvalues[0])== null ||inputvalues[0]==null || inputvalues[0]=='')
        {
          validRecord.put(j,false);
          system.debug('map value is Depot'+ validRecord.get(j));
          err.wareHouseCode= inputvalues[0];
          err.SKUCode = inputvalues[1];
          err.avail= inputvalues[2];
          err.cmnt= inputvalues[3];
          err.availdte= inputvalues[4];
          err.reason= err.reason+System.Label.Warehouse_Error1;
          counter='1';  
        }
        if (mapSKUId.get(inputvalues[1])== null ||inputvalues[1]==null || inputvalues[1]=='')
        {
          validRecord.put(j,false);
          system.debug('map value is Depot'+ validRecord.get(j));
          err.wareHouseCode= inputvalues[0];
          err.SKUCode = inputvalues[1];
          err.avail= inputvalues[2];
          err.cmnt= inputvalues[3];
          err.availdte= inputvalues[4];
          err.reason= err.reason+System.Label.SKU_Error;
          counter='1';  
        }
        
         if ((((inputvalues[2]== 'Empty' || inputvalues[2]=='Indisponível') || (String.isBlank(inputvalues[2]))) && (String.isBlank(inputvalues[4]))))
        {
          validRecord.put(j,false);
          system.debug('map value is Depot'+ validRecord.get(j));
          err.wareHouseCode= inputvalues[0];
          err.SKUCode = inputvalues[1];
          err.avail= inputvalues[2];
          err.cmnt= inputvalues[3];
          err.availdte= inputvalues[4];
          err.reason= err.reason+System.Label.Avail_Date_Error1;
          counter='1';  
        }
        List<String> availVal = new list<string>();//= new List<String>{'Empty', 'High','Medium','Low'};
        Schema.DescribeFieldResult fieldResult = inventory__c.Availability__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            availVal .add(pickListVal.getLabel());
            
        } 
        system.debug(inputvalues[2]+'---'+availVal );  
        Boolean result = availVal .contains(inputvalues[2]);
        system.debug('result val-----'+result);
        if(!result){
              system.debug('result val-'+result);
              validRecord.put(j,false);          
              err.wareHouseCode= inputvalues[0];
              err.SKUCode = inputvalues[1];
              err.avail= inputvalues[2];
              err.cmnt= inputvalues[3];
              err.availdte= inputvalues[4];
              err.reason= err.reason+System.Label.Availability_Check;//System.Label.Avail_Date_Error1;
              counter='1';
        }



        system.debug('out of validation');
        /* Date formatting */
        if(!String.isBlank(inputvalues[4])){
        String str= inputvalues[4];
            system.debug(str);
            String[] dts = str.split('/');
            Integer day=Integer.valueOf(dts[0].replaceAll( '\\s+', ''));
            Integer mnth=Integer.valueOf(dts[1].replaceAll( '\\s+', ''));            
            Integer yr = Integer.valueOf(dts[2].replaceAll( '\\s+', ''));
            
            
            DateTime dT = System.now();
            Date sysDate = date.newinstance(dT.year(), dT.month(), dT.day());
             Date availibilityDate=Date.newInstance(yr,mnth,day);
             String dte=String.valueOf(yr)+'-'+String.valueOf(mnth)+'-'+String.valueOf(day);
             system.debug('dte--'+dte);
             String errMessage;
           try{           
                Date availibilityDate1= Date.valueOf(dte);
            }catch(exception e){
                  validRecord.put(j,false);
                  system.debug('map value is Depot'+ validRecord.get(j));
                  err.wareHouseCode= inputvalues[0];
                  err.SKUCode = inputvalues[1];
                  err.avail= inputvalues[2];
                  err.cmnt= inputvalues[3];
                  err.availdte= inputvalues[4];
                  err.reason= err.reason+System.Label.Invalid_Date;
                  counter='1';
                  errMessage=e.getMessage();
            
            }
            
            
            
            
             
            string todayDate=String.valueOf(sysDate);
                //if(todayDate > String.valueOf(availibilityDate)){
                if(sysDate>availibilityDate && String.isBlank(errMessage) ){
                    validRecord.put(j,false);
                  system.debug('map value is Depot'+ validRecord.get(j));
                  err.wareHouseCode= inputvalues[0];
                  err.SKUCode = inputvalues[1];
                  err.avail= inputvalues[2];
                  err.cmnt= inputvalues[3];
                  err.availdte= inputvalues[4];
                  err.reason= err.reason+System.Label.Future_Date_Error1;
                  counter='1'; 
                
                }
             
            }
            
            
        
        
        /* --------------------- */
        if(counter=='1'){
          errorList.add(err); 
          errorCounter =errorCounter +1;          
          k = k+1;
        }
        else if (counter =='0'){
            if(inputvalues[2]=='Alto'){ inputvalues[2]='High';}
       else if(inputvalues[2]=='Médio'){inputvalues[2]='Medium';}
       else if(inputvalues[2]=='Baixo'){inputvalues[2]='Low';}
       else if(inputvalues[2]=='Indisponível'){inputvalues[2]='Empty';}
       else{inputvalues[2]=inputvalues[2];}
        
          validRecord.put(j,true); 
          Inventory__c invntDataObj = new Inventory__c() ;
          
          String depotCode = mapDepotId.get(inputvalues[0]) ;
          String SKUCode = mapSKUId.get(inputvalues[1]) ;
          system.debug('depotCode ---'+depotCode +'---'+'SKUCode--'+SKUCode  );
          String SKUDepotCode= SalesOrg+inputvalues[0]+inputvalues[1];
          String availibility= inputvalues[2];
          String comment= inputvalues[3];
          if(!String.isempty(depotCode))
            invntDataObj.Depot__c = depotCode;
          if(!String.isempty(SKUCode))
            invntDataObj.SKU__c = SKUCode;
          if(!String.isempty(SKUCode))
            invntDataObj.SKU_Depot__c = SKUDepotCode;            
          //if(!String.isempty(comment))
              invntDataObj.Comments__c = comment;
          if(!String.isempty(availibility))
              invntDataObj.Availability__c = availibility;             
          // if (inputvalues[4]!= null && inputvalues[4]!= ' '&& inputvalues[4]!= '' )
           if(!String.isBlank(inputvalues[4])){
            String str= inputvalues[4];
            system.debug(str);
            String[] dts = str.split('/');
            Integer day=Integer.valueOf(dts[0]);
            Integer mnth=Integer.valueOf(dts[1]);            
            Integer yr = Integer.valueOf(dts[2].replaceAll( '\\s+', ''));
             
            Date availibilityDate= Date.newInstance(yr,mnth,day); 
            //availibilityDate = availibilityDate.format('MM/dd/yyyy');          
            invntDataObj.availability_date__c=availibilityDate;
            system.debug('availibilityDate--'+availibilityDate); 
        }else
        invntDataObj.availability_date__c=null;
        invntDataObj.Sales_Org__c=salesorgId.Id;
        invntDatalist.put(invntDataObj.SKU_Depot__c,invntDataObj);
        }  
        System.debug('invntDatalist---'+invntDatalist);                   
            }
            
            list<string> successstring= new list<string>();
            Integer successCounter=0;
            
            if(invntDatalist.size()>0)
            {
        Database.UpsertResult[] invntUplResult = Database.upsert(invntDatalist.values(),inventory__c.SKU_Depot__c,false);
        system.debug('invntUPLResult---' + invntUPLResult);
        for(Integer i=0;i<invntUplResult.size();i++)
        {
          if(!invntUplResult.get(i).isSuccess()){
            k = k+1;
            errorCounter=errorCounter+1;
            errorWrapper err1= new errorWrapper();
            
            for(Database.Error err : invntUplResult.get(i).getErrors()) {
            //errorList.add(err.getMessagge);
            System.debug('The following error has occurred.');                    
            System.debug(err.getStatusCode() + ': ' + err.getMessage());
            System.debug('Fields that affected this error: ' + err.getFields());
            //err1.reason=err.getMessage();
        }
            
            }
          else if(invntUplResult.get(i).isSuccess())
          {
                        String succ= String.valueOf(invntUplResult.get(i).getId());
                        successCounter=successCounter+1;
                        successstring.add(succ);                      
                    }
               }
            } 
            
            if (errorList.size()>0){
                
            List<Messaging.Emailfileattachment> efaList = new List<Messaging.Emailfileattachment>();
        
        //csv generator code for error 
        string header = 'Armazém,Produtos,Disponibilidade,Observações,Previsão,Razão\n';
        string finalstr = header ;
        for(errorWrapper a: errorList)
        {
           if(a.avail=='High'){ a.avail='Alto';}
           else if(a.avail=='Medium'){a.avail='Médio';}
           else if(a.avail=='Low'){a.avail='Baixo';}
           else if(a.avail=='Empty'){a.avail='Indisponível';}
           else{a.avail=a.avail;}  
          string recordString = '"'+a.wareHouseCode+'","'+a.SKUCode +'","'+a.avail+'","'+a.cmnt +'","'+a.availdte+'","'+a.reason +'" \n';
          finalstr = finalstr +recordString;
        }
                    
        //csv for success
        string successheader= 'RecordId \n';
        string finalSuccessHeader= successheader;
        for (string success: successstring)
        {
          String tempString =success+'\n'; 
          finalSuccessHeader= finalSuccessHeader+tempString;
        }//ends
        
        Messaging.EmailFileAttachment csvsuccessAttc = new Messaging.EmailFileAttachment();
        blob csvsuccessBlob = Blob.valueOf(finalSuccessHeader);
        string csvsuccessname= 'Success.csv';
        csvsuccessAttc.setFileName(csvsuccessname);
        csvsuccessAttc.setBody(csvsuccessBlob);
        efaList.add(csvsuccessAttc);
        
        String loggedInUser= UserInfo.getUserEmail();
        system.debug('email value is '+ loggedInUser);
        
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(finalstr);
        string csvname= 'error.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        efaList.add(csvAttc);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String[] toAddresses = new list<string> {loggedInUser};
        //String[] toAddresses = new string[] {'myadava1@in.ibm.com'};
          String subject ='Error while uploading Inventory Data';
        email.setSubject(subject);
        email.setToAddresses( toAddresses );
        email.setPlainTextBody(Label.SIC_email_Text);
        email.setFileAttachments(efaList);
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        j=j-k;
        if(j == 0)
        {
          system.debug('NoSuccess');
          return ('NoSuccess');
        }
        
        system.debug('PartialSuccess'+j);
        System.debug('error:'+errorCounter);
        return ('PartialSuccess: '+j+' Error: '+errorCounter);
            }
             else
      {
        String recordsupdated= String.valueOf(successCounter);  
        System.debug('success:'+recordsupdated);
        
        return ('success:'+recordsupdated);
            }

    }
      
      
    catch(Exception e){
        System.debug('The following exception has occurred: ' + e.getMessage());        
        
        return 'error';
    }
       
  
}
}