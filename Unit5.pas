unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TChsWnd = class(TForm)
    ListBox: TListBox;
    OkBtn: TButton;
    CancelBtn: TButton;
    procedure FormShow(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ChsWnd: TChsWnd;

implementation

uses Unit1;

{$R *.dfm}

procedure TChsWnd.FormShow(Sender: TObject);
var
  Window: HWND;
  Buff: array [0..127] of Char;
begin
  ListBox.Clear;
  Window:=GetWindow(Handle, GW_HWNDFIRST);
  while Window <> 0 do begin // Не показываем:
    if (Window <> Application.Handle) // Собственное окно
      and IsWindowVisible(Window) // Невидимые окна
      and (GetWindow(Window, GW_OWNER) = 0) // Дочерние окна
      and (GetWindowText(Window, Buff, SizeOf(Buff)) <> 0) then begin

        GetWindowText(Window, Buff, SizeOf(Buff));
        ListBox.Items.Add(StrPas(Buff));
      end;
    Window:=GetWindow(Window, GW_HWNDNEXT);
  end;
  ListBox.ItemIndex:=0;
end;

procedure TChsWnd.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TChsWnd.OkBtnClick(Sender: TObject);
begin
  if ListBox.ItemIndex <> -1 then begin
    Main.ScreenShotWindow(FindWindow(nil, PChar(ListBox.Items[ListBox.ItemIndex])));
    Close;
  end;
end;

end.
