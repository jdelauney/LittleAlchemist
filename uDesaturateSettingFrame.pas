unit uDesaturateSettingFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls, Spin, Graphics,
  BZColors, BZGraphic;
type

  { TDesaturateSettingFrame }

  TDesaturateSettingFrame = class(TFrame)
    pnlTitle : TPanel;
    imgTitleFilterGlyph : TImage;
    lblTitleFrame : TLabel;
    Panel1 : TPanel;
    pnlParam3 : TPanel;
    Label4 : TLabel;
    fseParam2 : TFloatSpinEdit;
    pnlParam2 : TPanel;
    Label3 : TLabel;
    fseParam1 : TFloatSpinEdit;
    pnlParam1 : TPanel;
    Label2 : TLabel;
    cbxColorMask : TComboBox;
    Panel2 : TPanel;
    pnlMethod : TPanel;
    Label1 : TLabel;
    cbxDesaturateMethod : TComboBox;
    gbxMatrix : TGroupBox;
    cbxDesaturateMatrix : TComboBox;

    procedure DoNotifyChange(Sender : TObject);
    procedure rgGrayScaleMethodSelectionChanged(Sender : TObject);
  private
    FOnParamChange : TNotifyEvent;
  public
    DoApplyChange : Boolean;
    FDataChangeCount : Byte;


    function GetDesaturateMethode : TBZGrayConvertMode;
    function GetDesaturateMatrix : TBZGrayMatrixType;
    function GetDesaturateColorMask : Byte;
    function GetParam1 : Single;
    function GetParam2 : Single;

    property OnParamChange : TNotifyEvent read FOnParamChange write FOnParamChange;
  end;

  function CreateDesaturateSettingFrame(TheOwner :  TComponent; Title : String; GlyphTitle : TBitmap; ParamChangeEvent : TNotifyEvent) : TFrame;

implementation

function CreateDesaturateSettingFrame(TheOwner : TComponent; Title : String; GlyphTitle : TBitmap; ParamChangeEvent : TNotifyEvent) : TFrame;
Var
  Frame : TDesaturateSettingFrame;
begin
  Frame := TDesaturateSettingFrame.Create(TheOwner);
  Frame.lblTitleFrame.Caption := Title;
  Frame.imgTitleFilterGlyph.Picture.Bitmap.Assign(GlyphTitle);
  Frame.DoApplyChange := False;
  Frame.FDataChangeCount := 0;

  Frame.OnParamChange := ParamChangeEvent;
  Result := Frame;
end;

{$R *.lfm}

{ TDesaturateSettingFrame }

procedure TDesaturateSettingFrame.DoNotifyChange(Sender : TObject);
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

procedure TDesaturateSettingFrame.rgGrayScaleMethodSelectionChanged(Sender : TObject);
Var
  idx : Integer;
begin
  Idx := cbxDesaturateMethod.ItemIndex;
  cbxDesaturateMatrix.Enabled := (Idx = 1);
  cbxColorMask.Enabled := (Idx = 6);
  fseParam1.Enabled := (Idx = 7) or (Idx = 8) or (Idx = 9);
  fseParam2.Enabled := (Idx = 8);
  //if (Idx<>1) and (Idx<>5) and (idx<>6) and (idx<>7) and (idx<>8) then
  DoNotifyChange(Self);
end;

function TDesaturateSettingFrame.GetDesaturateMethode : TBZGrayConvertMode;
begin
  Result := TBZGrayConvertMode(cbxDesaturateMethod.ItemIndex);
end;

function TDesaturateSettingFrame.GetDesaturateMatrix : TBZGrayMatrixType;
begin
  Result := TBZGrayMatrixType(cbxDesaturateMatrix.ItemIndex);
end;

function TDesaturateSettingFrame.GetDesaturateColorMask : Byte;
begin
  Result := cbxColorMask.ItemIndex;
end;

function TDesaturateSettingFrame.GetParam1 : Single;
begin
  Result := fseParam1.Value;
end;

function TDesaturateSettingFrame.GetParam2 : Single;
begin
  Result := fseParam2.Value;
end;

end.

