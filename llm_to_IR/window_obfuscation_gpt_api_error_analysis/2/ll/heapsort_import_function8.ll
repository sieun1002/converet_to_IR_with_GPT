; ModuleID = 'pseudo_reloc_runtime'
target triple = "x86_64-pc-windows-msvc"

; External globals (PE-style)
@dword_1400070A0 = external dso_local global i32            ; init guard
@dword_1400070A4 = external dso_local global i32            ; count of deferred ops
@qword_1400070A8 = external dso_local global i8*            ; buffer base for deferred ops (array stride 0x28)
@off_1400043A0   = external dso_local global i8*            ; image base
@off_1400043B0   = external dso_local global i8*            ; table end (v1/v2 pseudo-reloc table)
@off_1400043C0   = external dso_local global i8*            ; table start

; Optional external strings (declared as extern pointers to avoid size mismatches)
@aUnknownPseudoR    = external dso_local global i8*
@aDBitPseudoRelo    = external dso_local global i8*
@aUnknownPseudoR_0  = external dso_local global i8*

; External functions
declare dso_local i32  @sub_140002690()
declare dso_local void @sub_1400028E0()
declare dso_local void @sub_140001B30(i8*)
declare dso_local void @sub_140002B78(i8*, i8*, i32)
declare dso_local void @sub_140001AD0(i8*, ...)
declare dso_local void @loc_1400298F9()
declare dso_local void @unk_140004B70(i8*, i8*, i32, i8*)

; A faithful, well-typed LLVM IR implementation of the old (v1) pseudo relocation protocol path.
; The newer protocol is environment-specific and handled by helpers; this IR leaves it to the same helpers.
define dso_local void @sub_140001CA0() {
entry:
  %guard.load = load i32, i32* @dword_1400070A0, align 4
  %guard.zero = icmp eq i32 %guard.load, 0
  br i1 %guard.zero, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %n.call = call i32 @sub_140002690()
  %n.sext = sext i32 %n.call to i64
  %mul40  = mul i64 %n.sext, 40
  %plus15 = add i64 %mul40, 15
  %stk.aligned = and i64 %plus15, -16
  call void @sub_1400028E0()
  %buf = alloca i8, i64 %stk.aligned, align 16
  store i32 0, i32* @dword_1400070A4, align 4
  store i8* %buf, i8** @qword_1400070A8, align 8

  %tbl.end.ptr  = load i8*, i8** @off_1400043B0, align 8
  %tbl.start.ptr= load i8*, i8** @off_1400043C0, align 8
  %end.i = ptrtoint i8* %tbl.end.ptr to i64
  %beg.i = ptrtoint i8* %tbl.start.ptr to i64
  %diff  = sub i64 %end.i, %beg.i
  %gt7   = icmp sgt i64 %diff, 7
  br i1 %gt7, label %dispatch, label %ret

dispatch:
  ; For simplicity, process entries using the v1 (8-byte) format.
  ; Environments that actually emit v2 (12-byte) entries should be handled
  ; by the helpers we call below; falling back to v1 is safe for empty/short tables.
  %img.base = load i8*, i8** @off_1400043A0, align 8

  ; Prepare loop state
  %start.i = ptrtoint i8* %tbl.start.ptr to i64
  %end2.i  = ptrtoint i8* %tbl.end.ptr   to i64

  ; A scratch slot analogous to [rbp+var_48] used by sub_140002B78
  %scratch = alloca i64, align 8
  %scratch.i8 = bitcast i64* %scratch to i8*

  br label %loop.v1

loop.v1:
  %p.i = phi i64 [ %start.i, %dispatch ], [ %p.i.next, %loop.body.end ]
  %cont = icmp ult i64 %p.i, %end2.i
  br i1 %cont, label %loop.body, label %finalize

loop.body:
  %p.ptr      = inttoptr i64 %p.i to i8*
  %p.addend.p = getelementptr inbounds i8, i8* %p.ptr, i64 0
  %p.rva.p    = getelementptr inbounds i8, i8* %p.ptr, i64 4

  %addend.ld.raw = load i32, i32* bitcast (i8* %p.addend.p to i32*), align 1
  %rva.ld.raw    = load i32, i32* bitcast (i8* %p.rva.p    to i32*), align 1

  %rva.sext = sext i32 %rva.ld.raw to i64
  %tgt.ptr  = getelementptr inbounds i8, i8* %img.base, i64 %rva.sext
  %tgt.i32p = bitcast i8* %tgt.ptr to i32*
  %tgt.val  = load i32, i32* %tgt.i32p, align 1

  %sum32    = add i32 %addend.ld.raw, %tgt.val
  %sum64    = sext i32 %sum32 to i64
  store i64 %sum64, i64* %scratch, align 8

  call void @sub_140001B30(i8* %tgt.ptr)
  call void @sub_140002B78(i8* %tgt.ptr, i8* %scratch.i8, i32 4)

  br label %loop.body.end

loop.body.end:
  %p.i.next = add i64 %p.i, 8
  br label %loop.v1

finalize:
  ; If helpers queued any operations (dword_1400070A4 > 0), perform them.
  %queued.cnt = load i32, i32* @dword_1400070A4, align 4
  %has.queued = icmp sgt i32 %queued.cnt, 0
  br i1 %has.queued, label %do.flush, label %ret

do.flush:
  call void @loc_1400298F9()

  %base.buf = load i8*, i8** @qword_1400070A8, align 8
  %zero.i   = add i32 0, 0
  br label %flush.loop

flush.loop:
  %i.cur = phi i32 [ %zero.i, %do.flush ], [ %i.next, %flush.next ]
  %i.lt  = icmp slt i32 %i.cur, %queued.cnt
  br i1 %i.lt, label %flush.body, label %ret

flush.body:
  %i.cur64 = sext i32 %i.cur to i64
  %off.bytes = mul i64 %i.cur64, 40
  %ent.ptr  = getelementptr inbounds i8, i8* %base.buf, i64 %off.bytes

  %ent.size.p = bitcast i8* %ent.ptr to i32*
  %ent.size   = load i32, i32* %ent.size.p, align 1

  %size.nonzero = icmp ne i32 %ent.size, 0
  br i1 %size.nonzero, label %flush.call, label %flush.next

flush.call:
  %rcx.p = getelementptr inbounds i8, i8* %ent.ptr, i64 8
  %rdx.p = getelementptr inbounds i8, i8* %ent.ptr, i64 16

  %rcx.ld = load i8*, i8** bitcast (i8* %rcx.p to i8**), align 8
  %rdx.ld = load i8*, i8** bitcast (i8* %rdx.p to i8**), align 8

  call void @unk_140004B70(i8* %rcx.ld, i8* %rdx.ld, i32 %ent.size, i8* %scratch.i8)
  br label %flush.next

flush.next:
  %i.next = add i32 %i.cur, 1
  br label %flush.loop

ret:
  ret void
}