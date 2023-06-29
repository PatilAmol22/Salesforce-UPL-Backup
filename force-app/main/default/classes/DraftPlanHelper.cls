public without sharing class DraftPlanHelper{
    public List<String> categoryList{ get; set; }
    public Integer currentYear{ get; set; }
    public Integer previousYear{ get; set; }
    public List<Draft_Plan__c> draftPlanListCurrent{ get; set; }
    public Map<String, List<Draft_Plan__c>> draftPlanListCurrentMap{ get; set; }
    public draftPlanWrapper dfWrapper{ get; set; }
    public Decimal totalEDI{ get; set; }
    public Decimal totalInvoice{ get; set; }
    public Decimal totalDraft{ get; set; }
    public Decimal totalValueDraft{ get; set; }
    public Decimal totalPctDraft{ get; set; }
    public Decimal pctDraft{ get; set; }
    public Boolean noData{ get; set; }
    public draftPlanWrapper generateDraftWrapper(Integer myear, date startDate, date endDate, Account distributor, String div){
        currentYear = Integer.valueof(myear);
        previousYear = endDate.year() - 1;
        totalInvoice = 0;
        totalDraft = 0;
        totalValueDraft = 0;
        totalEDI = 0;
        pctDraft = 0;
        decimal rtotalInvoice = 0;
        decimal rtotalDraft = 0;
        decimal rtotalValueDraft = 0;
        decimal rtotalEDI = 0;
        decimal rpctDraft = 0;
        system.debug('dist' + distributor.Id + '*' + div + '*' + distributor.Sales_Org__r.Sales_Org_Code__c + '*' + startDate + '*' + endDate);
        draftPlanListCurrent = [SELECT Id, lastmodifieddate, lastmodifiedBy.name, Draft_Plan_Header__r.id, Draft_Plan_Header__r.Distributor__c, Draft_Plan_Header__r.Sales_Org__r.Sales_Org_Code__c, Draft_Plan_Header__r.Status__c, Draft_Plan_Header__r.MKT_Year_Start_Date__c, Draft_Plan_Header__r.MKT_Year_End_Date__c, Draft_Plan_Header__r.Combination_Key__c, SKU__c, Product_Price__c, EDI_Quantity_LY__c, EDI_Amount_LY__c, Invoice_Quantity_LY__c, Invoice_Amount_LY__c, Draft_Quantity__c, Target_Amount__c, Target_Quantity__c, Target_Updated__c, Value_At_Target__c, Pct_Of_Prev_Yr_Target__c, Draft_Amount__c, Value_At_Draft__c, Pct_Of_Prev_Yr__c, sku__r.SKU_Code__c, sku__r.Name, sku__r.Product_Category__c,sku__r.Material_Group_5__c, sku__r.Brand_Name__c, SKU__r.uom__c, SKU__r.SKU_Description__c, (select id, Payout_Entry_Type__c, Payout_Per_Unit__c, Payout_Per_Unit_Pct__c, Qty_as_a_Pct__c, Qty_as_Percentage__c, Reason_Code__c, Threshold_Quantity__c, Tier__c, Value_At_Target__c, draft_plan__c
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   from Draft_Plan_Payouts__r
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   order by Tier__c)
                                FROM Draft_Plan__c
                                where Draft_Plan_Header__r.MKT_Year_Start_Date__c >= :startDate AND Draft_Plan_Header__r.MKT_Year_End_Date__c <= :endDate AND Draft_Plan_Header__r.Sales_Org__r.Sales_Org_Code__c = :distributor.Sales_Org__r.Sales_Org_Code__c AND Draft_Plan_Header__r.Distributor__c = :distributor.Id and Draft_Plan_Header__r.Division__c = :div];
        system.debug('draftPlanListCurrentsize' + draftPlanListCurrent.size());
        draftPlanListCurrentMap = new Map<String, List<Draft_Plan__c>>();
        Map<Id, String> reasonMap = new Map<Id, String>();
        if (draftPlanListCurrent.size() > 0){
            for (Draft_Plan__c dc : draftPlanListCurrent){
                system.debug('ggg' + dc.sku__r.Product_Category__c);
                if (draftPlanListCurrentMap.containsKey(dc.sku__r.Product_Category__c)){
                    draftPlanListCurrentMap.get(dc.sku__r.Product_Category__c).add(dc);

                } else if (dc.sku__r.Product_Category__c == null){

                    String categ = '';
                    system.debug('hello' + categ);
                    if (draftPlanListCurrentMap.containsKey(categ)){
                        draftPlanListCurrentMap.get(categ).add(dc);
                    } else{
                        draftPlanListCurrentMap.put(categ, new List<Draft_Plan__c>{ dc });//to cehck
                    }
                } else{
                    draftPlanListCurrentMap.put(dc.sku__r.Product_Category__c, new List<Draft_Plan__c>{ dc });//to cehck
                }
                for (Draft_Plan_Payout__c dp : dc.Draft_Plan_Payouts__r){

                    system.debug('ggg' + dc.Draft_Plan_Payouts__r);
                    if (!reasonMap.containsKey(dc.Id)){
                        reasonMap.put(dc.id, dp.Reason_Code__c);
                    }
                }
                //system.debug('inv'+dc.Draft_Amount__c);
                if (dc.Invoice_Amount_LY__c != null){
                    totalInvoice += dc.Invoice_Amount_LY__c;
                }
                if (dc.Target_Updated__c == true){
                    if (dc.Target_Amount__c != null){
                        totalDraft += dc.Target_Amount__c;
                    }
                    if (dc.Value_At_Target__c != null){
                        totalValueDraft += dc.Value_At_Target__c;
                    }
                } else{
                    if (dc.Draft_Amount__c != null){
                        totalDraft += dc.Draft_Amount__c;
                    }
                    if (dc.Value_At_Draft__c != null){
                        totalValueDraft += dc.Value_At_Draft__c;
                    }
                }
                if (dc.EDI_Amount_LY__c != null){
                    totalEDI += dc.EDI_Amount_LY__c;
                }
                if (totalDraft != 0 && totalDraft != null){
                    pctDraft = totalValueDraft / totalDraft;
                }

            }
            rtotalInvoice = totalInvoice.setScale(2);
            rtotalDraft = totalDraft.setScale(2);
            rtotalValueDraft = totalInvoice.setScale(2);
            rtotalEDI = totalEDI.setScale(2);
            rpctDraft = pctDraft.setScale(2);
            //rounded = toround.setScale(2);
            Set<String> keyValues = draftPlanListCurrentMap.keySet();
            categoryList = new List<String>();
            categoryList.addAll(keyValues);
            system.debug('categoryList' + categoryList);
            system.debug('categoryList1' + draftPlanListCurrentMap);
            system.debug('reasonmap' + reasonMap);

            dfWrapper = new draftPlanWrapper(distributor.Name, draftPlanListCurrentMap, categoryList, currentYear, previousYear, reasonMap, rtotalEDI, rtotalInvoice, rtotalDraft, rtotalValueDraft, rpctDraft, false);
            return dfWrapper;
        } else{
            draftPlanWrapper dp = new draftPlanWrapper();
            dp.noData = true;
            return dp;
        }
    }

    public List<divWrapper> getDivision(Id accountId){
        Map<String, String> divMap = new Map<String, String>();
        List<divWrapper> dWrap = new List<divWrapper>();
        List<DistributorSalesAreaMapping__c> distArea = [SELECT id, Distributor__c, Division__c, Division__r.name, Division__r.Division_Code__c
                                                         from DistributorSalesAreaMapping__c
                                                         where Distributor__c = :accountId];
        system.debug('dist' + distArea);
        if (distArea.size() > 0){
            for (DistributorSalesAreaMapping__c dd : distArea){
                system.debug('enter div' + dd.Division__c);
                divWrapper dW = new divWrapper();
                dW.divId = dd.Division__c;
                dW.divLength = distArea.size();
                dW.divName = dd.Division__r.name;
                dW.divCode = dd.Division__r.Division_Code__c;
                dWrap.add(dW);
                divMap.put(dd.Division__c, dd.Division__r.name);
            }
        } else{
            Account a = [select name, Sales_Org__c, Sales_Org__r.Sales_Org_Code__c, SFDC_Distributor_Code__c, SAP_Code__c, Division__c, Division__r.name, Division__r.Division_Code__c, Screen_Flow_Value__c
                         from account
                         where id = :accountId];
            divWrapper dW = new divWrapper();
            dW.divId = a.Division__c;
            dW.divLength = 1;
            dW.divName = a.Division__r.name;
            dW.divCode = a.Division__r.Division_Code__c;
            dWrap.add(dW);
            system.debug('dWrap' + dWrap);
        }
        system.debug('dWrap' + dWrap);
        return dWrap;
    }

    public class divWrapper{
        public id divId{ get; set; }
        public Integer divLength{ get; set; }
        public string divName{ get; set; }
        public String divCode{ get; set; }
    }
}