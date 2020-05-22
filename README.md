# kustomize-sandbox

A playground for testing various kustomize and argo versions, etc.

## Running the tests

To run the tests for `job-generate-name`, you must have two versions of kustomize available: 1.0.11 and 3.5.  You can either name them `kustomize1` and `kustomize3`, respectively, and ensure that each is in your `$PATH`, or you can set the environment variables `KUSTOMIZE1` and `KUSTOMIZE3` to fully-qualified paths to the binaries, e.g.:

```
# assumes `kustomize1` and `kustomize3` are in $PATH
./job-generate-name/tests/tests.sh

# explicitly sets kustomize v1 and v3 locations
KUSTOMIZE1=/path/to/v1/kustomize KUSTOMIZE3=/path/to/v3/kustomize ./job-generate-name/tests/tests.sh
```
