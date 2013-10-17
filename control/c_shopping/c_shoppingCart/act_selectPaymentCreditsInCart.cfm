<!--- Assumes productID_custom for courses is "courseX-cd" or "courseX-online" where X is the course number --->
<cfset paymentCreditStruct.creditCD_amount = 19.90>
<cfset paymentCreditStruct.creditCD_paymentCategoryID_custom = "credit3cd">

<cfset paymentCreditStruct.creditOnline_amount = 17.90>
<cfset paymentCreditStruct.creditOnline_paymentCategoryID_custom = "credit3online">

<cfset paymentCreditStruct.productCountCD = 0>
<cfset paymentCreditStruct.productCountOnline = 0>

<cfloop Index="count" From="1" To="#ArrayLen(theShoppingCart)#">
	<cfif ListLen(theShoppingCart[count].invoiceLineItemProductID_custom, "-") is 2
			and Left(ListFirst(theShoppingCart[count].invoiceLineItemProductID_custom, "-"), 6) is "course"
			and Application.fn_IsIntegerPositive(Replace(ListFirst(theShoppingCart[count].invoiceLineItemProductID_custom, "-"), "course", "", "ALL"))>
		<cfif ListLast(theShoppingCart[count].invoiceLineItemProductID_custom, "-") is "cd">
			<cfset paymentCreditStruct.productCountCD = paymentCreditStruct.productCountCD + theShoppingCart[count].invoiceLineItemQuantity>
		<cfelseif ListLast(theShoppingCart[count].invoiceLineItemProductID_custom, "-") is "online">
			<cfset paymentCreditStruct.productCountOnline = paymentCreditStruct.productCountOnline + theShoppingCart[count].invoiceLineItemQuantity>
		</cfif>
	</cfif>
</cfloop>

<cfif paymentCreditStruct.productCountCD lt 3>
	<cfset paymentCreditStruct.creditCountCD = 0>
<cfelse>
	<cfset paymentCreditStruct.creditCountCD = paymentCreditStruct.productCountCD \ 3>

	<cfinvoke Component="#Application.billingMapping#data.PaymentCategory" Method="selectPaymentCategoryIDViaCustomID" ReturnVariable="realPaymentCategoryID">
		<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
		<cfinvokeargument Name="paymentCategoryID_custom" Value="#paymentCreditStruct.creditCD_paymentCategoryID_custom#">
	</cfinvoke>

	<cfif Application.fn_IsIntegerPositive(realPaymentCategoryID)>
		<cfinvoke Component="#Application.billingMapping#data.PaymentCategory" Method="selectPaymentCategory" ReturnVariable="qry_selectPaymentCategory">
			<cfinvokeargument Name="paymentCategoryID" Value="#realPaymentCategoryID#">
		</cfinvoke>

		<cfloop Index="count" From="1" To="#paymentCreditStruct.creditCountCD#">
			<cfset temp = QueryAddRow(qry_selectPaymentCreditsInCart, 1)>
			<cfset temp = QuerySetCell(qry_selectPaymentCreditsInCart, "paymentCategoryID", realPaymentCategoryID)>
			<cfset temp = QuerySetCell(qry_selectPaymentCreditsInCart, "paymentCreditName", qry_selectPaymentCategory.paymentCategoryTitle)>
			<cfset temp = QuerySetCell(qry_selectPaymentCreditsInCart, "paymentCreditAmount", paymentCreditStruct.creditCD_amount)>
			<cfset temp = QuerySetCell(qry_selectPaymentCreditsInCart, "paymentCreditID_custom", paymentCreditStruct.creditCD_paymentCategoryID_custom)>
		</cfloop>
	</cfif>
</cfif>

<cfif paymentCreditStruct.productCountOnline lt 3>
	<cfset paymentCreditStruct.creditCountOnline = 0>
<cfelse>
	<cfset paymentCreditStruct.creditCountOnline = paymentCreditStruct.productCountOnline \ 3>

	<cfinvoke Component="#Application.billingMapping#data.PaymentCategory" Method="selectPaymentCategoryIDViaCustomID" ReturnVariable="realPaymentCategoryID">
		<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
		<cfinvokeargument Name="paymentCategoryID_custom" Value="#paymentCreditStruct.creditOnline_paymentCategoryID_custom#">
	</cfinvoke>

	<cfif Application.fn_IsIntegerPositive(realPaymentCategoryID)>
		<cfinvoke Component="#Application.billingMapping#data.PaymentCategory" Method="selectPaymentCategory" ReturnVariable="qry_selectPaymentCategory">
			<cfinvokeargument Name="paymentCategoryID" Value="#realPaymentCategoryID#">
		</cfinvoke>

		<cfloop Index="count" From="1" To="#paymentCreditStruct.creditCountOnline#">
			<cfset temp = QueryAddRow(qry_selectPaymentCreditsInCart, 1)>
			<cfset temp = QuerySetCell(qry_selectPaymentCreditsInCart, "paymentCategoryID", realPaymentCategoryID)>
			<cfset temp = QuerySetCell(qry_selectPaymentCreditsInCart, "paymentCreditName", qry_selectPaymentCategory.paymentCategoryTitle)>
			<cfset temp = QuerySetCell(qry_selectPaymentCreditsInCart, "paymentCreditAmount", paymentCreditStruct.creditOnline_amount)>
			<cfset temp = QuerySetCell(qry_selectPaymentCreditsInCart, "paymentCreditID_custom", paymentCreditStruct.creditOnline_paymentCategoryID_custom)>
		</cfloop>
	</cfif>
</cfif>

