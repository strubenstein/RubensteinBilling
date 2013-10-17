<cfset Variables.isCountrySelected = False>
<cfparam Name="Variables.countrySelected" Default="">

<cfoutput>
<option value=""<cfif Variables.countrySelected is ""> selected</cfif>>SELECT COUNTRY</option>
<option value=" "<cfif Variables.countrySelected is " "> selected</cfif>>OTHER</option>
<cfloop Index="count" From="1" To="#ListLen(Variables.countryList_value)#"><option value="#ListGetAt(Variables.countryList_value, count)#"<cfif Variables.countrySelected is ListGetAt(Variables.countryList_value, count)> selected<cfset Variables.isCountrySelected = True></cfif>>#ListGetAt(Variables.countryList_label, count)#</option></cfloop>
</cfoutput>
