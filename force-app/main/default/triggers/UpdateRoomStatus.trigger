/*trigger UpdateRoomStatus on Patient__c (before insert, before update) {
    List<Rooms__c> roomsToUpdate = new List<Rooms__c>();
    Patient__c patient = new Patient__c();
       for(Patient__c patient: Trigger.new){
           if(!patient.Closure__c && patient.Rooms_Patient__c !=null){
               Rooms__c room = new Rooms__c(
               Id = patient.Rooms_Patient__c,
               Room_Status__c ='Occupied');
               roomsToUpdate.add(room); 
           }
       }
       if(!roomsToUpdate.isEmpty()){
           update roomsToUpdate;
       }
   
   }    */

   trigger UpdateRoomStatus on Patient__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            UpdateRoomStatusTriggerHandler.handleBeforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            UpdateRoomStatusTriggerHandler.handleBeforeUpdate(Trigger.oldMap, Trigger.new);
        }
    }
}
