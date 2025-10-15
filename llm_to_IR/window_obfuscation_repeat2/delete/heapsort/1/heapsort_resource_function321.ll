; ModuleID = 'pe_section_scan'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i32 @sub_1400026D0(i64 %rcx) local_unnamed_addr nounwind {
entry:
  %baseptr.addr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr = bitcast i8* %baseptr.addr to i16*
  %mz.val = load i16, i16* %mz.ptr, align 1
  %is.mz = icmp eq i16 %mz.val, 23117
  br i1 %is.mz, label %check_pe, label %ret0

check_pe:
  %lfanew.ptr.i8 = getelementptr i8, i8* %baseptr.addr, i64 60
  %lfanew.ptr = bitcast i8* %lfanew.ptr.i8 to i32*
  %lfanew.val = load i32, i32* %lfanew.ptr, align 1
  %lfanew.sext = sext i32 %lfanew.val to i64
  %pehdr = getelementptr i8, i8* %baseptr.addr, i64 %lfanew.sext
  %sig.ptr = bitcast i8* %pehdr to i32*
  %sig.val = load i32, i32* %sig.ptr, align 1
  %is.pe = icmp eq i32 %sig.val, 17744
  br i1 %is.pe, label %check_magic, label %ret0

check_magic:
  %magic.ptr.i8 = getelementptr i8, i8* %pehdr, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic.val = load i16, i16* %magic.ptr, align 1
  %is.peplus = icmp eq i16 %magic.val, 523
  br i1 %is.peplus, label %get_nsects, label %ret0

get_nsects:
  %nsec.ptr.i8 = getelementptr i8, i8* %pehdr, i64 6
  %nsec.ptr = bitcast i8* %nsec.ptr.i8 to i16*
  %nsec16 = load i16, i16* %nsec.ptr, align 1
  %nsec.zero = icmp eq i16 %nsec16, 0
  br i1 %nsec.zero, label %ret0, label %get_opt_size

get_opt_size:
  %optsz.ptr.i8 = getelementptr i8, i8* %pehdr, i64 20
  %optsz.ptr = bitcast i8* %optsz.ptr.i8 to i16*
  %optsz16 = load i16, i16* %optsz.ptr, align 1
  %optsz = zext i16 %optsz16 to i64
  %firstsect.base = getelementptr i8, i8* %pehdr, i64 24
  %firstsect = getelementptr i8, i8* %firstsect.base, i64 %optsz
  %nsec32 = zext i16 %nsec16 to i32
  %nsec64 = zext i32 %nsec32 to i64
  %sects.bytes = mul nuw i64 %nsec64, 40
  %endptr = getelementptr i8, i8* %firstsect, i64 %sects.bytes
  br label %loop

loop:
  %cur = phi i8* [ %firstsect, %get_opt_size ], [ %next, %cont ]
  %count = phi i64 [ %rcx, %get_opt_size ], [ %count.next, %cont ]
  %char.byte.ptr.i8 = getelementptr i8, i8* %cur, i64 39
  %char.byte = load i8, i8* %char.byte.ptr.i8, align 1
  %masked = and i8 %char.byte, 32
  %is.set = icmp ne i8 %masked, 0
  br i1 %is.set, label %check_count, label %cont_nochange

check_count:
  %is.zero = icmp eq i64 %count, 0
  br i1 %is.zero, label %ret0, label %dec

dec:
  %count.dec = add i64 %count, -1
  br label %cont

cont_nochange:
  br label %cont

cont:
  %count.next = phi i64 [ %count, %cont_nochange ], [ %count.dec, %dec ]
  %next = getelementptr i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %endptr
  br i1 %done, label %ret0, label %loop

ret0:
  ret i32 0
}