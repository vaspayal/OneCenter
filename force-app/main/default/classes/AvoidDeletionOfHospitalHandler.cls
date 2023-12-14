public class AvoidDeletionOfHospitalHandler {
    public static void handleBeforeDelete(List<Hospital__c> hospitals) {
        for (Hospital__c hospital : hospitals) {
            if (hospital.Total_Rooms__c != 0) {
                hospital.addError('Cannot delete hospital with occupied rooms.');
            }
        }
    }
}
