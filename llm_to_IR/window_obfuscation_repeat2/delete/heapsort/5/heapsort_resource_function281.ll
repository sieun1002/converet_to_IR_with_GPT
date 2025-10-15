; ModuleID = 'pe_section_lookup'
target triple = "x86_64-pc-windows-msvc"

define dso_local i8* @sub_140002520(i8* %rcx, i64 %rdx) {
entry:
  %e_lfanew.ptr = getelementptr inbounds i8, i8* %rcx, i64 60
  %e_lfanew.i32ptr = bitcast i8* %e_lfanew.ptr to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew.i32ptr, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %nt.ptr = getelementptr inbounds i8, i8* %rcx, i64 %e_lfanew64
  %numsec.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr, align 1
  %is.zero = icmp eq i16 %numsec16, 0
  br i1 %is.zero, label %ret.zero, label %has.sections

has.sections:                                     ; preds = %entry
  %sizeopt.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr, i64 20
  %sizeopt.ptr = bitcast i8* %sizeopt.ptr.i8 to i16*
  %sizeopt16 = load i16, i16* %sizeopt.ptr, align 1
  %sizeopt64 = zext i16 %sizeopt16 to i64
  %first.base = getelementptr inbounds i8, i8* %nt.ptr, i64 24
  %first.sect = getelementptr inbounds i8, i8* %first.base, i64 %sizeopt64
  %numsec64 = zext i16 %numsec16 to i64
  %count.bytes = mul nuw i64 %numsec64, 40
  %end.ptr = getelementptr inbounds i8, i8* %first.sect, i64 %count.bytes
  br label %loop

loop:                                             ; preds = %cont, %has.sections
  %cur = phi i8* [ %first.sect, %has.sections ], [ %next, %cont ]
  %va.ptr.i8 = getelementptr inbounds i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va32 = load i32, i32* %va.ptr, align 1
  %va64 = zext i32 %va32 to i64
  %cmp.below = icmp ult i64 %rdx, %va64
  br i1 %cmp.below, label %cont, label %check.end

check.end:                                        ; preds = %loop
  %size.ptr.i8 = getelementptr inbounds i8, i8* %cur, i64 8
  %size.ptr = bitcast i8* %size.ptr.i8 to i32*
  %size32 = load i32, i32* %size.ptr, align 1
  %sum32 = add i32 %va32, %size32
  %sum64 = zext i32 %sum32 to i64
  %in.range = icmp ult i64 %rdx, %sum64
  br i1 %in.range, label %ret.cur, label %cont

cont:                                             ; preds = %check.end, %loop
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %end.ptr
  br i1 %done, label %ret.zero, label %loop

ret.zero:                                         ; preds = %cont, %entry
  ret i8* null

ret.cur:                                          ; preds = %check.end
  ret i8* %cur
}