unit uInfosFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls, Buttons;

type

  { TInfosFrame }

  TInfosFrame = class(TFrame)
    pnlTitleBar : TPanel;
    lblTitle : TLabel;
    ImageList1 : TImageList;
    btnToggleFrame : TSpeedButton;
    procedure btnToggleFrameClick(Sender : TObject);
  private
    FExpanded : Boolean;
  public
    property Expanded : Boolean read FExpanded write FExpanded default True;
  end;

  function CreateInfosFrame(TheOwner :  TComponent; Title : String; Const ExpandedState : Boolean = true) : TFrame;

implementation

function CreateInfosFrame(TheOwner : TComponent; Title : String; Const ExpandedState : Boolean) : TFrame;
Var
  Frame : TInfosFrame;
begin
  Frame := TInfosFrame.Create(TheOwner);
  Frame.lblTitle.Caption := Title;
  Frame.Expanded := ExpandedState;
  Result := Frame;
end;

{$R *.lfm}

{ TInfosFrame }

procedure TInfosFrame.btnToggleFrameClick(Sender : TObject);
begin
  if FExpanded then
  begin
    btnToggleFrame.ImageIndex := 31;
    Self.Height := pnlTitleBar.Height + 1;
  end
  else
  begin
    btnToggleFrame.ImageIndex := 32;
    Self.Height := pnlTitleBar.Height + 1;
  end;

end;

end.

