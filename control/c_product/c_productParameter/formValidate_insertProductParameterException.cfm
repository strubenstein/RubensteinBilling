<cfset errorMessage_fields = StructNew()>

<cfif Len(Form.productParameterExceptionDescription) gt maxlength_ProductParameterException.productParameterExceptionDescription>
	<cfset errorMessage_fields.productParameterExceptionDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertProductParameterException.productParameterExceptionDescription_maxlength, "<<MAXLENGTH>>", maxlength_ProductParameterException.productParameterExceptionDescription, "ALL"), "<<LEN>>", Len(Form.productParameterExceptionDescription), "ALL")>
</cfif>

<!--- list of options that trigger the exception --->
<cfset Variables.productParameterOptionID = "">
<!--- list of parameters represented to avoid a parameter having more than one option --->
<cfset Variables.productParameterID = "">

<cfloop Index="parameterOptionID" List="#Form.productParameterOptionID#">
	<cfif parameterOptionID is not "" and parameterOptionID is not 0>
		<cfset Variables.parameterOptionRow = ListFind(ValueList(qry_selectProductParameterOptionList.productParameterOptionID), parameterOptionID)>
		<cfif Variables.parameterOptionRow is 0>
			<cfset errorMessage_fields.productParameterOptionID_invalid = Variables.lang_insertProductParameterException.productParameterOptionID_invalid>
		<cfelseif ListFind(Variables.productParameterOptionID, parameterOptionID)>
			<cfset errorMessage_fields.productParameterOptionID_repeat = Variables.lang_insertProductParameterException.productParameterOptionID_repeat>
		<cfelseif ListFind(Variables.productParameterID, qry_selectProductParameterOptionList.productParameterID[Variables.parameterOptionRow])>
			<cfset errorMessage_fields.productParameterOptionID_multiple = Variables.lang_insertProductParameterException.productParameterOptionID_multiple>
		<cfelse>
			<cfset Variables.productParameterOptionID = ListAppend(Variables.productParameterOptionID, parameterOptionID)>
			<cfset Variables.productParameterID = ListAppend(Variables.productParameterID, qry_selectProductParameterOptionList.productParameterID[Variables.parameterOptionRow])>
		</cfif>
	</cfif>
</cfloop>

<cfif ListLen(Variables.productParameterOptionID) is 0>
	<cfset errorMessage_fields.productParameterOptionID_zero = Variables.lang_insertProductParameterException.productParameterOptionID_zero>
<cfelseif ListLen(Variables.productParameterOptionID) gt 4>
	<cfset errorMessage_fields.productParameterOptionID_maximum = Variables.lang_insertProductParameterException.productParameterOptionID_maximum>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.ProductParameterException" Method="checkProductParameterExceptionIsUnique" ReturnVariable="isProductParameterExceptionUnique">
		<cfinvokeargument Name="productID" Value="#URL.productID#">
		<cfinvokeargument Name="productParameterOptionID_list" Value="#Variables.productParameterOptionID#">
		<cfif URL.productParameterExceptionID is not 0>
			<cfinvokeargument Name="productParameterExceptionID" Value="#URL.productParameterExceptionID#">
		</cfif>
	</cfinvoke>

	<cfif isProductParameterExceptionUnique is False>
		<cfset errorMessage_fields.productParameterOptionID_unique = Variables.lang_insertProductParameterException.productParameterOptionID_unique>
	</cfif>
</cfif>

<cfif Not ListFind("0,1", Form.productParameterExceptionExcluded)>
	<cfset errorMessage_fields.productParameterExceptionExcluded = Variables.lang_insertProductParameterException.productParameterExceptionExcluded_valid>
<cfelseif Form.productParameterExceptionExcluded is 1 and ListLen(Variables.productParameterOptionID) is 1>
	<cfset errorMessage_fields.productParameterExceptionExcluded = Variables.lang_insertProductParameterException.productParameterExceptionExcluded_count>
</cfif>

<cfif Form.productParameterExceptionPricePremium is not "">
	<cfif Form.productParameterExceptionExcluded is 1><!--- cannot also check excluded option --->
		<cfset errorMessage_fields.productParameterExceptionPricePremium = Variables.lang_insertProductParameterException.productParameterExceptionPricePremium_excluded>
	<cfelseif Form.productParameterExceptionPricePremium is 0>
		<cfset errorMessage_fields.productParameterExceptionPricePremium = Variables.lang_insertProductParameterException.productParameterExceptionPricePremium_zero>
	<cfelseif Not IsNumeric(Form.productParameterExceptionPricePremium)><!--- not a number --->
		<cfset errorMessage_fields.productParameterExceptionPricePremium = Variables.lang_insertProductParameterException.productParameterExceptionPricePremium_numeric>
	<cfelseif Len(ListLast(Form.productParameterExceptionPricePremium, ".")) gt maxlength_ProductParameterException.productParameterExceptionPricePremium>
		<cfset errorMessage_fields.productParameterExceptionPricePremium = ReplaceNoCase(Variables.lang_insertProductParameterException.productParameterExceptionPricePremium_decimal, "<<MAXLENGTH>>", maxlength_ProductParameterException.productParameterExceptionPricePremium, "ALL")>
	</cfif>
</cfif>

<cfif Len(Form.productParameterExceptionText) gt maxlength_ProductParameterException.productParameterExceptionText>
	<cfset errorMessage_fields.productParameterExceptionText = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertProductParameterException.productParameterExceptionText_maxlength, "<<MAXLENGTH>>", maxlength_ProductParameterException.productParameterExceptionText, "ALL"), "<<LEN>>", Len(Form.productParameterExceptionText), "ALL")>
<cfelseif Trim(Form.productParameterExceptionText) is "" and Form.productParameterExceptionExcluded is 0 and Form.productParameterExceptionPricePremium is "">
	<cfset errorMessage_fields.productParameterExceptionText = Variables.lang_insertProductParameterException.productParameterExceptionText_noResult>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertProductParameter">
		<cfset errorMessage_title = Variables.lang_insertProductParameterException.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertProductParameterException.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertProductParameterException.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertProductParameterException.errorFooter>
</cfif>
