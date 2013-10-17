<cfparam Name="URL.IPaddressID" Default="0">

<cfinclude template="security_IPaddress.cfm">
<cfinclude template="../../view/v_IPaddress/nav_IPaddress.cfm">
<cfif IsDefined("URL.confirm_IPaddress")>
	<cfinclude template="../../view/v_IPaddress/confirm_IPaddress.cfm">
</cfif>
<cfif IsDefined("URL.error_IPaddress")>
	<cfinclude template="../../view/v_IPaddress/error_IPaddress.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listIPaddresses">
	<cfinclude template="control_listIPaddresses.cfm">
</cfcase>

<cfcase value="insertIPaddress">
	<cfinclude template="control_insertIPaddress.cfm">
</cfcase>

<cfcase value="updateIPaddress">
	<cfinclude template="control_updateIPaddress.cfm">
</cfcase>

<cfcase value="deleteIPaddress">
	<cfinvoke Component="#Application.billingMapping#data.IPaddress" Method="deleteIPaddress" ReturnVariable="isIPaddressDeleted">
		<cfinvokeargument Name="IPaddressID" Value="#URL.IPaddressID#">
	</cfinvoke>

	<cflocation url="index.cfm?method=IPaddress.listIPaddresses&confirm_IPaddress=#Variables.doAction#" AddToken="No">
</cfcase>

<cfdefaultcase>
	<cfset URL.error_IPaddress = "invalidAction">
	<cfinclude template="../../view/v_IPaddress/error_IPaddress.cfm">
</cfdefaultcase>
</cfswitch>

