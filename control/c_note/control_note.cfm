<cfinvoke component="#Application.billingMapping#control.c_note.ControlNote" method="controlNote" returnVariable="noteResult">
	<cfinvokeargument name="doControl" value="#URL.control#">
	<cfinvokeargument name="doAction" value="#URL.action#">
	<cfinvokeargument name="formAction" value="index.cfm?method=#URL.control#.#URL.action#">
</cfinvoke>
