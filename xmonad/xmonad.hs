import XMonad

import qualified XMonad.StackSet as W

import XMonad.Actions.CycleWS
import XMonad.Actions.EasyMotion (selectWindow, textSize, EasyMotionConfig(..))
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.GroupNavigation

import XMonad.Config.Desktop

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.WindowSwallowing

import XMonad.Layout.NoBorders

import XMonad.Prompt
import XMonad.Prompt.Man

import XMonad.Util.EZConfig
import XMonad.Util.Loggers
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.ClickableWorkspaces
import XMonad.Util.Ungrab

main :: IO ()
main = do
    xmonad . ewmh . docks $ withSB mySB myConfig

mySB = statusBarProp "xmobar" (clickablePP xmobarPP)

myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Firefox-esr"          --> doShift "9:<fn=2>\xf269</fn>"
    , className =? "Google-chrome"        --> doShift "9:<fn=2>\xf269</fn>"
    , className =? "Evince"               --> doShift "8:<fn=2>\xf02d</fn>"
    , className =? "Bytedance-feishu"     --> doShift "7:<fn=2>\xf866</fn>"
    , className =? "Seal"                 --> doShift "6:<fn=2>\xf013</fn>"
    , className =? "netease-cloud-music"  --> doShift "4:<fn=2>\xf025</fn>"
    , className =? "GoldenDict"           --> doCenterFloat
    , className =? "feh"                  --> doCenterFloat
    ]

myStartupHook = do 
    spawnOnce "xrandr --output DP-2.8 --left-of HDMI-0"
    spawnOnce "nm-applet --sm-disable&"
    spawnOnce "feh --bg-fill ~/Pictures/Wallpapers/0001.jpg"
    spawnOnce "trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand false --transparent true --alpha 0 --tint 0x2E3440 --widthtype percent --width 10 --height 24 &"
    spawnOnce "ibus-daemon -dr"

myTerminal = "/opt/kitty/bin/kitty"
myModMask = mod4Mask
myBorderWidth = 1

myWorkspaces =
        "1:<fn=2>\xf120</fn>" : -- local
        "2:<fn=2>\xf0c2</fn>" : -- dev
        "3:<fn=2>\xf0e8</fn>" : -- server
        "4:<fn=2>\xf025</fn>" : -- audio
        "5:<fn=2>\xf03d</fn>" : -- video
        "6:<fn=2>\xf013</fn>" : -- tools
        "7:<fn=2>\xf866</fn>" : -- IM
        "8:<fn=2>\xe28b</fn>" : -- doc
        "9:<fn=2>\xf269</fn>" : -- web
        []

myLayout = avoidStruts
    -- $ spacingRaw True (Border 7 0 7 0) True (Border 0 7 0 7) True
    $ tiled ||| noBorders Full
    where
        tiled = Tall nmaster delta ratio
        nmaster = 1
        ratio   = 1/2
        delta   = 3/100

myLogHook = do
    historyHook

myHandleEventHook = swallowEventHook (
    className =? "kitty" <||> className =? "XTerm") (return True)

myEmConf :: EasyMotionConfig
myEmConf = def
    { cancelKey = xK_Escape
    , emFont = "xft: Sans-40"
    , overlayF = textSize
    , borderPx = 0
    , bgCol = "#eee8d5"
    }

goToNextScreen ws =
    case W.visible ws of
        newVisible:rest -> ws { W.current = newVisible
                              , W.visible = W.current ws:rest
                              }
        _ -> ws

goToNextScreenX = windows goToNextScreen

myConfig = desktopConfig
    { modMask = mod4Mask
    , terminal = myTerminal
    , borderWidth = myBorderWidth
    , workspaces = myWorkspaces
    , layoutHook = myLayout
    , logHook = myLogHook
    , manageHook = myManageHook <+> manageHook desktopConfig <+> manageDocks
    , startupHook = myStartupHook
    , handleEventHook = myHandleEventHook
    }
    `additionalKeysP`
    [ ("C-M1-l", spawn "i3lock-fancy")
    , ("M-<Up>", prevWS)
    , ("M-<Down>", nextWS)
    , ("M-<Left>", prevScreen)
    , ("M-<Right>", nextScreen)
    , ("M-s", selectWindow myEmConf {txtCol = "#2aa198"} >>= (`whenJust` windows . W.focusWindow))
    , ("M-S-s", selectWindow myEmConf{txtCol = "#cb4b16"} >>= (`whenJust` killWindow))
    , ("M-f", moveTo Next emptyWS)
    , ("M-i", toggleWS)
    , ("M-o", nextMatch History (return True))
    , ("M-p", spawn "rofi -show run")
    , ("M-x", swapNextScreen >> goToNextScreenX)
    , ("M-<F1>", manPrompt def)
    , ("M-<F10>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
    , ("M-<F11>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -10%")
    , ("M-<F12>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +10%")
    ]
