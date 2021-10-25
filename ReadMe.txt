If you want to run the Win32 API Hooking Project correctly and see how it works do the following.

- Compile DLL Injector
- Compile Hook DLL
- Compile Test Application

- Open the "Test Application" and "DLL Injector".

- Inside the "DLL Injector" application load the dll. 

- Select the "Test Application" from the process list. 

  (Note: If the "Test Application" is not in the list double-click it to refresh the list.)

- Hit the messagebox button before injecting and after and you will see how the api was re-routed to the dll instead
	of the original api call in the USER32.DLL.