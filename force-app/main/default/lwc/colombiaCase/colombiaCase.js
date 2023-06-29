import { LightningElement, api, track,wire  } from 'lwc';
import getAccountEmailandPhone from '@salesforce/apex/SaveColombiaCase.getAccountEmailandPhone';
import SaveCase from '@salesforce/apex/SaveColombiaCase.SaveCase';
import getProductInformation from '@salesforce/apex/SaveColombiaCase.getProductInformation';
import makeProductList from '@salesforce/apex/SaveColombiaCase.makeProductList';
import { fireEvent } from 'c/pubsub';
import { CurrentPageReference } from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import FAQ_s_Quality from '@salesforce/label/c.FAQ_s_Quality';
import FAQ_s_Effectiveness from '@salesforce/label/c.FAQ_s_Effectiveness';
import Account from '@salesforce/label/c.Account';
import Farmer_Name from '@salesforce/label/c.Farmer_Name';
import Email from '@salesforce/label/c.Email';
import Mobile_number from '@salesforce/label/c.Mobile_number';
import Priority_Level from '@salesforce/label/c.Priority_Level';
import ID_Number from '@salesforce/label/c.ID_Number';
import colombia_Status from '@salesforce/label/c.colombia_Status';
import Sales_Representative from '@salesforce/label/c.Sales_Representative';
import Country from '@salesforce/label/c.Country';
import Zone from '@salesforce/label/c.Zone';
import City from '@salesforce/label/c.City';
import Product from '@salesforce/label/c.Product';
import SKU from '@salesforce/label/c.SKU';
import Quantity from '@salesforce/label/c.Quantity';
import Lot_Number from '@salesforce/label/c.Lot_Number';
import Expiration_Date from '@salesforce/label/c.Expiration_Date';
import Date_of_Receiving_Product from '@salesforce/label/c.Date_of_Receiving_Product';
import ACTION from '@salesforce/label/c.Action';
import Additional_Information from '@salesforce/label/c.Additional_Information';
import UPLOAD_FILE from '@salesforce/label/c.Upload_File';
import REASON_CLOSE from '@salesforce/label/c.Reason_for_close';
import Complete_this_field from '@salesforce/label/c.Complete_this_field';
import select_an_option from '@salesforce/label/c.select_an_option';
import save from '@salesforce/label/c.Save';
import cancel from '@salesforce/label/c.Cancel';
import preview from '@salesforce/label/c.Preview';
import delete1 from '@salesforce/label/c.Delete';
import file_name from '@salesforce/label/c.File_Name';
import file_extension from '@salesforce/label/c.File_extension';
import case_detail from '@salesforce/label/c.Case_Details';
import area_detail from '@salesforce/label/c.Area_Details';
import product_information from '@salesforce/label/c.Product_Information';
import Files_uploaded_Successfully from '@salesforce/label/c.Files_uploaded_Successfully';
import Updated from '@salesforce/label/c.Updated';
import Created from '@salesforce/label/c.Created';
import Case_record from '@salesforce/label/c.Case_record';
import Cases from '@salesforce/label/c.Cases';
import Price from '@salesforce/label/c.Price';

import unable_to_created_Case_record from '@salesforce/label/c.unable_to_created_Case_record';
import Mandatory_fields_can_not_be_empty from '@salesforce/label/c.Mandatory_fields_can_not_be_empty';
import Unable_to_add_Product_Information from '@salesforce/label/c.Unable_to_add_Product_Information';
import Unable_to_delete_Product_Information from '@salesforce/label/c.Unable_to_delete_Product_Information';
import please_select_any_product from '@salesforce/label/c.please_select_any_product';
import ph_case_type from '@salesforce/label/c.select_case_type';
import ph_select_account from '@salesforce/label/c.Select_Account';
import ph_select_level from '@salesforce/label/c.Select_level';
import ph_select_status from '@salesforce/label/c.Select_status';
import ph_sales_reps from '@salesforce/label/c.Select_Sales_Representative';
import ph_select_country from '@salesforce/label/c.Select_Country';
import ph_select_zone from '@salesforce/label/c.Select_Zone'
import ph_select_city from '@salesforce/label/c.Select_City';
import ph_select_product from '@salesforce/label/c.Select_Product';
import ph_select_sku from '@salesforce/label/c.Select_sku';
import option_open from '@salesforce/label/c.Open';
import option_closed from '@salesforce/label/c.Closed';
import successfully from '@salesforce/label/c.successfully';
import invalid_mobile_no from '@salesforce/label/c.Please_complete_this_field_or_enter_valid_value';



import getCaseInfomation from '@salesforce/apex/SaveColombiaCase.getCaseInfomation';
// Case OBJECT
import CASE_OBJECT from '@salesforce/schema/Case';
//import  CASE_Priority from '@salesforce/schema/Case.Priority';
import CASE_Type from '@salesforce/schema/Case.Type';
import CASE_FAQs_Effectiveness__c from '@salesforce/schema/Case.FAQs_Effectiveness__c';
import CASE_AccountID from '@salesforce/schema/Case.AccountId';
import CASE_Farmer_Name__c from '@salesforce/schema/Case.Farmer_Name__c';
import CASE_Email__c from '@salesforce/schema/Case.Email__c';
import CASE_ID_Number__c from '@salesforce/schema/Case.ID_Number__c';
import CASE_Mobile_Number_col__c from '@salesforce/schema/Case.Mobile_Number_col__c';
import CASE_status from '@salesforce/schema/Case.Status';
import CASE_zone from '@salesforce/schema/Case.Zone__c';
import CASE_city from '@salesforce/schema/Case.City__c';
import CASE_SALES_REPS from '@salesforce/schema/Case.Sales_representative__c';
import CASE_REASON_FOR_CLOSE from '@salesforce/schema/Case.Reason_for_Closure__c';
import CASE_ADDITIONAL_INFO from '@salesforce/schema/Case.Additional_Information__c';
import CASE_country from '@salesforce/schema/Case.Country__c';
import CASE_createdby from '@salesforce/schema/Case.CreatedById';

import deleteProductList from '@salesforce/apex/SaveColombiaCase.deleteProductList';
import { NavigationMixin } from 'lightning/navigation';
import getFilesdata from '@salesforce/apex/SaveColombiaCase.getFilesdata';
import getFilesdataTemp from '@salesforce/apex/SaveColombiaCase.getFilesdataTemp';
import deleteFilefromTemp from '@salesforce/apex/SaveColombiaCase.deleteFilefromTemp';
import deleteFiles from '@salesforce/apex/SaveColombiaCase.deleteFiles';
import addAssignmentRule from '@salesforce/apex/SaveColombiaCase.addAssignmentRule';
import getFileAttachment from '@salesforce/apex/SaveColombiaCase.getFileAttachment';


const mandetory_for = ["Despachos","Producto Próximo a vencer","Disponibilidad de Producto","Quejas de Productos por Agricultores","Filtración"];
export default class ColombiaCase  extends NavigationMixin(LightningElement) {

    //Account and Sales_reps parameter value
    // @track parameter_value_Account='5710';
    // @track parameter_value_salesresps='';

    // private variable
    @track email = CASE_Email__c;
    @track phone= CASE_Mobile_Number_col__c;
    @track faq_quality = CASE_Type;
    @track faq_effective = CASE_FAQs_Effectiveness__c;
    @track accountId = CASE_AccountID ;
    @track priority_level= ''//CASE_Priority;
    @track id_number = CASE_ID_Number__c;
    @track status = CASE_status;
    @track country=CASE_country;
    @track zone = CASE_zone;
    @track city = CASE_city;
    @track farmer_name = CASE_Farmer_Name__c;
    @track additional_information = CASE_ADDITIONAL_INFO;
    @track reason_for_close = CASE_REASON_FOR_CLOSE;
    @track case_createdBy = CASE_createdby;
    @track sku ='';
    @track product ='';
    @track quality;
    @track lot_number;
    @track price;
    @track expiration_date;
    @track date_of_receving='';
    @track Sales_Representative = ''
    @track sales_reps_userid = CASE_SALES_REPS;
    @track account_filter = '';
    @track product_filter = '';
    @track sku_filter = '';
    @track sales_representative_filter= '';
    // for required 
    @track account_require=false;
    @track farmer_name_require = false;
    @track priority_level_required = false;
    @track faq_Quality_required = false;
    @track id_number_required = false;
    @track mobile_num_required = false;
    @track Sales_Representative_required  = false;
    @track country_required = false;
    @track Zone_required= false;
    @track City_required= false;
    @track Status_required= false;
    @track product_required = false;
    @track sku_required = false;
    @track quality_required = false;
    @track expiration_date_required = false;
    @track date_of_receiving_required = false;
    @track reason_for_close_required = false;
    @track price_required = false;
    // product information
    @track lst_productInformation = [];
    @track is_lst_productInformation = false;
    @track lst_temp_productInformation = [];
    @track lst_deleteproductInformation = [];
    @track index=0;
    @track acc_name = '';
    @track show_productInformation = false;
    @track disableBtnSubmit = false;
    start_product_size = 0;
    total_product_size = 0;
    //product and SKU
    
    @track parentProductid ='';
    @track skuid = '';
   
    @track files =[];
    //file-attachment UPL-test : a4H0k000000M8dG
    //file-attachment UPL-uat : a671m0000004CmZAAU
    @track myRecordId=''; // change on 11-10-2020 01:57 PM  a7F0K000000fzpB
    @wire(CurrentPageReference) pageRef;
    // combobox
    
   
    @track disable_type = false;
    @track disable_faq_effective = false;
    @track disable_account = false;
    @track disable_farmer_name = false;
    @track disable_email = false;
    @track disable_phone = false;
    @track disable_priority = false;
    @track disable_idnumber = false;
    @track disablestatus = true;
    @track disableSales_reps = false;
    @track disablecountry = true;
    @track disable_zone = false;
    @track disablecity = false;
    @track disable_Product = false;
    @track disableDependentsku = true;
    @track disable_Quality = false;
    @track disable_lotnum = false;
    @track disable_price = false;
    @track disable_exprirationdate = false;
    @track disable_receivingdate = false;
    @track disable_additionalInfo = false;
    @track disableReasonClose = true;
    @track disable_addproductInfo = false;
    @track disable_removeproductInfo_btn = false;
    @track disable_removefile_btn = false;

    @track country_value = ''
    @track zone_city_map = new Map();
    @track case_id;
    @track show_spinner = false;
    @track case_number = 'Case';

    // Files
    @track lst_files = [];
    @track is_files = false; 
    @track file_delete = [];
    @track madetory_product_required = false;
    @track hide_farmer_name_star = 'hide_star';
    @track hide_account_star = 'hide_star';
    @track hide_reason_for_close_star = 'hide_star';
    

    @track label = {
       faq_quality  : FAQ_s_Quality,
       faq_effective : FAQ_s_Effectiveness,
       account  : Account,
       farmer_name : Farmer_Name,
       email : Email,
       mobile_number  : Mobile_number,
       priority_level : Priority_Level,
       id_number : ID_Number,
       status : colombia_Status,
       sales_reps : Sales_Representative,
       country : Country,
       zone : Zone,
       city : City,
       product : Product,
       sku : SKU,
       quality : Quantity,
       lot_number : Lot_Number,
       expiration_date : Expiration_Date,
       date_of_receiving : Date_of_Receiving_Product,
       action : ACTION,
       additional_information : Additional_Information,
       upload_file : UPLOAD_FILE,
       complete_field:Complete_this_field,
       select_option:select_an_option,
       reason_close:REASON_CLOSE,
        Files_uploaded_Successfully: Files_uploaded_Successfully,
        Updated:Updated,
        Created:Created,
        Case_record:Case_record,
        unable_to_created_Case_record:unable_to_created_Case_record,
        Mandatory_fields_can_not_be_empty:Mandatory_fields_can_not_be_empty,
        Unable_to_add_Product_Information:Unable_to_add_Product_Information,
        Unable_to_delete_Product_Information:Unable_to_delete_Product_Information,
        please_select_any_product:please_select_any_product,
        save:save,
        cancel : cancel,
        delete1:delete1,
        preview:preview,
        file_name:file_name,
        file_extension:file_extension,
        case_detail:case_detail,
        product_information:product_information,
        area_detail : area_detail,
        case : Cases,
        ph_case_type:ph_case_type,
        ph_select_account:ph_select_account,
        ph_select_level:ph_select_level,
        ph_select_status:ph_select_status,
        ph_sales_reps:ph_sales_reps,
        ph_select_country:ph_select_country,
        ph_select_zone:ph_select_zone,
        ph_select_city:ph_select_city,
        ph_select_product:ph_select_product,
        ph_select_sku:ph_select_sku,
        op_open:option_open,
        op_close:option_closed,
        Price:Price,
        successfully :successfully,
        invalid_mobile :invalid_mobile_no
    }

    @api case_recordId=''; 
    @track case_record = {
            Id:this.case_id,
            Priority:this.priority_level,
            Type:this.faq_quality,
            FAQs_Effectiveness__c: this.faq_effective,
            AccountId:this.accountId,
            Farmer_Name__c:this.farmer_name,
            Email__c:this.email,
            ID_Number__c:this.id_number,
            Mobile_Number_col__c:this.phone,
            Status:this.status,
            Country__c :this.country,
            Zone__c:this.zone,
            City__c:this.city,
            Sales_representative__c:this.sales_reps_userid,
            Reason_for_Closure__c:this.reason_for_close,
            Additional_Information__c:this.additional_information,
            CreatedById : this.case_createdBy,
    }
// Edit 
 @api
  getFiredFromAura() {
      console.log('fire from Aura');
      this.lst_productInformation = [];
      this.is_lst_productInformation = false
      this.lst_temp_productInformation = [];
      this.lst_deleteproductInformation = [];
      this.acc_name = '';
      this.Sales_Representative = '';
      this.product = '';
      this.sku = '';
      this.quality = '';
      this.lot_number = '';
      this.expiration_date = '';
      this.date_of_receving = '';
      this.files = [];
      this.lst_files = [];
      this.is_files = false;

      this.case_record = {
        Id:'',
        Priority:'',//this.priority_level,
        Type:'',
        FAQs_Effectiveness__c: '',
        AccountId:'',
        Farmer_Name__c:'',
        Email__c:'',
        ID_Number__c:'',
        Mobile_Number_col__c:'',
        Status:'',
        Country__c :'',
        Zone__c:'',
        City__c:'',
        Sales_representative__c:'',
        Reason_for_Closure__c:'',
        Additional_Information__c:'',
        CreatedById : '',
    }

      this.connectedCallback();
  }

    
    get acceptedFormats() {
         
        return ['.pdf', '.png','.jpg','.jpeg','.csv','.doc','.docx','.xls','.xlsx'];
    }

    @wire(getFileAttachment)
    getFileAttachmentId({error,data}){
        if(data){
            this.myRecordId = data;
        }
        if(error){
            console.log('File_Attchment__c Record Id not found',error)
        }
    }

    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        let uploadedFileNames = '';
        for(let i = 0; i < uploadedFiles.length; i++) {
            uploadedFileNames += uploadedFiles[i].name + ', ';
        }
        this.showToastmessage('Success',uploadedFiles.length + ' '+this.label.Files_uploaded_Successfully+' ' + uploadedFileNames,'success');

        getFilesdataTemp().then(file_data=>{
            this.files = file_data;
            file_data.forEach(element => {
                let fileobj = {
                    fileid : element.ContentDocument.Id,
                    file_name:element.ContentDocument.Title,
                    file_extension:element.ContentDocument.FileExtension,
                    contentdocumentid:element.ContentDocumentId,
                    LinkedEntityId :element.LinkedEntityId,
                 }
                 let index1 = this.file_delete.findIndex(ele => { 
                    ele.contentdoc_id === fileobj.contentdocumentid
                    console.log('ele.contentdoc_id '+ele.contentdoc_id+' '+'fileobj.contentdocumentid '+element.ContentDocumentId);
                    return ele.contentdoc_id === fileobj.contentdocumentid;
                })
                 console.log('lst file ',this.lst_files);
                 if(this.lst_files.length>0){
                    let index = this.lst_files.findIndex(ele => ele.fileid === fileobj.fileid);
                    console.log('index',index);
                    console.log('index1',index1);
                    if(index===-1 && index1===-1){
                        this.is_files = true;
                        this.lst_files.push(fileobj);
                    }
                }else{
                    if(index1===-1){
                        this.is_files = true;
                        this.lst_files.push(fileobj);
                    }
                }
            });
            console.log('File_data TEmp',this.files,length);
        }).catch(err=>{
            console.log('unable to find files',err);
        });
    }

    showToastmessage(title,message,varient){
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: varient,
            }),
        );
    }

    value = 'Normal';

    get priorityLevelOptions() {
        return [
            { label: 'Low', value: 'Low' },
            { label: 'Normal', value: 'Normal' },
            { label: 'High', value: 'High' },
        ];
    }

    get faqQualityOptions() {
        return [
            { label: 'Límite de Crédito', value: 'Límite de Crédito' },
            { label: 'Despachos', value: 'Despachos' },
            { label: 'Factura', value: 'Factura' },
            { label: 'Cancelación de Orden', value: 'Cancelación de Orden' },
            { label: 'Actualización de Pedido', value: 'Actualización de Pedido' },
            { label: 'Otros', value: 'Otros' },
            { label: 'Outstanding', value: 'Outstanding' },
            { label: 'Pagos y recibos', value: 'Pagos y recibos' },
            { label: 'Disponibilidad de Producto', value: 'Disponibilidad de Producto' },
            { label: 'Quejas de Productos por Agricultores', value: 'Quejas de Productos por Agricultores' },
            { label: 'Filtración', value: 'Filtración' },
            { label: 'Producto Próximo a vencer', value: 'Producto Próximo a vencer'},
            { label: 'Dirección de Envío - Actualización información del cliente', value: 'Dirección de Envío - Actualización información del cliente' },
        ];
    }


    get countryOptions() {
        return [
            { label: 'Colombia', value: 'Colombia' },
        ];
    }

    get zoneOptions() {
        return [
            { label:'Antioquia Norte',value:'Antioquia Norte'}, 
            { label:'Antioquia Sur',value:'Antioquia Sur'}, 
            { label:'Boyacá',value:'Boyaca'},
            { label:'Caldas',value:'Caldas'},
            { label:'Casanare',value:'Casanare'},
            { label:'Cauca',value:'Cauca'},
            { label:'Cordoba',value:'Cordoba'},
            { label:'Cundinamarca',value:'Cundinamarca'},
            { label:'Diabonos',value:'Diabonos'},
            { label:'Flores',value:'Flores'},
            { label:'Huila Norte',value:'Huila Norte'},
            { label:'Huila Sur',value:'Huila Sur'},
            { label:'Meta Norte',value:'Meta Norte'},
            { label:'Meta Sur',value:'Meta Sur'},
            { label:'Nariño',value:'Narino'},
            { label:'Norte de Santander',value:'Norte de Santander'},
            { label:'Santander',value:'Santander'},
            { label:'Quindío',value:'Quindio'},
            { label:'Risaralda',value:'Risaralda'},
            { label:'Tolima Norte',value:'Tolima Norte'},
            { label:'Tolima Sur',value:'Tolima Sur'},
            { label:'UPL Max',value:'UPL Max'},
            { label:'Uraba',value:'Uraba'},
            { label:'Valle',value:'Valle'},                
        ];
    }
   
    get cityOptions() {
        return [
            { label:'Medellin' ,value:'Medellin'},
            { label:'Tunja' ,value:'Tunja'},
            { label:'Manizales' ,value:'Manizales'},
            { label:'Yopal' ,value:'Yopal'},
            { label:'Popayan' ,value:'Popayan'},
            { label:'Monteria' ,value:'Monteria'},
            { label:'Bogota' ,value:'Bogota'},
            { label:'Diabonos' ,value:'Diabonos'},
            { label:'Flores' ,value:'Flores'},
            { label:'Neiva' ,value:'Neiva'},
            { label:'Villavicencio' ,value:'Villavicencio'},
            { label:'Pasto' ,value:'Pasto'},
            { label:'Cucuta' ,value:'Cucuta'},
            { label:'Armenia' ,value:'Armenia'},
            { label:'Pereira' ,value:'Pereira'},
            { label:'Ibagué' ,value:'Ibagué'},
            { label:'UPL Max' ,value:'UPL Max'},
            { label:'Uraba' ,value:'Uraba'},
            { label:'Cali' ,value:'Cali'},
        ];
    }

    get productOptions() {
        return [
            { label: 'Product1', value: 'Product1' },
            { label: 'Product2', value: 'Product2' },
        ];
    }

    get skuOptions() {
        return [
            { label: 'Unit1', value: 'Unit1' },
            { label: 'Unit2', value: 'Unit2' },
        ];
    }

    get statusOptions() {
        return [
            { label: this.label.op_open, value: this.label.op_open },
            { label: this.label.op_close, value: this.label.op_close },
        ];
    }

    value = ['option1'];

    get options2() {
        return [
            { label: 'True', value: 'true' },
            { label: 'False', value: 'false' },
        ];
    }
 

    // render() {
    //     window.console.log('Hello')
    //     return false;
    // }
   
    handleChange(event) {
        this.value = event.detail.value;
    }
    handleChangefaqs_Effective(event){
        if(event.target.checked===true){
            this.case_record.FAQs_Effectiveness__c = true;
            console.log('on true ',this.case_record.FAQs_Effectiveness__c);
            this.hide_farmer_name_star = 'show_star';
            this.hide_account_star = 'hide_star';
        }
        if(event.target.checked===false){
            this.case_record.FAQs_Effectiveness__c = false;
            console.log('on false ',this.case_record.FAQs_Effectiveness__c);
            this.hide_account_star = 'show_star';
            this.hide_farmer_name_star = 'hide_star';
        }
    }
    handleChangeCaseType(event){
        this.case_record.Type = event.detail.value;
        console.log(`${mandetory_for} .includes( ${this.case_record.Type})`);
        console.log('Case type-->',mandetory_for.includes(this.case_record.Type))
        if(mandetory_for.includes(this.case_record.Type)){
            this.show_productInformation = true;
        }else{
            this.show_productInformation = false;
        }
        console.log(this.case_record.Type);
    }
    handleChangePriorityLevel(event){
        this.case_record.Priority = event.detail.value;
        console.log(this.case_record.Priority);
    }
    handleChangeStatus(event){
        this.case_record.Status = event.detail.value;
        if(this.case_record.Status==this.label.op_close){
            this.disableReasonClose = false;
            this.hide_reason_for_close_star = 'show_star';
        }else{
            this.disableReasonClose = true;
            this.hide_reason_for_close_star = 'hide_star';
        }
    }
    handleChangeCountry(event){
        this.country = event.detail.value;
    }
    handleChangeSku(event) {
        this.sku = event.detail.value;
    }
    handleChangeProduct(event) {
        this.product = event.detail.value;
    }
    handleChangeCity(event){
        this.case_record.City__c = event.detail.value;
    }
    handleChangeZone(event){
        this.case_record.Zone__c = event.detail.value;
        //console.log(this.zone_city_map.get(this.case_record.Zone__c));
        this.case_record.City__c = this.zone_city_map.get(this.case_record.Zone__c);
        this.disablecity = true;
    }
    
    handleChangeFarmerName(event){
        this.case_record.Farmer_Name__c = event.target.value;
    }
    handleChangeId_Number(evt){
        // this.case_record.ID_Number__c = event.target.value;
        var theEvent = evt || window.event;
        this.case_record.ID_Number__c = evt.target.value;
        // Handle key press
            var key = theEvent.keyCode || theEvent.which;
            key = String.fromCharCode(key);
      
        var regex = /[0-9]|\./;
        if( !regex.test(key) ) {
          theEvent.returnValue = false;
         // if(theEvent.preventDefault) theEvent.preventDefault();
        }
    }
    handleChangeEmail(event){
        this.case_record.Email__c = event.target.value;
    }

    handleChangeMobile(evt){
        var theEvent = evt || window.event;
        this.case_record.Mobile_Number_col__c = evt.target.value;
        // Handle key press
            var key = theEvent.keyCode || theEvent.which;
            key = String.fromCharCode(key);
      
        var regex = /[0-9]|\./;
        if( !regex.test(key) ) {
          theEvent.returnValue = false;
         // if(theEvent.preventDefault) theEvent.preventDefault();
        }
    }
    handleChangeQuality(event){
        this.quality = event.target.value;
    }
    handleChangeLotnumber(event){
        this.lot_number = event.target.value;
    }
    handleChangePrice(evt){
        //this.price = event.target.value;
        var theEvent = evt || window.event;
        this.price = evt.target.value;
        // Handle key press
            var key = theEvent.keyCode || theEvent.which;
            key = String.fromCharCode(key);
      
        var regex = /[0-9]|\./;
        if( !regex.test(key) ) {
          theEvent.returnValue = false;
         // if(theEvent.preventDefault) theEvent.preventDefault();
        }
    }
    handleChangeExpriration(event){
        this.expiration_date = event.target.value;
    }
    handleChangeRecevingProduct(event){
        this.date_of_receving = event.target.value;
    }

        constructor(){
            super();
            console.log('constructor -->',this.case_recordId)
        }



    connectedCallback(){

        this.case_record.Priority='',
        this.case_record.Type='';
        this.case_record.FAQs_Effectiveness__c=false; 
        this.case_record.AccountId='';
        this.case_record.Farmer_Name__c='';
        this.case_record.Email__c='';
        this.case_record.ID_Number__c='';
        this.case_record.Mobile_Number_col__c = '';
        this.case_record.Status=this.label.op_open;
        this.case_record.Country__c = 'Colombia';
        this.case_record.Zone__c = '';
        this.case_record.City__c = '';
        this.case_record.Sales_representative__c = '';
        this.case_record.Reason_for_Closure__c = '';
        this.case_record.Additional_Information__c = '';
        

        this.account_filter = "Sales_Org__r.Sales_Org_Code__c = '5710' and RecordType.Name='Distributor' and Account_Type__c='Sold To Party'"
        this.product_filter = "Active__c=true and Product_Name__r.Sales_Org_Code__c ='5710' AND Product_Name__r.Distribution_Channel__r.Distribution_Channel_Code__c ='20' AND Product_Name__r.Division__r.Division_Code__c='10' limit 10";
        this.sku_filter = "Sales_Org_Code__c='5710'";

        this.zone_city_map.set('Antioquia Norte','Medellin');
        this.zone_city_map.set('Antioquia Sur','Medellin');
        this.zone_city_map.set('Boyaca','Tunja');
        this.zone_city_map.set('Caldas','Manizales');
        this.zone_city_map.set('Casanare','Yopal');
        this.zone_city_map.set('Cauca','Popayan');
        this.zone_city_map.set('Cordoba','Monteria');
        this.zone_city_map.set('Cundinamarca','Bogota');
        this.zone_city_map.set('Diabonos','Diabonos');
        this.zone_city_map.set('Flores','Flores');
        this.zone_city_map.set('Huila Norte','Neiva');
        this.zone_city_map.set('Huila Sur','Neiva');
        this.zone_city_map.set('Meta Norte','Villavicencio');
        this.zone_city_map.set('Meta Sur','Villavicencio');
        this.zone_city_map.set('Narino','Pasto');
        this.zone_city_map.set('Norte de Santander','Cucuta');
        this.zone_city_map.set('Santander','Giron');
        this.zone_city_map.set('Quindio','Armenia');
        this.zone_city_map.set('Risaralda','Pereira');
        this.zone_city_map.set('Tolima Norte','Ibagué');
        this.zone_city_map.set('Tolima Sur','Ibagué');
        this.zone_city_map.set('UPL Max','UPL Max');
        this.zone_city_map.set('Uraba','Uraba');
        this.zone_city_map.set('Valle','Cali');
       
       // console.log('rec ID connected callback',this.case_recordId);
       deleteFilefromTemp().then(data=>{ // Delete Files assosiated Temp Record
            console.log('is Deleted ',data);
        }).catch(err=>{
            console.log('is Deleted exception ',err);
        });

        this.case_record.Id = this.case_recordId;
        console.log('Case rec ID ',this.case_record.Id);
        getProductInformation({caseid:this.case_record.Id}).then(data=>{
            console.log("Product infomation ",data);
        }).catch(err=>{
            console.log("Product infomation ",err);
        });

        getFilesdata({caseid:this.case_record.Id}).then(file_data=>{
            // this.files = file_data;
            console.log('File data -->',file_data);
           file_data.forEach(element => {
            let fileobj = {
                fileid : element.ContentDocument.Id,
               file_name:element.ContentDocument.Title,
               file_extension:element.ContentDocument.FileExtension,
               contentdocumentid:element.ContentDocumentId,
               LinkedEntityId :element.LinkedEntityId,
            }
            this.is_files = true;
            this.lst_files.push(fileobj);
           });
            // console.log('File_data original',this.files.length);
        }).catch(err=>{
            console.log('unable to find files',err);
        });
        
        getCaseInfomation({case_recid:this.case_recordId}).then(case_info =>{
            console.log('connected callback Case info --->',JSON.stringify(case_info));
            this.case_record.Priority = case_info.caseRec.Priority;
            this.case_record.Type = case_info.caseRec.Type;
            if(this.case_record.Type!==undefined){
                this.disable_type = true;
                if(mandetory_for.includes(this.case_record.Type)){
                    this.show_productInformation = true;
                }else{
                    this.show_productInformation = false;
                }
            }
            if(case_info.caseRec.FAQs_Effectiveness__c!==undefined){
                if(case_info.caseRec.FAQs_Effectiveness__c==true){
                    this.case_record.FAQs_Effectiveness__c = true;
                    this.hide_farmer_name_star = 'show_star';
                    this.hide_account_star = 'hide_star';
                }
                if(case_info.caseRec.FAQs_Effectiveness__c==false){
                    this.case_record.FAQs_Effectiveness__c = false;
                    this.hide_farmer_name_star = 'hide_star';
                    this.hide_account_star = 'show_star';
                }
            }else{
                this.case_record.FAQs_Effectiveness__c = false;
                this.hide_farmer_name_star = 'hide_star';
                this.hide_account_star = 'show_star';
            }
            this.case_record.AccountId = case_info.caseRec.AccountId;
            if(case_info.caseRec.Account!==undefined){
            this.acc_name = case_info.caseRec.Account.Name;
            }
            this.case_record.Farmer_Name__c = case_info.caseRec.Farmer_Name__c;
            this.case_record.ID_Number__c = case_info.caseRec.ID_Number__c;
            this.case_record.Email__c = case_info.caseRec.Email__c;
            this.case_record.Mobile_Number_col__c = case_info.caseRec.Mobile_Number_col__c!==undefined?case_info.caseRec.Mobile_Number_col__c:'';
            if(case_info.caseRec.Status!==undefined){
                this.case_record.Status = case_info.caseRec.Status;
                this.disablestatus = false;
                //this.disableReasonClose = false; // edit 
                if(case_info.caseRec.Status===this.label.op_close){
                    this.hide_reason_for_close_star = 'show_star';
                    this.disableAll();
                }
            }
            this.case_record.Zone__c = case_info.caseRec.Zone__c;
            this.case_record.CreatedById = case_info.caseRec.CreatedById!==undefined?case_info.caseRec.CreatedById:'';
            
            if(this.case_record.City__c!=''||this.case_record.City__c!=undefined){
                this.case_record.City__c = case_info.caseRec.City__c;
                this.disablecity = true;
            }
            this.case_record.Country__c = case_info.caseRec.Country__c!==undefined?case_info.caseRec.Country__c:'Colombia';
            this.case_record.Additional_Information__c = case_info.caseRec.Additional_Information__c!==undefined?case_info.caseRec.Additional_Information__c:'';

            this.case_record.Reason_for_Closure__c = case_info.caseRec.Reason_for_Closure__c!==undefined?case_info.caseRec.Reason_for_Closure__c:'';
            

            this.case_number = case_info.caseRec.CaseNumber!==undefined?this.label.case+' '+case_info.caseRec.CaseNumber:this.label.case;
            if(case_info.caseRec.Sales_representative__r!==undefined){
                this.case_record.Sales_representative__c = case_info.caseRec.Sales_representative__r.Id;
                this.Sales_Representative = case_info.caseRec.Sales_representative__r.Name;
            }
            //this.case_record.Priority = case_info.caseRec.RecordTypeId;

            case_info.lstProductinfo.forEach(element => {
                this.index ++;
                let productInformation ={
                        id:this.index,
                        product:element.product,
                        productname:element.productname,
                        sku:element.sku,
                        skuname:element.skuname,
                        quality:element.quality,
                        lot_number:element.lot_number,
                        expiration_date:element.expiration_date,
                        date_of_receiving:element.date_of_receiving,
                        caseId:element.caseId,
                        recId:element.recId,
                        price:element.price
                    }
                    this.is_lst_productInformation = true;
                this.lst_productInformation.push(productInformation);   

            });
            this.start_product_size = this.lst_productInformation.length;
           console.log(" start_size =",this.lst_productInformation.length);
        }).catch(err=>{
            console.log('Error ',err);
        });
    }

    renderedCallback(){
        console.log('status ',this.show_productInformation);
        //console.log('Sales reps',this.sales_reps_userid,'Case_rec.salesreps',this.case_record.Sales_representative__c);
        if(this.case_record.AccountId!=='' && this.case_record.AccountId!==undefined){
           // console.log('Acc Id '+this.case_record.AccountId);
            this.sales_representative_filter = `Distributor__c ='${this.case_record.AccountId}' and Sales_Org_Code__c ='5710' and AccountOwner__r.Name!='Neebal User' and AccountOwner__r.Name!='SAP Integration User'`;
        }else{
            this.sales_representative_filter = "Sales_Org_Code__c ='5710' and AccountOwner__r.Name!='Neebal User' and AccountOwner__r.Name!='SAP Integration User'";
        }
    }


    handleAccountSelected(event){
        console.log('Event Account ',event.detail.recId);
        
        this.case_record.AccountId = event.detail.recId;
        console.log('Acc id ',this.case_record.AccountId);
        this.acc_name = event.detail.recName;
        this.parameter_value_salesresps = this.case_record.AccountId;
        getAccountEmailandPhone({accid:event.detail.recId}).then(email_and_phone=>{
            console.log("Email and phone ",email_and_phone);
            if(email_and_phone.length >0){
                this.case_record.Email__c = email_and_phone[0].Email__c!==undefined ? email_and_phone[0].Email__c: '';
                this.case_record.Mobile_Number_col__c = email_and_phone[0].Mobile__c!==undefined ?email_and_phone[0].Mobile__c: '';
                // this.case_record.ID_Number__c = email_and_phone[0].Tax_Number_1__c!==undefined ?email_and_phone[0].Tax_Number_1__c: '';
                if(email_and_phone[0].Tax_Number_1__c!==undefined){
                    this.case_record.ID_Number__c = email_and_phone[0].Tax_Number_1__c;
                    this.disable_idnumber = true; 
                }else{
                    this.disable_idnumber = false;
                }
            }
          fireEvent(this.pageRef,'disblesku','true');
        }).catch(err=>{
            console.log('unable to find email and phone for given Account ',err);
        });
        
    }

    handleRemoveAccount(event){
        console.log('remove Account');
        this.case_record.AccountId = '';
        this.acc_name = '';
        this.case_record.ID_Number__c = '';
        this.case_record.Email__c = '';
        this.case_record.Mobile_Number_col__c = '';
        this.disable_idnumber = false;
    }

    handleSelesRepSelected(event){
        console.log('Rec id',event.detail.recId);
        this.case_record.Sales_representative__c = event.detail.recId;
        this.Sales_Representative = event.detail.recName;
    }

    handleRemoveSelesRep(event){
        console.log('remove sales');
        this.case_record.Sales_representative__c = '';
        this.Sales_Representative = '';
    }

    handleAdditioninfo(event){
        this.case_record.Additional_Information__c = event.target.value;
    }
    handleReasonForClose(event){
        this.case_record.Reason_for_Closure__c = event.target.value;
    }
    
    handleSaveCase(event){
        this.show_spinner = true;
        console.log('show spinner ',this.show_spinner);
        this.deleteFile();
        if(this.checkValidation()==true){
            if(this.validateMandatoryProduct()==true){
            console.log('Case record-->',this.case_record)
            let text_mesg = this.label.Updated;
            if(this.case_record.Id===''){
                delete this.case_record.Id;
                text_mesg = this.label.Created;
            }
             
                SaveCase({ case_rec:this.case_record }).then(case_data=>{
                    let caseid = case_data.split(" ")[0]!==undefined? case_data.split(" ")[0]:'';
                    let isassign = JSON.parse(case_data.split(" ")[1])!==undefined? JSON.parse(case_data.split(" ")[1]):'';
                    console.log('Case insert success ',caseid+' is assign ',isassign);
                    this.showToastmessage('Success'," "+this.label.Case_record+" "+text_mesg+" "+this.label.successfully,'success');
                    this.handleAddProductInformation(caseid);
                    //console.log('Total file ',this.files.length);
                    this.show_spinner = false;
                    if(isassign==true){
                        console.log('assign ')
                        addAssignmentRule({case_id:caseid}).then(assign_data =>{
                            console.log('assign ',assign_data);
                        });
                    }
                    this.navigateToListView(caseid);
                }).catch(err=>{
                    console.log('case inserted falied ',err);
                    this.showToastmessage('Error',this.label.unable_to_created_Case_record,'error');
                    this.show_spinner = false;
                });
            }else{
                this.show_spinner = false;
            }
       }else{
           this.showToastmessage('Error',this.label.Mandatory_fields_can_not_be_empty,'error');
          // console.log('Validation excception');
          this.show_spinner = false;
       }
       
    }
    handleAddProductInformation(case_id){
        console.log('Case Id',case_id,' AND PRODUCT INFO ',this.lst_temp_productInformation);
        console.log('Case Num created : ',this.lst_temp_productInformation.length+' '+'Case Num deleted : ',this.lst_deleteproductInformation.length);
       makeProductList({case_id:case_id,productlst:JSON.stringify(this.lst_temp_productInformation)}).then(size =>{
           if(size>0 && this.lst_temp_productInformation.length>0){
            // this.showToastmessage('Success',this.lst_temp_productInformation.length +' Product Information updated successfully' ,'success');
            this.lst_temp_productInformation = [];
           }
       }).catch(err=>{
            this.showToastmessage('Error',this.label.Unable_to_add_Product_Information ,'error');
       });

       deleteProductList({case_id:this.lst_deleteproductInformation}).then(del_item=>{
        console.log(del_item);
       }).catch(err=>{
            this.showToastmessage('Error',this.label.Unable_to_delete_Product_Information ,'error');
       })
    }

    

   checkValidation(){
    // Priority Level
    // FAQ´s Quality
    // ID Number
    // Mobile Number
    // Sales Representative
    // Zone
    // City
    // Status
    if(this.case_record.Priority=='' || this.case_record.Priority==undefined){
        this.priority_level_required = true;
    }else{
        this.priority_level_required = false;
    }

    if(this.case_record.Type=='' || this.case_record.Type==undefined){
        this.faq_Quality_required = true;
    }else{
        this.faq_Quality_required = false;
    }

    if(this.case_record.ID_Number__c=='' || this.case_record.ID_Number__c==undefined){
        this.id_number_required = true;
    }else{
        this.id_number_required = false;
    }

    if(this.case_record.Mobile_Number_col__c=='' || this.case_record.Mobile_Number_col__c==undefined){
        this.mobile_num_required = true;
    }else{
        if(this.case_record.Mobile_Number_col__c.length==10){
        this.mobile_num_required = false;
        }else{
            this.mobile_num_required = true;
        }
    }

    // if(this.Sales_Representative=='' || this.Sales_Representative==undefined){ // Change latter
    //     this.Sales_Representative_required = true;
    // }else{
    //     this.Sales_Representative_required = false;
    // }
    if(this.case_record.Sales_representative__c=='' || this.case_record.Sales_representative__c==undefined){ // Change latter
        this.Sales_Representative_required = true;
    }else{
        this.Sales_Representative_required = false;
    }
    if(this.case_record.Zone__c=='' || this.case_record.Zone__c==undefined){
        this.Zone_required = true;
    }else{
        this.Zone_required = false;
    }
    if(this.case_record.City__c=='' || this.case_record.City__c==undefined){
        this.City_required = true;
    }else{
        this.City_required = false;
    }
    if(this.case_record.Status =='' || this.case_record.Status==undefined){
        this.Status_required = true;
    }else{
        this.Status_required = false;
    }

    if(this.case_record.FAQs_Effectiveness__c===true){
        console.log('Whem true this.case_record.FAQs_Effectiveness__c -->',this.case_record.FAQs_Effectiveness__c);
        this.account_require = false;
        if(this.case_record.Farmer_Name__c==''|| this.case_record.Farmer_Name__c==undefined){
            this.farmer_name_require = true;
        }else{
            this.farmer_name_require = false;
        }
    }

    if(this.case_record.FAQs_Effectiveness__c===false){
        console.log('When false this.case_record.FAQs_Effectiveness__c -->',this.case_record.FAQs_Effectiveness__c);
        this.farmer_name_require = false;
        if(this.case_record.AccountId==''|| this.case_record.AccountId==undefined){
            this.account_require = true;
        }else{
            this.account_require = false;
        }
    }

    if(this.case_record.Status == this.label.op_close){
        if(this.case_record.Reason_for_Closure__c == '' || this.case_record.Reason_for_Closure__c ==unable_to_created_Case_record){
            this.reason_for_close_required = true;
        }else{
            this.reason_for_close_required = false;
        }
    }else{
        this.reason_for_close_required = false;
    }

    console.log(`priority level ${this.priority_level_required} faq ${this.faq_Quality_required} id_num ${this.id_number_required} mobile ${this.mobile_num_required} salesreps ${this.Sales_Representative_required} xone${this.Zone_required} city ${this.City_required} status ${this.Status_required} account ${this.account_require} farmer    ${this.farmer_name_require}`); // need changes for country,zone , city

    if(this.priority_level_required==false&&this.faq_Quality_required==false&&this.id_number_required==false&&this.mobile_num_required==false&&this.Sales_Representative_required==false&&this.Zone_required==false&&this.City_required==false&&this.Status_required==false&&this.account_require==false&&this.farmer_name_require==false&&this.reason_for_close_required==false){
        return true;
    }else{
        return false;
    }
    }

    validateMandatoryProduct(){
        if(mandetory_for.includes(this.case_record.Type)){
            if(this.lst_productInformation.length==0){
                this.madetory_product_required = true;
                this.showToastmessage('Error',`${this.label.please_select_any_product}`,'error');
                return false;
            }else{
                this.madetory_product_required = true;
                return true;
            }
        }else{
            this.madetory_product_required = true;
            return true;
        }
    }

    validateproductionInfo(){
        console.log('product ',this.product)
        if(this.product==''||this.product==undefined){
            this.product_required = true;
        }else{
            this.product_required = false;
        }

        if(this.sku==''||this.sku==undefined){
            this.sku_required = true;
        }else{
            this.sku_required = false;
        }

        if(this.quality==''||this.quality==undefined){
            this.quality_required = true;
        }else{
            this.quality_required = false;
        }

        if(this.expiration_date==''||this.expiration_date==undefined){
            this.expiration_date_required = true;
        }else{
            this.expiration_date_required = false;
        }

        if(this.date_of_receving==''||this.date_of_receving==undefined){
            this.date_of_receiving_required = true;
        }else{
            this.date_of_receiving_required = false;
        }

        if(this.price==''||this.price==undefined){
            this.price_required = true;
        }else{
            this.price_required = false;
        }

        console.log(`product ${this.product_required===false} sku ${this.sku===false} quality ${this.quality===false} expiraton date ${this.expiration_date===false} receiving ${this.date_of_receving===false} Price ${this.price_required===false}`);

        if(this.product_required===false&&this.sku_required===false&&this.quality_required===false&&this.expiration_date_required===false&&this.date_of_receiving_required===false&&this.price_required===false){
            return true;
        }else{
            return false;
        }
    }
    
    addProductInformation(){
        this.index ++;
        let productInformation ={
            id:this.index,
            product:this.parentProductid,
            productname:this.product,
            sku:this.skuid,
            skuname:this.sku,
            quality:this.quality,
            lot_number:this.lot_number,
            expiration_date:this.expiration_date,
            date_of_receiving:this.date_of_receving,
            price:this.price,
            caseId :'',
            recId :'',
        }
        if(this.validateproductionInfo()==true){
            this.is_lst_productInformation = true;
        this.lst_productInformation.push(productInformation);
        this.lst_temp_productInformation.push(productInformation); // contain record to save in backend
        console.log('OLD lst production information ',JSON.stringify(this.lst_productInformation));
        console.log('NEW lst temp production information ',this.lst_temp_productInformation.length);
        //console.log('Added size ',this.lst_productInformation.length);
        //this.total_product_size = this.lst_temp_productInformation.length;
        console.log('Total product info list size ',this.lst_productInformation.length);
        this.clearFields();
        }else{
            console.log('validation exception product info');
        }
    }
    handleChangeDeleteRow(event){
        let del_index = this.lst_productInformation.findIndex((ele)=>ele.id === parseInt(event.target.dataset.rowid));
        console.log('this.lst_productInformation[del_index].recId--> ',this.lst_productInformation[del_index].recId);
        if(this.lst_productInformation[del_index].recId){
            this.lst_deleteproductInformation.push(this.lst_productInformation[del_index].recId);
        }
        this.lst_productInformation.splice(del_index,1);
        if(this.lst_productInformation.length===0){
            this.is_lst_productInformation = false;
        }
        console.log('OLD this.lst_productInformation',this.lst_productInformation.length);
        if(this.lst_temp_productInformation.length>0){
            let del_index1 = this.lst_temp_productInformation.findIndex((ele)=>ele.id === parseInt(event.target.dataset.rowid));
            console.log('lst temp1 --> del index',del_index1);
            // console.log('this.lst_temp_productInformation[del_index1].recId--> ',this.lst_temp_productInformation[del_index1].recId);
            if(del_index1!==-1){
            this.lst_temp_productInformation.splice(del_index1,1);
            }
        console.log('NEW this.lst_temp_productInformation-->',this.lst_temp_productInformation.length);
        }


    }
    handleProductSelected(event){
        this.parentProductid = event.detail.recId;
        this.product = event.detail.recName;
        console.log('recName ',event.detail.recName,'recId ',event.detail.recId);
        // 
        this.sku_filter = "Sales_Org_Code__c='5710' and Product_Name__c="+`'${this.parentProductid}'`;
        this.disableDependentsku = false;
       // console.log('disable -->',this.disableDependentsku);
    }
    handleRemoveproduct(event){
        this.parentProductid = '';
        this.product = '';
    }
    handleSkuSelected(event){
        this.skuid = event.detail.recId;
        this.sku = event.detail.recName;
        console.log('sku ',event.detail.recId);
    }
    handleRemoveSkU(event){
        console.log('remove sku');
        this.skuid = '';
        this.sku = '';
    }

    handleGoBack(){
        window.history.back();
    }

   
        navigateToListView(case_id) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: case_id,
                objectApiName: 'Case', // objectApiName is optional
                actionName: 'view'
            }
        });

        }

        filePreview(event) {
            // Naviagation Service to the show preview
            this[NavigationMixin.Navigate]({
                type: 'standard__namedPage',
                attributes: {
                    pageName: 'filePreview'
                },
                state : {
                    // assigning ContentDocumentId to show the preview of file
                    selectedRecordId:event.currentTarget.dataset.id
                }
              })
        }

        createMapfileDelete(event){
            console.log(event.target.dataset.docid);
            if(event.currentTarget.dataset.docid!==undefined){
               let obj = {
                   contentdoc_id:event.currentTarget.dataset.docid,
                   link_id:event.currentTarget.dataset.linkid,
               } 
               this.file_delete.push(obj);
               console.log('File delete ',this.file_delete);
               //this.deleteFile();
            }
            
            let del_index = this.lst_files.findIndex(ele => ele.fileid === event.currentTarget.dataset.row);
            console.log('Del index',del_index);
            if(del_index!==-1){
                this.lst_files.splice(del_index,1);
                if(this.lst_files.length===0){
                    this.is_files = false;
                }
            }
            console.log('lst files ',this.lst_files.length);
        }
        deleteFile(){
            if(this.file_delete.length>0){
                console.log('File to delete ',this.file_delete);
                //alert(JSON.stringify(this.file_delete));
            deleteFiles({lst_data:JSON.stringify(this.file_delete)}).then(size=>{
                console.log('File Deleted ',size);
                console.log('File uploaded ',this.files.length - size)
           }).catch(err=>{
            console.log('Err ',err);
           });
        }
        }

    clearFields(){
        this.product = '';
        this.sku = '';
        this.quality = '';
        this.lot_number  = '';
        this.expiration_date = '';
        this.date_of_receving = '';
        this.price = '';
        this.disableDependentsku = true;
    }

    disableAll(){
     this.disable_type = true;
     this.disable_faq_effective = true;
     this.disable_account = true;
     this.disable_farmer_name = true;
     this.disable_email = true;
     this.disable_phone = true;
     this.disable_priority = true;
     this.disable_idnumber = true;
     this.disablestatus = true;
     this.disableSales_reps = true;
     this.disablecountry = true;
     this.disable_zone = true;
     this.disablecity = true;
     this.disable_Product = true;
     this.disableDependentsku = true;
     this.disable_Quality = true;
     this.disable_lotnum = true;
     this.disable_price = true;
     this.disable_exprirationdate = true;
     this.disable_receivingdate = true;
     this.disable_additionalInfo = true;
     this.disableReasonClose = true;
     this.disable_addproductInfo = true;
     this.disable_removeproductInfo_btn = true;
     this.disable_removefile_btn = true;
     this.disableBtnSubmit = true;
    }
    
}