import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

myManageHook = composeAll
    [ ]

-- Loghook
-- 
-- note: some of these colors may differ from what's in the
-- screenshot, it changes daily
-- 
myLogHook h = dynamicLogWithPP $ defaultPP -- the h here...
    -- display current workspace as darkgrey on light grey (opposite of default colors)
    { ppCurrent         = dzenColor "#303030" "#909090" . pad 

    -- display other workspaces which contain windows as a brighter grey
    , ppHidden          = dzenColor "#909090" "" . pad 

    -- display other workspaces with no windows as a normal grey
    , ppHiddenNoWindows = dzenColor "#606060" "" . pad 

    -- display the current layout as a brighter grey
    , ppLayout          = dzenColor "#909090" "" . pad 

    -- if a window on a hidden workspace needs my attention, color it so
    , ppUrgent          = dzenColor "#ff0000" "" . pad . dzenStrip

    -- shorten if it goes over 100 characters
    , ppTitle           = shorten 100  

    -- no separator between workspaces
    , ppWsSep           = ""

    -- put a few spaces between each object
    , ppSep             = "  "

    , ppOutput          = hPutStrLn h -- ... must match the h here
    }

main = do
    dzenproc <- spawnPipe "dzen2 -ta l -w 500"
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> myManageHook -- myManageHook from above
                       <+> manageHook defaultConfig
        , layoutHook = avoidStruts $ layoutHook defaultConfig
        , logHook = myLogHook dzenproc
        -- for xmobar, uncomment below
        -- , logHook = dynamicLogWithPP $ xmobarPP
        --    { ppOutput = hPutStrLn xmproc
        --    , ppTitle = xmobarColor "green" "" . shorten 50
        --    }
        , modMask = mod4Mask -- make "modMask" = mod4 key
        , terminal = "urxvt"
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock") 
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
        , ((mod4Mask, xK_d), spawn "exe=`dmenu_run` && eval \"exec $exe\"")
        ]
