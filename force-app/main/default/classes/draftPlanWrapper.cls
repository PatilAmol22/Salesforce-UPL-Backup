public without sharing class draftPlanWrapper {
		public string accountName {get;set;}
    	public Map<String,List<Draft_Plan__c>> wrpDraftPlanListCurrentMap {get;set;}
        public List<String> wrpCategoryList{get;set;}
        public Integer wrpCurrentYear{get;set;}
        public Integer wrpPreviousYear{get;set;}
        public Decimal wrptotalEDI{get;set;}
        public Decimal wrptotalInvoice{get;set;}
        public Decimal wrptotalDraft{get;set;}
        public Decimal wrptotalValueDraft{get;set;}
        public Decimal wrptotalPctDraft{get;set;}
        public map<id,string> wrpreasonMap{get;set;}
    	public Boolean nodata{get;set;}
    //public Boolean showpayout{get;set;}
        public draftPlanWrapper(){}
        public draftPlanWrapper(String accName,Map<String,List<Draft_Plan__c>> dfMap,List<String> catList,Integer cYear,Integer pYear,map<id,string>rempap,Decimal edi,Decimal invoice,Decimal draft,Decimal val,Decimal pct,Boolean ndata){
            system.debug('hello'+accName);
            this.accountName=accName;
            this.wrpDraftPlanListCurrentMap=dfMap;
            this.wrpCategoryList=catList;
            this.wrptotalEDI=edi;
            this.wrptotalInvoice=invoice;
            this.wrptotalDraft=draft;
            this.wrptotalValueDraft=val;
            this.wrptotalPctDraft=pct;
            this.wrpCurrentYear=cYear;
            this.wrpPreviousYear=pYear;
            this.wrpreasonMap=rempap;
            this.nodata=ndata;
            //this.showpayout=shopayout;
            
        }
}