; ModuleID = '_term_proc'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: _term_proc ; Address: 0x0000000000001BC8
; Intent: no-op finalizer stub (confidence=0.95). Evidence: adjusts stack by 8 then returns; no calls or side effects
; Preconditions: none
; Postconditions: returns immediately; no observable effects

; Only the necessary external declarations:
; (none)

define dso_local void @_term_proc() local_unnamed_addr {
entry:
  ret void
}