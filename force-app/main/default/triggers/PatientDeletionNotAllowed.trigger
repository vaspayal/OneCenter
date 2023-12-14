trigger PatientDeletionNotAllowed on Patient__c (before delete) {
    if(Trigger.isBefore){
        if(Trigger.isDelete){
            PatientDeletionNotAllowedHandler.patientDeletionHandler(trigger.old);
        }
        }
    }
