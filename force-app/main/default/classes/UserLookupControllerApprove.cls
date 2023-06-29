/*
Created on 30 Jan 2023
Created by Shubham Grazitti
 Apex class for lookupApproval lwc component
*/

public class UserLookupControllerApprove { 
    private final static Integer MAX_RESULTS = 5;
    
    @AuraEnabled(Cacheable=true)
    public static List<USer> search(String searchTerm, List<String> userIdList) {
        List<User> searchResults = new List<User>();
       String searchTerm1 = '%'+searchTerm+'%';
        system.debug('userIdList'+searchTerm);
        if(userIdList != null && !userIdList.isEmpty()) {
            searchResults = [Select Id, Name, Email, FullPhotoUrl from user WHERE Id IN :userIdList and isActive=true
                             LIMIT :MAX_RESULTS];
        } else {
            searchResults = [Select Id, Name, Email, FullPhotoUrl from user WHERE
                             Name Like: searchTerm1 and isActive=true LIMIT :MAX_RESULTS];
        }
        system.debug('curUsercurUser'+searchResults);
        
        return searchResults;
    }
}