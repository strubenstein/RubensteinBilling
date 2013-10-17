<!--- The Graphs --->
<cfoutput>
<!--- # and $ closed by unpaid, partially paid, fully paid --->
<cfif qry_selectInvoiceList_paid.RecordCount is not 0>
	<table border="0" cellspacing="2" cellpadding="2" class="MainText">
	<tr valign="top" align="center">
		<td>
			<b>## of Closed Invoices by Payment Status</b><br>
			<cfchart Format="flash" ChartHeight="100" xAxisTitle="" yAxisTitle="" URL="" ShowLegend="Yes" PieSliceStyle="solid">
				<cfchartseries Type="pie" Query="qry_selectInvoiceList_paid" ItemColumn="InvoicePaidStatus" ValueColumn="countInvoice" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
			</cfchart>
		</td>
		<td>
			<b>Total $ of Closed Invoices by Payment Status</b><br>
			<cfchart Format="flash" ChartHeight="100" xAxisTitle="" yAxisTitle="" URL="" ShowLegend="Yes" PieSliceStyle="solid" LabelFormat="currency">
				<cfchartseries Type="pie" Query="qry_selectInvoiceList_paid" ItemColumn="InvoicePaidStatus" ValueColumn="sumInvoiceTotal" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
			</cfchart>
		</td>
	</tr>
	</table>
	<img src="#Application.billingUrlroot#/images/aline.gif" width="100%" height="1" alt="" border="0">
</cfif>

<!--- # and $ by status: open, closed, completed --->
<cfif qry_selectInvoiceList_closed.RecordCount is not 0>
	<table border="0" cellspacing="2" cellpadding="2" class="MainText">
	<tr valign="top" align="center">
		<td>
			<b>## of Invoices by Open/Closed Status</b><br>
			<cfchart Format="flash" ChartHeight="100" xAxisTitle="" yAxisTitle="" URL="" ShowLegend="Yes" PieSliceStyle="solid">
				<cfchartseries Type="pie" Query="qry_selectInvoiceList_closed" ItemColumn="InvoiceClosedStatus" ValueColumn="countInvoice" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
			</cfchart>
		</td>
		<td>
			<b>Total $ of Invoices by Open/Closed Status</b><br>
			<cfchart Format="flash" ChartHeight="100" xAxisTitle="" yAxisTitle="" URL="" ShowLegend="Yes" PieSliceStyle="solid" LabelFormat="currency">
				<cfchartseries Type="pie" Query="qry_selectInvoiceList_closed" ItemColumn="InvoiceClosedStatus" ValueColumn="sumInvoiceTotal" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
			</cfchart>
		</td>
	</tr>
	</table>
</cfif>

<!--- # and $ by due date: unpaid and partially paid --->

<!--- # and $ by product --->
<cfif qry_selectInvoiceList_productCount.RecordCount gt 2 and qry_selectInvoiceList_productTotal.RecordCount gt 2>
	<img src="#Application.billingUrlroot#/images/aline.gif" width="100%" height="1" alt="" border="0">

	<div align="center" class="MainText" style="width: 700"><b>10 Most Popular Products by ## of Line Items</b></div>
	<cfchart Format="flash" ChartHeight="200" ChartWidth="700" xAxisTitle="" yAxisTitle="" URL="" ShowLegend="Yes" PieSliceStyle="solid">
		<cfchartseries Type="pie" Query="qry_selectInvoiceList_productCount" ItemColumn="productName" ValueColumn="countInvoiceLineItem" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
	</cfchart>

	<div align="center" class="MainText" style="width: 700"><b>10 Most Popular Products by Total $ of Line Items</b></div>
	<cfchart Format="flash" ChartHeight="200" ChartWidth="700" xAxisTitle="" yAxisTitle="" URL="" ShowLegend="Yes" PieSliceStyle="solid" LabelFormat="currency">
		<cfchartseries Type="pie" Query="qry_selectInvoiceList_productTotal" ItemColumn="productName" ValueColumn="sumInvoiceLineItemTotal" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
	</cfchart>
</cfif>

<!--- # and $ by billing state --->
<cfif qry_selectInvoiceList_stateCount.RecordCount gt 2 and qry_selectInvoiceList_stateTotal.RecordCount gt 2>
	<img src="#Application.billingUrlroot#/images/aline.gif" width="100%" height="1" alt="" border="0">

	<table border="0" cellspacing="2" cellpadding="2" class="MainText">
	<tr valign="top" align="center">
		<td>
			<b>10 Most Popular States by ## of Invoices</b><br>
			<cfchart Format="flash" ChartHeight="200" ChartWidth="350" xAxisTitle="" yAxisTitle="" URL="" ShowLegend="Yes" PieSliceStyle="solid">
				<cfchartseries Type="pie" Query="qry_selectInvoiceList_stateCount" ItemColumn="state" ValueColumn="countInvoice" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
			</cfchart>
		</td>
		<td>
			<b>10 Most Popular States by Total $ of Invoices</b><br>
			<cfchart Format="flash" ChartHeight="200" ChartWidth="350" xAxisTitle="" yAxisTitle="" URL="" ShowLegend="Yes" PieSliceStyle="solid" LabelFormat="currency">
				<cfchartseries Type="pie" Query="qry_selectInvoiceList_stateTotal" ItemColumn="state" ValueColumn="sumInvoiceTotal" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
			</cfchart>
		</td>
	</tr>
	</table>
</cfif>

<!--- # and $ by billing country --->
<cfif qry_selectInvoiceList_countryCount.RecordCount gt 1 and qry_selectInvoiceList_countryTotal.RecordCount gt 1>
	<img src="#Application.billingUrlroot#/images/aline.gif" width="100%" height="1" alt="" border="0">
	<table border="0" cellspacing="2" cellpadding="2" class="MainText">
	<tr valign="top" align="center">
		<td>
			<b>10 Most Popular Countries by ## of Invoices</b><br>
			<cfchart Format="flash" ChartHeight="200" ChartWidth="350" xAxisTitle="" yAxisTitle="" URL="" ShowLegend="Yes" PieSliceStyle="solid">
				<cfchartseries Type="pie" Query="qry_selectInvoiceList_countryCount" ItemColumn="country" ValueColumn="countInvoice" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
			</cfchart>
		</td>
		<td>
			<b>10 Most Popular Countries by Total $ of Invoices</b><br>
			<cfchart Format="flash" ChartHeight="200" ChartWidth="350" xAxisTitle="" yAxisTitle="" URL="" ShowLegend="Yes" PieSliceStyle="solid" LabelFormat="currency">
				<cfchartseries Type="pie" Query="qry_selectInvoiceList_countryTotal" ItemColumn="country" ValueColumn="sumInvoiceTotal" SeriesColor="green" PaintStyle="light"></CFCHARTSERIES>
			</cfchart>
		</td>
	</tr>
	</table>
</cfif>
</cfoutput>
