<cfset errorMessage_fields = StructNew()>

<cfloop Index="field" List="productParameterStatus,productParameterRequired,productParameterCodeStatus,productParameterExportXml,productParameterExportTab,productParameterExportHtml">
	<cfif Not ListFind("0,1", Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_insertUpdateProductParameter[field]>
	</cfif>
</cfloop>

<cfif Trim(Form.productParameterName) is "">
	<cfset errorMessage_fields.productParameterName = Variables.lang_insertUpdateProductParameter.productParameterName_blank>
<cfelseif Len(Form.productParameterName) gt maxlength_ProductParameter.productParameterName>
	<cfset errorMessage_fields.productParameterName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateProductParameter.productParameterName_maxlength, "<<MAXLENGTH>>", maxlength_ProductParameter.productParameterName, "ALL"), "<<LEN>>", Len(Form.productParameterName), "ALL")>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.ProductParameter" Method="checkProductParameterNameIsUnique" ReturnVariable="isProductParameterNameUnique">
		<cfinvokeargument Name="productID" Value="#URL.productID#">
		<cfinvokeargument Name="productParameterName" Value="#Form.productParameterName#">
		<cfinvokeargument Name="productParameterID" Value="#URL.productParameterID#">
	</cfinvoke>

	<cfif isProductParameterNameUnique is False>
		<cfset errorMessage_fields.productParameterName = Variables.lang_insertUpdateProductParameter.productParameterName_unique>
	</cfif>
</cfif>

<cfif Trim(Form.productParameterText) is "">
	<cfset errorMessage_fields.productParameterText = Variables.lang_insertUpdateProductParameter.productParameterText_blank>
<cfelseif Len(Form.productParameterText) gt maxlength_ProductParameter.productParameterText>
	<cfset errorMessage_fields.productParameterText = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateProductParameter.productParameterText_maxlength, "<<MAXLENGTH>>", maxlength_ProductParameter.productParameterText, "ALL"), "<<LEN>>", Len(Form.productParameterText), "ALL")>
</cfif>

<cfif Len(Form.productParameterDescription) gt maxlength_ProductParameter.productParameterDescription>
	<cfset errorMessage_fields.productParameterDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateProductParameter.productParameterDescription_maxlength, "<<MAXLENGTH>>", maxlength_ProductParameter.productParameterDescription, "ALL"), "<<LEN>>", Len(Form.productParameterDescription), "ALL")>
</cfif>

<cfif Not Application.fn_IsIntegerNonNegative(Form.productParameterOrder) or Form.productParameterOrder gt qry_selectProductParameterList.RecordCount>
	<cfset errorMessage_fields.productParameterOrder = Variables.lang_insertUpdateProductParameter.productParameterOrder>
</cfif>

<cfif Not Application.fn_IsIntegerNonNegative(Form.productParameterCodeOrder) or Form.productParameterCodeOrder gt qry_selectProductParameterList.RecordCount>
	<cfset errorMessage_fields.productParameterCodeOrder = Variables.lang_insertUpdateProductParameter.productParameterCodeOrder>
</cfif>

<cfif Form.productParameterImage is not "" and Not fn_IsValidImageURL(Form.productParameterImage)>
	<cfset errorMessage_fields.productParameterImage = Variables.lang_insertUpdateProductParameter.productParameterImage_valid>
<cfelseif Len(Form.productParameterImage) gt maxlength_ProductParameter.productParameterImage>
	<cfset errorMessage_fields.productParameterImage = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateProductParameter.productParameterImage_maxlength, "<<MAXLENGTH>>", maxlength_ProductParameter.productParameterImage, "ALL"), "<<LEN>>", Len(Form.productParameterImage), "ALL")>
</cfif>

<!--- must have at least one option --->
<cfif Trim(Form.productParameterOptionLabel1) is "" and Trim(Form.productParameterOptionLabel2) is "">
	<cfset errorMessage_fields.productParameterOptionLabel = Variables.lang_insertUpdateProductParameter.productParameterOptionLabel>
<cfelse>
	<cfset Variables.productParameterOptionCount = 0>
	<cfloop Index="count" From="1" To="#Form.productParameterOptionCount#">
		<cfif Trim(Form["productParameterOptionLabel#count#"]) is "" and count gt 1>
			<cfbreak>
		<cfelse>
			<cfset Variables.productParameterOptionCount = Variables.productParameterOptionCount + 1>
			<cfif Len(Form["productParameterOptionLabel#count#"]) gt maxlength_ProductParameterOption.productParameterOptionLabel>
				<cfset errorMessage_fields["productParameterOptionLabel#count#"] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateProductParameter.productParameterOptionLabel_maxlength, "<<MAXLENGTH>>", maxlength_ProductParameterOption.productParameterOptionLabel, "ALL"), "<<LEN>>", Len(Form["productParameterOptionLabel#count#"]), "ALL"), "<<COUNT>>", count, "ALL")>
			</cfif>
			<cfif Len(Form["productParameterOptionValue#count#"]) gt maxlength_ProductParameterOption.productParameterOptionValue>
				<cfset errorMessage_fields["productParameterOptionValue#count#"] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateProductParameter.productParameterOptionValue_maxlength, "<<MAXLENGTH>>", maxlength_ProductParameterOption.productParameterOptionValue, "ALL"), "<<LEN>>", Len(Form["productParameterOptionValue#count#"]), "ALL"), "<<COUNT>>", count, "ALL")>
			</cfif>
			<cfif Len(Form["productParameterOptionCode#count#"]) gt maxlength_ProductParameterOption.productParameterOptionCode>
				<cfset errorMessage_fields["productParameterOptionCode#count#"] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateProductParameter.productParameterOptionCode_maxlength, "<<MAXLENGTH>>", maxlength_ProductParameterOption.productParameterOptionCode, "ALL"), "<<LEN>>", Len(Form["productParameterOptionCode#count#"]), "ALL"), "<<COUNT>>", count, "ALL")>
			</cfif>
			<cfif Trim(Form["productParameterOptionImage#count#"]) is not "" and Not fn_IsValidImageURL(Form["productParameterOptionImage#count#"])>
				<cfset errorMessage_fields["productParameterOptionImage#count#"] = ReplaceNoCase(Variables.lang_insertUpdateProductParameter.productParameterOptionImage_valid, "<<COUNT>>", count, "ALL")>
			<cfelseif Len(Form["productParameterOptionImage#count#"]) gt maxlength_ProductParameterOption.productParameterOptionImage>
				<cfset errorMessage_fields["productParameterOptionImage#count#"] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateProductParameter.productParameterOptionImage_maxlength, "<<MAXLENGTH>>", maxlength_ProductParameterOption.productParameterOptionImage, "ALL"), "<<LEN>>", Len(Form["productParameterOptionImage#count#"]), "ALL"), "<<COUNT>>", count, "ALL")>
			</cfif>
		</cfif>
	</cfloop>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertProductParameter">
		<cfset errorMessage_title = Variables.lang_insertUpdateProductParameter.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdateProductParameter.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateProductParameter.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateProductParameter.errorFooter>
</cfif>
