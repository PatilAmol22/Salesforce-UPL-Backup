public class ObjectDataDeletion{

    
    // var Declaration
    public String ObjName {get;set;}
    public List<String> lstOfErr {get;set;}
    public String strErr {get;set;}
    public List<SelectOption> ObjectList {get;set;}
    public Date dtObj {get;set;}
    public Date todayDtObj {get;set;}
    
    public Boolean errorpnl {get;set;}
    public Boolean btchInterfacepnl {get;set;}
    
    // Constructor
    public ObjectDataDeletion(){
    
        System.debug('Constructor==>');
        
        errorpnl = false;
        btchInterfacepnl = true;
        lstOfErr = new List<String>();
        todayDtObj = System.today()-7;
        
        strErr = 'Selected Date should be less than Week';
        
    }
    public List<SelectOption> GetObjectOptions(){
        try{
        
            ObjectList = new List<SelectOption>();
            List<Schema.SObjectType> allObjects = Schema.getGlobalDescribe().Values();
            List<String> objLabels = new List<String>();
            Map<String, String> objLabelNameMap = new Map<String, String>();
            for(Schema.SObjectType objectName : allObjects) {  
         
                 String nm = objectName.getDescribe().getName();
                 Schema.DescribeSObjectResult objectResult = objectName.getDescribe();   
                 if(!nm.containsignorecase('history') && !nm.containsignorecase('Log')  && !nm.containsignorecase('feed') && !nm.containsignorecase('Share') && !nm.containsignorecase('Activity') && !objectResult.isCustomSetting()){
             
                    objLabels.add(objectName.getDescribe().getName());
                    objLabelNameMap.put(objectName.getDescribe().getName(),objectName.getDescribe().getName());
                    objLabels.sort();
                }
            }
            for(String objLabel : objLabels){            
                ObjectList.add(new SelectOption(objLabelNameMap.get(objLabel),objLabel));
            }
        }catch(Exception ex){
            
            System.debug('Error==>'+ex.getLinenumber());
            System.debug('Error==>'+ex.getcause());
        }
        return ObjectList;
    }
    
    public void DeleteObjData(){
        try{
            
            System.debug('DeleteObjData==>'+dtObj);
            
            errorpnl = false;
            if(dtObj != null){
                
                if(dtObj  < todayDtObj){                
                   
                        Database.executeBatch(new Batch_DelObjectDataOfSpecifiedDate(ObjName,dtObj),100);
                         
                }
                else{
                    
                    lstOfErr.add(strErr);
                    errorpnl = true;
                    //btchInterfacepnl = false;
                }
            }
        }catch(Exception ex){
            System.debug('Error==>'+ex.getLinenumber());
            System.debug('Error==>'+ex.getcause());
        }
    }
}