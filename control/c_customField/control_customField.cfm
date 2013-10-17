<!--- 
avCustomField
	customFieldFormSize(2) size/maxlength or rows/cols
	customFieldRangeMinimum
	customFieldRangeMaximum
	customFieldRequired
	customFieldFormType = hidden ?
NAV BAR - SWITCH TO TARGET-ORIENTED NAV BAR

SUB-NAV ACROSS ALL SHARED FEATURES FOR COMPANY/USER:
note,task,custom fields,group,price,contact,address,phone,creditcard,permissions
--->

<cfparam Name="URL.customFieldID" Default="0">
<cfparam Name="Variables.urlParameters" Default="">

<cfinclude template="security_customField.cfm">
<cfif URL.control is "customField"><!---  or Variables.urlParameters is not "" --->
	<cfinclude template="../../view/v_customField/nav_customField.cfm">
</cfif>
<cfif IsDefined("URL.confirm_customField")>
	<cfinclude template="../../view/v_customField/confirm_customField.cfm">
</cfif>
<cfif IsDefined("URL.error_customField")>
	<cfinclude template="../../view/v_customField/error_customField.cfm">
</cfif>

<cfinclude template="../../view/v_customField/var_customFieldTypeList.cfm">
<cfinclude template="../../view/v_customField/var_customFieldTargetList.cfm">

<cfswitch expression="#Variables.doAction#">
<cfcase value="listCustomFields">
	<cfinclude template="control_listCustomFields.cfm">
</cfcase>

<cfcase value="insertCustomField">
	<cfinclude template="control_insertCustomField.cfm">
</cfcase>

<cfcase value="updateCustomField">
	<cfinclude template="control_updateCustomField.cfm">
</cfcase>

<cfcase value="listCustomFieldTargets">
	<cfinclude template="control_listCustomFieldTargets.cfm">
</cfcase>

<cfcase value="moveCustomFieldTargetUp,moveCustomFieldTargetDown">
	<cfinclude template="control_moveCustomFieldTarget.cfm">
</cfcase>

<cfcase value="viewCustomFieldValuesAll">
	<cfif URL.control is "customField">
		<cfset URL.error_customField = "invalidTargetAction">
		<cfinclude template="../../view/v_customField/error_customField.cfm">
	<cfelse>
		<cfparam Name="Variables.primaryTargetID" Default="0">
		<cfparam Name="Variables.targetID" Default="0">

		<cfinvoke Component="#Application.billingMapping#data.CustomFieldTarget" Method="selectCustomFieldListForTarget" ReturnVariable="qry_selectCustomFieldListForTarget">
			<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
			<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
		</cfinvoke>

		<cfif qry_selectCustomFieldListForTarget.RecordCount is 0>
			<!--- only display error if displaying on its own form instead of being incorporated into primary object form --->
			<cfif Not IsDefined("Variables.formAction") or Variables.formAction is not "">
				<cfset URL.error_customField = "noCustomFieldsForTarget">
				<cfinclude template="../../view/v_customField/error_customField.cfm">
			</cfif>
		<cfelse>
			<cfinclude template="control_viewCustomFieldValuesAll.cfm">
		</cfif>
	</cfif>
</cfcase>

<cfdefaultcase>
	<cfset URL.error_customField = "invalidAction">
	<cfinclude template="../../view/v_customField/error_customField.cfm">
</cfdefaultcase>
</cfswitch>

