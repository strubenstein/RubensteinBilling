<!--- The Graphs --->
<cfoutput>
<!--- # and $ of payments by category --->
<cfif qry_selectPaymentList_category.RecordCount gt 1>
	<table border="0" cellspacing="2" cellpadding="2" class="MainText">
	<tr valign="top" align="center">
		<td>
			<b>## of Payments by Payment Category</b><br>
			<cfchart Format="flash" ChartHeight="100" xAxisTitle="" yAxisTitle="" URL="" ShowLegend="Yes" PieSliceStyle="solid">
				<cfchartseries Type="pie" Query="qry_selectPaymentList_category" ItemColumn="paymentCategoryName" ValueColumn="countPayment" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
			</cfchart>
		</td>
		<td>
			<b>Total $ of Payments by Payment Category</b><br>
			<cfchart Format="flash" ChartHeight="100" xAxisTitle="" yAxisTitle="" URL="" ShowLegend="Yes" PieSliceStyle="solid" LabelFormat="currency">
				<cfchartseries Type="pie" Query="qry_selectPaymentList_category" ItemColumn="paymentCategoryName" ValueColumn="sumPaymentAmount" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
			</cfchart>
		</td>
	</tr>
	</table>
	<img src="#Application.billingUrlroot#/images/aline.gif" width="100%" height="1" alt="" border="0">
</cfif>


<!--- # and $ of payments by approval status --->
<cfif qry_selectPaymentList_status.RecordCount is not 0>
	<table border="0" cellspacing="2" cellpadding="2" class="MainText">
	<tr valign="top" align="center">
		<td>
			<b>## of Payments by Approval Status</b><br>
			<cfchart Format="flash" ChartHeight="100" xAxisTitle="" yAxisTitle="" URL="" ShowLegend="Yes" PieSliceStyle="solid">
				<cfchartseries Type="pie" Query="qry_selectPaymentList_status" ItemColumn="PaymentApprovedStatus" ValueColumn="countPayment" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
			</cfchart>
		</td>
		<td>
			<b>Total $ of Payments by Approval Status</b><br>
			<cfchart Format="flash" ChartHeight="100" xAxisTitle="" yAxisTitle="" URL="" ShowLegend="Yes" PieSliceStyle="solid" LabelFormat="currency">
				<cfchartseries Type="pie" Query="qry_selectPaymentList_status" ItemColumn="PaymentApprovedStatus" ValueColumn="sumPaymentAmount" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
			</cfchart>
		</td>
	</tr>
	</table>
</cfif>

<!--- # and $ of payments by method --->
<cfif qry_selectPaymentList_method.RecordCount gt 1>
	<img src="#Application.billingUrlroot#/images/aline.gif" width="100%" height="1" alt="" border="0">
	<table border="0" cellspacing="2" cellpadding="2" class="MainText">
	<tr valign="top" align="center">
		<td>
			<b>## of Payments by Payment Method</b><br>
			<cfchart Format="flash" ChartHeight="100" xAxisTitle="" yAxisTitle="" URL="" ShowLegend="Yes" PieSliceStyle="solid">
				<cfchartseries Type="pie" Query="qry_selectPaymentList_method" ItemColumn="paymentMethod" ValueColumn="countPayment" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
			</cfchart>
		</td>
		<td>
			<b>Total $ of Payments by Payment Method</b><br>
			<cfchart Format="flash" ChartHeight="100" xAxisTitle="" yAxisTitle="" URL="" ShowLegend="Yes" PieSliceStyle="solid" LabelFormat="currency">
				<cfchartseries Type="pie" Query="qry_selectPaymentList_method" ItemColumn="paymentMethod" ValueColumn="sumPaymentAmount" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
			</cfchart>
		</td>
	</tr>
	</table>
</cfif>


<!--- # and $ of payments manual vs automatic --->
<cfif qry_selectPaymentList_manual.RecordCount gt 1>
	<img src="#Application.billingUrlroot#/images/aline.gif" width="100%" height="1" alt="" border="0">
	<table border="0" cellspacing="2" cellpadding="2" class="MainText">
	<tr valign="top" align="center">
		<td>
			<b>## of Payments by Manual vs. Automatic</b><br>
			<cfchart Format="flash" ChartHeight="100" xAxisTitle="" yAxisTitle="" URL="" ShowLegend="Yes" PieSliceStyle="solid">
				<cfchartseries Type="pie" Query="qry_selectPaymentList_manual" ItemColumn="PaymentManualStatus" ValueColumn="countPayment" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
			</cfchart>
		</td>
		<td>
			<b>Total $ of Payments by Manual vs. Automatic</b><br>
			<cfchart Format="flash" ChartHeight="100" xAxisTitle="" yAxisTitle="" URL="" ShowLegend="Yes" PieSliceStyle="solid" LabelFormat="currency">
				<cfchartseries Type="pie" Query="qry_selectPaymentList_manual" ItemColumn="PaymentManualStatus" ValueColumn="sumPaymentAmount" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
			</cfchart>
		</td>
	</tr>
	</table>
</cfif>


<!--- # and $ with error message --->
<cfif qry_selectPaymentList_message.RecordCount is not 0>
	<img src="#Application.billingUrlroot#/images/aline.gif" width="100%" height="1" alt="" border="0">
	<table border="0" cellspacing="2" cellpadding="2" class="MainText">
	<tr valign="top" align="center">
		<td>
			<b>## of Rejected Payments by Error Message</b><br>
			<cfchart Format="flash" ChartHeight="100" xAxisTitle="" yAxisTitle="" URL="" ShowLegend="Yes" PieSliceStyle="solid">
				<cfchartseries Type="pie" Query="qry_selectPaymentList_message" ItemColumn="paymentMessage" ValueColumn="countPayment" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
			</cfchart>
		</td>
		<td>
			<b>Total $ of Rejected Payments by Error Message</b><br>
			<cfchart Format="flash" ChartHeight="100" xAxisTitle="" yAxisTitle="" URL="" ShowLegend="Yes" PieSliceStyle="solid" LabelFormat="currency">
				<cfchartseries Type="pie" Query="qry_selectPaymentList_message" ItemColumn="paymentMessage" ValueColumn="sumPaymentAmount" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
			</cfchart>
		</td>
	</tr>
	</table>
</cfif>


<!--- # and $ by credit card type --->
<cfif qry_selectPaymentList_card.RecordCount is not 0>
	<img src="#Application.billingUrlroot#/images/aline.gif" width="100%" height="1" alt="" border="0">
	<table border="0" cellspacing="2" cellpadding="2" class="MainText">
	<tr valign="top" align="center">
		<td>
			<b>## of Payments by Credit Card Type</b><br>
			<cfchart Format="flash" ChartHeight="100" xAxisTitle="" yAxisTitle="" URL="" ShowLegend="Yes" PieSliceStyle="solid">
				<cfchartseries Type="pie" Query="qry_selectPaymentList_card" ItemColumn="paymentCreditCardType" ValueColumn="countPayment" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
			</cfchart>
		</td>
		<td>
			<b>Total $ of Payments by Credit Card Type</b><br>
			<cfchart Format="flash" ChartHeight="100" xAxisTitle="" yAxisTitle="" URL="" ShowLegend="Yes" PieSliceStyle="solid" LabelFormat="currency">
				<cfchartseries Type="pie" Query="qry_selectPaymentList_card" ItemColumn="paymentCreditCardType" ValueColumn="sumPaymentAmount" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
			</cfchart>
		</td>
	</tr>
	</table>
</cfif>

<!--- Refund: Main products that are source of refund --->
<cfif FindNoCase("Refund", Variables.doAction)>
	<img src="#Application.billingUrlroot#/images/aline.gif" width="100%" height="1" alt="" border="0">

	<div align="center" class="MainText" style="width: 700"><b>10 Products as Bigger ## Source of Refunds</b></div>
	<cfchart Format="flash" ChartHeight="200" ChartWidth="700" xAxisTitle="" yAxisTitle="" URL="" ShowLegend="Yes" PieSliceStyle="solid">
		<cfchartseries Type="pie" Query="qry_selectPaymentList_productCount" ItemColumn="productName" ValueColumn="countPayment" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
	</cfchart>

	<div align="center" class="MainText" style="width: 700"><b>10 Products as Bigger $$ Source of Refunds</b></div>
	<cfchart Format="flash" ChartHeight="200" ChartWidth="700" xAxisTitle="" yAxisTitle="" URL="" ShowLegend="Yes" PieSliceStyle="solid" LabelFormat="currency">
		<cfchartseries Type="pie" Query="qry_selectPaymentList_productTotal" ItemColumn="productName" ValueColumn="sumPaymentAmount" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
	</cfchart>
</cfif>
</cfoutput>
