public class EmailNotificationHandler {
    public static void handleNewPatients(List<Patient__c> newPatients) {
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();

        for (Patient__c newPatient : newPatients) {
            if (newPatient.Email__c != null) {
                Messaging.SingleEmailMessage newMail = new Messaging.SingleEmailMessage();
                
                // Specify the recipient email address
                List<String> sendTo = new List<String>{newPatient.Email__c};
                List<String> hospAddress = new List<String>{'pnareshvaswani@deloitte.com'};
                
                newMail.setToAddresses(sendTo);
                newMail.setCcAddresses(hospAddress);
                newMail.setReplyTo('bmanojludhani@deloitte.com');
                newMail.setSenderDisplayName('Payal');
                newMail.setSubject('New Patient Added');
                newMail.setHtmlBody('A new patient record has been added');
                
                mailList.add(newMail);
            }
        }

        Messaging.sendEmail(mailList);
    }
}
