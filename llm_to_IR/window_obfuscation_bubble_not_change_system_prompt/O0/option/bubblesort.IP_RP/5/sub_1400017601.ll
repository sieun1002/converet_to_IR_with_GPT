; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@qword_140008260 = external global i8*
@aVirtualprotect = external global [0 x i8]
@aVirtualqueryFa = external global [0 x i8]
@aAddressPHasNoI = external global [0 x i8]

declare i8* @sub_140002250(i8*)
declare i8* @sub_140002390()
declare i64 @loc_1403D6CC2(i8*, i8*, i64)
declare i32 @sub_1400E9A25(i8*, i64, i32, i8*, i64)
declare void @sub_140001700(i8*, ...)

define void @sub_140001760(i8* %rcx) local_unnamed_addr {
entry:
  %mbi = alloca [48 x i8], align 8
  %addr = ptrtoint i8* %rcx to i64
  %cnt = load i32, i32* @dword_1400070A4, align 4
  %le = icmp sle i32 %cnt, 0
  br i1 %le, label %call_common, label %loop_prep

loop_prep:                                           ; preds = %entry
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  %cur0 = getelementptr i8, i8* %base0, i64 24
  br label %loop

loop:                                                ; preds = %loop_cont, %loop_prep
  %cur = phi i8* [ %cur0, %loop_prep ], [ %cur.next, %loop_cont ]
  %j = phi i32 [ 0, %loop_prep ], [ %j.next, %loop_cont ]
  %p0 = bitcast i8* %cur to i8**
  %r8 = load i8*, i8** %p0, align 8
  %r8i = ptrtoint i8* %r8 to i64
  %ltl = icmp ult i64 %addr, %r8i
  br i1 %ltl, label %loop_cont, label %check_upper

check_upper:                                         ; preds = %loop
  %cur8 = getelementptr i8, i8* %cur, i64 8
  %p1 = bitcast i8* %cur8 to i8**
  %rdx.mem = load i8*, i8** %p1, align 8
  %rdx.mem8 = getelementptr i8, i8* %rdx.mem, i64 8
  %p2 = bitcast i8* %rdx.mem8 to i32*
  %len32 = load i32, i32* %p2, align 4
  %len64 = zext i32 %len32 to i64
  %end = add i64 %r8i, %len64
  %ltu = icmp ult i64 %addr, %end
  br i1 %ltu, label %ret_epilogue, label %loop_cont

loop_cont:                                           ; preds = %check_upper, %loop
  %j.next = add i32 %j, 1
  %cur.next = getelementptr i8, i8* %cur, i64 40
  %cmpj = icmp ne i32 %j.next, %cnt
  br i1 %cmpj, label %loop, label %call_common

call_common:                                         ; preds = %entry, %loop_cont, %call_common_from_fail
  %sival = phi i32 [ 0, %entry ], [ %cnt, %loop_cont ], [ 0, %call_common_from_fail ]
  %rdi = call i8* @sub_140002250(i8* %rcx)
  %isnull = icmp eq i8* %rdi, null
  br i1 %isnull, label %no_image_section, label %have_rdi

have_rdi:                                            ; preds = %call_common
  %sival64 = sext i32 %sival to i64
  %mul5 = mul i64 %sival64, 5
  %off = shl i64 %mul5, 3
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %entry.ptr = getelementptr i8, i8* %base1, i64 %off
  %ep32 = getelementptr i8, i8* %entry.ptr, i64 32
  %ep32p = bitcast i8* %ep32 to i8**
  store i8* %rdi, i8** %ep32p, align 8
  %entry.i32 = bitcast i8* %entry.ptr to i32*
  store i32 0, i32* %entry.i32, align 4
  %t = call i8* @sub_140002390()
  %rdi12 = getelementptr i8, i8* %rdi, i64 12
  %rdi12p = bitcast i8* %rdi12 to i32*
  %ofs32 = load i32, i32* %rdi12p, align 4
  %ofs64 = zext i32 %ofs32 to i64
  %rcx.addr = getelementptr i8, i8* %t, i64 %ofs64
  %ep24 = getelementptr i8, i8* %entry.ptr, i64 24
  %ep24p = bitcast i8* %ep24 to i8**
  store i8* %rcx.addr, i8** %ep24p, align 8
  %mbi.ptr = getelementptr [48 x i8], [48 x i8]* %mbi, i64 0, i64 0
  %vqret = call i64 @loc_1403D6CC2(i8* %rcx.addr, i8* %mbi.ptr, i64 48)
  %vqz = icmp eq i64 %vqret, 0
  br i1 %vqz, label %vq_failed, label %after_vq

after_vq:                                            ; preds = %have_rdi
  %prot.off = getelementptr i8, i8* %mbi.ptr, i64 36
  %prot.p = bitcast i8* %prot.off to i32*
  %prot = load i32, i32* %prot.p, align 4
  %m4 = sub i32 %prot, 4
  %m4a = and i32 %m4, -5
  %ok1 = icmp eq i32 %m4a, 0
  %m64 = sub i32 %prot, 64
  %m64a = and i32 %m64, -65
  %ok2 = icmp eq i32 %m64a, 0
  %ok = or i1 %ok1, %ok2
  br i1 %ok, label %inc_and_ret, label %try_vprotect

try_vprotect:                                        ; preds = %after_vq
  %is_ro = icmp eq i32 %prot, 2
  %newprot = select i1 %is_ro, i32 4, i32 64
  %ba.p = bitcast i8* %mbi.ptr to i8**
  %baseaddr = load i8*, i8** %ba.p, align 8
  %sz.off = getelementptr i8, i8* %mbi.ptr, i64 24
  %sz.p = bitcast i8* %sz.off to i64*
  %size = load i64, i64* %sz.p, align 8
  %ep8 = getelementptr i8, i8* %entry.ptr, i64 8
  %ep8p = bitcast i8* %ep8 to i8**
  store i8* %baseaddr, i8** %ep8p, align 8
  %ep16 = getelementptr i8, i8* %entry.ptr, i64 16
  %ep16p = bitcast i8* %ep16 to i64*
  store i64 %size, i64* %ep16p, align 8
  %protret = call i32 @sub_1400E9A25(i8* %baseaddr, i64 %size, i32 %newprot, i8* %entry.ptr, i64 %size)
  %prot_ok = icmp ne i32 %protret, 0
  br i1 %prot_ok, label %inc_and_ret, label %log_vprotect_fail

log_vprotect_fail:                                   ; preds = %try_vprotect
  %fpraw = load i8*, i8** @qword_140008260, align 8
  %fp = bitcast i8* %fpraw to i32 ()*
  %err = call i32 %fp()
  %fmtvp = getelementptr [0 x i8], [0 x i8]* @aVirtualprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001700(i8* %fmtvp, i32 %err)
  br label %call_common_from_fail

call_common_from_fail:                               ; preds = %log_vprotect_fail
  br label %call_common

vq_failed:                                           ; preds = %have_rdi
  %rdi8 = getelementptr i8, i8* %rdi, i64 8
  %rdi8p = bitcast i8* %rdi8 to i32*
  %val32 = load i32, i32* %rdi8p, align 4
  %addrstored.p = bitcast i8* %ep24 to i8**
  %addrstored = load i8*, i8** %addrstored.p, align 8
  %fmtvq = getelementptr [0 x i8], [0 x i8]* @aVirtualqueryFa, i64 0, i64 0
  call void (i8*, ...) @sub_140001700(i8* %fmtvq, i32 %val32, i8* %addrstored)
  br label %no_image_section

no_image_section:                                    ; preds = %vq_failed, %call_common
  %fmtno = getelementptr [0 x i8], [0 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001700(i8* %fmtno, i8* %rcx)
  br label %ret_epilogue

inc_and_ret:                                         ; preds = %try_vprotect, %after_vq
  %old = load i32, i32* @dword_1400070A4, align 4
  %inc = add i32 %old, 1
  store i32 %inc, i32* @dword_1400070A4, align 4
  br label %ret_epilogue

ret_epilogue:                                        ; preds = %inc_and_ret, %no_image_section, %check_upper
  ret void
}