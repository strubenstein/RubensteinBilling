<cfcomponent DisplayName="WebServiceSecurity" Hint="Manages all web services security functions for validating targetID's.">

<!--- Company --->
<cffunction Name="ws_checkCompanyPermission" Access="public" Output="No" ReturnType="string" Hint="Determines whether company has permission for requested company. Returns list of companyID's instead of True/False in case checking via companyID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="string" Required="No" Default="">
	<cfargument Name="companyID_custom" Type="string" Required="No" Default="">
	<cfargument Name="useCustomIDFieldList" Type="string" Required="No" Default="">

	<cfset var returnValue = 0>
	<!--- <cfset var isCompanyPermission = False><cfset var companyIDViaCustomID = ""> --->

	<cfinclude template="webserviceSecurity/ws_checkCompanyPermission.cfm">
	<cfreturn returnValue>
</cffunction>

<!--- User --->
<cffunction Name="ws_checkUserPermission" Access="public" Output="No" ReturnType="string" Hint="Determines whether company has permission for requested user. Returns list of userID's instead of True/False in case checking via userID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="string" Required="Yes">
	<cfargument Name="userID_custom" Type="string" Required="No" Default="">
	<cfargument Name="useCustomIDFieldList" Type="string" Required="No" Default="">
	<cfargument Name="companyID" Type="numeric" Required="No">

	<cfset var returnValue = 0>
	<!--- <cfset var isUserPermission = False><cfset var userIDViaCustomID = ""> --->

	<cfinclude template="webserviceSecurity/ws_checkUserPermission.cfm">
	<cfreturn returnValue>
</cffunction>

<!--- Affiliate --->
<cffunction Name="ws_checkAffiliatePermission" Access="public" Output="No" ReturnType="string" Hint="Determines whether company has permission for requested affiliate. Returns list of affiliateID's instead of True/False in case checking via affiliateID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="affiliateID" Type="string" Required="Yes">
	<cfargument Name="affiliateID_custom" Type="string" Required="No" Default="">
	<cfargument Name="useCustomIDFieldList" Type="string" Required="No" Default="">

	<cfset var returnValue = 0>
	<!--- <cfset var isAffiliatePermission = False><cfset var affiliateIDViaCustomID = ""> --->

	<cfinclude template="webserviceSecurity/ws_checkAffiliatePermission.cfm">
	<cfreturn returnValue>
</cffunction>

<!--- Cobrand --->
<cffunction Name="ws_checkCobrandPermission" Access="public" Output="No" ReturnType="string" Hint="Determines whether company has permission for requested cobrand. Returns list of cobrandID's instead of True/False in case checking via cobrandID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="cobrandID" Type="string" Required="Yes">
	<cfargument Name="cobrandID_custom" Type="string" Required="No" Default="">
	<cfargument Name="useCustomIDFieldList" Type="string" Required="No" Default="">

	<cfset var returnValue = 0>
	<!--- <cfset var isCobrandPermission = False><cfset var cobrandIDViaCustomID = ""> --->

	<cfinclude template="webserviceSecurity/ws_checkCobrandPermission.cfm">
	<cfreturn returnValue>
</cffunction>

<!--- Group --->
<cffunction Name="ws_checkGroupPermission" Access="public" Output="No" ReturnType="string" Hint="Determines whether company has permission for requested group. Returns list of groupID's instead of True/False in case checking via groupID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="groupID" Type="string" Required="Yes">
	<cfargument Name="groupID_custom" Type="string" Required="No" Default="">
	<cfargument Name="useCustomIDFieldList" Type="string" Required="No" Default="">

	<cfset var returnValue = 0>
	<!--- <cfset var isGroupPermission = False><cfset var groupIDViaCustomID = ""> --->

	<cfinclude template="webserviceSecurity/ws_checkGroupPermission.cfm">
	<cfreturn returnValue>
</cffunction>

<!--- Vendor --->
<cffunction Name="ws_checkVendorPermission" Access="public" Output="No" ReturnType="string" Hint="Determines whether company has permission for requested vendor. Returns list of vendorID's instead of True/False in case checking via vendorID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="vendorID" Type="string" Required="Yes">
	<cfargument Name="vendorID_custom" Type="string" Required="No" Default="">
	<cfargument Name="useCustomIDFieldList" Type="string" Required="No" Default="">

	<cfset var returnValue = 0>
	<!--- <cfset var isVendorPermission = False><cfset var vendorIDViaCustomID = ""> --->

	<cfinclude template="webserviceSecurity/ws_checkVendorPermission.cfm">
	<cfreturn returnValue>
</cffunction>

<!--- Payflow --->
<cffunction Name="ws_checkPayflowPermission" Access="public" Output="No" ReturnType="string" Hint="Determines whether company has permission for requested payflow. Returns list of payflowID's instead of True/False in case checking via payflowID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="payflowID" Type="string" Required="Yes">
	<cfargument Name="payflowID_custom" Type="string" Required="No" Default="">
	<cfargument Name="useCustomIDFieldList" Type="string" Required="No" Default="">

	<cfset var returnValue = 0>
	<!--- <cfset var isPayflowPermission = False><cfset var payflowIDViaCustomID = ""> --->

	<cfinclude template="webserviceSecurity/ws_checkPayflowPermission.cfm">
	<cfreturn returnValue>
</cffunction>

<!--- Status --->
<cffunction Name="ws_checkStatusPermission" Access="public" Output="No" ReturnType="string" Hint="Determines whether company has permission for requested status. Returns list of statusID's instead of True/False in case checking via statusID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="statusID" Type="string" Required="Yes">
	<cfargument Name="statusID_custom" Type="string" Required="No" Default="">
	<cfargument Name="useCustomIDFieldList" Type="string" Required="No" Default="">
	<cfargument Name="primaryTargetKey" Type="string" Required="No" Default="">

	<cfset var returnValue = 0>
	<cfset var primaryTargetID = 0>
	<!--- <cfset var isStatusPermission = False><cfset var statusIDViaCustomID = ""> --->

	<cfinclude template="webserviceSecurity/ws_checkStatusPermission.cfm">
	<cfreturn returnValue>
</cffunction>

<!--- Address --->
<!--- 
<cffunction Name="ws_checkAddressPermission" Access="public" Output="No" ReturnType="boolean" Hint="Determines whether company/user combination has permission for requested address. Returns True/False.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="No" Default="0">
	<cfargument Name="userID" Type="numeric" Required="No" Default="0">
	<cfargument Name="addressID" Type="string" Required="No" Default="">
	<!--- 
	<cfargument Name="addressTypeBilling" Type="string" Required="No" Default="">
	<cfargument Name="addressTypeShipping" Type="string" Required="No" Default="">
	--->
	<cfinclude template="webserviceSecurity/ws_checkAddressPermission.cfm">
	<cfreturn returnValue>
</cffunction>
--->
<!--- Phone --->
<!--- Bank --->
<!--- CreditCard --->

<!--- Price --->
<cffunction Name="ws_checkPricePermission" Access="public" Output="No" ReturnType="string" Hint="Determines whether company has permission for requested custom price. Returns list of priceID's instead of True/False in case checking via priceID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="priceID" Type="string" Required="Yes">
	<cfargument Name="priceID_custom" Type="string" Required="Yes">
	<cfargument Name="useCustomIDFieldList" Type="string" Required="No" Default="">

	<cfset var returnValue = 0>
	<!--- <cfset var isPricePermission = False><cfset var priceIDViaCustomID = ""> --->

	<cfinclude template="webserviceSecurity/ws_checkPricePermission.cfm">
	<cfreturn returnValue>
</cffunction>

<!--- Product --->
<cffunction Name="ws_checkProductPermission" Access="public" Output="No" ReturnType="string" Hint="Determines whether company has permission for requested product. Returns list of productID's instead of True/False in case checking via productID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="productID" Type="string" Required="Yes">
	<cfargument Name="productID_custom" Type="string" Required="Yes">
	<cfargument Name="useCustomIDFieldList" Type="string" Required="No" Default="">

	<cfset var returnValue = 0>
	<!--- <cfset var isProductPermission = False><cfset var productIDViaCustomID = ""> --->

	<cfinclude template="webserviceSecurity/ws_checkProductPermission.cfm">
	<cfreturn returnValue>
</cffunction>

<!--- Invoice --->
<cffunction Name="ws_checkInvoicePermission" Access="public" Output="No" ReturnType="string" Hint="Determines whether company has permission for requested invoice. Returns list of invoiceID's instead of True/False in case checking via invoiceID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="invoiceID" Type="string" Required="Yes">
	<cfargument Name="invoiceID_custom" Type="string" Required="Yes">
	<cfargument Name="useCustomIDFieldList" Type="string" Required="No" Default="">

	<cfset var returnValue = 0>
	<!--- <cfset var isInvoicePermission = False><cfset var invoiceIDViaCustomID = ""> --->

	<cfinclude template="webserviceSecurity/ws_checkInvoicePermission.cfm">
	<cfreturn returnValue>
</cffunction>

<!--- Subscriber --->
<cffunction Name="ws_checkSubscriberPermission" Access="public" Output="No" ReturnType="string" Hint="Determines whether company has permission for requested subscriber. Returns list of subscriberID's instead of True/False in case checking via subscriberID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="subscriberID" Type="string" Required="Yes">
	<cfargument Name="subscriberID_custom" Type="string" Required="Yes">
	<cfargument Name="useCustomIDFieldList" Type="string" Required="No" Default="">
	<cfargument Name="companyID" Type="numeric" Required="No">

	<cfset var returnValue = 0>
	<!--- <cfset var isSubscriberPermission = False><cfset var subscriberIDViaCustomID = ""> --->

	<cfinclude template="webserviceSecurity/ws_checkSubscriberPermission.cfm">
	<cfreturn returnValue>
</cffunction>

<!--- Subscription --->
<cffunction Name="ws_checkSubscriptionPermission" Access="public" Output="No" ReturnType="string" Hint="Determines whether company has permission for requested subscription. Returns list of subscriptionID's instead of True/False in case checking via subscriptionID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="subscriptionID" Type="string" Required="Yes">
	<cfargument Name="subscriptionID_custom" Type="string" Required="Yes">
	<cfargument Name="useCustomIDFieldList" Type="string" Required="No" Default="">

	<cfset var returnValue = 0>
	<!--- <cfset var isSubscriptionPermission = False><cfset var subscriptionIDViaCustomID = ""> --->

	<cfinclude template="webserviceSecurity/ws_checkSubscriptionPermission.cfm">
	<cfreturn returnValue>
</cffunction>

<!--- Commission --->
<cffunction Name="ws_checkCommissionPermission" Access="public" Output="No" ReturnType="string" Hint="Determines whether company has permission for requested commission plan. Returns list of commissionID's instead of True/False in case checking via commissionID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="commissionID" Type="string" Required="Yes">
	<cfargument Name="commissionID_custom" Type="string" Required="Yes">
	<cfargument Name="useCustomIDFieldList" Type="string" Required="No" Default="">

	<cfset var returnValue = 0>
	<!--- <cfset var isCommissionPermission = False><cfset var commissionIDViaCustomID = ""> --->

	<cfinclude template="webserviceSecurity/ws_checkCommissionPermission.cfm">
	<cfreturn returnValue>
</cffunction>

<!--- Payment --->
<cffunction Name="ws_checkPaymentPermission" Access="public" Output="No" ReturnType="string" Hint="Determines whether company has permission for requested payment. Returns list of paymentID's instead of True/False in case checking via paymentID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="paymentID" Type="string" Required="Yes">
	<cfargument Name="paymentID_custom" Type="string" Required="No" Default="">
	<cfargument Name="useCustomIDFieldList" Type="string" Required="No" Default="">

	<cfset var returnValue = 0>
	<!--- <cfset var isPaymentPermission = False><cfset var paymentIDViaCustomID = ""> --->

	<cfinclude template="webserviceSecurity/ws_checkPaymentPermission.cfm">
	<cfreturn returnValue>
</cffunction>

<!--- PaymentCredit --->
<!--- 
<cffunction Name="ws_checkPaymentCreditPermission" Access="public" Output="No" ReturnType="string" Hint="Determines whether company has permission for requested paymentCredit. Returns list of paymentCreditID's instead of True/False in case checking via paymentCreditID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="paymentCreditID" Type="string" Required="Yes">
	<cfargument Name="paymentCreditID_custom" Type="string" Required="No" Default="">
	<cfargument Name="useCustomIDFieldList" Type="string" Required="No" Default="">

	<cfset var returnValue = 0>
	<!--- <cfset var isPaymentCreditPermission = False><cfset var paymentCreditIDViaCustomID = ""> --->

	<cfinclude template="webserviceSecurity/ws_checkPaymentCreditPermission.cfm">
	<cfreturn returnValue>
</cffunction>
--->

<!--- PaymentCategory --->
<cffunction Name="ws_checkPaymentCategoryPermission" Access="public" Output="No" ReturnType="string" Hint="Determines whether company has permission for requested paymentCategory. Returns list of paymentCategoryID's instead of True/False in case checking via paymentCategoryID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="paymentCategoryID" Type="string" Required="Yes">
	<cfargument Name="paymentCategoryID_custom" Type="string" Required="No" Default="">
	<cfargument Name="useCustomIDFieldList" Type="string" Required="No" Default="">

	<cfset var returnValue = 0>
	<!--- <cfset var isPaymentCategoryPermission = False><cfset var paymentCategoryIDViaCustomID = ""> --->

	<cfinclude template="webserviceSecurity/ws_checkPaymentCategoryPermission.cfm">
	<cfreturn returnValue>
</cffunction>

<!--- Category --->
<cffunction Name="ws_checkCategoryPermission" Access="public" Output="No" ReturnType="string" Hint="Determines whether company has permission for requested (product) category. Returns list of categoryID's instead of True/False in case checking via categoryCode.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="categoryID" Type="string" Required="Yes">
	<cfargument Name="categoryCode" Type="string" Required="No" Default="">
	<cfargument Name="useCustomIDFieldList" Type="string" Required="No" Default="">

	<cfset var returnValue = 0>
	<!--- <cfset var isCategoryPermission = False><cfset var categoryIDViaCode = ""> --->

	<cfinclude template="webserviceSecurity/ws_checkCategoryPermission.cfm">
	<cfreturn returnValue>
</cffunction>

</cfcomponent>
