#! /bin/bash

main() {
  if [[ -e "$DATA_DIR_NAME" ]]; then
    echo "::error::Directory $DATA_DIR_NAME already exists"
    return 1
  fi

  mkdir "$DATA_DIR_NAME"
  cp "$GITHUB_ACTION_PATH"/data/* "$DATA_DIR_NAME"

  print_codeql_env >> "$GITHUB_ENV"
}

print_codeql_env() {
  local -r ANALYSIS_PATHS=(
    "$DATA_DIR_NAME/stub.js"
    '.github/workflows'
  )

  echo 'LGTM_INDEX_INCLUDE<<EOF'
  printf '%s\n' "${ANALYSIS_PATHS[@]}"
  echo 'EOF'

  echo 'LGTM_INDEX_FILTERS<<EOF'
  printf 'include:%s\n' "${ANALYSIS_PATHS[@]}"
  echo 'EOF'
}

main; exit "$?"
