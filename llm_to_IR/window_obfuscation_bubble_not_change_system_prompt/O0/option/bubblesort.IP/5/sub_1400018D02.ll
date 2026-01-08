; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

; extern globals
@dword_1400070A0 = external global i32, align 4
@off_1400043D0 = external global i8*, align 8
@off_1400043E0 = external global i8*, align 8
@off_1400043C0 = external global i8*, align 8
@dword_1400070A4 = external global i32, align 4
@qword_1400070A8 = external global i8*, align 8

; external strings (unknown sizes/content; declared as byte symbols)
@aUnknownPseudoR = external constant i8, align 1
@aDBitPseudoRelo = external constant i8, align 1
@aUnknownPseudoR_0 = external constant i8, align 1

; extern functions
declare i32 @sub_1400022D0()
declare i64 @sub_140002520()
declare void @sub_140001760(i8*)
declare void @sub_140001700(i8*, ...)
declare i32 @sub_1400BF822()

define void @sub_1400018D0() local_unnamed_addr {
entry:
  %var48 = alloca i64, align 8
  %var60 = alloca i64, align 8
  %var50 = alloca [24 x i8], align 8
  %g0 = load i32, i32* @dword_1400070A0, align 4
  %tst = icmp eq i32 %g0, 0
  br i1 %tst, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %c0 = call i32 @sub_1400022D0()
  %c0sx = sext i32 %c0 to i64
  %mul5 = mul nsw i64 %c0sx, 5
  %mul40 = shl i64 %mul5, 3
  %add15 = add i64 %mul40, 15
  %aligned = and i64 %add15, -16
  %chk = call i64 @sub_140002520()
  %dyn = alloca i8, i64 %chk, align 16
  store i32 0, i32* @dword_1400070A4, align 4
  %var50_i8 = getelementptr inbounds [24 x i8], [24 x i8]* %var50, i64 0, i64 0
  store i8* %var50_i8, i8** @qword_1400070A8, align 8
  %rdi = load i8*, i8** @off_1400043D0, align 8
  %rbx = load i8*, i8** @off_1400043E0, align 8
  %rdi_i = ptrtoint i8* %rdi to i64
  %rbx_i = ptrtoint i8* %rbx to i64
  %diff = sub i64 %rdi_i, %rbx_i
  %le7 = icmp sle i64 %diff, 7
  br i1 %le7, label %ret, label %chk11

chk11:
  %gt11 = icmp sgt i64 %diff, 11
  br i1 %gt11, label %proto2_entry, label %proto1_check

; Version 1 header check
proto1_check:
  %rbx_i32p = bitcast i8* %rbx to i32*
  %h0 = load i32, i32* %rbx_i32p, align 4
  %h0nz = icmp ne i32 %h0, 0
  br i1 %h0nz, label %proto2_start_from_rbx, label %proto1_check2

proto1_check2:
  %rbx_p4 = getelementptr inbounds i8, i8* %rbx, i64 4
  %rbx_p4_i32p = bitcast i8* %rbx_p4 to i32*
  %h1 = load i32, i32* %rbx_p4_i32p, align 4
  %h1nz = icmp ne i32 %h1, 0
  br i1 %h1nz, label %proto2_start_from_rbx, label %proto1_check3

proto1_check3:
  %rbx_p8 = getelementptr inbounds i8, i8* %rbx, i64 8
  %rbx_p8_i32p = bitcast i8* %rbx_p8 to i32*
  %h2 = load i32, i32* %rbx_p8_i32p, align 4
  %is_v1 = icmp eq i32 %h2, 1
  br i1 %is_v1, label %proto1_prep, label %unknown_protocol

unknown_protocol:
  call void (i8*, ...) @sub_140001700(i8* @aUnknownPseudoR_0)
  br label %ret

proto1_prep:
  %rbx_add12 = getelementptr inbounds i8, i8* %rbx, i64 12
  %r14 = load i8*, i8** @off_1400043C0, align 8
  %r12p = bitcast i64* %var48 to i8*
  %rbx_add12_i = ptrtoint i8* %rbx_add12 to i64
  %jb = icmp ult i64 %rbx_add12_i, %rdi_i
  br i1 %jb, label %proto1_loop, label %ret

; Version 1 loop over 12-byte entries
proto1_loop:
  %rbx_cur = phi i8* [ %rbx_add12, %proto1_prep ], [ %rbx_next, %after_case ]
  %rbx_cur_i32p = bitcast i8* %rbx_cur to i32*
  %off32 = load i32, i32* %rbx_cur_i32p, align 4
  %rbx_cur_p4 = getelementptr inbounds i8, i8* %rbx_cur, i64 4
  %rbx_cur_p4_i32p = bitcast i8* %rbx_cur_p4 to i32*
  %val32 = load i32, i32* %rbx_cur_p4_i32p, align 4
  %rbx_cur_p8 = getelementptr inbounds i8, i8* %rbx_cur, i64 8
  %rbx_cur_p8_i32p = bitcast i8* %rbx_cur_p8 to i32*
  %bits = load i32, i32* %rbx_cur_p8_i32p, align 4
  %cl = and i32 %bits, 255
  %off32_z = zext i32 %off32 to i64
  %val32_z = zext i32 %val32 to i64
  %r8ptr = getelementptr inbounds i8, i8* %r14, i64 %off32_z
  %r8ptr_i64p = bitcast i8* %r8ptr to i64*
  %r9 = load i64, i64* %r8ptr_i64p, align 8
  %r15ptr = getelementptr inbounds i8, i8* %r14, i64 %val32_z
  %is32 = icmp eq i32 %cl, 32
  br i1 %is32, label %case32, label %leq32

leq32:
  %le32 = icmp ule i32 %cl, 32
  br i1 %le32, label %small_cases, label %check64

small_cases:
  %is8 = icmp eq i32 %cl, 8
  br i1 %is8, label %case8, label %chk16

chk16:
  %is16 = icmp eq i32 %cl, 16
  br i1 %is16, label %case16, label %unknown_bit

check64:
  %is64 = icmp eq i32 %cl, 64
  br i1 %is64, label %case64, label %unknown_bit

unknown_bit:
  store i64 0, i64* %var48, align 8
  call void (i8*, ...) @sub_140001700(i8* @aUnknownPseudoR)
  br label %ret

; 32-bit case
case32:
  %r15ptr_i32p = bitcast i8* %r15ptr to i32*
  %v32 = load i32, i32* %r15ptr_i32p, align 4
  %v32sx = sext i32 %v32 to i64
  %r8_i = ptrtoint i8* %r8ptr to i64
  %tmp32 = sub i64 %v32sx, %r8_i
  %rel32 = add i64 %tmp32, %r9
  store i64 %rel32, i64* %var48, align 8
  %flg32 = and i32 %bits, 192
  %zflg32 = icmp eq i32 %flg32, 0
  br i1 %zflg32, label %chk_range32, label %emit32

chk_range32:
  %hiok32 = icmp sle i64 %rel32, 4294967295
  %l_ok32 = icmp sge i64 %rel32, -2147483648
  %ok32 = and i1 %hiok32, %l_ok32
  br i1 %ok32, label %emit32, label %range_error

emit32:
  call void @sub_140001760(i8* %r15ptr)
  %fp32 = inttoptr i64 5368720056 to void (i8*, i8*, i32)*
  call void %fp32(i8* %r15ptr, i8* %r12p, i32 4)
  br label %after_case

; 8-bit case
case8:
  %v8 = load i8, i8* %r15ptr, align 1
  %v8sx = sext i8 %v8 to i64
  %r8_i8 = ptrtoint i8* %r8ptr to i64
  %tmp8 = sub i64 %v8sx, %r8_i8
  %rel8 = add i64 %tmp8, %r9
  store i64 %rel8, i64* %var48, align 8
  %flg8 = and i32 %bits, 192
  %zflg8 = icmp eq i32 %flg8, 0
  br i1 %zflg8, label %chk_range8, label %emit8

chk_range8:
  %hiok8 = icmp sle i64 %rel8, 255
  %lowok8 = icmp sge i64 %rel8, -128
  %ok8 = and i1 %hiok8, %lowok8
  br i1 %ok8, label %emit8, label %range_error

emit8:
  call void @sub_140001760(i8* %r15ptr)
  %fp8 = inttoptr i64 5368720056 to void (i8*, i8*, i32)*
  call void %fp8(i8* %r15ptr, i8* %r12p, i32 1)
  br label %after_case

; 16-bit case
case16:
  %v16p = bitcast i8* %r15ptr to i16*
  %v16 = load i16, i16* %v16p, align 2
  %v16sx = sext i16 %v16 to i64
  %r8_i16 = ptrtoint i8* %r8ptr to i64
  %tmp16 = sub i64 %v16sx, %r8_i16
  %rel16 = add i64 %tmp16, %r9
  store i64 %rel16, i64* %var48, align 8
  %flg16 = and i32 %bits, 192
  %zflg16 = icmp eq i32 %flg16, 0
  br i1 %zflg16, label %chk_range16, label %emit16

chk_range16:
  %hiok16 = icmp sle i64 %rel16, 65535
  %lowok16 = icmp sge i64 %rel16, -32768
  %ok16 = and i1 %hiok16, %lowok16
  br i1 %ok16, label %emit16, label %range_error

emit16:
  call void @sub_140001760(i8* %r15ptr)
  %fp16 = inttoptr i64 5368720056 to void (i8*, i8*, i32)*
  call void %fp16(i8* %r15ptr, i8* %r12p, i32 2)
  br label %after_case

; 64-bit case
case64:
  %r15ptr_i64p = bitcast i8* %r15ptr to i64*
  %v64 = load i64, i64* %r15ptr_i64p, align 8
  %r8_i64 = ptrtoint i8* %r8ptr to i64
  %tmp64 = sub i64 %v64, %r8_i64
  %rel64 = add i64 %tmp64, %r9
  store i64 %rel64, i64* %var48, align 8
  %flg64 = and i32 %bits, 192
  %zflg64 = icmp eq i32 %flg64, 0
  br i1 %zflg64, label %chk_range64, label %emit64

chk_range64:
  %neg64 = icmp slt i64 %rel64, 0
  br i1 %neg64, label %emit64, label %range_error

emit64:
  call void @sub_140001760(i8* %r15ptr)
  %fp64 = inttoptr i64 5368720056 to void (i8*, i8*, i32)*
  call void %fp64(i8* %r15ptr, i8* %r12p, i32 8)
  br label %after_case

after_case:
  %rbx_next = getelementptr inbounds i8, i8* %rbx_cur, i64 12
  %rbx_next_i = ptrtoint i8* %rbx_next to i64
  %cont = icmp ult i64 %rbx_next_i, %rdi_i
  br i1 %cont, label %proto1_loop, label %post_scan

range_error:
  store i64 0, i64* %var60, align 8
  store i64 0, i64* %var60, align 8
  %relin = load i64, i64* %var48, align 8
  store i64 %relin, i64* %var60, align 8
  call void (i8*, ...) @sub_140001700(i8* @aDBitPseudoRelo)
  br label %ret

post_scan:
  %cA4 = load i32, i32* @dword_1400070A4, align 4
  %gt0 = icmp sgt i32 %cA4, 0
  br i1 %gt0, label %call_finalize, label %ret

call_finalize:
  %fret = call i32 @sub_1400BF822()
  br label %ret

; Version 2 path (minimal loop reflecting 8-byte entries)
proto2_entry:
  %rbx_ge = icmp uge i64 %rbx_i, %rdi_i
  br i1 %rbx_ge, label %ret, label %proto2_loop

proto2_start_from_rbx:
  %rbx_ge2 = icmp uge i64 %rbx_i, %rdi_i
  br i1 %rbx_ge2, label %ret, label %proto2_loop

proto2_loop:
  %rbx2 = phi i8* [ %rbx, %proto2_entry ], [ %rbx_next2, %proto2_loop_body ], [ %rbx, %proto2_start_from_rbx ]
  %r14v2 = load i8*, i8** @off_1400043C0, align 8
  %r13p = bitcast i64* %var48 to i8*
  %off2_p4 = getelementptr inbounds i8, i8* %rbx2, i64 4
  %off2_p4_i32p = bitcast i8* %off2_p4 to i32*
  %off2 = load i32, i32* %off2_p4_i32p, align 4
  %rbx2_i32p = bitcast i8* %rbx2 to i32*
  %add2 = load i32, i32* %rbx2_i32p, align 4
  %rbx_next2 = getelementptr inbounds i8, i8* %rbx2, i64 8
  %off2_z = zext i32 %off2 to i64
  %tgt = getelementptr inbounds i8, i8* %r14v2, i64 %off2_z
  %tgt32p = bitcast i8* %tgt to i32*
  %cur = load i32, i32* %tgt32p, align 4
  %sum = add i32 %cur, %add2
  %var48_i32p = bitcast i64* %var48 to i32*
  store i32 %sum, i32* %var48_i32p, align 4
  call void @sub_140001760(i8* %tgt)
  %fp2 = inttoptr i64 5368720056 to void (i8*, i8*, i32)*
  call void %fp2(i8* %tgt, i8* %r13p, i32 4)
  %rbx_next2_i = ptrtoint i8* %rbx_next2 to i64
  %more = icmp ult i64 %rbx_next2_i, %rdi_i
  br i1 %more, label %proto2_loop_body, label %post_scan

proto2_loop_body:
  br label %proto2_loop

ret:
  ret void
}