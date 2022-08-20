build: build-all-assemblyscript build-all-rust

run: run-all-assemblyscript run-all-rust

build-all-assemblyscript:
  for dir in `ls assemblyscript`; do \
    just build-assemblyscript $dir; \
  done

build-all-rust:
  for dir in `ls rust`; do \
    just build-rust $dir; \
  done

run-all-assemblyscript:
  for dir in `ls assemblyscript`; do \
    just run-assemblyscript $dir; \
  done

run-all-rust:
  for dir in `ls rust`; do \
    just run-rust $dir; \
  done

build-assemblyscript project:
  cd "assemblyscript/{{project}}" && yarn && yarn build

build-rust project:
  cd "rust/{{project}}" && cargo wasi build --release

run-assemblyscript project:
  @echo "Run assemblyscript/{{project}}"
  wasmtime "assemblyscript/{{project}}/build/{{project}}.wasm"
  @echo ""

run-rust project:
  @echo "Run rust/{{project}}"
  wasmtime "rust/{{project}}/target/wasm32-wasi/release/{{project}}.wasm"
  @echo ""

# Copy all WASI-enabled Wasm binaries to a directory "dist"
dist:
  rm -rf dist && mkdir dist
  for dir in `ls assemblyscript`; do \
    cp "assemblyscript/$dir/build/$dir.wasm" dist; \
  done
  for dir in `ls rust`; do \
    cp "rust/$dir/target/wasm32-wasi/release/$dir.wasm" dist; \
  done

clean:
  rm -rf **/node_modules/ **/build/ **/target/

setup:
  #!/bin/bash
  cargo wasi --help &>/dev/null || cargo install -f cargo-wasi
  wasmtime -V &>/dev/null || curl https://wasmtime.dev/install.sh -sSf | bash
