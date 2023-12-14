public class InvoiceStatusAndEmailHandler {
    public static void handleAfterUpdate(List<Invoice__c> newInvoices, Map<Id, Invoice__c> oldInvoiceMap) {
        List<Invoice__c> updatedInvoices = new List<Invoice__c>();
        Set<Id> patientIds = new Set<Id>();
        
        for (Invoice__c newInvoice : newInvoices) {
            // Check if the status changed to 'Paid'
            Boolean newStatus = newInvoice.Invoice_Status__c;
            Boolean oldStatus = oldInvoiceMap.get(newInvoice.Id).Invoice_Status__c;
            
            if (newStatus && !oldStatus) {
                updatedInvoices.add(newInvoice);
                patientIds.add(newInvoice.Patient_Invoice__c);
            }
        }
        
        if (!updatedInvoices.isEmpty()) {
            // get patient information
            Map<Id, Patient__c> patientsMap = new Map<Id, Patient__c>([SELECT Id, Name, Email__c FROM Patient__c WHERE Id IN :patientIds]);

            // Update Patient closure checkbox to true
            List<Patient__c> updatedPatients = new List<Patient__c>();
            for (Id patientId : patientIds) {
                Patient__c patient = patientsMap.get(patientId);
                if (patient != null) {
                    updatedPatients.add(new Patient__c(Id = patientId, Closure__c = true));
                }
            }

            // Send closure email 
            sendClosureEmailToHospitalManagement(updatedInvoices, patientsMap);
            sendWellBeingEmailToPatients(updatedPatients);

            // Update patients with closure checkbox
            update updatedPatients;

            // Prevent editing of paid invoices
            preventEditingOfPaidInvoices(updatedInvoices);
        }
    }

    private static void sendClosureEmailToHospitalManagement(List<Invoice__c> invoices, Map<Id, Patient__c> patientsMap) {
        for (Invoice__c invoice : invoices) {
            Patient__c patient = patientsMap.get(invoice.Patient_Invoice__c);
            if (patient != null) {
                String hospitalManagementEmail = 'pnareshvaswani@deloitte.com';

                // Send email to Hospital Management
                Messaging.SingleEmailMessage emailToHospital = new Messaging.SingleEmailMessage();
                emailToHospital.setToAddresses(new String[]{hospitalManagementEmail});
                emailToHospital.setSubject('Patient Closure Notification');
                emailToHospital.setPlainTextBody('Patient ' + patient.Name + ' with Invoice ID ' + invoice.Id + ' has been closed.');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{emailToHospital});
            }
        }
       
    }

    private static void sendWellBeingEmailToPatients(List<Patient__c> patients) {
        for (Patient__c patient : patients) {
            if (patient.Email__c != null) {
                Messaging.SingleEmailMessage wellBeingEmail = new Messaging.SingleEmailMessage();
                wellBeingEmail.setToAddresses(new String[]{patient.Email__c});
                wellBeingEmail.setSubject('Well-being Message');
                wellBeingEmail.setPlainTextBody('Thank you for choosing our services, ' + patient.Name + '. We wish you a speedy recovery.');
    
                try {
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[]{wellBeingEmail});
                } catch (Exception e) {
                    // Handle the exception (log, rethrow, etc.)
                    System.debug('Error sending well-being email to patient ' + patient.Name + ': ' + e.getMessage());
                }
            }
        }
    }

    private static void preventEditingOfPaidInvoices(List<Invoice__c> invoices) {
        for (Invoice__c invoice : invoices) {
            if (invoice.Invoice_Status__c) {
                invoice.addError('Paid invoices cannot be edited.');
            }
        }
    }
}
