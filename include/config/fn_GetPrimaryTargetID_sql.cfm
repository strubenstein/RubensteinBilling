
<cfscript>
function fn_GetPrimaryTargetID (primaryTargetKey)
{
switch(primaryTargetKey)
	{
	case "addressID" : return 1;
	case "affiliateID" : return 2;
	case "bankID" : return 4;
	case "categoryID" : return 5;
	case "cobrandID" : return 9;
	case "commissionCategoryID" : return 74;
	case "commissionCustomerID" : return 75;
	case "commissionID" : return 10;
	case "commissionProductID" : return 76;
	case "commissionStageID" : return 77;
	case "commissionTargetID" : return 11;
	case "commissionVolumeDiscountID" : return 78;
	case "companyID" : return 12;
	case "contactID" : return 13;
	case "contactTemplateID" : return 59;
	case "contactTopicID" : return 60;
	case "contentCategoryID" : return 61;
	case "contentCompanyID" : return 15;
	case "contentID" : return 14;
	case "creditCardID" : return 16;
	case "customFieldBitID" : return 80;
	case "customFieldDecimalID" : return 81;
	case "customFieldID" : return 79;
	case "customFieldIntID" : return 82;
	case "customFieldOptionID" : return 83;
	case "customFieldVarcharID" : return 84;
	case "exportQueryFieldID" : return 86;
	case "exportQueryID" : return 85;
	case "exportTableFieldID" : return 88;
	case "exportTableID" : return 87;
	case "fieldArchiveID" : return 19;
	case "groupID" : return 20;
	case "groupTargetID" : return 89;
	case "headerFooterID" : return 21;
	case "imageID" : return 40;
	case "invoiceID" : return 22;
	case "invoiceLineItemID" : return 23;
	case "invoicePaymentCreditID" : return 90;
	case "invoiceSentID" : return 25;
	case "IPaddressID" : return 91;
	case "merchantAccountID" : return 93;
	case "merchantID" : return 92;
	case "newsletterID" : return 65;
	case "newsletterSubscriberID" : return 66;
	case "noteID" : return 27;
	case "payflowID" : return 69;
	case "payflowInvoiceID" : return 71;
	case "payflowNotifyID" : return 94;
	case "payflowTargetID" : return 73;
	case "payflowTemplateID" : return 70;
	case "paymentCategoryID" : return 95;
	case "paymentCreditID" : return 29;
	case "paymentID" : return 28;
	case "permissionCategoryID" : return 31;
	case "permissionID" : return 30;
	case "permissionTargetID" : return 96;
	case "phoneID" : return 32;
	case "priceID" : return 33;
	case "priceStageID" : return 97;
	case "priceTargetID" : return 34;
	case "priceVolumeDiscountID" : return 98;
	case "primaryTargetID" : return 64;
	case "productBundleID" : return 36;
	case "productCategoryID" : return 37;
	case "productDateID" : return 38;
	case "productID" : return 35;
	case "productLanguageID" : return 41;
	case "productParameterExceptionID" : return 99;
	case "productParameterID" : return 62;
	case "productParameterOptionID" : return 100;
	case "productSpecID" : return 101;
	case "regionID" : return 63;
	case "schedulerID" : return 44;
	case "shippingID" : return 45;
	case "statusHistoryID" : return 48;
	case "statusID" : return 47;
	case "subscriberID" : return 67;
	case "subscriberPaymentID" : return 102;
	case "subscriberProcessID" : return 103;
	case "subscriptionID" : return 68;
	case "taskID" : return 3;
	case "templateID" : return 104;
	case "userID" : return 54;
	case "vendorID" : return 55;
	default : return 0;
	}
}

function fn_GetPrimaryTargetKey (primaryTargetID)
{
switch(primaryTargetID)
	{
	case 1 : return "addressID";
	case 2 : return "affiliateID";
	case 3 : return "taskID";
	case 4 : return "bankID";
	case 5 : return "categoryID";
	case 9 : return "cobrandID";
	case 10 : return "commissionID";
	case 11 : return "commissionTargetID";
	case 12 : return "companyID";
	case 13 : return "contactID";
	case 14 : return "contentID";
	case 15 : return "contentCompanyID";
	case 16 : return "creditCardID";
	case 19 : return "fieldArchiveID";
	case 20 : return "groupID";
	case 21 : return "headerFooterID";
	case 22 : return "invoiceID";
	case 23 : return "invoiceLineItemID";
	case 25 : return "invoiceSentID";
	case 27 : return "noteID";
	case 28 : return "paymentID";
	case 29 : return "paymentCreditID";
	case 30 : return "permissionID";
	case 31 : return "permissionCategoryID";
	case 32 : return "phoneID";
	case 33 : return "priceID";
	case 34 : return "priceTargetID";
	case 35 : return "productID";
	case 36 : return "productBundleID";
	case 37 : return "productCategoryID";
	case 38 : return "productDateID";
	case 40 : return "imageID";
	case 41 : return "productLanguageID";
	case 44 : return "schedulerID";
	case 45 : return "shippingID";
	case 47 : return "statusID";
	case 48 : return "statusHistoryID";
	case 54 : return "userID";
	case 55 : return "vendorID";
	case 59 : return "contactTemplateID";
	case 60 : return "contactTopicID";
	case 61 : return "contentCategoryID";
	case 62 : return "productParameterID";
	case 63 : return "regionID";
	case 64 : return "primaryTargetID";
	case 65 : return "newsletterID";
	case 66 : return "newsletterSubscriberID";
	case 67 : return "subscriberID";
	case 68 : return "subscriptionID";
	case 69 : return "payflowID";
	case 70 : return "payflowTemplateID";
	case 71 : return "payflowInvoiceID";
	case 73 : return "payflowTargetID";
	case 74 : return "commissionCategoryID";
	case 75 : return "commissionCustomerID";
	case 76 : return "commissionProductID";
	case 77 : return "commissionStageID";
	case 78 : return "commissionVolumeDiscountID";
	case 79 : return "customFieldID";
	case 80 : return "customFieldBitID";
	case 81 : return "customFieldDecimalID";
	case 82 : return "customFieldIntID";
	case 83 : return "customFieldOptionID";
	case 84 : return "customFieldVarcharID";
	case 85 : return "exportQueryID";
	case 86 : return "exportQueryFieldID";
	case 87 : return "exportTableID";
	case 88 : return "exportTableFieldID";
	case 89 : return "groupTargetID";
	case 90 : return "invoicePaymentCreditID";
	case 91 : return "IPaddressID";
	case 92 : return "merchantID";
	case 93 : return "merchantAccountID";
	case 94 : return "payflowNotifyID";
	case 95 : return "paymentCategoryID";
	case 96 : return "permissionTargetID";
	case 97 : return "priceStageID";
	case 98 : return "priceVolumeDiscountID";
	case 99 : return "productParameterExceptionID";
	case 100 : return "productParameterOptionID";
	case 101 : return "productSpecID";
	case 102 : return "subscriberPaymentID";
	case 103 : return "subscriberProcessID";
	case 104 : return "templateID";
	default : return "";
	}
}

</cfscript>

<cflock Scope="Application" Timeout="5">
	<cfset Application.fn_GetPrimaryTargetID = fn_GetPrimaryTargetID>
	<cfset Application.fn_GetPrimaryTargetKey = fn_GetPrimaryTargetKey>
</cflock>


