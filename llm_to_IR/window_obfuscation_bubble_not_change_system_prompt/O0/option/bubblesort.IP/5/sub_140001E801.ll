; ModuleID = 'sub_140001E80_module'
target triple = "x86_64-pc-windows-msvc"

@unk_140007100 = external global i8

declare void @sub_1400DC968(i8*)
declare void @loc_1400ADE72()
declare void @loc_1403E33B2()

define dso_local void @sub_140001E80(i8* %rbx_init, i8* %rbp_fnptr, i8* %rdi_fnptr) local_unnamed_addr {
entry:
  call void @sub_1400DC968(i8* @unk_140007100)
  %cmp_rbx_null = icmp eq i8* %rbx_init, null
  br i1 %cmp_rbx_null, label %endprep, label %loop

loop:                                             ; preds = %entry, %aftercall
  %node = phi i8* [ %rbx_init, %entry ], [ %next, %aftercall ]
  %valptr = bitcast i8* %node to i32*
  %ecx_val = load i32, i32* %valptr, align 4
  %rbp_cast = bitcast i8* %rbp_fnptr to i8* (i32)*
  %rsi_ptr = call i8* %rbp_cast(i32 %ecx_val)
  %rdi_cast = bitcast i8* %rdi_fnptr to i32 ()*
  %eax_ret = call i32 %rdi_cast()
  %c1 = icmp ne i8* %rsi_ptr, null
  %c2 = icmp eq i32 %eax_ret, 0
  %cond_both = and i1 %c1, %c2
  br i1 %cond_both, label %doind, label %skip

doind:                                            ; preds = %loop
  %fp_field_ptr = getelementptr i8, i8* %node, i64 8
  %fp_field_ptr_cast = bitcast i8* %fp_field_ptr to i8**
  %fp_indirect = load i8*, i8** %fp_field_ptr_cast, align 8
  %fp_indirect_cast = bitcast i8* %fp_indirect to void (i8*)*
  call void %fp_indirect_cast(i8* %rsi_ptr)
  br label %aftercall

skip:                                             ; preds = %loop
  br label %aftercall

aftercall:                                        ; preds = %skip, %doind
  %next_ptr = getelementptr i8, i8* %node, i64 16
  %next_ptr_cast = bitcast i8* %next_ptr to i8**
  %next = load i8*, i8** %next_ptr_cast, align 8
  %has_next = icmp ne i8* %next, null
  br i1 %has_next, label %loop, label %endprep

endprep:                                          ; preds = %aftercall, %entry
  call void @loc_1403E33B2()
  ret void
}