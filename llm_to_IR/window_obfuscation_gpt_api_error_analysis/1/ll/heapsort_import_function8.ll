I can generate LLVM 14 IR for this function, but to satisfy your strict rules (especially 3, 4, 7, 8, and 10) I need a few specifics:

- Target triple and data layout to use. Is this x86_64-pc-windows-msvc?
- Exact prototypes for the external functions:
  - sub_140002690 returns i32? Any args?
  - sub_1400028E0 takes i64 and returns i64?
  - sub_140001B30 signature (looks like void(i8*)?).
  - sub_140002B78 signature (looks like void(i8*, i8*, i32)?).
  - sub_140001AD0 is variadic printf-like (i32(i8*, ...))?
  - loc_1400298F9 signature (void()?) or something else?
- Clarify the external globals:
  - off_1400043C0 and off_1400043B0 are the start/end of the pseudo-reloc list, correct?
  - off_1400043A0 is the image base?
  - dword_1400070A0, dword_1400070A4, qword_1400070A8 are writable globals?
- The callable function pointer used near 0x140001E9D (“call rdi”) appears to be loaded from off_1400043B0 earlier, but that same value is used in arithmetic as if it were the list end. Please confirm:
  - Is off_1400043B0 the list end, or a callback function pointer, or do we have two distinct globals and the disassembly conflated names?
- May I model the dynamic stack allocation with an alloca of size ceil16(0x28 * sub_140002690()) rather than literally calling sub_1400028E0 to compute the alignment, or should I preserve that call?
- Please confirm compiling with -fno-stack-protector is acceptable so I don’t need to reference __stack_chk_guard.

Once I have these, I’ll emit IR that:
- Uses unique SSA names
- Has exact-typed PHIs and loads/stores
- Declares all externs correctly
- Keeps string constants with exact lengths
- Avoids any undefined references and matches Windows x64 calling convention.