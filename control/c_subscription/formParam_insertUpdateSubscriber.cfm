<cfif URL.subscriberID is not 0 and IsDefined("qry_selectSubscriber")>
	<cfparam Name="Form.companyID" Default="#qry_selectSubscriber.companyID#">
	<cfparam Name="Form.userID" Default="#qry_selectSubscriber.userID#">
	<cfparam Name="Form.subscriberName" Default="#qry_selectSubscriber.subscriberName#">
	<cfparam Name="Form.subscriberID_custom" Default="#qry_selectSubscriber.subscriberID_custom#">
	<cfparam Name="Form.subscriberStatus" Default="#qry_selectSubscriber.subscriberStatus#">
	<cfparam Name="Form.addressID_billing" Default="#qry_selectSubscriber.addressID_billing#">
	<cfparam Name="Form.addressID_shipping" Default="#qry_selectSubscriber.addressID_shipping#">
	<cfif Not IsDefined("Form.isFormSubmitted")>
		<cfparam Name="Form.subscriberCompleted" Default="#qry_selectSubscriber.subscriberCompleted#">
	</cfif>

	<cfloop Index="dateField" List="#Variables.subscriberDateFieldList#">
		<cfset Variables.thisDate = Evaluate("qry_selectSubscriber.#dateField#")>
		<cfif IsDate(Variables.thisDate)>
			<cfset Variables.hour_ampm = fn_ConvertFrom24HourFormat(Hour(Variables.thisDate))>
			<cfparam Name="Form.#dateField#_date" Default="#DateFormat(Variables.thisDate, 'mm/dd/yyyy')#">
			<cfparam Name="Form.#dateField#_hh" Default="#ListFirst(Variables.hour_ampm, '|')#">
			<cfparam Name="Form.#dateField#_mm" Default="#Minute(Variables.thisDate)#">
			<cfparam Name="Form.#dateField#_tt" Default="#ListLast(Variables.hour_ampm, '|')#">
		</cfif>
	</cfloop>

	<cfparam Name="Form.creditCardID" Default="#qry_selectSubscriberPaymentList.creditCardID#">
	<cfparam Name="Form.bankID" Default="#qry_selectSubscriberPaymentList.bankID#">
</cfif>

<cfif URL.subscriberID is 0>
	<cfif URL.control is "company" and URL.userID is 0 and IsDefined("qry_selectCompany.userID")>
		<cfparam Name="Form.userID" Default="#qry_selectCompany.userID#">
	<cfelseif URL.control is "user" and URL.companyID is 0 and IsDefined("qry_selectUser.companyID")>
		<cfparam Name="Form.companyID" Default="#qry_selectUser.companyID#">
	</cfif>
</cfif>

<cfparam Name="Form.companyID" Default="#URL.companyID#">
<cfparam Name="Form.userID" Default="#URL.userID#">

<cfif URL.control is "company" and IsDefined("qry_selectCompany.companyName")>
	<cfparam Name="Form.subscriberName" Default="#qry_selectCompany.companyName#">
	<cfparam Name="Form.subscriberID_custom" Default="#qry_selectCompany.companyID_custom#">
<cfelseif URL.control is "user" and IsDefined("qry_selectUser.firstName")>
	<cfparam Name="Form.subscriberName" Default="#qry_selectUser.firstName# #qry_selectUser.lastName#">
	<cfparam Name="Form.subscriberID_custom" Default="#qry_selectUser.userID_custom#">
</cfif>

<cfparam Name="Form.subscriberName" Default="">
<cfparam Name="Form.subscriberID_custom" Default="">
<cfparam Name="Form.subscriberStatus" Default="1">
<cfparam Name="Form.subscriberCompleted" Default="0">

<cfparam Name="Form.creditCardID" Default="0">
<cfparam Name="Form.bankID" Default="0">
<cfparam Name="Form.addressID_billing" Default="0">
<cfparam Name="Form.addressID_shipping" Default="0">

<cfloop Index="dateField" List="#Variables.subscriberDateFieldList#">
	<cfparam Name="Form.#dateField#_date" Default="">
	<cfparam Name="Form.#dateField#_hh" Default="12">
	<cfparam Name="Form.#dateField#_mm" Default="00">
	<cfparam Name="Form.#dateField#_tt" Default="am">
</cfloop>

<!--- 
regionID
languageID
--->

