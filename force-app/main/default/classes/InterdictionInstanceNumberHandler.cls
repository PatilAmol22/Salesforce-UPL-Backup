/*
@Author: Pragati Sharma  For APPS-3648
@Class_Description : Invocable method to call from flow for updating instance number.
*/ 
public class InterdictionInstanceNumberHandler {
    @InvocableMethod (label='Instance Number on Interdiction Process')
    public static void updateInstanceNumber(List<String> recordId){
        List<Interdiction_Process__c> interdictionList=[Select id,Instance_Number__c,IS_AN_INTERDICTION__c from Interdiction_Process__c where id in:recordId];
        System.debug('interdictionList'+interdictionList);
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        System.debug('DataFromInterdictioncustom'+DataFromInterdictioncustom);
        String SimCount=String.valueOf(DataFromInterdictioncustom.Sim__c);
        String NaoCount=String.valueOf(DataFromInterdictioncustom.Nao__c);
        System.debug('DataFromInterdictioncustom 1'+SimCount);
        System.debug('DataFromInterdictioncustom 2'+SimCount);
        Integer naoCounter;
        Integer simCounter;
        String variabletoComparethelength;
        List<Interdiction_Process__c> InterListToUpdate=new List<Interdiction_Process__c>();
        List<InterdictionProcessInstanceSetting__c> CustomSettingListToUpdate=new List<InterdictionProcessInstanceSetting__c>();
        Integer NaoCountInt;
        Integer SimCountInt;
        for(Interdiction_Process__c ipc:interdictionList){
            System.debug('@@ eneter in for loop ip cid '+ipc.id+'@@ '+ipc.Instance_Number__c );
            if(ipc.IS_AN_INTERDICTION__c=='Sim'){
                if(Integer.valueOf(SimCount)==0){
                    
                    ipc.Instance_Number__c='INT0000001';
                    SimCount='1';
                    System.debug('SimCount 18'+SimCount);
                     //InterListToUpdate.add(ipc);
                    
                }
                else{
                    
                    
                    if(SimCount.length()==1){
                        System.debug('eneter in 38'+simCounter);
                        if(simCounter!=null && variabletoComparethelength.length()==1){
                            
                            ipc.Instance_Number__c= 'INT000000'+simCounter;
                            simCounter=Integer.valueOf(simCounter)+1;
                            variabletoComparethelength =String.valueOf(simCounter);
                        }
                        if(simCounter!=null && variabletoComparethelength.length()==2){
                            
                            ipc.Instance_Number__c= 'INT00000'+simCounter;
                            simCounter=Integer.valueOf(simCounter)+1;
                            variabletoComparethelength =String.valueOf(simCounter);
                        }
                        if(simCounter!=null && variabletoComparethelength.length()==3){
                            
                            ipc.Instance_Number__c= 'INT0000'+simCounter;
                            simCounter=Integer.valueOf(simCounter)+1;
                            variabletoComparethelength =String.valueOf(simCounter);
                        }
                       
                        else if(simCounter==null) {
                            System.debug('eneter in 70');
                            SimCountInt=Integer.valueOf(SimCount)+1;
                             if(SimCountInt==10){
                              ipc.Instance_Number__c= 'INT00000'+SimCountInt; 
                                simCounter=Integer.valueOf(SimCountInt)+1;
                            variabletoComparethelength =String.valueOf(simCounter);
                            }
                            else{
                            ipc.Instance_Number__c= 'INT000000'+SimCountInt;
                            simCounter=Integer.valueOf(SimCountInt)+1;
                            variabletoComparethelength =String.valueOf(simCounter);
                            }
                        }
                        System.debug('ipc.Instance_Number__c'+ipc.Instance_Number__c);
                    }
                    if(SimCount.length()==2 ){
                        if(simCounter!=null && variabletoComparethelength.length()==2){
                            System.debug('eneter in nao counter 2');
                            ipc.Instance_Number__c= 'INT00000'+simCounter;
                            simCounter=Integer.valueOf(simCounter)+1;
                            variabletoComparethelength =String.valueOf(simCounter);
                            
                        }
                        else if(simCounter!=null && variabletoComparethelength.length()==3){
                            System.debug('eneter in nao counter 3'+simCounter);
                            ipc.Instance_Number__c= 'INT0000'+simCounter;
                            simCounter=Integer.valueOf(simCounter)+1;
                            variabletoComparethelength =String.valueOf(simCounter);
                        }
                        else if(simCounter!=null && variabletoComparethelength.length()==4){
                            System.debug('eneter in nao counter 3');
                            ipc.Instance_Number__c= 'INT000'+simCounter;
                            simCounter=Integer.valueOf(simCounter)+1;
                            variabletoComparethelength =String.valueOf(simCounter);
                        }
                       
                        else if(simCounter==null){
                            SimCountInt=Integer.valueOf(SimCount)+1;
                           if(SimCountInt==100){
                              ipc.Instance_Number__c= 'INT0000'+SimCountInt; 
                                simCounter=Integer.valueOf(SimCountInt)+1;
                            variabletoComparethelength =String.valueOf(simCounter);
                            }
                            else{
                            ipc.Instance_Number__c= 'INT00000'+SimCountInt;
                            simCounter=Integer.valueOf(SimCountInt)+1;
                            variabletoComparethelength =String.valueOf(simCounter);
                            }
                        }
                        
                        System.debug('simCounter'+simCounter+' ipc.Instance_Number__c '+ ipc.Instance_Number__c);
                    }
                    if(SimCount.length()==3 ){
                        if(simCounter!=null && variabletoComparethelength.length()==3){
                            System.debug('eneter in nao counter 3');
                            ipc.Instance_Number__c= 'INT0000'+simCounter;
                            simCounter=Integer.valueOf(simCounter)+1;
                            variabletoComparethelength =String.valueOf(simCounter);
                        }
                        else if(simCounter!=null && variabletoComparethelength.length()==4){
                            System.debug('eneter in nao counter 3');
                            ipc.Instance_Number__c= 'INT000'+simCounter;
                            simCounter=Integer.valueOf(simCounter)+1;
                            variabletoComparethelength =String.valueOf(simCounter);
                        }
                        else if(simCounter!=null && variabletoComparethelength.length()==5){
                            System.debug('eneter in nao counter 3');
                            ipc.Instance_Number__c= 'INT00'+simCounter;
                            simCounter=Integer.valueOf(simCounter)+1;
                            variabletoComparethelength =String.valueOf(simCounter);
                        }
                        else if(simCounter==null){
                            SimCountInt=Integer.valueOf(SimCount)+1;
                            if(SimCountInt==1000){
                              ipc.Instance_Number__c= 'INT000'+SimCountInt; 
                                simCounter=Integer.valueOf(SimCountInt)+1;
                            variabletoComparethelength =String.valueOf(simCounter);
                            }
                            else{
                            ipc.Instance_Number__c= 'INT0000'+SimCountInt;
                            simCounter=Integer.valueOf(SimCountInt)+1;
                            variabletoComparethelength =String.valueOf(simCounter);
                            }
                        }
                    }
                    if(SimCount.length()==4 ){
                        if(simCounter!=null && variabletoComparethelength.length()==4){
                            System.debug('eneter in nao counter 4');
                            ipc.Instance_Number__c= 'INT000'+simCounter;
                            simCounter=Integer.valueOf(simCounter)+1;
                            variabletoComparethelength =String.valueOf(simCounter);
                        }
                        else if(simCounter!=null && variabletoComparethelength.length()==5){
                            System.debug('eneter in nao counter 3');
                            ipc.Instance_Number__c= 'INT00'+simCounter;
                            simCounter=Integer.valueOf(simCounter)+1;
                            variabletoComparethelength =String.valueOf(simCounter);
                        }
                        else if(simCounter==null){
                            SimCountInt=Integer.valueOf(SimCount)+1;
                            if(SimCountInt==10000){
                              ipc.Instance_Number__c= 'INT00'+SimCountInt; 
                                simCounter=Integer.valueOf(SimCountInt)+1;
                            variabletoComparethelength =String.valueOf(simCounter);
                            }
                            else{
                            ipc.Instance_Number__c= 'INT000'+SimCountInt;
                            simCounter=Integer.valueOf(SimCountInt)+1;
                            variabletoComparethelength =String.valueOf(simCounter);
                            }
                        }
                    }
                    if(SimCount.length()==5){
                        if(simCounter!=null  && variabletoComparethelength.length()==5){
                            System.debug('eneter in nao counter');
                            ipc.Instance_Number__c= 'INT00'+simCounter;
                            simCounter=Integer.valueOf(simCounter)+1;
                            variabletoComparethelength =String.valueOf(simCounter);
                        }
                        else if(simCounter!=null && variabletoComparethelength.length()==6){
                            System.debug('eneter in nao counter 3');
                            ipc.Instance_Number__c= 'INT0'+simCounter;
                            simCounter=Integer.valueOf(simCounter)+1;
                            variabletoComparethelength =String.valueOf(simCounter);
                        }
                        else if(simCounter==null){
                            SimCountInt=Integer.valueOf(SimCount)+1;
                            if(SimCountInt==100000){
                              ipc.Instance_Number__c= 'INT0'+SimCountInt; 
                                simCounter=Integer.valueOf(SimCountInt)+1;
                            variabletoComparethelength =String.valueOf(simCounter);
                            }
                            else{
                            ipc.Instance_Number__c= 'INT00'+SimCountInt;
                            simCounter=Integer.valueOf(SimCountInt)+1;
                            variabletoComparethelength =String.valueOf(simCounter);
                            }
                        }
                        
                        
                    }
                }
                 InterListToUpdate.add(ipc);
            }
            else if(ipc.IS_AN_INTERDICTION__c=='Não'){
                
                if(Integer.valueOf(NaoCount)==0){
                    
                    ipc.Instance_Number__c='REC0000001';
                    NaoCount='1';
                    System.debug('NaoCount 18'+NaoCount);
                    // InterListToUpdate.add(ipc);
                }
                else{
                    
                    
                    if(NaoCount.length()==1){
                        if(naoCounter!=null && variabletoComparethelength.length()==1){
                            
                            ipc.Instance_Number__c= 'REC000000'+naoCounter;
                            naoCounter=Integer.valueOf(naoCounter)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                        }
                        if(naoCounter!=null && variabletoComparethelength.length()==2){
                            
                            ipc.Instance_Number__c= 'REC00000'+naoCounter;
                            naoCounter=Integer.valueOf(naoCounter)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                        }
                        if(naoCounter!=null && variabletoComparethelength.length()==3){
                            
                            ipc.Instance_Number__c= 'REC0000'+naoCounter;
                            naoCounter=Integer.valueOf(naoCounter)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                        }
                        if(naoCounter!=null && variabletoComparethelength.length()==4){
                            
                            ipc.Instance_Number__c= 'REC000'+naoCounter;
                            naoCounter=Integer.valueOf(naoCounter)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                        }
                        if(naoCounter!=null && variabletoComparethelength.length()==5){
                            
                            ipc.Instance_Number__c= 'REC00'+naoCounter;
                            naoCounter=Integer.valueOf(naoCounter)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                        }
                        else if(naoCounter==null) {
                            NaoCountInt=Integer.valueOf(NaoCount)+1;
                             if(NaoCountInt==10){
                              ipc.Instance_Number__c= 'REC00000'+NaoCountInt; 
                                naoCounter=Integer.valueOf(NaoCountInt)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                            }
                            else{
                            ipc.Instance_Number__c= 'REC000000'+NaoCountInt;
                            naoCounter=Integer.valueOf(NaoCountInt)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                            }
                        }
                        System.debug('ipc.Instance_Number__c'+ipc.Instance_Number__c);
                    }
                    if(NaoCount.length()==2 ){
                        if(naoCounter!=null && variabletoComparethelength.length()==2){
                            System.debug('eneter in nao counter 2');
                            ipc.Instance_Number__c= 'REC00000'+naoCounter;
                            naoCounter=Integer.valueOf(naoCounter)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                            
                        }
                        else if(naoCounter!=null && variabletoComparethelength.length()==3){
                            System.debug('eneter in nao counter 3');
                            ipc.Instance_Number__c= 'REC0000'+naoCounter;
                            naoCounter=Integer.valueOf(naoCounter)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                        }
                        else if(naoCounter!=null && variabletoComparethelength.length()==4){
                            System.debug('eneter in nao counter 3');
                            ipc.Instance_Number__c= 'REC000'+naoCounter;
                            naoCounter=Integer.valueOf(naoCounter)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                        }
                        else if(naoCounter!=null && variabletoComparethelength.length()==5){
                            System.debug('eneter in nao counter 3');
                            ipc.Instance_Number__c= 'REC00'+naoCounter;
                            naoCounter=Integer.valueOf(naoCounter)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                        }
                        else if(naoCounter==null){
                            NaoCountInt=Integer.valueOf(NaoCount)+1;
                            if(NaoCountInt==100){
                              ipc.Instance_Number__c= 'REC0000'+NaoCountInt; 
                                naoCounter=Integer.valueOf(NaoCountInt)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                            }
                            else{
                            ipc.Instance_Number__c= 'REC00000'+NaoCountInt;
                            naoCounter=Integer.valueOf(NaoCountInt)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                            }
                        }
                        
                        System.debug('naoCounter'+naoCounter+' ipc.Instance_Number__c '+ ipc.Instance_Number__c);
                    }
                    if(NaoCount.length()==3 ){
                        if(naoCounter!=null && variabletoComparethelength.length()==3){
                            System.debug('eneter in nao counter 3');
                            ipc.Instance_Number__c= 'REC0000'+naoCounter;
                            naoCounter=Integer.valueOf(naoCounter)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                        }
                        else if(naoCounter!=null && variabletoComparethelength.length()==4){
                            System.debug('eneter in nao counter 3');
                            ipc.Instance_Number__c= 'REC000'+naoCounter;
                            naoCounter=Integer.valueOf(naoCounter)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                        }
                        else if(naoCounter!=null && variabletoComparethelength.length()==5){
                            System.debug('eneter in nao counter 3');
                            ipc.Instance_Number__c= 'REC00'+naoCounter;
                            naoCounter=Integer.valueOf(naoCounter)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                        }
                        else if(naoCounter==null){
                            NaoCountInt=Integer.valueOf(NaoCount)+1;
                                   if(NaoCountInt==1000){
                              ipc.Instance_Number__c= 'REC000'+NaoCountInt; 
                                naoCounter=Integer.valueOf(NaoCountInt)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                            }
                            else{
                            ipc.Instance_Number__c= 'REC0000'+NaoCountInt;
                            naoCounter=Integer.valueOf(NaoCountInt)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                            }
                        }
                    }
                    if(NaoCount.length()==4 ){
                        if(naoCounter!=null && variabletoComparethelength.length()==4){
                            System.debug('eneter in nao counter 4');
                            ipc.Instance_Number__c= 'REC000'+naoCounter;
                            naoCounter=Integer.valueOf(naoCounter)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                        }
                        else if(naoCounter!=null && variabletoComparethelength.length()==5){
                            System.debug('eneter in nao counter 3');
                            ipc.Instance_Number__c= 'REC00'+naoCounter;
                            naoCounter=Integer.valueOf(naoCounter)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                        }
                        else if(naoCounter==null){
                            NaoCountInt=Integer.valueOf(NaoCount)+1;
                             if(NaoCountInt==10000){
                              ipc.Instance_Number__c= 'REC00'+NaoCountInt; 
                                naoCounter=Integer.valueOf(NaoCountInt)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                            }
                            else{
                            ipc.Instance_Number__c= 'REC000'+NaoCountInt;
                            naoCounter=Integer.valueOf(NaoCountInt)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                            }
                        }
                    }
                    if(NaoCount.length()==5){
                        if(naoCounter!=null  && variabletoComparethelength.length()==5){
                            System.debug('eneter in nao counter');
                            ipc.Instance_Number__c= 'REC00'+naoCounter;
                            naoCounter=Integer.valueOf(naoCounter)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                        }
                        else if(naoCounter!=null && variabletoComparethelength.length()==6){
                            System.debug('eneter in nao counter 3');
                            ipc.Instance_Number__c= 'REC0'+naoCounter;
                            naoCounter=Integer.valueOf(naoCounter)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                        }
                        else if(naoCounter==null){
                            NaoCountInt=Integer.valueOf(NaoCount)+1;
                            if(NaoCountInt==100000){
                              ipc.Instance_Number__c= 'REC0'+NaoCountInt; 
                                naoCounter=Integer.valueOf(NaoCountInt)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                            }
                            else{
                            ipc.Instance_Number__c= 'REC00'+NaoCountInt;
                            naoCounter=Integer.valueOf(NaoCountInt)+1;
                            variabletoComparethelength =String.valueOf(naoCounter);
                            }
                        }
                    }
                    
                    
                    
                }
                InterListToUpdate.add(ipc);
                System.debug('Instance_Number__c'+ipc.Instance_Number__c);
                
                System.debug('ipc'+ipc);
                
                
            }
        }
            InterdictionProcessInstanceSetting__c ipi=new InterdictionProcessInstanceSetting__c();
            ipi.id=DataFromInterdictioncustom.id;
            
 if(simCounter == null && SimCount=='1'){
                ipi.Sim__c=Double.valueOf(SimCount);
                System.debug('ipi.Sim__c'+ipi.Sim__c);
            }
         if(simCounter!=null){
                ipi.Sim__c=Double.valueOf(simCounter)-1;
                System.debug('ipi.Sim__c 11 '+ ipi.Sim__c);
            }
         if(naoCounter == null && NaoCount=='1'){
                ipi.Nao__c=Double.valueOf(NaoCount);
                System.debug('ipi.NaoCount 1'+ipi.Nao__c);
            }
            if(naoCounter!=null){
                ipi.Nao__c=Double.valueOf(naoCounter)-1;
                System.debug('ipi.Nao__c'+ ipi.Nao__c);
            }
            System.debug('ipi'+ipi);
            CustomSettingListToUpdate.add(ipi);
            if(CustomSettingListToUpdate.size()>0 && !CustomSettingListToUpdate.isEmpty()){
            update CustomSettingListToUpdate;
            }
            if(InterListToUpdate.size()>0 && !InterListToUpdate.isEmpty()){
            update InterListToUpdate;
            }
            
        
    }
}