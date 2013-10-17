<!--- 
userID,invoiceID,companyID:select user(s)
multiple recipients? groups,newsletter,
contactTemplateCategory ?
--->

<cfparam Name="URL.contactID" Default="0">
<cfparam Name="Variables.primaryTargetID" Default="0">
<cfparam Name="Variables.targetID" Default="0">
<cfparam Name="Variables.userID" Default="0">
<cfparam Name="Variables.companyID" Default="0">
<cfparam Name="Variables.invoiceID" Default="0">
<cfparam Name="Variables.shippingID" Default="0">
<cfparam Name="Variables.urlParameters" Default="">

<cfinclude template="security_contact.cfm">
<cfinclude template="../../view/v_contact/nav_contact.cfm">
<cfif IsDefined("URL.confirm_contact")>
	<cfinclude template="../../view/v_contact/confirm_contact.cfm">
</cfif>
<cfif IsDefined("URL.error_contact")>
	<cfinclude template="../../view/v_contact/error_contact.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listContacts">
	<cfinclude template="control_listContacts.cfm">
</cfcase>

<cfcase value="insertContact,replyToContact">
	<cfinclude template="control_insertContact.cfm">
</cfcase>

<cfcase value="updateContact">
	<cfinclude template="control_updateContact.cfm">
</cfcase>

<cfcase value="viewContact">
	<cfinclude template="control_viewContact.cfm">
</cfcase>

<cfcase value="updateContactStatus0,updateContactStatus1">
	<cfinclude template="control_updateContactStatus.cfm">
</cfcase>

<!--- 
<cfcase value="listStatusHistory">
	<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistory">
		<cfinvokeargument name="primaryTargetKey" value="contactID">
		<cfinvokeargument name="targetID" value="#URL.contactID#">
	</cfinvoke>
</cfcase>
--->

<cfdefaultcase>
	<cfset URL.error_contact = "invalidAction">
	<cfinclude template="../../view/v_contact/error_contact.cfm">
</cfdefaultcase>
</cfswitch>