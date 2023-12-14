trigger InvoiceStatusAndEmail on Invoice__c (before update,after update)  {
        if(Trigger.isInsert || Trigger.isUpdate) {
            InvoiceStatusAndEmailHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        }
}
    
