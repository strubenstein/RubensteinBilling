<cfset errorMessage_fields = StructNew()>

<cfset Variables.payflowTargetDateList_begin = "">
<cfset Variables.payflowTargetDateList_end = "">

<cfloop Query="qry_selectPayflowList">
	<cfif ListFind(Form.payflowID, qry_selectPayflowList.payflowID)>
		<cfset Variables.payflowTargetDateBegin = Form["payflowTargetDateBegin#qry_selectPayflowList.payflowID#_date"]>
		<cfset Variables.payflowTargetDateEnd = Form["payflowTargetDateEnd#qry_selectPayflowList.payflowID#_date"]>

		<cfif Variables.payflowTargetDateBegin is "">
			<cfset Variables.payflowTargetDateBegin = DateFormat(Now(), "mm/dd/yyyy")>
		</cfif>
		<cfif Not IsDate(Variables.payflowTargetDateBegin)>
			<cfset errorMessage_fields["payflowTargetDateBegin#qry_selectPayflowList.payflowID#_date"] = ReplaceNoCase(Variables.lang_insertPayflowTarget.payflowTargetDateBegin_valid, "<<COUNT>>", qry_selectPayflowList.CurrentRow, "ALL")>
		<cfelseif ListLen(Variables.payflowTargetDateList_begin) is 0>
			<cfset Variables.dateIndex = 0>
			<cfset Variables.payflowTargetDateList_begin = Variables.payflowTargetDateBegin>
		<cfelse><!--- insert begin date into list in chrono order for later comparison --->
			<cfset Variables.dateIndex = -1>
			<cfloop Index="count" From="1" To="#ListLen(Variables.payflowTargetDateList_begin)#">
				<!--- begin date cannot be repeated --->
				<cfif DateCompare(ListGetAt(Variables.payflowTargetDateList_begin, count), Variables.payflowTargetDateBegin) is 0>
					<cfset errorMessage_fields["payflowTargetDateBegin#qry_selectPayflowList.payflowID#_date"] = ReplaceNoCase(Variables.lang_insertPayflowTarget.payflowTargetDateBegin_repeat, "<<COUNT>>", qry_selectPayflowList.CurrentRow, "ALL")>
					<cfbreak>
				<cfelseif DateCompare(ListGetAt(Variables.payflowTargetDateList_begin, count), Variables.payflowTargetDateBegin) is 1>
					<cfset Variables.dateIndex = count>
					<cfset Variables.payflowTargetDateList_begin = ListInsertAt(Variables.payflowTargetDateList_begin, count, Variables.payflowTargetDateBegin)>
					<cfbreak>
				<cfelseif count is ListLen(Variables.payflowTargetDateList_begin)>
					<cfset Variables.dateIndex = 0>
					<cfset Variables.payflowTargetDateList_begin = ListAppend(Variables.payflowTargetDateList_begin, Variables.payflowTargetDateBegin)>
				</cfif>
			</cfloop>
		</cfif>

		<cfif Variables.payflowTargetDateEnd is "">
			<cfif ListFind(Variables.payflowTargetDateList_end, "NULL")><!--- cannot have more than one null end date --->
				<cfset errorMessage_fields["payflowTargetDateEnd#qry_selectPayflowList.payflowID#_date"] = ReplaceNoCase(Variables.lang_insertPayflowTarget.payflowTargetDateEnd_repeatNull, "<<COUNT>>", qry_selectPayflowList.CurrentRow, "ALL")>
			<cfelseif Variables.dateIndex is not 0><!--- null end date cannot come after non-null end date --->
				<cfset errorMessage_fields["payflowTargetDateEnd#qry_selectPayflowList.payflowID#_date"] = ReplaceNoCase(Variables.lang_insertPayflowTarget.payflowTargetDateEnd_afterNull, "<<COUNT>>", qry_selectPayflowList.CurrentRow, "ALL")>
			<cfelse>
				<cfset Variables.payflowTargetDateList_end = ListAppend(Variables.payflowTargetDateList_end, "NULL")>
			</cfif>
		<cfelseif Not IsDate(Variables.payflowTargetDateEnd)>
			<cfset errorMessage_fields["payflowTargetDateEnd#qry_selectPayflowList.payflowID#_date"] = ReplaceNoCase(Variables.lang_insertPayflowTarget.payflowTargetDateEnd_valid, "<<COUNT>>", qry_selectPayflowList.CurrentRow, "ALL")>
		<cfelseif IsDate(Variables.payflowTargetDateBegin) and DateCompare(Variables.payflowTargetDateBegin, Variables.payflowTargetDateEnd) is not -1>
			<cfset errorMessage_fields["payflowTargetDateEnd#qry_selectPayflowList.payflowID#_date"] = ReplaceNoCase(Variables.lang_insertPayflowTarget.payflowTargetDateEnd_begin, "<<COUNT>>", qry_selectPayflowList.CurrentRow, "ALL")>
		<cfelseif ListFind(Variables.payflowTargetDateList_end, Variables.payflowTargetDateEnd)>
			<cfset errorMessage_fields["payflowTargetDateEnd#qry_selectPayflowList.payflowID#_date"] = ReplaceNoCase(Variables.lang_insertPayflowTarget.payflowTargetDateEnd_repeat, "<<COUNT>>", qry_selectPayflowList.CurrentRow, "ALL")>
		<cfelse>
			<cfset Variables.firstEndDateNull = ListFind(Variables.payflowTargetDateList_end, "NULL")>
			<cfif Variables.firstEndDateNull is not 0 and (Variables.dateIndex is 0 or Variables.firstEndDateNull lt Variables.dateIndex)>
				<cfset errorMessage_fields["payflowTargetDateEnd#qry_selectPayflowList.payflowID#_date"] = ReplaceNoCase(Variables.lang_insertPayflowTarget.payflowTargetDateEnd_afterNull, "<<COUNT>>", qry_selectPayflowList.CurrentRow, "ALL")>
			<cfelseif Variables.dateIndex is 0><!--- last begin date; append to end of list --->
				<cfset Variables.payflowTargetDateList_end = ListAppend(Variables.payflowTargetDateList_end, Variables.payflowTargetDateEnd)>
			<cfelse><!--- not last begin date --->
				<cfset Variables.payflowTargetDateList_end = ListInsertAt(Variables.payflowTargetDateList_end, Variables.dateIndex, Variables.payflowTargetDateEnd)>
			</cfif>
		</cfif>
	</cfif>
</cfloop>

<!--- Check that begin/end time do not conflict with other begin/end time combinations --->
<cfif StructIsEmpty(errorMessage_fields) and ListLen(Variables.payflowTargetDateList_begin) gt 1>
	<cfloop Index="count" From="2" To="#ListLen(Variables.payflowTargetDateList_begin)#">
		<cfset Variables.thispayflowTargetDateBegin = ListGetAt(Variables.payflowTargetDateList_begin, count)>
		<cfset Variables.previouspayflowTargetDateEnd = ListGetAt(Variables.payflowTargetDateList_end, count - 1)>

		<cfif IsDate(Variables.previouspayflowTargetDateEnd) and DateCompare(Variables.thispayflowTargetDateBegin, Variables.previouspayflowTargetDateEnd) is not 1>
			<cfset errorMessage_fields.payflowTargetDateEnd = Variables.lang_insertPayflowTarget.payflowTargetDateEnd_chrono>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_insertPayflowTarget.errorTitle>
	<cfset errorMessage_header = Variables.lang_insertPayflowTarget.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertPayflowTarget.errorFooter>
</cfif>
