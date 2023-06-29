@istest
public with sharing class SchedulerAllAkcTestClass {
    static testmethod void Method1() {
        Test.startTest();
        CallRegistration_Scheduler   obj = new CallRegistration_Scheduler();
        obj.execute(null);
        Test.stopTest();
    }
static testmethod void Method2() {
        Test.startTest();
        FarmerRegistration_Scheduler obj = new FarmerRegistration_Scheduler();
        obj.execute(null);
        Test.stopTest();
    }
static testmethod void Method3() {
        Test.startTest();
        ThisYearTotalRegistration_Scheduler obj = new ThisYearTotalRegistration_Scheduler();
        obj.execute(null);
        Test.stopTest();
    }
static testmethod void Method4() {
        Test.startTest();
        ThisMonthTotalRegistration_Scheduler  obj = new ThisMonthTotalRegistration_Scheduler();
        obj.execute(null);
        Test.stopTest();
    }

static testmethod void Method5() {
        Test.startTest();
        TotalRegistration_Scheduler   obj = new TotalRegistration_Scheduler();
        obj.execute(null);
        Test.stopTest();
    }

static testmethod void Method6() {
        Test.startTest();
        CallType_Scheduler   obj = new CallType_Scheduler();
        obj.execute(null);
        Test.stopTest();
    }

static testmethod void Method7() {
        Test.startTest();
        ThisMonthProductRecomd_Scheduler obj = new ThisMonthProductRecomd_Scheduler();
        obj.execute(null);
        Test.stopTest();
    }
    static testmethod void Method8() {
        Test.startTest();
        ThisYearProductRecomd_Scheduler obj = new ThisYearProductRecomd_Scheduler();
        obj.execute(null);
        Test.stopTest();
    }

static testmethod void Method9() {
        Test.startTest();
        LastYearProductRecomd_Scheduler obj = new LastYearProductRecomd_Scheduler();
        obj.execute(null);
        Test.stopTest();
    }

static testmethod void Method10() {
        Test.startTest();
        CurrMonthLastYearProductRecomd_Scheduler obj = new CurrMonthLastYearProductRecomd_Scheduler();
        obj.execute(null);
        Test.stopTest();
    }


}