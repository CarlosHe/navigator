unit FMX.Navigator;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, FMX.Types, FMX.Controls, FMX.Layouts, FMX.StdCtrls,
  FMX.Objects, FMX.Graphics, FMX.MultiView, FMX.Effects, System.UITypes,
  FMX.Forms, FMX.Controls.Presentation;

type

  TNavigator = class(TFrame)
    LayoutHeader: TLayout;
    ToolBar: TToolBar;
    LabelCaption: TLabel;
    ShadowEffectToolbar: TShadowEffect;
    MenuButton: TButton;
    BackButton: TButton;
    procedure BackButtonClick(Sender: TObject);
    procedure MenuButtonClick(Sender: TObject);
  private
    FMultiView: TMultiView;
    FMenuButton: TButton;
    FBackButton: TButton;
    FMultiViewButton: TButton;
    FStack: TStack<TPair<string, TFrame>>;
    FFontColor: TAlphaColor;
    procedure SetMultiView(const Value: TMultiView);
    function HasMultiView: Boolean;
    function StackIsEmpty: Boolean;
    function GetTitle: string;
    procedure SetTitle(const Value: string);
    procedure SetFontColor(const Value: TAlphaColor);
    procedure DoPush(TitleNavigator: string; Frame: TFrame);
    function GetTintColor: TAlphaColor;
    procedure SetTintColor(const Value: TAlphaColor);
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
    property TintColor: TAlphaColor read GetTintColor write SetTintColor;
    property Title: string read GetTitle write SetTitle;
    property FontColor: TAlphaColor read FFontColor write SetFontColor default TAlphaColorRec.Black;
  end;

procedure Register;

implementation

{$R *.fmx}

procedure Register;
begin
  RegisterComponents('HashLoad', [TNavigator]);
end;

{ TNavigator }

procedure TNavigator.BackButtonClick(Sender: TObject);
begin
  Pop;
end;

constructor TNavigator.Create(AOwner: TComponent);
begin
  inherited;

  FStack := TStack<TPair<string, TFrame>>.Create;
  LayoutHeader.SetSubComponent(True);
  ToolBar.SetSubComponent(True);
  ShadowEffectToolbar.SetSubComponent(True);
  LabelCaption.SetSubComponent(True);
  BackButton.SetSubComponent(True);
  MenuButton.SetSubComponent(True);

  Align := TAlignLayout.Top;
  Height := 56;

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

function TNavigator.GetTintColor: TAlphaColor;
begin
  Result := ToolBar.TintColor;
end;

function TNavigator.GetTitle: string;
begin
  Result := LabelCaption.Text;
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

procedure TNavigator.SetFontColor(const Value: TAlphaColor);
begin
  if FFontColor <> Value then
  begin
    FFontColor := Value;
    LabelCaption.TextSettings.FontColor := Value;
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

procedure TNavigator.SetTintColor(const Value: TAlphaColor);
begin
  ToolBar.TintColor := Value;
end;

procedure TNavigator.SetTitle(const Value: string);
begin
  if LabelCaption.Text <> Value then
    LabelCaption.Text := Value;
end;

end.
