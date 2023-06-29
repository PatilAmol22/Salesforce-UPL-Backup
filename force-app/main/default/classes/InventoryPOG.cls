public without sharing class InventoryPOG {
    
    @auraenabled
    public static CampaignWrap getCampaign(String Product_Campaign)
    {
        CampaignWrap wr = new CampaignWrap();
        switch on Product_Campaign {
            when 'C01' {
                Date todayDate = System.Today();
                String startt = ''+System.Today().year()+'-01-01';
                Date startdate= date.valueOf(startt);
                if (startdate>todayDate)
                {
                    Integer year =   System.Today().year() - 1;
                    startt=''+year+'-01-01';
                    startDate= date.valueOf(startt);
                }
                System.debug('start date is '+ startdate +'    '+ todayDate);
                DateTime endDate = startDate.addMonths(12).addDays(-1);  
                wr.Campaign='C1';
                wr.Start_Date=date.valueOf(startt) ;
                wr.End_Date=date.valueOf(endDate); 
                return wr;
            }
            when 'C02' {
                Date todayDate = System.Today();
                String startt = ''+System.Today().year()+'-02-01';
                Date startdate= date.valueOf(startt);
                if (startdate>todayDate)
                {
                    Integer year =   System.Today().year() - 1;
                    startt=''+year+'-02-01';
                    startDate= date.valueOf(startt);
                }
                System.debug('start date is '+ startdate +'    '+ todayDate);
                System.debug('start date is '+ startdate);
                DateTime endDate = startDate.addMonths(12).addDays(-1);
                //String endd = '31-12-'+System.Today().addMonths(11).year()+'';  
                wr.Campaign='C2';
                wr.Start_Date=date.valueOf(startt) ;
                wr.End_Date=date.valueOf(endDate); 
                return wr;
            }
            when 'C03' {
                Date todayDate = System.Today();
                String startt = ''+System.Today().year()+'-03-01';
                Date startdate= date.valueOf(startt);
                if (startdate>todayDate)
                {
                    Integer year =   System.Today().year() - 1;
                    startt=''+year+'-03-01';
                    startDate= date.valueOf(startt);
                }
                System.debug('start date is '+ startdate +'    '+ todayDate);
                System.debug('start date is '+ startdate);
                DateTime endDate = startDate.addMonths(12).addDays(-1);
                //String endd = '31-12-'+System.Today().addMonths(11).year()+'';  
                wr.Campaign='C3';
                wr.Start_Date=date.valueOf(startt) ;
                wr.End_Date=date.valueOf(endDate); 
                return wr;
            }
            when 'C04' {
                Date todayDate = System.Today();
                String startt = ''+System.Today().year()+'-04-01';
                Date startdate= date.valueOf(startt);
                if (startdate>todayDate)
                {
                    Integer year =   System.Today().year() - 1;
                    startt=''+year+'-04-01';
                    startDate= date.valueOf(startt);
                }
                System.debug('start date is '+ startdate +'    '+ todayDate);
                System.debug('start date is '+ startdate);
                DateTime endDate = startDate.addMonths(12).addDays(-1);
                //String endd = '31-12-'+System.Today().addMonths(11).year()+'';  
                wr.Campaign='C4';
                wr.Start_Date=date.valueOf(startt) ;
                wr.End_Date=date.valueOf(endDate); 
                return wr;
            }
            when 'C05' {
                Date todayDate = System.Today();
                String startt = ''+System.Today().year()+'-05-01';
                Date startdate= date.valueOf(startt);
                if (startdate>todayDate)
                {
                    Integer year =   System.Today().year() - 1;
                    startt=''+year+'-05-01';
                    startDate= date.valueOf(startt);
                }
                System.debug('start date is '+ startdate +'    '+ todayDate);
                System.debug('start date is '+ startdate);
                DateTime endDate = startDate.addMonths(12).addDays(-1);
                //String endd = '31-12-'+System.Today().addMonths(11).year()+'';  
                wr.Campaign='C5';
                wr.Start_Date=date.valueOf(startt) ;
                wr.End_Date=date.valueOf(endDate); 
                return wr;
            }
            when 'C06' {
                Date todayDate = System.Today();
                String startt = ''+System.Today().year()+'-06-01';
                Date startdate= date.valueOf(startt);
                if (startdate>todayDate)
                {
                    Integer year =   System.Today().year() - 1;
                    startt=''+year+'-06-01';
                    startDate= date.valueOf(startt);
                }
                System.debug('start date is '+ startdate +'    '+ todayDate);
                System.debug('start date is '+ startdate);
                DateTime endDate = startDate.addMonths(12).addDays(-1);
                //String endd = '31-12-'+System.Today().addMonths(11).year()+'';  
                wr.Campaign='C6';
                wr.Start_Date=date.valueOf(startt) ;
                wr.End_Date=date.valueOf(endDate); 
                return wr;
            }
            when 'C07' {
                Date todayDate = System.Today();
                String startt = ''+System.Today().year()+'-07-01';
                Date startdate= date.valueOf(startt);
                if (startdate>todayDate)
                {
                    Integer year =   System.Today().year() - 1;
                    startt=''+year+'-07-01';
                    startDate= date.valueOf(startt);
                }
                System.debug('start date is '+ startdate +'    '+ todayDate);
                System.debug('start date is '+ startdate);
                DateTime endDate = startDate.addMonths(12).addDays(-1);
                //String endd = '31-12-'+System.Today().addMonths(11).year()+'';  
                wr.Campaign='C7';
                wr.Start_Date=date.valueOf(startt) ;
                wr.End_Date=date.valueOf(endDate); 
                return wr;
            }
            when 'C08' {
                Date todayDate = System.Today();
                String startt = ''+System.Today().year()+'-08-01';
                Date startdate= date.valueOf(startt);
                if (startdate>todayDate)
                {
                    Integer year =   System.Today().year() - 1;
                    startt=''+year+'-08-01';
                    startDate= date.valueOf(startt);
                }
                System.debug('start date is '+ startdate +'    '+ todayDate);
                System.debug('start date is '+ startdate);
                DateTime endDate = startDate.addMonths(12).addDays(-1);
                //String endd = '31-12-'+System.Today().addMonths(11).year()+'';  
                wr.Campaign='C8';
                wr.Start_Date=date.valueOf(startt) ;
                wr.End_Date=date.valueOf(endDate); 
                return wr;
            }
            when 'C09' {
                Date todayDate = System.Today();
                String startt = ''+System.Today().year()+'-09-01';
                Date startdate= date.valueOf(startt);
                if (startdate>todayDate)
                {
                    Integer year =   System.Today().year() - 1;
                    startt=''+year+'-09-01';
                    startDate= date.valueOf(startt);
                }
                System.debug('start date is '+ startdate +'    '+ todayDate);
                System.debug('start date is '+ startdate);
                DateTime endDate = startDate.addMonths(12).addDays(-1);
                //String endd = '31-12-'+System.Today().addMonths(11).year()+'';  
                wr.Campaign='C9';
                wr.Start_Date=date.valueOf(startt) ;
                wr.End_Date=date.valueOf(endDate); 
                return wr;
            }
            when 'C10' {
                Date todayDate = System.Today();
                String startt = ''+System.Today().year()+'-10-01';
                Date startdate= date.valueOf(startt);
                if (startdate>todayDate)
                {
                    Integer year =   System.Today().year() - 1;
                    startt=''+year+'-10-01';
                    startDate= date.valueOf(startt);
                }
                System.debug('start date is '+ startdate +'    '+ todayDate);
                System.debug('start date is '+ startdate);
                DateTime endDate = startDate.addMonths(12).addDays(-1);
                //String endd = '31-12-'+System.Today().addMonths(11).year()+'';  
                wr.Campaign='C10';
                wr.Start_Date=date.valueOf(startt) ;
                wr.End_Date=date.valueOf(endDate); 
                return wr;
            }
            when 'C11' {
                Date todayDate = System.Today();
                String startt = ''+System.Today().year()+'-11-01';
                Date startdate= date.valueOf(startt);
                if (startdate>todayDate)
                {
                    Integer year =   System.Today().year() - 1;
                    startt=''+year+'-11-01';
                    startDate= date.valueOf(startt);
                }
                System.debug('start date is '+ startdate +'    '+ todayDate);
                System.debug('start date is '+ startdate);
                DateTime endDate = startDate.addMonths(12).addDays(-1);
                //String endd = '31-12-'+System.Today().addMonths(11).year()+'';  
                wr.Campaign='C11';
                wr.Start_Date=date.valueOf(startt) ;
                wr.End_Date=date.valueOf(endDate); 
                return wr;
            }
            when 'C12' {
                Date todayDate = System.Today();
                String startt = ''+System.Today().year()+'-12-01';
                Date startdate= date.valueOf(startt);
                if (startdate>todayDate)
                {
                    Integer year =   System.Today().year() - 1;
                    startt=''+year+'-12-01';
                    startDate= date.valueOf(startt);
                }
                System.debug('start date is '+ startdate +'    '+ todayDate);
                DateTime endDate = startDate.addMonths(12).addDays(-1); 
                wr.Campaign='C12';
                wr.Start_Date=date.valueOf(startt);
                wr.End_Date=date.valueOf(endDate); 
                return wr;
            }
            when else {		  
                return null;
            }
        }
        
    }
    
    @auraenabled
    public static SKUPaginationWrapper getallSKU(String CustomerID,Date Current_Date)
    { 
        SalesOrgCode__c dat = SalesOrgCode__c.getValues('France');
        Integer d= Integer.valueOf(dat.Inventory_Block_Days__c);
        String SalesOrgCode=dat.Code__c;
        
        date dt = Date.today();
        Id recordId= Id.valueOf(CustomerID);
        String sObjName = recordid.getSObjectType().getDescribe().getName();
        system.debug('value is '+sObjName);
        Account ac = [select account_type__c,id ,name, customer_tag__c,ownerID from account where id =:CustomerID and Sales_Org_Code__c=:SalesOrgCode__c.getValues('France').Code__c limit 1 ];
        String userId = UserInfo.getUserId();
        String custOwner;
        
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        system.debug('ProfileName'+profileName);
        
        SKUPaginationWrapper SKU = new SKUPaginationWrapper();
        /*UserRecordAccess ag= [SELECT HasEditAccess,HasReadAccess,RecordId FROM UserRecordAccess WHERE UserId =:userId and  RecordId=:CustomerID limit 1];
if (ag.HasEditAccess == false)
{
SKU.revokeAccess= true;
}
if(ac.Customer_tag__c == 'U' && profileName!='France System Administrator')
{
SKU.revokeAccess= true;
}
if(ac.Customer_tag__c == 'U' && profileName =='France System Administrator')
{
SKU.revokeAccess= false;
}*/
        //dynamic date picker changes 
        SKU.BlockDate=System.today()-d;
        /*
if (userId!=ac.OwnerId)
{
SKU.revokeAccess= true;
}
if (profileName=='Regional Manager France' || profileName == 'System Administrator' || profileName == 'Technical Manager France')
SKU.revokeAccess= false;
*/
        SKU.CustomerName= ac.name;
        List<Inventory_POG__c> liInventoryPOG = new List<Inventory_POG__c>();
        if(ac.account_type__c != 'Sold To Party')
            liInventoryPOG = Database.query('select Id,Combination_Key__c,SKU_Name__r.Id,SKU_Name__r.SKU_Code__c,SKU_Name__r.Start_Date__c,SKU_Name__r.Current_Fiscal_Year_Last_Date__c,SKU_Name__r.Last_Fiscal_Year__c,SKU_Name__r.Last_Fiscal_Year_End_Date__c,SKU_Name__r.Current_Fiscal_Year_Start_Date__c,SKU_Name__r.SKU_Description__c,SKU_Name__r.UOM__c,tolabel(SKU_Name__r.Product_Campaign__c),Stock_at_Farm_Last_Campaign__c,Stock_Pending_Last_Campaign__c,Marketing_Load__c,Quantity_ordered__c,Quantity_Sold_Current_Campaign__c,Quantity_Sold_Current_Fiscal__c,Quantity_Sold_Last_Fiscal__c,Customer_Name__c,Stock_pending_end_prev_product_campaign__c FROM Inventory_POG__c where Customer_Name__c =:CustomerID and Start_Date__c <=:Current_Date  AND End_Date__c >=:Current_Date ORDER BY SKU_Name__r.SKU_Description__c ASC');
        else
            liInventoryPOG = Database.query('select Id,Combination_Key__c,SKU_Name__r.Id,SKU_Name__r.SKU_Code__c,SKU_Name__r.Start_Date__c,SKU_Name__r.Current_Fiscal_Year_Last_Date__c,SKU_Name__r.Last_Fiscal_Year__c,SKU_Name__r.Last_Fiscal_Year_End_Date__c,SKU_Name__r.Current_Fiscal_Year_Start_Date__c,SKU_Name__r.SKU_Description__c,SKU_Name__r.UOM__c,tolabel(SKU_Name__r.Product_Campaign__c),Stock_at_Farm_Last_Campaign__c,Stock_Pending_Last_Campaign__c,Marketing_Load__c,Quantity_ordered__c,Quantity_Sold_Current_Campaign__c,Quantity_Sold_Current_Fiscal__c,Quantity_Sold_Last_Fiscal__c,Customer_Name__c, Stock_pending_end_prev_product_campaign__c FROM Inventory_POG__c where (Customer_Name__r.Sold_To_Party__c =:CustomerID OR Customer_Name__c =:CustomerID) and Start_Date__c <=:Current_Date  AND End_Date__c >=:Current_Date ORDER BY SKU_Name__r.SKU_Description__c ASC');
        // 21 feb 

        //RITM0222834:added by Sayan(crmcomsultant3),6th Sept,2021
        Map <id ,Sales_Data__c> salesData;
        Map<String, Sales_Data__c> mapSKUSalesData = new Map<String, Sales_Data__c>();
        
        if(ac.account_type__c != 'Sold To Party'){
            salesData = new map <id,Sales_Data__c>([select Customer__c,Destruction_previous_product_campaign__c,Stock_pending_end_prev_product_campaign__c,Last_Calculated_Date__c,SKU__r.SKU_Code__c,SKU__r.Start_Date__c,SKU__r.Current_Fiscal_Year_Last_Date__c,SKU__r.Last_Fiscal_Year__c,SKU__r.Last_Fiscal_Year_End_Date__c,SKU__r.Current_Fiscal_Year_Start_Date__c,Quantity_Sold_Last_Fiscal_Year__c,Quantity_Sold_Last_Campaign__c,Quantity_Sold_Current_Fiscal_Year__c,Quantity_Sold_Current_Campaign__c,SKU__c from Sales_Data__c where Customer__c=:CustomerID and Sales_Org_Code__c=:SalesOrgCode__c.getValues('France').Code__c]);
            for(Id itemId: salesData.keySet()){ mapSKUSalesData.put(salesData.get(itemId).SKU__c, salesData.get(itemId));
            }
        }
        else{
            List<AggregateResult> ar = [SELECT SKU__c,MAX(Last_Calculated_Date__c)lcd,
                                        SUM(Quantity_Sold_Last_Fiscal_Year__c)qs1,SUM(Quantity_Sold_Last_Campaign__c)qs2,
                                        SUM(Quantity_Sold_Current_Fiscal_Year__c)qs3,
                                        SUM(Quantity_Sold_Current_Campaign__c)qs4, 
                                        SUM(Destruction_previous_product_campaign__c)qs5,SUM(Stock_pending_end_prev_product_campaign__c)qs6 
                                        from Sales_Data__c 
                                        where Customer__r.Sold_To_Party__c=:CustomerID  
                                        and Sales_Org_Code__c=:SalesOrgCode__c.getValues('France').Code__c 
                                        GROUP BY SKU__c];
            for(AggregateResult t:ar){
                Sales_Data__c sd = new Sales_Data__c();
                sd.SKU__c = (Id)t.get('SKU__c');
                sd.Quantity_Sold_Last_Fiscal_Year__c = (Decimal)t.get('qs1');
                sd.Quantity_Sold_Last_Campaign__c = (Decimal)t.get('qs2');
                sd.Quantity_Sold_Current_Fiscal_Year__c = (Decimal)t.get('qs3');
                sd.Quantity_Sold_Current_Campaign__c = (Decimal)t.get('qs4');
                sd.Destruction_previous_product_campaign__c	 = (Decimal)t.get('qs5');
                sd.Stock_pending_end_prev_product_campaign__c = (Decimal)t.get('qs6');
                sd.Last_Calculated_Date__c = (Date)t.get('lcd');
                mapSKUSalesData.put(sd.SKU__c,sd);
            }
        }
        //RITM0222834:added by Sayan(crmcomsultant3),6th Sept,2021
        
        
        Sales_Data__c sales = new Sales_Data__c();
        list<Inventory_POG__c> updatepog = new list<Inventory_POG__c>();
        if (liInventoryPOG.size()>0)
        {
            
            for(Inventory_POG__c inv : liInventoryPOG)
            {
                Inventory_POG__c invSalesdata = new Inventory_POG__c();
                invSalesdata = inv;
                
                sales = mapSKUSalesData.get(inv.SKU_Name__r.Id);
                if(sales!=null && dt==Current_Date)
                {   
                    if ((inv.SKU_Name__r.Start_Date__c!=null) && (inv.SKU_Name__r.Start_Date__c<=sales.Last_Calculated_Date__c))
                    {
                        invSalesdata.Quantity_ordered__c= sales.Quantity_Sold_Last_Campaign__c;
                        invSalesdata.Quantity_Sold_Current_Campaign__c= sales.Quantity_Sold_Current_Campaign__c;                
                        invSalesdata.Quantity_Sold_Last_Fiscal__c=sales.Quantity_Sold_Last_Fiscal_Year__c;
                        invSalesdata.Quantity_Sold_Current_Fiscal__c=sales.Quantity_Sold_Current_Fiscal_Year__c;
                        invSalesdata.Destruction_previous_product_campaign__c=sales.Destruction_previous_product_campaign__c;
                        //invSalesdata.Stock_pending_end_prev_product_campaign__c=sales.Stock_pending_end_prev_product_campaign__c;
                    }
                    /*if((inv.SKU_Name__r.Last_Fiscal_Year__c<=sales.Last_Calculated_Date__c) && (inv.SKU_Name__r.Last_Fiscal_Year_End_Date__c>=sales.Last_Calculated_Date__c))
{
invSalesdata.Quantity_Sold_Last_Fiscal__c=sales.Quantity_Sold_Last_Fiscal_Year__c;
}
if((inv.SKU_Name__r.Current_Fiscal_Year_Start_Date__c<=sales.Last_Calculated_Date__c) && (inv.SKU_Name__r.Current_Fiscal_Year_Last_Date__c>=sales.Last_Calculated_Date__c))
{
invSalesdata.Quantity_Sold_Current_Fiscal__c=sales.Quantity_Sold_Current_Fiscal_Year__c;
}*/
                    updatepog.add(invSalesdata);
                }
                
            }
            update updatepog;
            
        }
        //ends
        
        
        List<InventoryPOGWrapper> liInventoryPOGWrapper = new List<InventoryPOGWrapper>();
        for(Inventory_POG__c INVPOG: liInventoryPOG){
            system.debug('Inventory_POG__c INVPOG: liInventoryPOG line number 330');
            if(INVPOG.SKU_Name__r.Product_Campaign__c != null && INVPOG.SKU_Name__r.Product_Campaign__c != ''){
                InventoryPOGWrapper wr = new InventoryPOGWrapper();    
                wr.SKU_Name = INVPOG.SKU_Name__r.SKU_Description__c;
                wr.Unit= INVPOG.SKU_Name__r.UOM__c;
                wr.Product_Campaign=INVPOG.SKU_Name__r.Product_Campaign__c;
                wr.SKUID= INVPOG.SKU_Name__r.Id;
                wr.Quantity_Ordered = INVPOG.Quantity_Ordered__c;
                wr.Stock_Pending_Last_Campaign = INVPOG.Stock_Pending_Last_Campaign__c;
                wr.Stock_at_Farm_Last_Campaign = INVPOG.Stock_at_Farm_Last_Campaign__c;
                wr.Quantity_Sold_Current_Campaign = INVPOG.Quantity_Sold_Current_Campaign__c;
                wr.Marketing_Load = INVPOG.Marketing_Load__c;
                wr.Quantity_Sold_Last_Fiscal = INVPOG.Quantity_Sold_Last_Fiscal__c;
                wr.Quantity_Sold_Current_Fiscal = INVPOG.Quantity_Sold_Current_Fiscal__c;
                wr.StartDate=INVPOG.SKU_Name__r.Start_Date__c;
                wr.CFLD=INVPOG.SKU_Name__r.Current_Fiscal_Year_Last_Date__c;
                wr.CFSD=INVPOG.SKU_Name__r.Current_Fiscal_Year_Start_Date__c;
                wr.LFLD=INVPOG.SKU_Name__r.Last_Fiscal_Year_End_Date__c;
                wr.LFSD=INVPOG.SKU_Name__r.Last_Fiscal_Year__c; 
                wr.Stock_pending_end_prev_product_campaign= INVPOG.Stock_pending_end_prev_product_campaign__c; //p
                liInventoryPOGWrapper.add(wr);
            }
        }
        
        if (dt == Current_Date)
        {   
            set<id> SKUId = new set<id>();
            for (Inventory_POG__c INPOG: liInventoryPOG)
                SKUId.add(INPOG.SKU_Name__c);
            
            //RITM0222834:added by Sayan(crmcomsultant3),6th Sept,2021
            List<SKU__c> skulist = new List<SKU__C>();
            if(ac.account_type__c != 'Sold To Party'){
                //retrieving only those SKU codes where there is a record present in sales data object
                skulist = [select Id,SKU_Description__c,Name,Last_Fiscal_Year__c,Start_Date__c,Current_Fiscal_Year_Last_Date__c,
                           Current_Fiscal_Year_Start_Date__c,Last_Fiscal_Year_End_Date__c,toLabel(product_campaign__c),UOM__c 
                           from SKU__c where Sales_Org_Code__c=:SalesOrgCode__c.getValues('France').Code__c 
                           and id not in :SKUId  
                           AND Id IN(SELECT SKU__c FROM Sales_Data__c WHERE Customer__c=:CustomerID) 
                           ORDER BY SKU_Description__c ASC ];
            }else{
                //retrieving those sku codes where sold to party's related ship tos are having sales data records
                skulist = [select Id,SKU_Description__c,Name,Last_Fiscal_Year__c,Start_Date__c,Current_Fiscal_Year_Last_Date__c,
                           Current_Fiscal_Year_Start_Date__c,Last_Fiscal_Year_End_Date__c,toLabel(product_campaign__c),UOM__c 
                           from SKU__c where Sales_Org_Code__c=:SalesOrgCode__c.getValues('France').Code__c 
                           and id not in :SKUId 
                           AND Id IN(SELECT SKU__c FROM Sales_Data__c WHERE Customer__r.Sold_To_Party__c=:CustomerID) 
                           ORDER BY SKU_Description__c ASC ];
            }
            Set<SKU__c> skuset = new Set<SKU__c>(skulist);
            system.debug('Sayan100->'+skuset.size());
            ////RITM0222834:added by Sayan(crmcomsultant3),6th Sept,2021

            for (SKU__C s: skuset ){ if(s.product_campaign__c != null && s.product_campaign__c != ''){

                    InventoryPOGWrapper wr = new InventoryPOGWrapper();
                    wr.SKU_Name=s.SKU_Description__c; 
                    wr.Unit= s.UOM__c;
                    wr.Product_Campaign=s.Product_Campaign__c;
                    wr.SKUID= s.Id;
                    wr.Quantity_Ordered = 0;
                    wr.Stock_Pending_Last_Campaign = 0;
                    wr.Stock_at_Farm_Last_Campaign = 0;
                    wr.Quantity_Sold_Current_Campaign = 0;
                    wr.Marketing_Load = 0;
                    wr.Quantity_Sold_Last_Fiscal = 0;
                    wr.Quantity_Sold_Current_Fiscal = 0;
                    wr.StartDate=s.Start_Date__c;
                    wr.CFLD=s.Current_Fiscal_Year_Last_Date__c;
                    wr.CFSD=s.Current_Fiscal_Year_Start_Date__c;
                    wr.LFLD=s.Last_Fiscal_Year_End_Date__c;
                    wr.LFSD=s.Last_Fiscal_Year__c; 
                    wr.Stock_pending_end_prev_product_campaign= 0; 
                    liInventoryPOGWrapper.add(wr);
                }
                
            }
            
            /* Map  <id ,Sales_Data__c> salesData = new map <id,Sales_Data__c>([select Customer__c,SKU__r.SKU_Code__c, Quantity_Sold_Last_Fiscal_Year__c,Quantity_Sold_Last_Campaign__c,Quantity_Sold_Current_Fiscal_Year__c,Quantity_Sold_Current_Campaign__c,SKU__c from Sales_Data__c where Customer__c=:CustomerID]);
Map<String, Sales_Data__c> mapSKUSalesData = new Map<String, Sales_Data__c>();
for(Id itemId: salesData.keySet()){
mapSKUSalesData.put(salesData.get(itemId).SKU__c, salesData.get(itemId));
}
*/
            list<InventoryPOGWrapper> retList = new list<InventoryPOGWrapper>();
            
            for (InventoryPOGWrapper wrr : liInventoryPOGWrapper){ InventoryPOGWrapper wrap = new InventoryPOGWrapper();
                wrap = wrr;
                Sales_Data__c sdata = new Sales_Data__c();
                sdata = mapSKUSalesData.get(wrr.SKUID);
                system.debug('skk is '+ sdata);
                if(sdata!= null)
                {
                    if (wrap.StartDate<=sdata.Last_Calculated_Date__c)
                    {
                        wrap.Quantity_Ordered= sdata.Quantity_Sold_Last_Campaign__c;
                        wrr.Quantity_Sold_Current_Campaign= sdata.Quantity_Sold_Current_Campaign__c;
                        wrap.Quantity_Sold_Last_Fiscal= sdata.Quantity_Sold_Last_Fiscal_Year__c;
                        wrr.Quantity_Sold_Current_Fiscal= sdata.Quantity_Sold_Current_Fiscal_Year__c;
                        wrr.Destruction_previous_product_campaign= sdata.Destruction_previous_product_campaign__c;
                        //wrr.Stock_pending_end_prev_product_campaign= sdata.Stock_pending_end_prev_product_campaign__c; 
                        //commented for RITM0255509 as it was setting null values for Stock_pending_end_prev_product_campaign__c
                    }
                    /* if((wrap.LFSD<=sdata.Last_Calculated_Date__c) && (wrap.LFLD>=sdata.Last_Calculated_Date__c))
wrap.Quantity_Sold_Last_Fiscal= sdata.Quantity_Sold_Last_Fiscal_Year__c;
if((wrap.CFSD<=sdata.Last_Calculated_Date__c) && (wrap.CFLD>=sdata.Last_Calculated_Date__c))
wrr.Quantity_Sold_Current_Fiscal= sdata.Quantity_Sold_Current_Fiscal_Year__c;
*/
                }
                retList.add(wrap);
            }
            
            //SKU.InventoryPOGDetails= liInventoryPOGWrapper;
            SKU.InventoryPOGDetails= retList;
            return SKU;
        }
        else
        {
            SKU.InventoryPOGDetails= liInventoryPOGWrapper;
            return SKU;
        }
        
        //return null;
        
    }
    
    @auraenabled
    public static string upsertInventoryPOGDetails(string SKUId,decimal quantity,string customerId,Date inputDate){    
        try
        {
            //decimal Stock_pending_end_prev_product_campaign,decimal Quantity_Ordered_Last_Campaign,decimal Quantity_Sold_Current_Campaign,decimal Quantity_Ordered_Last_Fiscal,decimal Quantity_Ordered_Current_Campaign,
            SalesOrgCode__c dat = SalesOrgCode__c.getValues('France');
            String SalesOrgCode = dat.Code__c;
            Sales_Org__c sorg =  [select id,name,Sales_Org_Code__c from Sales_Org__c where Sales_Org_Code__c=:SalesOrgCode Limit 1];
            system.debug('**inputDate - '+inputDate);
            system.debug('**sku id - '+SKUId);
            account acc = [select id,SAP_Code__c,combination_key__c,recordtype.developername,OwnerId from account where id = :customerId and Sales_Org_Code__c=:SalesOrgCode ];
            SKU__c SKU = [select id,name,product_campaign__c,SKU_Code__c from SKU__c where id = :SKUId and Sales_Org_Code__c=:SalesOrgCode ];
            InventoryPOG.CampaignWrap CID = new InventoryPOG.CampaignWrap();
            CID = getCampaign(SKU.product_campaign__c);
            system.debug('CID is '+CID+'SKU.product_campaign__c '+SKU.product_campaign__c);
            Inventory_POG__c wr = new Inventory_POG__c();
            String startDate= String.valueOf(CID.Start_Date);
            startDate= startDate.replace('-','');
            String endDate=String.valueOf(CID.End_Date); 
            endDate=endDate.replace('-','');
           /* string LYCombinationKey;
            if(acc.recordtype.developername=='Ship_To')
            {
                LYCombinationKey = acc.Combination_Key__c+SKU.SKU_Code__c+startDate+endDate;
            }
            else
            {    
                LYCombinationKey = acc.SAP_Code__c+SKU.SKU_Code__c+startDate+endDate; 
            }
            system.debug('**CombinationKey - '+LYCombinationKey);
            system.debug('**startDate - '+startDate);
			system.debug('**endDate - '+endDate); */
                        list<Inventory_POG__c> invList = new list<Inventory_POG__c>();
			list<Inventory_POG__c> invUpdatedList = new list<Inventory_POG__c>();
            if(SKUId!=null && customerId!=null){
            invList = [select id,name,SKU_Name__c,SKU_Description__c,UoM__c, Stock_pending_end_prev_product_campaign__c,
                                             Stock_Pending_Last_Campaign__c,Combination_Key__c,Customer_Name__r.name,Customer_Name__r.SAP_Code__c,
                                             SKU_Name__r.SKU_Code__c ,Start_Date__c,End_Date__c,Customer_Name__c
                                             from Inventory_POG__c where SKU_Name__c =:SKUId and Customer_Name__c =:customerId 
                                              and Start_Date__c<=:inputDate and End_Date__c >= :inputDate Limit 1];
            //system.debug('**invList - ' +invList);  && CID.Start_Date!=null && CID.End_Date!=null
            }
            
            
           if(invList!=null && invList.size()>0){
               invList[0].Stock_Pending_Last_Campaign__c= quantity;
              // invList[0].Combination_Key__c = LYCombinationKey;
               update invList;
               system.debug('**invUpdatedList - ' +invList);
               return 'true'; 
           }
            else{
            Inventory_POG__c invObj = new Inventory_POG__c();
            invObj.SKU_Name__c= SKU.id;
            invObj.Sales_Org__c= sorg.id;
            //invObj.Stock_pending_end_prev_product_campaign__c= Stock_pending_end_prev_product_campaign;
			invObj.Stock_Pending_Last_Campaign__c = quantity;
            invObj.Customer_Name__c= customerId;
            invObj.Start_Date__c =CID.Start_Date;
            invObj.End_Date__c = CID.End_Date;
            //invObj.Combination_Key__c = LYCombinationKey;
            insert invObj;
            system.debug('**invInsertedList - ' +invObj);
            return 'true'; 
             }
            
            /* 
            wr.SKU_Name__c= SKU.id;
            Sales_Org__c sOrg = new Sales_Org__c(Sales_Org_Code__c='2710');
            wr.Sales_Org__r= sOrg;
            wr.Stock_Pending_Last_Campaign__c= quantity;
            wr.Quantity_ordered__c= Quantity_Ordered_Last_Campaign;
            wr.Quantity_Sold_Current_Campaign__c= Quantity_Sold_Current_Campaign;
            wr.Quantity_Sold_Last_Fiscal__c= Quantity_Ordered_Last_Fiscal;
            wr.Quantity_Sold_Current_Fiscal__c= Quantity_Ordered_Current_Campaign;    
            wr.combination_key__c= LYCombinationKey;
            wr.Customer_Name__c= customerId;
            wr.Start_Date__c =CID.Start_Date;
            wr.End_Date__c = CID.End_Date;
            
            
            upsert wr Combination_Key__c;
            return 'true';      */                                        
        }
        catch(Exception ex)
        {
            System.debug('ex No: '+ex.getLineNumber()+' ex Msg: '+ex.getMessage()); 
            return 'false';
        }
    }
    
    
    @auraenabled
    public static string upsertInventoryPOGDetailsSAFLC(string SKUId,decimal quantity,decimal Quantity_Ordered_Last_Campaign,decimal Quantity_Sold_Current_Campaign,decimal Quantity_Ordered_Last_Fiscal,decimal Quantity_Ordered_Current_Campaign,string customerId){    
        try
        {
            account acc = [select id,SAP_Code__c,combination_key__c,recordtype.developername from account where id = :customerId and Sales_Org_Code__c=:SalesOrgCode__c.getValues('France').Code__c ];
            system.debug('sku id '+SKUId);
            SKU__c SKU = [select id,name,SKU_Code__c,Product_Campaign__c from SKU__c where id = :SKUId and Sales_Org_Code__c=:SalesOrgCode__c.getValues('France').Code__c ];
            InventoryPOG.CampaignWrap CID = new InventoryPOG.CampaignWrap();
            CID = getCampaign(SKU.product_campaign__c);
            Inventory_POG__c wr = new Inventory_POG__c();
            //string LYCombinationKey = acc.SAP_Code__c+'_'+SKU.name+'_'+String.valueOf(CID.Start_Date)+'_'+String.valueOf(CID.End_Date); 
            String startDate= String.valueOf(CID.Start_Date);
            startDate= startDate.replace('-','');
            String endDate=String.valueOf(CID.End_Date); 
            endDate=endDate.replace('-','');
            string LYCombinationKey;
            if(acc.recordtype.developername=='Ship_To')
            {
                //LYCombinationKey = acc.Combination_Key__c+SKU.SKU_Code__c+startDate+endDate;
            }
            else
            {    
                LYCombinationKey = acc.SAP_Code__c+SKU.SKU_Code__c+startDate+endDate; 
            }
    
            wr.SKU_Name__c= SKU.id;
            Sales_Org__c sOrg = new Sales_Org__c(Sales_Org_Code__c='2710');
            wr.Sales_Org__r= sOrg;
            wr.Stock_at_Farm_Last_Campaign__c= quantity;
            wr.Quantity_ordered__c= Quantity_Ordered_Last_Campaign;
            wr.Quantity_Sold_Current_Campaign__c= Quantity_Sold_Current_Campaign;
            wr.Quantity_Sold_Last_Fiscal__c= Quantity_Ordered_Last_Fiscal;
            wr.Quantity_Sold_Current_Fiscal__c= Quantity_Ordered_Current_Campaign;   
            wr.combination_key__c= LYCombinationKey;
            wr.Customer_Name__c= customerId;
            wr.Start_Date__c =CID.Start_Date;
            wr.End_Date__c = CID.End_Date;   
            upsert wr Combination_Key__c;
            return 'true';  
        }
        catch(Exception ex)
        {
            System.debug('ex No: '+ex.getLineNumber()+' ex Msg: '+ex.getMessage()); 
            return 'false';
        }
    }
    
    @auraenabled
    public static string updateStockPendingPrev(string SKUId,decimal quantity,decimal Stock_Pending_Last_Campaign,string customerId){    
        try
        {
            SalesOrgCode__c dat = SalesOrgCode__c.getValues('France');
            String SalesOrgCode = dat.Code__c;
            Sales_Org__c sorg =  [select id,name,Sales_Org_Code__c from Sales_Org__c where Sales_Org_Code__c=:SalesOrgCode Limit 1];
            system.debug('**Sales_Org - '+sorg);
            account acc = [select id,SAP_Code__c,combination_key__c,recordtype.developername,OwnerId from account where id = :customerId and Sales_Org_Code__c=:SalesOrgCode Limit 1];
            system.debug('**sku id - '+SKUId);
			system.debug('**Stock_Pending_Last_Campaign - '+Stock_Pending_Last_Campaign);
            SKU__c SKU = [select id,name,product_campaign__c,SKU_Code__c,SKU_Description__c from SKU__c where id = :SKUId and Sales_Org_Code__c=:SalesOrgCode Limit 1];
			system.debug('**SKU_Description__c - '+SKU.SKU_Description__c);
            InventoryPOG.CampaignWrap CID = new InventoryPOG.CampaignWrap();
            CID = getCampaign(SKU.product_campaign__c);
            system.debug('**CID is '+CID+'**SKU.product_campaign__c - '+SKU.product_campaign__c);
            Inventory_POG__c wr = new Inventory_POG__c();
            String startDate= String.valueOf(CID.Start_Date);
            startDate= startDate.replace('-','');
            String endDate=String.valueOf(CID.End_Date); 
            endDate=endDate.replace('-','');
			//Database.upsertResult[] strList;
			list<Inventory_POG__c> invList = new list<Inventory_POG__c>();
			list<Inventory_POG__c> invUpdatedList = new list<Inventory_POG__c>();
            if(SKUId!=null && customerId!=null && CID.Start_Date!=null && CID.End_Date!=null){
            invList = [select id,name,SKU_Name__c,SKU_Description__c,UoM__c, Stock_pending_end_prev_product_campaign__c,
                                             Stock_Pending_Last_Campaign__c,Combination_Key__c,Customer_Name__r.name,Customer_Name__r.SAP_Code__c,
                                             SKU_Name__r.SKU_Code__c ,Start_Date__c,End_Date__c,Customer_Name__c
                                             from Inventory_POG__c where SKU_Name__c =:SKUId and Customer_Name__c =:customerId 
                                             and Start_Date__c=:CID.Start_Date and End_Date__c = :CID.End_Date Limit 1];
            //system.debug('**invList - ' +invList);
            }
            
            
           if(invList!=null && invList.size()>0){
               invList[0].Stock_pending_end_prev_product_campaign__c= quantity;
               update invList;
               system.debug('**invUpdatedList - ' +invList);
               return 'true'; 
           }
            else{
            Inventory_POG__c invObj = new Inventory_POG__c();
            invObj.SKU_Name__c= SKU.id;
            invObj.Sales_Org__c= sorg.id;
            invObj.Stock_pending_end_prev_product_campaign__c= quantity;
			invObj.Stock_Pending_Last_Campaign__c = Stock_Pending_Last_Campaign;
            invObj.Customer_Name__c= customerId;
            invObj.Start_Date__c =CID.Start_Date;
            invObj.End_Date__c = CID.End_Date;
            //invObj.Quantity_ordered__c= Quantity_Ordered_Last_Campaign;
            insert invObj;
            system.debug('**invInsertedList - ' +invObj);
            return 'true'; 
             }
            
			  
			/* if(invUpdatedList.size()>0){
			
           //  for(Inventory_POG__c invObj:invList){
			//invUpdatedList.add(invObj);
                Schema.SObjectField uniqueField = Inventory_POG__c.Fields.Combination_Key__c;
                strList=Database.upsert(invUpdatedList,uniqueField,false); 
                //System.debug('**Database.upsert Result --> '+strList); 
                system.debug('**invUpdatedList - ' +invUpdatedList);
                return 'true';  				
            }
                else{
                System.debug('Data Not Found');
				return 'false';                   
            }     */                                
        }
        catch(Exception ex)
        {
            System.debug('ex No: '+ex.getLineNumber()+' ex Msg: '+ex.getMessage()); 
            return 'false';
        }
    }
    
    
    public class SKUPaginationWrapper {
        
        @AuraEnabled
        public List<InventoryPOGWrapper> InventoryPOGDetails {get;set;}
        @AuraEnabled
        public List<string> ProductGroupList {get;set;} 
        @AuraEnabled
        public Boolean revokeAccess {get;set;}
        //changes for dynamic date setup
        @AuraEnabled
        public Date BlockDate {get;set;}    
        @AuraEnabled
        public String CustomerName {get;set;}    
    }
    
    
    
    
    public class CampaignWrap
    {
        @AuraEnabled
        public string Campaign {get;set;}
        @AuraEnabled
        public Date Start_Date {get;set;} 
        @AuraEnabled
        public Date End_Date {get;set;}
        
        
    }
    
    
    
    public class InventoryPOGWrapper {
        
        @AuraEnabled
        public string SKU_Name {get;set;}
        @AuraEnabled
        public string Unit {get;set;}
        @AuraEnabled
        public string Product_Campaign {get;set;}
        @AuraEnabled
        public string SKUID {get;set;} 
        @AuraEnabled
        public decimal Quantity_Ordered {get;set;}
        @AuraEnabled
        public decimal Stock_Pending_Last_Campaign {get;set;}
        @AuraEnabled
        public decimal Stock_at_Farm_Last_Campaign {get;set;}
        @AuraEnabled
        public decimal Quantity_Sold_Current_Campaign {get;set;}
        @AuraEnabled
        public decimal Marketing_Load{get;set;}
        @AuraEnabled
        public decimal Quantity_Sold_Last_Fiscal {get;set;}
        @AuraEnabled
        public Date StartDate {get;set;}
        @AuraEnabled
        public Date CFLD {get;set;}
        @AuraEnabled
        public Date CFSD {get;set;}
        @AuraEnabled
        public Date LFSD {get;set;}
        @AuraEnabled
        public Date LFLD {get;set;}
        @AuraEnabled
        public decimal Quantity_Sold_Current_Fiscal {get;set;}
        @AuraEnabled
        public decimal Destruction_previous_product_campaign {get;set;}
        @AuraEnabled
        public decimal Stock_pending_end_prev_product_campaign {get;set;}
        
    }
}