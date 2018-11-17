unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PNGImage;

type
  TChsArea = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ChsArea: TChsArea;
  isDown: Boolean;
  downX, downY: integer;

implementation

uses Unit1;

{$R *.dfm}

function GetDesktopWidth: integer;
var
  i: integer;
begin
  Result:=Screen.Width;
  if Screen.MonitorCount > 0 then
    for i:=1 to Screen.MonitorCount - 1 do
      Result:=Result + Screen.Monitors[i].Width;
end;

function GetDesktopHeight: integer;
var
  i: integer;
begin
  Result:=Screen.Height;
  if Screen.MonitorCount > 0 then
    for i:=1 to Screen.MonitorCount - 1 do
      if Screen.Monitors[i].Height > Result then
        Result:=Screen.Monitors[i].Height;
end;

procedure TChsArea.FormCreate(Sender: TObject);
begin
  Left:=0;
  Top:=0;
  Width:=GetDesktopWidth;
  Height:=GetDesktopHeight;
end;

procedure TChsArea.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  isDown:=true;
  downX:=X;
  downY:=Y;
end;

procedure TChsArea.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
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

procedure TChsArea.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  r: TRect;
  PNG: TPNGObject;
  Bitmap: TBitmap;
  i, tmp: integer;
  ScreenDC: HDC;
begin
  isDown:=false;
  if (downX = x) or (downY = y) then begin
    Main.StatusBar.SimpleText:=' ������� ������� ������� �������';
    Close;
    Exit;
  end;

  if (GetAsyncKeyState(VK_ESCAPE) and $8000) <> 0 then begin
    Main.StatusBar.SimpleText:=' ������ ������� �������';
    Close;
    Exit;
  end;

  if downX > X then begin
    tmp:=downX;
    downX:=x;
    x:=tmp;
  end;

  if downY > Y then begin
    tmp:=downY;
    downY:=y;
    y:=tmp;
  end;

  r.Left:=downX;
  r.Top:=downY;
  r.Right:=X;
  r.Bottom:=Y;
  ChsArea.Visible:=false;

  Bitmap:=TBitmap.Create;
  Bitmap.Width:=r.Right - r.Left;
  Bitmap.Height:=r.Bottom - r.Top;
  ScreenDC:=GetDC(0);
  try
    BitBlt(Bitmap.Canvas.Handle, 0, 0, Bitmap.Width, Bitmap.Height, ScreenDC, r.Left, r.Top, SRCCOPY);
  finally
    ReleaseDC(0, ScreenDC);
  end;

  PNG:=TPNGObject.Create;
  PNG.Assign(Bitmap);
  i:=0;
  while true do begin
    inc(i);
    if not FileExists(MyPath + ScrName + IntToStr(i) + '.png') then begin
      PNG.SaveToFile(MyPath + ScrName + IntToStr(i)+ '.png');
      if Main.UploadCB.Checked = false then begin
        Main.StatusBar.SimpleText:=' ������ ��������';
        if (UseHotKey) and (UseTray) then
          Main.ShowNotify('������ ��������');
      end;
      break;
    end;
  end;
  PNG.Free;
  Bitmap.Free;
  if (FileExists(MyPath + ScrName + IntToStr(i) + '.png')) and (Main.UploadCB.Checked) then begin
    Main.PicToHost(MyPath + ScrName + IntToStr(i) + '.png');
    if Main.SaveCB.Checked = false then
      DeleteFile(MyPath + ScrName + IntToStr(i) + '.png');
  end;

  Close;
end;

procedure TChsArea.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if UseTray = false then
    Main.MainShow;
end;

end.
 