program SDIAPP;

{$R *.dres}

uses
  // fastmm4, //unterstützt bei der suche nach memory-leaks, ggf dll/einstellungen nötig
  // https://sergworks.wordpress.com/2018/06/06/fastmm4-fulldebugmode-setup-guide/
  sysutils,
  oracleci,
  Forms,
  FoRepAppMAIN in 'Forms\FoRepAppMAIN.PAS' {RepApp} ,
  FoCreateCustomer in 'Forms\FoCreateCustomer.pas' {FormCreateCustomer} ,
  FoCreateTask in 'Forms\FoCreateTask.pas' {FormCreateTask} ,
  FoComponentEditor in 'Forms\FoComponentEditor.pas' {FormComponentEditor} ,
  FoLogin in 'Forms\FoLogin.pas' {FormLogin} ,
  FoCreateEmployee in 'Forms\FoCreateEmployee.pas' {FormCreateEmployee} ,
  UOracleDB in 'Units\UOracleDB.pas',
  FoCreateBooking in 'Forms\FoCreateBooking.pas' {FormCreateBooking} ,
  FoEditTask in 'Forms\FoEditTask.pas' {FormEditTask} ,
  FoShowBooking in 'Forms\FoShowBooking.pas' {ShowBooking} ,
  FrBooking in 'Frames\FrBooking.pas' {FrameBooking: TFrame} ,
  FrTask in 'Frames\FrTask.pas' {FrameTask: TFrame} ,
  FoTaskHistory in 'Forms\FoTaskHistory.pas' {FormTaskHistory} ,
  FrTaskHistory in 'Frames\FrTaskHistory.pas' {FrameTaskHistory: TFrame} ,
  FoTransfer in 'Maintenance stuff\FoTransfer.pas' {FormTransfer} ,
  uLevenshtein in 'StringSimilarity\uLevenshtein.pas',
  FoEditCustomer in 'Forms\FoEditCustomer.pas' {FormEditCustomer} ,
  FrSRNHistory in 'Frames\FrSRNHistory.pas' {FrameSRNHistory: TFrame} ,
  FoShowSRNHistory in 'Forms\FoShowSRNHistory.pas' {FormShowSRNHistory} ,
  USettings in 'Units\USettings.pas',
  UUser in 'Objects\UUser.pas',
  FrCompBox in 'Frames\FrCompBox.pas' {FrameComponentBox: TFrame} ,
  moreUtils in 'Units\moreUtils.pas',
  FoSearchSerNr in 'Forms\FoSearchSerNr.pas' {FormSearchSerNr} ,
  UCustomer in 'Objects\UCustomer.pas',
  UComponent in 'Objects\UComponent.pas',
  UTask in 'Objects\UTask.pas',
  UEmployee in 'Objects\UEmployee.pas',
  UBooking in 'Objects\UBooking.pas',
  FoShowKomponentList in 'Forms\FoShowKomponentList.pas' {FoCompList} ,
  FoTemplaceServiceMail in 'Forms\FoTemplaceServiceMail.pas' {FormTemplateServMail} ,
  UTaskStatus in 'Objects\UTaskStatus.pas',
  UComponentDictionary in 'Objects\UComponentDictionary.pas',
  UCustomerDictionary in 'Objects\UCustomerDictionary.pas',
  UTaskDictionary in 'Objects\UTaskDictionary.pas',
  UBookStatus in 'Objects\UBookStatus.pas',
  UReadTextAsTime in 'Units\UReadTextAsTime.pas',
  UEmployeeDictionary in 'Objects\UEmployeeDictionary.pas',
  FoSplashScreen in 'Forms\FoSplashScreen.pas' {FormSplashScreen} ,
  URepAppExcelWriter in 'Objects\URepAppExcelWriter.pas',
  ImportXLSToDB in 'ImportXLS\ImportXLSToDB.pas';

var
  SplashScreen: TFormSplashScreen;
{$R *.RES}

begin
  // loading screen
  SplashScreen := TFormSplashScreen.Create('Lade Applikation..');

  try
    SplashScreen.Subtitle('lade lokale oci-Daten');
    oracleci.InitOCI; // this helps on "locally only" installed OCIs
  except
    SplashScreen.Subtitle('lade oci-Daten aus bin-Verzeichnis');
    oracleci.ocidll := ExtractFileDir(Application.ExeName) + '\bin\oci.dll';
    oracleci.InitOCI; // this helps on "locally only" installed OCIs
  end;
  // bei stolle kann mit den lokalen oci-daten nicht auf die lokale datenbank zugegriffen werden
  // dies wird ein einrichtingsfehler seitens herrn stolle sein

  SplashScreen.Subtitle('Deklariere Modus');
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  USettings.debugmode := True;
  { TODO -ostolle -cGeneral : auf der offiziellen Datenbank auf der VM sollte ein weiterer Benutzer(User) angelegt werden,
    auf die im DEBUG-MODE zugegriffen wird, um funktionen austesten zu können }
{$ELSE}
  USettings.debugmode := false;
{$ENDIF}
  SplashScreen.Subtitle('Initialisiere App');
  Application.Initialize;
  SplashScreen.Free;
  Application.CreateForm(TRepApp, RepApp);
  Application.Run;

end.


// fastmm4, //unterstützt bei der suche nach memory-leaks, ggf dll/einstellungen nötig

// https://sergworks.wordpress.com/2018/06/06/fastmm4-fulldebugmode-setup-guide/
