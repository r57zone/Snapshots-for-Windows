unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ShlObj;

type
  TForm2 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  isDown: Boolean;
  downX, downY: integer;

implementation

uses Unit1;

{$R *.dfm}

function GetSpecialPath(CSIDL: word): string;
var
  s: string;
begin
  SetLength(s, MAX_PATH);
  if not SHGetSpecialFolderPath(0, PChar(s), CSIDL, true) then s:='';
  Result:=PChar(s);
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  BorderStyle:=bsNone;
  WindowState:=wsMaximized;
end;

procedure TForm2.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  isDown:=true;
  downX:=X;
  downY:=Y;
end;

procedure TForm2.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if isDown then begin
    Self.Repaint;
    Self.Canvas.Pen.Color:=clWhite;
    Self.Canvas.Pen.Width:=2;
    //Self.Canvas.Pen.Style:=psDot;
    Self.Canvas.Brush.Color:=clFuchsia;
    Self.Canvas.Rectangle(downX, downY, X, Y);
    Self.Canvas.Pen.Style:=psSolid;
    Self.Canvas.Brush.Color:=clblue;
    //Self.Canvas.Rectangle(downX-3, downY-3, downX+3, downY+3);
    //Self.Canvas.Rectangle(X-3, Y-3, X+3, Y+3);
    //Self.Canvas.Rectangle(X-3, downY-3, X+3, downY+3);
    //Self.Canvas.Rectangle(downX-3, Y-3, downX+3, Y+3);
    //Self.Canvas.Rectangle(downX-3, (downY+Y) div 2-3, downX+3,(downY+Y) div 2+3);
    //Self.Canvas.Rectangle(X-3, (downY + Y) div 2-3, X+3,(downY + Y) div 2+3);
    //Self.Canvas.Rectangle((downX+X) div 2-3, downY-3,(downX + X) div 2+3, downY + 3);
    //Self.Canvas.Rectangle((downX+X) div 2-3, Y-3, (downX + X) div 2+3,Y+3);
  end;
end;

function CaptureScreenRect(aRect: TRect): TBitMap;
var
  ScreenDC: HDC;
begin
  Result:=TBitMap.Create;
  with Result, aRect do begin
    Width:=Right-Left;
    Height:=Bottom-Top;
    ScreenDC:=GetDC(0);
    try
      BitBlt(Canvas.Handle, 0, 0, Width, Height, ScreenDC, Left, Top, SRCCOPY);
    finally
      ReleaseDC(0, ScreenDC);
    end;
  end;
end;

procedure TForm2.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  r: TRect;
  JPEG: TJPEGImage;
  i, tmp: integer;
begin
  isDown:=false;
  if (downX=x) or (downY=y) then begin
    Form1.StatusBar1.SimpleText:=' Неверно выбрана область захвата';
    Close;
    Exit;
  end;
  if GetAsyncKeyState(VK_ESCAPE)<>0 then begin Form1.StatusBar1.SimpleText:=' Захват области отменен'; Close; Exit; end;
  if downX>X then begin tmp:=downX; downX:=x; x:=tmp; end;
  if downY>Y then begin tmp:=downY; downY:=y; y:=tmp; end;
  r.Left:=downX;
  r.Top:=downY;
  r.Right:=X;
  r.Bottom:=Y;
  Form2.Visible:=false;
  Bitmap:=CaptureScreenRect(r);
  JPEG:=TJPEGImage.Create;
  JPEG.Assign(Bitmap);
  JPEG.CompressionQuality:=100;
  JPEG.Compress;
  for i:=1 to 999999 do
    if not FileExists(MyPath+'\snapshot'+IntToStr(i)+'.jpg') then begin
      JPEG.SaveToFile(MyPath+'\snapshot'+IntToStr(i)+'.jpg');
      if Form1.CheckBox1.Checked=false then begin
        Form1.StatusBar1.SimpleText:=' Снимок сохранен';
        if (UseHotKey=true) and (UseTray=true) then Form1.ShowNotify('Снимок сохранен');
      end;
      break;
    end;
  JPEG.Free;
  if FileExists(MyPath+'\snapshot'+IntToStr(i)+'.jpg') and Form1.CheckBox1.Checked then begin
    Form1.PostImgToHosting(MyPath+'\snapshot'+IntToStr(i)+'.jpg');
    if Form1.CheckBox2.Checked=false then DeleteFile(MyPath+'\snapshot'+IntToStr(i)+'.jpg');
  end;
  if UseHotKey=false then SetForegroundWindow(Form1.Handle);
  Close;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if TopT=Screen.Width then TopT:=Screen.Width div 2 - Form1.Width div 2;
  if LeftT=Screen.Height then LeftT:=Screen.Height div 2 - Form1.Height div 2;
  Form1.Top:=TopT;
  Form1.Left:=LeftT;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  if TopT=Screen.Width then TopT:=Screen.Width div 2 - Form1.Width div 2;
  if LeftT=Screen.Height then LeftT:=Screen.Height div 2 - Form1.Height div 2;
  Form1.Top:=TopT;
  Form1.Left:=LeftT;
end;

end.
 