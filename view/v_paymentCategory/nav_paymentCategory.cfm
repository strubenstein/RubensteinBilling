<cfoutput>
<div class="SubNav">
<form method="get" action="">
<span class="SubNavTitle">Payment Categories: </span>
<b>Transaction Type: </b>
<select name="paymentCategoryType" size="1" class="TableText" onChange="window.open(this.options[this.selectedIndex].value,'_main')">
<cfloop Index="count" From="1" To="#ListLen(Variables.paymentCategoryTypeList_label)#">
	<option value="index.cfm?method=paymentCategory.listPaymentCategories&paymentCategoryType=#ListGetAt(Variables.paymentCategoryTypeList_value, count)#"<cfif URL.paymentCategoryType is ListGetAt(Variables.paymentCategoryTypeList_value, count)> selected</cfif>>#HTMLEditFormat(ListGetAt(Variables.paymentCategoryTypeList_label, count))#</option>
</cfloop>
</select><br>
<cfif Application.fn_IsUserAuthorized("listPaymentCategories")><a href="index.cfm?method=paymentCategory.listPaymentCategories&paymentCategoryType=#URL.paymentCategoryType#" title="List existing categories for this payment type" class="SubNavLink<cfif Variables.doAction is "listPaymentCategories">On</cfif>">List Categories For Payment Type</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertPaymentCategory")> | <a href="index.cfm?method=paymentCategory.insertPaymentCategory&paymentCategoryType=#URL.paymentCategoryType#" title="Create new category for this payment type" class="SubNavLink<cfif Variables.doAction is "insertPaymentCategory">On</cfif>">Create New Category For Payment Type</a></cfif>
</div><br>
</form>
</cfoutput>

