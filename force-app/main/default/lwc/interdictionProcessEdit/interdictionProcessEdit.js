import { LightningElement, api, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import updateFileRecordOnCV from '@salesforce/apex/InterdictionProcessEditController.updateFileRecordOnCV';
import DeleteProductRecords from '@salesforce/apex/InterdictionProcessEditController.DeleteProductRecords';
import deleteContentDocument from '@salesforce/apex/InterdictionProcessEditController.deleteContentDocument';
import getInterRecords from '@salesforce/apex/InterdictionProcessEditController.getInterRecords';
import getUserInfo from '@salesforce/apex/InterdictionProcessEditController.getUserInfo';
import updateProductRecords from '@salesforce/apex/InterdictionProcessEditController.updateProductRecords';
import getInterProductRecords from '@salesforce/apex/InterdictionProcessEditController.getInterProductRecords';
import Id from '@salesforce/user/Id';
import updateRecords from '@salesforce/apex/InterdictionProcessEditController.updateRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';
import DATEOFREQUEST from '@salesforce/label/c.BRZ_DATE_OF_REQUEST';
import IsAnInterDiction from '@salesforce/label/c.BRZ_IS_AN_INTERDICTION';
import termNumber from '@salesforce/label/c.Brz_Term_Number';
import cancel from '@salesforce/label/c.BRZ_CANCEL';
import DueDate from '@salesforce/label/c.BRZ_DUE_DATE';
import reason from '@salesforce/label/c.BRZ_REASON';
import Priority from '@salesforce/label/c.BRZ_PRIORITY';
import street from '@salesforce/label/c.BRZ_STREET';
import CNPJ_CPF from '@salesforce/label/c.CNPJ_CPF';
import SUBURB from '@salesforce/label/c.BRZ_SUBURB';
import POSTCODE from '@salesforce/label/c.BRZ_POSTCODE';
import Contact from '@salesforce/label/c.BRZ_CONTACT';
import status from '@salesforce/label/c.Interdiction_Status';
import InterCity from '@salesforce/label/c.Inter_City';
import InterDictionState from '@salesforce/label/c.InterDiction_State';
import ESTIMATEDCOLLECTIONDATE from '@salesforce/label/c.BRZ_ESTIMATED_COLLECTION_DATE';
import DATEOFREALCOLLECTION from '@salesforce/label/c.BRZ_DATE_OF_REAL_COLLECTION';
import getPicklistTypeFields from '@salesforce/apex/InderdictionProcessController.getPicklistTypeFields';
import DATE_OF_SUBMISSION_TO_LOGISTICS_OPERATOR from '@salesforce/label/c.BRZ_DATE_OF_SUBMISSION_TO_LOGISTICS_OPERATOR';
import ENTRY_CLOSED from '@salesforce/label/c.BRZ_ENTRY_CLOSED';
import EMAIL_LOGISTICS_OPERATOR from '@salesforce/label/c.BRZ_EMAIL_LOGISTICS_OPERATOR';
import getProduct from '@salesforce/apex/InderdictionProcessController.getProduct';
import interdiction_COMMENTS from '@salesforce/label/c.interdiction_COMMENTS';
import AGENT_EMAIL from '@salesforce/label/c.BRZ_AGENT_EMAIL';
import LOGISTICS from '@salesforce/label/c.BRZ_LOGISTICS';
import INTER_ATTACHMENTS from '@salesforce/label/c.INTER_ATTACHMENTS';
import Number from '@salesforce/label/c.BRZ_NUMBER';
import Create_Interdiction_Process from '@salesforce/label/c.Create_Interdiction_Process';
import Legal from '@salesforce/label/c.BRZ_LEGAL';
import DeleteFilesOnChange from '@salesforce/apex/InterdictionProcessEditController.DeleteFilesOnChange';
import getgroupInfo from '@salesforce/apex/InterdictionProcessEditController.getgroupInfo';
import { NavigationMixin } from 'lightning/navigation';
import Raise_Interdiction_Process from '@salesforce/label/c.Raise_Interdiction_Process';
import Save from '@salesforce/label/c.BRZ_SAVE';
import Product from '@salesforce/label/c.BRZ_PRODUCT';
import Quantity from '@salesforce/label/c.BRZ_QUANTITY';
import Batch from '@salesforce/label/c.BRZ_BATCH';
import Expire_Date from '@salesforce/label/c.BRZ_Expire_Date';
import Edit_Interdiction_Process from '@salesforce/label/c.Edit_Interdiction_Process';
import record_Created from '@salesforce/label/c.Record_was_saved';
import recordwasnot_Created from '@salesforce/label/c.Record_was_not_saved';
import Vendor from '@salesforce/label/c.BRZ_VENDOR_CODE';
import ADD_PRODUCT from '@salesforce/label/c.BRZ_ADD_PRODUCT';
import CUSTOMER_DETAILS from '@salesforce/label/c.INTER_CUSTOMER_DETAILS';
import Brz_Label_For_Compulsory_Field_For_Book_Collection from '@salesforce/label/c.Brz_Label_For_Compulsory_Field_For_Book_Collection';
import Fill_mandatory_fields from '@salesforce/label/c.Fill_mandatory_fields';
import Brz_Label_For_Legal_Assessment from '@salesforce/label/c.Brz_Label_For_Legal_Assessment';
import Brz_Label_For_Waiting_For_Collection from '@salesforce/label/c.Brz_Label_For_Waiting_For_Collection';
import Brz_LAbel_For_Compulsory_Field_Vendor from '@salesforce/label/c.Brz_LAbel_For_Compulsory_Field_Vendor';
import Brz_Label_For_Agent_Field from '@salesforce/label/c.Brz_Label_For_Agent_Field';
import File_Name from '@salesforce/label/c.File_Name';
import Delete from '@salesforce/label/c.Delete';
const COLUMNS = [
  {
    label: "Ação", type: "button", typeAttributes: {
      variant: 'base',
      label: 'Selecione',
      name: 'Select',
      title: 'Select',
      disabled: false,
      value: 'Select',
      iconPosition: 'left'
    }
  },
  { label: 'SKU', fieldName: 'Name', type: 'text' },
  { label: 'CÓDIGO SKU', fieldName: 'SKU_Code__c', type: 'text' }];
export default class InterdictionProcessEdit extends NavigationMixin(LightningElement) {
  userId = Id;
  COLUMNS = COLUMNS;
  filesList=[];
  log;
  objList=[];
  showfileForTable=false;
  fileForTable;
  @track showTable = false;
  @track picklistResult;
  @track currentIndexTable;
  @track priorMapdata = [];
  @track ReasonPick = [];
  @track interPick = [];
  tableRowIndex;
  @track DocIdList = [];
  @track contentId = [];
  @track docId;
  @track arrayToPass = [];
  @track rowIndex;

  @track rowRemove;
  @track rowId;
  label = {
    DATEOFREQUEST,
    IsAnInterDiction,
    termNumber,
    DueDate,
    reason,
    Priority,
    street,
    CNPJ_CPF,
    SUBURB,
    POSTCODE,
    Contact,
    InterCity,
    InterDictionState,
    ESTIMATEDCOLLECTIONDATE,
    DATEOFREALCOLLECTION,
    DATE_OF_SUBMISSION_TO_LOGISTICS_OPERATOR,
    ENTRY_CLOSED,
    EMAIL_LOGISTICS_OPERATOR,
    CUSTOMER_DETAILS,
    interdiction_COMMENTS,
    AGENT_EMAIL, INTER_ATTACHMENTS,
    LOGISTICS,
    INTER_ATTACHMENTS,
    Create_Interdiction_Process,
    Raise_Interdiction_Process,
    Number,
    Legal,
    status,
    Save,
    Product,
    Quantity,
    Expire_Date,
    Batch, Edit_Interdiction_Process,
    record_Created,
    recordwasnot_Created, 
    Vendor, 
    ADD_PRODUCT, 
    cancel, 
    Fill_mandatory_fields, 
    Brz_Label_For_Compulsory_Field_For_Book_Collection
    , Brz_Label_For_Legal_Assessment, 
    Brz_Label_For_Waiting_For_Collection, 
    Brz_LAbel_For_Compulsory_Field_Vendor, 
    Brz_Label_For_Agent_Field
  };
  dateOfRequest;
  dateOfRealCollection;
  stepStatus = true;
  showFields = false;
  showFileUploader = false;
  @track fileData = [];
  @track interdictionRecords = [];
  @api recordId;
  @track recordArray = [];
  @track statusPick = [];
  @track saveProgress = {};
  @track productData = [];
  productArray = [];
  statePick = [];
  productListToBeCheckedForEmpty = [];
  myOutputText;
  submission;
  @track dateofRequest = true;
  showTemplateMessage = false;
  isInterdiction = true;
  PriorValue = true;
  Reason = true;
  searchbutton = true;
  dDate = true;
  termNumber = true;
  CNPJ = true;
  street = true;
  SUBURB = true;
  INSCRI_O_ESTADUAL = true;
  Number = true;
  RAZ_O_SOCIAL = true;
  POSTCODE = true;
  Contact = true;
  City = true;
  state = true;
  expireDate = true;
  productName = true;
  Batch = true;
  deleteIcon = true;
  Quantity = true;
   @api columns = [
        { label: File_Name, fieldName: 'Title' }, 
        
        // { label: Download, type:  'button', typeAttributes: { 
        //     label: Download, name: 'Download', variant: 'brand', cellAttributes:{iconName: 'action:download'}, 
        //     iconPosition: 'right' 
        // } 
        // },
        { label: Delete, type:  'button', typeAttributes: { 
            label: Delete,   name: 'Delete',   variant: 'destructive',cellAttributes:{iconName: 'standard:record_delete'}, 
            iconPosition: 'right' 
        }
        }
    ];

  @track stepEstimate = true;
  @track stepComment = true;
  @track stepAgent = true;
  @track stepEntryClosed = true;
  @track stepDateOfReal = true;
  @track stepSubmission = true;
  @track stepEmailLogistic = true;
  @track stepVendor = true;
  buttonToShow = true;
  IndexFromTableTobeRemoved = [];
  @track currentUserProfileName;
  CurrentUSerGroupId;
  rowNumberOffset = 1; //Row number
  isModalOpen = false;
  recordsToDisplay = [];

  connectedCallback() {

    this.showIntError = false;
    console.log('this' + this.recordId);
    getUserInfo({})
      .then((result) => {
        this.currentUserProfileName = result;
        console.log('this.currentUserProfileName' + JSON.stringify(this.currentUserProfileName));
      })
      .catch((error) => {
        console.error(error.body.message);

      })
    getgroupInfo({})
      .then((result) => {
        this.CurrentUSerGroupId = result;
        console.log('this.CurrentUSerGroupId' + JSON.stringify(this.CurrentUSerGroupId));
      })
      .catch((error) => {
        console.error(error.body.message);

      })

    getInterRecords({ recordId: this.recordId })

      .then((result) => {
        this.interdictionRecords = result;
        console.log('this.resu;' + JSON.stringify(this.interdictionRecords));

        for (var i = 0; i < this.interdictionRecords.length; i++) {
          console.log('ener in interdictionRecords');
          console.log('owner ' + this.interdictionRecords[i].OwnerId + 'usetr id ' + this.CurrentUSerGroupId);
          if (this.interdictionRecords[i].IS_AN_INTERDICTION__c == 'Sim') {
            console.log('eneter');
            this.showFields = true;
          }
          if (this.currentUserProfileName.Name === 'Brazil System Administrator' || this.currentUserProfileName.Name === 'System Administrator' || this.currentUserProfileName.Name === 'Brazil Customer Service User') {
            this.stepStatus = false;

          }
          if (this.interdictionRecords[i].Owner.Type != null) {
            console.log('eneter in type' + this.interdictionRecords[i].Owner.Type);
            if (this.interdictionRecords[i].Owner.Type == 'Queue' && this.interdictionRecords[i].OwnerId == this.CurrentUSerGroupId) {
              this.buttonToShow = false;
            }
            else if (this.interdictionRecords[i].OwnerId == this.userId) {
              this.buttonToShow = false;
            }
          }
          if (this.interdictionRecords[i].Status__c === 'Registrar Devolução' && (this.currentUserProfileName.Name === 'Brazil Customer Service User' || this.currentUserProfileName.Name === 'Brazil System Administrator' || this.currentUserProfileName.Name === 'System Administrator')) {
            this.dateofRequest = false;
            this.isInterdiction = false;
            this.PriorValue = false;
            this.Reason = false;
            this.CNPJ = false;
            this.street = false;
            this.SUBURB = false;
            this.INSCRI_O_ESTADUAL = false;
            this.Number = false;
            this.RAZ_O_SOCIAL = false;
            this.POSTCODE = false;
            this.Contact = false;
            this.City = false;
            this.state = false;

            this.expireDate = false;
            this.productName = false;
            this.Batch = false;
            this.deleteIcon = false;
            this.Quantity = false;
            this.searchbutton = false;
            this.dDate = false;
            this.termNumber = false;
            this.buttonToShow = false;
            this.stepVendor = false;

          }
          if (this.interdictionRecords[i].Status__c === 'Disponibilizar Coleta' && this.currentUserProfileName.Name === 'Brazil Logistics') {
            console.log('Book Collection')

            this.stepEmailLogistic = false;
            this.showFileUploader = true;

            this.buttonToShow = false;
            console.log('this.step1' + this.myOutputText);
          }
          if (this.interdictionRecords[i].Status__c === 'Análise Jurídica' && this.currentUserProfileName.Name === 'LEGAL USER') {
            console.log('step1')
            this.stepComment = false;
            this.stepAgent = false;
            this.showFileUploader = true;
            this.buttonToShow = false;
            console.log('this.step1' + this.step1);
          }
          if (this.interdictionRecords[i].Status__c === 'Aguardando Coleta' && this.currentUserProfileName.Name === 'Brazil Logistics') {
            console.log('step1')
            this.stepDateOfReal = false;
            this.stepEstimate = false;
            this.showFileUploader = true;
            this.buttonToShow = false;
            console.log('this.step1' + this.step1);
          }
          if (this.interdictionRecords[i].Status__c === 'Criar Código de Fornecedor' && this.currentUserProfileName.Name === 'PURCHASING USER') {
            this.showFileUploader = true;
            this.stepVendor = false;
            this.buttonToShow = false;

          }
          if (this.interdictionRecords[i].Status__c === 'Criar Remessa de Devolução' && this.currentUserProfileName.Name === 'Brazil Logistics') {
            this.stepEntryClosed = false;
            this.showFileUploader = true;
            this.buttonToShow = false;
          }

        }



      })

      .catch((error) => {
        console.log(error);
      });

    getPicklistTypeFields()
      .then((result) => {

        for (let key in result) {
          if (key == 'Status__c') {
            let testList = result.Status__c;

            for (var i = 0; i < testList.length; i++) {
              if (testList[i] == this.interdictionRecords[0].Status__c) {
                console.log('Data Matched: ', testList[i])
              } else {
                this.statusPick.push({ key: key, value: testList[i] });
              }
            }

          }
          if (key == 'IS_AN_INTERDICTION__c') {
            let testList = result.IS_AN_INTERDICTION__c;

            for (var i = 0; i < testList.length; i++) {
              if (testList[i] == this.interdictionRecords[0].IS_AN_INTERDICTION__c) {
                console.log('Data Matched: ', testList[i])
              } else {
                this.interPick.push({ key: key, value: testList[i] });
              }
            }

          }
          if (key == 'REASON__c') {
            let testList = result.REASON__c;

            for (var i = 0; i < testList.length; i++) {
              if (testList[i] == this.interdictionRecords[0].REASON__c) {
                console.log('Data Matched: ', testList[i])
              } else {
                this.ReasonPick.push({ key: key, value: testList[i] });
              }
            }

          }
          if (key == 'PRIORITY__c') {
            let testList = result.PRIORITY__c;

            for (var i = 0; i < testList.length; i++) {
              if (testList[i] == this.interdictionRecords[0].PRIORITY__c) {
                console.log('Data Matched: ', testList[i])
              } else {
                this.priorMapdata.push({ key: key, value: testList[i] });
              }
            }

          }
          if (key == 'STATE__c') {
            let testList = result.STATE__c;

            for (var i = 0; i < testList.length; i++) {
              if (testList[i] == this.interdictionRecords[0].STATE__c) {
                console.log('Data Matched: ', testList[i])
              } else {
                this.statePick.push({ key: key, value: testList[i] });
              }
            }

          }
        }



      })
      .catch((error) => {
        console.log('In connected call back error....');
        this.error = error;

        console.log('Error is', this.error);
      });

    this.initData();

  }


  handlePaginatorChange(event) {
    console.log('event.detail' + event.detail);
    this.recordsToDisplay = event.detail;
    console.log('this.recordsToDisplayssssssss ' + JSON.stringify(this.recordsToDisplay));
    // this.rowNumberOffset = this.recordsToDisplay[0].length-1;
  }
  onValueChange(event) {
    console.log('thiss' + JSON.stringify(this.interdictionRecords.data));
    if (event.target.name == 'Vendor__c') {
      console.log('vendor');
      this.saveProgress.Vendor__c = event.target.value;
      console.log('aa' + JSON.stringify(this.saveProgress));

    }
    if (event.target.name == 'DATE_OF_REQUEST__c') {
      this.dateOfRequest = event.target.value;
      var d = new Date(this.dateOfRequest).toLocaleDateString('en-GB');
      console.log('d' + d);
      this.saveProgress.DATE_OF_REQUEST__c = this.dateOfRequest;
      console.log('123' + JSON.stringify(this.saveProgress));
    }
    if (event.target.name == 'DATE_OF_REAL_COLLECTION__c') {
      this.dateOfRealCollection = event.target.value;

      this.saveProgress.DATE_OF_REAL_COLLECTION__c = this.dateOfRealCollection;
      console.log('tttt' + JSON.stringify(this.saveProgress));
    }
    if (event.target.name == 'TERM_NUMBER__c') {

      // this.Term = event.target.value;
      this.saveProgress.TERM_NUMBER__c = event.target.value;
      console.log('tttt' + JSON.stringify(this.saveProgress));
    }
    if (event.target.name == 'DATE_OF_SUBMISSION_TO_LOGISTICS_OPERATOR__c') {
      this.submission = event.target.value;
      var d = new Date(this.submission).toLocaleDateString('en-GB');
      this.saveProgress.DATE_OF_SUBMISSION_TO_LOGISTICS_OPERATOR__c = this.submission;

    }
    if (event.target.name == 'DUE_DATE__c') {
      this.saveProgress.DUE_DATE__c = event.target.value;


    }
    if (event.target.name == 'REASON__c') {
      this.saveProgress.REASON__c = event.target.value;

    }

    if (event.target.name == 'CNPJ_CPF__c') {
      this.saveProgress.CNPJ_CPF__c = event.target.value;

    }
    if (event.target.name == 'NUMBER__c') {
      this.saveProgress.NUMBER__c = event.target.value;
    }
    if (event.target.name == 'STREET__c') {
      this.saveProgress.STREET__c = event.target.value;

    }
    if (event.target.name == 'INSCRI_O_ESTADUAL__c') {
      this.saveProgress.INSCRI_O_ESTADUAL__c = event.target.value;

    }
    if (event.target.name == 'SUBURB__c') {
      this.saveProgress.SUBURB__c = event.target.value;

    }
    if (event.target.name == 'RAZ_O_SOCIAL__c') {
      this.saveProgress.RAZ_O_SOCIAL__c = event.target.value;

    }
    if (event.target.name == 'POSTCODE__c') {
      this.saveProgress.POSTCODE__c = event.target.value;

    }
    if (event.target.name == 'CONTACT__c') {
      this.saveProgress.CONTACT__c = event.target.value;

    }
    if (event.target.name == 'CITY__c') {
      this.saveProgress.CITY__c = event.target.value;

    }
    if (event.target.name == 'STATE__c') {
      this.saveProgress.STATE__c = event.target.value;

    }
    if (event.target.name == 'ESTIMATED_COLLECTION_DATE__c') {
      this.saveProgress.ESTIMATED_COLLECTION_DATE__c = event.target.value;

    }
    if (event.target.name == 'ENTRY_CLOSED__c') {
      this.saveProgress.ENTRY_CLOSED__c = event.target.value;


    }
    if (event.target.name == 'EMAIL_LOGISTICS_OPERATOR_Brazil__c') {
      var mail = event.target.value;
      mail = mail.replaceAll(',', ';');
      this.saveProgress.EMAIL_LOGISTICS_OPERATOR_Brazil__c = mail;

    }

    if (event.target.name == 'AGENT_EMAIL_Brazil__c') {
      var mail = event.target.value;
      mail = mail.replaceAll(',', ';');
      this.saveProgress.AGENT_EMAIL_Brazil__c = mail;

    }

    if (event.target.name == 'COMMENTS__c') {
      this.saveProgress.COMMENTS__c = event.target.value;


      if (event.target.name == 'Status__c') {
        console.log('es');
        this.saveProgress.Status__c = event.target.value;

      }
      if (event.target.name == 'IS_AN_INTERDICTION__c') {

        this.saveProgress.IS_AN_INTERDICTION__c = event.target.value;
        if (event.target.value == 'Sim') {
          this.showFields = true;

        }

        else {
          this.showFields = false;
        }
      }
      if (event.target.name == 'PRIORITY__c') {
        console.log('es');
        this.saveProgress.PRIORITY__c = event.target.value;

      }
    }
  }



  @wire(getInterProductRecords, { recordId: '$recordId' }) wiredProducts({ error, data }) {
    if (data) {
      console.log('dtata2667' + data);
      this.productData = data;


      let productDataCopy = [];
      for (var i = 0; i < this.productData.length; i++) {
        let tempRecord = Object.assign({}, this.productData[i]);

        tempRecord['index'] = i + 1;
        // tempRecord[this.tableRowIndex]=i+1;
        console.log('tempPickList1' + JSON.stringify(tempRecord) + typeof (tempRecord) + typeof (this.productData));
        productDataCopy.push(tempRecord);
      }
      this.productData = productDataCopy;
      //this.tableRowIndex=this.productData.length;
      console.log('prodd' + JSON.stringify(this.productData));
    } else if (error) {
      this.error = error;
      console.log('error in product load' + this.error);
    }
    console.log('this.productData' + JSON.stringify(this.productData));
    // this.disableFields();

  }
  isObjEmpty(obj) {
    return Object.values(obj).length === 0 && obj.constructor === Object;
  }
  handleSave() {
    console.log('eneterd in save');

    const isInputsCorrect = [...this.template.querySelectorAll('lightning-input')]
      .reduce((validSoFar, inputField) => {


        inputField.reportValidity();
        if (inputField.reportValidity() == false) {
          const evt = new ShowToastEvent({
            title: 'Erro',
            message: this.label.Fill_mandatory_fields,
            variant: 'error',
            //mode: 'dismissable'
          });
          // console.log('toast');
          this.dispatchEvent(evt);
          console.log('toast');
        }
        console.log('add' + inputField.reportValidity() + '@@@@@2 ' + validSoFar + '****** ' + inputField.checkValidity());
        return validSoFar && inputField.checkValidity();

      }, true);
    const isInputTextCorrect = [...this.template.querySelectorAll('lightning-textarea')]
      .reduce((validSoFar, inputField) => {


        inputField.reportValidity();
        if (inputField.reportValidity() == false) {
          const evt = new ShowToastEvent({
            title: 'Erro',
            message: this.label.Fill_mandatory_fields,
            variant: 'error',
            //mode: 'dismissable'
          });
          // console.log('toast');
          this.dispatchEvent(evt);
          console.log('toast');
        }
        console.log('add' + inputField.reportValidity() + '@@@@@2 ' + validSoFar + '****** ' + inputField.checkValidity());
        return validSoFar && inputField.checkValidity();

      }, true);

    if (isInputsCorrect && isInputTextCorrect) {
      if (this.isObjEmpty(this.saveProgress)) {
        console.log('cond 1');
        this.FuncToShowToastOnSecondSave();
      }

      else if (!this.isObjEmpty(this.saveProgress)) {
        console.log('cond 3');
        this.updateMainInterdictionRecord();
      }




    }
  }

  updateMainInterdictionRecord() {
    updateRecords({ Interpro: this.saveProgress, recordId: this.recordId })
      .then((result) => {

        if (this.DocIdList != null) {
          console.log('save file');
        }
        if (this.rowRemove != null) {
          this.DeleteProductsFromTable();
        }
        this.updateProduct();
        const toastEvent = new ShowToastEvent({
          title: 'Sucesso!',
          message: this.label.record_Created,
          variant: 'success'
        });
        this.dispatchEvent(toastEvent);
        this.handleNavigate();
        this.updateRecordView(this.recordId);




      })


      .catch((error) => {
        const evt = new ShowToastEvent({
          title: 'Erro',
          message: this.label.recordwasnot_Created,
          variant: 'error',
          mode: 'dismissable'
        });
        this.dispatchEvent(evt);
      });

  }
  updateProduct() {
    console.log('eneter in update product');
    updateProductRecords({ recordId: this.recordId, Interproduct: JSON.stringify(this.productData) })
      .then((result) => {
        console.log('after success');
      })

      .catch((error) => {
        console.log('error in update product' + error);
      });
  }
  DeleteProductsFromTable() {
    console.log('remove row delete' + JSON.stringify(this.rowRemove));
    DeleteProductRecords({ recordId: this.rowRemove })
      .then(result => {
        console.log('deleted products');
      })
      .catch(error => {
        console.log('error while auto update' + error);

      });
  }

  handleNavigate() {
    this[NavigationMixin.Navigate]({
      type: 'standard__recordPage',
      attributes: {
        recordId: this.recordId,
        actionName: 'view',
      }

    })


  }
  updateRecordView(recordId) {
    updateRecord({ fields: { Id: recordId } });
  }


  handleCancel() {
    this.handleNavigate();
    if (this.DocIdList.length > 0) {
      DeleteFilesOnChange({ filedata: JSON.stringify(this.DocIdList) })
        .then(result => {
          console.log('deleted filess' + JSON.stringify(result));
        })
        .catch(error => {
          console.log('error while auto update' + error);

        });
    }
  }
  handleUploadFinished(event) {
    console.log('ressssssss upload');
     console.log('evee'+JSON.stringify(event.detail.files));
        let mainList = [];
        
        let objList = JSON.parse(JSON.stringify(event.detail.files));
        console.log('objList'+JSON.stringify(objList));
        let arry = [];
        arry = JSON.parse(JSON.stringify(this.filesList));
        objList.forEach(function(item){
            console.log('handleUploadFinished 113 - ');
            let obj = {"ContentDocumentId":item.documentId,"Title":item.name};
            arry.push(obj);
        },this);
        
        this.filesList = arry;
        arry = [];
        this.filesList.forEach(function(item2){
            console.log('handleUploadFinished 121 - ');
            let obj = {"docId":item2.ContentDocumentId,"name":item2.Title};
            arry.push(obj);
        },this);
        mainList = arry;
       
        console.log('this.filesList - ', JSON.parse(JSON.stringify(this.filesList)));
  
        if(this.filesList.length>0){
          this.showfileForTable=true;
        }
//     const uploadedFiles = event.detail.files;
//     console.log('evee' + JSON.stringify(event.detail.files));
// for(let i=0;i<uploadedFiles.length;i++){
//            this.objList.push({'Title':uploadedFiles[i].name,'ContentDocumentId':uploadedFiles[i].documentId,index:i});
//         }
//         this.fileForTable=this.objList;
//         if(this.fileForTable.length>0){
//           this.showfileForTable=true;
//         }
//         console.log('this.filee'+JSON.stringify(this.fileForTable));
//     let uploadedFileNames = '';
//     if (uploadedFiles.length == 1) {
//       console.log('fileData' + this.fileData.length);


//       uploadedFileNames += uploadedFiles[0].name;

//       this.fileData = uploadedFileNames;
//       this.docId = uploadedFiles[0].documentId;
//       this.DocIdList.push(this.docId);
//       this.contentId.push(uploadedFiles[0].contentVersionId);
//     }
//     else {
//       for (let i = 0; i < uploadedFiles.length; i++) {
//         uploadedFileNames = this.fileData + ',' + uploadedFiles[i].name;
//         this.fileData = uploadedFileNames;
//         console.log('this.fileData', this.fileData);
//         console.log('upload', uploadedFileNames);
//         this.fileData = this.fileData.replace(/^,|,$/g, '');

//         this.docId = uploadedFiles[i].documentId;
//         this.DocIdList.push(this.docId);
//         this.contentId.push(uploadedFiles[i].contentVersionId);
//         //console.log('uplo'+this.uploadedFileNames);


//       }
//     }

//     console.log('uploaded files' + JSON.stringify(this.fileData));
     updateFileRecordOnCV({ filedata: JSON.stringify(this.DocIdList), recordId: this.recordId })
      .then(result => {
        console.log('updated filess');
      })
      .catch(error => {
        console.log('error while auto update' + error);

      });
    console.log('doc id' + this.DocIdList);
    console.log('con id' + this.contentId);
    sessionStorage.setItem('DocIdList', this.DocIdList);
    console.log('test default' + sessionStorage.getItem('DocIdList'));
    window.onbeforeunload = function (event) {
      event.preventDefault();
      console.log('docc' + sessionStorage.getItem('DocIdList'));
      this.arrayToPass = sessionStorage.getItem('DocIdList');
      console.log('array' + JSON.stringify(this.arrayToPass));
      DeleteFilesOnChange({ filedata: sessionStorage.getItem('DocIdList') })
        .then(result => {
          console.log('deleted filess on before load' + sessionStorage.getItem('DocIdList'));
        })
        .catch(error => {
          console.log('error while auto update' + error);

        });
      return event.returnValue = "Are you sure you want to exit?";

    }

    window.addEventListener('popstate', function (ev) {
      console.log('windoww eventlistener' + sessionStorage.getItem('DocIdList'));
      DeleteFilesOnChange({ filedata: sessionStorage.getItem('DocIdList') })
        .then(result => {
          console.log('deleted filess');
        })
        .catch(error => {
          console.log('error while auto update' + error);

        });

    });
    sessionStorage.clear();

  }

  async refresh() {
    await refreshApex(this.recordId);
  }
  onChangeOnProduct(event) {
    console.log('eneter in change');
    this.currentIndexTable = event.target.dataset.id;
    console.log('cyree' + this.currentIndexTable);
    let value = event.target.value;



    for (var i = 0; i < this.productData.length; i++) {
      let tempPickList = JSON.parse(JSON.stringify(this.productData));



      console.log('this@@@@@@' + JSON.stringify(this.productData));

      tempPickList.map(e => {
        console.log(e.index + '/// ' + this.tableRowIndex);
        if (e.index == this.currentIndexTable) {

          if (event.target.name == 'Name') {
            e.Name = value;
          }
          if (event.target.name == 'Batch__c') {
            e.Batch__c = value;
          }
          if (event.target.name == 'Quantity__c') {
            e.Quantity__c = value;
          }
          if (event.target.name == 'Expire_Date__c') {
            e.Expire_Date__c = value;
          }
        }

      })
      this.productData = tempPickList;
      console.log('796' + this.productData);


      console.log('32234242344' + tempPickList)
      this.productData = this.productData;
      this.productListToBeCheckedForEmpty = this.productData;
      console.log('name3333999444411' + JSON.stringify(this.productListToBeCheckedForEmpty.length));
      console.log('name33339994444' + JSON.stringify(this.productData.length));

    }

  }

  removeRow(event) {
    console.log('remove row');

    let toBeDeletedRowIndex = event.target.dataset.id;
    let toBeDeletedRowIndex1 = event;


    console.log('length' + this.productData.length);
    let productData = [];
    let productDataToRemove = [];

    for (let i = 0; i < this.productData.length; i++) {
      this.IndexFromTableTobeRemoved = [];
      let tempRecord = Object.assign({}, this.productData[i]); //cloning object
      console.log('tempRecords' + JSON.stringify(tempRecord.Id != null) + JSON.stringify(tempRecord.Id) + '## ' + JSON.stringify(tempRecord.index));
      console.log(JSON.stringify(tempRecord.index) === toBeDeletedRowIndex);
      if (JSON.stringify(tempRecord.Id) != null && JSON.stringify(tempRecord.index) === toBeDeletedRowIndex) {

        productDataToRemove.push(tempRecord);

        //this.removeRow=productDataToRemove;
        for (let i = 0; i < productDataToRemove.length; i++) {
          this.rowRemove = productDataToRemove[i].Id;
        }
        console.log('thj' + JSON.stringify(this.rowRemove));
      }
      else if (tempRecord.Id == undefined && JSON.stringify(tempRecord.index) == toBeDeletedRowIndex) {
        let IndexFromTableTobeRemoved = [];
        //this.IndexFromTableTobeRemoved=[]; 
        console.log('else if' + JSON.stringify(tempRecord.index));
        console.log('after else if' + JSON.stringify(productData) + JSON.stringify(this.IndexFromTableTobeRemoved) + '%%%%%%% ' + JSON.stringify(this.productListToBeCheckedForEmpty));
        IndexFromTableTobeRemoved.push(JSON.stringify(tempRecord));
        this.IndexFromTableTobeRemoved = IndexFromTableTobeRemoved;
        console.log('this.IndexFromTableTobeRemoved' + this.IndexFromTableTobeRemoved);
        productDataToRemove.push(tempRecord);

        this.rowRemove = productDataToRemove;
        console.log('removeee' + this.rowRemove.length);

      }
      else {
        productData.push(tempRecord);
      }

    }



    for (let i = 0; i < productData.length; i++) {
      productData[i].index = i + 1;
      //this.removeRow = productData;
    }

    this.productData = productData;
    // //this.tableRowIndex=this.tableRowIndex-1;
    console.log('this.product' + JSON.stringify(this.productData.index));


  }

  showProducts(event) {

    this.isModalOpen = true;
    this.currentIndexTable = event.target.dataset.id;
    console.log('this.currentIndexTable' + this.currentIndexTable);
    getProduct()
      .then(result => {
        console.log('resultt' + JSON.stringify(result));
        //  this.error = undefined;
        this.log = result;
        console.log('proddd' + this.log);
        this.showTable = true;
        console.log('this.log' + JSON.stringify(this.log));

      })
      .catch(error => {
        console.log('error while auto update' + error);

      });
  }
  closeModal() {
    this.isModalOpen = false;
  }


  handleRowAction(event) {
    console.log('tbindex' + JSON.stringify(this.currentIndexTable));
    console.log('event', JSON.stringify(event));
    // var rowIndex = this.productData.findIndex(row => row.id === event.detail.productData[0].id);
    //console.log('rowIndex',rowIndex);
    let tempPickList = JSON.parse(JSON.stringify(this.productData));

    tempPickList.map(e => {

      console.log(e.index);
      if (e.index == this.currentIndexTable) {
        e.SKU_Code__c = event.detail.row.Id;
        e.Name = event.detail.row.Name;
      }

    })

    this.productData = tempPickList;
    console.log('listOfAccounts' + JSON.stringify(this.productData));
    this.productListToBeCheckedForEmpty = this.productData;
    this.isModalOpen = false;



    console.log('prodd' + this.productName);





    console.log('prodd' + this.productName);
    //this.productName=[];
  }

  initData() {
    let productData = [];
    this.createRow(productData);
    this.productData = productData;
  }

  createRow(productData) {
    let prodObject = {};
    this.IndexFromTableTobeRemoved = [];
    if (productData.length > 0) {
      //console.log('length'+productData.length );
      console.log('eneter' + '55', productData.length);
      prodObject.index = productData.length + 1;
      prodObject.tableRow = productData.length + 1;
      //this.tableRowIndex=productData.length;
      console.log('prodObject.index', prodObject.index + '##3 ' + this.tableRowIndex);
    } else {
      console.log('else');
      prodObject.index = 1;
      prodObject.tableRow = 1;
    }

    prodObject.Name = '';

    prodObject.Batch__c = null;
    prodObject.Quantity__c = null;
    prodObject.Expire_Date__c = null;
    let tempPickList = JSON.parse(JSON.stringify(this.productData));


    this.productData = [...this.productData, prodObject];
    console.log('this.prodObj' + JSON.stringify(this.productData));

  }
  addNewRow() {
    //this.listOfAccounts=[];


    this.createRow(this.productData);
    this.tableRowIndex = this.tableRowIndex + 1;
  }

  FuncToShowToastOnSecondSave() {


    for (var i = 0; i < this.interdictionRecords.length; i++) {


      if (this.interdictionRecords[i].Status__c == 'Registrar Devolução') {
        console.log('r1' + this.productListToBeCheckedForEmpty.length + '@@@@@@ ' + this.rowRemove);
        console.log('222' + this.isObjEmpty(this.IndexFromTableTobeRemoved) + ' ' + JSON.stringify(this.IndexFromTableTobeRemoved) + ' ' + this.productData);
        if (this.isObjEmpty(this.saveProgress) && this.productListToBeCheckedForEmpty.length == 0 && this.rowRemove == undefined) {

          console.log('enee');
          this.myOutputText = 'Você precisa editar alguns campos editáveis ​​para mover o status para o próximo estágio';
          this.showNotification();

        }





        else {
          this.updateMainInterdictionRecord();
        }



      }

      if (this.interdictionRecords[i].Status__c == 'Disponibilizar Coleta') {
        console.log('toast2');
        this.myOutputText = this.label.Brz_Label_For_Compulsory_Field_For_Book_Collection;
        this.showNotification();

      }
      if (this.interdictionRecords[0].Status__c == 'Análise Jurídica') {
        console.log('toast3');
        this.myOutputText = this.label.Brz_Label_For_Legal_Assessment;
        this.showNotification();

      }
      if (this.interdictionRecords[0].Status__c == 'Aguardando Coleta') {
        console.log('toast4');
        this.myOutputText = this.label.Brz_Label_For_Waiting_For_Collection;
        this.showNotification();

      }
      if (this.interdictionRecords[0].Status__c == 'Criar Código de Fornecedor') {
        console.log('toast5');
        this.myOutputText = this.label.Brz_LAbel_For_Compulsory_Field_Vendor;
        this.showNotification();

      }
      if (this.interdictionRecords[0].Status__c == 'Criar Remessa de Devolução') {
        console.log('toast6');
        this.myOutputText = this.label.Brz_Label_For_Agent_Field;
        this.showNotification();

      }



    }
    //this.IndexFromTableTobeRemoved=[];
  }
  showNotification() {
    const evt = new ShowToastEvent({
      title: 'Erro',
      message: this.myOutputText,
      variant: 'warning',
    });
    this.dispatchEvent(evt);
  }
  handleRowActionForFileDelete(event){
     
        const actionName = event.detail.action.name;
        let row = event.detail.row;
    let idListToPAss=[];
    idListToPAss=row.ContentDocumentId;
    console.log('idListToPAss'+JSON.stringify(idListToPAss));
       
            
                DeleteFilesOnChange({filedata:idListToPAss})
                .then(result=>{
                    this.filesList  = this.filesList.filter(item => {
                        return item.ContentDocumentId !== row.ContentDocumentId ;
                    });
                    let mainList = [];
                    mainList = JSON.parse(JSON.stringify(this.filesList));
                    console.log('mainList'+JSON.stringify(mainList));
                    let arry = [];
                    this.filesList.forEach(function(item2){
                        //console.log('handleUploadFinished - ', item);
                        let obj = {"docId":item2.ContentDocumentId,"name":item2.Title};
                        arry.push(obj);
                    },this);
                    //this.fileData=mainList;
                     if(this.filesList==''){
                    this.showfileForTable=false;
                   }
                    
                })
           
        
                    
            }

}