object Settings: TSettings
  Left = 192
  Top = 124
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 312
  ClientWidth = 431
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
  object SaveScrPathLbl: TLabel
    Left = 8
    Top = 208
    Width = 171
    Height = 13
    Caption = #1055#1091#1090#1100' '#1076#1083#1103' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103' '#1089#1082#1088#1080#1085#1096#1086#1090#1086#1074
  end
  object NotifyAppPathLbl: TLabel
    Left = 216
    Top = 208
    Width = 197
    Height = 13
    Caption = #1055#1091#1090#1100' '#1076#1086' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1081' (tray)'
  end
  object DefActGB: TGroupBox
    Left = 8
    Top = 8
    Width = 201
    Height = 97
    Caption = #1044#1077#1081#1089#1090#1074#1080#1077' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
    TabOrder = 0
    object UploadRB: TRadioButton
      Left = 8
      Top = 24
      Width = 73
      Height = 17
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object UploadSaveRB: TRadioButton
      Left = 8
      Top = 48
      Width = 137
      Height = 17
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080' '#1089#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 1
    end
    object SaveRB: TRadioButton
      Left = 8
      Top = 72
      Width = 73
      Height = 17
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 2
    end
  end
  object HKActGB: TGroupBox
    Left = 216
    Top = 8
    Width = 201
    Height = 150
    Caption = #1044#1077#1081#1089#1090#1074#1080#1077' '#1087#1088#1080' '#1085#1072#1078#1072#1090#1080#1080' Prt Scr'
    TabOrder = 2
    object HKNotUseRB: TRadioButton
      Left = 8
      Top = 24
      Width = 113
      Height = 17
      Caption = #1053#1077' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object HKAreaRB: TRadioButton
      Left = 8
      Top = 48
      Width = 65
      Height = 17
      Caption = #1054#1073#1083#1072#1089#1090#1100
      TabOrder = 1
    end
    object HKFullScrRB: TRadioButton
      Left = 8
      Top = 72
      Width = 81
      Height = 17
      Caption = #1042#1077#1089#1100' '#1101#1082#1088#1072#1085
      TabOrder = 2
    end
    object HKWNDRB: TRadioButton
      Left = 8
      Top = 96
      Width = 49
      Height = 17
      Caption = #1054#1082#1085#1086
      TabOrder = 3
    end
    object HKShowDlgRB: TRadioButton
      Left = 8
      Top = 120
      Width = 153
      Height = 17
      Caption = #1042#1099#1079#1074#1072#1090#1100' '#1076#1080#1072#1083#1086#1075' '#1074#1099#1073#1086#1088#1072
      TabOrder = 4
    end
  end
  object OkBtn: TButton
    Left = 6
    Top = 280
    Width = 75
    Height = 25
    Caption = #1054#1082
    TabOrder = 7
    OnClick = OkBtnClick
  end
  object CancelBtn: TButton
    Left = 86
    Top = 280
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 8
    OnClick = CancelBtnClick
  end
  object TrayCB: TCheckBox
    Left = 216
    Top = 167
    Width = 169
    Height = 27
    Caption = #1057#1074#1086#1088#1072#1095#1080#1074#1072#1090#1100' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077' '#1074' '#1086#1073#1083#1072#1089#1090#1100' '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1081' (tray)'
    TabOrder = 3
    WordWrap = True
  end
  object PicHostGB: TGroupBox
    Left = 8
    Top = 112
    Width = 201
    Height = 81
    Caption = #1061#1086#1089#1090#1080#1085#1075' '#1082#1072#1088#1090#1080#1085#1086#1082
    TabOrder = 1
    object ImgurKeyLbl: TLabel
      Left = 8
      Top = 50
      Width = 57
      Height = 13
      Caption = #1050#1083#1102#1095' imgur:'
    end
    object Pixs: TRadioButton
      Left = 88
      Top = 24
      Width = 57
      Height = 17
      Caption = 'Pixs.ru'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
    object ImgurRB: TRadioButton
      Left = 8
      Top = 24
      Width = 65
      Height = 17
      Caption = 'Imgr.com'
      TabOrder = 0
    end
    object ImgurKeyEdt: TEdit
      Left = 72
      Top = 48
      Width = 121
      Height = 21
      TabOrder = 2
    end
  end
  object NotifyAppPathEdt: TEdit
    Left = 216
    Top = 232
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 9
  end
  object ChooseNotifyAppBtn: TButton
    Left = 344
    Top = 232
    Width = 75
    Height = 21
    Caption = #1042#1099#1073#1088#1072#1090#1100
    TabOrder = 6
    OnClick = ChooseNotifyAppBtnClick
  end
  object ChsFolderBtn: TButton
    Left = 134
    Top = 232
    Width = 75
    Height = 21
    Caption = #1042#1099#1073#1088#1072#1090#1100
    TabOrder = 4
    OnClick = ChsFolderBtnClick
  end
  object PathScrEdt: TEdit
    Left = 8
    Top = 232
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 5
  end
  object OpenDialog: TOpenDialog
    Filter = #1055#1088#1080#1083#1086#1078#1077#1085#1080#1103' (*.exe)|*.exe'
    Title = #1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077' '#1076#1083#1103' '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1081
    Left = 216
    Top = 256
  end
end
