trigger InvoicePdfTrigger on Invoice__c (after update) {
    InvoicePdfHandler.handleAfterUpdate(trigger.new, trigger.oldMap);
}