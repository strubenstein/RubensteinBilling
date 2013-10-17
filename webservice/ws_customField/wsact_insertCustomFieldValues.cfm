<cfinclude template="wslang_customField.cfm">
<cfif Trim(Arguments.customField) is "">
	<cfset customFieldXml = "">
<cfelse>
	<cftry>
		<cfset customFieldXML = XMLParse(Arguments.customField)>

		<cfcatch>
			<cfset customFieldXml = "">
		</cfcatch>
	</cftry>
</cfif>

<!--- customField must be valid xml with child tags and customField as root element --->
<cfif customFieldXml is "" or Not IsXMLDoc(customFieldXml)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_customField.invalidXml>
<cfelseif StructKeyList(customFieldXml) is not "customField">
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_customField.parentXml>
<cfelseif ArrayLen(customFieldXml.XmlRoot.XmlChildren) is 0>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_customField.noValues>
<cfelseif primaryTargetID is 0>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_customField.invalidTargetType>
<cfelseif Not Application.fn_IsIntegerPositive(Arguments.targetID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_customField.invalidTarget>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.CustomFieldTarget" Method="selectCustomFieldListForTarget" ReturnVariable="qry_selectCustomFieldListForTarget">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID_author#">
		<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID#">
		<cfinvokeargument Name="customFieldStatus" Value="1">
	</cfinvoke>

	<cfif qry_selectCustomFieldListForTarget.RecordCount is 0>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_customField.noCustomFields>
	<cfelse>
		<cfset customFieldTypeList = "">
		<cfloop Query="qry_selectCustomFieldListForTarget">
			<cfif Not ListFind(customFieldTypeList, qry_selectCustomFieldListForTarget.customFieldType)>
				<cfset customFieldTypeList = ListAppend(customFieldTypeList, qry_selectCustomFieldListForTarget.customFieldType)>
			</cfif>
			<!--- set default value for all custom fields --->
			<cfset Form["customField#qry_selectCustomFieldListForTarget.customFieldID#"] = "">
		</cfloop>

		<!--- select existing values of custom fields for target --->
		<cfinvoke Component="#Application.billingMapping#data.CustomFieldValue" Method="selectCustomFieldValueList" ReturnVariable="qry_selectCustomFieldValueList">
			<cfinvokeargument Name="customFieldID" Value="#ValueList(qry_selectCustomFieldListForTarget.customFieldID)#">
			<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID#">
			<cfinvokeargument Name="targetID" Value="#Arguments.targetID#">
			<cfinvokeargument Name="customFieldValueStatus" Value="1">
			<cfinvokeargument Name="customFieldTypeList" Value="#customFieldTypeList#">
		</cfinvoke>

		<!--- loop thru elements in customField xml and set as custom field value --->
		<cfset customFieldXmlCount = ArrayLen(customFieldXml.XmlRoot.XmlChildren)>
		<cfloop Index="count" From="1" To="#customFieldXmlCount#">
			<cfset customFieldXmlName = customFieldXml.XmlRoot.XmlChildren[count].XmlName>
			<cfset customFieldXmlValue = customFieldXml.XmlRoot.XmlChildren[count].XmlText>
			<cfset customFieldRow = ListFind(ValueList(qry_selectCustomFieldListForTarget.customFieldName), customFieldXmlName)>
			<cfif customFieldRow is not 0>
				<cfset customFieldID = qry_selectCustomFieldListForTarget.customFieldID[customFieldRow]>
				<cfset Form["customField#customFieldID#"] = customFieldXmlValue>
			</cfif>
		</cfloop>

		<!--- determine which custom field values changed --->
		<cfset Form.updatedFormFieldList = "">
		<cfloop Query="qry_selectCustomFieldListForTarget">
			<cfset valueRow = ListFind(ValueList(qry_selectCustomFieldValueList.customFieldID), qry_selectCustomFieldListForTarget.customFieldID)>
			<cfif valueRow is 0 or Form["customField#qry_selectCustomFieldListForTarget.customFieldID#"] is not qry_selectCustomFieldListForTarget.customFieldValueValue[valueRow]>
				<cfset Form.updatedFormFieldList = ListAppend(Form.updatedFormFieldList, "customField#qry_selectCustomFieldListForTarget.customFieldID#")>
			</cfif>
		</cfloop>

		<cfinvoke Component="#Application.billingMapping#data.CustomFieldOption" Method="selectCustomFieldOptionList" ReturnVariable="qry_selectCustomFieldOptionList">
			<cfinvokeargument Name="customFieldID" Value="#ValueList(qry_selectCustomFieldListForTarget.customFieldID)#">
			<cfinvokeargument Name="customFieldOptionStatus" Value="1">
		</cfinvoke>

		<!--- 
		<cfset customFieldOptionID_struct = StructNew()>
		<cfset customFieldValue_struct = StructNew()>
		--->

		<cfinclude template="../../view/v_customField/lang_insertCustomFieldValues.cfm">
		<cfinvoke component="#Application.billingMapping#data.CustomFieldVarchar" method="maxlength_CustomFieldVarchar" returnVariable="maxlength_CustomFieldVarchar" />
		<cfinvoke component="#Application.billingMapping#data.CustomFieldDecimal" method="maxlength_CustomFieldDecimal" returnVariable="maxlength_CustomFieldDecimal" />
		<cfinclude template="../../control/c_customField/formValidate_insertCustomFieldValues.cfm">

		<cfif isAllFormFieldsOk is False>
			<cfset returnValue = False>
			<cfset returnError = "">
			<cfloop Collection="#errorMessage_fields#" Item="field">
				<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
			</cfloop>
		<cfelse>
			<cfloop Query="qry_selectCustomFieldListForTarget">
				<!--- if custom field is active and field is active for this target --->
				<cfif qry_selectCustomFieldListForTarget.customFieldStatus is 1 and qry_selectCustomFieldListForTarget.customFieldTargetStatus is 1
						and ListFind(Form.updatedFormFieldList, "customField#qry_selectCustomFieldListForTarget.customFieldID#")>
					<cfset thisCustomFieldID = qry_selectCustomFieldListForTarget.customFieldID>
					<cfset thisCustomFieldType = qry_selectCustomFieldListForTarget.customFieldType>
					<cfset thisCustomFormType = qry_selectCustomFieldListForTarget.customFieldFormType>

					<cfset formVariable = "customField#qry_selectCustomFieldListForTarget.customFieldID#">
					<cfset formValue = Form[formVariable]>

					<cfloop Index="count" From="1" To="#ListLen(customFieldOptionID_struct[formVariable])#">
						<cfset optionID = ListGetAt(customFieldOptionID_struct[formVariable], count)>
						<cfif ListFind("checkbox,selectMultiple", thisCustomFormType) and IsArray(customFieldValue_struct[formVariable])>
							<cfset fieldValue = customFieldValue_struct[formVariable][count]>
						<cfelse>
							<cfset fieldValue = customFieldValue_struct[formVariable]>
						</cfif>

						<cfinvoke Component="#Application.billingMapping#data.CustomFieldValue" Method="insertCustomFieldValue" ReturnVariable="isCustomFieldValueInserted">
							<cfinvokeargument Name="customFieldID" Value="#thisCustomFieldID#">
							<cfinvokeargument Name="userID" Value="#Arguments.userID_author#">
							<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID#">
							<cfinvokeargument Name="targetID" Value="#Arguments.targetID#">
							<cfinvokeargument Name="customFieldOptionID" Value="#optionID#">
							<cfinvokeargument Name="customFieldType" Value="#thisCustomFieldType#">
							<cfinvokeargument Name="customFieldValue" Value="#fieldValue#">
							<cfif count gt 1>
								<cfinvokeargument Name="updateCustomFieldStatus" Value="False">
							</cfif>
						</cfinvoke>
					</cfloop>
				</cfif>
			</cfloop>
		
			<cfset returnValue = True>
		</cfif><!--- /ok to insert custom field values --->
	</cfif><!--- /custom fields exist for target --->
</cfif><!--- /valid customField xml --->

