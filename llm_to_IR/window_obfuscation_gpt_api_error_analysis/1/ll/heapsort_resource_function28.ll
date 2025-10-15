; ModuleID = 'sub_140002520'
target triple = "x86_64-pc-windows-msvc"

define dso_local i8* @sub_140002520(i8* nocapture readonly %base, i64 %rva) local_unnamed_addr {
entry:
  %eoff.ptr = getelementptr inbounds i8, i8* %base, i64 60
  %eoff.p32 = bitcast i8* %eoff.ptr to i32*
  %eoff.v32 = load i32, i32* %eoff.p32, align 1
  %eoff.v64 = sext i32 %eoff.v32 to i64
  %nt.ptr = getelementptr inbounds i8, i8* %base, i64 %eoff.v64
  %num.ptr = getelementptr inbounds i8, i8* %nt.ptr, i64 6
  %num.p16 = bitcast i8* %num.ptr to i16*
  %num.v16 = load i16, i16* %num.p16, align 1
  %num.iszero = icmp eq i16 %num.v16, 0
  br i1 %num.iszero, label %ret_null, label %cont

cont:
  %size.ptr = getelementptr inbounds i8, i8* %nt.ptr, i64 20
  %size.p16 = bitcast i8* %size.ptr to i16*
  %size.v16 = load i16, i16* %size.p16, align 1
  %size.v64 = zext i16 %size.v16 to i64
  %afterfh = getelementptr inbounds i8, i8* %nt.ptr, i64 24
  %first = getelementptr inbounds i8, i8* %afterfh, i64 %size.v64
  %num.v32 = zext i16 %num.v16 to i32
  %num.v64 = zext i32 %num.v32 to i64
  %span = mul nuw i64 %num.v64, 40
  %end = getelementptr inbounds i8, i8* %first, i64 %span
  br label %loop

loop:
  %cur = phi i8* [ %first, %cont ], [ %next, %advance ]
  %va.ptr = getelementptr inbounds i8, i8* %cur, i64 12
  %va.p32 = bitcast i8* %va.ptr to i32*
  %va.v32 = load i32, i32* %va.p32, align 1
  %va.v64 = zext i32 %va.v32 to i64
  %ltva = icmp ult i64 %rva, %va.v64
  br i1 %ltva, label %advance, label %check

check:
  %vs.ptr = getelementptr inbounds i8, i8* %cur, i64 8
  %vs.p32 = bitcast i8* %vs.ptr to i32*
  %vs.v32 = load i32, i32* %vs.p32, align 1
  %sum.v32 = add i32 %va.v32, %vs.v32
  %sum.v64 = zext i32 %sum.v32 to i64
  %inrange = icmp ult i64 %rva, %sum.v64
  br i1 %inrange, label %found, label %advance

advance:
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  %more = icmp ne i8* %next, %end
  br i1 %more, label %loop, label %ret_null

found:
  ret i8* %cur

ret_null:
  ret i8* null
}