object ChsAct: TChsAct
  Left = 448
  Top = 235
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = #1044#1077#1081#1089#1090#1074#1080#1077
  ClientHeight = 40
  ClientWidth = 251
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object AreaBtn: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = #1054#1073#1083#1072#1089#1090#1100
    TabOrder = 0
    OnClick = AreaBtnClick
  end
  object FullScrBtn: TButton
    Left = 88
    Top = 8
    Width = 75
    Height = 25
    Caption = #1042#1077#1089#1100' '#1101#1082#1088#1072#1085
    TabOrder = 1
    OnClick = FullScrBtnClick
  end
  object WndBtn: TButton
    Left = 168
    Top = 8
    Width = 75
    Height = 25
    Caption = #1054#1082#1085#1086
    TabOrder = 2
    OnClick = WndBtnClick
  end
end
