
<cfscript>
function fn_GetPrimaryTargetID (primaryTargetKey)
{
switch(primaryTargetKey)
	{
	case "addressID" : return 60;
	case "affiliateID" : return 61;
	case "bankID" : return 63;
	case "categoryID" : return 64;
	case "checklistCategoryColumnID" : return 67;
	case "checklistCategoryID" : return 66;
	case "checklistID" : return 65;
	case "cobrandID" : return 68;
	case "commissionID" : return 69;
	case "commissionTypeID" : return 70;
	case "companyID" : return 71;
	case "contactID" : return 72;
	case "contactTemplateID" : return 118;
	case "contactTopicID" : return 119;
	case "contentCategoryID" : return 120;
	case "contentCompanyID" : return 74;
	case "contentID" : return 73;
	case "creditCardID" : return 75;
	case "eventID" : return 76;
	case "faxNumberID" : return 77;
	case "fieldArchiveID" : return 78;
	case "groupID" : return 79;
	case "headerFooterID" : return 80;
	case "imageID" : return 99;
	case "invoiceID" : return 81;
	case "invoiceLineItemID" : return 82;
	case "invoiceRecurringID" : return 83;
	case "invoiceSentID" : return 84;
	case "invoiceTaxID" : return 85;
	case "newsletterID" : return 124;
	case "newsletterSubscriberID" : return 125;
	case "noteID" : return 86;
	case "paymentCreditID" : return 88;
	case "paymentID" : return 87;
	case "permissionID" : return 89;
	case "permissionStructureID" : return 90;
	case "phoneID" : return 91;
	case "priceID" : return 92;
	case "priceTargetID" : return 93;
	case "primaryTargetID" : return 123;
	case "productBundleID" : return 95;
	case "productCategoryID" : return 96;
	case "productDateID" : return 97;
	case "productFavoriteID" : return 98;
	case "productID" : return 94;
	case "productLanguageID" : return 100;
	case "productParameterID" : return 121;
	case "regionID" : return 122;
	case "salespersonCustomerID" : return 102;
	case "salespersonID" : return 101;
	case "schedulerID" : return 103;
	case "shippingCarrierID" : return 105;
	case "shippingID" : return 104;
	case "statusHistoryID" : return 107;
	case "statusID" : return 106;
	case "subscriberID" : return 126;
	case "subscriptionID" : return 127;
	case "taskID" : return 62;
	case "taxCategoryID" : return 109;
	case "taxID" : return 108;
	case "taxLocaleID" : return 110;
	case "taxProductID" : return 111;
	case "taxTypeID" : return 112;
	case "userID" : return 113;
	case "vendorID" : return 114;
	case "warehouseID" : return 115;
	case "warehouseInventoryID" : return 116;
	case "warehouseProductID" : return 117;
	default : return 0;
	}
}

function fn_GetPrimaryTargetKey (primaryTargetID)
{
switch(primaryTargetID)
	{
	case 60 : return "addressID";
	case 61 : return "affiliateID";
	case 62 : return "taskID";
	case 63 : return "bankID";
	case 64 : return "categoryID";
	case 65 : return "checklistID";
	case 66 : return "checklistCategoryID";
	case 67 : return "checklistCategoryColumnID";
	case 68 : return "cobrandID";
	case 69 : return "commissionID";
	case 70 : return "commissionTypeID";
	case 71 : return "companyID";
	case 72 : return "contactID";
	case 73 : return "contentID";
	case 74 : return "contentCompanyID";
	case 75 : return "creditCardID";
	case 76 : return "eventID";
	case 77 : return "faxNumberID";
	case 78 : return "fieldArchiveID";
	case 79 : return "groupID";
	case 80 : return "headerFooterID";
	case 81 : return "invoiceID";
	case 82 : return "invoiceLineItemID";
	case 83 : return "invoiceRecurringID";
	case 84 : return "invoiceSentID";
	case 85 : return "invoiceTaxID";
	case 86 : return "noteID";
	case 87 : return "paymentID";
	case 88 : return "paymentCreditID";
	case 89 : return "permissionID";
	case 90 : return "permissionStructureID";
	case 91 : return "phoneID";
	case 92 : return "priceID";
	case 93 : return "priceTargetID";
	case 94 : return "productID";
	case 95 : return "productBundleID";
	case 96 : return "productCategoryID";
	case 97 : return "productDateID";
	case 98 : return "productFavoriteID";
	case 99 : return "imageID";
	case 100 : return "productLanguageID";
	case 101 : return "salespersonID";
	case 102 : return "salespersonCustomerID";
	case 103 : return "schedulerID";
	case 104 : return "shippingID";
	case 105 : return "shippingCarrierID";
	case 106 : return "statusID";
	case 107 : return "statusHistoryID";
	case 108 : return "taxID";
	case 109 : return "taxCategoryID";
	case 110 : return "taxLocaleID";
	case 111 : return "taxProductID";
	case 112 : return "taxTypeID";
	case 113 : return "userID";
	case 114 : return "vendorID";
	case 115 : return "warehouseID";
	case 116 : return "warehouseInventoryID";
	case 117 : return "warehouseProductID";
	case 118 : return "contactTemplateID";
	case 119 : return "contactTopicID";
	case 120 : return "contentCategoryID";
	case 121 : return "productParameterID";
	case 122 : return "regionID";
	case 123 : return "primaryTargetID";
	case 124 : return "newsletterID";
	case 125 : return "newsletterSubscriberID";
	case 126 : return "subscriberID";
	case 127 : return "subscriptionID";
	default : return "";
	}
}
</cfscript>

<cflock Scope="Application" Timeout="5">
	<cfset Application.fn_GetPrimaryTargetID = fn_GetPrimaryTargetID>
	<cfset Application.fn_GetPrimaryTargetKey = fn_GetPrimaryTargetKey>
</cflock>


