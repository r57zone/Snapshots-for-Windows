unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm3 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  protected
    procedure CreateParams(var Params:TCreateParams);override;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm3.CreateParams(var Params: TCreateParams);
begin
inherited;
Params.WndParent:=Form1.Handle;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
Button1.ControlState:=[csFocusing];
end;

procedure TForm3.FormShow(Sender: TObject);
begin
SetForegroundWindow(Form3.Handle); 
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
Close;
Form1.Button1.Click;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
Close;
Form1.Button2.Click;
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
Close;
Form1.Button3.Click;
end;

end.
