; ModuleID = 'sub_140002880_module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @llvm.stacksave()

define void @sub_140002880(i64 %size) {
entry:
  %base = call i8* @llvm.stacksave()
  %isSmall = icmp ult i64 %size, 4096
  br i1 %isSmall, label %small, label %firstIter

small:
  br label %final

firstIter:
  %rcx1 = getelementptr i8, i8* %base, i64 -4096
  %ptr1 = bitcast i8* %rcx1 to i64*
  %old1 = load volatile i64, i64* %ptr1, align 8
  store volatile i64 %old1, i64* %ptr1, align 8
  %r1 = sub i64 %size, 4096
  br label %loopCheck

loopCheck:
  %rcx_phi = phi i8* [ %rcx1, %firstIter ], [ %rcx_next, %loopBody ]
  %r_phi = phi i64 [ %r1, %firstIter ], [ %r_next, %loopBody ]
  %cond = icmp ugt i64 %r_phi, 4096
  br i1 %cond, label %loopBody, label %afterBig

loopBody:
  %rcx_next = getelementptr i8, i8* %rcx_phi, i64 -4096
  %ptrn = bitcast i8* %rcx_next to i64*
  %oldn = load volatile i64, i64* %ptrn, align 8
  store volatile i64 %oldn, i64* %ptrn, align 8
  %r_next = sub i64 %r_phi, 4096
  br label %loopCheck

afterBig:
  br label %final

final:
  %rcx_fin_phi = phi i8* [ %base, %small ], [ %rcx_phi, %afterBig ]
  %r_fin_phi = phi i64 [ %size, %small ], [ %r_phi, %afterBig ]
  %neg = sub i64 0, %r_fin_phi
  %rcx_fin = getelementptr i8, i8* %rcx_fin_phi, i64 %neg
  %ptrf = bitcast i8* %rcx_fin to i64*
  %oldf = load volatile i64, i64* %ptrf, align 8
  store volatile i64 %oldf, i64* %ptrf, align 8
  ret void
}