; ModuleID = 'sub_140001CA0.ll'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = external global i32, align 4
@dword_1400070A4 = external global i32, align 4
@qword_1400070A8 = external global i8*, align 8

@off_1400043A0 = external global i8*, align 8
@off_1400043B0 = external global i8*, align 8
@off_1400043C0 = external global i8*, align 8

declare i32 @sub_140002690()
declare void @sub_1400028E0()
declare void @sub_140001B30(i8*)
declare i8* @memcpy(i8*, i8*, i64)
declare i1 @VirtualProtect(i8*, i64, i32, i32*)

define void @sub_140001CA0() local_unnamed_addr {
entry:
  %guard.ld = load i32, i32* @dword_1400070A0, align 4
  %guard.iszero = icmp eq i32 %guard.ld, 0
  br i1 %guard.iszero, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %n.call = call i32 @sub_140002690()
  %n.sext = sext i32 %n.call to i64
  %n.mul5 = mul i64 %n.sext, 5
  %n.mul40 = mul i64 %n.mul5, 8
  %n.add15 = add i64 %n.mul40, 15
  %n.al16 = and i64 %n.add15, -16
  call void @sub_1400028E0()
  %start.ld = load i8*, i8** @off_1400043C0, align 8
  %end.ld = load i8*, i8** @off_1400043B0, align 8
  %entries.alloca = alloca i8, i64 %n.al16, align 16
  store i32 0, i32* @dword_1400070A4, align 4
  store i8* %entries.alloca, i8** @qword_1400070A8, align 8
  %start.int = ptrtoint i8* %start.ld to i64
  %end.int = ptrtoint i8* %end.ld to i64
  %diff = sub i64 %end.int, %start.int
  %diff.le.7 = icmp sle i64 %diff, 7
  br i1 %diff.le.7, label %ret, label %check_v2

check_v2:
  %diff.gt.11 = icmp sgt i64 %diff, 11
  br i1 %diff.gt.11, label %protocol_v2, label %ret

protocol_v2:
  %base.ld = load i8*, i8** @off_1400043A0, align 8
  %oldprot = alloca i32, align 4
  %tmp32 = alloca i32, align 4
  br label %loop

loop:
  %cur.ptr = phi i8* [ %start.ld, %protocol_v2 ], [ %next.ptr, %loop ]
  %cont = icmp ult i8* %cur.ptr, %end.ld
  br i1 %cont, label %body, label %after_loop

body:
  %addend.p32 = bitcast i8* %cur.ptr to i32*
  %addend = load i32, i32* %addend.p32, align 4
  %off.ptr = getelementptr i8, i8* %cur.ptr, i64 4
  %off.p32 = bitcast i8* %off.ptr to i32*
  %offset = load i32, i32* %off.p32, align 4
  %next.ptr = getelementptr i8, i8* %cur.ptr, i64 8
  %offset.sext = sext i32 %offset to i64
  %tgt.ptr = getelementptr i8, i8* %base.ld, i64 %offset.sext
  %tgt.p32 = bitcast i8* %tgt.ptr to i32*
  %curval = load i32, i32* %tgt.p32, align 4
  %sum = add i32 %curval, %addend
  store i32 %sum, i32* %tmp32, align 4
  call void @sub_140001B30(i8* %tgt.ptr)
  %tmp.i8 = bitcast i32* %tmp32 to i8*
  %memcpy.call = call i8* @memcpy(i8* %tgt.ptr, i8* %tmp.i8, i64 4)
  br label %loop

after_loop:
  %count.ld = load i32, i32* @dword_1400070A4, align 4
  %has.count = icmp sgt i32 %count.ld, 0
  br i1 %has.count, label %prot_loop.pre, label %ret

prot_loop.pre:
  %entries.base = load i8*, i8** @qword_1400070A8, align 8
  %count.sext = sext i32 %count.ld to i64
  br label %prot_loop

prot_loop:
  %i = phi i64 [ 0, %prot_loop.pre ], [ %i.next, %prot_loop ]
  %i.x5 = mul i64 %i, 5
  %i.x40 = mul i64 %i.x5, 8
  %ent.ptr = getelementptr i8, i8* %entries.base, i64 %i.x40
  %fl.p32 = bitcast i8* %ent.ptr to i32*
  %fl.ld = load i32, i32* %fl.p32, align 4
  %fl.nonzero = icmp ne i32 %fl.ld, 0
  br i1 %fl.nonzero, label %do_protect, label %skip_protect

do_protect:
  %addr.off = getelementptr i8, i8* %ent.ptr, i64 8
  %addr.pp = bitcast i8* %addr.off to i8**
  %addr.ld = load i8*, i8** %addr.pp, align 8
  %size.off = getelementptr i8, i8* %ent.ptr, i64 16
  %size.p64 = bitcast i8* %size.off to i64*
  %size.ld = load i64, i64* %size.p64, align 8
  %vp.call = call i1 @VirtualProtect(i8* %addr.ld, i64 %size.ld, i32 %fl.ld, i32* %oldprot)
  br label %skip_protect

skip_protect:
  %i.next = add i64 %i, 1
  %more = icmp slt i64 %i.next, %count.sext
  br i1 %more, label %prot_loop, label %ret

ret:
  ret void
}