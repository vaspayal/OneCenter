public class DuplicateValuesHandler {
    public static void handleDuplicateValues(List<Patient__c> patients) {
        Set<String> emailSet = new Set<String>();
        Set<String> phoneSet = new Set<String>();

        for (Patient__c patient : patients) {
            if (emailSet.contains(patient.Email__c) || phoneSet.contains(patient.Phone__c)) {
                patient.addError('You are inserting a duplicate record');
            } else {
                emailSet.add(patient.Email__c);
                phoneSet.add(patient.Phone__c);
            }
        }
    }
}