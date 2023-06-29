/*
* Name: LookupControllerCmp
* Created On: 17 March 2023
* Author: Kalpesh Chande (Kalpesh.Chande@skinternational.com)
* Description: Class is used for lookup component.
*/
public class LookupControllerCmp {
/*
* @Description  Fetching Sobject records.
* @Param        String obj 			-Name of the SObject to query
                String name 		-Name of the field to retrieve
                String filter 		-WHERE clause for the query
				String mergefield	-Optional parameter that specifies a field to merge with the lookup field
* @return       Returns a list of SObject records that match the query criteria.
*/
    @AuraEnabled(cacheable=true)
    public static List<Sobject> searchedLookupList(String obj,String name,String filter,String mergefield){
        System.debug('Name'+name);
        System.debug('obj is'+obj);
        System.debug('filter'+filter);
        Set<String> serachset = new Set<String>();
        List<SObject> sObjList=new List<SObject>();
        
        if(mergefield == null || String.isBlank(mergefield)){
            System.debug('select id,'+name+' from '+obj+' where '+filter);
            sObjList = Database.query('select id,'+name+' from '+obj+' where '+filter);
        }else{
            System.debug('select id,'+name+' from '+obj+' where '+mergefield+'and '+filter);
            sObjList = Database.query('select id,'+name+','+mergefield+' from '+obj+' where '+filter);
        }
        System.debug('size of list'+sObjList.size());
        return sObjList;
    }
}