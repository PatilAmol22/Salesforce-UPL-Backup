trigger AutoNumberGenerate ON Customer_Visit__c (before insert) {

If(trigger.isBefore){
    If(Trigger.isInsert){
      CustomerVisitTrigerHandler.beforeInsertProduct(Trigger.New);
     }
   }

   
 }