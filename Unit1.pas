unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, JPEG, XPMan, ExtCtrls, ClipBRD, ShellAPI, IniFiles,
  Buttons, Menus, MMSystem, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, IdMultipartFormData;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    XPManifest1: TXPManifest;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    SpeedButton1: TSpeedButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    IdHTTP1: TIdHTTP;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure StatusBar1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
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
    procedure PostImgToHosting(Img:string);
    procedure ShowNotify(NotifyMessage:string);
    { Public declarations }
  end;

var
  Form1: TForm1;
  Bitmap: TBitmap;
  MyPath, NotificationPath: string;
  UseHotKey, UseTray: boolean;
  HotKeyMode, LeftT, TopT: integer;

implementation

uses Unit2, Unit3, Unit4;

{$R *.dfm}

procedure ScreenShot;
var
  c:TCanvas;
  r:TRect;
  JPEG:TJPEGImage;
  i:integer;
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
      if not FileExists(MyPath+'\snapshot'+IntToStr(i)+'.jpg') then begin
        JPEG.SaveToFile(MyPath+'\snapshot'+IntToStr(i)+'.jpg');
        if Form1.CheckBox1.Checked=false then begin
          Form1.StatusBar1.SimpleText:=' Снимок сохранен';
          if (UseHotKey=true) and (UseTray=true) then Form1.ShowNotify('Снимок сохранен');
        end;
        break;
      end;
    end;
    JPEG.Free;
    if FileExists(MyPath+'\snapshot'+IntToStr(i)+'.jpg') and Form1.CheckBox1.Checked then begin
      Form1.PostImgToHosting(MyPath+'\snapshot'+IntToStr(i)+'.jpg');
      if Form1.CheckBox2.Checked=false then DeleteFile(MyPath+'\snapshot'+IntToStr(i)+'.jpg');
    end;
  finally
    ReleaseDC(0, c.Handle);
    c.Free;
  end;
end;

procedure ScreenShotActiveWindow;
var
  c: TCanvas;
  r, t: TRect;
  h: THandle;
  JPEG: TJPEGImage;
  i: integer;
begin
  c:=TCanvas.Create;
  c.Handle:=GetWindowDC(GetDesktopWindow);
  h:=GetForeGroundWindow;
  while h=Application.Handle do Application.ProcessMessages;
  if h<>0 then GetWindowRect(h, t);
  try
    r:=Rect(0,0,t.Right-t.Left,t.Bottom-t.Top);
    Bitmap.Width:=t.Right-t.Left;
    Bitmap.Height:=t.Bottom-t.Top;
    Bitmap.Canvas.CopyRect(r, c, t);
    JPEG:=TJPEGImage.Create;
    JPEG.Assign(Bitmap);
    JPEG.CompressionQuality:=100;
    JPEG.Compress;
    i:=0;
    while true do begin
      inc(i);
      if not FileExists(MyPath+'\snapshot'+IntToStr(i)+'.jpg') then begin
        JPEG.SaveToFile(MyPath+'\snapshot'+IntToStr(i)+'.jpg');
        if Form1.CheckBox1.Checked=false then begin
          Form1.StatusBar1.SimpleText:=' Снимок сохранен';
          if (UseHotKey=true) and (UseTray=true) then Form1.ShowNotify('Снимок сохранен');
        end;
        break;
      end;
    end;
    JPEG.Free;
    if FileExists(MyPath+'\snapshot'+IntToStr(i)+'.jpg') and Form1.CheckBox1.Checked then begin
      Form1.PostImgToHosting(MyPath+'\snapshot'+IntToStr(i)+'.jpg');
      if Form1.CheckBox2.Checked=false then DeleteFile(MyPath+'\snapshot'+IntToStr(i)+'.jpg');
    end;
  finally
    ReleaseDC(0,c.Handle);
    c.Free;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  TopT:=Top;
  LeftT:=Left;
  Left:=Screen.Width;
  Top:=Screen.Height;
  Form2.ShowModal;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  TopT:=Top;
  LeftT:=Left;
  Left:=Screen.Width;
  Top:=Screen.Height;
  ScreenShot;
  Top:=TopT;
  Left:=LeftT;
end;

procedure Tray(n:integer);
var
  nim: TNotifyIconData;
begin
  with nim do begin
    cbSize:=SizeOf(nim);
    wnd:=Form1.Handle;
    uid:=1;
    uflags:=nif_icon or nif_message or nif_tip;
    hicon:=Application.Icon.Handle;
    ucallbackmessage:=WM_User+1;
    //sztip:='Снимки';
    StrCopy(szTip, PChar(Form1.Caption));
  end;
  case n of
    1: Shell_NotifyIcon(nim_add,@nim);
    2: Shell_NotifyIcon(nim_delete,@nim);
    3: Shell_NotifyIcon(nim_modify,@nim);
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if UseHotKey then UnRegisterHotKey(Form1.Handle,101);
  Bitmap.Free;
  if UseTray then Tray(2);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  IdHttp1.Request.CustomHeaders.Add('Authorization:Client-ID 2dee61a2a821ed3');

  Form1.Left:=Screen.Width div 2 - Form1.Width div 2;
  Form1.Top:=Screen.Height div 2 - Form1.Height div 2;

  Ini:=TIniFile.Create(ExtractFilePath(paramstr(0))+'config.ini');

  MyPath:=Ini.ReadString('Main','Path','');
  if trim(MyPath)='' then MyPath:=ExtractFileDir(ParamStr(0));

  if Ini.ReadInteger('Main','Mode',0)=1 then CheckBox2.Checked:=true;
  if Ini.ReadInteger('Main','Mode',0)=2 then begin CheckBox1.Checked:=false; CheckBox2.Checked:=true; end;

  if Ini.ReadInteger('Main','Hotkey',0)=1 then UseHotKey:=true else UseHotKey:=false;

  if UseHotKey then begin
    RegisterHotKey(Form1.Handle,101,0,VK_SNAPSHOT);
    HotKeyMode:=Ini.ReadInteger('Main','HotKeyMode',0);
    NotificationPath:=Ini.ReadString('Main','Notification','');
  end;

  if Ini.ReadInteger('Main','Tray',0)=1 then UseTray:=true else UseTray:=false;

  if UseTray then begin
    Tray(1);
    SetWindowLong(Application.Handle,GWL_EXSTYLE,GetWindowLong(Application.Handle,GWL_EXSTYLE) or WS_EX_TOOLWINDOW);
    Form1.Left:=Screen.Width;
    Form1.Top:=Screen.Height;
  end;

  Ini.Free;
  Button1.ControlState:=[csFocusing];
  Bitmap:=TBitmap.Create;
  Application.Title:=Caption;
  DragAcceptFiles(Handle, True);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  TopT:=Top;
  LeftT:=Left;
  Left:=Screen.Width;
  Top:=Screen.Height;
  Form1.Visible:=false;
  sleep(50);
  ScreenShotActiveWindow;
  Form1.Visible:=true;
  Top:=TopT;
  Left:=LeftT;
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

procedure TForm1.PostImgToHosting(Img: string);
var
  source: string;
  FormData: TIdMultiPartFormDataStream;
begin
  StatusBar1.SimpleText:=' Загрузка изображения';
  FormData:=TIdMultiPartFormDataStream.Create;
  FormData.AddFile('userfile', img, '');
  FormData.AddFormField('file2', '');
  FormData.AddFormField('title', '');
  FormData.AddFormField('resize_x', '800');
  FormData.AddFormField('private_code', '');
  Form1.IdHTTP1.Request.ContentType:='multipart/form-data';;
  try
    source:=Form1.IdHTTP1.Post('http://pixs.ru/redirects/upload.php',FormData);
  except
    Form1.Left:=Screen.Width div 2 - Form1.Width div 2;
    Form1.Top:=Screen.Height div 2 - Form1.Height div 2;
  end;
  if Pos('успешно загружена',source)>0 then begin
    delete(source,1,pos('Прямая ссылка:',source));
    delete(source,1,pos('http',source)-1);
    delete(source,Pos('''>',source),Length(source)-pos('''>',source)+1);
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
end;

procedure TForm1.WMDropFiles(var Msg: TMessage);
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
  Form1.StatusBar1.SimpleText:=' Неверный формат изображения';
end;

procedure TForm1.WMHotKey(var Msg: TWMHotKey);
begin
  if Msg.HotKey=101 then
    case HotKeyMode of
    0: Button1.Click;
    1: Button2.Click;
    2: Button3.Click;
    3: Form3.Show;
  end;
end;

procedure TForm1.StatusBar1Click(Sender: TObject);
begin
  Application.MessageBox('Cнимки 1.0.8'+#13#10+'Последнее обновление: 04.06.2016'+#13#10+'https://github.com/r57zone/Snapshots-for-Windows'+#13#10+'r57zone@gmail.com','О программе...',0);
end;

procedure TForm1.ControlWindow(var Msg: TMessage);
begin
  if (Msg.wparam=SC_Minimize) and (UseTray) then begin
    Tray(1);
    SetWindowLong(Application.Handle,GWL_EXSTYLE,GetWindowLong(Application.Handle,GWL_EXSTYLE) or WS_EX_TOOLWINDOW);
    ShowWindow(Handle,SW_HIDE);
  end else
  inherited;
end;

procedure TForm1.IconMouse(var Msg: Tmessage);
begin
  case Msg.lparam of
    WM_LButtonUp:
      begin
        Tray(2);
        if (Form1.Left=Screen.Width) and (Form1.Top=Screen.Height) then begin
          Form1.Left:=Screen.Width div 2 - Form1.Width div 2;
          Form1.Top:=Screen.Height div 2 - Form1.Height div 2;
        end;
        SetWindowLong(Handle, GWL_EXSTYLE,GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_APPWINDOW);
        ShowWindow(Handle,SW_SHOW);
        SetForegroundWindow(Handle);
      end;

    WM_RButtonUp:
      begin
        PopupMenu1.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
        //case MessageBox(Handle,'Закрыть приложение?','Снимки',35) of
        //6: Close;
        //end;
      end;
  end;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  Form4.ShowModal;
end;

procedure TForm1.N3Click(Sender: TObject);
begin
  Form4.ShowModal;
end;

procedure TForm1.N1Click(Sender: TObject);
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

procedure TForm1.ShowNotify(NotifyMessage: string);
begin
  if Trim(NotificationPath)='' then PlaySound(PChar(GetWindowsDir+'\Media\notify.wav'), 0, SND_ASYNC)
  else WinExec(PChar(StringReplace(NotificationPath,'%NotifyMessage%',NotifyMessage,[rfReplaceAll])), SW_ShowNormal);
end;

end.
