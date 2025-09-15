; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/mcsema/ll/O0/selectionsort_function.ll'
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
  %4 = getelementptr i64, i64* %1, i64 -1
  store i64 %0, i64* %4, align 8
  store i64 %3, i64* @RSP_2312_2a2e65b8, align 8, !tbaa !8
  store i64 %3, i64* @RBP_2328_2a2e65b8, align 8, !tbaa !8
  %5 = add i64 %2, -32
  %6 = load i64, i64* @RDI_2296_2a2e65b8, align 8
  %7 = inttoptr i64 %5 to i64*
  store i64 %6, i64* %7, align 8
  %8 = add i64 %2, -36
  %9 = load i32, i32* @RSI_2280_2a2e65a0, align 4
  %10 = inttoptr i64 %8 to i32*
  store i32 %9, i32* %10, align 4
  %11 = add i64 %2, -24
  %12 = inttoptr i64 %11 to i32*
  br label %inst_123a

inst_11cb:                                        ; preds = %inst_1195, %inst_11c5
  br label %inst_11cf

inst_11cf:                                        ; preds = %inst_1184, %inst_11cb
  %storemerge1.in.in = phi i32* [ %12, %inst_1184 ], [ %109, %inst_11cb ]
  %storemerge1.in = load i32, i32* %storemerge1.in.in, align 4
  %storemerge1 = add i32 %storemerge1.in, 1
  store i32 %storemerge1, i32* %109, align 4
  %13 = load i32, i32* %10, align 4
  %14 = sub i32 %storemerge1, %13
  %15 = lshr i32 %14, 31
  %16 = lshr i32 %storemerge1, 31
  %17 = lshr i32 %13, 31
  %18 = xor i32 %17, %16
  %19 = xor i32 %15, %16
  %20 = add nuw nsw i32 %19, %18
  %21 = icmp eq i32 %20, 2
  %22 = icmp slt i32 %14, 0
  %23 = xor i1 %22, %21
  br i1 %23, label %inst_1195, label %inst_11d7

inst_123a:                                        ; preds = %inst_11d7, %inst_1169
  %storemerge = phi i32 [ 0, %inst_1169 ], [ %105, %inst_11d7 ]
  store i32 %storemerge, i32* %12, align 4
  %24 = load i32, i32* %10, align 4
  %25 = add i32 %24, -1
  %26 = zext i32 %25 to i64
  store i64 %26, i64* @RAX_2216_2a2e65b8, align 8, !tbaa !8
  %27 = load i32, i32* %12, align 4
  %28 = sub i32 %27, %25
  %29 = icmp ult i32 %27, %25
  %30 = zext i1 %29 to i8
  store i8 %30, i8* @CF_2065_2a2e6570, align 1, !tbaa !10
  %31 = and i32 %28, 255
  %32 = call i32 @llvm.ctpop.i32(i32 %31) #2, !range !24
  %33 = trunc i32 %32 to i8
  %34 = and i8 %33, 1
  %35 = xor i8 %34, 1
  store i8 %35, i8* @PF_2067_2a2e6570, align 1, !tbaa !25
  %36 = xor i32 %27, %25
  %37 = xor i32 %36, %28
  %38 = trunc i32 %37 to i8
  %39 = lshr i8 %38, 4
  %40 = and i8 %39, 1
  store i8 %40, i8* @AF_2069_2a2e6570, align 1, !tbaa !26
  %41 = icmp eq i32 %28, 0
  %42 = zext i1 %41 to i8
  store i8 %42, i8* @ZF_2071_2a2e6570, align 1, !tbaa !27
  %43 = lshr i32 %28, 31
  %44 = trunc i32 %43 to i8
  store i8 %44, i8* @SF_2073_2a2e6570, align 1, !tbaa !28
  %45 = lshr i32 %27, 31
  %46 = lshr i32 %25, 31
  %47 = xor i32 %45, %46
  %48 = xor i32 %43, %45
  %49 = add nuw nsw i32 %48, %47
  %50 = icmp eq i32 %49, 2
  %51 = zext i1 %50 to i8
  store i8 %51, i8* @OF_2077_2a2e6570, align 1, !tbaa !29
  %52 = icmp slt i32 %28, 0
  %53 = xor i1 %52, %50
  br i1 %53, label %inst_1184, label %inst_1249

inst_11c5:                                        ; preds = %inst_1195
  store i32 %storemerge1, i32* %107, align 4
  br label %inst_11cb

inst_1195:                                        ; preds = %inst_11cf
  %54 = sext i32 %storemerge1 to i64
  %55 = shl nsw i64 %54, 2
  %56 = load i64, i64* %7, align 8
  %57 = add i64 %55, %56
  %58 = inttoptr i64 %57 to i32*
  %59 = load i32, i32* %58, align 4
  %60 = load i32, i32* %107, align 4
  %61 = sext i32 %60 to i64
  %62 = shl nsw i64 %61, 2
  %63 = add i64 %62, %56
  %64 = inttoptr i64 %63 to i32*
  %65 = load i32, i32* %64, align 4
  %66 = sub i32 %59, %65
  %67 = lshr i32 %66, 31
  %68 = lshr i32 %59, 31
  %69 = lshr i32 %65, 31
  %70 = xor i32 %69, %68
  %71 = xor i32 %67, %68
  %72 = add nuw nsw i32 %71, %70
  %73 = icmp eq i32 %72, 2
  %74 = icmp sgt i32 %66, -1
  %75 = xor i1 %74, %73
  br i1 %75, label %inst_11cb, label %inst_11c5

inst_11d7:                                        ; preds = %inst_11cf
  %76 = load i32, i32* %12, align 4
  %77 = sext i32 %76 to i64
  %78 = shl nsw i64 %77, 2
  %79 = load i64, i64* %7, align 8
  %80 = add i64 %78, %79
  %81 = inttoptr i64 %80 to i32*
  %82 = load i32, i32* %81, align 4
  %83 = add i64 %2, -12
  %84 = inttoptr i64 %83 to i32*
  store i32 %82, i32* %84, align 4
  %85 = load i32, i32* %107, align 4
  %86 = sext i32 %85 to i64
  %87 = shl nsw i64 %86, 2
  %88 = load i64, i64* %7, align 8
  %89 = add i64 %87, %88
  %90 = load i32, i32* %12, align 4
  %91 = sext i32 %90 to i64
  %92 = shl nsw i64 %91, 2
  store i64 %92, i64* @RCX_2248_2a2e65b8, align 8, !tbaa !8
  %93 = add i64 %92, %88
  %94 = inttoptr i64 %89 to i32*
  %95 = load i32, i32* %94, align 4
  %96 = inttoptr i64 %93 to i32*
  store i32 %95, i32* %96, align 4
  %97 = load i32, i32* %107, align 4
  %98 = sext i32 %97 to i64
  %99 = shl nsw i64 %98, 2
  %100 = load i64, i64* %7, align 8
  %101 = add i64 %100, %99
  store i64 %101, i64* @RDX_2264_2a2e65b8, align 8, !tbaa !8
  %102 = load i32, i32* %84, align 4
  %103 = inttoptr i64 %101 to i32*
  store i32 %102, i32* %103, align 4
  %104 = load i32, i32* %12, align 4
  %105 = add i32 %104, 1
  br label %inst_123a

inst_1184:                                        ; preds = %inst_123a
  %106 = add i64 %2, -16
  %107 = inttoptr i64 %106 to i32*
  store i32 %27, i32* %107, align 4
  %108 = add i64 %2, -20
  %109 = inttoptr i64 %108 to i32*
  br label %inst_11cf

inst_1249:                                        ; preds = %inst_123a
  %110 = load i64, i64* %4, align 8
  store i64 %110, i64* @RBP_2328_2a2e65b8, align 8, !tbaa !8
  %111 = add i64 %2, 8
  store i64 %111, i64* @RSP_2312_2a2e65b8, align 8, !tbaa !8
  ret %struct.Memory* %memory
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
