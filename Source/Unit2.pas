unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PNGImage;

type
  TCaptureArea = class(TForm)
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
  CaptureArea: TCaptureArea;
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

procedure TCaptureArea.FormCreate(Sender: TObject);
begin
  Left:=0;
  Top:=0;
  Width:=GetDesktopWidth;
  Height:=GetDesktopHeight;
  Caption:=ID_CAPTURE_AREA_TITLE;
end;

procedure TCaptureArea.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  isDown:=true;
  downX:=X;
  downY:=Y;
end;

procedure TCaptureArea.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if isDown then begin
    Self.Repaint;
    Self.Canvas.Pen.Color:=clWhite;
    //Self.Canvas.Pen.Width:=2;
    //Self.Canvas.Pen.Style:=psSolid;
    //Self.Canvas.Pen.Style:=psDash;
    Self.Canvas.Pen.Style:=psDot;
    Self.Canvas.Brush.Color:=clFuchsia;
    Self.Canvas.Rectangle(downX, downY, X, Y);
    {Self.Canvas.Rectangle(downX-3, downY-3, downX+3, downY+3);
    Self.Canvas.Rectangle(X-3, Y-3, X+3, Y+3);
    Self.Canvas.Rectangle(X-3, downY-3, X+3, downY+3);
    Self.Canvas.Rectangle(downX-3, Y-3, downX+3, Y+3);
    Self.Canvas.Rectangle(downX-3, (downY+Y) div 2-3, downX+3,(downY+Y) div 2+3);
    Self.Canvas.Rectangle(X-3, (downY + Y) div 2-3, X+3,(downY + Y) div 2+3);
    Self.Canvas.Rectangle((downX+X) div 2-3, downY-3,(downX + X) div 2+3, downY + 3);
    Self.Canvas.Rectangle((downX+X) div 2-3, Y-3, (downX + X) div 2+3,Y+3);}
  end;
end;

procedure TCaptureArea.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  MyRect: TRect;
  PNG: TPNGObject;
  Bitmap: TBitmap;
  FileCounter, CrdTmp: integer;
  ScreenDC: HDC;
begin
  isDown:=false;
  if (DownX = X) or (DownY = Y) then begin
    Main.StatusBar.SimpleText:=' ' + ID_WRONG_CAPTURE_AREA;
    Close;
    Exit;
  end;

  if (GetAsyncKeyState(VK_ESCAPE) and $8000) <> 0 then begin
    Main.StatusBar.SimpleText:=' ' + ID_CAPTURE_AREA_CANCELED;
    Close;
    Exit;
  end;

  if DownX > X then begin
    CrdTmp:=downX;
    DownX:=X;
    X:=CrdTmp;
  end;

  if DownY > Y then begin
    CrdTmp:=DownY;
    DownY:=Y;
    Y:=CrdTmp;
  end;

  MyRect.Left:=downX;
  MyRect.Top:=downY;
  MyRect.Right:=X;
  MyRect.Bottom:=Y;
  CaptureArea.Visible:=false;

  Bitmap:=TBitmap.Create;
  Bitmap.Width:=MyRect.Right - MyRect.Left;
  Bitmap.Height:=MyRect.Bottom - MyRect.Top;
  ScreenDC:=GetDC(0);
  try
    BitBlt(Bitmap.Canvas.Handle, 0, 0, Bitmap.Width, Bitmap.Height, ScreenDC, MyRect.Left, MyRect.Top, SRCCOPY);
  finally
    ReleaseDC(0, ScreenDC);
  end;

  PNG:=TPNGObject.Create;
  PNG.Assign(Bitmap);
  FileCounter:=0;
  while true do begin
    Inc(FileCounter);
    if not FileExists(MyPath + ScrName + IntToStr(FileCounter) + '.png') then begin
      PNG.SaveToFile(MyPath + ScrName + IntToStr(FileCounter)+ '.png');
      if Main.UploadCB.Checked = false then begin
        Main.StatusBar.SimpleText:=' ' + ID_SCREENSHOT_SAVED;
        if (UseHotKey) and (UseTray) then
          Main.ShowNotify(ID_SCREENSHOT_SAVED);
      end;
      break;
    end;
  end;
  PNG.Free;
  Bitmap.Free;
  if (FileExists(MyPath + ScrName + IntToStr(FileCounter) + '.png')) and (Main.UploadCB.Checked) then begin
    Main.PicToHost(MyPath + ScrName + IntToStr(FileCounter) + '.png');
    if Main.SaveCB.Checked = false then
      DeleteFile(MyPath + ScrName + IntToStr(FileCounter) + '.png');
  end;

  Close;
end;

procedure TCaptureArea.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if UseTray = false then
    Main.AppShow;
end;

end.
 