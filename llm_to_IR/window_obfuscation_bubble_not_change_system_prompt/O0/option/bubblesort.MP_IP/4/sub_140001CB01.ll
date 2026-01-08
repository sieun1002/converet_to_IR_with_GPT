; ModuleID = 'sub_140001CB0.ll'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i8*

declare i8* @sub_1400027A8(i32, i32)
declare void @sub_140002120()

define i32 @sub_140001CB0(i8** %rcx) {
entry:
  %rdx = load i8*, i8** %rcx, align 8
  %rdx.i32ptr = bitcast i8* %rdx to i32*
  %eax = load i32, i32* %rdx.i32ptr, align 4
  %masked = and i32 %eax, 553648127 ; 0x20FFFFFF
  %cmp.magic = icmp eq i32 %masked, 541549763 ; 0x20474343
  br i1 %cmp.magic, label %d60, label %cd1

d60:                                              ; 0x140001d60
  %rdx.plus4 = getelementptr i8, i8* %rdx, i32 4
  %b4 = load i8, i8* %rdx.plus4, align 1
  %b4.and1 = and i8 %b4, 1
  %b4.nzero = icmp ne i8 %b4.and1, 0
  br i1 %b4.nzero, label %cd1, label %ret_minus1

cd1:                                              ; 0x140001cd1
  %cmp_hi = icmp ugt i32 %eax, 3221225622 ; 0xC0000096
  br i1 %cmp_hi, label %d1f, label %cd1.cont

cd1.cont:
  %cmp_le = icmp ule i32 %eax, 3221225483 ; 0xC000008B
  br i1 %cmp_le, label %d40, label %switchRange

switchRange:                                      ; 0x140001cdf..cf7
  switch i32 %eax, label %ret_minus1 [
    i32 3221225485, label %d00       ; 0xC000008D
    i32 3221225486, label %d00       ; 0xC000008E
    i32 3221225487, label %d00       ; 0xC000008F
    i32 3221225488, label %d00       ; 0xC0000090
    i32 3221225489, label %d00       ; 0xC0000091
    i32 3221225491, label %d00       ; 0xC0000093
    i32 3221225492, label %dc0       ; 0xC0000094
    i32 3221225494, label %d8e       ; 0xC0000096
  ]

d00:                                              ; 0x140001d00
  %p1 = call i8* @sub_1400027A8(i32 8, i32 0)
  %p1.int = ptrtoint i8* %p1 to i64
  %p1.is1 = icmp eq i64 %p1.int, 1
  br i1 %p1.is1, label %e54, label %d00.test

d00.test:
  %p1.nz = icmp ne i8* %p1, null
  br i1 %p1.nz, label %e20, label %d1f

d40:                                              ; 0x140001d40
  %is_av = icmp eq i32 %eax, 3221225477 ; 0xC0000005
  br i1 %is_av, label %df0, label %d40.cont

d40.cont:
  %ugt_0005 = icmp ugt i32 %eax, 3221225477 ; 0xC0000005
  br i1 %ugt_0005, label %d80, label %d40.low

d40.low:
  %is_80000002 = icmp eq i32 %eax, 2147483650 ; 0x80000002
  br i1 %is_80000002, label %ret_minus1, label %d1f

d80:                                              ; 0x140001d80
  %is_0008 = icmp eq i32 %eax, 3221225480 ; 0xC0000008
  br i1 %is_0008, label %ret_minus1, label %d80.cont

d80.cont:
  %is_001D = icmp eq i32 %eax, 3221225501 ; 0xC000001D
  br i1 %is_001D, label %d8e, label %d1f

dc0:                                              ; 0x140001dc0
  %p2 = call i8* @sub_1400027A8(i32 8, i32 0)
  %p2.int = ptrtoint i8* %p2 to i64
  %p2.is1 = icmp eq i64 %p2.int, 1
  br i1 %p2.is1, label %dc0.eq1, label %dc0.test

dc0.test:
  %p2.nz = icmp ne i8* %p2, null
  br i1 %p2.nz, label %e20, label %d1f

dc0.eq1:
  %tmp.dc0 = call i8* @sub_1400027A8(i32 8, i32 1)
  br label %ret_minus1

d8e:                                              ; 0x140001d8e
  %p3 = call i8* @sub_1400027A8(i32 4, i32 0)
  %p3.int = ptrtoint i8* %p3 to i64
  %p3.is1 = icmp eq i64 %p3.int, 1
  br i1 %p3.is1, label %e40, label %d8e.test

d8e.test:
  %p3.nz = icmp ne i8* %p3, null
  br i1 %p3.nz, label %call_p3, label %d1f

call_p3:
  %fp3 = bitcast i8* %p3 to void (i32)*
  call void %fp3(i32 4)
  br label %ret_minus1

df0:                                              ; 0x140001df0
  %p4 = call i8* @sub_1400027A8(i32 11, i32 0)
  %p4.int = ptrtoint i8* %p4 to i64
  %p4.is1 = icmp eq i64 %p4.int, 1
  br i1 %p4.is1, label %e2c, label %df0.test

df0.test:
  %p4.nz = icmp ne i8* %p4, null
  br i1 %p4.nz, label %call_p4, label %d1f

call_p4:
  %fp4 = bitcast i8* %p4 to void (i32)*
  call void %fp4(i32 11)
  br label %ret_minus1

e20:                                              ; 0x140001e20
  %p.call = phi i8* [ %p1, %d00.test ], [ %p2, %dc0.test ]
  %fp = bitcast i8* %p.call to void (i32)*
  call void %fp(i32 8)
  br label %ret_minus1

e2c:                                              ; 0x140001e2c
  %tmp.e2c = call i8* @sub_1400027A8(i32 11, i32 1)
  br label %ret_minus1

e40:                                              ; 0x140001e40
  %tmp.e40 = call i8* @sub_1400027A8(i32 4, i32 1)
  br label %ret_minus1

e54:                                              ; 0x140001e54
  %tmp.e54 = call i8* @sub_1400027A8(i32 8, i32 1)
  call void @sub_140002120()
  br label %ret_minus1

d1f:                                              ; 0x140001d1f
  %fpraw = load i8*, i8** @qword_1400070D0, align 8
  %fpnull = icmp eq i8* %fpraw, null
  br i1 %fpnull, label %d70, label %tailjmp

tailjmp:
  %callee = bitcast i8* %fpraw to i32 (i8**)*
  %ret = tail call i32 %callee(i8** %rcx)
  ret i32 %ret

d70:                                              ; 0x140001d70
  ret i32 0

ret_minus1:                                       ; 0x140001d54 and other def cases
  ret i32 -1
}