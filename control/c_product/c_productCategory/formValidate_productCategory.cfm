<cfif Variables.doAction is "insertProductCategory" or Not IsDefined("errorMessage_fields")>
	<cfset errorMessage_fields = StructNew()>
</cfif>

<!--- new categories to insert for this product --->
<cfset Form.categoryID_insert = "">

<!--- former categories in which product is re-listed --->
<cfset Form.categoryID_updateStatusTrue = "">

<cfloop Index="loopCategoryID" List="#Form.categoryID#">
	<cfif Not ListFind(ValueList(qry_selectCategoryList.categoryID), loopCategoryID)>
		<cfset errorMessage_fields.categoryID = Variables.lang_productCategory.categoryID>
		<cfbreak>
	<cfelse>
		<cfset Variables.prodCatRow = ListFind(ValueList(qry_selectProductCategory.categoryID), loopCategoryID)>
		<cfif Variables.prodCatRow is 0>
			<cfset Form.categoryID_insert = ListAppend(Form.categoryID_insert, loopCategoryID)>
		<cfelse><!--- qry_selectProductCategory.productCategoryStatus[Variables.prodCatRow] is 0 --->
			<cfset Form.categoryID_updateStatusTrue = ListAppend(Form.categoryID_updateStatusTrue, loopCategoryID)>
		</cfif>

		<!--- validate begin/end date --->
		<cfset Form["productCategoryDateBegin#loopCategoryID#"] = "">
		<cfset Variables.dateBeginResponse = fn_FormValidateDateTime("begin", "productCategoryDateBegin#loopCategoryID#_date", Form["productCategoryDateBegin#loopCategoryID#_date"], "productCategoryDateBegin#loopCategoryID#_hh", Form["productCategoryDateBegin#loopCategoryID#_hh"], "productCategoryDateBegin#loopCategoryID#_mm", Form["productCategoryDateBegin#loopCategoryID#_mm"], "productCategoryDateBegin#loopCategoryID#_tt", Form["productCategoryDateBegin#loopCategoryID#_tt"])>
		<cfif IsStruct(Variables.dateBeginResponse)>
			<cfloop Collection="#Variables.dateBeginResponse#" Item="field">
				<cfset errorMessage_fields["#field#"] = StructFind(Variables.dateBeginResponse, field)>
			</cfloop>
		<cfelse><!--- Variables.dateBeginResponse is "" or IsDate(Variables.dateBeginResponse) --->
			<cfset Form["productCategoryDateBegin#loopCategoryID#"] = Variables.dateBeginResponse>
		</cfif>

		<cfset Form["productCategoryDateEnd#loopCategoryID#"] = "">
		<cfset Variables.dateEndResponse = fn_FormValidateDateTime("end", "productCategoryDateEnd#loopCategoryID#_date", Form["productCategoryDateEnd#loopCategoryID#_date"], "productCategoryDateEnd#loopCategoryID#_hh", Form["productCategoryDateEnd#loopCategoryID#_hh"], "productCategoryDateEnd#loopCategoryID#_mm", Form["productCategoryDateEnd#loopCategoryID#_mm"], "productCategoryDateEnd#loopCategoryID#_tt", Form["productCategoryDateEnd#loopCategoryID#_tt"])>
		<cfif IsStruct(Variables.dateEndResponse)>
			<cfloop Collection="#Variables.dateEndResponse#" Item="field">
				<cfset errorMessage_fields["#field#"] = StructFind(Variables.dateEndResponse, field)>
			</cfloop>
		<cfelse><!--- Variables.dateEndResponse is "" or IsDate(Variables.dateEndResponse) --->
			<cfset Form["productCategoryDateEnd#loopCategoryID#"] = Variables.dateEndResponse>
		</cfif>

		<cfif IsDate(Form["productCategoryDateBegin#loopCategoryID#"]) and IsDate(Form["productCategoryDateEnd#loopCategoryID#"]) and DateCompare(Form["productCategoryDateBegin#loopCategoryID#"], Form["productCategoryDateEnd#loopCategoryID#"]) is not -1>
			<cfset errorMessage_fields.productCategoryDateBeginEnd = Variables.lang_productCategory.productCategoryDateBeginEnd>
		</cfif>
	</cfif>
</cfloop>

<!--- existing categories in which product is no longer listed --->
<cfset Form.categoryID_updateStatusFalse = "">
<cfif URL.productID is not 0 and IsDefined("qry_selectProductCategory")>
	<cfloop Query="qry_selectProductCategory">
		<cfif Not ListFind(Form.categoryID, qry_selectProductCategory.categoryID)>
			<cfset Form.categoryID_updateStatusFalse = ListAppend(Form.categoryID_updateStatusFalse, qry_selectProductCategory.categoryID)>
		</cfif>
	</cfloop>
</cfif>

<cfif Variables.doAction is "insertProductCategory">
	<cfif StructIsEmpty(errorMessage_fields)>
		<cfset isAllFormFieldsOk = True>
	<cfelse>
		<cfset isAllFormFieldsOk = False>
		<cfset errorMessage_title = Variables.lang_productCategory.errorTitle>
		<cfset errorMessage_header = Variables.lang_productCategory.errorHeader>
		<cfset errorMessage_footer = Variables.lang_productCategory.errorFooter>
	</cfif>
</cfif>

