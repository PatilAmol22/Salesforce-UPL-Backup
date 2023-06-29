Public Class AKCReportdetails{
    public Integer presentMonth {get;set;}
    public Integer presentyear {get;set;}
    public Integer nextyear {get;set;}
    public Integer startFY {get;set;}
    public Integer EndFY {get;set;}
    public Integer monthsinFY {get;set;}
    public Integer FiscalYearStartMonth {get;set;}
    public Set<Integer> monthSet{get;set;}
    public String monthJSON {get;set;}
    public AKCReportdetails(){
         presentMonth = 0;
         presentyear = 0;
         nextyear = 0;
         monthsinFY = 0;
         startFY = 0;
         EndFY = 0;
         monthsinFY = 0;
         monthJSON = '';
         monthSet = new Set<Integer>();
         
         FiscalYearStartMonth = [select FiscalYearStartMonth from Organization 
                                            where id=:Userinfo.getOrganizationId()].FiscalYearStartMonth;
         Date Today_date = date.today();
         presentMonth = Today_date.month();
         presentyear = Today_date.year();
         
        if(presentMonth < FiscalYearStartMonth){
            nextyear = presentyear-1;
            startFY = presentyear-1;
            EndFY = presentyear;
            monthsinFY = (12-FiscalYearStartMonth)+presentMonth+1;
        }
        else{
            nextyear = presentyear+1;
            startFY = presentyear;
            EndFY = presentyear+1;
            if(presentMonth == FiscalYearStartMonth){
                monthsinFY = 1;
            }else{
                monthsinFY = (presentMonth - FiscalYearStartMonth)+1;
            }
        }
         
         for(Integer i=0;i<=monthsinFY;i++){
             Integer temp = FiscalYearStartMonth + i;
             if(temp>12){
                 temp = temp - 12;
             }
             monthSet.add(temp);
         }
         monthJSON = JSON.serialize(monthSet);        
    }
}