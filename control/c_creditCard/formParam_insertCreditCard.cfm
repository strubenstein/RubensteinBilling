<cfif URL.creditCardID is not 0 and IsDefined("qry_selectCreditCard")>
	<cfparam Name="Form.creditCardStatus" Default="#qry_selectCreditCard.creditCardStatus#">
	<cfparam Name="Form.creditCardName" Default="#qry_selectCreditCard.creditCardName#">
	<cfparam Name="Form.creditCardType" Default="#qry_selectCreditCard.creditCardType#">
	<cfparam Name="Form.creditCardNumber" Default="#qry_selectCreditCard.creditCardNumber#">
	<cfparam Name="Form.creditCardExpirationMonth" Default="#qry_selectCreditCard.creditCardExpirationMonth#">
	<cfparam Name="Form.creditCardExpirationYear" Default="#qry_selectCreditCard.creditCardExpirationYear#">
	<cfparam Name="Form.creditCardCVC" Default="#qry_selectCreditCard.creditCardCVC#">
	<cfparam Name="Form.addressID" Default="#qry_selectCreditCard.addressID#">
	<cfparam Name="Form.creditCardDescription" Default="#qry_selectCreditCard.creditCardDescription#">
	<cfparam Name="Form.creditCardRetain" Default="#qry_selectCreditCard.creditCardRetain#">
</cfif>

<cfparam Name="Form.creditCardStatus" Default="1">
<cfparam Name="Form.creditCardName" Default="">
<cfparam Name="Form.creditCardType" Default="">
<cfparam Name="Form.creditCardNumber" Default="">
<cfparam Name="Form.creditCardExpirationMonth" Default="">
<cfparam Name="Form.creditCardExpirationYear" Default="">
<cfparam Name="Form.creditCardCVC" Default="">
<cfparam Name="Form.addressID" Default="0">
<cfparam Name="Form.creditCardDescription" Default="">
<cfparam Name="Form.creditCardRetain" Default="0">