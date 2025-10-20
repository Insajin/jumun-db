#!/usr/bin/env bash

# Regenerate Supabase cloud SQL scripts so that cloud and local schemas stay in sync.
# Usage: ./scripts/generate-cloud-sql.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${ROOT_DIR}"

MIGRATIONS_DIR="${ROOT_DIR}/supabase/migrations"
SCHEMA_FILE="${ROOT_DIR}/init-cloud-db.sql"
SIMPLE_FILE="${ROOT_DIR}/init-cloud-db-simple.sql"
COMPLETE_FILE="${ROOT_DIR}/init-cloud-db-complete.sql"
SEED_SIMPLE="${ROOT_DIR}/seed_data_only.sql"
SEED_COMPLETE="${ROOT_DIR}/seed/seed.sql"

if [[ ! -d "${MIGRATIONS_DIR}" ]]; then
  echo "❌ Cannot find migrations directory at ${MIGRATIONS_DIR}" >&2
  exit 1
fi

timestamp="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
tmp_schema="$(mktemp)"

# Compose schema from migrations (sorted by filename/timestamp)
{
  printf '%s\n' '-- =========================================================================='
  printf '%s\n' '-- Jumun Supabase Schema'
  printf '%s\n' "-- Generated: ${timestamp} UTC"
  printf '%s\n' '-- Source: supabase/migrations (concatenated in timestamp order)'
  printf '%s\n' '-- Do not edit manually. Update migrations instead.'
  printf '%s\n' '-- =========================================================================='
  printf '\n'
  printf '%s\n' 'SET statement_timeout = 0;'
  printf '%s\n' 'SET lock_timeout = 0;'
  printf '%s\n' 'SET idle_in_transaction_session_timeout = 0;'
  printf '%s\n' 'SET search_path = public, extensions;'
  printf '\n'

  while IFS= read -r migration; do
    base="$(basename "${migration}")"
    printf '%s\n' '-- =========================================================================='
    printf '%s\n' "-- Migration: ${base}"
    printf '%s\n' '-- =========================================================================='
    cat "${migration}"
    printf '\n'
  done < <(find "${MIGRATIONS_DIR}" -maxdepth 1 -type f -name '*.sql' | sort)
} > "${tmp_schema}"

cp "${tmp_schema}" "${SCHEMA_FILE}"

# Append seed snippets
{
  cat "${tmp_schema}"
  printf '%s\n' '-- =========================================================================='
  printf '%s\n' '-- Minimal reference data (seed_data_only.sql)'
  printf '%s\n' '-- =========================================================================='
  cat "${SEED_SIMPLE}"
  printf '\n'
} > "${SIMPLE_FILE}"

{
  cat "${tmp_schema}"
  printf '%s\n' '-- =========================================================================='
  printf '%s\n' '-- Full sample data (seed/seed.sql)'
  printf '%s\n' '-- =========================================================================='
  cat "${SEED_COMPLETE}"
  printf '\n'
} > "${COMPLETE_FILE}"

rm "${tmp_schema}"

echo "✅ Updated:"
echo "  - ${SCHEMA_FILE}"
echo "  - ${SIMPLE_FILE}"
echo "  - ${COMPLETE_FILE}"
echo
echo "Cloud Supabase now has exactly the same schema definitions as local migrations."
