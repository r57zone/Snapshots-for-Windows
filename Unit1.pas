unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, JPEG, ShlObj, XPMan, ExtCtrls,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdMultipartFormData, ClipBRD, ShellAPI, IniFiles;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    XPManifest1: TXPManifest;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    IdHTTP1: TIdHTTP;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure StatusBar1Click(Sender: TObject);
  protected
    procedure WMDropFiles (var Msg: TMessage); message wm_DropFiles;
  private
    procedure WMHotKey(var Msg : TWMHotKey); message WM_HOTKEY;
    { Private declarations }
  public
    procedure postimgtohosting(img:string);
    { Public declarations }
  end;

var
  Form1: TForm1;
  Bitmap: TBitmap;
  MyPath:string;
  UseHotKey:boolean;
  HotKeyMode:integer;

implementation

uses Unit2, Unit3;

{$R *.dfm}

function GetSpecialPath(CSIDL: word): string;
var
s:string;
begin
SetLength(s, MAX_PATH);
if not SHGetSpecialFolderPath(0, PChar(s), CSIDL, true)
then s:='';
result:=PChar(s);
end;

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
for i:=1 to 999999 do
if not fileexists(MyPath+'\snapshot'+inttostr(i)+'.jpg') then begin
JPEG.SaveToFile(MyPath+'\snapshot'+inttostr(i)+'.jpg');
if Form1.CheckBox1.Checked=false then Form1.StatusBar1.SimpleText:=' Снимок сохранен';
break;
end;
JPEG.Free;
if fileexists(MyPath+'\snapshot'+inttostr(i)+'.jpg') and Form1.CheckBox1.Checked then begin
Form1.postimgtohosting(MyPath+'\snapshot'+inttostr(i)+'.jpg');
if Form1.CheckBox2.Checked=false then DeleteFile(MyPath+'\snapshot'+inttostr(i)+'.jpg');
end;
finally
ReleaseDC(0, c.Handle);
c.Free;
end;
end;

procedure ScreenShotActiveWindow;
var
c:TCanvas;
r,t:TRect;
h:THandle;
JPEG:TJPEGImage;
i:integer;
begin
c:= TCanvas.Create;
c.Handle := GetWindowDC(GetDesktopWindow);
h := GetForeGroundWindow;
if h <> 0 then
GetWindowRect(h, t);
try
r := Rect(0,0,t.Right-t.Left,t.Bottom-t.Top);
Bitmap.Width:=t.Right-t.Left;
Bitmap.Height:=t.Bottom-t.Top;
Bitmap.Canvas.CopyRect(r, c, t);
JPEG:=TJPEGImage.Create;
JPEG.Assign(Bitmap);
for i:=1 to 999999 do
if not fileexists(MyPath+'\snapshot'+inttostr(i)+'.jpg') then begin
JPEG.SaveToFile(MyPath+'\snapshot'+inttostr(i)+'.jpg');
if Form1.CheckBox1.Checked=false then Form1.StatusBar1.SimpleText:=' Снимок сохранен';
break;
end;
JPEG.Free;
if fileexists(MyPath+'\snapshot'+inttostr(i)+'.jpg') and Form1.CheckBox1.checked then begin
Form1.postimgtohosting(MyPath+'\snapshot'+inttostr(i)+'.jpg');
if Form1.CheckBox2.Checked=false then DeleteFile(MyPath+'\snapshot'+inttostr(i)+'.jpg');
end;
finally
ReleaseDC(0,c.Handle);
c.Free;
end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
Hide;
Form2.ShowModal;
Show;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Hide;
ScreenShot;
Show;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if UseHotKey then UnRegisterHotKey(Form1.Handle,101);
Bitmap.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
Ini:TIniFile;
begin
Ini:=TIniFile.Create(extractfilepath(paramstr(0))+'config.ini');

MyPath:=Ini.ReadString('Main','Path','');
if trim(MyPath)='' then MyPath:=GetSpecialPath(CSIDL_DESKTOP);

if Ini.ReadInteger('Main','Mode',0)=1 then CheckBox2.Checked:=true;
if Ini.ReadInteger('Main','Mode',0)=2 then begin Checkbox1.Checked:=false; CheckBox2.Checked:=true; end;

if Ini.ReadInteger('Main','Hotkey',0)=1 then UseHotKey:=true else UseHotKey:=false;
if UseHotKey then begin
RegisterHotKey(Form1.Handle,101,0,VK_SNAPSHOT);
HotKeyMode:=Ini.ReadInteger('Main','HotKeyMode',0);
end;

Ini.Free;
Button1.ControlState:=[csFocusing];
Bitmap:=TBitmap.Create;
Application.Title:=caption;
DragAcceptFiles(Handle, True);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
Hide;
ScreenShotActiveWindow;
Show;
end;

procedure TForm1.postimgtohosting(img: string); 
var
source:string;
FormData: TIdMultiPartFormDataStream;
begin
Form1.StatusBar1.SimpleText:=' Загрузка изображения';
FormData:=TIdMultiPartFormDataStream.Create;
FormData.AddFile('userfile', img, '');
FormData.AddFormField('file2', '');
FormData.AddFormField('title', '');
FormData.AddFormField('resize_x', '800');
FormData.AddFormField('private_code', '');
Form1.IdHTTP1.Request.ContentType:='multipart/form-data';
try
source:=Form1.idhttp1.Post('http://pixs.ru/redirects/upload.php',FormData);
except
end;
if pos('успешно загружена',source)>0 then begin
delete(source,1,pos('Прямая ссылка:',source));
delete(source,1,pos('http',source)-1);
delete(source,pos('''>',source),length(source)-pos('''>',source)+1);
clipboard.AsText:=source;
Form1.StatusBar1.SimpleText:=' Ссылка скопирована в буфер'; end else
Form1.StatusBar1.SimpleText:=' Ошибка загрузки на сервер';
FormData.Free;
end;

procedure TForm1.WMDropFiles(var Msg: TMessage);
var
i, amount, size: integer;
Filename: PChar; path:string;
begin
inherited;
Amount := DragQueryFile(Msg.WParam, $FFFFFFFF, Filename, 255);
for i := 0 to (Amount - 1) do
begin
size := DragQueryFile(Msg.WParam, i, nil, 0) + 1;
Filename := StrAlloc(size);
DragQueryFile(Msg.WParam, i, Filename, size);
path:=StrPas(Filename);
StrDispose(Filename);
end;
DragFinish(Msg.WParam);
if (ansiuppercase(copy(path, length(path)-2,3))='JPG') or (ansiuppercase(copy(path, length(path)-2,3))='PNG')
or (ansiuppercase(copy(path, length(path)-2,3))='BMP') or (ansiuppercase(copy(path, length(path)-2,3))='GIF') then postimgtohosting(path) else Form1.StatusBar1.SimpleText:=' Неверный формат изображения';
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
Application.MessageBox('Cнимки 0.4'+#13#10+'https://github.com/r57zone'+#13#10+'Последнее обновление: 06.10.2014','О программе...',0);
end;

end.
