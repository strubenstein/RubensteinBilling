<cfloop INDEX="nextVar" LIST="#StructKeyList(URL)#">
	<cfif Not REFind("[^A-Za-z0-9_-]", nextVar) and REFind("[A-Za-z_]", Left(nextVar, 1))>
		<cfset temp = SetVariable("Form.#nextVar#", URL[nextVar])>
	</cfif>
</cfloop>
