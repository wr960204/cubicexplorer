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
//  The Original Code is fCE_OptionsPage_Display_FolderTree.pas.                                                            
//                                                                                            
//  The Initial Developer of the Original Code is Marko Savolainen (cubicreality@gmail.com).  
//  Portions created by Marko Savolainen Copyright (C) Marko Savolainen. All Rights Reserved. 
//                                                                                            
//******************************************************************************

unit fCE_OptionsPage_Display_FolderTree;

interface

uses
  // CE Units
  fCE_OptionsDialog, fCE_OptionsCustomPage, CE_SettingsIntf, fCE_FolderPanel,
  CE_LanguageEngine,
  // Tnt
  TntStdCtrls,
  // System Units
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TCE_OptionsPage_Display_FolderTree = class(TCEOptionsCustomPage)
    check_autocollapse: TTntCheckBox;
    check_autoexpand: TTntCheckBox;
    check_newtabdefault: TTntCheckBox;
    procedure HandleChange(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure ApplySettings; override;
    procedure LoadFromStorage(Storage: ICESettingsStorage); override; stdcall;
    procedure SaveToStorage(Storage: ICESettingsStorage); override; stdcall;
    { Public declarations }
  end;

var
  CE_OptionsPage_Display_FolderTree: TCE_OptionsPage_Display_FolderTree;

implementation

{$R *.dfm}

{-------------------------------------------------------------------------------
  Create an instance of TCEOptionsPage_Display
-------------------------------------------------------------------------------}
constructor TCE_OptionsPage_Display_FolderTree.Create(AOwner: TComponent);
begin
  inherited;
  PageName:= _('Folders');
  PageTitle:= _('Folders Panel Settings');
  PagePath:= 'Display/Folders';
  ImageIndex:= 4;
end;

{-------------------------------------------------------------------------------
  Apply Settings
-------------------------------------------------------------------------------}
procedure TCE_OptionsPage_Display_FolderTree.ApplySettings;
begin
  // Toggles
  CEFolderPanel.FolderTree.AutoExpand:= check_autoexpand.Checked;
  CEFolderPanel.FolderTree.AutoCollapse:= check_autocollapse.Checked;
  CEFolderPanel.NewTabByDefault:= check_newtabdefault.Checked;
end;

{-------------------------------------------------------------------------------
  Handle changes
-------------------------------------------------------------------------------}
procedure TCE_OptionsPage_Display_FolderTree.HandleChange(Sender: TObject);
begin
  inherited;
end;

{-------------------------------------------------------------------------------
  Load From Storage
-------------------------------------------------------------------------------}
procedure TCE_OptionsPage_Display_FolderTree.LoadFromStorage(Storage:
    ICESettingsStorage);
begin
  // Toggles
  check_autoexpand.Checked:= Storage.ReadBoolean('/FolderPanel/AutoExpand', CEFolderPanel.FolderTree.AutoExpand);
  check_autocollapse.Checked:= Storage.ReadBoolean('/FolderPanel/AutoCollapse', CEFolderPanel.FolderTree.AutoCollapse);
  check_newtabdefault.Checked:= Storage.ReadBoolean('/FolderPanel/OpenInNewTab', CEFolderPanel.NewTabByDefault);
end;

{-------------------------------------------------------------------------------
  Save To Storage
-------------------------------------------------------------------------------}
procedure TCE_OptionsPage_Display_FolderTree.SaveToStorage(Storage:
    ICESettingsStorage);
begin
  // Toggles
  Storage.WriteBoolean('/FolderPanel/AutoExpand', check_autoexpand.Checked);
  Storage.WriteBoolean('/FolderPanel/AutoCollapse', check_autocollapse.Checked);
  Storage.WriteBoolean('/FolderPanel/OpenInNewTab', check_newtabdefault.Checked);
end;

{##############################################################################}

initialization
  RegisterOptionsPageClass(TCE_OptionsPage_Display_FolderTree);

finalization

end.