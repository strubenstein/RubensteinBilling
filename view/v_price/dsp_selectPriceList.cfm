<cfoutput>
<cfif qry_selectPriceList.RecordCount is 0>
	<p class="ErrorMessage">There are no custom prices for 
	<cfif IsDefined("URL.groupID")>this group
	<cfelseif IsDefined("URL.userID")>this user
	<cfelseif IsDefined("URL.companyID")>this company
	<cfelseif URL.categoryID is not 0>this category
	<cfelseif URL.productID is not 0>this product
	<cfelse>all products or to the entire invoice</cfif>
	 at this time.</p>
<cfelse>
	<script language="JavaScript">
	function toggle(target)
	{ obj=(document.all) ? document.all[target] : document.getElementById(target);
	  obj.style.display=(obj.style.display=='none') ? 'inline' : 'none';
	}
	
	var clicks = 0;
	function ChangeText(obj, originalText, clickText)
	{
		if(clicks == 0)
		{
			obj.innerHTML = clickText;
			clicks = 1;
		}
		else
		{
			obj.innerHTML = originalText;
			clicks = 0;
		}	
	}
	</script>

	<p class="MainText">Below are the custom prices for 
	<cfif IsDefined("URL.groupID")>this group.
	<cfelseif IsDefined("URL.userID")>this user.
	<cfelseif IsDefined("URL.companyID")>this company.
	<cfelseif URL.categoryID is not 0>this category.
	<cfelseif URL.productID is not 0>this product.
	<cfelse>all products or to the entire invoice.
	</cfif>
	<br>To display the price targets and volume discount details, click &quot;Show Details&quot;.
	<cfif IsDefined("URL.priceID")>
		<br>The green highlighted price indicates the custom price you requested to view.
	</cfif>
	</p>

	<!--- <cfset Variables.toggleList = "toggle('price" & Replace(ValueList(qry_selectPriceList.priceID), ",", "');toggle('price", "ALL") & "')"> --->
	<cfparam Name="URL.showDetails" Default="False">
	<cfif URL.showDetails is False>
		<cfset Variables.showText = "Show Details">
		<cfset Variables.hideText = "Hide Details">
	<cfelse>
		<cfset Variables.showText = "Hide Details">
		<cfset Variables.hideText = "Show Details">
	</cfif>
	<div class="MainText">
	[<a href="#Variables.queryViewAction#&showDetails=True" class="plainlink"><cfif URL.showDetails is True><b>Show All Details</b><cfelse>Show All Details</cfif></a>] 
	[<a href="#Variables.queryViewAction#&showDetails=False" class="plainlink"><cfif URL.showDetails is False><b>Hide All Details</b><cfelse>Hide All Details</cfif></a>]
	</div>
	<!--- <cfset Variables.toggleList = "toggle('price" & Replace(ValueList(qry_selectPriceList.priceID), ",", "');toggle('price", "ALL") & "')"> --->

	<cfif URL.productID gt 0>
		<p class="MainText"><b>Normal Price: $#Application.fn_LimitPaddedDecimalZerosDollar(Variables.normalPrice)#</b></p>
	</cfif>

	#fn_DisplayCurrentRecordNumbers(Variables.queryViewAction, Form.queryOrderBy, "<br>", Variables.priceColumnCount, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.priceColumnList, "", True)#
	<cfset Variables.rowBG = 1>
	<cfloop Query="qry_selectPriceList">
		<cfset Variables.currentPriceID = qry_selectPriceList.priceID>
		<cfset Variables.currentPriceStageID = qry_selectPriceList.priceStageID>
		<cfif CurrentRow is 1 or qry_selectPriceList.priceID is not qry_selectPriceList.priceID[CurrentRow - 1]>
			<cfset Variables.rowBG = Iif(Variables.rowBG is 1, 0, 1)>
			<tr class="TableText" valign="top"<cfif Variables.rowBG is 1> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
			<cfif Variables.displayPriceCode is True>
				<td><cfif qry_selectPriceList.priceCode is "">-<cfelse>#qry_selectPriceList.priceCode#<cfif qry_selectPriceList.priceCodeRequired is 1><div class="SmallText" align="center">(Required)</div></cfif></cfif></td>
				<td>&nbsp;</td>
			</cfif>
			<td><cfif qry_selectPriceList.priceName is "">(<i>No Name</i>)<cfelse>#qry_selectPriceList.priceName#</cfif></td>
			<td>&nbsp;</td>
			<td>
				<cfif qry_selectPriceList.priceHasMultipleStages is 0>
					#fn_DisplayPriceAmount(qry_selectPriceList.productPrice, qry_selectPriceList.priceStageAmount, qry_selectPriceList.priceStageDollarOrPercent, qry_selectPriceList.priceStageNewOrDeduction, qry_selectPriceList.priceStageVolumeDiscount, qry_selectPriceList.priceStageVolumeDollarOrQuantity, qry_selectPriceList.priceStageVolumeStep)#
				<cfelse>
					<table border="0" cellspacing="0" cellpadding="0">
					<tr><td class="SmallText">Stage ###qry_selectPriceList.priceStageOrder#</i> - #fn_ReturnPriceInterval(qry_selectPriceList.priceStageInterval, qry_selectPriceList.priceStageIntervalType)#</td></tr>
					<tr><td class="TableText">#fn_DisplayPriceAmount(qry_selectPriceList.productPrice, qry_selectPriceList.priceStageAmount, qry_selectPriceList.priceStageDollarOrPercent, qry_selectPriceList.priceStageNewOrDeduction, qry_selectPriceList.priceStageVolumeDiscount, qry_selectPriceList.priceStageVolumeDollarOrQuantity, qry_selectPriceList.priceStageVolumeStep)#</td></tr>
					<cfloop Index="priceRow" From="#IncrementValue(qry_selectPriceList.CurrentRow)#" To="#qry_selectPriceList.RecordCount#">
						<cfif qry_selectPriceList.priceID[priceRow] is not Variables.currentPriceID><cfbreak></cfif>
						<tr><td class="SmallText" height="3"><img src="#Application.billingUrlroot#/images/aline.gif" width="125" height="1" alt="" border="0"></td></tr>
						<tr><td class="SmallText">Stage ###qry_selectPriceList.priceStageOrder[priceRow]# - #fn_ReturnPriceInterval(qry_selectPriceList.priceStageInterval[priceRow], qry_selectPriceList.priceStageIntervalType[priceRow])#</td></tr>
						<tr><td class="TableText">#fn_DisplayPriceAmount(qry_selectPriceList.productPrice[priceRow], qry_selectPriceList.priceStageAmount[priceRow], qry_selectPriceList.priceStageDollarOrPercent[priceRow], qry_selectPriceList.priceStageNewOrDeduction[priceRow], qry_selectPriceList.priceStageVolumeDiscount[priceRow], qry_selectPriceList.priceStageVolumeDollarOrQuantity[priceRow], qry_selectPriceList.priceStageVolumeStep[priceRow])#</td></tr>
					</cfloop>
					</table>
				</cfif>
			</td>
			<td>&nbsp;</td>
			<td nowrap>#DateFormat(qry_selectPriceList.priceDateBegin, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectPriceList.priceDateBegin, "hh:mm tt")#</div></td>
			<td>&nbsp;</td>
			<td nowrap><cfif Not IsDate(qry_selectPriceList.priceDateEnd)>-<cfelse>#DateFormat(qry_selectPriceList.priceDateEnd, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectPriceList.priceDateEnd, "hh:mm tt")#</div></cfif></td>
			<td>&nbsp;</td>
			<td>
				<cfif qry_selectPriceList.priceStatus is 0>
					<font color="red">Inactive</font>
				<cfelse>
					<font color="green">Active</font>
					<cfif ListFind(Variables.permissionActionList, "updatePriceStatus")>
						<div class="SmallText"><a href="index.cfm?method=#Variables.priceControl#.updatePriceStatus#Variables.urlParameters#&priceID=#qry_selectPriceList.priceID#" class="plainlink">Make Inactive</a></div>
					</cfif>
				</cfif>
			</td>
			<td>&nbsp;</td>
			<td><cfif qry_selectPriceList.priceAppliedStatus is 0>-<cfelse>Yes</cfif></td>
			<td>&nbsp;</td>
			<td nowrap>#DateFormat(qry_selectPriceList.priceDateCreated, "mm-dd-yy")#</td>
			<td>&nbsp;</td>
			<td nowrap><cfif qry_selectPriceList.priceStatus is 1>-<cfelse>#DateFormat(qry_selectPriceList.priceDateUpdated, "mm-dd-yy")#</cfif></td>
			<td>&nbsp;</td>
			<td class="SmallText">
				<cfif ListFind(Variables.permissionActionList, "viewPrice")><a href="index.cfm?method=#Variables.priceControl#.viewPrice#Variables.urlParameters#&priceID=#qry_selectPriceList.priceID#" class="plainlink">Manage</a><br></cfif>
				<a href="javascript:void(0);" class="plainlink" onClick="toggle('price#qry_selectPriceList.priceID#');ChangeText(this,'#Variables.showText#', '#Variables.hideText#');">#Variables.showText#</a>
			</td>
			</tr>

			<tr id="price#qry_selectPriceList.priceID#"<cfif URL.showDetails is False> style="display:none;"</cfif> valign="top"<cfif Variables.rowBG is 1> bgcolor="f4f4ff"</cfif>>
			<td <cfif Variables.displayPriceCode is True>colspan="7"<cfelse>colspan="5"</cfif>>
				<cfif Variables.isVolumeDiscount is True>
					<cfloop Index="priceRow" From="#qry_selectPriceList.CurrentRow#" To="#qry_selectPriceList.RecordCount#">
						<cfif qry_selectPriceList.priceID[priceRow] is not Variables.currentPriceID><cfbreak></cfif>
						<cfset Variables.volumeDiscountRowStart = ListFind(ValueList(qry_selectPriceVolumeDiscount.priceStageID), qry_selectPriceList.priceStageID[priceRow])>
						<cfif Variables.volumeDiscountRowStart gt 0>
							<cfset Variables.volumeDollarOrQuantity = qry_selectPriceList.priceStageVolumeDollarOrQuantity[priceRow]>
							<cfset Variables.volumeStep = qry_selectPriceList.priceStageVolumeStep[priceRow]>
							<cfset Variables.dollarOrPercent = qry_selectPriceList.priceStageDollarOrPercent[priceRow]>
							<cfset Variables.newOrDeduction = qry_selectPriceList.priceStageNewOrDeduction[priceRow]>

							<cfset Variables.displayCustomPriceCalc = False>
							<cfset Variables.displayIsTotalPrice = False>
							<cfif qry_selectPriceList.productID[priceRow] is not 0 and IsNumeric(qry_selectPriceList.productPrice[priceRow])>
								<cfif Variables.dollarOrPercent is 1 or Variables.newOrDeduction is 1>
									<cfset Variables.displayCustomPriceCalc = True>
								</cfif>
								<cfif Variables.volumeStep is 1 and Variables.dollarOrPercent is 0 and Variables.newOrDeduction is 0>
									<cfset Variables.displayIsTotalPrice = True>
								</cfif>
							</cfif>
							<table border="1" cellspacing="0" cellpadding="0">
							<cfif qry_selectPriceList.priceHasMultipleStages[priceRow] is 1>
								<tr valign="bottom" class="TableHeader">
									<th colspan="4"><i>Stage ###qry_selectPriceList.priceStageOrder[priceRow]#</i> - #fn_ReturnPriceInterval(qry_selectPriceList.priceStageInterval[priceRow], qry_selectPriceList.priceStageIntervalType[priceRow])#</th>
								</tr>
							</cfif>
							<tr valign="bottom" class="TableHeader">
								<th>Min. <cfif Variables.volumeDollarOrQuantity is 0>Order ($)<cfelse>Quantity (##)</cfif></th>
								<th><cfswitch expression="#Variables.dollarOrPercent#_#Variables.newOrDeduction#"><cfcase value="0_0">Custom Price ($)</cfcase><cfcase value="0_1">$ Discount</cfcase><cfcase value="1_0">% of Normal Price</cfcase><cfdefaultcase><!--- 1_1 --->% Discount</cfdefaultcase></cfswitch></th>
								<cfif Variables.displayCustomPriceCalc is True><th>Custom Price</th></cfif>
								<cfif Variables.displayIsTotalPrice is True><th>Total Price?</th></cfif>
							</tr>
							<cfset Variables.currentPriceStageID = qry_selectPriceList.priceStageID[priceRow]>
							<cfloop Query="qry_selectPriceVolumeDiscount" StartRow="#Variables.volumeDiscountRowStart#">
								<cfif qry_selectPriceVolumeDiscount.priceStageID is not Variables.currentPriceStageID><cfbreak></cfif>
								<tr class="TableText" valign="top" align="center">
								<td><cfif Variables.volumeDollarOrQuantity is 0>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum)#<cfelse>#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceVolumeDiscount.priceVolumeDiscountQuantityMinimum)#</cfif></td>
								<td><cfif Variables.dollarOrPercent is 0>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount)#<cfelse>#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount * 100)#%</cfif><br></td>
								<!--- #fn_DisplayVolumePriceAmount(Variables.normalPrice, qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount, Variables.dollarOrPercent, Variables.newOrDeduction, 0, Variables.volumeDollarOrQuantity, Variables.volumeStep)# --->
								<cfif Variables.displayCustomPriceCalc is True>
									<td>#fn_DisplayVolumePriceCustom(qry_selectPriceList.productPrice[priceRow], qry_selectPriceVolumeDiscount.priceVolumeDiscountAmount, Variables.dollarOrPercent, Variables.newOrDeduction, 0, Variables.volumeDollarOrQuantity, Variables.volumeStep)#</td>
								</cfif>
								<cfif Variables.displayIsTotalPrice is True>
									<td align="center"><cfif qry_selectPriceVolumeDiscount.priceVolumeDiscountIsTotalPrice is 1>Yes<cfelse>-</cfif></td>
								</cfif>
								</tr>
							</cfloop>
							</table>
						</cfif>
					</cfloop>
				</cfif>
			</td>
			<td class="SmallText" colspan="#DecrementValue(Variables.priceColumnCount)#">
				Created by #qry_selectPriceList.firstName# #qry_selectPriceList.lastName#.<br>
				<cfif qry_selectPriceList.priceAppliesToAllCustomers is 1>Applies to all customers.<br></cfif>
				<cfif qry_selectPriceList.priceAppliesToAllProducts is 1>
					Applies to all products.<br>
				<cfelseif qry_selectPriceList.priceAppliesToInvoice is 1>
					Applies to entire invoice.<br>
				<cfelseif qry_selectPriceList.priceAppliesToCategory is 1>
					Applies to category <cfif qry_selectPriceList.priceAppliesToCategoryChildren is 1> and sub-categories</cfif>.<br>
					<cfif qry_selectPriceList.categoryName is not ""><i>#qry_selectPriceList.categoryName#</i></cfif>
				<cfelseif qry_selectPriceList.priceAppliesToProduct is 1>
					Applies to product <cfif qry_selectPriceList.priceAppliesToProductChildren is 1> and child products</cfif>.<br>
					<cfif IsNumeric(qry_selectPriceList.productPrice)>Normal Price: $#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectPriceList.productPrice)#<br></cfif>
					<cfif qry_selectPriceList.productName is not "">
						<i>#qry_selectPriceList.productName#</i><cfif ListFind(Variables.permissionActionList, "viewProduct")> (<a href="index.cfm?method=product.viewProduct&productID=#qry_selectPriceList.productID#" class="plainlink">go</a>)</cfif><br>
					</cfif>
					<cfif qry_selectPriceList.priceQuantityMinimumPerOrder is not 0>Min. Qty Per Order: #Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceList.priceQuantityMinimumPerOrder)#.<br></cfif>
					<cfif qry_selectPriceList.priceQuantityMaximumPerCustomer is not 0>Max. Qty Per Customer: #Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceList.priceQuantityMaximumPerCustomer)#.<br></cfif>
					<cfif qry_selectPriceList.priceQuantityMaximumAllCustomers is not 0>Max. Qty All Customers: #Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceList.priceQuantityMaximumAllCustomers)#.<br></cfif>
				</cfif>
				<cfif qry_selectPriceList.priceDescription is not ""><br><i>Description</i>: #qry_selectPriceList.priceDescription#</cfif>
			</td>
			</tr>
		</cfif>
	</cfloop>
	#fn_DisplayOrderByPages(Variables.priceColumnCount, Variables.queryViewAction_orderBy, Form.queryDisplayPerPage, Form.queryPage, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.totalPages, False, "")#
</cfif>
</cfoutput>
