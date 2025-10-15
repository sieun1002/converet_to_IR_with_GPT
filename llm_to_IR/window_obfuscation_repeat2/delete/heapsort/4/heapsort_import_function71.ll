; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@qword_140008260 = external global i32 ()*

@aVirtualprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00"
@aVirtualqueryFa = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00"
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00"

declare i8* @sub_140002610(i8*)
declare i8* @sub_140002750()
declare i64 @sub_14001FAD3(i8*, i8*, i32)
declare i32 @loc_14000EEBA(i8*, i8*, i32, i8*)
declare i32 @sub_140001AD0(i8*, ...)

define void @sub_140001B30(i8* %addr) {
entry:
  %cnt0 = load i32, i32* @dword_1400070A4, align 4
  %le0 = icmp sle i32 %cnt0, 0
  br i1 %le0, label %c60, label %loop_prep

loop_prep:
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  %p_start = getelementptr i8, i8* %base0, i64 24
  br label %loop

loop:
  %p.cur = phi i8* [ %p_start, %loop_prep ], [ %p.next, %cont_after ]
  %i.cur = phi i32 [ 0, %loop_prep ], [ %i.next, %cont_after ]
  %start.ptr = load i8*, i8** %p.cur, align 8
  %addr.int = ptrtoint i8* %addr to i64
  %start.int = ptrtoint i8* %start.ptr to i64
  %ge.start = icmp uge i64 %addr.int, %start.int
  br i1 %ge.start, label %check_end, label %cont_after

check_end:
  %hdr.ptr.ptr = getelementptr i8, i8* %p.cur, i64 8
  %hdr.ptr = load i8*, i8** %hdr.ptr.ptr, align 8
  %size.ptr = getelementptr i8, i8* %hdr.ptr, i64 8
  %size32 = load i32, i32* %size.ptr, align 4
  %size64 = zext i32 %size32 to i64
  %end.int = add i64 %start.int, %size64
  %inrange = icmp ult i64 %addr.int, %end.int
  br i1 %inrange, label %epilogue, label %cont_after

cont_after:
  %i.next = add i32 %i.cur, 1
  %p.next = getelementptr i8, i8* %p.cur, i64 40
  %cnt1 = load i32, i32* @dword_1400070A4, align 4
  %more = icmp ne i32 %i.next, %cnt1
  br i1 %more, label %loop, label %b88

c60:
  br label %b88

b88:
  %s.val = phi i32 [ 0, %c60 ], [ %cnt1, %cont_after ]
  %found = call i8* @sub_140002610(i8* %addr)
  %isnull = icmp eq i8* %found, null
  br i1 %isnull, label %c82, label %b9c

b9c:
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %s64 = sext i32 %s.val to i64
  %offs = mul i64 %s64, 40
  %entry.ptr = getelementptr i8, i8* %base1, i64 %offs
  %field20 = getelementptr i8, i8* %entry.ptr, i64 32
  store i8* %found, i8** %field20, align 8
  %entry.i32 = bitcast i8* %entry.ptr to i32*
  store i32 0, i32* %entry.i32, align 4
  %t2 = call i8* @sub_140002750()
  %rdi.plus.c = getelementptr i8, i8* %found, i64 12
  %edxload = load i32, i32* %rdi.plus.c, align 4
  %edx64z = zext i32 %edxload to i64
  %rcx.ptr = getelementptr i8, i8* %t2, i64 %edx64z
  %field18 = getelementptr i8, i8* %entry.ptr, i64 24
  store i8* %rcx.ptr, i8** %field18, align 8
  %buf = alloca [48 x i8], align 16
  %buf.ptr = getelementptr [48 x i8], [48 x i8]* %buf, i64 0, i64 0
  %qres = call i64 @sub_14001FAD3(i8* %rcx.ptr, i8* %buf.ptr, i32 48)
  %qzero = icmp eq i64 %qres, 0
  br i1 %qzero, label %c67, label %after_call

c67:
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %rdi.plus.8 = getelementptr i8, i8* %found, i64 8
  %bytes = load i32, i32* %rdi.plus.8, align 4
  %field18b = getelementptr i8, i8* %entry.ptr, i64 24
  %ptr18 = load i8*, i8** %field18b, align 8
  %fmtvq = getelementptr [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  %log1 = call i32 (i8*, ...) @sub_140001AD0(i8* %fmtvq, i32 %bytes, i8* %ptr18)
  br label %c82

after_call:
  %p2c = getelementptr i8, i8* %buf.ptr, i64 44
  %eaxv = load i32, i32* %p2c, align 4
  %tmp1 = sub i32 %eaxv, 4
  %mask1 = and i32 %tmp1, -5
  %iszero1 = icmp eq i32 %mask1, 0
  br i1 %iszero1, label %bfe, label %test2

test2:
  %tmp2 = sub i32 %eaxv, 64
  %mask2 = and i32 %tmp2, -65
  %ne2 = icmp ne i32 %mask2, 0
  br i1 %ne2, label %c10, label %bfe

bfe:
  %oldcnt2 = load i32, i32* @dword_1400070A4, align 4
  %newcnt = add i32 %oldcnt2, 1
  store i32 %newcnt, i32* @dword_1400070A4, align 4
  br label %epilogue

c10:
  %cmp2 = icmp eq i32 %eaxv, 2
  %r8sel = select i1 %cmp2, i32 4, i32 64
  %mbi.base = load i8*, i8** %buf.ptr, align 8
  %mbi.rs.ptr = getelementptr i8, i8* %buf.ptr, i64 24
  %mbi.rs.val = load i64, i64* bitcast (i8* %mbi.rs.ptr to i64*), align 8
  %mbi.rs = inttoptr i64 %mbi.rs.val to i8*
  %field8 = getelementptr i8, i8* %entry.ptr, i64 8
  store i8* %mbi.base, i8** %field8, align 8
  %field10 = getelementptr i8, i8* %entry.ptr, i64 16
  store i8* %mbi.rs, i8** %field10, align 8
  %protres = call i32 @loc_14000EEBA(i8* %mbi.base, i8* %mbi.rs, i32 %r8sel, i8* %entry.ptr)
  %okprot = icmp ne i32 %protres, 0
  br i1 %okprot, label %bfe, label %prot_fail

prot_fail:
  %fp = load i32 ()*, i32 ()** @qword_140008260, align 8
  %err = call i32 %fp()
  %fmtvp = getelementptr [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  %log2 = call i32 (i8*, ...) @sub_140001AD0(i8* %fmtvp, i32 %err)
  br label %c60

c82:
  %fmtnoimg = getelementptr [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  %log3 = call i32 (i8*, ...) @sub_140001AD0(i8* %fmtnoimg, i8* %addr)
  ret void

epilogue:
  ret void
}