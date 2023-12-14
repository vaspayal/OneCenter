import { LightningElement, track, wire } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import HOSPITAL_OBJECT from '@salesforce/schema/Hospital__c';
import { createRecord } from 'lightning/uiRecordApi';
import FEEDBACK_OBJECT from '@salesforce/schema/Feedback__c';
import getHospitalOptions from '@salesforce/apex/FeedbackController.getHospitalOptions'
import getFeedbackFormUrl from '@salesforce/apex/FeedbackController.getFeedbackFormUrl'

export default class FeedbackForm2Controller extends LightningElement {
    @track name = '';
    @track rating = '';
    @track comments = '';
    @track selectedHospital = '';
    selectedHospitalId;
    hospitalOptions=[];
    feedbackFormUrl;

    @wire(getHospitalOptions)
    wiredHospitals({error,data}){
        if(data){
            this.hospitalOptions= data.map(hospital=>{
                return{
                    label: hospital.Name,
                    value: hospital.Id
                };
            });
        }else if(error){
            console.error(error);
        }
    }

    @wire(getFeedbackFormUrl)
    wiredUrl({error,data}){
        if(data && data.url){
            this.feedbackFormUrl= data.url;
            }
        else if(error){
            console.error(error);
        }
    }
    
    handleHospitalChange(event){
        this.selectedHospitalId = event.detail.value;
    }
    get ratingOptions() {
        return [
            { label: 'Good', value: 'Good' },
            { label: 'Average', value: 'Average' },
            { label: 'Bad', value: 'Bad' },
            { label: 'Worst', value: 'Worst' }
        ];
    }

    handleSubmit() {
        const fields = {
            Name: this.name,
            Overall_Rating__c: this.rating,
            Comments__c: this.comments,
            Hospital__c: this.selectedHospital
        };

        const recordInput = { apiName: FEEDBACK_OBJECT.objectApiName, fields };
        createRecord(recordInput)
            .then(() => {
                // Success logic
                this.dispatchEvent(new CustomEvent('close'));
            })
            .catch(error => {
                // Handle error
                console.error('Error creating record:', error);
            });
    }
}
