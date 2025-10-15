; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*, align 8

define dso_local i32 @sub_140002790(i8* %p) {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 0
  %mz.ptr = bitcast i8* %mz.ptr.i8 to i16*
  %mz.val = load i16, i16* %mz.ptr, align 1
  %is.mz = icmp eq i16 %mz.val, 23117
  br i1 %is.mz, label %checkPE, label %ret0

checkPE:                                          ; preds = %entry
  %e_lfanew.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew.val = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew.sext = sext i32 %e_lfanew.val to i64
  %nt.ptr = getelementptr i8, i8* %base.ptr, i64 %e_lfanew.sext
  %pe.sig.ptr = bitcast i8* %nt.ptr to i32*
  %pe.sig = load i32, i32* %pe.sig.ptr, align 1
  %is.pe = icmp eq i32 %pe.sig, 17744
  br i1 %is.pe, label %checkOptional, label %ret0

checkOptional:                                    ; preds = %checkPE
  %opt.magic.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 24
  %opt.magic.ptr = bitcast i8* %opt.magic.ptr.i8 to i16*
  %opt.magic = load i16, i16* %opt.magic.ptr, align 1
  %is.pe32plus = icmp eq i16 %opt.magic, 523
  br i1 %is.pe32plus, label %cont1, label %ret0

cont1:                                            ; preds = %checkOptional
  %numsec.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec = load i16, i16* %numsec.ptr, align 1
  %numsec.iszero = icmp eq i16 %numsec, 0
  br i1 %numsec.iszero, label %ret0, label %haveSections

haveSections:                                     ; preds = %cont1
  %soh.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 20
  %soh.ptr = bitcast i8* %soh.ptr.i8 to i16*
  %soh = load i16, i16* %soh.ptr, align 1
  %p.int = ptrtoint i8* %p to i64
  %base.int = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %p.int, %base.int
  %numsec.zext = zext i16 %numsec to i32
  %numsec.m1 = sub i32 %numsec.zext, 1
  %numsec.m1.zext = zext i32 %numsec.m1 to i64
  %tmp.mul4 = mul i64 %numsec.m1.zext, 4
  %five.mul = add i64 %numsec.m1.zext, %tmp.mul4
  %soh.zext32 = zext i16 %soh to i32
  %soh.zext64 = zext i32 %soh.zext32 to i64
  %sections.base = getelementptr i8, i8* %nt.ptr, i64 24
  %sections.start = getelementptr i8, i8* %sections.base, i64 %soh.zext64
  %five.mul.x8 = mul i64 %five.mul, 8
  %end.base = getelementptr i8, i8* %sections.start, i64 %five.mul.x8
  %end.ptr = getelementptr i8, i8* %end.base, i64 40
  br label %loop

loop:                                             ; preds = %loop_continue, %haveSections
  %sec.ptr = phi i8* [ %sections.start, %haveSections ], [ %next.sec, %loop_continue ]
  %virtaddr.ptr.i8 = getelementptr i8, i8* %sec.ptr, i64 12
  %virtaddr.ptr = bitcast i8* %virtaddr.ptr.i8 to i32*
  %virtaddr32 = load i32, i32* %virtaddr.ptr, align 1
  %virtaddr64 = zext i32 %virtaddr32 to i64
  %cmp.before = icmp ult i64 %rva, %virtaddr64
  br i1 %cmp.before, label %loop_continue, label %checkEnd

checkEnd:                                         ; preds = %loop
  %vsize.ptr.i8 = getelementptr i8, i8* %sec.ptr, i64 8
  %vsize.ptr = bitcast i8* %vsize.ptr.i8 to i32*
  %vsize32 = load i32, i32* %vsize.ptr, align 1
  %sum32 = add i32 %virtaddr32, %vsize32
  %sum64 = zext i32 %sum32 to i64
  %in.range = icmp ult i64 %rva, %sum64
  br i1 %in.range, label %found, label %loop_continue

loop_continue:                                    ; preds = %checkEnd, %loop
  %next.sec = getelementptr i8, i8* %sec.ptr, i64 40
  %cont = icmp ne i8* %end.ptr, %next.sec
  br i1 %cont, label %loop, label %ret0

found:                                            ; preds = %checkEnd
  %chars.ptr.i8 = getelementptr i8, i8* %sec.ptr, i64 36
  %chars.ptr = bitcast i8* %chars.ptr.i8 to i32*
  %chars = load i32, i32* %chars.ptr, align 1
  %not.chars = xor i32 %chars, -1
  %res = lshr i32 %not.chars, 31
  ret i32 %res

ret0:                                             ; preds = %loop_continue, %cont1, %checkOptional, %checkPE, %entry
  ret i32 0
}