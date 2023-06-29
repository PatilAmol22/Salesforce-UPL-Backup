@isTest
public class SideBarController_Test {
    static testmethod void getCategoriesTest(){
        
        
        List<SideBar_Parent__c> parentList = new List<SideBar_Parent__c>();
        SideBar_Parent__c parent = new SideBar_Parent__c();
        parent.AccessType__c = 'Public';
        parent.Category_Name__c ='Moderators_Admins';
        parent.CategoryId__c = 'moderator';
        parent.Name = 'Moderators_Admins';
        parent.Order__c = 5;
        parent.Type__c = 'Talend Category';
        parent.url__c = 'google.com';
      
        parentList.add(parent);
  SideBar_Parent__c parent2 = new SideBar_Parent__c();
        parent2.AccessType__c = 'Private';
        parent2.Category_Name__c ='Moderators_Admins';
        parent2.CategoryId__c = 'moderator';
        parent2.Name = 'Moderators_Admins';
        parent2.Order__c = 5;
        parent2.Type__c = 'Talend Category';
        parentList.add(parent2); 
        insert parentList;
        
        List<SideBar_Child__c> childList = new List<SideBar_Child__c>();
        for(Integer i = 1;i<=10;i++){
            if(i<5){
        SideBar_Child__c child = new SideBar_Child__c();
        child.AccessType__c = 'Public';
        child.Category_Name__c ='Moderators_Admins';
        child.CategoryId__c = 'tld_knowledge_base';
        child.Name = 'Architecture, Best Practices, and How-Tos';
        child.Order__c = 5;
        //child.Type_c = 'Record Type';
        child.Group_Name__c = 'Architecture';
        child.Label__c = 'Architecture';
        child.SideBar_Parent__c = parentList[0].id;
        childList.add(child);
           }else{
        SideBar_Child__c child1 = new SideBar_Child__c();
        child1.AccessType__c = 'Private';
        child1.Category_Name__c ='Moderators';
        child1.CategoryId__c = 'tld_knowledge_base';
        child1.Name = 'Architecture';
        child1.Order__c = 4;
        //child1.Type_c__c = 'Record Type';
        child1.Group_Name__c = 'Architecture';
        child1.Label__c = 'Architecture';
        child1.SideBar_Parent__c = parentList[1].id;
        //child1.User_Role__c = 'Talend External User/Guest';
        childList.add(child1);
            }
        }
        insert childList;
                
       
         Id p = [select id from profile where name='System Administrator'].id;
   
        
        User user = new User(alias = 'test123', email='test123@noemail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                        
                             timezonesidkey='America/Los_Angeles', username='test54321@noemail.com');
        
        insert user;
        profileBasedTab__c pb=new profileBasedTab__c();
        pb.Name='System Administrator';
        pb.Tabs__c='Home';
        insert pb;
     test.startTest();
        system.runAs(user){
                    SideBarController.getSideBarData();
        }
       test.stopTest();
     
    }

    static testmethod void getCategoriesTest1(){
        
List<SideBar_Parent__c> parentList = new List<SideBar_Parent__c>();
        SideBar_Parent__c parent2 = new SideBar_Parent__c();
        parent2.AccessType__c = 'Private';
        parent2.Category_Name__c ='Moderators_Admins';
        parent2.CategoryId__c = 'moderator';
        parent2.Name = 'Home';
        parent2.Order__c = 5;
       // parent2.Type__c = 'Talend Category';
       // parent2.User_Role__c = 'Talend External User/Guest';
        parentList.add(parent2); 
        SideBar_Parent__c parent12 = new SideBar_Parent__c();
        parent12.AccessType__c = 'Public';
        parent12.Category_Name__c ='Moderators_Admins';
        parent12.CategoryId__c = 'moderator';
        parent12.Name = 'Moderators_Admins';
        parent12.Order__c = 5;
        parent12.Type__c = 'Talend Category';
        insert parentList;
        
        List<SideBar_Child__c> childList = new List<SideBar_Child__c>();
        for(Integer i = 0;i<=10;i++){
            if(i<5){
        SideBar_Child__c child = new SideBar_Child__c();
        child.AccessType__c = 'Public';
        child.Category_Name__c ='Moderators & Admins';
        child.CategoryId__c = 'tld_knowledge_base';
        child.Name = 'Architecture, Best Practices, and How-Tos';
        child.Order__c = 5;
        //child.Type_c__c = 'Record Type';
        child.Group_Name__c = 'Architecture';
        child.Label__c = 'Architecture';
        child.SideBar_Parent__c = parentList[0].id;
       // child.User_Role__c = 'Talend External User/Guest';
        
        childList.add(child);
            }else{
        SideBar_Child__c child1 = new SideBar_Child__c();
        child1.AccessType__c = 'Private';
        child1.Category_Name__c ='Moderators';
        child1.CategoryId__c = 'tld_knowledge_base';
        child1.Name = 'Architecture';
        child1.Order__c = 4;
       // child1.Type_c__c = 'Record Type';
        child1.Group_Name__c = 'Architecture';
        child1.Label__c = 'Architecture';
        child1.SideBar_Parent__c = parentList[0].id;
        //child1.User_Role__c = 'Talend External User/Guest';
        childList.add(child1);
            }
        }
        insert childList;
                        Id p = [select id from profile where name='System Administrator'].id;

        User user = new User(alias = 'test123', email='tesdfst123@noemail.com',
                             emailencodingkey='UTF-8', lastname='Testsdfing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                            CategoryRole__c='Talend External User/Guest',
                             timezonesidkey='America/Los_Angeles', username='test543sdf21@noemail.com');
        
        insert user;
        profileBasedTab__c pb=new profileBasedTab__c();
        pb.Name='System Administrator';
        pb.Tabs__c='Home';
        insert pb;
        System.runAs(user){
        
        SideBarController.getSideBarData();
        }
       
    }
    
  
}