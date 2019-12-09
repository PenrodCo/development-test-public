public with sharing class TopPiecesController {

	@AuraEnabled
	public static String getImageUrl(Piece__c piece) {
		String imgString = piece!=null && piece.Image__c!=null ? piece.Image__c : '';
		String firstSubString = imgString.substringBetween('<img', 'img>');
		String secondSubString = firstSubString != null ? firstSubString.substringBetween('src="', '"') : null;
		String link = secondSubString != null ? secondSubString.replace('amp;', '') : null;
		return link;
	}

    @AuraEnabled
    public static List<Piece__c> getRecentlyAddedPieces(Id vendorId, Integer num){
        List<Piece__c> recentlyAdded =[SELECT Id,
            Artist__c,
            Asking_Price__c,
            Name
            FROM Piece__c
            WHERE Vendor__c=:vendorId
            ORDER BY CreatedDate
            LIMIT :num
        ];
        return recentlyAdded;    
    }

    @AuraEnabled
    public static List<Piece__c> getTopPieces(Id vendorId, Integer num){
        List<Piece__c> topPieces =[SELECT Id,
            Artist__c,
            Artist__r.Name,
            Asking_Price__c,
            Image__c,
            Name,
            Top_Bid__c,
            (SELECT 
                Id,
                Above_Asking__c,
                Offered_Price__c
                FROM Bids__r
                ORDER BY Above_Asking__c DESC
            )
            FROM Piece__c
            WHERE Vendor__c=:vendorId
            ORDER BY Top_Bid__c DESC NULLS LAST
            LIMIT :num
        ];
        return topPieces;
    }
}
