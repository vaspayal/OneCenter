trigger FeedbackTrigger on Feedback__c (after insert) {
    FeedbackTriggerHandler.handleBadOrWorstFeedback(trigger.new);
}