public class StockReturnEntry{

  


    
    public list<Account> lstDistributor{get;set;}
    public list<SelectOption> selistDistributor{get;set;}
    public string distributorId{get;set;}
    public string distCode{get;set;}
    public string depot{get;set;}
    public boolean showtable{get;set;}
    public list<Invoice_Line_Item__c> lstInvoiceItems;
    public list<SelectOption> selstProductSku{get;set;}
    public list<SelectOption> selstInvoice{get;set;}
    public String invoiceItemId{get;set;}
    public list <Invoice__c> lstInvoices{get;set;}
    public string invoiceId{get;set;}
    public Date returnDate{get;set;}
    public list<Distributor_Depot_Mapping__c> lstDistDepotMap;
    public list<SelectOption> SelLstStockCondtn{get;set;}
    public string stockCondtn{get;set;}
    public string stkRtnQty {get;set;}
    public string batchNum {get;set;}
    public string resonStkReturn {get;set;}
    public string distName{get;set;}
    public list<list<Invoice__c>> lstoflstInvoice{get;set;}
    public list<list<Invoice_Line_Item__c>> lstoflstprdSKU{get;set;}
    public string prodName{get;set;}
    public string InvNum{get;set;}
    public list<Return_Item__c> lstReturnItem{get;set;}
    public list<StockReturnItem> lststkRtnItmObj{get;set;}
    public integer rowNum {get;set;}
    public map<string,decimal> mapReturnQty;
    public string qtyErrorMsg{get;set;} 
    public string stockRetunName{get;set;}
    public string noInvErrorMsg{get;set;}
    public string errBatch{get;set;}
    public string errInvAndItem{get;set;}
    public map<string,Invoice_Line_Item__c> mapInvLineItem;
    public list<Invoice_Line_Item__c> lstInvItemBatch{get;set;} 
    public string invitemBatch{get;set;}
    public list<Territory_Distributor__c > lstTerritory;
    public String terErr{get;set;}
     
    /*public StockReturnEntry(){  
        errBatch = '';   
        batchNum = '';
        rowNum = 0;
        terErr = '';
        errInvAndItem = '';
        distName = '';
        stkRtnQty = '';
        invitemBatch = '';
        prodName = '';
        invoiceId = '';
        InvNum = '';
        distributorId = '';
        resonStkReturn = '';
        qtyErrorMsg = '';
        noInvErrorMsg = ''; 
        string userId = UserInfo.getUserId();
        string userName = UserInfo.getName();
        depot = '';
        stockRetunName  ='';
        invoiceItemId = '';
        stockCondtn = '';
        lstTerritory = new list<Territory_Distributor__c >();
        lstTerritory = [SELECT Id, Name, TerritoryCode__c, TerritoryManager__c,Present_in_KEDE__c,Neglected__c,Regional_Manager_Id__c, Zonal_Manager_Id__c, SBU_Head_Id__c 
                        FROM Territory_Distributor__c WHERE TerritoryManager__c =:userId AND Present_in_KEDE__c = true AND Neglected__c = false LIMIT 1];
        if(lstTerritory.isEmpty()){
            terErr = 'There Is no Territory assign to '+userName ;
        }
        showtable = false;
        lstInvItemBatch = new list<Invoice_Line_Item__c>();
        mapReturnQty = new map<string,decimal>();
        returnDate = date.newInstance(system.today().year(),system.today().Month(),system.today().day());
        lststkRtnItmObj = new list<StockReturnItem>();
        lstReturnItem = new list<Return_Item__c>();
        SelLstStockCondtn = new list<Selectoption>();
        SelLstStockCondtn.add(new SelectOption('Good','Good'));
        SelLstStockCondtn.add(new SelectOption('Damaged','Damaged'));
        SelLstStockCondtn.add(new SelectOption('Leakage','Leakage'));
        SelLstStockCondtn.add(new SelectOption('Expired','Expired'));
        string profileName = [SELECT Name FROM profile WHERE id =: userinfo.getProfileId()].name;    
        lstDistributor = new list<Account>();
        selistDistributor = new list<SelectOption>();    
        Id recordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        if(profileName == 'Territory Manager'){
            lstDistributor = [SELECT id, Name FROM Account WHERE OwnerId =: userId AND  Sales_Org_Code__c ='1000' AND RecordType.Id =:recordTypeIdAccount ORDER BY Name];    
            selistDistributor.add(new SelectOption('Select','--Select--'));
            if(!lstDistributor.isEmpty()){   
                for(Account acc : lstDistributor){
                    selistDistributor.add(new SelectOption(acc.id,acc.Name));            
                }            
            }
        }   
    }*/
    
      public StockReturnEntry(ApexPages.StandardController controller) {
        try{
        errBatch = '';   
        batchNum = '';
        rowNum = 0;
        terErr = '';
        errInvAndItem = '';
        distName = '';
        stkRtnQty = '';
        invitemBatch = '';
        prodName = '';
        invoiceId = '';
        InvNum = '';
        distributorId = '';
        resonStkReturn = '';
        qtyErrorMsg = '';
        noInvErrorMsg = ''; 
        string userId = UserInfo.getUserId();
        string userName = UserInfo.getName();
        depot = '';
        stockRetunName  ='';
        invoiceItemId = '';
        stockCondtn = '';
        lstTerritory = new list<Territory_Distributor__c >();
        lstTerritory = [SELECT Id, Name, TerritoryCode__c, TerritoryManager__c,Present_in_KEDE__c,Neglected__c,Regional_Manager_Id__c, Zonal_Manager_Id__c, SBU_Head_Id__c 
                        FROM Territory_Distributor__c WHERE TerritoryManager__c =:userId AND Present_in_KEDE__c = true AND Neglected__c = false LIMIT 1];
        if(lstTerritory.isEmpty()){
            terErr = 'There Is no Territory assign to '+userName ;
        }
        showtable = false;
        lstInvItemBatch = new list<Invoice_Line_Item__c>();
        mapReturnQty = new map<string,decimal>();
        returnDate = date.newInstance(system.today().year(),system.today().Month(),system.today().day());
        lststkRtnItmObj = new list<StockReturnItem>();
        lstReturnItem = new list<Return_Item__c>();
        SelLstStockCondtn = new list<Selectoption>();
        SelLstStockCondtn.add(new SelectOption('Good','Good'));
        SelLstStockCondtn.add(new SelectOption('Damaged','Damaged'));
        SelLstStockCondtn.add(new SelectOption('Leakage','Leakage'));
        SelLstStockCondtn.add(new SelectOption('Expired','Expired'));
        string profileName = [SELECT Name FROM profile WHERE id =: userinfo.getProfileId()].name;    
        lstDistributor = new list<Account>();
        selistDistributor = new list<SelectOption>();    
        Id recordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        if(profileName == 'Territory Manager'){
            lstDistributor = [SELECT id, Name FROM Account WHERE OwnerId =: userId AND  Sales_Org_Code__c ='1000' AND RecordType.Id =:recordTypeIdAccount ORDER BY Name];    
            selistDistributor.add(new SelectOption('Select','--Select--'));
            if(!lstDistributor.isEmpty()){   
                for(Account acc : lstDistributor){
                    selistDistributor.add(new SelectOption(acc.id,acc.Name));            
                }            
            }
        }  
        }catch(exception e){
            system.debug('Error Line Number >>--->'+e.getLineNumber());
            system.debug('Error Message >>--->'+e.getMessage());
            
        }
         
    }
    
    public void updatelineitem(){
        try{
            system.debug('invoiceItemId>>--->'+invoiceItemId);
            list<Invoice_Line_Item__c> lstinvoiceitenms = [SELECT Id, Name, Invoice__c, Invoice__r.Billing_Doc_Number__c, Batch__c, Product__c, Quantity__c, SKU__c, SKU__r.Product_with_SKU__c, Product_Name__c FROM Invoice_Line_Item__c WHERE id=:invoiceItemId];
            for(Invoice_Line_Item__c invitem : lstinvoiceitenms){
                invitemBatch = invitem.Batch__c;
            }
        }catch(exception e){
            system.debug('Error Line Number >>--->'+e.getLineNumber());
            system.debug('Error Message >>--->'+e.getMessage());   
        }
    }
    public void  getDistCodeDepot(){
        
        system.debug('distributorId>>----->'+distributorId);
        try{
         lstDistDepotMap = new list<Distributor_Depot_Mapping__c>();
        if(distributorId != ''){
            //distCode = [SELECT SAP_Code__c FROM Account WHERE id =:distributorId].SAP_Code__c;
            lstDistDepotMap = [SELECT Depot__c,Depot__r.Name,Distributor__c,Distributor__r.Name ,Distributor__r.SAP_Code__c  FROM Distributor_Depot_Mapping__c WHERE Distributor__c =:distributorId];
            if(!lstDistDepotMap.isEmpty()){
                depot = lstDistDepotMap[0].Depot__r.Name;
                distName = lstDistDepotMap[0].Distributor__r.Name;
                distCode = lstDistDepotMap[0].Distributor__r.SAP_Code__c;
                showtable = true;
                system.debug('distributor Code>>----->'+distCode);
                system.debug('distributor Depot>>----->'+depot);
                lstInvoiceItems = new list<Invoice_Line_Item__c>();
                lstInvoiceItems = [SELECT Id, Name, Invoice__c, Invoice__r.Billing_Doc_Number__c, Batch__c, Product__c, Quantity__c, SKU__c, SKU__r.Product_with_SKU__c, Product_Name__c 
                                    FROM Invoice_Line_Item__c WHERE Invoice__r.Sold_To_Party__c =: lstDistDepotMap[0].Distributor__c ORDER BY SKU__r.Product_with_SKU__c ];

                lstInvoices = new list<Invoice__c>(); 
                lstInvoices = [SELECT Id,Name,Sold_To_Party__c, Billing_Date__c, Billing_Doc_Number__c, Sales_Org__c, Depot__c, Depot__R.NAME, Delivery_Number__c FROM Invoice__c WHERE  Sold_To_Party__c =:lstDistDepotMap[0].Distributor__c ORDER BY Billing_Doc_Number__c ];
                system.debug('Depot>>----->'+lstDistDepotMap[0].Depot__r.name);  
                lstoflstprdSKU = new list<list<Invoice_Line_Item__c>>(); 
                mapInvLineItem = new map<string,Invoice_Line_Item__c>();
                lstoflstInvoice = new list<list<Invoice__c>>();
                
                for(Invoice_Line_Item__c invitem : lstInvoiceItems){
                    if(!mapInvLineItem.containskey(invitem.SKU__r.Product_with_SKU__c)){
                        mapInvLineItem.put(invitem.SKU__r.Product_with_SKU__c,invitem);    
                    }
                }
                if(lstInvoices.size()<999){
                    list<Invoice__c> lstinv = new list<Invoice__c>();
                    for(Invoice__c inv : lstInvoices){
                        if(lstinv.size()<999){
                            lstinv.add(inv);
                        }else{
                            lstoflstInvoice.add(lstinv);
                            lstinv = new list<Invoice__c>();
                        } 
                    }
                    if(lstinv.size()>0){
                        lstoflstInvoice.add(lstinv);
                    }
                    }else{
                        lstoflstInvoice.add(lstInvoices);
                    } 
                 
               
                if(mapInvLineItem.values().size()<999){
                    list<Invoice_Line_Item__c> lstInvoiceItem = new list<Invoice_Line_Item__c>();
                    for(Invoice_Line_Item__c invitem : mapInvLineItem.values()){
                        if(lstInvoiceItem.size()<999){
                            lstInvoiceItem.add(invitem );
                        }else{
                            lstoflstprdSKU .add(lstInvoiceItem);
                            lstInvoiceItem = new list<Invoice_Line_Item__c>();
                        } 
                    }
                    if(lstInvoiceItem.size()>0){
                        lstoflstprdSKU.add(lstInvoiceItem);
                    }
                    }else{
                        lstoflstprdSKU.add(mapInvLineItem.values());
                    } 
  
                system.debug('lstoflstprdSKU size >>----->'+lstoflstprdSKU.size());
                if(lstInvoices.isEmpty()){
                    noInvErrorMsg = 'No Invoices available for Distributor.'; 
                    system.debug('noInvErrorMsg>>----->'+noInvErrorMsg);
                }else{
                noInvErrorMsg = '';
                }
                system.debug('lstInvoices>>----->'+lstInvoices.size());
                system.debug('lstoflstInvoice>>----->'+lstoflstInvoice.size());
                
                selstProductSku = new list<SelectOption>();
                selstProductSku.add(new Selectoption('Select','--Select--'));
                selstInvoice = new list<SelectOption>();
                selstInvoice.add(new SelectOption('Select','--Select--'));
                
                for(Invoice__c inv : lstInvoices){
                for(Invoice_Line_Item__c invItem : inv.Invoice_Line_Item__r){
                   system.debug(invItem.SKU__r.Product_with_SKU__c);
                   selstProductSku.add(new selectoption(invItem.id,invItem.SKU__r.Product_with_SKU__c));
                }
                 selstInvoice.add(new SelectOption(inv.id,inv.Billing_Doc_Number__c));
            }
                
                /*for(Invoice__c  inv : lstInvoices){
                    selstInvoice.add(new SelectOption(inv.id,inv.name));
                }*/
            }
        }else{
        showtable = false;
        depot = '';
        distCode = '';
        }
         }catch(exception e){
            system.debug('Error Line Number >>--->'+e.getLineNumber());
            system.debug('Error Message >>--->'+e.getMessage());
            
        }   
    }
    
    public void changeProductlist(){
        try{
        invitemBatch = '';
        system.debug('invoiceId>>--->'+invoiceId+'\nInvNum>>--->'+InvNum );
        if(invoiceId != '' && !lstDistDepotMap.isEmpty()){
            list<Invoice_Line_Item__c> lstInvLineItems = new list<Invoice_Line_Item__c>();           
            lstInvLineItems = [SELECT Id, Name, Invoice__c, Invoice__r.Billing_Doc_Number__c, Batch__c, Product__c, Quantity__c, SKU__c, SKU__r.Product_with_SKU__c,product_Name__c 
                                    FROM Invoice_Line_Item__c WHERE Invoice__c =:invoiceId AND Invoice__r.Sold_To_Party__c =: lstDistDepotMap[0].Distributor__c ORDER BY SKU__r.Product_with_SKU__c];                     
            for(Invoice_Line_Item__c inv :lstInvLineItems ){
                InvNum = inv.Invoice__r.Billing_Doc_Number__c;
            }
            system.debug('invoiceId >----->'+invoiceId);
            system.debug('product size>----->'+lstInvLineItems.size());
            list<Invoice__c> lstinv = new list<Invoice__c>();
            lstoflstprdSKU = new list<list<Invoice_Line_Item__c>>();
            mapInvLineItem = new map<string,Invoice_Line_Item__c>();
            
             for(Invoice_Line_Item__c invitem : lstInvLineItems){
                    if(!mapInvLineItem.containskey(invitem.SKU__r.Product_with_SKU__c)){
                        mapInvLineItem.put(invitem.SKU__r.Product_with_SKU__c,invitem);    
                    }
                }
            
             if(mapInvLineItem.values().size()<999){
                    list<Invoice_Line_Item__c> lstInvoiceItem = new list<Invoice_Line_Item__c>();
                    for(Invoice_Line_Item__c invitem : mapInvLineItem.values()){
                        if(lstInvoiceItem.size()<999){
                            lstInvoiceItem.add(invitem );
                        }else{
                            lstoflstprdSKU .add(lstInvoiceItem);
                            lstInvoiceItem = new list<Invoice_Line_Item__c>();
                        } 
                    }
                    if(lstInvoiceItem.size()>0){
                        lstoflstprdSKU.add(lstInvoiceItem);
                    }
                    }else{
                        lstoflstprdSKU.add(mapInvLineItem.values());
                    } 
            
            
            
            system.debug('lstoflstprdSKU>>--->'+lstoflstprdSKU.size());   
            selstProductSku = new list<SelectOption>();
            for(Invoice__c inv : lstInvoices){
                for(Invoice_Line_Item__c invItem : inv.Invoice_Line_Item__r){
                   system.debug(invItem.SKU__r.Product_with_SKU__c);
                   selstProductSku.add(new selectoption(invItem.id,invItem.SKU__r.Product_with_SKU__c));
                }
             
            }
        }
        
         }catch(exception e){
            system.debug('Error Line Number >>--->'+e.getLineNumber());
            system.debug('Error Message >>--->'+e.getMessage());
            
        }
    }
    
    public void changeInvoiceList(){
        try{
            invitemBatch = '';
            system.debug('prodName >>--->'+prodName);
            system.debug('invoiceId>>--->'+invoiceId);
            list<Invoice_Line_Item__c> lstinvLineItem = new list<Invoice_Line_Item__c>();
            lstInvoices = new list<Invoice__c>();
            if(!lstDistDepotMap.isEmpty()){
               
                list<Invoice__c> lstPrdctInvoices = new list<Invoice__c>();
                lstInvoices = [SELECT Id,Name,Sold_To_Party__c, Billing_Date__c, Billing_Doc_Number__c, Sales_Org__c, Depot__c, Depot__R.NAME, Delivery_Number__c
                                 FROM Invoice__c WHERE Id IN (SELECT Invoice__c FROM Invoice_Line_Item__c WHERE SKU__r.Product_with_SKU__c =: prodName AND Invoice__r.Sold_To_Party__c =:lstDistDepotMap[0].Distributor__c) ORDER BY Billing_Doc_Number__c];
                system.debug('lstInvoices>>--->'+lstInvoices.size());
                lstoflstInvoice = new list<list<Invoice__c>>();
                list<Invoice__c> lstinv = new list<Invoice__c>();
            if(lstInvoices.size()>999){
           
                     for(Invoice__c inv : lstInvoices){
                         if(lstinv.size()<999 ){  
                            lstinv.add(inv);
                         }else{
                             lstoflstInvoice.add(lstinv);
                             lstinv = new list<Invoice__c>();
                         }      
                     }
                     if(lstinv.size()>0){
                         lstoflstInvoice.add(lstinv);   
                         }
                 }else{
                     system.debug('inside else');
                     lstoflstInvoice.add(lstInvoices);
                  }                  
                system.debug('lstoflstInvoice>>--->'+lstoflstInvoice.size());
                selstInvoice = new list<SelectOption>();
                selstInvoice.add(new SelectOption('Select','--Select--'));
                for(Invoice__c inv : lstPrdctInvoices){
                    selstInvoice.add(new SelectOption(inv.id,inv.name));
                }
            }
          }catch(exception e){
            system.debug('Error Line Number >>--->'+e.getLineNumber());
            system.debug('Error Message >>--->'+e.getMessage());
            
        }
        
    }
    
    public void updateInvoiceId(){
        try{
        system.debug('invoiceId>>--->'+invoiceId);
        system.debug('prodName >>--->'+prodName);
        lstInvItemBatch = new  list<Invoice_Line_Item__c>();
        lstInvItemBatch = [SELECT Id, Name, Invoice__c, Invoice__r.Billing_Doc_Number__c, Batch__c, Product__c, Quantity__c, SKU__c, SKU__r.Product_with_SKU__c, Product_Name__c 
                                    FROM Invoice_Line_Item__c WHERE  SKU__r.Product_with_SKU__c =: prodName AND Invoice__c =: invoiceId AND Invoice__r.Sold_To_Party__c =: lstDistDepotMap[0].Distributor__c ORDER BY SKU__r.Product_with_SKU__c];
        
        system.debug('lstInvItemBatch>>----->'+lstInvItemBatch.size());
        list<Invoice__c> lstInv  = new list<Invoice__c>();
        lstInv = [SELECT Id,Name,Sold_To_Party__c, Billing_Date__c, Billing_Doc_Number__c FROM Invoice__c where id =:invoiceId];
        
        for(Invoice__c inv :lstInv){
            InvNum = inv.Billing_Doc_Number__c;
        }
        }catch(exception e){
            system.debug('Error Line Number >>--->'+e.getLineNumber());
            system.debug('Error Message >>--->'+e.getMessage());
            
        }
    }
    
    public void updateinv(){
    try{
    if(!lstDistDepotMap.isEmpty()){
    lstInvoiceItems = new list<Invoice_Line_Item__c>();
    lstInvoiceItems = [SELECT Id, Name, Invoice__c, Invoice__r.Billing_Doc_Number__c, Batch__c, Product__c, Quantity__c, SKU__c, SKU__r.Product_with_SKU__c, Product_Name__c 
                                    FROM Invoice_Line_Item__c WHERE Invoice__r.Sold_To_Party__c =: lstDistDepotMap[0].Distributor__c ORDER BY SKU__r.Product_with_SKU__c ];

    lstInvoices = new list<Invoice__c>(); 
    lstInvoices = [SELECT Id,Name,Sold_To_Party__c, Billing_Date__c, Billing_Doc_Number__c, Sales_Org__c, Depot__c, Depot__R.NAME, Delivery_Number__c FROM Invoice__c WHERE  Sold_To_Party__c =:lstDistDepotMap[0].Distributor__c ORDER BY Billing_Doc_Number__c ];
    system.debug('lstInvoices>>--->'+lstInvoices.size());
    system.debug('Depot>>----->'+lstDistDepotMap[0].Depot__r.name);  
                lstoflstprdSKU = new list<list<Invoice_Line_Item__c>>(); 
                mapInvLineItem = new map<string,Invoice_Line_Item__c>();
                lstoflstInvoice = new list<list<Invoice__c>>();
                
                for(Invoice_Line_Item__c invitem : lstInvoiceItems){
                    if(!mapInvLineItem.containskey(invitem.SKU__r.Product_with_SKU__c)){
                        mapInvLineItem.put(invitem.SKU__r.Product_with_SKU__c,invitem);    
                    }
                }
                if(lstInvoices.size()<999){
                    list<Invoice__c> lstinv = new list<Invoice__c>();
                    for(Invoice__c inv : lstInvoices){
                        if(lstinv.size()<999){
                            lstinv.add(inv);
                        }else{
                            lstoflstInvoice.add(lstinv);
                            lstinv = new list<Invoice__c>();
                        } 
                    }
                    if(lstinv.size()>0){
                        lstoflstInvoice.add(lstinv);
                    }
                    }else{
                        lstoflstInvoice.add(lstInvoices);
                    } 
                 
               
                if(mapInvLineItem.values().size()<999){
                    list<Invoice_Line_Item__c> lstInvoiceItem = new list<Invoice_Line_Item__c>();
                    for(Invoice_Line_Item__c invitem : mapInvLineItem.values()){
                        if(lstInvoiceItem.size()<999){
                            lstInvoiceItem.add(invitem );
                        }else{
                            lstoflstprdSKU .add(lstInvoiceItem);
                            lstInvoiceItem = new list<Invoice_Line_Item__c>();
                        } 
                    }
                    if(lstInvoiceItem.size()>0){
                        lstoflstprdSKU.add(lstInvoiceItem);
                    }
                    }else{
                        lstoflstprdSKU.add(mapInvLineItem.values());
                    } 
  
                 
                 prodName ='';
                 InvNum = '';  
                 invitemBatch = '';
                 invoiceId ='';
                 invoiceItemId = '';
          }      
      }catch(exception e){
            system.debug('Error Line Number >>--->'+e.getLineNumber());
            system.debug('Error Message >>--->'+e.getMessage());
            
        }
     
    }
    
    public void addToItemList(){
        try{
        Integer days = 0;
        decimal trnprtCstCustToDpt = 0.0;
        decimal trnprtCstDptToCust = 0.0;
        list<Invoice_Line_Item__c>lstInvoiceItem = new list<Invoice_Line_Item__c>();
        system.debug('invoiceItemId>>--->'+invoiceItemId);
        system.debug('invoiceId>>--->'+invoiceId);
        StockReturnItem stkRtnItmObj = new StockReturnItem(); 
        lstInvoiceItem = [SELECT  Id, Name, Invoice__c, Batch__c,Product__c,Quantity__c,SKU__c,SKU__r.Product_with_SKU__c, Product_Name__c 
                             FROM Invoice_Line_Item__c WHERE id =: invoiceItemId AND Invoice__c =:invoiceId AND Invoice__r.Sold_To_Party__c =: lstDistDepotMap[0].Distributor__c];
        system.debug('lstInvoiceItem>>--->'+lstInvoiceItem);
        if(!lstInvoiceItem.isEmpty()){
            for(Invoice_Line_Item__c invitem : lstInvoiceItem){
                stkRtnItmObj.rtnItm.SKU__c = invitem.SKU__c; 
                stkRtnItmObj.rtnItm.Invoice_Line_Item__c = invitem.id;
                stkRtnItmObj.rtnItm.Invoice__c = invitem.Invoice__c ; 
                 if(!String.isBlank(batchNum)){
                  if(invItem.Batch__c != batchNum ){
                      errBatch = 'Invalid Batch Number.';
                  }
                  else{
                  errBatch = '';
              }
              }else{
                  errBatch = '';
              }           
             }
              for(Invoice_Line_Item__c invitem : lstInvoiceItem){
              if(mapReturnQty.containskey(prodName+invitem.id)){
                  mapReturnQty.put(prodName+invItem.id,mapReturnQty.get(prodName+invitem.id)+Decimal.valueOf(stkRtnQty));
                  system.debug('stock Qty>>--->'+mapReturnQty.get(prodName+invitem.id));
              }
              if(!mapReturnQty.containskey(prodName+invitem.id)){
               mapReturnQty.put(prodName+invitem.id,Decimal.valueOf(stkRtnQty));
               }
              if(invitem.Quantity__c < mapReturnQty.get(prodName+invitem.id)){
                  qtyErrorMsg = 'Return Quantity should be less than Invoice Quantity ('+invitem.Quantity__c+') for '+prodName;
                   mapReturnQty.put(prodName+invitem.id,mapReturnQty.get(prodName+invitem.id)-Decimal.valueOf(stkRtnQty));
                 
              }else{
                  qtyErrorMsg = '';
                  
              }
            
              
        }
        
        stkRtnItmObj.prodName  = prodName;
        stkRtnItmObj.rtnItm.Reference_Invoice_Number__c = InvNum;
        stkRtnItmObj.rtnItm.Stock_Return_Quantity__c = Decimal.valueOf(stkRtnQty);
        Invoice_Line_Item__c invLineItem = new Invoice_Line_Item__c();
        if(!String.isEmpty(invoiceItemId)){
            invLineItem =[SELECT  Id,Name,Net_Value__c,Quantity__c,Invoice__c,Batch__c,Product__c,SKU__c,SKU__r.Product_with_SKU__c,Product_Name__c,SalesOrg__r.name FROM Invoice_Line_Item__c WHERE  id =:invoiceItemId limit 1 ];
            stkRtnItmObj.invoiceRate =0.0;
            stkRtnItmObj.invoiceRate = invLineItem.Net_Value__c/invLineItem.Quantity__c;
            stkRtnItmObj.rtnItm.Invoice_Rate__c =  invLineItem.Net_Value__c/invLineItem.Quantity__c;
            if(invLineItem.Quantity__c>0){
                stkRtnItmObj.stkRetVal = 0;
                stkRtnItmObj.stkRetVal = (stkRtnItmObj.invoiceRate) * stkRtnItmObj.rtnItm.Stock_Return_Quantity__c;
               
            }
        }
        stkRtnItmObj.rtnItm.Condition_Of_Stock__c = stockCondtn;
        if(!lstInvoices.isEmpty()){
            days = lstInvoices[0].Billing_Date__c.daysBetween(returnDate);
            system.debug('days>>--->'+days);
        }
        Stock_Return_Values__c stkRtnValObj = new Stock_Return_Values__c();
        stkRtnValObj = [SELECT Admin_Days__c, Freight_Rate__c FROM Stock_Return_Values__c];
        integer adminDays = days - Integer.valueOf(stkRtnValObj.Admin_Days__c);
        trnprtCstCustToDpt = (Decimal.valueof(stkRtnQty) * stkRtnValObj.Freight_Rate__c);
        system.debug('adminDays>>--->'+adminDays);
        stkRtnItmObj.adminChrgs = (stkRtnItmObj.stkRetVal )*(( adminDays  * 0.033)/100);
        system.debug('return value>>--->'+stkRtnItmObj.stkRetVal);
        system.debug('days>>--->'+( adminDays * 0.033)/100);
        system.debug('admincharges>>--->'+stkRtnItmObj.adminChrgs);
        
        stkRtnItmObj.rtnItm.Date_Of_Return__c = returnDate;
        stkRtnItmObj.TotalDebVal = stkRtnItmObj.adminChrgs + trnprtCstCustToDpt + trnprtCstCustToDpt;
        stkRtnItmObj.rtnItm.Reason_for_StockReturn__c = resonStkReturn;
        if(qtyErrorMsg == '' && errBatch == '' ){
            lststkRtnItmObj.add(stkRtnItmObj);
        }
        system.debug('invoiceItemId>>----->'+invoiceItemId);
        system.debug('batchNum>>----->'+batchNum);
        system.debug('invoiceId>>----->'+invoiceId);
        system.debug('stkRtnQty>>----->'+stkRtnQty);
        system.debug('returnDate>>----->'+returnDate);
        system.debug('stockCondtn>>----->'+stockCondtn);
        system.debug('resonStkReturn>>----->'+resonStkReturn);
        system.debug('distributorId>>----->'+distributorId);
        //if(string.isEmpty(qtyErrorMsg) && string.isEmpty(errBatch)){
        prodName ='';
        InvNum ='';
        invoiceItemId ='';
        returnDate = date.newInstance(system.today().year(),system.today().Month(),system.today().day());
        system.debug('returnDate>>----->'+returnDate);
        batchNum ='';
        stkRtnQty = '';
        stockCondtn ='';
        resonStkReturn ='';
        invitemBatch = '';
        invoiceId ='';
        lstInvItemBatch = new list<Invoice_Line_Item__c>();
        getDistCodeDepot();
        //} 
        }else{
            errInvAndItem = 'Invalid Combination of Invoice and Product/SKU ';
        }
         }catch(exception e){
            system.debug('Error Line Number >>--->'+e.getLineNumber());
            system.debug('Error Message >>--->'+e.getMessage());
            
        }
    }
    
   
   public pagereference  saveReturnItems(){
       try{
       system.debug('----start----');
       list<Return_Item__c> lstreturnItem = new list<Return_Item__c>();
       Stock_Return__c stckRtrnObj = new Stock_Return__c(); 
       stckRtrnObj.Customer_Name__c = lstDistDepotMap[0].Distributor__c;  
       stckRtrnObj.Depot__c = lstDistDepotMap[0].Depot__c;  
       if(!lstTerritory.isEmpty()){
           for(Territory_Distributor__c ter : lstTerritory){ 
               stckRtrnObj.Territory__c = ter.id; 
               //stckRtrnObj.Regional_Manager__c = ter.Regional_Manager_Id__c;
               stckRtrnObj.Zonal_Head__c = ter.Zonal_Manager_Id__c;
               stckRtrnObj.SBU_Head__c = ter.SBU_Head_Id__c;
           }
       }
       if(stckRtrnObj!=NULL){
           insert stckRtrnObj;
       }
       system.debug('stckRtrnObj>>--->'+stckRtrnObj);
       stockRetunName = stckRtrnObj.id; 
       
         system.debug('stockRetun id>>--->'+stockRetunName );
       for(StockReturnItem stkRtnItem :lststkRtnItmObj){
       
           stkRtnItem.rtnItm.Stock_Return__c = stckRtrnObj.id;
           lstreturnItem.add(stkRtnItem.rtnItm);
       }
       system.debug('lstreturnItem>>--->'+lstreturnItem.size());
       system.debug('lstreturnItem>>--->'+lstreturnItem);
       if(!lstreturnItem.isEmpty()){
           insert lstreturnItem;
       }
       
       if(stckRtrnObj!=NULL){
           stckRtrnObj.Sent_to_Approval__c = true;
           system.debug('update stock return');
           update stckRtrnObj;
       }
       system.debug('stockRetunName>>--->'+stockRetunName);
      pagereference  pageref = new ApexPages.StandardController(stckRtrnObj).view();
      pageref.setRedirect(true);
      
      system.debug('----End----');
      return pageref;
       }catch(exception e){
            system.debug('Error Line Number >>--->'+e.getLineNumber());
            system.debug('Error Message >>--->'+e.getMessage());
            return null;
        }
   }
   public void removeItem(){
       try{
       system.debug('lststkRtnItmObj>>--->'+lststkRtnItmObj.size());
       StockReturnItem stkRtnItem = new StockReturnItem();
       system.debug('rowNum>>--->'+rowNum);
       stkRtnItem  = lststkRtnItmObj.get(rowNum-1);
       mapReturnQty.put(stkRtnItem.prodName+stkRtnItem.rtnItm.Invoice_Line_Item__c,mapReturnQty.get(stkRtnItem.prodName+stkRtnItem.rtnItm.Invoice_Line_Item__c)-stkRtnItem.rtnItm.Stock_Return_Quantity__c);
       lststkRtnItmObj.remove(rowNum-1);
       system.debug('lststkRtnItmObj>>--->'+lststkRtnItmObj.size());
        }catch(exception e){
            system.debug('Error Line Number >>--->'+e.getLineNumber());
            system.debug('Error Message >>--->'+e.getMessage());
            
        }
   } 
   public class StockReturnItem{   
       public string prodName {get;set;}
       public decimal stkRetVal {get;set;}
       public decimal TotalDebVal {get;set;}
       public Return_Item__c rtnItm{get;set;}
       public decimal adminChrgs{get;set;} 
       public decimal invoiceRate{get;set;}
       
   public StockReturnItem (){
       prodName = '';
       invoiceRate = 0.0;
       rtnItm = new Return_Item__c();
       stkRetVal = 0.0;
       TotalDebVal = 0.0;
       adminChrgs = 0.0;
   }
   
   }
}