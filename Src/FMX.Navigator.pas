unit FMX.Navigator;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, FMX.Types, FMX.Controls, FMX.Layouts, FMX.StdCtrls,
  FMX.Objects, FMX.Graphics, FMX.MultiView, FMX.Effects, System.UITypes,
  FMX.Forms, FMX.Controls.Presentation, FMX.Filter.Effects;

type

  TNavigator = class(TLayout)
  private
    FMultiView: TMultiView;
    FMultiViewButton: TButton;
    FStack: TStack<TPair<string, TFrame>>;
    FFontColor: TAlphaColor;

    FShadowEffectToolbar: TShadowEffect;
    FRectangle: TRectangle;
    FTitle: TLabel;
    FMenuButton: TSpeedButton;
    FBackButton: TSpeedButton;

    procedure SetMultiView(const Value: TMultiView);
    function HasMultiView: Boolean;
    function StackIsEmpty: Boolean;
    function GetTitle: string;
    procedure SetTitle(const Value: string);
    procedure SetFontColor(const Value: TAlphaColor);
    procedure DoPush(TitleNavigator: string; Frame: TFrame);
    procedure BackButtonClick(Sender: TObject);
    procedure MenuButtonClick(Sender: TObject);

    procedure CreateShadow;
    procedure CreateButtons;
    procedure CreateRectangle;
    procedure CreateLabel;
    procedure SetHeight(const Value: Single);
    function GetFill: TBrush;
    procedure SetFill(const Value: TBrush);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Stack: TStack <TPair<string, TFrame>> read FStack write FStack;
    procedure Push(Frame: TFrame); overload;
    procedure Push(NavigatorTitle: string; Frame: TFrame); overload;
    procedure Pop;
    procedure Clear;

  published
    property MultiView: TMultiView read FMultiView write SetMultiView;
    property Fill: TBrush read GetFill write SetFill;
    property Title: string read GetTitle write SetTitle;
    property FontColor: TAlphaColor read FFontColor write SetFontColor default TAlphaColorRec.Black;
  end;

procedure Register;

implementation

uses
  FMX.Styles.Objects;

procedure Register;
begin
  RegisterComponents('HashLoad', [TNavigator]);
end;

{ TNavigator }

procedure TNavigator.BackButtonClick(Sender: TObject);
begin
  Pop;
end;

procedure TNavigator.Clear;
begin
  while not StackIsEmpty do
    Pop;
end;

constructor TNavigator.Create(AOwner: TComponent);
begin
  inherited;
  FStack := TStack<TPair<string, TFrame>>.Create;
  CreateShadow;
  CreateRectangle;
  CreateButtons;
  CreateLabel;

  Align := TAlignLayout.Top;
  Height := 56;

  FontColor := TAlphaColorRec.Black;
end;

procedure TNavigator.CreateButtons;
begin
  FMenuButton := TSpeedButton.Create(Self);
  FMenuButton.Parent := FRectangle;
  FMenuButton.Align := TAlignLayout.Left;
  FMenuButton.Size.Width := FRectangle.Height;
  FMenuButton.StyleLookup := 'drawertoolbutton';
  FMenuButton.OnClick := MenuButtonClick;
  FMenuButton.Stored := False;
  FMenuButton.SetSubComponent(True);

  FBackButton := TSpeedButton.Create(Self);
  FBackButton.Parent := FRectangle;
  FBackButton.Align := TAlignLayout.Left;
  FBackButton.Size.Width := FRectangle.Height;
  FBackButton.StyleLookup := 'backtoolbutton';
  FBackButton.Visible := False;
  FBackButton.OnClick := BackButtonClick;
  FBackButton.Stored := False;
  FBackButton.SetSubComponent(True);

  FMultiViewButton := TButton.Create(Self);
  FMultiViewButton.Stored := False;
  FMultiViewButton.SetSubComponent(True);
end;

procedure TNavigator.CreateLabel;
begin
  FTitle := TLabel.Create(Self);
  FTitle.Parent := FRectangle;
  FTitle.Align := TAlignLayout.Client;
  FTitle.Margins.Left := 16;
  FTitle.Margins.Top := 5;
  FTitle.Margins.Right := 5;
  FTitle.Margins.Bottom := 5;

end;

procedure TNavigator.CreateShadow;
begin
  FShadowEffectToolbar := TShadowEffect.Create(Self);
  FShadowEffectToolbar.Distance := 3;
  FShadowEffectToolbar.Direction := 90;
  FShadowEffectToolbar.Softness := 0.3;
  FShadowEffectToolbar.Opacity := 1;
  FShadowEffectToolbar.ShadowColor := TAlphaColorRec.Darkgray;
  FShadowEffectToolbar.Stored := False;
  FShadowEffectToolbar.Parent := Self;
  FShadowEffectToolbar.SetSubComponent(True);
end;

procedure TNavigator.CreateRectangle;
begin
  FRectangle := TRectangle.Create(Self);
  FRectangle.SetSubComponent(True);
  FRectangle.Stored := False;
  FRectangle.Stroke.Kind := TBrushKind.None;
  FRectangle.Align := TAlignLayout.Client;
  FRectangle.Parent := Self;
end;

destructor TNavigator.Destroy;
begin
  FStack.DisposeOf;

  if HasMultiView then
    FMultiView.RemoveFreeNotify(Self);

  inherited;
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

procedure TNavigator.MenuButtonClick(Sender: TObject);
begin
  if Assigned(FMultiView) then
    FMultiViewButton.OnClick(Sender);
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
    if Assigned(FBackButton.IconTintObject) then
      FBackButton.IconTintObject.TintColor := Value;

    if Assigned(FMenuButton.IconTintObject) then
      FMenuButton.IconTintObject.TintColor := Value;
  end;
end;

procedure TNavigator.SetHeight(const Value: Single);
begin

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
      FMenuButton.Visible := True;
    end;
  end;
end;

procedure TNavigator.SetTitle(const Value: string);
begin
  if FTitle.Text <> Value then
    FTitle.Text := Value;
end;

end.
