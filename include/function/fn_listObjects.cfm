<cfoutput>
<script language="JavaScript" type="text/javascript">
<!-- Begin
function checkUncheck (field, count)
{
	if (count == 0)
		var fieldName = eval("document.#Variables.formName#." + field + "[1]");
	else
		var fieldName = eval("document.#Variables.formName#." + field + "[0]");

	if (fieldName.checked == true)
			fieldName.checked = false;
}

function toggle(target)
{ obj=(document.all) ? document.all[target] : document.getElementById(target);
  obj.style.display=(obj.style.display=='none') ? 'inline' : 'none';
}
//  End -->
</script>
</cfoutput>

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
<cfset Variables.showText = "Show Advanced Search">
<cfset Variables.hideText = "Hide Advanced Search">
