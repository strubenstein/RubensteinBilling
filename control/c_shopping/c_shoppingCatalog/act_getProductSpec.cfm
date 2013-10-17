<!--- 
Select product spec(s) if necessary: parent and/or children
If parent and children, assumes all have the same spec names in the same order
--->
<cfset Variables.displayProductSpec = False>
<cfset Variables.displayProductSpec_parent = False>
<cfset Variables.displayProductSpec_child = False>

<cfif qry_selectProduct.productHasSpec is 1 or Variables.childProductHasSpec is True>
	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectProductSpecList" ReturnVariable="qry_selectProductSpecList">
		<cfinvokeargument Name="productID" Value="#Variables.productID_getSpecs#">
	</cfinvoke>

	<cfif qry_selectProductSpecList.RecordCount is not 0><!--- if parent/child product has specs --->
		<cfset Variables.displayProductSpec = True>

		<!--- determine whether parent product has any specs --->
		<cfif ListFind(ValueList(qry_selectProductSpecList.productID), URL.productID)>
			<cfset Variables.displayProductSpec_child = True>
		</cfif>

		<!--- determine whether child products have any specs --->
		<cfif ListValueCount(ValueList(qry_selectProductSpecList.productID), URL.productID) lt qry_selectProductSpecList.RecordCount>
			<cfset Variables.displayProductSpec_child = True>
		</cfif>
	</cfif>
</cfif>

<!--- 
<cfif qry_selectProduct.productHasSpec is 1 or Variables.childProductHasSpec is True>
	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectProductSpecList" ReturnVariable="qry_selectProductSpecList">
		<cfinvokeargument Name="productID" Value="#Variables.productID_getSpecs#">
	</cfinvoke>

	<cfif qry_selectProductSpecList.RecordCount is not 0><!--- if parent/child product has specs --->
		<!--- indicate that product has specs --->
		<cfset Variables.displayProductSpec = True>
		<!--- initialize array that holds row/column cell values of specs table --->
		<cfset Variables.productSpecTable = ArrayNew(2)>

		<!--- determine whether child products have any specs --->
		<cfif ListValueCount(ValueList(qry_selectProductSpecList.productID), URL.productID) lt qry_selectProductSpecList.RecordCount>
			<cfset Variables.displayProductSpec_child = True>
		<cfelse>
			<cfset Variables.displayProductSpec_child = False>
		</cfif>

		<cfset Variables.beginRow = ListFind(ValueList(qry_selectProductSpecList.productID), URL.productID)>
		<cfif Variables.beginRow is 0><!--- if parent product does not have specs --->
			<cfset Variables.displayProductSpec_parent = False>
			<cfset Variables.tableColumn = 1>
		<cfelse><!--- if parent product has specs --->
			<cfset Variables.displayProductSpec_parent = True>
			<cfset Variables.tableColumn = 2>
			<cfif Variables.displayProductSpec_child is False>
				<cfset Variables.rowAdd = 0>
			<cfelse>
				<cfset Variables.rowAdd = 1>
				<cfset Variables.productSpecTable[1][1] = "Product">
				<cfset Variables.productSpecTable[1][2] = qry_selectProduct.productLanguageName>
			</cfif>

			<!--- add parent product specs to array for display --->
			<cfloop Query="qry_selectProductSpecList" StartRow="#Variables.beginRow#">
				<cfif qry_selectProductSpecList.productID is not URL.productID><cfbreak></cfif>
				<cfset Variables.productSpecTable[qry_selectProductSpecList.CurrentRow + Variables.rowAdd][1] = qry_selectProductSpecList.productSpecName>
				<cfset Variables.productSpecTable[qry_selectProductSpecList.CurrentRow + Variables.rowAdd][2] = qry_selectProductSpecList.productSpecValue>
			</cfloop>
		</cfif><!--- /if parent product has specs --->

		<cfif Variables.displayProductSpec_child is True><!--- if child products, check for specs --->
			<cfset Variables.paramColumnCount = 0>
			<cfloop Query="qry_selectProductChildList"><!--- /loop thru child products --->
				<cfset Variables.thisCurrentRow = qry_selectProductChildList.CurrentRow>
				<cfset Variables.thisChildProductID = qry_selectProductChildList.productID>
				<cfset Variables.beginRow = ListFind(ValueList(qry_selectProductSpecList.productID), Variables.thisChildProductID)>

				<!--- 
				<cfif Variables.beginRow is not 0><!--- if child product has specs --->
					<cfset Variables.tableColumn = Variables.tableColumn + 1>
					<cfif Variables.paramColumnCount is 0 and Variables.displayProductSpec_parent is False>
						<cfset Variables.productSpecTable[1][1] = "Part ##">
						<cfset Variables.productSpecTable[2][1] = "Product">
					</cfif>
					<cfset Variables.productSpecTable[1][Variables.tableColumn] = qry_selectProductChildList.productID_custom>
					<cfset Variables.productSpecTable[2][Variables.tableColumn] = qry_selectProductChildList.productLanguageName>
					<cfset Variables.lastCount = 2>

					<cfloop Query="qry_selectProductSpecList" StartRow="#Variables.beginRow#"><!--- loop thru child product specs --->
						<cfif qry_selectProductSpecList.productID is not Variables.thisChildProductID><cfbreak></cfif>
						<cfif Variables.tableColumn is 3 and Variables.displayProductSpec_parent is False>
							<cfset Variables.productSpecTable[qry_selectProductSpecList.productSpecOrder + 2][1] = qry_selectProductSpecList.productSpecName>
						</cfif>
						<cfset Variables.productSpecTable[qry_selectProductSpecList.productSpecOrder + 2][Variables.tableColumn] = qry_selectProductSpecList.productSpecValue>
						<cfset Variables.lastCount = Variables.lastCount + 1>
					</cfloop><!--- /loop thru child product specs --->

					<cfif Variables.paramColumnCount is 0 and Variables.displayProductSpec_parent is False>
						<cfset Variables.productSpecTable[Variables.lastCount + 1][1] = "Price">
						<cfset Variables.productSpecTable[Variables.lastCount + 2][1] = "Add To Cart">
					</cfif>

					<cfset Variables.productSpecTable[Variables.lastCount + 1][Variables.tableColumn] = DollarFormat(qry_selectProductChildList.productPrice)>
					<cfset Variables.productSpecTable[Variables.lastCount + 2][Variables.tableColumn] = "link">
				</cfif><!--- /if child product has specs --->
				--->

				<cfif Variables.beginRow is not 0><!--- if child product has specs --->
					<cfset Variables.tableColumn = Variables.tableColumn + 1>
					<!--- DO I NEED TO KEEP THIS??? --->
					<cfif Variables.paramColumnCount is 0 and Variables.displayProductSpec_parent is False>
						<cfset Variables.productSpecTable[1][1] = "Product">
					</cfif>
					<cfset Variables.productSpecTable[1][Variables.tableColumn] = qry_selectProductChildList.productLanguageName>

					<cfloop Query="qry_selectProductSpecList" StartRow="#Variables.beginRow#"><!--- loop thru child product specs --->
						<cfif qry_selectProductSpecList.productID is not Variables.thisChildProductID><cfbreak></cfif>
						<cfif Variables.tableColumn is 2 and Variables.displayProductSpec_parent is False>
							<cfset productSpecTable[qry_selectProductSpecList.productSpecOrder + 1][1] = qry_selectProductSpecList.productSpecName>
						</cfif>
						<cfset productSpecTable[qry_selectProductSpecList.productSpecOrder + 1][Variables.tableColumn] = qry_selectProductSpecList.productSpecValue>
					</cfloop><!--- /loop thru child product specs --->
				</cfif><!--- /if child product has specs --->
			</cfloop><!--- /loop thru child products --->
		</cfif><!--- /if child products, check for specs --->
	</cfif><!--- if parent/child product has specs --->
</cfif><!--- parent/child product has specs --->
--->
