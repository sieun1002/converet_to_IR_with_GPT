; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/mcsema/ll/O0/mergesort_function.ll'
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

@__mcsema_reg_state = external thread_local(initialexec) global %struct.State
@data_1208 = external global i8
@data_13e3 = external global i8
@RSP_2312_3bf505b8 = external global i64
@OF_2077_3bf50570 = external global i8
@SF_2073_3bf50570 = external global i8
@ZF_2071_3bf50570 = external global i8
@AF_2069_3bf50570 = external global i8
@PF_2067_3bf50570 = external global i8
@CF_2065_3bf50570 = external global i8
@RAX_2216_3bf505b8 = external global i64
@RBP_2328_3bf505b8 = external global i64
@RBP_2328_3bf57bc0 = external global i64*
@RCX_2248_3bf505b8 = external global i64
@RDX_2264_3bf505b8 = external global i64
@RSI_2280_3bf505b8 = external global i64
@RDI_2296_3bf505b8 = external global i64

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare !remill.function.type !4 i32 @llvm.ctpop.i32(i32) #0

; Function Attrs: noinline
define hidden %struct.Memory* @sub_11e9_merge_sort(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #1 {
inst_11e9:
  %0 = load i64, i64* @RBP_2328_3bf505b8, align 8
  %1 = load i64, i64* @RSP_2312_3bf505b8, align 8, !tbaa !5
  %2 = add i64 %1, -8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3, align 8
  store i64 %2, i64* @RBP_2328_3bf505b8, align 8, !tbaa !8
  %4 = add i64 %1, -120
  store i64 %4, i64* @RSP_2312_3bf505b8, align 8, !tbaa !8
  %5 = add i64 %1, -112
  %6 = load i64, i64* @RDI_2296_3bf505b8, align 8
  %7 = inttoptr i64 %5 to i64*
  store i64 %6, i64* %7, align 8
  %8 = load i64, i64* @RSI_2280_3bf505b8, align 8
  %9 = inttoptr i64 %4 to i64*
  store i64 %8, i64* %9, align 8
  %10 = add i64 %8, -1
  %11 = icmp eq i64 %8, 0
  %12 = zext i1 %11 to i8
  store i8 %12, i8* @CF_2065_3bf50570, align 1, !tbaa !10
  %13 = trunc i64 %10 to i32
  %14 = and i32 %13, 255
  %15 = call i32 @llvm.ctpop.i32(i32 %14) #3, !range !24
  %16 = trunc i32 %15 to i8
  %17 = and i8 %16, 1
  %18 = xor i8 %17, 1
  store i8 %18, i8* @PF_2067_3bf50570, align 1, !tbaa !25
  %19 = xor i64 %8, %10
  %20 = trunc i64 %19 to i8
  %21 = lshr i8 %20, 4
  %22 = and i8 %21, 1
  store i8 %22, i8* @AF_2069_3bf50570, align 1, !tbaa !26
  %23 = icmp eq i64 %10, 0
  %24 = zext i1 %23 to i8
  store i8 %24, i8* @ZF_2071_3bf50570, align 1, !tbaa !27
  %25 = lshr i64 %10, 63
  %26 = trunc i64 %25 to i8
  store i8 %26, i8* @SF_2073_3bf50570, align 1, !tbaa !28
  %27 = lshr i64 %8, 63
  %28 = xor i64 %25, %27
  %29 = add nuw nsw i64 %28, %27
  %30 = icmp eq i64 %29, 2
  %31 = zext i1 %30 to i8
  store i8 %31, i8* @OF_2077_3bf50570, align 1, !tbaa !29
  %32 = icmp ult i64 %8, 2
  br i1 %32, label %inst_13f5, label %inst_1208

inst_1382:                                        ; preds = %inst_1244, %inst_1377
  %storemerge1 = phi i64 [ 0, %inst_1244 ], [ %147, %inst_1377 ]
  store i64 %storemerge1, i64* %180, align 8
  %33 = load i64, i64* %36, align 8
  %34 = icmp ugt i64 %33, %storemerge1
  br i1 %34, label %inst_1251, label %inst_1390

inst_13ac:                                        ; preds = %inst_1390, %inst_1227
  %storemerge = phi i64 [ 1, %inst_1227 ], [ %178, %inst_1390 ]
  store i64 %storemerge, i64* %119, align 8
  %35 = add i64 %96, -112
  %36 = inttoptr i64 %35 to i64*
  %37 = load i64, i64* %36, align 8
  %38 = icmp ugt i64 %37, %storemerge
  br i1 %38, label %inst_1244, label %inst_13ba

inst_1332:                                        ; preds = %inst_12bc.inst_1332_crit_edge, %inst_12d0
  %.pre-phi = phi i64 [ %.pre6, %inst_12bc.inst_1332_crit_edge ], [ %126, %inst_12d0 ]
  %39 = phi i64 [ %.pre, %inst_12bc.inst_1332_crit_edge ], [ %120, %inst_12d0 ]
  %40 = add i64 %39, 1
  store i64 %40, i64* %168, align 8
  %41 = load i64, i64* %114, align 8
  %42 = add i64 %.pre-phi, %41
  %43 = load i64, i64* %171, align 8
  %44 = shl i64 %43, 2
  store i64 %44, i64* @RCX_2248_3bf505b8, align 8, !tbaa !8
  %45 = load i64, i64* %117, align 8
  %46 = add i64 %44, %45
  store i64 %46, i64* @RDX_2264_3bf505b8, align 8, !tbaa !8
  %47 = inttoptr i64 %42 to i32*
  %48 = load i32, i32* %47, align 4
  %49 = inttoptr i64 %46 to i32*
  store i32 %48, i32* %49, align 4
  br label %inst_1364

inst_13e3:                                        ; preds = %inst_13c4, %inst_13ba
  %50 = phi %struct.Memory* [ %95, %inst_13ba ], [ %211, %inst_13c4 ]
  %51 = load i64, i64* @RBP_2328_3bf505b8, align 8
  %52 = add i64 %51, -24
  %53 = inttoptr i64 %52 to i64*
  %54 = load i64, i64* %53, align 8
  store i64 %54, i64* @RAX_2216_3bf505b8, align 8, !tbaa !8
  store i64 %54, i64* @RDI_2296_3bf505b8, align 8, !tbaa !8
  %55 = load i64, i64* @RSP_2312_3bf505b8, align 8, !tbaa !5
  %56 = add i64 %55, -8
  %57 = inttoptr i64 %56 to i64*
  store i64 add (i64 ptrtoint (i8* @data_13e3 to i64), i64 12), i64* %57, align 8
  store i64 %56, i64* @RSP_2312_3bf505b8, align 8, !tbaa !8
  %58 = call %struct.Memory* @ext_10a0__free(%struct.State* nonnull @__mcsema_reg_state, i64 undef, %struct.Memory* %50)
  br label %inst_13f5

inst_1364:                                        ; preds = %inst_12fe, %inst_1332
  %59 = load i64, i64* %171, align 8
  %60 = add i64 %59, 1
  br label %inst_1369

inst_1369:                                        ; preds = %inst_1251, %inst_1364
  %storemerge3 = phi i64 [ %169, %inst_1251 ], [ %60, %inst_1364 ]
  store i64 %storemerge3, i64* %171, align 8
  %61 = load i64, i64* %161, align 8
  %62 = icmp ugt i64 %61, %storemerge3
  br i1 %62, label %inst_12bc, label %inst_1377

inst_13f5:                                        ; preds = %inst_1208, %inst_13e3, %inst_11e9
  %63 = phi %struct.Memory* [ %58, %inst_13e3 ], [ %95, %inst_1208 ], [ %memory, %inst_11e9 ]
  %64 = load i64*, i64** @RBP_2328_3bf57bc0, align 8
  %65 = load i64, i64* @RBP_2328_3bf505b8, align 8, !tbaa !5
  %66 = load i64, i64* %64, align 8
  store i64 %66, i64* @RBP_2328_3bf505b8, align 8, !tbaa !8
  %67 = add i64 %65, 16
  store i64 %67, i64* @RSP_2312_3bf505b8, align 8, !tbaa !8
  ret %struct.Memory* %63

inst_12fe:                                        ; preds = %inst_12c6.inst_12fe_crit_edge, %inst_12d0
  %.pre-phi8 = phi i64 [ %.pre7, %inst_12c6.inst_12fe_crit_edge ], [ %121, %inst_12d0 ]
  %68 = add i64 %142, 1
  store i64 %68, i64* %165, align 8
  %69 = load i64, i64* %114, align 8
  %70 = add i64 %.pre-phi8, %69
  %71 = load i64, i64* %171, align 8
  %72 = shl i64 %71, 2
  store i64 %72, i64* @RCX_2248_3bf505b8, align 8, !tbaa !8
  %73 = load i64, i64* %117, align 8
  %74 = add i64 %72, %73
  store i64 %74, i64* @RDX_2264_3bf505b8, align 8, !tbaa !8
  %75 = inttoptr i64 %70 to i32*
  %76 = load i32, i32* %75, align 4
  %77 = inttoptr i64 %74 to i32*
  store i32 %76, i32* %77, align 4
  br label %inst_1364

inst_1208:                                        ; preds = %inst_11e9
  %78 = shl i64 %8, 2
  store i64 %78, i64* @RAX_2216_3bf505b8, align 8, !tbaa !8
  %79 = lshr i64 %8, 62
  %80 = trunc i64 %79 to i8
  %81 = and i8 %80, 1
  store i8 %81, i8* @CF_2065_3bf50570, align 1, !tbaa !5
  %82 = trunc i64 %78 to i32
  %83 = and i32 %82, 252
  %84 = call i32 @llvm.ctpop.i32(i32 %83) #3, !range !24
  %85 = trunc i32 %84 to i8
  %86 = and i8 %85, 1
  %87 = xor i8 %86, 1
  store i8 %87, i8* @PF_2067_3bf50570, align 1, !tbaa !5
  store i8 0, i8* @AF_2069_3bf50570, align 1, !tbaa !5
  %88 = icmp eq i64 %78, 0
  %89 = zext i1 %88 to i8
  store i8 %89, i8* @ZF_2071_3bf50570, align 1, !tbaa !5
  %90 = lshr i64 %78, 63
  %91 = trunc i64 %90 to i8
  store i8 %91, i8* @SF_2073_3bf50570, align 1, !tbaa !5
  store i8 0, i8* @OF_2077_3bf50570, align 1, !tbaa !5
  store i64 %78, i64* @RDI_2296_3bf505b8, align 8, !tbaa !8
  %92 = load i64, i64* @RSP_2312_3bf505b8, align 8, !tbaa !5
  %93 = add i64 %92, -8
  %94 = inttoptr i64 %93 to i64*
  store i64 add (i64 ptrtoint (i8* @data_1208 to i64), i64 16), i64* %94, align 8
  store i64 %93, i64* @RSP_2312_3bf505b8, align 8, !tbaa !8
  %95 = call %struct.Memory* @ext_10f0__malloc(%struct.State* nonnull @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  %96 = load i64, i64* @RBP_2328_3bf505b8, align 8
  %97 = add i64 %96, -24
  %98 = load i64, i64* @RAX_2216_3bf505b8, align 8
  %99 = inttoptr i64 %97 to i64*
  store i64 %98, i64* %99, align 8
  store i8 0, i8* @CF_2065_3bf50570, align 1, !tbaa !10
  %100 = trunc i64 %98 to i32
  %101 = and i32 %100, 255
  %102 = call i32 @llvm.ctpop.i32(i32 %101) #3, !range !24
  %103 = trunc i32 %102 to i8
  %104 = and i8 %103, 1
  %105 = xor i8 %104, 1
  store i8 %105, i8* @PF_2067_3bf50570, align 1, !tbaa !25
  store i8 0, i8* @AF_2069_3bf50570, align 1, !tbaa !26
  %106 = icmp eq i64 %98, 0
  %107 = zext i1 %106 to i8
  store i8 %107, i8* @ZF_2071_3bf50570, align 1, !tbaa !27
  %108 = lshr i64 %98, 63
  %109 = trunc i64 %108 to i8
  store i8 %109, i8* @SF_2073_3bf50570, align 1, !tbaa !28
  store i8 0, i8* @OF_2077_3bf50570, align 1, !tbaa !29
  br i1 %106, label %inst_13f5, label %inst_1227

inst_1227:                                        ; preds = %inst_1208
  %110 = add i64 %96, -104
  %111 = inttoptr i64 %110 to i64*
  %112 = load i64, i64* %111, align 8
  %113 = add i64 %96, -96
  %114 = inttoptr i64 %113 to i64*
  store i64 %112, i64* %114, align 8
  %115 = load i64, i64* %99, align 8
  %116 = add i64 %96, -88
  %117 = inttoptr i64 %116 to i64*
  store i64 %115, i64* %117, align 8
  %118 = add i64 %96, -80
  %119 = inttoptr i64 %118 to i64*
  br label %inst_13ac

inst_12c6:                                        ; preds = %inst_12bc
  %120 = load i64, i64* %168, align 8
  %.not5 = icmp ugt i64 %61, %120
  br i1 %.not5, label %inst_12d0, label %inst_12c6.inst_12fe_crit_edge

inst_12c6.inst_12fe_crit_edge:                    ; preds = %inst_12c6
  %.pre7 = shl i64 %142, 2
  br label %inst_12fe

inst_12d0:                                        ; preds = %inst_12c6
  %121 = shl i64 %142, 2
  %122 = load i64, i64* %114, align 8
  %123 = add i64 %121, %122
  %124 = inttoptr i64 %123 to i32*
  %125 = load i32, i32* %124, align 4
  %126 = shl i64 %120, 2
  %127 = add i64 %126, %122
  %128 = inttoptr i64 %127 to i32*
  %129 = load i32, i32* %128, align 4
  %130 = sub i32 %125, %129
  %131 = icmp ne i32 %130, 0
  %132 = lshr i32 %130, 31
  %133 = lshr i32 %125, 31
  %134 = lshr i32 %129, 31
  %135 = xor i32 %134, %133
  %136 = xor i32 %132, %133
  %137 = add nuw nsw i32 %136, %135
  %138 = icmp eq i32 %137, 2
  %139 = icmp sgt i32 %130, -1
  %140 = xor i1 %139, %138
  %141 = and i1 %131, %140
  br i1 %141, label %inst_1332, label %inst_12fe

inst_12bc:                                        ; preds = %inst_1369
  %142 = load i64, i64* %165, align 8
  %143 = load i64, i64* %154, align 8
  %.not4 = icmp ugt i64 %143, %142
  br i1 %.not4, label %inst_12c6, label %inst_12bc.inst_1332_crit_edge

inst_12bc.inst_1332_crit_edge:                    ; preds = %inst_12bc
  %.pre = load i64, i64* %168, align 8
  %.pre6 = shl i64 %.pre, 2
  br label %inst_1332

inst_1377:                                        ; preds = %inst_1369
  %144 = load i64, i64* %119, align 8
  %145 = shl i64 %144, 1
  %146 = load i64, i64* %180, align 8
  %147 = add i64 %146, %145
  br label %inst_1382

inst_1251:                                        ; preds = %inst_1382
  %148 = add i64 %96, -8
  %149 = inttoptr i64 %148 to i64*
  store i64 %storemerge1, i64* %149, align 8
  %150 = load i64, i64* %180, align 8
  %151 = load i64, i64* %119, align 8
  %152 = add i64 %150, %151
  %153 = add i64 %96, -64
  %154 = inttoptr i64 %153 to i64*
  store i64 %152, i64* %154, align 8
  %155 = load i64, i64* %36, align 8
  %.not = icmp ult i64 %155, %152
  %spec.store.select702 = select i1 %.not, i64 %155, i64 %152
  store i64 %spec.store.select702, i64* %154, align 8
  %156 = load i64, i64* %119, align 8
  %157 = shl i64 %156, 1
  store i64 %157, i64* @RDX_2264_3bf505b8, align 8, !tbaa !8
  %158 = load i64, i64* %180, align 8
  %159 = add i64 %157, %158
  %160 = add i64 %96, -56
  %161 = inttoptr i64 %160 to i64*
  store i64 %159, i64* %161, align 8
  %162 = load i64, i64* %36, align 8
  %.not2 = icmp ult i64 %162, %159
  %spec.store.select = select i1 %.not2, i64 %162, i64 %159
  store i64 %spec.store.select, i64* %161, align 8
  %163 = load i64, i64* %149, align 8
  %164 = add i64 %96, -48
  %165 = inttoptr i64 %164 to i64*
  store i64 %163, i64* %165, align 8
  %166 = load i64, i64* %154, align 8
  %167 = add i64 %96, -40
  %168 = inttoptr i64 %167 to i64*
  store i64 %166, i64* %168, align 8
  %169 = load i64, i64* %149, align 8
  %170 = add i64 %96, -32
  %171 = inttoptr i64 %170 to i64*
  br label %inst_1369

inst_1390:                                        ; preds = %inst_1382
  %172 = load i64, i64* %114, align 8
  %173 = add i64 %96, -16
  %174 = inttoptr i64 %173 to i64*
  store i64 %172, i64* %174, align 8
  %175 = load i64, i64* %117, align 8
  store i64 %175, i64* %114, align 8
  %176 = load i64, i64* %174, align 8
  store i64 %176, i64* %117, align 8
  %177 = load i64, i64* %119, align 8
  %178 = shl i64 %177, 1
  br label %inst_13ac

inst_1244:                                        ; preds = %inst_13ac
  %179 = add i64 %96, -72
  %180 = inttoptr i64 %179 to i64*
  br label %inst_1382

inst_13ba:                                        ; preds = %inst_13ac
  %181 = load i64, i64* %114, align 8
  %182 = load i64, i64* %111, align 8
  %183 = sub i64 %181, %182
  %184 = icmp ult i64 %181, %182
  %185 = zext i1 %184 to i8
  store i8 %185, i8* @CF_2065_3bf50570, align 1, !tbaa !10
  %186 = trunc i64 %183 to i32
  %187 = and i32 %186, 255
  %188 = call i32 @llvm.ctpop.i32(i32 %187) #3, !range !24
  %189 = trunc i32 %188 to i8
  %190 = and i8 %189, 1
  %191 = xor i8 %190, 1
  store i8 %191, i8* @PF_2067_3bf50570, align 1, !tbaa !25
  %192 = xor i64 %182, %181
  %193 = xor i64 %192, %183
  %194 = trunc i64 %193 to i8
  %195 = lshr i8 %194, 4
  %196 = and i8 %195, 1
  store i8 %196, i8* @AF_2069_3bf50570, align 1, !tbaa !26
  %197 = icmp eq i64 %183, 0
  %198 = zext i1 %197 to i8
  store i8 %198, i8* @ZF_2071_3bf50570, align 1, !tbaa !27
  %199 = lshr i64 %183, 63
  %200 = trunc i64 %199 to i8
  store i8 %200, i8* @SF_2073_3bf50570, align 1, !tbaa !28
  %201 = lshr i64 %181, 63
  %202 = lshr i64 %182, 63
  %203 = xor i64 %202, %201
  %204 = xor i64 %199, %201
  %205 = add nuw nsw i64 %204, %203
  %206 = icmp eq i64 %205, 2
  %207 = zext i1 %206 to i8
  store i8 %207, i8* @OF_2077_3bf50570, align 1, !tbaa !29
  br i1 %197, label %inst_13e3, label %inst_13c4

inst_13c4:                                        ; preds = %inst_13ba
  %208 = shl i64 %37, 2
  store i64 %208, i64* @RDX_2264_3bf505b8, align 8, !tbaa !8
  store i64 %181, i64* @RCX_2248_3bf505b8, align 8, !tbaa !8
  store i64 %182, i64* @RAX_2216_3bf505b8, align 8, !tbaa !8
  store i64 %181, i64* @RSI_2280_3bf505b8, align 8, !tbaa !8
  store i64 %182, i64* @RDI_2296_3bf505b8, align 8, !tbaa !8
  %209 = load i64, i64* @RSP_2312_3bf505b8, align 8, !tbaa !5
  %210 = add i64 %209, -8
  store i64 %210, i64* @RSP_2312_3bf505b8, align 8, !tbaa !8
  %211 = call %struct.Memory* @ext_10e0__memcpy(%struct.State* nonnull @__mcsema_reg_state, i64 undef, %struct.Memory* %95)
  br label %inst_13e3
}

; Function Attrs: noinline
declare hidden %struct.Memory* @ext_10f0__malloc(%struct.State*, i64, %struct.Memory*) #2

; Function Attrs: noinline
declare hidden %struct.Memory* @ext_10e0__memcpy(%struct.State*, i64, %struct.Memory*) #2

; Function Attrs: noinline
declare hidden %struct.Memory* @ext_10a0__free(%struct.State*, i64, %struct.Memory*) #2

attributes #0 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #1 = { noinline "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { noinline }
attributes #3 = { nounwind }

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
