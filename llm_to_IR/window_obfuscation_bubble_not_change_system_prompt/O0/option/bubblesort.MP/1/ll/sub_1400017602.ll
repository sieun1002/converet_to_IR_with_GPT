; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32, align 4
@qword_1400070A8 = external global i8*, align 8
@qword_140008298 = external global i8*, align 8
@qword_140008290 = external global i8*, align 8
@qword_140008260 = external global i8*, align 8

@aVirtualprotect = external global i8, align 1
@aVirtualqueryFa = external global i8, align 1
@aAddressPHasNoI = external global i8, align 1

declare i8* @sub_140002250(i8* noundef)
declare i8* @sub_140002390()
declare void @sub_140001700(i8* noundef, ...)

define void @sub_140001760(i8* %rcx) local_unnamed_addr {
entry:
  %mbi = alloca [48 x i8], align 8
  %rsi.slot = alloca i64, align 8
  %count32 = load i32, i32* @dword_1400070A4, align 4
  %rsi.init = sext i32 %count32 to i64
  store i64 %rsi.init, i64* %rsi.slot, align 8
  %cmp.le = icmp sle i32 %count32, 0
  br i1 %cmp.le, label %loc_140001890, label %init_search

init_search:                                      ; preds = %entry
  %base_ptr0 = load i8*, i8** @qword_1400070A8, align 8
  %cur0 = getelementptr i8, i8* %base_ptr0, i64 24
  br label %loop

loop:                                             ; preds = %iterate, %init_search
  %idx = phi i32 [ 0, %init_search ], [ %idx.next, %iterate ]
  %cur.phi = phi i8* [ %cur0, %init_search ], [ %cur.next, %iterate ]
  %rsi.cur = load i64, i64* %rsi.slot, align 8
  %idx.ext = sext i32 %idx to i64
  %cmp.eq = icmp eq i64 %idx.ext, %rsi.cur
  br i1 %cmp.eq, label %loc_1400017B8, label %body

body:                                             ; preds = %loop
  %r8.ptr = bitcast i8* %cur.phi to i8**
  %r8.val = load i8*, i8** %r8.ptr, align 8
  %rbx.int = ptrtoint i8* %rcx to i64
  %r8.int = ptrtoint i8* %r8.val to i64
  %cmp.jb1 = icmp ult i64 %rbx.int, %r8.int
  br i1 %cmp.jb1, label %iterate, label %check_end

check_end:                                        ; preds = %body
  %cur.plus8 = getelementptr i8, i8* %cur.phi, i64 8
  %rdx.ptrptr = bitcast i8* %cur.plus8 to i8**
  %rdx.val = load i8*, i8** %rdx.ptrptr, align 8
  %rdx.plus8 = getelementptr i8, i8* %rdx.val, i64 8
  %size32.ptr = bitcast i8* %rdx.plus8 to i32*
  %size32 = load i32, i32* %size32.ptr, align 4
  %size64 = zext i32 %size32 to i64
  %end.int = add i64 %r8.int, %size64
  %cmp.jb2 = icmp ult i64 %rbx.int, %end.int
  br i1 %cmp.jb2, label %epilogue_ret, label %iterate

iterate:                                          ; preds = %check_end, %body
  %idx.next = add i32 %idx, 1
  %cur.next = getelementptr i8, i8* %cur.phi, i64 40
  br label %loop

epilogue_ret:                                     ; preds = %check_end
  ret void

loc_1400017B8:                                    ; preds = %loop, %loc_140001890
  %call.sub_2250 = call i8* @sub_140002250(i8* %rcx)
  %cmp.null = icmp eq i8* %call.sub_2250, null
  br i1 %cmp.null, label %loc_1400018B2, label %create_entry

create_entry:                                     ; preds = %loc_1400017B8
  %base_ptr1 = load i8*, i8** @qword_1400070A8, align 8
  %rsi.for.entry = load i64, i64* %rsi.slot, align 8
  %mul5 = mul i64 %rsi.for.entry, 5
  %off.bytes = mul i64 %mul5, 8
  %entry.ptr = getelementptr i8, i8* %base_ptr1, i64 %off.bytes
  %entry.plus32 = getelementptr i8, i8* %entry.ptr, i64 32
  %entry.plus32.ptr = bitcast i8* %entry.plus32 to i8**
  store i8* %call.sub_2250, i8** %entry.plus32.ptr, align 8
  %entry.as.i32 = bitcast i8* %entry.ptr to i32*
  store i32 0, i32* %entry.as.i32, align 4
  %call.sub_2390 = call i8* @sub_140002390()
  %rdi.plus12 = getelementptr i8, i8* %call.sub_2250, i64 12
  %rdi.plus12.i32ptr = bitcast i8* %rdi.plus12 to i32*
  %edx.val = load i32, i32* %rdi.plus12.i32ptr, align 4
  %edx.zext = zext i32 %edx.val to i64
  %rcx.calc = getelementptr i8, i8* %call.sub_2390, i64 %edx.zext
  %entry.plus24 = getelementptr i8, i8* %entry.ptr, i64 24
  %entry.plus24.ptr = bitcast i8* %entry.plus24 to i8**
  store i8* %rcx.calc, i8** %entry.plus24.ptr, align 8
  %mbi.base = getelementptr [48 x i8], [48 x i8]* %mbi, i64 0, i64 0
  %fp298.raw = load i8*, i8** @qword_140008298, align 8
  %fp298 = bitcast i8* %fp298.raw to i64 (i8*, i8*, i64)*
  %vq.ret = call i64 %fp298(i8* %rcx.calc, i8* %mbi.base, i64 48)
  %vq.ok = icmp ne i64 %vq.ret, 0
  br i1 %vq.ok, label %after_vq_success, label %loc_140001897

after_vq_success:                                 ; preds = %create_entry
  %var24.off = getelementptr i8, i8* %mbi.base, i64 36
  %prot.ptr = bitcast i8* %var24.off to i32*
  %prot.val = load i32, i32* %prot.ptr, align 4
  %t1 = sub i32 %prot.val, 4
  %t2 = and i32 %t1, -5
  %z1 = icmp eq i32 %t2, 0
  br i1 %z1, label %loc_14000182E, label %check64

check64:                                          ; preds = %after_vq_success
  %t3 = sub i32 %prot.val, 64
  %t4 = and i32 %t3, -65
  %nz2 = icmp ne i32 %t4, 0
  br i1 %nz2, label %loc_140001840, label %loc_14000182E

loc_14000182E:                                    ; preds = %check64, %after_vq_success, %loc_140001874
  %oldcnt = load i32, i32* @dword_1400070A4, align 4
  %inc = add i32 %oldcnt, 1
  store i32 %inc, i32* @dword_1400070A4, align 4
  ret void

loc_140001840:                                    ; preds = %check64
  %var48.ptrptr = bitcast i8* %mbi.base to i8**
  %baseaddr = load i8*, i8** %var48.ptrptr, align 8
  %var30.off = getelementptr i8, i8* %mbi.base, i64 24
  %regionsize.ptr = bitcast i8* %var30.off to i64*
  %regionsize = load i64, i64* %regionsize.ptr, align 8
  %cmp.eax2 = icmp eq i32 %prot.val, 2
  %newprot.sel = select i1 %cmp.eax2, i32 4, i32 64
  %base_ptr2 = load i8*, i8** @qword_1400070A8, align 8
  %rsi.for.vp = load i64, i64* %rsi.slot, align 8
  %mul5b = mul i64 %rsi.for.vp, 5
  %off.bytes.b = mul i64 %mul5b, 8
  %entry.ptr.b = getelementptr i8, i8* %base_ptr2, i64 %off.bytes.b
  %entry.plus8 = getelementptr i8, i8* %entry.ptr.b, i64 8
  %entry.plus8.ptr = bitcast i8* %entry.plus8 to i8**
  store i8* %baseaddr, i8** %entry.plus8.ptr, align 8
  %entry.plus16 = getelementptr i8, i8* %entry.ptr.b, i64 16
  %entry.plus16.ptr = bitcast i8* %entry.plus16 to i64*
  store i64 %regionsize, i64* %entry.plus16.ptr, align 8
  %oldprotptr = bitcast i8* %entry.ptr.b to i32*
  %fp290.raw = load i8*, i8** @qword_140008290, align 8
  %fp290 = bitcast i8* %fp290.raw to i32 (i8*, i64, i32, i32*)*
  %vp.ret = call i32 %fp290(i8* %baseaddr, i64 %regionsize, i32 %newprot.sel, i32* %oldprotptr)
  %vp.ok = icmp ne i32 %vp.ret, 0
  br i1 %vp.ok, label %loc_14000182E, label %loc_vp_fail

loc_vp_fail:                                      ; preds = %loc_140001840
  %fp260.raw = load i8*, i8** @qword_140008260, align 8
  %fp260 = bitcast i8* %fp260.raw to i32 ()*
  %errcode = call i32 %fp260()
  call void (i8*, ...) @sub_140001700(i8* @aVirtualprotect, i32 %errcode)
  br label %loc_140001890

loc_140001890:                                    ; preds = %loc_vp_fail, %entry
  store i64 0, i64* %rsi.slot, align 8
  br label %loc_1400017B8

loc_140001897:                                    ; preds = %create_entry
  %base_ptr3 = load i8*, i8** @qword_1400070A8, align 8
  %edx.rdi8.ptr = getelementptr i8, i8* %call.sub_2250, i64 8
  %edx.rdi8.i32ptr = bitcast i8* %edx.rdi8.ptr to i32*
  %edx.rdi8 = load i32, i32* %edx.rdi8.i32ptr, align 4
  %rsi.for.msg = load i64, i64* %rsi.slot, align 8
  %mul5c = mul i64 %rsi.for.msg, 5
  %off.bytes.c = mul i64 %mul5c, 8
  %entry.ptr.c = getelementptr i8, i8* %base_ptr3, i64 %off.bytes.c
  %entry.plus24.c = getelementptr i8, i8* %entry.ptr.c, i64 24
  %entry.plus24.loadptr = bitcast i8* %entry.plus24.c to i8**
  %r8.msg = load i8*, i8** %entry.plus24.loadptr, align 8
  call void (i8*, ...) @sub_140001700(i8* @aVirtualqueryFa, i32 %edx.rdi8, i8* %r8.msg)
  br label %loc_1400018B2

loc_1400018B2:                                    ; preds = %loc_140001897, %loc_1400017B8
  call void (i8*, ...) @sub_140001700(i8* @aAddressPHasNoI, i8* %rcx)
  ret void
}