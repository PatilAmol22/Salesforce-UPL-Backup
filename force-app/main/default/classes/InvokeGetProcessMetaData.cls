public with sharing class InvokeGetProcessMetaData {
    List<String> salesOrgCode= new List<String>();//Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF material Requisition AF Material Requisition

    public static List<Free_Sample_Management__c> getMethod1(Set<String> targetObjectIds, List<String> salesOrgCode,String status, String subStatus, DateTime fromDateTime, DateTime toDateTime, String rName){//Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF material Requisition 
        List<Free_Sample_Management__c> fsmList= new List<Free_Sample_Management__c>();
        //Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF material Requisition
        fsmList=[SELECT Id, Name,Depot__r.Name,Territory_Manager__r.Name,Territory__r.Name,Approval_Submission_Date_Time__c  FROM Free_Sample_Management__c WHERE Id IN :targetObjectIds And Name Like : rName AND Approval_Submission_Date_Time__c >=: fromDateTime AND Approval_Submission_Date_Time__c <=: toDateTime AND SalesOrg__r.Sales_Org_Code__c  IN :salesOrgCode AND Status__c=:status AND Sub_Status__c=:subStatus];
    	return fsmList;
    }
    
    public static List<Free_Sample_Management__c> getMethod2(Set<String> targetObjectIds, List<String> salesOrgCode,String status, String subStatus, String rName){//Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF material Requisition
        System.debug('salesOrgCode :'+salesOrgCode);
        System.debug('status :'+status);
        System.debug('subStatus :'+subStatus); 
        List<Free_Sample_Management__c> fsmList= new List<Free_Sample_Management__c>();
        //Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF material Requisition
        fsmList=[SELECT Id, Name,Depot__r.Name,Territory_Manager__r.Name,Territory__r.Name,Approval_Submission_Date_Time__c  FROM Free_Sample_Management__c WHERE Id IN :targetObjectIds AND Name Like : rName AND SalesOrg__r.Sales_Org_Code__c IN :salesOrgCode AND Status__c=:status AND Sub_Status__c=:subStatus];
    	return fsmList;
    }
    //Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF material Requisition
    public static List<Free_Sample_Management__c> getMethod3(Set<String> targetObjectIds, List<String> salesOrgCode,String status, String subStatus, DateTime fromDateTime, DateTime toDateTime, String dName){
        List<Free_Sample_Management__c> fsmList= new List<Free_Sample_Management__c>();
        //Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF material Requisition
        fsmList=[SELECT Id, Name,Depot__r.Name,Territory_Manager__r.Name,Territory__r.Name,Approval_Submission_Date_Time__c  FROM Free_Sample_Management__c WHERE Id IN :targetObjectIds And Depot__r.Name Like : dName AND Approval_Submission_Date_Time__c >= :fromDateTime AND Approval_Submission_Date_Time__c <= :toDateTime AND SalesOrg__r.Sales_Org_Code__c IN :salesOrgCode AND Status__c=:status AND Sub_Status__c=:subStatus];
    	return fsmList;
    }
    //Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF material Requisition
    public static List<Free_Sample_Management__c> getMethod4(Set<String> targetObjectIds, List<String> salesOrgCode,String status, String subStatus, String dName){
        List<Free_Sample_Management__c> fsmList= new List<Free_Sample_Management__c>();
        //Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF material Requisition
        fsmList=[SELECT Id, Name,Depot__r.Name,Territory_Manager__r.Name,Territory__r.Name,Approval_Submission_Date_Time__c  FROM Free_Sample_Management__c WHERE Id IN :targetObjectIds And Depot__r.Name Like : dName AND SalesOrg__r.Sales_Org_Code__c IN :salesOrgCode AND Status__c=:status AND Sub_Status__c=:subStatus];
    	return fsmList;
    }
    //Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF material Requisition
    public static List<Free_Sample_Management__c> getMethod5(Set<String> targetObjectIds, List<String> salesOrgCode,String status, String subStatus,DateTime fromDateTime, DateTime toDateTime, String tName){
        List<Free_Sample_Management__c> fsmList= new List<Free_Sample_Management__c>();
        //Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF material Requisition
        fsmList=[SELECT Id, Name,Depot__r.Name,Territory_Manager__r.Name,Territory__r.Name,Approval_Submission_Date_Time__c  FROM Free_Sample_Management__c WHERE Id IN :targetObjectIds AND Territory__r.Name Like : tName AND Approval_Submission_Date_Time__c >=:fromDateTime AND Approval_Submission_Date_Time__c <=: toDateTime AND SalesOrg__r.Sales_Org_Code__c IN :salesOrgCode AND Status__c=:status AND Sub_Status__c=:subStatus];
    	return fsmList;
    }
    //Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF material Requisition
    public static List<Free_Sample_Management__c> getMethod6(Set<String> targetObjectIds, List<String> salesOrgCode,String status, String subStatus, String tName){
        List<Free_Sample_Management__c> fsmList= new List<Free_Sample_Management__c>();
        //Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF material Requisition
        fsmList=[SELECT Id, Name,Depot__r.Name,Territory_Manager__r.Name,Territory__r.Name,Approval_Submission_Date_Time__c  FROM Free_Sample_Management__c WHERE Id IN :targetObjectIds AND Territory__r.Name Like : tName AND SalesOrg__r.Sales_Org_Code__c IN :salesOrgCode AND Status__c=:status AND Sub_Status__c=:subStatus];
    	return fsmList;
    }
    //Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF material Requisition
    public static List<Free_Sample_Management__c> getMethod7(Set<String> targetObjectIds, List<String> salesOrgCode,String status, String subStatus, DateTime fromDateTime, DateTime toDateTime){
        List<Free_Sample_Management__c> fsmList= new List<Free_Sample_Management__c>();
        //Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF material Requisition
        fsmList=[SELECT Id, Name,Depot__r.Name,Territory_Manager__r.Name,Territory__r.Name,Approval_Submission_Date_Time__c  FROM Free_Sample_Management__c WHERE Id IN :targetObjectIds AND Approval_Submission_Date_Time__c >=:fromDateTime AND Approval_Submission_Date_Time__c <=: toDateTime AND SalesOrg__r.Sales_Org_Code__c IN :salesOrgCode AND Status__c=:status AND Sub_Status__c=:subStatus];
    	return fsmList;
    }
    //Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF material Requisition
    public static List<Free_Sample_Management__c> getMethod8(Set<String> targetObjectIds, List<String> salesOrgCode,String status, String subStatus){
        System.debug('targetObjectIds :'+targetObjectIds);
        System.debug('salesOrgCode :'+salesOrgCode);
        System.debug('status :'+status);
        System.debug('subStatus :'+subStatus);
        List<Free_Sample_Management__c> fsmList= new List<Free_Sample_Management__c>();
        //Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF material Requisition
        fsmList=[SELECT Id, Name,Depot__r.Name,Territory_Manager__r.Name,Territory__r.Name,Approval_Submission_Date_Time__c FROM Free_Sample_Management__c WHERE Id IN :targetObjectIds AND SalesOrg__r.Sales_Org_Code__c IN :salesOrgCode AND Status__c=:status AND Sub_Status__c=:subStatus ORDER BY LastModifiedDate ASC];
    	return fsmList;
    }
}