<cfinclude template="../../view/v_paymentCategory/var_paymentCategoryTypeList.cfm">

<cfparam Name="URL.paymentCategoryID" Default="0">
<cfparam Name="URL.paymentCategoryType" Default="payment"><!--- refund,credit --->

<cfinclude template="security_paymentCategory.cfm">
<cfinclude template="../../view/v_paymentCategory/nav_paymentCategory.cfm">
<cfif IsDefined("URL.confirm_paymentCategory")>
	<cfinclude template="../../view/v_paymentCategory/confirm_paymentCategory.cfm">
</cfif>
<cfif IsDefined("URL.error_paymentCategory")>
	<cfinclude template="../../view/v_paymentCategory/error_paymentCategory.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listPaymentCategories">
	<cfinclude template="control_listPaymentCategories.cfm">
</cfcase>

<cfcase value="insertPaymentCategory">
	<cfinclude template="control_insertPaymentCategory.cfm">
</cfcase>

<cfcase value="updatePaymentCategory">
	<cfinclude template="control_updatePaymentCategory.cfm">
</cfcase>

<cfcase value="movePaymentCategoryUp,movePaymentCategoryDown">
	<cfinvoke Component="#Application.billingMapping#data.PaymentCategory" Method="switchPaymentCategoryOrder" ReturnVariable="isPaymentCategoryOrderSwitched">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
		<cfinvokeargument Name="paymentCategoryID" Value="#URL.paymentCategoryID#">
		<cfinvokeargument Name="paymentCategoryType" Value="#qry_selectPaymentCategory.paymentCategoryType#">
		<cfinvokeargument Name="paymentCategoryOrder_direction" Value="#Variables.doAction#">
	</cfinvoke>

	<cflocation url="index.cfm?method=paymentCategory.listPaymentCategories&confirm_paymentCategory=#Variables.doAction#" AddToken="No">
</cfcase>

<cfdefaultcase>
	<cfset URL.error_paymentCredit = "invalidAction">
	<cfinclude template="../../view/v_paymentCategory/error_paymentCategory.cfm">
</cfdefaultcase>
</cfswitch>
