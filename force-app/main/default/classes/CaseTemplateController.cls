public class CaseTemplateController {
    
  //public Case caseObj{get;set;}
    public String lastApproverName{get;set;}
    public String comments{get;set;}
    public String combinedStrings {get;set;}
    
    Set<String> myset;
    public List<ProcessInstance> piList{get;set;}
    public List<ProcessInstanceStep> options{get;set;}
    public ProcessInstance piObj;
    
   
    public CaseTemplateController(){
        piList = new List<ProcessInstance>();
        options = new List<ProcessInstanceStep>();
        piObj = new ProcessInstance();
      //  getProcessInstanceList();
    }
   
  public String str{
   get{
       System.debug('combinedStrings :- '+combinedStrings);
        getProcessInstanceList(combinedStrings);
       return str;
   }
   }
    public void getProcessInstanceList(String c_id){
    
  
    System.Debug('combinedStrings========>' +combinedStrings);
        
        try{
        piList = [SELECT Status, TargetObjectId,LastActor.Name,
                  (Select StepStatus,Comments,ActorId,Actor.Name FROM Steps Where StepStatus='Approved' ORDER BY StepStatus DESC)// 
                  FROM ProcessInstance WHERE TargetObjectId =:c_id];
       
        for(ProcessInstanceStep  pi:piList[0].Steps){
             
            System.debug('Comments ==> '+pi.Comments);          
            options.add(pi);
          }
            
           
        System.debug('Option.size ---> '+options.size());
           
        } catch(Exception e){
            System.debug('error :- '+e.getMessage());
            System.debug('error :- '+e.getLineNumber());
        }
       
    }
}