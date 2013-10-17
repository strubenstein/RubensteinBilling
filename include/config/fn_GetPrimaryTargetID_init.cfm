<cfscript>
function fn_GetPrimaryTargetID (primaryTargetKey)
{
switch(primaryTargetKey)
	{
	case "addressID" : return 1;
	case "affiliateID" : return 2;
	case "bankID" : return 3;
	case "categoryID" : return 4;
	case "cobrandID" : return 5;
	case "commissionCategoryID" : return 7;
	case "commissionID" : return 6;
	case "commissionProductID" : return 8;
	case "commissionStageID" : return 9;
	case "commissionTargetID" : return 10;
	case "commissionVolumeDiscountID" : return 11;
	case "companyID" : return 12;
	case "contactID" : return 13;
	case "contactTemplateID" : return 14;
	case "contactTopicID" : return 15;
	case "contentCategoryID" : return 17;
	case "contentCompanyID" : return 18;
	case "contentID" : return 16;
	case "creditCardID" : return 19;
	case "customFieldBitID" : return 21;
	case "customFieldDecimalID" : return 22;
	case "customFieldID" : return 20;
	case "customFieldIntID" : return 23;
	case "customFieldOptionID" : return 24;
	case "customFieldVarcharID" : return 25;
	case "exportQueryFieldID" : return 27;
	case "exportQueryID" : return 26;
	case "exportTableFieldID" : return 29;
	case "exportTableID" : return 28;
	case "fieldArchiveID" : return 30;
	case "groupID" : return 31;
	case "groupTargetID" : return 32;
	case "headerFooterID" : return 33;
	case "imageID" : return 34;
	case "invoiceID" : return 35;
	case "invoiceLineItemID" : return 36;
	case "invoicePaymentCreditID" : return 37;
	case "invoiceSentID" : return 38;
	case "IPaddressID" : return 39;
	case "merchantAccountID" : return 41;
	case "merchantID" : return 40;
	case "newsletterID" : return 42;
	case "newsletterSubscriberID" : return 43;
	case "noteID" : return 44;
	case "payflowID" : return 45;
	case "payflowInvoiceID" : return 46;
	case "payflowNotifyID" : return 47;
	case "payflowTargetID" : return 48;
	case "payflowTemplateID" : return 49;
	case "paymentCategoryID" : return 51;
	case "paymentCreditID" : return 52;
	case "paymentID" : return 50;
	case "permissionCategoryID" : return 54;
	case "permissionID" : return 53;
	case "permissionTargetID" : return 55;
	case "phoneID" : return 56;
	case "priceID" : return 57;
	case "priceStageID" : return 58;
	case "priceTargetID" : return 59;
	case "priceVolumeDiscountID" : return 60;
	case "primaryTargetID" : return 61;
	case "productBundleID" : return 63;
	case "productDateID" : return 64;
	case "productID" : return 62;
	case "productLanguageID" : return 65;
	case "productParameterExceptionID" : return 67;
	case "productParameterID" : return 66;
	case "productParameterOptionID" : return 68;
	case "productSpecID" : return 69;
	case "regionID" : return 70;
	case "salesCommissionID" : return 71;
	case "commissionCustomerID" : return 72;
	case "schedulerID" : return 73;
	case "shippingID" : return 74;
	case "statusHistoryID" : return 76;
	case "statusID" : return 75;
	case "subscriberID" : return 77;
	case "subscriberPaymentID" : return 79;
	case "subscriberProcessID" : return 80;
	case "subscriptionID" : return 81;
	case "taskID" : return 82;
	case "templateID" : return 83;
	case "userID" : return 84;
	case "vendorID" : return 85;
	default : return 0;
	}
}

function fn_GetPrimaryTargetKey (primaryTargetID)
{
switch(primaryTargetID)
	{
	case 1 : return "addressID";
	case 2 : return "affiliateID";
	case 3 : return "bankID";
	case 4 : return "categoryID";
	case 5 : return "cobrandID";
	case 6 : return "commissionID";
	case 7 : return "commissionCategoryID";
	case 8 : return "commissionProductID";
	case 9 : return "commissionStageID";
	case 10 : return "commissionTargetID";
	case 11 : return "commissionVolumeDiscountID";
	case 12 : return "companyID";
	case 13 : return "contactID";
	case 14 : return "contactTemplateID";
	case 15 : return "contactTopicID";
	case 16 : return "contentID";
	case 17 : return "contentCategoryID";
	case 18 : return "contentCompanyID";
	case 19 : return "creditCardID";
	case 20 : return "customFieldID";
	case 21 : return "customFieldBitID";
	case 22 : return "customFieldDecimalID";
	case 23 : return "customFieldIntID";
	case 24 : return "customFieldOptionID";
	case 25 : return "customFieldVarcharID";
	case 26 : return "exportQueryID";
	case 27 : return "exportQueryFieldID";
	case 28 : return "exportTableID";
	case 29 : return "exportTableFieldID";
	case 30 : return "fieldArchiveID";
	case 31 : return "groupID";
	case 32 : return "groupTargetID";
	case 33 : return "headerFooterID";
	case 34 : return "imageID";
	case 35 : return "invoiceID";
	case 36 : return "invoiceLineItemID";
	case 37 : return "invoicePaymentCreditID";
	case 38 : return "invoiceSentID";
	case 39 : return "IPaddressID";
	case 40 : return "merchantID";
	case 41 : return "merchantAccountID";
	case 42 : return "newsletterID";
	case 43 : return "newsletterSubscriberID";
	case 44 : return "noteID";
	case 45 : return "payflowID";
	case 46 : return "payflowInvoiceID";
	case 47 : return "payflowNotifyID";
	case 48 : return "payflowTargetID";
	case 49 : return "payflowTemplateID";
	case 50 : return "paymentID";
	case 51 : return "paymentCategoryID";
	case 52 : return "paymentCreditID";
	case 53 : return "permissionID";
	case 54 : return "permissionCategoryID";
	case 55 : return "permissionTargetID";
	case 56 : return "phoneID";
	case 57 : return "priceID";
	case 58 : return "priceStageID";
	case 59 : return "priceTargetID";
	case 60 : return "priceVolumeDiscountID";
	case 61 : return "primaryTargetID";
	case 62 : return "productID";
	case 63 : return "productBundleID";
	case 64 : return "productDateID";
	case 65 : return "productLanguageID";
	case 66 : return "productParameterID";
	case 67 : return "productParameterExceptionID";
	case 68 : return "productParameterOptionID";
	case 69 : return "productSpecID";
	case 70 : return "regionID";
	case 71 : return "salesCommissionID";
	case 72 : return "commissionCustomerID";
	case 73 : return "schedulerID";
	case 74 : return "shippingID";
	case 75 : return "statusID";
	case 76 : return "statusHistoryID";
	case 77 : return "subscriberID";
	case 79 : return "subscriberPaymentID";
	case 80 : return "subscriberProcessID";
	case 81 : return "subscriptionID";
	case 82 : return "taskID";
	case 83 : return "templateID";
	case 84 : return "userID";
	case 85 : return "vendorID";
	default : return "";
	}
}
</cfscript>

<cflock Scope="Application" Timeout="5">
	<cfset Application.fn_GetPrimaryTargetID = fn_GetPrimaryTargetID>
	<cfset Application.fn_GetPrimaryTargetKey = fn_GetPrimaryTargetKey>
</cflock>


