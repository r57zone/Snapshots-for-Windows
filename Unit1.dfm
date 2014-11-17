object Form1: TForm1
  Left = 198
  Top = 130
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1057#1085#1080#1084#1082#1080
  ClientHeight = 179
  ClientWidth = 230
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
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
    Top = 162
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
      Left = 88
      Top = 40
      Width = 73
      Height = 17
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 4
    end
  end
  object XPManifest1: TXPManifest
    Left = 72
    Top = 104
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
    Top = 104
  end
end
