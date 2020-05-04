unit uResizeImageForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons, StdCtrls, Spin, Menus,
  BZMath, BZGraphic, BZInterpolationFilters, BZImageViewer;

type

  { TResizeForm }
  TSelectedUnit = (suPixel,suPercent,suPrint);
  TSelectedPrintUnit = (spuInch,spuCm,spuMm);
  TResizeForm = class(TForm)
    Panel1 : TPanel;
    btnApply : TBitBtn;
    btnCancel : TBitBtn;
    GroupBox1 : TGroupBox;
    Label1 : TLabel;
    Label2 : TLabel;
    btnKeepAspectRatio : TSpeedButton;
    ImageList1 : TImageList;
    Shape1 : TShape;
    GroupBox2 : TGroupBox;
    Label3 : TLabel;
    Label4 : TLabel;
    cbxResizeMode : TComboBox;
    cbxResampleMethod : TComboBox;
    Panel2 : TPanel;
    Panel3 : TPanel;
    rgUnits : TRadioGroup;
    cbxPrintUnit : TComboBox;
    btnPreset : TSpeedButton;
    ppmPixelSize : TPopupMenu;
    ppmPercentSize : TPopupMenu;
    MenuItem1 : TMenuItem;
    MenuItem2 : TMenuItem;
    MenuItem3 : TMenuItem;
    MenuItem4 : TMenuItem;
    MenuItem5 : TMenuItem;
    MenuItem6 : TMenuItem;
    MenuItem7 : TMenuItem;
    MenuItem8 : TMenuItem;
    MenuItem9 : TMenuItem;
    MenuItem10 : TMenuItem;
    MenuItem11 : TMenuItem;
    MenuItem12 : TMenuItem;
    MenuItem13 : TMenuItem;
    MenuItem14 : TMenuItem;
    MenuItem15 : TMenuItem;
    MenuItem16 : TMenuItem;
    MenuItem17 : TMenuItem;
    MenuItem18 : TMenuItem;
    MenuItem19 : TMenuItem;
    MenuItem20 : TMenuItem;
    MenuItem21 : TMenuItem;
    MenuItem22 : TMenuItem;
    MenuItem23 : TMenuItem;
    MenuItem24 : TMenuItem;
    MenuItem25 : TMenuItem;
    MenuItem26 : TMenuItem;
    MenuItem27 : TMenuItem;
    MenuItem28 : TMenuItem;
    MenuItem29 : TMenuItem;
    MenuItem30 : TMenuItem;
    cbxDPI : TComboBox;
    Label6 : TLabel;
    speWidth : TFloatSpinEdit;
    speHeight : TFloatSpinEdit;
    GroupBox3 : TGroupBox;
    lblOriginalSize : TLabel;
    Label5 : TLabel;
    lblOriginalPrintSize : TLabel;
    Label7 : TLabel;
    Label8 : TLabel;
    lblOriginalDPI : TLabel;
    GroupBox4 : TGroupBox;
    lblNewSize : TLabel;
    Label10 : TLabel;
    lblNewPrintSize : TLabel;
    Label11 : TLabel;
    Label12 : TLabel;
    lblNewDPI : TLabel;
    procedure btnKeepAspectRatioClick(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure speWidthChange(Sender : TObject);
    procedure speHeightChange(Sender : TObject);
    procedure FormShow(Sender : TObject);
    procedure btnPresetClick(Sender : TObject);
    procedure rgUnitsSelectionChanged(Sender : TObject);
    procedure cbxDPIChange(Sender : TObject);
    procedure cbxPrintUnitSelect(Sender : TObject);
    procedure cbxResizeModeSelect(Sender : TObject);
    procedure cbxResampleMethodSelect(Sender : TObject);
  private
    FKeepAspectRatio : Boolean;
    FImageWidth : Integer;
    FImageHeight : Integer;
    FNewImageWidth : Integer;
    FNewImageHeight : Integer;
    FSelectedUnit : TSelectedUnit;
    FSelectedPrintUnit : TSelectedPrintUnit;
    FResizeMode : TBZImageStretchMode;
    FResampleMethod : TBZInterpolationFilterMethod;

    FDPI : Integer;

    procedure SetImageWidth(const AValue : Integer);
    procedure SetImageHeight(const AValue : Integer);
    procedure SetNewImageWidth(const AValue : Integer);
    procedure SetNewImageHeight(const AValue : Integer);
  protected
    vChange, hChange : Boolean;
    procedure ComputeNewSize(nw, nh : Single);
    procedure UpdateInfos;
  public
    property ImageWidth : Integer read FImageWidth write SetImageWidth;
    property ImageHeight : Integer read FImageHeight write SetImageHeight;
    property NewImageWidth : Integer read FNewImageWidth write SetNewImageWidth;
    property NewImageHeight : Integer read FNewImageHeight write SetNewImageHeight;
    property ResizeMode : TBZImageStretchMode read FResizeMode write FResizeMode;
    property ResampleMethod : TBZInterpolationFilterMethod read FResampleMethod;
  end;

var
  ResizeForm : TResizeForm;

implementation

{$R *.lfm}

Uses BZTypesHelpers;

{ TResizeForm }
procedure TResizeForm.FormCreate(Sender : TObject);
Var
  sl : TStringList;
begin
  FKeepAspectRatio := False;
  vChange := False;
  hChange := False;
  FSelectedUnit := suPixel;
  FSelectedPrintUnit := spuCm;
  sl := TStringList.Create;
  GetBZInterpolationFilters.BuildStringList(sl);
  cbxResampleMethod.Items.Assign(sl);
  cbxResampleMethod.ItemIndex := 29; //Lanczos3
  FResizeMode := ismResample;
  FResampleMethod := ifmLanczos3;
  FreeAndNil(sl);
end;

procedure TResizeForm.btnKeepAspectRatioClick(Sender : TObject);
begin
 // btnKeepAspectRatio.Down := not(btnKeepAspectRatio.Down);
  if btnKeepAspectRatio.Down then
  begin
    btnKeepAspectRatio.ImageIndex := 3;
    FKeepAspectRatio := True;
    Case FSelectedUnit of
      suPixel, suPrint :
      begin
        speWidth.Enabled := True;
        speHeight.Enabled := True;
      end;
      suPercent :
      begin
        speWidth.Enabled := True;
        speHeight.Enabled := False;
      end;
    end;
  end
  else
  begin
    btnKeepAspectRatio.ImageIndex := 2;
    FKeepAspectRatio := False;
    speWidth.Enabled := True;
    speHeight.Enabled := True;
  end;
end;

procedure TResizeForm.speWidthChange(Sender : TObject);
begin
  hChange := True;
  if not(vChange) then ComputeNewSize(speWidth.Value,speHeight.Value);
  vChange := False;
end;

procedure TResizeForm.speHeightChange(Sender : TObject);
begin
  vChange := True;
  if not(hChange) then ComputeNewSize(speWidth.Value,speHeight.Value);
  hChange := False;
end;

procedure TResizeForm.FormShow(Sender : TObject);
var
  cmx, cmy : Single;
begin
  lblOriginalSize.Caption := ImageWidth.ToString + 'x' + ImageHeight.ToString;
  speWidth.Value := ImageWidth;
  speHeight.Value := ImageHeight;
  cmx := PixelsResolutionToCentimeters(ImageWidth,96);
  cmy := PixelsResolutionToCentimeters(ImageHeight,96);
  lblOriginalPrintSize.Caption := cmx.ToString(2) + 'x' + cmy.ToString(2);
  NewImageWidth := ImageWidth;
  NewImageHeight := ImageHeight;
  lblNewSize.Caption := NewImageWidth.ToString + 'x' + NewImageHeight.ToString;
end;

procedure TResizeForm.btnPresetClick(Sender : TObject);
begin
  btnPreset.PopupMenu.PopUp;
end;

procedure TResizeForm.rgUnitsSelectionChanged(Sender : TObject);
begin
  Case rgUnits.ItemIndex of
    0 :
    begin
      FSelectedUnit := suPixel;
      speWidth.Enabled := True;
      speHeight.Enabled := True;
      cbxDPI.Enabled := False;
      cbxPrintUnit.Enabled := False;
    end;
    1 :
    begin
      FSelectedUnit := suPercent;
      speWidth.Value := ((NewImageWidth * 100) / ImageWidth);
      speWidth.Enabled := True;
      speHeight.Value := ((NewImageHeight * 100) / ImageHeight);
      speHeight.Enabled := not(btnKeepAspectRatio.Down);
      cbxDPI.Enabled := False;
      cbxPrintUnit.Enabled := False;
    end;
    2 :
    begin
      FSelectedUnit := suPrint;
      speWidth.Value := PixelsResolutionToCentimeters(NewImageWidth,StrToInt(cbxDPI.Text));
      speHeight.Value := PixelsResolutionToCentimeters(NewImageHeight,StrToInt(cbxDPI.Text));
      speWidth.Enabled := True;
      speHeight.Enabled := True;
      cbxDPI.Enabled := True;
      cbxPrintUnit.Enabled := True;
    end;
  end;
end;

procedure TResizeForm.cbxDPIChange(Sender : TObject);
begin
  if (Length(cbxDPI.Text) > 0) then FDPI := StrToInt(cbxDPI.Text);
end;

procedure TResizeForm.cbxPrintUnitSelect(Sender : TObject);
begin
  Case cbxPrintUnit.ItemIndex of
    0 : FSelectedPrintUnit := spuInch;
    1 : FSelectedPrintUnit := spuCm;
    2 : FSelectedPrintUnit := spuMm;
  end;
end;

procedure TResizeForm.cbxResizeModeSelect(Sender : TObject);
begin
  FResizeMode := TBZImageStretchMode(cbxResizeMode.ItemIndex);
  cbxResampleMethod.Enabled := (cbxResizeMode.ItemIndex = 3);
end;

procedure TResizeForm.cbxResampleMethodSelect(Sender : TObject);
begin
  FresampleMethod := TBZInterpolationFilterMethod(cbxResampleMethod.ItemIndex);
end;

procedure TResizeForm.SetImageHeight(const AValue : Integer);
begin
  if FImageHeight = AValue then Exit;
  FImageHeight := AValue;
  speHeight.Value := FImageHeight;
end;

procedure TResizeForm.SetImageWidth(const AValue : Integer);
begin
  if FImageWidth = AValue then Exit;
  FImageWidth := AValue;
  speWidth.Value := FImageWidth;
end;

procedure TResizeForm.SetNewImageHeight(const AValue : Integer);
begin
  if FNewImageHeight = AValue then Exit;
  FNewImageHeight := AValue;
end;

procedure TResizeForm.SetNewImageWidth(const AValue : Integer);
begin
  if FNewImageWidth = AValue then Exit;
  FNewImageWidth := AValue;
end;

procedure TResizeForm.ComputeNewSize(nw, nh : Single);
Var
  Delta, dw, dh,  TmpW, TmpH : Single;
begin
  Case FSelectedUnit of
    suPixel:
    begin
      if FKeepAspectRatio then
      begin
        if vChange then
        begin
          TmpH := nh;
          Delta := TmpH / ImageHeight;
          NewImageWidth := Round(ImageWidth * Delta);
          NewImageHeight := Round(nh);
          speWidth.Value := NewImageWidth;
        end
        else if hChange then
        begin
          TmpW := nw;
          Delta := TmpW / ImageWidth;
          NewImageHeight := Round(ImageHeight * Delta);
          NewImageWidth  := Round(nw);
          speHeight.Value := NewImageHeight;
        end;
      end
      else
      begin
        NewImageWidth  := Round(nw);
        NewImageHeight := Round(nh);
      end;
    end;
    suPercent:
    begin
      if FKeepAspectRatio then
      begin
        TmpW := nw;
        Delta := TmpW / 100;
        NewImageWidth := Round(ImageWidth * Delta);
        NewImageHeight := Round(ImageHeight * Delta);
      end
      else
      begin
        TmpW := nw;
        TmpH := nh;
        Delta := TmpH / 100;
        NewImageHeight := Round(ImageHeight * Delta);
        Delta := TmpW / 100;
        NewImageWidth := Round(ImageWidth * Delta);
      end;
    end;
    suPrint:
    begin
      TmpW := nw;
      TmpH := nh;
      Case FSelectedPrintUnit of
        spuInch :
        begin
          if FKeepAspectRatio then
          begin
            if vChange then
            begin
              dh := InchToCentimeters(TmpH);
              NewImageHeight := CentimetersToPixelsResolution(dh, FDPI);
              Delta := TmpW / ImageWidth;
              NewImageHeight := Round(ImageHeight * Delta);
              speHeight.Value := NewImageHeight;
            end
            else if hChange then
            begin
              Delta := TmpH / ImageHeight;
              NewImageWidth := Round(ImageWidth * Delta);
              speWidth.Value := NewImageWidth;
            end;
          end
          else
          begin
            dw := InchToCentimeters(TmpW);
            dh := InchToCentimeters(TmpH);
            NewImageWidth  := CentimetersToPixelsResolution(dw, FDPI);
            NewImageHeight := CentimetersToPixelsResolution(dh, FDPI);
          end;
        end;
        spuCm :
        begin
          if FKeepAspectRatio then
          begin

          end
          else
          begin
            NewImageWidth  := CentimetersToPixelsResolution(TmpW, FDPI);
            NewImageHeight := CentimetersToPixelsResolution(TmpH, FDPI);
          end;
        end;
        spuMm :
        begin
          TmpW := TmpW / 10;
          TmpH := TmpH / 10;
          if FKeepAspectRatio then
          begin

          end
          else
          begin
            NewImageWidth  := CentimetersToPixelsResolution(TmpW, FDPI);
            NewImageHeight := CentimetersToPixelsResolution(TmpH, FDPI);
          end;
        end;
      end;
    end;
  end;

  lblNewSize.Caption := NewImageWidth.ToString + 'x' + NewImageHeight.ToString;
end;

procedure TResizeForm.UpdateInfos;
Var
  npWidth, npHeight : Integer;
begin

end;

end.

