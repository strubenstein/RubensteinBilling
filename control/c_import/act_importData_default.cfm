<!--- <cfobject Component="#Application.billingMapping#webservice.#Variables.importWebserviceComponent#" Name="objImport"> --->

<cfif Form.importFileFirstRowIsHeader is True>
	<cfset Variables.firstRow = 2>
<cfelse>
	<cfset Variables.firstRow = 1>
</cfif>

<!--- structure used to store imported fields --->
<cfset Variables.importDataStruct = StructNew()>
<cfset Variables.importDataFailed = "">

<!--- Login user to create web services session for import purposes --->
<cfif Not StructKeyExists(Application, "WebServiceSessions")>
	<cflock Scope="Application" Timeout="10">
		<cfif Not StructKeyExists(Application, "WebServiceSessions")>
			<cfset Application.objWebServiceSessions = StructNew()>
		</cfif>
	</cflock>
</cfif>

<cfset Variables.sessionUUID = CreateUUID()>

<cfset permissionStructList = "">
<cfloop Collection="#Session.permissionStruct#" Item="field">
	<cfset permissionStructList = ListAppend(permissionStructList, field & "_" & Session.permissionStruct[field])>
</cfloop>

<cfinvoke Component="#Application.billingMapping#webservice.WebServiceSecurity" Method="insertWebServiceSession" ReturnVariable="isWebServiceSessionInserted">
	<cfinvokeargument Name="webServiceSessionUUID" Value="#Variables.sessionUUID#">
	<cfinvokeargument Name="userID" Value="#Session.userID#">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
	<cfinvokeargument Name="webServiceSessionPermissionStruct" Value="#permissionStructList#">
	<cfinvokeargument Name="webServiceSessionIPaddress" Value="#CGI.REMOTE_ADDR#">
	<cfinvokeargument Name="webServiceSessionLastError" Value="">
</cfinvoke>

<cfset Variables.importDataStruct.sessionUUID = Variables.sessionUUID>

<!--- create default values for fields in method that are not in import file --->
<cfloop Index="field" List="#Variables.importFieldList_value#">
	<cfif Left(field, 12) is not "customField_">
		<cfset Variables.booleanPosition = ListFind(Variables.importFieldList_boolean, field)>
		<cfif Variables.booleanPosition is not 0>
			<cfset Variables.importDataStruct[field] = ListGetAt(Variables.importFieldList_booleanDefault, Variables.booleanPosition)>
		<cfelse>
			<cfset Variables.numericPosition = ListFind(Variables.importFieldList_numeric, field)>
			<cfif Variables.numericPosition is not 0>
				<cfset Variables.importDataStruct[field] = ListGetAt(Variables.importFieldList_numericDefault, Variables.numericPosition)>
			<cfelse>
				<cfset Variables.importDataStruct[field] = "">
			</cfif>
		</cfif>
	</cfif>
</cfloop>

