#!/usr/bin/env bash
# quick_ir_eval.sh
# IR 유효성/라운드트립(컴파일·링크) 1일차 측정 스크립트
# 사용법:
#   bash quick_ir_eval.sh <CASES_ROOT>
# 폴더 구조 예:
#   <CASES_ROOT>/case1/src.c            # 선택: 정답 IR을 소스에서 생성
#   <CASES_ROOT>/case1/ref.ll           # 또는 미리 준비한 정답 IR
#   <CASES_ROOT>/case1/llm.ll           # 후보 IR(LLM)
#   <CASES_ROOT>/case1/mcsema.ll        # 후보 IR(McSema 산출물)
#   <CASES_ROOT>/case1/retdec.ll        # 후보 IR(RetDec 산출물)
#   <CASES_ROOT>/case1/harness.c        # 선택: 링크/라운드트립용 하네스
# 결과:
#   out/results.csv, out/summary.txt, 각 케이스별 *.log
#
# 필요 도구: clang, llvm-as, opt, llc, llvm-diff

set -uo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <CASES_ROOT>"
  exit 1
fi

CASES_ROOT="$1"
if [[ ! -d "$CASES_ROOT" ]]; then
  echo "No such directory: $CASES_ROOT"
  exit 1
fi

# 확인: 필수 바이너리
require() { command -v "$1" >/dev/null 2>&1 || { echo "Missing: $1"; exit 1; }; }
require clang
require llvm-as
require opt
require llc
require llvm-diff

# 공통 정규화 패스(가벼운 세트)
PASSES=${PASSES:-"mem2reg,sroa,instcombine,simplifycfg,gvn,adce"}

OUT="out"
mkdir -p "$OUT"

CSV="$OUT/results.csv"
echo "case,artifact,valid_parse,verify_ok,codegen_ok,diff_equal,link_ok,roundtrip_ok" > "$CSV"

shopt -s nullglob

# 케이스 루프
for CASE in "$CASES_ROOT"/*; do
  [[ -d "$CASE" ]] || continue

  # 정답 IR 준비
  REF_LL="$CASE/ref.ll"
  if [[ ! -f "$REF_LL" && -f "$CASE/src.c" ]]; then
    clang -O0 -emit-llvm -S "$CASE/src.c" -o "$REF_LL" 2> "$CASE/ref.clang.log" || REF_LL=""
  fi

  if [[ ! -f "$REF_LL" ]]; then
    echo "WARN: $CASE 에 ref.ll 또는 src.c가 없어 정답 IR 없이 진행합니다(llvm-diff 생략)."
  fi

  # 정답 정규화
  REF_NORM="$CASE/ref.norm.ll"
  if [[ -f "$REF_LL" ]]; then
    opt -passes="$PASSES" "$REF_LL" -S -o "$REF_NORM" 2> "$CASE/ref.norm.log" || true
  fi

  # 후보 IR들 순회(정답 ref.ll은 제외)
  for CAND_LL in "$CASE"/*.ll; do
    [[ -f "$CAND_LL" ]] || continue
    [[ "$CAND_LL" == "$REF_LL" ]] && continue
    [[ "$CAND_LL" == "$REF_NORM" ]] && continue      # ← 추가
    [[ "$CAND_LL" == *.norm.ll ]] && continue  

    ARTIFACT="$(basename "$CAND_LL")"
    BASE="${ARTIFACT%.ll}"

    # 1) 파싱 유효성
    VALID=0
    if llvm-as "$CAND_LL" -o /dev/null 2> "$CASE/$BASE.as.log"; then VALID=1; fi

    # 2) opt -verify
    VERIFY=0
    if opt -verify "$CAND_LL" -disable-output 2> "$CASE/$BASE.verify.log"; then VERIFY=1; fi

    # 정규화
    CAND_NORM="$CASE/$BASE.norm.ll"
    opt -passes="$PASSES" "$CAND_LL" -S -o "$CAND_NORM" 2> "$CASE/$BASE.norm.log" || true

    # 3) 경량 유사도: llvm-diff 동일 여부(정답이 있을 때만)
    DIFF_EQUAL="NA"
    if [[ -f "$REF_NORM" ]]; then
      if llvm-diff "$REF_NORM" "$CAND_NORM" >/dev/null 2>&1; then
        DIFF_EQUAL=1
      else
        DIFF_EQUAL=0
      fi
    fi

    # 4) 코드생성
    CODEGEN=0
    if llc "$CAND_NORM" -filetype=obj -o "$CASE/$BASE.o" 2> "$CASE/$BASE.llc.log"; then CODEGEN=1; fi

    # 5) 링크(선택: harness.c가 있을 때만)
    LINK="NA"
    ROUND="NA"
    if [[ -f "$CASE/harness.c" ]]; then
      LINK=0
      if clang "$CASE/harness.c" "$CASE/$BASE.o" -o "$CASE/$BASE.bin" 2> "$CASE/$BASE.link.log"; then LINK=1; fi
      if [[ "$CODEGEN" -eq 1 && "$LINK" -eq 1 ]]; then ROUND=1; else ROUND=0; fi
    fi

    echo "$(basename "$CASE"),$ARTIFACT,$VALID,$VERIFY,$CODEGEN,$DIFF_EQUAL,$LINK,$ROUND" >> "$CSV"
  done
done

# 요약(NA 제외 집계)
{
  echo "====== SUMMARY (rates; NA 제외) ======"
  awk -F, 'NR>1 {
              v_tot+=($3!=""); v_ok+=($3==1);
              y_tot+=($4!=""); y_ok+=($4==1);
              c_tot+=($5!=""); c_ok+=($5==1);
              if($6!="NA"){ d_tot++; d_ok+=($6==1); }
              if($7!="NA"){ l_tot++; l_ok+=($7==1); }
              if($8!="NA"){ r_tot++; r_ok+=($8==1); }
           }
           END {
             if (v_tot) printf "valid_rate=%.4f (%d/%d)\n", v_ok/v_tot, v_ok, v_tot;
             if (y_tot) printf "verify_rate=%.4f (%d/%d)\n", y_ok/y_tot, y_ok, y_tot;
             if (c_tot) printf "codegen_rate=%.4f (%d/%d)\n", c_ok/c_tot, c_ok, c_tot;
             if (d_tot) printf "diff_equal_rate=%.4f (%d/%d)\n", d_ok/d_tot, d_ok, d_tot;
             if (l_tot) printf "link_rate=%.4f (%d/%d)\n", l_ok/l_tot, l_ok, l_tot;
             if (r_tot) printf "roundtrip_rate=%.4f (%d/%d)\n", r_ok/r_tot, r_ok, r_tot;
           }' "$CSV"
} | tee "$OUT/summary.txt"

echo "Done. Results at: $CSV and $OUT/summary.txt"
