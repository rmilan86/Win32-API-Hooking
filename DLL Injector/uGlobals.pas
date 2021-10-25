(************************************************************)
(* Win32 API Hooking Library                                *)
(* by Robert Milan (03/23/13)                               *)
(************************************************************)
(* This code is provided "as is" without express or         *)
(* implied warranty of any kind. Use it at your own risk.   *)
(************************************************************)

unit uGlobals;

interface

uses
   Windows,
   SysUtils,
   TLHelp32;

  function GetProcessIdByName(s : String) : Cardinal;
  function InjectDLL(Process : AnsiString; Dll : AnsiString): Integer;

var
   szAppName : String;

implementation

function GetProcessIdByName(s : String) : Cardinal;
var
   { Process Vars }
   hProcessSnap : THandle;
   PE32         : ProcessEntry32;
begin
	{ Init. Result }
  	Result := 0;

  	{ Take a snapshot of all the processes in the system }
  	hProcessSnap := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  	if (hProcessSnap = INVALID_HANDLE_VALUE) then exit;

  	{ Size of the ProcessEntry32 Structure }
  	PE32.dwSize := SizeOf(TProcessEntry32);

  	{ Unable to retreive information about the first process }
  	if not (Process32First(hProcessSnap, PE32)) then
  	begin
    	PE32.dwSize := 0;
    	CloseHandle(hProcessSnap);
    	exit;
  	end;

  	{ Iterate through the process list }
  	while not (Process32Next(hProcessSnap, PE32) = false) do
  	begin
   	if (Lowercase(PE32.szExeFile) = Lowercase(s)) then
    	begin
         Result := PE32.th32ProcessID;
         break;
    	end;
  	end;

   { Cleanup the ProcessEntry32 struct. }
   with PE32 do
   begin
      dwSize := 0;
      cntUsage := 0;
      th32ProcessID := 0;
      th32DefaultHeapID := 0;
      th32ModuleID := 0;
      cntThreads := 0;
      th32ParentProcessID := 0;
      pcPriClassBase := 0;
      dwFlags := 0;
      szExeFile := '';
   end;

   { Freeup allocated memory }
   CloseHandle(hProcessSnap);
end;

function InjectDLL(Process: AnsiString; Dll: AnsiString) : Integer;
var
   PID          : Cardinal; { Process ID }

   hProcess     : THandle;  { Process Object }
   hThread      : THandle;  { Remote Thread Handle }

   dwThreadID   : DWORD;    { Remote Thread ID }

   BaseAddr     : PChar;    { Memory Address }

   BytesWritten : LongWord; { Total Bytes Written }
begin
   { Search for process id }
   PID := GetProcessIdByName(Process);

   { Process wasn't found }
   if (PID = 0) then
   begin
   	Result := -1;
   	exit;
   end;

   { Something went wrong, we can't find the process }
   if (PID = 0) then
   begin
      Result := -1;
      exit;
   end;

   { Open the process }
   hProcess := OpenProcess(PROCESS_QUERY_INFORMATION or { For Token, Exit code and more }
                           PROCESS_CREATE_THREAD or     { For CreateRemoteThread }
                           PROCESS_VM_OPERATION or      { For VirtualAllocEx/VirtualFreeEx }
                           PROCESS_VM_WRITE,            { For WriteProcessMemory }
                           false, PID);

   { Allocate some extra memory in the target process }
   BaseAddr := PChar(VirtualAllocEx(hProcess, nil, strlen(PChar(DLL)) + 1 * sizeof(Char), MEM_RESERVE or MEM_COMMIT, PAGE_READWRITE));

   { Inject dll into memory }
   if not (BaseAddr = nil) then
   begin
      WriteProcessMemory(hProcess, BaseAddr, PChar(DLL), Length(DLL), BytesWritten);
   end else
   begin
      { No need to continue, we couldn't write the dll into memory }
      Result := -1;
      exit;
   end;

   { Create a thread, force the process to load the dll }
   hThread := CreateRemoteThread(hProcess, nil, 0, GetProcAddress(LoadLibrary('Kernel32.dll'), 'LoadLibraryA'), BaseAddr, 0, dwThreadID);

   { Wait for the thread to execute }
   WaitForSingleObject(hThread, INFINITE);

   { Free allocated memory }
   VirtualFreeEx(hProcess, BaseAddr, 0, MEM_RELEASE);
   CloseHandle(hProcess);

   Result := 0;
end;

end.
