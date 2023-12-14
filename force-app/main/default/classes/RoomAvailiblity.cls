public class RoomAvailiblity {
    public List<Rooms__c> getAvailableRooms() {
        return [SELECT Id,Name FROM Rooms__c WHERE Room_Status__c = 'Vacant'];

    }
}