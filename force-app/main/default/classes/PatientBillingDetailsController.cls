public class PatientBillingDetailsController {
    @AuraEnabled(cacheable=true)
    public static Invoice__c getInvoiceDetails(String invoiceId) {
        return [SELECT Id, Amount__c, Entry_Date__c, Exit_Date__c, Patient_Invoice__r.Name FROM Invoice__c WHERE Id = :invoiceId LIMIT 1];
    }
}
