unit uConvolutionFilterFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls, Spin, graphics,
  BZClasses, BZUtils, BZGraphic, BZBitmap;

type
  TAOS = Array of Single;
  TConvolutionFrame = class(TFrame)
    cbxMatrixSize : TComboBox;
    cbxMode : TComboBox;
    chkApplyBlue : TCheckBox;
    chkApplyGreen : TCheckBox;
    chkApplyRed : TCheckBox;
    fseDivisor : TFloatSpinEdit;
    GroupBox3 : TGroupBox;
    imgTitleFilterGlyph : TImage;
    Label2 : TLabel;
    Label3 : TLabel;
    Label4 : TLabel;
    Label5 : TLabel;
    Label6 : TLabel;
    lblTitleFrame : TLabel;
    lbxConvolutionFilters : TListBox;
    Panel1 : TPanel;
    Panel5 : TPanel;
    Panel6 : TPanel;
    Panel7 : TPanel;
    Panel9 : TPanel;
    pnlMatRow1 : TPanel;
    pnlMatRow2 : TPanel;
    pnlMatRow3 : TPanel;
    pnlMatRow4 : TPanel;
    pnlMatRow5 : TPanel;
    pnlMatRow6 : TPanel;
    pnlMatRow7 : TPanel;
    pnlTitle : TPanel;
    speBias : TSpinEdit;
    speMatrixShift : TSpinEdit;

    procedure cbxMatrixSizeChange(Sender : TObject);
    procedure lbxConvolutionFiltersSelectionChange(Sender : TObject; User : boolean);
    procedure DoParamChange(Sender : TObject);
  private
    FEditMatrix : Array[0..6,0..6] of TFloatSpinEdit;
    FConvMatrix :  TAOS;
    FOnParamChange : TNotifyEvent;
    function GetIconGlyph : TBitmap;
    procedure SetIconGlyph(AValue : TBitmap);

  protected

  public
    Constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure GetConvolutionMatrix(var Matrix :  TAOS);
    function GetMatrixSize : Byte;
    function GetDivisor : Single;
    function GetBias : Byte;
    function GetApplyRed : Boolean;
    function GetApplyGreen : Boolean;
    function GetApplyBLue : Boolean;
    function GetMode : TBZConvolutionFilterMode;


    property OnParamChange : TNotifyEvent read FOnParamChange write FOnParamChange;
    property IconGlyph : TBitmap read GetIconGlyph write SetIconGlyph;
  end;

implementation

{$R *.lfm}

{ TConvolutionFrame }

constructor TConvolutionFrame.Create(AOwner : TComponent);
var
  i,j : Integer;
begin
  inherited Create(AOwner);
  For j := 0 to 6 do
  begin
    for i := 0 to 6 do
    begin
      FEditMatrix[i,j] := TFloatSpinEdit.Create(Self);
      With FEditMatrix[i,j] do
      begin
        Case j of
          0 : Parent := pnlMatRow1;
          1 : Parent := pnlMatRow2;
          2 : Parent := pnlMatRow3;
          3 : Parent := pnlMatRow4;
          4 : Parent := pnlMatRow5;
          5 : Parent := pnlMatRow6;
          6 : Parent := pnlMatRow7;
        end;
        Width := 48;
        Name := 'speMatrix'+i.ToString+'_'+j.ToString;
        Hint := 'speMatrix'+i.ToString+'_'+j.ToString;
        ParentShowHint := False;
        ShowHint := True;
        MinValue := -500;
        MaxValue := 500;
        Value := 0;
        Enabled := False;
        ReadOnly := True;
        DecimalPlaces := 1;
        TabOrder := i;
        Align := alRight;
      end;
    end;
  end;

  For j:= 0 to high(BZConvolutionFilterPresets) do
  begin
    lbxConvolutionFilters.Items.Add(BZConvolutionFilterPresets[j].Name);
  end;
  lbxConvolutionFilters.Items.Add('Personnalisé');

end;

destructor TConvolutionFrame.Destroy;
var
  i,j : Integer;
begin
  For j := 0 to 6 do
  begin
    for i := 0 to 6 do
    begin
      FreeAndNil(FEditMatrix[j,i]);
    end;
  end;
  inherited Destroy;
end;


procedure TConvolutionFrame.GetConvolutionMatrix(var Matrix :  TAOS);
Var
  i, j, MatrixSize : Integer;
begin

  i := lbxConvolutionFilters.ItemIndex;

  if (i <= high(BZConvolutionFilterPresets)) then
  begin
    MatrixSize := BZConvolutionFilterPresets[i].MatrixSize;
    SetLength(FConvMatrix, MatrixSize * MatrixSize);
    Case MatrixSize of
      3: FConvMatrix := BZConvolutionFilterPresets[i].Matrix._3;
      5: FConvMatrix := BZConvolutionFilterPresets[i].Matrix._5;
      7: FConvMatrix := BZConvolutionFilterPresets[i].Matrix._7;
    end;
    if speMatrixShift.Value <>0 then
    begin
      if speMatrixShift.Value < 0 then CircularShiftLeftArray(FConvMatrix,MatrixSize,abs(speMatrixShift.Value))
      else CircularShiftRightArray(FConvMatrix,MatrixSize,speMatrixShift.Value);
    end;
  end
  else
  begin
    MatrixSize := 3;
    Case cbxMatrixSize.ItemIndex of
      0 :
      begin
        SetLength(FConvMatrix,9);
        MatrixSize := 3;
        for j := 2 to 4 do
        begin
          for i := 2 to 4 do
          begin
            FConvMatrix[((j-2)* 3) + (i-2) ] := FEditMatrix[i,j].Value;
          end;
        end;
      end;
      1 :
      begin
        SetLength(FConvMatrix,25);
        MatrixSize := 5;
        for j := 1 to 5 do
        begin
          for i := 1 to 5 do
          begin
            FConvMatrix[((j-1) * 5) + (i-1)] := FEditMatrix[i,j].Value;
          end;
        end;
      end;
      2 :
      begin
        SetLength(FConvMatrix,49);
        MatrixSize := 7;
        for j := 0 to 6 do
        begin
          for i := 0 to 6 do
          begin
            FConvMatrix[ (j * 7) + i] := FEditMatrix[i,j].Value;
          end;
        end;
      end;
    end;
        if speMatrixShift.Value <>0 then
    begin
      if speMatrixShift.Value < 0 then CircularShiftLeftArray(FConvMatrix,MatrixSize,abs(speMatrixShift.Value))
      else CircularShiftRightArray(FConvMatrix,MatrixSize,speMatrixShift.Value);
    end;
  end;

  Matrix := FConvMatrix;
end;

function TConvolutionFrame.GetMatrixSize : Byte;
begin
  Case cbxMatrixSize.ItemIndex of
    0 : Result :=3;
    1 : Result :=5;
    2 : Result :=7;
  end;
end;

function TConvolutionFrame.GetDivisor : Single;
begin
  result := fseDivisor.Value;
end;

function TConvolutionFrame.GetBias : Byte;
begin
  result := speBias.Value;
end;

function TConvolutionFrame.GetApplyRed : Boolean;
begin
  result := chkApplyRed.Checked;
end;

function TConvolutionFrame.GetApplyGreen : Boolean;
begin
  result := chkApplyGreen.Checked;
end;

function TConvolutionFrame.GetApplyBLue : Boolean;
begin
  result := chkApplyBlue.Checked;
end;

function TConvolutionFrame.GetMode : TBZConvolutionFilterMode;
begin
  Result := TBZConvolutionFilterMode(cbxMode.ItemIndex);
end;

procedure TConvolutionFrame.lbxConvolutionFiltersSelectionChange(Sender : TObject; User : boolean);
Var
  i,j,k, start : Integer;
begin
  k := lbxConvolutionFilters.ItemIndex;
  for j := 0 to 6 do
  begin
    for i := 0 to 6 do
    begin
      if k > high(BZConvolutionFilterPresets) then
      begin
        FEditMatrix[i,j].ReadOnly := False;
        FEditMatrix[i,j].Enabled := False;
        FEditMatrix[i,j].Value := 0;
        cbxMatrixSize.Enabled := True;
        cbxMatrixSize.ItemIndex := 0;
        cbxMatrixSizeChange(Self);
      end
      else
      begin
        FEditMatrix[i,j].ReadOnly := True;
        FEditMatrix[i,j].Enabled := False;
        cbxMatrixSize.Enabled := False;
      end;
    end;
  end;

  if k <= high(BZConvolutionFilterPresets) then
  begin
    Case BZConvolutionFilterPresets[k].MatrixType of
      mct3x3 :
      begin
        cbxMatrixSize.ItemIndex := 0;
        start := 2;
        for j := Start to 6-Start do
        begin
          for i := Start to 6-Start do
          begin
            FEditMatrix[i,j].Value := BZConvolutionFilterPresets[k].Matrix._3[ ((i-Start) * 3) + (j-Start) ];
            FEditMatrix[i,j].Enabled := True;
          end;
        end;
      end;
      mct5x5 :
      begin
        cbxMatrixSize.ItemIndex := 1;
        start := 1;
        for j := Start to 6-Start do
        begin
          for i := Start to 6-Start do
          begin
            FEditMatrix[i,j].Value := BZConvolutionFilterPresets[k].Matrix._5[ ((j-Start) * 5) + (i-Start) ];
            FEditMatrix[i,j].Enabled := True;
          end;
        end;
      end;
      mct7x7 :
      begin
        cbxMatrixSize.ItemIndex := 2;
        start := 0;
        for j := Start to 6-Start do
        begin
          for i := Start to 6-Start do
          begin
            FEditMatrix[i,j].Value := BZConvolutionFilterPresets[k].Matrix._7[ (j-Start) * 7 + (i-Start) * 3 ];
            FEditMatrix[i,j].Enabled := True;
          end;
        end;
      end;
    end;
    fseDivisor.Value := BZConvolutionFilterPresets[k].Divisor;
    speBias.Value := BZConvolutionFilterPresets[k].Bias;
  end;
  DoParamChange(self);
end;

procedure TConvolutionFrame.cbxMatrixSizeChange(Sender : TObject);
var
  i,j : Integer;
  Start : Integer;
begin
  if cbxMatrixSize.Enabled then
  begin
    if cbxMatrixSize.ItemIndex = 2 then
    begin
      for j := 0 to 6 do
      begin
        for i := 0 to 6 do
        begin
          FEditMatrix[j,i].ReadOnly := False;
          FEditMatrix[j,i].Enabled := True;
        end;
      end;
    end
    else
    begin
      if cbxMatrixSize.ItemIndex = 1 then start := 1 else Start := 2;
      for j := 0 to 6 do
      begin
        for i := 0 to 6 do
        begin
          FEditMatrix[j,i].ReadOnly := False;
          FEditMatrix[j,i].Enabled := (((j>=Start) and (j<=6-start)) and ((i>=Start) and (i<=6-start)));
        end;
      end;
    end;
  end;
end;

function TConvolutionFrame.GetIconGlyph : TBitmap;
begin
  result := imgTitleFilterGlyph.Picture.Bitmap;
end;

procedure TConvolutionFrame.SetIconGlyph(AValue : TBitmap);
begin
  imgTitleFilterGlyph.Picture.Bitmap.Assign(AValue);
end;

procedure TConvolutionFrame.DoParamChange(Sender : TObject);
begin
  if Assigned(FOnParamChange) then FOnParamChange(sender);
end;



end.

