public without sharing class RebateTerms {
    public string Header { get; set; }
    public string Footer { get; set; }
    public string name { get; set; }
    public string formatter { get; set; }
    public Map<decimal, string> MapTerms { get; set; }
    public Map<string,map<String, string>> MapGoals { get; set; }
    public set<string> MapPCKeys { get; set; }
    public set<string> MapBRKeys { get; set; }
    public string Term1 { get; set; }
    public string Term2 { get; set; }
    public Rebate_Contract__c Contract { get; set; }
    public string totalAmountInString { get; set; }
    public list<approvalClass> approvalList{get;set;}// added this for RITM0439917  26-10-2022 GRZ(Javed Ahmed)
    
    
    public RebateTerms(){
        
        /*Decimal value = 1000.10;
String formattedValue = value.format();
String thousandSep = formattedValue.substring(1,2);
String decimalSep = formattedValue.substring(5,6);

formatter = '{0,number,#'+thousandSep+'###'+thousandSep+'###'+thousandSep+'###'+thousandSep+'###'+thousandSep+'##0'+decimalSep+'00}';
system.debug(formatter);*/
        MapTerms = new Map<decimal, string>();
        approvalList= new list<approvalClass>();
        String contractId = System.currentPageReference().getParameters().get('contractId');
        string CurrencySymbol;
        string description ;
        string RebateTermDate =System.Label.RebateTermDate; //add this for INC0435220 this ticket by GRZ(Javed Ahmed)
        system.debug('RebateTermDate'+RebateTermDate);
        //integer nextYear = (System.Today().year()-1)+1;  
        Contract = [select Name,Type_Code__c, CurrencyIsoCode , Total_Value__c, Distributor__r.name,Distributor__r.Tax_Number_1__c ,Distributor__r.BillingStreet, Distributor__r.BillingCity, Distributor__r.BillingState, Distributor__r.Customer_Region__c from Rebate_Contract__c where Name =:contractId ]; // Added Distributor__r.Customer_Region__c for RITM0452534 GRZ(Nikhil Verma)
        list<Rebate_Term__mdt> customMetadata = [SELECT id,DeveloperName,IncludeTable__c,Term_Number__c,Sort_Order__c,Type__c,Term_Description__c FROM Rebate_Term__mdt where contract_type_code__c=:Contract.Type_Code__c  order by Sort_Order__c asc];
        if(Contract.Type_Code__c == 'C'){
            name = 'COOPERATIVA';
        }
        else{
            name = 'REVENDA';
        }
        //String contractId = System.currentPageReference().getParameters().get('contractId');
        
        //string TypeCode;
        Contract = [select id,Type__c,Type_Code__c, Total_Value_LY__c   ,CurrencyIsoCode , Total_Value__c, Distributor__r.Tax_Number_1__c,Distributor__r.name,Distributor__r.BillingStreet, Distributor__r.BillingCity, Distributor__r.BillingState, Distributor__r.Customer_Region__c from Rebate_Contract__c where Name =:contractId ]; // Added Distributor__r.Customer_Region__c for RITM0452534 GRZ(Nikhil Verma)
        //TypeCode = Contract.Type_Code__c;
        string termNumber;
        for(Rebate_Term__mdt RT: customMetadata){
            if(RT.Term_Number__c!=null){
                termNumber=RT.Term_Number__c+'.';
            }else{
                termNumber='';
            }
            if(RT.Type__c == 'Header'){
                
                if(RT.Term_Description__c.contains('#YEAR')){
                    
                    Header = RT.Term_Description__c.replace('#YEAR',RebateTermDate); // add this for INC0435220 this ticket by GRZ(Javed Ahmed)
                }
                else{
                    Header = RT.Term_Description__c; 
                }
            }
            if(RT.Type__c == 'Footer')
                footer = RT.Term_Description__c; 
            //added this for RITM0439917  01-11-2022 GRZ(Javed Ahmed)
            if(Contract.Type__c == 'Cooper Up'){
                description = RT.Term_Description__c;
                if(RT.Term_Description__c.contains('#YEAR')){
                    description = description.replace('#YEAR', RebateTermDate); // add this  for INC0435220 this ticket by GRZ(Javed Ahmed)
                    RT.Term_Description__c = description;
                    //added this for RITM0439917  26-10-2022 GRZ(Javed Ahmed)
                    MapTerms.put(RT.Sort_Order__c, termNumber + ' ' + RT.Term_Description__c.replaceAll('</b>','').replaceAll('<br/>','').replaceAll('<b>','').replaceAll('&nbsp;','')); //+string.valueof(RT.Sort_Order__c)
                }
                
                if(RT.Term_Description__c.contains('#CURRENCYINWORDS')){
                    if(Contract.Total_Value__c != null){
                        //String s = String.valueOf(Contract.Total_Value__c);
                        //INC0414706-Modified by Nandhini to extract 2 decimal points from Total_Value__c::Added setScale(2)
                        String s = String.valueOf(Contract.Total_Value__c.setScale(2));
                        String afterDecimal = s.substringAfter('.'); 
                        if(afterDecimal != null && afterDecimal != '00'){
                            description = description.replace('#CURRENCYINWORDS', NumberToWord.portuguese_number_word(integer.valueOf(Contract.Total_Value__c)) + ' Reais e '+ NumberToWord.portuguese_number_word(integer.valueOf(afterDecimal)) + ' Centavo ');      
                        }
                        else{
                            description = description.replace('#CURRENCYINWORDS', NumberToWord.portuguese_number_word(integer.valueOf(Contract.Total_Value__c)) + ' Reais');
                        }
                        RT.Term_Description__c = description;
                        //added this for RITM0439917  26-10-2022 GRZ(Javed Ahmed)
                        MapTerms.put(RT.Sort_Order__c,termNumber+ ' ' + RT.Term_Description__c.replaceAll('</b>','').replaceAll('<br/>','').replaceAll('<b>','').replaceAll('&nbsp;','')); //+string.valueof(RT.Sort_Order__c)    
                    }
                }
                // added this for RITM0439917  01-11-2022 GRZ(Javed Ahmed)
                if(RT.Term_Description__c.contains('PRODUTO ESCOADO (Produto aplicado na lavoura) ')){
                    if(Contract.Total_Value_LY__c!= null){
                        description = description.replace('Rebate.Actual_Value_LY__c',currencyBrazil(integer.valueOf(Contract.Total_Value_LY__c))).replace('FULL NUMERAL OF Actual_Value_LY__c',NumberToWord.portuguese_number_word(integer.valueOf(Contract.Total_Value_LY__c)));
                        RT.Term_Description__c = description;
                        MapTerms.put(RT.Sort_Order__c,termNumber+ ' ' + RT.Term_Description__c.replaceAll('</b>','').replaceAll('<br/>','').replaceAll('<b>','').replaceAll('&nbsp;','').replaceAll('','')); //+string.valueof(RT.Sort_Order__c)    
                    }
                    else{
                        description = description.replace('FULL NUMERAL OF Actual_Value_LY__c', '0').replace('Rebate.Actual_Value_LY__c', '0');      
                        RT.Term_Description__c = description;
                        MapTerms.put(RT.Sort_Order__c,termNumber+ ' ' + RT.Term_Description__c.replaceAll('</b>','').replaceAll('<br/>','').replaceAll('<b>','').replaceAll('&nbsp;',''));
                    }                     
                }
                //added this for RITM0439917  01-11-2022 GRZ(Javed Ahmed)
                if(RT.Term_Description__c.contains('As metas em volume(Kg/L) por produto estão descritas abaixo:')){
                    description = description.replace(':', '.');
                    RT.Term_Description__c = description;
                    MapTerms.put(RT.Sort_Order__c,termNumber+ ' ' + RT.Term_Description__c.replaceAll('</b>','').replaceAll('<br/>','').replaceAll('<b>','').replaceAll('&nbsp;','')); //+string.valueof(RT.Sort_Order__c)    
                }
                //added this for RITM0439917  01-11-2022 GRZ(Javed Ahmed)
                if(RT.Term_Description__c.contains('Revenda')){
                    description = description.replaceAll('Revenda', 'Cooperativa');
                    RT.Term_Description__c = description;
                    MapTerms.put(RT.Sort_Order__c,termNumber+ ' ' + RT.Term_Description__c.replaceAll('</b>','').replaceAll('<br/>','').replaceAll('<b>','').replaceAll('&nbsp;','')); //+string.valueof(RT.Sort_Order__c)    
                }
                
                if(RT.Term_Description__c.contains('#CURRENCY')){
                    if(Contract.CurrencyIsoCode == 'BRL'){
                        CurrencySymbol = 'R$';
                    }
                    description = description.replace('#CURRENCY', CurrencySymbol);
                    // description = description.replace('#CURRENCYINWORDS', NumberToWord.portuguese_number_word(integer.valueOf(Contract.Total_Value__c)));
                    //added this for RITM0439917  26-10-2022 GRZ(Javed Ahmed)
                    MapTerms.put(RT.Sort_Order__c,  termNumber+ ' ' +RT.Term_Description__c.replaceAll('</b>','').replaceAll('<br/>','').replaceAll('<b>','').replaceAll('&nbsp;','')); //+string.valueof(RT.Sort_Order__c)
                }   
                
                
                if(RT.Term_Description__c.contains('#TOTAL')){
                    if(Contract.Total_Value__c != null){
                        description = description.replace('#TOTAL', currencyBrazil(Contract.Total_Value__c));
                        RT.Term_Description__c = description;
                        //added this for RITM0439917  26-10-2022 GRZ(Javed Ahmed)
                        MapTerms.put(RT.Sort_Order__c, termNumber+ ' ' + RT.Term_Description__c.replaceAll('</b>','').replaceAll('<br/>','').replaceAll('<b>','').replaceAll('&nbsp;','')); //+string.valueof(RT.Sort_Order__c)
                    }
                    else{
                        description =  description.replace('#TOTAL', '0.00');
                        RT.Term_Description__c = description;
                        //added this for RITM0439917  26-10-2022 GRZ(Javed Ahmed)
                        MapTerms.put(RT.Sort_Order__c,termNumber+ ' ' +RT.Term_Description__c.replaceAll('</b>','').replaceAll('<br/>','').replaceAll('<b>','').replaceAll('&nbsp;',''));   
                    }
                    
                }
                
                else{
                    RT.Term_Description__c = description;
                    //added this for RITM0439917  26-10-2022 GRZ(Javed Ahmed)
                    MapTerms.put(RT.Sort_Order__c,termNumber+ ' ' + RT.Term_Description__c.replaceAll('</b>','').replaceAll('<br/>','').replaceAll('<b>','').replaceAll('&nbsp;','')); //RT.Term_Description__c
                }
            }
            
            if(RT.Type__c == 'Term'){
                description = RT.Term_Description__c;
                system.debug(RT.Sort_Order__c+Header);
                if(RT.Term_Description__c.contains('#YEAR')){
                    description = description.replace('#YEAR', RebateTermDate); // add this  for INC0435220 this ticket by GRZ(Javed Ahmed)
                    RT.Term_Description__c = description;
                    //added this for RITM0439917  26-10-2022 GRZ(Javed Ahmed)
                    MapTerms.put(RT.Sort_Order__c, termNumber + ' ' + RT.Term_Description__c.replaceAll('</b>','').replaceAll('<br/>','').replaceAll('<b>','').replaceAll('&nbsp;','')); //+string.valueof(RT.Sort_Order__c)
                }
                
                if(RT.Term_Description__c.contains('#CURRENCYINWORDS')){
                    if(Contract.Total_Value__c != null){
                    //Change by Grazitti(Aashima) for INC0410433
                        String s = String.valueOf(Contract.Total_Value__c.setScale(2));
                        String afterDecimal = s.substringAfter('.'); 
                        if(afterDecimal != null && afterDecimal != '00'){
                            description = description.replace('#CURRENCYINWORDS', NumberToWord.portuguese_number_word(integer.valueOf(Contract.Total_Value__c)) + ' Reais e '+ NumberToWord.portuguese_number_word(integer.valueOf(afterDecimal)) + ' Centavo ');      
                        }
                        else{
                            description = description.replace('#CURRENCYINWORDS', NumberToWord.portuguese_number_word(integer.valueOf(Contract.Total_Value__c)) + ' Reais');
                        }
                        RT.Term_Description__c = description;
                        //added this for RITM0439917  26-10-2022 GRZ(Javed Ahmed)
                        MapTerms.put(RT.Sort_Order__c,termNumber+ ' ' + RT.Term_Description__c.replaceAll('</b>','').replaceAll('<br/>','').replaceAll('<b>','').replaceAll('&nbsp;','')); //+string.valueof(RT.Sort_Order__c)    
                    }
                    
                    
                }
                //added this for RITM0439917  26-10-2022 GRZ(Javed Ahmed)
                if(RT.Term_Description__c.contains('PRODUTO ESCOADO (Produto aplicado na lavoura) ')){
                    if(Contract.Total_Value_LY__c!= null){
                        description = description.replace('Rebate.Actual_Value_LY__c',currencyBrazil(integer.valueOf(Contract.Total_Value_LY__c))).replace('FULL NUMERAL OF Actual_Value_LY__c',NumberToWord.portuguese_number_word(integer.valueOf(Contract.Total_Value_LY__c)));
                        RT.Term_Description__c = description;
                        MapTerms.put(RT.Sort_Order__c,termNumber+ ' ' + RT.Term_Description__c.replaceAll('</b>','').replaceAll('<br/>','').replaceAll('<b>','').replaceAll('&nbsp;','').replaceAll('','')); //+string.valueof(RT.Sort_Order__c)    
                    }
                    else{
                        description = description.replace('FULL NUMERAL OF Actual_Value_LY__c', '0').replace('Rebate.Actual_Value_LY__c', '0');      
                        RT.Term_Description__c = description;
                        MapTerms.put(RT.Sort_Order__c,termNumber+ ' ' + RT.Term_Description__c.replaceAll('</b>','').replaceAll('<br/>','').replaceAll('<b>','').replaceAll('&nbsp;',''));
                    }                     
                }
                
                if(RT.Term_Description__c.contains('As metas em volume(Kg/L) por produto estão descritas abaixo:')){
                    description = description.replace(':', '.');
                    RT.Term_Description__c = description;
                    MapTerms.put(RT.Sort_Order__c,termNumber+ ' ' + RT.Term_Description__c.replaceAll('</b>','').replaceAll('<br/>','').replaceAll('<b>','').replaceAll('&nbsp;','')); //+string.valueof(RT.Sort_Order__c)    
                }
                
                if(RT.Term_Description__c.contains('#CURRENCY')){
                    if(Contract.CurrencyIsoCode == 'BRL'){
                        CurrencySymbol = 'R$';
                    }
                    description = description.replace('#CURRENCY', CurrencySymbol);
                    // description = description.replace('#CURRENCYINWORDS', NumberToWord.portuguese_number_word(integer.valueOf(Contract.Total_Value__c)));
                    //added this for RITM0439917  26-10-2022 GRZ(Javed Ahmed)
                    MapTerms.put(RT.Sort_Order__c,  termNumber+ ' ' +RT.Term_Description__c.replaceAll('</b>','').replaceAll('<br/>','').replaceAll('<b>','').replaceAll('&nbsp;','')); //+string.valueof(RT.Sort_Order__c)
                }   
                
                
                if(RT.Term_Description__c.contains('#TOTAL')){
                    if(Contract.Total_Value__c != null){
                        description = description.replace('#TOTAL', currencyBrazil(Contract.Total_Value__c));
                        
                        RT.Term_Description__c = description;
                        //added this for RITM0439917  26-10-2022 GRZ(Javed Ahmed)
                        MapTerms.put(RT.Sort_Order__c, termNumber+ ' ' + RT.Term_Description__c.replaceAll('</b>','').replaceAll('<br/>','').replaceAll('<b>','').replaceAll('&nbsp;','')); //+string.valueof(RT.Sort_Order__c)
                    }
                    else{
                        description =  description.replace('#TOTAL', '0.00');
                        RT.Term_Description__c = description;
                        //added this for RITM0439917  26-10-2022 GRZ(Javed Ahmed)
                        MapTerms.put(RT.Sort_Order__c,termNumber+ ' ' +RT.Term_Description__c.replaceAll('</b>','').replaceAll('<br/>','').replaceAll('<b>','').replaceAll('&nbsp;',''));   
                    }
                    
                }
                
                else{
                    RT.Term_Description__c = description;
                    //added this for RITM0439917  26-10-2022 GRZ(Javed Ahmed)
                    MapTerms.put(RT.Sort_Order__c,termNumber+ ' ' + RT.Term_Description__c.replaceAll('</b>','').replaceAll('<br/>','').replaceAll('<b>','').replaceAll('&nbsp;','')); //RT.Term_Description__c
                }
            }
        }
        
        totalAmountInString = NumberToWord.portuguese_number_word(integer.valueOf(Contract.Total_Value__c));
        system.debug('totalAmountInString'+totalAmountInString);
        MapGoals = new map<string,map<string,string>>();
        //Contract__r.name =:contractId
        /*
list<Rebate_Goal_Brand__c> rebBrand = new list<Rebate_Goal_Brand__c>([SELECT Actual_Value__c,Actual_Volume__c,Attainment_Volume__c,Brand_Name__c,Product_Category__c ,Name,Net_Value__c,Net_Volume__c,Returns_Value__c,Returns_Volume__c,Total_Actual_Value__c,Total_Returns_Value__c,Value_LY__c,Value__c,Volume_LY__c,Volume__c FROM Rebate_Goal_Brand__c where Contract__r.name =:contractId and Contract__r.Sales_Org__r.Sales_Org_Code__c='5191' and Product_Category__c != 'Outros']);
//list<Rebate_Goal_SKU__c> rebBrand = new list<Rebate_Goal_SKU__c>([SELECT Brand_Name__c,Product_Category__c ,Name,Volume_LY__c,Volume__c FROM Rebate_Goal_SKU__c where Contract__r.name =:contractId and Contract__r.Sales_Org__r.Sales_Org_Code__c='5191' and Product_Category__c != 'Outros']);

system.debug('**Rebate_Goal - '+rebBrand);
for(Rebate_Goal_Brand__c rB: rebBrand)
{
if(!MapGoals.containsKey(rb.Product_Category__c) ){
MapGoals.put(rb.Product_Category__c, new map<string,string>());
}
MapGoals.get(rb.Product_Category__c).put(rb.Brand_Name__c,string.valueOf(rb.Volume__c));//.format()

}

MapPCKeys = new set<string>();
MapPCKeys = MapGoals.keySet(); */
        
        //Commented above code and added below code for RITM0313255
        
        string ids;
        Decimal total;
        string totalString;
        string prodCategory;
        
        List<AggregateResult> sumList =  [select sum(Volume__c)tot,SKU__r.Brand_Name__c,Product_Category__c from Rebate_Goal_SKU__c where SKU__r.Brand_Name__c!=null and Volume__c!=null and Product_Category__c!=null and Contract__r.name = :contractId group by SKU__r.Brand_Name__c,Product_Category__c];
        system.debug('**sumList - '+sumList);
        
        Map<string,Decimal> mapTot=new Map<string,Decimal>();
        if(sumList.size()>0){
            for(AggregateResult agr :sumList){
                ids = (string)agr.get('Brand_Name__c');
                total = (Decimal)agr.get('tot');
                totalString =  currencyBrazil(total);//added this for RITM0439917  04-10-2022 GRZ(Javed Ahmed)
                mapTot.put(ids,total);
                
                if(!MapGoals.containsKey((string)agr.get('Product_Category__c')) ){
                    MapGoals.put((string)agr.get('Product_Category__c'), new map<string,string>());
                }
                MapGoals.get((string)agr.get('Product_Category__c')).put(ids,totalString);
            }
        }
        //system.debug('**mapTot - '+mapTot);
        //system.debug('**MapGoals - '+MapGoals);
        
        // start ************added this for RITM0439917  26-10-2022 GRZ(Javed Ahmed)**********
        list<approvalClass> listApproval= new list<approvalClass>();
        List<ProcessInstance> processList = [SELECT Id,ProcessDefinition.Name,(SELECT Id, StepStatus, Comments,Actor.Name,Actor.Profile.Name, CreatedDate 
                                                                               FROM Steps  where StepStatus!='Started'
                                                                               ORDER BY CreatedDate ASC
                                                                              ) FROM ProcessInstance WHERE TargetObjectId =:Contract.Id ORDER BY CreatedDate DESC LIMIT 1];
        for(ProcessInstance pI : processList){
            for(ProcessInstanceStep st : pI.Steps){
                    approvalClass ap = new approvalClass();
                    ap.approverName = st.Actor.Name;
                    ap.profileName= st.Actor.Profile.Name;
                    ap.approvedDate =st.CreatedDate.format('dd-MM-YY HH:MM:SS');  
                    listApproval.add(ap);               
            }
        }
        approvalList = listApproval;
        
    }
    
    public class approvalClass{
        public string approverName { get; set; }
        public string profileName { get; set; }
        public string approvedDate  { get; set; }
    }
    public static String currencyBrazil(Decimal inrValue){
        List<String> args = new String[]{'0','number','#,###.0'};
            String parseVal = String.format(inrValue.format(), args);
        return parseVal;
    }
    // End ************added this for RITM0439917  26-10-2022 GRZ(Javed Ahmed)**********
}