<cfoutput>
<cfif Session.companyDirectory is "" and FileExists(Application.billingCustomerDirectoryPath & Application.billingFilePathSlash & "footer_admin.cfm")>
	<cfinclude template="../../#Application.billingCustomerDirectoryInclude#footer_admin.cfm">
<cfelseif Session.companyDirectory is not "" and FileExists(Application.billingCustomerDirectoryPath & Application.billingFilePathSlash & Session.companyDirectory & Application.billingFilePathSlash & "footer_admin.cfm")>
	<cfinclude template="../../#Application.billingCustomerDirectoryInclude##Session.companyDirectory#/footer_admin.cfm">
</cfif>

<!--- border-top: 1px solid 778899; border-right: 1px solid 778899; border-bottom: 1px solid 778899; border-left: 1px solid 006699; --->
<div style="background-color: E7D8F3; width: 800px; padding: 2px 2px 2px 2px;" class="SmallText" align="center">
Copyright&copy; 2005-#Year(Now())# by <a href="http://www.strubenstein.com" target="strubenstein" style="color: black; text-decoration: none">Steven Rubenstein</a> - A Few Rights Reserved.
</div>

</body>
</html>
</cfoutput>
