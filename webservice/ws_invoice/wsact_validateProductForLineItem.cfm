<cfif Not IsDefined("Variables.wslang_invoice")>
	<cfinclude template="wslang_invoice.cfm">
</cfif>

<!--- validate product --->
<cfif (Arguments.productID is not 0 or Arguments.productID_custom is not "") and returnValue is 0>
	<cfset Arguments.productID = Application.objWebServiceSecurity.ws_checkProductPermission(qry_selectWebServiceSession.companyID_author, Arguments.productID, Arguments.productID_custom, Arguments.useCustomIDFieldList)>
	<cfif Arguments.productID lte 0 or ListLen(Arguments.productID) gt 1>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_invoice.invalidProduct>
	</cfif>
</cfif>

<!--- validate price --->
<cfif (Arguments.priceID is not 0 or Arguments.priceID_custom is not "") and returnValue is 0>
	<cfset Arguments.priceID = Application.objWebServiceSecurity.ws_checkPricePermission(qry_selectWebServiceSession.companyID_author, Arguments.priceID, Arguments.priceID_custom, Arguments.useCustomIDFieldList)>
	<cfif Arguments.priceID lte 0 or ListLen(Arguments.priceID) gt 1>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_invoice.invalidCustomPrice>
	</cfif>
</cfif>

<!--- validate product parameters --->
<cfset productParameterOptionID_list = "">
<cfif Arguments.productParameter is not "" and returnValue is 0>
	<cfif Arguments.productID is 0>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_invoice.productParameter>
	<cfelse>
		<!--- validate productParameter --->
		<cftry>
			<cfset productParameterXml = XMLParse(Arguments.productParameter)>

			<cfcatch>
				<cfset productParameterXml = "">
			</cfcatch>
		</cftry>

		<!--- productParameter must be valid xml with child tags and productParameter as root element --->
		<cfif productParameterXml is "" or Not IsXMLDoc(productParameterXml)
				or StructKeyList(productParameterXml) is not "productParameter"
				or ArrayLen(productParameterXml.XmlRoot.XmlChildren) is 0>
			<cfset returnValue = -1>
			<cfset returnError = Variables.wslang_invoice.invalidParameter>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.ProductParameter" Method="selectProductParameterList" ReturnVariable="qry_selectProductParameterList">
				<cfinvokeargument Name="productID" Value="#Arguments.productID#">
				<cfinvokeargument Name="productParameterStatus" Value="1">
			</cfinvoke>

			<cfif qry_selectProductParameterList.RecordCount is 0>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_invoice.noParameters>
			<cfelse>
				<cfinvoke Component="#Application.billingMapping#data.ProductParameterOption" Method="selectProductParameterOptionList" ReturnVariable="qry_selectProductParameterOptionList">
					<cfinvokeargument Name="productParameterID" Value="#ValueList(qry_selectProductParameterList.productParameterID)#">
					<cfinvokeargument Name="productParameterOptionStatus" Value="1">
				</cfinvoke>

				<!--- loop thru elements in productParameter xml and append to option list --->
				<cfset productParameterXmlCount = ArrayLen(productParameterXml.XmlRoot.XmlChildren)>
				<cfset productParameterID_list = "">

				<cfloop Index="count" From="1" To="#productParameterXmlCount#">
					<cfset productParameterXmlName = productParameterXml.XmlRoot.XmlChildren[count].XmlName>
					<cfset productParameterXmlValue = productParameterXml.XmlRoot.XmlChildren[count].XmlText>

					<!--- validate parameter name --->
					<cfset parameterRow = ListFind(ValueList(qry_selectProductParameterList.productParameterName), productParameterXmlName)>
					<cfif parameterRow is 0>
						<cfset returnValue = -1>
						<cfset returnError = Variables.wslang_invoice.invalidParameter>
					<cfelse>
						<cfset productParameterID_list = ListAppend(productParameterID_list, qry_selectProductParameterList.productParameterID[parameterRow])>
						<!--- validate parameter value --->
						<cfif productParameterXmlValue is not "">
							<cfset isOptionExist = False>
							<cfloop Query="qry_selectProductParameterOptionList">
								<cfif qry_selectProductParameterOptionList.productParameterID is qry_selectProductParameterList.productParameterID[parameterRow]
										and qry_selectProductParameterOptionList.productParameterOptionValue is productParameterXmlValue>
									<cfset productParameterOptionID_list = ListAppend(productParameterOptionID_list, qry_selectProductParameterOptionList.productParameterOptionID)>
									<cfset Arguments["parameter#qry_selectProductParameterOptionList.productParameterID[parameterRow]#"] = qry_selectProductParameterOptionList.productParameterOptionID>
									<cfset isOptionExist = True>
									<cfbreak>
								</cfif>
							</cfloop>

							<cfif isOptionExist is False>
								<cfset returnValue = -1>
								<cfset returnError = Variables.wslang_invoice.invalidParameterOption>
							</cfif>
						</cfif>
					</cfif>
				</cfloop>

				<!--- validate that all required parameters have been entered --->
				<cfloop Query="qry_selectProductParameterList">
					<cfif qry_selectProductParameterList.productParameterRequired is 1 and Not ListFind(productParameterID_list, qry_selectProductParameterList.productParameterID)>
						<cfset returnValue = -1>
						<cfset returnError = Variables.wslang_invoice.parameterRequired>
					</cfif>
				</cfloop>
			</cfif><!--- /product has parameters --->
		</cfif><!--- /productParameter field is valid xml variable --->
	</cfif><!--- /not a custom product --->
</cfif><!--- /productParameter field is not blank --->

