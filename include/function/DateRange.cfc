<cfcomponent displayName="DateRange" hint="Returns shortcuts for date ranges">

<cffunction name="dateRangeShortcut" access="public" output="no" returnType="struct" hint="Returns structure of date range shortcuts">
	<cfset var dateRangeStruct = StructNew()>
	<cfset var methodStruct = StructNew()>

	<cfset dateRangeStruct.today_from = CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 00, 00, 00)>
	<cfset dateRangeStruct.today_to = CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 23, 59, 59)>

	<cfset methodStruct.yesterday = DateAdd("d", -1, Now())>
	<cfset dateRangeStruct.yesterday_from = CreateDateTime(Year(methodStruct.yesterday), Month(methodStruct.yesterday), Day(methodStruct.yesterday), 00, 00, 00)>
	<cfset dateRangeStruct.yesterday_to = CreateDateTime(Year(methodStruct.yesterday), Month(methodStruct.yesterday), Day(methodStruct.yesterday), 23, 59, 59)>

	<cfset methodStruct.tomorrow = DateAdd("d", 1, Now())>
	<cfset dateRangeStruct.tomorrow_from = CreateDateTime(Year(methodStruct.tomorrow), Month(methodStruct.tomorrow), Day(methodStruct.tomorrow), 00, 00, 00)>
	<cfset dateRangeStruct.tomorrow_to = CreateDateTime(Year(methodStruct.tomorrow), Month(methodStruct.tomorrow), Day(methodStruct.tomorrow), 23, 59, 59)>

	<cfset methodStruct.thisWeekSunday = DateAdd("d", -1 * DecrementValue(DayOfWeek(Now())), Now())>
	<cfset methodStruct.thisWeekSaturday = DateAdd("d", 6, methodStruct.thisWeekSunday)>
	<cfset dateRangeStruct.thisWeek_from = CreateDateTime(Year(methodStruct.thisWeekSunday), Month(methodStruct.thisWeekSunday), Day(methodStruct.thisWeekSunday), 00, 00, 00)>
	<cfset dateRangeStruct.thisWeek_to = CreateDateTime(Year(methodStruct.thisWeekSaturday), Month(methodStruct.thisWeekSaturday), Day(methodStruct.thisWeekSaturday), 23, 59, 59)>

	<cfset methodStruct.lastWeekSunday = DateAdd("ww", -1, methodStruct.thisWeekSunday)>
	<cfset methodStruct.lastWeekSaturday = DateAdd("ww", -1, methodStruct.thisWeekSaturday)>
	<cfset dateRangeStruct.lastWeek_from = CreateDateTime(Year(methodStruct.lastWeekSunday), Month(methodStruct.lastWeekSunday), Day(methodStruct.lastWeekSunday), 00, 00, 00)>
	<cfset dateRangeStruct.lastWeek_to = CreateDateTime(Year(methodStruct.lastWeekSaturday), Month(methodStruct.lastWeekSaturday), Day(methodStruct.lastWeekSaturday), 23, 59, 59)>

	<cfset methodStruct.nextWeekSunday = DateAdd("ww", 1, methodStruct.thisWeekSunday)>
	<cfset methodStruct.nextWeekSaturday = DateAdd("ww", 1, methodStruct.thisWeekSaturday)>
	<cfset dateRangeStruct.nextWeek_from = CreateDateTime(Year(methodStruct.nextWeekSunday), Month(methodStruct.nextWeekSunday), Day(methodStruct.nextWeekSunday), 00, 00, 00)>
	<cfset dateRangeStruct.nextWeek_to = CreateDateTime(Year(methodStruct.nextWeekSaturday), Month(methodStruct.nextWeekSaturday), Day(methodStruct.nextWeekSaturday), 23, 59, 59)>

	<cfset dateRangeStruct.thisMonth_from = CreateDateTime(Year(Now()), Month(Now()), 1, 00, 00, 00)>
	<cfset dateRangeStruct.thisMonth_to = CreateDateTime(Year(Now()), Month(Now()), DaysInMonth(Now()), 23, 59, 59)>

	<cfset methodStruct.lastMonth = DateAdd("m", -1, Now())>
	<cfset dateRangeStruct.lastMonth_from = CreateDateTime(Year(methodStruct.lastMonth), Month(methodStruct.lastMonth), 1, 00, 00, 00)>
	<cfset dateRangeStruct.lastMonth_to = CreateDateTime(Year(methodStruct.lastMonth), Month(methodStruct.lastMonth), DaysInMonth(methodStruct.lastMonth), 23, 59, 59)>

	<cfset methodStruct.nextMonth = DateAdd("m", 1, Now())>
	<cfset dateRangeStruct.nextMonth_from = CreateDateTime(Year(methodStruct.nextMonth), Month(methodStruct.nextMonth), 1, 00, 00, 00)>
	<cfset dateRangeStruct.nextMonth_to = CreateDateTime(Year(methodStruct.nextMonth), Month(methodStruct.nextMonth), DaysInMonth(methodStruct.nextMonth), 23, 59, 59)>

	<cfset dateRangeStruct.thisQuarter_from = CreateDateTime(Year(Now()), 1 + (3 * DecrementValue(Quarter(Now()))), 1, 00, 00, 00)>
	<cfset methodStruct.thisQuarter_to = DateAdd("m", 2, dateRangeStruct.thisQuarter_from)>
	<cfset dateRangeStruct.thisQuarter_to = CreateDateTime(Year(Now()), Month(methodStruct.thisQuarter_to), DaysInMonth(methodStruct.thisQuarter_to), 23, 59, 59)>

	<cfset methodStruct.lastQuarter_to = DateAdd("d", -1, dateRangeStruct.thisQuarter_from)>
	<cfset methodStruct.lastQuarter_from = DateAdd("m", -2, methodStruct.lastQuarter_to)>
	<cfset dateRangeStruct.lastQuarter_from = CreateDateTime(Year(methodStruct.lastQuarter_from), Month(methodStruct.lastQuarter_from), 1, 00, 00, 00)>
	<cfset dateRangeStruct.lastQuarter_to = CreateDateTime(Year(methodStruct.lastQuarter_to), Month(methodStruct.lastQuarter_to), Day(methodStruct.lastQuarter_to), 23, 59, 59)>

	<cfset methodStruct.nextQuarter_from = DateAdd("d", 1, methodStruct.thisQuarter_to)>
	<cfset methodStruct.nextQuarter_to = DateAdd("m", 2, methodStruct.nextQuarter_from)>
	<cfset dateRangeStruct.nextQuarter_from = CreateDateTime(Year(methodStruct.nextQuarter_from), Month(methodStruct.nextQuarter_from), 1, 00, 00, 00)>
	<cfset dateRangeStruct.nextQuarter_to = CreateDateTime(Year(methodStruct.nextQuarter_to), Month(methodStruct.nextQuarter_to), DaysInMonth(methodStruct.nextQuarter_to), 23, 59, 59)>

	<cfset dateRangeStruct.thisYear_from = CreateDateTime(Year(Now()), 1, 1, 00, 00, 00)>
	<cfset dateRangeStruct.thisYear_to = CreateDateTime(Year(Now()), 12, 31, 23, 59, 59)>

	<cfset dateRangeStruct.lastYear_from = CreateDateTime(Year(Now()) - 1, 1, 1, 00, 00, 00)>
	<cfset dateRangeStruct.lastYear_to = CreateDateTime(Year(Now()) - 1, 12, 31, 23, 59, 59)>

	<cfset dateRangeStruct.nextYear_from = CreateDateTime(Year(Now()) + 1, 1, 1, 00, 00, 00)>
	<cfset dateRangeStruct.nextYear_to = CreateDateTime(Year(Now()) + 1, 12, 31, 23, 59, 59)>

	<cfreturn dateRangeStruct>
</cffunction>

</cfcomponent>
