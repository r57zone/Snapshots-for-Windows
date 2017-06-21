unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, JPEG, XPMan, ExtCtrls, ClipBRD, ShellAPI, IniFiles,
  Buttons, Menus, MMSystem, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, IdMultipartFormData;

type
  TMain = class(TForm)
    StatusBar: TStatusBar;
    XPManifest1: TXPManifest;
    Panel: TPanel;
    AreaBtn: TButton;
    FullScrBtn: TButton;
    WndBtn: TButton;
    Label1: TLabel;
    UploadCB: TCheckBox;
    SaveCB: TCheckBox;
    SettgsBtn: TSpeedButton;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    IdHTTP1: TIdHTTP;
    procedure AreaBtnClick(Sender: TObject);
    procedure FullScrBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure WndBtnClick(Sender: TObject);
    procedure StatusBarClick(Sender: TObject);
    procedure SettgsBtnClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
  protected
    procedure WMDropFiles (var Msg: TMessage); message WM_DropFiles;
    procedure ControlWindow(var Msg: TMessage); message WM_SysCommand;
    procedure IconMouse(var Msg: TMessage); message WM_User+1;
  private
    procedure WMHotKey(var Msg: TWMHotKey); message WM_HOTKEY;
    { Private declarations }
  public
    procedure ScreenShotWindow(Window: HWND);
    procedure PostImgToHosting(Img:string);
    procedure ShowNotify(NotifyMessage:string);
    { Public declarations }
  end;

var
  Main: TMain;
  Bitmap: TBitmap;
  MyPath, NotificationPath: string;
  UseHotKey, UseTray: boolean;
  HotKeyMode, LeftT, TopT: integer;

implementation

uses Unit2, Unit3, Unit4, Unit5;

{$R *.dfm}

procedure ScreenShot;
var
  c: TCanvas;
  r: TRect;
  JPEG: TJPEGImage;
  i: integer;
begin
  c:=TCanvas.Create;
  c.Handle:=GetWindowDC(GetDesktopWindow);
  try
    r:=Rect(0,0,Screen.Width,Screen.Height);
    Bitmap.Width:=Screen.Width;
    Bitmap.Height:=Screen.Height;
    Bitmap.Canvas.CopyRect(r,c,r);
    JPEG:=TJPEGImage.Create;
    JPEG.Assign(Bitmap);
    JPEG.CompressionQuality:=100;
    JPEG.Compress;
    i:=0;
    while true do begin
      inc(i);
      if not FileExists(MyPath+'\Screenshot_'+IntToStr(i)+'.jpg') then begin
        JPEG.SaveToFile(MyPath+'\Screenshot_'+IntToStr(i)+'.jpg');
        if Main.UploadCB.Checked=false then begin
          Main.StatusBar.SimpleText:=' Снимок сохранен';
          if (UseHotKey=true) and (UseTray=true) then Main.ShowNotify('Снимок сохранен');
        end;
        break;
      end;
    end;
    if FileExists(MyPath+'\Screenshot_'+IntToStr(i)+'.jpg') and Main.UploadCB.Checked then begin
      Main.PostImgToHosting(MyPath+'\Screenshot_'+IntToStr(i)+'.jpg');
      if Main.SaveCB.Checked=false then DeleteFile(MyPath+'\Screenshot_'+IntToStr(i)+'.jpg');
    end;
  finally
    JPEG.Free;
    ReleaseDC(0, c.Handle);
    c.Free;
  end;
end;

procedure TMain.AreaBtnClick(Sender: TObject);
begin
  TopT:=Top;
  LeftT:=Left;
  Left:=0 - Width;
  Top:=0 - Height;
  ChsArea.ShowModal;
end;

procedure TMain.FullScrBtnClick(Sender: TObject);
begin
  TopT:=Top;
  LeftT:=Left;
  Left:=0 - Width;
  Top:=0 - Height;
  ScreenShot;
  Top:=TopT;
  Left:=LeftT;
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
  if UseHotKey then UnRegisterHotKey(Main.Handle,101);
  Bitmap.Free;
  if UseTray then Tray(2);
end;

procedure TMain.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  //IdHttp1.Request.CustomHeaders.Add('Authorization:Client-ID 2dee61a2a821ed3');

  Main.Left:=Screen.Width div 2 - Main.Width div 2;
  Main.Top:=Screen.Height div 2 - Main.Height div 2;

  Ini:=TIniFile.Create(ExtractFilePath(paramstr(0)) + 'config.ini');

  MyPath:=Ini.ReadString('Main', 'Path', '');
  if trim(MyPath)='' then MyPath:=ExtractFileDir(ParamStr(0));

  if Ini.ReadInteger('Main', 'Mode', 0) = 1 then
    SaveCB.Checked:=true;

  if Ini.ReadInteger('Main', 'Mode', 0) = 2 then begin
    UploadCB.Checked:=false;
    SaveCB.Checked:=true;
  end;

  if Ini.ReadInteger('Main', 'Hotkey', 0) = 1 then
    UseHotKey:=true
  else
    UseHotKey:=false;

  if UseHotKey then begin
    RegisterHotKey(Main.Handle,101,0,VK_SNAPSHOT);
    HotKeyMode:=Ini.ReadInteger('Main','HotKeyMode',0);
    NotificationPath:=Ini.ReadString('Main','Notification','');
  end;

  if Ini.ReadInteger('Main','Tray',0)=1 then
    UseTray:=true
  else
    UseTray:=false;

  if UseTray then begin
    Tray(1);
    SetWindowLong(Application.Handle,GWL_EXSTYLE,GetWindowLong(Application.Handle,GWL_EXSTYLE) or WS_EX_TOOLWINDOW);
    Main.Left:=Screen.Width;
    Main.Top:=Screen.Height;
  end;

  Ini.Free;
  //AreaBtn.ControlState:=[csFocusing];
  Bitmap:=TBitmap.Create;
  Application.Title:=Caption;
  DragAcceptFiles(Handle, True);
end;

procedure TMain.WndBtnClick(Sender: TObject);
begin
  ChsWnd.ShowModal;
end;

{procedure TForm1.PostImgToHosting(Img: string);
var
  source: string;
  FormData: TIdMultiPartFormDataStream;
begin
  StatusBar1.SimpleText:=' Загрузка изображения';
  FormData:=TIdMultiPartFormDataStream.Create;
  FormData.AddFile('image', img, '');
  IdHTTP1.Request.ContentType:='Content-Type: application/octet-stream';
  try
    source:=IdHTTP1.Post('https://api.imgur.com/3/image.xml',FormData);
  except
    Form1.Left:=Screen.Width div 2 - Form1.Width div 2;
    Form1.Top:=Screen.Height div 2 - Form1.Height div 2;
  end;
  if IdHTTP1.ResponseCode=200 then begin
    delete(source,1,pos('<link>',source)+5);
    delete(source,pos('<',source),length(source)-pos('<',source)+1);
    clipboard.AsText:=source;
    StatusBar1.SimpleText:=' Ссылка скопирована в буфер';
    if (UseHotKey=true) and (UseTray=true) then ShowNotify('Ссылка скопирована в буфер');
  end else begin
    StatusBar1.SimpleText:=' Ошибка загрузки на сервер';
    if (UseHotKey=true) and (UseTray=true) then ShowNotify('Ошибка загрузки на сервер');
  end;
  FormData.Free;
  if UseTray then begin
    Form1.Left:=Screen.Width div 2 - Form1.Width div 2;
    Form1.Top:=Screen.Height div 2 - Form1.Height div 2;
  end;
end;}

procedure TMain.PostImgToHosting(Img: string);
var
  source: string;
  FormData: TIdMultiPartFormDataStream;
begin
  StatusBar.SimpleText:=' Загрузка изображения';
  FormData:=TIdMultiPartFormDataStream.Create;
  FormData.AddFile('userfile', img, '');
  FormData.AddFormField('file2', '');
  FormData.AddFormField('title', '');
  FormData.AddFormField('resize_x', '800');
  FormData.AddFormField('private_code', '');
  Main.IdHTTP1.Request.ContentType:='multipart/form-data';;
  try
    source:=Main.IdHTTP1.Post('http://pixs.ru/redirects/upload.php',FormData);
  except
    Main.Left:=Screen.Width div 2 - Main.Width div 2;
    Main.Top:=Screen.Height div 2 - Main.Height div 2;
  end;
  if Pos('успешно загружена',source) > 0 then begin
    delete(source, 1, Pos('Прямая ссылка:', source));
    delete(source, 1, Pos('http', source) - 1);
    delete(source, Pos('''>', source), Length(source) - pos('''>', source) + 1);
    ClipBoard.AsText:=source;
    StatusBar.SimpleText:=' Ссылка скопирована в буфер';
    if (UseHotKey=true) and (UseTray=true) then ShowNotify('Ссылка скопирована в буфер');
  end else begin
    StatusBar.SimpleText:=' Ошибка загрузки на сервер';
    if (UseHotKey=true) and (UseTray=true) then ShowNotify('Ошибка загрузки на сервер');
  end;
  FormData.Free;
  if UseTray then begin
    Main.Left:=Screen.Width div 2 - Main.Width div 2;
    Main.Top:=Screen.Height div 2 - Main.Height div 2;
  end;
end;

procedure TMain.WMDropFiles(var Msg: TMessage);
var
  i, Amount, Size: integer;
  Filename: PChar;
  Path: string;
begin
  inherited;
  Amount:=DragQueryFile(Msg.WParam, $FFFFFFFF, Filename, 255);
  for i:=0 to (Amount-1) do begin
    Size:=DragQueryFile(Msg.WParam, i, nil, 0) + 1;
    Filename:=StrAlloc(Size);
    DragQueryFile(Msg.WParam, i, Filename, Size);
    Path:=StrPas(Filename);
    StrDispose(Filename);
  end;
  DragFinish(Msg.WParam);
  if (AnsiLowerCase(ExtractFileExt(path))='.jpg') or (AnsiLowerCase(ExtractFileExt(path))='.png')
  or (AnsiLowerCase(ExtractFileExt(path))='.bmp') or (AnsiLowerCase(ExtractFileExt(path))='.gif')
  or (AnsiLowerCase(ExtractFileExt(path))='.jpeg') then PostImgToHosting(path) else
  Main.StatusBar.SimpleText:=' Неверный формат изображения';
end;

procedure TMain.WMHotKey(var Msg: TWMHotKey);
begin
  if Msg.HotKey=101 then
    case HotKeyMode of
    0: AreaBtn.Click;
    1: FullScrBtn.Click;
    2: WndBtn.Click;
    3: ChsAct.Show;
  end;
end;

procedure TMain.StatusBarClick(Sender: TObject);
begin
  Application.MessageBox('Cнимки 1.0.9' + #13#10 + 'Последнее обновление: 21.06.2017' + #13#10 + 'http://r57zone.github.io' + #13#10 + 'r57zone@gmail.com', 'О программе...',0);
end;

procedure TMain.ControlWindow(var Msg: TMessage);
begin
  if (Msg.WParam=SC_Minimize) and (UseTray) then begin
    Tray(1);
    SetWindowLong(Application.Handle, GWL_EXSTYLE, GetWindowLong(Application.Handle,GWL_EXSTYLE) or WS_EX_TOOLWINDOW);
    ShowWindow(Handle, SW_HIDE);
  end else
  inherited;
end;

procedure TMain.IconMouse(var Msg: Tmessage);
begin
  case Msg.LParam of
    WM_LButtonUp:
      begin
        Tray(2);
        if (Main.Left=Screen.Width) and (Main.Top=Screen.Height) then begin
          Main.Left:=Screen.Width div 2 - Main.Width div 2;
          Main.Top:=Screen.Height div 2 - Main.Height div 2;
        end;
        SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
        ShowWindow(Handle, SW_SHOW);
        SetForegroundWindow(Handle);
      end;

    WM_RButtonUp: PopupMenu.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
  end;
end;

procedure TMain.SettgsBtnClick(Sender: TObject);
begin
  Settings.ShowModal;
end;

procedure TMain.N3Click(Sender: TObject);
begin
  Settings.ShowModal;
end;

procedure TMain.N1Click(Sender: TObject);
begin
  Close;
end;

function GetWindowsDir:string;
var
  Name: array [0..255] of Char;
begin
  GetWindowsDirectory(Name, SizeOf(Name));
  Result:=Name;
end;

procedure TMain.ShowNotify(NotifyMessage: string);
begin
  if Trim(NotificationPath)='' then
    PlaySound(PChar(GetWindowsDir+'\Media\notify.wav'), 0, SND_ASYNC)
  else
    WinExec(PChar(StringReplace(NotificationPath, '%NotifyMessage%', NotifyMessage, [rfReplaceAll])), SW_ShowNormal);
end;

procedure TMain.ScreenShotWindow(Window: HWND);
var
  c: TCanvas;
  r, t: TRect;
  JPEG: TJPEGImage;
  i: integer;
begin
  if Window = 0 then begin
    Main.StatusBar.SimpleText:=' Окно не найдено';
    Exit;
  end;
  SetForegroundWindow(Window);
  c:=TCanvas.Create;
  c.Handle:=GetWindowDC(GetDesktopWindow);
  GetWindowRect(Window, t);
  try
    r:=Rect(0, 0, t.Right - t.Left, t.Bottom - t.Top);
    Bitmap.Width:=t.Right - t.Left;
    Bitmap.Height:=t.Bottom - t.Top;
    Bitmap.Canvas.CopyRect(r, c, t);
    JPEG:=TJPEGImage.Create;
    JPEG.Assign(Bitmap);
    JPEG.CompressionQuality:=100;
    JPEG.Compress;
    i:=0;
    while true do begin
      inc(i);
      if not FileExists(MyPath+'\Screenshot_'+IntToStr(i)+'.jpg') then begin
        JPEG.SaveToFile(MyPath+'\Screenshot_'+IntToStr(i)+'.jpg');
        if Main.UploadCB.Checked = false then begin
          Main.StatusBar.SimpleText:=' Снимок сохранен';
          if (UseHotKey=true) and (UseTray=true) then Main.ShowNotify('Снимок сохранен');
        end;
        break;
      end;
    end;
    if FileExists(MyPath+'\Screenshot_'+IntToStr(i)+'.jpg') and Main.UploadCB.Checked then begin
      Main.PostImgToHosting(MyPath+'\Screenshot_'+IntToStr(i)+'.jpg');
      if Main.SaveCB.Checked=false then DeleteFile(MyPath+'\Screenshot_'+IntToStr(i)+'.jpg');
    end;
  finally
    JPEG.Free;
    ReleaseDC(0,c.Handle);
    c.Free;
  end;
end;

end.
