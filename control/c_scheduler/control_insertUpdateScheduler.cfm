<cfinclude template="../../include/function/fn_datetime.cfm">
<cfinvoke component="#Application.billingMapping#data.Scheduler" method="maxlength_Scheduler" returnVariable="maxlength_Scheduler" />
<cfinclude template="formParam_insertUpdateScheduler.cfm">
<cfinclude template="../../view/v_scheduler/lang_insertUpdateScheduler.cfm">

<cfset Variables.displayForm = True>
<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitScheduler")>
	<cfinclude template="formValidate_insertUpdateScheduler.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Scheduler" Method="#Variables.doAction#" ReturnVariable="newSchedulerID">
			<cfif Variables.doAction is "insertScheduler">
				<cfinvokeargument Name="companyID" Value="#Form.companyID#">
			<cfelse>
				<cfinvokeargument Name="schedulerID" Value="#URL.schedulerID#">
			</cfif>
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="schedulerStatus" Value="#Form.schedulerStatus#">
			<cfinvokeargument Name="schedulerName" Value="#Form.schedulerName#">
			<cfinvokeargument Name="schedulerDescription" Value="#Form.schedulerDescription#">
			<cfinvokeargument Name="schedulerURL" Value="#Form.schedulerURL#">
			<cfinvokeargument Name="schedulerDateBegin" Value="#Form.schedulerDateBegin#">
			<cfinvokeargument Name="schedulerDateEnd" Value="#Form.schedulerDateEnd#">
			<cfinvokeargument Name="schedulerInterval" Value="#Form.schedulerInterval#">
			<cfinvokeargument Name="schedulerRequestTimeOut" Value="#Form.schedulerRequestTimeOut#">
		</cfinvoke>

		<!--- "update" scheduled script --->
		<cfif Form.schedulerStatus is 1>
			<cfif IsDate(Form.schedulerDateBegin)>
				<cfset Variables.startDate = DateFormat(Form.schedulerDateBegin, "mm/dd/yyyy")>
				<cfset Variables.startTime = TimeFormat(Form.schedulerDateBegin, "hh:mm tt")>
			<cfelse>
				<cfset Variables.startDate = DateFormat(Now(), "mm/dd/yyyy")>
				<cfset Variables.startTime = TimeFormat(Now(), "hh:mm tt")>
			</cfif>

			<cfif IsDate(Form.schedulerDateEnd)>
				<cfset Variables.endDate = DateFormat(Form.schedulerDateEnd, "mm/dd/yyyy")>
				<cfset Variables.endTime = TimeFormat(Form.schedulerDateEnd, "hh:mm tt")>
			<cfelse>
				<cfset Variables.endDate = "">
				<cfset Variables.endTime = "">
			</cfif>

			<cftry>
			<cfschedule 
				Action="Update"
				Task="#Form.schedulerName#"
				Operation="HTTPRequest"
				StartDate="#Variables.startDate#"
				StartTime="#Variables.startTime#"
				EndDate="#Variables.endDate#"
				EndTime="#Variables.endTime#"
				URL="#Form.schedulerURL#"
				Publish="No"
				Interval="#Form.schedulerInterval#"
				RequestTimeOut="#Form.schedulerRequestTimeOut#">

			<cflocation url="index.cfm?method=scheduler.listSchedulers&confirm_scheduler=#Variables.doAction#" AddToken="No">

			<cfcatch>
				<cfset Variables.displayForm = False>
				<p class="ErrorMessage">An error occurred while trying to 
				<cfif Variables.doAction is "insertScheduler">add<cfelse>update</cfif> 
				this scheduled task to the ColdFusion Scheduler.</p>

				<p class="MainText">#CFCATCH.Message#</p>
				<p class="MainText">#CFCATCH.Detail#</p>
				<cfif IsDefined("CFCATCH.TagContext") and Not IsSimpleValue(CFCATCH.TagContext)>
					<p class="MainText"><cfdump Var="#CFCATCH.TagContext#" Expand="Yes" Label="CFCATCH.TagContext"></p>
				</cfif>
			</cfcatch>
			</cftry>

		<!--- "delete" scheduled script --->
		<cfelseif Form.schedulerStatus is 0 and Variables.doAction is "updateScheduler" and qry_selectScheduler.schedulerStatus is 1>
			<cftry>
			<cfschedule Action="Delete" Task="#Form.schedulerName#">

			<cflocation url="index.cfm?method=scheduler.listSchedulers&confirm_scheduler=#Variables.doAction#" AddToken="No">

			<cfcatch>
				<cfset Variables.displayForm = False>
				<p class="ErrorMessage">An error occurred while trying to 
				<cfif Variables.doAction is "insertScheduler">add<cfelse>update</cfif> 
				this scheduled task to the ColdFusion Scheduler.</p>

				<p class="MainText">#CFCATCH.Message#</p>
				<p class="MainText">#CFCATCH.Detail#</p>
				<cfif IsDefined("CFCATCH.TagContext") and Not IsSimpleValue(CFCATCH.TagContext)>
					<p class="MainText"><cfdump Var="#CFCATCH.TagContext#" Expand="Yes" Label="CFCATCH.TagContext"></p>
				</cfif>
			</cfcatch>
			</cftry>
		<cfelse>
			<cflocation url="index.cfm?method=scheduler.listSchedulers&confirm_scheduler=#Variables.doAction#" AddToken="No">
		</cfif><!--- /action --->
	</cfif><!--- /form validated --->
</cfif><!--- /form submitted --->

<cfif Variables.displayForm is True>
	<cfset Variables.formName = "insertUpdateScheduler">

	<cfif Variables.doAction is "insertScheduler">
		<cfset Variables.formSubmitValue = Variables.lang_insertUpdateScheduler.formSubmitValue_insert>
	<cfelse>
		<cfset Variables.formSubmitValue = Variables.lang_insertUpdateScheduler.formSubmitValue_update>
	</cfif>

	<cfinclude template="../../view/v_scheduler/form_insertUpdateScheduler.cfm">
</cfif>
