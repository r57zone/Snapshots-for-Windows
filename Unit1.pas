unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, JPEG, XPMan, ExtCtrls, ClipBRD, ShellAPI, IniFiles,
  Buttons, Menus, MMSystem, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, IdMultipartFormData, IdIOHandler, IdIOHandlerSocket, IdSSLOpenSSL, PNGImage;

type
  TMain = class(TForm)
    StatusBar: TStatusBar;
    XPManifest: TXPManifest;
    Panel: TPanel;
    AreaBtn: TButton;
    FullScrBtn: TButton;
    WndBtn: TButton;
    UploadCB: TCheckBox;
    SaveCB: TCheckBox;
    SettgsBtn: TSpeedButton;
    PopupMenu: TPopupMenu;
    MenuCloseBtn: TMenuItem;
    MenuLine: TMenuItem;
    MenuSettingsBtn: TMenuItem;
    IdHTTP: TIdHTTP;
    IdSSLIOHandlerSocket: TIdSSLIOHandlerSocket;
    procedure AreaBtnClick(Sender: TObject);
    procedure FullScrBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure WndBtnClick(Sender: TObject);
    procedure StatusBarClick(Sender: TObject);
    procedure SettgsBtnClick(Sender: TObject);
    procedure MenuSettingsBtnClick(Sender: TObject);
    procedure MenuCloseBtnClick(Sender: TObject);
  protected
    procedure WMDropFiles (var Msg: TMessage); message WM_DropFiles;
    procedure ControlWindow(var Msg: TMessage); message WM_SysCommand;
    procedure IconMouse(var Msg: TMessage); message WM_User+1;
  private
    procedure WMHotKey(var Msg: TWMHotKey); message WM_HOTKEY;
    { Private declarations }
  public
    procedure ScreenShotWindow(Window: HWND);
    procedure PicToHost(PicPath: string);
    procedure PicToImgur(PicPath: string);
    procedure PicToPixs(PicPath: string);
    procedure ShowNotify(Notify: string);
    procedure ScreenShot;
    procedure MainShow;
    procedure MainHide;
    { Public declarations }
  end;

var
  Main: TMain;
  MyPath, NotificationPath: string;
  UseHotKey, UseTray: boolean;
  HotKeyMode, LeftT, TopT, PicHost: integer;

implementation

uses Unit2, Unit3, Unit4, Unit5;

{$R *.dfm}

function GetWindowsDir:string;
var
  Name: array [0..255] of Char;
begin
  GetWindowsDirectory(Name, SizeOf(Name));
  Result:=Name;
end;

procedure TMain.ShowNotify;
begin
  if Trim(NotificationPath) = '' then
    PlaySound(PChar(GetWindowsDir + '\Media\notify.wav'), 0, SND_ASYNC)
  else
    WinExec(PChar(NotificationPath), SW_SHOWNORMAL);
end;

procedure TMain.ScreenShot;
var
  c: TCanvas;
  r: TRect;
  PNG: TPNGObject;
  Bitmap: TBitmap;
  i: integer;
begin
  try
    c:=TCanvas.Create;
    c.Handle:=GetWindowDC(GetDesktopWindow);
    r:=Rect(0, 0, Screen.Width, Screen.Height);
    Bitmap:=TBitmap.Create;
    Bitmap.Width:=Screen.Width;
    Bitmap.Height:=Screen.Height;
    Bitmap.Canvas.CopyRect(r, c, r);
    PNG:=TPNGObject.Create;
    PNG.Assign(Bitmap);
    i:=0;
    while true do begin
      inc(i);
      if not FileExists(MyPath + 'Screenshot_' + IntToStr(i) + '.png') then begin
        PNG.SaveToFile(MyPath + 'Screenshot_' + IntToStr(i) + '.png');
        if UploadCB.Checked = false then begin
          StatusBar.SimpleText:=' Скриншот сохранен';
          if (UseHotKey) and (UseTray) then
            ShowNotify('Скриншот сохранен');
        end;
        break;
      end;
    end;
    if (FileExists(MyPath + 'Screenshot_' + IntToStr(i) + '.png')) and (UploadCB.Checked) then begin
      PicToHost(MyPath + 'Screenshot_' + IntToStr(i) + '.png');
      if SaveCB.Checked = false then
        DeleteFile(MyPath + 'Screenshot_' + IntToStr(i) + '.png');
    end;
    PNG.Free;
    Bitmap.Free;
    ReleaseDC(0, c.Handle);
    c.Free;
  except
    StatusBar.SimpleText:=' Не удалось создать скриншот';
  end;
end;

procedure TMain.MainHide;
begin
  TopT:=Top;
  LeftT:=Left;
  Main.Left:=0;
  Main.Top:=0 - Main.Height - 25;
end;

procedure TMain.MainShow;
begin
  Main.Top:=TopT;
  Main.Left:=LeftT;
  if UseTray = false then
    SetForegroundWindow(Handle);
end;

procedure TMain.AreaBtnClick(Sender: TObject);
begin
  if UseTray = false then
    MainHide;
  ChsArea.ShowModal;
end;

procedure TMain.FullScrBtnClick(Sender: TObject);
begin
  if UseTray = false then
    MainHide;
  ScreenShot;
  if UseTray = false then
    MainShow;
end;

procedure Tray(n:integer); //1 - добавить, 2 - удалить, 3 -  заменить
var
  nim: TNotifyIconData;
begin
  with nim do begin
    cbSize:=SizeOf(nim);
    wnd:=Main.Handle;
    uId:=1;
    uFlags:=nif_icon or nif_message or nif_tip;
    hIcon:=Application.Icon.Handle;
    uCallBackMessage:=WM_User + 1;
    StrCopy(szTip, PChar(Application.Title));
  end;
  case n of
    1: Shell_NotifyIcon(nim_add, @nim);
    2: Shell_NotifyIcon(nim_delete, @nim);
    3: Shell_NotifyIcon(nim_modify, @nim);
  end;
end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if UseHotKey then
    UnRegisterHotKey(Handle, 101);

  if UseTray then
    Tray(2);
end;

procedure TMain.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  //AreaBtn.ControlState:=[csFocusing];
  Application.Title:=Caption;
  DragAcceptFiles(Handle, True);
  Main.Left:=Screen.Width div 2 - Main.Width div 2;
  Main.Top:=Screen.Height div 2 - Main.Height div 2;

  Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');

  MyPath:=Ini.ReadString('Main', 'Path', '');
  if Trim(MyPath)= '' then MyPath:=ExtractFilePath(ParamStr(0));

  if Ini.ReadInteger('Main', 'Mode', 0) = 1 then
    SaveCB.Checked:=true
  else
    if Ini.ReadInteger('Main', 'Mode', 0) = 2 then begin
      UploadCB.Checked:=false;
      SaveCB.Checked:=true;
    end;

  if Trim(Ini.ReadString('Main', 'ImgurClientID', '')) <> '' then begin
    IdHttp.Request.CustomHeaders.Add('Authorization:Client-ID ' + Ini.ReadString('Main', 'ImgurClientID', ''));
    PicHost:=1;
  end else PicHost:=2;

  UseHotKey:=Ini.ReadBool('Main', 'Hotkey', false);

  if UseHotKey then begin
    RegisterHotKey(Main.Handle, 101, 0, VK_SNAPSHOT);
    HotKeyMode:=Ini.ReadInteger('Main', 'HotKeyMode', 0);
    NotificationPath:=Ini.ReadString('Main', 'Notification', '');
  end;

  UseTray:=Ini.ReadBool('Main', 'Tray', false);

  if UseTray then begin
    Tray(1);
    SetWindowLong(Application.Handle,GWL_EXSTYLE,GetWindowLong(Application.Handle,GWL_EXSTYLE) or WS_EX_TOOLWINDOW);
    MainHide;
  end;

  Ini.Free;
end;

procedure TMain.WndBtnClick(Sender: TObject);
begin
  ChsWnd.ShowModal;
end;

procedure TMain.PicToHost(PicPath: string);
begin
  case PicHost of
    1: PicToImgur(PicPath);
    2: PicToPixs(PicPath);
  end;
end;

procedure TMain.PicToImgur(PicPath: string);
var
  Source: string;
  FormData: TIdMultiPartFormDataStream;
begin
  StatusBar.SimpleText:=' Загрузка изображения';
  FormData:=TIdMultiPartFormDataStream.Create;
  FormData.AddFile('image', PicPath, '');
  IdHTTP.Request.ContentType:='Content-Type: application/octet-stream';
  try
    Source:=IdHTTP.Post('https://api.imgur.com/3/image.xml', FormData);
  except
  end;
  if IdHTTP.ResponseCode = 200 then begin
    Delete(Source, 1, Pos('<link>', Source) + 5);
    Delete(Source, Pos('<', Source), Length(Source) - Pos('<', Source) + 1);
    Clipboard.AsText:=Source;
    StatusBar.SimpleText:=' Ссылка скопирована в буфер';
    if (UseHotKey) and (UseTray) then
      ShowNotify('Ссылка скопирована в буфер');
  end else begin
    StatusBar.SimpleText:=' Ошибка загрузки на сервер';
    if (UseHotKey) and (UseTray) then
      ShowNotify('Ошибка загрузки на сервер');
  end;
  FormData.Free;
end;

procedure TMain.PicToPixs(PicPath: string);
var
  Source: string;
  FormData: TIdMultiPartFormDataStream;
begin
  StatusBar.SimpleText:=' Загрузка изображения';
  FormData:=TIdMultiPartFormDataStream.Create;
  FormData.AddFile('userfile', PicPath, '');
  FormData.AddFormField('file2', '');
  FormData.AddFormField('title', '');
  FormData.AddFormField('resize_x', '800');
  FormData.AddFormField('private_code', '');
  Main.IdHTTP.Request.ContentType:='multipart/form-data';;
  try
    Source:=Main.IdHTTP.Post('http://pixs.ru/redirects/upload.php', FormData);
  except
  end;
  if Pos('успешно загружена', Source) > 0 then begin
    Delete(Source, 1, Pos('Прямая ссылка:', Source));
    Delete(Source, 1, Pos('http', Source) - 1);
    Delete(Source, Pos('''>', source), Length(Source) - Pos('''>', Source) + 1);
    ClipBoard.AsText:=Source;
    StatusBar.SimpleText:=' Ссылка скопирована в буфер';
    if (UseHotKey) and (UseTray) then
      ShowNotify('Ссылка скопирована в буфер');
  end else begin
    StatusBar.SimpleText:=' Ошибка загрузки на сервер';
    if (UseHotKey) and (UseTray) then
      ShowNotify('Ошибка загрузки на сервер');
  end;
  FormData.Free;
end;

procedure TMain.WMDropFiles(var Msg: TMessage);
var
  i, Amount, Size: integer;
  Filename: PChar;
  Path: string;
begin
  inherited;
  Amount:=DragQueryFile(Msg.WParam, $FFFFFFFF, Filename, 255);
  for i:=0 to Amount - 1 do begin
    Size:=DragQueryFile(Msg.WParam, i, nil, 0) + 1;
    Filename:=StrAlloc(Size);
    DragQueryFile(Msg.WParam, i, Filename, Size);
    Path:=StrPas(Filename);
    StrDispose(Filename);
  end;
  DragFinish(Msg.WParam);
  if (AnsiLowerCase(ExtractFileExt(Path)) = '.jpg') or (AnsiLowerCase(ExtractFileExt(Path)) = '.png')
  or (AnsiLowerCase(ExtractFileExt(Path)) = '.bmp') or (AnsiLowerCase(ExtractFileExt(Path)) = '.gif')
  or (AnsiLowerCase(ExtractFileExt(Path)) = '.jpeg') then
    PicToHost(Path)
  else
    StatusBar.SimpleText:=' Неверный формат изображения';
end;

procedure TMain.WMHotKey(var Msg: TWMHotKey);
begin
  if Msg.HotKey = 101 then
    case HotKeyMode of
      0: AreaBtn.Click;
      1: FullScrBtn.Click;
      2: WndBtn.Click;
      3: ChsAct.Show;
  end;
end;

procedure TMain.StatusBarClick(Sender: TObject);
begin
  Application.MessageBox('Cнимки 1.2.1' + #13#10 +
  'Последнее обновление: 04.01.2018' + #13#10 +
  'http://r57zone.github.io' + #13#10 + 'r57zone@gmail.com', 'О программе...', MB_ICONINFORMATION);
end;

procedure TMain.ControlWindow(var Msg: TMessage);
begin
  if (UseTray) and (Msg.WParam = SC_Minimize) then
    MainHide
  else
    inherited;
end;

procedure TMain.IconMouse(var Msg: Tmessage);
begin
  case Msg.LParam of
    WM_LButtonUp:
      begin
        MainShow;
        SetForegroundWindow(Handle);
      end;

    WM_RButtonUp: PopupMenu.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
  end;
end;

procedure TMain.SettgsBtnClick(Sender: TObject);
begin
  Settings.ShowModal;
end;

procedure TMain.MenuSettingsBtnClick(Sender: TObject);
begin
  Settings.ShowModal;
end;

procedure TMain.MenuCloseBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TMain.ScreenShotWindow(Window: HWND);
var
  c: TCanvas;
  r, t: TRect;
  PNG: TPNGObject;
  Bitmap: TBitmap;
  i: integer;
begin
  if Window = 0 then begin
    Main.StatusBar.SimpleText:=' Окно не найдено';
    Exit;
  end;

  SetForegroundWindow(Window);
  try
    c:=TCanvas.Create;
    c.Handle:=GetWindowDC(GetDesktopWindow);
    GetWindowRect(Window, t);
    r:=Rect(0, 0, t.Right - t.Left, t.Bottom - t.Top);
    Bitmap:=TBitmap.Create;
    Bitmap.Width:=t.Right - t.Left;
    Bitmap.Height:=t.Bottom - t.Top;
    Bitmap.Canvas.CopyRect(r, c, t);
    PNG:=TPNGObject.Create;
    PNG.Assign(Bitmap);
    i:=0;
    while true do begin
      inc(i);
      if not FileExists(MyPath + 'Screenshot_' + IntToStr(i) + '.png') then begin
        PNG.SaveToFile(MyPath + 'Screenshot_' + IntToStr(i) + '.png');
        if UploadCB.Checked = false then begin
          StatusBar.SimpleText:=' Скриншот сохранен';
          if (UseHotKey) and (UseTray) then
            ShowNotify('Скриншот сохранен');
        end;
        break;
      end;
    end;
    if (FileExists(MyPath + 'Screenshot_' + IntToStr(i) + '.png')) and (UploadCB.Checked) then begin
      PicToHost(MyPath + 'Screenshot_' + IntToStr(i) + '.png');
      if SaveCB.Checked = false then
        DeleteFile(MyPath + 'Screenshot_' + IntToStr(i) + '.png');
    end;
    PNG.Free;
    Bitmap.Free;
    ReleaseDC(0,c.Handle);
    c.Free;
  except
    StatusBar.SimpleText:=' Не удалось создать скриншот';
  end;
end;

end.

