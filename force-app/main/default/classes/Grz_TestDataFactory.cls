@isTest
public class Grz_TestDataFactory {
    
    Public static Partner_Portal_Configuration__c createSummaryTabs(Boolean doInsert,String Name,String Label,Integer Order,String Url,String Language,Id RecordTypeId){
        Partner_Portal_Configuration__c obj=new Partner_Portal_Configuration__c();
        obj.Name = Name;
        obj.Label__c = Label;        
        obj.Order__c = Order;
        obj.URL__c = Url;
        obj.Language__c = Language;
        obj.RecordTypeId=RecordTypeId;
        if (doInsert) {
            insert obj;
        }        
        return obj;
    }
    
    Public static Sales_Org__c createSalesOrg(Boolean doInsert, String Name, String orgCode){
        Sales_Org__c sorg = new Sales_Org__c();
        sorg.Name = Name;
        sorg.Sales_Org_Code__c = orgCode;
        //Change by Aashima(Grazitti) for APPS-4027 28Dec22
        if(orgCode=='1410'){
            sorg.Company_Code__c = '1400';
        }
        else{
            sorg.Company_Code__c = orgCode;
        }
        
        if (doInsert)
        {
            insert sorg;
        }        
        return sorg;
    }
    Public static Account createUserAccount(Boolean doInsert, String AccountName, Id RecordTypeId , Id orgId){
        Account acc = new Account();
        acc.Name = AccountName;
        acc.RecordTypeId = RecordTypeId;
        acc.SAP_Code__c = '1001801';
        acc.Sales_Org__c = orgId;
        acc.Sap_UserId__c = 'UPLINTCRM';
        if (doInsert) {
            insert acc;
        }        
        return acc;
    }
    Public static Account createAccount(Boolean doInsert, String AccountName, Id RecordTypeId){
        Territory_Distributor__c trt = Grz_TestDataFactory.createTeritory(true);
        Account acc = new Account();
        acc.Name = AccountName;
        acc.Territory_Distributor__c = trt.Id;
        acc.RecordTypeId = RecordTypeId;
        if (doInsert) {
            insert acc;
        }        
        return acc;
    }
    
    Public static Sales_Order__c createSalesOrderRecord(Boolean doInsert,String SAPOrderNumber,String OrderStatus,Date Orderdate,String Accountname){
        Sales_Order__c obj = new Sales_Order__c();
        obj.SAP_Order_Number__c = SAPOrderNumber;        
        obj.Order_Status__c = OrderStatus;
        obj.Order_Date__c = Orderdate;
        obj.Sold_to_Party__c = Accountname;
        if (doInsert) {
            insert obj;
        }        
        return obj;
    }
    Public static Sales_Order_Line_Item__c createsalesLineItemsRecord(Boolean doInsert,String SalesOrderId,Integer TotalDiscount){
        Sales_Order_Line_Item__c orderlineObj = new Sales_Order_Line_Item__c();
        orderlineObj.Sale_Order__c = SalesOrderId;        
        orderlineObj.Per_Unit_Discount__c = TotalDiscount;
        if (doInsert) {
            insert orderlineObj;
        }        
        return orderlineObj;
    }
    
    Public static Case createCaseRecord(Boolean doInsert,String Subject,String CaseType,String AccountId,Id RecordtypeId){
        Case caseObj = new Case();
        caseObj.RecordTypeId = RecordtypeId;
        caseObj.Subject = Subject;        
        caseObj.AccountId = AccountId;
        caseObj.Type = CaseType;
        //caseObj.Crop_pick__c = 'Coffee';
        caseObj.Escalation_Level__c = 'Escalated L1';
        //caseObj.CaseOwner__c = 'RCM';
        if (doInsert) {
            insert caseObj;
        }        
        return caseObj;
    }
    
    Public static CaseComment createCaseComment(Boolean doInsert,Id CaseId,String Body){
        CaseComment cm = new CaseComment();
        cm.parentid = CaseId;
        cm.CommentBody = Body;
        cm.IsPublished = true;
        if (doInsert) {
            insert cm;
        } 
        
        return cm;
    }
    Public static SKU__c createSKU(Boolean doInsert){
        SKU__c sk = new SKU__c();
        sk.Name = 'test';
        sk.Combination_Key__c = '12345';
        sk.SKU_Code__c = '12334';
        sk.SKU_Description__c = 'test description';
        sk.Pack_Size__c = 32.32;
        if (doInsert) {
            insert sk;
        } 
        return sk;
    }
    Public static PriceBookMaster__c createPriceBook(Boolean doInsert,Id accId , Id skId){
        PriceBookMaster__c pb = new PriceBookMaster__c();
        pb.StartDate__c = Date.newInstance(2020, 12, 9);
        pb.EndDate__c =  Date.newInstance(2021, 12, 9);
        pb.DistributorCustomerCode__c = accId;
        pb.CompositeKey__c = '12345';
        pb.Price__c = 1324;
        pb.SKUCode__c = skId;
        
        if (doInsert) {
            insert pb;
        } 
        return pb;
    }
    Public static Matching_Discount__c createMatchingDiscount(Boolean doInsert,Id skId){
        Matching_Discount__c md = new Matching_Discount__c();
        md.EndDate__c = Date.newInstance(2020, 12, 9);
        md.StartDate__c = Date.newInstance(2021, 12, 9);
        md.SKUCode__c = skId;
        md.Price__c = 2321;
        if (doInsert) {
            insert md;
        } 
        return md;
    }
    Public static Contact createContact(Boolean doInsert,String lastName, Id accId){
        Contact con = new Contact();
        con.LastName = lastName;
        con.firstName = lastName;
        con.AccountId = accId;
        if (doInsert) {
            insert con;
        }        
        return con;
    }
    Public static SMS_Template__c createTemplate(Boolean doInsert, String Name , String ObjectName){
        SMS_Template__c tem = new SMS_Template__c();
        tem.Name = Name;
        tem.ObjectName__c = ObjectName;
        tem.Text__c ='<URL> Test';
        if (doInsert) {
            insert tem;
        }        
        return tem;
    }
    Public static Invoice__c createInvoice(Boolean doInsert , Id accId){
        Invoice__c inv = new Invoice__c();
        inv.Billing_Doc_Number__c = '1234';
        inv.Sold_To_Party__c = accId;
        if (doInsert) {
            insert inv;
        }        
        return inv;
    }
    public static User createExternalUser(Boolean doInsert,Id profileId, Id conId){
        
        Decimal num=Math.random();
        User usr=new User();
        usr.alias = 'tusr8x8';
        usr.email='test@grazitti.com'; 
        usr.emailencodingkey='UTF-8';
        usr.lastname='Testing';
        usr.firstname='Testing';
        usr.languagelocalekey='en_US'; 
        usr.localesidkey='en_US';
        usr.ContactId = conId;
        usr.ProfileId = profileId;
        usr.MobilePhone = '0000000000';
        usr.timezonesidkey='America/Los_Angeles';
        usr.username='test@grazitti'+num+'.com';
        if (doInsert) {
            insert usr;
        }
        return usr;
    }
    
    public static User updateExternalUser(Boolean doUpdate, Id usrId){
        User usr=new User();
        usr.Id = usrId;
        usr.lastname='Testing';
        usr.firstname='Testing';       
        if (doUpdate) {
            update usr;
        }
        return usr;
    }
    public static User createInternalUser(Boolean doInsert,Id profileId){
        Decimal num=Math.random();
        User usr=new User();
        usr.alias = 'tusr8x8';
        usr.email='test1@grazitti.com'; 
        usr.emailencodingkey='UTF-8';
        usr.lastname='Testing';
        usr.firstname='C&F';
        usr.languagelocalekey='en_US'; 
        usr.localesidkey='en_US';
        usr.ProfileId = profileId;
        usr.MobilePhone = '0000000000';
        usr.timezonesidkey='America/Los_Angeles';
        usr.username='test@grazitti'+num+'.com';        
        if (doInsert) {
            insert usr;
        }
        return usr;
    }
    Public static ContentDocument createContentDocument(Boolean doInsert){
        ContentVersion cv = new ContentVersion();
        cv.Title = '#999-343434343';
        cv.PathOnClient = 'testDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        if (doInsert) {
            Insert cv;
            List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
            List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            return cdList[0];
        }        
        else{
            return null;
        }
    }
    public static Territory_Distributor__c createTeritory(Boolean doInsert){
        Territory_Distributor__c tr=new Territory_Distributor__c();
        tr.Name = 'test';
        tr.TerritoryCode__c = 'IND1001';
        tr.RCM_Email__c = 'TestUser@gmail.com';
        tr.TerritoryManager__c = userinfo.getUserId();
        if (doInsert) {
            insert tr;
        }
        return tr;
    }
    public static EmailTemplate createEmailTemplate(Boolean doInsert){
        EmailTemplate et=new EmailTemplate();
        et.Body = 'test';
        et.Subject = '[CaseNumber] test';
        et.HtmlValue = '[OwnerEmail] test [CaseDetailPageLink]';
        et.DeveloperName = 'CaseCommentEmailTemplate';
        if (doInsert) {
            insert et;
        }
        return et;
    }
    
    public static Case_Matrix__c createCaseMatrix(Boolean doInsert,String CaseType,String CaseOwner,Id SalesOrgId){
        Case_Matrix__c cmax = new Case_Matrix__c();
        cmax.Case_Type__c = CaseType;
        cmax.Case_Owner__c = CaseOwner;
        cmax.Sales_Org__c = SalesOrgId;
        
        if (doInsert) {
            insert cmax;
        }
        return cmax;
    }
    
    public static List<Id> mapAttachmentToCase(Boolean doInsert,String ContentDocId,String CaseId){
        List<ContentVersion> contentVerList=[Select Id,Guest_Record_fileupload__c from contentversion where contentdocumentid =: ContentDocId];
        List<ContentVersion> cvUpdateList=new List<ContentVersion>();
        List<Id> cvIdList = new List<id>();
        for(ContentVersion cv:contentVerList){
            cv.Guest_Record_fileupload__c = CaseId;
            cvUpdateList.add(cv);
            cvIdList.add(cv.Id);
        }            
        if(!cvUpdateList.isEmpty()){
            update cvUpdateList;
        }
        List<ContentDocumentLink> cdlinklist = new List<ContentDocumentLink>();
        ContentDocumentLink cDocLink = new ContentDocumentLink(ContentDocumentId = ContentDocId);
        //cDocLink.ContentDocumentId = ctid;//Add ContentDocumentId
        cDocLink.LinkedEntityId = CaseId;//Add attachment parentId
        cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers 
        cdlinklist.add(cDocLink); 
        
        if (doInsert) {
            insert cdlinklist; 
        }
        return cvIdList;
    }
    public static Group creategroup(Boolean doInsert){
        Group grp=new Group();
        grp.Name = 'India Test Users';
        if (doInsert) {
            insert grp;
        }
        return grp;
    }
    public static GroupMember createGM(Boolean doInsert, Id groupID,Id userId){
        GroupMember grpm=new GroupMember();
        grpm.GroupId = groupID;
        grpm.UserOrGroupId = userId;
        if (doInsert) {
            insert grpm;
        }
        return grpm;
    }
    
    public static Zone__c createZone(Boolean doInsert, String Name, String zoneHeadId,String OrgId){
        Zone__c zone = new Zone__c();
        zone.Name = Name;
        zone.ZonalHead__c = zoneHeadId;
        zone.SalesOrg__c = OrgId;
        zone.ZoneCode__c = 'IND1001';
        if (doInsert) {
            insert zone;
        }
        return zone;
    }
    
    public static Depot__c createDepot(Boolean doInsert, String Name,String OrgId){
        Depot__c Depot = new Depot__c();
        Depot.Name = Name;
        Depot.Depot_Code__c = Name+'ind1001';
        Depot.Case_Access_Email__c = 'Test123@gmail.com';
        Depot.Active__c = true;
        Depot.SalesOrg__c = OrgId;
        if (doInsert) {
            insert Depot;
        }
        return Depot;
    }
    
    public static TM_Depot_Mapping__c createTMDepot(Boolean doInsert, String DepotId){
        TM_Depot_Mapping__c tmDepot = new TM_Depot_Mapping__c();
        tmDepot.Depot__c = DepotId;
        tmDepot.Territory_Manager__c = userinfo.getUserId();
        tmDepot.Depot_Name__c = 'Test Depot';
        if (doInsert) {
            insert tmDepot;
        }
        return tmDepot;
    }
    
    Public static Case createBrazilCaseRecord(Boolean doInsert,String Subject,String CaseType,String AccountId,Id RecordtypeId,String entitlementId,String OwnerId){
        Case caseObj = new Case();
        caseObj.RecordTypeId = RecordtypeId;
        caseObj.Subject = Subject;        
        caseObj.AccountId = AccountId;
        caseObj.Type = CaseType;
        caseObj.Crop_pick__c = 'Coffee';
        caseObj.Escalation_Level__c = 'Escalated L1';
        caseObj.OwnerId = OwnerId;
        caseObj.EntitlementId=entitlementId;
        if (doInsert) {
            insert caseObj;
        }        
        return caseObj;
    }
    public static Zone__c CreateZoneBr()
    {
        Zone__c zn = new Zone__c();
        zn.Name='BU CERRADO LESTE';
        zn.ZoneCode__c='BR15';
        insert zn;
        return zn;
    }
    public static Territory_Distributor__c CreateTerritoryBr(Zone__c zn,User usr,Sales_Org__c sorg)
    {
        Territory_Distributor__c tr = new Territory_Distributor__c();
        tr.SalesOrg__c =sorg.id;
        tr.TerritoryManager__c=usr.Id;
        tr.TerritoryCode__c='BR160';//added while create rebate 
        tr.Zone__c=zn.Id;
        insert tr;
        return tr;
        
    }
    public static DistributorSalesAreaMapping__c CreateSalesArea(Boolean doInsert,Account acc,String SalaeOrgId,String TerritoryId)
    {
        DistributorSalesAreaMapping__c sa = new DistributorSalesAreaMapping__c();
        sa.Distributor__c  =acc.id;
        sa.AccountOwner__c = acc.OwnerId;
        sa.SalesOrg__c = SalaeOrgId;
        if(TerritoryId!='')
        sa.Territory__c = TerritoryId;
        if (doInsert) {
            insert sa;
        } 
        return sa;
    }
    public static Dispatch__c CreateDispatch(Boolean doInsert,Account acc,String Deliverynumber,String SalesOrderId,String SalesOrderLineId,String SalesOrgId){
        Dispatch__c ds = new Dispatch__c();
        ds.Customer__c = acc.id;
        ds.Deliverynumber__c = Deliverynumber;
        ds.Sales_Order__c = SalesOrderId;
        ds.SalesOrderLineItem__c = SalesOrderLineId;
        ds.SalesOrg__c = SalesOrgId;
        if (doInsert) {
            insert ds;
        } 
        return ds;
    }     
    
    public static Shipping_Location__c CreateShippingLocation(Boolean doInsert,String acc,String distributionalChannelId,String divisonId,String SalesOrderId){
        
        Shipping_Location__c shippLocation=new Shipping_Location__c();
        shippLocation.Active__c=true;
        shippLocation.Distribution_Channel__c=distributionalChannelId;
        shippLocation.Division__c=divisonId;
        shippLocation.Distributor__c=acc;
        shippLocation.Country_Name__c='India';
        shippLocation.Sales_Org__c=SalesOrderId;
        shippLocation.SAP_Code__c='123456';
        if (doInsert) {
            insert shippLocation;
        } 
        return shippLocation;
    }     
}