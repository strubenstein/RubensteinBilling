<!--- state options --->
<cfset Variables.selectStateOption = 123>
<cfinclude template="../../../view/v_address/var_stateList.cfm">
<cfinclude template="../../../view/v_address/act_stateList.cfm">

<!--- country options --->
<cfinclude template="../../../view/v_address/var_countryList.cfm">
<cfset Variables.countryList_value = Variables.selectCountry_name_short>
<cfset Variables.countryList_label = Variables.selectCountry_name_short>

<cfparam Name="Form.firstName" Default="">
<cfparam Name="Form.lastName" Default="">
<cfparam Name="Form.email" Default="">
<cfparam Name="Form.companyName" Default="">
<cfparam Name="Form.phoneAreaCode" Default="">
<cfparam Name="Form.phoneNumber" Default="">
<cfparam Name="Form.phoneExtension" Default="">
<cfparam Name="Form.address" Default="">
<cfparam Name="Form.city" Default="">
<cfparam Name="Form.state" Default="">
<cfparam Name="Form.zipCode" Default="">
<cfparam Name="Form.country" Default="United States">

<!--- contactus form fields --->
<cfparam Name="Form.contactSubject" Default="">
<cfparam Name="Form.contactMessage" Default="">
<cfparam Name="Form.contactTopicID" Default="">

<cfset Variables.selectStateSelected = Form.state>
<cfset Variables.countrySelected = Form.country>
