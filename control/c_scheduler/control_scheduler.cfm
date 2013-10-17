<cfparam Name="URL.schedulerID" Default="0">

<cfset Variables.formAction = "index.cfm?method=#URL.control#.#URL.action#">
<cfif URL.schedulerID is not 0>
	<cfset Variables.formAction = Variables.formAction & "&schedulerID=" & URL.schedulerID>
</cfif>

<cfinclude template="security_scheduler.cfm">
<cfinclude template="../../view/v_scheduler/nav_scheduler.cfm">
<cfif IsDefined("URL.confirm_scheduler")>
	<cfinclude template="../../view/v_scheduler/confirm_scheduler.cfm">
</cfif>
<cfif IsDefined("URL.error_scheduler")>
	<cfinclude template="../../view/v_scheduler/error_scheduler.cfm">
</cfif>

<cfinclude template="fn_schedulerInterval.cfm">

<cfswitch expression="#Variables.doAction#">
<cfcase value="listSchedulers">
	<cfinclude template="control_listSchedulers.cfm">
</cfcase>

<cfcase value="insertScheduler,updateScheduler">
	<cfinclude template="control_insertUpdateScheduler.cfm">
</cfcase>

<!--- 
<cfcase value="viewScheduler">
	<cfinclude template="control_viewScheduler.cfm">
</cfcase>
--->

<cfcase value="listNotes,insertNote,updateNote">
	<cfinvoke component="#Application.billingMapping#control.c_note.ControlNote" method="controlNote" returnVariable="isNotesListed">
		<cfinvokeargument name="doControl" value="#URL.control#">
		<cfinvokeargument name="doAction" value="#Variables.doAction#">
		<cfinvokeargument name="formAction" value="#Variables.formAction#">
		<cfinvokeargument name="primaryTargetKey" value="schedulerID">
		<cfinvokeargument name="targetID" value="#URL.schedulerID#">
		<cfinvokeargument name="urlParameters" value="&schedulerID=#URL.schedulerID#">
	</cfinvoke>
</cfcase>

<cfdefaultcase>
	<cfset URL.error_scheduler = "invalidAction">
	<cfinclude template="../../view/v_scheduler/error_scheduler.cfm">
</cfdefaultcase>
</cfswitch>

