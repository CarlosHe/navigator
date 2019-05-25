program Simple;

uses
  System.StartUpCopy,
  FMX.Forms,
  Simple.Main in 'Simple.Main.pas' {SimpleMain},
  FMX.Navigator in '..\..\Src\FMX.Navigator.pas',
  Simple.Master in 'Simple.Master.pas' {SimpleMaster: TFrame},
  Simple.Detail in 'Simple.Detail.pas' {SimpleDetail: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TSimpleMain, SimpleMain);
  Application.Run;
end.
