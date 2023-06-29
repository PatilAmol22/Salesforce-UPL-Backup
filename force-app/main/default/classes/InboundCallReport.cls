Public Class InboundCallReport{
    public List<AggregateResult> casetypewise {get;set;}
    public List<AggregateResult> casecropwise {get;set;}
    public Integer presentMonth {get;set;}
    public Integer presentyear {get;set;}
    public String selectedyear {get;set;}
    public String selectedmonth {get;set;}
    public List<typewrapper> typeList{get;set;}
    public List<cropwrapper> cropList{get;set;}
    
    public InboundCallReport(){
        casetypewise = new List<AggregateResult>();
        casecropwise = new List<AggregateResult>();
        typeList = new List<typewrapper>();
        cropList = new List<cropwrapper>();
        
        presentMonth = 0;
        presentyear = 0;
        selectedyear = '';
        selectedmonth = '';
        
        date myDate = date.today();
        presentMonth = myDate.month();
        presentyear = myDate.year();
        
        selectedyear = ApexPages.currentpage().getparameters().get('syear');
        selectedmonth = ApexPages.currentpage().getparameters().get('smonth');
        
        System.debug('selectedmonth_1   :'+selectedmonth);
        System.debug('selectedyear_1   :'+selectedyear);
        
        if(String.isNotBlank(selectedyear)&&String.isNotBlank(selectedmonth)){
            
        }
        else{
            selectedyear = String.ValueOf(presentyear);
            selectedmonth = String.ValueOf(presentMonth);
        }
        System.debug('presentMonth   :'+presentMonth);
        System.debug('presentyear   :'+presentyear);
        
        casedata();
    }
    
    public void casedata(){
        System.debug('selectedmonth   :'+selectedmonth);
        System.debug('selectedyear   :'+selectedyear);
        
        Integer selMonth = Integer.ValueOf(selectedmonth);
        Integer selYear = Integer.ValueOf(selectedyear);
        selectedmonth = String.ValueOf(selMonth);
        selectedyear = String.ValueOf(selYear);
        typeList = new List<typewrapper>();
        cropList = new List<cropwrapper>();
        
        System.debug('selectedmonth_2   :'+selectedmonth);
        System.debug('selectedyear_2   :'+selectedyear);
        System.debug('selMonth    :'+selMonth);
        System.debug('selYear      :'+selYear);
        
        casetypewise = [select  type type,Calendar_Month(CreatedDate),Calendar_YEAR(CreatedDate), count(id) numb from Case 
                        Where RecordType.DeveloperName =: 'UPL_General_Case' group by type, Calendar_Month(CreatedDate),Calendar_YEAR(CreatedDate) 
                        Having Calendar_Month(CreatedDate) =: selMonth And Calendar_YEAR(CreatedDate) =: selYear];
        for(AggregateResult aggObj: casetypewise){
            typewrapper temp = new typewrapper();
            temp.type = (String)aggObj.get('type');
            temp.count = (Integer)aggObj.get('numb');
            typeList.add(temp);
        }
                        
        casecropwise = [select Crop_pick__c crop,Calendar_Month(CreatedDate),Calendar_YEAR(CreatedDate), count(id) numb from Case 
                        Where RecordType.DeveloperName = 'UPL_General_Case' group by Crop_pick__c , Calendar_Month(CreatedDate),Calendar_YEAR(CreatedDate) 
                        Having Calendar_Month(CreatedDate) =: selMonth And Calendar_YEAR(CreatedDate) =: selYear];
        for(AggregateResult aggObj: casecropwise){
            cropwrapper temp = new cropwrapper();
            temp.crop = (String)aggObj.get('crop');
            temp.count = (Integer)aggObj.get('numb');
            cropList.add(temp);
        }
    }
    
    public List<SelectOption> getmonthsOptions() {
        List<SelectOption> months = new List<SelectOption>();
        months.add(new SelectOption('1','Jan'));
        months.add(new SelectOption('2','Feb'));
        months.add(new SelectOption('3','Mar'));
        months.add(new SelectOption('4','Apr'));
        months.add(new SelectOption('5','May'));
        months.add(new SelectOption('6','Jun'));
        months.add(new SelectOption('7','Jul'));
        months.add(new SelectOption('8','Aug'));
        months.add(new SelectOption('9','Sep'));
        months.add(new SelectOption('10','Oct'));
        months.add(new SelectOption('11','Nov'));
        months.add(new SelectOption('12','Dec'));

        return months;
    }
    
    public List<SelectOption> getyearsOptions() {
        List<SelectOption> years = new List<SelectOption>();
        for(Integer i=2000;i<=presentyear;i++){
            years.add(new SelectOption(String.valueOF(i),String.valueOF(i)));
        }
        
        return years;
    }
    
    public class typewrapper{
        public String type{get;set;}
        public Integer Count {get;set;}
        
        public typewrapper(){
            type ='';
            Count = 0;
        }
    }
    
    public class cropwrapper{
        public String crop{get;set;}
        public Integer Count {get;set;}
        
        public cropwrapper(){
            crop ='';
            Count = 0;
        }
    }
}