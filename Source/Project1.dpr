program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Main},
  Unit2 in 'Unit2.pas' {ChsArea},
  Unit3 in 'Unit3.pas' {ChsAct},
  Unit4 in 'Unit4.pas' {Settings},
  Unit5 in 'Unit5.pas' {ChsWnd};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.CreateForm(TChsArea, ChsArea);
  Application.CreateForm(TChsAct, ChsAct);
  Application.CreateForm(TSettings, Settings);
  Application.CreateForm(TChsWnd, ChsWnd);
  Application.Run;
end.
