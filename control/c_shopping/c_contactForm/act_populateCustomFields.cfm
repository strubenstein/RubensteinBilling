<cfinvoke Component="#Application.billingMapping#data.CustomField" Method="selectCustomFieldList" ReturnVariable="qry_selectCustomFieldList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="customFieldName" Value="#Variables.customFieldName_list#">
</cfinvoke>

<!--- validate field type! --->
<cfif qry_selectCustomFieldList.RecordCount is not 0>
	<cfinvoke Component="#Application.billingMapping#data.CustomFieldOption" Method="selectCustomFieldOptionList" ReturnVariable="qry_selectCustomFieldOptionList">
		<cfinvokeargument Name="customFieldID" Value="#ValueList(qry_selectCustomFieldList.customFieldID)#">
		<cfinvokeargument Name="customFieldOptionStatus" Value="1">
	</cfinvoke>

	<cfset Variables.customFieldOptionValue_array = ArrayNew(1)>

	<cfloop Query="qry_selectCustomFieldList">
		<!--- if custom field variable exists in form and is not blank --->
		<cfset Variables.formVariable = qry_selectCustomFieldList.customFieldName>
		<cfif IsDefined("Form.#Variables.formVariable#") and Trim(Form[Variables.formVariable]) is not "">
			<cfset Variables.formValue = Form[Variables.formVariable]>
			<cfset Variables.thisCustomFieldID = qry_selectCustomFieldList.customFieldID>

			<cfset Variables.customFieldOptionID = "">
			<cfset Variables.customFieldOptionValue = "">

			<cfset Variables.thisPrimaryTarget = ListGetAt(Variables.customFieldTarget_list, ListFind(Variables.customFieldName_list, qry_selectCustomFieldList.customFieldName))>
			<cfset Variables.thisPrimaryTargetID = Application.fn_GetPrimaryTargetID(Variables.thisPrimaryTarget)>
			<cfif Variables.thisPrimaryTarget is "userID">
				<cfset Variables.thisTargetID = Variables.userID>
			<cfelse>
				<cfset Variables.thisTargetID = Variables.companyID>
			</cfif>

			<cfswitch expression="#qry_selectCustomFieldList.customFieldFormType#">
			<cfcase value="text,textarea">
				<cfset Variables.customFieldOptionID = 0>
				<cfset Variables.customFieldOptionValue = Variables.formValue>
			</cfcase>

			<cfcase value="radio,select">
				<cfset Variables.optionRow = ListFind(ValueList(qry_selectCustomFieldOptionList.customFieldID), Variables.thisCustomFieldID)>
				<cfif Variables.optionRow is not 0>
					<cfloop Query="qry_selectCustomFieldOptionList" StartRow="#Variables.optionRow#">
						<cfif qry_selectCustomFieldOptionList.customFieldID is not Variables.thisCustomFieldID><cfbreak></cfif>
						<cfif Variables.formValue is qry_selectCustomFieldOptionList.customFieldOptionValue>
							<cfset Variables.customFieldOptionID = qry_selectCustomFieldOptionList.customFieldOptionID>
							<cfset Variables.customFieldOptionValue = Variables.formValue>
							<cfbreak>
						</cfif>
					</cfloop>
				</cfif>
			</cfcase>

			<cfcase value="checkbox,selectMultiple">
				<cfset Variables.optionRow = ListFind(ValueList(qry_selectCustomFieldOptionList.customFieldID), Variables.thisCustomFieldID)>
				<cfif Variables.optionRow is not 0>
					<cfset temp = ArrayClear(Variables.customFieldOptionValue_array)>
					<cfloop Query="qry_selectCustomFieldOptionList" StartRow="#Variables.optionRow#">
						<cfif qry_selectCustomFieldOptionList.customFieldID is not Variables.thisCustomFieldID><cfbreak></cfif>
						<cfif ListFind(Variables.formValue, qry_selectCustomFieldOptionList.customFieldOptionValue)>
							<cfset Variables.customFieldOptionID = ListAppend(Variables.customFieldOptionID, qry_selectCustomFieldOptionList.customFieldOptionID)>
							<cfset temp = ArrayAppend(Variables.customFieldOptionValue_array, qry_selectCustomFieldOptionList.customFieldOptionValue)>
						</cfif>
					</cfloop>
				</cfif>
			</cfcase>
			</cfswitch>

			<!--- if custom form field value is not blank, insert --->
			<cfif Variables.customFieldOptionID is not "">
				<cfset Variables.thisCustomFieldType = qry_selectCustomFieldList.customFieldType>
				<cfset Variables.thisCustomFieldFormType = qry_selectCustomFieldList.customFieldFormType>

				<cfloop Index="count" From="1" To="#ListLen(Variables.customFieldOptionID)#">
					<cfif ListFind("checkbox,selectMultiple", Variables.thisCustomFieldFormType)>
						<cfset Variables.thisCustomFieldOptionValue = Variables.customFieldOptionValue_array[count]>
					<cfelse>
						<cfset Variables.thisCustomFieldOptionValue = Variables.customFieldOptionValue>
					</cfif>

					<cfinvoke Component="#Application.billingMapping#data.CustomFieldValue" Method="insertCustomFieldValue" ReturnVariable="isCustomFieldValueInserted">
						<cfinvokeargument Name="customFieldID" Value="#Variables.thisCustomFieldID#">
						<cfinvokeargument Name="userID" Value="#Variables.userID#">
						<cfinvokeargument Name="primaryTargetID" Value="#Variables.thisPrimaryTargetID#">
						<cfinvokeargument Name="targetID" Value="#Variables.thisTargetID#">
						<cfinvokeargument Name="customFieldType" Value="#Variables.thisCustomFieldType#">
						<cfinvokeargument Name="customFieldOptionID" Value="#ListGetAt(Variables.customFieldOptionID, count)#">
						<cfinvokeargument Name="customFieldValue" Value="#Variables.thisCustomFieldOptionValue#">
						<cfif count gt 1>
							<cfinvokeargument Name="updateCustomFieldStatus" Value="False">
						</cfif>
					</cfinvoke>

					<cfset Variables.theContactMessage = ReplaceNoCase(Variables.theContactMessage, "<<#Variables.formVariable#>>", Variables.thisCustomFieldOptionValue, "ALL")>
				</cfloop>
			</cfif>
		</cfif>
		<cfset Variables.theContactMessage = ReplaceNoCase(Variables.theContactMessage, "<<#Variables.formVariable#>>", "", "ALL")>
	</cfloop>
</cfif>
