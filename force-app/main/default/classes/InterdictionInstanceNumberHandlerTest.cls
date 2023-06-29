@isTest
public class InterdictionInstanceNumberHandlerTest {
    @testSetup static void GetData() {
        
         InterdictionProcessInstanceSetting__c custInstance =new InterdictionProcessInstanceSetting__c();
      custInstance.Sim__c=0;
     custInstance.Nao__c=0;
        custInstance.Name='test record';
     insert custInstance;
     Interdiction_Process__c ip=new Interdiction_Process__c();
         
         ip.IS_AN_INTERDICTION__c='Sim';
         ip.TERM_NUMBER__c='123';
         ip.DUE_DATE__c=system.today();
         ip.PRIORITY__c='URGENTE';
         ip.REASON__c='EMBALAGEM';
         ip.CNPJ_CPF__c='test';
         ip.INSCRI_O_ESTADUAL__c='test';
         ip.CITY__c='Panchkula';
         ip.STATE__c='Haryana';
         ip.RAZ_O_SOCIAL__c='test';
         ip.Contact__c='1223445666';
         ip.AGENT_EMAIL__c='123@gmail.com';
             insert ip;
       
          Interdiction_Process__c ip1=new Interdiction_Process__c();
         
         ip1.IS_AN_INTERDICTION__c='Não';
         ip1.TERM_NUMBER__c='123';
         ip1.DUE_DATE__c=system.today();
         ip1.PRIORITY__c='URGENTE';
         ip1.REASON__c='EMBALAGEM';
         ip1.CNPJ_CPF__c='test';
         ip1.INSCRI_O_ESTADUAL__c='test';
         ip1.CITY__c='Panchkula';
         ip1.STATE__c='Haryana';
         ip1.RAZ_O_SOCIAL__c='test';
         ip1.Contact__c='1223445666';
         ip1.AGENT_EMAIL__c='123@gmail.com';
             insert ip1;
         Interdiction_Process__c ip2=new Interdiction_Process__c();
         
         ip2.IS_AN_INTERDICTION__c='Não';
         ip2.TERM_NUMBER__c='1234';
         ip2.DUE_DATE__c=system.today();
         ip2.PRIORITY__c='URGENTE';
         ip2.REASON__c='EMBALAGEM';
         ip2.CNPJ_CPF__c='test';
         ip2.INSCRI_O_ESTADUAL__c='test';
         ip2.CITY__c='Panchkula';
         ip2.STATE__c='Haryana';
         ip2.RAZ_O_SOCIAL__c='test1';
         ip2.Contact__c='1223445666';
         ip2.AGENT_EMAIL__c='123@gmail.com';
             insert ip2;
        Interdiction_Process__c ip3=new Interdiction_Process__c();
         
         ip3.IS_AN_INTERDICTION__c='Sim';
         ip3.TERM_NUMBER__c='123';
         ip3.DUE_DATE__c=system.today();
         ip3.PRIORITY__c='URGENTE';
         ip3.REASON__c='EMBALAGEM';
         ip3.CNPJ_CPF__c='test';
         ip3.INSCRI_O_ESTADUAL__c='test';
         ip3.CITY__c='Panchkula';
         ip3.STATE__c='Haryana';
         ip3.RAZ_O_SOCIAL__c='test';
         ip3.Contact__c='1223445666';
         ip3.AGENT_EMAIL__c='123@gmail.com';
             insert ip3;
        

}
    static testMethod void testMethod1() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        List<Interdiction_Process__c> interListFromSetup=[Select id from Interdiction_Process__c ];
         List<String> interList=new  List<String>();
        for(Interdiction_Process__c ip:interListFromSetup){
            interList.add(ip.id);
        }
        
                 
     Test.startTest();
        try{
            InterdictionInstanceNumberHandler.updateInstanceNumber(interList);
        }
        Catch(Exception e){
            System.debug('error on line number'+e.getLineNumber()+'due to'+e.getCause());
        }
     Test.stopTest();
         
    }
    static testMethod void testMethod2() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        DataFromInterdictioncustom.Sim__c=9;
        DataFromInterdictioncustom.Nao__c=9;
        update DataFromInterdictioncustom;
        List<Interdiction_Process__c> interListFromSetup=[Select id from Interdiction_Process__c ];
         List<String> interList=new  List<String>();
        for(Interdiction_Process__c ip:interListFromSetup){
            interList.add(ip.id);
        }
        
                 
     Test.startTest();
        try{
            InterdictionInstanceNumberHandler.updateInstanceNumber(interList);
        }
        Catch(Exception e){
            System.debug('error on line number'+e.getLineNumber()+'due to'+e.getCause());
        }
     Test.stopTest();
         
    }
      static testMethod void testMethod3() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        DataFromInterdictioncustom.Sim__c=99;
        DataFromInterdictioncustom.Nao__c=99;
        update DataFromInterdictioncustom;
        List<Interdiction_Process__c> interListFromSetup=[Select id from Interdiction_Process__c ];
         List<String> interList=new  List<String>();
        for(Interdiction_Process__c ip:interListFromSetup){
            interList.add(ip.id);
        }
        
                 
     Test.startTest();
        try{
            InterdictionInstanceNumberHandler.updateInstanceNumber(interList);
        }
        Catch(Exception e){
            System.debug('error on line number'+e.getLineNumber()+'due to'+e.getCause());
        }
     Test.stopTest();
         
    }
      static testMethod void testMethod4() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        DataFromInterdictioncustom.Sim__c=999;
        DataFromInterdictioncustom.Nao__c=999;
        update DataFromInterdictioncustom;
        List<Interdiction_Process__c> interListFromSetup=[Select id from Interdiction_Process__c ];
         List<String> interList=new  List<String>();
        for(Interdiction_Process__c ip:interListFromSetup){
            interList.add(ip.id);
        }
        
                 
     Test.startTest();
        try{
            InterdictionInstanceNumberHandler.updateInstanceNumber(interList);
        }
        Catch(Exception e){
            System.debug('error on line number'+e.getLineNumber()+'due to'+e.getCause());
        }
     Test.stopTest();
         
    }
      static testMethod void testMethod5() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        DataFromInterdictioncustom.Sim__c=9999;
        DataFromInterdictioncustom.Nao__c=9999;
        update DataFromInterdictioncustom;
        List<Interdiction_Process__c> interListFromSetup=[Select id from Interdiction_Process__c ];
         List<String> interList=new  List<String>();
        for(Interdiction_Process__c ip:interListFromSetup){
            interList.add(ip.id);
        }
        
                 
     Test.startTest();
        try{
            InterdictionInstanceNumberHandler.updateInstanceNumber(interList);
        }
        Catch(Exception e){
            System.debug('error on line number'+e.getLineNumber()+'due to'+e.getCause());
        }
     Test.stopTest();
         
    }
      static testMethod void testMethod6() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        DataFromInterdictioncustom.Sim__c=99999;
        DataFromInterdictioncustom.Nao__c=99999;
        update DataFromInterdictioncustom;
        List<Interdiction_Process__c> interListFromSetup=[Select id from Interdiction_Process__c ];
         List<String> interList=new  List<String>();
        for(Interdiction_Process__c ip:interListFromSetup){
            interList.add(ip.id);
        }
        
                 
     Test.startTest();
        try{
            InterdictionInstanceNumberHandler.updateInstanceNumber(interList);
        }
        Catch(Exception e){
            System.debug('error on line number'+e.getLineNumber()+'due to'+e.getCause());
        }
     Test.stopTest();
         
    }
     static testMethod void testMethod7() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        DataFromInterdictioncustom.Sim__c=9;
        DataFromInterdictioncustom.Nao__c=9;
        update DataFromInterdictioncustom;
        List<Interdiction_Process__c> interListToInsert= new  List<Interdiction_Process__c>();
         for(integer i=0;i<=100;i++){
            Interdiction_Process__c ip=new Interdiction_Process__c();
         
         ip.IS_AN_INTERDICTION__c='Sim';
         ip.TERM_NUMBER__c='123';
         ip.DUE_DATE__c=system.today();
         ip.PRIORITY__c='URGENTE';
         ip.REASON__c='EMBALAGEM';
         ip.CNPJ_CPF__c='test';
         ip.INSCRI_O_ESTADUAL__c='test';
         ip.CITY__c='Panchkula';
         ip.STATE__c='Haryana';
         ip.RAZ_O_SOCIAL__c='test';
         ip.Contact__c='1223445666';
         ip.AGENT_EMAIL__c='123@gmail.com';
            // insert ip; 
             interListToInsert.add(ip);
         }
         insert interListToInsert;
         List<String> interList=new  List<String>();
        for(Interdiction_Process__c ip:interListToInsert){
            interList.add(ip.id);
        }
        
                 
     Test.startTest();
        try{
            InterdictionInstanceNumberHandler.updateInstanceNumber(interList);
        }
        Catch(Exception e){
            System.debug('error on line number'+e.getLineNumber()+'due to'+e.getCause());
        }
     Test.stopTest();
         
    }
    static testMethod void testMethod8() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        DataFromInterdictioncustom.Sim__c=99;
        DataFromInterdictioncustom.Nao__c=99;
        update DataFromInterdictioncustom;
        List<Interdiction_Process__c> interListToInsert= new  List<Interdiction_Process__c>();
         for(integer i=0;i<=100;i++){
            Interdiction_Process__c ip=new Interdiction_Process__c();
         
         ip.IS_AN_INTERDICTION__c='Sim';
         ip.TERM_NUMBER__c='123';
         ip.DUE_DATE__c=system.today();
         ip.PRIORITY__c='URGENTE';
         ip.REASON__c='EMBALAGEM';
         ip.CNPJ_CPF__c='test';
         ip.INSCRI_O_ESTADUAL__c='test';
         ip.CITY__c='Panchkula';
         ip.STATE__c='Haryana';
         ip.RAZ_O_SOCIAL__c='test';
         ip.Contact__c='1223445666';
         ip.AGENT_EMAIL__c='123@gmail.com';
            // insert ip; 
             interListToInsert.add(ip);
         }
         insert interListToInsert;
         List<String> interList=new  List<String>();
        for(Interdiction_Process__c ip:interListToInsert){
            interList.add(ip.id);
        }
        
                 
     Test.startTest();
        try{
            InterdictionInstanceNumberHandler.updateInstanceNumber(interList);
        }
        Catch(Exception e){
            System.debug('error on line number'+e.getLineNumber()+'due to'+e.getCause());
        }
     Test.stopTest();
    }  
    
     static testMethod void testMethod9() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        DataFromInterdictioncustom.Sim__c=99998;
        DataFromInterdictioncustom.Nao__c=99998;
        update DataFromInterdictioncustom;
        List<Interdiction_Process__c> interListFromSetup=[Select id from Interdiction_Process__c];
         List<String> interList=new  List<String>();
        for(Interdiction_Process__c ip:interListFromSetup){
            interList.add(ip.id);
        }
        
                 
     Test.startTest();
        try{
            InterdictionInstanceNumberHandler.updateInstanceNumber(interList);
        }
        Catch(Exception e){
            System.debug('error on line number'+e.getLineNumber()+'due to'+e.getCause());
        }
     Test.stopTest();
         
    }
     static testMethod void testMethod10() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        DataFromInterdictioncustom.Sim__c=4444;
        DataFromInterdictioncustom.Nao__c=4444;
        update DataFromInterdictioncustom;
        List<Interdiction_Process__c> interListFromSetup=[Select id from Interdiction_Process__c];
         List<String> interList=new  List<String>();
        for(Interdiction_Process__c ip:interListFromSetup){
            interList.add(ip.id);
        }
        
                 
     Test.startTest();
        try{
            InterdictionInstanceNumberHandler.updateInstanceNumber(interList);
        }
        Catch(Exception e){
            System.debug('error on line number'+e.getLineNumber()+'due to'+e.getCause());
        }
     Test.stopTest();
         
    }
     static testMethod void testMethod11() {
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        DataFromInterdictioncustom.Sim__c=44444;
        DataFromInterdictioncustom.Nao__c=44444;
        update DataFromInterdictioncustom;
        List<Interdiction_Process__c> interListFromSetup=[Select id from Interdiction_Process__c];
         List<String> interList=new  List<String>();
        for(Interdiction_Process__c ip:interListFromSetup){
            interList.add(ip.id);
        }
        
                 
     Test.startTest();
        try{
            InterdictionInstanceNumberHandler.updateInstanceNumber(interList);
        }
        Catch(Exception e){
            System.debug('error on line number'+e.getLineNumber()+'due to'+e.getCause());
        }
     Test.stopTest();
         
    }
    }