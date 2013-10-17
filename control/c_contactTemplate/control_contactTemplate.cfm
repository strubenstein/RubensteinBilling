<!--- 
Targets for contact management templates (primaryTargetID):
User,Company,Salesperson,Vendor,Cobrand,Affiliate,Invoice,Payment,Shipping,Newsletter
--->

<cfset Variables.primaryTargetKey_list = "userID,companyID,vendorID,cobrandID,affiliateID,invoiceID,paymentID,shippingID,newsletterID">
<cfinvoke Component="#Application.billingMapping#data.PrimaryTarget" Method="selectPrimaryTargetList" ReturnVariable="qry_selectPrimaryTargetList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="primaryTargetKey" Value="#Variables.primaryTargetKey_list#">
	<cfinvokeargument Name="queryOrderBy" Value="primaryTargetName">
</cfinvoke>

<cfparam Name="URL.contactTemplateID" Default="0">
<cfparam Name="URL.languageID" Default="">

<cfinclude template="security_contactTemplate.cfm">
<cfinclude template="../../view/v_contactTemplate/nav_contactTemplate.cfm">
<cfif IsDefined("URL.confirm_contactTemplate")>
	<cfinclude template="../../view/v_contactTemplate/confirm_contactTemplate.cfm">
</cfif>
<cfif IsDefined("URL.error_contactTemplate")>
	<cfinclude template="../../view/v_contactTemplate/error_contactTemplate.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listContactTemplates">
	<cfinclude template="control_listContactTemplates.cfm">
</cfcase>

<cfcase value="insertContactTemplate">
	<cfinclude template="control_insertContactTemplate.cfm">
</cfcase>

<cfcase value="updateContactTemplate">
	<cfinclude template="control_updateContactTemplate.cfm">
</cfcase>

<cfcase value="moveContactTemplateUp,moveContactTemplateDown">
	<cfinvoke Component="#Application.billingMapping#data.ContactTemplate" Method="switchContactTemplateOrder" ReturnVariable="isContactTemplateOrderSwitched">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
		<cfinvokeargument Name="contactTemplateID" Value="#URL.contactTemplateID#">
		<cfinvokeargument Name="contactTemplateOrder_direction" Value="#Variables.doAction#">
	</cfinvoke>

	<cflocation url="index.cfm?method=contactTemplate.listContactTemplates&confirm_contactTemplate=#Variables.doAction#" AddToken="No">
</cfcase>

<cfcase value="viewContactTemplateFields">
	<cfinclude template="../../view/v_contactTemplate/dsp_contactTemplateFields.cfm">
</cfcase>

<cfdefaultcase>
	<cfset URL.error_contactTemplate = "invalidAction">
	<cfinclude template="../../view/v_contactTemplate/error_contactTemplate.cfm">
</cfdefaultcase>
</cfswitch>

