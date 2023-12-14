trigger DuplicateValues on Patient__c (before insert) {
    DuplicateValuesHandler.handleDuplicateValues(Trigger.new);
}