; ModuleID = 'pe_section_finder'
target triple = "x86_64-pc-windows-msvc"

define dso_local i8* @sub_140002520(i8* %base, i64 %rva) local_unnamed_addr nounwind {
entry:
  %p3c = getelementptr i8, i8* %base, i64 60
  %p3c_i32ptr = bitcast i8* %p3c to i32*
  %e_lfanew32 = load i32, i32* %p3c_i32ptr, align 1
  %e_lfanew = sext i32 %e_lfanew32 to i64
  %nt = getelementptr i8, i8* %base, i64 %e_lfanew
  %pNumSec = getelementptr i8, i8* %nt, i64 6
  %pNumSec_i16 = bitcast i8* %pNumSec to i16*
  %numSec16 = load i16, i16* %pNumSec_i16, align 1
  %isZero = icmp eq i16 %numSec16, 0
  br i1 %isZero, label %ret_zero, label %nonzero

nonzero:                                          ; preds = %entry
  %pSizeOpt = getelementptr i8, i8* %nt, i64 20
  %pSizeOpt_i16 = bitcast i8* %pSizeOpt to i16*
  %sizeOpt16 = load i16, i16* %pSizeOpt_i16, align 1
  %sizeOpt64 = zext i16 %sizeOpt16 to i64
  %basePlus18 = getelementptr i8, i8* %nt, i64 24
  %firstSec = getelementptr i8, i8* %basePlus18, i64 %sizeOpt64
  %numSec64 = zext i16 %numSec16 to i64
  %bytes = mul nuw nsw i64 %numSec64, 40
  %endPtr = getelementptr i8, i8* %firstSec, i64 %bytes
  br label %loop

loop:                                             ; preds = %cont, %nonzero
  %cur = phi i8* [ %firstSec, %nonzero ], [ %next, %cont ]
  %pVA = getelementptr i8, i8* %cur, i64 12
  %pVA_i32 = bitcast i8* %pVA to i32*
  %va32 = load i32, i32* %pVA_i32, align 1
  %va64 = zext i32 %va32 to i64
  %cmpLower = icmp ult i64 %rva, %va64
  br i1 %cmpLower, label %cont, label %check_upper

check_upper:                                      ; preds = %loop
  %pVSZ = getelementptr i8, i8* %cur, i64 8
  %pVSZ_i32 = bitcast i8* %pVSZ to i32*
  %vsz32 = load i32, i32* %pVSZ_i32, align 1
  %sum32 = add i32 %va32, %vsz32
  %sum64 = zext i32 %sum32 to i64
  %cmpUpper = icmp ult i64 %rva, %sum64
  br i1 %cmpUpper, label %ret_found, label %cont

cont:                                             ; preds = %check_upper, %loop
  %next = getelementptr i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %endPtr
  br i1 %done, label %ret_zero, label %loop

ret_found:                                        ; preds = %check_upper
  ret i8* %cur

ret_zero:                                         ; preds = %cont, %entry
  ret i8* null
}