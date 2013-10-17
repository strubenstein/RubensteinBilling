<!--- 
0	nothing
1	Country

1	Display state
2	Display abbreviation

1	Store state
2	Store abbreviation

1	US only,
2	Canada only
3	US,Canada
4	Canada,US
--->

<cfparam Name="Variables.selectStateOption" Default="123">
<cfparam Name="Variables.selectStateSelected" Default="">

<cfswitch expression="#Variables.selectStateOption#">
<cfcase value="111"><!--- Display state / Store state / US only --->
	<cfset Variables.selectStateList_label = Variables.selectStateUSList_nameByName>
	<cfset Variables.selectStateList_value = Variables.selectStateUSList_nameByName>
</cfcase>
<cfcase value="112"><!--- Display state / Store state / Canada only --->
	<cfset Variables.selectStateList_label = Variables.selectStateCanadaList_nameByName>
	<cfset Variables.selectStateList_value = Variables.selectStateCanadaList_nameByName>
</cfcase>
<cfcase value="113"><!--- Display state / Store state / US,Canada --->
	<cfset Variables.selectStateList_label = Variables.selectStateUSList_nameByName & "," & Variables.selectStateCanadaList_nameByName>
	<cfset Variables.selectStateList_value = Variables.selectStateUSList_nameByName & "," & Variables.selectStateCanadaList_nameByName>
</cfcase>
<cfcase value="114"><!--- Display state / Store state / Canada,US --->
	<cfset Variables.selectStateList_label = Variables.selectStateCanadaList_nameByName & "," & Variables.selectStateUSList_nameByName>
	<cfset Variables.selectStateList_value = Variables.selectStateCanadaList_nameByName & "," & Variables.selectStateUSList_nameByName>
</cfcase>

<cfcase value="121"><!--- Display state / Store abbreviation / US only --->
	<cfset Variables.selectStateList_label = Variables.selectStateUSList_nameByName>
	<cfset Variables.selectStateList_value = Variables.selectStateUSList_abbrByName>
</cfcase>
<cfcase value="122"><!--- Display state / Store abbreviation / Canada only --->
	<cfset Variables.selectStateList_label = Variables.selectStateCanadaList_nameByName>
	<cfset Variables.selectStateList_value = Variables.selectStateCanadaList_abbrByName>
</cfcase>
<cfcase value="123"><!--- Display state / Store abbreviation / US,Canada --->
	<cfset Variables.selectStateList_label = Variables.selectStateUSList_nameByName & "," & Variables.selectStateCanadaList_nameByName>
	<cfset Variables.selectStateList_value = Variables.selectStateUSList_abbrByName & "," & Variables.selectStateCanadaList_abbrByName>
</cfcase>
<cfcase value="124"><!--- Display state / Store abbreviation / Canada,US --->
	<cfset Variables.selectStateList_label = Variables.selectStateCanadaList_nameByName & "," & Variables.selectStateUSList_nameByName>
	<cfset Variables.selectStateList_value = Variables.selectStateCanadaList_abbrByName & "," & Variables.selectStateUSList_abbrByName>
</cfcase>

<cfcase value="211"><!--- Display abbreviation / Store state / US only --->
	<cfset Variables.selectStateList_label = Variables.selectStateUSList_abbrByAbbr>
	<cfset Variables.selectStateList_value = Variables.selectStateUSList_nameByAbbr>
</cfcase>
<cfcase value="212"><!--- Display abbreviation / Store state / Canada only --->
	<cfset Variables.selectStateList_label = Variables.selectStateCanadaList_abbrByAbbr>
	<cfset Variables.selectStateList_value = Variables.selectStateCanadaList_nameByAbbr>
</cfcase>
<cfcase value="213"><!--- Display abbreviation / Store state / US,Canada --->
	<cfset Variables.selectStateList_label = Variables.selectStateUSList_abbrByAbbr & "," & Variables.selectStateCanadaList_abbrByAbbr>
	<cfset Variables.selectStateList_value = Variables.selectStateUSList_nameByAbbr & "," & Variables.selectStateCanadaList_nameByAbbr>
</cfcase>
<cfcase value="214"><!--- Display abbreviation / Store state / Canada,US --->
	<cfset Variables.selectStateList_label =  Variables.selectStateCanadaList_abbrByAbbr & "," & Variables.selectStateUSList_abbrByAbbr>
	<cfset Variables.selectStateList_value = Variables.selectStateCanadaList_nameByAbbr & "," & Variables.selectStateUSList_nameByAbbr>
</cfcase>

<cfcase value="221"><!--- Display abbreviation / Store abbreviation / US only --->
	<cfset Variables.selectStateList_label = Variables.selectStateUSList_abbrByAbbr>
	<cfset Variables.selectStateList_value = Variables.selectStateUSList_abbrByAbbr>
</cfcase>
<cfcase value="222"><!--- Display abbreviation / Store abbreviation / Canada only --->
	<cfset Variables.selectStateList_label = Variables.selectStateCanadaList_abbrByAbbr>
	<cfset Variables.selectStateList_value = Variables.selectStateCanadaList_abbrByAbbr>
</cfcase>
<cfcase value="223"><!--- Display abbreviation / Store abbreviation / US,Canada --->
	<cfset Variables.selectStateList_label = Variables.selectStateUSList_abbrByAbbr & "," & Variables.selectStateCanadaList_abbrByAbbr>
	<cfset Variables.selectStateList_value = Variables.selectStateUSList_abbrByAbbr & "," & Variables.selectStateCanadaList_abbrByAbbr>
</cfcase>
<cfcase value="224"><!--- Display abbreviation / Store abbreviation / Canada,US --->
	<cfset Variables.selectStateList_label = Variables.selectStateCanadaList_abbrByAbbr & "," & Variables.selectStateUSList_abbrByAbbr>
	<cfset Variables.selectStateList_value = Variables.selectStateCanadaList_abbrByAbbr & "," & Variables.selectStateUSList_abbrByAbbr>
</cfcase>
</cfswitch>

