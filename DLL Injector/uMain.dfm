object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'DLL Injector'
  ClientHeight = 299
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 11
    Width = 22
    Height = 13
    Caption = 'Path'
  end
  object Label2: TLabel
    Left = 8
    Top = 48
    Width = 119
    Height = 13
    Caption = 'Process List (Select One)'
  end
  object Edit1: TEdit
    Left = 36
    Top = 8
    Width = 205
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 247
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Load'
    TabOrder = 1
    OnClick = Button1Click
  end
  object lst: TListBox
    Left = 8
    Top = 67
    Width = 313
    Height = 190
    ItemHeight = 13
    TabOrder = 2
    OnDblClick = lstDblClick
  end
  object Button2: TButton
    Left = 246
    Top = 263
    Width = 75
    Height = 25
    Caption = 'Inject DLL'
    TabOrder = 3
    OnClick = Button2Click
  end
end
