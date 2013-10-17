<cfinvoke Component="#Application.billingMapping#data.Contact" Method="updateContact" ReturnVariable="isContactUpdated">
	<cfinvokeargument Name="contactID" Value="#URL.contactID#">
	<cfinvokeargument Name="contactStatus" Value="#Right(Variables.doAction, 1)#">
</cfinvoke>

<cfif Not FindNoCase("index.cfm?method=", CGI.HTTP_REFERER)>
	<cflocation url="index.cfm?method=contact.listContacts&confirm_contact=#Variables.doAction#" AddToken="No">
<cfelse>
	<cfset Variables.redirectURL = CGI.HTTP_REFERER>
	<cfset Variables.findConfirm = ListFindNoCase(Variables.redirectURL, "confirm_contact", "=&")>
	<cfif Variables.findConfirm is 0>
		<cfset Variables.redirectURL = Variables.redirectURL & "&confirm_contact=" & Variables.doAction>
	<cfelse>
		<cfset Variables.redirectURL = ListSetAt(Variables.redirectURL, Variables.findConfirm + 1, Variables.doAction, "&=")>
	</cfif>

	<cflocation url="#Variables.redirectURL#" AddToken="No">
</cfif>
