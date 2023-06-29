public without sharing class Grz_AdminPanel {
    
    @AuraEnabled(cacheable=true)
    public static AdminPanelInformationParent AdminPaneInfo(decimal pageNumber, Decimal pageSize){
        
        AdminPanelInformationParent AdminPanelParent = new AdminPanelInformationParent();
        List<AdminPanelInformation> AInfoList = new List<AdminPanelInformation>();
        Integer pSize;
        if(pageSize!=null && pageSize!=0.0){
            pSize = (Integer)pageSize;
        }else{
            pSize=10;
        }
        
        Integer pNumber = (Integer)pageNumber;
        Integer offset = (pNumber - 1) * pSize;
        
        List<Period> fiscalYearList = [Select Type, StartDate, EndDate, Number, FiscalYearSettings.PeriodId From Period Where Type='Year' and startDate <= TODAY and  endDate >= TODAY limit 1];
        Integer FY =fiscalYearList[0].StartDate.year();
        String id = userinfo.getUserId();
        String query ='select id,name,Circular_Detail__c,Fetched_Date__c,Send_Date__c,Email_Sent__c from Admin_Panel__c where CreatedById =: id and CALENDAR_YEAR(CreatedDate) =:FY ORDER BY CreatedDate desc';
        Integer totalRecords= [Select Count() from Admin_Panel__c where CreatedById =: id and CALENDAR_YEAR(CreatedDate) =:FY ];
        Integer recordEnd = pSize * pNumber;
        
        AdminPanelParent.pageSize = pSize;
        AdminPanelParent.pageNumber = pNumber;
        AdminPanelParent.recordStart = offset + 1;
        AdminPanelParent.totalRecords = totalRecords;
        AdminPanelParent.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        
        query += ' LIMIT :pSize OFFSET :offset';
        List<Admin_Panel__c> APanel = Database.query(query);
        List<Id> idList=new List<Id>();
        for(Admin_Panel__c a : APanel){
            idList.add(a.Id);
        }
        Map<Id,Id> idMap=new Map<Id,Id>();
        for(ContentDocumentLink CD:[SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink where LinkedEntityId IN :idList]){
            if(!idMap.containsKey(CD.LinkedEntityId))
            idMap.put(CD.LinkedEntityId,CD.ContentDocumentId);
        }
        
        
        for(Admin_Panel__c a : APanel){
            AdminPanelInformation AInfo = new AdminPanelInformation();
            AInfo.cir1 = a.Name;
            AInfo.cir2 = a.Circular_Detail__c;
            AInfo.sent = a.Email_Sent__c;
            Datetime dt = a.Send_Date__c;
            String FormatDate = dt.format('MMM dd, yyyy');
            AInfo.sentDate = FormatDate;
            //List<ContentDocumentLink> CD= [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =: a.id];
            
            if(idMap.containsKey(a.Id)){
                AInfo.ContentDocId = idMap.get(a.Id);
            }
            AInfoList.add(AInfo);
        }
        AdminPanelParent.AdminPanelRecs = AInfoList;
        return AdminPanelParent;
    }
    
    @AuraEnabled(cacheable=true)
    public static Sbu GetSbu(List<String> SalesOrg){
        Sbu sb = new sbu();
        String query = 'SELECT SBUCode__c, SBUUser__c,SalesOrg__r.Sales_Org_Code__c, SalesOrg__c, Id, Name,(select id,name,sbucode__r.name from zones__r) FROM SBU__c';
        if(SalesOrg.size()>0){
            query +=' where SalesOrg__r.Company_Code__c IN: SalesOrg';
        }
        List<SBU__c> sbu = database.query(query);
        Map<String, list<zone__c>> m1 = new Map<String, list<zone__c>>();
        for(SBU__c s : sbu){
            m1.put(s.Name, s.zones__r);
        }
        sb.Sbus = m1;
        List<Period> fiscalYearList = [Select Type, StartDate, EndDate, Number, FiscalYearSettings.PeriodId From Period Where Type='Year' and startDate <= TODAY and endDate >= TODAY limit 1];
        Integer curFiscYear = fiscalYearList[0].StartDate.year();
        sb.FiscalYear = curFiscYear;
        return sb;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static  FinalRes  GetPriceBook(String Zones, String StartDate, String EndDate, String Month, String year, boolean isRelatedList,String Customer, String sbu){
       
        FinalRes wrap = new FinalRes();
        list<ResultStored> rs = new list<ResultStored>(); 
        
        list<PrIce_List_Type_Master__c> PriceList = new list<PrIce_List_Type_Master__c>();
        List<pricebookmaster__c> PriceBookMasterLatestStartDate = new List<pricebookmaster__c>();
        List<pricebookmaster__c> pm = new List<pricebookmaster__c>();
        List<String> AccIds = new List<String>();
        Map<String,String> DistributorEmails = new Map<String,String>();
        
        if(Month == '' || Month == null){
            
            Date Start =  date.valueOf(StartDate); 
            Date EndD =  date.valueOf(EndDate);
            PriceList = [select id,(select id,name,email__c from Accounts__r where PriceGroupCode__r.PG_Code__c=: Customer),(select id,StartDate__c,EndDate__c, DistributorCustomerCode__c,SKUCode__r.SKU_Description__c,SKUCode__r.Product_Name__r.Name,SKUCode__r.Brand_Name__c,SKUCode__r.Product_Name__r.Portfolio__c,SKUCode__r.Product_Name__r.Technical_Name__c,SKUCode__r.Product_Name__r.Indication_Type__c,SKUCode__r.Product_Name__r.Description,SKUCode__r.Pack_Size_Description__c,Price__c, SKUCode__r.GST__c from Price_Book_Masters__r where StartDate__c >=: Start AND EndDate__c <=: EndD AND StartDate__c <= TODAY AND PG_CODE__r.PG_CODE__c=: Customer AND price__c != 0 AND SKUCode__r.PriceList_Active__c = true order by startdate__c desc) from PrIce_List_Type_Master__c where sbu__r.name =:sbu and zone__r.name =: Zones limit 1];
            if(!PriceList.isEmpty()){
                for(Account a : PriceList[0].Accounts__r){
                    if(a.email__c == null){
                        DistributorEmails.put(a.name+'('+a.id+')','null');
                    }else{
                        DistributorEmails.put(a.name+'('+a.id+')',a.email__c);
                    }
                    
                }
            }
            wrap.DistributorMails = DistributorEmails;
        }
        else{
            integer month1 = Integer.valueOf(Month);
            Integer year1 = Integer.valueOf(year);
            System.debug('month1==>'+month1);
            System.debug('year1==>'+year1);
            System.debug('Customer==>'+Customer);
            //List<PriceBookMaster__c> p =[select id,StartDate__c,EndDate__c, DistributorCustomerCode__c,SKUCode__r.SKU_Description__c,SKUCode__r.PriceList_Active__c,SKUCode__r.Product_Name__r.Name,SKUCode__r.Brand_Name__c,SKUCode__r.Product_Name__r.Portfolio__c,SKUCode__r.Product_Name__r.Technical_Name__c,SKUCode__r.Product_Name__r.Indication_Type__c,SKUCode__r.Product_Name__r.Description,SKUCode__r.Pack_Size_Description__c,Price__c, SKUCode__r.GST__c from PriceBookMaster__c where CALENDAR_MONTH(StartDate__c) =: month1 AND CALENDAR_YEAR(StartDate__c) =: year1 AND PG_CODE__r.PG_CODE__c=: Customer];
            
            PriceList = [select id,(select id,StartDate__c,EndDate__c,SKUCode__r.SKU_Description__c,SKUCode__r.Brand_Name__c,SKUCode__r.Product_Name__r.Portfolio__c,SKUCode__r.Product_Name__r.Technical_Name__c,SKUCode__r.Pack_Size__c,Price__c,SKUCode__r.Pack_Size_Description__c, SKUCode__r.GST__c from Price_Book_Masters__r where CALENDAR_MONTH(StartDate__c) =: month1 AND CALENDAR_YEAR(StartDate__c) =: year1 AND PG_CODE__r.PG_CODE__c=: Customer AND price__c != 0 AND SKUCode__r.PriceList_Active__c = true order by startdate__c desc) from PrIce_List_Type_Master__c where sbu__r.name =:sbu and zone__r.name =: Zones limit 1];
        }
        if(!PriceList.isEmpty()){
            if(PriceList[0].Price_Book_Masters__r.size()>0){
                Date LatestStartDate = PriceList[0].Price_Book_Masters__r[0].StartDate__c;
                for(pricebookmaster__c PBM : PriceList[0].Price_Book_Masters__r){
                    if(LatestStartDate == PBM.StartDate__c){
                        PriceBookMasterLatestStartDate.add(PBM);
                    }
                }
            }
            pm = PriceList[0].Price_Book_Masters__r;
        }
        
        if(isRelatedList == true){
            List<SKU__c> MasterPrice = new  List<SKU__c>();
            List<String> SkuIds = new List<String>();
            for(pricebookmaster__c pb : PriceBookMasterLatestStartDate){
                SkuIds.add(pb.SKUCode__r.Id);
            }
            if(!PriceList.isEmpty()){
                if(Month == '' || Month == null){
                    Date Start =  date.valueOf(StartDate); 
                    Date EndD =  date.valueOf(EndDate);
                    MasterPrice = [select id,(select id,Price__c from Matching_Discounts__r where StartDate__c >=: Start AND EndDate__c <=: EndD AND StartDate__c <= TODAY AND PG_CODE__r.PG_CODE__c=: Customer AND PrIce_List_Type__c =: PriceList[0].id order by startdate__c desc limit 1),(select id,Price__c from Discount_Masters__r where StartDate__c >=: Start AND EndDate__c <=: EndD AND StartDate__c <= TODAY AND PG_CODE__r.PG_CODE__c=: Customer AND PrIce_List_Type__c =: PriceList[0].id order by startdate__c desc limit 1) from SKU__c where id in : SkuIds ];
                }else{
                    integer month1 = Integer.valueOf(Month);
                    Integer year1 = Integer.valueOf(year);
                    MasterPrice = [select id,(select id,Price__c from Matching_Discounts__r where CALENDAR_MONTH(StartDate__c) =: month1 AND CALENDAR_YEAR(StartDate__c) =: year1 AND PG_CODE__r.PG_CODE__c=: Customer AND PrIce_List_Type__c =: PriceList[0].id order by startdate__c desc limit 1),(select id,Price__c from Discount_Masters__r where CALENDAR_MONTH(StartDate__c) =: month1 AND CALENDAR_YEAR(StartDate__c) =: year1 AND PG_CODE__r.PG_CODE__c=: Customer AND PrIce_List_Type__c =: PriceList[0].id order by startdate__c desc limit 1) from SKU__c where id in : SkuIds ];
                }
            }
            Map<id, Decimal> MasterMap = new Map<id, Decimal>();
            Map<id, Decimal> PlacementSchMap = new Map<id, Decimal>();
            for(SKU__c s : MasterPrice){
                if(s.Matching_Discounts__r.size()>0){
                    Decimal d = s.Matching_Discounts__r[0].Price__c;
                    if(d < 0 ){
                        d = (-1)*d;
                    }
                    MasterMap.put(s.id, d);
                }else{
                    MasterMap.put(s.id, 0);
                }
               
                if(s.Discount_Masters__r.size()>0){
                    Decimal d = s.Discount_Masters__r[0].Price__c;
                    if(d < 0 ){
                        d = (-1)*d;
                    }
                    PlacementSchMap.put(s.id, d);
                }else{
                    PlacementSchMap.put(s.id, 0);
                }
            }
            for(pricebookmaster__c p : PriceBookMasterLatestStartDate){
                
                ResultStored FinResults = new ResultStored();
                Decimal Price = 0;
                Decimal Channel = 5;
                Decimal Placement = 0;
                Decimal Matching = 0;
                Decimal gst = 0;
                
                if(p.Price__c != null){
                    Price = p.Price__c;
                }
               
                if(Customer.equals('03')){
                    Channel = 3;
                }
                if(PlacementSchMap.get(p.SKUCode__r.Id) != null){
                    Placement = PlacementSchMap.get(p.SKUCode__r.Id);
                }
                if(MasterMap.get(p.SKUCode__r.Id) != null){
                    Matching = MasterMap.get(p.SKUCode__r.Id);
                }
                if(p.SKUCode__r.GST__c != null){
                    gst = p.SKUCode__r.GST__c;
                }
                
                FinResults.Price  = p.Price__c;
                FinResults.SDate  = p.StartDate__c;
                FinResults.ProdectDescriptionFooter= p.SKUCode__r.Product_Name__r.Technical_Name__c;
                FinResults.EDate  = p.EndDate__c;
                FinResults.ProductName  = p.SKUCode__r.Brand_Name__c;
                FinResults.ProductIndicationType  = p.SKUCode__r.Product_Name__r.Portfolio__c;
                FinResults.Pack = p.SKUCode__r.Pack_Size_Description__c;
                FinResults.Gst = p.SKUCode__r.GST__c;
                FinResults.Description = p.SKUCode__r.SKU_Description__c;
                FinResults.MatchingPrice = MasterMap.get(p.SKUCode__r.Id);
                FinResults.ChannelMargin = Channel;
                FinResults.PlacementSchemes = PlacementSchMap.get(p.SKUCode__r.Id);
                
                Decimal CredNetPrice = Channel+Placement;
                CredNetPrice = (CredNetPrice/100)*Price;
                CredNetPrice = CredNetPrice + Matching;
                CredNetPrice = Price - CredNetPrice;
                FinResults.CreditNetPrice = CredNetPrice.setScale(2);
                Decimal NetPriceDistrib = (gst/100)*CredNetPrice;
                NetPriceDistrib = NetPriceDistrib + CredNetPrice;
                FinResults.NetPriceDist = NetPriceDistrib.setScale(2);
                Decimal suggestedRetPrice = (gst/100)*Price;
                suggestedRetPrice = suggestedRetPrice + Price;
                FinResults.SuggestedRetailerPrice= suggestedRetPrice.setScale(2);
                
                rs.add(FinResults);
            }
            wrap.Resuts = rs;
        }
        wrap.pricebookmaster = PriceList;
        wrap.PricesListBook = pm;
        return wrap;
    }
    
    
    @AuraEnabled
    public static PdfHeaderDetails HeaderDet(String Sbu, String Zones, String StartDate, String EndDate, String CustomerNum ){
        Datetime Start = Date.valueOf(StartDate);
        Datetime EndD = Date.valueOf(EndDate);
        
        PdfHeaderDetails PHD = new PdfHeaderDetails();
        List<Zone__c> ZoneCode = [select ZoneCode__c from Zone__c where name =:Zones];
        List<Period> fiscalYearList = [Select Type, StartDate, EndDate, Number, FiscalYearSettings.PeriodId From Period Where Type='Year' and startDate <= TODAY and endDate >= TODAY limit 1];
        String curFiscYear = String.valueof(fiscalYearList[0].StartDate.year());
        String circular ;
        String circular2;
        String CircularForEmail;
        if(ZoneCode.size() > 0 ){
            if(CustomerNum.equals('03')){
                circular = 'PL/'+ZoneCode[0].ZoneCode__c+'/Dist/'+Datetime.now().format('MMM')+'/'+curFiscYear.substring(2,4)+'/'+Zones.substring(0,3);
                circular2 = Sbu+' - '+Zones+' Distributor Price List for period '+Start.format('MMM dd, yyyy')+' till '+EndD.format('MMM dd, yyyy');
                CircularForEmail = Zones+' Distributor Price List for period '+Start.format('MMM dd, yyyy')+' till '+EndD.format('MMM dd, yyyy');
                
            } else{
                circular = 'PL/'+ZoneCode[0].ZoneCode__c+'/SuperDist/'+Datetime.now().format('MMM')+'/'+curFiscYear.substring(2,4)+'/'+Zones.substring(0,3);
                circular2 = Sbu+' - '+Zones+' Super Distributors Price List for period '+Start.format('MMM dd, yyyy')+' till '+EndD.format('MMM dd, yyyy');
                CircularForEmail = Zones+' Super Distributors Price List for period '+Start.format('MMM dd, yyyy')+' till '+EndD.format('MMM dd, yyyy');
            }
        }
        PHD.Circular1 = circular;
        PHD.Circular2 = circular2;
        PHD.Circular3 = CircularForEmail;
        return PHD;
    }
    
    
    public class FinalRes {
        @auraenabled  public list<PrIce_List_Type_Master__c> pricebookmaster {get; set;}
        @auraenabled  public list<ResultStored> Resuts {get; set;}
        @auraenabled  public List<pricebookmaster__c>  PricesListBook {get; set;}
        @auraenabled  public Map<String,String> DistributorMails {get; set;}
        
    }
    
    public class ResultStored { 
        @auraenabled  public Decimal Price {get; set;}
        @auraenabled  public String  Pack {get; set;}
        @auraenabled  public Decimal Gst {get; set;}
        @auraenabled  public Decimal ChannelMargin {get; set;}
        @auraenabled  public Decimal PlacementSchemes {get; set;}
        @auraenabled  public decimal MatchingPrice {get; set;}
        @auraenabled  public decimal CreditNetPrice {get; set;}
        @auraenabled  public decimal NetPriceDist {get; set;}
        @auraenabled  public String Description {get; set;}
        @auraenabled  public String ProductName {get; set;}
        @auraenabled  public String ProductIndicationType {get; set;}
        @auraenabled  public decimal SuggestedRetailerPrice {get; set;}
        @auraenabled  public String ProdectDescriptionFooter {get; set;}
        @auraenabled  public Date SDate {get; set;}
        @auraenabled  public Date EDate {get; set;}
        
        
    }
    
    public class Sbu {
        @AuraEnabled public Map<String, list<zone__c>> Sbus{get;set;}
        @AuraEnabled public Integer FiscalYear{get;set;}
    }
    
    public class PdfHeaderDetails {
        @auraenabled  public String Circular1 {get; set;}
        @auraenabled  public String Circular2 {get; set;}
        @auraenabled  public String Circular3 {get; set;}
        
    }
    
    public class AdminPanelInformation {
        @auraenabled  public String cir1 {get; set;}
        @auraenabled  public String cir2 {get; set;}
        @auraenabled  public boolean sent {get; set;}
        @auraenabled  public String sentDate {get; set;}
        @auraenabled  public String ContentDocId {get; set;}
        
    }
    
    public class AdminPanelInformationParent {
        @auraenabled 
        public List<AdminPanelInformation> AdminPanelRecs {get; set;}
        @AuraEnabled
        public Integer pageSize {get;set;}
        @AuraEnabled
        public Integer pageNumber {get;set;}
        @AuraEnabled
        public Integer totalRecords {get;set;}
        @AuraEnabled
        public Integer recordStart {get;set;}
        @AuraEnabled
        public Integer recordEnd {get;set;}
        
    }
    
}