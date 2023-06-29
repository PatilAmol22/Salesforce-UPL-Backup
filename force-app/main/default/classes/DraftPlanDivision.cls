public class DraftPlanDivision {
    public List<DraftPlanHelper.divWrapper> divWrapperList{get;set;}
    public draftPlanWrapper dfWrapper{get;set;}
    public boolean showDiv{get;set;}
    public Id distributorID{get;set;}
    public String cusDiv{get;set;}
    public Account distributor{get;set;}
    public DraftPlanDivision(ApexPages.StandardController stdController) {
        this.distributor = (Account) stdController.getRecord();
        system.debug(this.distributor);
        distributorID = (Id)ApexPages.currentPage().getParameters().get('id');
        system.debug('hello'+distributorID);
        //distributorID='0011e000003XdcNAAS';
        distributor = [Select id,name,Sales_Org__c,Sales_Org__r.Sales_Org_Code__c,Division__c from account where id=:distributor.id];
        distributorID=distributor.Id;
        system.debug(distributor.name);
        DraftPlanHelper dhelper=new DraftPlanHelper();
        divWrapperList=dhelper.getDivision(distributorID);
        //Marketing_Year__c MKTYear=CalculateMarkettingYearHelper.calculateYear(distributor.Sales_Org__r.Sales_Org_Code__c);
        //CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapper = CalculateMarkettingYearHelper.calculateMarketingYear(distributor.Sales_Org__r.Sales_Org_Code__c);
       /* DraftPlanHelper dhelper=new DraftPlanHelper();
        system.debug('v'+mktYearWrapper);
        
        if(divWrapperList.size()==1){
           dfWrapper=dhelper.generateDraftWrapper(mktYearWrapper.firstMarketingYear,mktYearWrapper.firstMarketingYearStartDate,mktYearWrapper.firstMarketingYearEndDate,distributor,divWrapperList[0].divId);
			showDiv=false;
        }
        else{
            showDiv=true;
        }*/
        //dfWrapper=dhelper.generateDraftWrapper(mktYearWrapper.firstMarketingYear,mktYearWrapper.firstMarketingYearStartDate,mktYearWrapper.firstMarketingYearEndDate,distributor,distributor.Division__c);
        //system.debug('kkk'+dfWrapper.wrpCategoryList.size());
        //dfWrapper.nodata==true
        }
public PageReference createPDF(){
        CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapper = CalculateMarkettingYearHelper.calculateMarketingYear(distributor.Sales_Org__r.Sales_Org_Code__c);
        DraftPlanHelper dhelper=new DraftPlanHelper();
        dfWrapper=dhelper.generateDraftWrapper(mktYearWrapper.firstMarketingYear,mktYearWrapper.firstMarketingYearStartDate,mktYearWrapper.firstMarketingYearEndDate,distributor,cusDiv);
		system.debug('hello in pdf'+dfWrapper);
        PageReference draftPage = new PageReference('/apex/DraftPlanPDF?id=' + distributor.id);
    draftPage.getParameters().put('custDiv',cusDiv);
        draftPage.setRedirect(true);
        return draftPage;
    }
    Public List<Selectoption> getdivisionWrapper(){
            List<Selectoption> lstnamesel = new List<selectoption>();
            lstnamesel.add(new selectOption('', '- None -'));
        system.debug('divWrapperList'+divWrapperList);
            for(DraftPlanHelper.divWrapper dd :divWrapperList){
                if(dd.divId!=null){
            lstnamesel.add(new selectoption(dd.divId,dd.divName));
                }
            }
            return lstnamesel; 
        }
}