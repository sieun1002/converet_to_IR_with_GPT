; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2030 = external constant <4 x i32>, align 16
@xmmword_2040 = external constant <4 x i32>, align 16
@qword_2050 = external global i64, align 8
@__stack_chk_guard = external global i64, align 8

@.str_found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str_not_found = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail() noreturn

define i32 @main() {
loc_1080:
  %frame = alloca [64 x i8], align 16
  %frame.base = getelementptr inbounds [64 x i8], [64 x i8]* %frame, i64 0, i64 0
  %p_var_58_i64 = bitcast i8* %frame.base to i64*
  %p_var_50_i8 = getelementptr inbounds i8, i8* %frame.base, i64 8
  %p_var_50_i32 = bitcast i8* %p_var_50_i8 to i32*
  %p_var_4C_i8 = getelementptr inbounds i8, i8* %frame.base, i64 12
  %p_var_48_i8 = getelementptr inbounds i8, i8* %frame.base, i64 16
  %p_var_48_vec = bitcast i8* %p_var_48_i8 to <4 x i32>*
  %p_var_38_i8 = getelementptr inbounds i8, i8* %frame.base, i64 32
  %p_var_38_vec = bitcast i8* %p_var_38_i8 to <4 x i32>*
  %p_var_28_i8 = getelementptr inbounds i8, i8* %frame.base, i64 48
  %p_var_28_i32 = bitcast i8* %p_var_28_i8 to i32*
  %p_var_20_i8 = getelementptr inbounds i8, i8* %frame.base, i64 56
  %p_var_20_i64 = bitcast i8* %p_var_20_i8 to i64*
  %fmt_found.ptr = bitcast [21 x i8]* @.str_found to i8*
  %fmt_notfound.ptr = bitcast [21 x i8]* @.str_not_found to i8*
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %p_var_20_i64, align 8
  %vec1 = load <4 x i32>, <4 x i32>* @xmmword_2030, align 16
  store <4 x i32> %vec1, <4 x i32>* %p_var_48_vec, align 16
  %vec2 = load <4 x i32>, <4 x i32>* @xmmword_2040, align 16
  store <4 x i32> %vec2, <4 x i32>* %p_var_38_vec, align 16
  %q2050 = load i64, i64* @qword_2050, align 8
  store i64 %q2050, i64* %p_var_58_i64, align 8
  store i32 -5, i32* %p_var_50_i32, align 4
  store i32 12, i32* %p_var_28_i32, align 4
  %arr.base.i32 = bitcast i8* %p_var_48_i8 to i32*
  %r12.slot = alloca i8*, align 8
  store i8* %frame.base, i8** %r12.slot, align 8
  br label %loc_10E0

loc_10E0:                                           ; preds = %loc_1127, %loc_1080
  %r12.cur = load i8*, i8** %r12.slot, align 8
  %key.ptr.i32 = bitcast i8* %r12.cur to i32*
  %esi.val = load i32, i32* %key.ptr.i32, align 4
  %rcx.init = add i64 0, 0
  %rdx.init = add i64 0, 9
  br label %loc_1105

loc_1105:                                           ; preds = %loc_1150, %loc_1102, %loc_10E0
  %rcx.phi = phi i64 [ %rcx.init, %loc_10E0 ], [ %rcx.plus1, %loc_1150 ], [ %rcx.phi, %loc_1102 ]
  %rdx.phi = phi i64 [ %rdx.init, %loc_10E0 ], [ %rdx.phi, %loc_1150 ], [ %rax.mid, %loc_1102 ]
  %esi.phi = phi i32 [ %esi.val, %loc_10E0 ], [ %esi.phi, %loc_1150 ], [ %esi.phi, %loc_1102 ]
  %cmp.rcx.rdx = icmp ult i64 %rcx.phi, %rdx.phi
  br i1 %cmp.rcx.rdx, label %loc_10F0, label %loc_110A

loc_10F0:                                           ; preds = %loc_1105
  %sub.rd.rc = sub i64 %rdx.phi, %rcx.phi
  %shr1 = lshr i64 %sub.rd.rc, 1
  %rax.mid = add i64 %shr1, %rcx.phi
  %mid.ptr = getelementptr inbounds i32, i32* %arr.base.i32, i64 %rax.mid
  %mid.val = load i32, i32* %mid.ptr, align 4
  %cmp.jg = icmp sgt i32 %esi.phi, %mid.val
  br i1 %cmp.jg, label %loc_1150, label %loc_1102

loc_1102:                                           ; preds = %loc_10F0
  br label %loc_1105

loc_1150:                                           ; preds = %loc_10F0
  %rcx.plus1 = add i64 %rax.mid, 1
  br label %loc_1105

loc_110A:                                           ; preds = %loc_1105
  %edx.from.esi = add i32 %esi.phi, 0
  %cmp.rcx.8 = icmp ugt i64 %rcx.phi, 8
  br i1 %cmp.rcx.8, label %loc_1156, label %loc_1112

loc_1112:                                           ; preds = %loc_110A
  %idx.ptr = getelementptr inbounds i32, i32* %arr.base.i32, i64 %rcx.phi
  %idx.val = load i32, i32* %idx.ptr, align 4
  %cmp.jnz = icmp ne i32 %esi.phi, %idx.val
  br i1 %cmp.jnz, label %loc_1156, label %loc_1118

loc_1118:                                           ; preds = %loc_1112
  %rcx.arg = add i64 %rcx.phi, 0
  %call.printf.found = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt_found.ptr, i32 %edx.from.esi, i64 %rcx.arg)
  br label %loc_1127

loc_1156:                                           ; preds = %loc_1112, %loc_110A
  %call.printf.miss = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt_notfound.ptr, i32 %edx.from.esi)
  br label %loc_1127

loc_1127:                                           ; preds = %loc_1156, %loc_1118
  %r12.old = load i8*, i8** %r12.slot, align 8
  %r12.next = getelementptr inbounds i8, i8* %r12.old, i64 4
  store i8* %r12.next, i8** %r12.slot, align 8
  %cmp.end = icmp ne i8* %p_var_4C_i8, %r12.next
  br i1 %cmp.end, label %loc_10E0, label %loc_1130

loc_1130:                                           ; preds = %loc_1127
  %saved.guard = load i64, i64* %p_var_20_i64, align 8
  %cur.guard = load i64, i64* @__stack_chk_guard, align 8
  %guard.diff = icmp ne i64 %saved.guard, %cur.guard
  br i1 %guard.diff, label %loc_116B, label %loc_1140

loc_1140:                                           ; preds = %loc_1130
  ret i32 0

loc_116B:                                           ; preds = %loc_1130
  call void @___stack_chk_fail()
  unreachable
}