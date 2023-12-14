trigger AvoidDeletionOfHospital on Hospital__c (before delete) {
    AvoidDeletionOfHospitalHandler.handleBeforeDelete(Trigger.old);
}
