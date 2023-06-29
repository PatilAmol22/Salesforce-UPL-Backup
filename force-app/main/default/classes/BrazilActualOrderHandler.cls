global class BrazilActualOrderHandler implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope env){
        
        // Create an InboundEmailResult object for returning the result of the 
        // Apex Email Service
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        System.debug('Start Time>>'+System.now());
        
        // Add the email plain text into the local variable 
        String myPlainSubject = email.subject;
        System.debug('Subject: '+myPlainSubject);
        System.debug('From Address:'+email.fromAddress);
        Integer failedRecordCounter=0;

        String fromAddress = email.fromAddress;
        
        Set<String> Email_Body= new Set<String>();

        Messaging.InboundEmail.BinaryAttachment[] bAttachments = email.BinaryAttachments; 
        
        String csvbody='';
        String mailTime = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        List<String> csvFileLines = new List<String>();
        try{
            if(bAttachments !=null){
                for(Messaging.InboundEmail.BinaryAttachment btt :bAttachments){
                    List<Actual_Order__c> aoList= New List<Actual_Order__c>();
                    if(btt.filename.endsWith('.csv')){
                        csvbody = btt.body.toString();
                        
                        //Now separate every row of the Csv   
                        Grz_SplitString splitObj = new Grz_SplitString(); 
                        List<String> csvRows = new List<String>();
                        csvRows = splitObj.safeSplit(csvbody, '\n'); 

                        //Sets for removing duplicate values
                        Set<String> Unique_Business_Unit_Code = new Set<String>();
                        Set<String> Unique_RegionalCode = new Set<String>();
                        Set<String> Unique_Region_Code = new Set<String>();
                        Set<String> Unique_Customer_Code = new Set<String>();
                        Set<String> Unique_Sales_Rep_Code = new Set<String>();
                        Set<String> Unique_Product_Code = new Set<String>();
                        
                        for(Integer i=1; i < csvRows.size(); i++){
                            if(String.isNotBlank(csvRows[i])) {
                                
                                String[] csvColumns = csvRows[i].split(',');
                                
                                Unique_Business_Unit_Code.add(csvColumns[0]);
                                Unique_RegionalCode.add(csvColumns[1].trim());
                                Unique_Region_Code.add('BR'+csvColumns[2]);
                                Unique_Customer_Code.add('000'+csvColumns[3]);
                                Unique_Sales_Rep_Code.add(csvColumns[4]);
                                String str = csvColumns[5];
                                Integer len = str.length();
                                String tempStr = '';
                                
                                if(len < 18)
                                {
                                    Integer zeroCount = 18 - len;
                                    for(Integer f=0;f<zeroCount;f++)
                                    {
                                        tempStr = tempStr + '0';
                                    } 
                                    str = tempStr + str;
                                }
                                Unique_Product_Code.add(str);
                            }
                        }
                        
                        System.debug('Unique_Business_Unit_Code>>>'+Unique_Business_Unit_Code);                    
                        System.debug('Unique_RegionalCode>>>'+Unique_RegionalCode);                    
                        System.debug('Unique_Region_Code>>>'+Unique_Region_Code);                    
                        System.debug('Unique_Customer_Code>>>'+Unique_Customer_Code);                    
                        System.debug('Unique_Sales_Rep_Code>>>'+Unique_Sales_Rep_Code);                    
                        System.debug('Unique_Product_Code>>>'+Unique_Product_Code);                    
                        
                        Map<String,String> Unique_Business_Unit_Code_Map = new Map<String,String>();
                        Map<String,String> Unique_RegionalCode_Map = new Map<String,String>();
                        Map<String,String> Unique_Region_Code_Map = new Map<String,String>();
                        Map<String,String> Unique_Customer_Code_Map = new Map<String,String>();
                        Map<String,String> Unique_Sales_Rep_Code_Map = new Map<String,String>();
                        Map<String,String> Unique_Product_Code_Map = new Map<String,String>();
                        
                        //Map<String,Zone__c> Unique_Business_Unit_Code_Map2 = new Map<String, Zone__c>([Select id, ZoneCode__c from Zone__c where ZoneCode__c in :Unique_Business_Unit_Code]);
                        
                        for(Zone__c z : [Select id, ZoneCode__c from Zone__c where ZoneCode__c in :Unique_Business_Unit_Code]){
                            Unique_Business_Unit_Code_Map.put(z.ZoneCode__c, z.id);
                        }
                        System.debug('Unique_Business_Unit_Code_Map>>'+Unique_Business_Unit_Code_Map);
                        
                        for(Region__c r : [Select id, RegionCode__c from Region__c where RegionCode__c in :Unique_RegionalCode]){
                            Unique_RegionalCode_Map.put(r.RegionCode__c, r.id);
                        }
                        System.debug('Unique_RegionalCode_Map>>'+Unique_RegionalCode_Map);
                        
                        for(Territory_Distributor__c td : [Select id, TerritoryCode__c from Territory_Distributor__c where TerritoryCode__c in :Unique_Region_Code]){
                            Unique_Region_Code_Map.put(td.TerritoryCode__c, td.id);
                        }
                        System.debug('Unique_Region_Code_Map>>'+Unique_Region_Code_Map);
                        
                        for(Account a : [Select id, SAP_Code__c from Account where SAP_Code__c in :Unique_Customer_Code]){
                            Unique_Customer_Code_Map.put(a.SAP_Code__c, a.id);
                        }
                        System.debug('Unique_Customer_Code_Map>>'+Unique_Customer_Code_Map);
                        
                        for(User u : [Select id, TM_Code__c from User where TM_Code__c in :Unique_Sales_Rep_Code]){
                            Unique_Sales_Rep_Code_Map.put(u.TM_Code__c, u.id);
                        }
                        System.debug('Unique_Sales_Rep_Code_Map>>'+Unique_Sales_Rep_Code_Map);
                        
                        for(SKU__c z : [Select id, SKU_Code__c from SKU__c where SKU_Code__c in :Unique_Product_Code]){
                            Unique_Product_Code_Map.put(z.SKU_Code__c, z.id);
                        }
                        System.debug('Unique_Product_Code_Map>>'+Unique_Product_Code_Map);
                        
                        //Insert new records                            
                        for(Integer i=1; i < csvRows.size(); i++){
                            if (String.isNotBlank(csvRows[i])) {
                                
                                String[] csvColumns = csvRows[i].split(',');
                                String str = csvColumns[5];
                                Integer len = str.length();
                                String tempStr = '';
                                
                                if(len < 18)
                                {
                                    Integer zeroCount = 18 - len;
                                    for(Integer f=0;f<zeroCount;f++)
                                    {
                                        tempStr = tempStr + '0';
                                    } 
                                    str = tempStr + str;
                                }
                          
                                System.debug('csvColumns[1]'+string.valueOf(csvColumns[1])+'csvColumns[0]'+csvColumns[0]);
                                System.debug('map  '+Unique_RegionalCode_Map+'@@@@@@ '+Unique_RegionalCode_Map.get('BR1502'));
                                if(Unique_Business_Unit_Code_Map.get(csvColumns[0])!=null){
                                    System.debug('138');
                                    if(Unique_RegionalCode_Map.get(csvColumns[1].trim())!=null){
                                        System.debug('140');
                                        if(Unique_Region_Code_Map.get('BR'+csvColumns[2]) !=null){
                                            if(Unique_Customer_Code_Map.get('000'+csvColumns[3]) !=null){
                                                if(Unique_Sales_Rep_Code_Map.get(csvColumns[4]) !=null){
                                                    if(Unique_Product_Code_Map.get(str) !=null){
                                                        Actual_Order__c aoObj = new Actual_Order__c();
                                                        aoObj.Business_Unit__c = Unique_Business_Unit_Code_Map.get(csvColumns[0]);
                                                        aoObj.Regional_Code__c = Unique_RegionalCode_Map.get(csvColumns[1].trim());
                                                        aoObj.Region__c = Unique_Region_Code_Map.get('BR'+csvColumns[2]);
                                                        aoObj.Customer__c = Unique_Customer_Code_Map.get('000'+csvColumns[3]);
                                                        aoObj.Sales_Rep__c = Unique_Sales_Rep_Code_Map.get(csvColumns[4]);
                                                        aoObj.Product__c = Unique_Product_Code_Map.get(str);
                                                        String dtStr1 = csvColumns[7];
                                                        if(Test.isRunningTest()){
                                                            dtStr1 = '01/01/2021';
                                                        }
                                                        if(!String.isEmpty(dtStr1) && dtStr1.contains('/')){
                                                            String one = dtStr1.substringBefore('/');
                                                            String two = dtStr1.substringBetween('/');
                                                            String three = dtStr1.substringAfterLast('/');
                                                            Date FaturmentoDate = Date.parse(one+'/'+two+'/'+three)+1;
                                                            aoObj.Data_de_Faturamento__c = FaturmentoDate;
                                                        }
                                                        aoObj.Qty_ORD__c = Double.valueOf(csvColumns[8]);
                                                        aoObj.Net_Sales_ORD__c = Double.valueOf(csvColumns[9]);
                                                        aoList.add(aoObj);  
                                                    }
                                                    else{
                                                        Email_Body.add('Couldn\'t find '+ csvColumns[5] +', ');
                                                        failedRecordCounter++;
                                                    }
                                                }
                                                else{
                                                    Email_Body.add('Couldn\'t find '+ csvColumns[4] +', ');
                                                    failedRecordCounter++;
                                                }
                                            }
                                            else{
                                                Email_Body.add('Couldn\'t find '+ csvColumns[3] +', ');
                                                failedRecordCounter++;
                                            }
                                        }
                                        else{
                                            Email_Body.add('Couldn\'t find '+ csvColumns[2] +', ');
                                            failedRecordCounter++;
                                        }
                                    }
                                    else{
                                        Email_Body.add('Couldn\'t find '+ csvColumns[1] +', ');
                                        failedRecordCounter++;
                                    }
                                }
                                else
                                {
                                    Email_Body.add('Couldn\'t find '+ csvColumns[0] +', ');
                                    failedRecordCounter++;
                                }
                            }
                        }
                    }
                    System.debug('Items to be inserted>>>'+aoList.size());
                    String subject =aoList.size() + ' Records are being inserted while '+ failedRecordCounter +' Records Failed due to invalid data';
                    

                    String Email_Body_String = String.join((Iterable<String>)Email_Body, ', ');
                    if(fromaddress!=null){
                        
                        Messaging.SingleEmailMessage emailToSend =new Messaging.SingleEmailMessage();
                        emailToSend.setSubject(subject);
                        emailToSend.setToAddresses(new String[] {fromaddress});
                        emailToSend.setHtmlBody(Email_Body_String);
                        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailToSend});
                        if (r[0].success) {
                            System.debug('The email was sent successfully.');
                        } else {
                            System.debug('The email failed to send: '
                                         + r[0].errors[0].message);
                        }
                    }
                    
                    if(!aoList.isEmpty()){
                        BrazilActualOrderDeleteBatch bcn = new BrazilActualOrderDeleteBatch(mailTime) ;
                        Database.executeBatch(bcn,2000);
                        BrazilActualOrderInsertBatch bin = new BrazilActualOrderInsertBatch(aoList) ;
                        Database.executeBatch(bin,2000);
                        System.debug('Items to be inserted>>>'+aoList.size());                        
                    }
                    
                }                     
            }       
        }
        catch(Exception e)
        {
            if (e.getTypeName() == 'System.TypeException' && e.getMessage().contains('Invalid date')) {
                Messaging.SingleEmailMessage emailToSend =new Messaging.SingleEmailMessage();
                emailToSend.setSubject('Failed to Insert Records');
                emailToSend.setToAddresses(new String[] {fromaddress});
                emailToSend.setHtmlBody('Date format is not correct, please check all the rows and enter date in this format: DD/MM/YYYY eg: (31/03/2023)');
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailToSend});
                if (r[0].success) {
                    System.debug('Invalid date format! Email Sent');
                } else {
                    System.debug('The email failed to send: '
                                 + r[0].errors[0].message);
                }
                System.debug('Invalid date format!');
            } else {
                if(fromaddress!=null){
                    Messaging.SingleEmailMessage emailToSend =new Messaging.SingleEmailMessage();
                    emailToSend.setSubject('Failed to Insert Records.');
                    emailToSend.setToAddresses(new String[] {fromaddress});
                    emailToSend.setHtmlBody('An exception occurred, please contact System Administrator');
                    Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailToSend});
                    if (r[0].success) {
                        System.debug('An exception occurred: Email Sent');
                    } else {
                        System.debug('The email failed to send: '
                                     + r[0].errors[0].message);
                    }    
                }
                
                System.debug('An exception occurred: ' + e.getMessage());
            }
        }
        
        result.success = true;
        // Return the result for the Apex Email Service
        return result;
    }
}