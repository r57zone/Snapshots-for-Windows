unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TChsAct = class(TForm)
    AreaBtn: TButton;
    FullScrBtn: TButton;
    WndBtn: TButton;
    procedure FormShow(Sender: TObject);
    procedure AreaBtnClick(Sender: TObject);
    procedure FullScrBtnClick(Sender: TObject);
    procedure WndBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ChsAct: TChsAct;

implementation

uses Unit1;

{$R *.dfm}

procedure TChsAct.FormShow(Sender: TObject);
begin
  SetForegroundWindow(ChsAct.Handle);
end;

procedure TChsAct.AreaBtnClick(Sender: TObject);
begin
  Close;
  Main.AreaBtn.Click;
end;

procedure TChsAct.FullScrBtnClick(Sender: TObject);
begin
  Close;
  Main.FullScrBtn.Click;
end;

procedure TChsAct.WndBtnClick(Sender: TObject);
begin
  Close;
  Main.WndBtn.Click;
end;

end.
