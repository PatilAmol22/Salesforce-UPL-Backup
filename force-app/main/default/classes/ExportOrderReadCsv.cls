Public class ExportOrderReadCsv{

    public  map<string,Integer> mapMonth ;
    public  SplitString splitObj;
    
    public ExportOrderReadCsv(){
     splitObj = new SplitString();
     mapMonth = new map<string,Integer>();
     mapMonth.put('JAN',1);
     mapMonth.put('FEB',2);
     mapMonth.put('MAR',3);
     mapMonth.put('APR',4);
     mapMonth.put('MAY',5);
     mapMonth.put('JUN',6);
     mapMonth.put('JUL',7);
     mapMonth.put('AUG',8);
     mapMonth.put('SEP',9);
     mapMonth.put('OCT',10);
     mapMonth.put('NOV',11);
     mapMonth.put('DEC',12);
    }
    
    public void exportOrderOperation(String csvData, String businessDashboardID, List<String> errorCSVList,List<String> successCSVList){
                          
               List<Export_Order__c> businessDataList = new List<Export_Order__c>();
               List<Export_Order__c> exportErrList = new List<Export_Order__c>();
               string row='';
               list<list<string>> csvdataParse = new List<List<String>>();     
              
         
               csvdataParse = parseCSV(csvData , True); 
               for(list<string> csvLineItem : csvdataParse){
                   try{
                           system.debug('csvLineItem Size>>--->'+csvLineItem.size());
                           system.debug('csvLineItem>>--->'+csvLineItem);
                       if(csvLineItem.size() == 65){                          
                           Export_Order__c expOrdObj = new Export_Order__c(); 
                           system.debug('Ship to Party>>--->'+csvLineItem[0]);
                           if(csvLineItem[1].Contains('U')){
                           csvLineItem[1] = csvLineItem[1].replace('U','').replaceAll('\\"','');
                           }
                           
                           if(csvLineItem[1].length() <= 10 &&  String.isNotBlank(csvLineItem[1])){
                            Integer reqSize = 0;
                            reqSize = 10 -   csvLineItem[1].length();
                            for(integer i=0; i<reqSize ;i++){
                              csvLineItem[1] = '0'+csvLineItem[1]; 
                            }
                           // System.debug('Shipping Loc Datail>>--->'+csvLineItem[0]);
                           // System.debug('Shipping Loc After appends>>--->'+csvLineItem[1]);
                           }
                           if(csvLineItem[5].Contains('U') ){
                           csvLineItem[5] = csvLineItem[5].replace('U','').replaceAll('\\"','');
                             }
                           if(csvLineItem[5].length() < 10 &&  String.isNotBlank(csvLineItem[5])){
                            Integer reqSize = 0;
                            reqSize = 10 -   csvLineItem[5].length();
                            for(integer i=0; i<reqSize ;i++){
                              csvLineItem[5] = '0'+csvLineItem[5]; 
                            }
                           
                           //Shipping_Location__c shipLocRef = new Shipping_Location__c(Combination_Key__c = csvLineItem[1]+''+csvLineItem[5]); 
                          // system.debug('Shipping Location >>--->'+shipLocRef);
                           //expOrdObj.Ship_To_Party__r = shipLocRef; 
                           expOrdObj.Shipping_Location__c = csvLineItem[0].replaceAll('\\"','');
                          // System.debug('Ship to Country>>--->'+csvLineItem[2]);
                           expOrdObj.Country_Name__c = csvLineItem[2].replaceAll('\\"','');
                           expOrdObj.Ship_To_County__c = csvLineItem[2].replaceAll('\\"','');    
                           system.debug('Country Code Before >>--->'+csvLineItem[3]);
                           system.debug('Country Code >>--->'+csvLineItem[3].replaceAll('\\"',''));
                           Sales_Org__c salesOrgRef = new Sales_Org__c(Country_Code__c = csvLineItem[3].replaceAll('\\"','')); 
                           expOrdObj.Sales_Org__r = salesOrgRef ;
                          // system.debug('csvLineItem[5].trim()>>--->'+csvLineItem[5].trim());
                          
                           // System.debug('Sold To Party Details>>--->'+csvLineItem[4]);
                           // System.debug('Sold To Party After appends>>--->'+csvLineItem[5]);
                           }
                           Account accountReference = new Account(SAP_Code__c = csvLineItem[5]); 
                           //system.debug('accountReference  >>--->'+accountReference );
                           expOrdObj.Sold_To_Party__r = accountReference;
                           expOrdObj.plant__c = csvLineItem[6].replaceAll('\\"','');
                           expOrdObj.sales_order_no__c = csvLineItem[7].replaceAll('\\"','');
                           system.debug('csvLineItem[8]>>--->'+csvLineItem[8]);
                           if(String.isNotEmpty(csvLineItem[8])){
                               expOrdObj.sales_order_date__c = generateDate(csvLineItem[8].replaceAll('\\"',''));
                           }
                           System.debug('csvLineItem[9]>>--->'+csvLineItem[9]);
                           expOrdObj.customer_po__c = csvLineItem[9].replaceAll('\\"','');
                           system.debug('customer_po_date__c  >>--->'+csvLineItem[10]);
                            csvLineItem[10] = csvLineItem[10].replaceAll('\\"','');
                           if(String.isNotEmpty(csvLineItem[10])){
                              system.debug('customer_po_date__c  >>--->'+csvLineItem[10]);
                               expOrdObj.customer_po_date__c  = generateDate(csvLineItem[10]);
                           }
                           csvLineItem[11] = csvLineItem[11].replaceAll('\\"','');
                            if(csvLineItem[11].length()<= 18 &&  String.isNotBlank(csvLineItem[11])){
                            Integer reqSize = 0;
                            reqSize = 18 -   csvLineItem[11].length();
                            for(integer i=0; i<reqSize ;i++){
                              csvLineItem[11] = '0'+csvLineItem[11]; 
                            }
                            System.debug('SKU After appends>>--->'+csvLineItem[11]);
                           }
                           SKU__c skuRef = new SKU__c(Combination_Key__c ='2000'+csvLineItem[58].replaceAll('\\"','')+''+csvLineItem[60].replaceAll('\\"','')+''+csvLineItem[11].replaceAll('\\"',''));
                           expOrdObj.SKU__r = skuRef;
                           
                           expOrdObj.material_description__c = csvLineItem[12].replaceAll('\\"','');
                           expOrdObj.order_quantity__c = Double.valueOf(!String.isEmpty(csvLineItem[13]) ? csvLineItem[13].replaceAll('\\"','').replaceAll(',','') : '0');
                            csvLineItem[14] = csvLineItem[14].replaceAll('\\"','');
                           if(String.isNotEmpty(csvLineItem[14])){
                           system.debug('schedule_line_date__c >>--->'+csvLineItem[14]);
                           expOrdObj.schedule_line_date__c = generateDate(csvLineItem[14]);
                           }
                           system.debug('csvLineItem[15]>>--->'+csvLineItem[15]);
                           expOrdObj.label_remark_in_so__c = csvLineItem[15].replaceAll('\\"','');
                           csvLineItem[16] = csvLineItem[16].replaceAll('\\"','');
                           if(String.isNotEmpty(csvLineItem[16])){
                               system.debug('label_confirmation_date__c >>--->'+csvLineItem[16]);
                               expOrdObj.label_confirmation_date__c = generateDate(csvLineItem[16]);
                          
                          }
                           System.debug('csvLineItem[17]>>--->'+csvLineItem[17]);
                           expOrdObj.credit_status__c = csvLineItem[17].replaceAll('\\"','');
                            csvLineItem[18] = csvLineItem[18].replaceAll('\\"','');
                           if(String.isNotEmpty(csvLineItem[18])){
                           system.debug('required_delivery_date__c >>--->'+csvLineItem[18]);
                               expOrdObj.required_delivery_date__c = generateDate(csvLineItem[18]);
                           }
                           
                            csvLineItem[19] = csvLineItem[19].replaceAll('\\"','');
                            if(String.isNotEmpty(csvLineItem[19])){
                            system.debug('last_date_of_shipment_as_per_lc__c >>--->'+csvLineItem[19]);
                           expOrdObj.last_date_of_shipment_as_per_lc__c = generateDate(csvLineItem[19]);
                           }
                            csvLineItem[20] = csvLineItem[20].replaceAll('\\"','');
                           if(String.isNotEmpty(csvLineItem[20])){
                              system.debug('commitment_date__c >>--->'+csvLineItem[20]);
                               expOrdObj.commitment_date__c = generateDate(csvLineItem[20]);
                           }
                            csvLineItem[21] = csvLineItem[21].replaceAll('\\"','');
                           if(String.isNotEmpty(csvLineItem[21])){
                           system.debug('rev_commitment_date__c >>--->'+csvLineItem[21]);
                               expOrdObj.rev_commitment_date__c = generateDate(csvLineItem[21]);
                           }
                            csvLineItem[22] = csvLineItem[22].replaceAll('\\"','');
                           if(String.isNotEmpty(csvLineItem[22])){
                           system.debug('act_readiness_date__c >>--->'+csvLineItem[22]);
                               expOrdObj.act_readiness_date__c = generateDate(csvLineItem[22]);
                           }
                            csvLineItem[23] = csvLineItem[23].replaceAll('\\"','');
                           if(String.isNotEmpty(csvLineItem[23])){
                           system.debug('fact_stuffing_date__c  >>--->'+csvLineItem[23]);
                               expOrdObj.fact_stuffing_date__c = generateDate(csvLineItem[23]);
                           }
                           system.debug('item 25  >>--->'+csvLineItem[24].replaceAll('\\"',''));
                           system.debug('item 26  >>--->'+csvLineItem[25].replaceAll('\\"',''));
                           if(!String.isEmpty(csvLineItem[24]))
                           system.debug('value>>--->'+(!String.isEmpty(csvLineItem[24].replaceAll('\\"','').replaceAll(',','')) ? csvLineItem[24].replaceAll('\\"','').replaceAll(',','') : '0'));
                           expOrdObj.invoice_quantity__c = Double.valueOf(!String.isEmpty(csvLineItem[24].replaceAll('\\"','').replaceAll(',','')) ? csvLineItem[24].replaceAll('\\"','').replaceAll(',','') : '0');
                           expOrdObj.pending_quantity__c = Double.valueOf(!String.isEmpty(csvLineItem[25].replaceAll('\\"','').replaceAll(',','')) ? csvLineItem[25].replaceAll('\\"','').replaceAll(',','') : '0');
                            csvLineItem[26] = csvLineItem[26].replaceAll('\\"','');
                           if(String.isNotEmpty(csvLineItem[26])){
                           system.debug('tentative_sailing_date__c >>--->'+csvLineItem[26]);
                               expOrdObj.tentative_sailing_date__c = generateDate(csvLineItem[26]);
                           }
                            csvLineItem[27] = csvLineItem[27].replaceAll('\\"','');
                           if(String.isNotEmpty(csvLineItem[27])){
                           system.debug('actual_sailing_date__c >>--->'+csvLineItem[27]);
                           expOrdObj.actual_sailing_date__c = generateDate(csvLineItem[27]);
                           }
                            csvLineItem[28] = csvLineItem[28].replaceAll('\\"','');
                           if(String.isNotEmpty(csvLineItem[28])){
                           system.debug('tentative_arrival_date__c >>--->'+csvLineItem[28]);
                           expOrdObj.tentative_arrival_date__c = generateDate(csvLineItem[28]);
                           }
                           //System.debug('csvLineItem[29]>>--->'+csvLineItem[29]);
                           expOrdObj.vessel_name__c = csvLineItem[29].replaceAll('\\"','');
                           //System.debug('csvLineItem[30]>>--->'+csvLineItem[30]);
                           expOrdObj.container_no__c = csvLineItem[30].replaceAll('\\"','');
                           //System.debug('csvLineItem[31]>>--->'+csvLineItem[31]);
                           expOrdObj.logistics_feedback__c = csvLineItem[31].replaceAll('\\"','');
                           //System.debug('csvLineItem[32]>>--->'+csvLineItem[32]);
                           expOrdObj.shipping_status__c = csvLineItem[32].replaceAll('\\"','');
                           //System.debug('csvLineItem[33]>>--->'+csvLineItem[33]);
                           expOrdObj.currencyisocode = csvLineItem[33].replaceAll('\\"','');
                           //System.debug('csvLineItem[34]>>--->'+csvLineItem[34]);
                           expOrdObj.so_net_price__c = Decimal.valueOf(!String.isEmpty(csvLineItem[34].replaceAll('\\"','').replaceAll(',','')) ? csvLineItem[34].replaceAll('\\"','').replaceAll(',','') : '0'); 
                           //System.debug('csvLineItem[35]>>--->'+csvLineItem[35]);
                           expOrdObj.so_net_value__c = Double.valueOf(!String.isEmpty(csvLineItem[35].replaceAll('\\"','').replaceAll(',','') ) ? csvLineItem[35].replaceAll('\\"','').replaceAll(',','') : '0');
                           //System.debug('csvLineItem[36]>>--->'+csvLineItem[36]);
                           expOrdObj.invoice_net_value__c = Decimal.valueOf(!String.isEmpty(csvLineItem[36].replaceAll('\\"','').replaceAll(',','') ) ? csvLineItem[36].replaceAll('\\"','').replaceAll(',','') : '0');
                           //System.debug('csvLineItem[37]>>--->'+csvLineItem[37]);
                           expOrdObj.sales_month__c = csvLineItem[37].replaceAll('\\"','');
                           
                           //Payment_Term__c payTermRef = new Payment_Term__c(CombinationKey__c = csvLineItem[41]);
                           //System.debug('csvLineItem[38]>>--->'+csvLineItem[38]);
                           expOrdObj.Payment_Term_Txt__c = csvLineItem[38].replaceAll('\\"',''); 
                           //System.debug('csvLineItem[39]>>--->'+csvLineItem[39]);
                           expOrdObj.commercial_invoice__c = csvLineItem[39].replaceAll('\\"','');
                            csvLineItem[40] = csvLineItem[40].replaceAll('\\"','');
                           if(String.isNotEmpty(csvLineItem[40])){
                               system.debug('commercial_invoice_date__c >>--->'+csvLineItem[40]);
                               expOrdObj.commercial_invoice_date__c = generateDate(csvLineItem[40]);
                           }
                           //System.debug('csvLineItem[41]>>--->'+csvLineItem[41]);
                           expOrdObj.dhl_no__c = csvLineItem[41].replaceAll('\\"','');
                            csvLineItem[42] = csvLineItem[42].replaceAll('\\"','');
                           if(String.isNotEmpty(csvLineItem[42])){
                              // system.debug('dhl_date__c >>--->'+csvLineItem[42]);
                               expOrdObj.dhl_date__c = generateDate(csvLineItem[42]);
                           }
                            csvLineItem[43] = csvLineItem[43].replaceAll('\\"','');
                           if(String.isNotEmpty(csvLineItem[43])){
                              // system.debug('copy_docs_date__c >>--->'+csvLineItem[43]);
                               expOrdObj.copy_docs_date__c = generateDate(csvLineItem[43]);
                           }
                           //System.debug('csvLineItem[44]>>--->'+csvLineItem[44]);
                           expOrdObj.docs_remark__c = csvLineItem[44].replaceAll('\\"','');
                           //System.debug('csvLineItem[45]>>--->'+csvLineItem[45]);
                           expOrdObj.ldoc_no__c = csvLineItem[45].replaceAll('\\"','');
                           //System.debug('csvLineItem[46]>>--->'+csvLineItem[46]);
                           expOrdObj.region__c = csvLineItem[46].replaceAll('\\"','');
                           //System.debug('csvLineItem[47]>>--->'+csvLineItem[47]);
                           expOrdObj.overall_order_status__c = csvLineItem[47].replaceAll('\\"','');
                           //System.debug('csvLineItem[48]>>--->'+csvLineItem[48]);
                           expOrdObj.excise_invoice__c = csvLineItem[48].replaceAll('\\"','');
                           //System.debug('csvLineItem[49]>>--->'+csvLineItem[49]);
                           expOrdObj.delivery_block__c = csvLineItem[49].replaceAll('\\"','');
                           //System.debug('csvLineItem[50]>>--->'+csvLineItem[50]);
                           expOrdObj.reason_for_rejection__c = csvLineItem[50].replaceAll('\\"',''); 
                           //System.debug('csvLineItem[51]>>--->'+csvLineItem[51]);
                           expOrdObj.item__c = Double.valueOf(csvLineItem[51].replaceAll('\\"',''));
                           //System.debug('csvLineItem[52]>>--->'+csvLineItem[52]);
                           expOrdObj.schedule_line__c = Double.valueOf(csvLineItem[52].replaceAll('\\"',''));
                           //System.debug('csvLineItem[53]>>--->'+csvLineItem[53]);
                           expOrdObj.order_quantity_unit__c = csvLineItem[53].replaceAll('\\"','');
                            csvLineItem[54] = csvLineItem[54].replaceAll('\\"','');
                           if(String.isNotEmpty(csvLineItem[54])){
                               system.debug('Bill of Landing>>--->'+csvLineItem[54]);
                               expOrdObj.bill_of_lading_date__c = generateDate(csvLineItem[54]);
                           }
                           System.debug('csvLineItem[55]>>--->'+csvLineItem[55]);
                           Product2 prodRef = new Product2(Combination_Key__c=csvLineItem[55].replaceAll('\\"','')+'2000'+csvLineItem[58].replaceAll('\\"','')+''+csvLineItem[60].replaceAll('\\"',''));
                           expOrdObj.Product__r = prodRef;
                           System.debug('csvLineItem[56]>>--->'+csvLineItem[56]);
                           expOrdObj.materialgroupdescription__c = csvLineItem[56].replaceAll('\\"','');
                           System.debug('csvLineItem[57]>>--->'+csvLineItem[57]);
                           System.debug('csvLineItem[58]>>--->'+csvLineItem[58]);
                           Distribution_Channel__c DistChannlRef = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[58].replaceAll('\\"',''));
                           expOrdObj.Distribution_Channel__r = DistChannlRef ;
                           System.debug('csvLineItem[59]>>--->'+csvLineItem[59]);
                           System.debug('csvLineItem[60]>>--->'+csvLineItem[60]);
                           Division__c divRef = new Division__c(Division_Code__c = csvLineItem[60].replaceAll('\\"',''));
                           expOrdObj.Division__r = divRef;
                           System.debug('csvLineItem[61]>>--->'+csvLineItem[61]);
                           expOrdObj.sales_office__c = csvLineItem[61].replaceAll('\\"','');
                           System.debug('csvLineItem[62]>>--->'+csvLineItem[62]);
                           expOrdObj.sales_office_key__c = csvLineItem[62].replaceAll('\\"','');
                           //system.debug('unconfirmed_mad>>--->'+csvLineItem[63]);
                            csvLineItem[63] = csvLineItem[63].replaceAll('\\"','');
                           if(String.isNotEmpty(csvLineItem[63]) || csvLineItem[63] !=''){
                           system.debug('unconfirmed_mad>>--->'+csvLineItem[63]);
                           expOrdObj.unconfirmed_mad__c = generateDate(csvLineItem[63]);
                           }
                           System.debug('Status >>--->'+csvLineItem[64].replaceAll('\\"','').replaceAll(' ',''));
                           if(csvLineItem[64].replaceAll('\\"','').replaceAll(' ','')!=''){
                           expOrdObj.Status__c = csvLineItem[64].replaceAll('\\"','');
                           }else{
                           System.debug('None');
                           expOrdObj.Status__c = 'NONE';
                           }
                            
                           expOrdObj.Combination_Key__c = csvLineItem[7].replaceAll('\\"','')+''+csvLineItem[51].replaceAll('\\"','')+''+csvLineItem[52].replaceAll('\\"','');          
                        for(string s : csvLineItem){
                        expOrdObj.CSV_Row__c += s;
                        row += s; 
                        }
                        businessDataList.add(expOrdObj);
                        }else{
                        Export_Order__c  expOrdObj = new Export_Order__c ();
                            for(string s : csvLineItem){
                        expOrdObj.CSV_Row__c +=  s+',';
                         row += s; 
                        
                        }
                        exportErrList.add(expOrdObj);
                        }
                    }
                    catch(Exception ex){
                      // BusinessDashboardBatch_clone exObj = new BusinessDashboardBatch_clone ();
                        exceptionHandler1(ex, 'exportOrderOperation');
                        errorCSVList.add(row+','+ex.getMessage());
                    }
                }
                
                System.debug('businessDataList: '+businessDataList.size());
                try{
                Database.UpsertResult[] srList;
                Schema.SObjectField ftoken = Export_Order__c.Fields.Combination_Key__c;
                if(businessDataList.size()>0){
                    srList = Database.upsert(businessDataList,ftoken ,false);
                }
               
                //Iterate through each returned result
                if(srList.isEmpty() || srList != NULL ){
                for(Integer i=0;i<srList.size();i++){
                    if (!srList[i].isSuccess()){
                        Database.Error[] errs = srList[i].getErrors();
                        errorCSVList.add(String.valueOf(businessDataList[i].get('CSV_Row__c'))+','+errs[0].getMessage());
                    }
                    else{
                        successCSVList.add(String.valueOf(businessDataList[i].get('Id'))+','+String.valueOf(businessDataList[i].get('CSV_Row__c')));
                    }
                }
                for (Export_Order__c expord :exportErrList){
                    errorCSVList.add(String.valueOf(expord.get('CSV_Row__c')+',"Data is not Proper."'));
                }
                }
            
        }
        catch(Exception ex){
           // BusinessDashboardBatch_clone exObj = new BusinessDashboardBatch_clone ();
            exceptionHandler1(ex, 'exportOrderOperation');
        }
    }
      public Date generateDate (String strDate){
      //system.debug('function Date>>--->'+strDate);
      strDate = strDate.replaceAll('\\"','');
      //system.debug('strDate>>--->'+strDate);
       string[] CsvDate = strDate.split('-');
                                           // system.debug('CsvDate>>--->'+CsvDate);
                                            string day='';
                                            string month='';
                                            string year='';  
                                             day  = CsvDate[0];
                                             month = CsvDate[1];
                                             year = CsvDate[2];
                                             year = '20'+Year;
                                             //system.debug('day>>--->'+day);
                                             //system.debug('month>>--->'+month);
                                             //system.debug('year>>--->'+year);
                                            Date dateVal = Date.newInstance(Integer.valueOf(year.trim()), mapMonth.get(month.toUpperCase()),Integer.valueOf(day.trim()));                                                         
       return dateVal;  
      }
      
 public  list<List<String>> parseCSV(String contents,Boolean skipHeaders) {
list<list<String>> allFields = new List<List<String>>();

// replace instances where a double quote begins a field containing a comma
// in this case you get a double quote followed by a doubled double quote
// do this for beginning and end of a field
contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
// now replace all remaining double quotes - we do this so that we can reconstruct
// fields with commas inside assuming they begin and end with a double quote


// we are not attempting to handle fields with a newline inside of them
// so, split on newline to get the spreadsheet rows
List<String> lines = new List<String>();
try {
    lines = splitObj.safeSplit(contents,'\r\n');

} catch (System.ListException e) {
    System.debug('Limits exceeded?' + e.getMessage());
}
//Integer num = 0;
for(String line : lines) {
    // check for blank CSV lines (only commas)
    if (line.replaceAll(',','').trim().length() == 0) break;
    //system.debug('field line >>--->'+line); 
    line  = line.replaceAll('""','DBLQT');
    List<String> fields = line.split(','); 
    
    List<String> cleanFields = new List<String>();
    String compositeField;
    Boolean makeCompositeField = false;
    system.debug('fields size >>--->'+fields.size()); 
   integer i=0;
    for(String field : fields) {
   /* if(field.contains('#')){
        field.replaceAll('#','');
    }*/
    if(field.Contains('\n')){  
  field = field.replaceAll('\n','');
  system.debug('last Field with n '+i+++' >>--->'+field);
  }
   if(field.Contains('CRLF')){  
  field = field.replaceAll('CRLF','');
  system.debug('last Field'+i+++' >>--->'+field);
  }
  if(field.Contains('\r')){  
  field = field.replaceAll('\r','');
  system.debug('last Field'+i+++' >>--->'+field);
  }
        if (field.startsWith('"') && field.endsWith('"')) {
            cleanFields.add(field.replaceAll('DBLQT','"'));
              //system.debug('field start And End with Q'+i+++' >>--->'+field);
        } else if (field.startsWith('"')) {
            makeCompositeField = true;
            compositeField = field;
             // system.debug('field start with Q '+i+++' >>--->'+field);
        } else if (field.endsWith('"')) {
            compositeField += ',' + field;
            cleanFields.add(compositeField.replaceAll('DBLQT','"'));
            makeCompositeField = false;
              //system.debug('field Ends with Q'+i+++' >>--->'+field);
        } else if (makeCompositeField) {
            compositeField +=  ',' + field;
             // system.debug('composite field '+i+++' >>--->'+field);
        } else {
            cleanFields.add(field.replaceAll('DBLQT','"'));
             // system.debug('field with DBLQT'+i+++' >>--->'+field);
           // system.debug('cleanFields values >>--->'+cleanFields);
        }
    }
    system.debug('cleanFields size>>--->'+cleanFields.size());
    allFields.add(cleanFields);
    //system.debug('allFields size>>--->'+allFields.size());
}


//if(skipHeaders)allFields.remove(0);

return allFields;       
}
      public void exceptionHandler1(Exception exObj, String methodName){
        if(exObj!=null){
            ExceptionMon1 monObj = new ExceptionMon1();
            list<ExceptionMon1> exceptionMonList = new list<ExceptionMon1>();
            // monObj.batchNo = batchNo;
            monObj.method = methodName;            
            monObj.lineNo = exObj.getLineNumber();
            monObj.message = exObj.getMessage();
            monObj.stackTrace = exObj.getStackTraceString();
            monObj.cause = String.valueOf(exObj.getCause());
            exceptionMonList.add(monObj);
            System.debug('exceptionMonList: '+exceptionMonList);
        }
    }
    
    public class ExceptionMon1{
        public Integer batchNo = 0;
        public String method = '';
        public Integer lineNo = 0;
        public String message = '';
        public String stackTrace = '';
        public String cause = '';
    }

}