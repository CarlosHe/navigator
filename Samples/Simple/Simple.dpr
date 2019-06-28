program Simple;

uses
  System.StartUpCopy,
  FMX.Forms,
  Simple.Navigator in 'Simple.Navigator.pas' {SimpleNavigator},
  FMX.Navigator in '..\..\Src\FMX.Navigator.pas',
  Simple.Master in 'Simple.Master.pas' {SimpleMaster: TFrame},
  Simple.Detail in 'Simple.Detail.pas' {SimpleDetail: TFrame};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.CreateForm(TSimpleNavigator, SimpleNavigator);
  Application.Run;
end.
