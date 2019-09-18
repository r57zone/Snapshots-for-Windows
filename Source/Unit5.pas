unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TSelectWnd = class(TForm)
    ListBox: TListBox;
    OkBtn: TButton;
    CancelBtn: TButton;
    procedure FormShow(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SelectWnd: TSelectWnd;

implementation

uses Unit1;

{$R *.dfm}

procedure TSelectWnd.FormShow(Sender: TObject);
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

procedure TSelectWnd.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TSelectWnd.OkBtnClick(Sender: TObject);
begin
  if ListBox.ItemIndex <> -1 then begin
    Main.AppHide;
    Main.ScreenShotWindow(FindWindow(nil, PChar(ListBox.Items[ListBox.ItemIndex])));
    Main.AppShow;
    Close;
  end;
end;

procedure TSelectWnd.FormCreate(Sender: TObject);
begin
  Caption:=ID_SELECT_WINDOW_TITLE;
  OkBtn.Caption:=ID_OK;
  CancelBtn.Caption:=ID_CANCEL;
end;

end.
