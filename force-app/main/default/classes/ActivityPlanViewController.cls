public class ActivityPlanViewController {
    public string actvyId{get; set;}
    public list<Activity_Plan__c> actPlan;
    public actvtywrap  actywrapobj {get;set;}
    public Boolean  status {get;set;}
    public string listid{get;set;}
    public list<RecordType> recordtypelist;
    public string marketReqId;
	public NumberTOWordConversion numToWordConversion;  
    
    public ActivityPlanViewController(ApexPages.StandardController stdController){
        recordtypelist = new list<RecordType>();
        actvyId = ApexPages.currentPage().getParameters().get('id');
        marketReqId= '';
        //setCon = stdController;
        system.debug('actvyId========'+actvyId);
        actplan = new list<Activity_Plan__c>();
        actywrapobj = new actvtywrap(); 
        status = true;
        List<ListView> listviews = [SELECT Id, Name FROM ListView WHERE SobjectType = 'Activity_Plan__c' and Name = 'All' limit 1];
        if(listviews.size()>0){
            listid = listviews[0].id;
        }
        numToWordConversion = new NumberTOWordConversion();
        viewActivityPlan();
        
    }
    public void viewActivityPlan(){
        try{
            
            actplan = [SELECT Id, Name,Crop_txt__c,Activity_Cost__c,Marketing_Requisition__c,Marketing_Requisition__r.name,RM_Settlement_Status__c,MM_Settlement_Status__c, CreatedDate  ,CreatedBy.name, CreatedBy.Bank_Name__c, CreatedBy.Bank_Account_Number__c, CreatedBy.TM_Code__c, CreatedBy.Email,CreatedBy.Title,RecordTypeId,Crop__r.name,Activity_Type__c,Territory_Name__c,Region_Name__c ,End_Date__c,Location__c,RM_Approval_Status__c,MM_Approval_Status__c,No_of_farmer_invited__c,MM_Approval__c,RM_approval__c,Time__c,No_of_R1_invited__c,Start_Date__c,Zonal_Manager__c from Activity_Plan__c where id =:actvyId]; 
            
            
            system.debug('actvyId========'+actvyId);
            // actywrapobj = new actvtywrap(); 
            if(actplan.size()>0){  
                recordtypelist = [SELECT Id, Name, DeveloperName, IsActive, Description FROM RecordType where IsActive = true AND id=:actplan[0].RecordTypeId];
                if(recordtypelist.size()>0){
                if(recordtypelist[0].Name == 'Marketing Requisiton' ){ 
                     system.debug('inside if Sohel');
                    actywrapobj.activityPlan =new Activity_Plan__c();
                    actywrapobj.activityPlan =  actplan[0];
                    actywrapobj.allocation= [select Id,Name,ProductGroup__c,Brand_Name__c,ProductGroup__r.Product_with_SKU__c,Product_Group__c,Product_Group__r.name,All_Percentage__c FROM  Allocation__c WHERE Activity_Plan__c  =: actvyId]; 
                    actywrapobj.itemAndAccm = [select Id,Name,Item_and_accomodation__c.NOU_Settlement__c,Item_and_accomodation__c.CPU_Settlement__c,Item_and_accomodation__c.ST_Settlement__c,Activity_Plan__c,Cost_Per_Unit__c,Item__c,No_of_Unit__c,Other_Item__c,Sub_total__c,Discription__c FROM  Item_and_accomodation__c WHERE Activity_Plan__c  =: actvyId];  
                    actywrapobj.liqdtn = [select Id,Name,Distributor__r.name,R1__r.name,Brand_Name__c,Activity_Plan__c,Product_SKU__c,Product_SKU__r.Name,Product_SKU__r.Product_with_SKU__c,Liquidation_Quantity__c,Price__c,Product__r.name,R1_Stock__c,Sub_Total__c FROM  Liquidation__c WHERE Activity_Plan__c  =: actvyId]; 
                    }else{
                    system.debug('inside else');
                    marketReqId = actplan[0].Marketing_Requisition__c;
                    system.debug('marketReqId ====>'+marketReqId );
                    actywrapobj.activityPlan =new Activity_Plan__c();
                    actywrapobj.activityPlan =  actplan[0];
                    actywrapobj.allocation= [select Id,Name,ProductGroup__r.Product_with_SKU__c,Brand_Name__c,Product_Group__c,Product_Group__r.name,All_Percentage__c FROM  Allocation__c WHERE Activity_Plan__c  =: marketReqId]; 
                    actywrapobj.itemAndAccm = [select Id,Name,Item_and_accomodation__c.NOU_Settlement__c,Item_and_accomodation__c.CPU_Settlement__c,Item_and_accomodation__c.ST_Settlement__c,Activity_Plan__c,Cost_Per_Unit__c,Item__c,No_of_Unit__c,Other_Item__c,Sub_total__c,Discription__c FROM  Item_and_accomodation__c WHERE Activity_Plan__c  =: actvyId];  
                    actywrapobj.liqdtn = [select Id,Name,Distributor__r.name,R1__r.name,Activity_Plan__c,Brand_Name__c,Product_SKU__c,Product_SKU__r.Name,Liquidation_Quantity__c,Price__c,Product__r.name,R1_Stock__c,Sub_Total__c FROM  Liquidation__c WHERE Activity_Plan__c  =: actvyId]; 
                    }
                    system.debug('actplan[0].Activity_Cost__c : '+actplan[0].Activity_Cost__c);
                    actywrapobj.sayInWords = numToWordConversion.getNumberTOWordConversion(DEcimal.ValueOf(String.valueOf(actplan[0].Activity_Cost__c)));
                    system.debug('actywrapobj.sayInWords : '+actywrapobj.sayInWords);
                    List<ProcessInstance> pInstance = [SELECT Id,Status,Createddate, (SELECT Id, Actor.Name, StepStatus, Comments, CreatedDate FROM Steps)
                                                 FROM ProcessInstance Where TargetObjectId =:actvyId Order by CreatedDate DESC LIMIT 1];
                    String allComments = '';                    
                    if(null != pInstance){
                        for(ProcessInstance p : pInstance){
                            if(null != p.Steps){
                                for(ProcessInstanceStep pstep : p.Steps){
                                    system.debug('pstep : '+pstep.comments); 
                                    if(null != pstep.comments && null != pstep.Actor.Name){
                                        allComments = allComments + '<strong>'+pstep.Actor.Name+'</strong>' +':: ' + pstep.comments+'<br/>';                    
                                    }                                    
                                }            
                            }    
                        } 
                        system.debug('allComments : '+allComments);
                        actywrapobj.remarks = allComments;
                    }
                    
            }
                    for(Allocation__c a  : actywrapobj.allocation){
                        actywrapobj.totalallctnPcent = actywrapobj.totalallctnPcent + a.All_Percentage__c;
                    }  
                    
                    for(Item_and_accomodation__c item :  actywrapobj.itemAndAccm){
                        actywrapobj.totalItemCost = actywrapobj.totalItemCost + item.Sub_total__c;
                    }      
                    
                    for(Liquidation__c liq  : actywrapobj.liqdtn){
                        actywrapobj.totalLqdCost =  actywrapobj.totalLqdCost + liq.Sub_total__c;
                    }                           
                
            }
            
        }catch(Exception e){
            
            System.debug('The following exception has occurred: ' + e.getMessage());
            System.debug('The following exception has occurred: ' + e.getLineNumber());
            
        }
        system.debug('activity plan ============'+actywrapobj.activityPlan);
        system.debug('activity allocation ============'+actywrapobj.allocation);
        system.debug('activity item_and_allocation ============'+actywrapobj.itemAndAccm);
        system.debug('activity Liqidation ============'+actywrapobj.liqdtn);
        system.debug('allcation percentage'+actywrapobj.totalallctnPcent);
    }
    
    public class actvtywrap{
        public Activity_Plan__c activityPlan{get;set;}
        public list<Allocation__c> allocation{get;set;}
        public list<Item_and_accomodation__c> itemAndAccm{get;set;}
        public list<Liquidation__c> liqdtn{get;set;}
        public decimal totalallctnPcent{get;set;}
        public decimal totalItemCost{get;set;}
        public decimal totalLqdCost{get;set;}
        public String sayInWords{get; set;}
        public String remarks{get; set;}
        
        public actvtywrap(){
            totalallctnPcent = 0;
            totalItemCost = 0;
            totalLqdCost = 0;
            activityPlan = new Activity_Plan__c();
            allocation = new  list<Allocation__c>();
            itemAndAccm = new list<Item_and_accomodation__c>();
            liqdtn = new list<Liquidation__c>();
            sayInWords = '';
            remarks='';
        }
    }
}