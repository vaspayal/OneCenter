// RoomSummaryController.cls
public class RoomSummaryController {
    @AuraEnabled
    public static List<Patient__c> getPatients(String roomId) {
        // Retrieve the patient data from the Apex class
        return [SELECT Id, Name, Phone__c FROM Patient__c WHERE Room__c = :roomId];
    }

    @AuraEnabled
    public static List<Invoice__c> getInvoices(String roomId) {
        // Retrieve the invoice data from the Apex class
        return [SELECT Id, Description__c, Amount__c FROM Invoice__c WHERE Room__c = :roomId];
    }

    @AuraEnabled
    public static String downloadPdf(String roomId) {
        // Retrieve the patient and invoice data from the Apex class
        List<Patient__c> patientList = getPatients(roomId);
        List<Invoice__c> invoiceList = getInvoices(roomId);

        // Generate the PDF and return the content document ID
        String contentDocumentId = Your_Class_Here.generatePdf(patientList, invoiceList);
        return contentDocumentId;
    }
}