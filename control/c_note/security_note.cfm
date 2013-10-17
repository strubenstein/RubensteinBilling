<cfif Not Application.fn_IsIntegerNonNegative(URL.noteID)>
	<cflocation url="index.cfm?method=#Arguments.doControl#.listNotes#Arguments.urlParameters#&error_note=invalidNote" AddToken="No">
<cfelseif URL.noteID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Note" Method="checkNotePermission" ReturnVariable="isNotePermission">
		<cfinvokeargument Name="noteID" Value="#URL.noteID#">
		<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID#">
		<cfinvokeargument Name="targetID" Value="#Arguments.targetID#">
		<!--- 
		<cfinvokeargument Name="companyID_target" Value="#Arguments.companyID#">
		<cfinvokeargument Name="userID_target" Value="#Arguments.userID#">
		--->
	</cfinvoke>

	<cfif isNotePermission is False>
		<cflocation url="index.cfm?method=#Arguments.doControl#.listNotes#Arguments.urlParameters#&error_note=invalidNote" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Note" Method="selectNote" ReturnVariable="qry_selectNote">
			<cfinvokeargument Name="noteID" Value="#URL.noteID#">
		</cfinvoke>
	</cfif>
<cfelseif Not ListFind("listNotes,insertNote", Arguments.doAction)>
	<cflocation url="index.cfm?method=#Arguments.doControl#.listNotes#Arguments.urlParameters#&error_note=noNote" AddToken="No">
</cfif>
