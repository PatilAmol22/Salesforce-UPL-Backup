public class VFPageToOpenCompcont {

    public String selectedId {get;set;}
    public Integer selectedSize {get;set;}
    public Boolean isSimulated {get;set;}
    public String salesOrgCode {get;set;}
    
    public VFPageToOpenCompcont(Apexpages.Standardsetcontroller cont){
        isSimulated = false;
        
        List<Sales_Order__c> selectedSO = cont.getSelected();
        System.debug('selectedSO'+selectedSO);
        
        String recordId = ApexPages.currentpage().getparameters().get('recordId');    
        
        selectedSize = selectedSO.size();
        System.debug('selectedSize'+selectedSize);
        
        if(selectedSO.size() != 0 || String.isNotBlank(recordId)){
            if(String.isNotBlank(recordId)){
                selectedId = recordId;
            }
            else{
                selectedId = selectedSO[0].id;
            }
            Sales_Order__c so = [Select Id, SalesOrgCode__c, RecordType.Name From Sales_Order__c Where Id =: selectedId];
            salesOrgCode = so.SalesOrgCode__c;
            System.debug('SalesOrgCode'+SalesOrgCode);
            
            if(so.RecordType.Name=='Simulation'){
                isSimulated = true;
            }
        }
        else{
            salesOrgCode='0000';
            System.debug('SalesOrgCode'+SalesOrgCode);
        }
        
    }
}