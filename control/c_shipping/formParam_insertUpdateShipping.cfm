<cfif URL.shippingID is not 0 and IsDefined("qry_selectShipping")>
	<cfif ListFind(Variables.shippingCarrierList_value, qry_selectShipping.shippingCarrier)>
		<cfparam Name="Form.shippingCarrier" Default="#qry_selectShipping.shippingCarrier#">
	<cfelseif qry_selectShipping.shippingCarrier is not "">
		<cfparam Name="Form.shippingCarrierOther" Default="#qry_selectShipping.shippingCarrier#">
	</cfif>

	<cfif ListFind(Variables.shippingMethodList_value, qry_selectShipping.shippingMethod)>
		<cfparam Name="Form.shippingMethod" Default="#qry_selectShipping.shippingMethod#">
	<cfelseif qry_selectShipping.shippingMethod is not "">
		<cfparam Name="Form.shippingMethodOther" Default="#qry_selectShipping.shippingMethod#">
	</cfif>

	<cfparam Name="Form.shippingWeight" Default="#qry_selectShipping.shippingWeight#">
	<cfparam Name="Form.shippingTrackingNumber" Default="#qry_selectShipping.shippingTrackingNumber#">
	<cfparam Name="Form.shippingInstructions" Default="#qry_selectShipping.shippingInstructions#">
	<cfparam Name="Form.shippingSent" Default="#qry_selectShipping.shippingSent#">
	<!--- <cfparam Name="Form.shippingDateSent" Default="#qry_selectShipping.shippingDateSent#"> --->
	<cfparam Name="Form.shippingReceived" Default="#qry_selectShipping.shippingReceived#">
	<!--- <cfparam Name="Form.shippingDateReceived" Default="#qry_selectShipping.shippingDateReceived#"> --->
	<cfparam Name="Form.shippingStatus" Default="#qry_selectShipping.shippingStatus#">
	<cfif IsDate(qry_selectShipping.shippingDateSent)>
		<cfparam Name="Form.shippingDateSent_date" Default="#DateFormat(qry_selectShipping.shippingDateSent, 'mm/dd/yyyy')#">
		<cfparam Name="Form.shippingDateSent_hh" Default="#ListFirst(fn_ConvertFrom24HourFormat(Hour(qry_selectShipping.shippingDateSent)), '|')#">
		<cfparam Name="Form.shippingDateSent_mm" Default="#Minute(qry_selectShipping.shippingDateSent)#">
		<cfparam Name="Form.shippingDateSent_tt" Default="#TimeFormat(qry_selectShipping.shippingDateSent, 'tt')#">
	</cfif>
	<cfif IsDate(qry_selectShipping.shippingDateReceived)>
		<cfparam Name="Form.shippingDateReceived_date" Default="#DateFormat(qry_selectShipping.shippingDateReceived, 'mm/dd/yyyy')#">
		<cfparam Name="Form.shippingDateReceived_hh" Default="#ListFirst(fn_ConvertFrom24HourFormat(Hour(qry_selectShipping.shippingDateReceived)), '|')#">
		<cfparam Name="Form.shippingDateReceived_mm" Default="#Minute(qry_selectShipping.shippingDateReceived)#">
		<cfparam Name="Form.shippingDateReceived_tt" Default="#TimeFormat(qry_selectShipping.shippingDateReceived, 'tt')#">
	</cfif>
</cfif>

<cfparam Name="Form.shippingCarrier" Default="">
<cfparam Name="Form.shippingMethod" Default="">
<cfparam Name="Form.shippingCarrierOther" Default="">
<cfparam Name="Form.shippingMethodOther" Default="">

<cfparam Name="Form.shippingWeight" Default="">
<cfparam Name="Form.shippingTrackingNumber" Default="">
<cfparam Name="Form.shippingInstructions" Default="">
<cfparam Name="Form.shippingSent" Default="0">
<!--- <cfparam Name="Form.shippingDateSent" Default=""> --->
<cfparam Name="Form.shippingReceived" Default="0">
<!--- <cfparam Name="Form.shippingDateReceived" Default=""> --->
<cfparam Name="Form.shippingStatus" Default="1">

<cfif Variables.doAction is "insertShipping">
	<cfparam Name="Form.shippingDateSent_date" Default="#DateFormat(Now(), 'mm/dd/yyyy')#">
<cfelse>
	<cfparam Name="Form.shippingDateSent_date" Default="">
</cfif>

<cfparam Name="Form.shippingDateSent_hh" Default="12">
<cfparam Name="Form.shippingDateSent_mm" Default="00">
<cfparam Name="Form.shippingDateSent_tt" Default="am">
<cfparam Name="Form.shippingDateReceived_date" Default="">
<cfparam Name="Form.shippingDateReceived_hh" Default="12">
<cfparam Name="Form.shippingDateReceived_mm" Default="00">
<cfparam Name="Form.shippingDateReceived_tt" Default="am">

<cfif Form.shippingWeight is 0>
	<cfset Form.shippingWeight = "">
</cfif>

