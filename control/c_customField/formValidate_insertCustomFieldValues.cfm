<!--- only create structure if not called via object validation --->
<cfif Not IsDefined("errorMessage_fields") or Not IsStruct(errorMessage_fields)>
	<cfset errorMessage_fields = StructNew()>
</cfif>

<!--- 
VALIDATION:
text/textarea
	maximum length 
	field type is valid (boolean,integer,decimal,date)
	decimal - decimal places
radio/checkbox/select(multiple) - all options exist for that field
--->

<cfset counter = 0>
<cfloop Query="qry_selectCustomFieldListForTarget">
	<cfif qry_selectCustomFieldListForTarget.customFieldStatus is 1 and qry_selectCustomFieldListForTarget.customFieldTargetStatus is 1>
		<cfset counter = counter + 1>
		<cfset formVariable = "customField#qry_selectCustomFieldListForTarget.customFieldID#">
		<cfset formValue = Form[formVariable]>

		<cfswitch expression="#qry_selectCustomFieldListForTarget.customFieldFormType#">
		<cfcase value="text,textarea">
			<cfset customFieldOptionID_struct[formVariable] = 0>
			<cfswitch expression="#qry_selectCustomFieldListForTarget.customFieldType#">
			<cfcase value="Varchar">
				<cfif Len(formValue) gt maxlength_CustomFieldVarchar.customFieldVarcharValue>
					<cfset errorMessage_fields[formVariable] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertCustomFieldValues.customFieldVarcharValue_maxlength, "<<MAXLENGTH>>", maxlength_CustomFieldVarchar.customFieldVarcharValue, "ALL"), "<<LEN>>", Len(formValue), "ALL"), "<<COUNT>>", counter, "ALL")>
				<cfelse>
					<cfset customFieldValue_struct[formVariable] = formValue>
				</cfif>
			</cfcase>
			<cfcase value="Bit">
				<cfif formValue is "">
					<cfset customFieldValue_struct[formVariable] = "">
				<cfelseif Not ListFindNoCase("0,1,yes,no,y,n,t,f,true,false", formValue)>
					<cfset errorMessage_fields[formVariable] = ReplaceNoCase(Variables.lang_insertCustomFieldValues.customFieldBitValue_valid, "<<COUNT>>", counter, "ALL")>
				<cfelseif ListFindNoCase("1,yes,y,t,true", formValue)>
					<cfset customFieldValue_struct[formVariable] = 1>
				<cfelse>
					<cfset customFieldValue_struct[formVariable] = 0>
				</cfif>
			</cfcase>
			<cfcase value="Int">
				<cfif formValue is not "" and Not Application.fn_IsInteger(formValue)>
					<cfset errorMessage_fields[formVariable] = ReplaceNoCase(Variables.lang_insertCustomFieldValues.customFieldIntegerValue_valid, "<<COUNT>>", counter, "ALL")>
				<cfelse>
					<cfset customFieldValue_struct[formVariable] = formValue>
				</cfif>
			</cfcase>
			<cfcase value="Decimal">
				<cfif formValue is not "" and Not IsNumeric(formValue)>
					<cfset errorMessage_fields[formVariable] = ReplaceNoCase(Variables.lang_insertCustomFieldValues.customFieldDecimalValue_valid, "<<COUNT>>", counter, "ALL")>
				<cfelseif Find(".", formValue) and Len(ListLast(formValue, ".")) gt maxlength_CustomFieldDecimal.customFieldDecimalValue>
					<cfset errorMessage_fields[formVariable] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertCustomFieldValues.customFieldDecimalValue_maxlength, "<<MAXLENGTH>>", maxlength_CustomFieldDecimal.customFieldDecimalValue, "ALL"), "<<LEN>>", Len(ListLast(formValue, ".")), "ALL"), "<<COUNT>>", counter, "ALL")>
				<cfelse>
					<cfset customFieldValue_struct[formVariable] = formValue>
				</cfif>
			</cfcase>
			<cfcase value="DateTime">
				<cfif formValue is "">
					<cfset customFieldValue_struct[formVariable] = "">
				<cfelseif Not IsDate(formValue)>
					<cfset errorMessage_fields[formVariable] = ReplaceNoCase(Variables.lang_insertCustomFieldValues.customFieldDateTimeValue_valid, "<<COUNT>>", counter, "ALL")>
				<cfelse>
					<cfset customFieldValue_struct[formVariable] = CreateODBCDateTime(formValue)>
				</cfif>
			</cfcase>
			</cfswitch>
		</cfcase>

		<cfcase value="radio,select">
			<cfif formValue is "">
				<cfset customFieldOptionID_struct[formVariable] = 0>
				<cfset customFieldValue_struct[formVariable] = "">
			<cfelse>
				<cfset customFieldOptionID_struct[formVariable] = formValue>
				<cfset optionRow = ListFind(ValueList(qry_selectCustomFieldOptionList.customFieldOptionID), formValue)>
				<cfif optionRow is 0 or qry_selectCustomFieldOptionList.customFieldID[optionRow] is not qry_selectCustomFieldListForTarget.customFieldID>
					<cfset errorMessage_fields[formVariable] = ReplaceNoCase(Variables.lang_insertCustomFieldValues.customFieldOptionID_singleValid, "<<COUNT>>", counter, "ALL")>
				<cfelse>
					<cfset customFieldValue_struct[formVariable] = qry_selectCustomFieldOptionList.customFieldOptionValue[optionRow]>
				</cfif>
			</cfif>
		</cfcase>

		<cfcase value="checkbox,selectMultiple">
			<cfif formValue is "">
				<cfset customFieldOptionID_struct[formVariable] = 0>
				<cfset customFieldValue_struct[formVariable] = "">
			<cfelse>
				<cfset customFieldOptionID_struct[formVariable] = formValue>
				<cfloop Index="optionID" List="#formValue#">
					<cfset optionRow = ListFind(ValueList(qry_selectCustomFieldOptionList.customFieldOptionID), optionID)>
					<cfif optionRow is 0 or qry_selectCustomFieldOptionList.customFieldID[optionRow] is not qry_selectCustomFieldListForTarget.customFieldID>
						<cfset errorMessage_fields[formVariable] = ReplaceNoCase(Variables.lang_insertCustomFieldValues.customFieldOptionID_multipleValid, "<<COUNT>>", counter, "ALL")>
					<cfelse>
						<cfif Not StructKeyExists(customFieldValue_struct, formVariable)>
							<cfset customFieldValue_struct[formVariable] = ArrayNew(1)>
						</cfif>
						<cfset temp = ArrayAppend(customFieldValue_struct[formVariable], qry_selectCustomFieldOptionList.customFieldOptionValue[optionRow])>
					</cfif>
				</cfloop>
			</cfif>
		</cfcase>
		</cfswitch>
	</cfif>
</cfloop>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<!--- 
	<cfif Variables.formAction is not "">
		<cfset errorMessage_title = Variables.lang_insertCustomFieldValues.errorTitle>
		<cfset errorMessage_header = Variables.lang_insertCustomFieldValues.errorHeader>
		<cfset errorMessage_footer = Variables.lang_insertCustomFieldValues.errorFooter>
	</cfif>
	--->
</cfif>

