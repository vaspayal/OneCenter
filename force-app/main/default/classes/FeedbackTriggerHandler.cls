public class FeedbackTriggerHandler {
    public static void handleBadOrWorstFeedback(List<Feedback__c> feedbackList) {
        Set<String> badOrWorstFeedbackIds = new Set<String>();
        
        for (Feedback__c feedback : feedbackList) {
            if (feedback.OverallRating__c == 'Bad' || feedback.OverallRating__c == 'Worst') {
                badOrWorstFeedbackIds.add(feedback.Id);
            }
        }
        
        if (!badOrWorstFeedbackIds.isEmpty()) {
            sendEmailToHospitalManagement(badOrWorstFeedbackIds);
        }
    }
    
    private static void sendEmailToHospitalManagement(Set<String> feedbackIds) {
        
        List<String> toAddresses = new List<String> { 'pnareshvaswani@deloitte.com' };
        String subject = 'Bad or Worst Feedback Received';
        String body = 'Dear Hospital Management,\n\n';
        body += 'The following feedback record(s) with overall rating "Bad" or "Worst" have been received:\n\n';
        
        List<Feedback__c> feedbackRecords = [SELECT Name, OverallRating__c, Comments__c FROM Feedback__c WHERE Id IN :feedbackIds];
        for (Feedback__c feedback : feedbackRecords) {
            body += 'Feedback Name: ' + feedback.Name + '\n';
            body += 'Overall Rating: ' + feedback.OverallRating__c + '\n';
            body += 'Comments: ' + feedback.Comments__c + '\n\n';
        }
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(toAddresses);
        email.setCcAddresses(toAddresses);
        email.setSubject(subject);
        email.setPlainTextBody(body);
        
        Messaging.SendEmailResult[] emailResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        
        if (emailResults[0].isSuccess()) {
            System.debug('Email sent successfully to Hospital Management');
        } else {
            System.debug('Failed to send email to Hospital Management: ' + emailResults[0].getErrors()[0].getMessage());
        }
    }
}