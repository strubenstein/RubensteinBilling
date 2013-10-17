<cfif IsDefined("Form.shippingAddressName")
		and IsDefined("Form.shippingAddress") and IsDefined("Form.shippingAddress2")
		and IsDefined("Form.shippingCity") and IsDefined("Form.shippingState")
		and IsDefined("Form.shippingZipCode") and IsDefined("Form.shippingZipCodePlus4")
		and IsDefined("Form.shippingCountry")>
	<cfparam Name="Form.billingAddressName" Default="#Form.shippingAddressName#">
	<cfparam Name="Form.billingAddress" Default="#Form.shippingAddress#">
	<cfparam Name="Form.billingAddress2" Default="#Form.shippingAddress2#">
	<cfparam Name="Form.billingCity" Default="#Form.shippingCity#">
	<cfparam Name="Form.billingState" Default="#Form.shippingState#">
	<cfparam Name="Form.billingZipCode" Default="#Form.shippingZipCode#">
	<cfparam Name="Form.billingZipCodePlus4" Default="#Form.shippingZipCodePlus4#">
	<cfparam Name="Form.billingCountry" Default="#Form.shippingCountry#">
</cfif>

<cfparam Name="Form.billingAddressName" Default="">
<cfparam Name="Form.billingAddress" Default="">
<cfparam Name="Form.billingAddress2" Default="">
<cfparam Name="Form.billingCity" Default="">
<cfparam Name="Form.billingState" Default="">
<cfparam Name="Form.billingZipCode" Default="">
<cfparam Name="Form.billingZipCodePlus4" Default="">
<cfparam Name="Form.billingCountry" Default="United States">

<cfparam Name="Form.creditCardName" Default="">
<cfparam Name="Form.creditCardType" Default="">
<cfparam Name="Form.creditCardNumber" Default="">
<cfparam Name="Form.creditCardExpirationMonth" Default="">
<cfparam Name="Form.creditCardExpirationYear" Default="">
<cfparam Name="Form.creditCardCVC" Default="">
<cfparam Name="Form.creditCardRetain" Default="0">
