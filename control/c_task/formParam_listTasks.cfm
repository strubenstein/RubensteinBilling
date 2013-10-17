<cfinclude template="../../include/function/act_urlToForm.cfm">

<cfparam Name="Form.userID_author" Default="0">
<cfparam Name="Form.userID_agent" Default="#Session.userID#">

<cfparam Name="Form.taskDateFrom_date" Default="">
<cfparam Name="Form.taskDateFrom_hh" Default="12">
<cfparam Name="Form.taskDateFrom_mm" Default="00">
<cfparam Name="Form.taskDateFrom_tt" Default="am">
<cfparam Name="Form.taskDateTo_date" Default="">
<cfparam Name="Form.taskDateTo_hh" Default="12">
<cfparam Name="Form.taskDateTo_mm" Default="00">
<cfparam Name="Form.taskDateTo_tt" Default="am">

<cfparam Name="Form.taskDateType" Default="">
<cfparam Name="Form.taskDateDefault" Default="">
<!--- <cfparam Name="Form.primaryTargetID" Default=""> --->

<cfparam Name="Form.taskMessage" Default="">

<cfparam Name="Form.taskStatus" Default="">
<cfparam Name="Form.taskCompleted" Default="">
<cfparam Name="Form.taskAll" Default="">
<cfparam Name="Form.taskAllForThisUser" Default="">
<cfparam Name="Form.taskAllForThisCompany" Default="">

<cfparam Name="Form.queryOrderBy" Default="taskDateScheduled_d">
<cfparam Name="Form.queryPage" Default="1">
<cfparam Name="Form.queryDisplayPerPage" Default="20">

