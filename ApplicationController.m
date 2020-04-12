#import "ApplicationController.h"
#import <Cocoa/Cocoa.h>

@implementation ApplicationController

-(void) applicationDidFinishLaunching:(NSNotification*) aNotification
{
	[NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];

	[self initializeMenus];

	NSWindow* window = [[NSWindow alloc] initWithContentRect:NSMakeRect(196,240,480,270) styleMask:(NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable) backing:NSBackingStoreBuffered defer:NO];

	[window orderFrontRegardless];
	[window setTitle:@"Window"];

	[NSApp activateIgnoringOtherApps:YES];
}

-(void) applicationWillTerminate:(NSNotification*) aNotification
{
}

-(bool) applicationShouldTerminateAfterLastWindowClosed:(NSApplication*) app
{
	return YES;
}

-(void) initializeMenus
{
	NSMenu* mainMenu = [[NSMenu alloc] initWithTitle:@"Main Menu"];

	[mainMenu addItem:[self initializeAppMenu]];
	[mainMenu addItem:[self initializeFileMenu]];
	[mainMenu addItem:[self initializeEditMenu]];
	[mainMenu addItem:[self initializeFormatMenu]];
	[mainMenu addItem:[self initializeViewMenu]];
	[mainMenu addItem:[self initializeWindowMenu]];
	[mainMenu addItem:[self initializeHelpMenu]];

	[NSApp setMainMenu:mainMenu];
}

-(NSMenuItem*) initializeAppMenu
{
	// Even though it's being set here, the title on this one really doesn't matter, as it'll be overwritten by the name of the app at runtime
	NSMenuItem* mainMenuAppItem = [[NSMenuItem alloc] initWithTitle:APP_MENU_NSSTRING action:nil keyEquivalent:@""];
	NSMenu* appMenu = [[NSMenu alloc] initWithTitle:APP_MENU_NSSTRING];
	[appMenu addItemWithTitle:[@"About " stringByAppendingString:APP_MENU_NSSTRING] action:@selector(orderFrontStandardAboutPanel:) keyEquivalent:@""];
	[appMenu addItem:[NSMenuItem separatorItem]];
	[appMenu addItemWithTitle:@"Preferences…" action:nil keyEquivalent:@","];
	[appMenu addItem:[NSMenuItem separatorItem]];

	// The app's Services menu needs to be assigned to that property of the running NSApplication object
	NSMenu* appServicesMenu = [[NSMenu alloc] initWithTitle:@"Services"];
	NSMenuItem* appServicesMenuItem = [[NSMenuItem alloc] initWithTitle:@"Services" action:nil keyEquivalent:@""];
	[appServicesMenuItem setSubmenu:appServicesMenu];
	[NSApp setServicesMenu:appServicesMenu];
	[appMenu addItem:appServicesMenuItem];

	[appMenu addItem:[NSMenuItem separatorItem]];
	[appMenu addItemWithTitle:[@"Hide " stringByAppendingString:APP_MENU_NSSTRING] action:@selector(hide:) keyEquivalent:@"h"];
	NSMenuItem* hideOthersMenuItem = [[NSMenuItem alloc] initWithTitle:@"Hide Others" action:@selector(hideOtherApplications:) keyEquivalent:@"h"];
	[hideOthersMenuItem setKeyEquivalentModifierMask:(NSEventModifierFlagCommand | NSEventModifierFlagOption)];
	[appMenu addItem:hideOthersMenuItem];
	[appMenu addItemWithTitle:@"Show All" action:@selector(unhideAllApplications:) keyEquivalent:@""];
	[appMenu addItem:[NSMenuItem separatorItem]];
	[appMenu addItemWithTitle:[@"Quit " stringByAppendingString:APP_MENU_NSSTRING] action:@selector(terminate:) keyEquivalent:@"q"];
	[mainMenuAppItem setSubmenu:appMenu];

	return mainMenuAppItem;
}

-(NSMenuItem*) initializeFileMenu
{
	NSMenuItem* mainMenuFileItem = [[NSMenuItem alloc] initWithTitle:@"File" action:nil keyEquivalent:@""];
	NSMenu* fileMenu = [[NSMenu alloc] initWithTitle:@"File"];
	[fileMenu addItemWithTitle:@"New" action:@selector(newDocument:) keyEquivalent:@"n"];
	[fileMenu addItemWithTitle:@"Open…" action:@selector(openDocument:) keyEquivalent:@"o"];

	// The Open Recent menu also needs some special treatment here
	NSMenuItem* openRecentMenuItem = [[NSMenuItem alloc] initWithTitle:@"Open Recent" action:nil keyEquivalent:@""];
	NSMenu* openRecentMenu = [[NSMenu alloc] initWithTitle:@"Open Recent"];
	[openRecentMenu performSelector:@selector(_setMenuName:) withObject:@"NSRecentDocumentsMenu"];
	[openRecentMenu addItemWithTitle:@"Clear Menu" action:@selector(clearRecentDocuments:) keyEquivalent:@""];
	[openRecentMenuItem setSubmenu:openRecentMenu];

	[fileMenu addItem:openRecentMenuItem];
	[fileMenu addItem:[NSMenuItem separatorItem]];
	[fileMenu addItemWithTitle:@"Close" action:@selector(performClose:) keyEquivalent:@"w"];
	[fileMenu addItemWithTitle:@"Save…" action:@selector(saveDocument:) keyEquivalent:@"s"];
	[fileMenu addItemWithTitle:@"Save As…" action:@selector(saveDocumentAs:) keyEquivalent:@"S"];
	[fileMenu addItemWithTitle:@"Revert to Saved" action:@selector(revertDocumentToSaved:) keyEquivalent:@"r"];
	[fileMenu addItem:[NSMenuItem separatorItem]];
	NSMenuItem* pageSetupMenuItem = [[NSMenuItem alloc] initWithTitle:@"Page Setup…" action:@selector(runPageLayout:) keyEquivalent:@"P"];
	[pageSetupMenuItem setKeyEquivalentModifierMask:(NSEventModifierFlagShift | NSEventModifierFlagCommand)];
	[fileMenu addItem:pageSetupMenuItem];
	[fileMenu addItemWithTitle:@"Print…" action:@selector(print:) keyEquivalent:@"p"];
	[mainMenuFileItem setSubmenu:fileMenu];

	return mainMenuFileItem;
}

-(NSMenuItem*) initializeEditMenu
{
	NSMenuItem* mainMenuEditItem = [[NSMenuItem alloc] initWithTitle:@"Edit" action:nil keyEquivalent:@""];
	NSMenu* editMenu = [[NSMenu alloc] initWithTitle:@"Edit"];
	[editMenu addItemWithTitle:@"Undo" action:@selector(undo:) keyEquivalent:@"z"];
	[editMenu addItemWithTitle:@"Redo" action:@selector(redo:) keyEquivalent:@"Z"];
	[editMenu addItem:[NSMenuItem separatorItem]];
	[editMenu addItemWithTitle:@"Cut" action:@selector(cut:) keyEquivalent:@"x"];
	[editMenu addItemWithTitle:@"Copy" action:@selector(copy:) keyEquivalent:@"c"];
	[editMenu addItemWithTitle:@"Paste" action:@selector(paste:) keyEquivalent:@"v"];
	NSMenuItem* pasteAndMatchStyleMenuItemEntry = [[NSMenuItem alloc] initWithTitle:@"Paste and Match Style" action:@selector(pasteAsPlainText:) keyEquivalent:@"V"];
	[pasteAndMatchStyleMenuItemEntry setKeyEquivalentModifierMask:(NSEventModifierFlagOption | NSEventModifierFlagCommand)];
	[editMenu addItem:pasteAndMatchStyleMenuItemEntry];
	[editMenu addItemWithTitle:@"Delete" action:@selector(delete:) keyEquivalent:@""];
	[editMenu addItemWithTitle:@"Select All" action:@selector(selectAll:) keyEquivalent:@"a"];
	[editMenu addItem:[NSMenuItem separatorItem]];
	NSMenuItem* findMenuItem = [[NSMenuItem alloc] initWithTitle:@"Find" action:nil keyEquivalent:@""];
	NSMenu* findMenu = [[NSMenu alloc] initWithTitle:@"Find"];
	NSMenuItem* findMenuItemEntry = [[NSMenuItem alloc] initWithTitle:@"Find…" action:@selector(performFindPanelAction:) keyEquivalent:@"f"];
	[findMenuItemEntry setTag:NSTextFinderActionShowFindInterface];
	[findMenu addItem:findMenuItemEntry];
	NSMenuItem* findAndReplaceMenuItemEntry = [[NSMenuItem alloc] initWithTitle:@"Find and Replace…" action:@selector(performFindPanelAction:) keyEquivalent:@"f"];
	[findAndReplaceMenuItemEntry setKeyEquivalentModifierMask:(NSEventModifierFlagOption | NSEventModifierFlagCommand)];
	[findAndReplaceMenuItemEntry setTag:NSTextFinderActionShowReplaceInterface];
	[findMenu addItem:findAndReplaceMenuItemEntry];
	NSMenuItem* findNextMenuItemEntry = [[NSMenuItem alloc] initWithTitle:@"Find Next" action:@selector(performFindPanelAction:) keyEquivalent:@"g"];
	[findNextMenuItemEntry setTag:NSTextFinderActionNextMatch];
	[findMenu addItem:findNextMenuItemEntry];
	NSMenuItem* findPreviousMenuItemEntry = [[NSMenuItem alloc] initWithTitle:@"Find Previous" action:@selector(performFindPanelAction:) keyEquivalent:@"G"];
	[findPreviousMenuItemEntry setTag:NSTextFinderActionPreviousMatch];
	[findMenu addItem:findPreviousMenuItemEntry];
	NSMenuItem* useSelectionForFindMenuItemEntry = [[NSMenuItem alloc] initWithTitle:@"Use Selection for Find" action:@selector(performFindPanelAction:) keyEquivalent:@"e"];
	[useSelectionForFindMenuItemEntry setTag:NSTextFinderActionSetSearchString];
	[findMenu addItem:useSelectionForFindMenuItemEntry];
	[findMenu addItemWithTitle:@"Jump to Selection" action:@selector(centerSelectionInVisibleArea:) keyEquivalent:@"j"];
	[findMenuItem setSubmenu:findMenu];
	[editMenu addItem:findMenuItem];
	NSMenuItem* spellingAndGrammarMenuItem = [[NSMenuItem alloc] initWithTitle:@"Spelling and Grammar" action:nil keyEquivalent:@""];
	NSMenu* spellingAndGrammarMenu = [[NSMenu alloc] initWithTitle:@"Spelling"];
	[spellingAndGrammarMenu addItemWithTitle:@"Show Spelling and Grammar" action:@selector(showGuessPanel:) keyEquivalent:@":"];
	[spellingAndGrammarMenu addItemWithTitle:@"Check Document Now" action:@selector(checkSpelling:) keyEquivalent:@";"];
	[spellingAndGrammarMenu addItem:[NSMenuItem separatorItem]];
	[spellingAndGrammarMenu addItemWithTitle:@"Check Spelling While Typing" action:@selector(toggleContinuousSpellChecking:) keyEquivalent:@""];
	[spellingAndGrammarMenu addItemWithTitle:@"Check Grammar With Spelling" action:@selector(toggleGrammarChecking:) keyEquivalent:@""];
	[spellingAndGrammarMenu addItemWithTitle:@"Correct Spelling Automatically" action:@selector(toggleAutomaticSpellingCorrection:) keyEquivalent:@""];
	[spellingAndGrammarMenuItem setSubmenu:spellingAndGrammarMenu];
	[editMenu addItem:spellingAndGrammarMenuItem];
	NSMenuItem* substitutionsMenuItem = [[NSMenuItem alloc] initWithTitle:@"Substitutions" action:nil keyEquivalent:@""];
	NSMenu* substitutionsMenu = [[NSMenu alloc] initWithTitle:@"Substitutions"];
	[substitutionsMenu addItemWithTitle:@"Show Substitutions" action:@selector(orderFrontSubstitutionsPanel:) keyEquivalent:@""];
	[substitutionsMenu addItem:[NSMenuItem separatorItem]];
	[substitutionsMenu addItemWithTitle:@"Smart Copy/Paste" action:@selector(toggleSmartInsertDelete:) keyEquivalent:@""];
	[substitutionsMenu addItemWithTitle:@"Smart Quotes" action:@selector(toggleAutomaticQuoteSubstitution:) keyEquivalent:@""];
	[substitutionsMenu addItemWithTitle:@"Smart Dashes" action:@selector(toggleAutomaticDashSubstitution:) keyEquivalent:@""];
	[substitutionsMenu addItemWithTitle:@"Smart Links" action:@selector(toggleAutomaticLinkDetection:) keyEquivalent:@""];
	[substitutionsMenu addItemWithTitle:@"Data Detectors" action:@selector(toggleAutomaticDataDetection:) keyEquivalent:@""];
	[substitutionsMenu addItemWithTitle:@"Text Replacement" action:@selector(toggleAutomaticTextReplacement:) keyEquivalent:@""];
	[substitutionsMenuItem setSubmenu:substitutionsMenu];
	[editMenu addItem:substitutionsMenuItem];
	NSMenuItem* transformationsMenuItem = [[NSMenuItem alloc] initWithTitle:@"Transformations" action:nil keyEquivalent:@""];
	NSMenu* transformationsMenu = [[NSMenu alloc] initWithTitle:@"Transformations"];
	[transformationsMenu addItemWithTitle:@"Make Upper Case" action:@selector(uppercaseWord:) keyEquivalent:@""];
	[transformationsMenu addItemWithTitle:@"Make Lower Case" action:@selector(lowercaseWord:) keyEquivalent:@""];
	[transformationsMenu addItemWithTitle:@"Capitalize" action:@selector(capitalizeWord:) keyEquivalent:@""];
	[transformationsMenuItem setSubmenu:transformationsMenu];
	[editMenu addItem:transformationsMenuItem];
	NSMenuItem* speechMenuItem = [[NSMenuItem alloc] initWithTitle:@"Speech" action:nil keyEquivalent:@""];
	NSMenu* speechMenu = [[NSMenu alloc] initWithTitle:@"Speech"];
	[speechMenu addItemWithTitle:@"Start Speaking" action:@selector(startSpeaking:) keyEquivalent:@""];
	[speechMenu addItemWithTitle:@"Stop Speaking" action:@selector(stopSpeaking:) keyEquivalent:@""];
	[speechMenuItem setSubmenu:speechMenu];
	[editMenu addItem:speechMenuItem];
	[mainMenuEditItem setSubmenu:editMenu];

	return mainMenuEditItem;
}

-(NSMenuItem*) initializeFormatMenu
{
	NSMenuItem* mainMenuFormatItem = [[NSMenuItem alloc] initWithTitle:@"Format" action:nil keyEquivalent:@""];
	NSMenu* formatMenu = [[NSMenu alloc] initWithTitle:@"Format"];
	NSMenuItem* fontMenuItem = [[NSMenuItem alloc] initWithTitle:@"Font" action:nil keyEquivalent:@""];
	NSMenu* fontMenu = [[NSMenu alloc] initWithTitle:@"Font"];
	[fontMenu addItemWithTitle:@"Show Fonts" action:@selector(orderFrontFontPanel:) keyEquivalent:@"t"];
	NSMenuItem* boldMenuItemEntry = [[NSMenuItem alloc] initWithTitle:@"Bold" action:@selector(addFontTrait:) keyEquivalent:@"b"];
	[boldMenuItemEntry setTag:NSBoldFontMask];
	[fontMenu addItem:boldMenuItemEntry];
	NSMenuItem* italicMenuItemEntry = [[NSMenuItem alloc] initWithTitle:@"Italic" action:@selector(addFontTrait:) keyEquivalent:@"i"];
	[italicMenuItemEntry setTag:NSItalicFontMask];
	[fontMenu addItem:italicMenuItemEntry];
	[fontMenu addItemWithTitle:@"Underline" action:@selector(underline:) keyEquivalent:@"u"];
	[fontMenu addItem:[NSMenuItem separatorItem]];
	NSMenuItem* biggerMenuItemEntry = [[NSMenuItem alloc] initWithTitle:@"Bigger" action:@selector(modifyFont:) keyEquivalent:@"+"];
	[biggerMenuItemEntry setTag:NSSizeUpFontAction];
	[fontMenu addItem:biggerMenuItemEntry];
	NSMenuItem* smallerMenuItemEntry = [[NSMenuItem alloc] initWithTitle:@"Smaller" action:@selector(modifyFont:) keyEquivalent:@"-"];
	[smallerMenuItemEntry setTag:NSSizeDownFontAction];
	[fontMenu addItem:smallerMenuItemEntry];
	[fontMenu addItem:[NSMenuItem separatorItem]];
	NSMenu* kernMenu = [[NSMenu alloc] initWithTitle:@"Kern"];
	NSMenuItem* kernMenuItem = [[NSMenuItem alloc] initWithTitle:@"Kern" action:nil keyEquivalent:@""];
	[kernMenu addItemWithTitle:@"Use Default" action:@selector(useStandardKerning:) keyEquivalent:@""];
	[kernMenu addItemWithTitle:@"Use None" action:@selector(turnOffKerning:) keyEquivalent:@""];
	[kernMenu addItemWithTitle:@"Tighten" action:@selector(tightenKerning:) keyEquivalent:@""];
	[kernMenu addItemWithTitle:@"Loosen" action:@selector(loosenKerning:) keyEquivalent:@""];
	[kernMenuItem setSubmenu:kernMenu];
	[fontMenu addItem:kernMenuItem];
	NSMenu* ligaturesMenu = [[NSMenu alloc] initWithTitle:@"Ligatures"];
	NSMenuItem* ligaturesMenuItem = [[NSMenuItem alloc] initWithTitle:@"Ligatures" action:nil keyEquivalent:@""];
	[ligaturesMenu addItemWithTitle:@"Use Default" action:@selector(useStandardLigatures:) keyEquivalent:@""];
	[ligaturesMenu addItemWithTitle:@"Use None" action:@selector(turnOffLigatures:) keyEquivalent:@""];
	[ligaturesMenu addItemWithTitle:@"Use All" action:@selector(useAllLigatures:) keyEquivalent:@""];
	[ligaturesMenuItem setSubmenu:ligaturesMenu];
	[fontMenu addItem:ligaturesMenuItem];
	NSMenu* baselineMenu = [[NSMenu alloc] initWithTitle:@"Baseline"];
	NSMenuItem* baselineMenuItem = [[NSMenuItem alloc] initWithTitle:@"Baseline" action:nil keyEquivalent:@""];
	[baselineMenu addItemWithTitle:@"Use Default" action:@selector(unscript:) keyEquivalent:@""];
	[baselineMenu addItemWithTitle:@"Superscript" action:@selector(superscript:) keyEquivalent:@""];
	[baselineMenu addItemWithTitle:@"Subscript" action:@selector(subscript:) keyEquivalent:@""];
	[baselineMenu addItemWithTitle:@"Raise" action:@selector(raiseBaseline:) keyEquivalent:@""];
	[baselineMenu addItemWithTitle:@"Lower" action:@selector(raiseBaseline:) keyEquivalent:@""];
	[baselineMenuItem setSubmenu:baselineMenu];

	// More special handling for the font menu
	[fontMenu addItem:baselineMenuItem];
	[fontMenu addItem:[NSMenuItem separatorItem]];
	[fontMenu addItemWithTitle:@"Show Colors" action:@selector(orderFrontColorPanel:) keyEquivalent:@"C"];
	[fontMenu addItem:[NSMenuItem separatorItem]];
	NSMenuItem* copyStyleMenuItemEntry = [[NSMenuItem alloc] initWithTitle:@"Copy Style" action:@selector(copyFont:) keyEquivalent:@"c"];
	[copyStyleMenuItemEntry setKeyEquivalentModifierMask:(NSEventModifierFlagOption | NSEventModifierFlagCommand)];
	[fontMenu addItem:copyStyleMenuItemEntry];
	NSMenuItem* pasteStyleMenuItemEntry = [[NSMenuItem alloc] initWithTitle:@"Paste Style" action:@selector(pasteFont:) keyEquivalent:@"v"];
	[pasteStyleMenuItemEntry setKeyEquivalentModifierMask:(NSEventModifierFlagOption | NSEventModifierFlagCommand)];
	[fontMenu addItem:pasteStyleMenuItemEntry];
	[fontMenuItem setSubmenu:fontMenu];
	[[NSFontManager sharedFontManager] setFontMenu:fontMenu];
	[formatMenu addItem:fontMenuItem];

	NSMenu* textMenu = [[NSMenu alloc] initWithTitle:@"Text"];
	NSMenuItem* textMenuItem = [[NSMenuItem alloc] initWithTitle:@"Text" action:nil keyEquivalent:@""];
	[textMenu addItemWithTitle:@"Align Left" action:@selector(alignLeft:) keyEquivalent:@"{"];
	[textMenu addItemWithTitle:@"Center" action:@selector(alignCenter:) keyEquivalent:@"|"];
	[textMenu addItemWithTitle:@"Justify" action:@selector(alignJustified:) keyEquivalent:@""];
	[textMenu addItemWithTitle:@"Align Right" action:@selector(alignRight:) keyEquivalent:@"}"];
	[textMenu addItem:[NSMenuItem separatorItem]];

	// The writing direction menus are a bit odd, in that the use disabled items as headers for submenus
	NSMenu* writingDirectionMenu = [[NSMenu alloc] initWithTitle:@"Writing Direction"];
	NSMenuItem* writingDirectionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Writing Direction" action:nil keyEquivalent:@""];
	NSMenuItem* paragraphMenuItemEntry = [[NSMenuItem alloc] initWithTitle:@"Paragraph" action:nil keyEquivalent:@""];
	[paragraphMenuItemEntry setEnabled:NO];
	[writingDirectionMenu addItem:paragraphMenuItemEntry];
	[writingDirectionMenu addItemWithTitle:@"	Default" action:@selector(makeBaseWritingDirectionNatural:) keyEquivalent:@""];
	[writingDirectionMenu addItemWithTitle:@"	Left to Right" action:@selector(makeBaseWritingDirectionLeftToRight:) keyEquivalent:@""];
	[writingDirectionMenu addItemWithTitle:@"	Right to Left" action:@selector(makeBaseWritingDirectionRightToLeft:) keyEquivalent:@""];
	[writingDirectionMenu addItem:[NSMenuItem separatorItem]];
	NSMenuItem* selectionMenuItemEntry = [[NSMenuItem alloc] initWithTitle:@"Selection" action:nil keyEquivalent:@""];
	[selectionMenuItemEntry setEnabled:NO];
	[writingDirectionMenu addItem:selectionMenuItemEntry];
	[writingDirectionMenu addItemWithTitle:@"	Default" action:@selector(makeTextWritingDirectionNatural:) keyEquivalent:@""];
	[writingDirectionMenu addItemWithTitle:@"	Left to Right" action:@selector(makeTextWritingDirectionLeftToRight:) keyEquivalent:@""];
	[writingDirectionMenu addItemWithTitle:@"	Right to Left" action:@selector(makeTextWritingDirectionRightToLeft:) keyEquivalent:@""];
	[writingDirectionMenuItem setSubmenu:writingDirectionMenu];
	[textMenu addItem:writingDirectionMenuItem];

	[textMenu addItem:[NSMenuItem separatorItem]];
	[textMenu addItemWithTitle:@"Show Ruler" action:@selector(toggleRuler:) keyEquivalent:@""];
	[textMenu addItemWithTitle:@"Copy Ruler" action:@selector(copyRuler:) keyEquivalent:@""];
	[textMenu addItemWithTitle:@"Paste Ruler" action:@selector(pasteRuler:) keyEquivalent:@""];
	[textMenuItem setSubmenu:textMenu];
	[formatMenu addItem:textMenuItem];
	[mainMenuFormatItem setSubmenu:formatMenu];

	return mainMenuFormatItem;
}

-(NSMenuItem*) initializeViewMenu
{
	NSMenuItem* mainMenuViewItem = [[NSMenuItem alloc] initWithTitle:@"View" action:nil keyEquivalent:@""];
	NSMenu* viewMenu = [[NSMenu alloc] initWithTitle:@"View"];
	NSMenuItem* showToolbarMenuItemEntry = [[NSMenuItem alloc] initWithTitle:@"Show Toolbar" action:@selector(toggleToolbarShown:) keyEquivalent:@"t"];
	[showToolbarMenuItemEntry setKeyEquivalentModifierMask:(NSEventModifierFlagOption | NSEventModifierFlagCommand)];
	[viewMenu addItem:showToolbarMenuItemEntry];
	[viewMenu addItemWithTitle:@"Customize Toolbar…" action:@selector(runToolbarCustomizationPalette:) keyEquivalent:@""];
	[viewMenu addItem:[NSMenuItem separatorItem]];
	NSMenuItem* showSidebarMenuItemEntry = [[NSMenuItem alloc] initWithTitle:@"Show Sidebar" action:@selector(toggleSidebar:) keyEquivalent:@"s"];
	[showSidebarMenuItemEntry setKeyEquivalentModifierMask:(NSEventModifierFlagControl | NSEventModifierFlagCommand)];
	[viewMenu addItem:showSidebarMenuItemEntry];
	NSMenuItem* enterFullScreenMenuItemEntry = [[NSMenuItem alloc] initWithTitle:@"Enter Full Screen" action:@selector(toggleFullScreen:) keyEquivalent:@"f"];
	[enterFullScreenMenuItemEntry setKeyEquivalentModifierMask:(NSEventModifierFlagControl | NSEventModifierFlagCommand)];
	[viewMenu addItem:enterFullScreenMenuItemEntry];
	[mainMenuViewItem setSubmenu:viewMenu];

	return mainMenuViewItem;
}

-(NSMenuItem*) initializeWindowMenu
{
	// More special handling for the Window menu
	NSMenuItem* mainMenuWindowItem = [[NSMenuItem alloc] initWithTitle:@"Window" action:nil keyEquivalent:@""];
	NSMenu* windowMenu = [[NSMenu alloc] initWithTitle:@"Window"];
	[windowMenu addItemWithTitle:@"Minimize" action:@selector(performMiniaturize:) keyEquivalent:@"m"];
	[windowMenu addItemWithTitle:@"Zoom" action:@selector(performZoom:) keyEquivalent:@""];
	[windowMenu addItem:[NSMenuItem separatorItem]];
	[windowMenu addItemWithTitle:@"Bring All to Front" action:@selector(arrangeInFront:) keyEquivalent:@""];
	[NSApp setWindowsMenu:windowMenu];
	[mainMenuWindowItem setSubmenu:windowMenu];

	return mainMenuWindowItem;
}

-(NSMenuItem*) initializeHelpMenu
{
	// The Help menu is apparently magic
	NSMenuItem* mainMenuHelpItem = [[NSMenuItem alloc] initWithTitle:@"Help" action:nil keyEquivalent:@""];
	NSMenu* helpMenu = [[NSMenu alloc] initWithTitle:@"Help"];
	[helpMenu addItemWithTitle:[APP_MENU_NSSTRING stringByAppendingString:@" Help"] action:@selector(showHelp:) keyEquivalent:@"?"];
	[mainMenuHelpItem setSubmenu:helpMenu];

	return mainMenuHelpItem;
}

@end
