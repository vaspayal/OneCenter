public with sharing class PatientDeletionNotAllowedHandler {
    public static void patientDeletionHandler(List<Patient__c>newPatient) {
       // newPatient = [SELECT Id FROM Patient__c WHERE Id IN :Trigger.new ];
        for(Patient__c patientToCheck: newPatient){
            if(patientToCheck.Closure__c == false){
                patientToCheck.addError('You can not delete record that has closure as false.'); 
            }
        }

    }
}