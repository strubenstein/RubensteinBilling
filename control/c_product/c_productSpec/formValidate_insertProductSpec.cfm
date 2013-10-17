<cfset errorMessage_fields = StructNew()>

<cfif Not Application.fn_IsIntegerPositive(Form.productSpecCount)>
	<cfset errorMessage_fields.productSpecCount = Variables.lang_insertProductSpec.productSpecCount>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.productSpecCount_orig)>
	<cfset errorMessage_fields.productSpecCount_orig = Variables.lang_insertProductSpec.productSpecCount_orig>
<cfelse>
	<cfset Variables.specNameList = "">
	<cfloop Index="count" From="1" To="#Form.productSpecCount_orig#">
		<cfif Not ListFind("0,1", Form["productSpecHasImage#count#"])>
			<cfset errorMessage_fields["productSpecHasImage#count#"] = Replace(Variables.lang_insertProductSpec.productSpecHasImage, "<<COUNT>>", count, "ALL")>
		</cfif>

		<cfif Len(Form["productSpecValue#count#"]) gt maxlength_ProductSpec.productSpecValue>
			<cfset errorMessage_fields["productSpecValue#count#"] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertProductSpec.productSpecValue, "<<MAXLENGTH>>", maxlength_ProductSpec.productSpecValue, "ALL"), "<<LEN>>", Len(Form.productSpecValue), "ALL"), "<<COUNT>>", count, "ALL")>
		</cfif>

		<cfset Form["productSpecName#count#"] = "">
		<cfif Form["productSpecName_text#count#"] is not "">
			<cfset Form["productSpecName#count#"] = Form["productSpecName_text#count#"]>
		<cfelseif Form["productSpecName_select#count#"] is not "">
			<cfset Form["productSpecName#count#"] = Form["productSpecName_select#count#"]>
		</cfif>

		<cfif Len(Form["productSpecName#count#"]) gt maxlength_ProductSpec.productSpecName>
			<cfset errorMessage_fields["productSpecName#count#"] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertProductSpec.productSpecName_maxlength, "<<MAXLENGTH>>", maxlength_ProductSpec.productSpecName, "ALL"), "<<LEN>>", Len(Form.productSpecName), "ALL"), "<<COUNT>>", count, "ALL")>
		<cfelseif Form["productSpecName#count#"] is not "">
			<cfif ListFind(Variables.specNameList, Form["productSpecName#count#"])>
				<cfset errorMessage_fields["productSpecName#count#"] = Replace(Variables.lang_insertProductSpec.productSpecName_unique, "<<COUNT>>", count, "ALL")>
			<cfelse>
				<cfset Variables.specNameList = ListAppend(Variables.specNameList, Form["productSpecName#count#"])>
			</cfif>
		</cfif>
	</cfloop>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_insertProductSpec.errorTitle>
	<cfset errorMessage_header = Variables.lang_insertProductSpec.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertProductSpec.errorFooter>
</cfif>

