<cfoutput>
<div class="MainText"><b><i>Custom Fields</i>:</b></div>
<input type="hidden" name="updatedFormFieldList" value="#Form.updatedFormFieldList#" onChange="this.value=this.form.name.value;">
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfloop Query="qry_selectCustomFieldListForTarget">
	<!--- if custom field is active and field is active for this target --->
	<cfif qry_selectCustomFieldListForTarget.customFieldStatus is 1 and qry_selectCustomFieldListForTarget.customFieldTargetStatus is 1>
		<cfset methodStruct.formVariable = "customField#qry_selectCustomFieldListForTarget.customFieldID#">
		<cfset methodStruct.valueRow = ListFind(ValueList(qry_selectCustomFieldValueList.customFieldID), qry_selectCustomFieldListForTarget.customFieldID)>
		<cfset methodStruct.optionRowBegin = ListFind(ValueList(qry_selectCustomFieldOptionList.customFieldID), qry_selectCustomFieldListForTarget.customFieldID)>
		<cfset methodStruct.typeRow = ListFind(Variables.customFieldTypeList_value, qry_selectCustomFieldListForTarget.customFieldType, "^")>

		<tr valign="top">
			<td align="right">#qry_selectCustomFieldListForTarget.customFieldTitle#: &nbsp;</td>
			<td>
			<cfswitch Expression="#qry_selectCustomFieldListForTarget.customFieldFormType#">
			<cfcase value="text">
				<input type="text" name="#methodStruct.formVariable#" size="40" onChange="this.form.updatedFormFieldList.value=this.name + ',' + this.form.updatedFormFieldList.value;" value="#HTMLEditFormat(Form[methodStruct.formVariable])#">
				<cfif methodStruct.typeRow is 0>(#qry_selectCustomFieldList.customFieldType#)<cfelse>(#ListGetAt(Variables.customFieldTypeList_label, methodStruct.typeRow, "^")#)</cfif>
			</cfcase>
			<cfcase value="textarea">
				<textarea name="#methodStruct.formVariable#" rows="5" cols="60" wrap="soft" onChange="this.form.updatedFormFieldList.value=this.name + ',' + this.form.updatedFormFieldList.value;">#HTMLEditFormat(Form[methodStruct.formVariable])#</textarea><br>
				<cfif methodStruct.typeRow is 0>(#qry_selectCustomFieldList.customFieldType#)<cfelse>(#ListGetAt(Variables.customFieldTypeList_label, methodStruct.typeRow, "^")#)</cfif>
			</cfcase>
			<cfcase value="radio,checkbox">
				<cfif methodStruct.optionRowBegin is 0>
					(no options specified)
				<cfelse>
					<cfset methodStruct.thisCustomFieldID = qry_selectCustomFieldListForTarget.customFieldID>
					<cfset methodStruct.thisCustomFieldFormType = qry_selectCustomFieldListForTarget.customFieldFormType>

					<cfloop Query="qry_selectCustomFieldOptionList" StartRow="#methodStruct.optionRowBegin#">
						<cfif qry_selectCustomFieldOptionList.customFieldID is not methodStruct.thisCustomFieldID><cfbreak></cfif>
						<input type="#methodStruct.thisCustomFieldFormType#" name="#methodStruct.formVariable#" value="#qry_selectCustomFieldOptionList.customFieldOptionID#" onChange="this.form.updatedFormFieldList.value=this.name + ',' + this.form.updatedFormFieldList.value;"<cfif ListFind(Form[methodStruct.formVariable], qry_selectCustomFieldOptionList.customFieldOptionID) or (Not IsDefined("Form.isFormSubmitted") and ListFind(Form[methodStruct.formVariable], qry_selectCustomFieldOptionList.customFieldOptionValue))> checked</cfif>>#qry_selectCustomFieldOptionList.customFieldOptionLabel#<br>
					</cfloop>
				</cfif>
			</cfcase>
			<cfcase value="select,selectMultiple">
				<select name="#methodStruct.formVariable#" onChange="this.form.updatedFormFieldList.value=this.name + ',' + this.form.updatedFormFieldList.value;"<cfif qry_selectCustomFieldListForTarget.customFieldFormType is "select"> size="1"<cfelse>size="#Min(6, methodStruct.optionRowCount)#" multiple</cfif>>
				<cfif methodStruct.optionRowBegin is 0>
					<option value="">-- NO OPTIONS --</option>
				<cfelse>
					<cfset methodStruct.thisCustomFieldID = qry_selectCustomFieldListForTarget.customFieldID>
					<cfset methodStruct.optionRowCount = ListValueCount(ValueList(qry_selectCustomFieldOptionList.customFieldID), qry_selectCustomFieldListForTarget.customFieldID)>
					<cfset methodStruct.optionRowEnd = methodStruct.optionRowBegin + methodStruct.optionRowCount - 1>
					<option value="">-- SELECT --</option>
					<cfloop Query="qry_selectCustomFieldOptionList" StartRow="#methodStruct.optionRowBegin#" EndRow="#methodStruct.optionRowEnd#">
						<cfif qry_selectCustomFieldOptionList.customFieldID is not methodStruct.thisCustomFieldID><cfbreak></cfif>
						<option value="#qry_selectCustomFieldOptionList.customFieldOptionID#"<cfif ListFind(Form[methodStruct.formVariable], qry_selectCustomFieldOptionList.customFieldOptionID) or (Not IsDefined("Form.isFormSubmitted") and ListFind(Form[methodStruct.formVariable],  qry_selectCustomFieldOptionList.customFieldOptionValue))> selected</cfif>>#HTMLEditFormat(qry_selectCustomFieldOptionList.customFieldOptionLabel)#</option>
					</cfloop>
				</cfif>
				</select>
			</cfcase>
			</cfswitch>
			</td>
		</tr>
	</cfif>
</cfloop>
</table>
</cfoutput>