(************************************************************)
(* Win32 API Hooking Library                                *)
(* by Robert Milan (03/23/13)                               *)
(************************************************************)
(* This code is provided "as is" without express or         *)
(* implied warranty of any kind. Use it at your own risk.   *)
(************************************************************)

unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TLHelp32, StrUtils, uGlobals;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Label2: TLabel;
    lst: TListBox;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure lstDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    procedure GetProcessList();
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
   ODialog : TOpenDialog;
begin
   ODialog := TOpenDialog.Create(Self);

   ODialog.Title := 'Search';
   ODialog.Filter := 'Dynamic Link Library (.dll)|*.dll;';
   ODialog.Execute(Handle);

   if (Length(ODialog.FileName) = 0) then
   begin
      MessageBoxA(Handle,
                  PAnsiChar('No file was selected!'),
                  PAnsiChar('DLL Injector'),
                  64);

      ODialog.Free;
      exit;
   end;

   Edit1.Text := ODialog.FileName;

   ODialog.Free;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   if (lst.ItemIndex = -1) then exit;
   
   InjectDLL(lst.Items.Strings[lst.ItemIndex], Edit1.Text);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   GetProcessList();
end;


{
   This procedure will get a list of processes and adds them into the listbox
}
procedure TForm1.GetProcessList;
var
   hProcessSnap : THandle;
   hThreadSnap  : THandle;
   PE32         : TProcessEntry32;
   TE32         : TThreadEntry32;
begin
   lst.Items.Clear;
   hProcessSnap := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);

   if (hProcessSnap <> 0) then
   begin
      PE32.dwSize := sizeof(TProcessEntry32);

      if (Process32First(hProcessSnap, PE32)) then
      begin
         while (Process32Next(hProcessSnap, PE32) = true) do
         begin
            if (RightStr(Lowercase(PE32.szExeFile), 3) = 'exe') then
            begin
               lst.Items.Add(PE32.szExeFile);

               { Retreive the main thread }
               hThreadSnap := CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0);

               TE32.dwSize := sizeof(TThreadEntry32);

               if (Thread32First(hThreadSnap, TE32)) then
               begin
                  //lst.Items.Add('FTID: ' + IntToStr(TE32.th32ThreadID));
                  
                  while (Thread32Next(hThreadSnap, TE32)) do
                  begin
                     if (TE32.th32OwnerProcessID = PE32.th32ProcessID) then
                     begin
                        //lst.Items.Add('TID: ' + IntToStr(TE32.th32ThreadID));
                        //lst.Items.Add(' BP: ' + IntToStr(TE32.tpBasePri));
                     end;
                  end;
               end else
               begin
                  lst.Items.Add(PE32.szExeFile);
               end;

               CloseHandle(hThreadSnap);
            end;
         end;
      end;
   end;

   CloseHandle(hProcessSnap);
   PE32.dwSize := 0;
end;

procedure TForm1.lstDblClick(Sender: TObject);
begin
   GetProcessList();
end;

end.
