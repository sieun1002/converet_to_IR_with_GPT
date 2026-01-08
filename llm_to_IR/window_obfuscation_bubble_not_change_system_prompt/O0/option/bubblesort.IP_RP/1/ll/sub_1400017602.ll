; ModuleID = 'sub_140001760.ll'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external dso_local global i32
@qword_1400070A8 = external dso_local global i8*
@qword_140008260 = external dso_local global i8*
@aVirtualprotect = external dso_local global i8
@aVirtualqueryFa = external dso_local global i8
@aAddressPHasNoI = external dso_local global i8

declare dso_local i8* @sub_140002250(i8*)
declare dso_local i8* @sub_140002390()
declare dso_local i64 @loc_1403D6CC2(i8*, i8*, i32)
declare dso_local i32 @sub_1400E9A25(i8*, i8*, i32, i8*)
declare dso_local void @sub_140001700(i8*, ...)

define dso_local void @sub_140001760(i8* %0) {
entry:
  %frame = alloca [72 x i8], align 8
  %cnt = load i32, i32* @dword_1400070A4, align 4
  %cmp_le = icmp sle i32 %cnt, 0
  br i1 %cmp_le, label %L1890, label %L1779

L1779:                                            ; preds = %entry
  %base = load i8*, i8** @qword_1400070A8, align 8
  %rax_plus = getelementptr i8, i8* %base, i64 24
  br label %L1790

L1790:                                            ; preds = %L17ab, %L1779
  %i = phi i32 [ 0, %L1779 ], [ %i_next, %L17ab ]
  %off_i32 = mul i32 %i, 40
  %off = sext i32 %off_i32 to i64
  %cur = getelementptr i8, i8* %rax_plus, i64 %off
  %cur_q = bitcast i8* %cur to i8**
  %r8 = load i8*, i8** %cur_q, align 8
  %rbx_i = ptrtoint i8* %0 to i64
  %r8_i = ptrtoint i8* %r8 to i64
  %cmp_jb = icmp ult i64 %rbx_i, %r8_i
  br i1 %cmp_jb, label %L17ab, label %L1798

L1798:                                            ; preds = %L1790
  %cur_p8 = getelementptr i8, i8* %cur, i64 8
  %cur_p8_q = bitcast i8* %cur_p8 to i8**
  %rdxptr = load i8*, i8** %cur_p8_q, align 8
  %rdxptr_p8 = getelementptr i8, i8* %rdxptr, i64 8
  %size32p = bitcast i8* %rdxptr_p8 to i32*
  %size32 = load i32, i32* %size32p, align 4
  %size64 = zext i32 %size32 to i64
  %r8_i64 = ptrtoint i8* %r8 to i64
  %end_i = add i64 %r8_i64, %size64
  %cmp_jb2 = icmp ult i64 %rbx_i, %end_i
  br i1 %cmp_jb2, label %L1835, label %L17ab

L17ab:                                            ; preds = %L1798, %L1790
  %i_next = add i32 %i, 1
  %cmp_nz = icmp ne i32 %i_next, %cnt
  br i1 %cmp_nz, label %L1790, label %L17b8

L17b8:                                            ; preds = %L1890, %L17ab
  %esi_phi = phi i32 [ 0, %L1890 ], [ %cnt, %L17ab ]
  %res = call i8* @sub_140002250(i8* %0)
  %isnull = icmp eq i8* %res, null
  br i1 %isnull, label %L18b2, label %L17cc

L17cc:                                            ; preds = %L17b8
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %esi64 = sext i32 %esi_phi to i64
  %mul5 = mul nsw i64 %esi64, 5
  %rbxOff = shl i64 %mul5, 3
  %entry_rec = getelementptr i8, i8* %base2, i64 %rbxOff
  %p20 = getelementptr i8, i8* %entry_rec, i64 32
  %p20_q = bitcast i8* %p20 to i8**
  store i8* %res, i8** %p20_q, align 8
  %dw0 = bitcast i8* %entry_rec to i32*
  store i32 0, i32* %dw0, align 4
  %baseA = call i8* @sub_140002390()
  %rdi_p0c = getelementptr i8, i8* %res, i64 12
  %rdi_p0c_i32 = bitcast i8* %rdi_p0c to i32*
  %edx32 = load i32, i32* %rdi_p0c_i32, align 4
  %edx64 = zext i32 %edx32 to i64
  %rcx_ptr = getelementptr i8, i8* %baseA, i64 %edx64
  %base3 = load i8*, i8** @qword_1400070A8, align 8
  %entry2 = getelementptr i8, i8* %base3, i64 %rbxOff
  %p18 = getelementptr i8, i8* %entry2, i64 24
  %p18_q = bitcast i8* %p18 to i8**
  store i8* %rcx_ptr, i8** %p18_q, align 8
  %frame_ptr = getelementptr [72 x i8], [72 x i8]* %frame, i64 0, i64 0
  %callq = call i64 @loc_1403D6CC2(i8* %rcx_ptr, i8* %frame_ptr, i32 48)
  %iszero = icmp eq i64 %callq, 0
  br i1 %iszero, label %L1897, label %L181a

L181a:                                            ; preds = %L17cc
  %var24_i8 = getelementptr i8, i8* %frame_ptr, i64 36
  %var24_i32p = bitcast i8* %var24_i8 to i32*
  %eax32 = load i32, i32* %var24_i32p, align 4
  %t1 = add i32 %eax32, -4
  %t2 = and i32 %t1, -5
  %jz1 = icmp eq i32 %t2, 0
  br i1 %jz1, label %L182e, label %L1826

L1826:                                            ; preds = %L181a
  %t3 = add i32 %eax32, -64
  %t4 = and i32 %t3, -65
  %jnz2 = icmp ne i32 %t4, 0
  br i1 %jnz2, label %L1840, label %L182e

L182e:                                            ; preds = %L1826, %L181a
  %old = load i32, i32* @dword_1400070A4, align 4
  %inc = add i32 %old, 1
  store i32 %inc, i32* @dword_1400070A4, align 4
  br label %ret

L1840:                                            ; preds = %L1826
  %cmpeq2 = icmp eq i32 %eax32, 2
  %var48_q = bitcast i8* %frame_ptr to i8**
  %rcx_load = load i8*, i8** %var48_q, align 8
  %var30_i8 = getelementptr i8, i8* %frame_ptr, i64 24
  %var30_q = bitcast i8* %var30_i8 to i8**
  %rdx_load = load i8*, i8** %var30_q, align 8
  %r8v = select i1 %cmpeq2, i32 4, i32 64
  %base4 = load i8*, i8** @qword_1400070A8, align 8
  %entry4 = getelementptr i8, i8* %base4, i64 %rbxOff
  %p8 = getelementptr i8, i8* %entry4, i64 8
  %p8_q = bitcast i8* %p8 to i8**
  store i8* %rcx_load, i8** %p8_q, align 8
  %p16 = getelementptr i8, i8* %entry4, i64 16
  %p16_q = bitcast i8* %p16 to i8**
  store i8* %rdx_load, i8** %p16_q, align 8
  %prot = call i32 @sub_1400E9A25(i8* %rcx_load, i8* %rdx_load, i32 %r8v, i8* %entry4)
  %succ = icmp ne i32 %prot, 0
  br i1 %succ, label %L182e, label %L1878

L1878:                                            ; preds = %L1840
  %fnaddr = load i8*, i8** @qword_140008260, align 8
  %fn = bitcast i8* %fnaddr to i32 ()*
  %code = call i32 %fn()
  call void (i8*, ...) @sub_140001700(i8* @aVirtualprotect, i32 %code)
  br label %L1890

L1897:                                            ; preds = %L17cc
  %base5 = load i8*, i8** @qword_1400070A8, align 8
  %rdi_p8 = getelementptr i8, i8* %res, i64 8
  %rdi_p8_i32 = bitcast i8* %rdi_p8 to i32*
  %edx2 = load i32, i32* %rdi_p8_i32, align 4
  %entry5 = getelementptr i8, i8* %base5, i64 %rbxOff
  %p18_2 = getelementptr i8, i8* %entry5, i64 24
  %p18_2_q = bitcast i8* %p18_2 to i8**
  %r8_load = load i8*, i8** %p18_2_q, align 8
  call void (i8*, ...) @sub_140001700(i8* @aVirtualqueryFa, i32 %edx2, i8* %r8_load)
  br label %L18b2

L18b2:                                            ; preds = %L1897, %L17b8
  call void (i8*, ...) @sub_140001700(i8* @aAddressPHasNoI, i8* %0)
  br label %ret

L1835:                                            ; preds = %L1798
  br label %ret

L1890:                                            ; preds = %entry, %L1878
  br label %L17b8

ret:                                              ; preds = %L1835, %L18b2, %L182e
  ret void
}