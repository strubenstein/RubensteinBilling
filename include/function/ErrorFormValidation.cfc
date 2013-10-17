<cfcomponent displayName="ErrorFormValidation" hint="Displays form validation errors">

<cffunction name="errorFormValidation" access="public" output="yes" returnType="boolean" hint="Displays error messages">
	<cfargument name="errorMessage_fields" type="struct" required="yes">
	<cfargument name="errorMessage_pageTitle" type="string" required="no" default="">
	<cfargument name="errorMessage_title" type="string" required="no" default="">
	<cfargument name="errorMessage_header" type="string" required="no" default="">
	<cfargument name="errorMessage_footer" type="string" required="no" default="">

	<cfoutput>
	<cfif Arguments.errorMessage_pageTitle is not "">
		<p class="SubTitle">#Arguments.errorMessage_pageTitle#</p>
	<cfelseif StructKeyExists(Arguments.errorMessage_fields, "errorMessage_pageTitle") and Arguments.errorMessage_fields.errorMessage_pageTitle is not "">
		<p class="SubTitle">#Arguments.errorMessage_fields.errorMessage_pageTitle#</p>
	</cfif>

	<cfif Arguments.errorMessage_title is not "">
		<p class="ErrorMessage">#Arguments.errorMessage_title#</p>
	<cfelseif StructKeyExists(Arguments.errorMessage_fields, "errorMessage_title") and Arguments.errorMessage_fields.errorMessage_title is not "">
		<p class="ErrorMessage">#Arguments.errorMessage_fields.errorMessage_title#</p>
	</cfif>

	<cfif Arguments.errorMessage_header is not "">
		<p class="MainText">#Arguments.errorMessage_header#</p>
	<cfelseif StructKeyExists(Arguments.errorMessage_fields, "errorMessage_header") and Arguments.errorMessage_fields.errorMessage_header is not "">
		<p class="MainText">#Arguments.errorMessage_fields.errorMessage_header#</p>
	</cfif>

	<ul class="MainText">
	<cfloop item="field" collection="#Arguments.errorMessage_fields#">
		<cfif Not ListFindNoCase("errorMessage_pageTitle,errorMessage_title,errorMessage_header,errorMessage_footer", field) and Arguments.errorMessage_fields[field] is not "">
			<li>#Arguments.errorMessage_fields[field]#</li>
		</cfif>
	</cfloop>
	</ul>

	<cfif Arguments.errorMessage_footer is not "">
		<p class="MainText">#Arguments.errorMessage_footer#</p>
	<cfelseif StructKeyExists(Arguments.errorMessage_fields, "errorMessage_footer") and Arguments.errorMessage_fields.errorMessage_footer is not "">
		<p class="MainText">#Arguments.errorMessage_fields.errorMessage_footer#</p>
	</cfif>
	</cfoutput>

	<cfreturn True>
</cffunction>

</cfcomponent>
