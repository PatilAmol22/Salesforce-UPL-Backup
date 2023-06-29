public class AccountEnhancedListView{
        public list<user> lstUser{get;set;}
        public Id userId;
        public string accId{get;set;}
        
        public AccountEnhancedListView(){
            userId = UserInfo.getUserId();
            lstUser = new list<user>();
            lstUser = [SELECT CompanyName, Id, LastName, Username, FirstName, MiddleName, AccountId FROM User WHERE AccountId != NULL AND Id =:userId];
            if(lstUser.size()>0){
                accId = lstUser[0].AccountId;
            } 
        }
        
       }