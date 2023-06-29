import BaseChatMessage from 'lightningsnapin/baseChatMessage';
import strUserId from '@salesforce/user/Id';
//import getCustomerDetail from '@salesforce/apex/LWCExampleController.getCustomerDetail';
//import getBrandDetail from '@salesforce/apex/ChatBot_LWCComponentController.getBrandDetail';
import getInventoryDetails from '@salesforce/apex/ChatBot_LWCComponentController.getInventoryDetails';
import getOrderStatus from '@salesforce/apex/ChatBot_LWCComponentController.getOrderStatus';
import getCustomerOrderDetails from '@salesforce/apex/ChatBot_LWCComponentController.getCustomerOrderDetails';
//import sendPdf from '@salesforce/apex/LWC_PdfEmailController.sendPdf';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { track, api,wire} from 'lwc';

const CHAT_CONTENT_CLASS = 'chat-content';
const AGENT_USER_TYPE = 'agent';
const CHASITOR_USER_TYPE = 'chasitor';
const SUPPORTED_USER_TYPES = [AGENT_USER_TYPE, CHASITOR_USER_TYPE];
var prevMsg=[];
var chatKey;

const cols = [
    
    {label: 'SAP Order No',fieldName: 'OrderNumber',wrapText:true,initialWidth:100},
    {label: 'Status',fieldName: 'Status',wrapText:true,initialWidth:100},
    {label: 'Currency',fieldName: 'currencyCode',wrapText:true,initialWidth:70},
    {label: 'Net Value ',fieldName: 'NetVal',wrapText:true,initialWidth:100}
    
    
];

const cols1 = [
    {label: 'Depot Code',fieldName: 'DepotCode',wrapText:true,initialWidth:80},
    {label: 'SKU Code',fieldName: 'SKUcode',wrapText:true,initialWidth:80},
    {label: 'SKU Name',fieldName: 'BrandName',wrapText:true,initialWidth:100},
    {label: 'Stock',fieldName: 'Quantity',wrapText:true,initialWidth:100,cellAttributes: { alignment: 'center' }},
    {label: 'UOM',fieldName: 'UOM',wrapText:true,initialWidth:70}
];

const cols2 = [
    
    {label: 'SAP Order No',fieldName: 'OrderNumber',wrapText:true,initialWidth:100},
    {label: 'Order Date',fieldName: 'OrderDate',wrapText:true,initialWidth:100},
    {label: 'Currency',fieldName: 'currencyCode',wrapText:true,initialWidth:70},
    {label: 'Net Value',fieldName: 'NetVal',wrapText:true,initialWidth:100}
    
];

/**
 * Displays a chat message using the inherited api messageContent and is styled based on the inherited api userType and messageContent api objects passed in from BaseChatMessage.
 */
export default class ChatMessageDefaultUI extends BaseChatMessage {
    @track messageStyle = '';
    @track custmMsg = '';
    @api requestJson = {};
    @track showSalesMTDbyCustomer1 = false;
    @track showData=false;
    @track OrderStatusColumns = cols;
    @track OrderDetailColumns = cols2;
    @track data;
    @api userTypeCss;
    @track brandColumns=cols1;
    @track brandData;
    @track showBrandDetails = false;
    @track isShow1=true;
    @track isShow2=false;
    @track orderStatus;
    @track showOrderStatus=false;
    @track uName=strUserId;
    @track noDataFound=false;
    @track orderDetailsData;
    @track showOrderDetails=false;
    @track strMessage = ''; 
    @track isBaseTextVisible = false;
    @track isBaseTextVisible1 = false;
    @track previousMsg='';

    isSupportedUserType(userType) {
        return SUPPORTED_USER_TYPES.some((supportedUserType) => supportedUserType === userType);
    }
    
    connectedCallback() {
        //console.log('username-->',this.uName);
        this.strMessage = this.messageContent.value;
        if (this.isSupportedUserType(this.userType)) {
            this.requestJson = JSON.parse(JSON.stringify(this.messageContent));
            //console.log(JSON.parse(JSON.stringify(this)));
            //console.log('Message ----> ', this.messageContent);
            this.custmMsg = this.messageContent.value;
            //console.log(' custmMsg Message ----> ', this.custmMsg);
            //console.log('User Type-----> ',this.userType.CHASITOR_USER_TYPE);

            if(this.userType===CHASITOR_USER_TYPE){
                prevMsg.push(this.messageContent.value);
                //console.log('Previous user messages-->',prevMsg);
            }

           

            if (this.userType == 'agent' && this.messageContent.value.startsWith('lwc:example')){
                    //this.samplevar=true;
                    chatKey=this.messageContent.value;
                    chatKey=chatKey.split('=',2)[1];
                    console.log(' this.chatKey', chatKey);
                    console.log('chatKey Id',this.messageContent.value);
            }
            else if(this.userType == 'agent' && this.messageContent.value.startsWith('Getting order status information')){
                //this.b1=prevMsg[prevMsg.length-1];
                //console.log("Previous mesg",prevMsg);
                this.getOrderStatus();
            }
            else if(this.userType == 'agent' && this.messageContent.value.startsWith('Getting order details')){
                //this.b1=prevMsg[prevMsg.length-1];
                //console.log("Previous mesg",prevMsg);
                this.getCustOrderDetails();
            }
            else if(this.userType == 'agent' && this.messageContent.value.startsWith('Searching Inventory')){
                //console.log('searching brands Message ----> ', this.custmMsg);
                    this.previousMsg=prevMsg[prevMsg.length-1];
                    console.log("Previous mesgs-->",prevMsg);
                    console.log("Previous mesg---->",this.previousMsg);
                    this.getBrandData();//isShow2=false
                }
           /*else if(this.userType == 'agent' && this.messageContent.value.startsWith('Searching inventory status')){
            //console.log('searching brands Message ----> ', this.custmMsg);
                //this.b1=prevMsg[prevMsg.length-1];
                //console.log("Previous mesg",prevMsg);
                this.getBrandData(this.isShow2);//isShow2=false
            }
            else if(this.userType == 'agent' && this.messageContent.value.startsWith('Searching inventory information')){
                //console.log('searching brand Message ----> ', this.custmMsg);
                //this.b1=prevMsg[prevMsg.length-1];
                //console.log("Previous mesg",prevMsg);
                this.getBrandData(this.isShow1);//isShow1=true
            }
            else if(this.userType == 'agent' && this.messageContent.value.startsWith('Please wait')){
                //console.log('searching brand Message ----> ', this.custmMsg);
                //this.b1=prevMsg[prevMsg.length-1];
                //console.log("Previous mesg",prevMsg);
                console.log(chatKey);
                this.getBrandData(this.isShow1);//isShow1=true
            }*/
            else if (this.userType == 'agent' && !this.messageContent.value.startsWith('lwc:hide'))
            {   
                
                this.isBaseTextVisible = true;
                this.messageStyle = `${CHAT_CONTENT_CLASS} ${this.userType}`;
            }
            else if (this.userType == 'chasitor' && !this.messageContent.value.startsWith('lwc:hide'))
            {   
                this.isBaseTextVisible1 = true;
                
                this.messageStyle = `${CHAT_CONTENT_CLASS} ${this.userType}`;
            }
            /*if(this.custmMsg.includes("LWC Component")){
                //this.b1=prevMsg[prevMsg.length-1];
                console.log("welcome to LWC");
                console.log('Previous user messages-->',prevMsg);
                this.showData=true;
                console.log("this.showData",this.showData);
            }*/
          
            this.custmMsg =this.custmMsg;//+"<table class='test slds-table slds-table_cell-buffer slds-table_bordered'><tbody><tr><td style='background:red'><a href='#' onlcick=downloadCSV>"+this.requestJson.value+"</a></td></tr></tbody></table>";
            // this.messageContent.value = this.requestJson;
            this.messageStyle = `${CHAT_CONTENT_CLASS} ${this.userType}`; 
            
        } else {
            throw new Error(`Unsupported user type passed in: ${this.userType}`);
        }
        
    }
  

    
    

    /*for brand data */
    getBrandData(){
        //console.log("value to pass--",isShow3);
        console.log("Brand Name--",prevMsg[prevMsg.length-1]);
        //console.log("is true--",isShow3);
        console.log("Session Id--",chatKey);
        //console.log('splitted value--',string.split('-',prevMsg[prevMsg.length-3])[1]);
        //var brandDepoCode=prevMsg[prevMsg.length-1]+'-'+string.split('-',prevMsg[prevMsg.length-3])[1];
        //console.log("value to pass--",brandDepoCode);
        //this.vBrandDetailsStatus=isShow3;
        //this.vBrandDetails=prevMsg[prevMsg.length-1];
        console.log("Console print1");
        getInventoryDetails({BrandName:prevMsg[prevMsg.length-1],ChatKey:chatKey})
        .then(result =>{
            console.log("Console print2");
            //console.log('Previous user messages in method-->',prevMsg);
            this.brandData=result;
            //console.log("Data From Class",JSON.stringify(result));
            console.log("Data From Class1",this.brandData);
            if(this.brandData.length>0){
                this.showBrandDetails=true;
            }else{
                this.noDataFound=true;
            }

        }).catch(error =>{
            this.error=error;
            this.brandData=undefined;
            //console.log('data--error--->',this.error);
        })

    }
/* For Order Status */
    getOrderStatus(){
        //console.log('Order Number-->',prevMsg[prevMsg.length-1]);
        getOrderStatus({OrderNumber:prevMsg[prevMsg.length-1]})
        .then(result =>{
            this.orderStatus=result;
            //console.log("Order Status-->",this.orderStatus);
            //console.log("Order Status result-->",JSON.stringify(result));
            if(this.orderStatus.length>0){
                this.showOrderStatus=true;
            }else{
                this.noDataFound=true;
            }
        }).catch(error =>{
            this.error=error;
            this.orderStatus=undefined;
            //console.log('data--error--->',this.error);
        })

    }
/*For Customer Order Details */
    getCustOrderDetails(){
        getCustomerOrderDetails({OrderNumber:prevMsg[prevMsg.length-1]})
        .then(result =>{
            this.orderDetailsData=result;
            //console.log("Order Details-->",this.orderDetailsData);
            //console.log("Order Details result-->",JSON.stringify(result));
            if(this.orderDetailsData.length>0){
                this.showOrderDetails=true;
            }else{
                this.noDataFound=true;
            }
        }).catch( error =>{
            this.error=error;
            this.orderDetailsData=undefined;
            //console.log('data--error--->',this.error);
        })
    }

    // sendEmail(){
    //     console.log('Sending file');
    //     sendPdf()
    //     .then(result => {
    //         this.dispatchEvent(
    //             new ShowToastEvent({
    //                 title: 'Email ', 
    //                 message: 'Email send successfully..',
    //                 variant: 'success'
    //             }),
    //         );
    //     })
       
    // } 
    // this method validates the data and creates the csv file to download
    /*downloadCSVFile() {   
        let rowEnd = '\n';
        let csvString = '';
        // this set elminates the duplicates if have any duplicate keys
        let rowData = new Set();

        // getting keys from data
        this.orderDetailsData.forEach(function (record) {
            Object.keys(record).forEach(function (key) {
                rowData.add(key);
            });
        });

        // Array.from() method returns an Array object from any object with a length property or an iterable object.
        rowData = Array.from(rowData);
        
        // splitting using ','
        csvString += rowData.join(',');
        csvString += rowEnd;

        // main for loop to get the data based on key value
        for(let i=0; i < this.orderDetailsData.length; i++){
            let colValue = 0;

            // validating keys in data
            for(let key in rowData) {
                if(rowData.hasOwnProperty(key)) {
                    // Key value 
                    // Ex: Id, Name
                    let rowKey = rowData[key];
                    // add , after every value except the first.
                    if(colValue > 0){
                        csvString += ',';
                    }
                    // If the column is undefined, it as blank in the CSV file.
                    let value = this.orderDetailsData[i][rowKey] === undefined ? '' : this.orderDetailsData[i][rowKey];
                    csvString += '"'+ value +'"';
                    colValue++;
                }
            }
            csvString += rowEnd;
        }

        // Creating anchor element to download
        let downloadElement = document.createElement('a');

        // This  encodeURI encodes special characters, except: , / ? : @ & = + $ # (Use encodeURIComponent() to encode these characters).
        downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvString);
        downloadElement.target = '_self';
        // CSV File Name
        downloadElement.download = 'Order Data.csv';
        // below statement is required if you are using firefox browser
        document.body.appendChild(downloadElement);
        // click() Javascript function to download CSV file
        downloadElement.click(); 
    }*/
    /* Neely Added 
    getSalesMTDAccountWise1(){
        console.log("Method called");
        console.log("value",this.messageContent.value);
        getCustomerDetail({SAPNumber:this.messageContent.value})
        .then(result => {
            console.log("Method called 1");
            console.log("previous message1-->",prevMsg[prevMsg.length-1]);
            console.log("previous message-->",prevMsg[prevMsg.length-2]);
            this.custData = result;
            console.log("Data From Class",JSON.stringify(result));
            console.log("Data From Class1",this.custData);
            this.showSalesMTDbyCustomer1 = true;
            console.log('data--showSalesMTDbyCustomer case--->',this.data);
        })
        .catch(error => {
            this.error = error;
          
            this.custData = undefined;
            console.log('data--error--->',this.error);
            console.log('data--error--->',this.data);
        });
    }

 Ended */
    
}