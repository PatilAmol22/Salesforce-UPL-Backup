public class NoMatchingRecord {
    String aniId ='';
    String dnisId ='';

    public NoMatchingRecord () {
         aniId = ApexPages.currentPage().getParameters().get('ANI');
         dnisId = ApexPages.currentPage().getParameters().get('DNIS');
         
         System.Debug('ANI : ========= ' + aniId);
         System.Debug('DNIS : ========= ' + dnisId );
         
         redirect();
        
    }
    
 
    public PageReference redirect(){
    
        System.Debug('Enter into Redirect Method');
        
         PageReference p = new PageReference('/001/e?RecordType=012280000001ePj&ent=Account');
            p.getParameters().put('PersonMobilePhone',aniId);
            
            System.Debug('Page Reference ======== ' + p);
            return p;
    }
}