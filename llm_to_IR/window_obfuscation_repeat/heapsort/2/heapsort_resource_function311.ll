; ModuleID = 'fixed'
source_filename = "fixed.ll"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define dso_local i32 @sub_140002690() {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %lfanewptr8 = getelementptr i8, i8* %baseptr, i64 60
  %lfanewptr = bitcast i8* %lfanewptr8 to i32*
  %lfanew = load i32, i32* %lfanewptr, align 1
  %lfanew64 = sext i32 %lfanew to i64
  %pehdr = getelementptr i8, i8* %baseptr, i64 %lfanew64
  %sigptr = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %sigptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %magicptr8 = getelementptr i8, i8* %pehdr, i64 24
  %magicptr16 = bitcast i8* %magicptr8 to i16*
  %magic = load i16, i16* %magicptr16, align 1
  %is_pe32p = icmp eq i16 %magic, 523
  br i1 %is_pe32p, label %read_sections, label %ret0

read_sections:
  %numsecptr8 = getelementptr i8, i8* %pehdr, i64 6
  %numsecptr = bitcast i8* %numsecptr8 to i16*
  %numsec16 = load i16, i16* %numsecptr, align 1
  %numseci32 = zext i16 %numsec16 to i32
  br label %ret

ret0:
  br label %ret

ret:
  %result = phi i32 [ 0, %ret0 ], [ %numseci32, %read_sections ]
  ret i32 %result
}