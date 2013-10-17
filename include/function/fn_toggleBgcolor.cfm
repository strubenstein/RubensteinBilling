<cfoutput>
<script language="JavaScript">
function fn_toggleBgcolorOver(rowNum, rowShowDescription)
{
	document.getElementById('row' + rowNum).style.backgroundColor = 'FFFFCC';
	if (rowShowDescription == 'True')
		document.getElementById('row' + rowNum + 'a').style.backgroundColor = 'FFFFCC';
	else if (rowShowDescription == 'True3')
		{
		document.getElementById('row' + rowNum + 'a').style.backgroundColor = 'FFFFCC';
		document.getElementById('row' + rowNum + 'b').style.backgroundColor = 'FFFFCC';
		}
}

function fn_toggleBgcolorOut(rowNum, rowShowDescription, rowColor)
{
	document.getElementById('row' + rowNum).style.backgroundColor = rowColor;
	if (rowShowDescription == 'True')
		document.getElementById('row' + rowNum + 'a').style.backgroundColor = rowColor;
	else if (rowShowDescription == 'True3')
		{
		document.getElementById('row' + rowNum + 'a').style.backgroundColor = rowColor;
		document.getElementById('row' + rowNum + 'b').style.backgroundColor = rowColor;
		}
}
</script>
</cfoutput>

