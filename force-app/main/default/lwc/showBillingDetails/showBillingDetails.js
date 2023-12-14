// showBillingDetails.js
import { LightningElement, api } from 'lwc';

export default class ShowBillingDetails extends LightningElement {
    @api patientName;
    @api invoiceAmount;
    @api entryDate;
    @api exitDate;

    connectedCallback() {
        // You can perform additional actions upon component initialization here
        console.log('Component connected to the DOM');
    }
}
