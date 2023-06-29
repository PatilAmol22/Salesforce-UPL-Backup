import { LightningElement,api } from 'lwc';
import Download_Invoice from '@salesforce/label/c.Download_Invoice';


export default class ResponsiveCard extends LightningElement {
    @api tableData;
    @api columns;
    @api colombiaCurrency;
    @api country;
    @api customerCode;
    @api customerName;
    @api city;
    @api chileOrderLink;
    @api creditChile;
    @api debitChile;
    records=[];
    isButtonClick = false;
    connectedCallback(){
        console.log('columns =>> ',this.columns);
        console.log('tableData =>> ',this.tableData);
        console.log('country',this.country);
        let data=[];
        let newData = {"Id":""};
        this.updateValues();
               
       
    }
    @api
    updateValues(){
        const jsonC = [];

        for (const objB of this.tableData) {
            const data = [];
            for (const objA of this.columns) {
                const label = objA.label;
                const type = objA.type;
                const typeAttributes = objA.typeAttributes;
                const fieldName = objA.fieldName;
                const iconName = objA.iconName;
                var value = objB[fieldName];
                var name = typeAttributes != undefined ? typeAttributes.name:"";
                if(this.country == 'Mexico' && label == 'Orden de venta'){
                    
                    if(value == null || value == undefined){
                        value = objB['SFDCOrderNumber']
                    }
                }
                if(fieldName.includes('__r.')){
                    var childArr=fieldName.split('.');
                    value = objB[childArr[0]][childArr[1]];

                }
                if(type == "iconbutton"){
                    name = objA.name;
                }
             
                const currencyCode = typeAttributes != undefined ? typeAttributes.currencyCode != undefined ? typeAttributes.currencyCode: typeAttributes.currencyCodeCountry!= undefined ?typeAttributes.currencyCodeCountry == 'Colombia'?"COP":typeAttributes.currencyCodeCountry == 'Poland'?"PLN":"":"":"";
                if(label == Download_Invoice && this.country =='Poland'){
                    break;
                }else if(this.creditChile==true && this.debitChile==false && fieldName=='Debit'){
                    console.log('if Credit');
                    //break;    
                }else if(this.debitChile==true && this.creditChile==false && fieldName=='Credit'){
                    console.log('if Debit');
                    //break;
                }else{
                data.push({
                    "label": label,
                    "value": value,
                    "fieldName": fieldName,
					"type" : type,
                    "isCurrency" : type == 'currency' ? true : false,
                    "currencyCode": currencyCode,
                    "currencyDisplayAs" : typeAttributes != undefined ? typeAttributes.currencyDisplayAs:"",
                    "typeAttributes" : typeAttributes,
                    "name":name,
                    "isButton": type == 'button' ? this.country =='Poland' && name == 'Download'? false : true : false,
                    "isIcon": type == 'iconbutton' ? true : false,
                    "docId" : value,
                    "iconName" : iconName,
                    "isDate": type == 'date-local' ? true : false,
                    "isNumber": type == 'Number' ? true : false,
                    "fractionDigit": objA.fractionDigit != null && objA.fractionDigit != undefined ? objA.fractionDigit : "0",
                    "isCustomerCode":type == 'CustomerCodeCl' ? true : false,
                    "isChileCurrency": type == 'currencyChile' ? true : false,
                    'isExpiredImg': type == 'ExpiredImg' ? true : false,
                    "isClientName": type== 'chileClient' ? true : false
                });
                }
               
            }
            
            if(data.length>0){
                jsonC.push({
                    "Id": ((this.country == 'Mexico' || this.country =='Chile') && objB.ivId != null && objB.ivId != undefined ) ? objB.ivId : objB.Id,
                    "data":data
    
                });
            }
           
        }
        console.log('JSON C=> ',jsonC);
        this.records=jsonC;
    }
    showDetails(event){
        if(this.country != 'Poland' && !this.isButtonClick){
            const showEvent = new CustomEvent("show",{detail:event.currentTarget.dataset.id});
            this.dispatchEvent(showEvent); 
        }else{
            this.isButtonClick = !this.isButtonClick;
        }
       
    }
    handleClick(event){
        console.log('on button click');
        this.isButtonClick = true;
        console.log('dataSEt=> ',event);
        if(this.country == 'Poland' || this.country == 'Chile' || this.country == 'Mexico'){
            const showEvent = new CustomEvent("buttonclick",{detail:{Id:event.currentTarget.dataset.id, actionName:event.currentTarget.dataset.actionName }});
            this.dispatchEvent(showEvent); 
        }
    }
    

}