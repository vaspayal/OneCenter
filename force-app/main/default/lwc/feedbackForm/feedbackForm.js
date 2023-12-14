import { LightningElement, track, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { createRecord } from 'lightning/uiRecordApi';
import FEEDBACK_OBJECT from '@salesforce/schema/Feedback__c';
import HOSPITAL_FIELD from '@salesforce/schema/Feedback__c.Hospital_Feedback__c';
import getHospitalOptions from '@salesforce/apex/PatientController.getHospitalOptions';
import createFeedbackRecord from '@salesforce/apex/PatientController.createFeedbackRecord';

export default class FeedbackForm extends LightningElement {
    @track name;
    @track rating;
    @track comments;
    @track email;
    @track hospital;
    @track hospitalOptions = [];

    ratingOptions = [
        { label: 'Good', value: 'good' },
        { label: 'Average', value: 'average' },
        { label: 'Bad', value: 'bad' },
        { label: 'Worst', value: 'worst' }
    ];

    @wire(getObjectInfo, { objectApiName: FEEDBACK_OBJECT })
    feedbackObjectInfo;

    @wire(getHospitalOptions)
    loadHospitalOptions({ data, error }) {
        if (data) {
            this.hospitalOptions = data.map(hospital => ({
                label: hospital.Name,
                value: hospital.Id
            }));
        } else if (error) {
            console.error('Error retrieving hospital options: ', error);
        }
    }

    handleNameChange(event) {
        this.name = event.target.value;
    }

    handleRatingChange(event) {
        this.rating = event.target.value;
    }

    handleCommentsChange(event) {
        this.comments = event.target.value;
    }

    handleEmailChange(event) {
        this.email = event.target.value;
    }

    handleHospitalChange(event) {
        this.hospital = event.target.value;
    }

    handleSubmit() {
        const fields = {};
        fields.Name = this.name;
        fields.OverallRating__c = this.rating;
        fields.Comments__c = this.comments;
        fields.Email__c = this.email;
        fields[HOSPITAL_FIELD.fieldApiName] = this.hospital;

        const recordInput = { apiName: FEEDBACK_OBJECT.objectApiName, fields };

        createRecord(recordInput)
            .then(result => {
                // Handle the successful creation of the feedback record
                console.log('Feedback record created: ', result.id);
            })
            .catch(error => {
                // Handle any errors that occurred during record creation
                console.error('Error creating feedback record: ', error.body.message);
            });
    }
}