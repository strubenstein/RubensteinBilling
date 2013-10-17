<cfif URL.productID is not 0 and IsDefined("qry_selectProductLanguage")>
	<cfparam Name="Form.productLanguageName" Default="#qry_selectProductLanguage.productLanguageName#">
	<cfparam Name="Form.productLanguageLineItemName" Default="#qry_selectProductLanguage.productLanguageLineItemName#">
	<cfparam Name="Form.productLanguageLineItemDescription" Default="#qry_selectProductLanguage.productLanguageLineItemDescription#">
	<cfparam Name="Form.productLanguageLineItemDescriptionHtml" Default="#qry_selectProductLanguage.productLanguageLineItemDescriptionHtml#">
	<cfparam Name="Form.productLanguageSummary" Default="#qry_selectProductLanguage.productLanguageSummary#">
	<cfparam Name="Form.productLanguageSummaryHtml" Default="#qry_selectProductLanguage.productLanguageSummaryHtml#">
	<cfparam Name="Form.productLanguageDescription" Default="#qry_selectProductLanguage.productLanguageDescription#">
	<cfparam Name="Form.productLanguageDescriptionHtml" Default="#qry_selectProductLanguage.productLanguageDescriptionHtml#">
</cfif>

<cfparam Name="Form.productLanguageName" Default="">
<cfparam Name="Form.productLanguageLineItemName" Default="">
<cfparam Name="Form.productLanguageLineItemDescription" Default="">
<cfparam Name="Form.productLanguageLineItemDescriptionHtml" Default="0">
<cfparam Name="Form.productLanguageSummary" Default="">
<cfparam Name="Form.productLanguageSummaryHtml" Default="0">
<cfparam Name="Form.productLanguageDescription" Default="">
<cfparam Name="Form.productLanguageDescriptionHtml" Default="0">

