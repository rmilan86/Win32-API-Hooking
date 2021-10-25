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
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  MessageBoxA(Self.Handle,                         // Application Handle
              PAnsiChar(AnsiString(Edit1.Text)),   // Message in messagebox
              PAnsiChar(Self.Caption),             // Title of messagebox
              $00000040);                          // Information Icon


end;

end.
