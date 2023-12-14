public with sharing class PatientController {

/* @AuraEnabled(cacheable=true)
   public static List<String> getPatientNames() {
        List<String> patientNames = new List<String>();

        List<Patient__c> patients = [SELECT Name FROM Patient__c WHERE Rooms_Patient__r.Room_Status__c ='Occupied'];
       for (Patient__c patient : patients) {
            patientNames.add(patient.Name);
        }

        return patientNames;
    }*/


    @AuraEnabled(cacheable=true)
    public static List<Hospital__c> getHospitalOptions() {
        return [SELECT Id, Name FROM Hospital__c];
    }

    @AuraEnabled
public static Id createFeedbackRecord(Feedback__c feedbackRecord) {
    try {
        insert feedbackRecord;
        return feedbackRecord.Id;
    } catch (Exception e) {
        throw new AuraHandledException('Error creating feedback record: ' + e.getMessage());
    }
}

    /*@AuraEnabled(cacheable=true)
    public static List<Hospital__c> getHospitals() {
        return [SELECT Id, Name FROM Hospital__c ORDER BY Name ASC];
    }
*/
}
