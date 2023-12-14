import { LightningElement, track, wire } from 'lwc';
import getPatients from '@salesforce/apex/InvoiceController.getPatients';
import createInvoice from '@salesforce/apex/InvoiceController.createInvoice';

export default class RoomInvoiceGenerator extends LightningElement {
    @track selectedPatient;
    @track entryDate;
    @track exitDate;
    @track numberOfDays;
    @track amount;
    @track discount;
    @track invoiceGeneratedMessage;

    
    @wire(getPatients)
    patients;

    get patientOptions() {
        return this.patients.data ? this.patients.data.map(patient => ({ label: patient.Name, value: patient.Id })) : [];
    }

    handlePatientChange(event) {
        this.selectedPatient = event.detail.value;
    }

    handleEntryDateChange(event) {
        this.entryDate = event.target.value;
        this.calculateNumberOfDaysAndAmount();
    }

    handleExitDateChange(event) {
        this.exitDate = event.target.value;
        this.calculateNumberOfDaysAndAmount();
    }

    calculateNumberOfDaysAndAmount() {
        if (this.entryDate && this.exitDate) {
            const startDate = new Date(this.entryDate);
            const endDate = new Date(this.exitDate);
            const diffInDays = Math.ceil((endDate - startDate) / (1000 * 60 * 60 * 24));
            this.numberOfDays = diffInDays;
            this.amount = diffInDays * 10000;
            this.calculateDiscount();
        }
    }

    calculateDiscount() {
      if (this.amount > 50000 && this.amount <= 250000) {
        this.discount = this.amount * 0.05;
      } else if (this.amount > 250000) {
        this.discount = this.amount * 0.1;
      } else if(this.amount > 600000) {
        this.discount = this.amount * 0.15;
      } else {
          this.discount =0;
      }
    }

    handleSubmit() {
        if (this.selectedPatient && this.entryDate && this.exitDate) {
            createInvoice({ patientId: this.selectedPatient, entryDate: this.entryDate, exitDate: this.exitDate })
                .then(result => {
                    this.invoiceGeneratedMessage = 'Invoice generated successfully!';
                })
                .catch(error => {
                    console.error('Error creating invoice:', error);
                });
        } 
    }
}
