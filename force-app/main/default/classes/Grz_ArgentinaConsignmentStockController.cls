/**************************************************************************************************
* Name             : Grz_ArgentinaConsignmentStockController                                                      
* Description      : Controller for the Argentina consignment stock datatable component that fetches 
data from the API and provides the download as PDF and XLS functionality.  
* Test Class       : Grz_ArgConsignmentStockControllerTest
* Created Date     : 31-08-2022                                                                        
* Project/JIRA     : APPS-1757                                                                        
* Created By       : Gurubaksh Grewal (Grazitti)                                                                        
* Last Modified By : Gurubaksh Grewal (Grazitti) 01-09-2022  
* CR JIRA          : APPS5386
* LastModifiedBy   :Ishu Mittal
* LastModifiedDate : 06-06-2023
**************************************************************************************************/
public class Grz_ArgentinaConsignmentStockController {
    public static List<ItemInfo> ItemInfo{get;set;}
    
    public static void getConsignmentData() {
        String customerCode = ApexPages.currentPage().getParameters().get('customerCode');
        
        ItemInfo = getArData(customerCode).ItemInfo;
        
        System.debug('ItemInfo : '+ItemInfo);   
    }
    
    /*
* Description: fetch UOM from the SKU Object on basis of Material Code.
* Modified By :Ishu Mittal
* */
    @AuraEnabled(cacheable=true) 
    public static ConsignmentStockWrapper getArData(String executedfrom){
        Map<String,SKU__c> uomMap = new Map<String,SKU__c>();
        Set<String> materialNo = new Set<String>();
        
        List<Account> acc = [SELECT Id,SAP_Customer_Code__c,Depot_Code__c FROM Account WHERE SAP_Customer_Code__c=: executedfrom];
        string depot = '';
        if(acc!=null&&!acc.isEmpty())depot=acc[0].Depot_Code__c;
        string jsonInput=grz_SapIntegration.ArgentinaConsignmentStockData(executedfrom,depot);
        /*if(jsonInput.containsIgnoreCase('MaterialNo')&&jsonInput.containsIgnoreCase('BatchNo')){
String jsonInput1 = jsonInput.substringBetween('"ItemInfo":', ',"Return"');
if(!jsonInput1.contains('['))jsonInput=jsonInput.replace(jsonInput1, ('['+jsonInput1+']'));
}*/
        //Added By Ishu Mittal to set the value of UOM.
        ConsignmentStockWrapper csWrap = parse(jsonInput);
        system.debug('csWrap-->'+csWrap);
        system.debug('csWrap.ItemInfo-->'+csWrap.ItemInfo);
        for(Integer materialCounter=0; materialCounter < csWrap.ItemInfo.size(); materialCounter++){
            materialNo.add(csWrap.ItemInfo[materialCounter].Materialno); // fetch Material number from the ItemInfo.
        }
        system.debug('materialNo-->'+materialNo);
        for(SKU__c sku : [Select uom__c,SKU_code__c,Multiple_of__c from SKU__c where SKU_code__c IN : materialNo]){
            uomMap.put(sku.SKU_code__c,sku);
        }
        
        for(Integer itemCounter =0; itemCounter < csWrap.ItemInfo.size(); itemCounter++){
            if(uomMap.get(csWrap.ItemInfo[itemCounter].Materialno)!=null){
                SKU__c sku=uomMap.get(csWrap.ItemInfo[itemCounter].Materialno);
                csWrap.ItemInfo[itemCounter].uom=sku.uom__c;
                csWrap.ItemInfo[itemCounter].multipleOf=sku.Multiple_of__c;
            }
        }
        //Code Ended By Ishu Mittal for CR:APPS5386
        system.debug('csWrap-->'+csWrap);
        csWrap.Message=null;
        if(jsonInput=='Error_In_Sap')csWrap.Message='Error_In_Sap';
        if(jsonInput.contains('Data does not exist'))csWrap.Message='Data does not exist';
        if(acc==null||acc.isEmpty())csWrap.Message='No access to account';
        
        return csWrap;
    }
    @AuraEnabled(cacheable=true)
    public static map<string,object> loggedUserData(){
        map<string,object> map2return = new map<string,object>();
        Id userId = UserInfo.getUserId();
        list<User> user = [SELECT Id,account.SAP_Customer_Code__c,account.Depot_Code__c,AccountId FROM User where Id =: userId];
        map2return.put('AccountId',user[0].AccountId);
        map2return.put('Depot',user[0].account.Depot_Code__c);
        map2return.put('CustomerCode',user[0].account.SAP_Customer_Code__c);
        return map2return;
    }
    
    /*
* Description: create/update Consignment record for Argentina.
* Param: arrayitemList, distributorId, currenci,exchangeRate, lpNumber, PaymentTermValue, file, fileName
* return : String
* Added By :Ishu Mittal
* CR: APPS5386
* */
    @AuraEnabled(cacheable=false)
    public static ToastMessage insertConsignmentStockList(List<consignmentStockListWrapper> arrayitemList,Id distributorId,String currenci,Decimal exchangeRate, String lpNumber,String PaymentTermValue,String PaymentMethod,String file,String fileName){
        String toastMessage = '';
        Boolean LPAlreadySubmit=false;
        ToastMessage toastmsg=new ToastMessage();
        List<Consignment_Stock__c> insertconsignmentStockList=new List<Consignment_Stock__c>();
        List<Consignment_Stock__c> updateconsignmentStockList=new List<Consignment_Stock__c>();
        Map<String,Consignment_Stock__c> consignmentStockMap=new Map<String,Consignment_Stock__c>();
        
        List<Consignment__c> consignmentList = [SELECT id,Exchange_Rate__c,LP_Number__c,Payment_Term__c,File_Name__c,Currency1__c,Payment_Method__c,Status__c,(SELECT id,Qty_Sold__c,Net_Price1__c,Lote_Number__c FROM Consignment_Stocks__r ) FROM Consignment__c WHERE Account__c=:distributorId AND LP_Number__c=:lpNumber LIMIT 1 ];
        //if lp number already exist then update the records.
        if(null != consignmentList && !consignmentList.isEmpty()){
            if(consignmentList[0].Status__c!='Pending')
            {
              LPAlreadySubmit=true;
            }
            else
            {
               consignmentList[0].Exchange_Rate__c=exchangeRate;
            consignmentList[0].Payment_Term__c=PaymentTermValue;
            consignmentList[0].Currency1__c=currenci;
            consignmentList[0].Payment_Method__c=PaymentMethod;
            consignmentList[0].File_Name__c=fileName;
            
            
            try
            {
                update consignmentList;  
                if(consignmentList.size()>0){
                    System.debug('consignmentList :'+consignmentList);
                    for(Consignment__c cL : consignmentList){
                        if(cL.id!=null){
                            
                            setMonitorLog('Consignment Stock ', +cL+':Update Successfully');
                        }}}
                
            }
            catch(DmlException ex)
            {
                setMonitorLog('Consignment Stock ', ex.getMessage());
            }
            
            //insert a Document in Consignment Related List File
            if(String.isNotBlank(file) && String.isNotBlank(fileName)){
                fileUpload(consignmentList[0].id,file,fileName);  
            }
            
            
            for(Consignment_Stock__c cs:consignmentList[0].Consignment_Stocks__r){
                consignmentStockMap.put(cs.Lote_Number__c,cs);               
            }
            
            for(consignmentStockListWrapper con:arrayitemList){
                if(consignmentStockMap.get(con.lote)!=null){
                    consignmentStockMap.get(con.lote).Net_Price1__c = con.netPrice;
                    consignmentStockMap.get(con.lote).Qty_Sold__c = con.quantitySold;
                    updateconsignmentStockList.add(consignmentStockMap.get(con.lote));
                }
            } 
            }
            
        } else{ //if LP number not exist then create a new record curencyCode
            Consignment__c c = new Consignment__c(Account__c =distributorId, 
                                                  Currency1__c = currenci,
                                                  Exchange_Rate__c = exchangeRate, 
                                                  LP_Number__c = lpNumber,
                                                  Payment_Term__c = PaymentTermValue ,
                                                  Payment_Method__c=PaymentMethod,
                                                  Status__c = 'Pending',
                                                 File_Name__c=fileName);
            try
            {
                INSERT c;  
                setMonitorLog('Consignment Stock ', +c+':Insert Successfully');
            }
            catch(DmlException ex)
            {
                setMonitorLog('Consignment Stock ', ex.getMessage());
            }
            //insert a Document in Consignment Related List File
            if(String.isNotBlank(file) && String.isNotBlank(fileName)){
                fileUpload(c.id,file,fileName);
            }
            
            for(consignmentStockListWrapper con:arrayitemList){
                Consignment_Stock__c cs = new Consignment_Stock__c(Product__c =con.product, 
                                                                   Lote_Number__c = con.lote,
                                                                   Quantity__c = con.quantity, UOM__c = con.uom,
                                                                   Qty_Sold__c =con.quantitySold ,
                                                                   Net_Price1__c = con.netPrice,Consignment__c=c.id,
                                                                   Expiry_Date__c=con.expiryDate,
                                                                   SKU__c=con.material
                                                                  );
                
                insertconsignmentStockList.add(cs); 
            }
        }     
        
        try{
            if(null != insertconsignmentStockList & !insertconsignmentStockList.isEmpty()){
                INSERT insertconsignmentStockList; 
                if(insertconsignmentStockList.size()>0){
                    System.debug('insertconsignmentStockList :'+insertconsignmentStockList);
                    for(Consignment_Stock__c cs : insertconsignmentStockList){
                        
                        setMonitorLog('Consignment Stock Insertion',+cs+ ': Insert Successfully');
                        
                    }
                    toastmsg.toastMsg = System.Label.Stock_Insert_Successfully;
                    toastmsg.Result='Success';
                }
                
            }
            else{
                if(LPAlreadySubmit==true)
                {
                   toastmsg.toastMsg = 'Duplicate LP Number Found';  
                    toastmsg.Result='Error';
                }
                else
                {
                  UPDATE updateconsignmentStockList; 
                if(updateconsignmentStockList.size()>0){
                    System.debug('updateconsignmentStockList :'+updateconsignmentStockList);
                    for(Consignment_Stock__c cs : updateconsignmentStockList){
                        
                        setMonitorLog('Consignment Stock Insertion',+cs+ ': Update Successfully');
                        
                    } 
                }
                toastmsg.toastMsg = System.Label.Stock_Update_Successfully;  
                    toastmsg.Result='Success';
                }
               
            }
        } catch(DmlException ex){
            setMonitorLog('Consignment Stock ', ex.getMessage());
           toastmsg.Result='Error';
            toastmsg.toastMsg =System.Label.Error_in_inserting_updation_Consignment ; //insert in monitor log object - read data from Custom Label
        }
        return toastmsg; 
    }
    
    /*
* Description: Retreive Consignment Stock with status = Pending.
* param: distributorId
* return : Map<Integer,Consignment__c>
* Added By :Ishu Mittal
* CR:APPS5386
* */
    //change method name
    @AuraEnabled
    public static Map<Integer,Consignment__c> retrieveConsignmentStock(String distributorId){
        Integer declarationCounter = 0;
        Map<Integer,Consignment__c> consignmentMapInfo = new Map<Integer,Consignment__c>();
        
        List<Consignment__c> declarationList = retrieveConsignment(distributorId);
        
        if(null != declarationList && !declarationList.isEmpty()){
            for(Consignment__c consignmentRecord : declarationList) {
                declarationCounter++;
                consignmentMapInfo.put(declarationCounter,consignmentRecord);
            }  
        }
        
        return consignmentMapInfo;
    }
    
     @AuraEnabled
    public static ToastMessage deleteConsignmentStock(String distributorId,String lpNo){
        ToastMessage toastmsg=new ToastMessage();
          Consignment__c consignment = [SELECT id FROM Consignment__c WHERE Account__c=:distributorId AND LP_Number__c=:lpNo ];     
        try{
          delete consignment;
            toastmsg.toastMsg='Consignment Successfully Deleted';
            toastmsg.Result='Success';
        } 
        catch(DmlException e)
        {
             toastmsg.toastMsg='error in deleting. Please refresh the page';
            toastmsg.Result='Error';
        }
        
        return toastmsg;
    }
    
    
    /*
* Description: Retrieve the declaration records based on LP Number.
* param: distributorId, lpNo
* return : consignmentWrapperRecord
* Added By :Ishu Mittal
* JIRA: CR APPS -5386
* */
    
    @AuraEnabled
    public static ConsignmentWrapper retrieveEditDeclaration(String distributorId,String lpNo){
        List<consignmentStockListWrapper> consignmentStockListWrapper = new List<consignmentStockListWrapper>();
        
        Consignment__c consignment = [SELECT id, Exchange_Rate__c,LP_Number__c,Payment_Term__c,Payment_Method__c,Currency1__c,Account__c,(SELECT id,Quantity__c,UOM__c,SKU__c,Qty_Sold__c,Net_Price1__c,Expiry_Date__c,Lote_Number__c,Product__c FROM Consignment_Stocks__r ) FROM Consignment__c WHERE Account__c=:distributorId AND LP_Number__c=:lpNo ];     
        
        for(Consignment_Stock__c c:consignment.Consignment_Stocks__r){
            consignmentStockListWrapper conwrapper=new consignmentStockListWrapper();
            conwrapper.product=c.Product__c;
            conwrapper.material=c.SKU__c;
            conwrapper.quantitySold=c.Qty_Sold__c;
            conwrapper.uom=c.UOM__c;
            conwrapper.lote=c.Lote_Number__c;
            conwrapper.quantity=c.Quantity__c;
            conwrapper.netPrice=c.Net_Price1__c;
            conwrapper.expiryDate=c.Expiry_Date__c;
            consignmentStockListWrapper.add(conwrapper);
        }
        
      ConsignmentWrapper consignmentWrapperRecord  =new ConsignmentWrapper(consignmentStockListWrapper,consignment.Currency1__c,consignment.Exchange_Rate__c,consignment.Payment_Term__c,
                                                                           consignment.Payment_Method__c,consignment.LP_Number__c,consignment.Account__c,true);
        
        
        return consignmentWrapperRecord;
    }
    
    /*
* Description: Fetch Existing Qty_Sold__c  on basis of Lote Number .
* Param: distributorId
* return : Map<String,Integer>
* Added By :Ishu Mittal
* CR:APPS5386
* */
    
    @AuraEnabled
    public static Map<String,decimal> retreiveExistingRecord(String distributorId){
        Map<String,decimal> existingquantity = new Map<String,decimal>();
        List<AggregateResult> existingQtyList = [SELECT SUM(Qty_Sold__c) qty, Lote_Number__c lote 
                                                 FROM Consignment_Stock__c 
                                                 WHERE Consignment__r.Account__c = :distributorId and Consignment__r.Status__c!='Approved'
                                                 GROUP BY Lote_Number__c ];
        
        if(null !=existingQtyList && !existingQtyList.isEmpty()){
            for(AggregateResult ar : existingQtyList) {
                existingquantity.put(String.valueOf(ar.get('lote')),(Decimal)(ar.get('qty')));
            }  
        }
        return existingquantity;
    }
    
    /*
* Description: Retrieve the consignment records with Status = Pending and update Status = Submit.
* param: distributorId
* return : String
* Added By :Ishu Mittal
* CR:APPS5386
* */
    
    @AuraEnabled
    public static String updateStatusOfConsignment(String distributorId){       
        String toastMessage = '';
        List<Consignment__c> updateConsignmentList = new List<Consignment__c>();
        
        //Create a method for query
        List<Consignment__c> declarationList =retrieveConsignment(distributorId);
        
        if(null != declarationList && !declarationList.isEmpty()){
            for(Consignment__c consignmentRecord : declarationList){
                consignmentRecord.Status__c = 'Submit';
                updateConsignmentList.add(consignmentRecord);
            }
        }
        
        try{
            if(null != updateConsignmentList && !updateConsignmentList.isEmpty()){
                update updateConsignmentList;    
                toastMessage = System.Label.Declaration_Submitted_Successfuly;  
            }
        } catch(Exception e) {
            toastMessage = System.label.Error_in_Submit_the_Declaration; 
        }
        
        return toastMessage;
    }
    
    public static List<Consignment__c> retrieveConsignment(String distributorId){
        List<Consignment__c> declarationList = [SELECT  Total_Amount__c, LP_Number__c,File_Name__c
                                                FROM  Consignment__c
                                                WHERE Account__c = :distributorId 
                                                AND Status__c='Pending'];
        return declarationList;
    }
    
    @AuraEnabled
    public static Map<String,List<String>> retrievePaymentMethod(){
        Map<String,List<String>> paymentMethodMap= new Map<String,List<String>>();
        
        List<Payment_Method_Payment_Term_Mapping__c> paymentMethodList=[SELECT  id,Payment_Method__c, Payment_Term__c,Payment_Term__r.Payment_Term__c,Payment_Method__r.Name 
                                                                        FROM Payment_Method_Payment_Term_Mapping__c
                                                                        WHERE Payment_Method__r.Sales_Org__r.Name='Argentina'];
        
        for(Payment_Method_Payment_Term_Mapping__c paymentMethod:paymentMethodList){
            if(paymentMethodMap.containsKey(paymentMethod.Payment_Method__r.Name)){
                paymentMethodMap.get(paymentMethod.Payment_Method__r.Name).add(paymentMethod.Payment_Term__r.Payment_Term__c);
            }else{
                paymentMethodMap.put(paymentMethod.Payment_Method__r.Name,new List<String>{paymentMethod.Payment_Term__r.Payment_Term__c});
            }
        }
        return paymentMethodMap;
    }
    
    
    public static void setMonitorLog( String name, String message){
        Monitor_log__c monitorLogObj= new Monitor_log__c();
        monitorLogObj.Name=name;
        monitorLogObj.Message__c=message;
        insert monitorLogObj;
        System.debug('monitorLogObj :- '+monitorLogObj);
    }
    
    public static void fileUpload(String consignmentId,String file,String fileName){  
        
        String base64File = EncodingUtil.urlDecode(file, 'UTF-8');     
        ContentVersion contentVersionRec = new ContentVersion();  
        contentVersionRec.Title = fileName;  
        contentVersionRec.PathOnClient = '/' + fileName;  
        contentVersionRec.FirstPublishLocationId =consignmentId;  
        contentVersionRec.VersionData = EncodingUtil.base64Decode(base64File);  
        contentVersionRec.IsMajorVersion = true;  
        INSERT contentVersionRec;    
    }
    
    
    public class ItemInfo {
        @AuraEnabled
        public String Customer{get; set;}
        @AuraEnabled
        public String MaterialNo{get; set;}
        @AuraEnabled
        public String MaterialDescription{get; set;}
        @AuraEnabled
        public String BatchNo{get; set;}
        @AuraEnabled
        public String UnrestrictedInventory{get; set;}
        @AuraEnabled
        public String uom{get; set;}
        @AuraEnabled
        public String Expirydate{get; set;}
        @AuraEnabled
        public Decimal multipleOf{get; set;}
    }
    
    
    public class ConsignmentStockWrapper {
        @AuraEnabled
        public List<ItemInfo> ItemInfo;
        @AuraEnabled
        public String Message;
        
    }
    public  class consignmentStockListWrapper {
        @AuraEnabled public String product { get; set; }
        @AuraEnabled public String material { get; set; }
        @AuraEnabled public String lote { get; set; }
        @AuraEnabled public String quantity { get; set; }
        @AuraEnabled public String uom { get; set; }
        
        @AuraEnabled public double quantitySold { get; set; }
        @AuraEnabled public double netPrice { get; set; }
        @AuraEnabled public String expiryDate{get;set;}
        
        
    }
      public  class ToastMessage {
        @AuraEnabled public String toastMsg { get; set; }
        @AuraEnabled public String Result { get; set; }
      }
    public  class consignmentWrapper {
        @AuraEnabled public List<consignmentStockListWrapper> ConsignmentInfo { get; set; }
        
        @AuraEnabled public String currenci { get; set; }
        @AuraEnabled public double exchangeRate { get; set; }
        
        @AuraEnabled public String paymentTerm { get; set; }
        @AuraEnabled public String paymentMethod { get; set; }
        
        @AuraEnabled public String lPNumber { get; set; }
        
        @AuraEnabled public String distributor { get; set; }
        @AuraEnabled public Boolean isEdit { get; set; }
        
        consignmentWrapper(List<consignmentStockListWrapper> ConsignmentInfo,String currenci,decimal exchangeRate, String paymentTerm,String paymentMethod,String lPNumber,String distributor ,Boolean isEdit )
        {
           this.ConsignmentInfo= ConsignmentInfo;
            this.currenci=currenci;
            this.exchangeRate=exchangeRate;
            this.paymentTerm=paymentTerm;
            this.paymentMethod=paymentMethod;
            this.lPNumber=lPNumber;
            this.distributor=distributor;
            this.isEdit=isEdit;
            
        }
    }
    
    public static ConsignmentStockWrapper parse(String json) {
        return (ConsignmentStockWrapper) System.JSON.deserialize(json, ConsignmentStockWrapper.class);
    }
}