unit uExtendFilterExFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls, Spin, ComCtrls, Graphics, Buttons,
  uDMMain, BZMath, BZGraphic, BZUtils, Types;

type

  { TExtendFilterExFrame }

  TExtendFilterExFrame = class(TFrame)
    pnlTitle : TPanel;
    imgTitleFilterGlyph : TImage;
    lblTitleFrame : TLabel;
    pnlParam1 : TPanel;
    lblParam1 : TLabel;
    fseFactor1 : TFloatSpinEdit;
    tbFactor1 : TTrackBar;
    pnlParam2 : TPanel;
    lblParam2 : TLabel;
    fseFactor2 : TFloatSpinEdit;
    tbFactor2 : TTrackBar;
    gbxCenter : TGroupBox;
    Panel1 : TPanel;
    Panel2 : TPanel;
    pnlChooseCenter : TPanel;
    pnlCenterX : TPanel;
    lblCenterX : TLabel;
    fseCenterX : TFloatSpinEdit;
    tbCenterX : TTrackBar;
    pnlCenterY : TPanel;
    lblCenterY : TLabel;
    fseCenterY : TFloatSpinEdit;
    tbCenterY : TTrackBar;
    pnlParam3 : TPanel;
    lblParam3 : TLabel;
    fseFactor3 : TFloatSpinEdit;
    tbFactor3 : TTrackBar;
    pnlParam4 : TPanel;
    lblParam4 : TLabel;
    fseFactor4 : TFloatSpinEdit;
    tbFactor4 : TTrackBar;
    pnlOptions : TPanel;
    Label1 : TLabel;
    cbxInterpolation : TComboBox;
    Label2 : TLabel;
    cbxEdgeAction : TComboBox;
    btnResetParam1 : TSpeedButton;
    cbxAALevel : TComboBox;
    btnResetParam2 : TSpeedButton;
    btnResetParam3 : TSpeedButton;
    btnResetParam4 : TSpeedButton;
    pnlParam0 : TPanel;
    lblParam0 : TLabel;
    cbxParam0 : TComboBox;
    procedure pnlChooseCenterMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure pnlChooseCenterMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure pnlChooseCenterMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
    procedure pnlChooseCenterPaint(Sender : TObject);

     procedure DoNotifyChange(Sender : TObject);
     procedure SliderChange(Sender : TObject);
     procedure tbFactor1MouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
     procedure cbxAALevelChange(Sender : TObject);
     procedure fseFactor1EditingDone(Sender : TObject);
     procedure cbxParam0Change(Sender : TObject);
  private
    FMousePos : TPoint;
    FCenterPos : TPoint;
    FCenterX, FCenterY : Integer;
    FMouseDown : Boolean;
    FDivParam1, FDivParam2, FDivParam3, FDivParam4 : Single;
    FSampleLevel : Byte;

    FOnParamChange : TNotifyEvent;


    procedure ComputeCenter;
    procedure MoveCenter;
    procedure SetCenterX(const AValue : Integer);
    procedure SetCenterY(const AValue : Integer);


  public
    DoApplyChange : Boolean;
    FDataChangeCount : Byte;

    function GetParam0 : Integer;
    function GetParam1 : Single;
    function GetParam2 : Single;
    function GetParam3 : Single;
    function GetParam4 : Single;

    procedure SetSampleLevel(lvl : Byte);
    function GetSampleLevel : Byte;

    procedure SetParam0Items(ItemList : TStringList; aItemIndex : Integer);

    function GetEdgeAction : TBZPixelEdgeAction;
    function GetSamplerMethod : TBZGetPixelSampleMethod;

    procedure SetRangeParam1(aMin, aMax, aDiv : Single);
    procedure SetRangeParam2(aMin, aMax, aDiv : Single);
    procedure SetRangeParam3(aMin, aMax, aDiv : Single);
    procedure SetRangeParam4(aMin, aMax, aDiv : Single);

    property CenterX : Integer read FCenterX write SetCenterX;
    property CenterY : Integer read FCenterY write SetCenterY;

    property OnParamChange : TNotifyEvent read FOnParamChange write FOnParamChange;
  end;

  function CreateExtendFilterExFrame(TheOwner :  TComponent; Title : String; GlyphTitle : TBitmap; ShowCenter : Boolean; ParamLabel0, ParamLabel1, ParamLabel2, ParamLabel3, ParamLabel4 : String;  aWidth, aHeight : Integer; ParamChangeEvent : TNotifyEvent; Const ShowOption : Boolean = true) : TFrame;

implementation

{$R *.lfm}

uses FPCanvas;

function CreateExtendFilterExFrame(TheOwner : TComponent; Title : String; GlyphTitle : TBitmap; ShowCenter : Boolean; ParamLabel0, ParamLabel1, ParamLabel2, ParamLabel3, ParamLabel4 : String; aWidth, aHeight : Integer; ParamChangeEvent : TNotifyEvent; Const ShowOption : Boolean) : TFrame;
Var
  Frame : TExtendFilterExFrame;
  cnt : Byte;
begin
  Frame := TExtendFilterExFrame.Create(TheOwner);
  Frame.lblTitleFrame.Caption := Title;
  cnt := 0;
  Frame.imgTitleFilterGlyph.Picture.Bitmap.Assign(GlyphTitle);
  Frame.DoApplyChange := False;
  Frame.FDataChangeCount := 0;
  if ParamLabel0 <> '' then
  begin
    Frame.lblParam0.Caption := ParamLabel0;
    Frame.pnlParam0.Visible := True;
    inc(cnt);
  end;
  if ParamLabel1 <> '' then
  begin
    Frame.lblParam1.Caption := ParamLabel1;
    Frame.pnlParam1.Visible := True;
    inc(cnt);
  end;
  if ParamLabel2 <> '' then
  begin
    Frame.lblParam2.Caption := ParamLabel2;
    Frame.pnlParam2.Visible := True;
    inc(cnt);
  end;
  if ParamLabel3 <> '' then
  begin
    Frame.lblParam3.Caption := ParamLabel3;
    Frame.pnlParam3.Visible := True;
    inc(cnt);
  end;
  if ParamLabel4 <> '' then
  begin
    Frame.lblParam4.Caption := ParamLabel4;
    Frame.pnlParam4.Visible := True;
    inc(cnt);
  end;
  cnt := 5 - cnt;
  Frame.tbCenterX.Max := AWidth;
  Frame.tbCenterY.Max := AHeight;
  Frame.fseCenterX.MaxValue := AWidth;
  Frame.fseCenterY.MaxValue := AHeight;
  Frame.CenterX := ((AWidth + 1) div 2) - 1;
  Frame.CenterY := ((AHeight + 1) div 2) - 1;
  Frame.pnlOptions.Visible := ShowOption;
  if ShowCenter then Frame.gbxCenter.Visible := true
  else
    Frame.Constraints.MaxHeight := Frame.Constraints.MaxHeight - Frame.gbxCenter.Height;
  Frame.Constraints.MaxHeight := Frame.Constraints.MaxHeight - (cnt * 28);
  Frame.Height := Frame.Constraints.MaxHeight;
  Frame.OnParamChange := ParamChangeEvent;
  Result := Frame;
end;



{ TExtendFilterExFrame }

procedure TExtendFilterExFrame.pnlChooseCenterMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  if Button = mbLeft then
  begin
    Screen.Cursor := crNone;
    FCenterPos.x := x;
    FCenterPos.y := y;
    ComputeCenter;
    tbCenterX.Position := FCenterX;
    tbCenterY.Position := FCenterY;
    pnlChooseCenter.Invalidate;
    FMouseDown := True;
  end;
end;

procedure TExtendFilterExFrame.pnlChooseCenterMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  FMouseDown := False;
  Screen.Cursor := crDefault;
  FDataChangeCount := 0;
  DoNotifyChange(Sender);
end;

procedure TExtendFilterExFrame.pnlChooseCenterMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
begin
  if FMouseDown and (ssLeft in Shift) then
  begin
    FCenterPos.x := x;
    FCenterPos.y := y;
    ComputeCenter;
    tbCenterX.Position := FCenterX;
    tbCenterY.Position := FCenterY;
    MoveCenter;
  end;
end;

procedure TExtendFilterExFrame.pnlChooseCenterPaint(Sender : TObject);
var
  cx,cy : Integer;

  procedure DrawCursor(x,y : Integer);
  begin
    With TPanel(Sender).Canvas do
    begin
      Pen.Style := psSolid;
      Pen.Color := clWhite;
      Brush.Style := bsClear;
      MoveTo(x,y);
      Ellipse(x - 3, y - 3, x + 3, y + 3);
      MoveTo(x - 8, y);
      LineTo(x - 3, y);
      MoveTo(x + 3, y);
      LineTo(x + 8, y);
      MoveTo(x, y - 3);
      LineTo(x, y - 8);
      MoveTo(x, y + 3);
      LineTo(x, y + 8);
    end;
  end;

begin
  inherited Paint;
  cx := (pnlChooseCenter.ClientWidth div 2) - 1;
  cy := (pnlChooseCenter.ClientHeight div 2) - 1;
  With TPanel(Sender).Canvas do
  begin
    Pen.Style := psClear;
    Brush.Style := bsSolid;
    Brush.Color := $333333;
    Rectangle(pnlChooseCenter.ClientRect);
    Brush.Style := bsClear;
    Pen.Style := psSolid;
    Pen.Color := clRed;
    Line(cx,0,cx,pnlChooseCenter.ClientHeight-1);
    Line(0,cy,pnlChooseCenter.ClientWidth-1, cy);
  end;
  DrawCursor(FCenterPos.X, FCenterPos.y);
end;

procedure TExtendFilterExFrame.DoNotifyChange(Sender : TObject);
begin
  Inc(FDataChangeCount);
  try
   if FDataChangeCount <> 1 then exit;
   //ShowMessage(FDataChangeCount.ToString);
   if Assigned(FOnParamChange) then FOnParamChange(sender);
  finally
    Dec(FDataChangeCount);
  end;
end;

procedure TExtendFilterExFrame.SliderChange(Sender : TObject);
begin
  FDataChangeCount := 1;
  Case TTrackbar(Sender).Tag of
    0 : fseFactor1.Value := TTrackbar(Sender).Position;
    1 : fseFactor2.Value := TTrackbar(Sender).Position;
    2 : fseFactor3.Value := TTrackbar(Sender).Position;
    3 : fseFactor4.Value := TTrackbar(Sender).Position;
    4 :
    begin
      fseCenterX.Value := TTrackbar(Sender).Position;
      if not(FMouseDown) then
      begin
        FCenterX := TTrackbar(Sender).Position;
        MoveCenter;
      end;
    end;
    5 :
    begin
      fseCenterY.Value := TTrackbar(Sender).Position;
      if not(FMouseDown) then
      begin
        FCenterY := TTrackbar(Sender).Position;
        MoveCenter;
      end;
    end;

  end;
end;

procedure TExtendFilterExFrame.tbFactor1MouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  FDataChangeCount := 0;
  DoNotifyChange(Sender);
end;

procedure TExtendFilterExFrame.cbxAALevelChange(Sender : TObject);
begin
  Case cbxAALevel.ItemIndex of
    0 : SetSampleLevel(2);
    1 : SetSampleLevel(3);
    2 : SetSampleLevel(4);
    3 : SetSampleLevel(5);
    4 : SetSampleLevel(6);
    5 : SetSampleLevel(7);
    6 : SetSampleLevel(8);
    7 : SetSampleLevel(12);
    8 : SetSampleLevel(16);
    9 : SetSampleLevel(32);
  end;
  FDataChangeCount := 0;
  DoNotifyChange(Sender);
end;

procedure TExtendFilterExFrame.fseFactor1EditingDone(Sender : TObject);
begin
  DoNotifyChange(Self);
end;

procedure TExtendFilterExFrame.cbxParam0Change(Sender : TObject);
begin
  FDataChangeCount := 0;
  DoNotifyChange(Sender);
end;

procedure TExtendFilterExFrame.ComputeCenter;
begin
  FCenterX := MulDiv(FCenterPos.X, tbCenterX.Max + 1, pnlChooseCenter.ClientWidth) - 1;
  FCenterY := MulDiv(FCenterPos.Y, tbCenterY.Max + 1, pnlChooseCenter.ClientHeight) - 1;
end;

procedure TExtendFilterExFrame.MoveCenter;
begin
  FCenterPos.X := MulDiv(FCenterX, pnlChooseCenter.ClientWidth, tbCenterX.Max + 1) - 1;
  FCenterPos.Y := MulDiv(FCenterY, pnlChooseCenter.ClientHeight, tbCenterY.Max + 1) - 1;;
  pnlChooseCenter.Invalidate;
end;

procedure TExtendFilterExFrame.SetCenterX(const AValue : Integer);
begin
  if FCenterX = AValue then Exit;
  FCenterX := AValue;
  tbCenterX.Position := AValue;
  fseCenterX.Value := AValue;
  MoveCenter;
end;

procedure TExtendFilterExFrame.SetCenterY(const AValue : Integer);
begin
  if FCenterY = AValue then Exit;
  FCenterY := AValue;
  tbCenterY.Position := AValue;
  fseCenterY.Value := AValue;
  MoveCenter;
end;

function TExtendFilterExFrame.GetParam0 : Integer;
begin
  Result := cbxParam0.ItemIndex;
end;

function TExtendFilterExFrame.GetParam1 : Single;
begin
  Result := fseFactor1.Value / FDivParam1;
end;

function TExtendFilterExFrame.GetParam2 : Single;
begin
  Result := fseFactor2.Value / FDivParam2;
end;

function TExtendFilterExFrame.GetParam3 : Single;
begin
  Result := fseFactor3.Value / FDivParam3;
end;

function TExtendFilterExFrame.GetParam4 : Single;
begin
  Result := fseFactor4.Value  / FDivParam4;
end;

procedure TExtendFilterExFrame.SetSampleLevel(lvl : Byte);
begin
  FSampleLevel := lvl;
end;

function TExtendFilterExFrame.GetSampleLevel : Byte;
begin
  Result := FSampleLevel;
end;

procedure TExtendFilterExFrame.SetParam0Items(ItemList : TStringList; aItemIndex : Integer);
begin
  cbxParam0.Items.Assign(ItemList);
  cbxParam0.ItemIndex := aItemIndex;
end;

function TExtendFilterExFrame.GetEdgeAction : TBZPixelEdgeAction;
begin
  Result := TBZPixelEdgeAction(cbxEdgeAction.ItemIndex)
end;

function TExtendFilterExFrame.GetSamplerMethod : TBZGetPixelSampleMethod;
begin
  Result := TBZGetPixelSampleMethod(cbxInterpolation.ItemIndex);
end;

procedure TExtendFilterExFrame.SetRangeParam1(aMin, aMax, aDiv : Single);
begin
  fseFactor1.MinValue := aMin;
  fseFactor1.MaxValue := aMax;
  tbFactor1.Min := Round(aMin);
  tbFactor1.Max := Round(aMax);
  FDivParam1 := aDiv;
end;

procedure TExtendFilterExFrame.SetRangeParam2(aMin, aMax, aDiv : Single);
begin
  fseFactor2.MinValue := aMin;
  fseFactor2.MaxValue := aMax;
  tbFactor2.Min := Round(aMin);
  tbFactor2.Max := Round(aMax);
  FDivParam2 := aDiv;
end;

procedure TExtendFilterExFrame.SetRangeParam3(aMin, aMax, aDiv : Single);
begin
  fseFactor3.MinValue := aMin;
  fseFactor3.MaxValue := aMax;
  tbFactor3.Min := Round(aMin);
  tbFactor3.Max := Round(aMax);
  FDivParam3 := aDiv;
end;

procedure TExtendFilterExFrame.SetRangeParam4(aMin, aMax, aDiv : Single);
begin
  fseFactor4.MinValue := aMin;
  fseFactor4.MaxValue := aMax;
  tbFactor4.Min := Round(aMin);
  tbFactor4.Max := Round(aMax);
  FDivParam4 := aDiv;
end;

end.

