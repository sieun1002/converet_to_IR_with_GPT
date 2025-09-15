; ModuleID = 'insertionsort.ll'
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

@RSP_2312_1eed5b8 = external global i64
@OF_2077_1eed570 = external global i8
@SF_2073_1eed570 = external global i8
@ZF_2071_1eed570 = external global i8
@AF_2069_1eed570 = external global i8
@PF_2067_1eed570 = external global i8
@CF_2065_1eed570 = external global i8
@RAX_2216_1eed5b8 = external global i64
@RSP_2312_1ef4bc0 = external global i64*
@RDI_2296_1eed5b8 = external global i64
@RBP_2328_1eed5b8 = external global i64
@RCX_2248_1eed5b8 = external global i64
@RSI_2280_1eed5b8 = external global i64
@RDX_2264_1eed5b8 = external global i64

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare !remill.function.type !4 i32 @llvm.ctpop.i32(i32) #0

; Function Attrs: noinline
define hidden %struct.Memory* @sub_1189_insertion_sort(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #1 {
inst_1189:
  %0 = load i64, i64* @RBP_2328_1eed5b8, align 8
  %1 = load i64*, i64** @RSP_2312_1ef4bc0, align 8
  %2 = load i64, i64* @RSP_2312_1eed5b8, align 8, !tbaa !5
  %3 = add i64 %2, -8
  %4 = getelementptr i64, i64* %1, i32 -1
  store i64 %0, i64* %4, align 8
  store i64 %3, i64* @RSP_2312_1eed5b8, align 8, !tbaa !8
  store i64 %3, i64* @RBP_2328_1eed5b8, align 8, !tbaa !8
  %5 = sub i64 %3, 40
  %6 = load i64, i64* @RDI_2296_1eed5b8, align 8
  %7 = inttoptr i64 %5 to i64*
  store i64 %6, i64* %7, align 8
  %8 = sub i64 %3, 48
  %9 = load i64, i64* @RSI_2280_1eed5b8, align 8
  %10 = inttoptr i64 %8 to i64*
  store i64 %9, i64* %10, align 8
  %11 = sub i64 %3, 16
  %12 = inttoptr i64 %11 to i64*
  store i64 1, i64* %12, align 8
  br label %inst_1235

inst_1235:                                        ; preds = %inst_1218, %inst_1189
  %13 = load i64, i64* %12, align 8
  store i64 %13, i64* @RAX_2216_1eed5b8, align 8, !tbaa !8
  %14 = load i64, i64* %10, align 8
  %15 = sub i64 %13, %14
  %16 = icmp ugt i64 %14, %13
  %17 = zext i1 %16 to i8
  store i8 %17, i8* @CF_2065_1eed570, align 1, !tbaa !10
  %18 = trunc i64 %15 to i32
  %19 = and i32 %18, 255
  %20 = call i32 @llvm.ctpop.i32(i32 %19) #2, !range !24
  %21 = trunc i32 %20 to i8
  %22 = and i8 %21, 1
  %23 = xor i8 %22, 1
  store i8 %23, i8* @PF_2067_1eed570, align 1, !tbaa !25
  %24 = xor i64 %14, %13
  %25 = xor i64 %24, %15
  %26 = lshr i64 %25, 4
  %27 = trunc i64 %26 to i8
  %28 = and i8 %27, 1
  store i8 %28, i8* @AF_2069_1eed570, align 1, !tbaa !26
  %29 = icmp eq i64 %15, 0
  %30 = zext i1 %29 to i8
  store i8 %30, i8* @ZF_2071_1eed570, align 1, !tbaa !27
  %31 = lshr i64 %15, 63
  %32 = trunc i64 %31 to i8
  store i8 %32, i8* @SF_2073_1eed570, align 1, !tbaa !28
  %33 = lshr i64 %13, 63
  %34 = lshr i64 %14, 63
  %35 = xor i64 %34, %33
  %36 = xor i64 %31, %33
  %37 = add nuw nsw i64 %36, %35
  %38 = icmp eq i64 %37, 2
  %39 = zext i1 %38 to i8
  store i8 %39, i8* @OF_2077_1eed570, align 1, !tbaa !29
  br i1 %16, label %inst_11a6, label %inst_1243

inst_11f7:                                        ; preds = %inst_11a6, %inst_11c8
  %40 = load i64, i64* %82, align 8
  %41 = icmp eq i64 %40, 0
  br i1 %41, label %inst_1218, label %inst_11fe

inst_1218:                                        ; preds = %inst_11fe, %inst_11f7
  %42 = mul i64 %40, 4
  %43 = load i64, i64* %7, align 8
  %44 = add i64 %43, %42
  store i64 %44, i64* @RDX_2264_1eed5b8, align 8, !tbaa !8
  %45 = load i32, i32* %79, align 4
  %46 = inttoptr i64 %44 to i32*
  store i32 %45, i32* %46, align 4
  %47 = load i64, i64* %12, align 8
  %48 = add i64 %47, 1
  store i64 %48, i64* %12, align 8
  br label %inst_1235

inst_11fe:                                        ; preds = %inst_11f7
  %49 = shl i64 %40, 1
  %50 = shl i64 %49, 1
  %51 = sub i64 %50, 4
  %52 = load i64, i64* %7, align 8
  %53 = add i64 %51, %52
  %54 = inttoptr i64 %53 to i32*
  %55 = load i32, i32* %54, align 4
  %56 = load i32, i32* %79, align 4
  %57 = sub i32 %56, %55
  %58 = lshr i32 %57, 31
  %59 = trunc i32 %58 to i8
  %60 = lshr i32 %56, 31
  %61 = lshr i32 %55, 31
  %62 = xor i32 %60, %61
  %63 = xor i32 %58, %60
  %64 = add nuw nsw i32 %63, %62
  %65 = icmp eq i32 %64, 2
  %66 = icmp ne i8 %59, 0
  %67 = xor i1 %66, %65
  br i1 %67, label %inst_11c8, label %inst_1218

inst_11c8:                                        ; preds = %inst_11fe
  %68 = mul i64 %40, 4
  store i64 %68, i64* @RCX_2248_1eed5b8, align 8, !tbaa !8
  %69 = add i64 %68, %52
  %70 = inttoptr i64 %69 to i32*
  store i32 %55, i32* %70, align 4
  %71 = load i64, i64* %82, align 8
  %72 = sub i64 %71, 1
  store i64 %72, i64* %82, align 8
  br label %inst_11f7

inst_11a6:                                        ; preds = %inst_1235
  %73 = mul i64 %13, 4
  %74 = load i64, i64* %7, align 8
  %75 = add i64 %73, %74
  %76 = inttoptr i64 %75 to i32*
  %77 = load i32, i32* %76, align 4
  %78 = sub i64 %3, 20
  %79 = inttoptr i64 %78 to i32*
  store i32 %77, i32* %79, align 4
  %80 = load i64, i64* %12, align 8
  %81 = sub i64 %3, 8
  %82 = inttoptr i64 %81 to i64*
  store i64 %80, i64* %82, align 8
  br label %inst_11f7

inst_1243:                                        ; preds = %inst_1235
  %83 = load i64, i64* %4, align 8
  store i64 %83, i64* @RBP_2328_1eed5b8, align 8, !tbaa !8
  %84 = add i64 %2, 8
  store i64 %84, i64* @RSP_2312_1eed5b8, align 8, !tbaa !8
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
