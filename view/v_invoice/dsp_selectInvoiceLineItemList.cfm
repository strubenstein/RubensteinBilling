<!--- parameters, parameter exceptions, real invoice totals --->

<cfset Variables.activeTotalQuantity = 0>
<cfset Variables.activeTotalSubTotal = 0>
<cfset Variables.activeTotalTax = 0>
<cfset Variables.activeTotalTotal = 0>
<cfset Variables.activeTotalDiscount = 0>

<cfset Variables.inactiveTotalQuantity = 0>
<cfset Variables.inactiveTotalSubTotal = 0>
<cfset Variables.inactiveTotalTax = 0>
<cfset Variables.inactiveTotalTotal = 0>
<cfset Variables.inactiveTotalDiscount = 0>

<cfoutput>
<p class="MainText">Note: <i>Updating</i> an existing line item means making the current line item inactive and creating a new one in its place.<br>
<i>Copying</i> a line item means to use the current settings of that line item (including product and pricing info) to create a new line item.</p>

#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.invoiceLineItemColumnCount, 0, 0, 0, Variables.invoiceLineItemColumnList, "", True)#
<cfloop Query="qry_selectInvoiceLineItemList">
	<cfif qry_selectInvoiceLineItemList.invoiceLineItemDescription is not "" or qry_selectInvoiceLineItemList.priceStageText is not ""><cfset Variables.showDescription = True><cfelse><cfset Variables.showDescription = False></cfif>
	<cfif (CurrentRow mod 2) is 0><cfset Variables.bgcolor = "f4f4ff"><cfelse><cfset Variables.bgcolor = "ffffff"></cfif>
	<tr class="TableText" valign="top" id="row#CurrentRow#" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'#Variables.showDescription#');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'#Variables.showDescription#','#Variables.bgcolor#');">
	<td align="right">#qry_selectInvoiceLineItemList.invoiceLineItemOrder#</td>
	<cfif Variables.displayProductID_custom is True>
		<td>&nbsp;</td>
		<td><cfif qry_selectInvoiceLineItemList.invoiceLineItemProductID_custom is "">&nbsp;<cfelse>#qry_selectInvoiceLineItemList.invoiceLineItemProductID_custom#</cfif></td>
	</cfif>
	<cfif Variables.displayVendor is True>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectInvoiceLineItemList.vendorID is 0>
				&nbsp;
			<cfelse>
				<cfset Variables.vendorRow = ListFind(ValueList(qry_selectVendorList.vendorID), qry_selectInvoiceLineItemList.vendorID)>
				<cfif Variables.vendorRow is 0>
					&nbsp;
				<cfelse>
					#qry_selectVendorList.vendorName[Variables.vendorRow]#
					<cfif ListFind(Variables.permissionActionList, "viewVendor")> (<a href="index.cfm?method=vendor.viewVendor&vendorID=#qry_selectInvoiceLineItemList.vendorID#" class="plainlink">go</a>)</cfif>
				</cfif>
			</cfif>
		</td>
	</cfif>
	<td>&nbsp;</td>
	<td>
		<cfif qry_selectInvoiceLineItemList.productID is 0>
			#qry_selectInvoiceLineItemList.invoiceLineItemName# (<font class="SmallText"><i>custom</i></font>)
		<cfelse>
			#qry_selectInvoiceLineItemList.invoiceLineItemName#
			<cfif ListFind(Variables.permissionActionList, "viewProduct")> (<a href="index.cfm?method=product.viewProduct&productID=#qry_selectInvoiceLineItemList.productID#" class="plainlink">go</a>)</cfif>
		</cfif>
	</td>
	<cfif Variables.displayBundle is True>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectInvoiceLineItemList.invoiceLineItemProductIsBundle is 1>
				Is A<br>Bundle
			<cfelseif qry_selectInvoiceLineItemList.invoiceLineItemProductInBundle is 1>
				In Bundle
			<cfelse>
				&nbsp;
			</cfif>
		</td>
	</cfif>
	<td>&nbsp;</td>
	<td>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectInvoiceLineItemList.invoiceLineItemPriceNormal)#</td>
	<td>&nbsp;</td>
	<td>
		$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectInvoiceLineItemList.invoiceLineItemPriceUnit)#
		<cfif qry_selectInvoiceLineItemList.priceID is not 0 and ListFind(Variables.permissionActionList, "listPrices")>
			(<a href="index.cfm?method=product.listPrices&productID=#qry_selectInvoiceLineItemList.productID#&priceID=#qry_selectInvoiceLineItemList.priceID#" class="plainlink">go</a>)
		</cfif>
	</td>
	<td>&nbsp;</td>
	<td align="right">#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectInvoiceLineItemList.invoiceLineItemQuantity)# &nbsp;</td>
	<td>&nbsp;</td>
	<td align="right">$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectInvoiceLineItemList.invoiceLineItemSubTotal)#</td>
	<td>&nbsp;</td>
	<td align="right">($#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectInvoiceLineItemList.invoiceLineItemDiscount)#)</td>
	<td>&nbsp;</td>
	<td align="right">$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectInvoiceLineItemList.invoiceLineItemTotalTax)#</td>
	<td>&nbsp;</td>
	<td align="right">$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectInvoiceLineItemList.invoiceLineItemTotal)#</td>
	<!--- 
	<td>&nbsp;</td>
	<td><cfif qry_selectInvoiceLineItemList.invoiceLineItemManual is 0>&nbsp;<cfelse>Manual</cfif></td>
	<td>&nbsp;</td>
	<td class="SmallText"><cfif qry_selectInvoiceLineItemList.userID_author is 0><div align="center">-</div><cfelse>#qry_selectInvoiceLineItemList.authorFirstName# #qry_selectInvoiceLineItemList.authorLastName#</cfif></td>
	<td>&nbsp;</td>
	<td nowrap>#DateFormat(qry_selectInvoiceLineItemList.invoiceLineItemDateCreated, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectInvoiceLineItemList.invoiceLineItemDateCreated, "hh:mm tt")#</div></td>
	--->
	<cfif Variables.doAction is "viewInvoiceLineItemsAll" or ListFind(Variables.permissionActionList, "updateInvoiceLineItemStatus")>
		<td>&nbsp;</td>
		<td class="SmallText">
			<cfif qry_selectInvoiceLineItemList.invoiceLineItemStatus is 0>
				<font class="TableText"><font color="red">Inactive</font></font>
			<cfelseif ListFind(Variables.permissionActionList, "updateInvoiceLineItem")>
				<a href="index.cfm?method=invoice.updateInvoiceLineItemStatus&invoiceID=#URL.invoiceID#&invoiceLineItemID=#qry_selectInvoiceLineItemList.invoiceLineItemID#&redirectAction=#Variables.doAction#" class="plainlink" onmouseout="window.status=''; return true;" onmouseover="window.status='Verify Request'; return true;" title="Verify Request" onclick="return confirm('Are you sure you want to make this line item inactive?');">Make<br>Inactive</a>
			<cfelse>
				<font class="TableText"><font color="green">Active</font></font>
			</cfif>
		</td>
	</cfif>
	<!--- 
	<cfif Variables.doAction is "viewInvoiceLineItemsAll">
		<td>&nbsp;</td>
		<td nowrap><cfif qry_selectInvoiceLineItemList.invoiceLineItemStatus is 1>-<cfelse>#DateFormat(qry_selectInvoiceLineItemList.invoiceLineItemDateUpdated, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectInvoiceLineItemList.invoiceLineItemDateUpdated, "hh:mm tt")#</div></cfif></td>
		<td>&nbsp;</td>
		<td class="SmallText"><cfif qry_selectInvoiceLineItemList.userID_cancel is 0>-<cfelse>#qry_selectInvoiceLineItemList.cancelFirstName# #qry_selectInvoiceLineItemList.cancelLastName#</cfif></td>
	<cfelseif ListFind(Variables.permissionActionList, "moveInvoiceLineItemUp") and ListFind(Variables.permissionActionList, "moveInvoiceLineItemDown")>
	--->
	<cfif Variables.doAction is not "viewInvoiceLineItemsAll" and ListFind(Variables.permissionActionList, "moveInvoiceLineItemUp") and ListFind(Variables.permissionActionList, "moveInvoiceLineItemDown")>
		<td>&nbsp;</td>
		<td>
			<cfif CurrentRow is RecordCount>
				<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
			<cfelse>
				<a href="index.cfm?method=invoice.moveInvoiceLineItemDown&invoiceID=#URL.invoiceID#&invoiceLineItemID=#qry_selectInvoiceLineItemList.invoiceLineItemID#"><img src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0"></a>
			</cfif>
			<cfif CurrentRow is 1>
				<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
			<cfelse>
				<a href="index.cfm?method=invoice.moveInvoiceLineItemUp&invoiceID=#URL.invoiceID#&invoiceLineItemID=#qry_selectInvoiceLineItemList.invoiceLineItemID#"><img src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0"></a>
			</cfif>
		</td>
	</cfif>
	<cfif ListFind(Variables.permissionActionList, "updateInvoiceLineItem") or ListFind(Variables.permissionActionList, "insertInvoiceLineItem") or ListFind(Variables.permissionActionList, "viewInvoiceLineItem")>
		<td>&nbsp;</td>
		<td class="SmallText">
			<cfif ListFind(Variables.permissionActionList, "viewInvoiceLineItem")>
				<a href="index.cfm?method=invoice.viewInvoiceLineItem&invoiceID=#URL.invoiceID#&invoiceLineItemID=#qry_selectInvoiceLineItemList.invoiceLineItemID#" class="plainlink">View</a><br>
			</cfif>
			<cfif ListFind(Variables.permissionActionList, "updateInvoiceLineItem")>
				<cfif qry_selectInvoiceLineItemList.invoiceLineItemStatus is 0>-<cfelse><a href="index.cfm?method=invoice.updateInvoiceLineItem&invoiceID=#URL.invoiceID#&invoiceLineItemID=#qry_selectInvoiceLineItemList.invoiceLineItemID#" class="plainlink">Update</a></cfif><br>
			</cfif> 
			<cfif ListFind(Variables.permissionActionList, "insertInvoiceLineItem")>
				<a href="index.cfm?method=invoice.insertInvoiceLineItem&invoiceID=#URL.invoiceID#&invoiceLineItemID=#qry_selectInvoiceLineItemList.invoiceLineItemID#" class="plainlink">Copy</a><br>
			</cfif>
		</td>
	</cfif>
	</tr>
	<cfif Variables.showDescription is True>
		<tr class="TableText" valign="top" id="row#CurrentRow#a" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'True');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'True','#Variables.bgcolor#');">
		<td colspan="2">&nbsp;</td>
		<td colspan="#Variables.totalColspan + 28#">
			<cfif qry_selectInvoiceLineItemList.priceStageText is not "">
				<div class="SmallText"><i>Price</i>: #qry_selectInvoiceLineItemList.priceStageText#</div>
			</cfif>
			<cfif qry_selectInvoiceLineItemList.invoiceLineItemDescription is not "">
				<i>Description</i>: 
				<cfif qry_selectInvoiceLineItemList.invoiceLineItemDescriptionHtml is 1>
					#qry_selectInvoiceLineItemList.invoiceLineItemDescription#
				<cfelse>
					#Replace(qry_selectInvoiceLineItemList.invoiceLineItemDescription, Chr(10), "<br>", "ALL")#
				</cfif>
			</cfif>
		</td>
		</tr>
	</cfif>

	<cfif qry_selectInvoiceLineItemList.invoiceLineItemStatus is 1>
		<cfset Variables.activeTotalQuantity = Variables.activeTotalQuantity + qry_selectInvoiceLineItemList.invoiceLineItemQuantity>
		<cfset Variables.activeTotalSubTotal = Variables.activeTotalSubTotal + qry_selectInvoiceLineItemList.invoiceLineItemSubTotal>
		<cfset Variables.activeTotalTax = Variables.activeTotalTax + qry_selectInvoiceLineItemList.invoiceLineItemTotalTax>
		<cfset Variables.activeTotalTotal = Variables.activeTotalTotal + qry_selectInvoiceLineItemList.invoiceLineItemTotal>
		<cfset Variables.activeTotalDiscount = Variables.activeTotalDiscount + qry_selectInvoiceLineItemList.invoiceLineItemDiscount>
	<cfelse>
		<cfset Variables.inactiveTotalQuantity = Variables.inactiveTotalQuantity + qry_selectInvoiceLineItemList.invoiceLineItemQuantity>
		<cfset Variables.inactiveTotalSubTotal = Variables.inactiveTotalSubTotal + qry_selectInvoiceLineItemList.invoiceLineItemSubTotal>
		<cfset Variables.inactiveTotalTax = Variables.inactiveTotalTax + qry_selectInvoiceLineItemList.invoiceLineItemTotalTax>
		<cfset Variables.inactiveTotalTotal = Variables.inactiveTotalTotal + qry_selectInvoiceLineItemList.invoiceLineItemTotal>
		<cfset Variables.inactiveTotalDiscount = Variables.inactiveTotalDiscount + qry_selectInvoiceLineItemList.invoiceLineItemDiscount>
	</cfif>
</cfloop>

<tr bgcolor="66FF99" class="MainText">
	<td colspan="#Variables.totalColspan#" align="right"><cfif Variables.inactiveTotalTotal is not 0><b>Active Line Items: </b></cfif> &nbsp; &nbsp; </td>
	<td nowrap align="right"><b>#Application.fn_LimitPaddedDecimalZerosQuantity(Variables.activeTotalQuantity)#</b> &nbsp;</td>
	<td>&nbsp;</td>
	<td align="right"><b>$#Application.fn_LimitPaddedDecimalZerosDollar(Variables.activeTotalSubTotal)#</b></td>
	<td>&nbsp;</td>
	<td align="right"><b>($#Application.fn_LimitPaddedDecimalZerosDollar(Variables.activeTotalDiscount)#)</b></td>
	<td>&nbsp;</td>
	<td align="right"><b>$#Application.fn_LimitPaddedDecimalZerosDollar(Variables.activeTotalTax)#</b></td>
	<td>&nbsp;</td>
	<td align="right"><b>$#Application.fn_LimitPaddedDecimalZerosDollar(Variables.activeTotalTotal)#</b></td>
	<td colspan="14">&nbsp;</td>
</tr>
<cfif Variables.inactiveTotalTotal is not 0>
	<tr bgcolor="DC143C" class="MainText">
		<td colspan="#Variables.totalColspan#" align="right"><b>Inactive Line Items: </b> &nbsp; &nbsp; </td>
		<td align="right"><b>#Application.fn_LimitPaddedDecimalZerosQuantity(Variables.inactiveTotalQuantity)# &nbsp;</b></td>
		<td>&nbsp;</td>
		<td align="right"><b>$#Application.fn_LimitPaddedDecimalZerosDollar(Variables.inactiveTotalSubTotal)#</b></td>
		<td>&nbsp;</td>
		<td align="right"><b>($#Application.fn_LimitPaddedDecimalZerosDollar(Variables.inactiveTotalDiscount)#)</b></td>
		<td>&nbsp;</td>
		<td align="right"><b>$#Application.fn_LimitPaddedDecimalZerosDollar(Variables.inactiveTotalTax)#</b></td>
		<td>&nbsp;</td>
		<td align="right"><b>$#Application.fn_LimitPaddedDecimalZerosDollar(Variables.inactiveTotalTotal)#</b></td>
		<td colspan="16">&nbsp;</td>
	</tr>
	<tr bgcolor="FFFF66" class="MainText">
		<td colspan="#Variables.totalColspan#" align="right"><b>All Line Items: </b> &nbsp; &nbsp; </td>
		<td align="right"><b>#Application.fn_LimitPaddedDecimalZerosQuantity(Variables.activeTotalQuantity + Variables.inactiveTotalQuantity)#</b> &nbsp;</td>
		<td>&nbsp;</td>
		<td align="right"><b>$#Application.fn_LimitPaddedDecimalZerosDollar(Variables.activeTotalSubTotal + Variables.inactiveTotalSubTotal)#</b></td>
		<td>&nbsp;</td>
		<td align="right"><b>($#Application.fn_LimitPaddedDecimalZerosDollar(Variables.activeTotalDiscount + Variables.inactiveTotalDiscount)#)</b></td>
		<td>&nbsp;</td>
		<td align="right"><b>$#Application.fn_LimitPaddedDecimalZerosDollar(Variables.activeTotalTax + Variables.inactiveTotalTax)#</b></td>
		<td>&nbsp;</td>
		<td align="right"><b>$#Application.fn_LimitPaddedDecimalZerosDollar(Variables.activeTotalTotal + Variables.inactiveTotalTotal)#</b></td>
		<td colspan="14">&nbsp;</td>
	</tr>
</cfif>
</table>
</cfoutput>