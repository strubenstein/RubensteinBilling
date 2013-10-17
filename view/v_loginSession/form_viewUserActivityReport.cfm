<cfoutput>
<script type="text/javascript">
var dateFrom_today = '#DateFormat(Now(), "mm/dd/yyyy")#';
var dateTo_today = '#DateFormat(Now(), "mm/dd/yyyy")#';
var dateFrom_yesterday = '#DateFormat(DateAdd("d", -1, Now()), "mm/dd/yyyy")#';
var dateTo_yesterday = '#DateFormat(DateAdd("d", -1, Now()), "mm/dd/yyyy")#';
var dateFrom_thisWeek = '#DateFormat(dateRangeStruct.thisWeek_from, "mm/dd/yyyy")#';
var dateTo_thisWeek = '#DateFormat(dateRangeStruct.thisWeek_to, "mm/dd/yyyy")#';
var dateFrom_lastWeek = '#DateFormat(dateRangeStruct.lastWeek_from, "mm/dd/yyyy")#';
var dateTo_lastWeek = '#DateFormat(dateRangeStruct.lastWeek_to, "mm/dd/yyyy")#';
var dateFrom_thisMonth = '#DateFormat(dateRangeStruct.thisMonth_from, "mm/dd/yyyy")#';
var dateTo_thisMonth = '#DateFormat(dateRangeStruct.thisMonth_to, "mm/dd/yyyy")#';
var dateFrom_lastMonth = '#DateFormat(dateRangeStruct.lastMonth_from, "mm/dd/yyyy")#';
var dateTo_lastMonth = '#DateFormat(dateRangeStruct.lastMonth_to, "mm/dd/yyyy")#';
</script>

<script language="Javascript" src="#Application.billingUrlRoot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlRoot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlRoot#/js/lw_menu.js"></script>

<script language="Javascript">
function setSearchDates (dateRange)
{
	var dateFrom = "";
	var dateTo = "";

	switch (dateRange)
	{
		case "today" : {dateFrom = dateFrom_today; dateTo = dateTo_today; break;}
		case "yesterday" : {dateFrom = dateFrom_yesterday; dateTo = dateTo_yesterday; break;}
		case "thisWeek" : {dateFrom = dateFrom_thisWeek; dateTo = dateTo_thisWeek; break;}
		case "lastWeek" : {dateFrom = dateFrom_lastWeek; dateTo = dateTo_lastWeek; break;}
		case "thisMonth" : {dateFrom = dateFrom_thisMonth; dateTo = dateTo_thisMonth; break;}
		case "lastMonth" : {dateFrom = dateFrom_lastMonth; dateTo = dateTo_lastMonth; break;}
	}

	document.listUserActivity.userActivityDateBegin.value = dateFrom;
	document.listUserActivity.userActivityDateEnd.value = dateTo;
}
</script>

<form method="post" name="#activityStruct.formName#" action="#Arguments.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<div class="SmallText">
	<a href="javascript:void(0)" onClick="setSearchDates('today')" class="plainlink">Today</a> | 
	<a href="javascript:void(0)" onClick="setSearchDates('yesterday')" class="plainlink">Yesterday</a> | 
	<a href="javascript:void(0)" onClick="setSearchDates('thisWeek')" class="plainlink">This Week</a> | 
	<a href="javascript:void(0)" onClick="setSearchDates('lastWeek')" class="plainlink">Last Week</a> | 
	<a href="javascript:void(0)" onClick="setSearchDates('thisMonth')" class="plainlink">This Month</a> | 
	<a href="javascript:void(0)" onClick="setSearchDates('lastMonth')" class="plainlink">Last Month</a>
</div>

<table border="0" cellspacing="0" cellpadding="0" class="TableText">
<tr>
	<td>From:&nbsp;</td>
	<td>#fn_FormSelectDateTime(activityStruct.formName, "userActivityDateBegin", Form.userActivityDateBegin, "", 0, False, 0, "", "am", True)#</td>
	<td> &nbsp; &nbsp; To:</td>
	<td>#fn_FormSelectDateTime(activityStruct.formName, "userActivityDateEnd", Form.userActivityDateEnd, "", 0, False, 0, "", "am", True)#</td>
	<td> &nbsp; &nbsp; <input type="submit" name="submitUserActivity" value="Submit" class="TableText"></td>
</tr>
</table>

</form>
</cfoutput>
