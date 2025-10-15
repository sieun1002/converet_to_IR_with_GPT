I can translate this function to LLVM IR, but I need a few specifics to make the IR valid and linkable per your rules:

- Target triple: please confirm (e.g., x86_64-w64-windows-gnu, x86_64-pc-windows-msvc).
- Calling convention: should I use the default C calling convention for all externals, or specific Windows x64 conventions?
- External symbols:
  - Should I declare these as extern (no definitions) in this module? sub_140002690, sub_1400028E0, sub_140001B30, sub_140002B78, sub_140001AD0, loc_1400298F9.
  - Globals: dword_1400070A0, dword_1400070A4, qword_1400070A8, off_1400043A0, off_1400043B0, off_1400043C0. Should these be extern globals, or should I provide tentative definitions (with zero initializers) here?
- Strings: I can embed the three format strings referenced; confirm you’re okay with me defining them as private unnamed_addr constants in this module.
- Return type: This function appears to return void; please confirm.

Once I have this, I’ll produce LLVM 14 IR that:
- Uses only valid LLVM opcodes (no plain assignments).
- Keeps unique SSA values.
- Matches integer vs floating constants and exact array sizes for the strings.
- Declares externals properly.
- Avoids stack protector references and uses a variable-sized alloca for the temporary record buffer (aligned to 16).