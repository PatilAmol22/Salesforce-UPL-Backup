/*
* Name: KYCScheduledDispatcher
* Created On: 28 May 2019 
* Author: Azhar Shaikh
* Description: Class is used for executing the KYCSchedulerDispatcherHandler class using interface IScheduleDispached.
*/
global class KYCScheduledDispatcher Implements Schedulable{

    public Interface IScheduleDispached{
        void execute(SchedulableContext sc);
    }

    global  void execute(SchedulableContext sc){
        //KYCSchedulerDispatcherHandler kYCSchedulerDispatcherHandlerObj=new KYCSchedulerDispatcherHandler();
        Type targetType = Type.forName('KYCSchedulerDispatcherHandler');
        if(targetType != null){
            IScheduleDispached obj = (IScheduleDispached)targetType.newInstance();
            obj.execute(sc);
        }
    }


}