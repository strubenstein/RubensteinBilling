<cfif URL.control is not "company">
	<cfset URL.companyID = qry_selectCobrand.companyID>
	<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
		<cfinvokeargument Name="companyID" Value="#URL.companyID#">
	</cfinvoke>
</cfif>

<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("cobrandID")>
<cfinvoke Component="#Application.billingMapping#data.HeaderFooter" Method="selectHeaderFooter" ReturnVariable="qry_selectHeaderFooter">
	<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
	<cfinvokeargument Name="targetID" Value="#URL.cobrandID#">
	<cfinvokeargument Name="headerFooterStatus" Value="1">
</cfinvoke>

<cfset Variables.formAction = "index.cfm?method=#URL.method#&cobrandID=#URL.cobrandID##Variables.urlParameters#">
<cfinclude template="formParam_insertCobrandHeader.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitCobrandHeader")>
	<cfinclude template="../../view/v_cobrand/lang_insertCobrandHeader.cfm">
	<cfinclude template="formValidate_insertCobrandHeader.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfif Form.cobrandHeaderText is not Variables.cobrandHeaderText_orig or Form.cobrandHeaderHtml is not Variables.cobrandHeaderHtml_orig>
			<cfinvoke Component="#Application.billingMapping#data.HeaderFooter" Method="insertHeaderFooter" ReturnVariable="newHeaderID">
				<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
				<cfinvokeargument Name="targetID" Value="#URL.cobrandID#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="languageID" Value="">
				<cfinvokeargument Name="headerFooterStatus" Value="1">
				<cfinvokeargument Name="headerFooterText" Value="#Trim(Form.cobrandHeaderText)#">
				<cfinvokeargument Name="headerFooterHtml" Value="#Form.cobrandHeaderHtml#">
				<cfinvokeargument Name="headerFooterIndicator" Value="0">
			</cfinvoke>
		</cfif>

		<cfif Form.cobrandFooterText is not Variables.cobrandFooterText_orig or Form.cobrandFooterHtml is not Variables.cobrandFooterHtml_orig>
			<cfinvoke Component="#Application.billingMapping#data.HeaderFooter" Method="insertHeaderFooter" ReturnVariable="newFooterID">
				<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
				<cfinvokeargument Name="targetID" Value="#URL.cobrandID#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="languageID" Value="">
				<cfinvokeargument Name="headerFooterStatus" Value="1">
				<cfinvokeargument Name="headerFooterText" Value="#Trim(Form.cobrandFooterText)#">
				<cfinvokeargument Name="headerFooterHtml" Value="#Form.cobrandFooterHtml#">
				<cfinvokeargument Name="headerFooterIndicator" Value="1">
			</cfinvoke>
		</cfif>

		<cflocation url="#Variables.formAction#&confirm_cobrand=#URL.action#" AddToken="No">
	</cfif>
</cfif>

<cfinclude template="../../view/v_cobrand/form_insertCobrandHeader.cfm">
