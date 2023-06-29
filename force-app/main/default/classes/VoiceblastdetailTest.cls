@isTest
public class VoiceblastdetailTest{
    static testmethod void casetest(){
        PageReference pageRef = Page.VoiceBlastDetailReport;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('selstate','[Maharashtra]');
        pageRef.getParameters().put('seldist','[Pune]');
        pageRef.getParameters().put('selzone','[pune zone]');
        pageRef.getParameters().put('selteri','[vakad]');
        pageRef.getParameters().put('selcrop','[both]');
        
        Voiceblastdetail vbd = new Voiceblastdetail();
    }
    
    static testmethod void casetest1(){
        PageReference pageRef = Page.VoiceBlastDetailReport;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('selstate','[]');
        pageRef.getParameters().put('seldist','[Pune]');
        pageRef.getParameters().put('selzone','[pune zone]');
        pageRef.getParameters().put('selteri','[vakad]');
        pageRef.getParameters().put('selcrop','[both]');
        
        Voiceblastdetail vbd = new Voiceblastdetail();
    }
    
    static testmethod void casetest2(){
        PageReference pageRef = Page.VoiceBlastDetailReport;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('selstate','[]');
        pageRef.getParameters().put('seldist','[]');
        pageRef.getParameters().put('selzone','[pune zone]');
        pageRef.getParameters().put('selteri','[vakad]');
        pageRef.getParameters().put('selcrop','[both]');
        
        Voiceblastdetail vbd = new Voiceblastdetail();
    }
    
    static testmethod void casetest3(){
        PageReference pageRef = Page.VoiceBlastDetailReport;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('selstate','[]');
        pageRef.getParameters().put('seldist','[]');
        pageRef.getParameters().put('selzone','[]');
        pageRef.getParameters().put('selteri','[vakad]');
        pageRef.getParameters().put('selcrop','[both]');
        
        Voiceblastdetail vbd = new Voiceblastdetail();
    }
    
    static testmethod void casetest4(){
        PageReference pageRef = Page.VoiceBlastDetailReport;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('selstate','[]');
        pageRef.getParameters().put('seldist','[]');
        pageRef.getParameters().put('selzone','[]');
        pageRef.getParameters().put('selteri','[]');
        pageRef.getParameters().put('selcrop','[both]');
        
        Voiceblastdetail vbd = new Voiceblastdetail();
    }
}