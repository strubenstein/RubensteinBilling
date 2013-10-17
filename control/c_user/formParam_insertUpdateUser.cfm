<cfif Variables.doAction is "updateUser">
	<cfparam Name="Form.companyID" Default="#qry_selectUser.companyID#">
	<cfparam Name="Form.username" Default="#qry_selectUser.username#">
	<cfparam Name="Form.password" Default="">
	<cfparam Name="Form.passwordVerify" Default="">
	<cfparam Name="Form.userStatus" Default="#qry_selectUser.userStatus#">
	<cfparam Name="Form.firstName" Default="#qry_selectUser.firstName#">
	<cfparam Name="Form.middleName" Default="#qry_selectUser.middleName#">
	<cfparam Name="Form.lastName" Default="#qry_selectUser.lastName#">
	<cfparam Name="Form.salutation_select" Default="#qry_selectUser.salutation#">
	<cfparam Name="Form.salutation_text" Default="#qry_selectUser.salutation#">
	<cfparam Name="Form.suffix_select" Default="#qry_selectUser.suffix#">
	<cfparam Name="Form.suffix_text" Default="#qry_selectUser.suffix#">
	<cfparam Name="Form.email" Default="#qry_selectUser.email#">
	<cfparam Name="Form.languageID" Default="#qry_selectUser.languageID#">
	<cfparam Name="Form.userID_custom" Default="#qry_selectUser.userID_custom#">
	<cfparam Name="Form.jobTitle" Default="#qry_selectUser.jobTitle#">
	<cfparam Name="Form.jobDepartment_select" Default="#qry_selectUser.jobDepartment#">
	<cfparam Name="Form.jobDepartment_text" Default="">
	<cfparam Name="Form.jobDivision" Default="#qry_selectUser.jobDivision#">
	<cfparam Name="Form.userNewsletterHtml" Default="#qry_selectUser.userNewsletterHtml#">

	<cfif Not IsDefined("Form.isFormSubmitted")>
		<cfparam Name="Form.userNewsletterStatus" Default="#qry_selectUser.userNewsletterStatus#">
	</cfif>

	<cfparam Name="Form.userEmailVerified" Default="#qry_selectUser.userEmailVerified#">
</cfif>

<cfparam Name="Form.companyID" Default="0">
<cfparam Name="Form.username" Default="">
<cfparam Name="Form.password" Default="">
<cfparam Name="Form.passwordVerify" Default="">
<cfparam Name="Form.userStatus" Default="1">
<cfparam Name="Form.firstName" Default="">
<cfparam Name="Form.middleName" Default="">
<cfparam Name="Form.lastName" Default="">
<cfparam Name="Form.salutation_select" Default="">
<cfparam Name="Form.salutation_text" Default="">
<cfparam Name="Form.suffix_select" Default="">
<cfparam Name="Form.suffix_text" Default="">
<cfparam Name="Form.email" Default="">
<cfparam Name="Form.languageID" Default="">
<cfparam Name="Form.userID_custom" Default="">
<cfparam Name="Form.jobTitle" Default="">
<cfparam Name="Form.jobDepartment_select" Default="">
<cfparam Name="Form.jobDepartment_text" Default="">
<cfparam Name="Form.jobDivision" Default="">
<cfparam Name="Form.userNewsletterStatus" Default="0">
<cfparam Name="Form.userNewsletterHtml" Default="1">

<cfparam Name="Form.userEmailVerified" Default="">
