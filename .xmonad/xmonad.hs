-- unqualified imports
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Layout.Magnifier
import XMonad.Layout.ThreeColumns
import XMonad.Util.EZConfig (additionalKeysP)

myLayout = tiled ||| Mirror tiled ||| Full ||| threeCol
 where
  threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
  tiled = Tall nmaster delta ratio
  nmaster = 1 -- Default number of windows in master pane
  delta = 3 / 100 -- Percent of screen to increment by when resizing
  ratio = 1 / 2 -- Default proportion of screen occupied by master pane (if other panes are visible)

-- Temporary for showing my posture via webcam
myManageHook =
  composeAll
    [ title =? "PostureCam" --> doFloat
    , isDialog --> doFloat
    ]

main :: IO ()
main =
  xmonad
    . ewmhFullscreen
    . ewmh
    . withEasySB (statusBarProp "xmobar" (pure def)) defToggleStrutsKey
    $ myConfig

myConfig =
  def
    { modMask = mod4Mask -- update the def record to bind mod to the super key
    , layoutHook = myLayout
    , manageHook = myManageHook <+> def
    }
    `additionalKeysP` [ ("M-C-s", unGrab *> spawn "scrot --line style=dash,color='red' --select") -- backticks to make this function infix
                      , ("M-d", spawn "exe=`dmenu_run` && eval \"exec $exe\"")
                      , ("M-z", spawn "systemctl suspend")
                      , ("M-p", spawn "mpv av://v4l2:/dev/video2 --profile=low-latency --untimed --no-cache --title=PostureCam --no-border")
                      ]
