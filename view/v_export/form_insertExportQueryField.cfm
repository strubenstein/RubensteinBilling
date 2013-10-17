<cfoutput>

<p class="Instructions">
To add fields to a query, first select the table that contains the field(s). 
You can then select which fields to add by moving the fields from the list 
on the left to the list on the right. Be sure to add the fields in the order 
in which you want them listed in the query. You may add the same field more 
than once, but it requires changing the &quot;Select As&quot; value to 
differentiate them. Those fields already in the query are marked with a star.
</p>

<form method="get" action="">
<font class="MainText">Select Table: </font>
<select name="exportTableID" size="1" class="TableText" onChange="window.open(this.options[this.selectedIndex].value,'_main')">
<option value="index.cfm?method=export.#Variables.doAction#&exportQueryID=#URL.exportQueryID#">-- SELECT TABLE --</option>
<cfloop Query="qry_selectExportTableList">
	<option value="index.cfm?method=export.#Variables.doAction#&exportQueryID=#URL.exportQueryID#&exportTableID=#qry_selectExportTableList.exportTableID#"<cfif URL.exportTableID is qry_selectExportTableList.exportTableID> selected</cfif>>#HTMLEditFormat(qry_selectExportTableList.exportTableName)#</option>
</cfloop>
</select> 
</form>

<SCRIPT LANGUAGE="JavaScript">
<!-- Begin
function move(fbox, tbox) {
var arrFbox = new Array();
var arrTbox = new Array();
var arrLookup = new Array();
var i;
for (i = 0; i < tbox.options.length; i++) {
arrLookup[tbox.options[i].text] = tbox.options[i].value;
arrTbox[i] = tbox.options[i].text;
}
var fLength = 0;
var tLength = arrTbox.length;
for(i = 0; i < fbox.options.length; i++) {
arrLookup[fbox.options[i].text] = fbox.options[i].value;
if (fbox.options[i].selected && fbox.options[i].value != "") {
arrTbox[tLength] = fbox.options[i].text;
tLength++;
}
else {
arrFbox[fLength] = fbox.options[i].text;
fLength++;
   }
}
fbox.length = 0;
tbox.length = 0;
var c;
for(c = 0; c < arrFbox.length; c++) {
var no = new Option();
no.value = arrLookup[arrFbox[c]];
no.text = arrFbox[c];
fbox[c] = no;
}
for(c = 0; c < arrTbox.length; c++) {
var no = new Option();
no.value = arrLookup[arrTbox[c]];
no.text = arrTbox[c];
tbox[c] = no;
   }
}

function saveFields (field)
{
	for (i = 0; i < field.length; i++)
	{
		field[i].selected = true;
	}
}

//  End -->
</script>

<cfif URL.exportTableID is not 0>
	<form method="post" name="#Variables.formName#" action="#Variables.formAction#&exportTableID=#URL.exportTableID#">
	<input type="hidden" name="isFormSubmitted" value="True">

	<table border="0" cellspacing="2" cellpadding="2" class="TableText">
	<tr>
		<th class="TableHeader">Available Fields</th>
		<td></td>
		<th class="TableHeader">Fields To Add to Query</th>
	</tr>
	<tr>
		<td>
			<select name="exportTableFieldID_out" size="10" multiple style="width:300">
			<cfloop Query="qry_selectExportTableFieldList">
				<option value="#qry_selectExportTableFieldList.exportTableFieldID#">#HTMLEditFormat(qry_selectExportTableFieldList.exportTableFieldName)#<cfif ListFind(ValueList(qry_selectExportQueryFieldList.exportTableFieldID), qry_selectExportTableFieldList.exportTableFieldID)> *</cfif></option>
			</cfloop>
			</select>
		</td>
		<td align="center" valign="middle">
			&nbsp;<input type="button" onClick="move(document.#Variables.formName#.exportTableFieldID_out,document.#Variables.formName#.exportTableFieldID_in)" value="&gt;&gt;">&nbsp;<br>
			<br>
			<br>
			<input type="button" onClick="move(document.#Variables.formName#.exportTableFieldID_in,document.#Variables.formName#.exportTableFieldID_out)" value="&lt;&lt;">
		</td>
		<td>
			<select name="exportTableFieldID_in" size="10" multiple style="width:300">
			</select>
		</td>
	</tr>
	<tr height="40"><td colspan="3" align="center"><input type="submit" name="submitExportQueryField" value="Add Fields to Query" onClick="saveFields(this.form.exportTableFieldID_in);"></td></tr>
	</table>
	</form>
</cfif>
</cfoutput>
	