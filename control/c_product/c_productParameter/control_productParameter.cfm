<!--- 
Copy existing list of parameters/options from another product
productParameterCustomIDSeparator ?
for monogram-type option: parameter has text value with maxlength and maximum number of lines
--->

<cfinclude template="../../../view/v_product/v_productParameter/nav_productParameter.cfm">

<cfparam Name="URL.queryOrderBy" Default="productParameterOrder">
<cfinvoke Component="#Application.billingMapping#data.ProductParameter" Method="selectProductParameterList" ReturnVariable="qry_selectProductParameterList">
	<cfinvokeargument Name="productID" Value="#URL.productID#">
	<cfif Variables.doAction is "listProductParameters">
		<cfinvokeargument Name="queryOrderBy" Value="#URL.queryOrderBy#">
		<cfinvokeargument Name="returnOptionCount" Value="True">
	</cfif>
</cfinvoke>

<cfparam Name="URL.productParameterID" Default="0">
<cfinclude template="security_productParameter.cfm">

<cfswitch expression="#Variables.doAction#">
<cfcase value="listProductParameters">
	<cfinclude template="control_listProductParameters.cfm">
</cfcase>

<cfcase value="insertProductParameter">
	<cfif qry_selectProductParameterList.RecordCount gte 254>
		<cfset URL.error_product = "insertProductParameter">
		<cfinclude template="../../../view/v_product/error_product.cfm">
	<cfelse>
		<cfinclude template="control_insertProductParameter.cfm">
	</cfif>
</cfcase>

<cfcase value="updateProductParameter">
	<cfinclude template="control_updateProductParameter.cfm">
</cfcase>

<cfcase value="moveProductParameterDown,moveProductParameterUp">
	<cfinvoke Component="#Application.billingMapping#data.ProductParameter" Method="switchProductParameterOrder" ReturnVariable="isProductParameterOrderSwitched">
		<cfinvokeargument Name="productID" Value="#URL.productID#">
		<cfinvokeargument Name="productParameterID" Value="#URL.productParameterID#">
		<cfinvokeargument Name="productParameterOrder_direction" Value="#Variables.doAction#">
	</cfinvoke>

	<cflocation url="index.cfm?method=product.listProductParameters&productID=#URL.productID#&queryOrderBy=productParameterOrder&confirm_product=#Variables.doAction#" AddToken="No">
</cfcase>

<cfcase value="moveProductParameterCodeDown,moveProductParameterCodeUp">
	<cfset Variables.parameterRow = ListFind(ValueList(qry_selectProductParameterList.productParameterID), URL.productParameterID)>
	<cfif qry_selectProductParameterList.productParameterCodeStatus[Variables.parameterRow] is 0>
		<cflocation url="index.cfm?method=product.listProductParameters&productID=#URL.productID#&queryOrderBy=productParameterOrder&error_product=#Variables.doAction#" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.ProductParameter" Method="switchProductParameterCodeOrder" ReturnVariable="isProductParameterCodeOrderSwitched">
			<cfinvokeargument Name="productID" Value="#URL.productID#">
			<cfinvokeargument Name="productParameterID" Value="#URL.productParameterID#">
			<cfinvokeargument Name="productParameterCodeOrder_direction" Value="#Variables.doAction#">
		</cfinvoke>

		<cflocation url="index.cfm?method=product.listProductParameters&productID=#URL.productID#&queryOrderBy=productParameterCodeOrder&confirm_product=#Variables.doAction#" AddToken="No">
	</cfif>
</cfcase>

<cfcase value="listProductParameterExceptions">
	<cfinclude template="control_listProductParameterExceptions.cfm">
</cfcase>

<cfcase value="updateProductParameterExceptionStatus">
	<cfinclude template="security_productParameterException.cfm">
	<cfif qry_selectProductParameterException.productParameterExceptionStatus is 0>
		<cflocation url="index.cfm?method=product.listProductParameterExceptions&productID=#URL.productID#&error_product=#Variables.doAction#" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.ProductParameterException" Method="updateProductParameterException" ReturnVariable="isProductParameterExceptionUpdated">
			<cfinvokeargument Name="productParameterExceptionID" Value="#URL.productParameterExceptionID#">
		</cfinvoke>

		<cflocation url="index.cfm?method=product.listProductParameterExceptions&productID=#URL.productID#&confirm_product=#Variables.doAction#" AddToken="No">
	</cfif>
</cfcase>

<cfcase value="insertProductParameterException,updateProductParameterException">
	<cfif qry_selectProductParameterList.RecordCount is 0>
		<cfset URL.error_product = "insertProductParameterException">
		<cfinclude template="../../../view/v_product/error_product.cfm">
	<cfelse>
		<cfinclude template="control_insertProductParameterException.cfm">
	</cfif>
</cfcase>
</cfswitch>
