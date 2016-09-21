import qualified XMonad.StackSet as W
import Solarized
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.GroupNavigation
import XMonad.Layout.IndependentScreens
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Layout.NoBorders
import XMonad.ManageHook
import XMonad.Prompt
import XMonad.Prompt.Man
import XMonad.Prompt.Shell
import XMonad.Util.EZConfig
import XMonad.Util.NamedScratchpad
import XMonad.Util.WorkspaceCompare
import XMonad.Util.Run

myFont = "Open Sans:size=12,WenQuanYi Zen Hei:size=12";
myTerminal = "/usr/local/bin/lxterminal"
-- myTerminal = "/usr/bin/gnome-terminal.wrapper"
myRanger = "/home/linxiangdong/.linuxbrew/bin/ranger"
myDmenu = "/usr/bin/dmenu_run -b -p \">\""
	++ " -fn \"Inconsolata 12\""
	++ " -nb " ++ "\"" ++ solarizedBase3 ++ "\""
	++ " -nf " ++ "\"" ++ solarizedBase03 ++ "\""
	++ " -sb " ++ "\"" ++ solarizedBase2 ++ "\""
	++ " -sf " ++ "\"" ++ solarizedOrangeD ++ "\""
myTrayer = "/usr/bin/trayer --align right --edge top"
	++ " --width 10 --transparent true --alpha 0 --height 24"
	++ " --tint 0xfdf6e3" {- solarizedBase3(0xfdf6e3) -}

scratchpads = [
		NS "ranger" spawnRanger findRanger manageRanger,
		NS "terminal" spawnTerm findTerm manageTerm,
		NS "stardict" spawnDict findDict manageDict,
		NS "notes" spawnNotes findNotes manageNotes
	] where
	role = stringProperty "WM_WINDOW_ROLE"
	terminal = "st"

	spawnRanger = terminal ++ " -e " ++ myRanger
	findRanger = title =? "ranger"
	manageRanger = defaultFloating

	spawnTerm = terminal ++ " -n scratchpad"
	findTerm = resource =? "scratchpad"
	manageTerm = customFloating $ W.RationalRect l t w h
		where
			h = (1/3)     -- height, 10%
			w = (1/1)     -- width, 100%
			t = (0/3)     -- bottom edge
			l = (0/3)     -- centered left/right

	spawnDict = "stardict"
	findDict = className =? "Stardict"
	manageDict = customFloating $ W.RationalRect l t w h
		where
			h = (1/6)
			w = (1/6)
			t = (2/3)
			l = (2/3)

	spawnNotes = "gvim --role notes ~/notes.txt"
	findNotes = role =? "notes"
	manageNotes = defaultFloating

myPP = sjanssenPP
	{ ppCurrent = xmobarColor solarizedRedD "" . wrap "*" "*"
	, ppVisible = xmobarColor solarizedGreenD "" . wrap "[" "]"
	, ppHidden = xmobarColor solarizedBlueD "" . noScratchPad
	, ppTitle = xmobarColor solarizedBase02  "" . shorten 90
	, ppUrgent = xmobarColor solarizedMagentaD ""
	, ppLayout = xmobarColor solarizedOrangeD ""
	, ppSort = getSortByXineramaRule
	}
	where
		noScratchPad ws = if ws == "NSP" then "" else ws

myLogHook = do
	historyHook
	dynamicLogWithPP . namedScratchpadFilterOutWorkspacePP $ myPP

myStartupHook =
	(spawn "/usr/bin/feh --bg-scale ~/Pictures/wallpaper/current.jpg") <+>
	(spawn "/usr/bin/xsettingsd") <+>
	(spawn "/usr/bin/ibus-daemon -d") <+>
	(spawn "xrandr --output DP1-8 --auto --left-of DP1-1 --primary") <+>
	(spawn myTrayer)

myWorkspaces = ["1","2","3","4","5","6","7","8:vm","9:web"]

myManageHook = composeAll
	[ className =? "Firefox" --> doShift "9:web"
	, className =? "VirtualBox" --> doShift "8:vm"
	]

toggleStrutsKey :: XConfig t -> (KeyMask, KeySym)
toggleStrutsKey XConfig{modMask = modm} = (modm, xK_b )

myConfig = desktopConfig
	{ modMask = mod4Mask
	, terminal = myTerminal
	, workspaces = myWorkspaces
	} `additionalKeysP` myKeys

myKeys= [ ("M-p", spawn myDmenu)
	, ("M-s", runInTerm "" "ssh relay01")
	, ("C-M1-l", spawn "slock")
	, ("M-<Print>", spawn "scrot -e 'mv $f ~/Pictures/shots'")
	, ("M-S-r", namedScratchpadAction scratchpads "ranger")
	, ("M-~", namedScratchpadAction scratchpads "terminal")
	, ("C-M1-d", namedScratchpadAction scratchpads "stardict")
	, ("M-S-n", namedScratchpadAction scratchpads "notes")
	, ("M-o", nextMatch History (return True))
	, ("M-f", moveTo Next EmptyWS)
	, ("M-<Down>", nextWS)
	, ("M-S-<Down>", shiftToNext >> nextWS)
	, ("M-<Up>", prevWS)
	, ("M-S-<Up>", shiftToPrev >> prevWS)
	, ("M-<Right>", nextScreen)
	, ("M-S-<Right>", shiftNextScreen >> nextScreen)
	, ("M-<Left>", prevScreen)
	, ("M-S-<Left>", shiftPrevScreen >> prevScreen)
	, ("M-z", toggleWS)
	, ("C-M1-<Right>",
		do t <- findWorkspace getSortByXineramaRule Next NonEmptyWS 2
		   windows . W.view $ t)
	] ++
	[ (otherModMasks ++ "M-" ++ [key], action tag)
	  | (tag, key)  <- zip myWorkspaces "123456789"
	  , (otherModMasks, action) <- [ ("", windows . W.view) -- was W.greedyView
									  , ("S-", windows . W.shift)]
	]

main = xmonad =<< statusBar "xmobar" myPP toggleStrutsKey myConfig
	{ logHook = myLogHook
	, layoutHook = (Tall 1 (3/100) (1/2)) ||| noBorders Full
	, manageHook = manageHook myConfig <+> manageDocks
					<+> namedScratchpadManageHook scratchpads
					<+> myManageHook
	, startupHook = myStartupHook
	}

