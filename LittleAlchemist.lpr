program LittleAlchemist;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uMainForm, uResizeImageForm,
  uScreenShootForm, uScreenShootHelpForm, uDMMain, uExtendFilterExFrame, uConvolutionFilterFrame
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDMMain, DMMain);
  Application.Run;
end.

