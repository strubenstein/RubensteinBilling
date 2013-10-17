<cfinclude template="wslang_invoice.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("viewInvoiceLineItems", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_invoice.viewInvoiceLineItems>
<cfelse>
	<cfset Arguments.invoiceID = Application.objWebServiceSecurity.ws_checkInvoicePermission(qry_selectWebServiceSession.companyID_author, Arguments.invoiceID, Arguments.invoiceID_custom, Arguments.useCustomIDFieldList)>

	<cfif ListLen(Arguments.invoiceID) is 1 and Arguments.invoiceID lte 0>
		<cfset returnValue = QueryNew("error")>
		<cfset returnError = Variables.wslang_invoice.invalidInvoice>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItemList" ReturnVariable="qry_selectInvoiceLineItemList">
			<cfinvokeargument Name="invoiceID" Value="#Arguments.invoiceID#">
			<cfinvokeargument Name="invoiceLineItemStatus" Value="1">
		</cfinvoke>

		<!--- <cfset lineItemParameterValueArray = ArrayNew(1)> --->
		<cfif qry_selectInvoiceLineItemList.RecordCount is not 0>
			<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItemParameterList" ReturnVariable="qry_selectInvoiceLineItemParameterList">
				<cfinvokeargument Name="invoiceLineItemID" Value="#ValueList(qry_selectInvoiceLineItemList.invoiceLineItemID)#">
			</cfinvoke>

			<cfset temp = ArraySet(lineItemParameterValueArray, 1, qry_selectInvoiceLineItemList.RecordCount, "")>

			<cfif qry_selectInvoiceLineItemParameterList.RecordCount is not 0>
				<cfinvoke Component="#Application.billingMapping#data.ProductParameterOption" Method="selectProductParameterOption" ReturnVariable="qry_selectProductParameterOption">
					<cfinvokeargument Name="productParameterOptionID" Value="#ValueList(qry_selectInvoiceLineItemParameterList.productParameterOptionID)#">
				</cfinvoke>

				<cfloop Query="qry_selectInvoiceLineItemParameterList">
					<cfset lineItemRow = ListFind(ValueList(qry_selectInvoiceLineItemList.invoiceLineItemID), qry_selectInvoiceLineItemParameterList.invoiceLineItemID)>
					<cfif lineItemRow is not 0>
						<cfset parameterOptionRow = ListFind(ValueList(qry_selectProductParameterOption.productParameterOptionID), qry_selectInvoiceLineItemParameterList.productParameterOptionID)>
						<cfif parameterOptionRow is not 0>
							<cfset lineItemParameterValueArray[lineItemRow] = 
								lineItemParameterValueArray[lineItemRow]
								& "<#qry_selectProductParameterOption.productParameterName[parameterOptionRow]#>"
								& qry_selectProductParameterOption.productParameterOptionValue[parameterOptionRow]
								& "</#qry_selectProductParameterOption.productParameterName[parameterOptionRow]#>">
						</cfif>
					</cfif>
				</cfloop>

				<!--- if not blank, add parent productParameter xml tag --->
				<cfif ArrayLen(lineItemParameterValueArray) is not 0>
					<cfloop Index="count" From="1" To="#ArrayLen(lineItemParameterValueArray)#">
						<cfif lineItemParameterValueArray[count] is not "">
							<cfset lineItemParameterValueArray[count] = "<productParameter>" & lineItemParameterValueArray[count] & "</productParameter>">
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
		</cfif>

		<cfset temp = QueryAddColumn(qry_selectInvoiceLineItemList, "productParameter", lineItemParameterValueArray)>

		<!--- add contact user(s) for line item(s) --->
		<cfif qry_selectInvoiceLineItemList.RecordCount is not 0>
			<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItemUser" ReturnVariable="qry_selectInvoiceLineItemUser">
				<cfinvokeargument Name="invoiceLineItemID" Value="#ValueList(qry_selectInvoiceLineItemList.invoiceLineItemID)#">
				<cfinvokeargument Name="returnUserField" Value="False">
			</cfinvoke>

			<cfset temp = ArraySet(invoiceLineItemUserArray, 1, qry_selectInvoiceLineItemList.RecordCount, 0)>

			<cfloop Query="qry_selectInvoiceLineItemUser">
				<cfset invoiceLineItemRow = ListFind(ValueList(qry_selectInvoiceLineItemList.invoiceLineItemID), qry_selectInvoiceLineItemUser.userID)>
				<cfif invoiceLineItemRow is not 0>
					<cfif invoiceLineItemUserArray[invoiceLineItemRow] is 0>
						<cfset invoiceLineItemUserArray[invoiceLineItemRow] = qry_selectInvoiceLineItemUser.userID>
					<cfelse>
						<cfset invoiceLineItemUserArray[invoiceLineItemRow] = ListAppend(invoiceLineItemUserArray[invoiceLineItemRow], qry_selectInvoiceLineItemUser.userID)>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>

		<cfset temp = QueryAddColumn(qry_selectInvoiceLineItemList, "userID", invoiceLineItemUserArray)>

		<cfset returnValue = qry_selectInvoiceLineItemList>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

