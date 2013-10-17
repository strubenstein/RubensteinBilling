<cfcomponent displayName="InsertFieldArchive">

<cffunction name="insertFieldArchiveViaTarget" access="public" output="no" returnType="boolean">
	<cfargument name="primaryTargetKey" type="string" required="yes">
	<cfargument name="targetID" type="numeric" required="yes">
	<cfargument name="userID" type="numeric" required="yes">
	<cfargument name="qry_selectTarget" type="query" required="yes">

	<cfset var fieldArchiveArray = ArrayNew(1)>
	<cfset var fieldArchiveStruct = StructNew()>

	<cfinvoke component="#Application.billingMapping#control.c_fieldArchive.ViewFieldArchives" method="determineFieldArchiveTarget" returnVariable="archiveStruct">
		<cfinvokeargument name="primaryTargetKey" value="#Arguments.primaryTargetKey#">
	</cfinvoke>

	<cfloop Index="field" List="#archiveStruct.fieldArchiveFieldList#">
		<cfif IsDefined("Form.#field#") and Form[field] is not Evaluate("Arguments.qry_selectTarget.#field#")>
			<cfset fieldArchiveStruct = StructNew()>
			<cfset fieldArchiveStruct.fieldArchiveTableName = archiveStruct.fieldArchiveTableName>
			<cfset fieldArchiveStruct.fieldArchiveFieldName = field>
			<cfset fieldArchiveStruct.fieldArchiveValue = Evaluate("Arguments.qry_selectTarget.#field#")>
			<cfset fieldArchiveArray[ArrayLen(fieldArchiveArray) + 1] = fieldArchiveStruct>
		</cfif>
	</cfloop>

	<cfif ArrayLen(fieldArchiveArray) is not 0>
		<cfinvoke Component="#Application.billingMapping#data.FieldArchive" Method="insertFieldArchive_multiple" ReturnVariable="isFieldArchiveMultipleInserted">
			<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey)#">
			<cfinvokeargument Name="targetID" Value="#Arguments.targetID#">
			<cfinvokeargument Name="fieldArchiveArray" Value="#fieldArchiveArray#">
			<cfinvokeargument Name="userID" Value="#Arguments.userID#">
		</cfinvoke>
	</cfif>

	<cfreturn True>
</cffunction>

</cfcomponent>

