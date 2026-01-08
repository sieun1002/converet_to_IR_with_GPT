I’m unable to produce correct LLVM IR for sub_1400018D0 from the provided assembly without violating the constraints. Specifically, the function performs an indirect call through the register rdi (call rdi) after popping the caller’s saved rdi value (pop rdi at 0x140001A9E). In LLVM IR, that requires a well-defined SSA value for the function pointer, but the assembly does not reference any symbol for this target (it is not loaded from a named global and is not passed as a parameter in any standard calling register on x64 Windows). Introducing a synthetic global or parameter to carry this function pointer would violate rule 1 (do not invent symbols/logic) and rule 7 (never reference undefined values).

If you can provide:
- The identity/source of the function pointer invoked via rdi (a named external/global symbol or a formal parameter of sub_1400018D0), or
- A guarantee that the path containing call rdi is unreachable (e.g., dword_1400070A4 is never set nonzero by any callee),

I can generate IR that satisfies all listed rules.