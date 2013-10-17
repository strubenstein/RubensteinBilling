<cfset Variables.isStateSelected = False>
<cfoutput>
<option value="">-- SELECT --</option>
<cfloop Index="count" From="1" To="#ListLen(Variables.selectStateList_label)#">
	<option value="#ListGetAt(Variables.selectStateList_value, count)#"<cfif Variables.selectStateSelected is ListGetAt(Variables.selectStateList_value, count)> selected<cfset Variables.isStateSelected = True></cfif>>#ListGetAt(Variables.selectStateList_label, count)#</option>
</cfloop>
</cfoutput>

