import LightningDatatable from 'lightning/datatable';
import { LightningElement } from 'lwc';
import custompicklist from './custompicklist.html';

export default class Customtypepicklist extends LightningDatatable {

    static customTypes = {
        multiselectpicklist: {
            template: custompicklist,
            standardCellLayout: true,
            typeAttributes: ['label', 'placeholder', 'options', 'value', 'context', 'variant','name']
        }
    };
}