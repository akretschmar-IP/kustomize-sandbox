#!/bin/bash


function run_test() {
    label=$1
    kustomize=$2
    template=$3
    expected=$4

    $kustomize build $template > $label.out 2> $label.err
    actual=$?

    if [ $actual -eq $expected ]; then
        result=PASS
        ret=0
    else
        result=FAIL
        ret=1
    fi

    printf "%-20s: expected: %s, actual %s, result: %s\n" $label $expected $actual $result
    #echo "$label: expected: $expected, actual: $actual, result: $result"

    return $ret
}

echo "checking for dependencies..."
ok=1
k1=${KUSTOMIZE1:-kustomize1}
k3=${KUSTOMIZE3:-kustomize3}

echo "checking for kustomize1..."
$k1 version | grep KustomizeVersion:1.0.11
if [ $? -ne 0 ]; then
    >&2 echo "kustomize v1 not found or not correct version"
    ok=0
fi

echo "checking for kustomize3..."
$k3 version | grep Version:3.5
if [ $? -ne 0 ]; then
    >&2 echo "kustomize v3 not found or not correct version"
    ok=0
fi

if [ $ok -ne 1 ]; then
    >&2 echo "failed to find all dependencies."
    >&2 echo "Please set KUSTOMIZE1 and KUSTOMIZE3, or ensure that the binaries kustomize and kustomize3 are in your \$PATH"
    exit 1
fi

res=0
overall=PASS

run_test "v1-only_with_k1" $k1 ./v1-only 0 || res=1
run_test "v1-only_with_k3" $k3 ./v1-only 1 || res=1
run_test "v3-only_with_k1" $k1 ./v3-only 1 || res=1
run_test "v3-only_with_k3" $k3 ./v3-only 0 || res=1
run_test "v1-and-v3_with_k1" $k1 ./v1-and-v3 0 || res=1
run_test "v1-and-v3_with_k3" $k3 ./v1-and-v3 0 || res=1

if [ $res -ne 0 ]; then
    overall=FAIL
fi

echo "Overall result: $overall"
exit $res
