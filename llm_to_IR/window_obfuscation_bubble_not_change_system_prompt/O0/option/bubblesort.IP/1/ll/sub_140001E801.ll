; ModuleID = 'sub_140001E80'
target triple = "x86_64-pc-windows-msvc"

@unk_140007100 = external global i8, align 1

declare void @sub_1400DC968(i8*)
declare i8* @loc_1400ADE72()
declare void @loc_1403E33B2(i8*)

declare i64 @llvm.read_register.i64(metadata)
declare i8 @llvm.fshr.i8(i8, i8, i8)

define void @sub_140001E80() {
entry:
  %p0 = getelementptr i8, i8* @unk_140007100, i64 0
  call void @sub_1400DC968(i8* %p0)
  %rbx_in = call i64 @llvm.read_register.i64(metadata !0)
  %rbx_is_zero = icmp eq i64 %rbx_in, 0
  br i1 %rbx_is_zero, label %ed4, label %ea1

ea1:
  %rbp_const = zext i32 1141549896 to i64
  %rax1 = call i8* @loc_1400ADE72()
  %rcx_in = call i64 @llvm.read_register.i64(metadata !1)
  %cl = trunc i64 %rcx_in to i8
  %addr = getelementptr i8, i8* %rax1, i64 -117
  %oldb = load i8, i8* %addr, align 1
  %cnt = and i8 %cl, 31
  %rot = call i8 @llvm.fshr.i8(i8 %oldb, i8 %oldb, i8 %cnt)
  store i8 %rot, i8* %addr, align 1
  br label %loop

loop:
  %rbx_cur = phi i64 [ %rbx_in, %ea1 ], [ %next, %ecb ]
  %rbx_cur_i32p = inttoptr i64 %rbx_cur to i32*
  %ecx_val = load i32, i32* %rbx_cur_i32p, align 4
  %rbp_func = inttoptr i64 %rbp_const to i8* (i32)*
  %rsi_val = call i8* %rbp_func(i32 %ecx_val)
  %rdi_in = call i64 @llvm.read_register.i64(metadata !2)
  %rdi_func = inttoptr i64 %rdi_in to i32 ()*
  %eax2 = call i32 %rdi_func()
  %rsi_notnull = icmp ne i8* %rsi_val, null
  %eax_is_zero = icmp eq i32 %eax2, 0
  %do_call = and i1 %rsi_notnull, %eax_is_zero
  br i1 %do_call, label %call_indirect, label %ecb

call_indirect:
  %rbx_cur_i8p = inttoptr i64 %rbx_cur to i8*
  %fp_addr_i8 = getelementptr i8, i8* %rbx_cur_i8p, i64 8
  %fp_addr = bitcast i8* %fp_addr_i8 to i64*
  %fp_val = load i64, i64* %fp_addr, align 8
  %fp = inttoptr i64 %fp_val to void (i8*)*
  call void %fp(i8* %rsi_val)
  br label %ecb

ecb:
  %rbx_cur_i8p_b = inttoptr i64 %rbx_cur to i8*
  %next_addr_i8 = getelementptr i8, i8* %rbx_cur_i8p_b, i64 16
  %next_addr = bitcast i8* %next_addr_i8 to i64*
  %next = load i64, i64* %next_addr, align 8
  %has_next = icmp ne i64 %next, 0
  br i1 %has_next, label %loop, label %ed4

ed4:
  %p1 = getelementptr i8, i8* @unk_140007100, i64 0
  call void @loc_1403E33B2(i8* %p1)
  ret void
}

!0 = !{!"rbx"}
!1 = !{!"rcx"}
!2 = !{!"rdi"}