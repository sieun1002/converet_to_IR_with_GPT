; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

@aVirtualprotect = external global i8*
@aVirtualqueryFa = external global i8*
@aAddressPHasNoI = external global i8*

declare i8* @sub_140002250(i8*)
declare i8* @sub_140002390()
declare i32 @loc_140012A4E(i8*, i8*, i32)
declare i32 @loc_1400D1740(i8*, i8*, i32, i8*)
declare i32 @sub_140001700(i8*, ...)

define void @sub_140001760(i8* %rcx) local_unnamed_addr {
entry:
  %buf = alloca [32 x i8], align 8
  %buf0 = getelementptr inbounds [32 x i8], [32 x i8]* %buf, i64 0, i64 0
  %buf24 = getelementptr inbounds [32 x i8], [32 x i8]* %buf, i64 0, i64 24
  %count = load i32, i32* @dword_1400070A4, align 4
  %cmp.le = icmp sle i32 %count, 0
  br i1 %cmp.le, label %bb_set0, label %bb_loop_init

bb_loop_init:                                      ; preds = %entry
  %base_ptr = load i8*, i8** @qword_1400070A8, align 8
  %p0 = getelementptr inbounds i8, i8* %base_ptr, i64 24
  br label %loop.header

loop.header:                                       ; preds = %advance, %bb_loop_init
  %p.phi = phi i8* [ %p0, %bb_loop_init ], [ %p.next, %advance ]
  %i.phi = phi i32 [ 0, %bb_loop_init ], [ %i.next, %advance ]
  %p.as.pp = bitcast i8* %p.phi to i8**
  %region.start = load i8*, i8** %p.as.pp, align 8
  %rcx.int = ptrtoint i8* %rcx to i64
  %start.int = ptrtoint i8* %region.start to i64
  %cmp.jb = icmp ult i64 %rcx.int, %start.int
  br i1 %cmp.jb, label %advance, label %check_inside

check_inside:                                      ; preds = %loop.header
  %p.plus8 = getelementptr inbounds i8, i8* %p.phi, i64 8
  %p.plus8.aspp = bitcast i8* %p.plus8 to i8**
  %rdx.ptr = load i8*, i8** %p.plus8.aspp, align 8
  %rdx.plus8 = getelementptr inbounds i8, i8* %rdx.ptr, i64 8
  %rdx.plus8.i32p = bitcast i8* %rdx.plus8 to i32*
  %size32 = load i32, i32* %rdx.plus8.i32p, align 4
  %size64 = zext i32 %size32 to i64
  %end.int = add i64 %start.int, %size64
  %cmp.jb2 = icmp ult i64 %rcx.int, %end.int
  br i1 %cmp.jb2, label %found_return, label %advance

advance:                                           ; preds = %check_inside, %loop.header
  %i.next = add i32 %i.phi, 1
  %p.next = getelementptr inbounds i8, i8* %p.phi, i64 40
  %cmp.ne = icmp ne i32 %i.next, %count
  br i1 %cmp.ne, label %loop.header, label %loop.exit

found_return:                                      ; preds = %check_inside
  ret void

loop.exit:                                         ; preds = %advance
  br label %notfound_start

bb_set0:                                           ; preds = %entry
  br label %notfound_start

notfound_start:                                    ; preds = %bb_set0, %loop.exit
  %rsi.phi = phi i32 [ 0, %bb_set0 ], [ %count, %loop.exit ]
  %rdi.val = call i8* @sub_140002250(i8* %rcx)
  %isnull = icmp eq i8* %rdi.val, null
  br i1 %isnull, label %no_image_section, label %after_rdi

after_rdi:                                         ; preds = %notfound_start
  %base.ptr2 = load i8*, i8** @qword_1400070A8, align 8
  %rsi64 = sext i32 %rsi.phi to i64
  %mul5 = mul nsw i64 %rsi64, 5
  %offset = shl i64 %mul5, 3
  %entry.ptr = getelementptr inbounds i8, i8* %base.ptr2, i64 %offset
  %field20 = getelementptr inbounds i8, i8* %entry.ptr, i64 32
  %field20.pp = bitcast i8* %field20 to i8**
  store i8* %rdi.val, i8** %field20.pp, align 8
  %entry.i32p = bitcast i8* %entry.ptr to i32*
  store i32 0, i32* %entry.i32p, align 4
  %rax2 = call i8* @sub_140002390()
  %rdi.plusC = getelementptr inbounds i8, i8* %rdi.val, i64 12
  %rdi.plusC.i32p = bitcast i8* %rdi.plusC to i32*
  %edxval = load i32, i32* %rdi.plusC.i32p, align 4
  %edx64b = zext i32 %edxval to i64
  %rcx.ptr2 = getelementptr inbounds i8, i8* %rax2, i64 %edx64b
  %field18 = getelementptr inbounds i8, i8* %entry.ptr, i64 24
  %field18.pp = bitcast i8* %field18 to i8**
  store i8* %rcx.ptr2, i8** %field18.pp, align 8
  %ret.eax = call i32 @loc_140012A4E(i8* %rcx.ptr2, i8* %buf0, i32 48)
  %var48.pp = bitcast i8* %buf0 to i8**
  %out.rcx = load i8*, i8** %var48.pp, align 8
  %var30.pp = bitcast i8* %buf24 to i8**
  %out.rdx = load i8*, i8** %var30.pp, align 8
  %cmp2 = icmp eq i32 %ret.eax, 2
  %r8d.sel = select i1 %cmp2, i32 4, i32 64
  %field8 = getelementptr inbounds i8, i8* %entry.ptr, i64 8
  %field8.pp = bitcast i8* %field8 to i8**
  store i8* %out.rcx, i8** %field8.pp, align 8
  %field10 = getelementptr inbounds i8, i8* %entry.ptr, i64 16
  %field10.pp = bitcast i8* %field10 to i8**
  store i8* %out.rdx, i8** %field10.pp, align 8
  %call.vp = call i32 @loc_1400D1740(i8* %out.rcx, i8* %out.rdx, i32 %r8d.sel, i8* %entry.ptr)
  ret void

no_image_section:                                  ; preds = %notfound_start
  %fmt.addr = load i8*, i8** @aAddressPHasNoI, align 8
  %call.log = call i32 (i8*, ...) @sub_140001700(i8* %fmt.addr, i8* %rcx)
  ret void
}