<cfif URL.cobrandID is not 0 and IsDefined("qry_selectHeaderFooter")>
	<cfloop Query="qry_selectHeaderFooter">
		<cfif qry_selectHeaderFooter.headerFooterIndicator is 0>
			<cfparam Name="Form.cobrandHeaderText" Default="#qry_selectHeaderFooter.headerFooterText#">
			<cfparam Name="Form.cobrandHeaderHtml" Default="#qry_selectHeaderFooter.headerFooterHtml#">
			<cfif IsDefined("Form.isFormSubmitted")>
				<cfparam Name="Variables.cobrandHeaderText_orig" Default="#qry_selectHeaderFooter.headerFooterText#">
				<cfparam Name="Variables.cobrandHeaderHtml_orig" Default="#qry_selectHeaderFooter.headerFooterHtml#">
			</cfif>
		<cfelse>
			<cfparam Name="Form.cobrandFooterText" Default="#qry_selectHeaderFooter.headerFooterText#">
			<cfparam Name="Form.cobrandFooterHtml" Default="#qry_selectHeaderFooter.headerFooterHtml#">
			<cfif IsDefined("Form.isFormSubmitted")>
				<cfparam Name="Variables.cobrandFooterText_orig" Default="#qry_selectHeaderFooter.headerFooterText#">
				<cfparam Name="Variables.cobrandFooterHtml_orig" Default="#qry_selectHeaderFooter.headerFooterHtml#">
			</cfif>
		</cfif>
	</cfloop>
</cfif>

<cfparam Name="Form.cobrandHeaderText" Default="">
<cfparam Name="Form.cobrandHeaderHtml" Default="0">
<cfparam Name="Form.cobrandFooterText" Default="">
<cfparam Name="Form.cobrandFooterHtml" Default="0">

<cfparam Name="Variables.cobrandHeaderText_orig" Default="">
<cfparam Name="Variables.cobrandHeaderHtml_orig" Default="0">
<cfparam Name="Variables.cobrandFooterText_orig" Default="">
<cfparam Name="Variables.cobrandFooterHtml_orig" Default="0">

