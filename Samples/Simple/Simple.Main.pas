unit Simple.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.Navigator, FMX.MultiView, FMX.Effects, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TSimpleMain = class(TForm)
    MultiView: TMultiView;
    Button1: TButton;
    Navigator: TNavigator;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  public
    { Public declarations }
  end;

var
  SimpleMain: TSimpleMain;

implementation

{$R *.fmx}

uses Simple.Master;

procedure TSimpleMain.Button1Click(Sender: TObject);
begin
  Navigator.Push(TSimpleMaster.Create(Navigator));
  MultiView.HideMaster;
end;

procedure TSimpleMain.Button2Click(Sender: TObject);
begin
  Navigator.FontColor := TAlphaColorRec.Red;
  Label1.TextSettings.FontColor := TAlphaColorRec.Red;
end;

procedure TSimpleMain.Button3Click(Sender: TObject);
begin
  Navigator.FontColor := TAlphaColorRec.White;
  Label1.TextSettings.FontColor := TAlphaColorRec.White;
end;

end.
