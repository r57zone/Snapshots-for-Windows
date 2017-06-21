object Settings: TSettings
  Left = 192
  Top = 124
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 238
  ClientWidth = 432
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 112
    Width = 171
    Height = 13
    Caption = #1055#1091#1090#1100' '#1076#1083#1103' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103' '#1089#1082#1088#1080#1085#1096#1086#1090#1086#1074
  end
  object DefActGB: TGroupBox
    Left = 8
    Top = 8
    Width = 201
    Height = 97
    Caption = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
    TabOrder = 0
    object RadioButton1: TRadioButton
      Left = 8
      Top = 24
      Width = 73
      Height = 17
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RadioButton2: TRadioButton
      Left = 8
      Top = 48
      Width = 137
      Height = 17
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080' '#1089#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 1
    end
    object RadioButton3: TRadioButton
      Left = 8
      Top = 72
      Width = 73
      Height = 17
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 2
    end
  end
  object ActHKGB: TGroupBox
    Left = 224
    Top = 8
    Width = 201
    Height = 150
    Caption = #1044#1077#1081#1089#1090#1074#1080#1077' '#1087#1088#1080' '#1085#1072#1078#1072#1090#1080#1080' Prt Scr'
    TabOrder = 1
    object RadioButton4: TRadioButton
      Left = 8
      Top = 24
      Width = 113
      Height = 17
      Caption = #1053#1077' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RadioButton5: TRadioButton
      Left = 8
      Top = 48
      Width = 113
      Height = 17
      Caption = #1054#1073#1083#1072#1089#1090#1100
      TabOrder = 1
    end
    object RadioButton6: TRadioButton
      Left = 8
      Top = 72
      Width = 113
      Height = 17
      Caption = #1042#1077#1089#1100' '#1101#1082#1088#1072#1085
      TabOrder = 2
    end
    object RadioButton7: TRadioButton
      Left = 8
      Top = 96
      Width = 113
      Height = 17
      Caption = #1054#1082#1085#1086
      TabOrder = 3
    end
    object RadioButton8: TRadioButton
      Left = 8
      Top = 120
      Width = 161
      Height = 17
      Caption = #1042#1099#1079#1074#1072#1090#1100' '#1076#1080#1072#1083#1086#1075' '#1074#1099#1073#1086#1088#1072
      TabOrder = 4
    end
  end
  object PathEdt: TEdit
    Left = 8
    Top = 136
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 2
  end
  object ChsFolder: TButton
    Left = 136
    Top = 136
    Width = 75
    Height = 21
    Caption = #1042#1099#1073#1088#1072#1090#1100
    TabOrder = 3
    OnClick = ChsFolderClick
  end
  object OkBtn: TButton
    Left = 272
    Top = 208
    Width = 75
    Height = 25
    Caption = #1054#1082
    TabOrder = 4
    OnClick = OkBtnClick
  end
  object CancelBtn: TButton
    Left = 352
    Top = 208
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 5
    OnClick = CancelBtnClick
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 167
    Width = 169
    Height = 27
    Caption = #1057#1074#1086#1088#1072#1095#1080#1074#1072#1090#1100' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077' '#1074' '#1086#1073#1083#1072#1089#1090#1100' '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1081' (tray)'
    TabOrder = 6
    WordWrap = True
  end
end
