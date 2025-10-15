; target: Windows x64, MSVC ABI
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

declare i64 @strlen(i8* nocapture) nounwind readonly
declare i32 @strncmp(i8* nocapture, i8* nocapture, i64) nounwind readonly

define i8* @sub_140002570(i8* %name) local_unnamed_addr nounwind {
entry:
  %len = call i64 @strlen(i8* %name)
  %gt8 = icmp ugt i64 %len, 8
  br i1 %gt8, label %fail, label %load_base

load_base:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr16 = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr16, align 1
  %is.mz = icmp eq i16 %mz, 23117
  br i1 %is.mz, label %read_nt, label %fail

read_nt:
  %e_lfanew.i8 = getelementptr i8, i8* %base.ptr, i64 60
  %e_lfanew.p32 = bitcast i8* %e_lfanew.i8 to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew.p32, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %nt = getelementptr i8, i8* %base.ptr, i64 %e_lfanew64
  %sig.p32 = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sig.p32, align 1
  %is.pe = icmp eq i32 %sig, 17744
  br i1 %is.pe, label %check_magic, label %fail

check_magic:
  %opt.magic.i8 = getelementptr i8, i8* %nt, i64 24
  %opt.magic.p16 = bitcast i8* %opt.magic.i8 to i16*
  %opt.magic = load i16, i16* %opt.magic.p16, align 1
  %is.pe32plus = icmp eq i16 %opt.magic, 523
  br i1 %is.pe32plus, label %check_sections, label %fail

check_sections:
  %numsects.i8 = getelementptr i8, i8* %nt, i64 6
  %numsects.p16 = bitcast i8* %numsects.i8 to i16*
  %numsects = load i16, i16* %numsects.p16, align 1
  %has.sections = icmp ne i16 %numsects, 0
  br i1 %has.sections, label %calc_first_section, label %fail

calc_first_section:
  %sizeopt.i8 = getelementptr i8, i8* %nt, i64 20
  %sizeopt.p16 = bitcast i8* %sizeopt.i8 to i16*
  %sizeopt = load i16, i16* %sizeopt.p16, align 1
  %sizeopt.z = zext i16 %sizeopt to i64
  %sec.ofs = add i64 %sizeopt.z, 24
  %secptr0 = getelementptr i8, i8* %nt, i64 %sec.ofs
  br label %loop

loop:
  %idx = phi i32 [ 0, %calc_first_section ], [ %idx.next, %loop_inc ]
  %secptr = phi i8* [ %secptr0, %calc_first_section ], [ %secptr.next, %loop_inc ]
  %cmpres = call i32 @strncmp(i8* %secptr, i8* %name, i64 8)
  %is.zero = icmp eq i32 %cmpres, 0
  br i1 %is.zero, label %success, label %loop_inc

loop_inc:
  %numsects.z32 = zext i16 %numsects to i32
  %idx.next = add i32 %idx, 1
  %secptr.next = getelementptr i8, i8* %secptr, i64 40
  %cont = icmp ult i32 %idx.next, %numsects.z32
  br i1 %cont, label %loop, label %fail

success:
  br label %ret

fail:
  br label %ret

ret:
  %retptr = phi i8* [ null, %fail ], [ %secptr, %success ]
  ret i8* %retptr
}