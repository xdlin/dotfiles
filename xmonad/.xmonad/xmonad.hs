import qualified XMonad.StackSet as W
import Solarized
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.GroupNavigation
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.ManageHook
import XMonad.Prompt
import XMonad.Prompt.Man
import XMonad.Prompt.Shell
import XMonad.Util.EZConfig
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run

myFont = "Open Sans:size=12,WenQuanYi Zen Hei:size=12";
myTerminal = "/usr/bin/gnome-terminal.wrapper"
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
	{ ppCurrent = xmobarColor solarizedYellowD "" . wrap "[" "]"
	, ppHidden = xmobarColor solarizedCyanD "" . noScratchPad
	, ppTitle = xmobarColor solarizedBlueD  "" . shorten 50
	, ppUrgent = xmobarColor solarizedBase02 ""
	, ppLayout = xmobarColor solarizedGreenL ""
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
	(spawn myTrayer)

myWorkspaces = ["1:code","2:dev","3","4","5","6","7:net","8:vm","9:web"]

myManageHook = composeAll
	[ className =? "Firefox" --> doShift "9:web"
	]

toggleStrutsKey :: XConfig t -> (KeyMask, KeySym)
toggleStrutsKey XConfig{modMask = modm} = (modm, xK_b )

myConfig = desktopConfig
	{ modMask = mod4Mask
	, terminal = myTerminal
	, workspaces = myWorkspaces
	} `additionalKeys`
	[ ((mod4Mask, xK_f), moveTo Next EmptyWS)
	, ((mod4Mask, xK_o), nextMatch History (return True))
	, ((mod4Mask, xK_p), spawn myDmenu)
	, ((mod4Mask, xK_s), runInTerm "" "ssh relay01")
	, ((mod4Mask, xK_Print), spawn "scrot -e 'mv $f ~/Pictures/shots'")
	, ((mod4Mask .|. shiftMask, xK_r),
			namedScratchpadAction scratchpads "ranger")
	, ((mod4Mask, xK_grave),
			namedScratchpadAction scratchpads "terminal")
	, ((controlMask .|. mod1Mask, xK_d),
			namedScratchpadAction scratchpads "stardict")
	, ((mod4Mask .|. shiftMask, xK_n),
		namedScratchpadAction scratchpads "notes")
	]

main = xmonad =<< statusBar "xmobar" myPP toggleStrutsKey myConfig
	{ logHook = myLogHook
	, layoutHook = (Tall 1 (3/100) (1/2)) ||| Full ||| simpleTabbed
	, manageHook = manageHook myConfig <+> manageDocks
					<+> namedScratchpadManageHook scratchpads
					<+> myManageHook
	, startupHook = myStartupHook
	}

