<cfif Not Application.fn_IsIntegerNonNegative(URL.contactID)>
	<cflocation url="index.cfm?method=#URL.control#.listContacts#Variables.urlParameters#&error_contact=invalidContact" AddToken="No">
<cfelseif URL.contactID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Contact" Method="checkContactPermission" ReturnVariable="isContactPermission">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
		<cfinvokeargument Name="contactID" Value="#URL.contactID#">
		<cfif Variables.userID is not 0>
			<cfinvokeargument Name="userID_target" Value="#Variables.userID#">
		</cfif>
		<cfif Variables.companyID is not 0>
			<cfinvokeargument Name="companyID_target" Value="#Variables.companyID#">
		</cfif>
		<!--- 
		<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
		<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
		--->
	</cfinvoke>

	<cfif isContactPermission is False>
		<cflocation url="index.cfm?method=#URL.control#.listContacts#Variables.urlParameters#&error_contact=invalidContact" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Contact" Method="selectContact" ReturnVariable="qry_selectContact">
			<cfinvokeargument Name="contactID" Value="#URL.contactID#">
		</cfinvoke>

		<cfif URL.contactID is qry_selectContact.contactID_custom>
			<cfset URL.contactID = qry_selectContact.contactID>
		</cfif>

		<cfif Variables.doAction is "updateContact" and IsDate(qry_selectContact.contactDateSent)>
			<cflocation url="index.cfm?method=#URL.control#.viewContact#Variables.urlParameters#&contactID=#URL.contactID#&error_contact=updateContactSent" AddToken="No">
		</cfif>
	</cfif>
<cfelseif Not ListFind("listContacts,insertContact", Variables.doAction)>
	<cflocation url="index.cfm?method=#URL.control#.listContacts#Variables.urlParameters#&error_contact=noContact" AddToken="No">
</cfif>
