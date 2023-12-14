//public with sharing class UpdateRoomStatusTriggerHandler {
   
    public with sharing class UpdateRoomStatusTriggerHandler {
        public static void handleBeforeInsert(List<Patient__c> newPatients) {
            List<Rooms__c> roomsToUpdate = new List<Rooms__c>();
            
            for (Patient__c patient : newPatients) {
                if (!patient.Closure__c && patient.Rooms_Patient__c != null) {
                    Rooms__c room = new Rooms__c(
                        Id = patient.Rooms_Patient__c,
                        Room_Status__c = 'Occupied'
                    );
                    roomsToUpdate.add(room);
                }
            }
    
            if (!roomsToUpdate.isEmpty()) {
                update roomsToUpdate;
            }
        }
    
        public static void handleBeforeUpdate(Map<Id, Patient__c> oldMap, List<Patient__c> updatedPatients) {
            List<Rooms__c> roomsToUpdate = new List<Rooms__c>();
            
            for (Patient__c patient : updatedPatients) {
                Patient__c oldPatient = oldMap.get(patient.Id);
                
                if (!patient.Closure__c && patient.Rooms_Patient__c != null 
                    && (oldPatient == null || oldPatient.Rooms_Patient__c != patient.Rooms_Patient__c)) {
                    Rooms__c room = new Rooms__c(
                        Id = patient.Rooms_Patient__c,
                        Room_Status__c = 'Occupied'
                    );
                    roomsToUpdate.add(room);
                }
            }
    
            if (!roomsToUpdate.isEmpty()) {
                update roomsToUpdate;
            }
        }
    }
    

    
