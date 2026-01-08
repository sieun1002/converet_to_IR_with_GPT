I’m missing a critical block of instructions for sub_140001010 between 0x1400011e3 and 0x1400012c8. That region appears to set up values later used in the argv-processing loop (r15, r12, r13, rsi, rdi, and the value in rax passed to sub_1400027B8). Without it, I cannot produce valid LLVM IR that respects SSA and “no undefined values” (rules 3 and 7), nor can I construct correct PHI nodes (rule 4).

Please provide the missing assembly for:
- 0x1400011e3 through 0x1400012c7 (inclusive)

Also, to model the “call near ptr loc_140002775+3” correctly, I’ll represent it as a call to a function symbol with pointer arithmetic (ptrtoint @loc_140002775 + 3 → inttoptr → call). I will declare:
- declare void @loc_140002775(i32)

Unless you have a different expected prototype for that code pointer, please confirm. If you can share the actual symbol name and prototype for the target of loc_140002775, even better.

Planned external declarations (based on the provided assembly):
- declare i8** @sub_140002660()
- declare void @sub_140002880(i32, i8*, i8*)
- declare void @sub_1400018D0()
- declare i8* @sub_14000AA1D(i8*)
- declare void @sub_140002790()
- declare void @sub_140002120()
- declare i8* @sub_140002720()
- declare void @sub_1400027B8(i8*, i8*, i8*)
- declare i64 @sub_140002700(i8*)
- declare i8* @sub_1400027F8(i64)
- declare void @sub_140002670(i32)
- declare void @sub_140002780(i8*, i8*)

And external globals (content types chosen to match the access patterns you showed):
- @off_140004470: external global i64*          ; lock slot pointer
- @qword_140008280: external global i8*          ; function pointer (Sleep-like), called with (i32)
- @off_140004480: external global i32*           ; init-state pointer
- @dword_140007004: external global i32
- @off_1400043F0: external global i8*            ; -> [ptr] holds function pointer
- @qword_140007010: external global i8*
- @dword_140007020: external global i32
- @qword_140007018: external global i8*
- @off_140004460: external global i8*            ; -> [ptr] destination to store a pointer result
- @off_140004430: external global i32*           ; pointers to dwords to set to 1
- @off_140004440: external global i32*
- @off_140004450: external global i32*
- @off_1400043C0: external global i8*            ; image base
- @dword_140007008: external global i32
- @off_140004420: external global i32*
- @off_140004490: external global i8*
- @off_1400044A0: external global i8*
- @qword_140007018: external global i8*

Additional function symbols referenced as addresses (passed to other functions):
- declare void @sub_140001CB0()
- declare void @nullsub_1()

Target triple will be x86_64-pc-windows-msvc as required.

Once you provide the missing block (0x1400011e3–0x1400012c7) and confirm the prototype for loc_140002775(+3), I can emit the complete, type-correct LLVM 14 IR for sub_140001010 without inventing any logic.