<cfinvoke component="#Application.billingMapping#control.c_task.ControlTask" method="controlTask" returnVariable="taskResult">
	<cfinvokeargument name="doControl" value="#URL.control#">
	<cfinvokeargument name="doAction" value="#URL.action#">
	<cfinvokeargument name="formAction" value="index.cfm?method=#URL.control#.#URL.action#">
</cfinvoke>
