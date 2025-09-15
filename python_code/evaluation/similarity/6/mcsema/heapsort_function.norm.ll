; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/mcsema/ll/O0/heapsort_function.ll'
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

@RSP_2312_2172d5b8 = external global i64
@OF_2077_2172d570 = external global i8
@SF_2073_2172d570 = external global i8
@ZF_2071_2172d570 = external global i8
@AF_2069_2172d570 = external global i8
@PF_2067_2172d570 = external global i8
@CF_2065_2172d570 = external global i8
@RAX_2216_2172d5b8 = external global i64
@RSP_2312_21734bc0 = external global i64*
@RDI_2296_2172d5b8 = external global i64
@RBP_2328_2172d5b8 = external global i64
@RCX_2248_2172d5b8 = external global i64
@RSI_2280_2172d5b8 = external global i64
@RDX_2264_2172d5b8 = external global i64

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare !remill.function.type !4 i32 @llvm.ctpop.i32(i32) #0

; Function Attrs: noinline
define hidden %struct.Memory* @sub_1189_heap_sort(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #1 {
inst_1189:
  %0 = load i64, i64* @RBP_2328_2172d5b8, align 8
  %1 = load i64*, i64** @RSP_2312_21734bc0, align 8
  %2 = load i64, i64* @RSP_2312_2172d5b8, align 8, !tbaa !5
  %3 = add i64 %2, -8
  %4 = getelementptr i64, i64* %1, i64 -1
  store i64 %0, i64* %4, align 8
  store i64 %3, i64* @RSP_2312_2172d5b8, align 8, !tbaa !8
  store i64 %3, i64* @RBP_2328_2172d5b8, align 8, !tbaa !8
  %5 = add i64 %2, -112
  %6 = load i64, i64* @RDI_2296_2172d5b8, align 8
  %7 = inttoptr i64 %5 to i64*
  store i64 %6, i64* %7, align 8
  %8 = add i64 %2, -120
  %9 = load i64, i64* @RSI_2280_2172d5b8, align 8
  %10 = inttoptr i64 %8 to i64*
  store i64 %9, i64* %10, align 8
  %11 = add i64 %9, -1
  %12 = icmp eq i64 %9, 0
  %13 = zext i1 %12 to i8
  store i8 %13, i8* @CF_2065_2172d570, align 1, !tbaa !10
  %14 = trunc i64 %11 to i32
  %15 = and i32 %14, 255
  %16 = call i32 @llvm.ctpop.i32(i32 %15) #2, !range !24
  %17 = trunc i32 %16 to i8
  %18 = and i8 %17, 1
  %19 = xor i8 %18, 1
  store i8 %19, i8* @PF_2067_2172d570, align 1, !tbaa !25
  %20 = xor i64 %9, %11
  %21 = trunc i64 %20 to i8
  %22 = lshr i8 %21, 4
  %23 = and i8 %22, 1
  store i8 %23, i8* @AF_2069_2172d570, align 1, !tbaa !26
  %24 = icmp eq i64 %11, 0
  %25 = zext i1 %24 to i8
  store i8 %25, i8* @ZF_2071_2172d570, align 1, !tbaa !27
  %26 = lshr i64 %11, 63
  %27 = trunc i64 %26 to i8
  store i8 %27, i8* @SF_2073_2172d570, align 1, !tbaa !28
  %28 = lshr i64 %9, 63
  %29 = xor i64 %26, %28
  %30 = add nuw nsw i64 %29, %28
  %31 = icmp eq i64 %30, 2
  %32 = zext i1 %31 to i8
  store i8 %32, i8* @OF_2077_2172d570, align 1, !tbaa !29
  %33 = icmp ult i64 %9, 2
  br i1 %33, label %inst_1449, label %inst_11a4

inst_1395:                                        ; preds = %inst_134b.inst_1395_crit_edge, %inst_1361
  %34 = phi i64 [ %.pre9, %inst_134b.inst_1395_crit_edge ], [ %171, %inst_1361 ]
  br label %inst_1399

inst_1399:                                        ; preds = %inst_1361, %inst_1395
  %storemerge4 = phi i64 [ %34, %inst_1395 ], [ %162, %inst_1361 ]
  store i64 %storemerge4, i64* @RAX_2216_2172d5b8, align 8, !tbaa !8
  %35 = add i64 %2, -40
  %36 = inttoptr i64 %35 to i64*
  store i64 %storemerge4, i64* %36, align 8
  %37 = load i64, i64* %226, align 8
  %38 = shl i64 %37, 2
  %39 = load i64, i64* %7, align 8
  %40 = add i64 %38, %39
  %41 = inttoptr i64 %40 to i32*
  %42 = load i32, i32* %41, align 4
  %43 = zext i32 %42 to i64
  store i64 %43, i64* @RDX_2264_2172d5b8, align 8, !tbaa !8
  %44 = load i64, i64* %36, align 8
  %45 = shl i64 %44, 2
  store i64 %45, i64* @RCX_2248_2172d5b8, align 8, !tbaa !8
  %46 = add i64 %45, %39
  %47 = inttoptr i64 %46 to i32*
  %48 = load i32, i32* %47, align 4
  %49 = zext i32 %48 to i64
  store i64 %49, i64* @RAX_2216_2172d5b8, align 8, !tbaa !8
  %50 = sub i32 %42, %48
  %51 = lshr i32 %50, 31
  %52 = lshr i32 %42, 31
  %53 = lshr i32 %48, 31
  %54 = xor i32 %53, %52
  %55 = xor i32 %51, %52
  %56 = add nuw nsw i32 %55, %54
  %57 = icmp eq i32 %56, 2
  %58 = icmp sgt i32 %50, -1
  %59 = xor i1 %58, %57
  br i1 %59, label %inst_1399.inst_1436_crit_edge, label %inst_13cb

inst_1399.inst_1436_crit_edge:                    ; preds = %inst_1399
  %.pre10 = load i64, i64* %161, align 8
  br label %inst_1436

inst_1223:                                        ; preds = %inst_11d9.inst_1223_crit_edge, %inst_11ef
  %.pre11.pre-phi = phi i64 [ %.pre12, %inst_11d9.inst_1223_crit_edge ], [ %121, %inst_11ef ]
  %60 = phi i64 [ %.pre, %inst_11d9.inst_1223_crit_edge ], [ %120, %inst_11ef ]
  br label %inst_1227

inst_1227:                                        ; preds = %inst_11ef, %inst_1223
  %.pre-phi = phi i64 [ %115, %inst_11ef ], [ %.pre11.pre-phi, %inst_1223 ]
  %storemerge8 = phi i64 [ %60, %inst_1223 ], [ %111, %inst_11ef ]
  store i64 %storemerge8, i64* @RAX_2216_2172d5b8, align 8, !tbaa !8
  %61 = add i64 %2, -16
  %62 = inttoptr i64 %61 to i64*
  store i64 %storemerge8, i64* %62, align 8
  %63 = load i64, i64* %157, align 8
  %64 = shl i64 %63, 2
  %65 = load i64, i64* %7, align 8
  %66 = add i64 %64, %65
  %67 = inttoptr i64 %66 to i32*
  %68 = load i32, i32* %67, align 4
  store i64 %.pre-phi, i64* @RCX_2248_2172d5b8, align 8, !tbaa !8
  %69 = add i64 %.pre-phi, %65
  %70 = inttoptr i64 %69 to i32*
  %71 = load i32, i32* %70, align 4
  %72 = sub i32 %68, %71
  %73 = lshr i32 %72, 31
  %74 = lshr i32 %68, 31
  %75 = lshr i32 %71, 31
  %76 = xor i32 %75, %74
  %77 = xor i32 %73, %74
  %78 = add nuw nsw i32 %77, %76
  %79 = icmp eq i32 %78, 2
  %80 = icmp sgt i32 %72, -1
  %81 = xor i1 %80, %79
  br i1 %81, label %inst_12c4, label %inst_1259

inst_132e:                                        ; preds = %inst_12ea, %inst_13cb
  %storemerge1 = phi i64 [ 0, %inst_12ea ], [ %206, %inst_13cb ]
  store i64 %storemerge1, i64* %226, align 8
  %82 = shl i64 %storemerge1, 1
  %83 = or i64 %82, 1
  %84 = add i64 %2, -56
  %85 = inttoptr i64 %84 to i64*
  store i64 %83, i64* %85, align 8
  store i64 %83, i64* @RAX_2216_2172d5b8, align 8, !tbaa !8
  %86 = load i64, i64* %161, align 8
  %.not2 = icmp ugt i64 %86, %83
  br i1 %.not2, label %inst_134b, label %inst_1436

inst_1436:                                        ; preds = %inst_1399.inst_1436_crit_edge, %inst_132e
  %87 = phi i64 [ %.pre10, %inst_1399.inst_1436_crit_edge ], [ %86, %inst_132e ]
  %88 = add i64 %87, -1
  br label %inst_143b

inst_143b:                                        ; preds = %inst_12d9, %inst_1436
  %storemerge = phi i64 [ %159, %inst_12d9 ], [ %88, %inst_1436 ]
  store i64 %storemerge, i64* %161, align 8
  store i8 0, i8* @CF_2065_2172d570, align 1, !tbaa !10
  %89 = trunc i64 %storemerge to i32
  %90 = and i32 %89, 255
  %91 = call i32 @llvm.ctpop.i32(i32 %90) #2, !range !24
  %92 = trunc i32 %91 to i8
  %93 = and i8 %92, 1
  %94 = xor i8 %93, 1
  store i8 %94, i8* @PF_2067_2172d570, align 1, !tbaa !25
  store i8 0, i8* @AF_2069_2172d570, align 1, !tbaa !26
  %95 = icmp eq i64 %storemerge, 0
  %96 = zext i1 %95 to i8
  store i8 %96, i8* @ZF_2071_2172d570, align 1, !tbaa !27
  %97 = lshr i64 %storemerge, 63
  %98 = trunc i64 %97 to i8
  store i8 %98, i8* @SF_2073_2172d570, align 1, !tbaa !28
  store i8 0, i8* @OF_2077_2172d570, align 1, !tbaa !29
  br i1 %95, label %inst_1449, label %inst_12ea

inst_11bc:                                        ; preds = %inst_11b4, %inst_1259
  %storemerge5 = phi i64 [ %105, %inst_11b4 ], [ %155, %inst_1259 ]
  store i64 %storemerge5, i64* %157, align 8
  %99 = shl i64 %storemerge5, 1
  %100 = or i64 %99, 1
  %101 = add i64 %2, -32
  %102 = inttoptr i64 %101 to i64*
  store i64 %100, i64* %102, align 8
  %103 = load i64, i64* %10, align 8
  %.not6 = icmp ugt i64 %103, %100
  br i1 %.not6, label %inst_11d9, label %inst_12c4

inst_12c4:                                        ; preds = %inst_11a4, %inst_11bc, %inst_1227
  %104 = load i64, i64* %110, align 8
  %105 = add i64 %104, -1
  store i64 %105, i64* @RDX_2264_2172d5b8, align 8, !tbaa !8
  store i64 %105, i64* %110, align 8
  %.not = icmp eq i64 %104, 0
  br i1 %.not, label %inst_12d9, label %inst_11b4

inst_1449:                                        ; preds = %inst_143b, %inst_1189
  %106 = load i64, i64* %4, align 8
  store i64 %106, i64* @RBP_2328_2172d5b8, align 8, !tbaa !8
  %107 = add i64 %2, 8
  store i64 %107, i64* @RSP_2312_2172d5b8, align 8, !tbaa !8
  ret %struct.Memory* %memory

inst_11a4:                                        ; preds = %inst_1189
  %108 = lshr i64 %9, 1
  %109 = add i64 %2, -88
  %110 = inttoptr i64 %109 to i64*
  store i64 %108, i64* %110, align 8
  br label %inst_12c4

inst_11d9:                                        ; preds = %inst_11bc
  %111 = add i64 %99, 2
  %112 = add i64 %2, -24
  %113 = inttoptr i64 %112 to i64*
  store i64 %111, i64* %113, align 8
  %114 = load i64, i64* %10, align 8
  %.not7 = icmp ugt i64 %114, %111
  br i1 %.not7, label %inst_11ef, label %inst_11d9.inst_1223_crit_edge

inst_11d9.inst_1223_crit_edge:                    ; preds = %inst_11d9
  %.pre = load i64, i64* %102, align 8
  %.pre12 = shl i64 %.pre, 2
  br label %inst_1223

inst_11ef:                                        ; preds = %inst_11d9
  %115 = shl i64 %111, 2
  %116 = load i64, i64* %7, align 8
  %117 = add i64 %115, %116
  %118 = inttoptr i64 %117 to i32*
  %119 = load i32, i32* %118, align 4
  %120 = load i64, i64* %102, align 8
  %121 = shl i64 %120, 2
  %122 = add i64 %121, %116
  %123 = inttoptr i64 %122 to i32*
  %124 = load i32, i32* %123, align 4
  %125 = sub i32 %119, %124
  %126 = icmp eq i32 %125, 0
  %127 = lshr i32 %125, 31
  %128 = lshr i32 %119, 31
  %129 = lshr i32 %124, 31
  %130 = xor i32 %129, %128
  %131 = xor i32 %127, %128
  %132 = add nuw nsw i32 %131, %130
  %133 = icmp eq i32 %132, 2
  %134 = icmp slt i32 %125, 0
  %135 = xor i1 %134, %133
  %136 = or i1 %126, %135
  br i1 %136, label %inst_1223, label %inst_1227

inst_1259:                                        ; preds = %inst_1227
  %137 = add i64 %2, -92
  %138 = inttoptr i64 %137 to i32*
  store i32 %68, i32* %138, align 4
  %139 = load i64, i64* %62, align 8
  %140 = shl i64 %139, 2
  %141 = load i64, i64* %7, align 8
  %142 = add i64 %140, %141
  %143 = load i64, i64* %157, align 8
  %144 = shl i64 %143, 2
  store i64 %144, i64* @RCX_2248_2172d5b8, align 8, !tbaa !8
  %145 = add i64 %144, %141
  %146 = inttoptr i64 %142 to i32*
  %147 = load i32, i32* %146, align 4
  %148 = inttoptr i64 %145 to i32*
  store i32 %147, i32* %148, align 4
  %149 = load i64, i64* %62, align 8
  %150 = shl i64 %149, 2
  %151 = load i64, i64* %7, align 8
  %152 = add i64 %151, %150
  %153 = load i32, i32* %138, align 4
  %154 = inttoptr i64 %152 to i32*
  store i32 %153, i32* %154, align 4
  %155 = load i64, i64* %62, align 8
  br label %inst_11bc

inst_11b4:                                        ; preds = %inst_12c4
  %156 = add i64 %2, -80
  %157 = inttoptr i64 %156 to i64*
  br label %inst_11bc

inst_12d9:                                        ; preds = %inst_12c4
  %158 = load i64, i64* %10, align 8
  %159 = add i64 %158, -1
  store i64 %159, i64* @RAX_2216_2172d5b8, align 8, !tbaa !8
  %160 = add i64 %2, -72
  %161 = inttoptr i64 %160 to i64*
  br label %inst_143b

inst_134b:                                        ; preds = %inst_132e
  %162 = add i64 %82, 2
  %163 = add i64 %2, -48
  %164 = inttoptr i64 %163 to i64*
  store i64 %162, i64* %164, align 8
  %165 = load i64, i64* %161, align 8
  %.not3 = icmp ugt i64 %165, %162
  br i1 %.not3, label %inst_1361, label %inst_134b.inst_1395_crit_edge

inst_134b.inst_1395_crit_edge:                    ; preds = %inst_134b
  %.pre9 = load i64, i64* %85, align 8
  br label %inst_1395

inst_1361:                                        ; preds = %inst_134b
  %166 = shl i64 %162, 2
  %167 = load i64, i64* %7, align 8
  %168 = add i64 %166, %167
  %169 = inttoptr i64 %168 to i32*
  %170 = load i32, i32* %169, align 4
  %171 = load i64, i64* %85, align 8
  %172 = shl i64 %171, 2
  %173 = add i64 %172, %167
  %174 = inttoptr i64 %173 to i32*
  %175 = load i32, i32* %174, align 4
  %176 = sub i32 %170, %175
  %177 = icmp eq i32 %176, 0
  %178 = lshr i32 %176, 31
  %179 = lshr i32 %170, 31
  %180 = lshr i32 %175, 31
  %181 = xor i32 %180, %179
  %182 = xor i32 %178, %179
  %183 = add nuw nsw i32 %182, %181
  %184 = icmp eq i32 %183, 2
  %185 = icmp slt i32 %176, 0
  %186 = xor i1 %185, %184
  %187 = or i1 %177, %186
  br i1 %187, label %inst_1395, label %inst_1399

inst_13cb:                                        ; preds = %inst_1399
  %188 = add i64 %2, -96
  %189 = inttoptr i64 %188 to i32*
  store i32 %42, i32* %189, align 4
  %190 = load i64, i64* %36, align 8
  %191 = shl i64 %190, 2
  %192 = load i64, i64* %7, align 8
  %193 = add i64 %191, %192
  %194 = load i64, i64* %226, align 8
  %195 = shl i64 %194, 2
  store i64 %195, i64* @RCX_2248_2172d5b8, align 8, !tbaa !8
  %196 = add i64 %195, %192
  %197 = inttoptr i64 %193 to i32*
  %198 = load i32, i32* %197, align 4
  %199 = inttoptr i64 %196 to i32*
  store i32 %198, i32* %199, align 4
  %200 = load i64, i64* %36, align 8
  %201 = shl i64 %200, 2
  %202 = load i64, i64* %7, align 8
  %203 = add i64 %202, %201
  store i64 %203, i64* @RDX_2264_2172d5b8, align 8, !tbaa !8
  %204 = load i32, i32* %189, align 4
  %205 = inttoptr i64 %203 to i32*
  store i32 %204, i32* %205, align 4
  %206 = load i64, i64* %36, align 8
  br label %inst_132e

inst_12ea:                                        ; preds = %inst_143b
  %207 = load i64, i64* %7, align 8
  %208 = inttoptr i64 %207 to i32*
  %209 = load i32, i32* %208, align 4
  %210 = add i64 %2, -100
  %211 = inttoptr i64 %210 to i32*
  store i32 %209, i32* %211, align 4
  %212 = load i64, i64* %161, align 8
  %213 = shl i64 %212, 2
  %214 = load i64, i64* %7, align 8
  %215 = add i64 %213, %214
  %216 = inttoptr i64 %215 to i32*
  %217 = load i32, i32* %216, align 4
  %218 = inttoptr i64 %214 to i32*
  store i32 %217, i32* %218, align 4
  %219 = load i64, i64* %161, align 8
  %220 = shl i64 %219, 2
  %221 = load i64, i64* %7, align 8
  %222 = add i64 %221, %220
  store i64 %222, i64* @RDX_2264_2172d5b8, align 8, !tbaa !8
  %223 = load i32, i32* %211, align 4
  %224 = inttoptr i64 %222 to i32*
  store i32 %223, i32* %224, align 4
  %225 = add i64 %2, -64
  %226 = inttoptr i64 %225 to i64*
  br label %inst_132e
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
