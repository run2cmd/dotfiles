#Requires AutoHotkey v2.0

; Win + Ctrl + P -> Play/Pause
#^p:: {
  Send("{Media_Play_Pause}")
}

; Win + Ctrl + ] -> Next track
#^]:: {
  Send("{Media_Next}")
}

; Win + Ctrl + [ -> Previous track
#^[:: {
  Send("{Media_Prev}")
}
