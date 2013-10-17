<!--- email online course instructions to customer if purchased any --->
<cfset Variables.isOnlineCourse = False>
<cfloop Index="count" From="1" To="#ArrayLen(Variables.theShoppingCart)#">
	<cfif ListLen(Variables.theShoppingCart[count].invoiceLineItemProductID_custom, "-") is 2
			and ListLast(Variables.theShoppingCart[count].invoiceLineItemProductID_custom, "-") is "online"
			and Left(Variables.theShoppingCart[count].invoiceLineItemProductID_custom, 6) is "course">
		<cfset Variables.isOnlineCourse = True>
		<cfbreak>
	</cfif>
</cfloop>

<cfif Variables.isOnlineCourse is True>
	<cfinvoke Component="#Application.billingMapping#data.ContentCompany" Method="selectContentCompanyList" ReturnVariable="qry_selectContentCompanyList_course">
		<cfinvokeargument Name="contentCode" Value="confirmInstrEmailSubject,confirmInstrEmailBody">
		<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
		<cfinvokeargument Name="languageID" Value="">
		<cfinvokeargument Name="contentCompanyStatus" Value="1">
	</cfinvoke>

	<cfset Variables.contentCodeRow_course = StructNew()>
	<cfloop Query="qry_selectContentCompanyList_course">
		<cfset Variables.contentCodeRow_course[qry_selectContentCompanyList_course.contentCode] = qry_selectContentCompanyList_course.CurrentRow>
	</cfloop>

	<cfset Variables.emailType = fn_EmailType(qry_selectContentCompanyList_course.contentCompanyHtml[Variables.contentCodeRow_course.confirmInstrEmailBody])>

	<cfinclude template="../../../view/v_shopping/v_shoppingCheckout/email_courseInstrToCustomer.cfm">
</cfif>

