<!--- date fields --->
<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<dateToday>>", DateFormat(Now(), "mmmm dd, yyyy"), "ALL")>
<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<dateToday>>", DateFormat(Now(), "mmmm dd, yyyy"), "ALL")>

<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<dateTomorrow>>", DateFormat(DateAdd("d", 1, Now()), "mmmm dd, yyyy"), "ALL")>
<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<dateTomorrow>>", DateFormat(DateAdd("d", 1, Now()), "mmmm dd, yyyy"), "ALL")>

<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<dateYesterday>>", DateFormat(DateAdd("d", -1, Now()), "mmmm dd, yyyy"), "ALL")>
<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<dateYesterday>>", DateFormat(DateAdd("d", -1, Now()), "mmmm dd, yyyy"), "ALL")>
