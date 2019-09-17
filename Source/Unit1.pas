unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, XPMan, ExtCtrls, ClipBRD, ShellAPI, IniFiles,
  Buttons, Menus, MMSystem, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, IdMultipartFormData, IdIOHandler, IdIOHandlerSocket, IdSSLOpenSSL, PNGImage, Registry;

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
    procedure ShowNotify(NotifyStr: string);
    procedure ScreenShot;
    procedure AppShow;
    procedure AppHide;
    { Public declarations }
  end;

const
  ScrName = 'Screenshot.';

var
  Main: TMain;
  MyPath, NotificationApp: string;
  UseHotKey, UseTray: boolean;
  HotKeyMode: integer;

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
  if Trim(NotificationApp) = '' then
    PlaySound(PChar(GetWindowsDir + '\Media\notify.wav'), 0, SND_ASYNC)
  else
    WinExec(PChar(NotificationApp + ' -t "' + Caption + '" -d "Скриншот сохранен" -b "Snapshots.png" -c 2'), SW_SHOWNORMAL);
end;

procedure TMain.ScreenShot;
var
  MyCanvas: TCanvas;
  MyRect: TRect;
  PNG: TPNGObject;
  Bitmap: TBitmap;
  FileCounter: integer;
begin
  try
    MyCanvas:=TCanvas.Create;
    MyCanvas.Handle:=GetWindowDC(GetDesktopWindow);
    MyRect:=Rect(0, 0, Screen.Width, Screen.Height);
    Bitmap:=TBitmap.Create;
    Bitmap.Width:=Screen.Width;
    Bitmap.Height:=Screen.Height;
    Bitmap.Canvas.CopyRect(MyRect, MyCanvas, MyRect);
    PNG:=TPNGObject.Create;
    PNG.Assign(Bitmap);
    FileCounter:=0;
    while true do begin
      Inc(FileCounter);
      if not FileExists(MyPath + ScrName + IntToStr(FileCounter) + '.png') then begin
        PNG.SaveToFile(MyPath + ScrName + IntToStr(FileCounter) + '.png');
        if UploadCB.Checked = false then begin
          StatusBar.SimpleText:=' Скриншот сохранен';
          if (UseHotKey) and (UseTray) then
            ShowNotify('Скриншот сохранен');
        end;
        break;
      end;
    end;
    if (FileExists(MyPath + ScrName + IntToStr(FileCounter) + '.png')) and (UploadCB.Checked) then begin
      PicToHost(MyPath + ScrName + IntToStr(FileCounter) + '.png');
      if SaveCB.Checked = false then
        DeleteFile(MyPath + ScrName + IntToStr(FileCounter) + '.png');
    end;
    PNG.Free;
    Bitmap.Free;
    ReleaseDC(0, MyCanvas.Handle);
    MyCanvas.Free;
  except
    StatusBar.SimpleText:=' Не удалось создать скриншот';
  end;
end;

procedure TMain.AppHide;
begin
  Main.AlphaBlendValue:=0;
end;

procedure TMain.AppShow;
begin
  Main.AlphaBlendValue:=255;
  if UseTray = false then
    SetForegroundWindow(Handle);
end;

procedure TMain.AreaBtnClick(Sender: TObject);
begin
  if UseTray = false then
    AppHide;
  ChsArea.ShowModal;
end;

procedure TMain.FullScrBtnClick(Sender: TObject);
begin
  if UseTray = false then
    AppHide;
  ScreenShot;
  if UseTray = false then
    AppShow;
end;

procedure Tray(ActInd: integer); //1 - добавить, 2 - удалить, 3 -  заменить
var
  NIM: TNotifyIconData;
begin
  with NIM do begin
    cbSize:=SizeOf(nim);
    WND:=Main.Handle;
    uId:=1;
    uFlags:=NIF_MESSAGE or NIF_ICON or NIF_TIP;
    hIcon:=Application.Icon.Handle;
    uCallBackMessage:=WM_USER + 1;
    StrCopy(szTip, PChar(Application.Title));
  end;
  case ActInd of
    1: Shell_NotifyIcon(NIM_ADD, @nim);
    2: Shell_NotifyIcon(NIM_DELETE, @nim);
    3: Shell_NotifyIcon(NIM_MODIFY, @nim);
  end;
end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if UseHotKey then
    UnRegisterHotKey(Handle, 101);

  if UseTray then
    Tray(2);
end;

function GetNotificationAppPath: string;
var
  Reg: TRegistry;
begin
  Reg:=TRegistry.Create;
  Reg.RootKey:=HKEY_CURRENT_USER;
  if Reg.OpenKey('\Software\r57zone\Notification', false) then begin
      Result:=Reg.ReadString('Path');
    Reg.CloseKey;
  end;
  Reg.Free;
end;

function GetLocaleInformation(Flag: integer): string;
var
  pcLCA: array [0..20] of Char;
begin
  if GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, Flag, pcLCA, 19)<=0 then
    pcLCA[0]:=#0;
  Result:=pcLCA;
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

  Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini');

  MyPath:=Ini.ReadString('Main', 'Path', '');
  if Trim(MyPath)= '' then MyPath:=GetEnvironmentVariable('USERPROFILE') + '\Desktop\';

  if Ini.ReadInteger('Main', 'Mode', 0) = 1 then
    SaveCB.Checked:=true
  else
    if Ini.ReadInteger('Main', 'Mode', 0) = 2 then begin
      UploadCB.Checked:=false;
      SaveCB.Checked:=true;
    end;

  IdHttp.Request.CustomHeaders.Add('Authorization:Client-ID ' + Ini.ReadString('Main', 'ImgurClientID', ''));

  UseHotKey:=Ini.ReadBool('Main', 'Hotkey', false);

  if UseHotKey then begin
    RegisterHotKey(Main.Handle, 101, 0, VK_SNAPSHOT);
    HotKeyMode:=Ini.ReadInteger('Main', 'HotKeyMode', 0);
    NotificationApp:=GetNotificationAppPath;
  end;

  UseTray:=Ini.ReadBool('Main', 'Tray', false);

  if UseTray then begin
    Tray(1);
    SetWindowLong(Application.Handle,GWL_EXSTYLE,GetWindowLong(Application.Handle,GWL_EXSTYLE) or WS_EX_TOOLWINDOW);
    AppHide;
  end;

  Ini.Free;
end;

procedure TMain.WndBtnClick(Sender: TObject);
begin
  ChsWnd.ShowModal;
end;

procedure TMain.PicToHost(PicPath: string);
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
    AppShow;
  end;
  if IdHTTP.ResponseCode = 200 then begin
    Delete(Source, 1, Pos('<link>', Source) + 5);
    Delete(Source, Pos('<', Source), Length(Source) - Pos('<', Source) + 1);
    Clipboard.AsText:=Source;
    StatusBar.SimpleText:=' Ссылка скопирована в буфер';
    if (UseHotKey) and (UseTray) then
      ShowNotify('Скриншот сохранен');
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
  //for i:=0 to Amount - 1 do begin
    //Size:=DragQueryFile(Msg.WParam, i, nil, 0) + 1;
    Size:=DragQueryFile(Msg.WParam, 0, nil, 0) + 1;
    Filename:=StrAlloc(Size);
    //DragQueryFile(Msg.WParam, i, Filename, Size);
    DragQueryFile(Msg.WParam, 0, Filename, Size);
    Path:=StrPas(Filename);
    StrDispose(Filename);
  //end;
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
  Application.MessageBox('Cнимки 1.3' + #13#10 +
  'Последнее обновление: 17.09.2019' + #13#10 +
  'http://r57zone.github.io' + #13#10 + 'r57zone@gmail.com', 'О программе...', MB_ICONINFORMATION);
end;

procedure TMain.ControlWindow(var Msg: TMessage);
begin
  if (UseTray) and (Msg.WParam = SC_MINIMIZE) then
    AppHide
  else
    inherited;
end;

procedure TMain.IconMouse(var Msg: Tmessage);
begin
  case Msg.LParam of
    WM_LBUTTONDOWN:
      begin
        PostMessage(Handle, WM_LBUTTONDOWN, MK_LBUTTON, 0);
        PostMessage(Handle, WM_LBUTTONUP, MK_LBUTTON, 0);
        AppShow;
        SetForegroundWindow(Handle);
      end;

    WM_RBUTTONDOWN: PopupMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
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
  MyCanvas: TCanvas;
  MyRect, WindowRect: TRect;
  PNG: TPNGObject;
  Bitmap: TBitmap;
  FileCounter: integer;
begin
  if Window = 0 then begin
    Main.StatusBar.SimpleText:=' Окно не найдено';
    Exit;
  end;

  SetForegroundWindow(Window);
  try
    MyCanvas:=TCanvas.Create;
    MyCanvas.Handle:=GetWindowDC(GetDesktopWindow);
    GetWindowRect(Window, WindowRect);
    MyRect:=Rect(0, 0, WindowRect.Right - WindowRect.Left, WindowRect.Bottom - WindowRect.Top);
    Bitmap:=TBitmap.Create;
    Bitmap.Width:=WindowRect.Right - WindowRect.Left;
    Bitmap.Height:=WindowRect.Bottom - WindowRect.Top;
    Bitmap.Canvas.CopyRect(MyRect, MyCanvas, WindowRect);
    PNG:=TPNGObject.Create;
    PNG.Assign(Bitmap);
    FileCounter:=0;
    while true do begin
      Inc(FileCounter);
      if not FileExists(MyPath + ScrName + IntToStr(FileCounter) + '.png') then begin
        PNG.SaveToFile(MyPath + ScrName + IntToStr(FileCounter) + '.png');
        if UploadCB.Checked = false then begin
          StatusBar.SimpleText:=' Скриншот сохранен';
          if (UseHotKey) and (UseTray) then
            ShowNotify('Скриншот сохранен');
        end;
        break;
      end;
    end;
    if (FileExists(MyPath + ScrName + IntToStr(FileCounter) + '.png')) and (UploadCB.Checked) then begin
      PicToHost(MyPath + ScrName + IntToStr(FileCounter) + '.png');
      if SaveCB.Checked = false then
        DeleteFile(MyPath + ScrName + IntToStr(FileCounter) + '.png');
    end;
    PNG.Free;
    Bitmap.Free;
    ReleaseDC(0, MyCanvas.Handle);
    MyCanvas.Free;
  except
    StatusBar.SimpleText:=' Не удалось создать скриншот';
  end;
end;

end.

