/* eslint-disable no-console */
import { LightningElement, api, track } from 'lwc';

import getImageUrl from '@salesforce/apex/TopPiecesController.getImageUrl'; 

export default class PieceDetails extends LightningElement {
    @api piece;
    @track imageUrl;
    @track aboveAsking;
    @track over30;

    // On init
    connectedCallback() {
        this.getImage();
        if(this.piece.Bids__r) {
            for(let bid of this.piece.Bids__r) {
                if(bid.Offered_Price__c===this.piece.Top_Bid__c) {
                    this.aboveAsking = bid.Above_Asking__c;
                }
            }
        }
        
        if(this.aboveAsking > 30) {
            this.over30 = true;
        }
    }

    getImage() {
        this.executeAction(getImageUrl, { piece: this.piece })
            .then(imgUrl => {
                this.imageUrl = imgUrl;
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