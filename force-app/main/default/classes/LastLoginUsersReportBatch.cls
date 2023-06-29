/*
*   Author : EY
*   Schedular Class - LastLoginUsersReportBatch
*   CreatedDate: 30-11-2022
*   Description - Fetch Reports for Country specific
**/
global class LastLoginUsersReportBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {

    //fetch last login specfic reports
    global Database.QueryLocator start(Database.BatchableContext BC) {
        if(Test.isRunningTest()){
            return Database.getQueryLocator('Select Id, Name, DeveloperName, FolderName From Report where FolderName = \'Users not logged in for less than 7 days\' LIMIT 200');
        }else{
        	return Database.getQueryLocator('Select Id, Name, DeveloperName, FolderName From Report where FolderName = \'Users not logged in for less than 7 days\' AND ID <> NULL');    
        }
        
    }
    
    //build map of reports and call sendEmailToCountryManager from execute
    global void execute(Database.BatchableContext BC, List<Report>  reportList) {
        Map<Id, String> reportMap = new Map<Id, String>();
        if(null != reportList && !reportList.isEmpty()){
            for(Integer reportCount = 0 ; reportCount < reportList.size() ; reportCount++){
                Id reportId = (Id) reportList.get(reportCount).get('Id');
                string reportName = String.valueOf(reportList.get(reportCount).get('Name'));
                reportMap.put(reportId, reportName);
            }
        }
        
        if(null != reportMap && !reportMap.isEmpty()){
            sendEmailToCountryManager(reportMap);
        }
    }
    
    //AsyncApexJob
    global void finish(Database.BatchableContext BC) {
        AsyncApexJob job=[select id,NumberOfErrors,JobItemsProcessed,Status,TotalJobItems,CompletedDate from AsyncApexJob where id =:bc.getJobId()];
        system.debug('Finish Method--->'+job.JobItemsProcessed);
    }
    
    //Logic to send Email alert to Shared mail box
    global void sendEmailToCountryManager(Map<Id, String> reportMap){
        String instanceName = URL.getSalesforceBaseUrl().toExternalForm();
        
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        
        Map<Id,String> reportIdAndName=new  Map<Id,String>();
        Map<String, Report_User_adoption__mdt> reportUserDetailsMap = getReportUserDetails();
        for(Id reportId : reportMap.keySet()){
            system.debug('reportMap.get(reportId)' +reportMap.get(reportId));
        	String url = instanceName + '/servlet/PrintableViewDownloadServlet?isdtp=p1&reportId='+reportId;
            ApexPages.PageReference objPage = new ApexPages.PageReference(url);
            Messaging.SingleEmailMessage  message = new Messaging.SingleEmailMessage();
            
            Messaging.EmailFileAttachment objMsgEmailAttach = new Messaging.EmailFileAttachment();
            objMsgEmailAttach.setFileName(reportMap.get(reportId)+'.csv');
            objMsgEmailAttach.body = Test.isRunningTest() ? Blob.valueOf('Test.Blob') : objPage.getContent();
            objMsgEmailAttach.contenttype = 'application/csv';
            
            message.setCharset('UTF8');
            message.setFileAttachments(new Messaging.EmailFileAttachment[] { objMsgEmailAttach });//Set File Attachment 
           
            
        	List<String> userList = new List<String>();
            if(reportMap.get(reportId).contains('India')){
                //Added by Nandhini to Change Subject and Body
                String indiaEmail = reportUserDetailsMap.get('India').Email__c;
                reportIdAndName.put(reportId,'India');
                if(String.isNotBlank(indiaEmail)){
                    for(String email : indiaEmail.split(',')){
                        userList.add(email);
                    }
                }
            }else if(reportMap.get(reportId).contains('Brazil')){
                 reportIdAndName.put(reportId,'Brazil');
                String brazilEmail = reportUserDetailsMap.get('Brazil').Email__c;
                if(String.isNotBlank(brazilEmail)){
                    for(String email : brazilEmail.split(',')){
                        userList.add(email);
                    }
                } 
            }else if(reportMap.get(reportId).contains('US')){
                reportIdAndName.put(reportId,'US');
                String USEmail = reportUserDetailsMap.get('US').Email__c;
                if(String.isNotBlank(USEmail)){
                    for(String email : USEmail.split(',')){
                        userList.add(email);
                    }
                } 
            }else if(reportMap.get(reportId).contains('Italy')){
                reportIdAndName.put(reportId,'Italy');
                String italyEmail = reportUserDetailsMap.get('Italy').Email__c;
                if(String.isNotBlank(italyEmail)){
                    for(String email : italyEmail.split(',')){
                        userList.add(email);
                    }
                }
            }else if(reportMap.get(reportId).contains('Turkey')){
                reportIdAndName.put(reportId,'Turkey');
                String turkeyEmail = reportUserDetailsMap.get('Turkey').Email__c;
                if(String.isNotBlank(turkeyEmail)){
                    for(String email : turkeyEmail.split(',')){
                        userList.add(email);
                    }
                }
            }
            /*else if(reportMap.get(reportId).contains('US')){
                String USEmail = reportUserDetailsMap.get('US').Email__c;
                if(String.isNotBlank(USEmail)){
                    for(String email : USEmail.split(',')){
                        userList.add(email);
                    }
                } 
            }*/
             else if(reportMap.get(reportId).contains('Spain/Portugal')){
                 reportIdAndName.put(reportId,'Spain/Portugal');
                String SPEmail = reportUserDetailsMap.get('Spain/Portugal').Email__c;
                if(String.isNotBlank(SPEmail)){
                    for(String email : SPEmail.split(',')){
                        userList.add(email);
                    }
                }
            }else if(reportMap.get(reportId).contains('Poland')){
                 reportIdAndName.put(reportId,'Poland');
                String polandEmail = reportUserDetailsMap.get('Poland').Email__c;
                if(String.isNotBlank(polandEmail)){
                    for(String email : polandEmail.split(',')){
                    	userList.add(email);
                    }
                }
            }else if(reportMap.get(reportId).contains('France')){
                reportIdAndName.put(reportId,'France');
                String franceEmail = reportUserDetailsMap.get('France').Email__c;
                if(String.isNotBlank(franceEmail)){
                    for(String email : franceEmail.split(',')){
                        userList.add(email);
                    }
                }
            }else if(reportMap.get(reportId).contains('UK')){
                reportIdAndName.put(reportId,'UK');
                String UKEmail = reportUserDetailsMap.get('UK').Email__c;
                if(String.isNotBlank(UKEmail)){
                    for(String email : UKEmail.split(',')){
                        userList.add(email);
                    }
                }
            }else if(reportMap.get(reportId).contains('Europe')){
                reportIdAndName.put(reportId,'Europe');
                system.debug('inside Europe if');
                String europeEmail = reportUserDetailsMap.get('Central/North Europe').Email__c;
                if(String.isNotBlank(europeEmail)){
                    for(String email : europeEmail.split(',')){
                        userList.add(email);
                    }
                }
            }else if(reportMap.get(reportId).contains('Indonesia')){
                reportIdAndName.put(reportId,'Indonesia');
                String indonesiaEmail = reportUserDetailsMap.get('Indonesia').Email__c;
                if(String.isNotBlank(indonesiaEmail)){
                    for(String email : indonesiaEmail.split(',')){
                        userList.add(email);
                    }
                }
            }else if(reportMap.get(reportId).contains('Australia')){
                reportIdAndName.put(reportId,'Australia');
                String australiaEmail = reportUserDetailsMap.get('Australia').Email__c;
                if(String.isNotBlank(australiaEmail)){
                    for(String email : australiaEmail.split(',')){
                        userList.add(email);
                    }
                } 
            }else if(reportMap.get(reportId).contains('Japan')){
                reportIdAndName.put(reportId,'Japan');
                String japanEmail = reportUserDetailsMap.get('Japan').Email__c;
                if(String.isNotBlank(japanEmail)){
                    for(String email : japanEmail.split(',')){
                        userList.add(email);
                    }
                }
            }else if(reportMap.get(reportId).contains('Vietnam')){
                reportIdAndName.put(reportId,'Vietnam');
                String vietnamEmail = reportUserDetailsMap.get('Vietnam').Email__c;
                if(String.isNotBlank(vietnamEmail)){
                    for(String email : vietnamEmail.split(',')){
                        userList.add(email);
                    } 
                }
            }else if(reportMap.get(reportId).contains('Mexico')){
                reportIdAndName.put(reportId,'Mexico');
                String mexicoEmail = reportUserDetailsMap.get('Mexico').Email__c;
                if(String.isNotBlank(mexicoEmail)){
                    for(String email : mexicoEmail.split(',')){
                        userList.add(email);
                    } 
                }
            }else if(reportMap.get(reportId).contains('Colombia')){
                 reportIdAndName.put(reportId,'Colombia');
                String colombiaEmail = reportUserDetailsMap.get('Colombia').Email__c;
                if(String.isNotBlank(colombiaEmail)){
                    for(String email : colombiaEmail.split(',')){
                        userList.add(email);
                    } 
                }
            }else if(reportMap.get(reportId).contains('Argentina')){
                reportIdAndName.put(reportId,'Argentina');
                String argentinaEmail = reportUserDetailsMap.get('Argentina').Email__c;
                if(String.isNotBlank(argentinaEmail)){
                    for(String email : argentinaEmail.split(',')){
                        userList.add(email);
                    }
                }
            }else if(reportMap.get(reportId).contains('Paraguay')){
                reportIdAndName.put(reportId,'Paraguay');
                String paraguayEmail = reportUserDetailsMap.get('Paraguay').Email__c;
                if(String.isNotBlank(paraguayEmail)){
                    for(String email : paraguayEmail.split(',')){
                        userList.add(email);
                    }
                } 
            }else if(reportMap.get(reportId).contains('Bolivia')){
                reportIdAndName.put(reportId,'Bolivia');
                String boliviaEmail = reportUserDetailsMap.get('Bolivia').Email__c;
                if(String.isNotBlank(boliviaEmail)){
                    for(String email : boliviaEmail.split(',')){
                        userList.add(email);
                    }  
                }               
            }else if(reportMap.get(reportId).contains('Costa Rica')){
                reportIdAndName.put(reportId,'Costa Rica');
                String costaricaEmail = reportUserDetailsMap.get('Costa Rica').Email__c;
                if(String.isNotBlank(costaricaEmail)){
                    for(String email : costaricaEmail.split(',')){
                        userList.add(email);
                    }  
                }                     
            }else if(reportMap.get(reportId).contains('Chile')){
                reportIdAndName.put(reportId,'Chile');
                String chileEmail = reportUserDetailsMap.get('Chile').Email__c;
                if(String.isNotBlank(chileEmail)){
                    for(String email : chileEmail.split(',')){
                        userList.add(email);
                    }  
                }                    
            }else if(reportMap.get(reportId).contains('Guatemala')){
                //Added by Nandhini to Change Subject and Body
                reportIdAndName.put(reportId,'Guatemala');
                String guatemalaEmail = reportUserDetailsMap.get('Guatemala').Email__c;
                if(String.isNotBlank(guatemalaEmail)){
                    for(String email : guatemalaEmail.split(',')){
                        userList.add(email);
                    }   
                }                   
            }
            System.debug('userList check'+userList.size());
            //Added by Nandhini to Change Subject and Body
            message.setSubject(reportIdAndName.get(reportId) +' : Users not logged into UPL Salesforce Production < 15 days');
            message.setHtmlBody('Hello, <br/><br/> Please find the attached '+reportIdAndName.get(reportId)+' users NOT logged in for < 15 days.<br/><br/>Thank You.<br/> UPL Management Team');
            message.setToAddresses(userList);
            //Added by Nandhini to add Common users in the CC.
            String supportEmailDetails=reportUserDetailsMap.get('CC Email Id').Email__c;
            List<String> ccEmailList = new List<String>();
            if(String.isNotBlank(supportEmailDetails)){
                for(String email : supportEmailDetails.split(',')){
                    ccEmailList.add(email);
                }   
            }
            message.setCcAddresses(ccEmailList);
            system.debug('check to address :'+message);
            emailList.add(message);
            
        }
        Messaging.sendEmail(emailList);
    }
    
    /*
    * Description: Retrieve all sales org details exist in Report_User_adoption__mdt custom metadata Types
	* Param: NA
	* return : msalesOrgDetailsMap
    * */

  public static Map<String,Report_User_adoption__mdt> mreportUserDetailsMap;
  public static Map<String, Report_User_adoption__mdt> getReportUserDetails(){
      if(mreportUserDetailsMap == null){
          mreportUserDetailsMap = new Map<String, Report_User_adoption__mdt>();
          List<Report_User_adoption__mdt> reportUserDetailsList = [SELECT Label, Email__c FROM Report_User_adoption__mdt];
          for(Report_User_adoption__mdt reportUserDetail : reportUserDetailsList){
             mreportUserDetailsMap.put(reportUserDetail.Label, reportUserDetail); 
          }
      }
	return mreportUserDetailsMap;
  }
    
}