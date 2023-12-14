/*trigger EmailNotification on Patient__c (before insert){
    List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
  for(Patient__c newPatient:Trigger.new){
	if (newPatient.Email__c !=null){
	Messaging.SingleEmailMessage newMail = new Messaging.SingleEmailMessage();
	List<String> sendTo = new List<String>(); 	
	List<String> hospAddress = new List<String>{ 'pnareshvaswani@deloitte.com' };
    
    newMail.setToAddresses(sendTo);
	newMail.setCcAddresses(hospAddress);
	newMail.setReplyTo('bmanojludhani@deloitte.com');
    newMail.setSenderDisplayName('Payal');
	newMail.setSubject('New Patient Added');
	newMail.setHtmlBody('A new patient record has been added');
	mailList.add(newMail);
	//newMail.setToAddresses(new List<String>{'hospitalmanagement@gmail.com', newPatient.Email__c});
	mailList.add(newMail);
	}
}
Messaging.sendEmail(mailList);
}*/


trigger EmailNotification on Patient__c (before insert) {
    EmailNotificationHandler.handleNewPatients(Trigger.new);
}
