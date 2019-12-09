/* eslint-disable no-console */
import { LightningElement, api, track } from 'lwc';

import getRecentlyAddedPieces from '@salesforce/apex/TopPiecesController.getRecentlyAddedPieces'; 

const columns = [
    { label: 'Name', fieldName: 'Name'},
    { label: 'Asking Price', fieldName: 'Asking_Price__c', type: 'currency'},
    { label: 'Size', fieldName: 'Size__c'},
    { label: 'Number of Bids', fieldName: 'Number_of_Bids__c'}
];

export default class RecentlyAddedPieces extends LightningElement {
    @api recordId;
    @api numRecordsToDisplay;
    @track columns = columns;
    @track data = [];

    // On init
    connectedCallback() {
        this.getRecentlyAdded();
    }

    getRecentlyAdded() {
        this.executeAction(getRecentlyAddedPieces, { vendorId: this.recordId, num: 3 })
            .then(recentlyAdded => {
                this.data = recentlyAdded;  
                console.log(JSON.parse(JSON.stringify(recentlyAdded)));
            })
            .catch(error => {
                console.log(error);
            });

    }

    executeAction(apexMethod, params) {
        return new Promise(function(resolve, reject) {
            apexMethod(params)
                .then(result => {
                    resolve(result);
                })
                .catch(error => {
                    reject(error);
                });
        });
    }
}