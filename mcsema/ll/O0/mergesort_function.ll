; ModuleID = 'mergesort.ll'
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
  %4 = sub i64 %2, 112
  store i64 %4, i64* @RSP_2312_3bf505b8, align 8, !tbaa !8
  %5 = sub i64 %2, 104
  %6 = load i64, i64* @RDI_2296_3bf505b8, align 8
  %7 = inttoptr i64 %5 to i64*
  store i64 %6, i64* %7, align 8
  %8 = load i64, i64* @RSI_2280_3bf505b8, align 8
  %9 = inttoptr i64 %4 to i64*
  store i64 %8, i64* %9, align 8
  %10 = sub i64 %8, 1
  %11 = icmp ult i64 %8, 1
  %12 = zext i1 %11 to i8
  store i8 %12, i8* @CF_2065_3bf50570, align 1, !tbaa !10
  %13 = trunc i64 %10 to i32
  %14 = and i32 %13, 255
  %15 = call i32 @llvm.ctpop.i32(i32 %14) #3, !range !24
  %16 = trunc i32 %15 to i8
  %17 = and i8 %16, 1
  %18 = xor i8 %17, 1
  store i8 %18, i8* @PF_2067_3bf50570, align 1, !tbaa !25
  %19 = xor i64 %8, 1
  %20 = xor i64 %19, %10
  %21 = lshr i64 %20, 4
  %22 = trunc i64 %21 to i8
  %23 = and i8 %22, 1
  store i8 %23, i8* @AF_2069_3bf50570, align 1, !tbaa !26
  %24 = icmp eq i64 %10, 0
  %25 = zext i1 %24 to i8
  store i8 %25, i8* @ZF_2071_3bf50570, align 1, !tbaa !27
  %26 = lshr i64 %10, 63
  %27 = trunc i64 %26 to i8
  store i8 %27, i8* @SF_2073_3bf50570, align 1, !tbaa !28
  %28 = lshr i64 %8, 63
  %29 = xor i64 %26, %28
  %30 = add nuw nsw i64 %29, %28
  %31 = icmp eq i64 %30, 2
  %32 = zext i1 %31 to i8
  store i8 %32, i8* @OF_2077_3bf50570, align 1, !tbaa !29
  %33 = or i8 %25, %12
  %34 = icmp ne i8 %33, 0
  br i1 %34, label %inst_13f5, label %inst_1208

inst_1382:                                        ; preds = %inst_1244, %inst_1377
  %35 = phi %struct.Memory* [ %39, %inst_1244 ], [ %35, %inst_1377 ]
  %36 = load i64, i64* %205, align 8
  %37 = load i64, i64* %42, align 8
  %38 = icmp ugt i64 %37, %36
  br i1 %38, label %inst_1251, label %inst_1390

inst_13ac:                                        ; preds = %inst_1390, %inst_1227
  %39 = phi %struct.Memory* [ %105, %inst_1227 ], [ %35, %inst_1390 ]
  %40 = load i64, i64* %129, align 8
  %41 = sub i64 %106, 112
  %42 = inttoptr i64 %41 to i64*
  %43 = load i64, i64* %42, align 8
  %44 = icmp ugt i64 %43, %40
  br i1 %44, label %inst_1244, label %inst_13ba

inst_1332:                                        ; preds = %inst_12bc, %inst_12d0
  %45 = load i64, i64* %193, align 8
  %46 = add i64 %45, 1
  store i64 %46, i64* %193, align 8
  %47 = mul i64 %45, 4
  %48 = load i64, i64* %124, align 8
  %49 = add i64 %47, %48
  %50 = load i64, i64* %196, align 8
  %51 = mul i64 %50, 4
  store i64 %51, i64* @RCX_2248_3bf505b8, align 8, !tbaa !8
  %52 = load i64, i64* %127, align 8
  %53 = add i64 %51, %52
  store i64 %53, i64* @RDX_2264_3bf505b8, align 8, !tbaa !8
  %54 = inttoptr i64 %49 to i32*
  %55 = load i32, i32* %54, align 4
  %56 = inttoptr i64 %53 to i32*
  store i32 %55, i32* %56, align 4
  br label %inst_1364

inst_13e3:                                        ; preds = %inst_13c4, %inst_13ba
  %57 = phi %struct.Memory* [ %39, %inst_13ba ], [ %237, %inst_13c4 ]
  %58 = load i64, i64* @RBP_2328_3bf505b8, align 8
  %59 = sub i64 %58, 24
  %60 = inttoptr i64 %59 to i64*
  %61 = load i64, i64* %60, align 8
  store i64 %61, i64* @RAX_2216_3bf505b8, align 8, !tbaa !8
  store i64 %61, i64* @RDI_2296_3bf505b8, align 8, !tbaa !8
  %62 = load i64, i64* @RSP_2312_3bf505b8, align 8, !tbaa !5
  %63 = add i64 %62, -8
  %64 = inttoptr i64 %63 to i64*
  store i64 add (i64 ptrtoint (i8* @data_13e3 to i64), i64 12), i64* %64, align 8
  store i64 %63, i64* @RSP_2312_3bf505b8, align 8, !tbaa !8
  %65 = call %struct.Memory* @ext_10a0__free(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %57)
  br label %inst_13f5

inst_1364:                                        ; preds = %inst_12fe, %inst_1332
  %66 = load i64, i64* %196, align 8
  %67 = add i64 %66, 1
  store i64 %67, i64* %196, align 8
  br label %inst_1369

inst_1369:                                        ; preds = %inst_1251, %inst_1364
  %68 = load i64, i64* %196, align 8
  %69 = load i64, i64* %183, align 8
  %70 = icmp ugt i64 %69, %68
  br i1 %70, label %inst_12bc, label %inst_1377

inst_13f5:                                        ; preds = %inst_1208, %inst_13e3, %inst_11e9
  %71 = phi %struct.Memory* [ %65, %inst_13e3 ], [ %105, %inst_1208 ], [ %memory, %inst_11e9 ]
  %72 = load i64*, i64** @RBP_2328_3bf57bc0, align 8
  %73 = load i64, i64* @RBP_2328_3bf505b8, align 8, !tbaa !5
  %74 = load i64, i64* %72, align 8
  store i64 %74, i64* @RBP_2328_3bf505b8, align 8, !tbaa !8
  %75 = add i64 %73, 8
  %76 = add i64 %75, 8
  store i64 %76, i64* @RSP_2312_3bf505b8, align 8, !tbaa !8
  ret %struct.Memory* %71

inst_12fe:                                        ; preds = %inst_12d0, %inst_12c6
  %77 = add i64 %158, 1
  store i64 %77, i64* %190, align 8
  %78 = mul i64 %158, 4
  %79 = load i64, i64* %124, align 8
  %80 = add i64 %78, %79
  %81 = load i64, i64* %196, align 8
  %82 = mul i64 %81, 4
  store i64 %82, i64* @RCX_2248_3bf505b8, align 8, !tbaa !8
  %83 = load i64, i64* %127, align 8
  %84 = add i64 %82, %83
  store i64 %84, i64* @RDX_2264_3bf505b8, align 8, !tbaa !8
  %85 = inttoptr i64 %80 to i32*
  %86 = load i32, i32* %85, align 4
  %87 = inttoptr i64 %84 to i32*
  store i32 %86, i32* %87, align 4
  br label %inst_1364

inst_1208:                                        ; preds = %inst_11e9
  %88 = shl i64 %8, 1
  %89 = shl i64 %88, 1
  store i64 %89, i64* @RAX_2216_3bf505b8, align 8, !tbaa !8
  %90 = lshr i64 %88, 63
  %91 = trunc i64 %90 to i8
  store i8 %91, i8* @CF_2065_3bf50570, align 1, !tbaa !5
  %92 = trunc i64 %89 to i32
  %93 = and i32 %92, 254
  %94 = call i32 @llvm.ctpop.i32(i32 %93) #3, !range !24
  %95 = trunc i32 %94 to i8
  %96 = and i8 %95, 1
  %97 = xor i8 %96, 1
  store i8 %97, i8* @PF_2067_3bf50570, align 1, !tbaa !5
  store i8 0, i8* @AF_2069_3bf50570, align 1, !tbaa !5
  %98 = icmp eq i64 %89, 0
  %99 = zext i1 %98 to i8
  store i8 %99, i8* @ZF_2071_3bf50570, align 1, !tbaa !5
  %100 = lshr i64 %89, 63
  %101 = trunc i64 %100 to i8
  store i8 %101, i8* @SF_2073_3bf50570, align 1, !tbaa !5
  store i8 0, i8* @OF_2077_3bf50570, align 1, !tbaa !5
  store i64 %89, i64* @RDI_2296_3bf505b8, align 8, !tbaa !8
  %102 = load i64, i64* @RSP_2312_3bf505b8, align 8, !tbaa !5
  %103 = add i64 %102, -8
  %104 = inttoptr i64 %103 to i64*
  store i64 add (i64 ptrtoint (i8* @data_1208 to i64), i64 16), i64* %104, align 8
  store i64 %103, i64* @RSP_2312_3bf505b8, align 8, !tbaa !8
  %105 = call %struct.Memory* @ext_10f0__malloc(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  %106 = load i64, i64* @RBP_2328_3bf505b8, align 8
  %107 = sub i64 %106, 24
  %108 = load i64, i64* @RAX_2216_3bf505b8, align 8
  %109 = inttoptr i64 %107 to i64*
  store i64 %108, i64* %109, align 8
  store i8 0, i8* @CF_2065_3bf50570, align 1, !tbaa !10
  %110 = trunc i64 %108 to i32
  %111 = and i32 %110, 255
  %112 = call i32 @llvm.ctpop.i32(i32 %111) #3, !range !24
  %113 = trunc i32 %112 to i8
  %114 = and i8 %113, 1
  %115 = xor i8 %114, 1
  store i8 %115, i8* @PF_2067_3bf50570, align 1, !tbaa !25
  store i8 0, i8* @AF_2069_3bf50570, align 1, !tbaa !26
  %116 = icmp eq i64 %108, 0
  %117 = zext i1 %116 to i8
  store i8 %117, i8* @ZF_2071_3bf50570, align 1, !tbaa !27
  %118 = lshr i64 %108, 63
  %119 = trunc i64 %118 to i8
  store i8 %119, i8* @SF_2073_3bf50570, align 1, !tbaa !28
  store i8 0, i8* @OF_2077_3bf50570, align 1, !tbaa !29
  br i1 %116, label %inst_13f5, label %inst_1227

inst_1227:                                        ; preds = %inst_1208
  %120 = sub i64 %106, 104
  %121 = inttoptr i64 %120 to i64*
  %122 = load i64, i64* %121, align 8
  %123 = sub i64 %106, 96
  %124 = inttoptr i64 %123 to i64*
  store i64 %122, i64* %124, align 8
  %125 = load i64, i64* %109, align 8
  %126 = sub i64 %106, 88
  %127 = inttoptr i64 %126 to i64*
  store i64 %125, i64* %127, align 8
  %128 = sub i64 %106, 80
  %129 = inttoptr i64 %128 to i64*
  store i64 1, i64* %129, align 8
  br label %inst_13ac

inst_12c6:                                        ; preds = %inst_12bc
  %130 = load i64, i64* %193, align 8
  %131 = icmp ugt i64 %69, %130
  %132 = zext i1 %131 to i8
  %133 = icmp eq i8 %132, 0
  br i1 %133, label %inst_12fe, label %inst_12d0

inst_12d0:                                        ; preds = %inst_12c6
  %134 = mul i64 %158, 4
  %135 = load i64, i64* %124, align 8
  %136 = add i64 %134, %135
  %137 = inttoptr i64 %136 to i32*
  %138 = load i32, i32* %137, align 4
  %139 = mul i64 %130, 4
  %140 = add i64 %139, %135
  %141 = inttoptr i64 %140 to i32*
  %142 = load i32, i32* %141, align 4
  %143 = sub i32 %138, %142
  %144 = icmp eq i32 %143, 0
  %145 = zext i1 %144 to i8
  %146 = lshr i32 %143, 31
  %147 = trunc i32 %146 to i8
  %148 = lshr i32 %138, 31
  %149 = lshr i32 %142, 31
  %150 = xor i32 %149, %148
  %151 = xor i32 %146, %148
  %152 = add nuw nsw i32 %151, %150
  %153 = icmp eq i32 %152, 2
  %154 = icmp eq i8 %145, 0
  %155 = icmp eq i8 %147, 0
  %156 = xor i1 %155, %153
  %157 = and i1 %154, %156
  br i1 %157, label %inst_1332, label %inst_12fe

inst_12bc:                                        ; preds = %inst_1369
  %158 = load i64, i64* %190, align 8
  %159 = load i64, i64* %173, align 8
  %160 = icmp ugt i64 %159, %158
  %161 = zext i1 %160 to i8
  %162 = icmp eq i8 %161, 0
  br i1 %162, label %inst_1332, label %inst_12c6

inst_1377:                                        ; preds = %inst_1369
  %163 = load i64, i64* %129, align 8
  %164 = add i64 %163, %163
  %165 = load i64, i64* %205, align 8
  %166 = add i64 %165, %164
  store i64 %166, i64* %205, align 8
  br label %inst_1382

inst_1251:                                        ; preds = %inst_1382
  %167 = sub i64 %106, 8
  %168 = inttoptr i64 %167 to i64*
  store i64 %36, i64* %168, align 8
  %169 = load i64, i64* %205, align 8
  %170 = load i64, i64* %129, align 8
  %171 = add i64 %169, %170
  %172 = sub i64 %106, 64
  %173 = inttoptr i64 %172 to i64*
  store i64 %171, i64* %173, align 8
  %174 = load i64, i64* %42, align 8
  %175 = icmp ult i64 %174, %171
  %176 = zext i1 %175 to i8
  %177 = icmp eq i8 %176, 0
  %spec.store.select702 = select i1 %177, i64 %171, i64 %174
  store i64 %spec.store.select702, i64* %173, align 8
  %178 = load i64, i64* %129, align 8
  %179 = add i64 %178, %178
  store i64 %179, i64* @RDX_2264_3bf505b8, align 8, !tbaa !8
  %180 = load i64, i64* %205, align 8
  %181 = add i64 %179, %180
  %182 = sub i64 %106, 56
  %183 = inttoptr i64 %182 to i64*
  store i64 %181, i64* %183, align 8
  %184 = load i64, i64* %42, align 8
  %185 = icmp ult i64 %184, %181
  %186 = zext i1 %185 to i8
  %187 = icmp eq i8 %186, 0
  %spec.store.select = select i1 %187, i64 %181, i64 %184
  store i64 %spec.store.select, i64* %183, align 8
  %188 = load i64, i64* %168, align 8
  %189 = sub i64 %106, 48
  %190 = inttoptr i64 %189 to i64*
  store i64 %188, i64* %190, align 8
  %191 = load i64, i64* %173, align 8
  %192 = sub i64 %106, 40
  %193 = inttoptr i64 %192 to i64*
  store i64 %191, i64* %193, align 8
  %194 = load i64, i64* %168, align 8
  %195 = sub i64 %106, 32
  %196 = inttoptr i64 %195 to i64*
  store i64 %194, i64* %196, align 8
  br label %inst_1369

inst_1390:                                        ; preds = %inst_1382
  %197 = load i64, i64* %124, align 8
  %198 = sub i64 %106, 16
  %199 = inttoptr i64 %198 to i64*
  store i64 %197, i64* %199, align 8
  %200 = load i64, i64* %127, align 8
  store i64 %200, i64* %124, align 8
  %201 = load i64, i64* %199, align 8
  store i64 %201, i64* %127, align 8
  %202 = load i64, i64* %129, align 8
  %203 = shl i64 %202, 1
  store i64 %203, i64* %129, align 8
  br label %inst_13ac

inst_1244:                                        ; preds = %inst_13ac
  %204 = sub i64 %106, 72
  %205 = inttoptr i64 %204 to i64*
  store i64 0, i64* %205, align 8
  br label %inst_1382

inst_13ba:                                        ; preds = %inst_13ac
  %206 = load i64, i64* %124, align 8
  %207 = load i64, i64* %121, align 8
  %208 = sub i64 %206, %207
  %209 = icmp ugt i64 %207, %206
  %210 = zext i1 %209 to i8
  store i8 %210, i8* @CF_2065_3bf50570, align 1, !tbaa !10
  %211 = trunc i64 %208 to i32
  %212 = and i32 %211, 255
  %213 = call i32 @llvm.ctpop.i32(i32 %212) #3, !range !24
  %214 = trunc i32 %213 to i8
  %215 = and i8 %214, 1
  %216 = xor i8 %215, 1
  store i8 %216, i8* @PF_2067_3bf50570, align 1, !tbaa !25
  %217 = xor i64 %207, %206
  %218 = xor i64 %217, %208
  %219 = lshr i64 %218, 4
  %220 = trunc i64 %219 to i8
  %221 = and i8 %220, 1
  store i8 %221, i8* @AF_2069_3bf50570, align 1, !tbaa !26
  %222 = icmp eq i64 %208, 0
  %223 = zext i1 %222 to i8
  store i8 %223, i8* @ZF_2071_3bf50570, align 1, !tbaa !27
  %224 = lshr i64 %208, 63
  %225 = trunc i64 %224 to i8
  store i8 %225, i8* @SF_2073_3bf50570, align 1, !tbaa !28
  %226 = lshr i64 %206, 63
  %227 = lshr i64 %207, 63
  %228 = xor i64 %227, %226
  %229 = xor i64 %224, %226
  %230 = add nuw nsw i64 %229, %228
  %231 = icmp eq i64 %230, 2
  %232 = zext i1 %231 to i8
  store i8 %232, i8* @OF_2077_3bf50570, align 1, !tbaa !29
  br i1 %222, label %inst_13e3, label %inst_13c4

inst_13c4:                                        ; preds = %inst_13ba
  %233 = mul i64 %43, 4
  store i64 %233, i64* @RDX_2264_3bf505b8, align 8, !tbaa !8
  store i64 %206, i64* @RCX_2248_3bf505b8, align 8, !tbaa !8
  store i64 %207, i64* @RAX_2216_3bf505b8, align 8, !tbaa !8
  store i64 %206, i64* @RSI_2280_3bf505b8, align 8, !tbaa !8
  store i64 %207, i64* @RDI_2296_3bf505b8, align 8, !tbaa !8
  %234 = load i64, i64* @RSP_2312_3bf505b8, align 8, !tbaa !5
  %235 = add i64 %234, -8
  %236 = inttoptr i64 %235 to i64*
  store i64 undef, i64* %236, align 8
  store i64 %235, i64* @RSP_2312_3bf505b8, align 8, !tbaa !8
  %237 = call %struct.Memory* @ext_10e0__memcpy(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %39)
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
