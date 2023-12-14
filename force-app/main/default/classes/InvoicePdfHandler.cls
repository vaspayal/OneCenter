public with sharing class InvoicePdfHandler {
    public class InvoiceSender {
        public void sendEmails(List<Id> invoiceIds) {
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

            for (Id invoiceId : invoiceIds) {
                Invoice__c invoice = [SELECT Id FROM Invoice__c WHERE Id = :invoiceId];

                // Create the email message
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setTargetObjectId(invoice.Patient_Invoice__c);
                email.setSubject('Invoice for Payment');
                email.setPlainTextBody('Please find attached the invoice for your recent payment.');

                // Attach the invoice PDF
                PageReference invoicePage = new PageReference('/apex/InvoicePage?id=' + invoice.Id);
                Blob invoicePdf = invoicePage.getContentAsPDF();
                Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                attachment.setFileName('Invoice.pdf');
                attachment.setBody(invoicePdf);
                email.setFileAttachments(new List<Messaging.EmailFileAttachment>{attachment});

                // Add the email to the list
                emails.add(email);
            }

            // Send the emails
            Messaging.sendEmail(emails);
        }
    }

    public static void handleAfterUpdate(List<Invoice__c> updatedInvoices, Map<Id, Invoice__c> oldInvoiceMap) {
        List<Id> invoicesToSend = new List<Id>();

        for (Invoice__c invoice : updatedInvoices) {
            // Check if the invoice status has changed to 'Paid'
            if (invoice.Invoice_Status__c && !oldInvoiceMap.get(invoice.Id).Invoice_Status__c) {
                invoicesToSend.add(invoice.Id);
            }
        }

        // Create an instance of InvoiceSender and call sendEmails method
        InvoiceSender invoiceSender = new InvoiceSender();
        invoiceSender.sendEmails(invoicesToSend);
    }
}