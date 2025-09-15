; ModuleID = 'selectionsort.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu-elf"

%struct.State = type { %struct.ArchState, [32 x %union.VectorReg], %struct.ArithFlags, %union.anon, %struct.Segments, %struct.AddressSpace, %struct.GPR, %struct.X87Stack, %struct.MMX, %struct.FPUStatusFlags, %union.anon, %union.FPU, %struct.SegmentCaches }
%struct.ArchState = type { i32, i32, %union.anon }
%union.VectorReg = type { %union.vec512_t }
%union.vec512_t = type { %struct.uint64v8_t }
%struct.uint64v8_t = type { [8 x i64] }
%struct.ArithFlags = type { i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8 }
%struct.Segments = type { i16, %union.SegmentSelector, i16, %union.SegmentSelector, i16, %union.SegmentSelector, i16, %union.SegmentSelector, i16, %union.SegmentSelector, i16, %union.SegmentSelector }
%union.SegmentSelector = type { i16 }
%struct.AddressSpace = type { i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg }
%struct.Reg = type { %union.anon }
%struct.GPR = type { i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg }
%struct.X87Stack = type { [8 x %struct.anon.3] }
%struct.anon.3 = type { [6 x i8], %struct.float80_t }
%struct.float80_t = type { [10 x i8] }
%struct.MMX = type { [8 x %struct.anon.4] }
%struct.anon.4 = type { i64, %union.vec64_t }
%union.vec64_t = type { %struct.uint64v1_t }
%struct.uint64v1_t = type { [1 x i64] }
%struct.FPUStatusFlags = type { i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, [4 x i8] }
%union.anon = type { i64 }
%union.FPU = type { %struct.anon.13 }
%struct.anon.13 = type { %struct.FpuFXSAVE, [96 x i8] }
%struct.FpuFXSAVE = type { %union.SegmentSelector, %union.SegmentSelector, %union.FPUAbridgedTagWord, i8, i16, i32, %union.SegmentSelector, i16, i32, %union.SegmentSelector, i16, %union.FPUControlStatus, %union.FPUControlStatus, [8 x %struct.FPUStackElem], [16 x %union.vec128_t] }
%union.FPUAbridgedTagWord = type { i8 }
%union.FPUControlStatus = type { i32 }
%struct.FPUStackElem = type { %union.anon.11, [6 x i8] }
%union.anon.11 = type { %struct.float80_t }
%union.vec128_t = type { %struct.uint128v1_t }
%struct.uint128v1_t = type { [1 x i128] }
%struct.SegmentCaches = type { %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow }
%struct.SegmentShadow = type { %union.anon, i32, i32 }
%struct.Memory = type opaque

@RSP_2312_2a2e65b8 = external global i64
@OF_2077_2a2e6570 = external global i8
@SF_2073_2a2e6570 = external global i8
@ZF_2071_2a2e6570 = external global i8
@AF_2069_2a2e6570 = external global i8
@PF_2067_2a2e6570 = external global i8
@CF_2065_2a2e6570 = external global i8
@RAX_2216_2a2e65b8 = external global i64
@RSP_2312_2a2edbc0 = external global i64*
@RCX_2248_2a2e65b8 = external global i64
@RDX_2264_2a2e65b8 = external global i64
@RBP_2328_2a2e65b8 = external global i64
@RDI_2296_2a2e65b8 = external global i64
@RSI_2280_2a2e65a0 = external global i32

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare !remill.function.type !4 i32 @llvm.ctpop.i32(i32) #0

; Function Attrs: noinline
define hidden %struct.Memory* @sub_1169_selection_sort(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #1 {
inst_1169:
  %0 = load i64, i64* @RBP_2328_2a2e65b8, align 8
  %1 = load i64*, i64** @RSP_2312_2a2edbc0, align 8
  %2 = load i64, i64* @RSP_2312_2a2e65b8, align 8, !tbaa !5
  %3 = add i64 %2, -8
  %4 = getelementptr i64, i64* %1, i32 -1
  store i64 %0, i64* %4, align 8
  store i64 %3, i64* @RSP_2312_2a2e65b8, align 8, !tbaa !8
  store i64 %3, i64* @RBP_2328_2a2e65b8, align 8, !tbaa !8
  %5 = sub i64 %3, 24
  %6 = load i64, i64* @RDI_2296_2a2e65b8, align 8
  %7 = inttoptr i64 %5 to i64*
  store i64 %6, i64* %7, align 8
  %8 = sub i64 %3, 28
  %9 = load i32, i32* @RSI_2280_2a2e65a0, align 4
  %10 = inttoptr i64 %8 to i32*
  store i32 %9, i32* %10, align 4
  %11 = sub i64 %3, 16
  %12 = inttoptr i64 %11 to i32*
  store i32 0, i32* %12, align 4
  br label %inst_123a

inst_11cb:                                        ; preds = %inst_1195, %inst_11c5
  %13 = load i32, i32* %119, align 4
  %14 = add i32 %13, 1
  store i32 %14, i32* %119, align 4
  br label %inst_11cf

inst_11cf:                                        ; preds = %inst_1184, %inst_11cb
  %15 = load i32, i32* %119, align 4
  %16 = load i32, i32* %10, align 4
  %17 = sub i32 %15, %16
  %18 = lshr i32 %17, 31
  %19 = trunc i32 %18 to i8
  %20 = lshr i32 %15, 31
  %21 = lshr i32 %16, 31
  %22 = xor i32 %21, %20
  %23 = xor i32 %18, %20
  %24 = add nuw nsw i32 %23, %22
  %25 = icmp eq i32 %24, 2
  %26 = icmp ne i8 %19, 0
  %27 = xor i1 %26, %25
  br i1 %27, label %inst_1195, label %inst_11d7

inst_123a:                                        ; preds = %inst_11d7, %inst_1169
  %28 = phi %struct.Memory* [ %memory, %inst_1169 ], [ %28, %inst_11d7 ]
  %29 = load i32, i32* %10, align 4
  %30 = sub i32 %29, 1
  %31 = zext i32 %30 to i64
  store i64 %31, i64* @RAX_2216_2a2e65b8, align 8, !tbaa !8
  %32 = load i32, i32* %12, align 4
  %33 = sub i32 %32, %30
  %34 = icmp ult i32 %32, %30
  %35 = zext i1 %34 to i8
  store i8 %35, i8* @CF_2065_2a2e6570, align 1, !tbaa !10
  %36 = and i32 %33, 255
  %37 = call i32 @llvm.ctpop.i32(i32 %36) #2, !range !24
  %38 = trunc i32 %37 to i8
  %39 = and i8 %38, 1
  %40 = xor i8 %39, 1
  store i8 %40, i8* @PF_2067_2a2e6570, align 1, !tbaa !25
  %41 = xor i32 %32, %30
  %42 = xor i32 %41, %33
  %43 = lshr i32 %42, 4
  %44 = trunc i32 %43 to i8
  %45 = and i8 %44, 1
  store i8 %45, i8* @AF_2069_2a2e6570, align 1, !tbaa !26
  %46 = icmp eq i32 %33, 0
  %47 = zext i1 %46 to i8
  store i8 %47, i8* @ZF_2071_2a2e6570, align 1, !tbaa !27
  %48 = lshr i32 %33, 31
  %49 = trunc i32 %48 to i8
  store i8 %49, i8* @SF_2073_2a2e6570, align 1, !tbaa !28
  %50 = lshr i32 %32, 31
  %51 = lshr i32 %30, 31
  %52 = xor i32 %50, %51
  %53 = xor i32 %48, %50
  %54 = add nuw nsw i32 %53, %52
  %55 = icmp eq i32 %54, 2
  %56 = zext i1 %55 to i8
  store i8 %56, i8* @OF_2077_2a2e6570, align 1, !tbaa !29
  %57 = icmp ne i8 %49, 0
  %58 = xor i1 %57, %55
  br i1 %58, label %inst_1184, label %inst_1249

inst_11c5:                                        ; preds = %inst_1195
  store i32 %15, i32* %115, align 4
  br label %inst_11cb

inst_1195:                                        ; preds = %inst_11cf
  %59 = sext i32 %15 to i64
  %60 = mul i64 %59, 4
  %61 = load i64, i64* %7, align 8
  %62 = add i64 %60, %61
  %63 = inttoptr i64 %62 to i32*
  %64 = load i32, i32* %63, align 4
  %65 = load i32, i32* %115, align 4
  %66 = sext i32 %65 to i64
  %67 = mul i64 %66, 4
  %68 = add i64 %67, %61
  %69 = inttoptr i64 %68 to i32*
  %70 = load i32, i32* %69, align 4
  %71 = sub i32 %64, %70
  %72 = lshr i32 %71, 31
  %73 = trunc i32 %72 to i8
  %74 = lshr i32 %64, 31
  %75 = lshr i32 %70, 31
  %76 = xor i32 %75, %74
  %77 = xor i32 %72, %74
  %78 = add nuw nsw i32 %77, %76
  %79 = icmp eq i32 %78, 2
  %80 = icmp eq i8 %73, 0
  %81 = xor i1 %80, %79
  br i1 %81, label %inst_11cb, label %inst_11c5

inst_11d7:                                        ; preds = %inst_11cf
  %82 = load i32, i32* %12, align 4
  %83 = sext i32 %82 to i64
  %84 = mul i64 %83, 4
  %85 = load i64, i64* %7, align 8
  %86 = add i64 %84, %85
  %87 = inttoptr i64 %86 to i32*
  %88 = load i32, i32* %87, align 4
  %89 = sub i64 %3, 4
  %90 = inttoptr i64 %89 to i32*
  store i32 %88, i32* %90, align 4
  %91 = load i32, i32* %115, align 4
  %92 = sext i32 %91 to i64
  %93 = mul i64 %92, 4
  %94 = load i64, i64* %7, align 8
  %95 = add i64 %93, %94
  %96 = load i32, i32* %12, align 4
  %97 = zext i32 %96 to i64
  %98 = shl i64 %97, 32
  %99 = ashr exact i64 %98, 32
  %100 = mul i64 %99, 4
  store i64 %100, i64* @RCX_2248_2a2e65b8, align 8, !tbaa !8
  %101 = add i64 %100, %94
  %102 = inttoptr i64 %95 to i32*
  %103 = load i32, i32* %102, align 4
  %104 = inttoptr i64 %101 to i32*
  store i32 %103, i32* %104, align 4
  %105 = load i32, i32* %115, align 4
  %106 = sext i32 %105 to i64
  %107 = mul i64 %106, 4
  %108 = load i64, i64* %7, align 8
  %109 = add i64 %108, %107
  store i64 %109, i64* @RDX_2264_2a2e65b8, align 8, !tbaa !8
  %110 = load i32, i32* %90, align 4
  %111 = inttoptr i64 %109 to i32*
  store i32 %110, i32* %111, align 4
  %112 = load i32, i32* %12, align 4
  %113 = add i32 %112, 1
  store i32 %113, i32* %12, align 4
  br label %inst_123a

inst_1184:                                        ; preds = %inst_123a
  %114 = sub i64 %3, 8
  %115 = inttoptr i64 %114 to i32*
  store i32 %32, i32* %115, align 4
  %116 = load i32, i32* %12, align 4
  %117 = add i32 1, %116
  %118 = sub i64 %3, 12
  %119 = inttoptr i64 %118 to i32*
  store i32 %117, i32* %119, align 4
  br label %inst_11cf

inst_1249:                                        ; preds = %inst_123a
  %120 = load i64, i64* %4, align 8
  store i64 %120, i64* @RBP_2328_2a2e65b8, align 8, !tbaa !8
  %121 = add i64 %2, 8
  store i64 %121, i64* @RSP_2312_2a2e65b8, align 8, !tbaa !8
  ret %struct.Memory* %28
}

attributes #0 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #1 = { noinline "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind }

!llvm.ident = !{!0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}
!llvm.dbg.cu = !{}

!0 = !{!"clang version 9.0.1 (https://github.com/trailofbits/vcpkg.git 4592a93cc4ca82f1963dba08413c43639662d7ae)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 2, !"Dwarf Version", i32 4}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{!"base.helper.semantics"}
!5 = !{!6, !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C++ TBAA"}
!8 = !{!9, !9, i64 0}
!9 = !{!"long", !6, i64 0}
!10 = !{!11, !6, i64 2065}
!11 = !{!"_ZTS5State", !6, i64 16, !12, i64 2064, !6, i64 2080, !13, i64 2088, !15, i64 2112, !17, i64 2208, !18, i64 2480, !19, i64 2608, !20, i64 2736, !6, i64 2760, !6, i64 2768, !21, i64 3280}
!12 = !{!"_ZTS10ArithFlags", !6, i64 0, !6, i64 1, !6, i64 2, !6, i64 3, !6, i64 4, !6, i64 5, !6, i64 6, !6, i64 7, !6, i64 8, !6, i64 9, !6, i64 10, !6, i64 11, !6, i64 12, !6, i64 13, !6, i64 14, !6, i64 15}
!13 = !{!"_ZTS8Segments", !14, i64 0, !6, i64 2, !14, i64 4, !6, i64 6, !14, i64 8, !6, i64 10, !14, i64 12, !6, i64 14, !14, i64 16, !6, i64 18, !14, i64 20, !6, i64 22}
!14 = !{!"short", !6, i64 0}
!15 = !{!"_ZTS12AddressSpace", !9, i64 0, !16, i64 8, !9, i64 16, !16, i64 24, !9, i64 32, !16, i64 40, !9, i64 48, !16, i64 56, !9, i64 64, !16, i64 72, !9, i64 80, !16, i64 88}
!16 = !{!"_ZTS3Reg", !6, i64 0}
!17 = !{!"_ZTS3GPR", !9, i64 0, !16, i64 8, !9, i64 16, !16, i64 24, !9, i64 32, !16, i64 40, !9, i64 48, !16, i64 56, !9, i64 64, !16, i64 72, !9, i64 80, !16, i64 88, !9, i64 96, !16, i64 104, !9, i64 112, !16, i64 120, !9, i64 128, !16, i64 136, !9, i64 144, !16, i64 152, !9, i64 160, !16, i64 168, !9, i64 176, !16, i64 184, !9, i64 192, !16, i64 200, !9, i64 208, !16, i64 216, !9, i64 224, !16, i64 232, !9, i64 240, !16, i64 248, !9, i64 256, !16, i64 264}
!18 = !{!"_ZTS8X87Stack", !6, i64 0}
!19 = !{!"_ZTS3MMX", !6, i64 0}
!20 = !{!"_ZTS14FPUStatusFlags", !6, i64 0, !6, i64 1, !6, i64 2, !6, i64 3, !6, i64 4, !6, i64 5, !6, i64 6, !6, i64 7, !6, i64 8, !6, i64 9, !6, i64 10, !6, i64 11, !6, i64 12, !6, i64 13, !6, i64 14, !6, i64 15, !6, i64 16, !6, i64 17, !6, i64 18, !6, i64 19, !6, i64 20}
!21 = !{!"_ZTS13SegmentCaches", !22, i64 0, !22, i64 16, !22, i64 32, !22, i64 48, !22, i64 64, !22, i64 80}
!22 = !{!"_ZTS13SegmentShadow", !6, i64 0, !23, i64 8, !23, i64 12}
!23 = !{!"int", !6, i64 0}
!24 = !{i32 0, i32 9}
!25 = !{!11, !6, i64 2067}
!26 = !{!11, !6, i64 2069}
!27 = !{!11, !6, i64 2071}
!28 = !{!11, !6, i64 2073}
!29 = !{!11, !6, i64 2077}
