inherited CEFileSearchPage: TCEFileSearchPage
  object SearchPanel: TSpTBXPanel
    Left = 0
    Top = 0
    Width = 587
    Height = 133
    Caption = 'SearchPanel'
    Align = alTop
    TabOrder = 0
    Borders = False
    TBXStyleBackground = True
    object label1: TSpTBXLabel
      Left = 8
      Top = 8
      Width = 85
      Height = 19
      Caption = 'Search File Mask'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'Tahoma'
      LinkFont.Style = [fsUnderline]
    end
    object edit_dosmask: TSpTBXEdit
      Left = 8
      Top = 24
      Width = 149
      Height = 21
      TabOrder = 1
    end
    object but_start: TSpTBXButton
      Left = 128
      Top = 100
      Width = 60
      Height = 23
      Caption = 'Start'
      TabOrder = 5
      OnClick = but_startClick
      Default = True
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'Tahoma'
      LinkFont.Style = [fsUnderline]
    end
    object label2: TSpTBXLabel
      Left = 163
      Top = 8
      Width = 177
      Height = 19
      Caption = 'Search Word or Phrase in File Name'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'Tahoma'
      LinkFont.Style = [fsUnderline]
    end
    object edit_wordphrase: TSpTBXEdit
      Left = 163
      Top = 24
      Width = 149
      Height = 21
      TabOrder = 2
    end
    object but_pause: TSpTBXButton
      Left = 190
      Top = 100
      Width = 60
      Height = 23
      Caption = 'Pause'
      TabOrder = 6
      OnClick = but_pauseClick
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'Tahoma'
      LinkFont.Style = [fsUnderline]
    end
    object but_stop: TSpTBXButton
      Left = 256
      Top = 100
      Width = 60
      Height = 23
      Caption = 'Stop'
      TabOrder = 7
      OnClick = but_stopClick
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'Tahoma'
      LinkFont.Style = [fsUnderline]
    end
    object label3: TSpTBXLabel
      Left = 8
      Top = 52
      Width = 97
      Height = 19
      Caption = 'Search in Directory'
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'Tahoma'
      LinkFont.Style = [fsUnderline]
    end
    object check_subdir: TSpTBXCheckBox
      Left = 8
      Top = 104
      Width = 92
      Height = 21
      Caption = 'Subdirectories'
      TabOrder = 4
    end
    object DestinationEdit: TSpTBXButtonEdit
      Left = 8
      Top = 68
      Width = 304
      Height = 21
      PopupMenu = FolderTreePopup
      TabOrder = 3
      EditButton.Left = 280
      EditButton.Top = 0
      EditButton.Width = 20
      EditButton.Height = 17
      EditButton.Align = alRight
      EditButton.DropDownMenu = FolderTreePopup
      EditButton.LinkFont.Charset = DEFAULT_CHARSET
      EditButton.LinkFont.Color = clBlue
      EditButton.LinkFont.Height = -11
      EditButton.LinkFont.Name = 'Tahoma'
      EditButton.LinkFont.Style = [fsUnderline]
    end
  end
  object StatusPanel: TSpTBXPanel
    Left = 0
    Top = 402
    Width = 587
    Height = 22
    Caption = 'StatusPanel'
    Align = alBottom
    TabOrder = 1
    Borders = False
    TBXStyleBackground = True
    DesignSize = (
      587
      22)
    object StatusLabel: TSpTBXLabel
      Left = 4
      Top = 2
      Width = 580
      Height = 18
      Anchors = [akLeft, akTop, akRight, akBottom]
      AutoSize = False
      LinkFont.Charset = DEFAULT_CHARSET
      LinkFont.Color = clBlue
      LinkFont.Height = -11
      LinkFont.Name = 'Tahoma'
      LinkFont.Style = [fsUnderline]
    end
  end
  object FolderTreePopup: TSpTBXFormPopupMenu
    OnPopup = FolderTreePopupPopup
    BorderStyle = pbsSizeable
    PopupFocus = True
    OnClosePopup = FolderTreePopupClosePopup
    Left = 324
    Top = 20
  end
  object UpdateTimer: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = UpdateTimerTimer
    Left = 324
    Top = 60
  end
end