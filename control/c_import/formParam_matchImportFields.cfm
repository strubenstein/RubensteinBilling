<cfset Variables.importDataArray = ArrayNew(2)>

<cfloop Index="rowCount" From="1" To="3">
	<cfif Variables.importRowCount gte rowCount>
		<cfset Variables.thisImportDataRow = ListGetAt(importFileContent, rowCount, Chr(10))>
		<cfset Variables.thisRowColumnCount = ListLen(Variables.thisImportDataRow, Variables.importFileSeparator)>
		<cfset Variables.thisRowCount = rowCount>

		<cfloop Index="colCount" From="1" To="#Variables.importColumnCount#">
			<cfif colCount gt Variables.thisRowColumnCount>
				<cfset Variables.importDataArray[Variables.thisRowCount][colCount] = "">
			<cfelse>
				<cfset Variables.importDataArray[Variables.thisRowCount][colCount] = ListGetAt(Variables.thisImportDataRow, colCount, Variables.importFileSeparator)>
			</cfif>
		</cfloop>
	</cfif>
</cfloop>

<cfloop Index="colCount" From="1" To="#Variables.importColumnCount#">
	<cfparam Name="Form.field#colCount#" Default="">
</cfloop>
