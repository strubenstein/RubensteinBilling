<cfset errorMessage_fields = StructNew()>

<cfif Not ListFind("0,1", Form.IPaddressBrowser)>
	<cfset errorMessage_fields.IPaddressBrowser = Variables.lang_insertUpdateIPaddress.IPaddressBrowser>
</cfif>

<cfif Not ListFind("0,1", Form.IPaddressWebService)>
	<cfset errorMessage_fields.IPaddressWebService = Variables.lang_insertUpdateIPaddress.IPaddressWebService>
</cfif>

<cfif Trim(Form.IPaddress) is "">
	<cfset errorMessage_fields.IPaddress = Variables.lang_insertUpdateIPaddress.IPaddress_blank>
<cfelseif Len(Form.IPaddress) gt maxlength_IPaddress.IPaddress>
	<cfset errorMessage_fields.IPaddress = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateIPaddress.IPaddress_maxlength, "<<MAXLENGTH>>", maxlength_IPaddress.IPaddress, "ALL"), "<<LEN>>", Len(Form.IPaddress), "ALL")>
<cfelseif Not fn_IsValidIPaddress(Form.IPaddress)>
	<cfset errorMessage_fields.IPaddress = Variables.lang_insertUpdateIPaddress.IPaddress_valid>
<cfelse>
	<cfloop Query="qry_selectIPaddressList">
		<cfif qry_selectIPaddressList.IPaddressID is not URL.IPaddressID>
			<cfif Form.IPaddress is qry_selectIPaddressList.IPaddress>
				<cfset errorMessage_fields.IPaddress = Variables.lang_insertUpdateIPaddress.IPaddress_exists>
			<cfelseif qry_selectIPaddressList.IPaddress_max is not ""
					and fn_IsIPaddressInRange(qry_selectIPaddressList.IPaddress, qry_selectIPaddressList.IPaddress_max, Form.IPaddress)>
				<cfset errorMessage_fields.IPaddress = Variables.lang_insertUpdateIPaddress.IPaddress_range>
			</cfif>
		</cfif>
	</cfloop>
</cfif>

<cfif Form.IPaddress_max is not "">
	<cfif Len(Form.IPaddress_max) gt maxlength_IPaddress.IPaddress_max>
		<cfset errorMessage_fields.IPaddress_max = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateIPaddress.IPaddress_max_maxlength, "<<MAXLENGTH>>", maxlength_IPaddress.IPaddress_max, "ALL"), "<<LEN>>", Len(Form.IPaddress_max), "ALL")>
	<cfelseif Not fn_IsValidIPaddress(Form.IPaddress_max)>
		<cfset errorMessage_fields.IPaddress_max = Variables.lang_insertUpdateIPaddress.IPaddress_max_valid>
	<cfelseif Form.IPaddress_max is Form.IPaddress>
		<cfset errorMessage_fields.IPaddress_max = Variables.lang_insertUpdateIPaddress.IPaddress_max_same>
	<cfelseif fn_IsValidIPaddress(Form.IPaddress)>
		<cfif Not fn_IsIPaddressInRange(Form.IPaddress, Form.IPaddress_max, Form.IPaddress_max)>
			<cfset errorMessage_fields.IPaddress_max = Variables.lang_insertUpdateIPaddress.IPaddress_max_greater>
		<cfelse>
			<cfloop Query="qry_selectIPaddressList">
				<cfif qry_selectIPaddressList.IPaddressID is not URL.IPaddressID>
					<cfif Form.IPaddress_max is qry_selectIPaddressList.IPaddress>
						<cfset errorMessage_fields.IPaddress_max = Variables.lang_insertUpdateIPaddress.IPaddress_max_exists>
					<cfelseif fn_IsIPaddressInRange(Form.IPaddress, Form.IPaddress_max, qry_selectIPaddressList.IPaddress)>
						<cfset errorMessage_fields.IPaddress_max = Variables.lang_insertUpdateIPaddress.IPaddress_max_overlap>
					<cfelseif qry_selectIPaddressList.IPaddress_max is not "">
						<cfif fn_IsIPaddressInRange(qry_selectIPaddressList.IPaddress, qry_selectIPaddressList.IPaddress_max, Form.IPaddress_max)>
							<cfset errorMessage_fields.IPaddress_max = Variables.lang_insertUpdateIPaddress.IPaddress_max_range>
						<cfelseif fn_IsIPaddressInRange(Form.IPaddress, Form.IPaddress_max, qry_selectIPaddressList.IPaddress_max)>
							<cfset errorMessage_fields.IPaddress_max = Variables.lang_insertUpdateIPaddress.IPaddress_max_overlapMax>
						</cfif>
					</cfif>
				</cfif><!--- /if not this listing --->
			</cfloop><!--- /loop thru existing IP addresses --->
		</cfif><!--- /if max IP greater than min IP --->
	</cfif><!--- /if min IP is valid --->
</cfif><!--- /validate max IP address --->

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertIPaddress">
		<cfset errorMessage_title = Variables.lang_insertUpdateIPaddress.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdateIPaddress.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateIPaddress.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateIPaddress.errorFooter>
</cfif>

