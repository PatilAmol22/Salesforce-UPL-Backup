public without sharing class DraftPlanController{
    public List<DraftPlanHelper.divWrapper> divWrapperList{ get; set; }
    public draftPlanWrapper dfWrapper{ get; set; }
    public boolean showDiv{ get; set; }
    public String custDiv{ get; set; }
    public Account distributor{ get; set; }
    //Added by GRZ(Nikhil Verma) RITM0478313 03-01-2023-->
    public string createdBy{ get; set; }
    public string approvedBy{ get; set; }
    public string distributorName{ get; set; }

    public DraftPlanController(ApexPages.StandardController stdController){
        this.distributor = (Account)stdController.getRecord();
        distributor = [Select id, name,EBID__c,Sales_Org__c, Sales_Org__r.Sales_Org_Code__c, Division__c, Owner.Name, Owner.Manager.Name from account where id = :distributor.id];
        //Added by GRZ(Nikhil Verma) RITM0478313 03-01-2023-->
        createdBy = distributor.Owner.Name;
        approvedBy = distributor.Owner.Manager.Name;
        if(distributor.EBID__c != null){
            distributorName = 'EBID #' + distributor.EBID__c + ' - ' + distributor.Name;
        }else{
            distributorName = distributor.Name;
        }

        CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapper = CalculateMarkettingYearHelper.calculateMarketingYear(distributor.Sales_Org__r.Sales_Org_Code__c);
        DraftPlanHelper dhelper = new DraftPlanHelper();
        custDiv = System.currentPagereference().getParameters().get('custDiv');
        dfWrapper = dhelper.generateDraftWrapper(mktYearWrapper.firstMarketingYear, mktYearWrapper.firstMarketingYearStartDate, mktYearWrapper.firstMarketingYearEndDate, distributor, custDiv);
    }
}