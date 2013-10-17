<cfcomponent displayName="ListObjectsJS" hint="Displays javascript for forms for listing/filtering items">

<cffunction name="listObjectsJS" access="public" output="yes" returnType="boolean" hint="Displays javascript for list forms">
	<cfargument name="formName" type="string" required="yes">

	<cfoutput>
	<script language="JavaScript" type="text/javascript">
	<!-- Begin
	function checkUncheck (field, count)
	{
		if (count == 0)
			var fieldName = eval("document.#Arguments.formName#." + field + "[1]");
		else
			var fieldName = eval("document.#Arguments.formName#." + field + "[0]");
	
		if (fieldName.checked == true)
				fieldName.checked = false;
	}

	function toggle(target)
	{ obj=(document.all) ? document.all[target] : document.getElementById(target);
	  obj.style.display=(obj.style.display=='none') ? 'block' : 'none';
	}
	//  End -->
	</script>
	</cfoutput>

	<cfsilent>
	<cfif IsDefined("Form.showAdvancedSearch")
			and ((Form.showAdvancedSearch is True and Session.showAdvancedSearch is False)
				or (Form.showAdvancedSearch is False and Session.showAdvancedSearch is True))>
		<cflock Scope="Session" Timeout="10">
			<cfset Session.showAdvancedSearch = Form.showAdvancedSearch>
		</cflock>
	<cfelseif IsDefined("URL.showAdvancedSearch")
			and ((URL.showAdvancedSearch is True and Session.showAdvancedSearch is False)
				or (URL.showAdvancedSearch is False and Session.showAdvancedSearch is True))>
		<cflock Scope="Session" Timeout="10">
			<cfset Session.showAdvancedSearch = URL.showAdvancedSearch>
		</cflock>
	</cfif>
	</cfsilent>

	<cfreturn True>
</cffunction>

</cfcomponent>

