unit uHistogramForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Buttons,
  uDMMain, BZColors, BZGraphic, BZBitmap;

type

  { THistogramForm }

  THistogramForm = class(TForm)
    pnlTitleBar : TPanel;
    lblTitle : TLabel;
    btnToggleFrame : TSpeedButton;
    btnClose : TSpeedButton;
    Panel2 : TPanel;
    Label1 : TLabel;
    btnHistoLinear : TSpeedButton;
    btnHistoLogarithm : TSpeedButton;
    cbxHistoChannel : TComboBox;
    pnlHistoView : TPanel;
    procedure btnCloseClick(Sender : TObject);
    procedure btnToggleFrameClick(Sender : TObject);
    procedure cbxHistoChannelChange(Sender : TObject);
    procedure pnlHistoViewPaint(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure btnHistoLinearClick(Sender : TObject);
    procedure FormCloseQuery(Sender : TObject; var CanClose : boolean);
    procedure pnlTitleBarMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure pnlTitleBarMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure pnlTitleBarMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
  private
    FImgHistogram : TBZBitmap;
    FSource : TBZBitmap;
    FExpanded : Boolean;
    FMouseMove :boolean;
    FMousePoint : TPoint;
  public
    procedure UpdateHistogram(bmp : TBZBitmap);

    property Expanded : Boolean read FExpanded write FExpanded default True;
  end;

var
  HistogramForm : THistogramForm;

implementation

{$R *.lfm}

{ THistogramForm }

procedure THistogramForm.FormCreate(Sender : TObject);
begin
  FImgHistogram := TBZBitmap.Create(pnlHistoView.ClientWidth, pnlHistoView.ClientHeight);
  FExpanded := true;
end;

procedure THistogramForm.FormDestroy(Sender : TObject);
begin
  FreeAndNil(FImgHistogram);
end;

procedure THistogramForm.btnCloseClick(Sender : TObject);
begin
  Close;
end;

procedure THistogramForm.btnToggleFrameClick(Sender : TObject);
begin
  if Expanded then
  begin
    btnToggleFrame.ImageIndex := 31;
    Self.ClientHeight := pnlTitleBar.Height + 1;
    Expanded := False;
  end
  else
  begin
    btnToggleFrame.ImageIndex := 32;
    Self.ClientHeight := 465;
    Expanded := True;
  end;
end;

procedure THistogramForm.cbxHistoChannelChange(Sender : TObject);
begin
  FSource.Histogram.DrawTo(FImgHistogram,TBZHistorgramDrawMode(cbxHistoChannel.ItemIndex),btnHistoLogarithm.Down,true, true, true);
  pnlHistoView.Invalidate;
end;

procedure THistogramForm.pnlHistoViewPaint(Sender : TObject);
begin
  FImgHistogram.DrawToCanvas(pnlHistoView.Canvas, pnlHistoView.ClientRect);
end;

procedure THistogramForm.pnlTitleBarMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  if Button= mbLeft then
  begin
    BeginDrag(True,3);
    FMouseMove := True;
    FMousePoint.x := x;
    FMousePoint.y := y;
  end;
end;

procedure THistogramForm.pnlTitleBarMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  FMouseMove := False;
end;

procedure THistogramForm.pnlTitleBarMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
begin
  If FMouseMove and (ssLeft in Shift) then
  begin
    Left := Left - (FMousePoint.X - X);
    Top  := Top - (FMousePoint.Y - Y);
  end;
end;

procedure THistogramForm.btnHistoLinearClick(Sender : TObject);
begin
  FSource.Histogram.DrawTo(FImgHistogram,TBZHistorgramDrawMode(cbxHistoChannel.ItemIndex),btnHistoLogarithm.Down,true, true, true);
  pnlHistoView.Invalidate;
end;

procedure THistogramForm.FormCloseQuery(Sender : TObject; var CanClose : boolean);
begin
  Dec(DMMain.DockFormCount);
  CanClose := True;
end;

procedure THistogramForm.UpdateHistogram(bmp : TBZBitmap);
begin
  FSource := bmp;
  FSource.Histogram.DrawTo(FImgHistogram,TBZHistorgramDrawMode(cbxHistoChannel.ItemIndex),btnHistoLogarithm.Down,true, true, true);
  pnlHistoView.Invalidate;
end;

end.

