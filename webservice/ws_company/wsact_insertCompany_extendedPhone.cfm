<!--- phone --->
<cfset Arguments.phoneID = 0>
<cfif ListFind(Arguments.insertExtendedFieldTypeList, "phoneID") and ListFind(permissionActionList, "insertPhone")>
	<cfset returnValue = 0>
	<cfset URL.phoneID = 0>
	<cfinclude template="../ws_phone/wsact_insertPhone.cfm">
	<cfif returnValue gt 0>
		<cfset Arguments.phoneID = returnValue>
		<cfset returnValueXml = returnValueXml & "<phoneID>#Arguments.phoneID#</phoneID>">
	</cfif>
</cfif>

<!--- fax --->
<cfset Arguments.faxID = 0>
<cfif ListFind(Arguments.insertExtendedFieldTypeList, "faxID") and ListFind(permissionActionList, "insertPhone")>
	<cfset Arguments.phoneExtension = "">
	<cfset Arguments.phoneType = "fax">
	<cfloop Index="field" List="AreaCode,Number,Description">
		<cfset Arguments["Phone#field#"] = Arguments["Fax#field#"]>
	</cfloop>

	<cfset returnValue = 0>
	<cfset URL.phoneID = 0>
	<cfinclude template="../ws_phone/wsact_insertPhone.cfm">
	<cfif returnValue gt 0>
		<cfset Arguments.faxID = returnValue>
		<cfset returnValueXml = returnValueXml & "<faxID>#Arguments.faxID#</faxID>">
	</cfif>
</cfif>
