unit uColorPickerForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LCLIntf, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons, StdCtrls, clipbrd,
  {$IFDEF WINDOWS}
  windows, jwawinuser,
  {$ENDIF}
  uDMMain, BZThreadTimer, BZColors, BZGraphic, BZBitmap, BZStopWatch;

type
  { TColorWatchForm }
  TSelectedValue =(svRed, svGreen, svBlue, svHexa);
  TColorWatchForm = class(TForm)
    ThrTimer : TBZThreadTimer;
    pnlTitleBar : TPanel;
    lblTitle : TLabel;
    btnToggleFrame : TSpeedButton;
    pnlContainer : TPanel;
    Label1 : TLabel;
    btnZoomOut : TSpeedButton;
    btnZoomIn : TSpeedButton;
    Label5 : TLabel;
    cbxColorFormat : TComboBox;
    pnlMagnifier : TPanel;
    btnActivateColorPicker : TSpeedButton;
    CheckBox1 : TCheckBox;
    pnlColorWatch : TPanel;
    lblValue1 : TLabel;
    edtRed : TEdit;
    lblValue2 : TLabel;
    edtGreen : TEdit;
    lblValue3 : TLabel;
    edtBlue : TEdit;
    Label4 : TLabel;
    edtHexa : TEdit;
    btnCopyToClipboard : TSpeedButton;
    btnClose : TSpeedButton;
    procedure ThrTimerTimer(Sender : TObject);
    procedure btnActivateColorPickerClick(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure FormClose(Sender : TObject; var CloseAction : TCloseAction);
    procedure btnZoomOutClick(Sender : TObject);
    procedure btnZoomInClick(Sender : TObject);
    procedure btnCopyToClipboardClick(Sender : TObject);
    procedure edtRedEnter(Sender : TObject);
    procedure edtGreenClick(Sender : TObject);
    procedure edtBlueClick(Sender : TObject);
    procedure edtHexaClick(Sender : TObject);
    procedure FormCloseQuery(Sender : TObject; var CanClose : boolean);
    procedure btnToggleFrameClick(Sender : TObject);
    procedure btnCloseClick(Sender : TObject);
    procedure pnlTitleBarMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure pnlTitleBarMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure pnlTitleBarMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
  private
     FExpanded : Boolean;
     FMousePos : TPoint;
     FPickerActive : Boolean;
     FScreenShot, FMagnifier, FSample : TBZBitmap;
     FZoomIndex : Integer;
     FZoomFactor : Integer;
     FDeltaZoom : Integer;
     FCurrentColor : TBZColor;
     FSelectedValue : TSelectedValue;
     FElapsedTime : Double;
     FStopWatch : TBZStopWatch;
     FMouseMove :boolean;
     FMousePoint : TPoint;


     procedure SetPickerActive(const AValue : Boolean);
     procedure SetZoomFactor(const AValue : Integer);
  protected

  public
    property PickerActive : Boolean read  FPickerActive write SetPickerActive;
    property ZoomFactor : Integer read FZoomFactor write SetZoomFactor;
    property Expanded : Boolean read FExpanded write FExpanded default True;
  end;

var
  ColorWatchForm : TColorWatchForm;

implementation

{$R *.lfm}

{.$R cursor.res}

uses
  BZSystem, BZMath;

Const
  crTarget = 1;

function LoadCursorFromRes(CursorName:String):THandle;
var
   Cur: TCursorImage;
begin
   Cur := TCursorImage.Create;
   Cur.LoadFromResourceName(HInstance,CursorName);
   result := Cur.ReleaseHandle;
   Cur.Free;
end;

{ TColorWatchForm }

procedure TColorWatchForm.ThrTimerTimer(Sender : TObject);
Var
  KeyState : TShiftState;
  MouseState : TShiftState;
  SelectRect : TBZRect;
begin

  FElapsedTime := FStopWatch.getAsSecond;
  if FElapsedTime >= 1 then
  begin
    FScreenShot.TakeDesktopScreenShot;
    FElapsedTime := 0;
    FStopWatch.Stop;
    FStopWatch.Start;
  end;
  LCLIntf.GetCursorPos(FMousePos);
  KeyState:= GetKeyShiftState;
  MouseState := GetMouseButtonState;
  if (ssCtrl in KeyState ) and (ssRight in MouseState) then
  begin
    PickerActive := False;
  end;

  SelectRect.Create((FMousePos.x - FDeltaZoom), (FMousePos.y - FDeltaZoom), (FMousePos.x + FDeltaZoom), (FMousePos.y + FDeltaZoom));
  FSample.Clear(clrBlack);
  FSample.PutImage(FScreenShot,SelectRect.Left, SelectRect.Top,SelectRect.Width, SelectRect.Height,0,0);
  FMagnifier.PutImageStretch(FSample,BZRect(0,0,159,159),255);

  FCurrentColor := FScreenShot.GetPixel(FMousePos.x, FMousePos.y);
  pnlColorWatch.Color := FCurrentColor.AsColor;
  With FMagnifier.Canvas do
  begin
    pen.Style := ssSolid;
    pen.Color := clrRed;
    Rectangle(FMagnifier.CenterX, FMagnifier.CenterY,FMagnifier.CenterX + FZoomFactor, FMagnifier.CenterY + FZoomFactor);
  end;

  edtRed.Text := FCurrentColor.Red.ToString;
  edtGreen.Text := FCurrentColor.Green.ToString;
  edtBlue.Text := FCurrentColor.Blue.ToString;
  edtHexa.Text := '#00' + FCurrentColor.Red.ToHexString(2) + FCurrentColor.Green.ToHexString(2) + FCurrentColor.Blue.ToHexString(2);

  FMagnifier.DrawToCanvas(pnlMagnifier.Canvas, pnlMagnifier.ClientRect);
end;

procedure TColorWatchForm.btnActivateColorPickerClick(Sender : TObject);
begin
  PickerActive := Not(PickerActive);
end;

procedure TColorWatchForm.FormCreate(Sender : TObject);
begin
  FZoomIndex := 0;
  FDeltaZoom := 80;
  FPickerActive := False;
  FScreenShot := TBZBitmap.Create;
  FMagnifier := TBZBitmap.Create(190,160);
  FSample := TBZBitmap.Create(190,160);
  FStopWatch := TBZStopWatch.Create(self);
  FSelectedValue := svHexa;
  FElapsedTime := 0;
 // Screen.Cursors[crTarget] := LoadCursorFromRes('target');
  FExpanded := true;
  FMouseMove := False;

end;

procedure TColorWatchForm.FormClose(Sender : TObject; var CloseAction : TCloseAction);
begin
  ThrTimer.Enabled := False;
  FreeAndNil(FSample);
  FreeAndNil(FMagnifier);
  FreeAndNil(FScreenShot);
  FreeAndNil(FStopWatch);
end;

procedure TColorWatchForm.btnZoomOutClick(Sender : TObject);
begin
  FZoomIndex := FZoomIndex - 1;
  if FZoomIndex < 0 then FZoomIndex := 0;
  Case FZoomIndex of
    0 :
    begin
      btnZoomOut.Enabled := False;
      ZoomFactor := 1;
    end;
    1 : ZoomFactor := 2;
    2 : ZoomFactor := 4;
    3 : ZoomFactor := 8;
  end;
  btnZoomIn.Enabled := True;
end;

procedure TColorWatchForm.btnZoomInClick(Sender : TObject);
begin
  FZoomIndex := FZoomIndex + 1;
  if FZoomIndex > 4 then FZoomIndex := 4;
  Case FZoomIndex of
    1 : ZoomFactor := 2;
    2 : ZoomFactor := 4;
    3 : ZoomFactor := 8;
    4 :
    begin
      btnZoomIn.Enabled := False;
      ZoomFactor := 16;
    end;
  end;
  btnZoomOut.Enabled := True;
end;

procedure TColorWatchForm.btnCloseClick(Sender : TObject);
begin
  //if not(Self.Floating) then
  //Dock(Nil, BoundsRect);
  //Hide;
  Close;
end;

procedure TColorWatchForm.btnCopyToClipboardClick(Sender : TObject);
begin
  Case FSelectedValue of
    svRed:
    begin
      edtRed.SelectAll;
      edtRed.CopyToClipboard;
    end;
    svGreen:
    begin
      edtGreen.SelectAll;
      edtGreen.CopyToClipboard;
    end;
    svBlue:
    begin
      edtBlue.SelectAll;
      edtBlue.CopyToClipboard;
    end;
    svHexa:
    begin
      edtHexa.SelectAll;
      edtHexa.CopyToClipboard;
    end;
  end;
end;

procedure TColorWatchForm.edtRedEnter(Sender : TObject);
begin
  FSelectedValue := svRed;
end;

procedure TColorWatchForm.edtGreenClick(Sender : TObject);
begin
  FSelectedValue := svGreen;
end;

procedure TColorWatchForm.edtBlueClick(Sender : TObject);
begin
  FSelectedValue := svBlue;
end;

procedure TColorWatchForm.edtHexaClick(Sender : TObject);
begin
  FSelectedValue := svHexa;
end;

procedure TColorWatchForm.FormCloseQuery(Sender : TObject; var CanClose : boolean);
begin
  FStopWatch.Stop;
  ThrTimer.Enabled := False;
  Dec(DMMain.DockFormCount);
  CanClose := True;
end;

procedure TColorWatchForm.btnToggleFrameClick(Sender : TObject);
begin
  if FExpanded then
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

procedure TColorWatchForm.pnlTitleBarMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  if Button= mbLeft then
  begin
    BeginDrag(True,3);
    FMouseMove := True;
    FMousePoint.x := x;
    FMousePoint.y := y;
  end;
end;

procedure TColorWatchForm.pnlTitleBarMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  FMouseMove := False;
end;

procedure TColorWatchForm.pnlTitleBarMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
begin
  If FMouseMove and (ssLeft in Shift) then
  begin
    Left := Left - (FMousePoint.X - X);
    Top  := Top - (FMousePoint.Y - Y);
  end;
end;

procedure TColorWatchForm.SetPickerActive(const AValue : Boolean);
//{$IFDEF WINDOWS}
//var
//  wcCursor : HCURSOR;
//{$ENDIF}
begin
  if FPickerActive = AValue then Exit;
  FPickerActive := AValue;
  if FPickerActive then
  begin
    btnActivateColorPicker.ImageIndex := 8;
    btnActivateColorPicker.Caption := 'Désactiver';
    Application.ProcessMessages;
    FScreenShot.TakeDesktopScreenShot;
    //Screen.Cursor := crTarget;
    //{$IFDEF WINDOWS}
    //wcCursor := CopyImage(Screen.Cursors[crTarget], IMAGE_CURSOR, 0, 0, LR_COPYFROMRESOURCE);
    //SetSystemCursor(wcCursor, OCR_NORMAL);
    //{$ENDIF}
    FStopWatch.Start();
    ThrTimer.Enabled := True;
  end
  else
  begin
    //Screen.Cursor := crDefault;
    //{$IFDEF WINDOWS}
    //wcCursor := CopyImage(Screen.Cursors[crDefault], IMAGE_CURSOR, 0, 0, LR_COPYFROMRESOURCE);
    //SetSystemCursor(wcCursor, OCR_NORMAL);
    //{$ENDIF}
    ThrTimer.Enabled := False;
    btnActivateColorPicker.ImageIndex := 7;
    btnActivateColorPicker.Caption := 'Activer';

  end;
end;

procedure TColorWatchForm.SetZoomFactor(const AValue : Integer);
begin
  if FZoomFactor = AValue then Exit;
  FZoomFactor := AValue;
  FDeltaZoom := (160 div FZoomFactor);
  FSample.SetSize(FDeltaZoom, FDeltaZoom);
  FDeltaZoom := FDeltaZoom div 2;
end;

end.

