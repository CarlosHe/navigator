unit Simple.Master;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox,
  FMX.Memo, FMX.Navigator;

type
  TSimpleMaster = class(TFrame)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    FNavigator: TNavigator;
    property Navigator: TNavigator read FNavigator write FNavigator;
  public
    constructor Create(Navigator: TNavigator); reintroduce;
  end;

implementation

{$R *.fmx}

uses Simple.Detail;

{ TSimpleMaster }

procedure TSimpleMaster.Button1Click(Sender: TObject);
begin
  Navigator.Push('New Title', TSimpleDetail.Create(nil));
end;

constructor TSimpleMaster.Create(Navigator: TNavigator);
begin
  inherited Create(nil);

  FNavigator := Navigator;
end;

end.
