<cfinvoke Component="#Application.billingMapping#data.Product" Method="selectProduct" ReturnVariable="qry_selectProduct">
	<cfinvokeargument Name="productID" Value="#URL.productID#">
</cfinvoke>

<cfif Variables.doAction is "insertSubscription" and Not IsDefined("Form.isFormSubmitted")>
	<cfinvoke Component="#Application.billingMapping#data.ProductLanguage" Method="selectProductLanguage" ReturnVariable="qry_selectProductLanguage">
		<cfinvokeargument Name="productID" Value="#URL.productID#">
		<cfinvokeargument Name="productLanguageStatus" Value="1">
	</cfinvoke>
</cfif>

<cfif qry_selectProduct.productID_parent is 0>
	<cfset productID_list = URL.productID>
<cfelse>
	<cfset productID_list = URL.productID & "," & qry_selectProduct.productID_parent>
</cfif>

<!--- select product parameter(s) if necessary --->
<cfif qry_selectProduct.productHasParameter is 1 or qry_selectProduct.productID_parent is not 0>
	<cfinvoke Component="#Application.billingMapping#data.ProductParameter" Method="selectProductParameterList" ReturnVariable="qry_selectProductParameterList">
		<cfinvokeargument Name="productID" Value="#productID_list#">
	</cfinvoke>

	<cfif qry_selectProductParameterList.RecordCount is not 0>
		<cfset displayProductParameter = True>
		<cfinvoke Component="#Application.billingMapping#data.ProductParameterOption" Method="selectProductParameterOptionList" ReturnVariable="qry_selectProductParameterOptionList">
			<cfinvokeargument Name="productParameterID" Value="#ValueList(qry_selectProductParameterList.productParameterID)#">
		</cfinvoke>

		<!--- select existing parameter values for this line item --->
		<cfinvoke Component="#Application.billingMapping#data.SubscriptionParameter" Method="selectSubscriptionParameterList" ReturnVariable="qry_selectSubscriptionParameterList">
			<cfinvokeargument Name="subscriptionID" Value="#URL.subscriptionID#">
		</cfinvoke>

		<!--- select parameter exceptions --->
		<cfinvoke Component="#Application.billingMapping#data.ProductParameterException" Method="selectProductParameterExceptionList" ReturnVariable="qry_selectProductParameterExceptionList">
			<cfinvokeargument Name="productID" Value="#productID_list#">
		</cfinvoke>

		<cfif qry_selectProductParameterExceptionList.RecordCount is not 0>
			<cfset displayProductParameterException = True>
		</cfif>
	</cfif>
</cfif>

<!--- get category info for pricing purposes --->
<cfinvoke Component="#Application.billingMapping#data.ProductCategory" Method="selectProductCategory" ReturnVariable="qry_selectProductCategory">
	<cfinvokeargument Name="productID" Value="#URL.productID#">
	<cfinvokeargument Name="productCategoryStatus" Value="1">
</cfinvoke>

<cfset categoryID_price = ValueList(qry_selectProductCategory.categoryID)>
<cfset categoryID_parentList_price = "">
<cfloop Query="qry_selectProductCategory">
	<cfloop Index="catID" List="#qry_selectProductCategory.categoryID_parentList#">
		<cfif Not ListFind(categoryID_parentList_price, catID)>
			<cfset categoryID_parentList_price = ListAppend(categoryID_parentList_price, catID)>
		</cfif>
	</cfloop>
</cfloop>
