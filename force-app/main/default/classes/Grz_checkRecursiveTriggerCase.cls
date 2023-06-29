/* Developer Name : Sumit Kumar
	Purpose: To avoide recursion in Brazil Case Trigger
	Jira Ticket No. RITM0427885 Created on 03-11-2022
*/
public class Grz_checkRecursiveTriggerCase {
    
    private static boolean run = true;
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }

}