unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShlObj, IniFiles;

type
  TSettings = class(TForm)
    DefActGB: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    ActHKGB: TGroupBox;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    PathEdt: TEdit;
    Label1: TLabel;
    ChsFolder: TButton;
    OkBtn: TButton;
    CancelBtn: TButton;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure ChsFolderClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Settings: TSettings;

implementation

uses Unit1;

{$R *.dfm}

function BrowseFolderDialog(Title:PChar):string;
var
  TitleName: string;
  lpItemId: pItemIdList;
  BrowseInfo: TBrowseInfo;
  DisplayName: array[0..Max_Path] of char;
  TempPath: array[0..Max_Path] of char;
begin
  FillChar(BrowseInfo,Sizeof(tBrowseInfo), #0);
  BrowseInfo.hwndowner:=GetDesktopWindow;
  BrowseInfo.pszdisplayname:=@DisplayName;
  TitleName:=Title;
  BrowseInfo.lpsztitle:=PChar(TitleName);
  BrowseInfo.ulflags:=bIf_ReturnOnlyFSDirs;
  lpItemId:=shBrowseForFolder(BrowseInfo);
  if lpItemId <> nil then begin
    shGetPathFromIdList(lpItemId, TempPath);
    Result:=TempPath;
    GlobalFreePtr(lpitemid);
  end;
end;

procedure TSettings.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  PathEdt.Text:=MyPath;

  if UseTray then
    CheckBox1.Checked:=true;

  if UseHotKey then
    case HotKeyMode of
      0: RadioButton5.Checked:=true;
      1: RadioButton6.Checked:=true;
      2: RadioButton7.Checked:=true;
      3: RadioButton8.Checked:=true;
    end;

  Ini:=TIniFile.Create(ExtractFilePath(paramstr(0))+'config.ini');
  if Ini.ReadInteger('Main','Mode',0)=1 then RadioButton2.Checked:=true;
  if Ini.ReadInteger('Main','Mode',0)=2 then RadioButton3.Checked:=true;
  Ini.Free;
end;

procedure TSettings.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TSettings.ChsFolderClick(Sender: TObject);
var
  TempPath: string;
begin
  TempPath:=BrowseFolderDialog('Выберите каталог');
  if TempPath<>'' then begin
    if TempPath[Length(TempPath)]='\' then Delete(TempPath,Length(TempPath),1);
    PathEdt.Text:=TempPath;
  end else ShowMessage('Не выбран каталог');
end;

procedure TSettings.OkBtnClick(Sender: TObject);
var
  Ini: TIniFile; ModeTmp: integer;
begin
  Ini:=TIniFile.Create(ExtractFilePath(paramstr(0))+'config.ini');

  if RadioButton1.Checked then ModeTmp:=0;
  if RadioButton2.Checked then ModeTmp:=1;
  if RadioButton3.Checked then ModeTmp:=2;
  Ini.WriteInteger('Main', 'Mode', ModeTmp);

  if PathEdt.Text <> MyPath then
    Ini.WriteString('Main', 'Path', PathEdt.Text);

  if RadioButton4.Checked then
    Ini.WriteInteger('Main', 'HotKey', 0)
  else
    Ini.WriteInteger('Main', 'HotKey', 1);

  ModeTmp:=0;
  if RadioButton5.Checked then ModeTmp:=0;
  if RadioButton6.Checked then ModeTmp:=1;
  if RadioButton7.Checked then ModeTmp:=2;
  if RadioButton8.Checked then ModeTmp:=3;
  Ini.WriteInteger('Main','HotKeyMode',ModeTmp);

  if CheckBox1.Checked then
    Ini.WriteInteger('Main','Tray',1) else Ini.WriteInteger('Main','Tray',0);

  Ini.Free;

  ShowMessage('Чтобы изменения вступили в силу, необходимо перезапустить программу.');
  Close;
end;

end.
