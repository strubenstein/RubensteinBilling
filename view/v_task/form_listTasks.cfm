<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<script language="JavaScript" type="text/javascript">
<!-- Begin
function useDefaultDate (defaultDate)
{
	document.#methodStruct.formName#.taskDateFrom_hh.value = '12';
	document.#methodStruct.formName#.taskDateFrom_tt.value = 'am';
	document.#methodStruct.formName#.taskDateTo_hh.value = '12';
	document.#methodStruct.formName#.taskDateTo_tt.value = 'am';

	switch (defaultDate)
	{
		case 'yesterday' : {
			document.#methodStruct.formName#.taskDateFrom_date.value = '#DateFormat(DateAdd("d", -1, Now()), "mm/dd/yyyy")#';
			document.#methodStruct.formName#.taskDateTo_date.value = '#DateFormat(Now(), "mm/dd/yyyy")#';
			break; }
		case 'today' : {
			document.#methodStruct.formName#.taskDateFrom_date.value = '#DateFormat(Now(), "mm/dd/yyyy")#';
			document.#methodStruct.formName#.taskDateTo_date.value = '#DateFormat(DateAdd("d", 1, Now()), "mm/dd/yyyy")#';
			break; }
		case 'tomorrow' : {
				document.#methodStruct.formName#.taskDateFrom_date.value = '#DateFormat(DateAdd("d", 1, Now()), "mm/dd/yyyy")#';
				document.#methodStruct.formName#.taskDateTo_date.value = '#DateFormat(DateAdd("d", 2, Now()), "mm/dd/yyyy")#';
			break; }
		<cfset methodStruct.thisWeekSunday = DateAdd("d", -1 * DecrementValue(DayOfWeek(Now())), Now())>
		case 'lastWeek' : {
			document.#methodStruct.formName#.taskDateFrom_date.value = '#DateFormat(DateAdd("d", -7, methodStruct.thisWeekSunday), "mm/dd/yyyy")#';
			document.#methodStruct.formName#.taskDateTo_date.value = '#DateFormat(methodStruct.thisWeekSunday, "mm/dd/yyyy")#';
			break; }
		case 'thisWeek' : {
			document.#methodStruct.formName#.taskDateFrom_date.value = '#DateFormat(methodStruct.thisWeekSunday, "mm/dd/yyyy")#';
			document.#methodStruct.formName#.taskDateTo_date.value = '#DateFormat(DateAdd("d", 7, methodStruct.thisWeekSunday), "mm/dd/yyyy")#';
			break; }
		<cfset methodStruct.thisDate = DateAdd("m", 1, Now())>
		case 'nextWeek' : {
			document.#methodStruct.formName#.taskDateFrom_date.value = '#DateFormat(DateAdd("d", 7, methodStruct.thisWeekSunday), "mm/dd/yyyy")#';
			document.#methodStruct.formName#.taskDateTo_date.value = '#DateFormat(DateAdd("d", 14, methodStruct.thisWeekSunday), "mm/dd/yyyy")#';
			break; }
		<cfset methodStruct.thisDate = DateAdd("m", -1, Now())>
		case 'lastMonth' : {
			document.#methodStruct.formName#.taskDateFrom_date.value = '#DateFormat(methodStruct.thisDate, "mm")#/01/#DateFormat(methodStruct.thisDate, "yyyy")#';
			document.#methodStruct.formName#.taskDateTo_date.value = '#DateFormat(Now(), "mm")#/01/#DateFormat(Now(), "yyyy")#';
			break; }
		<cfset methodStruct.thisDate2 = DateAdd("m", 1, Now())>
		case 'thisMonth' : {
			document.#methodStruct.formName#.taskDateFrom_date.value = '#DateFormat(Now(), "mm")#/01/#DateFormat(Now(), "yyyy")#';
			document.#methodStruct.formName#.taskDateTo_date.value = '#DateFormat(methodStruct.thisDate2, "mm")#/01/#DateFormat(methodStruct.thisDate2, "yyyy")#';
			break; }
		<cfset methodStruct.thisDate1 = DateAdd("m", 1, Now())>
		<cfset methodStruct.thisDate2 = DateAdd("m", 2, Now())>
		case 'nextMonth' : {
			document.#methodStruct.formName#.taskDateFrom_date.value = '#DateFormat(methodStruct.thisDate1, "mm")#/01/#DateFormat(methodStruct.thisDate1, "yyyy")#';
			document.#methodStruct.formName#.taskDateTo_date.value = '#DateFormat(methodStruct.thisDate2, "mm")#/01/#DateFormat(methodStruct.thisDate2, "yyyy")#';
			break; }
		default : {
			document.#methodStruct.formName#.taskDateFrom_date.value = '';
			document.#methodStruct.formName#.taskDateFrom_hh.value = '12';
			document.#methodStruct.formName#.taskDateFrom_tt.value = 'am';
			document.#methodStruct.formName#.taskDateTo_date.value = '';
			document.#methodStruct.formName#.taskDateTo_hh.value = '12';
			document.#methodStruct.formName#.taskDateTo_tt.value = 'am';
			break; }
	}
}
//  End -->
</script>

<p>
<!--- Basic Search Form --->
<table border="0" cellspacing="0" cellpadding="2" class="TableText" width="800"><tr bgcolor="ccccff" valign="middle" id="basicSearch"<cfif Session.showAdvancedSearch is True> style="display:none;"</cfif>>
<form method="post" name="taskListBasic" action="#Arguments.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="queryOrderBy" value="#HTMLEditFormat(Form.queryOrderBy)#">
<input type="hidden" name="showAdvancedSearch" value="False">
<input type="hidden" name="searchField" value="companyName,companyDBA,companyURL,companyID_custom">
<td>
	Display Per Page: <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> &nbsp; &nbsp; &nbsp; &nbsp; 
	Search Description: <input type="text" name="taskMessage" size="30" value="#HTMLEditFormat(Form.taskMessage)#"> <input type="submit" name="submitTaskList" value="Submit">
</td>
<td align="right" class="TableText">[ <a href="javascript:void(0);" class="plainlink" onClick="toggle('advancedSearch');toggle('basicSearch');">Show Advanced Search</a> ]</td>
</tr>
</form>
</table>

<!--- Advanced Search Form --->
<table border="0" cellspacing="0" cellpadding="2" class="TableText" width="800" id="advancedSearch"<cfif Session.showAdvancedSearch is False> style="display:none;"</cfif>>
<form method="post" name="#methodStruct.formName#" action="#Arguments.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="queryOrderBy" value="#HTMLEditFormat(Form.queryOrderBy)#">
<input type="hidden" name="showAdvancedSearch" value="True">
<tr bgcolor="ccccff" class="MainText">
	<td><b>Advanced Search</b></td>
	<td colspan="2" align="right" class="TableText">[ <a href="javascript:void(0);" class="plainlink" onClick="toggle('advancedSearch');toggle('basicSearch');">Return to Basic Search</a> ]</td>
</tr>

<tr bgcolor="E7D8F3" valign="top">
	<td>
		Search Description:<br>
		<input type="text" name="taskMessage" size="30" value="#HTMLEditFormat(Form.taskMessage)#"><br>
		<cfif IsDefined("qry_selectUserCompanyList_company") and qry_selectUserCompanyList_company.RecordCount is not 0>
			<table border="0" cellspacing="0" cellpadding="0" class="TableText">
			<tr height="30" valign="bottom">
				<td>Created By:&nbsp;</td>
				<td>
					<select name="userID_author" size="1" class="TableText" style="width=200">
					<option value="0">-- SELECT AUTHOR --</option>
					<cfloop Query="qry_selectUserCompanyList_company">
						<option value="#qry_selectUserCompanyList_company.userID#"<cfif Form.userID_author is qry_selectUserCompanyList_company.userID> selected</cfif>>#HTMLEditFormat(qry_selectUserCompanyList_company.lastName)#, #HTMLEditFormat(qry_selectUserCompanyList_company.firstName)#</option>
					</cfloop>
					</select>
				</td>
			</tr>
			<tr height="30" valign="bottom">
				<td>Assigned To:&nbsp;</td>
				<td>
					<select name="userID_agent" size="1" class="TableText" style="width=200">
					<option value="0">-- SELECT ASSIGNED USER --</option>
					<cfloop Query="qry_selectUserCompanyList_company">
						<option value="#qry_selectUserCompanyList_company.userID#"<cfif Form.userID_agent is qry_selectUserCompanyList_company.userID> selected</cfif>>#HTMLEditFormat(qry_selectUserCompanyList_company.lastName)#, #HTMLEditFormat(qry_selectUserCompanyList_company.firstName)#</option>
					</cfloop>
					</select>
				</td>
			</tr>
			</table>
		</cfif>
		<!--- 
		Search Description:<br>
		<input type="text" name="taskMessage" size="25" value="#HTMLEditFormat(Form.taskMessage)#"><br>
		<cfif IsDefined("qry_selectUserCompanyList_company") and qry_selectUserCompanyList_company.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			Created By: 
			<select name="userID_author" size="1" class="TableText">
			<option value="0">-- SELECT AUTHOR --</option>
			<cfloop Query="qry_selectUserCompanyList_company">
				<option value="#qry_selectUserCompanyList_company.userID#"<cfif Form.userID_author is qry_selectUserCompanyList_company.userID> selected</cfif>>#HTMLEditFormat(qry_selectUserCompanyList_company.lastName)#, #HTMLEditFormat(qry_selectUserCompanyList_company.firstName)#</option>
			</cfloop>
			</select><br>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			Assigned To:<br>
			<select name="userID_agent" size="1" class="TableText">
			<option value="0">-- SELECT ASSIGNED USER --</option>
			<cfloop Query="qry_selectUserCompanyList_company">
				<option value="#qry_selectUserCompanyList_company.userID#"<cfif Form.userID_agent is qry_selectUserCompanyList_company.userID> selected</cfif>>#HTMLEditFormat(qry_selectUserCompanyList_company.lastName)#, #HTMLEditFormat(qry_selectUserCompanyList_company.firstName)#</option>
			</cfloop>
			</select>
		</cfif>
		--->
	</td>
	<td>
		<div class="TableText"><i>Date Shortcuts</i>:<!---  (<i><a href="##" onClick="javascript:clearDefaultDate();" class="plainlink">clear</a></i>) --->
		<select name="taskDateDefault" size="1" class="TableText" onChange="useDefaultDate(this.options[this.selectedIndex].value)">
		<option value="">-- (no shortcut) --</option>
		<option value="yesterday"<cfif Form.taskDateDefault is "yesterday"> selected</cfif>>Yesterday</option>
		<option value="today"<cfif Form.taskDateDefault is "today"> selected</cfif>>Today</option>
		<option value="tomorrow"<cfif Form.taskDateDefault is "tomorrow"> selected</cfif>>Tomorrow</option>
		<option value="lastWeek"<cfif Form.taskDateDefault is "lastWeek"> selected</cfif>>Last Week</option>
		<option value="thisWeek"<cfif Form.taskDateDefault is "thisWeek"> selected</cfif>>This Week</option>
		<option value="nextWeek"<cfif Form.taskDateDefault is "nextWeek"> selected</cfif>>Next Week</option>
		<option value="lastMonth"<cfif Form.taskDateDefault is "lastMonth"> selected</cfif>>Last Month</option>
		<option value="thisMonth"<cfif Form.taskDateDefault is "thisMonth"> selected</cfif>>This Month</option>
		<option value="nextMonth"<cfif Form.taskDateDefault is "nextMonth"> selected</cfif>>Next Month</option>
		</select>
		</div>
		<img src="#Application.billingUrlroot#/images/blank.gif" width="5" height="6" alt="" border="0"><br>
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr valign="top">
			<td>From:&nbsp;</td>
			<td>#fn_FormSelectDateTime(methodStruct.formName, "taskDateFrom_date", Form.taskDateFrom_date, "taskDateFrom_hh", Form.taskDateFrom_hh, False, 0, "taskDateFrom_tt", Form.taskDateFrom_tt, True)#</td>
		</tr>

		<tr valign="top">
			<td align="right">To:&nbsp;</td>
			<td>#fn_FormSelectDateTime(methodStruct.formName, "taskDateTo_date", Form.taskDateTo_date, "taskDateTo_hh", Form.taskDateTo_hh, False, 0, "taskDateTo_tt", Form.taskDateTo_tt, True)#</td>
		</tr>
		</table>
		<label><input type="checkbox" name="taskDateType" value="taskDateCreated"<cfif ListFind("taskDateCreated", Form.taskDateType)> checked</cfif>>Created</label> &nbsp; 
		<label><input type="checkbox" name="taskDateType" value="taskDateScheduled"<cfif ListFind("taskDateScheduled", Form.taskDateType)> checked</cfif>>Scheduled</label> &nbsp; 
		<label><input type="checkbox" name="taskDateType" value="taskDateUpdated"<cfif ListFind("taskDateUpdated", Form.taskDateType)> checked</cfif>>Completed</label><br>
	</td>

	<td align="center">

		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr class="TableText">
			<th>&nbsp;</th>
			<th>Yes&nbsp;No</th>
		</tr>
		<tr onMouseOver="bgColor='FFFFCC'" onMouseOut="bgColor='E7D8F3'">
			<td>&nbsp; Is Completed</td>
			<td><input type="checkbox" name="taskCompleted" value="1"<cfif Form.taskCompleted is 1> checked</cfif> onClick="javascript:checkUncheck('taskCompleted', 0)"><input type="checkbox" name="taskCompleted" value="0"<cfif Form.taskCompleted is 0> checked</cfif> onClick="javascript:checkUncheck('taskCompleted', 1)"></td>
		</tr>
		<tr onMouseOver="bgColor='FFFFCC'" onMouseOut="bgColor='E7D8F3'">
			<td nowrap>&nbsp; Is Ignored</td>
			<td><input type="checkbox" name="taskStatus" value="0"<cfif Form.taskStatus is 0> checked</cfif> onClick="javascript:checkUncheck('taskStatus', 0)"><input type="checkbox" name="taskStatus" value="1"<cfif Form.taskStatus is 1> checked</cfif> onClick="javascript:checkUncheck('taskStatus', 1)"></td>
		</tr>
		<tr onMouseOver="bgColor='FFFFCC'" onMouseOut="bgColor='E7D8F3'">
			<td>&nbsp; <i>All</i> Tasks</td>
			<td><input type="checkbox" name="taskAll" value="1"<cfif Form.taskAll is 1> checked</cfif>></td>
		</tr>
		<tr onMouseOver="bgColor='FFFFCC'" onMouseOut="bgColor='E7D8F3'">
			<td>&nbsp; All Tasks for this User</td>
			<td><cfif Arguments.userID_target is 0><div align="center">n/a</div><cfelse><input type="checkbox" name="taskAllForThisUser" value="1"<cfif Form.taskAllForThisUser is 1> checked</cfif>></cfif></td>
		</tr>
		<tr onMouseOver="bgColor='FFFFCC'" onMouseOut="bgColor='E7D8F3'">
			<td nowrap>&nbsp; All Tasks for this Company</td>
			<td><cfif Arguments.companyID_target is 0><div align="center">n/a</div><cfelse><input type="checkbox" name="taskAllForThisCompany" value="1"<cfif Form.taskAllForThisCompany is 1> checked</cfif>></cfif></td>
		</tr>
		</table>
	</td>
</tr>

<tr bgcolor="ccccff">
	<td align="center" colspan="3">
		<b>Display Per Page:</b> <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> 
		<input type="submit" name="submitTaskList" value="Submit">  &nbsp; &nbsp; <input type="reset" value="Reset">
	</td>
</tr>
</form>
</table>
</p>
</cfoutput>

