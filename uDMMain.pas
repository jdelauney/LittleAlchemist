unit uDMMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls,
  BZColors, BZGraphic, BZBitmap;

type

  { TDMMain }

  TDMMain = class(TDataModule)
    ImageList : TImageList;
    procedure DataModuleCreate(Sender : TObject);
  private

  public
    DockFormCount : Byte;
    ScreenShotBitmap : TBZBitmap;
  end;

var
  DMMain : TDMMain;

implementation

{$R *.lfm}

{ TDMMain }

procedure TDMMain.DataModuleCreate(Sender : TObject);
begin
  DockFormCount := 0;
end;

end.

