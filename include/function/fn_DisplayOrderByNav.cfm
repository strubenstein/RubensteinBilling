<cfscript>
function fn_DisplayOrderByButtons (viewAction, orderByValue, orderByField, buttonSeparator)
{
	var newViewAction = "<a href=""#viewAction#&queryOrderBy=#orderByField#""><img src=""#Application.billingUrlroot#/images/sort_up";
	if (orderByValue is orderByField)
		newViewAction = newViewAction & "_s";
	newViewAction = newViewAction & ".gif"" width=""26"" height=""9"" alt=""up"" border=""0"" hspace=""2""></a>" & buttonSeparator & "<a href=""#viewAction#&queryOrderBy=#orderByField#_d""><img src=""#Application.billingUrlroot#/images/sort_down";
	if (orderByValue is "#orderByField#_d")
		newViewAction = newViewAction & "_s";
	newViewAction = newViewAction & ".gif"" width=""26"" height=""9"" alt=""down"" border=""0"" hspace=""2""></a>";
	return newViewAction;
}
</cfscript>

<cffunction Name="fn_DisplayCurrentRecordNumbers" Output="Yes">
	<cfargument Name="viewAction" Type="string" Required="Yes">
	<cfargument Name="orderByValue" Type="string" Required="Yes">
	<cfargument Name="buttonSeparator" Type="string" Required="No" Default=" ">
	<cfargument Name="colspan" Type="numeric" Required="Yes">
	<cfargument Name="firstRecord" Type="numeric" Required="Yes">
	<cfargument Name="lastRecord" Type="numeric" Required="Yes">
	<cfargument Name="totalRecords" Type="numeric" Required="Yes">
	<cfargument Name="columnHeaderList" Type="string" Required="No" Default="">
	<cfargument Name="columnOrderByList" Type="string" Required="No" Default="">
	<cfargument Name="useFixedWidth" Type="boolean" Required="No" Default="True">
	<cfargument Name="tableWidth" Type="numeric" Required="No" Default="800">

	<cfoutput>
	<table border="0" cellspacing="0" cellpadding="2"<cfif Arguments.useFixedWidth is True><cfif Not StructKeyExists(Arguments, "tableWidth")>width="800"<cfelse>width="830"</cfif></cfif>>
	<cfif Arguments.firstRecord gt 0>
		<tr><td colspan="#Arguments.colspan#" align="center" class="MainText" bgcolor="ccccff"><b><i>Displaying #NumberFormat(Arguments.firstRecord)# - #NumberFormat(Arguments.lastRecord)# of #NumberFormat(Arguments.totalRecords)#</i></b></td></tr>
		<tr><td colspan="#Arguments.colspan#" height="3" align="center"><img src="#Application.billingUrlroot#/images/aline.gif" width="100%" height="1" alt="" border="0"></td></tr>
	</cfif>

	<cfif Arguments.columnHeaderList is not "">
		<tr class="TableHeader" valign="bottom">
		<cfset firstColumn = True>
		<cfloop Index="count" From="1" To="#ListLen(Arguments.columnHeaderList, "^")#">
			<cfif firstColumn is True><cfset firstColumn = False><cfelse><td width="5">&nbsp;</td></cfif>
			<td align="left">
				<table border="0" cellspacing="0" cellpadding="0"><tr valign="top">
				<td class="TableHeader" valign="bottom">
				<cfif Arguments.columnOrderByList is "" or ListGetAt(Arguments.columnOrderByList, count, "^") is False>
					#ListGetAt(Arguments.columnHeaderList, count, "^")#
				<cfelseif Arguments.orderByValue is ListGetAt(Arguments.columnOrderByList, count, "^")>
					<a href="#Arguments.viewAction#&queryOrderBy=#ListGetAt(Arguments.columnOrderByList, count, "^")#_d" class="blacklink">#ListGetAt(Arguments.columnHeaderList, count, "^")#</a>
				<cfelse>
					<a href="#Arguments.viewAction#&queryOrderBy=#ListGetAt(Arguments.columnOrderByList, count, "^")#" class="blacklink">#ListGetAt(Arguments.columnHeaderList, count, "^")#</a>
				</cfif>
				</td>
				<cfif Arguments.columnOrderByList is not "" and ListGetAt(Arguments.columnOrderByList, count, "^") is not False>
					<td valign="bottom" width="17" align="right"><a href="#Arguments.viewAction#&queryOrderBy=#ListGetAt(Arguments.columnOrderByList, count, "^")#"><img src="#Application.billingUrlroot#/images/arrow_up<cfif Arguments.orderByValue is not "#ListGetAt(Arguments.columnOrderByList, count, "^")#">_sel</cfif>.gif" width="14" height="13" alt="" border="0"></a><br><a href="#Arguments.viewAction#&queryOrderBy=#ListGetAt(Arguments.columnOrderByList, count, "^")#_d"><img src="#Application.billingUrlroot#/images/arrow_down<cfif Arguments.orderByValue is not "#ListGetAt(Arguments.columnOrderByList, count, "^")#_d">_sel</cfif>.gif" width="14" height="13" alt="" border="0"></a></td>
				</cfif>
				</tr></table>
			</td>
		</cfloop>
		</tr>
	</cfif>

	<!--- 
	<cfif Arguments.columnHeaderList is not "">
		<tr class="TableHeader" valign="bottom">
		<cfset firstColumn = True>
		<cfloop Index="column" List="#Arguments.columnHeaderList#" Delimiters="^">
			<cfif firstColumn is True><cfset firstColumn = False><cfelse><td width="5">&nbsp;</td></cfif>
			<th>#column#</th>
		</cfloop>
		</tr>
	</cfif>
	<cfif Arguments.columnOrderByList is not "">
		<tr class="TableHeader" valign="bottom" align="center">
		<cfset firstColumn = True>
		<cfloop Index="column" List="#Arguments.columnOrderByList#" Delimiters="^">
			<cfif firstColumn is True><cfset firstColumn = False><cfelse><td>&nbsp;</td></cfif>
			<cfif column is "False"><td>&nbsp;</td><cfelse><td nowrap>#fn_DisplayOrderByButtons(Arguments.viewAction, Arguments.orderByValue, column, Arguments.buttonSeparator)#</td></cfif>
		</cfloop>
		</tr>
	</cfif>
	--->
	<tr><td colspan="#Arguments.colspan#" height="3" align="center"><img src="#Application.billingUrlroot#/images/aline.gif" width="100%" height="1" alt="" border="0"></td></tr>
	</cfoutput>
</cffunction>

<cffunction Name="fn_DisplayOrderByPages" Output="Yes">
	<cfargument Name="colspan" Type="numeric" Required="Yes">
	<cfargument Name="viewAction" Type="string" Required="Yes">
	<cfargument Name="displayPerPage" Type="numeric" Required="Yes">
	<cfargument Name="currentPage" Type="numeric" Required="Yes">
	<cfargument Name="firstRecord" Type="numeric" Required="Yes">
	<cfargument Name="lastRecord" Type="numeric" Required="Yes">
	<cfargument Name="totalRecords" Type="numeric" Required="Yes">
	<cfargument Name="totalPages" Type="numeric" Required="Yes">
	<cfargument Name="displayAlphabet" Type="boolean" Required="No" Default="True">
	<cfargument Name="alphabetList" Type="string" Required="No" Default="">

	<cfoutput>
	<tr><td colspan="#Arguments.colspan#" height="3" align="center"><img src="#Application.billingUrlroot#/images/aline.gif" width="100%" height="1" alt="" border="0"></td></tr>
	<tr><td colspan="#Arguments.colspan#">
		<table border="0" cellspacing="0" cellpadding="3" width="100%">
		<form method="post" action="#Arguments.viewAction#">
		<tr bgcolor="dddddd"><!--- CCCC99 --->
			<td align="left" class="TableText" nowrap>
				&nbsp;
				<cfif Arguments.totalPages is 1>&lt;&lt; First #Arguments.displayPerPage#<cfelse><a href="#Arguments.viewAction#&queryPage=1" class="bluelink">&lt;&lt; First #Arguments.displayPerPage#</a></cfif> | 
				<cfif Arguments.currentPage is 1>&lt; Previous #Arguments.displayPerPage#<cfelse><a href="#Arguments.viewAction#&queryPage=#DecrementValue(Arguments.currentPage)#" class="bluelink">&lt; Previous #Arguments.displayPerPage#</a></cfif>
				&nbsp;
			</td>
			<td align="center" class="TableText">&nbsp;<b>Jump To Page (1-#Arguments.totalPages#):</b> <input type="text" name="queryPage" size="2" value="#HTMLEditFormat(Arguments.currentPage)#"> <input type="submit" value="go"> &nbsp;</td>
			<td align="right" class="TableText" nowrap>
				&nbsp;
				<cfif Arguments.currentPage is Arguments.totalPages>Next #Arguments.displayPerPage# &gt;<cfelse><a href="#Arguments.viewAction#&queryPage=#IncrementValue(Arguments.currentPage)#" class="bluelink">Next #Arguments.displayPerPage# &gt;</a></cfif> | 
				<cfif Arguments.totalPages is 1>Last #Arguments.displayPerPage# &gt;&gt;<cfelse><a href="#Arguments.viewAction#&queryPage=#Arguments.totalPages#" class="bluelink">Last #Arguments.displayPerPage# &gt;&gt;</a></cfif>
				&nbsp;
			</td>
		</tr>
		<!--- 
		<tr>
			<td colspan="2" align="center" class="TableText" bgcolor="ccccff">
				&nbsp;<b>Jump To Page:</b> 
				<cfloop Index="count" From="1" To="#Arguments.totalPages#">
					<cfif count is Arguments.currentPage><b>#count#</b><cfelse><a href="#Arguments.viewAction#&queryPage=#count#" class="bluelink">#count#</a></cfif><cfif count is not Arguments.totalPages>&middot;</cfif>
				</cfloop>
				&nbsp;
			</td>
		</tr>
		--->
		</form>
		<cfif Arguments.displayAlphabet is True>
			<cfset UcaseAlphabetList = UCase(Arguments.alphabetList)>
			<tr><td colspan="3" height="3" align="center" bgcolor="ccccff"><img src="#Application.billingUrlroot#/images/aline.gif" width="100%" height="1" alt="" border="0"></td></tr>
			<tr>
				<td colspan="3" align="center" class="TableText" bgcolor="ccccff" nowrap>
					&nbsp;<b>Jump To Name:</b> 
					<cfif Not REFind("[0-9]", Arguments.alphabetList)>0-9<cfelse><a href="#Arguments.viewAction#&queryLetter=0-9" class="bluelink">0-9</a></cfif>&middot;
					<cfloop Index="letter" List="A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"><cfif Not ListFind(UcaseAlphabetList, letter, "|")>#letter#<cfelse><a href="#Arguments.viewAction#&queryFirstLetter=#letter#" class="bluelink">#letter#</a></cfif>&middot;</cfloop>
					&nbsp;
				</td>
			</tr>
		</cfif>
		</table>
	</td></tr>
	</table>
	</cfoutput>
</cffunction>
