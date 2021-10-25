object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Message App'
  ClientHeight = 74
  ClientWidth = 401
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 11
    Width = 42
    Height = 13
    Caption = 'Message'
  end
  object Button1: TButton
    Left = 328
    Top = 35
    Width = 65
    Height = 33
    Caption = 'Message'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 56
    Top = 8
    Width = 337
    Height = 21
    TabOrder = 1
    Text = 'Hello World!'
  end
end
