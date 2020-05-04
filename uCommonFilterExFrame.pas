unit uCommonFilterExFrame;

{$mode objfpc}{$H+}

interface

uses
  LCLType, Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls, Spin, ComCtrls, Dialogs,
  Graphics, BZColors,BZGraphic;

type

  { TCommonFilterExFrame }

  TCommonFilterExFrame = class(TFrame)
    pnlTitle : TPanel;
    imgTitleFilterGlyph : TImage;
    lblTitleFrame : TLabel;
    gbxSelectTone : TGroupBox;
    chkShadowTone : TCheckBox;
    chkMidTone : TCheckBox;
    chkHighlightTone : TCheckBox;
    Bevel1 : TBevel;
    chkPreserveLuminosity : TCheckBox;
    GroupBox1 : TGroupBox;
    pnlParam1 : TPanel;
    lblParam1 : TLabel;
    fseFactor1 : TFloatSpinEdit;
    tbFactor1 : TTrackBar;
    pnlParam2 : TPanel;
    lblParam2 : TLabel;
    fseFactor2 : TFloatSpinEdit;
    tbFactor2 : TTrackBar;
    pnlParam3 : TPanel;
    lblParam3 : TLabel;
    fseFactor3 : TFloatSpinEdit;
    tbFactor3 : TTrackBar;
    pnlParam4 : TPanel;
    lblParam4 : TLabel;
    fseFactor4 : TFloatSpinEdit;
    tbFactor4 : TTrackBar;
    pnlColorSelectA : TPanel;
    lblParam5 : TLabel;
    btnColorA : TColorButton;
    pnlColorSelectB : TPanel;
    lblParam6 : TLabel;
    btnColorB : TColorButton;
    chkParam7 : TCheckBox;

    procedure DoNotifyChange(Sender : TObject);
    procedure SliderChange(Sender : TObject);
    procedure tbFactor1MouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
  private
     FOnParamChange : TNotifyEvent;


  public
    DoApplyChange : Boolean;
    FDataChangeCount : Byte;

    function ApplyOnShadowTone : Boolean;
    function ApplyOnMidTone : Boolean;
    function ApplyOnHighlightTone : Boolean;
    function PreserveLuminosity : Boolean;

    function GetParam1 : Single;
    function GetParam2 : Single;
    function GetParam3 : Single;
    function GetParam4 : Single;
    function GetColorA : TBZColor;
    function GetColorB : TBZColor;
    function GetCheckParam : Boolean;

    property OnParamChange : TNotifyEvent read FOnParamChange write FOnParamChange;
  end;

  function CreateCommonFilterExFrame(TheOwner :  TComponent; Title : String; GlyphTitle : TBitmap; ShowSelectTone, ShadowTone, MidTone, HighlightTone, PreserveLum, ShowPreserveLum : Boolean; ParamLabel1, ParamLabel2, ParamLabel3, ParamLabel4, ColorLabel1, ColorLabel2, CheckLabel : String; ParamChangeEvent : TNotifyEvent) : TFrame;

implementation

uses
  BZMath;

function CreateCommonFilterExFrame(TheOwner :  TComponent; Title : String; GlyphTitle : TBitmap; ShowSelectTone, ShadowTone, MidTone, HighlightTone, PreserveLum, ShowPreserveLum : Boolean; ParamLabel1, ParamLabel2, ParamLabel3, ParamLabel4, ColorLabel1, ColorLabel2, CheckLabel : String; ParamChangeEvent : TNotifyEvent) : TFrame;
Var
  Frame : TCommonFilterExFrame;
  cnt : Byte;
begin
  cnt := 0;
  Frame := TCommonFilterExFrame.Create(TheOwner);
  Frame.lblTitleFrame.Caption := Title;
  Frame.chkPreserveLuminosity.Checked := PreserveLum;
  Frame.chkPreserveLuminosity.Visible := ShowPreserveLum;
  Frame.chkShadowTone.Checked := ShadowTone;
  Frame.chkMidTone.Checked := MidTone;
  Frame.chkHighlightTone.Checked := HighlightTone;
  Frame.gbxSelectTone.Visible := ShowSelectTone;

  Frame.imgTitleFilterGlyph.Picture.Bitmap.Assign(GlyphTitle);
  Frame.DoApplyChange := False;
  Frame.FDataChangeCount := 0;
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
  if ColorLabel1 <> '' then
  begin
    Frame.pnlColorSelectA.Visible := True;
    Frame.lblParam5.Caption := ColorLabel1;
    inc(cnt);
  end;
  if ColorLabel2 <> '' then
  begin
    Frame.pnlColorSelectB.Visible := True;
    Frame.lblParam6.Caption := ColorLabel2;
    inc(cnt);
  end;
  if CheckLabel <> '' then
  begin
    Frame.chkParam7.Visible := True;
    Frame.chkParam7.Caption := CheckLabel;
    inc(cnt);
  end;
  cnt := 7 - cnt;
  Frame.Constraints.MaxHeight := Max(Frame.Constraints.MinHeight, Frame.Constraints.MaxHeight - (cnt * 28));
  Frame.Height := Frame.Constraints.MaxHeight;

  Frame.OnParamChange := ParamChangeEvent;
  Result := Frame;
end;

{$R *.lfm}

{ TCommonFilterExFrame }

procedure TCommonFilterExFrame.DoNotifyChange(Sender : TObject);
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

procedure TCommonFilterExFrame.SliderChange(Sender : TObject);
begin
  //DoApplyChange := False;
  FDataChangeCount := 1;
  Case TTrackbar(Sender).Tag of
    0 : fseFactor1.Value := TTrackbar(Sender).Position;
    1 : fseFactor2.Value := TTrackbar(Sender).Position;
    2 : fseFactor3.Value := TTrackbar(Sender).Position;
    3 : fseFactor4.Value := TTrackbar(Sender).Position;
  end;
end;

procedure TCommonFilterExFrame.tbFactor1MouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
 // DoApplyChange := True;
  FDataChangeCount := 0;
  DoNotifyChange(Sender);
end;

function TCommonFilterExFrame.ApplyOnShadowTone : Boolean;
begin
  Result :=  chkShadowTone.Checked;
end;

function TCommonFilterExFrame.ApplyOnMidTone : Boolean;
begin
  Result := chkMidTone.Checked;
end;

function TCommonFilterExFrame.ApplyOnHighlightTone : Boolean;
begin
  Result := chkHighlightTone.Checked;
end;

function TCommonFilterExFrame.PreserveLuminosity : Boolean;
begin
  Result := chkPreserveLuminosity.Checked;
end;

function TCommonFilterExFrame.GetParam1 : Single;
begin
  Result := fseFactor1.Value / 100;
end;

function TCommonFilterExFrame.GetParam2 : Single;
begin
  Result := fseFactor2.Value / 100;
end;

function TCommonFilterExFrame.GetParam3 : Single;
begin
  Result := fseFactor3.Value / 100;
end;

function TCommonFilterExFrame.GetParam4 : Single;
begin
  Result := fseFactor4.Value / 100;
end;

function TCommonFilterExFrame.GetColorA : TBZColor;
begin
  Result := clrBlack;
  Result.Create(btnColorA.ButtonColor);
end;

function TCommonFilterExFrame.GetColorB : TBZColor;
begin
  Result := clrBlack;
  Result.Create(btnColorB.ButtonColor);
end;

function TCommonFilterExFrame.GetCheckParam : Boolean;
begin
  Result := chkParam7.Checked;
end;

end.

