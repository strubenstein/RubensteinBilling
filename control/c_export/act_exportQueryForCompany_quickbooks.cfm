<cfset tab = "	">

<cfswitch expression="#Variables.exportQueryName#">
<cfcase value="qry_selectInvoiceList">
	<cfinvoke Component="#Application.billingMapping#data.InvoicePaymentCredit" Method="selectInvoicePaymentCreditList" ReturnVariable="qry_selectInvoicePaymentCreditList">
		<cfinvokeargument Name="invoiceID" Value="#ValueList(qry_selectInvoiceList.invoiceID)#">
		<cfinvokeargument Name="returnInvoiceFields" Value="False">
		<cfinvokeargument Name="returnPaymentCreditFields" Value="True">
	</cfinvoke>

	<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddress" ReturnVariable="qry_selectAddress">
		<cfinvokeargument Name="addressID" Value="#ValueList(qry_selectInvoiceList.addressID_billing)#">
	</cfinvoke>

	<cfset Variables.exportFile = "">

!TRNS	TRNSTYPE	DATE	ACCNT	NAME	AMOUNT	DOCNUM	ADDR1	ADDR2	ADDR3	DUEDATE	PAID	SHIPDATE	INVTITLE
!SPL	TRNSTYPE	DATE	ACCNT	NAME	AMOUNT	DOCNUM	INVITEM									
!ENDTRNS

	<cfset Variables.exportFile = Variables.exportFile & "TRNS" & tab & "INVOICE" & DateFormat(Now(), "yyyymmdd") & ".qbo">
	34424	Accounts Receivable	Lisa Yee	669.62	679	Light fixtures	N	Y	Lisa Yee	541 Surf Road	Sycamore, CA	34454	1%10 Net 30	Y	34424	Invoice

	<cfloop Query="qry_selectInvoiceList">
		<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItemList" ReturnVariable="qry_selectInvoiceLineItemList">
			<cfinvokeargument Name="invoiceID" Value="#qry_selectInvoiceList.invoiceID#">
			<cfinvokeargument Name="invoiceLineItemStatus" Value="1">
		</cfinvoke>

		<cfset Variables.paymentCreditRowBegin = ListFind(ValueList(qry_selectInvoicePaymentCreditList.invoiceID), qry_selectInvoiceList.invoiceID)>


SPL	INVOICE	34424	Sales Income		-456.92		Light Fixtures	N		Resale									
SPL	INVOICE	34424	Labor Income		-175		Labor	N	128	Labor									
SPL	INVOICE	34424	Sales Tax Payable	Tax Board	-37.7		Sales Tax	N		Auto Tax

	</cfloop>
	<cfset Variables.exportFile = Variables.exportFile & Chr(10) & "ENDTRNS">
</cfcase>
</cfswitch>





<cfset Variables.exportTableFieldName_list = "">
<cfset Variables.exportQueryFieldAs_list = "">
<cfset Variables.exportTableFieldName_default_list = "">
<cfset Variables.exportTableFieldName_custom_list = "">

<cfset temp = QueryAddColumn(qry_selectExportQueryForCompany, "exportTableFieldName", ListToArray(Variables.exportTableFieldName_list))>
<cfset temp = QueryAddColumn(qry_selectExportQueryForCompany, "exportQueryFieldAs", ListToArray(Variables.exportQueryFieldAs_list))>
<cfset temp = QueryAddColumn(qry_selectExportQueryForCompany, "exportTableFieldName_default", ListToArray(Variables.exportTableFieldName_default_list))>
<cfset temp = QueryAddColumn(qry_selectExportQueryForCompany, "exportTableFieldName_custom", ListToArray(Variables.exportTableFieldName_custom_list))>

affiliate,cobrand
company
newsletterSubscriber
payment,paymentCredit
salesCommission
subscriber
user

invoice,invoiceLineItem,invoicePaymentCredit


product
vendor

<cfset Variables.queryStruct.qry_selectAffiliateList = "Affiliate.affiliateID,Affiliate.companyID,Affiliate.userID,Affiliate.userID_author,Affiliate.affiliateCode,Affiliate.affiliateName,Affiliate.affiliateURL,Affiliate.affiliateStatus,Affiliate.affiliateID_custom,Affiliate.affiliateDateCreated,Affiliate.affiliateDateUpdated,Company.companyName,Company.companyID_custom,Company.companyDBA,Company.companyStatus,User.firstName,User.lastName,User.userID_custom,User.userStatus">
<cfset Variables.queryStruct.qry_selectCobrandList = "Cobrand.cobrandID,Cobrand.companyID,Cobrand.userID,Cobrand.userID_author,Cobrand.companyID_author,Cobrand.cobrandName,Cobrand.cobrandCode,Cobrand.cobrandStatus,Cobrand.cobrandImage,Cobrand.cobrandURL,Cobrand.cobrandTitle,Cobrand.cobrandDomain,Cobrand.cobrandDirectory,Cobrand.cobrandID_custom,Cobrand.cobrandDateCreated,Cobrand.cobrandDateUpdated,Company.companyName,Company.companyID_custom,Company.companyDBA,Company.companyStatus,User.firstName,User.lastName,User.userID_custom,User.userStatus">
<cfset Variables.queryStruct.qry_selectCompanyList = "Company.companyID,Company.userID,Company.companyName,Company.companyDBA,Company.companyURL,Company.languageID,Company.companyPrimary,Company.companyStatus,Company.affiliateID,Company.cobrandID,Company.companyID_custom,Company.companyID_parent,Company.companyID_author,Company.companyIsAffiliate,Company.companyIsCobrand,Company.companyIsVendor,Company.companyIsCustomer,Company.companyIsTaxExempt,Company.companyDirectory,Company.companyDateCreated,Company.companyDateUpdated,User.firstName,User.lastName,User.userID_custom">
<cfset Variables.queryStruct.qry_selectInvoiceList = "Invoice.invoiceID,Invoice.invoiceClosed,Invoice.invoiceDateClosed,Invoice.invoiceSent,Invoice.invoicePaid,Invoice.invoiceDatePaid,Invoice.invoiceTotal,Invoice.invoiceTotalTax,Invoice.invoiceTotalLineItem,Invoice.invoiceTotalPaymentCredit,Invoice.invoiceTotalShipping,Invoice.invoiceShipped,Invoice.subscriberID,Invoice.invoiceCompleted,Invoice.invoiceDateCompleted,Invoice.invoiceStatus,Invoice.invoiceID_custom,Invoice.invoiceShippingMethod,Invoice.invoiceDateCreated,Invoice.invoiceDateUpdated,Invoice.companyID,Invoice.userID,Invoice.invoiceManual,Invoice.invoiceDateDue,Invoice.languageID,Invoice.userID_author,Invoice.companyID_author,Invoice.regionID,Invoice.invoiceInstructions,Invoice.addressID_shipping,Invoice.addressID_billing,Invoice.creditCardID,Invoice.bankID,Company.companyName,Company.companyID_custom,User.firstName,User.lastName,User.userID_custom,Subscriber.subscriberName,Subscriber.subscriberID_custom">
<cfset Variables.queryStruct.qry_selectNewsletterSubscriberList = "NewsletterSubscriber.newsletterSubscriberID,NewsletterSubscriber.newsletterSubscriberEmail,NewsletterSubscriber.newsletterSubscriberStatus,NewsletterSubscriber.newsletterSubscriberHtml,NewsletterSubscriber.cobrandID,NewsletterSubscriber.affiliateID,User.firstName,User.lastName,User.userID_custom,Company.companyID,Company.companyName,Company.companyID_custom">
<cfset Variables.queryStruct.qry_selectPaymentList = "Payment.paymentID,Payment.userID,Payment.companyID,Payment.userID_author,Payment.paymentManual,Payment.creditCardID,Payment.bankID,Payment.merchantAccountID,Payment.paymentCheckNumber,Payment.paymentID_custom,Payment.paymentStatus,Payment.paymentAmount,Payment.paymentApproved,Payment.paymentDescription,Payment.paymentMessage,Payment.paymentMethod,Payment.paymentProcessed,Payment.paymentDateReceived,Payment.paymentDateScheduled,Payment.paymentCategoryID,Payment.subscriberID,Payment.subscriberProcessID,Payment.paymentIsRefund,Payment.paymentID_refund,Payment.paymentDateCreated,Payment.paymentDateUpdated,Subscriber.subscriberName,Subscriber.subscriberID_custom,User.firstName AS authorFirstName,User.lastName AS authorLastName,User.userID_custom AS authorUserID_custom,User.firstName AS targetFirstName,User.lastName AS targetLastName,User.userID_custom AS targetUserID_custom,Company.companyName AS targetCompanyName,Company.companyID_custom AS targetCompanyID_custom">
<cfset Variables.queryStruct.qry_selectPaymentCreditList = "PaymentCredit.paymentCreditID,PaymentCredit.userID,PaymentCredit.companyID,PaymentCredit.userID_author,PaymentCredit.companyID_author,PaymentCredit.paymentCreditAmount,PaymentCredit.paymentCreditStatus,PaymentCredit.paymentCreditName,PaymentCredit.paymentCreditID_custom,PaymentCredit.paymentCreditDescription,PaymentCredit.paymentCreditDateBegin,PaymentCredit.paymentCreditDateEnd,PaymentCredit.paymentCreditAppliedMaximum,PaymentCredit.paymentCreditAppliedCount,PaymentCredit.paymentCategoryID,PaymentCredit.paymentCreditRollover,PaymentCredit.subscriberID,PaymentCredit.paymentCreditCompleted,PaymentCredit.paymentCreditDateCreated,PaymentCredit.paymentCreditDateUpdated,Subscriber.subscriberName,Subscriber.subscriberID_custom,User.firstName AS authorFirstName,User.lastName AS authorLastName,User.userID_custom AS authorUserID_custom,User.firstName AS targetFirstName,User.lastName AS targetLastName,User.userID_custom AS targetUserID_custom,Company.companyName AS targetCompanyName,Company.companyID_custom AS targetCompanyID_custom">
<cfset Variables.queryStruct.qry_selectProductList = "Product.productID,Product.companyID,Product.userID_author,Product.userID_manager,Product.vendorID,Product.productCode,Product.productName,Product.productPrice,Product.productPriceCallForQuote,Product.productWeight,Product.productStatus,Product.productListedOnSite,Product.productHasImage,Product.productHasCustomPrice,Product.productHasSpec,Product.productCanBePurchased,Product.productDisplayChildren,Product.productChildType,Product.productViewCount,Product.productInBundle,Product.productIsBundle,Product.productIsRecommended,Product.productHasRecommendation,Product.productIsDateRestricted,Product.productIsDateAvailable,Product.productID_custom,Product.templateFilename,Product.productCatalogPageNumber,Product.productID_parent,Product.productHasChildren,Product.productChildOrder,Product.productChildSeparate,Product.productInWarehouse,Product.productHasParameter,Product.productHasParameterException,Product.productDateCreated,Product.productDateUpdated">
<cfset Variables.queryStruct.qry_selectSalesCommissionList = "SalesCommission.salesCommissionID,SalesCommission.primaryTargetID,SalesCommission.targetID,SalesCommission.salesCommissionAmount,SalesCommission.commissionID,SalesCommission.userID_author,SalesCommission.salesCommissionFinalized,SalesCommission.salesCommissionDateFinalized,SalesCommission.salesCommissionPaid,SalesCommission.salesCommissionDatePaid,SalesCommission.salesCommissionStatus,SalesCommission.salesCommissionManual,SalesCommission.salesCommissionBasisTotal,SalesCommission.salesCommissionBasisQuantity,SalesCommission.salesCommissionDateBegin,SalesCommission.salesCommissionDateEnd,SalesCommission.commissionStageID,SalesCommission.commissionVolumeDiscountID,SalesCommission.salesCommissionCalculatedAmount,SalesCommission.salesCommissionDateCreated,SalesCommission.salesCommissionDateUpdated,User.firstName,User.lastName,User.userID_custom">
	<!--- targetName,Commission.commissionName,Commission.commissionID_custom,Commission.commissionStatus,Commission.commissionSharable,Commission.commissionPeriodOrInvoiceBased,Commission.commissionHasMultipleStages,Commission.commissionDescription,Commission.commissionDateCreated,Commission.commissionDateUpdated --->
<cfset Variables.queryStruct.qry_selectSubscriberList = "Subscriber.subscriberID,Subscriber.subscriberID_custom,Subscriber.companyID,Subscriber.userID,Subscriber.userID_author,Subscriber.userID_cancel,Subscriber.companyID_author,Subscriber.subscriberName,Subscriber.subscriberID_custom,Subscriber.subscriberStatus,Subscriber.subscriberCompleted,Subscriber.subscriberDateProcessNext,Subscriber.subscriberDateProcessLast,Subscriber.addressID_billing,Subscriber.addressID_shipping,Subscriber.subscriberDateCreated,Subscriber.subscriberDateUpdated,Company.companyName,Company.companyID_custom,User.firstName,User.lastName,User.userID_custom">
	<!--- subscriberLineItemCount,subscriberLineItemTotal --->
<cfset Variables.queryStruct.qry_selectUserList = "User.userID,User.companyID,User.username,User.userStatus,User.userID_author,User.firstName,User.middleName,User.lastName,User.suffix,User.salutation,User.email,User.languageID,User.userID_custom,User.jobTitle,User.jobDepartment,User.jobDivision,User.userNewsletterStatus,User.userNewsletterHtml,User.userDateCreated,User.userDateUpdated,Company.companyName,Company.companyID_custom,Company.affiliateID,Company.cobrandID">
<cfset Variables.queryStruct.qry_selectVendorList = "Vendor.vendorID,Vendor.companyID,Vendor.userID,Vendor.companyID_author,Vendor.userID_author,Vendor.vendorCode,Vendor.vendorDescriptionDisplay,Vendor.vendorURL,Vendor.vendorURLdisplay,Vendor.vendorName,Vendor.vendorImage,Vendor.vendorStatus,Vendor.vendorID_custom,Vendor.vendorDateCreated,Vendor.vendorDateUpdated,Company.companyName,Company.companyID_custom,Company.companyDBA,Company.companyStatus,User.firstName,User.lastName,User.userID_custom,User.userStatus">

