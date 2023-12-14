import { LightningElement, wire } from 'lwc';
import { getPatientsByRoom } from 'c.roomSummaryController';
import { jsPDF } from 'jspdf';

export default class RoomSummary extends LightningElement {
    patientData;
    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Stay Time', fieldName: 'Number_of_Days__c' },
        { label: 'Amount', fieldName: 'Amount__c' }
    ];

    @wire(getPatientsByRoom, { roomId: '$recordId' })
    wiredPatients({ error, data }) {
        if (data) {
            this.patientData = data;
        } else if (error) {
            // Handle error
            console.error(error);
        }
    }

    handleDownload() {
        // Implement the download functionality to save the information in PDF format
       

        const doc = new jsPDF();
        let tableData = [];
        
        // Format patientData into tableData
        this.patientData.forEach(patient => {
            tableData.push([
                patient.Name,
                patient.Number_of_Days__c,
                patient.Amount__c
            ]);
        });

        doc.autoTable({
            head: [['Name', 'Stay Time', 'Amount']],
            body: tableData
        });

        doc.save('RoomSummary.pdf');
    }
}
