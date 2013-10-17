<cfcomponent displayName="CheckForTrigger">

<cffunction name="checkForTrigger" access="public" returnType="boolean">
	<cfargument name="companyID" type="numeric" required="yes">
	<cfargument name="doAction" type="string" required="yes">
	<cfargument name="isWebService" type="boolean" required="no" default="False">
	<cfargument name="doControl" type="string" required="no" default="">
	<cfargument name="primaryTargetKey" type="string" required="no" default="">
	<cfargument name="targetID" type="numeric" required="no" default="0">

	<cfset var returnTriggerValue = False>

	<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectTriggerCompany">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
	</cfinvoke>

	<!--- 
	Determine whether to initiate a trigger based on company/action.
	Triggers can only be executed by primary companies, i.e., companies using the billing system to bill their own customers.
	It is not used by customers of that company if logged into their customer interface.
	--->

	<cfif qry_selectTriggerCompany.companyID_author is Application.billingSuperuserCompanyID>
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="getCompanyTriggerDirectory" returnVariable="triggerDirStruct">
			<cfinvokeargument name="companyDirectory" value="#qry_selectTriggerCompany.companyDirectory#">
		</cfinvoke>

		<cfif DirectoryExists(triggerDirStruct.companyTriggerDirectoryPath)>
			<cfinvoke Component="#Application.billingMapping#data.Trigger" Method="selectTriggerList" ReturnVariable="qry_selectTriggerList">
				<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
				<cfinvokeargument Name="triggerAction" Value="#Arguments.doAction#">
				<cfinvokeargument Name="triggerStatus" Value="1">
				<cfinvokeargument Name="triggerIsActive" Value="True">
			</cfinvoke>

			<cfif qry_selectTriggerList.RecordCount is 1 and FileExists(triggerDirStruct.companyTriggerDirectoryPath & Application.billingFilePathSlash & qry_selectTriggerList.triggerFilename)>
				<cfset returnTriggerValue = True>
				<cfinclude template="#triggerDirStruct.companyTriggerDirectoryInclude#/#qry_selectTriggerList.triggerFilename#">
			</cfif><!--- /trigger file exists --->
		</cfif><!--- /trigger exists --->
	</cfif><!--- /company is server manager company or billing customer --->

	<cfreturn returnTriggerValue>
</cffunction>

<cffunction name="getCompanyTriggerDirectory" access="public" output="no" returnType="struct">
	<cfargument name="companyDirectory" type="string" required="yes">

	<cfset var triggerDirectoryStruct = StructNew()>

	<cfif Arguments.companyDirectory is "">
		<cfset triggerDirectoryStruct.companyTriggerDirectoryPath = Application.billingCustomerDirectoryPath & Application.billingFilePathSlash & "trigger">
		<cfset triggerDirectoryStruct.companyTriggerDirectoryInclude = "../../" & Application.billingCustomerDirectoryInclude & "trigger">
	<cfelse>
		<cfset triggerDirectoryStruct.companyTriggerDirectoryPath = Application.billingCustomerDirectoryPath & Application.billingFilePathSlash & Arguments.companyDirectory & Application.billingFilePathSlash & "trigger">
		<cfset triggerDirectoryStruct.companyTriggerDirectoryInclude = "../../" & Application.billingCustomerDirectoryInclude & Arguments.companyDirectory & "/trigger">
	</cfif>

	<cfreturn triggerDirectoryStruct>
</cffunction>

</cfcomponent>