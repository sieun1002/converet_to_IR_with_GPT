I can translate this to LLVM 14 IR, but to emit correct, linkable IR under your rules I need a few specifics that aren’t derivable from the snippet:

1) Target details
- Exact target triple (e.g., x86_64-pc-windows-msvc, x86_64-w64-mingw32, etc.)
- Data layout if you require one

2) External symbol prototypes
Please provide or confirm the exact types (return and parameter types, calling convention) for each external you want referenced, so types strictly match:
- Functions:
  - sub_140002A20
  - sub_14000171D
  - sub_140002A30
  - sub_140002AE0
  - sub_140002AD8
  - sub_140002AC0
  - sub_140002A60
  - sub_140002BB8
  - sub_140002B78
  - sub_140002B38
  - sub_140002B48
  - sub_140002B40
  - sub_140002B60
  - sub_140001910
  - sub_1400018F0
  - sub_1400019D0
  - sub_140001CA0
  - sub_140002070
  - loc_1403DADE6
  - near ptr loc_140002B4D+3
  - near ptr loc_140002B0D+3
  - loc_140002B90
  - qword_140008280 target function (looks like Sleep: int32 millis)
- Globals (with pointee types and volatility if any):
  - off_140004450    ; lock location pointer
  - off_140004460    ; state word location (read/set to 0,1,2)
  - dword_140007004
  - off_1400043D0    ; callback pointer-to-pointer, called with (ecx=0, edx=2, r8=0)
  - qword_140007010
  - qword_140007018
  - dword_140007020
  - dword_140007008
  - off_140004440
  - off_140004410
  - off_140004420
  - off_140004430
  - off_1400043A0     ; PE header base
  - off_140004400
  - off_1400044D0
  - off_1400044B0
  - off_140004380
  - off_1400043E0
  - off_1400044A0
  - off_140004490
  - off_140004500
  - off_1400044C0
  - off_140004480
  - off_140004470

3) TEB/GS access
The lock owner uses rsi = qword ptr [gs:0x30]+8. Do you want this modeled literally (as inline asm/intrinsic to read GS and load +8), or replaced by a provided external helper returning a unique per‑thread token? If literally, please confirm Windows x64 ABI and allow inline asm or provide an intrinsic to fetch that value.

4) Stack protector
Confirm compilation without stack protector (-fno-stack-protector), or provide the expected __stack_chk_guard/__stack_chk_fail symbols.

Once I have these, I’ll emit a single LLVM 14 IR function definition for sub_140001010 with:
- A lock acquisition loop using cmpxchg on the pointer loaded from off_140004450
- Reentrancy detection when the previous owner equals the current thread token
- The full control-flow and calls as in your listing
- Strictly typed externs/globals and no undefined references
- No plain assignments; valid opcodes only
- Correct PHI nodes where needed

If you prefer, I can also propose reasonable prototypes inferred from the call sites and Windows x64 calling convention and proceed, but please confirm that’s acceptable so we don’t violate your type-matching rule.