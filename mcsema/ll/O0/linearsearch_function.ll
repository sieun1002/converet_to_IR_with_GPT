; ModuleID = 'linearsearch.ll'
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

@RSP_2312_d4765b8 = external global i64
@OF_2077_d476570 = external global i8
@SF_2073_d476570 = external global i8
@ZF_2071_d476570 = external global i8
@AF_2069_d476570 = external global i8
@PF_2067_d476570 = external global i8
@CF_2065_d476570 = external global i8
@RAX_2216_d4765b8 = external global i64
@RSP_2312_d47dbc0 = external global i64*
@RDI_2296_d4765b8 = external global i64
@RBP_2328_d4765b8 = external global i64
@RDX_2264_d4765b8 = external global i64
@RDX_2264_d4765a0 = external global i32
@RSI_2280_d4765a0 = external global i32

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare !remill.function.type !4 i32 @llvm.ctpop.i32(i32) #0

; Function Attrs: noinline
define hidden %struct.Memory* @sub_1189_linear_search(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #1 {
inst_1189:
  %0 = load i32, i32* @RDX_2264_d4765a0, align 4
  %1 = load i64, i64* @RBP_2328_d4765b8, align 8
  %2 = load i64*, i64** @RSP_2312_d47dbc0, align 8
  %3 = load i64, i64* @RSP_2312_d4765b8, align 8, !tbaa !5
  %4 = add i64 %3, -8
  %5 = getelementptr i64, i64* %2, i32 -1
  store i64 %1, i64* %5, align 8
  store i64 %4, i64* @RSP_2312_d4765b8, align 8, !tbaa !8
  store i64 %4, i64* @RBP_2328_d4765b8, align 8, !tbaa !8
  %6 = sub i64 %4, 24
  %7 = load i64, i64* @RDI_2296_d4765b8, align 8
  %8 = inttoptr i64 %6 to i64*
  store i64 %7, i64* %8, align 8
  %9 = sub i64 %4, 28
  %10 = load i32, i32* @RSI_2280_d4765a0, align 4
  %11 = inttoptr i64 %9 to i32*
  store i32 %10, i32* %11, align 4
  %12 = sub i64 %4, 32
  %13 = inttoptr i64 %12 to i32*
  store i32 %0, i32* %13, align 4
  %14 = sub i64 %4, 4
  %15 = inttoptr i64 %14 to i32*
  store i32 0, i32* %15, align 4
  br label %inst_11c8

inst_11c8:                                        ; preds = %inst_11c4, %inst_1189
  %16 = load i32, i32* %15, align 4
  %17 = load i32, i32* %11, align 4
  %18 = sub i32 %16, %17
  %19 = icmp ugt i32 %17, %16
  %20 = zext i1 %19 to i8
  store i8 %20, i8* @CF_2065_d476570, align 1, !tbaa !10
  %21 = and i32 %18, 255
  %22 = call i32 @llvm.ctpop.i32(i32 %21) #2, !range !24
  %23 = trunc i32 %22 to i8
  %24 = and i8 %23, 1
  %25 = xor i8 %24, 1
  store i8 %25, i8* @PF_2067_d476570, align 1, !tbaa !25
  %26 = xor i32 %17, %16
  %27 = xor i32 %26, %18
  %28 = lshr i32 %27, 4
  %29 = trunc i32 %28 to i8
  %30 = and i8 %29, 1
  store i8 %30, i8* @AF_2069_d476570, align 1, !tbaa !26
  %31 = icmp eq i32 %18, 0
  %32 = zext i1 %31 to i8
  store i8 %32, i8* @ZF_2071_d476570, align 1, !tbaa !27
  %33 = lshr i32 %18, 31
  %34 = trunc i32 %33 to i8
  store i8 %34, i8* @SF_2073_d476570, align 1, !tbaa !28
  %35 = lshr i32 %16, 31
  %36 = lshr i32 %17, 31
  %37 = xor i32 %36, %35
  %38 = xor i32 %33, %35
  %39 = add nuw nsw i32 %38, %37
  %40 = icmp eq i32 %39, 2
  %41 = zext i1 %40 to i8
  store i8 %41, i8* @OF_2077_d476570, align 1, !tbaa !29
  %42 = icmp ne i8 %34, 0
  %43 = xor i1 %42, %40
  br i1 %43, label %inst_11a4, label %inst_11d0

inst_11d5:                                        ; preds = %inst_11d0, %inst_11bf
  %44 = load i64, i64* %5, align 8
  store i64 %44, i64* @RBP_2328_d4765b8, align 8, !tbaa !8
  %45 = add i64 %3, 8
  store i64 %45, i64* @RSP_2312_d4765b8, align 8, !tbaa !8
  ret %struct.Memory* %memory

inst_11c4:                                        ; preds = %inst_11a4
  %46 = add i32 %16, 1
  store i32 %46, i32* %15, align 4
  br label %inst_11c8

inst_11bf:                                        ; preds = %inst_11a4
  %47 = zext i32 %16 to i64
  store i64 %47, i64* @RAX_2216_d4765b8, align 8, !tbaa !8
  br label %inst_11d5

inst_11a4:                                        ; preds = %inst_11c8
  %48 = sext i32 %16 to i64
  %49 = mul i64 %48, 4
  store i64 %49, i64* @RDX_2264_d4765b8, align 8, !tbaa !8
  %50 = load i64, i64* %8, align 8
  %51 = add i64 %49, %50
  %52 = inttoptr i64 %51 to i32*
  %53 = load i32, i32* %52, align 4
  %54 = load i32, i32* %13, align 4
  %55 = sub i32 %54, %53
  %56 = icmp ult i32 %54, %53
  %57 = zext i1 %56 to i8
  store i8 %57, i8* @CF_2065_d476570, align 1, !tbaa !10
  %58 = and i32 %55, 255
  %59 = call i32 @llvm.ctpop.i32(i32 %58) #2, !range !24
  %60 = trunc i32 %59 to i8
  %61 = and i8 %60, 1
  %62 = xor i8 %61, 1
  store i8 %62, i8* @PF_2067_d476570, align 1, !tbaa !25
  %63 = xor i32 %54, %53
  %64 = xor i32 %63, %55
  %65 = lshr i32 %64, 4
  %66 = trunc i32 %65 to i8
  %67 = and i8 %66, 1
  store i8 %67, i8* @AF_2069_d476570, align 1, !tbaa !26
  %68 = icmp eq i32 %55, 0
  %69 = zext i1 %68 to i8
  store i8 %69, i8* @ZF_2071_d476570, align 1, !tbaa !27
  %70 = lshr i32 %55, 31
  %71 = trunc i32 %70 to i8
  store i8 %71, i8* @SF_2073_d476570, align 1, !tbaa !28
  %72 = lshr i32 %54, 31
  %73 = lshr i32 %53, 31
  %74 = xor i32 %72, %73
  %75 = xor i32 %70, %72
  %76 = add nuw nsw i32 %75, %74
  %77 = icmp eq i32 %76, 2
  %78 = zext i1 %77 to i8
  store i8 %78, i8* @OF_2077_d476570, align 1, !tbaa !29
  %79 = icmp eq i8 %69, 0
  br i1 %79, label %inst_11c4, label %inst_11bf

inst_11d0:                                        ; preds = %inst_11c8
  store i64 4294967295, i64* @RAX_2216_d4765b8, align 8, !tbaa !8
  br label %inst_11d5
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
