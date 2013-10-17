<cfparam Name="URL.action" Default="viewCart">

<cfif Not StructKeyExists(Session, "shoppingCart")>
	<cflock Scope="Session" Timeout="10">
		<cfset Session.shoppingCart = ArrayNew(1)>
	</cflock>
</cfif>

<cfinclude template="control/c_shopping/c_shoppingCart/control_shoppingCart.cfm">
