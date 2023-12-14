public with sharing class InvoiceController {
    @AuraEnabled(cacheable=true)
    public static List<Patient__c> getPatients() {
        return [SELECT Id, Name FROM Patient__c];
    }

    @AuraEnabled
    public static void createInvoice(Id patientId, Date entryDate, Date exitDate) {
        // Validate input parameters
        if (patientId == null || entryDate == null || exitDate == null) {
            throw new AuraHandledException('Invalid input parameters');
        }

        // Calculate number of days
        Integer numberOfDays = entryDate.daysBetween(exitDate);

        // Calculate amount based on your business logic (assuming $10,000 per day for simplicity)
        Decimal amount = numberOfDays * 10000;

        // Calculate discount based on the amount
        Decimal discount;
        if (amount > 50000 && amount <= 250000) {
            discount = amount * 0.05;
          } else if (amount > 250000) {
            discount = amount * 0.1;
          } else if(amount > 600000) {
            discount = amount * 0.15;
          } else {
            discount =0;
          }

        // Create Invoice__c record
        Invoice__c newInvoice = new Invoice__c(
            Patient_Invoice__c = patientId,
            Entry_Date__c = entryDate,
            Exit_Date__c = exitDate,
            Number_of_Days__c = numberOfDays,
            Amount__c = amount,
            Discount__c = discount
            // Add other relevant fields as needed
        );

        // Insert the new Invoice__c record
        try {
            insert newInvoice;
        } catch (DmlException e) {
            throw new AuraHandledException('Error creating invoice: ' + e.getMessage());
        }
    }
}
