unit uHistogramFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls, Buttons,
  BZColors, BZGraphic, BZBitmap;

type

  { THistogramFrame }

  THistogramFrame = class(TFrame)
    pnlTitleBar : TPanel;
    lblTitle : TLabel;
    btnToggleFrame : TSpeedButton;
    Panel2 : TPanel;
    Label1 : TLabel;
    btnHistoLinear : TSpeedButton;
    btnHistoLogarithm : TSpeedButton;
    cbxHistoChannel : TComboBox;
    pnlHistoView : TPanel;
    procedure btnToggleFrameClick(Sender : TObject);
    procedure pnlHistoViewPaint(Sender : TObject);
    procedure cbxHistoChannelChange(Sender : TObject);
    procedure btnHistoLinearClick(Sender : TObject);
  private
    FExpanded : Boolean;
    FImgHistogram : TBZBitmap;
    FSource : TBZBitmap;
  public
    procedure Init;
    procedure UpdateHistogram(bmp : TBZBitmap);
    property Expanded : Boolean read FExpanded write FExpanded default True;
  end;

  function CreateHistogramFrame(TheOwner :  TComponent; Title : String; Const ExpandedState : Boolean = true) : TFrame;

implementation

function CreateHistogramFrame(TheOwner : TComponent; Title : String; Const ExpandedState : Boolean) : TFrame;
Var
  Frame : THistogramFrame;
begin
  Frame := THistogramFrame.Create(TheOwner);
  Frame.lblTitle.Caption := Title;
  Frame.Expanded :=ExpandedState;
  THistogramFrame(Frame).Init;
  Result := Frame;
end;

{$R *.lfm}

{ THistogramFrame }

procedure THistogramFrame.btnToggleFrameClick(Sender : TObject);
begin
  if FExpanded then
  begin
    btnToggleFrame.ImageIndex := 31;
    Self.Height := pnlTitleBar.Height + 1;
    Expanded := False;
  end
  else
  begin
    btnToggleFrame.ImageIndex := 32;
    Self.Height := 190;
    Expanded := True;
  end;
end;

procedure THistogramFrame.pnlHistoViewPaint(Sender : TObject);
begin
  FImgHistogram.DrawToCanvas(pnlHistoView.Canvas, pnlHistoView.ClientRect);
end;

procedure THistogramFrame.cbxHistoChannelChange(Sender : TObject);
begin
  FSource.Histogram.DrawTo(FImgHistogram,TBZHistorgramDrawMode(cbxHistoChannel.ItemIndex),btnHistoLogarithm.Down,true, true, true);
  pnlHistoView.Invalidate;
end;

procedure THistogramFrame.btnHistoLinearClick(Sender : TObject);
begin
  FSource.Histogram.DrawTo(FImgHistogram,TBZHistorgramDrawMode(cbxHistoChannel.ItemIndex),btnHistoLogarithm.Down,true, true, true);
  pnlHistoView.Invalidate;
end;

procedure THistogramFrame.Init;
begin
  FImgHistogram := TBZBitmap.Create(pnlHistoView.ClientWidth, pnlHistoView.ClientHeight);
end;

procedure THistogramFrame.UpdateHistogram(bmp : TBZBitmap);
begin
  FSource := bmp;
  FSource.Histogram.DrawTo(FImgHistogram,TBZHistorgramDrawMode(cbxHistoChannel.ItemIndex),btnHistoLogarithm.Down,true, true, true);
end;

end.

