<cfcomponent DisplayName="WSNewsletterSubscriber" Hint="Manages all newsletter subscriber web services">

<cffunction Name="insertNewsletterSubscriber" Access="remote" Output="No" ReturnType="boolean" Hint="Inserts newsletter subscriber into database and returns True">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="cobrandID" Type="numeric">
	<cfargument Name="cobrandID_custom" Type="string">
	<cfargument Name="affiliateID" Type="numeric">
	<cfargument Name="affiliateID_custom" Type="string">
	<cfargument Name="newsletterSubscriberEmail" Type="string">
	<cfargument Name="newsletterSubscriberStatus" Type="boolean">
	<cfargument Name="newsletterSubscriberHtml" Type="boolean">

	<cfset var returnValue = False>
	<cfset var returnError = "">
	<cfset var qry_selectAffiliateList = QueryNew("affiliateID")>
	<cfset var qry_selectCobrandList = QueryNew("cobrandID")>
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>

	<cfinclude template="ws_newsletter/ws_insertNewsletterSubscriber.cfm">
	<cfreturn returnValue>
</cffunction>

</cfcomponent>
