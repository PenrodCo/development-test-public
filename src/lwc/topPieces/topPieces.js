/* eslint-disable no-console */
import { LightningElement, api, track } from 'lwc';

import getTopPieces from '@salesforce/apex/TopPiecesController.getTopPieces'; 

export default class TopPieces extends LightningElement {
    @api recordId;
    @track topPieces = [];

    // On init
    connectedCallback() {
        this.getTopPieces();
    }

    getTopPieces() {
        this.executeAction(getTopPieces, { vendorId: this.recordId, num: 3 })
            .then(pieces => {
                this.topPieces = pieces;  
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