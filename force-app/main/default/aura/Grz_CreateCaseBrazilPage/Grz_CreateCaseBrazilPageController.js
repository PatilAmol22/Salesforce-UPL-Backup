({
    doInit : function(component, event, helper) {
        console.log('inside post method');
        var action = component.get("c.fetchUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('inside do init ==== ',response);
            if (state == "SUCCESS") {
                var tempList = response.getReturnValue().CaseTypeList;
               // var tempcategory = response.getReturnValue().CaseTypeList;
                component.set("v.fieldList", tempList);
               //  component.set("v.caseCategory", tempList);
                component.set("v.initWrapper",response.getReturnValue());
                console.log('ContactName',component.get("v.initWrapper"));
            }
        });
        $A.enqueueAction(action);
    },
    onChange: function (component, event, helper) {
        var select = component.find('caseTypePicklist').get('v.value');
        console.log('select',select);
        component.set("v.casesTypes",select);
        
        
         var action = component.get("c.CaseCategory");
          action.setParams({
            CaseType : select
            
          });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('inside do init ==== ',response);
             console.log('state ==== ',state);
            if (state == "SUCCESS") {
                console.log("response.getReturnValue()",response.getReturnValue());
                 component.set("v.caseCategory",response.getReturnValue());
                
            }
            else{
                component.set("v.caseCategory",'');
            }
        });
        $A.enqueueAction(action);
        
    },
    createCaseData : function(component, event, helper){
        var accountid = component.get("v.selItem2.val");
        var types = component.get("v.casesTypes");
        console.log('iaccountid',accountid);
        document.getElementById("casebtn").disabled = true;
        console.log('inside post method');
        var errormsg ='';
        var caseCreate =component.get("v.caseAttribute");  
        console.log('ContactPhone Value', caseCreate.ContactPhone);
        var phoneNum=/^[0-9_ ]*$/;
        console.log('caseCreate++++',caseCreate);
        if (caseCreate.Subject == '') {
            errormsg = ' Assunto';
            component.set("v.errorsubject",'*Por favor insira o Assunto');
            document.getElementById("casebtn").disabled = false;
        }
        else{
            if(caseCreate.Subject.length > 255){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "O comprimento do assunto deve ser inferior a 255",
                    "type" : "error"
                });
                toastEvent.fire();
                document.getElementById("casebtn").disabled = false;
                return true;
            }
            component.set("v.errorsubject",'');
        }
        if(caseCreate.Description == '') {
            if(errormsg == ''){
                errormsg = 'Descrição';
            }
            else{
                errormsg += ', Descrição';
            }
            component.set("v.errorDescription",'*Forneça o Description');
            document.getElementById("casebtn").disabled = false;
        }
        else{
            if(caseCreate.Description.length > 32000){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "O comprimento da descrição deve ser inferior a 32000",
                    "type" : "error"
                });
                toastEvent.fire();
                document.getElementById("casebtn").disabled = false;
                return true;
            }
            component.set("v.errorDescription",'');
        }
        console.log('hi--');
        var internaluser = component.get("v.initWrapper.IsInternalUser");
        console.log('internaluser',internaluser);
        if(internaluser){
            if (accountid == null || accountid == '') {
                if(errormsg == ''){
                    errormsg = 'Conta';
                }
                else{
                    errormsg += ', Conta';
                }
                component.set("v.erroraccount",'*Por favor insira o Account');
                document.getElementById("casebtn").disabled = false;
            }
            else{
                component.set("v.erroraccount",'');
            }
        }
        if(types == '' || types == null) {
            if(errormsg == ''){
                errormsg = 'Tipo de Atendimento';
            }
            else{
                errormsg += ', Tipo de Atendimento';
            }
            document.getElementById("casebtn").disabled = false;  
        }
        else{
            component.set("v.errorcasetype",'');
        }
        console.log('v.contentDocumentId : ', component.get("v.contentDocumentId"));        
        if(errormsg != '')
        {   
            errormsg = 'Campo (s) obrigatório (s) em falta:' + errormsg;
            component.set("v.errormessage",errormsg);
            return true;
        }
        component.set("v.loaded", true);
        var action = component.get("c.createCase");
        console.log('caseCreate== ', caseCreate);
        action.setParams({
            cs : caseCreate,
            casetypes : component.get("v.casesTypes"),
            AccountID : accountid,
            ContentDocId : component.get("v.contentDocumentId")
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('inside post method action1', state);
            console.log('inside do init ==== ', response.getError());
            component.set("v.loaded", false);
            if (state == "SUCCESS") {
                console.log('response.getReturnValue()', response.getReturnValue());   
                console.log('inside post method action2', state);
                console.log('inside Success');
                var makeCase = {'sobjectType': 'Case',
                                'Subject': '',
                                'Description': '',                             	
                               };
                component.set("v.caseAttribute", makeCase);
                console.log('return Values--1 ',component.get("v.caseAttribute"));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Novo Atendimento foi criado com sucesso.",
                    "type" : "success"
                });
                console.log('response.getReturnValue()', response.getReturnValue().Id);
                toastEvent.fire();
                window.location.href = "/uplpartnerportal/s/case/" + response.getReturnValue().Id;
                console.log('inside post method action', window.location.href);
                console.log('response.getReturnValue()', response.getReturnValue());
            }
            else {
                document.getElementById("casebtn").disabled = false;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "ERROR!",
                    "message": "O Atendimento não pode ser criado.",
                    "type" : "error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    Cancel:function(component, event, helper) {
        var action = component.get("c.deleteAttachments");
        action.setParams({
            ContentDocId : component.get("v.contentDocumentId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                location.href = "/uplpartnerportal/s/casehome";
            }
        });
        $A.enqueueAction(action);
    },
    handleUploadFinished:function(component, event, helper){
        var uploadedFiles = event.getParam("files");
        console.log('uploadedFiles---',uploadedFiles);
        var filelength= uploadedFiles.length;
        var documentId = uploadedFiles[0].documentId;
        console.log('documentId--',documentId);
        var action = component.get("c.contentSize");
        action.setParams({ cid : documentId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state--',state);
            if (state == "SUCCESS") {
                var tempList = response.getReturnValue();
                console.log('state--',tempList);
                if(tempList == 'ERROR'){
                    console.log('state--',tempList);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": "O tamanho do arquivo não pode ser maior que 20 MB",
                        "type" : "Warning"
                    });
                    toastEvent.fire();
                    
                }else{
                    
                    
                    var send = [];
                    var documentids = [];
                    send = component.get("v.documents");
                    documentids = component.get("v.contentDocumentId");
                    for(var i = 0; i < uploadedFiles.length; i ++){
                        var documentId = uploadedFiles[i].documentId;
                        var fileName = uploadedFiles[i].name;
                        documentids.push(documentId);
                        var ca = {'Name':fileName, 'documentId':documentId};
                        uploadedFiles.forEach(file => console.log(file.name));
                        send.push(ca);
                    }
                    component.set("v.contentDocumentId", documentids);
                    component.set("v.documents", send);
                    //component.set("v.disabledattachment",true);
                    
                }
                
            }
        });
        $A.enqueueAction(action);
    }
})