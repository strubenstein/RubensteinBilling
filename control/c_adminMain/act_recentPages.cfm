<!--- 
Build/update session variable that stores last X objects viewed
- Determine whether viewing an object that should be stored
- If object is already in list
	- move to top of list
   Else preprend to beginning list and delete last object if now more than X
--->

<cfset Variables.addThisPage = False>
<cfif Find("view", URL.action)>
	<cfloop Index="fieldWithValue" List="#CGI.QUERY_STRING#" Delimiters="&">
		<cfset Variables.field = ListFirst(fieldWithValue, "=")>
		<cfif ListFind("affiliateID,cobrandID,commissionID,companyID,groupID,invoiceID,payflowID,paymentID,paymentCreditID,priceID,productID,subscriberID,userID,vendorID", Variables.field)
				and IsDefined("URL.#Variables.field#")
				and Application.fn_IsIntegerPositive(URL[Variables.field])
				and FindNoCase(Left(Variables.field, Len(Variables.field) - 2), URL.action)>
			<cfset Variables.recentPrimaryTargetKey = Variables.field>
			<cfset Variables.recentTargetID = URL[Variables.field]>
			<cfset Variables.addThisPage = True>
		</cfif>
	</cfloop>
</cfif>

<cfif Variables.addThisPage is True and StructKeyExists(Session, "recentPagesArray") and ArrayLen(Session.recentPagesArray) gt 0>
	<cfloop Index="count" From="1" To="#ArrayLen(Session.recentPagesArray)#">
		<cfif Session.recentPagesArray[count].primaryTargetKey is Variables.recentPrimaryTargetKey and Session.recentPagesArray[count].targetID is Variables.recentTargetID>
			<cfset Variables.addThisPage = False>
			<cfset Variables.recentPagesArray = Session.recentPagesArray>
			<cfset temp = ArrayPrepend(Variables.recentPagesArray, Variables.recentPagesArray[count])>
			<cfset temp = ArrayDeleteAt(Variables.recentPagesArray, count + 1)>

			<cflock Scope="Session" Timeout="5">
				<cfset Session.recentPagesArray = Variables.recentPagesArray>
			</cflock>
		</cfif>
	</cfloop>
</cfif>

<cfif Variables.addThisPage is True>
	<cfinclude template="../../view/v_adminMain/lang_recentPages.cfm">

	<cfset Variables.recentPagesMaximum = 10>
	<cfset Variables.recentPagesTitle = "">
	<cfset Variables.recentPagesText = "">

	<cfswitch expression="#Variables.recentPrimaryTargetKey#">
	<cfcase value="affiliateID">
		<cfif IsDefined("URL.affiliateID") and Application.fn_IsIntegerPositive(URL.affiliateID) and IsDefined("qry_selectAffiliate")>
			<cfset Variables.recentPagesText = Variables.lang_recentPages_title.affiliate & " #URL.affiliateID# - #qry_selectAffiliate.affiliateName#">
			<cfset Variables.recentPagesTitle = Variables.lang_recentPages_title.viewAffiliate>
			<cfset Variables.recentMethod = "affiliate.viewAffiliate">
		</cfif>
	</cfcase>
	<!--- 
	<cfcase value="categoryID">
		<cfif IsDefined("URL.categoryID") and Application.fn_IsIntegerPositive(URL.categoryID) and IsDefined("qry_selectCategory")>
			<cfset Variables.recentPagesText = Variables.lang_recentPages_title.category & " #URL.categoryID# - #qry_selectCategory.categoryName#">
			<cfset Variables.recentPagesTitle = Variables.lang_recentPages_title.viewCategory>
			<cfset Variables.recentMethod = "category.viewCategory">
		</cfif>
	</cfcase>
	--->
	<cfcase value="cobrandID">
		<cfif IsDefined("URL.cobrandID") and Application.fn_IsIntegerPositive(URL.cobrandID) and IsDefined("qry_selectCobrand")>
			<cfset Variables.recentPagesText = Variables.lang_recentPages_title.cobrand & " #URL.cobrandID# - #qry_selectCobrand.cobrandName#">
			<cfset Variables.recentPagesTitle = Variables.lang_recentPages_title.viewCobrand>
			<cfset Variables.recentMethod = "cobrand.viewCobrand">
		</cfif>
	</cfcase>
	<cfcase value="commissionID">
		<cfif IsDefined("URL.commissionID") and Application.fn_IsIntegerPositive(URL.commissionID) and IsDefined("qry_selectCobrand")>
			<cfset Variables.recentPagesText = Variables.lang_recentPages_title.commission & " #URL.commissionID# - #qry_selectCommission.commissionName#">
			<cfset Variables.recentPagesTitle = Variables.lang_recentPages_title.viewCommission>
			<cfset Variables.recentMethod = "commission.viewCommission">
		</cfif>
	</cfcase>
	<cfcase value="companyID">
		<cfif IsDefined("URL.companyID") and Application.fn_IsIntegerPositive(URL.companyID) and IsDefined("qry_selectCompany")>
			<cfset Variables.recentPagesText = Variables.lang_recentPages_title.company & " #URL.companyID# - #qry_selectCompany.companyName#">
			<cfset Variables.recentPagesTitle = Variables.lang_recentPages_title.viewCompany>
			<cfset Variables.recentMethod = "company.viewCompany">
		</cfif>
	</cfcase>
	<!--- <cfcase value="contactID"></cfcase> --->
	<cfcase value="groupID">
		<cfif IsDefined("URL.groupID") and Application.fn_IsIntegerPositive(URL.groupID) and IsDefined("qry_selectGroup")>
			<cfset Variables.recentPagesText = Variables.lang_recentPages_title.group & " #URL.groupID# - #qry_selectGroup.groupName#">
			<cfset Variables.recentPagesTitle = Variables.lang_recentPages_title.viewGroup>
			<cfset Variables.recentMethod = "group.viewGroup">
		</cfif>
	</cfcase>
	<cfcase value="invoiceID">
		<cfif IsDefined("URL.invoiceID") and Application.fn_IsIntegerPositive(URL.invoiceID) and IsDefined("qry_selectInvoice")>
			<cfset Variables.recentPagesText = Variables.lang_recentPages_title.invoice & " #URL.invoiceID# - #qry_selectInvoice.companyName#">
			<cfset Variables.recentPagesTitle = Variables.lang_recentPages_title.viewInvoice>
			<cfset Variables.recentMethod = "invoice.viewInvoice">
		</cfif>
	</cfcase>
	<cfcase value="payflowID">
		<cfif IsDefined("URL.payflowID") and Application.fn_IsIntegerPositive(URL.payflowID) and IsDefined("qry_selectPayflow")>
			<cfset Variables.recentPagesText = Variables.lang_recentPages_title.payflow & " #URL.payflowID# - #qry_selectPayflow.payflowName#">
			<cfset Variables.recentPagesTitle = Variables.lang_recentPages_title.viewPayflow>
			<cfset Variables.recentMethod = "payflow.viewPayflow">
		</cfif>
	</cfcase>
	<cfcase value="paymentID">
		<cfif IsDefined("URL.paymentID") and Application.fn_IsIntegerPositive(URL.paymentID) and IsDefined("qry_selectPayment")>
			<cfif qry_selectPayment.paymentIsRefund is 0>
				<cfset Variables.recentPagesText = Variables.lang_recentPages_title.payment
						& " " & ListFirst(DollarFormat(qry_selectPayment.paymentAmount), ".") 
						& Variables.lang_recentPages_title.on
						& DateFormat(qry_selectPayment.paymentDateReceived, "mm/dd")
						& " - " & qry_selectPayment.targetCompanyName>
				<cfset Variables.recentPagesTitle = Variables.lang_recentPages_title.viewPayment>
				<cfset Variables.recentMethod = "payment.viewPayment">
			<cfelse>
				<cfset Variables.recentPagesText = Variables.lang_recentPages_title.refund
						& " " & ListFirst(DollarFormat(qry_selectPayment.paymentAmount), ".")
						& Variables.lang_recentPages_title.on
						& DateFormat(qry_selectPayment.paymentDateReceived, "mm/dd")
						& " - " & qry_selectPayment.targetCompanyName>
				<cfset Variables.recentPagesTitle = Variables.lang_recentPages_title.viewRefund>
				<cfset Variables.recentMethod = "payment.viewPaymentRefund">
			</cfif>
		</cfif>
	</cfcase>
	<cfcase value="paymentCreditID">
		<cfif IsDefined("URL.paymentCreditID") and Application.fn_IsIntegerPositive(URL.paymentCreditID) and IsDefined("qry_selectPaymentCredit")>
			<cfset Variables.recentPagesText = Variables.lang_recentPages_title.paymentCredit
					& " " & ListFirst(DollarFormat(qry_selectPaymentCredit.paymentCreditAmount), ".")
					& Variables.lang_recentPages_title.on
					& DateFormat(qry_selectPaymentCredit.paymentCreditDateCreated, "mm/dd")
					& " - " & qry_selectPaymentCredit.targetCompanyName>
			<cfset Variables.recentPagesTitle = Variables.lang_recentPages_title.viewPaymentCredit>
			<cfset Variables.recentMethod = "paymentCredit.viewPaymentCredit">
		</cfif>
	</cfcase>
	<cfcase value="priceID">
		<cfif IsDefined("URL.priceID") and Application.fn_IsIntegerPositive(URL.priceID) and IsDefined("qry_selectPrice")>
			<cfset Variables.recentPagesText = Variables.lang_recentPages_title.price & " #URL.priceID# - #qry_selectPrice.priceName#">
			<cfset Variables.recentPagesTitle = Variables.lang_recentPages_title.viewPrice>
			<cfset Variables.recentMethod = "price.viewPrice">
		</cfif>
	</cfcase>
	<cfcase value="productID">
		<cfif IsDefined("URL.productID") and Application.fn_IsIntegerPositive(URL.productID) and IsDefined("qry_selectProduct")>
			<cfset Variables.recentPagesText = Variables.lang_recentPages_title.product & " #URL.productID# - #qry_selectProduct.productName#">
			<cfset Variables.recentPagesTitle = Variables.lang_recentPages_title.viewProduct>
			<cfset Variables.recentMethod = "product.viewProduct">
		</cfif>
	</cfcase>
	<!--- 
	<cfcase value="salesCommissionID">
		<cfif IsDefined("URL.salesCommissionID") and Application.fn_IsIntegerPositive(URL.salesCommissionID) and IsDefined("qry_selectSalesCommission")>
			<cfset Variables.recentPagesText = Variables.lang_recentPages_title.salesCommission
					& ListFirst(DollarFormat(qry_selectSalesCommission.salesCommissionAmount), ".")
					& Variables.lang_recentPages_title.on
					& DateFormat(qry_selectSalesCommission.salesCommissionDateCreated, "mm/dd")
					& " - " & qry_selectSalesCommission.targetName>
			<cfset Variables.recentPagesTitle = Variables.lang_recentPages_title.viewSalesCommission>
			<cfset Variables.recentMethod = "salesCommission.viewSalesCommission">
		</cfif>
	</cfcase>
	--->
	<cfcase value="subscriberID">
		<cfif IsDefined("URL.subscriberID") and Application.fn_IsIntegerPositive(URL.subscriberID) and IsDefined("qry_selectSubscriber")>
			<cfset Variables.recentPagesText = Variables.lang_recentPages_title.subscriber & " #URL.subscriberID# - #qry_selectSubscriber.subscriberName#">
			<cfset Variables.recentPagesTitle = Variables.lang_recentPages_title.viewSubscriber>
			<cfset Variables.recentMethod = "subscription.viewSubscriber">
		</cfif>
	</cfcase>
	<!--- <cfcase value="taskID"></cfcase> --->
	<cfcase value="userID">
		<cfif IsDefined("URL.userID") and Application.fn_IsIntegerPositive(URL.userID) and IsDefined("qry_selectUser")>
			<cfset Variables.recentPagesText = Variables.lang_recentPages_title.user & " #URL.userID# - #qry_selectUser.firstName# #qry_selectUser.lastName#">
			<cfset Variables.recentPagesTitle = Variables.lang_recentPages_title.viewUser>
			<cfset Variables.recentMethod = "user.viewUser">
		</cfif>
	</cfcase>
	<cfcase value="vendorID">
		<cfif IsDefined("URL.vendorID") and Application.fn_IsIntegerPositive(URL.vendorID) and IsDefined("qry_selectVendor")>
			<cfset Variables.recentPagesText = Variables.lang_recentPages_title.vendor & " #URL.vendorID# - #qry_selectVendor.vendorName#">
			<cfset Variables.recentPagesTitle = Variables.lang_recentPages_title.viewVendor>
			<cfset Variables.recentMethod = "vendor.viewVendor">
		</cfif>
	</cfcase>
	</cfswitch>

	<cfif Variables.recentPagesText is not "">
		<cfif Not StructKeyExists(Session, "recentPagesArray")>
			<cfset Variables.recentPagesArray = ArrayNew(1)>
			<cfset Variables.recentPagesArray[1] = StructNew()>
			<cfset Variables.recentPagesArray[1].url = "index.cfm?method=#Variables.recentMethod#&#Variables.recentPrimaryTargetKey#=#Variables.recentTargetID#">
			<cfset Variables.recentPagesArray[1].title = Variables.recentPagesTitle>
			<cfset Variables.recentPagesArray[1].text = Variables.recentPagesText>
			<cfset Variables.recentPagesArray[1].primaryTargetKey = Variables.recentPrimaryTargetKey>
			<cfset Variables.recentPagesArray[1].targetID = Variables.recentTargetID>
		<cfelse>
			<cfset Variables.recentPagesArray = Session.recentPagesArray>
			<cfset Variables.newRecentPageStruct = StructNew()>
			<cfset Variables.newRecentPageStruct.url = "index.cfm?#CGI.QUERY_STRING#">
			<cfset Variables.newRecentPageStruct.title = Variables.recentPagesTitle>
			<cfset Variables.newRecentPageStruct.text = Variables.recentPagesText>
			<cfset Variables.newRecentPageStruct.primaryTargetKey = Variables.recentPrimaryTargetKey>
			<cfset Variables.newRecentPageStruct.targetID = Variables.recentTargetID>

			<cfset temp = ArrayPrepend(Variables.recentPagesArray, Variables.newRecentPageStruct)>
			<cfif ArrayLen(Variables.recentPagesArray) gt Variables.recentPagesMaximum>
				<cfset temp = ArrayDeleteAt(Variables.recentPagesArray, Variables.recentPagesMaximum + 1)>
			</cfif>
		</cfif>

		<cflock Scope="Session" Timeout="5">
			<cfset Session.recentPagesArray = Variables.recentPagesArray>
		</cflock>
	</cfif>
</cfif>

