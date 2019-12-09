@isTest
private class TopPiecesControllerTest {
    static String VENDOR_NAME = 'Vendor of ART';
    static String PIECE_NAME = 'An ART';
    static String PIECE_NAME2 = 'An Second ART';
    static String PIECE_NAME3 = 'An ART the third';
    static Decimal TOP_BID = 150.00;
    static String URL = 'http://www.test.com/image.png';

    @testSetup 
	static void testSetup() {
        Id vendorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        
        Account vendor = new Account();
        vendor.RecordTypeId = vendorRecordTypeId;
        vendor.Name = VENDOR_NAME;
        insert vendor;

        Piece__c piece = new Piece__c();
        piece.Name = PIECE_NAME;
        piece.Vendor__c = vendor.Id;
        piece.Asking_Price__c = 50.0;
        piece.Image__c = '<p><img src="http://www.test.com/image.png"/></p>';

        Piece__c piece2 = new Piece__c();
        piece2.Name = PIECE_NAME2;
        piece2.Vendor__c = vendor.Id;
        piece2.Asking_Price__c = 80.0;

        Piece__c piece3 = new Piece__c();
        piece3.Name = PIECE_NAME3;
        piece3.Vendor__c = vendor.Id;
        piece3.Asking_Price__c = 110.0;
        piece3.Top_Bid__c = TOP_BID;
        insert new List<Piece__c>{piece, piece2, piece3};
	}

    @isTest 
	static void testGetImageUrl() {
		Piece__c p = [SELECT Id, Image__c FROM Piece__c WHERE Name=:PIECE_NAME];

		String imgUrl = TopPiecesController.getImageUrl(p);

		System.assertEquals(URL, imgUrl);
	}

    @isTest 
	static void testGetTopPieces() {
		Account vendor = [SELECT Id FROM Account WHERE Name=:VENDOR_NAME];

		List<Piece__c> topPieces = TopPiecesController.getTopPieces(vendor.Id, 1);

        System.assertEquals(1, topPieces.size());
        System.assertEquals(TOP_BID, topPieces[0].Top_Bid__c);
        System.assertEquals(PIECE_NAME3, topPieces[0].Name);
	}
	
}
