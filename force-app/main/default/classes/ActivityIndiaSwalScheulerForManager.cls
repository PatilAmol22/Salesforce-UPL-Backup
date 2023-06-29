/* Class Name:- ActivityIndiaSwalScheulerForManager
* Description: This Class is used to schdeule the BatchClassForIndiaSwalEventNotification .
* Created By: Shubham Bansal
* Created Date: 10 March 2023
* Created For India and Swal
*/
public class ActivityIndiaSwalScheulerForManager implements Schedulable {
    public void execute(SchedulableContext sc) {
        BatchClassForIndiaSwalEventNotification b = new BatchClassForIndiaSwalEventNotification(); 
        database.executebatch(b);
    }
}