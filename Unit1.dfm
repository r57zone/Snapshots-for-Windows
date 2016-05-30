object Form1: TForm1
  Left = 198
  Top = 130
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1057#1085#1080#1084#1082#1080
  ClientHeight = 173
  ClientWidth = 230
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 112
    Top = 112
    Width = 3
    Height = 13
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 156
    Width = 230
    Height = 17
    Panels = <>
    SimplePanel = True
    OnClick = StatusBar1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 230
    Height = 64
    Align = alTop
    TabOrder = 1
    object SpeedButton1: TSpeedButton
      Left = 205
      Top = 40
      Width = 18
      Height = 18
      Flat = True
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFADADAD7B7B7BADADADFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFADADADFF00FFFF00FF7B7B7B7B
        7B7B7B7B7BFF00FFFF00FFADADADFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        8484847B7B7B949494ADADAD7B7B7B7B7B7B7B7B7BADADAD9494947B7B7B8484
        84FF00FFFF00FFFF00FFFF00FFA5A5A57B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B
        7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7BA5A5A5FF00FFFF00FFFF00FFADADAD
        7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B
        7BADADADFF00FFFF00FFFF00FFFF00FF8C8C8C7B7B7B8C8C8CFF00FFFF00FFFF
        00FFFF00FFFF00FF8C8C8C7B7B7B8C8C8CFF00FFFF00FFFF00FFADADAD7B7B7B
        7B7B7B7B7B7BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF7B7B7B7B7B
        7B7B7B7BADADADFF00FF7B7B7B7B7B7B7B7B7B7B7B7BFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FF7B7B7B7B7B7B7B7B7B7B7B7BFF00FF7B7B7B7B7B7B
        7B7B7B7B7B7BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF7B7B7B7B7B
        7B7B7B7B7B7B7BFF00FFADADAD7B7B7B7B7B7B7B7B7BFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FF7B7B7B7B7B7B7B7B7BADADADFF00FFFF00FFFF00FF
        8484847B7B7B8C8C8CFF00FFFF00FFFF00FFFF00FFFF00FF8C8C8C7B7B7B8484
        84FF00FFFF00FFFF00FFFF00FFADADAD7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B
        7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7BADADADFF00FFFF00FFFF00FFA5A5A5
        7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B
        7BA5A5A5FF00FFFF00FFFF00FFFF00FF8C8C8C7B7B7B8C8C8CADADAD7B7B7B7B
        7B7B7B7B7BADADAD9494947B7B7B8C8C8CFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFADADADFF00FFFF00FF7B7B7B7B7B7B7B7B7BFF00FFFF00FFADADADFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFADADAD7B
        7B7BADADADFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      OnClick = SpeedButton1Click
    end
    object Button1: TButton
      Left = 6
      Top = 8
      Width = 70
      Height = 25
      Caption = #1054#1073#1083#1072#1089#1090#1100
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 80
      Top = 8
      Width = 70
      Height = 25
      Caption = #1042#1077#1089#1100' '#1101#1082#1088#1072#1085
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 154
      Top = 8
      Width = 70
      Height = 25
      Caption = #1054#1082#1085#1086
      TabOrder = 2
      OnClick = Button3Click
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 40
      Width = 73
      Height = 17
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object CheckBox2: TCheckBox
      Left = 82
      Top = 40
      Width = 73
      Height = 17
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 4
    end
  end
  object XPManifest1: TXPManifest
    Left = 8
    Top = 72
  end
  object IdHTTP1: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
    AllowCookies = True
    HandleRedirects = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 40
    Top = 72
  end
  object PopupMenu1: TPopupMenu
    Left = 72
    Top = 72
    object N3: TMenuItem
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      OnClick = N3Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N1: TMenuItem
      Caption = #1047#1072#1082#1088#1099#1090#1100
      OnClick = N1Click
    end
  end
end
