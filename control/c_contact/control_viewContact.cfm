<cfinclude template="../../view/v_contact/lang_viewContact.cfm">

<cfset Variables.displayContactTopic = False>
<cfif qry_selectContact.contactTopicID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.ContactTopic" Method="selectContactTopic" ReturnVariable="qry_selectContactTopic">
		<cfinvokeargument Name="contactTopicID" Value="#qry_selectContact.contactTopicID#">
	</cfinvoke>

	<cfif qry_selectContactTopic.RecordCount is 1>
		<cfset Variables.displayContactTopic = True>
	</cfif>
</cfif>

<cfset Variables.displayContactTemplate = False>
<cfif qry_selectContact.contactTemplateID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.ContactTemplate" Method="selectContactTemplate" ReturnVariable="qry_selectContactTemplate">
		<cfinvokeargument Name="contactTemplateID" Value="#qry_selectContact.contactTemplateID#">
	</cfinvoke>

	<cfif qry_selectContactTemplate.RecordCount is 1>
		<cfset Variables.displayContactTemplate = True>
	</cfif>
</cfif>

<cfset Variables.displayProductInfo = False>
<cfif qry_selectContact.primaryTargetID is Application.fn_GetPrimaryTargetID("productID") and Application.fn_IsIntegerPositive(qry_selectContact.targetID) is True>
	<cfinvoke Component="#Application.billingMapping#data.Product" Method="selectProduct" ReturnVariable="qry_selectProduct">
		<cfinvokeargument Name="productID" Value="#qry_selectContact.targetID#">
	</cfinvoke>

	<cfif qry_selectProduct.RecordCount is 1>
		<cfset Variables.displayProductInfo = True>
	</cfif>
</cfif>

<cfset Variables.displayPartnerCompany = "">
<cfif qry_selectContact.primaryTargetID_partner is not 0>
	<cfswitch expression="#Application.fn_GetPrimaryTargetKey(qry_selectContact.primaryTargetID_partner)#">
	<cfcase value="affiliateID">
		<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliate" ReturnVariable="qry_selectAffiliate">
			<cfinvokeargument Name="affiliateID" Value="#qry_selectContact.targetID_partner#">
		</cfinvoke>
		<cfset Variables.displayPartnerCompany = Variables.lang_viewContact_title.affiliateName & qry_selectAffiliate.affiliateName>
	</cfcase>
	<cfcase value="cobrandID">
		<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrand" ReturnVariable="qry_selectCobrand">
			<cfinvokeargument Name="cobrandID" Value="#qry_selectContact.targetID_partner#">
		</cfinvoke>
		<cfset Variables.displayPartnerCompany = Variables.lang_viewContact_title.cobrandName & qry_selectCobrand.cobrandName>
	</cfcase>
	<cfcase value="vendorID">
		<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendor" ReturnVariable="qry_selectVendor">
			<cfinvokeargument Name="vendorID" Value="#qry_selectContact.targetID_partner#">
		</cfinvoke>
		<cfset Variables.displayPartnerCompany = Variables.lang_viewContact_title.vendorName & qry_selectVendor.vendorName>
	</cfcase>
	</cfswitch>
</cfif>

<cfset Variables.displayPartnerUser = "">
<cfif qry_selectContact.userID_partner is not 0>
	<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUser">
		<cfinvokeargument Name="userID" Value="#qry_selectContact.userID_partner#">
	</cfinvoke>

	<cfset Variables.displayPartnerCompany = qry_selectUser.firstName & " " & qry_selectUser.lastName>
	<cfif Variables.displayPartnerCompany is "">
		<cfset Variables.displayPartnerCompany = Variables.lang_viewContact_title.salespersonName & Variables.displayPartnerCompany>
	<cfelse>
		<cfset Variables.displayPartnerCompany = Variables.lang_viewContact_title.contactName & Variables.displayPartnerCompany>
	</cfif>	
</cfif>

<cfinclude template="../../view/v_contact/dsp_selectContact.cfm">
