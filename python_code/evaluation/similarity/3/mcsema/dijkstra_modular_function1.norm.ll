; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/mcsema/ll/O0/dijkstra_modular_function1.ll'
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

@RSP_2312_4145c678 = external global i64
@OF_2077_4145c630 = external global i8
@SF_2073_4145c630 = external global i8
@ZF_2071_4145c630 = external global i8
@AF_2069_4145c630 = external global i8
@PF_2067_4145c630 = external global i8
@CF_2065_4145c630 = external global i8
@RAX_2216_4145c678 = external global i64
@RSP_2312_41463c00 = external global i64*
@RCX_2248_4145c678 = external global i64
@RDI_2296_4145c678 = external global i64
@RBP_2328_4145c678 = external global i64
@RSI_2280_4145c660 = external global i32

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare !remill.function.type !4 i32 @llvm.ctpop.i32(i32) #0

; Function Attrs: noinline
define hidden %struct.Memory* @sub_401130_init_graph(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #1 {
inst_401130:
  %0 = load i64, i64* @RBP_2328_4145c678, align 8
  %1 = load i64*, i64** @RSP_2312_41463c00, align 8
  %2 = load i64, i64* @RSP_2312_4145c678, align 8, !tbaa !5
  %3 = add i64 %2, -8
  %4 = getelementptr i64, i64* %1, i64 -1
  store i64 %0, i64* %4, align 8
  store i64 %3, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  store i64 %3, i64* @RBP_2328_4145c678, align 8, !tbaa !8
  %5 = add i64 %2, -16
  %6 = load i64, i64* @RDI_2296_4145c678, align 8
  %7 = inttoptr i64 %5 to i64*
  store i64 %6, i64* %7, align 8
  %8 = add i64 %2, -20
  %9 = load i32, i32* @RSI_2280_4145c660, align 4
  %10 = inttoptr i64 %8 to i32*
  store i32 %9, i32* %10, align 4
  %11 = add i64 %2, -24
  %12 = inttoptr i64 %11 to i32*
  br label %inst_401142

inst_401142:                                      ; preds = %inst_40118c, %inst_401130
  %storemerge = phi i32 [ 0, %inst_401130 ], [ %57, %inst_40118c ]
  store i32 %storemerge, i32* %12, align 4
  %13 = zext i32 %storemerge to i64
  store i64 %13, i64* @RAX_2216_4145c678, align 8, !tbaa !8
  %14 = load i32, i32* %10, align 4
  %15 = sub i32 %storemerge, %14
  %16 = icmp ult i32 %storemerge, %14
  %17 = zext i1 %16 to i8
  store i8 %17, i8* @CF_2065_4145c630, align 1, !tbaa !10
  %18 = and i32 %15, 255
  %19 = call i32 @llvm.ctpop.i32(i32 %18) #2, !range !24
  %20 = trunc i32 %19 to i8
  %21 = and i8 %20, 1
  %22 = xor i8 %21, 1
  store i8 %22, i8* @PF_2067_4145c630, align 1, !tbaa !25
  %23 = xor i32 %14, %storemerge
  %24 = xor i32 %23, %15
  %25 = trunc i32 %24 to i8
  %26 = lshr i8 %25, 4
  %27 = and i8 %26, 1
  store i8 %27, i8* @AF_2069_4145c630, align 1, !tbaa !26
  %28 = icmp eq i32 %15, 0
  %29 = zext i1 %28 to i8
  store i8 %29, i8* @ZF_2071_4145c630, align 1, !tbaa !27
  %30 = lshr i32 %15, 31
  %31 = trunc i32 %30 to i8
  store i8 %31, i8* @SF_2073_4145c630, align 1, !tbaa !28
  %32 = lshr i32 %storemerge, 31
  %33 = lshr i32 %14, 31
  %34 = xor i32 %33, %32
  %35 = xor i32 %30, %32
  %36 = add nuw nsw i32 %35, %34
  %37 = icmp eq i32 %36, 2
  %38 = zext i1 %37 to i8
  store i8 %38, i8* @OF_2077_4145c630, align 1, !tbaa !29
  %39 = icmp sgt i32 %15, -1
  %40 = xor i1 %39, %37
  br i1 %40, label %inst_40119f, label %inst_40114e

inst_401155:                                      ; preds = %inst_401161, %inst_40114e
  %storemerge1 = phi i32 [ 0, %inst_40114e ], [ %68, %inst_401161 ]
  store i32 %storemerge1, i32* %55, align 4
  %41 = load i32, i32* %10, align 4
  %42 = sub i32 %storemerge1, %41
  %43 = lshr i32 %42, 31
  %44 = lshr i32 %storemerge1, 31
  %45 = lshr i32 %41, 31
  %46 = xor i32 %45, %44
  %47 = xor i32 %43, %44
  %48 = add nuw nsw i32 %47, %46
  %49 = icmp eq i32 %48, 2
  %50 = icmp sgt i32 %42, -1
  %51 = xor i1 %50, %49
  br i1 %51, label %inst_40118c, label %inst_401161

inst_40119f:                                      ; preds = %inst_401142
  %52 = load i64, i64* %4, align 8
  store i64 %52, i64* @RBP_2328_4145c678, align 8, !tbaa !8
  %53 = add i64 %2, 8
  store i64 %53, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  ret %struct.Memory* %memory

inst_40114e:                                      ; preds = %inst_401142
  %54 = add i64 %2, -28
  %55 = inttoptr i64 %54 to i32*
  br label %inst_401155

inst_40118c:                                      ; preds = %inst_401155
  %56 = load i32, i32* %12, align 4
  %57 = add i32 %56, 1
  br label %inst_401142

inst_401161:                                      ; preds = %inst_401155
  %58 = load i64, i64* %7, align 8
  %59 = load i32, i32* %12, align 4
  %60 = sext i32 %59 to i64
  %61 = mul nsw i64 %60, 400
  %62 = add i64 %61, %58
  %63 = sext i32 %storemerge1 to i64
  store i64 %63, i64* @RCX_2248_4145c678, align 8, !tbaa !8
  %64 = shl nsw i64 %63, 2
  %65 = add i64 %64, %62
  %66 = inttoptr i64 %65 to i32*
  store i32 0, i32* %66, align 4
  %67 = load i32, i32* %55, align 4
  %68 = add i32 %67, 1
  br label %inst_401155
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
