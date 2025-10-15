I can generate correct LLVM 14 IR for this routine, but I need a few specifics to avoid violating the constraints (correct types, no undefined values, exact extern decls, and matching target):

Please provide:
- Target triple you want (e.g., x86_64-pc-windows-msvc or x86_64-w64-windows-gnu). Rule 10 requires this to match your build env.
- The precise C-like prototypes (or at least parameter/return types) for all external symbols referenced:
  - qword_140008280 (indirect call target; looks like Sleep: int Sleep(int) but please confirm)
  - sub_140002A20, sub_14000171D, sub_140002A30, sub_140002B60, sub_140002B38, sub_140002AE0, sub_140002AD8, sub_140001910, sub_140002B48, sub_140002A60, sub_140002BB8, sub_140002AC0, sub_140002B40, sub_1400018F0, sub_140002B90, sub_140002070, sub_1400019D0, sub_140001CA0, sub_14001E978, sub_1400024E0
  - The call via off_1400043D0 (appears to be void (*)(int,int,int), but confirm)
  - The indirect calls at loc_140002B4D+3 and loc_140002B0D+3 and loc_140002B75+3 look like thunks; please provide their real targets and prototypes.
- Exact types for all external globals:
  - off_140004450 (appears to be i8** pointing to a lock-owner slot of type i8*)
  - off_140004460 (appears to be i32* state variable)
  - dword_140007004, dword_140007008, dword_140007020 (i32?)
  - qword_140007010 (pointer-sized opaque payload), qword_140007018 (i8** vector)
  - off_1400043D0 (pointer to function pointer: void (i32,i32,i32)**?)
  - off_140004410, off_140004420, off_140004430 (each looks like i32* flagged to 1)
  - off_1400043A0 (module base; used as bytes/words/dwords)
  - off_140004400 (i32* or similar; read then used to branch)
  - off_1400044D0, off_1400044B0 (i32* sources copied into buffers returned by sub_140002AE0/AD8)
  - off_140004380, off_1400043E0 (i32* flags)
  - off_1400044A0, off_140004490 (arguments to sub_140002B48)
  - off_140004500 (i32* used as input to sub_140002A60)
  - off_1400044C0 (i32* providing r9d to sub_140002A60)
  - off_140004480, off_140004470 (arguments to sub_140002B40)

Notes:
- The bytes between calls around 0x14000111C–0x14000113A decode as bogus instructions in your dump; they are almost certainly data/unwind info. I will omit them in IR and preserve only the actual call semantics.
- The code uses a re-entrant spin/owner lock with cmpxchg on [*off_140004450] and a same-thread check using gs:[0x30]+8 as an owner token. LLVM IR cannot directly read gs; I can model the token via an extern helper (e.g., i8* @GetCurrentThreadOwnerToken()) unless you prefer an intrinsic-based implementation.
- If you compile with stack protector enabled, please confirm whether __stack_chk_guard is required; otherwise compile with -fno-stack-protector per rule 9.

Once you confirm the target triple and these symbol types/prototypes, I will emit a single, well-typed LLVM 14 IR definition of sub_140001010 with:
- Unique SSA values
- Proper atomic cmpxchg on the lock slot
- Correct PHI edges and dominance
- Exact external decls
- No undefined references