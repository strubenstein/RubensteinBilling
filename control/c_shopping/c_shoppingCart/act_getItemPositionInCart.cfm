<!--- if no parameters, just look for productID. otherwise check all parameters --->
<cfif Arguments.productParameterOptionID_list is "">
	<cfloop Index="count" From="1" To="#ArrayLen(theShoppingCart)#">
		<cfif theShoppingCart[count].productID is Arguments.productID>
			<cfset currentArrayPosition = count>
			<cfbreak>
		</cfif>
	</cfloop>
<cfelse><!--- check that parameters match --->
	<cfloop Index="count" From="1" To="#ArrayLen(theShoppingCart)#">
		<cfif theShoppingCart[count].productID is Arguments.productID>
			<cfset isParametersMatch = True>
			<cfif ListLen(Arguments.productParameterOptionID_list) is not ListLen(theShoppingCart[count].productParameterOptionID_list)>
				<cfset isParametersMatch = False>
				<cfbreak>
			<cfelse>
				<cfloop Index="optionID" List="#Arguments.productParameterOptionID_list#">
					<cfif Not ListFind(theShoppingCart[count].productParameterOptionID_list, optionID)>
						<cfset isParametersMatch = False>
						<cfbreak>
					</cfif>
				</cfloop>
			</cfif>

			<cfif isParametersMatch is True>
				<cfset currentArrayPosition = count>
				<cfbreak>
			</cfif>
		</cfif>
	</cfloop>
</cfif>
