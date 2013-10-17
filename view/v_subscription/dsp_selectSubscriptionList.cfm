<!--- parameters, parameter exceptions, real totals --->

<cfset Variables.activeTotalQuantity = 0>
<cfset Variables.activeTotalSubTotal = 0>
<!--- <cfset Variables.activeTotalTax = 0> --->
<cfset Variables.activeTotalTotal = 0>
<cfset Variables.activeTotalDiscount = 0>

<cfset Variables.inactiveTotalQuantity = 0>
<cfset Variables.inactiveTotalSubTotal = 0>
<!--- <cfset Variables.inactiveTotalTax = 0> --->
<cfset Variables.inactiveTotalTotal = 0>
<cfset Variables.inactiveTotalDiscount = 0>

<cfoutput>
<p class="MainText">Note: <i>Updating</i> an existing subscription means making the current subscription inactive and creating a new one in its place.<br>
<i>Copying</i> a subscription means to use the current settings of that subscription (including product and pricing info) to create a new subscription.</p>

#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.subscriptionColumnCount, 0, 0, 0, Variables.subscriptionColumnList, "", True)#
<cfloop Query="qry_selectSubscriptionList">
	<cfset Variables.subscriptionSubTotal = qry_selectSubscriptionList.subscriptionQuantity * qry_selectSubscriptionList.subscriptionPriceUnit>
	<cfset Variables.subscriptionTotal = Variables.subscriptionSubTotal - qry_selectSubscriptionList.subscriptionDiscount>
	<cfif (CurrentRow mod 2) is 0><cfset Variables.bgcolor = "f4f4ff"><cfelse><cfset Variables.bgcolor = "ffffff"></cfif>
	<tr class="TableText" valign="top" id="row#CurrentRow#" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'True');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'True','#Variables.bgcolor#');">
	<td align="right">#qry_selectSubscriptionList.subscriptionOrder#.</td>
	<cfif Variables.displaySubscriptionID_custom is True>
		<td>&nbsp;</td>
		<td><cfif qry_selectSubscriptionList.subscriptionID_custom is "">-<cfelse>#qry_selectSubscriptionList.subscriptionID_custom#</cfif></td>
	</cfif>
	<!--- 
	<cfif Variables.displayProductID_custom is True>
		<td>&nbsp;</td>
		<td><cfif qry_selectSubscriptionList.subscriptionProductID_custom is "">&nbsp;<cfelse>#qry_selectSubscriptionList.subscriptionProductID_custom#</cfif></td>
	</cfif>
	--->
	<!--- 
	<td>&nbsp;</td>
	<td>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectSubscriptionList.subscriptionPriceNormal)#</td>
	--->
	<td>&nbsp;</td>
	<td>
		<cfif qry_selectSubscriptionList.subscriptionID_rollup is not 0>
			<div class="SmallText">Rolls Up</div>
		<cfelse>
			$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectSubscriptionList.subscriptionPriceUnit)#
			<cfif qry_selectSubscriptionList.priceID is not 0 and ListFind(Variables.permissionActionList, "listPrices")>
				<br>(<a href="index.cfm?method=price.listPrices&priceID=#qry_selectSubscriptionList.priceID#" class="plainlink">go</a>)
			</cfif>
		</cfif>
	</td>
	<td>&nbsp;</td>
	<td>
		#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectSubscriptionList.subscriptionQuantity)# &nbsp;
		<cfif qry_selectSubscriptionList.subscriptionQuantityVaries is 1><div class="SmallText" align="center">Varies</div></cfif>
		<cfif qry_selectSubscriptionList.subscriptionIsRollup is 1><div class="SmallText" align="center">Roll To</div></cfif>
	</td>
	<!--- 
	<td>&nbsp;</td>
	<td>#DollarFormat(Variables.subscriptionSubTotal)#</td>
	<td>&nbsp;</td>
	<td>($#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectSubscriptionList.subscriptionDiscount)#)</td>
	--->
	<td>&nbsp;</td>
	<td><cfif qry_selectSubscriptionList.subscriptionID_rollup is not 0>-<cfelse>#DollarFormat(Variables.subscriptionTotal)#</cfif></td>
	<cfif Variables.doAction is "viewSubscriptionsAll" or ListFind(Variables.permissionActionList, "updateSubscription")>
		<td>&nbsp;</td>
		<td align="center" class="SmallText">
			<cfif qry_selectSubscriptionList.subscriptionStatus is 0>
				<font class="TableText"><font color="red">Inactive</font></font><br>
			<cfelseif ListFind(Variables.permissionActionList, "updateSubscription")>
				<cfif Variables.doAction is "viewSubscriptionsAll"><font class="TableText"><font color="green">Active</font></font><br></cfif>
				<a href="index.cfm?method=subscription.updateSubscriptionStatus&subscriberID=#URL.subscriberID#&subscriptionID=#qry_selectSubscriptionList.subscriptionID#&redirectAction=#Variables.doAction#" class="plainlink" onmouseout="window.status=''; return true;" onmouseover="window.status='Verify Request'; return true;" title="Verify Request" onclick="return confirm('Are you sure you want to make this subscription inactive?');">Make<br>Inactive</a>
			<cfelse>
				&nbsp;
			</cfif>
		</td>
	</cfif>
	<td>&nbsp;</td>
	<td nowrap>#DateFormat(qry_selectSubscriptionList.subscriptionDateCreated, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectSubscriptionList.subscriptionDateCreated, "hh:mm tt")#</div></td>
	<cfif Variables.doAction is "viewSubscriptionsAll">
		<td>&nbsp;</td>
		<td nowrap><cfif qry_selectSubscriptionList.subscriptionStatus is 1>-<cfelse>#DateFormat(qry_selectSubscriptionList.subscriptionDateUpdated, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectSubscriptionList.subscriptionDateUpdated, "hh:mm tt")#</div></cfif></td>
	</cfif>
	<td>&nbsp;</td>
	<td nowrap>
		#DateFormat(qry_selectSubscriptionList.subscriptionDateBegin, "mm-dd-yy")#<br>
		<cfif Not IsDate(qry_selectSubscriptionList.subscriptionDateEnd)>-<cfelse>#DateFormat(qry_selectSubscriptionList.subscriptionDateEnd, "mm-dd-yy")#</cfif>
	</td>
	<td>&nbsp;</td>
	<td class="SmallText">
		<cfif qry_selectSubscriptionList.subscriptionEndByDateOrAppliedMaximum is "">
			Continues<br>Indefinitely
		<cfelseif qry_selectSubscriptionList.subscriptionEndByDateOrAppliedMaximum is 1>
			#qry_selectSubscriptionList.subscriptionAppliedMaximum# time(s)
		<cfelse>
			End date
		</cfif>
		<cfif ListFind("0,1", qry_selectSubscriptionList.subscriptionEndByDateOrAppliedMaximum) and qry_selectSubscriptionList.subscriptionContinuesAfterEnd is 1>
			.<br>Continues<br>'til cancel
		</cfif>
		<!--- <cfif qry_selectSubscriptionList.subscriptionAppliedMaximum is not 0>After #qry_selectSubscriptionList.subscriptionAppliedMaximum# time(s)<cfelseif IsDate(qry_selectSubscriptionList.subscriptionDateEnd)>At end date<cfelse>Until<br>cancelled</cfif> --->
	</td>
	<td>&nbsp;</td>
	<td>#qry_selectSubscriptionList.subscriptionAppliedCount#</td>
	<td>&nbsp;</td>
	<cfset Variables.intervalTypePosition = ListFind(Variables.subscriptionIntervalTypeList_value, qry_selectSubscriptionList.subscriptionIntervalType)>
	<td>#qry_selectSubscriptionList.subscriptionInterval# <cfif Variables.intervalTypePosition is 0>#qry_selectSubscriptionList.subscriptionIntervalType#<cfelse>#ListGetAt(Variables.subscriptionIntervalTypeList_label, Variables.intervalTypePosition)#</cfif><cfif qry_selectSubscriptionList.subscriptionInterval gt 1>s</cfif></td>
	<td>&nbsp;</td>
	<td nowrap>
		<cfif Not IsDate(qry_selectSubscriptionList.subscriptionDateProcessLast)>-<cfelse>#DateFormat(qry_selectSubscriptionList.subscriptionDateProcessLast, "mm-dd-yy")#</cfif><br>
		<cfif Not IsDate(qry_selectSubscriptionList.subscriptionDateProcessNext)>-<cfelse>#DateFormat(qry_selectSubscriptionList.subscriptionDateProcessNext, "mm-dd-yy")#</cfif>
	</td>
	<!--- 
	<td>&nbsp;</td>
	<td nowrap><cfif Not IsDate(qry_selectSubscriptionList.subscriptionDateProcessNext)>-<cfelse>#DateFormat(qry_selectSubscriptionList.subscriptionDateProcessNext, "mm-dd-yy")#</cfif></td>
	--->
	<cfif Variables.doAction is not "viewSubscriptionsAll" and ListFind(Variables.permissionActionList, "moveSubscriptionUp") and ListFind(Variables.permissionActionList, "moveSubscriptionDown")>
		<td>&nbsp;</td>
		<td>
			<cfif CurrentRow is RecordCount>
				<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
			<cfelse>
				<a href="index.cfm?method=subscription.moveSubscriptionDown&subscriberID=#URL.subscriberID#&subscriptionID=#qry_selectSubscriptionList.subscriptionID#"><img src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0"></a>
			</cfif>
			<cfif CurrentRow is 1>
				<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
			<cfelse>
				<a href="index.cfm?method=subscription.moveSubscriptionUp&subscriberID=#URL.subscriberID#&subscriptionID=#qry_selectSubscriptionList.subscriptionID#"><img src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0"></a>
			</cfif>
		</td>
	</cfif>
	<cfif ListFind(Variables.permissionActionList, "viewSubscription")>
		<td>&nbsp;</td>
		<td class="SmallText"><a href="index.cfm?method=subscription.viewSubscription&subscriberID=#URL.subscriberID#&subscriptionID=#qry_selectSubscriptionList.subscriptionID#" class="plainlink">Manage</a></td>
	</cfif>
	</tr>

	<tr class="TableText" valign="top" id="row#CurrentRow#a" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'True');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'True','#Variables.bgcolor#');">
	<td colspan="2">&nbsp;</td>
	<td colspan="#Variables.totalColspan + 30#">
		<i>Product</i>: 
		<cfif qry_selectSubscriptionList.subscriptionProductID_custom is not "">#qry_selectSubscriptionList.subscriptionProductID_custom#. </cfif>
		#qry_selectSubscriptionList.subscriptionName#<cfif qry_selectSubscriptionList.productID is 0> (<font class="SmallText"><i>custom</i></font>)<cfelseif ListFind(Variables.permissionActionList, "viewProduct")> (<a href="index.cfm?method=product.viewProduct&productID=#qry_selectSubscriptionList.productID#" class="plainlink">go</a>)</cfif>
		<cfif Variables.displayVendor is True and qry_selectSubscriptionList.vendorID is not 0>
			<cfset Variables.vendorRow = ListFind(ValueList(qry_selectVendorList.vendorID), qry_selectSubscriptionList.vendorID)>
			<cfif Variables.vendorRow is not 0>
				<div class="SmallText"><i>Vendor: </i>
				<cfif Not ListFind(Variables.permissionActionList, "viewVendor")>
					#qry_selectVendorList.vendorName[Variables.vendorRow]#
				<cfelse>
					<a href="index.cfm?method=vendor.viewVendor&vendorID=#qry_selectSubscriptionList.vendorID#" class="plainlink">#qry_selectVendorList.vendorName[Variables.vendorRow]#</a>
				</cfif>
				</div>
			</cfif>
		</cfif>
		<cfif qry_selectSubscriptionList.subscriptionDescription is not "">
			<br><i>Description</i>: 
			<cfif qry_selectSubscriptionList.subscriptionDescriptionHtml is 1>
				#qry_selectSubscriptionList.subscriptionDescription#
			<cfelse>
				#Replace(qry_selectSubscriptionList.subscriptionDescription, Chr(10), "<br>", "ALL")#
			</cfif>
		</cfif>
	</td>
	</tr>

	<cfif qry_selectSubscriptionList.subscriptionStatus is 1>
		<cfset Variables.activeTotalQuantity = Variables.activeTotalQuantity + qry_selectSubscriptionList.subscriptionQuantity>
		<cfset Variables.activeTotalSubTotal = Variables.activeTotalSubTotal + Variables.subscriptionSubTotal>
		<!--- <cfset Variables.activeTotalTax = Variables.activeTotalTax + qry_selectSubscriptionList.subscriptionTotalTax> --->
		<cfset Variables.activeTotalTotal = Variables.activeTotalTotal + Variables.subscriptionTotal>
		<cfset Variables.activeTotalDiscount = Variables.activeTotalDiscount + qry_selectSubscriptionList.subscriptionDiscount>
	<cfelse>
		<cfset Variables.inactiveTotalQuantity = Variables.inactiveTotalQuantity + qry_selectSubscriptionList.subscriptionQuantity>
		<cfset Variables.inactiveTotalSubTotal = Variables.inactiveTotalSubTotal + Variables.subscriptionSubTotal>
		<!--- <cfset Variables.inactiveTotalTax = Variables.inactiveTotalTax + qry_selectSubscriptionList.subscriptionTotalTax> --->
		<cfset Variables.inactiveTotalTotal = Variables.inactiveTotalTotal + Variables.subscriptionTotal>
		<cfset Variables.inactiveTotalDiscount = Variables.inactiveTotalDiscount + qry_selectSubscriptionList.subscriptionDiscount>
	</cfif>
</cfloop>

<!--- if displaying individual line item, do not display totals --->
<cfif IsDefined("URL.subscriptionID") and Application.fn_IsIntegerList(URL.subscriptionID)>
	<tr><td colspan="40"><hr noshade size="1" width="100%"></td></tr>
<cfelse>
	<tr bgcolor="66FF99" class="MainText">
		<td colspan="#Variables.totalColspan#" align="right"><cfif Variables.inactiveTotalTotal is not 0><b>Active Subscriptions: </b></cfif> &nbsp; &nbsp; </td>
		<td><b>#Application.fn_LimitPaddedDecimalZerosQuantity(Variables.activeTotalQuantity)#</b> &nbsp;</td>
		<!--- 
		<td>&nbsp;</td>
		<td><b>$#Application.fn_LimitPaddedDecimalZerosDollar(Variables.activeTotalSubTotal)#</b></td>
		<td>&nbsp;</td>
		<td><b>($#Application.fn_LimitPaddedDecimalZerosDollar(Variables.activeTotalDiscount)#)</b></td>
		<td>&nbsp;</td>
		<td><b>$#Application.fn_LimitPaddedDecimalZerosDollar(Variables.activeTotalTax)#</b></td>
		--->
		<td>&nbsp;</td>
		<td><b>$#Application.fn_LimitPaddedDecimalZerosDollar(Variables.activeTotalTotal)#</b></td>
		<td colspan="24">&nbsp;</td>
	</tr>
	<cfif Variables.inactiveTotalTotal is not 0>
		<tr bgcolor="DC143C" class="MainText">
			<td colspan="#Variables.totalColspan#" align="right"><b>Inactive Line Items: </b> &nbsp; &nbsp; </td>
			<td><b>#Application.fn_LimitPaddedDecimalZerosQuantity(Variables.inactiveTotalQuantity)# &nbsp;</b></td>
			<td>&nbsp;</td>
			<td><b>$#Application.fn_LimitPaddedDecimalZerosDollar(Variables.inactiveTotalSubTotal)#</b></td>
			<td>&nbsp;</td>
			<td><b>($#Application.fn_LimitPaddedDecimalZerosDollar(Variables.inactiveTotalDiscount)#)</b></td>
			<!--- 
			<td>&nbsp;</td>
			<td><b>$#Application.fn_LimitPaddedDecimalZerosDollar(Variables.inactiveTotalTax)#</b></td>
			--->
			<td>&nbsp;</td>
			<td><b>$#Application.fn_LimitPaddedDecimalZerosDollar(Variables.inactiveTotalTotal)#</b></td>
			<td colspan="24">&nbsp;</td>
		</tr>
		<tr bgcolor="FFFF66" class="MainText">
			<td colspan="#Variables.totalColspan#" align="right"><b>All Line Items: </b> &nbsp; &nbsp; </td>
			<td><b>#Application.fn_LimitPaddedDecimalZerosQuantity(Variables.activeTotalQuantity + Variables.inactiveTotalQuantity)#</b> &nbsp;</td>
			<td>&nbsp;</td>
			<td><b>$#Application.fn_LimitPaddedDecimalZerosDollar(Variables.activeTotalSubTotal + Variables.inactiveTotalSubTotal)#</b></td>
			<td>&nbsp;</td>
			<td><b>($#Application.fn_LimitPaddedDecimalZerosDollar(Variables.activeTotalDiscount + Variables.inactiveTotalDiscount)#)</b></td>
			<!--- 
			<td>&nbsp;</td>
			<td><b>$#Application.fn_LimitPaddedDecimalZerosDollar(Variables.activeTotalTax + Variables.inactiveTotalTax)#</b></td>
			--->
			<td>&nbsp;</td>
			<td><b>$#Application.fn_LimitPaddedDecimalZerosDollar(Variables.activeTotalTotal + Variables.inactiveTotalTotal)#</b></td>
			<td colspan="24">&nbsp;</td>
		</tr>
	</cfif>
</cfif>
</table>
</cfoutput>