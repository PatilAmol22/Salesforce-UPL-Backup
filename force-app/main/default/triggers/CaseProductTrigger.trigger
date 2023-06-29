trigger CaseProductTrigger on Case_Product__c (before insert,before update,after delete) {
    Set<Id> caseid=new Set<Id>();
    Set<case> caseNewid=new Set<case>();
        Set<case> caseUpid=new Set<case>();

    
    map<id,List<case_product__c>> caseProdMap = new map<id,List<case_product__c>>();
	set<Id> skuSet=new set<Id>();
    set<Id> managerSet=new set<Id>();
    List<Id> managerList=new List<Id>();
    List<case> cList=new list<case>();
    List<case_product__c> cUpdateList=new list<case_product__c>();

    if(trigger.isDelete){
        cUpdateList=Trigger.Old;
    	for(Case_Product__c cp:Trigger.Old){
            system.debug('inside del');
            caseid.add(cp.Case__c);
            
            
    }
    }
    map<Id,id> cpSKuMap=new map<id,id>();
    List<id> cpidList=new List<Id>();
    if((trigger.isinsert || trigger.isupdate)){
        system.debug('insup');
        cUpdateList=Trigger.New;
        
    for(Case_Product__c cp:Trigger.New){
        system.debug('cp'+cp.Case__c);
        skuSet.add(cp.Brand_Pack_Size__c);
		caseid.add(cp.Case__c);
        cpidList.add(cp.id);
        //cpSKuMap.put(cp.id,cp.Brand_Pack_Size__c);
        system.debug('caseidin'+caseid);
                    }
        map<Id,id> cpMap=new map<id,id>();
        id rectype=Schema.SObjectType.case.getRecordTypeInfosByName().get('CSR').getRecordTypeId();
        List<Case_Product__c> cpProd=[select id,case__c,Brand_Pack_Size__c from Case_Product__c where case__c in:caseid and case__r.recordtypeId=:rectype and id NOT In:cpidList];
        for(Case_Product__c cp1:cpProd){
            cpMap.put(cp1.Brand_Pack_Size__c,cp1.id);
        }
        system.debug('**cpmap**'+cpMap);
        for(Case_Product__c cp:Trigger.New){
            system.debug('**bdp'+cp.Brand_Pack_Size__c+cpMap.get(cp.id));
            if(cpMap.get(cp.Brand_Pack_Size__c)!=null ){
                system.debug('hello');
                cp.addError('Product with similar SKU cannot be added for CSR Cases');
            }
        }
    }
    
    system.debug('caseid'+caseid);
    Set<Id>sidSet=new Set<Id>();
    map<Id,string>sidmap=new map<Id,string>();
    map<Id,string>scodemap=new map<Id,string>();
	List<sales_org__c> sList=[select id,sales_org_code__c from sales_org__c where sales_org_code__c='3100' or sales_org_code__c='3710'];
    List<case> caseRecList=[select id,recordtype.name,account.sales_org__r.sales_org_code__c from case where id in:caseid];
    for(case c:caseRecList){
        for(sales_org__c ss:sList){
        system.debug('***123***'+c.account.sales_org__c + c.recordtype.name);
        if((c.account.sales_org__c==ss.id)&& (c.recordtype.name=='Complaint' || c.recordtype.name=='CSR' || c.recordtype.name=='Sample' || c.recordtype.name=='FOC' || c.recordtype.name=='Product Swap')){
        sidSet.add(c.account.sales_org__c);
            sidmap.put(c.id,c.account.sales_org__c);
            caseNewid.add(c);
        }
        }
    }
           
    
	List<case_product__c> cpList=[select id,name,Brand_Pack_Size__c,Brand_Pack_Size__r.Market_Manager__c,case__r.contact.account.sales_org__r.sales_org_code__c from case_product__c where case__c In:caseNewid];
	system.debug('cpList'+cpList);
    for(Case_Product__c cp:cpList){
		skuSet.add(cp.Brand_Pack_Size__c);
		//caseid.add(cp.Case__c);
    
    }
    system.debug('skuSet'+skuSet);
	List<sku__c> skuList=[select id,Market_Manager__c from sku__c where id in:skuSet];
	for(sku__c sk:skuList){
		managerSet.add(sk.Market_Manager__c);
	}
	if(managerSet.size()>0){
		managerList.addAll(managerSet);
	}
	system.debug('managerList'+managerList);
    if(managerList.size()>5){
        	
            if((trigger.isinsert && trigger.isbefore)||(trigger.isupdate && trigger.isbefore)){
                for(Case_Product__c cp:Trigger.New){
                cp.AddError('Number of Marketing managers to approve this case exceeds 5, Please split the case into two different cases to reduce the number of marketing managers on each case.');
                
            }
        }
    }else{
        system.debug('else');
        for(Case_Product__c cp:cUpdateList){
        Case c=new case(Id=cp.Case__c);
        c.Approver_1__c=null;
        c.Approver_2__c=null;
        c.Approver_3__c=null;
        c.Approver_4__c=null;
        c.Approver_5__c=null;
        c.No_of_Approvers__c=null;
            if(managerList.size()>=1){
        c.Approver_1__c=managerList[0];
            }
            if(managerList.size()>=2){
        c.Approver_2__c=managerList[1];
            }
            if(managerList.size()>=3){
        c.Approver_3__c=managerList[2];
            }
            if(managerList.size()>=4){
        c.Approver_4__c=managerList[3];
            }
            if(managerList.size()>=5){
        c.Approver_5__c=managerList[4];
            }
        c.No_of_Approvers__c=managerList.size();
            cList.add(c);
            
        
        
    }
        
    }
    system.debug(cList);
    if(cList.size()>0){
        update cList;
    }
}