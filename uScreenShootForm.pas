unit uScreenShootForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, BZThreadTimer,
  LCLIntf, uDMMain, BZClasses, BZColors, BZGraphic, BZBitmap;

type

  { TScreenShootForm }
  TBZSelectionDragMode = (sdmNone, sdmInside, sdmTop, sdmBottom, sdmLeft, sdmRight, sdmTopLeft, sdmTopRight, sdmBottomLeft, sdmBottomRight);
  TBZSelectionAction = (saNone, saMoving, saResizingHorz, saResizingVert, saResizingDiag);

  { TBZSelectTool }

  TBZSelectTool = class(TBZUpdateAbleObject)
  private
    FSelection : TBZRect;
    FDragMode : TBZSelectionDragMode;
    FCurrentAction : TBZSelectionAction;
    FAnchorSize : Byte;
    FLastCursorPos, FCurrentCursorPos : TBZPoint;
    FSelectionMouseActive : Boolean;
    FEmptySelection : Boolean;
    procedure SetEmptySelection(const AValue : Boolean);
  protected
    procedure SwapHorizBorders;
    procedure SwapVertBorders;

    function GetSelectionDragMode(x, y : Integer) : TBZSelectionDragMode;
    function GetSelectionAction : TBZSelectionAction;
    function GetAnchorRect(x, y : Integer) : TBZRect;
    function GetMouseCursor : TCursor;

    procedure DrawAnchor(x, y : Integer; VirtualCanvas : TBZBitmapCanvas);

  public
    Constructor Create; override;

    procedure DrawSelection(VirtualCanvas : TBZBitmapCanvas);

    procedure DoSelectionMouseDownHandle(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure DoSelectionMouseUpHandle(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure DoSelectionMouseMoveHandle(Sender : TObject; Shift : TShiftState; X, Y : Integer);

    property Selection : TBZRect read FSelection write FSelection;
    property CurrentAction : TBZSelectionAction  read FCurrentAction write FCurrentAction;

    property IsEmpty : Boolean read FEmptySelection write SetEmptySelection;
  end;

  TScreenShootForm = class(TForm)
    BZThreadTimer1 : TBZThreadTimer;
    pnlMagnifier : TPanel;
    pnlMagnifierView : TPanel;
    Label1 : TLabel;
    pnlSelectInfo : TPanel;
    lblSelectInfo : TLabel;
    procedure FormShow(Sender : TObject);
    procedure BZThreadTimer1Timer(Sender : TObject);
    procedure FormPaint(Sender : TObject);
    procedure FormKeyPress(Sender : TObject; var Key : char);
    procedure FormCloseQuery(Sender : TObject; var CanClose : boolean);
    procedure FormCreate(Sender : TObject);
    procedure FormMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure FormMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
    procedure FormMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure pnlMagnifierViewPaint(Sender : TObject);
  private
     FScreenShooted : Boolean;
     FDisplayBuffer : TBZBitmap;
     FMagnifierBuffer : TBZBitmap;
     FMagnifierBitmap : TBZBitmap;
     FSelectionTool : TBZSelectTool;
     //FMagnifierRect : TRect;

     procedure SwapMagnifier;
  public

  end;

var
  ScreenShootForm : TScreenShootForm;

implementation

{$R *.lfm}

{ TBZSelectTool }

Constructor TBZSelectTool.Create;
begin
  FAnchorSize := 5;
  FDragMode := sdmNone;
  FCurrentAction := saNone;
  FEmptySelection := True;
end;

procedure TBZSelectTool.SetEmptySelection(const AValue : Boolean);
begin
  if FEmptySelection = AValue then Exit;
  FEmptySelection := AValue;
end;

procedure TBZSelectTool.SwapHorizBorders;
Var
  Temp : Integer;
begin
  Temp := FSelection.Left;
  FSelection.Left := FSelection.Right;
  FSelection.Right := Temp;
end;

procedure TBZSelectTool.SwapVertBorders;
Var
  Temp : Integer;
begin
  Temp := FSelection.Top;
  FSelection.Top := FSelection.Bottom;
  FSelection.Bottom := Temp;
end;

function TBZSelectTool.GetSelectionDragMode(x, y : Integer) : TBZSelectionDragMode;
Var
  pos : TBZPoint;
begin
  pos.Create(x,y);
  if GetAnchorRect(FSelection.Left, FSelection.Top).PointInRect(pos) then Exit(sdmTopLeft);
  if GetAnchorRect(FSelection.Right, FSelection.Top).PointInRect(pos) then Exit(sdmTopRight);
  if GetAnchorRect(FSelection.Left, FSelection.Bottom).PointInRect(pos) then Exit(sdmBottomLeft);
  if GetAnchorRect(FSelection.Right, FSelection.Bottom).PointInRect(pos) then Exit(sdmBottomRight);
  if GetAnchorRect(FSelection.CenterPoint.X, FSelection.Top).PointInRect(pos) then Exit(sdmTop);
  if GetAnchorRect(FSelection.CenterPoint.X, FSelection.Bottom).PointInRect(pos) then Exit(sdmBottom);
  if GetAnchorRect(FSelection.Left, FSelection.CenterPoint.Y).PointInRect(pos) then Exit(sdmLeft);
  if GetAnchorRect(FSelection.Right, FSelection.CenterPoint.Y).PointInRect(pos) then Exit(sdmRight);
  if FSelection.PointInRect(pos) then Exit(sdmInside);
  Result := sdmNone;
end;

function TBZSelectTool.GetSelectionAction : TBZSelectionAction;
begin
  Case FDragMode of
    sdmNone : Result := saNone;
    sdmInside : Result := saMoving;
    sdmTop, sdmBottom : Result := saResizingVert;
    sdmLeft, sdmRight : Result := saResizingHorz;
    sdmTopLeft, sdmTopRight, sdmBottomLeft, sdmBottomRight : Result := saResizingDiag;
  end;
end;

function TBZSelectTool.GetAnchorRect(x, y : Integer) : TBZRect;
Var
  s : Integer;
begin
  s := FAnchorSize div 2;
  Result.Create(x - s, y - s, x + s + 1, y + s + 1);
end;

function TBZSelectTool.GetMouseCursor : TCursor;
begin
  Case FDragMode of
    sdmNone : Result := crDefault;
    sdmInside : Result := crSizeAll;
    sdmTop, sdmBottom : Result := crSizeNS;
    sdmLeft, sdmRight : Result := crSizeWE;
    sdmTopLeft, sdmBottomRight : Result := crSizeNWSE;
    sdmTopRight, sdmBottomLeft : Result := crSizeNESW;
  end;
end;

procedure TBZSelectTool.DrawAnchor(x, y : Integer; VirtualCanvas : TBZBitmapCanvas);
Var
  OldPenStyle : TBZStrokeStyle;
  OldBrushStyle : TBZBrushStyle;
  OldCombineMode : TBZColorCombineMode;
  OldPixelMode : TBZBitmapDrawMode;
  OldAlphaMode : TBZBitmapAlphaMode;
  OldPenColor : TBZColor;
  OldBrushColor : TBZColor;
begin
  With VirtualCanvas do
  begin
    OldPenStyle := Pen.Style;
    OldPenColor := Pen.Color;
    OldBrushStyle := Brush.Style;
    OldBrushColor := Brush.Color;
    OldCombineMode := DrawMode.CombineMode;
    OldPixelMode := DrawMode.PixelMode;
    OldAlphaMode := DrawMode.AlphaMode;
    DrawMode.PixelMode := dmCombine;
    DrawMode.AlphaMode := amNone; //amAlphaBlendHQ;
    DrawMode.CombineMode := cmXOr;
    Pen.Style := ssSolid;
    Pen.Color := clrCyan;//clrYellow;
    Brush.Style := bsSolid;
    Brush.Color := clrWhite; //clrRed;
    Rectangle(X - FAnchorSize, Y  - FAnchorSize, X + FAnchorSize, Y + FAnchorSize);
    //Circle(X,Y, FAnchorSize);
    Pen.Style := OldPenStyle;
    Pen.Color := OldPenColor;
    Brush.Style := OldBrushStyle;
    Brush.Color := OldBrushColor;
    DrawMode.CombineMode := OldCombineMode;
    DrawMode.PixelMode := OldPixelMode;
    DrawMode.AlphaMode := OldAlphaMode;
  end;
end;

procedure TBZSelectTool.DrawSelection(VirtualCanvas : TBZBitmapCanvas);
Var
  OldPenStyle : TBZStrokeStyle;
  OldBrushStyle : TBZBrushStyle;
  OldCombineMode : TBZColorCombineMode;
  OldAlphaMode : TBZBitmapAlphaMode;
  OldPixelMode : TBZBitmapDrawMode;
  OldPenColor : TBZColor;
  VertMiddle, HorizMiddle : Integer;
begin

  With VirtualCanvas do
  begin
    OldCombineMode := DrawMode.CombineMode;
    OldPixelMode := DrawMode.PixelMode;
    OldAlphaMode := DrawMode.AlphaMode;
    OldPenStyle := Pen.Style;
    OldPenColor := Pen.Color;
    OldBrushStyle := Brush.Style;
    DrawMode.PixelMode := dmCombine;
    DrawMode.AlphaMode := amNone; //amAlphaBlendHQ;
    DrawMode.CombineMode := cmXor;
    Pen.Style := ssSolid;
    Pen.Color := clrWhite; //clrBlack; //clrYellow;
    Brush.Style := bsClear;
    Rectangle(FSelection);// (FStartPos.X, FStartPos.Y, FEndPos.X, FEndPos.Y);
    Pen.Style := OldPenStyle;
    Pen.Color := OldPenColor;
    Brush.Style := OldBrushStyle;
    DrawMode.CombineMode := OldCombineMode;
    DrawMode.PixelMode := OldPixelMode;
    DrawMode.AlphaMode := OldAlphaMode;
  end;

  HorizMiddle :=   FSelection.CenterPoint.X;
  VertMiddle := FSelection.CenterPoint.Y;

  DrawAnchor(FSelection.Left, FSelection.Top, VirtualCanvas);
  DrawAnchor(FSelection.Left, FSelection.Bottom, VirtualCanvas);
  DrawAnchor(FSelection.Right, FSelection.Top, VirtualCanvas);
  DrawAnchor(FSelection.Right, FSelection.Bottom, VirtualCanvas);
  DrawAnchor(HorizMiddle, FSelection.Top, VirtualCanvas);
  DrawAnchor(HorizMiddle, FSelection.Bottom, VirtualCanvas);
  DrawAnchor(FSelection.Left, VertMiddle, VirtualCanvas);
  DrawAnchor(FSelection.Right, VertMiddle, VirtualCanvas);
  DrawAnchor(HorizMiddle, VertMiddle, VirtualCanvas);

end;

procedure TBZSelectTool.DoSelectionMouseDownHandle(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  FSelectionMouseActive := True;
  FCurrentCursorPos.Create(X, Y);
  if Button = mbLeft then
  begin
    if FEmptySelection then
    begin
      FSelection.TopLeft := FCurrentCursorPos;
      FDragMode := sdmBottomRight;
      FCurrentAction := saResizingDiag;
      //ShowMessage(FSelection.ToString);
    end
    else
    begin
      FDragMode := GetSelectionDragMode(FCurrentCursorPos.x, FCurrentCursorPos.y);
      FCurrentAction := GetSelectionAction;
      Screen.Cursor := GetMouseCursor;
    end;
  end;
  FLastCursorPos := FCurrentCursorPos;
end;

procedure TBZSelectTool.DoSelectionMouseUpHandle(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  if FSelection.Left > FSelection.Right then SwapHorizBorders;
  if FSelection.Top > FSelection.Bottom then SwapVertBorders;
  FSelectionMouseActive := False;
  if FEmptySelection then FEmptySelection := False;
  FDragMode := sdmNone;
  FCurrentAction := saNone;
  Screen.Cursor := crDefault;
end;

procedure TBZSelectTool.DoSelectionMouseMoveHandle(Sender : TObject; Shift : TShiftState; X, Y : Integer);
Var
  DeltaPos : TBZPoint;
begin
  FCurrentCursorPos.Create(X, Y);
  if FSelectionMouseActive then
  begin
    if (ssLeft in Shift) then
    begin
      if FEmptySelection then
      begin
        FSelection.BottomRight := FCurrentCursorPos;
      end
      else
      begin
        if FCurrentAction <> saNone then
        begin
          DeltaPos := FCurrentCursorPos - FLastCursorPos;
          Case FCurrentAction of
            saMoving:
            begin
              FSelection.TopLeft := FSelection.TopLeft + DeltaPos;
              FSelection.BottomRight := FSelection.BottomRight + DeltaPos;
            end;
            saResizingHorz:
            begin
              Case FDragMode of
                sdmLeft :
                begin
                  FSelection.Left := FSelection.Left + DeltaPos.X;
                end;
                sdmRight :
                begin
                  FSelection.Right := FSelection.Right + DeltaPos.X;
                end;
              end;
            end;
            saResizingVert:
            begin
              Case FDragMode of
                sdmTop :
                begin
                  FSelection.Top := FSelection.Top + DeltaPos.Y;
                end;
                sdmBottom :
                begin
                  FSelection.Bottom := FSelection.Bottom + DeltaPos.Y;
                end;
              end;
            end;
            saResizingDiag:
            begin
              Case FDragMode of
                sdmTopLeft :
                begin
                  FSelection.TopLeft := FSelection.TopLeft + DeltaPos;
                end;
                sdmTopRight :
                begin
                  FSelection.Top := FSelection.Top + DeltaPos.Y;
                  FSelection.Right := FSelection.Right + DeltaPos.X;
                end;
                sdmBottomLeft :
                begin
                  FSelection.Left := FSelection.Left + DeltaPos.X;
                  FSelection.Bottom := FSelection.Bottom + DeltaPos.Y;
                end;
                sdmBottomRight :
                begin
                  FSelection.BottomRight := FSelection.BottomRight + DeltaPos;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  FLastCursorPos := FCurrentCursorPos;
end;

{ TScreenShootForm }

procedure TScreenShootForm.FormShow(Sender : TObject);
begin
  FDisplayBuffer.FastCopy(DMMain.ScreenShotBitmap);
  Visible := True;
  BZThreadTimer1.Enabled := True;
end;

procedure TScreenShootForm.BZThreadTimer1Timer(Sender : TObject);
Var
  pt : TPoint;
begin
  GetCursorPos(pt);
  pt := Self.ScreenToClient(pt);
  if pnlMagnifier.BoundsRect.Contains(pt) then
  begin
    SwapMagnifier;
  end;

  if FSelectionTool.IsEmpty then
  begin
    lblSelectInfo.Caption := 'X : ' + pt.X.ToString + ' ' +
                             'Y : ' + pt.Y.ToString + ' - ' +
                             'L : 0 ' +
                             'H : 0';
  end
  else
  begin
    lblSelectInfo.Caption := 'X : ' + FSelectionTool.Selection.Left.ToString + ' ' +
                             'Y : ' + FSelectionTool.Selection.Top.ToString + ' - ' +
                             'L : ' + FSelectionTool.Selection.Width.ToString + ' ' +
                             'H : ' + FSelectionTool.Selection.Height.ToString;

  end;
  //FMagnifierBuffer.CopyBlock(DMMain.ScreenShotBitmap, pt.x - 10, pt.y - 10, 20,20,0,0);
  FMagnifierBuffer.CopyBlock(FDisplayBuffer, pt.x - 10, pt.y - 10, 20,20,0,0);
  FMagnifierBitmap.PutImageStretch(FMagnifierBuffer,0,0,239,239);
  pnlMagnifierView.Invalidate;
end;

procedure TScreenShootForm.FormPaint(Sender : TObject);
begin
  FDisplayBuffer.FastCopy(DMMain.ScreenShotBitmap);
  FSelectionTool.DrawSelection(FDisplayBuffer.Canvas);
  FDisplayBuffer.DrawToCanvas(Self.Canvas, Self.BoundsRect);
end;

procedure TScreenShootForm.FormKeyPress(Sender : TObject; var Key : char);
begin
  if Key = #27 then
  begin
    FScreenShooted := False;
    Close;
  end
  else if Key = #13 then
  begin
    FScreenShooted := True;
    Close;
  end
end;

procedure TScreenShootForm.FormCloseQuery(Sender : TObject; var CanClose : boolean);
begin
  BZThreadTimer1.Enabled := False;
  if FScreenShooted then
  begin
    DMMain.ScreenShotBitmap.Transformation.CropRect(FSelectionTool.Selection);

    Self.ModalResult := mrOk;
  end
  else
  begin
    FreeAndNil(DMMain.ScreenShotBitmap);
    Self.ModalResult := mrCancel;
  end;
  FreeAndNil(FSelectionTool);
  FreeAndNil(FMagnifierBitmap);
  FreeAndNil(FMagnifierBuffer);
  FreeAndNil(FDisplayBuffer);

  CanClose := True;
end;

procedure TScreenShootForm.FormCreate(Sender : TObject);
begin
  Width := Screen.Width;
  Height := Screen.Height;
  FSelectionTool := TBZSelectTool.Create;
  FScreenShooted := False;
  Visible := False;
  DMMain.ScreenShotBitmap := TBZBitmap.Create(Width, Height);
  FDisplayBuffer := TBZBitmap.Create(Width, Height);

  pnlMagnifier.Top := 0;
  pnlMagnifier.Left :=  Self.Width - pnlMagnifier.Width;

  FMagnifierBitmap := TBZBitmap.Create(240,240);
  FMagnifierBuffer := TBZBitmap.Create(20,20);
end;

procedure TScreenShootForm.FormMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  FSelectionTool.DoSelectionMouseDownHandle(Sender, Button, Shift, x, y);
end;

procedure TScreenShootForm.FormMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
begin
  FSelectionTool.DoSelectionMouseMoveHandle(Sender, Shift, x, y);
  Invalidate;
end;

procedure TScreenShootForm.FormMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  FSelectionTool.DoSelectionMouseUpHandle(Sender, Button, Shift, x, y);
  Invalidate;
end;

procedure TScreenShootForm.pnlMagnifierViewPaint(Sender : TObject);
begin
 FMagnifierBitmap.DrawToCanvas(pnlMagnifierView.Canvas, pnlMagnifierView.ClientRect);
end;

procedure TScreenShootForm.SwapMagnifier;
begin
   if pnlMagnifier.Top = 0 then
  begin
    pnlMagnifier.Top := Self.Height - pnlMagnifier.Height;
    //pnlMagnifier.Left :=  Self.Width - pnlMagnifier.Width;
  end
  else
  begin
    pnlMagnifier.Top := 0;
    //pnlMagnifier.Left := 0;
  end;
end;

end.

