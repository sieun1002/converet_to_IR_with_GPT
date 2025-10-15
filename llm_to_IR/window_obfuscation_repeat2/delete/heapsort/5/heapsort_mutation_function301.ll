; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*

define i32 @sub_1400026D0(i64 %rcx) {
entry:
  %base = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %mz.ok = icmp eq i16 %mz, 23117
  br i1 %mz.ok, label %check_nt, label %ret0

check_nt:
  %lfanew.ptr.i8 = getelementptr i8, i8* %base, i64 60
  %lfanew.ptr = bitcast i8* %lfanew.ptr.i8 to i32*
  %lfanew32 = load i32, i32* %lfanew.ptr, align 1
  %lfanew64 = sext i32 %lfanew32 to i64
  %nt.i8 = getelementptr i8, i8* %base, i64 %lfanew64
  %sig.ptr = bitcast i8* %nt.i8 to i32*
  %sig = load i32, i32* %sig.ptr, align 1
  %is.pe = icmp eq i32 %sig, 17744
  br i1 %is.pe, label %after_pe, label %ret0

after_pe:
  %magic.ptr.i8 = getelementptr i8, i8* %nt.i8, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic = load i16, i16* %magic.ptr, align 1
  %is.pe32plus = icmp eq i16 %magic, 523
  br i1 %is.pe32plus, label %cont1, label %ret0

cont1:
  %numsect.ptr.i8 = getelementptr i8, i8* %nt.i8, i64 6
  %numsect.ptr = bitcast i8* %numsect.ptr.i8 to i16*
  %numsect16 = load i16, i16* %numsect.ptr, align 1
  %numsect.ne0 = icmp ne i16 %numsect16, 0
  br i1 %numsect.ne0, label %cont2, label %ret0

cont2:
  %optsize.ptr.i8 = getelementptr i8, i8* %nt.i8, i64 20
  %optsize.ptr = bitcast i8* %optsize.ptr.i8 to i16*
  %optsize16 = load i16, i16* %optsize.ptr, align 1
  %optsize64 = zext i16 %optsize16 to i64
  %secstart.pre = getelementptr i8, i8* %nt.i8, i64 24
  %secstart = getelementptr i8, i8* %secstart.pre, i64 %optsize64
  %numsect32 = zext i16 %numsect16 to i32
  %numsectm1 = add i32 %numsect32, 4294967295
  %mul5 = mul i32 %numsectm1, 5
  %mul5.z = zext i32 %mul5 to i64
  %scale = mul i64 %mul5.z, 8
  %end.plus = getelementptr i8, i8* %secstart, i64 %scale
  %end.ptr = getelementptr i8, i8* %end.plus, i64 40
  br label %loop

loop:
  %curr = phi i8* [ %secstart, %cont2 ], [ %next, %loop.tail ]
  %count = phi i64 [ %rcx, %cont2 ], [ %count.next, %loop.tail ]
  %char.ptr = getelementptr i8, i8* %curr, i64 39
  %char = load i8, i8* %char.ptr, align 1
  %masked = and i8 %char, 32
  %has.bit = icmp ne i8 %masked, 0
  br i1 %has.bit, label %check_rcx, label %loop.tail.nodec

check_rcx:
  %is.zero = icmp eq i64 %count, 0
  br i1 %is.zero, label %ret0, label %dec.and.tail

dec.and.tail:
  %count.dec = add i64 %count, -1
  br label %loop.tail

loop.tail.nodec:
  br label %loop.tail

loop.tail:
  %count.next = phi i64 [ %count.dec, %dec.and.tail ], [ %count, %loop.tail.nodec ]
  %next = getelementptr i8, i8* %curr, i64 40
  %cont = icmp ne i8* %end.ptr, %next
  br i1 %cont, label %loop, label %done

done:
  ret i32 0

ret0:
  ret i32 0
}