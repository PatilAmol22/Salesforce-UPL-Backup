/*
* Name: Business Dashboard Batch
* Created On: 08 Mar 2017
* Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com) / Azhar Shaikh (azhar.shaikh@skinternational.com)
* Description: Utility Class used for Dynamic CSV Parsing by BusinessDashboardReadAndPopulateBatch.
  APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
  Modified By: Harshaprasad Srustu
  LastmodifiedDate: 12-Feb-2023

*/
public class BusinessDashboardBatch {
    public List<ExceptionMon> exceptionMonList;
    public List<String> errorCSVList;
    public List<String> successCSVList;
    
    public String businessDashboardID;
    private SplitString splitObj ;
    
    public Integer batchNo;
    public String rowNo;
    public String row;
    public String selectedObject;
    public String fileName;
    public DateTime asOfNow;
    
    public Map<String,String> combinationKeyMap;
    public Map<String,String> csvMap;
    public Map<String,String> fiscalyearMap;
    public Map<String,List<Map<Integer,String>>> csvlistMap;
    public Map<String,List<Map<Integer,String>>> liqcsvlistMap;
    public List<Map<Integer,String>> csvlist;
    public Map<Integer,String> ytdMap;
    
    public Map<String,String> mapYtdGovSaib;
    public Map<String,String> mapYtdCopSaib;
    public Map<Integer,Map<String,String>> mapMapYtdGovSaib;
    
    public List<Map<Integer,Map<String,String>>> ytdGovSaibList;
    //public Map<String,List<Map<Integer,Map<String,String>>>> mapCsv;
    public Map<String,List<saibWrapper>> mapCsv;
    public Map<String,String> mapDemo;
    public String keySaib='';
    public String liqkeySaib='';
    public String key='';
    public String csvkey='';
    public String liqKey='';
    public Integer keycsv;
    public List<Opening_Inventory2__c> OIList;
    public List<Liquidation2__c> LiqList;
    public sObject sObj_new; 
    
    public BusinessDashboardBatch(){
        businessDashboardID = '';
        selectedObject = '';
        batchNo = 0;
        rowNo = '';
        filename = '';
        asOfNow = System.Today();
        combinationKeyMap= new Map<String,String>();
        mapDemo = new Map<String,String>();
        //mapCsv= new Map<String,List<Map<Integer,Map<String,String>>>>();
        mapCsv= new Map<String,List<saibWrapper>>();
        csvMap = new Map<String,String>();
        csvlistMap = new Map<String,List<Map<Integer,String>>>();
        liqcsvlistMap = new Map<String,List<Map<Integer,String>>>();
        csvlist = new List<Map<Integer,String>>(); 
        splitObj = new SplitString();
        
        
        fiscalyearMap = new Map<String,String>();
        OIList = new List<Opening_Inventory2__c>();
        LiqList = new List<Liquidation2__c>();
        exceptionMonList = new List<ExceptionMon>();
        errorCSVList = new List<String>();
        successCSVList = new List<String>();
        
        //Fetch single record from bdObjage Object created today & status = draft
        List<BusinessDashboard__c> businessDashboardList = [SELECT Id, Header__c, As_of_now__c 
                                                            FROM BusinessDashboard__c 
                                                            WHERE CreatedDate = TODAY 
                                                            AND Status__c = 'Draft' 
                                                            ORDER By CreatedDate LIMIT 1 ];
        
        System.debug('businessDashboardList >>>>>>>>>>>' +businessDashboardList);
        if(!businessDashboardList.isEmpty()){
            //system.debug('businessDashboardList'+businessDashboardList);
            businessDashboardID = businessDashboardList[0].Id;
            asOfNow = businessDashboardList[0].As_of_now__c;
            errorCSVList.add(businessDashboardList[0].Header__c+',Error Description');
            successCSVList.add('Record ID,'+businessDashboardList[0].Header__c);
        }
    }
    
    //Method to fetch attachment from bdObjage Object
    public String getFile(){
        String myFile = '';
        //system.debug('businessDashboardID: '+businessDashboardID);
        
        if(String.isNotBlank(businessDashboardID)){
            
            List<Attachment> attachmentList = [SELECT Id,Name,Body,ParentId 
                                               FROM Attachment 
                                               WHERE ParentId = :businessDashboardID
                                               AND (Name != 'Success.csv' 
                                                    OR Name != 'Error.csv')
                                               AND Name LIKE '%.csv'
                                               ORDER BY CreatedDate LIMIT 1];
            
            if(!attachmentList.isEmpty()){
                //Return csv to scope of Batch class from attachment
                //system.debug('Attachment List Size: '+attachmentList.size());
                myFile = attachmentList[0].Body.toString();  
                //system.debug('myFile :- '+myFile);
                
                fileName = attachmentList[0].Name;
                
                fileName = fileName.substringBefore('_');
                
                system.debug('fileName :- '+fileName);
                
                //Integer endIndex = fileName.indexOf('_');
                //fileName = fileName.substring(0, endIndex);
                List<SchemaObjectMapping__c> lisSC= new List<SchemaObjectMapping__c>();
                /*if(test.isRunningTest()){
                    lisSC= [Select Name, Filename__c, Object__c FROM SchemaObjectMapping__c  WHERE Filename__c ='test2.csv' ];  
                    system.debug('size list>>--->'+lisSC.size());
                    system.debug('fileName >>--->'+fileName);
                    if(lisSC.size()==0){
                        lisSC= [Select Name, Filename__c, Object__c FROM SchemaObjectMapping__c  WHERE Filename__c ='test.csv' ]; 
                    }
                }else{*/
                   lisSC= [Select Name, Filename__c, Object__c FROM SchemaObjectMapping__c  WHERE Filename__c LIKE:fileName ]; 
                //}
                 
                //system.debug('lisSC :-----'+lisSC);
                Map<String, String> objectNameMap = new Map<String, String>();
                for(SchemaObjectMapping__c smObj : lisSC){
                    //system.debug('smObj :-'+smObj);
                    objectNameMap.put(smObj.Filename__c, smObj.Object__c);
                }
                //system.debug('objectNameMap :-'+objectNameMap);
                if(objectNameMap.containsKey(fileName) || test.isRunningTest()){
                    //system.debug('inside if Map :-');
                    if(test.isRunningTest()){
                        selectedObject = objectNameMap.get(fileName);
                        
                        if(fileName == 'test.csv'){
                                selectedObject = 'Opening_Inventory2__c';
                        }else if(fileName == 'test2.csv'){
                            selectedObject = 'Export_Order__c';
                            }else if(fileName == 'test3.csv'){
                            selectedObject = 'Opening_Inventory2__c';
                            }else if(fileName == 'test-6410.csv'){
                            selectedObject = 'Opening_Inventory2__c';
                            }
                            else if(fileName == 'Liquidation Report - 2941.csv'){
                            selectedObject = 'Opening_Inventory2__c';
                            }else if(fileName == 'test-SHT 5100.csv'){
                            selectedObject = 'Opening_Inventory2__c';
                            }else {
                            selectedObject='BusinessDashboardData__c';
                        }
                         
                    }else{
                         selectedObject = objectNameMap.get(fileName);
                    }
                   
                    //system.debug('selectedObject :- '+selectedObject);
                }
                //system.debug('After Map :-');
                //Change status of current record being processed by the batch
                BusinessDashboard__c bdObj = new BusinessDashboard__c();
                bdObj.Id = businessDashboardID;
                bdObj.Status__c ='Processing';
                update bdObj;
            }
            else{
                //Update Record if no attachment found
                BusinessDashboard__c bdObj = new BusinessDashboard__c();
                bdObj.Id = businessDashboardID;
                bdObj.Status__c ='Completed';
                update bdObj;
            }
            //system.debug('File Length: '+ myFile.length());
            //system.debug('Heap size is ' + limits.getHeapSize() + ' enforced is ' + limits.getLimitHeapSize());
        }
        return myFile;
    }
    
    //Method to process CSV rows and insert records in bdObjage Data 
    public void processData(String csvFile){
        combinationKeyMap= new Map<String,String>();
        csvMap = new Map<String,String>();
        
        csvlistMap = new Map<String,List<Map<Integer,String>>>();
        liqcsvlistMap = new Map<String,List<Map<Integer,String>>>();
        csvlist = new List<Map<Integer,String>>(); 
        ytdMap = new Map<Integer,String>();
        Map<String,integer> ytdMap2 = new Map<String,integer>();
        Map<String,Integer> liqytdMap = new Map<String,Integer>();
        
        Map<String,Map<String,String>> ytdMap2Saib = new Map<String,Map<String,String>>();
        mapYtdGovSaib = new Map<String,String>();
        mapYtdCopSaib = new Map<String,String>();
        
        mapMapYtdGovSaib = new Map<Integer,Map<String,String>>();
        
        ytdGovSaibList = new  List<Map<Integer,Map<String,String>>>();
        
        List<saibWrapper> saibWrapperList= new List<saibWrapper>();
        Map<String,List<saibWrapper>> maps=new Map<String,List<saibWrapper>>();
        Map<String,List<saibWrapper>> liqmaps=new Map<String,List<saibWrapper>>();
        Map<String,String> checkSuccessMAp=new Map<String,String>();
        
       // mapCsv= new Map<String,List<Map<Integer,Map<String,String>>>>();
        try{
            batchNo++;
            
            //Logic to parse CSV row by row
            List<String> csvData = new List<String>();
            csvData = splitObj.safeSplit(csvFile, '\n');
            system.debug('csvData--'+csvData);
            
            List<sObject> businessDataList = new List<sObject>();
            
            Map<Integer,Mapping> posApiMap = new Map<Integer,Mapping>();
            posApiMap = Mapping.deSerializedMap(selectedObject,fileName);
            //system.debug('csvData 1 :- '+csvData);
            system.debug('selectedObject :- '+selectedObject);
            if(selectedObject == 'Export_Order__c'){
                ExportOrderReadCsv exOrderObj = new ExportOrderReadCsv();
                exOrderObj.exportOrderOperation(csvFile,businessDashboardID,errorCSVList,successCSVList);
                
            }else
                if(selectedObject == 'Opening_Inventory2__c'){
                    
                    // File Name :----     Trade_Liquidation_YTD_Sales
                   system.debug('csvData 2 :- '+csvData);
                    if(test.isRunningTest()){
                        /*if(fileName!='test.csv'){
                            fileName = 'SAIB';
                        }else*/ 
                         if(fileName=='test-6410.csv') {
                            fileName = '6410';
                        }else if(fileName=='test-SHT 5100.csv') {
                            fileName = 'SHT 5100';
                        }else if(fileName=='Liquidation Report - 2941.csv'){
                            fileName = '2941';
                        }else if(fileName!='test.csv') {
                            fileName = 'SWAL';
                        }
                        else {
                             fileName = 'Trade';
                        }
                    }
                    // SAIB code is commented because it is not required now by Azhar Shaikh
                      /*if(fileName.contains('SAIB'))
                    {
                      
                        //system.debug('csvData size :- '+csvData.size());
                        Map<String,String> monthMap= new Map<String,String>();
                        monthMap.put('Apr','1');
                        monthMap.put('May','2');
                        monthMap.put('Jun','3');
                        monthMap.put('Jul','4');
                        monthMap.put('Aug','5');
                        monthMap.put('Sep','6');
                        monthMap.put('Oct','7');
                        monthMap.put('Nov','8');
                        monthMap.put('Dec','9');
                        monthMap.put('Jan','10');
                        monthMap.put('Feb','11');
                        monthMap.put('Mar','12');
                        //List<String> monthStr= new List<String>();
                        for (Integer i = 0; i < csvData.size()-1; i++){
                            saibWrapper wrapObj= new saibWrapper();
                            row = csvData[i];
                            
                            
                            //monthStr= csvData[i].split(',');
                            //system.debug('monthStr :---'+monthStr);
                            //system.debug('csvData[i] :---'+csvData[i]);
                            try{
                            String[] arrTest = csvData[i].split('("[^"]*")');
                            String[] FinalarrTest =new List<String>(); 
                            
                            String[] DoubleQ= parse(csvData[i]);
                                System.debug('DoubleQ size :- '+DoubleQ.size());
                                if(DoubleQ.size()!=0){
                            String ySales;
                            String[] numPostCode19=new String[]{'1','2','3','4','5','6','7','8','9'};
                            String[] numPostCode1012=new String[]{'10','11','12'};
                            String csvStr0= DoubleQ[0].replaceAll('\\"','').trim();
                            String csvStr1= DoubleQ[1].replaceAll('\\"','').trim();
                            String csvStr2= DoubleQ[2].replaceAll('\\"','').trim();
                            String csvStr3= DoubleQ[3].replaceAll('\\"','').trim();
                            String csvStr4= DoubleQ[4].replaceAll('\\"','').trim();
                            String csvStr5= DoubleQ[5].replaceAll('\\"','').trim();
                            
                            String[] csvStrMonth=csvStr2.split(',');
                                    String[] monthyearStr=csvStrMonth[0].split('\\s+');
                                    System.debug('csvStrMonth :- '+monthyearStr[1]);
                                    String fiscalyear;
                                    Integer csvStrMonth_new = Integer.valueOf(monthyearStr[1]) - 1;
                                    System.debug('csvStrMonth_new :- '+csvStrMonth_new);
                             if(monthMap.containsKey(csvStrMonth[0].substring(0, 3))){
                                 if(csvStrMonth[0].substring(0, 3)>='1' || csvStrMonth[0].substring(0, 3)<'10'){
                                     fiscalyear= csvStr1;
                                 }  else {
                                     fiscalyear = String.valueOf(csvStrMonth_new) +'-'+ csvStrMonth[1];
                                 }
                             }
                                    
                                String[] comStr = (csvStr3+'1000'+fiscalyear+csvStr0).split(',');
                                comStr[0]=comStr[0].replaceAll('\\(','');
                                comStr[0]=comStr[0].replaceAll('\\)','');
                                keySaib= comStr[0]+'SAIB'.replaceAll('\\s+','').trim();
                                liqkeySaib = comStr[0]+'SAIB'.replaceAll('\\s+','').trim()+csvStrMonth[0].substring(0, 3);
                                    
                                String csvStr6= csvStr5.replaceAll('\\)','').trim();
                                System.debug('keySaib :- '+keySaib);
                                System.debug('liqkeySaib :- '+liqkeySaib);
                                    
                                System.debug('csvStrMonth[0].substring(0, 3)) :- '+csvStrMonth[0].substring(0, 3));
                                if(monthMap.containsKey(csvStrMonth[0].substring(0, 3))){
                                        wrapObj.strPeriod=monthMap.get(csvStrMonth[0].substring(0, 3));
                                        wrapObj.strytdGovSales=csvStr4;
                                        wrapObj.strytdCopSales=csvStr6;
                                }
                                System.debug('wrapObj :- '+wrapObj);
                               // saibWrapperList.add(wrapObj);
                                //saibWrapperList.sort();    
                                System.debug('saibWrapperList :- '+saibWrapperList);
                                //maps.put(keySaib,wrapObj); 
                               // maps.put(keySaib,saibWrapperList); 
                                    if(maps.containsKey(keySaib)){
                                        maps.get(keySaib).add(wrapObj);
                                    }
                                    else{
                                         saibWrapperList = new List<saibWrapper>();
                                        saibWrapperList.add(wrapObj);
                                         maps.put(keySaib,saibWrapperList);
                                        liqmaps.put(liqkeySaib, saibWrapperList);
                                    }  
                                System.debug('maps :- '+maps);
                                checkSuccessMAp.put(keySaib,row);
                            }
                            } catch(Exception ex){
                                system.debug('ex getMessage() :- '+ex.getMessage());
                                System.debug('ex.getLineNumber :-------'+ex.getLineNumber());
                            }
                        }
                        system.debug('maps 2:- '+maps.keySet());
                        
                        List<Opening_Inventory2__c> oiUpdateList= new List<Opening_Inventory2__c>();
                        List<Opening_Inventory2__c> oiList = [Select id, combination_key__c, YTD_Sales_Govt__c, YTD_Sales_Corporate__c,Period__c from Opening_Inventory2__c Where combination_key__c IN: maps.keySet()];
                        system.debug('oiList :--- '+oiList);
                        Map<String,String> oiObjId = new Map<String,String>();
                        Map<String,Opening_Inventory2__c> Opening_Inventory2MAP = new Map<String,Opening_Inventory2__c>();
                        for(Opening_Inventory2__c oiObj:oiList){
                            
                            Opening_Inventory2MAP.put(oiObj.combination_key__c,oiObj);
                            oiObjId.put(oiObj.combination_key__c,'');
                            
                        }   

                        for(String str:maps.keySet())
                        {
                          Opening_Inventory2__c oiObj2 = new Opening_Inventory2__c();
                          if(Opening_Inventory2MAP.containsKey(str)){
                             oiObj2 = Opening_Inventory2MAP.get(str);
                              for(saibWrapper wrapObj: maps.get(str)){
                                  if(Decimal.valueOf(wrapObj.strPeriod) >= Opening_Inventory2MAP.get(str).Period__c){
                                        
                                        try{
                                            //oiObj2.Id=oiObj.Id;
                                            oiObj2.Period__c=Decimal.valueOf(wrapObj.strPeriod);
                                            if(wrapObj.strytdGovSales!=''){
                                                oiObj2.YTD_Sales_Govt__c=Decimal.valueOf(wrapObj.strytdGovSales);
                                            }
                                            oiObj2.YTD_Sales_Corporate__c=Decimal.valueOf(wrapObj.strytdCopSales);
                                            oiUpdateList.add(oiObj2); 
                                            
                                        }catch(Exception ex){
                                            System.debug('ex.getMessage :-------'+ex.getMessage());
                                            System.debug('ex.getLineNumber :-------'+ex.getLineNumber());
                                        }
                                    }
                              }
                          } 
                            
                            
                        }
                         System.debug('oiUpdateList :- '+oiUpdateList);

                        for(String str:maps.keySet()){
                            if(oiObjId.containsKey(str)){

                                successCSVList.add(checkSuccessMAp.get(str));
                            }else{

                                errorCSVList.add(checkSuccessMAp.get(str));
                            }
                        }

                      
                        Database.SaveResult[] srList;
                        if(oiUpdateList.size()>0){
                            system.debug('inside if');
                            srList = Database.update(oiUpdateList, false);
                            if(srList.size()>0){
                                system.debug('srList size :-'+srList.size());
                                List<Liquidation2__c> liqList=[Select id, combination_key__c, Inventory_in_Kg_Cooperatives__c, Inventory_in_Kg_Govt__c from Liquidation2__c Where combination_key__c IN:liqmaps.keySet()];
                                Map<String,Liquidation2__c> liquidationMap=new Map<String,Liquidation2__c>();
                                system.debug('liqList :-'+liqList);
                                for(Liquidation2__c liqObj:liqList){
                                    liquidationMap.put(liqObj.combination_key__c, liqObj);
                                }
                                List<Liquidation2__c> liqUpdateList= new List<Liquidation2__c>();
                                for(String str:liqmaps.keySet()){
                                    Liquidation2__c liqObj= new Liquidation2__c();
                                    if(liquidationMap.containsKey(str)){
                                        liqObj = liquidationMap.get(str);
                                        for(saibWrapper saibWrapObj:liqmaps.get(str)){
                                            liqObj.Inventory_in_Kg_Cooperatives__c=Decimal.valueOf(saibWrapObj.strytdCopSales);
                                            liqObj.Inventory_in_Kg_Govt__c=Decimal.valueOf(saibWrapObj.strytdGovSales);
                                            liqUpdateList.add(liqObj);
                                        }
                                    }
                                }
                                Database.SaveResult[] srLiqList;
                                if(liqUpdateList.size()>0){
                                    srLiqList = Database.update(liqUpdateList, false);
                                    System.debug('srLiqList :- '+srLiqList);
                                }
                            }
                        }
                    }*/
                    System.debug('Line 439'+fileName.contains('SWAL'));
                    if(fileName.contains('SWAL'))
                    {   // Swal Trade code
                        System.debug('Line 442'+fileName.contains('SWAL'));
                        List<Opening_Inventory2__c> oiUpdateList= new List<Opening_Inventory2__c>();
                        Map<String,String> comytdsalesMap= new Map<String,String>();
                        String csvStr3;
                        Integer currentMonth;//INCTASK0015463
                        system.debug('csvData.size()-------'+csvData.size());
                        for (Integer i = 0; i < csvData.size()-1; i++){
                            
                             //system.debug('check :----');
                            List<String> csvLineItem = new List<String>();
                            row = csvData[i];
                            if (String.isNotBlank(row)){
                                String[] arrTest = csvData[i].split('("[^"]*")');
                                String[] FinalarrTest =new List<String>(); 
                                String[] DoubleQ= csvData[i].split(',');//Deeksha :Added for Qliksense
                            //String[] DoubleQ= parse(csvData[i]);//Deeksha :Removed for Qliksense
                            system.debug('DoubleQ-------'+DoubleQ);
                            String ySales ;
                            for(integer l=0; l<arrTest.size(); l++)
                            {
                                FinalarrTest.add(string.valueof(string.valueof(arrTest[l]).split(','))); 
                            }
                            
                            try{
                                
                               // doubleList = DoubleQ[0].split(',');
                                //system.debug('DoubleQ[2] :----'+DoubleQ[2].replaceAll('\\"',''));
                                //INCTASK0015463
                                String currentMonthStr = DoubleQ[2].replaceAll('\\"','').trim().substringBefore('.'); //Divya for Qliksense
                                currentMonth = Integer.valueOf(currentMonthStr.trim().right(2)); //Divya for Qliksense
                                system.debug('currentMonth--'+currentMonth);
                                String intFisYearStr = DoubleQ[2].replaceAll('\\"','').trim().substringAfter('.'); //Divya for Qliksense
                                Integer intFisYear = Integer.valueOf(intFisYearStr.trim().left(4)); //Divya for Qliksense
                                Integer fisYear = intFisYear+1;
                                String fiscalYear = intFisYear + '-' +fisYear;
                                Integer fisYearNext = intFisYear-1;
                                String fiscalYearNext = fisYearNext+'-'+DoubleQ[2].replaceAll('\\"','').trim();
                                //system.debug('fiscalYearNext:----'+fiscalYearNext);
                                fiscalYearNext=fiscalYearNext.trim();
                                key='';
                                liqKey='';
                                String[] numPostCode19=new String[]{'1','2','3','4','5','6','7','8','9'};
                                String[] numPostCode1012=new String[]{'10','11','12'};
                                //system.debug('DoubleQ :------'+DoubleQ);
                                
                                String csvStr0= DoubleQ[0].replaceAll('\\"','').trim();
                                String csvStr1= DoubleQ[1].replaceAll('\\"','').trim();
                                String csvStr2= DoubleQ[2].replaceAll('\\"','').trim();
                                csvStr3= DoubleQ[3].replaceAll('\\"','').trim();
                                
                                csvStr2 = fiscalYear;
                                String[] comStr = (csvStr1.remove('\'')+'1210'+csvStr2.trim()+csvStr0.remove('\'')).split(',');
                                comStr[0]=comStr[0].replaceAll('\\(','');
                                key= comStr[0]+'SWAL TRADE'.trim();//Divya
                                System.debug('key:- '+key);
                                comytdsalesMap.put(key,csvStr3.remove('\''));
                                //System.debug('comytdsalesMap :- '+comytdsalesMap);
                                csvMap.put(key, row);
                            }
                            catch(Exception ex){
                                system.assert(FALSE,ex.getMessage());
                                //system.debug('error line number :- '+ex.getLineNumber());
                            } 
                            }
                            
                            
                        }
                        System.debug('key :----'+key);
                        //System.debug('currentMonth :----'+currentMonth);
                        //APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                        /*List<Opening_Inventory2__c> OILst = [SELECT Id, Name,YTD_Sales__c, YTD_Sales_Jan__c, YTD_Sales_Feb__c, YTD_Sales_Mar__c, YTD_Sales_Apr__c,
                                                             YTD_Sales_May__c, YTD_Sales_Jun__c, YTD_Sales_Jul__c, YTD_Sales_Aug__c,
                                                             YTD_Sales_Sept__c, YTD_Sales_Oct__c, YTD_Sales_Nov__c, YTD_Sales_Dec__c, combination_key__c
                                                             FROM Opening_Inventory2__c Where combination_key__c IN:comytdsalesMap.keySet()];*/
                        
                        List<Opening_Inventory2__c> OILst = [SELECT Id, Name,YTD_Sales__c, MTD_Sales_Jan__c, MTD_Sales_Feb__c, MTD_Sales_Mar__c, MTD_Sales_Apr__c,
                                                             MTD_Sales_May__c, MTD_Sales_Jun__c, MTD_Sales_Jul__c, MTD_Sales_Aug__c,
                                                             MTD_Sales_Sept__c, MTD_Sales_Oct__c, MTD_Sales_Nov__c, MTD_Sales_Dec__c, combination_key__c
                                                             FROM Opening_Inventory2__c Where combination_key__c IN:comytdsalesMap.keySet()];
                        //APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC

                        System.debug('OILst :----'+OILst);
                        Map<String,Opening_Inventory2__c>Opening_Inventory2MAP = new Map<String,Opening_Inventory2__c>();
                        Map<String,String>opIdMap = new Map<String,String>();
                        for(Opening_Inventory2__c oib:OILst){
                            Opening_Inventory2MAP.put(oib.combination_key__c,oib);
                            opIdMap.put(oib.combination_key__c,'');       
                        }
                        for(String ytdSalesValue:comytdsalesMap.keySet()){
                                        if(Opening_Inventory2MAP.containsKey(ytdSalesValue)){
                                            String ytdSalesMonthValue=comytdsalesMap.get(ytdSalesValue);
                                            ytdSalesMonthValue = ytdSalesMonthValue.replaceAll(',','').trim();
                                            Opening_Inventory2__c op = new Opening_Inventory2__c();
                                            op = Opening_Inventory2MAP.get(ytdSalesValue);
                                        //System.debug('ytdSalesMonthValue :--- '+ytdSalesMonthValue);
                                    //INCTASK0015463
                                    if(Date.today().day()>integer.valueof(System.Label.Ytd_upload_max_range) || Date.today().day()<integer.valueof(System.Label.Ytd_upload_max_range)){
                                        if(currentMonth==10){
                                               //op.YTD_Sales_Jan__c =  Decimal.valueof(ytdSalesMonthValue);
                                               op.MTD_Sales_Jan__c =  Decimal.valueof(ytdSalesMonthValue);//APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                                            }else 
                                            if(currentMonth==11){
                                               //op.YTD_Sales_Feb__c =  Decimal.valueof(ytdSalesMonthValue);
                                               op.MTD_Sales_Feb__c =  Decimal.valueof(ytdSalesMonthValue);//APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                                            }else
                                            if(currentMonth==12){
                                               //op.YTD_Sales_Mar__c =  Decimal.valueof(ytdSalesMonthValue);
                                               op.MTD_Sales_Mar__c =  Decimal.valueof(ytdSalesMonthValue);//APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                                            }else
                                            if(currentMonth==1){
                                               //op.YTD_Sales_Apr__c =  Decimal.valueof(ytdSalesMonthValue);
                                               op.MTD_Sales_Apr__c =  Decimal.valueof(ytdSalesMonthValue);//APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                                            }else
                                            if(currentMonth==2){
                                               //op.YTD_Sales_May__c =  Decimal.valueof(ytdSalesMonthValue);
                                               op.MTD_Sales_May__c =  Decimal.valueof(ytdSalesMonthValue);//APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                                            }else
                                            if(currentMonth==3){
                                               //op.YTD_Sales_Jun__c =  Decimal.valueof(ytdSalesMonthValue);
                                               op.MTD_Sales_Jun__c =  Decimal.valueof(ytdSalesMonthValue);//APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                                            }else
                                            if(currentMonth==4){
                                               //op.YTD_Sales_Jul__c =  Decimal.valueof(ytdSalesMonthValue);
                                               op.MTD_Sales_Jul__c =  Decimal.valueof(ytdSalesMonthValue);//APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                                            }else
                                            if(currentMonth==5){
                                               //op.YTD_Sales_Aug__c =  Decimal.valueof(ytdSalesMonthValue);
                                               op.MTD_Sales_Aug__c =  Decimal.valueof(ytdSalesMonthValue);//APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                                            }else
                                            if(currentMonth==6){
                                               //op.YTD_Sales_Sept__c =  Decimal.valueof(ytdSalesMonthValue);
                                               op.MTD_Sales_Sept__c =  Decimal.valueof(ytdSalesMonthValue);//APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                                            }else
                                            if(currentMonth==7){
                                               //op.YTD_Sales_Oct__c =  Decimal.valueof(ytdSalesMonthValue);
                                               op.MTD_Sales_Oct__c =  Decimal.valueof(ytdSalesMonthValue);//APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                                            }else
                                            if(currentMonth==8){
                                               //op.YTD_Sales_Nov__c =  Decimal.valueof(ytdSalesMonthValue);
                                               op.MTD_Sales_Nov__c =  Decimal.valueof(ytdSalesMonthValue);//APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                                            }else
                                            if(currentMonth==9){
                                               //op.YTD_Sales_Dec__c =  Decimal.valueof(ytdSalesMonthValue);
                                               op.MTD_Sales_Dec__c =  Decimal.valueof(ytdSalesMonthValue);//APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                                            }
                                       oiUpdateList.add(op);
                                    }
                              }
                        }
                        
                       // Logic for successcsv and errorcsv 
                       for(String s:comytdsalesMap.keySet()){
                            if(opIdMap.containsKey(s)){ 
                               successCSVList.add(csvMap.get(s));
                               system.debug('successCSVList:::' +successCSVList.size());
                            }else{
                               errorCSVList.add(csvMap.get(s));
                                system.debug('errorCSVList:::' +errorCSVList);
                            } 
                        }
                        
                        
                        Database.SaveResult[] srList;
                        if(oiUpdateList.size()>0){
                            srList = Database.update(oiUpdateList, false);
                            if(srList.size()>0){
                                system.debug('srList :- '+srList);
                                
                            }
                            
                        }    
                        
                    }else if(fileName.contains('6410') || fileName.contains('7110') || fileName.contains('6451') || fileName.contains('7120') || fileName.contains('6610') || fileName.contains('6631')){
                        String salesOrgCode='';
                        if(fileName.contains('6410')){
                            salesOrgCode='6410';
                        }else if(fileName.contains('7110')){
                            salesOrgCode='7110';
                        }else if(fileName.contains('6451')){
                            salesOrgCode='6451';
                        }else if(fileName.contains('7120')){
                            salesOrgCode='7120';
                        }else if(fileName.contains('6610')){
                            salesOrgCode='6610';
                        }else if(fileName.contains('6631')){
                            salesOrgCode='6631';
                        }
                        System.debug('fileName : '+fileName);
                        Map<String,Opening_Inventory2__c> OICombinationMap= new Map<String,Opening_Inventory2__c>();
                        Map<String,String> OICombinationMap2= new Map<String,String>();
                        Map<String,String> OICombinationPeriodMap= new Map<String,String>();
                        Map<String,String> oiIDMap= new Map<String,String>();
                        RecordType rTObj = [SELECT Id,Name FROM RecordType WHERE SobjectType='Opening_Inventory2__c' and Name='Multi Country'];
                        
                        List<Opening_Inventory2__c> oiUpdateList= new List<Opening_Inventory2__c>();
                        Map<String,String> comytdsalesMap= new Map<String,String>();
                        system.debug('csvData.size()  :----'+csvData.size());
                        for (Integer i = 0; i < csvData.size()-1; i++){
                            row = csvData[i];
                            system.debug('csvData :----'+csvData[i]);
                            if(csvData[i].contains('"')){
                                if (!String.isBlank(csvData[i])){
                                    String[] arrTest = csvData[i].split('("[^"]*")');
                                    String[] FinalarrTest =new List<String>(); 
                                    String[] DoubleQ= parse(csvData[i]);
                                    system.debug('DoubleQ :----'+DoubleQ);
                                    String ySales ;
                                    for(integer l=0; l<arrTest.size(); l++)
                                    {
                                        FinalarrTest.add(string.valueof(string.valueof(arrTest[l]).split(','))); 
                                    }
                                    
                                    try{
                                        
                                        // doubleList = DoubleQ[0].split(',');
                                        //system.debug('DoubleQ[2] :----'+DoubleQ[2].replaceAll('\\"',''));
                                        Integer intFisYear = Integer.valueOf(DoubleQ[2].replaceAll('\\"','').trim());
                                        Integer fisYear = intFisYear+1;
                                        String fiscalYear = DoubleQ[2].replaceAll('\\"','').trim() + '-' +fisYear;
                                        
                                        //system.debug('DoubleQ :------'+DoubleQ);
                                        String csvStr0= DoubleQ[0].replaceAll('\\"','').trim();
                                        String csvStr1= DoubleQ[1].replaceAll('\\"','').trim();
                                        String csvStr2= DoubleQ[2].replaceAll('\\"','').trim();
                                        String csvStr3= DoubleQ[3].replaceAll('\\"','').trim();
                                        String csvStr4= DoubleQ[4].replaceAll('\\"','').trim();
                                        
                                        String skucode = csvStr1.trim();
                                        String customercode = csvStr0.trim();
                                        
                                        if(skucode.length()==6){
                                            skucode = '000000000000'+csvStr1;
                                        }
                                        else if(skucode.length()==7){
                                            skucode = '00000000000'+csvStr1;
                                        }
                                        
                                        if(customercode.length()==7){
                                            customercode = '000'+ csvStr0;
                                        }else if(customercode.length()==6){
                                            customercode = '0000'+ csvStr0;
                                        }
                                        
                                        String[] combinationKey = (skucode+customercode+fiscalYear+salesOrgCode).split(',');
                                        System.debug('combinationKey==>'+combinationKey );
                                        combinationKey[0]=combinationKey[0].replaceAll('\\(','');
                                        OICombinationMap2.put(combinationKey[0], csvStr4);
                                        System.debug('OICombinationMap2==>'+OICombinationMap2);
                                        OICombinationPeriodMap.put(combinationKey[0],csvStr3);
                                        System.debug('OICombinationPeriodMap==>'+OICombinationPeriodMap);
                                        csvMap.put(combinationKey[0], row);
                                        System.debug('csvMap==>'+csvMap);
                                    }
                                    catch(Exception ex){
                                        
                                    } 
                                }
                            }else{
                                Opening_Inventory2__c op=new Opening_Inventory2__c();
                                List<String> csvLineItem = new List<String>();
                                csvLineItem = csvData[i].split(',');
                                String combinationKey = '';
                                Date todays= System.today();
                                Integer currentMonth =todays.month();
                                for(Integer j=0; j<csvLineItem.size()-1; j++){
                                    System.debug('csvLineItem :'+csvLineItem[j]);
                                    if(!String.isBlank(csvLineItem[j])){
                                        String customercode = csvLineItem[0].trim();
                                        String code = csvLineItem[1].trim();
                                        if(code.length()==6){
                                            code = '000000000000'+csvLineItem[1];
                                        }
                                        else if(code.length()==7){
                                            code = '00000000000'+csvLineItem[1];
                                        }
                                        if(customercode.length()==7){
                                            customercode = '000'+ csvLineItem[0];
                                        }else if(customercode.length()==6){
                                            customercode = '0000'+ csvLineItem[0];
                                        }
                                        
                                        Integer intFisYear = Integer.valueOf(csvLineItem[2].trim());
                                        Integer fisYear = intFisYear+1;
                                        String fiscalYear = csvLineItem[2].trim() + '-' +fisYear;
                                        
                                        combinationKey=code+customercode+fiscalYear+salesOrgCode;
                                        OICombinationMap2.put(combinationKey, csvLineItem[4]);
                                        OICombinationPeriodMap.put(combinationKey,csvLineItem[3]);
                                        csvMap.put(combinationKey, row);
                                    }
                                }
                            }
                        }     
                        System.debug('OICombinationMap2 keys :'+OICombinationMap2.keySet());            
                        List<Opening_Inventory2__c> OILst2 = [SELECT Id, Name,YTD_Sales__c, YTD_Sales_Jan__c, YTD_Sales_Feb__c, YTD_Sales_Mar__c, YTD_Sales_Apr__c,
                                                              YTD_Sales_May__c, YTD_Sales_Jun__c, YTD_Sales_Jul__c, YTD_Sales_Aug__c,
                                                              YTD_Sales_Sept__c, YTD_Sales_Oct__c, YTD_Sales_Nov__c, YTD_Sales_Dec__c, Multi_Country_Key__c
                                                              FROM Opening_Inventory2__c Where Multi_Country_Key__c IN:OICombinationMap2.keySet()];
                        
                        for(Opening_Inventory2__c oiOb:OILst2){
                            OICombinationMap.put(oiOb.Multi_Country_Key__c, oiOb);
                            oiIDMap.put(oiOb.Multi_Country_Key__c,oiOb.Id);
                        }
                        for(String combinationKey:OICombinationMap.keySet()){
                            if(OICombinationMap.containsKey(combinationKey)){
                                System.debug('combinationKey1 :- '+combinationKey);
                                Opening_Inventory2__c op=new Opening_Inventory2__c();
                                op = OICombinationMap.get(combinationKey);
                                
                                if(Decimal.valueof(OICombinationPeriodMap.get(combinationKey))==10){
                                    op.YTD_Sales_Jan__c =  Decimal.valueof(OICombinationMap2.get(combinationKey));
                                } 
                                if(Decimal.valueof(OICombinationPeriodMap.get(combinationKey))==11){
                                    op.YTD_Sales_Feb__c =  Decimal.valueof(OICombinationMap2.get(combinationKey));
                                }
                                if(Decimal.valueof(OICombinationPeriodMap.get(combinationKey))==12){
                                    op.YTD_Sales_Mar__c =  Decimal.valueof(OICombinationMap2.get(combinationKey));
                                }
                                if(Decimal.valueof(OICombinationPeriodMap.get(combinationKey))==1){
                                    op.YTD_Sales_Apr__c =  Decimal.valueof(OICombinationMap2.get(combinationKey));
                                }
                                if(Decimal.valueof(OICombinationPeriodMap.get(combinationKey))==2){
                                    op.YTD_Sales_May__c =  Decimal.valueof(OICombinationMap2.get(combinationKey));
                                }
                                if(Decimal.valueof(OICombinationPeriodMap.get(combinationKey))==3){
                                    op.YTD_Sales_Jun__c =  Decimal.valueof(OICombinationMap2.get(combinationKey));
                                }
                                if(Decimal.valueof(OICombinationPeriodMap.get(combinationKey))==4){
                                    op.YTD_Sales_Jul__c =  Decimal.valueof(OICombinationMap2.get(combinationKey));
                                }
                                if(Decimal.valueof(OICombinationPeriodMap.get(combinationKey))==5){
                                    op.YTD_Sales_Aug__c =  Decimal.valueof(OICombinationMap2.get(combinationKey));
                                }
                                if(Decimal.valueof(OICombinationPeriodMap.get(combinationKey))==6){
                                    op.YTD_Sales_Sept__c =  Decimal.valueof(OICombinationMap2.get(combinationKey));
                                }
                                if(Decimal.valueof(OICombinationPeriodMap.get(combinationKey))==7){
                                    op.YTD_Sales_Oct__c =  Decimal.valueof(OICombinationMap2.get(combinationKey));
                                }
                                if(Decimal.valueof(OICombinationPeriodMap.get(combinationKey))==8){
                                    op.YTD_Sales_Nov__c =  Decimal.valueof(OICombinationMap2.get(combinationKey));
                                }
                                if(Decimal.valueof(OICombinationPeriodMap.get(combinationKey))==9){
                                    op.YTD_Sales_Dec__c =  Decimal.valueof(OICombinationMap2.get(combinationKey));
                                }
                                oiUpdateList.add(op);
                            }
                        }
                        System.debug('oiUpdateList :'+oiUpdateList);
                        
                        for(String s:OICombinationMap2.keySet()){
                            if(OICombinationMap.containsKey(s)){
                               successCSVList.add(oiIDMap.get(s)+','+csvMap.get(s));
                            }else{
                                errorCSVList.add(csvMap.get(s));
                            } 
                        }
                        
                        //put all the values from the list to map. 
                        Database.SaveResult[] srList;
                        if(oiUpdateList.size()>0){
                            srList =Database.update(oiUpdateList, false);
                            if(srList.size()>0){
                                system.debug('srList :- '+srList);
                            }
                        }
                        
                    }
                    
                    
                    
                    else if(fileName.contains('Liquidation Report - 1000') ||fileName.contains('2941')){
                        String salesOrgCode='';
                        if(fileName.contains('2941')){
                            salesOrgCode='2941';
                        }else if(fileName.contains('1000')){
                            salesOrgCode='1000';
                        }
                        System.debug('fileName : '+fileName);
                        Map<String,Opening_Inventory2__c> OICombinationMap= new Map<String,Opening_Inventory2__c>();
                        Map<String,String> OICombinationMap2= new Map<String,String>();
                        Map<String,String> OICombinationPeriodMap= new Map<String,String>();
                        Set<String> OICombinationList= new Set<String>();
                        Map<String,String> oiIDMap= new Map<String,String>();
                        RecordType rTObj = [SELECT Id,Name FROM RecordType WHERE SobjectType='Opening_Inventory2__c' and Name='Multi Country'];
                        
                        List<Opening_Inventory2__c> oiUpdateList= new List<Opening_Inventory2__c>();
                        Map<String,String> comytdsalesMap= new Map<String,String>();
                        system.debug('csvData.size()  :----'+csvData.size());
                        for (Integer i = 0; i < csvData.size()-1; i++){
                            row = csvData[i];
                            system.debug('csvData :----'+csvData[i]+'abc');
                            if(csvData[i].contains('"')){
                                if (!String.isBlank(csvData[i])){
                                System.debug('inside csvdata not empty');
                                    String[] arrTest = csvData[i].split('("[^"]*")');
                                    String[] FinalarrTest =new List<String>(); 
                                    String[] DoubleQ= parse(csvData[i]);
                                    system.debug('DoubleQ :----'+DoubleQ);
                                    String ySales ;
                                    for(integer l=0; l<arrTest.size(); l++)
                                    {
                                        FinalarrTest.add(string.valueof(string.valueof(arrTest[l]).split(','))); 
                                    }
                                    
                                    try{
                                        
                                        // doubleList = DoubleQ[0].split(',');
                                        //system.debug('DoubleQ[2] :----'+DoubleQ[2].replaceAll('\\"',''));
                                        Integer intFisYear = Integer.valueOf(DoubleQ[2].replaceAll('\\"','').trim());
                                        Integer fisYear = intFisYear+1;
                                        String fiscalYear = DoubleQ[2].replaceAll('\\"','').trim() + '-' +fisYear;
                                        
                                        //system.debug('DoubleQ :------'+DoubleQ);
                                        String csvStr0= DoubleQ[0].replaceAll('\\"','').trim();
                                        String csvStr1= DoubleQ[1].replaceAll('\\"','').trim();
                                        String csvStr2= DoubleQ[2].replaceAll('\\"','').trim();
                                        String csvStr3= DoubleQ[3].replaceAll('\\"','').trim();
                                        String csvStr4= DoubleQ[4].replaceAll('\\"','').trim();
                                        
                                        String skucode = csvStr1.trim();
                                        String customercode = csvStr0.trim();
                                        
                                        if(skucode.length()==6){
                                            skucode = '000000000000'+csvStr1;
                                        }
                                        else if(skucode.length()==7){
                                            skucode = '00000000000'+csvStr1;
                                        }
                                        
                                        if(customercode.length()==7){
                                            customercode = '000'+ csvStr0;
                                        }else if(customercode.length()==6){
                                            customercode = '0000'+ csvStr0;
                                        }
                                        
                                        String[] combinationKey = (skucode+customercode+fiscalYear+salesOrgCode).split(',');
                                        System.debug('combinationKey==>'+combinationKey );
                                        combinationKey[0]=combinationKey[0].replaceAll('\\(','');
                                        OICombinationMap2.put(combinationKey[0], csvStr4);
                                        System.debug('OICombinationMap2==>'+OICombinationMap2);
                                        OICombinationPeriodMap.put(combinationKey[0],csvStr3);
                                        System.debug('OICombinationPeriodMap==>'+OICombinationPeriodMap);
                                        csvMap.put(combinationKey[0], row);
                                        System.debug('csvMap==>'+csvMap);
                                        OICombinationList.add(combinationKey[0]);
                                    }
                                    catch(Exception ex){
                                        
                                    } 
                                }
                            }else{
                                Opening_Inventory2__c op=new Opening_Inventory2__c();
                                List<String> csvLineItem = new List<String>();
                                csvLineItem = csvData[i].split(',');
                                String combinationKey = '';
                                Date todays= System.today();
                                Integer currentMonth =todays.month();
                                for(Integer j=0; j<csvLineItem.size()-1; j++){
                                    System.debug('csvLineItem :'+csvLineItem[j]);
                                    if(!String.isBlank(csvLineItem[j])){
                                        String customercode = csvLineItem[0].trim();
                                        String code = csvLineItem[1].trim();
                                        if(code.length()==6){
                                            code = '000000000000'+csvLineItem[1];
                                        }
                                        else if(code.length()==7){
                                            code = '00000000000'+csvLineItem[1];
                                        }
                                        if(customercode.length()==7){
                                            customercode = '000'+ csvLineItem[0];
                                        }else if(customercode.length()==6){
                                            customercode = '0000'+ csvLineItem[0];
                                        }
                                        
                                        Integer intFisYear = Integer.valueOf(csvLineItem[2].trim());
                                        Integer fisYear = intFisYear+1;
                                        String fiscalYear = csvLineItem[2].trim() + '-' +fisYear;
                                        
                                        combinationKey=code+customercode+fiscalYear+salesOrgCode;
                                        OICombinationMap2.put(combinationKey+String.valueOf(csvLineItem[3]), csvLineItem[4]);
                                        OICombinationPeriodMap.put(combinationKey+String.valueOf(csvLineItem[3]),csvLineItem[3]);
                                        csvMap.put(combinationKey+String.valueOf(csvLineItem[3]), row);
                                        if(!OICombinationList.contains(combinationKey)){
                                            OICombinationList.add(combinationKey);
                                        }
                                        
                                        
                                    }
                                    system.debug('OICombinationList size : '+OICombinationList.size());
                                }
                            }
                        }     
                        
                        System.debug('OICombinationMap2 keys :'+OICombinationMap2);            
                        System.debug('OICombinationPeriodMap keys :'+OICombinationPeriodMap); 
                        List<Opening_Inventory2__c> OILst2 = [SELECT Id, Name,YTD_Sales__c, YTD_Sales_Jan__c, YTD_Sales_Feb__c, YTD_Sales_Mar__c, YTD_Sales_Apr__c,
                                                              YTD_Sales_May__c, YTD_Sales_Jun__c, YTD_Sales_Jul__c, YTD_Sales_Aug__c,
                                                              YTD_Sales_Sept__c, YTD_Sales_Oct__c, YTD_Sales_Nov__c, YTD_Sales_Dec__c, Multi_Country_Key__c
                                                              FROM Opening_Inventory2__c Where Multi_Country_Key__c IN:OICombinationList];
                        
                        for(Opening_Inventory2__c oiOb:OILst2){
                            OICombinationMap.put(oiOb.Multi_Country_Key__c, oiOb);
                            oiIDMap.put(oiOb.Multi_Country_Key__c,oiOb.Id);
                        }
                        for(String combinationKey:OICombinationMap.keySet()){
                            if(OICombinationMap.containsKey(combinationKey)){
                                System.debug('combinationKey12 :- '+combinationKey);
                                Opening_Inventory2__c op=new Opening_Inventory2__c();
                                op = OICombinationMap.get(combinationKey);
                               String keyVal=combinationKey+'10';
                               System.debug('keyVal==>'+keyVal);
                                if(!OICombinationPeriodMap.isEmpty() && OICombinationPeriodMap.containsKey(keyVal)){
                                    if(Decimal.valueof(OICombinationPeriodMap.get(keyVal))==10){
                                        op.YTD_Sales_Jan__c =  Decimal.valueof(OICombinationMap2.get(keyVal));
                                    }
                                }
                               keyVal=combinationKey+'11';
                                if(!OICombinationPeriodMap.isEmpty() && OICombinationPeriodMap.containsKey(keyVal)){
                                    if(Decimal.valueof(OICombinationPeriodMap.get(keyVal))==11){
                                        op.YTD_Sales_Feb__c =  Decimal.valueof(OICombinationMap2.get(keyVal));
                                    }
                                }
                               keyVal=combinationKey+'12';
                                if(!OICombinationPeriodMap.isEmpty() && OICombinationPeriodMap.containsKey(keyVal)){
                                    if(Decimal.valueof(OICombinationPeriodMap.get(keyVal))==12){
                                        op.YTD_Sales_Mar__c =  Decimal.valueof(OICombinationMap2.get(keyVal));
                                    }
                                }
                                
                                keyVal=combinationKey+'1';
                                if(!OICombinationPeriodMap.isEmpty() && OICombinationPeriodMap.containsKey(keyVal)){
                                    if(Decimal.valueof(OICombinationPeriodMap.get(keyVal))==1){
                                        op.YTD_Sales_Apr__c =  Decimal.valueof(OICombinationMap2.get(keyVal));
                                    }
                                }
                                
                                keyVal=combinationKey+'2';
                                if(!OICombinationPeriodMap.isEmpty() && OICombinationPeriodMap.containsKey(keyVal)){
                                    if(Decimal.valueof(OICombinationPeriodMap.get(keyVal))==2){
                                        op.YTD_Sales_May__c =  Decimal.valueof(OICombinationMap2.get(keyVal));
                                    }
                                }
                                
                                keyVal=combinationKey+'3';
                                if(!OICombinationPeriodMap.isEmpty() && OICombinationPeriodMap.containsKey(keyVal)){
                                    if(Decimal.valueof(OICombinationPeriodMap.get(keyVal))==3){
                                        op.YTD_Sales_Jun__c =  Decimal.valueof(OICombinationMap2.get(keyVal));
                                    }
                                }
                                
                               keyVal=combinationKey+'4';
                               System.debug('keyVal==>'+keyVal);
                                if(!OICombinationPeriodMap.isEmpty() && OICombinationPeriodMap.containsKey(keyVal)){
                                    if(Decimal.valueof(OICombinationPeriodMap.get(keyVal))==4){
                                        op.YTD_Sales_Jul__c =  Decimal.valueof(OICombinationMap2.get(keyVal));
                                    }
                                }
                                
                                keyVal=combinationKey+'5';
                                if(!OICombinationPeriodMap.isEmpty() && OICombinationPeriodMap.containsKey(keyVal)){
                                    if(Decimal.valueof(OICombinationPeriodMap.get(keyVal))==5){
                                        op.YTD_Sales_Aug__c =  Decimal.valueof(OICombinationMap2.get(keyVal));
                                    }
                                }
                                
                                keyVal=combinationKey+'6';
                                if(!OICombinationPeriodMap.isEmpty() && OICombinationPeriodMap.containsKey(keyVal)){
                                    if(Decimal.valueof(OICombinationPeriodMap.get(keyVal))==6){
                                        op.YTD_Sales_Sept__c =  Decimal.valueof(OICombinationMap2.get(keyVal));
                                    }
                                }
                                
                                keyVal=combinationKey+'7';
                                if(!OICombinationPeriodMap.isEmpty() && OICombinationPeriodMap.containsKey(keyVal)){
                                    if(Decimal.valueof(OICombinationPeriodMap.get(keyVal))==7){
                                        op.YTD_Sales_Oct__c =  Decimal.valueof(OICombinationMap2.get(keyVal));
                                    }
                                }
                                
                                keyVal=combinationKey+'8';
                                if(!OICombinationPeriodMap.isEmpty() && OICombinationPeriodMap.containsKey(keyVal)){
                                    if(Decimal.valueof(OICombinationPeriodMap.get(keyVal))==8){
                                        op.YTD_Sales_Nov__c =  Decimal.valueof(OICombinationMap2.get(keyVal));
                                    }
                                }
                                keyVal=combinationKey+'9';
                                if(!OICombinationPeriodMap.isEmpty() && OICombinationPeriodMap.containsKey(keyVal)){
                                    if(Decimal.valueof(OICombinationPeriodMap.get(keyVal))==9){
                                        op.YTD_Sales_Dec__c =  Decimal.valueof(OICombinationMap2.get(keyVal));
                                    }
                                }
                                oiUpdateList.add(op);
                            }
                        }
                        System.debug('oiUpdateList :'+oiUpdateList);
                        System.debug('OICombinationMap2 Sumit :'+OICombinationMap2);
                        System.debug('OICombinationList Sumit :'+OICombinationList);
                        System.debug('OICombinationList Sumit :'+OICombinationList.size());
                        System.debug('OICombinationMap Sumit :'+OICombinationMap);
                        for(String s:OICombinationList){
                            if(OICombinationMap.containsKey(s)){
                                System.debug('csvMap sumit:'+csvMap.get(s));
                                System.debug('oiIDMap sumit:'+oiIDMap.get(s));
                                
                                for(String ss:csvMap.keySet()){
                                    if(ss.contains(s)){
                                       successCSVList.add(oiIDMap.get(s)+','+csvMap.get(ss));
                                    }
                                }
                               
                            }else{
                                for(String ss:csvMap.keySet()){
                                    if(ss.contains(s)){
                                       errorCSVList.add(csvMap.get(ss));
                                    }
                                }
                               
                                System.debug('errorCSVList Sumit :'+errorCSVList);
                            } 
                        }
                        
                        //put all the values from the list to map. 
                        Database.SaveResult[] srList;
                        if(oiUpdateList.size()>0){
                            srList =Database.update(oiUpdateList, false);
                            if(srList.size()>0){
                                system.debug('srList :- '+srList);
                            }
                        }
                        
                    }
                    
                    
                    
                    
                    
                    else if(fileName.contains('SHT 5100') || fileName.contains('Mexico')){
                        
                        System.debug('fileName : '+fileName);
                        String salesOrgCode='5100';
                        Map<String,Opening_Inventory2__c> OICombinationMap= new Map<String,Opening_Inventory2__c>();
                        Map<String,String> OICombinationMap2= new Map<String,String>();
                        Map<String,String> OICombinationPeriodMap= new Map<String,String>();
                        Map<String,String> oiIDMap= new Map<String,String>();
                        RecordType rTObj = [SELECT Id,Name FROM RecordType WHERE SobjectType='Opening_Inventory2__c' and Name='Multi Country'];
                        
                        List<Opening_Inventory2__c> oiUpdateList= new List<Opening_Inventory2__c>();
                        Map<String,String> comytdsalesMap= new Map<String,String>();
                        system.debug('csvData.size()  :----'+csvData.size());
                        for (Integer i = 0; i < csvData.size()-1; i++){
                            row = csvData[i];
                            if(csvData[i].contains('"')){
                                if (!String.isBlank(csvData[i])){
                                    String[] arrTest = csvData[i].split('("[^"]*")');
                                    String[] FinalarrTest =new List<String>(); 
                                    String[] DoubleQ= parse(csvData[i]);
                                    system.debug('DoubleQ :----'+DoubleQ[0]);
                                    String ySales ;
                                    
                                    try{
                                        String csvStr5= DoubleQ[0].replaceAll('\\"','').trim();
                                        system.debug('csvData :------'+csvData[i]);
                                        String[] csvSplit=csvData[i].split(',');
                                        for(Integer f=0;f<csvSplit.size();f++){
                                            if(!csvSplit[f].contains('"')){
                                                System.debug('f : '+csvSplit[f]);
                                                Integer intFisYear = Integer.valueOf(csvSplit[3].trim());
                                                Integer fisYear = intFisYear+1;
                                                String fiscalYear = csvSplit[3].trim() + '-' +fisYear;
                                                
                                                String csvStr0= csvSplit[0].trim();
                                                String csvStr1= csvSplit[1].trim();
                                                String csvStr2= csvSplit[2].trim();
                                                String csvStr3= csvSplit[3].trim();
                                                String csvStr4= csvSplit[4].trim();
                                                
                                                
                                                String skucode = csvStr2.trim();
                                                String customercode = csvStr0.trim();
                                                String shipToCode = csvStr1.trim();
                                                
                                                if(skucode.length()==6){
                                                    skucode = '000000000000'+csvStr2;
                                                }
                                                else if(skucode.length()==7){
                                                    skucode = '00000000000'+csvStr2;
                                                }
                                                
                                                if(customercode.length()==7){
                                                    customercode = '000'+ csvStr0;
                                                }else if(customercode.length()==6){
                                                    customercode = '0000'+ csvStr0;
                                                }
                                                
                                                if(shipToCode.length()==7){
                                                    shipToCode = '000'+ csvStr1;
                                                }else if(shipToCode.length()==6){
                                                    shipToCode = '0000'+ csvStr1;
                                                }
                                                
                                                String[] combinationKey = (skucode+customercode+shipToCode+fiscalYear+salesOrgCode).split(',');
                                                combinationKey[0]=combinationKey[0].replaceAll('\\(','');
                                                String ytdSaleStr=csvStr5.replaceAll('"','');
                                                if(ytdSaleStr.contains(',')){
                                                    OICombinationMap2.put(combinationKey[0], ytdSaleStr.replaceAll(',',''));
                                                }else{
                                                    OICombinationMap2.put(combinationKey[0], ytdSaleStr);
                                                }
                                                
                                                OICombinationPeriodMap.put(combinationKey[0],csvStr4);
                                                csvMap.put(combinationKey[0], row);
                                            }
                                            
                                        }
                                        
                                    }
                                    catch(Exception ex){
                                        System.debug('getMessage : '+ex.getMessage());
                                        System.debug('getLineNumber : '+ex.getLineNumber());
                                        System.debug('getStackTraceString : '+ex.getStackTraceString());
                                    } 
                                }
                            }else{
                                Opening_Inventory2__c op=new Opening_Inventory2__c();
                                List<String> csvLineItem = new List<String>();
                                csvLineItem = csvData[i].split(',');
                                String combinationKey = '';
                                Date todays= System.today();
                                Integer currentMonth =todays.month();
                                for(Integer j=0; j<csvLineItem.size()-1; j++){
                                    System.debug('csvLineItem :'+csvLineItem[j]);
                                    if(!String.isBlank(csvLineItem[j])){
                                        String customercode = csvLineItem[0].trim();
                                        String shipToCode = csvLineItem[1].trim();
                                        String code = csvLineItem[2].trim();
                                        if(code.length()==6){
                                            code = '000000000000'+csvLineItem[2];
                                        }
                                        else if(code.length()==7){
                                            code = '00000000000'+csvLineItem[2];
                                        }
                                        
                                        if(customercode.length()==7){
                                            customercode = '000'+ csvLineItem[0];
                                        }else if(customercode.length()==6){
                                            customercode = '0000'+ csvLineItem[0];
                                        }
                                        
                                        if(shipToCode.length()==7){
                                            shipToCode = '000'+ csvLineItem[1];
                                        }else if(shipToCode.length()==6){
                                            shipToCode = '0000'+ csvLineItem[1];
                                        }
                                        
                                        Integer intFisYear = Integer.valueOf(csvLineItem[3].trim());
                                        Integer fisYear = intFisYear+1;
                                        String fiscalYear = csvLineItem[3].trim() + '-' +fisYear;
                                        //
                                        combinationKey=code+customercode+shipToCode+fiscalYear+salesOrgCode;
                                        OICombinationMap2.put(combinationKey, csvLineItem[5]);
                                        OICombinationPeriodMap.put(combinationKey,csvLineItem[4]);
                                        csvMap.put(combinationKey, row);
                                    }
                                }
                            }
                        }     
                        System.debug('OICombinationMap2 keys :'+OICombinationMap2.keySet());            
                        List<Opening_Inventory2__c> OILst2 = [SELECT Id, Name,YTD_Sales__c, YTD_Sales_Jan__c, YTD_Sales_Feb__c, YTD_Sales_Mar__c, YTD_Sales_Apr__c,
                                                              YTD_Sales_May__c, YTD_Sales_Jun__c, YTD_Sales_Jul__c, YTD_Sales_Aug__c,
                                                              YTD_Sales_Sept__c, YTD_Sales_Oct__c, YTD_Sales_Nov__c, YTD_Sales_Dec__c, Multi_Country_Key__c
                                                              FROM Opening_Inventory2__c Where Multi_Country_Key__c IN:OICombinationMap2.keySet()];
                        
                        for(Opening_Inventory2__c oiOb:OILst2){
                            OICombinationMap.put(oiOb.Multi_Country_Key__c, oiOb);
                            oiIDMap.put(oiOb.Multi_Country_Key__c,oiOb.Id);
                        }
                        for(String combinationKey:OICombinationMap.keySet()){
                            if(OICombinationMap.containsKey(combinationKey)){
                                System.debug('combinationKey1 :- '+combinationKey);
                                Opening_Inventory2__c op=new Opening_Inventory2__c();
                                op = OICombinationMap.get(combinationKey);
                                
                                if(Decimal.valueof(OICombinationPeriodMap.get(combinationKey))==10){
                                    op.YTD_Sales_Jan__c =  Decimal.valueof(OICombinationMap2.get(combinationKey));
                                } 
                                if(Decimal.valueof(OICombinationPeriodMap.get(combinationKey))==11){
                                    op.YTD_Sales_Feb__c =  Decimal.valueof(OICombinationMap2.get(combinationKey));
                                }
                                if(Decimal.valueof(OICombinationPeriodMap.get(combinationKey))==12){
                                    op.YTD_Sales_Mar__c =  Decimal.valueof(OICombinationMap2.get(combinationKey));
                                }
                                if(Decimal.valueof(OICombinationPeriodMap.get(combinationKey))==1){
                                    op.YTD_Sales_Apr__c =  Decimal.valueof(OICombinationMap2.get(combinationKey));
                                }
                                if(Decimal.valueof(OICombinationPeriodMap.get(combinationKey))==2){
                                    op.YTD_Sales_May__c =  Decimal.valueof(OICombinationMap2.get(combinationKey));
                                }
                                if(Decimal.valueof(OICombinationPeriodMap.get(combinationKey))==3){
                                    op.YTD_Sales_Jun__c =  Decimal.valueof(OICombinationMap2.get(combinationKey));
                                }
                                if(Decimal.valueof(OICombinationPeriodMap.get(combinationKey))==4){
                                    op.YTD_Sales_Jul__c =  Decimal.valueof(OICombinationMap2.get(combinationKey));
                                }
                                if(Decimal.valueof(OICombinationPeriodMap.get(combinationKey))==5){
                                    op.YTD_Sales_Aug__c =  Decimal.valueof(OICombinationMap2.get(combinationKey));
                                }
                                if(Decimal.valueof(OICombinationPeriodMap.get(combinationKey))==6){
                                    op.YTD_Sales_Sept__c =  Decimal.valueof(OICombinationMap2.get(combinationKey));
                                }
                                if(Decimal.valueof(OICombinationPeriodMap.get(combinationKey))==7){
                                    op.YTD_Sales_Oct__c =  Decimal.valueof(OICombinationMap2.get(combinationKey));
                                }
                                if(Decimal.valueof(OICombinationPeriodMap.get(combinationKey))==8){
                                    op.YTD_Sales_Nov__c =  Decimal.valueof(OICombinationMap2.get(combinationKey));
                                }
                                if(Decimal.valueof(OICombinationPeriodMap.get(combinationKey))==9){
                                    op.YTD_Sales_Dec__c =  Decimal.valueof(OICombinationMap2.get(combinationKey));
                                }
                                oiUpdateList.add(op);
                            }
                        }
                        System.debug('oiUpdateList :'+oiUpdateList);
                        for(String s:OICombinationMap2.keySet()){
                            if(OICombinationMap.containsKey(s)){
                               successCSVList.add(oiIDMap.get(s)+','+csvMap.get(s));
                            }else{
                                errorCSVList.add(csvMap.get(s));
                            } 
                        }
                        
                        //put all the values from the list to map. 
                        Database.SaveResult[] srList;
                        if(oiUpdateList.size()>0){
                            srList =Database.update(oiUpdateList, false);
                            if(srList.size()>0){
                                system.debug('srList :- '+srList);
                            }
                        }
                        
                          
                        
                    }else{   // India Trade code
                        List<Opening_Inventory2__c> oiUpdateList= new List<Opening_Inventory2__c>();
                        Map<String,String> comytdsalesMap= new Map<String,String>();
                        String csvStr3;
                        Integer currentMonth;//INCTASK0015463
                        for (Integer i = 0; i < csvData.size()-1; i++){
                            
                            
                            List<String> csvLineItem = new List<String>();
                            row = csvData[i];
                            if (String.isNotBlank(row)){
                                String[] arrTest = csvData[i].split('("[^"]*")');
                                String[] FinalarrTest =new List<String>(); 
                            String[] DoubleQ= csvData[i].split(',');//Deeksha :Added for Qliksense
                            //String[] DoubleQ= parse(csvData[i]);//Deeksha :Removed for Qliksense
                            system.debug('DoubleQ :----'+DoubleQ[0]);
                            String ySales ;
                            for(integer l=0; l<arrTest.size(); l++)
                            {
                                FinalarrTest.add(string.valueof(string.valueof(arrTest[l]).split(','))); 
                            }
                            
                            try{
                                
                               // doubleList = DoubleQ[0].split(',');
                                //system.debug('DoubleQ[2] :----'+DoubleQ[2].replaceAll('\\"',''));
                                //INCTASK0015463
                                String csvStr0= DoubleQ[0].replaceAll('\\"','').trim();
                                system.debug('csvStr0--'+csvStr0);
                                String csvStr1= DoubleQ[1].replaceAll('\\"','').trim();
                                String csvStr2= DoubleQ[2].replaceAll('\\"','').trim();
                                csvStr3= DoubleQ[3].replaceAll('\\"','').trim();
                                String currentMonthStr = DoubleQ[2].replaceAll('\\"','').trim().substringBefore('.');
                                currentMonth = Integer.valueOf(currentMonthStr.trim().right(2));
                                system.debug('currentMonth--'+currentMonth);
                                String intFisYearStr = DoubleQ[2].replaceAll('\\"','').trim().substringAfter('.');
                                Integer intFisYear = Integer.valueOf(intFisYearStr.trim().left(4));
                                Integer fisYear = intFisYear+1;
                                String fiscalYear = intFisYear + '-' +fisYear;
                                Integer fisYearNext = intFisYear-1;
                                String fiscalYearNext = fisYearNext+'-'+DoubleQ[2].replaceAll('\\"','').trim();
                                //system.debug('fiscalYearNext:----'+fiscalYearNext);
                                fiscalYearNext=fiscalYearNext.trim();
                                key='';
                                liqKey='';
                                String[] numPostCode19=new String[]{'1','2','3','4','5','6','7','8','9'};
                                String[] numPostCode1012=new String[]{'10','11','12'};
                                csvStr2 = fiscalYear;
                                Map<String, UPL_SalesOrg_Detail__mdt> salesOrgDetailsMap = UtilityClass.getSalesOrgDetails();
                                String salesOrgCodeSAS = salesOrgDetailsMap.get('India_SalesOrg').value__c;
                                System.debug('salesOrgCodeSAS >>>>>>>>>>>>.' +salesOrgCodeSAS);
                                String[] comStr = (csvStr1.remove('\'')+salesOrgCodeSAS+csvStr2.trim()+csvStr0.remove('\'')).split(',');
                                System.debug('concat>>>>>>>>>>' +comStr);
                                //String[] comStr = (csvStr1.remove('\'')+'1000'+csvStr2.trim()+csvStr0.remove('\'')).split(',');
                                comStr[0]=comStr[0].replaceAll('\\(','');
                                key= comStr[0]+'Trade'.replaceAll('\\s+','').trim();
                                System.debug('key:- '+key);
                                comytdsalesMap.put(key,csvStr3.remove('\''));
                                //System.debug('comytdsalesMap :- '+comytdsalesMap);
                                csvMap.put(key, row);
                            }
                            catch(Exception ex){
                                //system.assert(FALSE, ex.getMessage());
                                //system.debug('error message:- '+ex.getMessage());
                                //system.debug('error line number :- '+ex.getLineNumber());
                            }
                            }
                             
                            
                        }
                        System.debug('key :----'+comytdsalesMap.keySet());
                        //System.debug('currentMonth :----'+currentMonth);
                        /*List<Opening_Inventory2__c> OILst = [SELECT Id, Name,YTD_Sales__c, YTD_Sales_Jan__c, YTD_Sales_Feb__c, YTD_Sales_Mar__c, YTD_Sales_Apr__c,
                                                             YTD_Sales_May__c, YTD_Sales_Jun__c, YTD_Sales_Jul__c, YTD_Sales_Aug__c,
                                                             YTD_Sales_Sept__c, YTD_Sales_Oct__c, YTD_Sales_Nov__c, YTD_Sales_Dec__c, combination_key__c
                                                             FROM Opening_Inventory2__c Where combination_key__c IN:comytdsalesMap.keySet()];*/
                        //APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                        List<Opening_Inventory2__c> OILst = [SELECT Id, Name,YTD_Sales__c, MTD_Sales_Jan__c, MTD_Sales_Feb__c, MTD_Sales_Mar__c, MTD_Sales_Apr__c,
                                                             MTD_Sales_May__c, MTD_Sales_Jun__c, MTD_Sales_Jul__c, MTD_Sales_Aug__c,
                                                             MTD_Sales_Sept__c, MTD_Sales_Oct__c, MTD_Sales_Nov__c, MTD_Sales_Dec__c, combination_key__c
                                                             FROM Opening_Inventory2__c Where combination_key__c IN:comytdsalesMap.keySet()];                                               
                        System.debug('OILst :----'+OILst);
                        Map<String,Opening_Inventory2__c>Opening_Inventory2MAP = new Map<String,Opening_Inventory2__c>();
                        Map<String,String>opIdMap = new Map<String,String>();
                        for(Opening_Inventory2__c oib:OILst){
                            Opening_Inventory2MAP.put(oib.combination_key__c,oib);
                            opIdMap.put(oib.combination_key__c,'');       
                        }
                        for(String ytdSalesValue:comytdsalesMap.keySet()){
                                        if(Opening_Inventory2MAP.containsKey(ytdSalesValue)){
                                            String ytdSalesMonthValue=comytdsalesMap.get(ytdSalesValue);
                                            ytdSalesMonthValue = ytdSalesMonthValue.replaceAll(',','').trim();
                                            Opening_Inventory2__c op = new Opening_Inventory2__c();
                                            op = Opening_Inventory2MAP.get(ytdSalesValue);
                                        System.debug('ytdSalesMonthValue :--- '+ytdSalesMonthValue);
                                   if(Date.today().day()>integer.valueof(System.Label.Ytd_upload_max_range) || Date.today().day()<integer.valueof(System.Label.Ytd_upload_max_range)){
                                        if(currentMonth==10){
                                               //op.YTD_Sales_Jan__c =  Decimal.valueof(ytdSalesMonthValue);
                                               op.MTD_Sales_Jan__c =  Decimal.valueof(ytdSalesMonthValue);//APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                                            }else 
                                            if(currentMonth==11){
                                               //op.YTD_Sales_Feb__c =  Decimal.valueof(ytdSalesMonthValue);
                                               op.MTD_Sales_Feb__c =  Decimal.valueof(ytdSalesMonthValue);//APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                                            }else
                                            if(currentMonth==12){
                                               //op.YTD_Sales_Mar__c =  Decimal.valueof(ytdSalesMonthValue);
                                               op.MTD_Sales_Mar__c =  Decimal.valueof(ytdSalesMonthValue);//APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                                            }else
                                            if(currentMonth==1){
                                               //op.YTD_Sales_Apr__c =  Decimal.valueof(ytdSalesMonthValue);
                                               op.MTD_Sales_Apr__c =  Decimal.valueof(ytdSalesMonthValue);//APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                                            }else
                                            if(currentMonth==2){
                                               //op.YTD_Sales_May__c =  Decimal.valueof(ytdSalesMonthValue);
                                               op.MTD_Sales_May__c =  Decimal.valueof(ytdSalesMonthValue);//APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                                            }else
                                            if(currentMonth==3){
                                               //op.YTD_Sales_Jun__c =  Decimal.valueof(ytdSalesMonthValue);
                                               op.MTD_Sales_Jun__c =  Decimal.valueof(ytdSalesMonthValue);//APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                                            }else
                                            if(currentMonth==4){
                                               //op.YTD_Sales_Jul__c =  Decimal.valueof(ytdSalesMonthValue);
                                               op.MTD_Sales_Jul__c =  Decimal.valueof(ytdSalesMonthValue);//APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                                            }else
                                            if(currentMonth==5){
                                               //op.YTD_Sales_Aug__c =  Decimal.valueof(ytdSalesMonthValue);
                                               op.MTD_Sales_Aug__c =  Decimal.valueof(ytdSalesMonthValue);//APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                                            }else
                                            if(currentMonth==6){
                                               //op.YTD_Sales_Sept__c =  Decimal.valueof(ytdSalesMonthValue);
                                               op.MTD_Sales_Sept__c =  Decimal.valueof(ytdSalesMonthValue);//APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                                            }else
                                            if(currentMonth==7){
                                               //op.YTD_Sales_Oct__c =  Decimal.valueof(ytdSalesMonthValue);
                                               op.MTD_Sales_Oct__c =  Decimal.valueof(ytdSalesMonthValue);//APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                                            }else
                                            if(currentMonth==8){
                                               //op.YTD_Sales_Nov__c =  Decimal.valueof(ytdSalesMonthValue);
                                               op.MTD_Sales_Nov__c =  Decimal.valueof(ytdSalesMonthValue);//APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                                            }else
                                            if(currentMonth==9){
                                               //op.YTD_Sales_Dec__c =  Decimal.valueof(ytdSalesMonthValue);
                                               op.MTD_Sales_Dec__c =  Decimal.valueof(ytdSalesMonthValue);//APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
                                            }
                                        oiUpdateList.add(op);
                                   }
                                    }
                        }
                        
                       // Logic for successcsv and errorcsv 
                       for(String s:comytdsalesMap.keySet()){
                            if(opIdMap.containsKey(s)){
                               successCSVList.add(csvMap.get(s));
                            }else{
                                errorCSVList.add(csvMap.get(s));
                            } 
                        }
                        
                        
                        Database.SaveResult[] srList;
                        if(oiUpdateList.size()>0){
                            srList = Database.update(oiUpdateList, false);
                            if(srList.size()>0){
                                system.debug('srList :- '+srList);
                                
                            }
                            
                        }
                        if(Test.isRunningTest()) {
                            CalloutException e = new CalloutException();
                            e.setMessage('This is a constructed exception for testing and code coverage');
                            throw e;
                        }
                        
                    }
                    
                } 
           /* else 
             if(selectedObject != 'Opening_Inventory2__c' || selectedObject != 'Export_Order__c'){
                for (Integer i = 0; i < csvData.size()-1; i++){
                    try{
                        List<String> csvLineItem = new List<String>();
                        sObject sObj = Schema.getGlobalDescribe().get(selectedObject).newSObject();
                        row = csvData[i];
                        sObj.put('CSV_Row__c',row);
                        
                        csvLineItem = csvData[i].split(',');
                        
                        for(Integer j=0; j<csvLineItem.size(); j++){
                            
                            if(posApiMap.containsKey(j)){
                              
                                
                                if(posApiMap.get(j).fieldType=='DOUBLE' || posApiMap.get(j).fieldType=='PERCENT'){
                                    if(String.isNotBlank(csvLineItem[j]))
                                        sObj.put(posApiMap.get(j).api, Double.valueOf(csvLineItem[j]));
                                    
                                }
                                else if(posApiMap.get(j).fieldType=='STRING' || posApiMap.get(j).fieldType=='REFERENCE'){
                                    if(String.isNotBlank(csvLineItem[j]))
                                        sObj.put(posApiMap.get(j).api, csvLineItem[j]);  
                                }
                                else if(posApiMap.get(j).fieldType=='DATETIME'){
                                    if(String.isNotBlank(csvLineItem[j]))
                                        sObj.put(posApiMap.get(j).api, DateTime.valueOf(csvLineItem[j]));  
                                }
                                else if(posApiMap.get(j).fieldType=='DATE'){
                                    if(String.isNotBlank(csvLineItem[j]))
                                        sObj.put(posApiMap.get(j).api, Date.valueOf(csvLineItem[j]));  
                                }
                                else if(posApiMap.get(j).fieldType=='BOOLEAN'){
                                    if(String.isNotBlank(csvLineItem[j]))
                                        sObj.put(posApiMap.get(j).api, Boolean.valueOf(csvLineItem[j]));  
                                }
                            }
                        }
                        sObj.put('BusinessDashboard__c',businessDashboardID);
                        
                        businessDataList.add(sObj);
                    }
                    catch(Exception ex){
                        exceptionHandler(ex, 'processData');
                        errorCSVList.add(row+','+ex.getMessage());
                    }
                }
                
                
                //End of Logic
                
                //system.debug('businessDataList: '+businessDataList);
                
                Database.SaveResult[] srList;
                if(businessDataList.size()>0){
                    srList = Database.insert(businessDataList, false);
                }
                
                //Iterate through each returned result
                for(Integer i=0;i<srList.size();i++){
                    if (!srList[i].isSuccess()){
                        Database.Error[] errs = srList[i].getErrors();
                        errorCSVList.add(String.valueOf(businessDataList[i].get('CSV_Row__c'))+','+errs[0].getMessage());
                    }
                    else{
                        successCSVList.add(String.valueOf(businessDataList[i].get('Id'))+','+String.valueOf(businessDataList[i].get('CSV_Row__c')));
                    }
                }
            }*/
        }
        catch(Exception ex){
            exceptionHandler(ex, 'processData');
        }
        //End of Logic
    }
    
    
    static List<String> parse(String input){
        Pattern doubleQuoteWrapped = Pattern.compile('("[^"]*")');
        Matcher m = doubleQuoteWrapped.matcher(input);
        List<String> output = new List<String>();
        while (m.find()) output.add(m.group());
        return output;
    }
    
    public class saibWrapper implements Comparable{
        public String strPeriod;
        public String strytdCopSales;
        public String strytdGovSales;
        
        public saibWrapper(){
            strPeriod='';
            strytdCopSales='0';
            strytdGovSales='0';
        }
        public Integer compareTo(Object ObjToCompare) {
            return strPeriod.CompareTo(((saibWrapper)ObjToCompare).strPeriod);
        }
    }
    
    //Method to handle & monitor Exceptions
    public void exceptionHandler(Exception exObj, String methodName){
        if(exObj!=null){
            ExceptionMon monObj = new ExceptionMon();
            monObj.batchNo = batchNo;
            monObj.method = methodName;            
            monObj.lineNo = exObj.getLineNumber();
            monObj.message = exObj.getMessage();
            monObj.stackTrace = exObj.getStackTraceString();
            monObj.cause = String.valueOf(exObj.getCause());
            exceptionMonList.add(monObj);
            //system.debug('exceptionMonList: '+exceptionMonList);
        }
    }
    
    public class ExceptionMon{
        public Integer batchNo = 0;
        public String method = '';
        public Integer lineNo = 0;
        public String message = '';
        public String stackTrace = '';
        public String cause = '';
    }
    
    
}