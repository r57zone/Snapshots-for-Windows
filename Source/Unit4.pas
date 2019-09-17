unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShlObj, IniFiles;

type
  TSettings = class(TForm)
    DefActGB: TGroupBox;
    UploadRB: TRadioButton;
    UploadSaveRB: TRadioButton;
    SaveRB: TRadioButton;
    HKActGB: TGroupBox;
    HKNotUseRB: TRadioButton;
    HKAreaRB: TRadioButton;
    HKFullScrRB: TRadioButton;
    HKWNDRB: TRadioButton;
    HKShowDlgRB: TRadioButton;
    SaveScrPathLbl: TLabel;
    OkBtn: TButton;
    CancelBtn: TButton;
    TrayCB: TCheckBox;
    PicHostGB: TGroupBox;
    ImgurKeyEdt: TEdit;
    ChsFolderBtn: TButton;
    PathScrEdt: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure ChsFolderBtnClick(Sender: TObject);
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

function BrowseFolderDialog(Title: PChar): string;
var
  TitleName: string;
  lpItemid: pItemIdList;
  BrowseInfo: TBrowseInfo;
  DisplayName: array[0..MAX_PATH] of Char;
  TempPath: array[0..MAX_PATH] of Char;
begin
  FillChar(BrowseInfo, SizeOf(TBrowseInfo), #0);
  BrowseInfo.hwndOwner:=GetDesktopWindow;
  BrowseInfo.pSzDisplayName:=@DisplayName;
  TitleName:=Title;
  BrowseInfo.lpSzTitle:=PChar(TitleName);
  BrowseInfo.ulFlags:=BIF_NEWDIALOGSTYLE;
  lpItemId:=shBrowseForFolder(BrowseInfo);
  if lpItemId <> nil then begin
    shGetPathFromIdList(lpItemId, TempPath);
    Result:=TempPath;
    GlobalFreePtr(lpItemId);
  end;
end;

procedure TSettings.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  PathScrEdt.Text:=MyPath;

  if UseTray then
    TrayCB.Checked:=true;

  if UseHotKey then
    case HotKeyMode of
      0: HKAreaRB.Checked:=true;
      1: HKFullScrRB.Checked:=true;
      2: HKWNDRB.Checked:=true;
      3: HKShowDlgRB.Checked:=true;
    end;

  Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini');
  if Ini.ReadInteger('Main', 'Mode', 0 ) = 1 then UploadSaveRB.Checked:=true;
  if Ini.ReadInteger('Main', 'Mode', 0 ) = 2 then SaveRB.Checked:=true;

  ImgurKeyEdt.Text:=Ini.ReadString('Main', 'ImgurClientID', '');

  Ini.Free;
end;

procedure TSettings.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TSettings.ChsFolderBtnClick(Sender: TObject);
var
  TempPath: string;
begin
  TempPath:=BrowseFolderDialog('Выберите папку');
  if TempPath <> '' then begin
    if TempPath[Length(TempPath)] <> '\' then
      TempPath:=TempPath + '\';
    PathScrEdt.Text:=TempPath;
  end else ShowMessage('Папка не выбрана');
end;

procedure TSettings.OkBtnClick(Sender: TObject);
var
  Ini: TIniFile; ModeTmp: integer;
begin
  Ini:=TIniFile.Create(ExtractFilePath(paramstr(0)) + 'Config.ini');

  if UploadRB.Checked then
    ModeTmp:=0;

  if UploadSaveRB.Checked then
    ModeTmp:=1;
  if SaveRB.Checked then
    ModeTmp:=2;
  Ini.WriteInteger('Main', 'Mode', ModeTmp);

  if PathScrEdt.Text <> MyPath then
    Ini.WriteString('Main', 'Path', PathScrEdt.Text);

  if HKNotUseRB.Checked then
    Ini.WriteBool('Main', 'HotKey', false)
  else
    Ini.WriteBool('Main', 'HotKey', true);

  ModeTmp:=0;
  if HKAreaRB.Checked then ModeTmp:=0;
  if HKFullScrRB.Checked then ModeTmp:=1;
  if HKWNDRB.Checked then ModeTmp:=2;
  if HKShowDlgRB.Checked then ModeTmp:=3;
  Ini.WriteInteger('Main', 'HotKeyMode', ModeTmp);

  Ini.WriteBool('Main', 'Tray', TrayCB.Checked);

  Ini.WriteString('Main', 'ImgurClientID', ImgurKeyEdt.Text);

  Ini.Free;

  Application.MessageBox('Для вступления изменений в силу' + #13#10 + 'необходимо перезапустить программу.', PChar(Caption), MB_ICONINFORMATION);
  Main.Close;
end;

end.
