; ModuleID = 'sub_140002250'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define i32 @sub_140002250(i8* %rcx) {
entry:
  %base.ptr = load i8*, i8** @off_1400043C0, align 8
  %mz.ptr16 = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr16, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret

check_pe:
  %lfanew.ptr = getelementptr i8, i8* %base.ptr, i64 60
  %lfanew.ptr32 = bitcast i8* %lfanew.ptr to i32*
  %lfanew32 = load i32, i32* %lfanew.ptr32, align 1
  %lfanew64 = sext i32 %lfanew32 to i64
  %nthdr = getelementptr i8, i8* %base.ptr, i64 %lfanew64
  %sig.ptr = bitcast i8* %nthdr to i32*
  %sig = load i32, i32* %sig.ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt, label %ret

check_opt:
  %optmagic.ptr = getelementptr i8, i8* %nthdr, i64 24
  %optmagic.ptr16 = bitcast i8* %optmagic.ptr to i16*
  %optmagic = load i16, i16* %optmagic.ptr16, align 1
  %is_pe32plus = icmp eq i16 %optmagic, 523
  br i1 %is_pe32plus, label %load_nsect, label %ret

load_nsect:
  %nsect.ptr = getelementptr i8, i8* %nthdr, i64 6
  %nsect.ptr16 = bitcast i8* %nsect.ptr to i16*
  %nsect16 = load i16, i16* %nsect.ptr16, align 1
  %nsect_is_zero = icmp eq i16 %nsect16, 0
  br i1 %nsect_is_zero, label %ret, label %continue1

continue1:
  %soh.ptr = getelementptr i8, i8* %nthdr, i64 20
  %soh.ptr16 = bitcast i8* %soh.ptr to i16*
  %soh16 = load i16, i16* %soh.ptr16, align 1
  %rcx.int = ptrtoint i8* %rcx to i64
  %base.int = ptrtoint i8* %base.ptr to i64
  %diff = sub i64 %rcx.int, %base.int
  %nsect32 = zext i16 %nsect16 to i32
  %nminus1 = add i32 %nsect32, -1
  %five_nminus1 = mul i32 %nminus1, 5
  %five_nminus1_64 = zext i32 %five_nminus1 to i64
  %soh16.zext = zext i16 %soh16 to i64
  %first_sect.tmp = getelementptr i8, i8* %nthdr, i64 %soh16.zext
  %first_sect = getelementptr i8, i8* %first_sect.tmp, i64 24
  %scale = shl i64 %five_nminus1_64, 3
  %last_end.tmp = getelementptr i8, i8* %first_sect, i64 %scale
  %last_end = getelementptr i8, i8* %last_end.tmp, i64 40
  br label %loop

loop:
  %cur = phi i8* [ %first_sect, %continue1 ], [ %next, %loop_end ]
  %va.ptr.i8 = getelementptr i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va = load i32, i32* %va.ptr, align 1
  %va64 = zext i32 %va to i64
  %cmp1 = icmp ult i64 %diff, %va64
  br i1 %cmp1, label %loop_advance, label %check_range

check_range:
  %vsize.ptr.i8 = getelementptr i8, i8* %cur, i64 8
  %vsize.ptr = bitcast i8* %vsize.ptr.i8 to i32*
  %vsize = load i32, i32* %vsize.ptr, align 1
  %sum32 = add i32 %va, %vsize
  %sum64 = zext i32 %sum32 to i64
  %cmp2 = icmp ult i64 %diff, %sum64
  br i1 %cmp2, label %ret, label %loop_advance

loop_advance:
  %next = getelementptr i8, i8* %cur, i64 40
  %cmpend = icmp ne i8* %next, %last_end
  br i1 %cmpend, label %loop_end, label %final_ret

loop_end:
  br label %loop

final_ret:
  ret i32 0

ret:
  ret i32 0
}