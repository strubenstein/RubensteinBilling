<cfscript>
function fn_NowDateTimeIn5MinuteInterval ()
{
	return CreateODBCDateTime(CreateDateTime(Year(Now()), Month(Now()), Day(Now()), Hour(Now()), 5 * (Minute(Now()) \ 5), 00));
}

function fn_ConvertTo24HourFormat (hour, tt)
{
	if (hour is 12 and tt is "am")
		return "00";
	else if (hour is 12 or tt is "am")
		return NumberFormat(hour, "00.");
	else
		return hour + 12;
}

function fn_ConvertFrom24HourFormat (hour)
{
	if (hour is 0)
		return "12|am";
	else if (hour lte 11)
		return "#hour#|am";
	else if (hour is 12)
		return "12|pm";
	else
		return "#hour - 12#|pm";
}

function fn_FormValidateDateTime (dateBeginOrEnd, dateField_date, dateValue_date, dateField_hh, dateValue_hh, dateField_mm, dateValue_mm, dateField_tt, dateValue_tt)
{
	var errMsg_fields = StructNew();

	if (Not IsDate(dateValue_date) and (dateValue_date is "begin" or dateValue_date is not ""))
		errMsg_fields["#dateField_date#"] = "You did not select a valid #dateBeginOrEnd# date.";

	if (dateField_hh is not "" and (Not Application.fn_IsIntegerPositive(dateValue_hh) or dateValue_hh lt 1 or dateValue_hh gt 12))
		errMsg_fields["#dateField_hh#"] = "You did not select a valid #dateBeginOrEnd# date hour.";

	if (dateField_mm is not "" and (Not Application.fn_IsIntegerNonNegative(dateValue_mm) or dateValue_mm lt 0 or dateValue_mm gt 59))
		errMsg_fields["#dateField_mm#"] = "You did not select a valid #dateBeginOrEnd# date minute.";

	if (dateField_tt is not "" and Not ListFindNoCase("am,pm", dateValue_tt))
		errMsg_fields["#dateField_tt#"] = "You did not select a valid #dateBeginOrEnd# date am/pm setting.";

	if (Not StructIsEmpty(errMsg_fields))
		return errMsg_fields;
	else if (Not IsDate(dateValue_date))
		return "";
	else if (dateField_hh is not "")
		return CreateODBCDateTime(CreateDateTime(Year(dateValue_date), Month(dateValue_date), Day(dateValue_date), fn_ConvertTo24HourFormat(dateValue_hh, dateValue_tt), dateValue_mm, 00));
	else
		return CreateODBCDate(CreateDate(Year(dateValue_date), Month(dateValue_date), Day(dateValue_date)));
}
</cfscript>

<cffunction Name="fn_FormSelectDateTime" Output="Yes">
	<cfargument Name="dateValue_formName" Type="string" Required="Yes">
	<cfargument Name="dateField_date" Type="string" Required="Yes">
	<cfargument Name="dateValue_date" Type="string" Required="Yes">
	<cfargument Name="dateField_hh" Type="string" Required="Yes">
	<cfargument Name="dateValue_hh" Type="numeric" Required="Yes">
	<cfargument Name="dateField_mm" Type="string" Required="Yes">
	<cfargument Name="dateValue_mm" Type="numeric" Required="Yes">
	<cfargument Name="dateField_tt" Type="string" Required="Yes">
	<cfargument Name="dateValue_tt" Type="string" Required="Yes">
	<cfargument Name="dateAndTimeOnSameLine" Type="boolean" Required="No" Default="True">

	<cfoutput>
	<input type="text" name="#Arguments.dateField_date#" value="#HTMLEditFormat(Arguments.dateValue_date)#" size="7" maxlength="10">
	<script language="Javascript">
	<!-- 
	if (!document.layers) {
		document.write("<input type=button onclick='popUpCalendar(this, #Arguments.dateValue_formName#.#Arguments.dateField_date#, \"mm/dd/yyyy\")' value='date' style='font-size:11px'><cfif Arguments.dateAndTimeOnSameLine is False><br></cfif>")
	}
	//-->
	</script>
	<cfif Arguments.dateField_hh is not "" and Arguments.dateField_mm is not "" and Arguments.dateField_tt is not "">
		 at 
		<select name="#Arguments.dateField_hh#" size="1">
		<cfloop Index="count" List="12,1,2,3,4,5,6,7,8,9,10,11">
			<option value="#count#"<cfif Arguments.dateValue_hh is count> selected</cfif>>#count#</option>
		</cfloop>
		</select>

		<cfif Arguments.dateField_mm is not False>
			<select name="#Arguments.dateField_mm#" size="1">
			<cfloop Index="count" List="00,05,10,15,20,25,30,35,40,45,50,55">
				<option value="#count#"<cfif Arguments.dateValue_mm is count> selected</cfif>>#count#</option>
			</cfloop>
			</select>
		</cfif>

		<select name="#Arguments.dateField_tt#" size="1">
		<option value="am"<cfif Arguments.dateValue_tt is "am"> selected</cfif>>am</option>
		<option value="pm"<cfif Arguments.dateValue_tt is "pm"> selected</cfif>>pm</option>
		</select>
	</cfif>
	</cfoutput>
</cffunction>
