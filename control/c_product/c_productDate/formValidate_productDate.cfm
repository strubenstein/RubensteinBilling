<cfset errorMessage_fields = StructNew()>

<cfset Form.productDateBegin = "">
<cfset Variables.dateBeginResponse = fn_FormValidateDateTime("begin", "productDateBegin_date", Form.productDateBegin_date, "productDateBegin_hh", Form.productDateBegin_hh, "productDateBegin_mm", Form.productDateBegin_mm, "productDateBegin_tt", Form.productDateBegin_tt)>
<cfif IsDate(Variables.dateBeginResponse)>
	<cfset Form.productDateBegin = Variables.dateBeginResponse>
<cfelse><!--- IsStruct(Variables.dateBeginResponse) --->
	<cfloop Collection="#Variables.dateBeginResponse#" Item="field">
		<cfset errorMessage_fields["#field#"] = StructFind(Variables.dateBeginResponse, field)>
	</cfloop>
</cfif>

<cfset Form.productDateEnd = "">
<cfset Variables.dateEndResponse = fn_FormValidateDateTime("end", "productDateEnd_date", Form.productDateEnd_date, "productDateEnd_hh", Form.productDateEnd_hh, "productDateEnd_mm", Form.productDateEnd_mm, "productDateEnd_tt", Form.productDateEnd_tt)>
<cfif IsDate(Variables.dateEndResponse)>
	<cfset Form.productDateEnd = Variables.dateEndResponse>
<cfelse><!--- IsStruct(Variables.dateEndResponse) --->
	<cfloop Collection="#Variables.dateEndResponse#" Item="field">
		<cfset errorMessage_fields["#field#"] = StructFind(Variables.dateEndResponse, field)>
	</cfloop>
</cfif>

<!--- check that end begin date/time is before end date/time --->
<cfif StructIsEmpty(errorMessage_fields) and IsDate(Form.productDateEnd_date) and DateCompare(Form.productDateBegin, Form.productDateEnd) is not -1>
	<cfset errorMessage_fields.productDateEnd = Variables.lang_productDate.productDateEnd>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<!--- 
	Check that begin/end time do not conflict with other begin/end time combinations
	If existing end time is blank:
		if new end time is blank, there should only be one date entry
		if new end time is not blank, new end should be before existing begin
	--->
	<cfloop Query="qry_selectProductDateList">
		<cfif URL.productDateID is not qry_selectProductDateList.productDateID>
			<cfif Not IsDate(qry_selectProductDateList.productDateEnd)>
				<cfif Not IsDate(Form.productDateEnd_date)>
					<cfset errorMessage_fields.productDate = Variables.lang_productDate.productDate_twoNoEnd>
				<cfelseif Form.productDateEnd_date gte qry_selectProductDateList.productDateBegin>
					<cfset errorMessage_fields.productDate = Variables.lang_productDate.productDate_beginAfterEnd>
				</cfif>
			<!--- new begin time between existing begin/end --->
			<cfelseif Form.productDateBegin gte qry_selectProductDateList.productDateBegin and Form.productDateBegin lte qry_selectProductDateList.productDateEnd>
				<cfset errorMessage_fields.productDate = Variables.lang_productDate.productDate_beginWithin>
			<!--- new end time between existing begin/end --->
			<cfelseif IsDate(Form.productDateEnd_date) and Form.productDateEnd gte qry_selectProductDateList.productDateBegin and Form.productDateEnd lte qry_selectProductDateList.productDateEnd>
				<cfset errorMessage_fields.productDate = Variables.lang_productDate.productDate_endWithin>
			<!--- new begin time before existing begin and new end after existing begin date --->
			<cfelseif IsDate(Form.productDateEnd_date) and Form.productDateBegin lt qry_selectProductDateList.productDateBegin and Form.productDateEnd gt qry_selectProductDateList.productDateEnd>
				<cfset errorMessage_fields.productDate = Variables.lang_productDate.productDate_span>
			</cfif>
		</cfif>
	</cfloop>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfif Form.productDateBegin gt Now()>
		<cfset Form.productDateStatus = 0>
	<cfelseif Not IsDate(Form.productDateEnd)>
		<cfset Form.productDateStatus = 1>
	<cfelseif Form.productDateEnd gt Now()>
		<cfset Form.productDateStatus = 1>
	<cfelse>
		<cfset Form.productDateStatus = 0>
	</cfif>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertProductDate">
		<cfset errorMessage_title = Variables.lang_productDate.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_productDate.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_productDate.errorHeader>
	<cfset errorMessage_footer = Variables.lang_productDate.errorFooter>
</cfif>

