trigger LiquidationApprovalTrigger on Liquidation_Approval_History__c (after update,after insert, before insert) {
   
    Trigger_Settings__c checktrigger = Trigger_Settings__c.getValues('LiquidationApprovalTrigger');
    if(checktrigger.isActive__c){
        /*
         //Old trigger logic starts here
        //we are giving the control of activating or deactivating a trigger to a customer setting
        //this way we can deactivate this trigger at anytime in PRODUCTION
        
        List<String> tids = new List<String>();
        Map<Id,Boolean> trcheck = new Map<Id,Boolean>();
        List<Territory_Distributor__c> tdlist = new List<Territory_Distributor__c>();
        if( trigger.new.size()>0 ){
            for( Liquidation_Approval_History__c var:trigger.new ){
                if( var.Territory__c!=null ){
                    tids.add( var.Territory__c );
                    //this is because we have to SOQL Territory_Distributor__c object out of the for loop
                }
            }
            if( tids.size()>0 ){
                List<Territory_Distributor__c> trlist = [SELECT Id,Liquidation_Submitted__c FROM Territory_Distributor__c WHERE Id IN:tids];
                if( trlist.size()>0 ){
                    for( Territory_Distributor__c temp:trlist ){
                        trcheck.put( temp.Id,temp.Liquidation_Submitted__c );
                        //we cannot fetch related object's field's checkbox data from trigger variable 
                        //we must SOQL the related object explicitely to fetch the values of "Liquidation_Submitted__c" field from Territory_Distributor__c object
                    }
                }
            }
            if( trcheck.size()>0 ){
                for( Liquidation_Approval_History__c var:trigger.new ){
                    if( trigger.isAfter && trigger.isUpdate ){
                        //this means approval instance is already present, TM is re submitting or managers are updating it
                        
                        if( ((Trigger.newMap.get(var.Id).Approval_Status__c == 'Approved')||(Trigger.newMap.get(var.Id).Approval_Status__c == 'Pending for Approval')) && trcheck.get(Trigger.oldMap.get(var.Id).Territory__c) == false ){
                            //incase if liquidation is deleted and TM is re-submitting again, approval instance will be UPDATED
                            
                            Territory_Distributor__c td = new Territory_Distributor__c();
                            td.Id = var.Territory__c;
                            td.Liquidation_Submitted__c = true;
                            tdlist.add(td);
                        }else if( Trigger.newMap.get(var.Id).Approval_Status__c == 'Rejected' && trcheck.get(Trigger.oldMap.get(var.Id).Territory__c) == true ){
                            //when managers are rejecting the records inserted by TM
                            
                            Territory_Distributor__c td = new Territory_Distributor__c();
                            td.Id = var.Territory__c;
                            td.Liquidation_Submitted__c = false;
                            tdlist.add(td);
                        }
                    }else if( trigger.isAfter && trigger.isInsert ){
                        //this will execute when a TM submits liquidations for the first time
                        //that time it will always be created with pending status
                        
                        if( var.Approval_Status__c == 'Pending for Approval' && trcheck.get(Trigger.newMap.get(var.Id).Territory__c) == false  ){
                            Territory_Distributor__c td = new Territory_Distributor__c();
                            td.Id = var.Territory__c;
                            td.Liquidation_Submitted__c = true;
                            tdlist.add(td);
                        }
                    }
                }
            }
        }
        if( tdlist.size()>0 ){
            UPDATE tdlist;
        }
        */
        //Old trigger logic ends here

        //New trigger logic starts here
        if(trigger.isAfter){
            //Handle after Update 
            if(trigger.isUpdate){
                //Call Handler class methods
                LiquidationApprovalTriggerHandler.sendMailOnLiquidationSubmission(trigger.new, trigger.oldMap);
                LiquidationApprovalTriggerHandler.sendMailOnLiquidationApproval(trigger.new, trigger.oldMap);
                LiquidationApprovalTriggerHandler.sendMailOnLiquidationRejection(trigger.new, trigger.oldMap);
                LiquidationApprovalTriggerHandler.sendMailOnLiquidationEditApproval(trigger.new, trigger.oldMap);
                LiquidationApprovalTriggerHandler.updateProductLiquidationSubmitted(trigger.new, trigger.oldMap);
            }
        }

        if(trigger.isBefore){
            //Handle before Insert 
            if(trigger.isInsert){
                //Call Handler class methods
                LiquidationApprovalTriggerHandler.updateMailIds(trigger.new);
            }
        }
    }
}