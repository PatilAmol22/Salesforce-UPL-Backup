public class VFSimulationController {
    
    public Boolean allowSimulation {get;set;}
    
    public VFSimulationController(Apexpages.Standardsetcontroller cont){
        //Initialized allowSimulation to false 
        allowSimulation = false;
        
        //Get current loggedIn user Id
        String loggedInUser = UserInfo.getUserId();
        
        //Get country & profile of loggedin user
        List<User> userList = [SELECT ID, Country, Profile.Name FROM User WHERE ID=:loggedInUser];
        
        //Allow Simulation if User belongs to Brazil or Profile = System Administrator
        if(userList[0].Profile.Name=='System Administrator' || userList[0].Profile.Name=='Regional Manager/Sales Reps Spain- Old' || userList[0].Profile.Name=='Regional Manager/Sales Reps Spain'){ // add Regional Manager/Sales Reps Spain/Regional Manager/Sales Reps Spain- Old profile for RITM0456737 16-11-2022 GRZ(Javed Ahmed)
            allowSimulation = true;
        }
        else{
            if(userList[0].country=='Brazil'){
                
               /* List<Territory_Distributor__c> tdList = [SELECT ID, Name, TerritoryManager__c
                                                         FROM Territory_Distributor__c 
                                                         WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                                                         AND TerritoryManagerActive__c = True
                                                         AND TerritoryManager__c=: loggedInUser];
                */
                //Check if user is SalesPerson from KEDE tdList.isEmpty() &&   && userList[0].Profile.Name=='Brazil Sales Person' && userList[0].Profile.Name=='Brazil Sales District Manager'
                
                if(userList[0].Profile.Name!='Brazil System Administrator' && userList[0].Profile.Name!='Brazil Customer Service Manager'  && userList[0].Profile.Name!='Brazil Customer Service User' && (userList[0].Profile.Name=='Brazil Sales Person' || userList[0].Profile.Name=='Brazil Sales District Manager'|| userList[0].Profile.Name=='Brazil Sales Office Manager' || userList[0].Profile.Name=='Brazil Barter Manager') ){
                    //if not then allow simulation 
                    //Sales Office Manager profile added by PM for SCTASK0613558 on 20-10-2021,deployed on 15-11-2021
                    //RITM0331872 : Barter Manager Admin profile added for Simulation Order on Vivek:10-March-22.
                    allowSimulation = true;
                }
            }
        }
    }
}