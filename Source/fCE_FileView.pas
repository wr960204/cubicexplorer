//******************************************************************************
//  CubicExplorer                                                                             
//  Version: 0.90                                                                             
//                                                                                            
//  The contents of this file are subject to the Mozilla Public License                       
//  Version 1.1 (the "License"); you may not use this file except in                          
//  compliance with the License. You may obtain a copy of the License at                      
//  http://www.mozilla.org/MPL/                                                               
//                                                                                            
//  Software distributed under the License is distributed on an "AS IS"
//  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
//  License for the specific language governing rights and limitations                        
//  under the License.                                                                        
//                                                                                            
//  The Original Code is fCE_FileView.pas.                                                            
//                                                                                            
//  The Initial Developer of the Original Code is Marko Savolainen (cubicreality@gmail.com).  
//  Portions created by Marko Savolainen Copyright (C) Marko Savolainen. All Rights Reserved. 
//                                                                                            
//******************************************************************************

unit fCE_FileView;

interface

uses
  // CE Units
  fCE_TabPage, CE_FileView, CE_GlobalCtrl, CE_Utils,
  dCE_Images, CE_ContextMenu, CE_LanguageEngine, CE_AppSettings,
  CE_InfoBar, CE_FileUtils, fCE_QuickView,
  // EasyListview
  EasyListview, 
  // VSTools
  VirtualExplorerEasyListview, MPCommonObjects, MPShellUtilities,
  VirtualExplorerTree, MPCommonUtilities, ColumnFormSpTBX,
  VirtualShellNotifier,
  // VT
  VirtualTrees,
  // SpTBX
  SpTBXItem, SpTBXControls, SpTBXDkPanels, SpTBXSkins,
  // TB2K
  TB2Item,
  // Tnt Controls
  TntSysUtils,
  // System Units
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ShlObj, Menus, JvAppStorage, Contnrs, StrUtils, ExtCtrls, ActiveX,
  VirtualThumbnails;

type
  TEasyEditManagerHack = class(TEasyEditManager);

  TCEFileViewHack = class(TCEFileView);

  TCEFileViewPage = class(TCECustomTabPage)
    QuickViewSplitter: TSpTBXSplitter;
    procedure QuickViewSplitterMoved(Sender: TObject);
    procedure View(Sender: TObject);
  private
    fDownShiftState: TShiftState;
    fPathChanging: Boolean;
    fShowInfoBar: Boolean;
    fShowItemContextMenu: Boolean;
    fThumbPosition: TAlign;
    fViewStyle: TEasyListStyle;
    fThumbViewStyle: TEasyListStyle;
    procedure SetShowInfoBar(const Value: Boolean);
    procedure SetThumbPosition(const Value: TAlign);
    procedure SetViewStyle(const Value: TEasyListStyle);
    procedure SetThumbViewStyle(const Value: TEasyListStyle);
  protected
    fFileViewDragging: Boolean;
    fQuickView: TCEQuickView;
    fShowCaptionsInFilmstrip: Boolean;
    fShowCaptionsInThumbnails: Boolean;
    function DragEnter(const dataObj: IDataObject; grfKeyState: Longint; pt:
        TPoint; var dwEffect: Longint): HResult; override; stdcall;
    function DragLeave: HResult; override; stdcall;
    function DragOver(grfKeyState: Longint; pt: TPoint; var dwEffect: Longint):
        HResult; override; stdcall;
    function Drop(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint; var
        dwEffect: Longint): HResult; override; stdcall;
    function GetSettingsClass: TCECustomTabPageSettingsClass; override;
    procedure GlobalFocusChanged(Sender: TObject; NewPath: WideString); override;
        stdcall;
    procedure GlobalPathChanged(Sender: TObject; NewPath: WideString); override;
        stdcall;
    procedure GlobalPIDLChanged(Sender: TObject; NewPIDL: PItemIDList); override;
        stdcall;
    procedure HandleFileViewResize(Sender: TObject); virtual;
    procedure HandleViewStyleChange(Sender: TObject); virtual;
    procedure InfoBarSplitterMouseUp(Sender: TObject; Button: TMouseButton; Shift:
        TShiftState; X, Y: Integer);
    procedure InfoBarSplitterMoving(Sender: TObject; var NewSize: Integer; var
        Accept: Boolean);
    procedure ItemSelectionsChanged(Sender: TCustomEasyListview);
    procedure OnColumnSizeChanged(Sender: TCustomEasyListview; Column: TEasyColumn);
    procedure OnEnumFinished(Sender: TCustomVirtualExplorerEasyListview);
    procedure OnItemContextMenu(Sender: TCustomEasyListview; HitInfo:
        TEasyHitInfoItem; WindowPoint: TPoint; var Menu: TPopupMenu; var Handled:
        Boolean);
    procedure OnShellNotify(Sender: TCustomVirtualExplorerEasyListview; ShellEvent:
        TVirtualShellEvent);
    procedure SetActive(const Value: Boolean); override;
    procedure OnGetStorage(Sender: TCustomVirtualExplorerEasyListview; var Storage:
        TRootNodeStorage);
    procedure SetShowCaptionsInFilmstrip(const Value: Boolean);
    procedure SetShowCaptionsInThumbnails(const Value: Boolean);
    procedure SetThumbViewSize(const Value: Integer);
  public
    FileView: TCEFileView;
    fThumbViewSize: Integer;
    InfoBar: TCEInfoBar;
    InfoBarSplitter: TSpTBXSplitter;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure OnMouseDown(Sender: TObject; Button: TMouseButton; Shift:
        TShiftState; X, Y: Integer);
    procedure RootChanging(Sender: TCustomVirtualExplorerEasyListview; const
        NewValue: TRootFolder; const CurrentNamespace, Namespace: TNamespace; var
        Allow: Boolean);
    procedure RootRebuild(Sender: TCustomVirtualExplorerEasyListview);
    procedure RootChange(
      Sender: TCustomVirtualExplorerEasyListview);
    procedure SelectPage; override;
    procedure UpdateCaption; override;
    procedure HidePage; override;
    procedure LoadFromStream(AStream: TStream); override;
    procedure OnContextMenu(Sender: TCustomEasyListview; MousePt: TPoint; var
        Handled: Boolean);
    procedure OnMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
        X, Y: Integer);
    procedure SaveToStream(AStream: TStream); override;
    procedure ShowHeaderSelector;
    property ShowInfoBar: Boolean read fShowInfoBar write SetShowInfoBar;
    property ThumbPosition: TAlign read fThumbPosition write SetThumbPosition;
    property ThumbViewSize: Integer read fThumbViewSize write SetThumbViewSize;
    property ViewStyle: TEasyListStyle read fViewStyle write SetViewStyle;
    property ThumbViewStyle: TEasyListStyle read fThumbViewStyle write
        SetThumbViewStyle;
  published
    property ShowCaptionsInFilmstrip: Boolean read fShowCaptionsInFilmstrip write
        SetShowCaptionsInFilmstrip;
    property ShowCaptionsInThumbnails: Boolean read fShowCaptionsInThumbnails write
        SetShowCaptionsInThumbnails;
  end;

  TCEFileViewPageSettings = class(TCECustomTabPageSettings)
  private
    function GetPath: WideString;
    function GetViewStyle: TEasyListStyle;
    procedure SetPath(const Value: WideString);
    procedure SetViewStyle(const Value: TEasyListStyle);
  protected
    function GetRememberInnerToolbarLayout: Boolean; override;
    function GetRememberOuterToolbarLayout: Boolean; override;
    function GetRememberPanelLayout: Boolean; override;
  public
    FileViewPage: TCEFileViewPage;
  published
    property Path: WideString read GetPath write SetPath;
    property ViewStyle: TEasyListStyle read GetViewStyle write SetViewStyle;
  end;

  TCEThumbnailSettings = class(TPersistent)
  private
  protected
    fLoadAllAtOnce: Boolean;
    fMaxThumbHeight: Integer;
    fMaxThumbWidth: Integer;
    fStorageCompressed: Boolean;
    fStorageFilename: WideString;
    fStorageRepositoryFolder: WideString;
    fStorageType: TThumbsAlbumStorage;
    fStretch: Boolean;
    fUseExifThumbnail: Boolean;
    fUseExifOrientation: Boolean;
    fUseFoldersShellExtraction: Boolean;
    fUseShellExtraction: Boolean;
    fUseStorage: Boolean;
    fUseSubsampling: Boolean;
  public
    constructor Create; virtual;
  published
    property LoadAllAtOnce: Boolean read fLoadAllAtOnce write fLoadAllAtOnce default False;
    property MaxThumbHeight: Integer read fMaxThumbHeight write fMaxThumbHeight default 512;
    property MaxThumbWidth: Integer read fMaxThumbWidth write fMaxThumbWidth default 512;
    property StorageCompressed: Boolean read fStorageCompressed write fStorageCompressed default True;
    property StorageFilename: WideString read fStorageFilename write fStorageFilename;
    property StorageRepositoryFolder: WideString read fStorageRepositoryFolder write fStorageRepositoryFolder;
    property StorageType: TThumbsAlbumStorage read fStorageType write fStorageType default tasRepository;
    property Stretch: Boolean read fStretch write fStretch default True;
    property UseExifThumbnail: Boolean read fUseExifThumbnail write fUseExifThumbnail default True;
    property UseExifOrientation: Boolean read fUseExifOrientation write fUseExifOrientation default True;
    property UseFoldersShellExtraction: Boolean read fUseFoldersShellExtraction write fUseFoldersShellExtraction default True;
    property UseShellExtraction: Boolean read fUseShellExtraction write fUseShellExtraction default True;
    property UseStorage: Boolean read fUseStorage write fUseStorage default false;
    property UseSubsampling: Boolean read fUseSubsampling write fUseSubsampling default True;
  end;  

  TCEFileViewSettings = class(TPersistent)
  private
    fArrowBrowse: Boolean;
    fFullRowSelect: Boolean;
    fHiddenFiles: Boolean;
    fSelectPreviousFolder: Boolean;
    fAutoSelectFirstItem: Boolean;
    fAutosizeListViewStyle: Boolean;
    fBrowseZipFolders: Boolean;
    fCellSizes: TCECellSizeSettings;
    fCheckBoxSelection: Boolean;
    fColumns: TCEColumnSettings;
    fFileSizeFormat: TVirtualFileSizeFormat;
    fFilmstrip: TCEFilmstripSettings;
    fFolderUpOnDblClick: Boolean;
    fFullRowDblClick: Boolean;
    fGroupBy: TCEGroupBySettings;
    fInfoBarSize: Integer;
    fShowInfoTips: Boolean;
    fRememberPanelLayout: Boolean;
    fRememberInnerToolbarLayout: Boolean;
    fRememberOuterToolbarLayout: Boolean;
    fSelectPasted: Boolean;
    fShowExtensions: Boolean;
    fShowGridLines: Boolean;
    fShowHeaderAlways: Boolean;
    fShowInfoBar: Boolean;
    fSingleClickBrowse: Boolean;
    fSingleClickExecute: Boolean;
    fSmoothScroll: Boolean;
    fSortAfterPaste: Boolean;
    fSortFolderFirstAlways: Boolean;
    fThreadedDetails: Boolean;
    fThreadedEnumeration: Boolean;
    fThreadedImages: Boolean;
    fUse_JumboIcons_in_InfoBar: Boolean;
    NotifyList: TComponentList;
    procedure SetArrowBrowse(const Value: Boolean);
    procedure SetFullRowSelect(const Value: Boolean);
    procedure SetHiddenFiles(const Value: Boolean);
    procedure SetSelectPreviousFolder(const Value: Boolean);
    procedure SetAutoSelectFirstItem(const Value: Boolean);
    procedure SetAutosizeListViewStyle(const Value: Boolean);
    procedure SetBrowseZipFolders(const Value: Boolean);
    procedure SetCheckBoxSelection(const Value: Boolean);
    procedure SetFileSizeFormat(const Value: TVirtualFileSizeFormat);
    procedure SetFolderUpOnDblClick(const Value: Boolean);
    procedure SetFullRowDblClick(const Value: Boolean);
    procedure SetSelectPasted(const Value: Boolean);
    procedure SetShowInfoTips(const Value: Boolean);
    procedure SetShowExtensions(const Value: Boolean);
    procedure SetShowGridLines(const Value: Boolean);
    procedure SetShowHeaderAlways(const Value: Boolean);
    procedure SetShowInfoBar(const Value: Boolean);
    procedure SetSingleClickBrowse(const Value: Boolean);
    procedure SetSingleClickExecute(const Value: Boolean);
    procedure SetSmoothScroll(const Value: Boolean);
    procedure SetSortAfterPaste(const Value: Boolean);
    procedure SetSortFolderFirstAlways(const Value: Boolean);
    procedure SetThreadedDetails(const Value: Boolean);
    procedure SetThreadedEnumeration(const Value: Boolean);
    procedure SetThreadedImages(const Value: Boolean);
    procedure SetUse_JumboIcons_in_InfoBar(const Value: Boolean);
  protected
    fBackgroundColor: TColor;
    fExtensionColors: WideString;
    fExtensionColorsEnabled: Boolean;
    fFont: TFont;
    fFullRowContextMenu: Boolean;
    fHideShortcutExtension: Boolean;
    fPerFolderSettings: Boolean;
    fShowCaptionsInFilmstrip: Boolean;
    fShowCaptionsInThumbnails: Boolean;
    fStorage: TRootNodeStorage;
    fStorageFilePath: WideString;
    fStorageIsLoaded: Boolean;
    fThumbnails: TCEThumbnailSettings;
    fTrackChangesInMappedDrives: Boolean;
    fUpdateCount: Integer;
    fViewStyle: TEasyListStyle;
    procedure SetBackgroundColor(const Value: TColor);
    procedure SetExtensionColors(const Value: WideString);
    procedure SetExtensionColorsEnabled(const Value: Boolean);
    procedure SetFont(const Value: TFont);
    procedure SetFullRowContextMenu(const Value: Boolean);
    procedure SetHideShortcutExtension(const Value: Boolean);
    procedure SetPerFolderSettings(const Value: Boolean);
    procedure SetShowCaptionsInFilmstrip(const Value: Boolean);
    procedure SetShowCaptionsInThumbnails(const Value: Boolean);
    procedure SetTrackChangesInMappedDrives(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure AssignSettingsTo(ATo: TComponent; AssignColumnSettings: Boolean =
        true);
    procedure AssignSettingsFrom(FileViewPage: TCEFileViewPage);
    procedure AssignFromActivePage;
    procedure RegisterNotify(AView: TComponent);
    procedure AssignColumnSettingsTo(FileView: TVirtualExplorerEasyListview);
    procedure SendChanges;
    procedure AssignColumnSettingsFrom(FileView: TVirtualExplorerEasyListview);
    procedure BeginUpdate;
    procedure ClearFilters;
    procedure EndUpdate(ASendChanges: Boolean = false);
    procedure LoadStorage;
    procedure SaveStorage;
    property Storage: TRootNodeStorage read fStorage;
    property StorageFilePath: WideString read fStorageFilePath write
        fStorageFilePath;
  published
    property ArrowBrowse: Boolean read fArrowBrowse write SetArrowBrowse default
        true;
    property SelectPreviousFolder: Boolean read fSelectPreviousFolder write
        SetSelectPreviousFolder;
    property AutoSelectFirstItem: Boolean read fAutoSelectFirstItem write
        SetAutoSelectFirstItem;
    property AutosizeListViewStyle: Boolean read fAutosizeListViewStyle write
        SetAutosizeListViewStyle;
    property BackgroundColor: TColor read fBackgroundColor write SetBackgroundColor;
    property BrowseZipFolders: Boolean read fBrowseZipFolders write
        SetBrowseZipFolders default false;
    property CellSizes: TCECellSizeSettings read fCellSizes write fCellSizes;
    property CheckBoxSelection: Boolean read fCheckBoxSelection write
        SetCheckBoxSelection;
    property Columns: TCEColumnSettings read fColumns write fColumns;
    property ExtensionColors: WideString read fExtensionColors write
        SetExtensionColors;
    property ExtensionColorsEnabled: Boolean read fExtensionColorsEnabled write
        SetExtensionColorsEnabled;
    property FileSizeFormat: TVirtualFileSizeFormat read fFileSizeFormat write
        SetFileSizeFormat default vfsfDefault;
    property Filmstrip: TCEFilmstripSettings read fFilmstrip write fFilmstrip;
    property FolderUpOnDblClick: Boolean read fFolderUpOnDblClick write
        SetFolderUpOnDblClick default true;
    property Font: TFont read fFont write SetFont;
    property FullRowContextMenu: Boolean read fFullRowContextMenu write
        SetFullRowContextMenu default false;
    property FullRowDblClick: Boolean read fFullRowDblClick write
        SetFullRowDblClick default false;
    property FullRowSelect: Boolean read fFullRowSelect write SetFullRowSelect;
    property GroupBy: TCEGroupBySettings read fGroupBy write fGroupBy;
    property HiddenFiles: Boolean read fHiddenFiles write SetHiddenFiles;
    property HideShortcutExtension: Boolean read fHideShortcutExtension write
        SetHideShortcutExtension default true;
    property InfoBarSize: Integer read fInfoBarSize write fInfoBarSize;
    property PerFolderSettings: Boolean read fPerFolderSettings write
        SetPerFolderSettings;
    property ShowInfoTips: Boolean read fShowInfoTips write SetShowInfoTips default
        true;
    property RememberPanelLayout: Boolean read fRememberPanelLayout write
        fRememberPanelLayout;
    property RememberInnerToolbarLayout: Boolean read fRememberInnerToolbarLayout
        write fRememberInnerToolbarLayout;
    property RememberOuterToolbarLayout: Boolean read fRememberOuterToolbarLayout
        write fRememberOuterToolbarLayout;
    property SelectPasted: Boolean read fSelectPasted write SetSelectPasted default
        true;
    property ShowCaptionsInFilmstrip: Boolean read fShowCaptionsInFilmstrip write
        SetShowCaptionsInFilmstrip default true;
    property ShowExtensions: Boolean read fShowExtensions write SetShowExtensions;
    property ShowGridLines: Boolean read fShowGridLines write SetShowGridLines;
    property ShowHeaderAlways: Boolean read fShowHeaderAlways write
        SetShowHeaderAlways;
    property ShowInfoBar: Boolean read fShowInfoBar write SetShowInfoBar;
    property ShowCaptionsInThumbnails: Boolean read fShowCaptionsInThumbnails write
        SetShowCaptionsInThumbnails default true;
    property SingleClickBrowse: Boolean read fSingleClickBrowse write
        SetSingleClickBrowse default false;
    property SingleClickExecute: Boolean read fSingleClickExecute write
        SetSingleClickExecute;
    property SmoothScroll: Boolean read fSmoothScroll write SetSmoothScroll;
    property SortAfterPaste: Boolean read fSortAfterPaste write SetSortAfterPaste
        default true;
    property SortFolderFirstAlways: Boolean read fSortFolderFirstAlways write
        SetSortFolderFirstAlways;
    property ThreadedDetails: Boolean read fThreadedDetails write
        SetThreadedDetails;
    property ThreadedEnumeration: Boolean read fThreadedEnumeration write
        SetThreadedEnumeration;
    property ThreadedImages: Boolean read fThreadedImages write SetThreadedImages;
    property Thumbnails: TCEThumbnailSettings read fThumbnails;
    property TrackChangesInMappedDrives: Boolean read fTrackChangesInMappedDrives
        write SetTrackChangesInMappedDrives;
    property Use_JumboIcons_in_InfoBar: Boolean read fUse_JumboIcons_in_InfoBar
        write SetUse_JumboIcons_in_InfoBar;
    property ViewStyle: TEasyListStyle read fViewStyle write fViewStyle;
  end;


var
  GlobalFileViewSettings: TCEFileViewSettings;

implementation

{$R *.dfm}

uses
  dCE_Actions, CE_VistaFuncs, fCE_FolderPanel, CE_CommonObjects, CE_SpTabBar,
  GR32_Math, Math, Main, ccClasses, ccStrings;

{*------------------------------------------------------------------------------
  Get's called when TCEFileViewPage is created.
-------------------------------------------------------------------------------}
constructor TCEFileViewPage.Create(AOwner: TComponent);
begin
  inherited;
  TCEFileViewPageSettings(Settings).FileViewPage:= Self;
  fThumbViewSize:= 100;
  fThumbPosition:= alBottom;
  fThumbViewStyle:= elsFilmStrip;
  Layout:= 'FileView';
  Images:= SmallSysImages;
  fShowCaptionsInFilmstrip:= false;
  fShowCaptionsInThumbnails:= true;
  fFileViewDragging:= false;

  // create FileView
  FileView:= TCEFileView.Create(Self);
  FileView.BeginUpdate;
  try
    fViewStyle:= FileView.View;
    FileView.View:= GlobalFileViewSettings.ViewStyle;
    FileView.Parent:= self;
    FileView.Align:= alClient;
    FileView.Themed:= false;
    FileView.BorderStyle:= bsNone;
    FileView.BoundsRect:= Rect(0,0, self.ClientWidth, self.ClientHeight);
    FileView.OnRootRebuild:= RootRebuild;
    FileView.OnRootChanging:= RootChanging;
    FileView.OnRootChange:= RootChange;
    FileView.OnItemSelectionsChanged:= ItemSelectionsChanged;
    FileView.OnColumnSizeChanged:= OnColumnSizeChanged;
    FileView.OnContextMenu:= OnContextMenu;
    FileView.OnItemContextMenu:= OnItemContextMenu;
    FileView.OnMouseDown:= OnMouseDown;
    FileView.OnMouseUp:= OnMouseUp;
    FileView.OnShellNotify:= OnShellNotify;
    FileView.OnEnumFinished:= OnEnumFinished;
    FileView.OnGetStorage:= OnGetStorage;
    FileView.OnViewStyleChange:= HandleViewStyleChange;
    FileView.OnResize:= HandleFileViewResize;
    FileView.FileObjects:= [foFolders,
                            foNonFolders];
    FileView.DragManager.MouseButton:= [cmbLeft,cmbRight];
    FileView.Selection.MouseButton:= [cmbLeft,cmbRight];
    FileView.ParentShowHint:= true;
    FileView.HintType:= ehtText;
    FileView.TabOrder:= 1;
    // translate header
    FileView.TranslateHeader:= false;

    FileView.PaintInfoGroup.BandThickness:= 2;
    FileView.PaintInfoGroup.BandColor:= clWindowText;
    FileView.PaintInfoGroup.BandColorFade:= clWindow;
    FileView.CompressedFile.Hilight:= false;
    FileView.EncryptedFile.Hilight:= false;
    FileView.GroupFont.Style:= [fsBold];
    SetDesktopIconFonts(FileView.Font);

    GlobalFocusCtrl.CtrlList.Add(FileView);
    FileView.OnMouseWheel:= GlobalFocusCtrl.DoMouseWheel;
    GlobalFileViewSettings.RegisterNotify(Self);

  finally
    FileView.EndUpdate;
  end;


  InfoBar:= TCEInfoBar.Create(nil);
  InfoBar.Parent:= Self;
  InfoBar.Align:= alBottom;
  InfoBar.Visible:= false;
  InfoBar.RowHeight:= SpGetControlTextHeight(InfoBar, InfoBar.Font) + 6;
  InfoBar.Height:= Max(GlobalFileViewSettings.InfoBarSize,InfoBar.RowHeight*3 + 6);

  InfoBarSplitter:= TSpTBXSplitter.Create(nil);
  InfoBarSplitter.Parent:= Self;
  InfoBarSplitter.Align:= alBottom;
  InfoBarSplitter.GripSize:= 0;
  InfoBarSplitter.MinSize:= InfoBar.RowHeight;
  InfoBarSplitter.Top:= InfoBar.BoundsRect.Top - InfoBarSplitter.Height;
  InfoBarSplitter.OnMouseUp:= InfoBarSplitterMouseUp;
  InfoBarSplitter.OnMoving:= InfoBarSplitterMoving;
  InfoBarSplitter.Visible:= false;

  ShowInfoBar:= false;

  GlobalFileViewSettings.AssignSettingsTo(Self);
  fShowItemContextMenu:= true;
end;

{*------------------------------------------------------------------------------
  Get's called when TCEFileViewPage is destoyed.
-------------------------------------------------------------------------------}
destructor TCEFileViewPage.Destroy;
begin
  if GlobalPathCtrl.ActivePage = Self then
  GlobalPathCtrl.ActivePage:= nil;
  //FileView.Free;
  InfoBar.Free;
  InfoBarSplitter.Free;
  inherited;
end;

{-------------------------------------------------------------------------------
  DragEnter
-------------------------------------------------------------------------------}
function TCEFileViewPage.DragEnter(const dataObj: IDataObject; grfKeyState:
    Longint; pt: TPoint; var dwEffect: Longint): HResult;
begin
  Result:= TCEFileViewHack(FileView).DropTarget.DragEnter(dataObj, grfKeyState, pt, dwEffect);
end;

{-------------------------------------------------------------------------------
  DragLeave
-------------------------------------------------------------------------------}
function TCEFileViewPage.DragLeave: HResult;
begin
  Result:= TCEFileViewHack(FileView).DropTarget.DragLeave;
end;

{-------------------------------------------------------------------------------
  DragOver
-------------------------------------------------------------------------------}
function TCEFileViewPage.DragOver(grfKeyState: Longint; pt: TPoint; var
    dwEffect: Longint): HResult;
begin
  Result:= TCEFileViewHack(FileView).DropTarget.DragOver(grfKeyState, pt, dwEffect);
end;

{-------------------------------------------------------------------------------
  Drop
-------------------------------------------------------------------------------}
function TCEFileViewPage.Drop(const dataObj: IDataObject; grfKeyState: Longint;
    pt: TPoint; var dwEffect: Longint): HResult;
begin
  Result:= TCEFileViewHack(FileView).DropTarget.Drop(dataObj, grfKeyState, pt, dwEffect);
end;

{*------------------------------------------------------------------------------
  Get's called when Global focus has changed
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.GlobalFocusChanged(Sender: TObject; NewPath:
    WideString);
begin
  // Do nothing
end;

{*------------------------------------------------------------------------------
  Get's called when Global path has changed (String)
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.GlobalPathChanged(Sender: TObject; NewPath:
    WideString);
begin
  FileView.BrowseTo(NewPath);
end;

{*------------------------------------------------------------------------------
  Get's called when Global path has changed (PIDL)
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.GlobalPIDLChanged(Sender: TObject; NewPIDL:
    PItemIDList);
begin
  fPathChanging:= true;
  FileView.Selection.ClearAll;
  FileView.BrowseToByPIDL(NewPIDL);
  if FileView.Selection.First <> nil then
  FileView.Selection.First.MakeVisible(emvMiddle);
end;

{-------------------------------------------------------------------------------
  Get's called on InfoBarSplitter MouseUp
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.InfoBarSplitterMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  InfoBar.RefreshThumbnail;
  GlobalFileViewSettings.InfoBarSize:= InfoBar.Height;
  InfoBar.Repaint;
end;

{-------------------------------------------------------------------------------
  Get's called on InfoBarSplitter Moving
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.InfoBarSplitterMoving(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin
  Accept:= NewSize > InfoBar.RowHeight;
  InfoBar.Paint;
end;

{*------------------------------------------------------------------------------
  Get's called on when item selection has changed
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.ItemSelectionsChanged(Sender: TCustomEasyListview);
var
  NS: TNamespace;
  Item: TEasyItem;
  lastItem, tmpItem: TEasyItem;
begin
//  if FileView.UpdateCount > 0 then
//  Exit;
  
  if assigned(FileView.Selection.FocusedItem) and (FileView.Selection.Count > 0) then
  Item:= FileView.Selection.FocusedItem
  else
  Item:= FileView.Selection.First;
  
  if Assigned(Item) then
  begin
    FileView.ValidateNamespace(Item, NS);
    if assigned(NS) then
    begin
      GlobalPathCtrl.ChangeFocusedPath(Self, NS.NameForParsing);
    end;
    if assigned(fQuickView) then
    fQuickView.ActiveFilePath:= NS.NameForParsing;

    // Change Info Bar
    if ShowInfoBar then
    begin
      if FileView.Selection.Count = 1 then
      begin
        InfoBar.LoadFromPIDL(NS.AbsolutePIDL, 1);
      end
      else
      begin
        lastItem:= nil;
        tmpItem:= FileView.Selection.First;
        while assigned(tmpItem) do
        begin
          lastItem:= tmpItem;
          tmpItem:= FileView.Selection.Next(tmpItem);
        end;
        FileView.ValidateNamespace(lastItem, NS);
        InfoBar.LoadFromPIDL(NS.AbsolutePIDL, FileView.Selection.Count);
      end;
    end;
  end
  else
  begin
    GlobalPathCtrl.ChangeFocusedPath(Self, '');
    if assigned(fQuickView) then
    fQuickView.Close;
    if ShowInfoBar then
    InfoBar.Clear;
  end;
end;

{*------------------------------------------------------------------------------
  Get's called on item mouse down.
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.OnMouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
begin
  fDownShiftState:= Shift;

  fShowItemContextMenu:= true;

  if Shift = [ssRight, ssAlt] then
  fShowItemContextMenu:= false
  else if FileView.UseMouseRocker then
  begin
    if (Button = mbLeft) and FileView.RightMouseButton_IsDown then
    fShowItemContextMenu:= false
    else if (Button = mbRight) and FileView.LeftMouseButton_IsDown then
    fShowItemContextMenu:= false
  end;
end;

{*------------------------------------------------------------------------------
  Get's called on item mouse up.
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.OnMouseUp(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
var
  NS, targetNS: TNamespace;
  item: TEasyItem;
  WindowPt: TPoint;
  freeTarget: Boolean;
begin
  if not FileView.DragInitiated and ((ssMiddle in fDownShiftState) or ((ssLeft in fDownShiftState) and (ssAlt in Shift))) then
  begin
    WindowPt := FileView.Scrollbars.MapWindowToView(Point(X,Y));
    item:= FileView.Groups.ItemByPoint(WindowPt);
    if assigned(item) and not FileView.EditManager.Editing then
    begin
      FileView.EditManager.EndEdit;
      FileView.ValidateNamespace(Item,NS);
      if assigned(NS) then
      begin
        if NS.Link and assigned(NS.ShellLink) then
        begin
          targetNS:= TNamespace.Create(PIDLMgr.CopyPIDL(NS.ShellLink.TargetIDList), nil);
          freeTarget:= true;
        end
        else
        begin
          targetNS:= NS;
          freeTarget:= false;
        end;

        try
          if targetNS.FileSystem and not targetNS.Folder then
          begin
            if ssShift in Shift then
            OpenFileInTab(targetNS.NameForParsing, not MainForm.TabSet.Settings.OpenTabSelect)
            else
            OpenFileInTab(targetNS.NameForParsing, MainForm.TabSet.Settings.OpenTabSelect)
          end
          else
          begin
            if ssShift in Shift then
            OpenFolderInTab(Self, targetNS.AbsolutePIDL, not MainForm.TabSet.Settings.OpenTabSelect)
            else
            OpenFolderInTab(Self, targetNS.AbsolutePIDL, MainForm.TabSet.Settings.OpenTabSelect)
          end;
        finally
          if freeTarget then
          targetNS.Free;
        end;            
      end;
    end;
  end
  else if (ssRight in fDownShiftState) and (Shift = [ssAlt]) then
  begin
    WindowPt := FileView.Scrollbars.MapWindowToView(Point(X,Y));
    item:= FileView.Groups.ItemByPoint(WindowPt);
    if assigned(item) and not FileView.EditManager.Editing then
    begin
      FileView.ValidateNamespace(Item,NS);
      if assigned(NS) then
      begin
        NS.ShowPropertySheet(MainForm);
      end;
    end;
    fShowItemContextMenu:= false;
  end;

  fDownShiftState:= [];
end;

{*------------------------------------------------------------------------------
  Get's called when root path is changing
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.RootChanging(Sender: TCustomVirtualExplorerEasyListview;
    const NewValue: TRootFolder; const CurrentNamespace, Namespace: TNamespace; var Allow: Boolean);
begin
  if Namespace <> nil then
  begin
    if GlobalPathCtrl.ActivePage = Self then
    begin
      if not fPathChanging then
      GlobalPathCtrl.ChangeGlobalPathPIDL(Self, Namespace.AbsolutePIDL);

      if not GlobalFileViewSettings.PerFolderSettings and FileView.Active then
      GlobalFileViewSettings.AssignColumnSettingsFrom(FileView);
    end;
  end;
  fPathChanging:= false;
end;

{*------------------------------------------------------------------------------
  Get's called when root path is changed
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.RootChange(
  Sender: TCustomVirtualExplorerEasyListview);
begin
  if not GlobalFileViewSettings.PerFolderSettings then
  GlobalFileViewSettings.AssignColumnSettingsTo(FileView);
end;

{*------------------------------------------------------------------------------
  Get's called on root rebuild
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.RootRebuild(Sender:
    TCustomVirtualExplorerEasyListview);
begin
  UpdateCaption;
  //GlobalPathCtrl.ChangeGlobalContent(Self);
end;

{*------------------------------------------------------------------------------
  Makes Self as a Active Component in GlobalPathCtrl
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.SelectPage;
var
  NS: TNamespace;
  Item: TEasyItem;
begin
  inherited;
  if not GlobalFileViewSettings.PerFolderSettings then
  begin
    // Save old tab's column settings
    if GlobalPathCtrl.ActivePage is TCEFileViewPage then
    GlobalFileViewSettings.AssignColumnSettingsFrom(TCEFileViewPage(GlobalPathCtrl.ActivePage).FileView);

    // Load column settings
    GlobalFileViewSettings.AssignColumnSettingsTo(FileView);
  end;
  // Set Page as active
  GlobalPathCtrl.ActivePage:= Self;
  GlobalPathCtrl.ChangeGlobalPathPIDL(Self, FileView.RootFolderNamespace.AbsolutePIDL);
  GlobalPathCtrl.GlobalPathCaption:= FileView.RootFolderNamespace.NameParseAddress;
  FileView.SetFocus;

  // Change focued path
  if assigned(FileView.Selection.FocusedItem) and (FileView.Selection.Count > 0) then
  Item:= FileView.Selection.FocusedItem
  else
  Item:= FileView.Selection.First;
  
  if Assigned(Item) then
  begin
    FileView.ValidateNamespace(Item, NS);
    if assigned(NS) then
    GlobalPathCtrl.ChangeFocusedPath(Self, NS.NameForParsing);
  end
  else
  GlobalPathCtrl.ChangeFocusedPath(Self, '');
end;

{*------------------------------------------------------------------------------
  Set Active value
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.SetActive(const Value: Boolean);
begin
  inherited;
  FileView.Active:= Value;
  if not GlobalFileViewSettings.PerFolderSettings then
  GlobalFileViewSettings.AssignColumnSettingsTo(FileView)
  else if Value then
  FileView.LoadFolderFromPropertyBag(true);
end;

{*------------------------------------------------------------------------------
  Update Caption
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.UpdateCaption;
begin
  TabCaption:= FileView.RootFolderNamespace.NameNormal;
  TCESpTabItem(TabItem).Images:= SmallSysImages;
  TCESpTabItem(TabItem).ImageIndex:= FileView.RootFolderNamespace.GetIconIndex(false, icSmall);
  TabItem.Hint:= FileView.RootFolderNamespace.NameParseAddress;
  if GlobalPathCtrl.ActivePage = Self then
  GlobalPathCtrl.GlobalPathCaption:= FileView.RootFolderNamespace.NameParseAddress;
end;

procedure TCEFileViewPage.View(Sender: TObject);
begin
  inherited;
end;

{*------------------------------------------------------------------------------
  Save Column settings
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.OnColumnSizeChanged(Sender: TCustomEasyListview;
    Column: TEasyColumn);
begin
  if not GlobalFileViewSettings.PerFolderSettings and
     (GlobalPathCtrl.ActivePage = Self) then
  GlobalFileViewSettings.AssignColumnSettingsFrom(FileView);
end;

{-------------------------------------------------------------------------------
  Get Settings Class
-------------------------------------------------------------------------------}
function TCEFileViewPage.GetSettingsClass: TCECustomTabPageSettingsClass;
begin
  Result:= TCEFileViewPageSettings;
end;

{-------------------------------------------------------------------------------
  Handle FileView Resize
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.HandleFileViewResize(Sender: TObject);
var
  h,w: Integer;
begin
  if fViewStyle = elsFilmStrip then
  begin
    if FileView.Header.ShowInAllViews then
    h:= FileView.ClientHeight-2 - FileView.Header.Height
    else
    h:= FileView.ClientHeight-2;

    w:= Round((h - (FileView.Canvas.TextHeight('|') * 2)) * 1.2);
    FileView.CellSizes.FilmStrip.SetSize(w, h);
  end;
end;

{-------------------------------------------------------------------------------
  Handle ViewChange
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.HandleViewStyleChange(Sender: TObject);
begin
  if fViewStyle = FileView.View then
  Exit;

  // save columns if needed
  if not GlobalFileViewSettings.PerFolderSettings and
     FileView.Active and ((fViewStyle = elsReport) or
     GlobalFileViewSettings.ShowHeaderAlways) then
  GlobalFileViewSettings.AssignColumnSettingsFrom(FileView);

  fViewStyle:= FileView.View;

  // show quickview
  if fViewStyle = elsFilmStrip then
  begin
    FileView.PaintInfoItem.HideCaption:= not fShowCaptionsInFilmstrip;
    
    if not assigned(fQuickView) then
    begin
      fQuickView:= TCEQuickView.Create(self);
      fQuickView.Parent:= self;
      fQuickView.Align:= alClient;
      fQuickview.Active:= true;
    end;

    FileView.Align:= fThumbPosition;
    if fThumbViewSize < 20 then
    fThumbViewSize:= 20;

    if (fThumbPosition = alTop) or (fThumbPosition = alBottom) then
    begin
      FileView.Height:= fThumbViewSize;
    end
    else
    begin
      FileView.Width:= fThumbViewSize;
    end;
    QuickViewSplitter.Align:= fThumbPosition;
    QuickViewSplitter.Visible:= true;

    case fThumbPosition of
      alLeft: QuickViewSplitter.Left:= FileView.BoundsRect.Right;
      alRight: QuickViewSplitter.Left:= FileView.BoundsRect.Left-QuickViewSplitter.Width;
      alTop: QuickViewSplitter.Top:= FileView.BoundsRect.Bottom;
      alBottom: QuickViewSplitter.Top:= FileView.BoundsRect.Top-QuickViewSplitter.Height;
    end;
  end
  // hide quickview
  else
  begin
    if fViewStyle = elsThumbnail then
    FileView.PaintInfoItem.HideCaption:= not fShowCaptionsInThumbnails
    else
    FileView.PaintInfoItem.HideCaption:= false;

    FileView.Align:= alClient;

    if assigned(fQuickView) then
    begin
      FreeAndNil(fQuickView);
    end;
    QuickViewSplitter.Visible:= false;

    // load columns if needed
    if not GlobalFileViewSettings.PerFolderSettings and FileView.Active and
      ((fViewStyle = elsReport) or GlobalFileViewSettings.ShowHeaderAlways) then
    GlobalFileViewSettings.AssignColumnSettingsTo(FileView);
  end;

  GlobalFileViewSettings.ViewStyle:= fViewStyle;
end;

{*------------------------------------------------------------------------------
  Hide page
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.HidePage;
begin
  inherited;
end;

{*------------------------------------------------------------------------------
  Set Thumbnail Position
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.SetThumbPosition(const Value: TAlign);
begin
  if fThumbPosition = Value then Exit;

  case Value of
    alNone, alClient, alCustom: fThumbPosition:= alBottom;
    else
    fThumbPosition:= Value;
  end;

  if fViewStyle = elsFilmStrip then
  begin
    FileView.Align:= fThumbPosition;
    if (fThumbPosition = alTop) or (fThumbPosition = alBottom) then
    begin
      FileView.Height:= fThumbViewSize;
    end
    else
    begin
      FileView.Width:= fThumbViewSize;
    end;
    
    QuickViewSplitter.Align:= fThumbPosition;
    case fThumbPosition of
      alLeft: QuickViewSplitter.Left:= FileView.BoundsRect.Right;
      alRight: QuickViewSplitter.Left:= FileView.BoundsRect.Left-QuickViewSplitter.Width;
      alTop: QuickViewSplitter.Top:= FileView.BoundsRect.Bottom;
      alBottom: QuickViewSplitter.Top:= FileView.BoundsRect.Top-QuickViewSplitter.Height;
    end;
  end;

  GlobalFileViewSettings.AssignSettingsFrom(Self);
end;

{*------------------------------------------------------------------------------
  Set View Style
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.SetViewStyle(const Value: TEasyListStyle);
begin
  if Value <> FileView.View then
  begin
    FileView.View:= Value;
  end;
end;

{*------------------------------------------------------------------------------
  QuickView Splitter Moved
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.QuickViewSplitterMoved(Sender: TObject);
begin
  if fViewStyle = elsFilmStrip then
  begin
    if (fThumbPosition = alTop) or (fThumbPosition = alBottom) then
    fThumbViewSize:= FileView.Height
    else
    fThumbViewSize:= FileView.Width;

    GlobalFileViewSettings.AssignSettingsFrom(Self);
  end;
end;

{*------------------------------------------------------------------------------
  Set Thumbnail View Style
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.SetThumbViewStyle(const Value: TEasyListStyle);
begin
  fThumbViewStyle:= Value;
  if fViewStyle = elsFilmStrip then
  begin
    FileView.View:= Value;
  end;
  
  GlobalFileViewSettings.AssignSettingsFrom(Self);
end;

{*------------------------------------------------------------------------------
  Get's called on background context menu
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.OnContextMenu(Sender: TCustomEasyListview; MousePt:
    TPoint; var Handled: Boolean);
var
  menu: TCEBackContextMenu;
  item: TEasyItem;
begin
  if fShowItemContextMenu then
  begin
    CEActions.UpdateAll;
    menu:= TCEBackContextMenu.Create;
    try
      menu.UpperMenuItems:= CEActions.BackgroundCMItems_up;
      menu.LowerMenuItems:= CEActions.BackgroundCMItems_down;

      if menu.ShowMenu(MousePt, FileView.RootFolderNamespace, FileView) then
      begin
        item:= TCEFileViewHack(FileView).RereadAndRefresh(False);
        if Assigned(item) then
        begin
          FileView.Selection.SelectRange(item,item,false,true);
          FileView.Selection.FocusedItem:= item;
          item.Edit(nil);
        end;
      end;
    finally
      menu.Free;
      Handled:= true;
    end;
  end;
end;

{-------------------------------------------------------------------------------
  On Item ContextMenu
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.OnItemContextMenu(Sender: TCustomEasyListview;
    HitInfo: TEasyHitInfoItem; WindowPoint: TPoint; var Menu: TPopupMenu; var
    Handled: Boolean);
begin
  if not Handled then
  Handled:= not fShowItemContextMenu;
end;

{-------------------------------------------------------------------------------
  On Shell Notify
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.OnShellNotify(Sender:
    TCustomVirtualExplorerEasyListview; ShellEvent: TVirtualShellEvent);
begin
  case ShellEvent.ShellNotifyEvent of
    vsneUpdateDir: begin
      if ShowInfoBar and assigned(InfoBar.LatestNS) then
      ItemSelectionsChanged(FileView);
    end;
    vsneUpdateItem: begin
      if Self.Visible and PIDLMgr.EqualPIDL(ShellEvent.PIDL1, FileView.RootFolderNamespace.AbsolutePIDL) then
      GlobalPathCtrl.ChangeGlobalContent(Self);
    end;
  end;
end;

{-------------------------------------------------------------------------------
  Load from stream
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.LoadFromStream(AStream: TStream);
var
  CustomPIDL: PItemIDList;
begin
  CustomPIDL:= PIDLMgr.LoadFromStream(AStream);
  if Assigned(CustomPIDL) then
  begin
    FileView.RootFolderCustomPIDL:= CustomPIDL;
  end;
  PIDLMgr.FreePIDL(CustomPIDL);
end;

{-------------------------------------------------------------------------------
  On EnumFinished
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.OnEnumFinished(Sender:
    TCustomVirtualExplorerEasyListview);
begin
  GlobalPathCtrl.ChangeGlobalContent(Self);
end;

{-------------------------------------------------------------------------------
  Save to stream
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.SaveToStream(AStream: TStream);
begin
  PIDLMgr.SaveToStream(AStream, FileView.RootFolderCustomPIDL);
end;

{-------------------------------------------------------------------------------
  Set Show InfoBar
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.SetShowInfoBar(const Value: Boolean);
var
  NS: TNamespace;
  Item: TEasyItem;
begin
  if fShowInfoBar <> Value then
  begin
    fShowInfoBar:= Value;
    if fShowInfoBar then
    begin
      InfoBar.Visible:= true;
      InfoBar.Top:= Self.BoundsRect.Bottom;
      InfoBarSplitter.Top:= InfoBar.Top - InfoBarSplitter.Height;
      InfoBarSplitter.Visible:= true;
      InfoBar.Height:= GlobalFileViewSettings.InfoBarSize;

      if FileView.Selection.Count > 1 then
      Item:= FileView.Selection.FocusedItem
      else
      Item:= FileView.Selection.First;

      if FileView.ValidateNamespace(Item, NS) then
      InfoBar.LoadFromPIDL(NS.AbsolutePIDL);
    end
    else
    begin
      InfoBar.Visible:= false;
      InfoBar.Clear;
      InfoBarSplitter.Visible:= false;
    end;
  end;
end;

{-------------------------------------------------------------------------------
  Show Header Selector
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.ShowHeaderSelector;
begin
  FileView.ShowHeaderSelector;
end;

{-------------------------------------------------------------------------------
  On Get Storage
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.OnGetStorage(Sender:
    TCustomVirtualExplorerEasyListview; var Storage: TRootNodeStorage);
begin
  Storage:= GlobalFileViewSettings.Storage;
end;

{-------------------------------------------------------------------------------
  Set ShowCaptionsInFilmstrip
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.SetShowCaptionsInFilmstrip(const Value: Boolean);
begin
  fShowCaptionsInFilmstrip:= Value;
  if fViewStyle = elsFilmStrip then
  FileView.PaintInfoItem.HideCaption:= not fShowCaptionsInFilmstrip;
end;

{-------------------------------------------------------------------------------
  Set ShowCaptionsInThumbnails
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.SetShowCaptionsInThumbnails(const Value: Boolean);
begin
  fShowCaptionsInThumbnails:= Value;
  if fViewStyle = elsThumbnail then
  FileView.PaintInfoItem.HideCaption:= not fShowCaptionsInThumbnails;
end;

{-------------------------------------------------------------------------------
  Set ThumbViewSize
-------------------------------------------------------------------------------}
procedure TCEFileViewPage.SetThumbViewSize(const Value: Integer);
begin
  fThumbViewSize:= Value;
  if fViewStyle = elsFilmStrip then
  begin
    if (fThumbPosition = alTop) or (fThumbPosition = alBottom) then
    begin
      FileView.Height:= fThumbViewSize;
    end
    else
    begin
      FileView.Width:= fThumbViewSize;
    end;
  end;
end;

{##############################################################################}

{*------------------------------------------------------------------------------
  Create an instance of TCEFileViewSettings
-------------------------------------------------------------------------------}
constructor TCEFileViewSettings.Create;
begin
  inherited;
  // create instances
  fStorage:= TRootNodeStorage.Create;
  // initialize values
  fUpdateCount:= 0;
  NotifyList:= TComponentList.Create(false);
  fColumns:= TCEColumnSettings.Create;
  fGroupBy:= TCEGroupBySettings.Create;
  fCellSizes:= TCECellSizeSettings.Create;
  fFilmstrip:= TCEFilmstripSettings.Create;
  Filmstrip.ThumbPos:= alBottom;
  Filmstrip.ThumbSize:= 120;
  fRememberInnerToolbarLayout:= true;
  fInfoBarSize:= 3;
  fShowInfoTips:= true;
  fBrowseZipFolders:= false;
  fSingleClickBrowse:= false;
  fFileSizeFormat:= vfsfDefault;
  fArrowBrowse:= true;
  fFolderUpOnDblClick:= true;
  fFullRowDblClick:= false;
  fSelectPasted:= true;
  fSortAfterPaste:= true;
  fPerFolderSettings:= false;
  fStorageFilePath:= '';
  fStorageIsLoaded:= false;
  fShowCaptionsInFilmstrip:= true;
  fShowCaptionsInThumbnails:= true;
  fFullRowContextMenu:= false;
  fBackgroundColor:= clWindow;
  fFont:= TFont.Create;
  SetDesktopIconFonts(fFont);
  fThumbnails:= TCEThumbnailSettings.Create;
  fHideShortcutExtension:= true;
  fTrackChangesInMappedDrives:= true;
end;

{*------------------------------------------------------------------------------
  Destroy an instance of TCEFileViewSettings
-------------------------------------------------------------------------------}
destructor TCEFileViewSettings.Destroy;
begin
  NotifyList.Free;
  fColumns.Free;
  fGroupBy.Free;
  fCellSizes.Free;
  fFilmstrip.Free;
  fStorage.Free;
  fFont.Free;
  fThumbnails.Free;
  inherited;
end;

{*------------------------------------------------------------------------------
  Assign options from FileView.
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.AssignSettingsFrom(FileViewPage: TCEFileViewPage);
begin
  if fUpdateCount > 0 then
  Exit;
  
  if not assigned(FileViewPage) then
  Exit;

  ViewStyle:= FileViewPage.ViewStyle;
  Filmstrip.ThumbPos:= FileViewPage.ThumbPosition;
  Filmstrip.ThumbSize:= FileViewPage.ThumbViewSize;
end;

{*------------------------------------------------------------------------------
  Assign options to FileView.
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.AssignSettingsTo(ATo: TComponent;
    AssignColumnSettings: Boolean = true);

  procedure AssignExtensionColors(AFileView: TCEFileView; const AColors: WideString);
  var
    i: Integer;
    list: TCCStringList;
    value, ws: WideString;
    color: TColor;
    isBold, isItalic, isUnderline, isEnabled: Boolean;
  begin
    AFileView.ExtensionColorCodeList.Clear;
    list:= TCCStringList.Create;
    try
      list.Delimiter:= '|';
      list.DelimitedText:= AColors;
      for i:= 0 to list.Count - 1 do
      begin
        ws:= list.Strings[i];
        value:= WideGetNextItem(ws, ',');
        if value <> '' then
        begin
          color:= StrToIntDef(WideGetNextItem(ws, ','), AFileView.Font.Color);
          if color = clDefault then
          color:= fFont.Color;
          
          AFileView.ExtensionColorCodeList.Add('.' + value, // extension
            color, // color
            StrToBoolDef(WideGetNextItem(ws, ','), false),  // bold
            StrToBoolDef(WideGetNextItem(ws, ','), false),  // italic
            StrToBoolDef(WideGetNextItem(ws, ','), false),  // underline
            true);                                          // enabled
        end;
      end;
    finally
      list.Free;
    end;
  end;

var
  options: TVirtualEasyListviewOptions;
  fileViewPage: TCEFileViewPage;
  fileView: TCEFileView;
  textHeight: Integer;
begin
  if not assigned(ATo) then
  Exit;

  Self.BeginUpdate;

  fileView:= nil;
  fileViewPage:= nil;

  if ATo is TCEFileView then
  fileView:= TCEFileView(ATo)
  else if ATo is TCEFileViewPage then
  begin
    fileViewPage:= TCEFileViewPage(ATo);
    fileView:= fileViewPage.FileView;
  end;

  // FileViewPage
  if assigned(fileViewPage) then
  begin
    fileViewPage.ThumbViewSize:= Filmstrip.ThumbSize;
    fileViewPage.ThumbPosition:= Filmstrip.ThumbPos;
    fileViewPage.InfoBar.CalculateHiddenItems:= fHiddenFiles;
    fileViewPage.ShowInfoBar:= fShowInfoBar;
    fileViewPage.InfoBar.Height:= fInfoBarSize;
    fileViewPage.InfoBar.UseJumboIcons:= fUse_JumboIcons_in_InfoBar;
    fileViewPage.ShowCaptionsInFilmstrip:= fShowCaptionsInFilmstrip;
    fileViewPage.ShowCaptionsInThumbnails:= fShowCaptionsInThumbnails;
    fileViewPage.FileView.PerFolderSettings:= fPerFolderSettings;
  end;

  // FileView
  if assigned(fileView) then
  begin
    fileView.BeginUpdate;
    try
    // ==== Toggles ====
      fileView.SmoothScroll:= fSmoothScroll;
      if fHiddenFiles then
      fileView.FileObjects:= [foFolders,foNonFolders,foHidden] //,foShareable,foNetworkPrinters]
      else
      fileView.FileObjects:= [foFolders,foNonFolders]; //,foShareable,foNetworkPrinters];
      fileView.Header.ShowInAllViews:= fShowHeaderAlways;
      if fShowHeaderAlways then
      fileView.Header.Visible:= true;
      fileView.Selection.FullRowSelect:= fFullRowSelect;
      fileView.ShowExtension:= fShowExtensions;
      fileView.SelectPreviousFolder:= fSelectPreviousFolder;
      fileView.AutoSelectFirstItem:= fAutoSelectFirstItem;
      fileView.AutosizeListViewStyle:= fAutosizeListViewStyle;
      fileView.SortFolderFirstAlways:= fSortFolderFirstAlways;
      fileView.SingleClickBrowse:= fSingleClickBrowse;
      fileView.SingleClickExecute:= fSingleClickExecute;
      fileView.CheckBoxSelection:= fCheckBoxSelection;
      fileView.PaintInfoItem.GridLines:= fShowGridLines;
      fileView.FolderUpOnDblClick:= fFolderUpOnDblClick;
      fileView.FullRowDblClick:= fFullRowDblClick;
      fileView.SelectPasted:= fSelectPasted;
      fileView.SortAfterPaste:= fSortAfterPaste;
      fileView.FullRowContextMenu:= fFullRowContextMenu;
      fileView.ArrowBrowse:= fArrowBrowse;
      fileView.HideShortcutExtension:= fHideShortcutExtension;

    // ==== Options ====
      options:= fileView.Options;
      if fBrowseZipFolders then Include(options, eloBrowseExecuteZipFolder) else Exclude(options, eloBrowseExecuteZipFolder);
      if fThreadedImages then Include(options, eloThreadedImages) else Exclude(options, eloThreadedImages);
      if fThreadedEnumeration then Include(options, eloThreadedEnumeration) else Exclude(options, eloThreadedEnumeration);
      if fThreadedDetails then Include(options, eloThreadedDetails) else Exclude(options, eloThreadedDetails);
      if fShowInfoTips then Include(options, eloQueryInfoHints) else Exclude(options, eloQueryInfoHints);
      if fTrackChangesInMappedDrives then Include(options, eloTrackChangesInMappedDrives) else Exclude(options, eloTrackChangesInMappedDrives);
      fileView.Options:= options;

    // ==== Misc ====

      // display
      fileView.FileSizeFormat:= fFileSizeFormat;

      if fBackgroundColor = clDefault then
      fileView.Color:= clWindow
      else
      fileView.Color:= fBackgroundColor;
      fileView.Font.Assign(fFont);
      // colors
      fileView.ExtensionColorCode:= fExtensionColorsEnabled;
      if fExtensionColorsEnabled then
      AssignExtensionColors(fileView, fExtensionColors);
      // thumbnails
      fileView.ThumbsManager.AutoLoad:= Thumbnails.fUseStorage;
      fileView.ThumbsManager.AutoSave:= Thumbnails.fUseStorage;
      fileView.ThumbsManager.LoadAllAtOnce:= Thumbnails.fLoadAllAtOnce;
      
      if Thumbnails.fMaxThumbHeight <= 0 then
      fileView.ThumbsManager.MaxThumbHeight:= 2048
      else
      fileView.ThumbsManager.MaxThumbHeight:= Thumbnails.fMaxThumbHeight;

      if Thumbnails.fMaxThumbWidth <= 0 then
      fileView.ThumbsManager.MaxThumbWidth:= 2048
      else
      fileView.ThumbsManager.MaxThumbWidth:= Thumbnails.fMaxThumbWidth;

      fileView.ThumbsManager.StorageCompressed:= Thumbnails.StorageCompressed;
      fileView.ThumbsManager.StorageFilename:= Thumbnails.StorageFilename;
      if Thumbnails.StorageRepositoryFolder <> '' then
      fileView.ThumbsManager.StorageRepositoryFolder:= Thumbnails.StorageRepositoryFolder
      else
      fileView.ThumbsManager.StorageRepositoryFolder:= SettingsDirPath + 'Thumbnails\';
      fileView.ThumbsManager.StorageType:= Thumbnails.StorageType;
      fileView.ThumbsManager.Stretch:= Thumbnails.fStretch;
      fileView.ThumbsManager.UseExifThumbnail:= Thumbnails.fUseExifThumbnail;
      fileView.ThumbsManager.UseExifOrientation:= Thumbnails.fUseExifOrientation;
      fileView.ThumbsManager.UseFoldersShellExtraction:= Thumbnails.fUseFoldersShellExtraction;
      fileView.ThumbsManager.UseShellExtraction:= Thumbnails.fUseShellExtraction;
      fileView.ThumbsManager.UseSubsampling:= Thumbnails.fUseSubsampling;


    // ==== Cell Sizes ====
      textHeight:= fileView.Canvas.TextHeight('|');

      // Large icons
      if (CellSizes.LargeIcons_Width < 1) or (CellSizes.LargeIcons_Height < 1) then
      begin
        fileView.CellSizes.Icon.RestoreDefaults;
        
        if CellSizes.LargeIcons_Width > 0 then
        fileView.CellSizes.Icon.Width:= CellSizes.LargeIcons_Width;

        if CellSizes.LargeIcons_Height > 0 then
        fileView.CellSizes.Icon.Height:= CellSizes.LargeIcons_Height
        else
        fileView.CellSizes.Icon.Height:= Max((textHeight*2) + 48, fileView.CellSizes.Icon.Height);
      end
      else
      fileView.CellSizes.Icon.SetSize(CellSizes.LargeIcons_Width, CellSizes.LargeIcons_Height);

      // Small Icons
      if (CellSizes.SmallIcons_Width < 1) or (CellSizes.SmallIcons_Height < 1) then
      begin
        fileView.CellSizes.SmallIcon.RestoreDefaults;
        if CellSizes.SmallIcons_Width > 0 then
        fileView.CellSizes.SmallIcon.Width:= CellSizes.SmallIcons_Width;

        if CellSizes.SmallIcons_Height > 0 then
        fileView.CellSizes.SmallIcon.Height:= CellSizes.SmallIcons_Height
        else
        fileView.CellSizes.SmallIcon.Height:= Max(textHeight, 18);
      end
      else
      fileView.CellSizes.SmallIcon.SetSize(CellSizes.SmallIcons_Width, CellSizes.SmallIcons_Height);

      // List
      if (CellSizes.List_Width < 1) or (CellSizes.List_Height < 1) then
      begin
        fileView.CellSizes.List.RestoreDefaults;
        if CellSizes.List_Width > 0 then
        fileView.CellSizes.List.Width:= CellSizes.List_Width;

        if CellSizes.List_Height > 0 then
        fileView.CellSizes.List.Height:= CellSizes.List_Height
        else
        fileView.CellSizes.List.Height:= Max(textHeight, 18);
      end
      else
      fileView.CellSizes.List.SetSize(CellSizes.List_Width, CellSizes.List_Height);

      // Details
      if (CellSizes.Details_Width < 1) or (CellSizes.Details_Height < 1) then
      begin
        fileView.CellSizes.Report.RestoreDefaults;
        if CellSizes.Details_Width > 0 then
        fileView.CellSizes.Report.Width:= CellSizes.Details_Width;

        if CellSizes.Details_Height > 0 then
        fileView.CellSizes.Report.Height:= CellSizes.Details_Height
        else
        fileView.CellSizes.Report.Height:= Max(textHeight, 18);
      end
      else
      fileView.CellSizes.Report.SetSize(CellSizes.Details_Width, CellSizes.Details_Height);

      // Tiles
      if (CellSizes.Tiles_Width < 1) or (CellSizes.Tiles_Height < 1) then
      begin
        fileView.CellSizes.Tile.RestoreDefaults;
        
        if CellSizes.Tiles_Width > 0 then
        fileView.CellSizes.Tile.Width:= CellSizes.Tiles_Width;

        if CellSizes.Tiles_Height > 0 then
        fileView.CellSizes.Tile.Height:= CellSizes.Tiles_Height
        else
        fileView.CellSizes.Tile.Height:= Max((textHeight*3) + 8, fileView.CellSizes.Tile.Height);
      end
      else
      fileView.CellSizes.Tile.SetSize(CellSizes.Tiles_Width, CellSizes.Tiles_Height);

      // Thumbnails
      if (CellSizes.Thumbnails_Width < 1) or (CellSizes.Thumbnails_Height < 1) then
      begin
        fileView.CellSizes.Thumbnail.RestoreDefaults;
        
        if CellSizes.Thumbnails_Width > 0 then
        fileView.CellSizes.Thumbnail.Width:= CellSizes.Thumbnails_Width;

        if CellSizes.Thumbnails_Height > 0 then
        fileView.CellSizes.Thumbnail.Height:= CellSizes.Thumbnails_Height
        else
        begin
          fileView.CellSizes.Thumbnail.Height:= (textHeight*2) + fileView.CellSizes.Thumbnail.Width;
        end;
      end
      else
      fileView.CellSizes.Thumbnail.SetSize(CellSizes.Thumbnails_Width, CellSizes.Thumbnails_Height);

      // Filmstrip
      if not assigned(fileViewPage) then
      begin
        if (CellSizes.Filmstrip_Width < 1) or (CellSizes.Filmstrip_Height < 1) then
        begin
          fileView.CellSizes.Thumbnail.RestoreDefaults;
        
          if CellSizes.Filmstrip_Width > 0 then
          fileView.CellSizes.FilmStrip.Width:= CellSizes.Filmstrip_Width;

          if CellSizes.Filmstrip_Height > 0 then
          fileView.CellSizes.FilmStrip.Height:= CellSizes.Filmstrip_Height
          else
          begin
            fileView.CellSizes.FilmStrip.Height:= (textHeight*2) + fileView.CellSizes.FilmStrip.Width;
          end;
        end
        else
        fileView.CellSizes.FilmStrip.SetSize(CellSizes.Filmstrip_Width, CellSizes.Filmstrip_Height);
      end;

      // Column settings
      if not PerFolderSettings and AssignColumnSettings then
      AssignColumnSettingsTo(FileView);
    finally
      fileView.EndUpdate(not (assigned(FileViewPage) and not FileViewPage.Visible));
    end;
  end;

  Self.EndUpdate;
end;

{*------------------------------------------------------------------------------
  Save Settings From ActivePage
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.AssignFromActivePage;
begin
  if GlobalPathCtrl.ActivePage is TCEFileViewPage then
  begin
    AssignSettingsFrom(TCEFileViewPage(GlobalPathCtrl.ActivePage));
    InfoBarSize:= TCEFileViewPage(GlobalPathCtrl.ActivePage).InfoBar.Height;
  end;
end;

{*------------------------------------------------------------------------------
  Register Notify
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.RegisterNotify(AView: TComponent);
begin
  NotifyList.Add(AView);
end;

{*------------------------------------------------------------------------------
  Restore Column Settings
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.AssignColumnSettingsTo(FileView:
    TVirtualExplorerEasyListview);
var
  i: Integer;
  col: TEasyColumn;
  settings: PCEColSettings;
  grouping: PCEGroupBySetting;
begin
  if not assigned(FileView) then
  Exit;
  
  if FileView.RootFolderNamespace.IsMyComputer then
  begin
    settings:= @Columns.MyComputerColSettings;
    grouping:= @GroupBy.MyComputerGroupBySettings;
  end
  else if FileView.RootFolderNamespace.IsControlPanel or FileView.RootFolderNamespace.IsControlPanelChildFolder(false) then
  begin
    settings:= @Columns.ControlPanelColSettings;
    grouping:= @GroupBy.ControlPanelGroupBySettings;
  end
  else if FileView.RootFolderNamespace.IsNetworkNeighborhood or FileView.RootFolderNamespace.IsNetworkNeighborhoodChild then
  begin
    settings:= @Columns.NetworkColSettings;
    grouping:= @GroupBy.NetworkGroupBySettings;
  end
  else
  begin
    settings:= @Columns.DefaultColSettings;
    grouping:= @GroupBy.DefaultGroupBySettings;
  end;

  FileView.GroupingColumn:= grouping.Index;
  FileView.Grouped:= grouping.Enabled;

  if Length(settings^) = 0 then
  Exit;

  FileView.Header.Columns.BeginUpdate(false);
  try
    for i:= 0 to FileView.Header.Columns.Count - 1 do
    begin
      if FileView.Header.Columns.Columns[i].Visible then
      FileView.Header.Columns.Columns[i].Visible:= false;
    end;

    for i:= 0 to Length(settings^) - 1 do
    begin
      if settings^[i].Index < FileView.Header.Columns.Count then
      begin
        col:= FileView.Header.Columns.Columns[settings^[i].Index];
        col.Visible:= true;
        col.Position:= settings^[i].Position;
        col.Width:= settings^[i].Width;
        col.SortDirection:= settings^[i].Sort;
      end;
    end;


  finally
    FileView.Header.Columns.EndUpdate(true);
  end;
end;

{*------------------------------------------------------------------------------
  Send Changes
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SendChanges;
var
  i: Integer;
  fileView: TCEFileView;
  doRebuild: Boolean;
begin
  if fUpdateCount > 0 then
  Exit;
  
  for i:= 0 to NotifyList.Count - 1 do
  begin
    if (NotifyList.Items[i] is TCEFileViewPage) or (NotifyList.Items[i] is TCEFileView) then
    begin
      if (NotifyList.Items[i] is TCEFileViewPage) then
      fileView:= TCEFileViewPage(NotifyList.Items[i]).FileView
      else
      fileView:= TCEFileView(NotifyList.Items[i]);
      
      doRebuild:= fileView.ShowExtension <> ShowExtensions;
      AssignSettingsTo(NotifyList.Items[i], false);
      if CellSizes.IsChanged(fileView) then
      fileView.Groups.Rebuild;
      if doRebuild then
      fileView.Rebuild;
    end
    else if NotifyList.Items[i] is TVirtualExplorerTree then
    begin
      if fHiddenFiles then
      TVirtualExplorerTree(NotifyList.Items[i]).FileObjects:= [foFolders,foNonFolders,foHidden] //,foShareable,foNetworkPrinters]
      else
      TVirtualExplorerTree(NotifyList.Items[i]).FileObjects:= [foFolders,foNonFolders];
    end

  end;
  CEFolderPanel.FolderTree.HiddenFiles:= fHiddenFiles;
end;

{*------------------------------------------------------------------------------
  Set Full Row select
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetFullRowSelect(const Value: Boolean);
begin
  fFullRowSelect:= Value;
  SendChanges;
end;

{*------------------------------------------------------------------------------
  Set Hidden Files
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetHiddenFiles(const Value: Boolean);
begin
  fHiddenFiles:= Value;
  SendChanges;
end;

{*------------------------------------------------------------------------------
  Set ShowExtensions
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetShowExtensions(const Value: Boolean);
begin
  fShowExtensions:= Value;
  SendChanges;

  if GlobalPathCtrl.ActivePage is TCEFileViewPage then
  begin
    TCEFileViewPage(GlobalPathCtrl.ActivePage).FileView.Refresh;
  end
end;

{*------------------------------------------------------------------------------
  Set Show Header Always
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetShowHeaderAlways(const Value: Boolean);
begin
  fShowHeaderAlways:= Value;
  SendChanges;
end;

{*------------------------------------------------------------------------------
  Set Smooth Scroll
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetSmoothScroll(const Value: Boolean);
begin
  fSmoothScroll:= Value;
  SendChanges;
end;

{*------------------------------------------------------------------------------
  Save Column Settings
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.AssignColumnSettingsFrom(FileView:
    TVirtualExplorerEasyListview);
var
  col: TEasyColumn;
  i,c: Integer;
  settings: PCEColSettings;
  grouping: PCEGroupBySetting;
begin
  if not assigned(FileView) then
  Exit;

  if FileView.RootFolderNamespace.IsMyComputer then
  begin
    settings:= @Columns.MyComputerColSettings;
    grouping:= @GroupBy.MyComputerGroupBySettings;
  end
  else if FileView.RootFolderNamespace.IsControlPanel or FileView.RootFolderNamespace.IsControlPanelChildFolder(false) then
  begin
    settings:= @Columns.ControlPanelColSettings;
    grouping:= @GroupBy.ControlPanelGroupBySettings;
  end
  else if FileView.RootFolderNamespace.IsNetworkNeighborhood or FileView.RootFolderNamespace.IsNetworkNeighborhoodChild then
  begin
    settings:= @Columns.NetworkColSettings;
    grouping:= @GroupBy.NetworkGroupBySettings;
  end
  else
  begin
    settings:= @Columns.DefaultColSettings;
    grouping:= @GroupBy.DefaultGroupBySettings;
  end;
  
  c:= 0;
  for i:= 0 to FileView.Header.Columns.Count - 1 do
  begin
    if FileView.Header.Columns.Columns[i].Visible then
    Inc(c,1);
  end;

  if Length(settings^) <> c then
  SetLength(settings^, c);
  
  i:= 0;

  col:= FileView.Header.FirstVisibleColumn;
  while assigned(col) do
  begin
    settings^[i].Index:= col.Index;
    settings^[i].Position:= col.Position;
    settings^[i].Width:= col.Width;
    settings^[i].Sort:= col.SortDirection;
    col:= FileView.Header.NextVisibleColumn(col);
    inc(i);
  end;

  grouping.Index:= FileView.GroupingColumn;
  grouping.Enabled:= FileView.Grouped;
end;

{-------------------------------------------------------------------------------
  Begin Update
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.BeginUpdate;
begin
  fUpdateCount:= fUpdateCount + 1;
end;

{-------------------------------------------------------------------------------
  End Update
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.EndUpdate(ASendChanges: Boolean = false);
begin
  fUpdateCount:= fUpdateCount - 1;
  if fUpdateCount < 0 then
  fUpdateCount:= 0;

  if (fUpdateCount = 0) and ASendChanges then
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Clear filters from all FileViews
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.ClearFilters;
var
  i,i2: Integer;
  FileViewPage: TCEFileViewPage;
begin
  for i:= 0 to NotifyList.Count - 1 do
  begin
    if NotifyList.Items[i] is TCEFileViewPage then
    begin
      FileViewPage:= TCEFileViewPage(NotifyList.Items[i]);
      FileViewPage.FileView.BeginUpdate;
      try
        for i2:= 0 to FileViewPage.FileView.ItemCount - 1 do
        begin
          FileViewPage.FileView.Items.Items[i2].Visible:= true;
        end;
        FileViewPage.FileView.BackGround.Enabled:= false;
      finally
        FileViewPage.FileView.EndUpdate;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------
  Load Storage
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.LoadStorage;
begin
  try
    fStorageIsLoaded:= true;
    if WideFileExists(StorageFilePath) then
    Storage.LoadFromFile(StorageFilePath);
  except
    // catch exceptions
  end;
end;

{-------------------------------------------------------------------------------
  Save Storage
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SaveStorage;
begin
  try
    Storage.SaveToFile(StorageFilePath);
  except
    // catch exceptions
  end;
end;

{-------------------------------------------------------------------------------
  Set ArrowBrowse
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetArrowBrowse(const Value: Boolean);
begin
  fArrowBrowse:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set SelectPreviousFolder
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetSelectPreviousFolder(const Value: Boolean);
begin
  fSelectPreviousFolder:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set SelectPreviousFolder
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetAutoSelectFirstItem(const Value: Boolean);
begin
  fAutoSelectFirstItem:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set AutosizeListViewStyle
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetAutosizeListViewStyle(const Value: Boolean);
begin
  fAutosizeListViewStyle:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set BackgroundColor
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetBackgroundColor(const Value: TColor);
begin
  fBackgroundColor:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set BrowseZipFolders
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetBrowseZipFolders(const Value: Boolean);
begin
  fBrowseZipFolders:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set CheckBoxSelection
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetCheckBoxSelection(const Value: Boolean);
begin
  fCheckBoxSelection:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set ExtensionColors
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetExtensionColors(const Value: WideString);
begin
  fExtensionColors:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set ExtensionColorsEnabled
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetExtensionColorsEnabled(const Value: Boolean);
begin
  fExtensionColorsEnabled:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set FileSizeFormat
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetFileSizeFormat(const Value:
    TVirtualFileSizeFormat);
begin
  fFileSizeFormat:= Value;
  SendChanges;
end;

procedure TCEFileViewSettings.SetFolderUpOnDblClick(const Value: Boolean);
begin
  fFolderUpOnDblClick:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set Font
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetFont(const Value: TFont);
begin
  fFont.Assign(Value);
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set FullRowContextMenu
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetFullRowContextMenu(const Value: Boolean);
begin
  fFullRowContextMenu:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set FullRow Dbl Click
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetFullRowDblClick(const Value: Boolean);
begin
  fFullRowDblClick:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set HideShortcutExtension
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetHideShortcutExtension(const Value: Boolean);
begin
  fHideShortcutExtension:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set Per Folder Settings
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetPerFolderSettings(const Value: Boolean);
begin
  if Value <> fPerFolderSettings then
  begin
    fPerFolderSettings:= Value;
    if fPerFolderSettings and not fStorageIsLoaded then
    LoadStorage;    
  end;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set Select Pasted
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetSelectPasted(const Value: Boolean);
begin
  fSelectPasted:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set ShowCaptionsInFilmstrip
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetShowCaptionsInFilmstrip(const Value: Boolean);
begin
  fShowCaptionsInFilmstrip:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set ShowGridLines
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetShowGridLines(const Value: Boolean);
begin
  fShowGridLines:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set ShowInfoBar
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetShowInfoBar(const Value: Boolean);
begin
  fShowInfoBar:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set ShowInfoTips
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetShowInfoTips(const Value: Boolean);
begin
  fShowInfoTips:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set ShowCaptionsInThumbnails
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetShowCaptionsInThumbnails(const Value: Boolean);
begin
  fShowCaptionsInThumbnails:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set SingleClickBrowse
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetSingleClickBrowse(const Value: Boolean);
begin
  fSingleClickBrowse:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set SingleClickExecute
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetSingleClickExecute(const Value: Boolean);
begin
  fSingleClickExecute:= Value;
  SendChanges;
end;

procedure TCEFileViewSettings.SetSortAfterPaste(const Value: Boolean);
begin
  fSortAfterPaste:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set SortFolderFirstAlways
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetSortFolderFirstAlways(const Value: Boolean);
begin
  fSortFolderFirstAlways:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set ThreadedDetails
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetThreadedDetails(const Value: Boolean);
begin
  fThreadedDetails:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set ThreadedEnumeration
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetThreadedEnumeration(const Value: Boolean);
begin
  fThreadedEnumeration:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set ThreadedImages
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetThreadedImages(const Value: Boolean);
begin
  fThreadedImages:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set TrackChangesInMappedDrives
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetTrackChangesInMappedDrives(const Value:
    Boolean);
begin
  fTrackChangesInMappedDrives:= Value;
  SendChanges;
end;

{-------------------------------------------------------------------------------
  Set Use_JumboIcons_in_InfoBar
-------------------------------------------------------------------------------}
procedure TCEFileViewSettings.SetUse_JumboIcons_in_InfoBar(const Value:
    Boolean);
begin
  fUse_JumboIcons_in_InfoBar:= Value;
  SendChanges;
end;

{##############################################################################}

{-------------------------------------------------------------------------------
  Get/Set Path
-------------------------------------------------------------------------------}
function TCEFileViewPageSettings.GetPath: WideString;
var
  i: Integer;
begin
  if FileViewPage.FileView.RootFolderNamespace.IsDesktop then
  i:= 0
  else
  i:= CE_SpecialNamespaces.GetSpecialID(FileViewPage.FileView.RootFolderNamespace.AbsolutePIDL);

  if i > -1 then
  begin
    Result:= 'special://' + IntToStr(i);
  end
  else if WideDirectoryExists(FileViewPage.FileView.RootFolderNamespace.NameForParsing) then
  begin
    Result:= 'file://' + FileViewPage.FileView.RootFolderNamespace.NameForParsing;
  end
  else
  begin
    Result:= 'pidl://' + SavePIDLToMime(FileViewPage.FileView.RootFolderNamespace.AbsolutePIDL);
  end;
end;

{-------------------------------------------------------------------------------
  Get RememberInnerToolbarLayout
-------------------------------------------------------------------------------}
function TCEFileViewPageSettings.GetRememberInnerToolbarLayout: Boolean;
begin
  Result:= GlobalFileViewSettings.RememberInnerToolbarLayout;
end;

{-------------------------------------------------------------------------------
  Get RememberOuterToolbarLayout
-------------------------------------------------------------------------------}
function TCEFileViewPageSettings.GetRememberOuterToolbarLayout: Boolean;
begin
  Result:= GlobalFileViewSettings.RememberOuterToolbarLayout;
end;

{-------------------------------------------------------------------------------
  Get RememberPanelLayout
-------------------------------------------------------------------------------}
function TCEFileViewPageSettings.GetRememberPanelLayout: Boolean;
begin
  Result:= GlobalFileViewSettings.RememberPanelLayout;
end;

{-------------------------------------------------------------------------------
  Set Path
-------------------------------------------------------------------------------}
procedure TCEFileViewPageSettings.SetPath(const Value: WideString);
var
  format, fPath: WideString;
  i,c: Integer;
  PIDL: PItemIDList;
begin
  FileViewPage.FileView.BeginUpdate;
  try
    i:= Pos('://', Value);
    if i > 0 then
    begin
      c:= Length(Value);
      format:= LeftStr(Value, i-1);
      fPath:= RightStr(Value, c - i-2);

      if format = 'file' then
      begin
        PIDL:= PathToPIDL(fPath);
      end
      else if format = 'pidl' then
      begin
        PIDL:= LoadPIDLFromMime(fPath);
      end
      else if format = 'special' then
      begin
        SHGetspecialFolderLocation(0, StrToIntDef(fPath, 0), PIDL);
      end
      else begin
        PIDL:= PathToPIDL(fPath);
      end;
    end
    else
    begin
      PIDL:= PathToPIDL(Value);
    end;

    if assigned(PIDL) then
    begin
      FileViewPage.FileView.BrowseToByPIDL(PIDL);
      FileViewPage.FileView.BeginHistoryUpdate;
      FileViewPage.FileView.ClearHistory;
      FileViewPage.FileView.History.Add(TNamespace.Create(PIDLMgr.CopyPIDL(PIDL),nil),true);
      FileViewPage.FileView.EndHistoryUpdate;
    end;
  finally
    FileViewPage.FileView.EndUpdate(false);
    FileViewPage.UpdateCaption;
  end;
end;

{-------------------------------------------------------------------------------
  Get/Set ViewStyle
-------------------------------------------------------------------------------}
function TCEFileViewPageSettings.GetViewStyle: TEasyListStyle;
begin
  Result:= FileViewPage.ViewStyle;
end;
procedure TCEFileViewPageSettings.SetViewStyle(const Value: TEasyListStyle);
begin
  FileViewPage.ViewStyle:= Value;
end;

{##############################################################################}
// TCEThumbnailSettings

{-------------------------------------------------------------------------------
  Create an instance of TCEThumbnailSettings
-------------------------------------------------------------------------------}
constructor TCEThumbnailSettings.Create;
begin
  inherited;
  fLoadAllAtOnce:= false;
  fMaxThumbHeight:= 512;
  fMaxThumbWidth:= 512;
  fStorageCompressed:= true;
  fStorageFilename:= 'Thumbnails.album';
  fStorageRepositoryFolder:= '';
  fStorageType:= tasRepository;
  fStretch:= true;
  fUseExifOrientation:= true;
  fUseExifThumbnail:= true;
  fUseFoldersShellExtraction:= true;
  fUseShellExtraction:= true;
  fUseStorage:= false;
  fUseSubsampling:= true;
end;

{##############################################################################}

initialization
  GlobalFileViewSettings:= TCEFileViewSettings.Create;
  GlobalAppSettings.AddItem('FileView', GlobalFileViewSettings, true);

  TabPageClassList.RegisterClass('FileView', TCEFileViewPage, TCEFileViewPageSettings);

finalization
  FreeAndNil(GlobalFileViewSettings);

end.
