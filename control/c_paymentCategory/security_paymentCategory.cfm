<cfif Not Application.fn_IsIntegerNonNegative(URL.paymentCategoryID)>
	<cflocation url="index.cfm?method=paymentCategory.listPaymentCategories&error_paymentCategory=invalidPaymentCategory" AddToken="No">
<cfelseif URL.paymentCategoryID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.PaymentCategory" Method="checkPaymentCategoryPermission" ReturnVariable="isPaymentCategoryPermission">
		<cfinvokeargument Name="paymentCategoryID" Value="#URL.paymentCategoryID#">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	</cfinvoke>

	<cfif isPaymentCategoryPermission is False>
		<cflocation url="index.cfm?method=paymentCategory.listPaymentCategories&error_paymentCategory=invalidPaymentCategory" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.PaymentCategory" Method="selectPaymentCategory" ReturnVariable="qry_selectPaymentCategory">
			<cfinvokeargument Name="paymentCategoryID" Value="#URL.paymentCategoryID#">
		</cfinvoke>
	</cfif>
<cfelseif Not ListFind("listPaymentCategories,insertPaymentCategory", Variables.doAction)>
	<cflocation url="index.cfm?method=paymentCategory.listPaymentCategories&error_paymentCategory=noPaymentCategory" AddToken="No">
</cfif>

<cfif Not ListFind(Variables.paymentCategoryTypeList_value, URL.paymentCategoryType)>
	<cflocation url="index.cfm?method=paymentCategory.listPaymentCategories&error_paymentCategory=invalidPaymentCategoryType" AddToken="No">
</cfif>
