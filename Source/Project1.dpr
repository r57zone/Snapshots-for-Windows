program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Main},
  Unit2 in 'Unit2.pas' {CaptureArea},
  Unit3 in 'Unit3.pas' {ChsAct},
  Unit4 in 'Unit4.pas' {Settings},
  Unit5 in 'Unit5.pas' {SelectWnd};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.CreateForm(TCaptureArea, CaptureArea);
  Application.CreateForm(TChsAct, ChsAct);
  Application.CreateForm(TSettings, Settings);
  Application.CreateForm(TSelectWnd, SelectWnd);
  Application.Run;
end.
