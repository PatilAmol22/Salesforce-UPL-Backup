/*
	* Name: Issue_Resolution_Flow_Controller
	* Created On: 5 Nov 2015
	* Author: Anant (anant.agarwal@comprotechnologies.com)
* Description: This controller is used to redirect the user on case edit page, on click of a finish 
			   button of Issue Resolution Flow.
* Change Log History:
* |-------------------------------------------------------------|
* | Version | Changes By | Date   | Description				    |
* |-------------------------------------------------------------|
* |   0.1   | Anant     | 5-11-15 |Initial version of Controller|
* |  
* |-------------------------------------------------------------|	
	*/

public with sharing class Issue_Resolution_Flow_Controller {
    public Flow.Interview.Issue_Resolution_Flow myFlow{get;set;}
    /*public String query;
    public string subquery;
    public String finaloutcome;
    public String status;
    public String crop;
    public String resolution;
    public String productRecommended;
    public String url;
*/
    public String caseID;
 

    public Issue_Resolution_Flow_Controller(ApexPages.StandardController controller) {

    }
/*
public String getaccountID() {
String var = ApexPages.currentPage().getParameters().get('id');
return var;
}
*/

    public PageReference getFinishPage(){ 
        
    //String ref='https://cs6.salesforce.com/500/e?retURL=%2F001N000000W9f9r&def_account_id='+getaccountID()+'&cas5='+getQuery()+'&00NN0000001QKeb='+getSubQuery()+'&cas7='+getStatus()+'&00NN0000001MQGk='+getCrop()+'&cas16='+getResolution();
    //String ref='/apex/Issue_Resolution_Flow_RedirectPage?cas5='+getQuery()+'&00NN0000001Q5DV=P2;P3;P4';
    String ref='https://'+getInstance()+'/'+getCaseID()+'/e?retURL=/'+getCaseID();  
    System.debug('ref is '+ref);  
    String url=getInstance();
    System.debug('Current Instance is'+url);    
    PageReference p = new PageReference(ref);
    //System.debug(':::::::::::'+p); 
    p.setRedirect(true);
    return p;
    }
    public String getCaseID()
    {
        if(myFlow==null)
        {
           //  query=(String) myFlow.getVariableValue('CaseID');
            return caseID;
        }
        else
        {
           caseID=(String) myFlow.getVariableValue('CaseID');
            System.debug('Now CaseID Is:'+CaseID);
            return caseID;
        }
    }
    public String getInstance()
    {
        String url=System.URL.getSalesforceBaseUrl().getHost();
        return url;
    }
    /*
    public String getQuery()
    {
        if(myFlow==null)
        {
           //  query=(String) myFlow.getVariableValue('Query_RelatedToResolution');
            return query;
        }
        else
        {
           query=(String) myFlow.getVariableValue('Query_RelatedToResolution');
            if(query==null)
            {
                System.debug('query is null');
                query='None';
            }
            System.debug('Now Query Is:'+query);
            return query;
        }
    }
     public String getSubQuery()
    {
        if(myFlow==null)
        {
          //   subquery=(String) myFlow.getVariableValue('SubQuery_RelatedToResolution');
            return subquery;
        }
        else
        {
           subquery=(String) myFlow.getVariableValue('SubQuery_RelatedToResolution');
            if(subquery==null)
                subquery='--None--';
            return subquery;
        }
    }
      public String getCrop()
    {
        if(myFlow==null)
        {
           //  query=(String) myFlow.getVariableValue('Query_RelatedToResolution');
            return crop;
        }
        else
        {
           crop=(String) myFlow.getVariableValue('Crop_RelatedToResolution');
            if(crop==null)
                crop='--None--';
            return crop;
        }
    }
    public String getStatus()
    {
         if(myFlow==null)
        {
           //  query=(String) myFlow.getVariableValue('Query_RelatedToResolution');
            return status;
        }
        else
        {
           finaloutcome=getFinalOutcome();
            if(finaloutcome=='Resolution')
                status='New';
            else 
                status='Escalated-L1';
           
            return status;
        }
       
    }
    public String getFinalOutcome()
    {
         if(myFlow==null)
        {
          //   subquery=(String) myFlow.getVariableValue('FinalOutcome');
            return finaloutcome;
        }
        else
        {
           finaloutcome=(String) myFlow.getVariableValue('FinalOutcome');
            return finaloutcome;
        }
        
    }
    public String getResolution()
    {
         if(myFlow==null)
        {
          //   subquery=(String) myFlow.getVariableValue('FinalResolution');
            return resolution;
        }
        else
        {
           resolution=(String) myFlow.getVariableValue('FinalResolution');
            return resolution;
        }
        
    }
    public String getProductRecommended()
    {
         if(myFlow==null)
        {
          //   subquery=(String) myFlow.getVariableValue('ProductRecommended');
            return productRecommended;
        }
        else
        {
           
           productRecommended=(String) myFlow.getVariableValue('ProductRecommended');
            if(productRecommended!=null)
            {
            List<string> products=productRecommended.split(';');
            string Firstproduct=products[0].split('\\[')[1];
            string Lastproduct=products[products.size()-1].split('\\]')[0];
                System.debug('First Product is '+Firstproduct);
                 System.debug('Last Product is '+Lastproduct);
                url='&00NN0000001Q5DV='+Firstproduct;
                 url=url+'&00NN0000001Q5DV='+Lastproduct;
                System.debug('URL is :'+url);
            Integer i=1;
            while(i<(products.size()-1))
            {
                url=url+'&00NN0000001Q5DV='+products[i];
                System.debug('Product'+i+' '+products[i]);
                i++;
            }
               
            }
            return url;
        } 
        
    }
*/
}