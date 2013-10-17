<cfoutput>
<div class="SubNav">
<form method="get" action="">
<span class="SubNavTitle">Custom Status: </span>
<b>Target Type: </b>
<select name="primaryTargetID" size="1" class="TableText" onChange="window.open(this.options[this.selectedIndex].value,'_main')">
<cfloop Index="count" From="1" To="#ListLen(Variables.statusTargetList_label)#">
	<option value="index.cfm?method=status.listStatuses&primaryTargetID=#ListGetAt(Variables.statusTargetList_id, count)#"<cfif URL.primaryTargetID is ListGetAt(Variables.statusTargetList_id, count)> selected</cfif>>#HTMLEditFormat(ListGetAt(Variables.statusTargetList_label, count))#<cfif ListFind(ValueList(qry_selectStatusTargetList.primaryTargetID), ListGetAt(Variables.statusTargetList_id, count))> *</cfif></option>
</cfloop>
</select> 
<span class="SmallText" style="color: yellow">* Indicates you have existing custom status options for this target type.</span><br>
<cfif Application.fn_IsUserAuthorized("listStatuses")><a href="index.cfm?method=status.listStatuses&primaryTargetID=#URL.primaryTargetID#" title="List existing custom status options for this selected target" class="SubNavLink<cfif Variables.doAction is "listStatuses">On</cfif>">List Existing Status Options For Target Type</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertStatus")> | <a href="index.cfm?method=status.insertStatus&primaryTargetID=#URL.primaryTargetID#" title="Create new custom status option for this selected target" class="SubNavLink<cfif Variables.doAction is "insertStatus">On</cfif>">Create New Status Option For Target Type</a></cfif>
<cfif qry_selectStatusTargetList.RecordCount is not 0> | <a href="index.cfm?method=status.updateStatusTarget&primaryTargetID=#URL.primaryTargetID#" title="Update custom status export options" class="SubNavLink<cfif Variables.doAction is "updateStatusTarget">On</cfif>">Update Export Options For <i>All</i> Types</a></cfif>
</div><br>
</form>
</cfoutput>

