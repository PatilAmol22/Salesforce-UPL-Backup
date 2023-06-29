/* Class Name:- ActivityIndiaSwalScheulerForOwner
* Description: This Class is used to schdeule the BatchCForIndiaSwalOwnerEventNotification .
* Created By: Shubham Bansal
* Created Date: 10 March 2023
* Created For India and Swal
*/

public class ActivityIndiaSwalScheulerForOwner implements Schedulable {
    public void execute(SchedulableContext sc) {
        BatchCForIndiaSwalOwnerEventNotification b = new BatchCForIndiaSwalOwnerEventNotification(); 
        database.executebatch(b);
        
        BatchClassForIndiaSwalEventNotification b1 = new BatchClassForIndiaSwalEventNotification(); 
        database.executebatch(b1);
    }
}