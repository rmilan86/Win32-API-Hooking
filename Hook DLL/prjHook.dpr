(************************************************************)
(* Win32 API Hooking Library                                *)
(* by Robert Milan (03/23/13)                               *)
(************************************************************)
(* This code is provided "as is" without express or         *)
(* implied warranty of any kind. Use it at your own risk.   *)
(************************************************************)

library prjHook;

uses
  Windows,
  SysUtils,
  StrUtils,
  Classes,
  Dialogs,
  Winsock;

var
   { Original API }
   TMessageBoxA : function (Handle : hWnd; lpText : PAnsiChar; lpCaption : PAnsiChar; uType : Cardinal) : Integer; stdcall;

{$R *.res}

{ Duplicate of the original api }
function OMessageBoxA(Handle : hWnd; lpText : PAnsiChar; lpCaption : PAnsiChar; uType : Cardinal) : Integer; stdcall;
begin

   { Here we will edit the api in any way that we want. }


   { Edit the message for the MessageBox }
   lpText := PAnsiChar('Message text edited!');

   { Change the icon type to exclamation }
   uType := $00000030;

   { Call the original api }
   Result := TMessageBoxA(Handle, lpText, lpCaption, uType);
end;

{
   This function will take a api call from a dll and create a
      unconditional JMP to the functions address in this dll.

   If the "REAL" function address is "0x00AA0F00" and the address to
      our replacement is "0x00FFFFFF" then the JMP will replace a JMP
      right before we reach the "REAL" address to the replacement address.
}
function InterceptAPI(lpModuleName : PAnsiChar; lpProcName: PAnsiChar;
   PCallBack : Pointer; var PTrampoline : Pointer) : Integer; stdcall;
var
   hMod      : HMODULE;
   FuncAddr  : Pointer;
   FuncOrg   : Pointer;
   dwProtect : DWORD;
begin
   { Dynamic Link Library }
   hMod := GetModuleHandle(lpModuleName);
   if (hMod = 0) then
   begin
      Result := 0;
      exit;
   end;

   { Address to api function }
   FuncAddr := GetProcAddress(hMod, lpProcName);
   if (FuncAddr = nil) then
   begin
      Result := 0;
      exit;
   end;

   VirtualProtect(FuncAddr, 5, PAGE_WRITECOPY, dwProtect);
   GetMem(FuncOrg, 20);
   CopyMemory(FuncOrg, FuncAddr, 5);

   { Create a unconditional JMP to the address of our replacement api}
   Byte(Pointer(DWORD(FuncOrg) + 5)^) := $E9;
   DWORD(Pointer(DWORD(FuncOrg) + 6)^) := (DWORD(FuncAddr) - (DWORD(FuncOrg) + 5));

   { Create a trampoline so that we can replace the replacement api back with the original }
   PTrampoline := FuncOrg;

   Byte(FuncAddr^) := $E9;
   DWORD(Pointer(DWORD(FuncAddr) + 1)^) := DWORD(PCallback) - (DWORD(FuncAddr) + 5);

   VirtualProtect(FuncAddr, 5, dwProtect, dwProtect);
   FlushInstructionCache(GetCurrentProcess(), Nil, 0);

   Result := 1;
end;

procedure DllMain(reason: integer);
begin
   case reason of
      DLL_PROCESS_ATTACH:   // DLL Loaded
      begin
         InterceptAPI('USER32.dll', 'MessageBoxA', @OMessageBoxA, @TMessageBoxA);
      end;

      DLL_PROCESS_DETACH:  // DLL Unloaded
      begin
         // Do something while dll is being unloaded.
      end;
   end;
end; { DllMain }

begin
   { Set the dll entry point and call it }
   DllProc := @DllMain;
   DllProc(DLL_PROCESS_ATTACH);
end.
