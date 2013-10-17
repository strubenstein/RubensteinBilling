<cfcomponent displayName="InsertCustomFieldValue" hint="Manages inserting and updating custom field values for a target">

<cfset This.customFieldOptionID_struct = StructNew()>
<cfset This.customFieldValue_struct = StructNew()>
<cfset This.isCustomFieldsExist = False>
<cfset This.primaryTargetID = 0>

<cffunction name="formParam_insertCustomFieldValue" access="public" output="no" returnType="boolean" hint="Sets initial form values for custom field values">
	<cfargument name="companyID" type="numeric" required="yes">
	<cfargument name="primaryTargetKey" type="string" required="yes">
	<cfargument name="targetID_formParam" type="numeric" required="yes">

	<cfset var customFieldTypeList = "">
	<cfset var thisValueValue = "">

	<cfset This.primaryTargetID = Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey)>
	<cfinclude Template="../../view/v_customField/var_customFieldTypeList.cfm">
	<cfinclude Template="../../view/v_customField/var_customFieldTargetList.cfm">

	<cfinvoke Component="#Application.billingMapping#data.CustomFieldTarget" Method="selectCustomFieldListForTarget" ReturnVariable="qry_selectCustomFieldListForTarget">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
		<cfinvokeargument Name="primaryTargetID" Value="#This.primaryTargetID#">
	</cfinvoke>

	<cfif qry_selectCustomFieldListForTarget.RecordCount is not 0>
		<cfset returnValue = True>
		<cfset This.isCustomFieldsExist = True>

		<cfloop Query="qry_selectCustomFieldListForTarget">
			<cfif Not ListFind(customFieldTypeList, qry_selectCustomFieldListForTarget.customFieldType)>
				<cfset customFieldTypeList = ListAppend(customFieldTypeList, qry_selectCustomFieldListForTarget.customFieldType)>
			</cfif>
		</cfloop>

		<!--- select existing values of custom fields for target --->
		<cfinvoke Component="#Application.billingMapping#data.CustomFieldValue" Method="selectCustomFieldValueList" ReturnVariable="qry_selectCustomFieldValueList">
			<cfinvokeargument Name="customFieldID" Value="#ValueList(qry_selectCustomFieldListForTarget.customFieldID)#">
			<cfinvokeargument Name="primaryTargetID" Value="#This.primaryTargetID#">
			<cfinvokeargument Name="targetID" Value="#Arguments.targetID_formParam#">
			<cfinvokeargument Name="customFieldValueStatus" Value="1">
			<cfinvokeargument Name="customFieldTypeList" Value="#customFieldTypeList#">
		</cfinvoke>

		<cfinvoke Component="#Application.billingMapping#data.CustomFieldOption" Method="selectCustomFieldOptionList" ReturnVariable="qry_selectCustomFieldOptionList">
			<cfinvokeargument Name="customFieldID" Value="#ValueList(qry_selectCustomFieldListForTarget.customFieldID)#">
			<cfinvokeargument Name="customFieldOptionStatus" Value="1">
		</cfinvoke>

		<cfif Not IsDefined("Form.isFormSubmitted")>
			<cfloop Query="qry_selectCustomFieldValueList">
				<cfset thisValueValue = ToString(qry_selectCustomFieldValueList.customFieldValueValue)>
				<cfif qry_selectCustomFieldValueList.customFieldValueType is "Decimal">
					<cfset thisValueValue = Application.fn_LimitPaddedDecimalZerosQuantity(thisValueValue)>
				</cfif>
		
				<cfif Not IsDefined("Form.customField#qry_selectCustomFieldValueList.customFieldID#")>
					<cfset Form["customField#qry_selectCustomFieldValueList.customFieldID#"] = thisValueValue>
				<cfelse>
					<cfset Form["customField#qry_selectCustomFieldValueList.customFieldID#"] = ListAppend(Form["customField#qry_selectCustomFieldValueList.customFieldID#"], thisValueValue)>
				</cfif>
			</cfloop>
		</cfif>

		<cfloop query="qry_selectCustomFieldListForTarget">
			<cfparam Name="Form.customField#qry_selectCustomFieldListForTarget.customFieldID#" Default="">
		</cfloop>

		<cfparam Name="Form.updatedFormFieldList" Default="">
	</cfif>

	<cfreturn This.isCustomFieldsExist>
</cffunction>

<cffunction name="formValidate_insertCustomFieldValue" access="public" output="no" returnType="struct" hint="Validates form values for custom field values">
	<cfset var errorMessageStruct = StructNew()>
	<cfset var methodStruct = StructNew()>

	<cfif This.isCustomFieldsExist is True>
		<cfinvoke component="#Application.billingMapping#data.CustomFieldValue" method="maxlength_CustomFieldVarchar" returnVariable="maxlength_CustomFieldVarchar" />
		<cfinvoke component="#Application.billingMapping#data.CustomFieldValue" method="maxlength_CustomFieldDecimal" returnVariable="maxlength_CustomFieldDecimal" />

		<cfinclude template="../../view/v_customField/lang_insertCustomFieldValues.cfm">

		<cfset methodStruct.counter = 0>
		<cfloop Query="qry_selectCustomFieldListForTarget">
			<cfif qry_selectCustomFieldListForTarget.customFieldStatus is 1 and qry_selectCustomFieldListForTarget.customFieldTargetStatus is 1>
				<cfset methodStruct.counter += 1>
				<cfset methodStruct.formVariable = "customField#qry_selectCustomFieldListForTarget.customFieldID#">
				<cfset methodStruct.formValue = Form[methodStruct.formVariable]>

				<cfswitch Expression="#qry_selectCustomFieldListForTarget.customFieldFormType#">
				<cfcase value="text,textarea">
					<cfset This.customFieldOptionID_struct[methodStruct.formVariable] = 0>
					<cfswitch Expression="#qry_selectCustomFieldListForTarget.customFieldType#">
					<cfcase value="Varchar">
						<cfif Len(methodStruct.formValue) gt maxlength_CustomFieldVarchar.customFieldVarcharValue>
							<cfset errorMessageStruct[methodStruct.formVariable] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertCustomFieldValues.customFieldVarcharValue_maxlength, "<<MAXLENGTH>>", maxlength_CustomFieldVarchar.customFieldVarcharValue, "ALL"), "<<LEN>>", Len(methodStruct.formValue), "ALL"), "<<COUNT>>", methodStruct.counter, "ALL")>
						<cfelse>
							<cfset This.customFieldValue_struct[methodStruct.formVariable] = methodStruct.formValue>
						</cfif>
					</cfcase>
					<cfcase value="Bit">
						<cfif methodStruct.formValue is "">
							<cfset This.customFieldValue_struct[methodStruct.formVariable] = "">
						<cfelseif Not ListFindNoCase("0,1,yes,no,y,n,t,f,true,false", methodStruct.formValue)>
							<cfset errorMessageStruct[methodStruct.formVariable] = ReplaceNoCase(Variables.lang_insertCustomFieldValues.customFieldBitValue_valid, "<<COUNT>>", methodStruct.counter, "ALL")>
						<cfelseif ListFindNoCase("1,yes,y,t,true", methodStruct.formValue)>
							<cfset This.customFieldValue_struct[methodStruct.formVariable] = 1>
						<cfelse>
							<cfset This.customFieldValue_struct[methodStruct.formVariable] = 0>
						</cfif>
					</cfcase>
					<cfcase value="Int">
						<cfif methodStruct.formValue is not "" and Not Application.fn_IsInteger(methodStruct.formValue)>
							<cfset errorMessageStruct[methodStruct.formVariable] = ReplaceNoCase(Variables.lang_insertCustomFieldValues.customFieldIntegerValue_valid, "<<COUNT>>", methodStruct.counter, "ALL")>
						<cfelse>
							<cfset This.customFieldValue_struct[methodStruct.formVariable] = methodStruct.formValue>
						</cfif>
					</cfcase>
					<cfcase value="Decimal">
						<cfif methodStruct.formValue is not "" and Not IsNumeric(methodStruct.formValue)>
							<cfset errorMessageStruct[methodStruct.formVariable] = ReplaceNoCase(Variables.lang_insertCustomFieldValues.customFieldDecimalValue_valid, "<<COUNT>>", methodStruct.counter, "ALL")>
						<cfelseif Find(".", methodStruct.formValue) and Len(ListLast(methodStruct.formValue, ".")) gt maxlength_CustomFieldDecimal.customFieldDecimalValue>
							<cfset errorMessageStruct[methodStruct.formVariable] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertCustomFieldValues.customFieldDecimalValue_maxlength, "<<MAXLENGTH>>", maxlength_CustomFieldDecimal.customFieldDecimalValue, "ALL"), "<<LEN>>", Len(ListLast(methodStruct.formValue, ".")), "ALL"), "<<COUNT>>", methodStruct.counter, "ALL")>
						<cfelse>
							<cfset This.customFieldValue_struct[methodStruct.formVariable] = methodStruct.formValue>
						</cfif>
					</cfcase>
					<cfcase value="DateTime">
						<cfif methodStruct.formValue is "">
							<cfset This.customFieldValue_struct[methodStruct.formVariable] = "">
						<cfelseif Not IsDate(methodStruct.formValue)>
							<cfset errorMessageStruct[methodStruct.formVariable] = ReplaceNoCase(Variables.lang_insertCustomFieldValues.customFieldDateTimeValue_valid, "<<COUNT>>", methodStruct.counter, "ALL")>
						<cfelse>
							<cfset This.customFieldValue_struct[methodStruct.formVariable] = CreateODBCDateTime(methodStruct.formValue)>
						</cfif>
					</cfcase>
					</cfswitch>
				</cfcase>

				<cfcase value="radio,select">
					<cfif methodStruct.formValue is "">
						<cfset This.customFieldOptionID_struct[methodStruct.formVariable] = 0>
						<cfset This.customFieldValue_struct[methodStruct.formVariable] = "">
					<cfelse>
						<cfset This.customFieldOptionID_struct[methodStruct.formVariable] = methodStruct.formValue>
						<cfset methodStruct.optionRow = ListFind(ValueList(qry_selectCustomFieldOptionList.customFieldOptionID), methodStruct.formValue)>
						<cfif methodStruct.optionRow is 0 or qry_selectCustomFieldOptionList.customFieldID[methodStruct.optionRow] is not qry_selectCustomFieldListForTarget.customFieldID>
							<cfset errorMessageStruct[methodStruct.formVariable] = ReplaceNoCase(Variables.lang_insertCustomFieldValues.customFieldOptionID_singleValid, "<<COUNT>>", methodStruct.counter, "ALL")>
						<cfelse>
							<cfset This.customFieldValue_struct[methodStruct.formVariable] = qry_selectCustomFieldOptionList.customFieldOptionValue[methodStruct.optionRow]>
						</cfif>
					</cfif>
				</cfcase>

				<cfcase value="checkbox,selectMultiple">
					<cfif methodStruct.formValue is "">
						<cfset This.customFieldOptionID_struct[methodStruct.formVariable] = 0>
						<cfset This.customFieldValue_struct[methodStruct.formVariable] = "">
					<cfelse>
						<cfset This.customFieldOptionID_struct[methodStruct.formVariable] = methodStruct.formValue>
						<cfloop Index="optionID" List="#methodStruct.formValue#">
							<cfset methodStruct.optionRow = ListFind(ValueList(qry_selectCustomFieldOptionList.customFieldOptionID), methodStruct.optionID)>
							<cfif methodStruct.optionRow is 0 or qry_selectCustomFieldOptionList.customFieldID[methodStruct.optionRow] is not qry_selectCustomFieldListForTarget.customFieldID>
								<cfset errorMessageStruct[methodStruct.formVariable] = ReplaceNoCase(Variables.lang_insertCustomFieldValues.customFieldOptionID_multipleValid, "<<COUNT>>", methodStruct.counter, "ALL")>
							<cfelse>
								<cfif Not StructKeyExists(This.customFieldValue_struct, methodStruct.formVariable)>
									<cfset This.customFieldValue_struct[methodStruct.formVariable] = ArrayNew(1)>
								</cfif>
								<cfset ArrayAppend(This.customFieldValue_struct[methodStruct.formVariable], qry_selectCustomFieldOptionList.customFieldOptionValue[methodStruct.optionRow])>
							</cfif>
						</cfloop>
					</cfif>
				</cfcase>
				</cfswitch>
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn errorMessageStruct>
</cffunction>

<cffunction name="formProcess_insertCustomFieldValue" access="public" output="no" returnType="boolean" hint="Inserts updated custom field values">
	<cfargument name="userID" type="numeric" required="yes">
	<cfargument name="targetID_formProcess" type="numeric" required="yes">

	<cfset var methodStruct = StructNew()>

	<cfif This.isCustomFieldsExist is True>
		<cfloop Query="qry_selectCustomFieldListForTarget">
			<!--- if custom field is active and field is active for this target --->
			<cfif qry_selectCustomFieldListForTarget.customFieldStatus is 1 and qry_selectCustomFieldListForTarget.customFieldTargetStatus is 1
					and ListFind(Form.updatedFormFieldList, "customField#qry_selectCustomFieldListForTarget.customFieldID#")>
				<cfset methodStruct.thisCustomFieldID = qry_selectCustomFieldListForTarget.customFieldID>
				<cfset methodStruct.thisCustomFieldType = qry_selectCustomFieldListForTarget.customFieldType>
				<cfset methodStruct.thisCustomFormType = qry_selectCustomFieldListForTarget.customFieldFormType>

				<cfset methodStruct.formVariable = "customField#qry_selectCustomFieldListForTarget.customFieldID#">
				<cfset methodStruct.formValue = Form[methodStruct.formVariable]>

				<cfloop Index="count" From="1" To="#ListLen(This.customFieldOptionID_struct[methodStruct.formVariable])#">
					<cfset methodStruct.optionID = ListGetAt(This.customFieldOptionID_struct[methodStruct.formVariable], count)>
					<cfif ListFind("checkbox,selectMultiple", methodStruct.thisCustomFormType) and IsArray(This.customFieldValue_struct[methodStruct.formVariable])>
						<cfset methodStruct.fieldValue = This.customFieldValue_struct[methodStruct.formVariable][count]>
					<cfelse>					
						<cfset methodStruct.fieldValue = This.customFieldValue_struct[methodStruct.formVariable]>
					</cfif>

					<cfinvoke Component="#Application.billingMapping#data.CustomFieldValue" Method="insertCustomFieldValue" ReturnVariable="isCustomFieldValueInserted">
						<cfinvokeargument Name="customFieldID" Value="#methodStruct.thisCustomFieldID#">
						<cfinvokeargument Name="userID" Value="#Arguments.userID#">
						<cfinvokeargument Name="primaryTargetID" Value="#This.primaryTargetID#">
						<cfinvokeargument Name="targetID" Value="#Arguments.targetID_formProcess#">
						<cfinvokeargument Name="customFieldOptionID" Value="#methodStruct.optionID#">
						<cfinvokeargument Name="customFieldType" Value="#methodStruct.thisCustomFieldType#">
						<cfinvokeargument Name="customFieldValue" Value="#methodStruct.fieldValue#">
						<cfif count gt 1>
							<cfinvokeargument Name="updateCustomFieldStatus" Value="False">
						</cfif>
					</cfinvoke>
				</cfloop>
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn True>
</cffunction>

<cffunction name="form_insertCustomFieldValue" access="public" output="yes" returnType="boolean" hint="Displays form for updating custom field values">
	<cfset var methodStruct = StructNew()>

	<cfif This.isCustomFieldsExist is True>
		<cfinclude template="../../view/v_customField/form_insertCustomFieldValue.cfm">
	</cfif>

	<cfreturn True>
</cffunction>

</cfcomponent>