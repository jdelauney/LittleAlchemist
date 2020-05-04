unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Types, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Menus, ComCtrls, ActnList, StdCtrls, ShellCtrls, ExtDlgs, Buttons,
  XMLPropStorage, LazFileUtils, uDMMain,
  BZClasses, // Unité de base pour les objets
  BZMath, BZColors, BZGraphic, BZBitmap, BZBitmapIO, BZImageViewer,  // Unités principales pour la gestion des bitmaps
  BZBitmapColorFilters, BZBitmapDeformationFilters;

type

  { TMainForm }
  TAutoFitMode = (afmManual, afmFitAll, afmFitOnlyBigger, afmFitOnlySmaller );
  TViewLayout =(vlSingle, vlSplit, vlDual);
  TFrameSettingType = (fstCommonFilter, fstCommonFilterEx, fstCommonFilterBlur, fstMotionFilterBlur);

  TMainForm = class(TForm)
    pnlStatus : TPanel;
    MainMenu : TMainMenu;
    mnuFile : TMenuItem;
    pnlExplorer : TPanel;
    cbMainMenu : TCoolBar;
    sptMainLeft : TSplitter;
    pnlMain : TPanel;
    pnlSettingsTool : TPanel;
    pnlViewContainer : TPanel;
    ActionList : TActionList;
    pnlAddons : TPanel;
    sbScrollH : TScrollBar;
    sbScrollV : TScrollBar;
    ShellTreeView : TShellTreeView;
    Splitter1 : TSplitter;
    ShellListView : TShellListView;
    ImageListTV : TImageList;
    ImageListLV : TImageList;
    pnlImageProgress : TPanel;
    lblImageProgress : TLabel;
    pbImageProgress : TProgressBar;
    pnlMainStatus : TPanel;
    tbFile : TToolBar;
    actFileOpen : TAction;
    mniFileOpen : TMenuItem;
    tbtnFileOpen : TToolButton;
    OPD : TOpenPictureDialog;
    pnlImageView : TPanel;
    ImageView : TBZImageViewer;
    actFileSave : TAction;
    actAppExit : TAction;
    mniSave : TMenuItem;
    N1 : TMenuItem;
    mniAppExit : TMenuItem;
    tbtnSave : TToolButton;
    SPD : TSavePictureDialog;
    actViewExplorer : TAction;
    actViewInformations : TAction;
    actOriginalSize : TAction;
    actBestFit : TAction;
    actStretch : TAction;
    actCenter : TAction;
    actAutoFit : TAction;
    actZoomIn : TAction;
    actZoomOut : TAction;
    actShowZoomGrid : TAction;
    mnuView : TMenuItem;
    mniShowExplorer : TMenuItem;
    mniViewImageInformations : TMenuItem;
    mnuOptions : TMenuItem;
    mniDisplay : TMenuItem;
    mniAutoFit : TMenuItem;
    mniProportionalStretch : TMenuItem;
    mniFullScreen : TMenuItem;
    mniOriginalSize : TMenuItem;
    N2 : TMenuItem;
    MenuItem1 : TMenuItem;
    mniZoom : TMenuItem;
    mniZoomIn : TMenuItem;
    mniZoomOut : TMenuItem;
    N3 : TMenuItem;
    MenuItem3 : TMenuItem;
    N4 : TMenuItem;
    mniZoom5 : TMenuItem;
    mniZoom10 : TMenuItem;
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
    ToolButton1 : TToolButton;
    ToolButton2 : TToolButton;
    tbViewSettings : TToolBar;
    tbtnAutoFit : TToolButton;
    ToolButton5 : TToolButton;
    ToolButton6 : TToolButton;
    ToolButton7 : TToolButton;
    ToolButton8 : TToolButton;
    ToolButton9 : TToolButton;
    ToolButton10 : TToolButton;
    ToolButton11 : TToolButton;
    actDrawWithTransparency : TAction;
    MenuItem17 : TMenuItem;
    ToolButton12 : TToolButton;
    ToolButton13 : TToolButton;
    ppmAutoFit : TPopupMenu;
    mniAutoFitOnlyBig : TMenuItem;
    mniAutoFitOnlySmall : TMenuItem;
    mniAutoFitBoth : TMenuItem;
    lblFilename : TLabel;
    tbTools : TToolBar;
    ToolButton18 : TToolButton;
    actColorPicker : TAction;
    ToolButton19 : TToolButton;
    actResize : TAction;
    ToolButton20 : TToolButton;
    actScreenShot : TAction;
    ppmScreenShot : TPopupMenu;
    MenuItem2 : TMenuItem;
    MenuItem18 : TMenuItem;
    sbAddons : TScrollBox;
    cbxtbZoom : TComboBox;
    DockFormWatcherTimer : TTimer;
    actHistogram : TAction;
    ppmColorFilters : TPopupMenu;
    actAdjustLuminosity : TAction;
    actAdjustContrast : TAction;
    MenuItem19 : TMenuItem;
    MenuItem20 : TMenuItem;
    ToolButton3 : TToolButton;
    tbFilters : TToolBar;
    ToolButton4 : TToolButton;
    Panel1 : TPanel;
    btnApplyFilter : TBitBtn;
    btnCloseFilters : TBitBtn;
    actAdjustSaturation : TAction;
    actAdjustExposure : TAction;
    MenuItem21 : TMenuItem;
    MenuItem22 : TMenuItem;
    actAdjustRGB : TAction;
    MenuItem23 : TMenuItem;
    MenuItem24 : TMenuItem;
    MenuItem25 : TMenuItem;
    MenuItem26 : TMenuItem;
    actAdjustGain : TAction;
    actAdjustGamma : TAction;
    actNegate : TAction;
    actPosterize : TAction;
    actSolarize : TAction;
    actNegateValue : TAction;
    MenuItem27 : TMenuItem;
    N5 : TMenuItem;
    MenuItem28 : TMenuItem;
    MenuItem29 : TMenuItem;
    MenuItem30 : TMenuItem;
    MenuItem31 : TMenuItem;
    N6 : TMenuItem;
    N7 : TMenuItem;
    actDesaturate : TAction;
    actThreshold : TAction;
    MenuItem32 : TMenuItem;
    MenuItem33 : TMenuItem;
    MenuItem34 : TMenuItem;
    ToolButton14 : TToolButton;
    ppmFilters : TPopupMenu;
    MenuItem35 : TMenuItem;
    MenuItem36 : TMenuItem;
    N8 : TMenuItem;
    MenuItem37 : TMenuItem;
    MenuItem38 : TMenuItem;
    MenuItem39 : TMenuItem;
    N9 : TMenuItem;
    MenuItem41 : TMenuItem;
    N10 : TMenuItem;
    MenuItem40 : TMenuItem;
    actBlurLinear : TAction;
    actPinchAndTwirl : TAction;
    MenuItem42 : TMenuItem;
    actTwirl : TAction;
    MenuItem43 : TMenuItem;
    actFishEye : TAction;
    MenuItem44 : TMenuItem;
    actOndulation : TAction;
    MenuItem45 : TMenuItem;
    actWaterRipple : TAction;
    MenuItem46 : TMenuItem;
    actDiffusion : TAction;
    MenuItem47 : TMenuItem;
    actPolar : TAction;
    MenuItem48 : TMenuItem;
    actBoxBlur : TAction;
    MenuItem49 : TMenuItem;
    actGaussianBlur : TAction;
    MenuItem50 : TMenuItem;
    actRadialZoomBlur : TAction;
    actZoomBlur : TAction;
    actSplitBlur : TAction;
    actThresholdBlur : TAction;
    MenuItem51 : TMenuItem;
    MenuItem52 : TMenuItem;
    MenuItem53 : TMenuItem;
    MenuItem54 : TMenuItem;
    actMotionBlur : TAction;
    MenuItem55 : TMenuItem;
    actColorBalance : TAction;
    MenuItem56 : TMenuItem;
    actAdjustHSV : TAction;
    MenuItem57 : TMenuItem;
    actInstagramFilter : TAction;
    MenuItem59 : TMenuItem;
    Panel2 : TPanel;
    Edit1 : TEdit;
    Label1 : TLabel;
    Button1 : TButton;
    actSepia : TAction;
    MenuItem58 : TMenuItem;
    actHueRotate : TAction;
    MenuItem60 : TMenuItem;
    ToolButton15 : TToolButton;

    procedure FormDropFiles(Sender : TObject; const FileNames : Array of String);
    procedure ShellTreeViewGetImageIndex(Sender : TObject; Node : TTreeNode);
    procedure ShellListViewColumnClick(Sender : TObject; Column : TListColumn);
    procedure ShellListViewFileAdded(Sender : TObject; Item : TListItem);
    procedure ShellListViewSelectItem(Sender : TObject; Item : TListItem; Selected : Boolean);
    procedure ShellTreeViewGetSelectedIndex(Sender : TObject; Node : TTreeNode);
    procedure FormCreate(Sender : TObject);
    procedure FormShow(Sender : TObject);
    procedure actFileOpenExecute(Sender : TObject);
    procedure sbScrollVChange(Sender : TObject);
    procedure sbScrollHChange(Sender : TObject);
    procedure ImageViewResize(Sender : TObject);
    procedure actAppExitExecute(Sender : TObject);
    procedure actFileSaveExecute(Sender : TObject);
    procedure actViewExplorerExecute(Sender : TObject);
    procedure actDrawWithTransparencyExecute(Sender : TObject);
    procedure actCenterExecute(Sender : TObject);
    procedure actOriginalSizeExecute(Sender : TObject);
    procedure actBestFitExecute(Sender : TObject);
    procedure actStretchExecute(Sender : TObject);
    procedure actShowZoomGridExecute(Sender : TObject);
    procedure actAutoFitExecute(Sender : TObject);
    procedure mniAutoFitBothClick(Sender : TObject);
    procedure ImageViewMouseWheelDown(Sender : TObject; Shift : TShiftState; MousePos : TPoint; var Handled : Boolean);
    procedure ImageViewMouseWheelUp(Sender : TObject; Shift : TShiftState; MousePos : TPoint; var Handled : Boolean);
    procedure actZoomInExecute(Sender : TObject);
    procedure actZoomOutExecute(Sender : TObject);
    procedure ChooseZoomPercent(Sender : TObject);
    procedure ImageViewMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure ImageViewMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
    procedure ImageViewMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure actColorPickerExecute(Sender : TObject);
    procedure actResizeExecute(Sender : TObject);
    procedure sbAddonsDockOver(Sender : TObject; Source : TDragDockObject; X, Y : Integer; State : TDragState; var Accept : Boolean);
    procedure sbAddonsDockDrop(Sender : TObject; Source : TDragDockObject; X, Y : Integer);
    procedure sbAddonsUnDock(Sender : TObject; Client : TControl; NewTarget : TWinControl; var Allow : Boolean);
    procedure DockFormWatcherTimerTimer(Sender : TObject);
    procedure actHistogramExecute(Sender : TObject);
    procedure actInitAndApplyFilterExecute(Sender : TObject);
    procedure actInitFilterExecute(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure btnCloseFiltersClick(Sender : TObject);
    procedure btnApplyFilterClick(Sender : TObject);
    procedure Button1Click(Sender : TObject);
    procedure actScreenShotExecute(Sender : TObject);

  private
    FImgSource, FImgResult : TBZBitmap;
    FInternalFrame : TFrame;
    FImageLoaded : Boolean;
    FTotalProgress : Byte;
    FCurrentFilter : Integer;
    FApplyFilter : Boolean;


    procedure InitFilterUI(Idx : Integer);
    procedure ApplyFilter(Idx : Integer);
    procedure HandleFilterChangeSettings(Sender : TObject);
    procedure UpdateViews;
    procedure UpdateHistogram;

  protected
    //DockingManager : TAnchorDockMaster;
    AutoFitMode : TAutoFitMode;
    { Facteur du zoom actuel de l'image }
    ZoomFactor : Integer;
    { Pour le control de la souris dans l'"ImageViewer" }
    FOffsetLeft, FOffsetTop, FLastOffsetTop, FLastOffsetLeft: Integer;
    FMoving : Boolean;
    LastMousePoint, MousePoint : TPoint;

    { Evenement lever en cas d'erreur de lecture ou d'ecriture de l'image }
    Procedure HandleOnBitmapLoadError(Sender: TObject; Const ErrorCount: Integer; Const ErrorList: TStringList);
    { Evenement pour afficher la progression du travail en cours sur l'image }
    Procedure HandleOnImageProgress(Sender: TObject; Stage: TBZProgressStage; PercentDone: Byte; RedrawNow: Boolean; Const R: TRect; Const Msg: String; Var aContinue: Boolean);

    { Controle du zoom de l'image }
    procedure HandleZoom(Const UpdateControls : Boolean);

    procedure HandleAutoFit(Const Mode : TAutoFitMode);

    { Mise à jour des informations sur l'image }
    procedure UpdateInformations;
    { Mise à jours des scrollbars pour le déplacement de l'image dans la fenêtre }
    procedure UpdateImageViewScrollBars(Const ResetPosition : Boolean  = False);
    { Afficher / cacher la barre de progression }
    procedure ShowHideImageProgress(Const IsShow : Boolean);
  public
    { Chargement des images }
    procedure LoadPicture(FileName : String; const Drag : Boolean = false);
    { Sauvegarde des images }
    procedure SavePicture(FileName : String);

  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

Uses
  BZUtils,
  BZImageFileBMP, BZImageFileTGA, BZImageFileJPEG, // Pour accéder aux options de sauvegarde
  //BZImageFilePNG, BZImageFileICO, etc...
  uErrorBoxForm, uColorPickerForm, uResizeImageForm,
  uCommonFilterExFrame, uDesaturateSettingFrame,
  uExtendFilterExFrame,
  uHistogramForm,
  uScreenShootForm,
  BZLogger,
  BZTypesHelpers;  // Assistants personnel pour les différents types de variable. /!\ A placer à la fin des "uses"

{ TMainForm }

Procedure TMainForm.HandleOnBitmapLoadError(Sender : TObject; Const ErrorCount : Integer; Const ErrorList : TStringList);
begin
  If ErrorCount > 0 then
  begin
    ErrorBoxForm.Memo1.Lines.Clear;
    ErrorBoxForm.Memo1.Lines := ErrorList;
    ErrorBoxForm.ShowModal;
  End;
end;

Procedure TMainForm.HandleOnImageProgress(Sender : TObject; Stage : TBZProgressStage; PercentDone : Byte; RedrawNow : Boolean; Const R : TRect; Const Msg : String; Var aContinue : Boolean);
begin
  Case Stage Of
    opsStarting:
    Begin
      lblImageProgress.Caption := Msg + ' - ' + IntToStr(PercentDone) + '%';
      pbImageProgress.Position := PercentDone;
      Application.ProcessMessages;
    End;
    opsRunning:
    Begin
      lblImageProgress.Caption := Msg + ' - ' + IntToStr(PercentDone) + '%';
      pbImageProgress.Position := PercentDone;
      // if (PercentDone mod 10)=0 then begin ImageView.Invalidate;end;   // Affichage progressif
      Application.ProcessMessages;
      //if RedrawNow then Application.ProcessMessages;
    End;
    opsEnding:
    Begin
      lblImageProgress.Caption := '';
      pbImageProgress.Position := 0;
      //Application.ProcessMessages;
    End;
  End;
end;

procedure TMainForm.FormCreate(Sender : TObject);
Var
  aCol : TListColumn;
Begin
  ShellListView.Mask := GetBZImageFileFormats.BuildFileFilterMask;
  aCol := ShellListView.Columns.Add;
  aCol.Caption := 'Date';
  aCol.AutoSize := true;
  ZoomFactor := 100;
  pnlImageProgress.Align := alClient;
  pnlImageProgress.Visible := false;
  pnlMainStatus.Align := alClient;
  AutoFitMode := afmFitAll;
  FMoving := False;
  FImageLoaded := False;
  //FFrameAddonsCount := 0;
  sbAddons.UseDockManager := True;
  FImgResult := TBZBitmap.Create;
  FImgSource := TBZBitmap.Create;
  FImgSource.OnProgress := @HandleOnImageProgress;
end;

procedure TMainForm.FormDestroy(Sender : TObject);
begin
  FreeAndNil(FImgSource);
  FreeAndNil(FImgResult);
  if Assigned(FInternalFrame) then
  begin
    FreeAndNil(FInternalFrame);
  end;
end;

procedure TMainForm.btnCloseFiltersClick(Sender : TObject);
begin
  pnlSettingsTool.Visible := False;
  FImgResult.FastCopy(FImgSource);
  UpdateViews;
  UpdateHistogram;
end;

procedure TMainForm.btnApplyFilterClick(Sender : TObject);
begin
  pnlSettingsTool.Visible := False;
  FImgSource.FastCopy(FImgResult);
  //UpdateViews;
  //UpdateHistogram;
end;

procedure TMainForm.Button1Click(Sender : TObject);
Var
  OutColor : TBZColor;
begin
  OutColor.Create(Edit1.Text);
  Label1.Caption := OutColor.ToString;
end;

procedure TMainForm.actScreenShotExecute(Sender : TObject);
begin

  ScreenShootForm := TScreenShootForm.Create(Self);
  Visible := False;

  Sleep(500); // Besoin d'une petite pause le temps que la fenêtre se ferme

  DMMain.ScreenShotBitmap.TakeDesktopScreenShot;
  if ScreenShootForm.ShowModal = mrOk then
  begin
    Visible := True;
    ImageView.Picture.Bitmap.Assign(DMMain.ScreenShotBitmap);
    ImageView.Invalidate;
  end;

  FreeAndNil(DMMain.ScreenShotBitmap);
  FreeAndNil(ScreenShootForm);
end;

procedure TMainForm.FormShow(Sender : TObject);
begin
  With ImageView Do
  Begin
    //Color := clBlack;

    // Pour forcer l'affichage dans l'imageviewer
    Picture.Bitmap.SetSize(1,1); //pnlImageView.ClientWidth-2, pnlImageView.ClientHeight-2);
    Picture.Bitmap.Clear(clrSilver);

    Picture.Bitmap.OnProgress := @HandleOnImageProgress;
    Picture.Bitmap.OnLoadError := @HandleOnBitmapLoadError;
    // Picture.Bitmap.OnChange := @HandleOnBitmapChange;
    // Picture.Bitmap.OnFrameChanged := @HandleOnFrameChanged;
  End;
  //pnlDocker.Height := sbAddons.ClientHeight;
  Self.Constraints.MaxHeight := 0;
  Self.Constraints.MaxWidth := 0;
end;

procedure TMainForm.InitFilterUI(Idx : Integer);
Var
  bmp : TBitmap;
  sl : TStringList;
begin
  if Assigned(FInternalFrame) then
  begin
    FreeAndNil(FInternalFrame);
  end;
  Case Idx of
    0 :  // Ajustement du Contraste
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(38, Bmp);
      pnlSettingsTool.Height := 180;
      FInternalFrame := CreateCommonFilterExFrame(pnlSettingsTool,'Ajuster le contraste',bmp,True,true,true, true, false, true,'Facteur : ','','','','','','', @HandleFilterChangeSettings);
      pnlSettingsTool.Height := 35 + FInternalFrame.Constraints.MaxHeight;
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;
    1 :  // Ajustement de la luminositée
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(39, Bmp);
      pnlSettingsTool.Height := 180;
      FInternalFrame := CreateCommonFilterExFrame(pnlSettingsTool,'Ajuster la luminosité',bmp,True,true,true, true, false, false,'Facteur : ','','','','','','', @HandleFilterChangeSettings);
      pnlSettingsTool.Height := 35 + FInternalFrame.Constraints.MaxHeight;
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;
    2 : // Ajustement de la Saturation
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(40, Bmp);
      pnlSettingsTool.Height := 180;
      FInternalFrame := CreateCommonFilterExFrame(pnlSettingsTool,'Ajuster la saturation',bmp,True,true,true, true, false, true,'Facteur : ','','','','','','Limiter la luminosité', @HandleFilterChangeSettings);
      pnlSettingsTool.Height := 35 + FInternalFrame.Constraints.MaxHeight;
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;
    3 : // Ajustement de l'exposition
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(41, Bmp);
      pnlSettingsTool.Height := 180;
      FInternalFrame := CreateCommonFilterExFrame(pnlSettingsTool,'Ajuster l''exposition',bmp,True,true,true, true, false, true, 'Facteur : ','','','','','','', @HandleFilterChangeSettings);
      pnlSettingsTool.Height := 35 + FInternalFrame.Constraints.MaxHeight;
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;
    4 : // Gain
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(42, Bmp);
      FInternalFrame := CreateCommonFilterExFrame(pnlSettingsTool,'Gain et polarisation',bmp,True,true,true, true, false, true, 'Gain : ','Bias : ','','','','','', @HandleFilterChangeSettings);
      pnlSettingsTool.Height := 35 + FInternalFrame.Constraints.MaxHeight;
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;
    5 : // Correction gamma
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(43, Bmp);
      FInternalFrame := CreateCommonFilterExFrame(pnlSettingsTool,'Correction gamma',bmp,True,true,true, true, false, true, 'Facteur : ','','','','','','', @HandleFilterChangeSettings);
      pnlSettingsTool.Height := 35 + FInternalFrame.Constraints.MaxHeight;
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;
    6 : // Inverser (Negate)
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(44, Bmp);
      FInternalFrame := CreateCommonFilterExFrame(pnlSettingsTool,'Inversion des couleurs',bmp,True,true,true, true, false, true,'','','','','','','', @HandleFilterChangeSettings);
      pnlSettingsTool.Height := 35 + FInternalFrame.Constraints.MaxHeight;
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;
    //7 : // Inverser valeurs(Negate Value)
    //begin
    //  bmp := TBitmap.Create;
    //  DMMain.ImageList.GetBitmap(44, Bmp);
    //  FInternalFrame := CreateCommonFilterExFrame(pnlSettingsTool,'Inversion des couleurs',bmp,True,true,true, true, false, true,'','','','','','','', @HandleFilterChangeSettings);
    //  FInternalFrame.Parent := pnlSettingsTool;
    //  FInternalFrame.Align := alClient;
    //  Bmp.Free;
    //end;
    8 : // Posterisation
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(46, Bmp);
      FInternalFrame := CreateCommonFilterExFrame(pnlSettingsTool,'Postérisation',bmp,True,true,true, true, false, true, 'Facteur : ','','','','','','', @HandleFilterChangeSettings);
      pnlSettingsTool.Height := 35 + FInternalFrame.Constraints.MaxHeight;
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;
    9 : // Solarisation
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(47, Bmp);
      FInternalFrame := CreateCommonFilterExFrame(pnlSettingsTool,'Solarisation',bmp,True,true,true, true, false, true, 'Facteur : ','','','','','','', @HandleFilterChangeSettings);
      pnlSettingsTool.Height := 35 + FInternalFrame.Constraints.MaxHeight;
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;
    10 : // Desaturation
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(48, Bmp);
      FInternalFrame := CreateDesaturateSettingFrame(pnlSettingsTool,'Désaturation', bmp, @HandleFilterChangeSettings);
      pnlSettingsTool.Height := 35 + FInternalFrame.Constraints.MaxHeight;
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;

    22 : // Ajustement RGB
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(43, Bmp);
      FInternalFrame := CreateCommonFilterExFrame(pnlSettingsTool,'Ajustement des couleurs',bmp,True,true,true, true, false, true,'Rouge', 'Vert', 'Bleu','','','','', @HandleFilterChangeSettings);
      pnlSettingsTool.Height := 35 + FInternalFrame.Constraints.MaxHeight;
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;

    23 : // Balance des couleurs
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(70, Bmp);
      FInternalFrame := CreateCommonFilterExFrame(pnlSettingsTool,'Balance des couleurs',bmp,True,true,true, true, false, true,'Cyan -> Rouge', 'Magenta -> Vert', 'Jaune -> Bleu','','','','', @HandleFilterChangeSettings);
      //TExtendFilterExFrame(FInternalFrame).SetRangeParam1(-100,100,100);
      //TExtendFilterExFrame(FInternalFrame).SetRangeParam2(-100,100,100);
      //TExtendFilterExFrame(FInternalFrame).SetRangeParam3(-100,100,100);
      pnlSettingsTool.Height := 35 + FInternalFrame.Constraints.MaxHeight;
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;

    24 : // Balance des couleurs
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(71, Bmp);
      FInternalFrame := CreateCommonFilterExFrame(pnlSettingsTool,'Ajustement Teinte Saturation Valeur',bmp,True,true,true, true, false, false,'Teinte', 'Saturation', 'Valeur','','','','', @HandleFilterChangeSettings);
      pnlSettingsTool.Height := 35 + FInternalFrame.Constraints.MaxHeight;
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;

    25 : // Filtre Instagram
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(72, Bmp);
      FInternalFrame := CreateExtendFilterExFrame(pnlSettingsTool,'Filtre Instagram',bmp,False,'Mode', '', '', '', '',FImgResult.MaxWidth, FImgResult.MaxHeight, @HandleFilterChangeSettings, False);
      sl := TStringList.Create;

      sl.Add('1977');
      sl.Add('Aden');
      sl.Add('Amaro');
      sl.Add('Antique');
      sl.Add('Black and white');
      sl.Add('Brannan');
      sl.Add('Brooklyn');
      sl.Add('Clarendon');
      sl.Add('Dream');
      sl.Add('Easy bird');
      sl.Add('Ever glow');
      sl.Add('Fresh aqua');
      sl.Add('Forest');
      sl.Add('Gingham');
      sl.Add('Hudson');
      sl.Add('Inkwell');
      sl.Add('Juno');
      sl.Add('Kelvin');
      sl.Add('Lark');
      sl.Add('Light');
      sl.Add('Lime');
      sl.Add('Lofi');
      sl.Add('Ludwig');
      sl.Add('Majesty');
      sl.Add('Maven');
      sl.Add('Mayfair');
      sl.Add('Moon');
      sl.Add('Nashville');
      sl.Add('Old photo');
      sl.Add('Peachy');
      sl.Add('Perpetua');
      sl.Add('Polaroid');
      sl.Add('Retro');
      sl.Add('Reyes');
      sl.Add('Rise');
      sl.Add('Slumber');
      sl.Add('Stinson');
      sl.Add('Toaster');
      sl.Add('Valencia');
      sl.Add('Vintage');
      sl.Add('Walden');
      sl.Add('Willow');
      sl.Add('XPro 2');
      TExtendFilterExFrame(FInternalFrame).SetParam0Items(sl,-1);
      FreeAndNil(sl);
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;

    26 : // Sepia
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(73, Bmp);
      FInternalFrame := CreateExtendFilterExFrame(pnlSettingsTool,'Sepia',bmp,False,'', 'Facteur', '', '', '',FImgResult.MaxWidth, FImgResult.MaxHeight, @HandleFilterChangeSettings, False);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam1(0,100,100);
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;

    27 : // Rotation teinte
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(74, Bmp);
      FInternalFrame := CreateExtendFilterExFrame(pnlSettingsTool,'Rotation de la teinte',bmp,False,'', 'Degré', '', '', '',FImgResult.MaxWidth, FImgResult.MaxHeight, @HandleFilterChangeSettings, False);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam1(-360,360,1);
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;

    30 : // Pincer et tournoyer
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(52, Bmp);
      FInternalFrame := CreateExtendFilterExFrame(pnlSettingsTool,'Pincer et tournoyer',bmp,True,'', 'Rayon', 'Angle', 'Pincement','',FImgResult.MaxWidth, FImgResult.MaxHeight, @HandleFilterChangeSettings);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam1(0,max(FImgResult.MaxWidth, FImgResult.MaxHeight),1);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam2(-360, 360,1);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam3(-200, 200,100);

      pnlSettingsTool.Height := 35 + FInternalFrame.Constraints.MaxHeight;
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;
    31 : // Tournoyer
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(53, Bmp);
      FInternalFrame := CreateExtendFilterExFrame(pnlSettingsTool,'Tournoyer',bmp,True,'', 'Rayon', 'Angle', '','',FImgResult.MaxWidth, FImgResult.MaxHeight, @HandleFilterChangeSettings);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam1(0,max(FImgResult.MaxWidth, FImgResult.MaxHeight),1);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam2(-720, 720,1);
      pnlSettingsTool.Height := 35 + FInternalFrame.Constraints.MaxHeight;
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;
    32 : // FishEye
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(54, Bmp);
      FInternalFrame := CreateExtendFilterExFrame(pnlSettingsTool,'Distortion de lentille',bmp,True,'', 'Rayon', 'Facteur', '','',FImgResult.MaxWidth, FImgResult.MaxHeight, @HandleFilterChangeSettings);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam1(0,max(FImgResult.MaxWidth, FImgResult.MaxHeight),1);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam2(-200, 200,1);
      pnlSettingsTool.Height := 35 + FInternalFrame.Constraints.MaxHeight;
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;

    33 : // Ondulation
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(56, Bmp);
      FInternalFrame := CreateExtendFilterExFrame(pnlSettingsTool,'Ondulation',bmp, False, 'Mode', 'Période X', 'Amplitude X', 'Période Y','Amplitude Y',FImgResult.MaxWidth, FImgResult.MaxHeight, @HandleFilterChangeSettings);
      sl := TStringList.Create;
      sl.Add('Sinuosidale');
      sl.Add('Carré');
      sl.Add('Dent de scie');
      sl.Add('Triangle');
      sl.Add('Aléatoire');
      TExtendFilterExFrame(FInternalFrame).SetParam0Items(sl,0);
      FreeAndNil(sl);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam1(1, 1000, 10);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam2(1, 1000, 10);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam3(1, 1000, 10);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam4(1, 1000, 10);

      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;
    34 : // Water Ripple
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(57, Bmp);
      FInternalFrame := CreateExtendFilterExFrame(pnlSettingsTool,'Ondulation d''eau',bmp,True,'', 'Rayon', 'Période', 'Amplitude','Phase',FImgResult.MaxWidth, FImgResult.MaxHeight, @HandleFilterChangeSettings);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam1(0,max(FImgResult.MaxWidth, FImgResult.MaxHeight),1);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam2(1, 1000, 10);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam3(1, 1000, 10);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam4(1, 1000, 10);      pnlSettingsTool.Height := 35 + FInternalFrame.Constraints.MaxHeight;
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;
    35 : // Diffusion
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(58, Bmp);
      FInternalFrame := CreateExtendFilterExFrame(pnlSettingsTool,'Eparpiller',bmp,False,'', 'Horizontal', 'Vertical', 'Distance mini', 'Distance maxi',FImgResult.MaxWidth, FImgResult.MaxHeight, @HandleFilterChangeSettings);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam1(1, 24, 1);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam2(1, 24, 1);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam3(-200, 200, 10);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam4(-200, 200, 10);
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;
    36 : // Transformation polaire
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(59, Bmp);
      FInternalFrame := CreateExtendFilterExFrame(pnlSettingsTool,'Transformation polaire',bmp,True,'Mode', '', '', '', '',FImgResult.MaxWidth, FImgResult.MaxHeight, @HandleFilterChangeSettings);
      sl := TStringList.Create;
      sl.Add('Cartésien vers polaire');
      sl.Add('Polaire vers cartésien');
      TExtendFilterExFrame(FInternalFrame).SetParam0Items(sl,0);
      FreeAndNil(sl);
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;

    41 : // Box blur
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(66, Bmp);
      FInternalFrame := CreateExtendFilterExFrame(pnlSettingsTool,'Adoucissement encadré',bmp,false,'', 'Rayon', '', '', '',FImgResult.MaxWidth, FImgResult.MaxHeight, @HandleFilterChangeSettings, False);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam1(1, 128, 1);
      pnlSettingsTool.Height := 30 + FInternalFrame.Constraints.MaxHeight;
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;
    42 : // Gaussian blur
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(60, Bmp);
      FInternalFrame := CreateExtendFilterExFrame(pnlSettingsTool,'Adoucissement Gaussien',bmp,false,'', 'Rayon', '', '', '',FImgResult.MaxWidth, FImgResult.MaxHeight, @HandleFilterChangeSettings, False);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam1(1, 128, 1);
      pnlSettingsTool.Height := 30 + FInternalFrame.Constraints.MaxHeight;
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;
    43 : // Radial blur
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(60, Bmp);
      FInternalFrame := CreateExtendFilterExFrame(pnlSettingsTool,'Adoucissement Radial',bmp,True,'', 'Rayon', '', '', '',FImgResult.MaxWidth, FImgResult.MaxHeight, @HandleFilterChangeSettings, False);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam1(1, 128, 1);
      pnlSettingsTool.Height := 30 + FInternalFrame.Constraints.MaxHeight;
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;
    44 : // Zoom blur
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(60, Bmp);
      FInternalFrame := CreateExtendFilterExFrame(pnlSettingsTool,'Adoucissement zoom',bmp,true,'', 'Rayon', '', '', '',FImgResult.MaxWidth, FImgResult.MaxHeight, @HandleFilterChangeSettings, False);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam1(1, 128, 1);
      pnlSettingsTool.Height := 30 + FInternalFrame.Constraints.MaxHeight;
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;
    45 : // Motion blur
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(60, Bmp);
      FInternalFrame := CreateExtendFilterExFrame(pnlSettingsTool,'Flou de mouvement',bmp,false,'', 'Rayon', 'Direction', 'Zoom', 'Rotation',FImgResult.MaxWidth, FImgResult.MaxHeight, @HandleFilterChangeSettings, False);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam1(-200, 200, 1);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam2(-360, 360, 1);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam3(1, 500, 100);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam4(-360, 360, 1);
      pnlSettingsTool.Height := 30 + FInternalFrame.Constraints.MaxHeight;
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;
    46 : // Split blur
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(60, Bmp);
      FInternalFrame := CreateExtendFilterExFrame(pnlSettingsTool,'Adoucissement découpé',bmp,false,'', 'Rayon', '', '', '',FImgResult.MaxWidth, FImgResult.MaxHeight, @HandleFilterChangeSettings, False);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam1(1, 128, 1);
      pnlSettingsTool.Height := 30 + FInternalFrame.Constraints.MaxHeight;
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;
    47 : // Threshold blur
    begin
      bmp := TBitmap.Create;
      DMMain.ImageList.GetBitmap(60, Bmp);
      FInternalFrame := CreateExtendFilterExFrame(pnlSettingsTool,'Adoucissement adaptatif',bmp,false,'', 'Rayon', 'Seuil', '', '',FImgResult.MaxWidth, FImgResult.MaxHeight, @HandleFilterChangeSettings, False);
      pnlSettingsTool.height := FInternalFrame.Constraints.MaxHeight + 4;
      TExtendFilterExFrame(FInternalFrame).SetRangeParam1(1, 128, 1);
      TExtendFilterExFrame(FInternalFrame).SetRangeParam2(1, 255, 1);
      pnlSettingsTool.Height := 30 + FInternalFrame.Constraints.MaxHeight;
      FInternalFrame.Parent := pnlSettingsTool;
      FInternalFrame.Align := alClient;
      Bmp.Free;
    end;

  end;
  pnlSettingsTool.Visible := True;
end;

procedure TMainForm.ApplyFilter(Idx : Integer);
Var
  FilterExFrame : TCommonFilterExFrame;
  DesaturateFrame : TDesaturateSettingFrame;
  ExtendFilterExFrame : TExtendFilterExFrame;

begin
  Screen.Cursor:= crHourGlass;
  FApplyFilter := True;
  ShowHideImageProgress(true);
  Case Idx of
    0 : // Contraste
    begin
      FilterExFrame := TCommonFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.ColorFilter.OnProgress := @HandleOnImageProgress;
      FImgResult.ColorFilter.AdjustContrast(FilterExFrame.GetParam1, FilterExFrame.PreserveLuminosity, FilterExFrame.ApplyOnShadowTone, FilterExFrame.ApplyOnMidTone, FilterExFrame.ApplyOnHighlightTone);
      UpdateViews;
      UpdateHistogram;
    end;
    1 : // Luminosité
    begin
      FilterExFrame := TCommonFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.ColorFilter.OnProgress := @HandleOnImageProgress;
      FImgResult.ColorFilter.AdjustBrightness(1.0+FilterExFrame.GetParam1, FilterExFrame.ApplyOnShadowTone, FilterExFrame.ApplyOnMidTone, FilterExFrame.ApplyOnHighlightTone);
      UpdateViews;
      UpdateHistogram;
    end;
    2 : // Saturation
    begin
      FilterExFrame := TCommonFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.ColorFilter.OnProgress := @HandleOnImageProgress;
      FImgResult.ColorFilter.AdjustSaturation(FilterExFrame.GetParam1, FilterExFrame.GetCheckParam, FilterExFrame.PreserveLuminosity, FilterExFrame.ApplyOnShadowTone, FilterExFrame.ApplyOnMidTone, FilterExFrame.ApplyOnHighlightTone);
      UpdateViews;
      UpdateHistogram;
    end;
    3 : // Exposition
    begin
      FilterExFrame := TCommonFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.ColorFilter.OnProgress := @HandleOnImageProgress;
      FImgResult.ColorFilter.AdjustExposure(1.0+FilterExFrame.GetParam1, FilterExFrame.PreserveLuminosity, FilterExFrame.ApplyOnShadowTone, FilterExFrame.ApplyOnMidTone, FilterExFrame.ApplyOnHighlightTone);
      UpdateViews;
      UpdateHistogram;
    end;
    4 : // Gain
    begin
      FilterExFrame := TCommonFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.ColorFilter.OnProgress := @HandleOnImageProgress;
      FImgResult.ColorFilter.AdjustGain(FilterExFrame.GetParam1, FilterExFrame.GetParam2, FilterExFrame.PreserveLuminosity, FilterExFrame.ApplyOnShadowTone, FilterExFrame.ApplyOnMidTone, FilterExFrame.ApplyOnHighlightTone);
      UpdateViews;
      UpdateHistogram;
    end;
    5 : // Correction gamma
    begin
      FilterExFrame := TCommonFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.ColorFilter.OnProgress := @HandleOnImageProgress;
      FImgResult.ColorFilter.GammaCorrection(1.0+FilterExFrame.GetParam1,FilterExFrame.PreserveLuminosity, FilterExFrame.ApplyOnShadowTone, FilterExFrame.ApplyOnMidTone, FilterExFrame.ApplyOnHighlightTone);
      UpdateViews;
      UpdateHistogram;
    end;
    6 : // Negate
    begin
      FilterExFrame := TCommonFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.ColorFilter.OnProgress := @HandleOnImageProgress;
      FImgResult.ColorFilter.Negate(FilterExFrame.PreserveLuminosity, FilterExFrame.ApplyOnShadowTone, FilterExFrame.ApplyOnMidTone, FilterExFrame.ApplyOnHighlightTone);
      UpdateViews;
      UpdateHistogram;
    end;
    //7 : // Negate Value
    //begin
    //  FilterExFrame := TCommonFilterExFrame(FInternalFrame);
    //  FImgResult.FastCopy(FImgSource);
    //  FImgResult.ColorFilter.OnProgress := @HandleOnImageProgress;
    //  FImgResult.ColorFilter.Negate(FilterExFrame.PreserveLuminosity, FilterExFrame.ApplyOnShadowTone, FilterExFrame.ApplyOnMidTone, FilterExFrame.ApplyOnHighlightTone);
    //  UpdateViews;
    //  UpdateHistogram;
    //end;
    8 : // Posterisation
    begin
      FilterExFrame := TCommonFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.ColorFilter.OnProgress := @HandleOnImageProgress;
      FImgResult.ColorFilter.Posterize(FilterExFrame.GetParam1,FilterExFrame.PreserveLuminosity, FilterExFrame.ApplyOnShadowTone, FilterExFrame.ApplyOnMidTone, FilterExFrame.ApplyOnHighlightTone);
      UpdateViews;
      UpdateHistogram;
    end;
    9 : // Solarisation
    begin
      FilterExFrame := TCommonFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.ColorFilter.OnProgress := @HandleOnImageProgress;
      FImgResult.ColorFilter.Solarize(FilterExFrame.GetParam1,FilterExFrame.PreserveLuminosity, FilterExFrame.ApplyOnShadowTone, FilterExFrame.ApplyOnMidTone, FilterExFrame.ApplyOnHighlightTone);
      UpdateViews;
      UpdateHistogram;
    end;
    10 : // Desaturate
    begin
      DesaturateFrame := TDesaturateSettingFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.ColorFilter.OnProgress := @HandleOnImageProgress;
      if DesaturateFrame.GetDesaturateMethode = gcmColorMask then
        FImgResult.ColorFilter.GrayScale(DesaturateFrame.GetDesaturateMethode,DesaturateFrame.GetDesaturateMatrix, DesaturateFrame.GetDesaturateColorMask, DesaturateFrame.GetParam2)
      else
        FImgResult.ColorFilter.GrayScale(DesaturateFrame.GetDesaturateMethode,DesaturateFrame.GetDesaturateMatrix, DesaturateFrame.GetParam1, DesaturateFrame.GetParam2);
      UpdateViews;
      UpdateHistogram;
    end;

    22 : // Ajustement RGB
    begin
      FilterExFrame := TCommonFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.ColorFilter.OnProgress := @HandleOnImageProgress;
      FImgResult.ColorFilter.AdjustRGB(FilterExFrame.GetParam1, FilterExFrame.GetParam2, FilterExFrame.GetParam3, FilterExFrame.PreserveLuminosity, FilterExFrame.ApplyOnShadowTone, FilterExFrame.ApplyOnMidTone, FilterExFrame.ApplyOnHighlightTone);
      UpdateViews;
      UpdateHistogram;
    end;

    23 : // Balance des couleurs
    begin
      FilterExFrame := TCommonFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.ColorFilter.OnProgress := @HandleOnImageProgress;
      FImgResult.ColorFilter.ColorBalance(FilterExFrame.GetParam1, FilterExFrame.GetParam2, FilterExFrame.GetParam3, FilterExFrame.PreserveLuminosity, FilterExFrame.ApplyOnShadowTone, FilterExFrame.ApplyOnMidTone, FilterExFrame.ApplyOnHighlightTone);
      UpdateViews;
      UpdateHistogram;
    end;

    24 : // Balance des couleurs
    begin
      FilterExFrame := TCommonFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.ColorFilter.OnProgress := @HandleOnImageProgress;
      FImgResult.ColorFilter.AdjustHSV(FilterExFrame.GetParam1, FilterExFrame.GetParam2, FilterExFrame.GetParam3, FilterExFrame.ApplyOnShadowTone, FilterExFrame.ApplyOnMidTone, FilterExFrame.ApplyOnHighlightTone);
      UpdateViews;
      UpdateHistogram;
    end;

    25 : // Filtres Instagram
    begin
      ExtendFilterExFrame := TExtendFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.EffectFilter.OnProgress := @HandleOnImageProgress;
      FImgResult.EffectFilter.InstagramFilter(TBZInstagramFilterType(ExtendFilterExFrame.GetParam0));
      UpdateViews;
      UpdateHistogram;
    end;

    26 : // Sepia
    begin
      ExtendFilterExFrame := TExtendFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.ColorFilter.OnProgress := @HandleOnImageProgress;
      FImgResult.ColorFilter.Sepia(ExtendFilterExFrame.GetParam1);
      UpdateViews;
      UpdateHistogram;
    end;

    27 : // Rotation teinte
    begin
      ExtendFilterExFrame := TExtendFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.ColorFilter.OnProgress := @HandleOnImageProgress;
      FImgResult.ColorFilter.HueRotate(Round(ExtendFilterExFrame.GetParam1));
      UpdateViews;
      UpdateHistogram;
    end;

    30 : // Pincer et tournoyer
    begin
      ExtendFilterExFrame := TExtendFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.DeformationFilter.OnProgress := @HandleOnImageProgress;
      FImgResult.DeformationFilter.PinchAndTwirl(ExtendFilterExFrame.CenterX, ExtendFilterExFrame.CenterY, Round(ExtendFilterExFrame.GetParam1), Round(ExtendFilterExFrame.GetParam2), ExtendFilterExFrame.GetParam3, ExtendFilterExFrame.GetEdgeAction, ExtendFilterExFrame.GetSamplerMethod, ExtendFilterExFrame.GetSampleLevel);
      UpdateViews;
      UpdateHistogram;
    end;
    31 : // Pincer et tournoyer
    begin
      ExtendFilterExFrame := TExtendFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.DeformationFilter.OnProgress := @HandleOnImageProgress;
      FImgResult.DeformationFilter.Twirl(ExtendFilterExFrame.CenterX, ExtendFilterExFrame.CenterY, Round(ExtendFilterExFrame.GetParam1), Round(ExtendFilterExFrame.GetParam2), ExtendFilterExFrame.GetEdgeAction, ExtendFilterExFrame.GetSamplerMethod);
      UpdateViews;
      UpdateHistogram;
    end;
    32 : // FishEye
    begin
      ExtendFilterExFrame := TExtendFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.DeformationFilter.OnProgress := @HandleOnImageProgress;
      FImgResult.DeformationFilter.FishEye(ExtendFilterExFrame.CenterX, ExtendFilterExFrame.CenterY, Round(ExtendFilterExFrame.GetParam1), Round(ExtendFilterExFrame.GetParam2), ExtendFilterExFrame.GetEdgeAction, ExtendFilterExFrame.GetSamplerMethod);
      UpdateViews;
      UpdateHistogram;
    end;
    33 : // Ondulation
    begin
      ExtendFilterExFrame := TExtendFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.DeformationFilter.OnProgress := @HandleOnImageProgress;
      FImgResult.DeformationFilter.WaveDistorsion(TBZWaveDistorsionMode(ExtendFilterExFrame.GetParam0), ExtendFilterExFrame.GetParam1, ExtendFilterExFrame.GetParam2, ExtendFilterExFrame.GetParam3, ExtendFilterExFrame.GetParam4, ExtendFilterExFrame.GetEdgeAction, ExtendFilterExFrame.GetSamplerMethod);
      UpdateViews;
      UpdateHistogram;
    end;
    34 : // Ondulation d'eau
    begin
      ExtendFilterExFrame := TExtendFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.DeformationFilter.OnProgress := @HandleOnImageProgress;
      FImgResult.DeformationFilter.WaterRipple(ExtendFilterExFrame.CenterX, ExtendFilterExFrame.CenterY, Round(ExtendFilterExFrame.GetParam1), ExtendFilterExFrame.GetParam2, ExtendFilterExFrame.GetParam3, ExtendFilterExFrame.GetParam4, ExtendFilterExFrame.GetEdgeAction, ExtendFilterExFrame.GetSamplerMethod, ExtendFilterExFrame.GetSampleLevel);
      UpdateViews;
      UpdateHistogram;
    end;
    35 : // Eparpiller
    begin
      ExtendFilterExFrame := TExtendFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.DeformationFilter.OnProgress := @HandleOnImageProgress;
      FImgResult.DeformationFilter.Diffusion(ExtendFilterExFrame.GetParam1, ExtendFilterExFrame.GetParam2, ExtendFilterExFrame.GetParam3, ExtendFilterExFrame.GetParam4, ExtendFilterExFrame.GetEdgeAction, ExtendFilterExFrame.GetSamplerMethod, ExtendFilterExFrame.GetSampleLevel);
      UpdateViews;
      UpdateHistogram;
    end;
    36 : // Ondulation d'eau
    begin
      ExtendFilterExFrame := TExtendFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.DeformationFilter.OnProgress := @HandleOnImageProgress;
      //FImgResult.Transformation.CartesianToPolar;
      FImgResult.DeformationFilter.Polar(TBZPolarTransformationMode(ExtendFilterExFrame.GetParam0), ExtendFilterExFrame.CenterX, ExtendFilterExFrame.CenterY, ExtendFilterExFrame.GetEdgeAction, ExtendFilterExFrame.GetSamplerMethod, ExtendFilterExFrame.GetSampleLevel);
      UpdateViews;
      UpdateHistogram;
    end;


    41 : // Box Blur
    begin
      ExtendFilterExFrame := TExtendFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.BlurFilter.OnProgress := @HandleOnImageProgress;
      //FImgResult.Transformation.CartesianToPolar;
      FImgResult.BlurFilter.BoxBlur(Round(ExtendFilterExFrame.GetParam1));
      UpdateViews;
      UpdateHistogram;
    end;
    42 : // Gaussian Blur
    begin
      ExtendFilterExFrame := TExtendFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.BlurFilter.OnProgress := @HandleOnImageProgress;
      //FImgResult.Transformation.CartesianToPolar;
      FImgResult.BlurFilter.GaussianBoxBlur(ExtendFilterExFrame.GetParam1);
      UpdateViews;
      UpdateHistogram;
    end;
    43 : // Radial Blur
    begin
      ExtendFilterExFrame := TExtendFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.BlurFilter.OnProgress := @HandleOnImageProgress;
      //FImgResult.Transformation.CartesianToPolar;
      FImgResult.BlurFilter.RadialZoomBlur(ExtendFilterExFrame.CenterX, ExtendFilterExFrame.CenterY, Round(ExtendFilterExFrame.GetParam1), 1);
      UpdateViews;
      UpdateHistogram;
    end;
    44 : // Zoom Blur
    begin
      ExtendFilterExFrame := TExtendFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.BlurFilter.OnProgress := @HandleOnImageProgress;
      //FImgResult.Transformation.CartesianToPolar;
      FImgResult.BlurFilter.ZoomBlur(ExtendFilterExFrame.CenterX, ExtendFilterExFrame.CenterY, Round(ExtendFilterExFrame.GetParam1), 100, 100);
      UpdateViews;
      UpdateHistogram;
    end;
    45 : // Motion Blur
    begin
      ExtendFilterExFrame := TExtendFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.BlurFilter.OnProgress := @HandleOnImageProgress;
      //FImgResult.Transformation.CartesianToPolar;
      FImgResult.BlurFilter.MotionBlur(ExtendFilterExFrame.GetParam2, Round(ExtendFilterExFrame.GetParam1), ExtendFilterExFrame.GetParam3, ExtendFilterExFrame.GetParam4);
      UpdateViews;
      UpdateHistogram;
    end;
    46 : // Split Blur
    begin
      ExtendFilterExFrame := TExtendFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.BlurFilter.OnProgress := @HandleOnImageProgress;
      //FImgResult.Transformation.CartesianToPolar;
      FImgResult.BlurFilter.SplitBlur(Round(ExtendFilterExFrame.GetParam1));
      UpdateViews;
      UpdateHistogram;
    end;
    47 : // Threshold Blur
    begin
      ExtendFilterExFrame := TExtendFilterExFrame(FInternalFrame);
      FImgResult.FastCopy(FImgSource);
      FImgResult.BlurFilter.OnProgress := @HandleOnImageProgress;
      //FImgResult.Transformation.CartesianToPolar;
      FImgResult.BlurFilter.ThresholdBlur(ExtendFilterExFrame.GetParam1, Round(ExtendFilterExFrame.GetParam2));
      UpdateViews;
      UpdateHistogram;
    end;

  end;
  ShowHideImageProgress(false);
  Screen.Cursor:= crDefault;
end;

procedure TMainForm.actFileOpenExecute(Sender : TObject);
begin
  if OPD.Execute then
  begin
    LoadPicture(OPD.FileName);
  end;
end;

procedure TMainForm.sbScrollVChange(Sender : TObject);
begin
  ImageView.OffsetTop := sbScrollV.Position;
end;

procedure TMainForm.sbScrollHChange(Sender : TObject);
begin
  ImageView.OffsetLeft := sbScrollH.Position;
end;

procedure TMainForm.ImageViewResize(Sender : TObject);
begin
  UpdateImageViewScrollBars(False);
end;

procedure TMainForm.actAppExitExecute(Sender : TObject);
begin
  Close;
end;

procedure TMainForm.actFileSaveExecute(Sender : TObject);
begin
  if SPD.Execute then
  begin
    SavePicture(SPD.FileName);
  end;
end;

procedure TMainForm.actViewExplorerExecute(Sender : TObject);
begin
  pnlExplorer.Visible := actViewExplorer.Checked;
  UpdateImageViewScrollBars(False);
end;

procedure TMainForm.actDrawWithTransparencyExecute(Sender : TObject);
begin
  ImageView.DrawWithTransparency := actDrawWithTransparency.Checked;
end;

procedure TMainForm.actCenterExecute(Sender : TObject);
begin
  ImageView.Center := actCenter.Checked;
  UpdateImageViewScrollBars(False);
end;

procedure TMainForm.actOriginalSizeExecute(Sender : TObject);
begin
  if actOriginalSize.Checked then
  begin
    AutoFitMode := afmManual;
    ImageView.Stretch := False;
    ImageView.Proportional := False;
    actZoomIn.Enabled := True;
    actZoomOut.Enabled := True;
    mniZoom.Enabled := True;
    //actShowZoomGrid.Enabled := False;
    UpdateImageViewScrollBars(False);
  end;
end;

procedure TMainForm.actBestFitExecute(Sender : TObject);
begin
  if actBestFit.Checked then
  begin
    AutoFitMode := afmManual;
    ImageView.Stretch := True;
    ImageView.Proportional := True;
    actZoomIn.Enabled := False;
    actZoomOut.Enabled := False;
    mniZoom.Enabled := False;
    //actShowZoomGrid.Enabled := False;
    UpdateImageViewScrollBars(False);
  end;
end;

procedure TMainForm.actStretchExecute(Sender : TObject);
begin
  if actStretch.Checked then
  begin
    AutoFitMode := afmManual;
    ImageView.Stretch := True;
    ImageView.Proportional := False;
    actZoomIn.Enabled := False;
    actZoomOut.Enabled := False;
    mniZoom.Enabled := False;
    //actShowZoomGrid.Enabled := False;
    UpdateImageViewScrollBars(False);
  end;
end;

procedure TMainForm.actShowZoomGridExecute(Sender : TObject);
begin
  ImageView.ZoomGrid := actShowZoomGrid.Checked;
end;

procedure TMainForm.actAutoFitExecute(Sender : TObject);
begin
  if actAutoFit.Checked then
  begin
    if mniAutoFitOnlyBig.Checked then
    begin
      AutoFitMode := afmFitOnlyBigger;
    end
    else if mniAutoFitOnlySmall.Checked then
    begin
      AutoFitMode := afmFitOnlySmaller;
    end
    else
    begin
      AutoFitMode := afmFitAll
    end;
    HandleAutoFit(AutoFitMode);
    ImageView.RePaint;
    UpdateImageViewScrollBars(False);
  end;
end;

procedure TMainForm.mniAutoFitBothClick(Sender : TObject);
begin
  actAutoFit.Checked := True;
  tbtnAutoFit.Down := True;
  actAutoFitExecute(Self);
end;

procedure TMainForm.ImageViewMouseWheelDown(Sender : TObject; Shift : TShiftState; MousePos : TPoint; var Handled : Boolean);
begin
  handled := True;
  If Not (ImageView.Stretch) Then
  Begin
    If (ssCTRL In Shift) Then
    Begin
      ZoomFactor := ZoomFactor - 1;
    End
    Else
    Begin
      ZoomFactor:= ZoomFactor - 5;
    End;
    HandleZoom(False);
  End;
end;

procedure TMainForm.ImageViewMouseWheelUp(Sender : TObject; Shift : TShiftState; MousePos : TPoint; var Handled : Boolean);
begin
  handled := True;
  If Not (ImageView.Stretch) Then
  Begin
    If (ssCTRL In Shift) Then
    Begin
      ZoomFactor := ZoomFactor + 1;
    End
    Else
    Begin
      ZoomFactor:= ZoomFactor + 5;
    End;
    HandleZoom(False);
  End;
end;

procedure TMainForm.actZoomInExecute(Sender : TObject);
begin
  ZoomFactor:= ZoomFactor + 5;
  HandleZoom(False);
end;

procedure TMainForm.actZoomOutExecute(Sender : TObject);
begin
  ZoomFactor:= ZoomFactor - 5;
  HandleZoom(False);
end;

procedure TMainForm.ChooseZoomPercent(Sender : TObject);
begin
  ZoomFactor:=  TMenuItem(Sender).Tag;
  HandleZoom(False);
end;

procedure TMainForm.ImageViewMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  MousePoint.x := X;
  MousePoint.y := Y;
  If (ssLeft In Shift) Then
  Begin
    If (ssCTRL In Shift) Then
    Begin
      if ImageView.CanScroll then
      begin
         FMoving := True;
         LastMousePoint := MousePoint;
         Screen.cursor := crSizeAll;
       //  lblImagePos.Caption := ImageView.VirtualViewPort.left.ToString()+'x'+ImageView.VirtualViewPort.Top.ToString();
      End;
    End;
  End;
end;

procedure TMainForm.ImageViewMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
begin
  If FMoving And ((ssleft In shift) And (ssCTRL In Shift)) Then
  Begin
    FOffsetLeft := FLastOffsetLeft + x - LastMousePoint.x;
    FOffsetTop := FLastOffsetTop + y - LastMousePoint.y;
    sbScrollH.Position := FOffsetLeft;
    sbScrollV.Position := FOffsetTop;
    //imageView.Invalidate;
    //lblImagePos.Caption := ImageView.VirtualViewPort.left.ToString()+'x'+ImageView.VirtualViewPort.Top.ToString();
  End
end;

procedure TMainForm.ImageViewMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  Screen.Cursor := crDefault;
  FLastOffsetTop := FOffsetTop;
  FLastOffsetLeft := FOffsetLeft;
  FMoving := False;
end;

procedure TMainForm.actColorPickerExecute(Sender : TObject);
begin
  if not(Assigned(ColorWatchForm)) then ColorWatchForm := TColorWatchForm.Create(Self);
  ColorWatchForm.Show;
end;

procedure TMainForm.actResizeExecute(Sender : TObject);
begin
  ResizeForm.ImageHeight := ImageView.Picture.Bitmap.Height;
  ResizeForm.ImageWidth := ImageView.Picture.Bitmap.Width;
  if ResizeForm.ShowModal = mrOk then
  begin
    if (ImageView.Picture.Bitmap.Width <> ResizeForm.NewImageWidth) or (ImageView.Picture.Bitmap.Height <> ResizeForm.NewImageHeight) then
    begin
      Case ResizeForm.ResizeMode of
        ismDraft: ImageView.Picture.Bitmap.Transformation.Stretch(ResizeForm.NewImageWidth, ResizeForm.NewImageHeight);
        ismSmooth: ImageView.Picture.Bitmap.Transformation.StretchSmooth(ResizeForm.NewImageWidth, ResizeForm.NewImageHeight);
        ismBicubic: ImageView.Picture.Bitmap.Transformation.StretchBicubic(ResizeForm.NewImageWidth, ResizeForm.NewImageHeight);
        ismResample: ImageView.Picture.Bitmap.Transformation.Resample(ResizeForm.NewImageWidth, ResizeForm.NewImageHeight,ResizeForm.ResampleMethod) ;
      end;
      ImageView.Invalidate;
    end;
  end;
end;

procedure TMainForm.sbAddonsDockOver(Sender : TObject; Source : TDragDockObject; X, Y : Integer; State : TDragState; var Accept : Boolean);
var
  ARect: TRect;
  D, NewHeight : Integer;
begin
  Accept := Source.Control is TForm;
  if Accept then
  begin
    NewHeight := Y;
    D := (Sender as TScrollBox).ClientHeight -  Source.Control.Height;
    if D>0 then
    begin
      NewHeight := NewHeight + (Sender as TScrollBox).ClientHeight + D;
      //(Sender as TScrollBox).ClientHeight := (Sender as TScrollBox).ClientHeight + D;

      //(Sender as TScrollBox). //.AdjustSize; //.DoAdjustClientRectChange(True); //.InvalidateClientRectCache(True);
    end
    else
    begin
      NewHeight := NewHeight +  Source.Control.Height;
    end;
    ARect.TopLeft := (Sender as TScrollBox).ClientToScreen(Point(0,Y));
    ARect.BottomRight := (Sender as TScrollBox).ClientToScreen(Point((Sender as TScrollBox).ClientWidth, NewHeight));
    Source.DockRect := ARect;

  end;
end;

procedure TMainForm.sbAddonsDockDrop(Sender : TObject; Source : TDragDockObject; X, Y : Integer);
begin
  //Change the dropped component (source) Align property to alTop to achieve top
  //alignment of docked control
  Source.Control.Align := alTop;
  TPanel((Sender as TScrollBox).Parent).Width := 245;
  Inc(DMMain.DockFormCount);
  Source.Control.Height := Source.Control.Constraints.MaxHeight; // Hack
end;

procedure TMainForm.sbAddonsUnDock(Sender : TObject; Client : TControl; NewTarget : TWinControl; var Allow : Boolean);
begin
  //Reset Align property to alNone to revert undocked control to original size
  //NOTE: Changing Source.DocRect like in OnDockOver event below will also change
  //original size of the control. So when undocked it will no longer have same
  //dimensions as it did before docking
  Dec(DMMain.DockFormCount);
  Client.Align := alNone;
end;

procedure TMainForm.DockFormWatcherTimerTimer(Sender : TObject);
begin
  if (DMMain.DockFormCount = 0) then pnlAddons.Width := 8;
end;

procedure TMainForm.actHistogramExecute(Sender : TObject);
begin
  //if Assigned(HistogramForm) then
  //begin
  //  if HistogramForm.Visible then
  //  begin
  //    HistogramForm.Close;
  //    HistogramForm := nil;
  //  end;
  //end
  //else
  //begin
    if not(Assigned(HistogramForm)) then HistogramForm := THistogramForm.Create(Self); //CreateHistogramFrame(Self, 'Histogram');
    if FImageLoaded then
    begin
     HistogramForm.UpdateHistogram(ImageView.Picture.Bitmap);
    end;
    HistogramForm.Show;
end;

procedure TMainForm.actInitAndApplyFilterExecute(Sender : TObject);
begin
  FCurrentFilter := TAction(Sender).Tag;
  InitFilterUI(FCurrentFilter);
  ApplyFilter(FCurrentFilter);
end;

procedure TMainForm.actInitFilterExecute(Sender : TObject);
begin
  FCurrentFilter := TAction(Sender).Tag;
  InitFilterUI(FCurrentFilter);
end;

procedure TMainForm.HandleFilterChangeSettings(Sender : TObject);
begin
  FInternalFrame.Enabled := False;
  ApplyFilter(FCurrentFilter);
  FInternalFrame.Enabled := True;
end;

procedure TMainForm.UpdateViews;
begin
  ImageView.Picture.Bitmap.Assign(FImgResult);
  HandleAutoFit(AutoFitMode);
  ImageView.Invalidate;
  UpdateImageViewScrollBars(False);
end;

procedure TMainForm.UpdateHistogram;
begin
  if Assigned(HistogramForm) then HistogramForm.UpdateHistogram(FImgResult);
end;

procedure TMainForm.FormDropFiles(Sender : TObject; const FileNames : Array of String);
begin
  if Length(FileNames) > 0 then LoadPicture(FileNames[0],true);
end;

procedure TMainForm.ShellTreeViewGetImageIndex(Sender : TObject; Node : TTreeNode);
begin
  case Node.Expanded of
    True : Node.ImageIndex:=1;
    False: Node.ImageIndex:=0;
  end;
end;

procedure TMainForm.ShellListViewColumnClick(Sender : TObject; Column : TListColumn);
begin
  ShellListView.SortColumn := Column.Index;
end;

procedure TMainForm.ShellListViewFileAdded(Sender : TObject; Item : TListItem);
Var
  Ext : String;
  dt: TDateTime;
Begin
  Ext := LowerCase(ExtractFileExt(Item.Caption));
  if (Ext = '.bmp') or (Ext = '.rle') or (Ext = '.dib') then Item.ImageIndex := 0
  else if (Ext = '.gif') then Item.ImageIndex := 1
  else if (Ext = '.jpeg') or (Ext = '.jpg') or (Ext = '.jpe') or (Ext = '.jfif') then Item.ImageIndex := 2
  else if (Ext = '.pcx') or (Ext = '.pcc') or (Ext = '.scr') then Item.ImageIndex := 3
  else if (Ext = '.pbm') or (Ext = '.pgm') or (Ext = '.pnm') or (Ext = '.ppm') or (Ext = '.pam') or (Ext = '.pfm') then Item.ImageIndex := 4
  else if (Ext = '.tga') or (Ext = '.vst') or (Ext = '.icb') or (Ext = '.vda') then Item.ImageIndex := 5
  else if (Ext = '.png') or (Ext = '.apng') or (Ext = '.mng') then Item.ImageIndex := 6
  else if (Ext = '.tif') or (Ext = '.tiff') then Item.ImageIndex := 7
  else if (Ext = '.xpm')  then Item.ImageIndex := 8;
  FileAge(ShellListView.Root+Item.Caption, dt);
  Item.SubItems.Add(FormatDateTime('DD/MM/YYYY  hh:mm',Dt));
end;

procedure TMainForm.ShellListViewSelectItem(Sender : TObject; Item : TListItem; Selected : Boolean);
begin
  if selected then LoadPicture(ShellListView.Root+Item.Caption);
end;

procedure TMainForm.ShellTreeViewGetSelectedIndex(Sender : TObject; Node : TTreeNode);
begin
  if (Node.Selected) or (nsSelected in Node.States) then  Node.SelectedIndex := 2
  else Node.SelectedIndex := Node.ImageIndex;
end;

procedure TMainForm.LoadPicture(FileName : String; const Drag : Boolean);
Var
  ff : String;
begin
  Try
    ShowHideImageProgress(true);
    Screen.Cursor := crHourGlass;
    FImgSource.OnProgress := @HandleOnImageProgress;
    FImgSource.LoadFromFile(FileName);
    FImgResult.Assign(FImgSource);
    ImageView.Picture.Bitmap.SetSize(FImgSource.Width, FImgSource.Height);
   // ImageView.Picture.Bitmap.Layers.Transparent := ImageView.Transparent;
  Finally
    ff := FImgSource.FullFileName;
    if Drag then
    begin
      ShellTreeView.Path := ExtractFilePath(ff);
    end;
    lblFileName.Hint := ff;
    lblFileName.Caption := MinimizeName(ff, lblFileName.Canvas ,lblFileName.ClientWidth);
    UpdateInformations;
    UpdateViews;
    UpdateHistogram;
    ShowHideImageProgress(false);
    FImageLoaded := True;
    Screen.Cursor := crDefault;
  end;
end;

procedure TMainForm.SavePicture(FileName : String);
Var
  Ext : String;
  Ok : Boolean;
begin
  Ok := False;
  Ext := LowerCase(ExtractFileExt(FileName));
  if  (Ext = '.bmp') or (Ext = '.rle') or (Ext = '.dib') then
  begin
    Ok := true;
  end
  else if (Ext = '.jpeg') or (Ext = '.jpg') or (Ext = '.jpe') or (Ext = '.jfif') then
  begin
    Ok := true;
  end
  else if (Ext = '.tga') or (Ext = '.vst') or (Ext = '.icb') or (Ext = '.vda') then
  begin
    Ok := true;
  end;
  if Ok then
  begin
    ShowHideImageProgress(true);
    Screen.Cursor := crHourGlass;
    try
      ImageView.Picture.Bitmap.SaveToFile(FileName);
    finally
      ShowHideImageProgress(false);
      Screen.Cursor := crDefault;
    end;
  end;
  //else if (Ext = '.png') then
  //else if (Ext = '.ico') then
end;

procedure TMainForm.HandleZoom(Const UpdateControls : Boolean);
begin
  If ZoomFactor < 5 Then ZoomFactor := 5;
  If ZoomFactor > 3200 Then ZoomFactor := 3200;
  ImageView.ZoomFactor := ZoomFactor;
  if UpdateControls then
  begin

  end;
  // ImageView.Invalidate;
  // On utilise repaint au lieu de Invalidate car
  // Invalidate sera traiter en dernier dans l'odre d'appel des methodes (en fait, des envois des messages ; Invalidate envoie un WM_PAINT)

  ImageView.Repaint;  //ou .Refresh  //.Update n'est pas vraiment conseillé, mais possible.

  // De ce fait avec Invalidate la methode ci-dessus sera traité AVANT, ce qui n'est pas le comportement désiré
  UpdateImageViewScrollBars(False);

  { Bon à savoir :
    ------------

    Repaint --> Force le réaffichage (rafraichissement ) du controle via la méthode Paint

    Refresh --> Appel Repaint.
    La méthode Refresh est là pour pouvoir "contourner" le rafraichissement directe,
    afin de pouvoir faire d'autres mises à jours avant le rafraichissement.
    Celle-ci doit être hériter et surcharger dans nos controles personnalisés.

    Update  --> Est censée forcer un WM_PAINT au contrôle directement.
    S'il y a eu un "Invalidate" avant, on est supposé vérifier la présence du
    message envoyé par Invalidate dans la mémoire tampon et vérifier que celui-ci n'a pas encore été traité.
    Puis seulement, on peux forcer le réaffichage. En suite, on doit enlever
    le message envoyé par "Invalidate" qui est encore en attente pour
    ne pas avoir un double rafraichissement }
end;

procedure TMainForm.HandleAutoFit(Const Mode : TAutoFitMode);
begin
  if Mode = afmManual then exit;
  Case Mode of
    afmFitAll:
    begin
      ImageView.Stretch := True;
      ImageView.Proportional := True;
    end;
    afmFitOnlyBigger:
    begin
      if (ImageView.Picture.Bitmap.Width > ImageView.Width) or (ImageView.Picture.Bitmap.Height > ImageView.Height) then
      begin
        ImageView.Stretch := True;
        ImageView.Proportional := True;
      end
      else
      begin
        ImageView.Stretch := False;
        ImageView.Proportional := False;
      end;
    end;
    afmFitOnlySmaller:
    begin
      if (ImageView.Picture.Bitmap.Width < ImageView.Width) or (ImageView.Picture.Bitmap.Height < ImageView.Height) then
      begin
        ImageView.Stretch := True;
        ImageView.Proportional := True;
      end
      else
      begin
        ImageView.Stretch := False;
        ImageView.Proportional := False;
      end;
    end;
  end;
  if ImageView.Stretch then
  begin
    actZoomIn.Enabled := False;
    actZoomOut.Enabled := False;
    mniZoom.Enabled := False;
    //actShowZoomGrid.Enabled := False;
  end
  else
  begin
    actZoomIn.Enabled := True;
    actZoomOut.Enabled := True;
    mniZoom.Enabled := True;
    //actShowZoomGrid.Enabled := True;
  end;

end;

procedure TMainForm.UpdateInformations;
begin
  with ImageView.Picture.Bitmap do
  begin
    With ImageDescription Do
    Begin
      // Informations
    end;
  end;
end;

procedure TMainForm.UpdateImageViewScrollBars(Const ResetPosition : Boolean);
begin
  if ImageView.CanScroll then
  begin
    sbScrollH.Min := ImageView.ScrollBounds.Left;
    sbScrollH.Max := ImageView.ScrollBounds.Right;
    sbScrollV.Min := ImageView.ScrollBounds.Top;
    sbScrollV.Max := ImageView.ScrollBounds.Bottom;
    if ResetPosition then
    begin
      sbScrollH.Position := 0;
      sbScrollV.Position := 0;
    end;
  end;
  sbScrollH.Enabled := ImageView.CanScrollHorizontal;
  sbScrollV.Enabled := ImageView.CanScrollVertical;
  //GlobalLogger.LogNotice('sbScrollH.Enabled = ' + sbScrollH.Enabled.ToString());
  //GlobalLogger.LogNotice('sbScrollV.Enabled = ' + sbScrollV.Enabled.ToString());
end;

procedure TMainForm.ShowHideImageProgress(Const IsShow : Boolean);
begin
  pnlMainStatus.Visible := not(IsShow);
  pnlImageProgress.Visible := IsShow;
end;

end.

