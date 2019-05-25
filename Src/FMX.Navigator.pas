unit FMX.Navigator;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, FMX.Types, FMX.Controls, FMX.Layouts, FMX.StdCtrls,
  FMX.Objects, FMX.Graphics, FMX.MultiView, FMX.Effects, System.UITypes,
  FMX.Forms;

type

  TNavigator = class(TLayout)
  private
    FRectangle: TRectangle;
    FMultiView: TMultiView;
    FMenuButton: TButton;
    FBackButton: TButton;
    FMultiViewButton: TButton;
    FStack: TStack<TPair<string, TFrame>>;
    FTitle: TLabel;
    FFontColor: TAlphaColor;
    procedure SetMultiView(const Value: TMultiView);
    procedure DoOnClickMultiViewButton(Sender: TObject);
    procedure DoOnClickBackButton(Sender: TObject);
    function HasMultiView: Boolean;
    function StackIsEmpty: Boolean;
    procedure SetFill(const Value: TBrush);
    function GetFill: TBrush;
    function GetTitle: string;
    procedure SetTitle(const Value: string);
    procedure SetFontColor(const Value: TAlphaColor);
    procedure DoPush(TitleNavigator: string; Frame: TFrame);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Stack: TStack<TPair<string, TFrame>> read FStack write FStack;
    procedure Push(Frame: TFrame); overload;
    procedure Push(NavigatorTitle: string; Frame: TFrame); overload;
    procedure Pop;
  published
    property MultiView: TMultiView read FMultiView write SetMultiView;
    property Fill: TBrush read GetFill write SetFill;
    property Title: string read GetTitle write SetTitle;
    property FontColor: TAlphaColor read FFontColor write SetFontColor default TAlphaColorRec.Black;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('HashLoad', [TNavigator]);
end;

{ TNavigator }

constructor TNavigator.Create(AOwner: TComponent);
begin
  inherited;

  FStack := TStack<TPair<string, TFrame>>.Create;

  Align := TAlignLayout.Top;
  Height := 56;

  FRectangle := TRectangle.Create(Self);
  FRectangle.SetSubComponent(True);
  FRectangle.Stored := False;
  FRectangle.Stroke.Kind := TBrushKind.None;
  FRectangle.Align := TAlignLayout.Client;
  FRectangle.Parent := Self;

  FMenuButton := TButton.Create(FRectangle);
  FMenuButton.SetSubComponent(True);
  FMenuButton.Stored := False;
  FMenuButton.StyleLookup := 'drawertoolbutton';
  FMenuButton.Align := TAlignLayout.Left;
  FMenuButton.Parent := FRectangle;
  FMenuButton.OnClick := DoOnClickMultiViewButton;

  FBackButton := TButton.Create(FRectangle);
  FBackButton.SetSubComponent(True);
  FBackButton.Stored := False;
  FBackButton.Visible := False;
  FBackButton.StyleLookup := 'backtoolbutton';
  FBackButton.Align := TAlignLayout.Left;
  FBackButton.Parent := FRectangle;
  FBackButton.OnClick := DoOnClickBackButton;

  FTitle := TLabel.Create(FRectangle);
  FTitle.SetSubComponent(True);
  FTitle.Stored := False;
  FTitle.Align := TAlignLayout.Client;
  FTitle.TextSettings.Font.Size := 20;
  FTitle.Parent := FRectangle;

  FontColor := TAlphaColorRec.Black;

  FMultiViewButton := TButton.Create(Self);
end;

destructor TNavigator.Destroy;
begin
  FStack.DisposeOf;

  if HasMultiView then
    FMultiView.RemoveFreeNotify(Self);

  inherited;
end;

procedure TNavigator.DoOnClickBackButton(Sender: TObject);
begin
  Pop;
end;

procedure TNavigator.DoOnClickMultiViewButton(Sender: TObject);
begin
  if Assigned(FMultiView) then
    FMultiViewButton.OnClick(Sender);
end;

function TNavigator.GetFill: TBrush;
begin
  Result := FRectangle.Fill;
end;

function TNavigator.GetTitle: string;
begin
  Result := FTitle.Text;
end;

function TNavigator.HasMultiView: Boolean;
begin
  Result := FMultiView <> nil;
end;

function TNavigator.StackIsEmpty: Boolean;
begin
  Result := FStack.Count = 0;
end;

procedure TNavigator.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;

  if (AComponent = FMultiView) and (Operation = opRemove) then
    FMultiView := nil;
end;

procedure TNavigator.Pop;
begin
  FStack.Peek.Value.Parent := nil;

  FStack
    .Pop
    .Value
    .DisposeOf;

  if StackIsEmpty then
  begin
    FMenuButton.Visible := True;
    FBackButton.Visible := False;
  end
  else
  begin
    FStack.Peek.Value.Parent := Parent;
    Title := FStack.Peek.Key;
  end;
end;

procedure TNavigator.DoPush(TitleNavigator: string; Frame: TFrame);
begin
  if StackIsEmpty then
  begin
    FMenuButton.Visible := False;
    FBackButton.Visible := True;
  end
  else
    FStack.Peek.Value.Parent := nil;
  FStack.Push(TPair<string, TFrame>.Create(TitleNavigator, Frame));
  Title := TitleNavigator;
  Frame.Align := TAlignLayout.Client;
  Frame.Parent := Parent;
end;

procedure TNavigator.Push(NavigatorTitle: string; Frame: TFrame);
begin
  DoPush(NavigatorTitle, Frame);
end;

procedure TNavigator.Push(Frame: TFrame);
begin
  DoPush(Title, Frame);
end;

procedure TNavigator.SetFill(const Value: TBrush);
begin
  FRectangle.Fill := Value;
end;

procedure TNavigator.SetFontColor(const Value: TAlphaColor);
begin
  if FFontColor <> Value then
  begin
    FFontColor := Value;
    FTitle.TextSettings.FontColor := Value;
    FBackButton.IconTintColor := Value;
    FMenuButton.IconTintColor := Value;
  end;
end;

procedure TNavigator.SetMultiView(const Value: TMultiView);
begin
if FMultiView <> Value then
  begin
    FMultiView := Value;

    if HasMultiView then
    begin
      FMultiView.AddFreeNotify(Self);
      FMultiView.MasterButton := FMultiViewButton;
    end;
  end;
end;

procedure TNavigator.SetTitle(const Value: string);
begin
  if FTitle.Text <> Value then
    FTitle.Text := Value;
end;

end.
