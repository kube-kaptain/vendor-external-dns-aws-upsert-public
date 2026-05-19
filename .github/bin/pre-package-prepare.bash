#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2025-2026 Kaptain contributors (Fred Cooke)
#
# pre-package-prepare hook for vendor-external-dns-aws-upsert-public
#
# Asserts that the upstream chart version recorded in
# src/config/VendorHelmRenderedVersion has the same minor part as the image
# tag named in KaptainPM.yaml's imageRetags section. Catches drift between
# the chart we render and the image we ship (e.g. chart 1.21.1 paired with
# app v0.21.0 - same minor 21, which is the correct combination).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

CHART_VERSION_FILE="${REPO_ROOT}/src/config/VendorHelmRenderedVersion"
KAPTAIN_PM_FILE="${REPO_ROOT}/KaptainPM.yaml"

CHART_VERSION="$(head -n 1 "${CHART_VERSION_FILE}" | tr -d '[:space:]')"
CHART_MINOR="$(printf '%s' "${CHART_VERSION}" | awk -F. '{print $2}')"

IMAGE_URI="$(yq '.spec.main.vendorHelmRendered.imageRetags[0].sourceImageUri' "${KAPTAIN_PM_FILE}")"
IMAGE_TAG="${IMAGE_URI##*:}"
IMAGE_TAG_STRIPPED="${IMAGE_TAG#v}"
IMAGE_MINOR="$(printf '%s' "${IMAGE_TAG_STRIPPED}" | awk -F. '{print $2}')"

if [ "${CHART_MINOR}" != "${IMAGE_MINOR}" ]; then
  printf 'ERROR: chart minor (%s from %s) does not match image minor (%s from %s)\n' "${CHART_MINOR}" "${CHART_VERSION}" "${IMAGE_MINOR}" "${IMAGE_TAG}" >&2
  printf 'Bump src/config/VendorHelmRenderedVersion or KaptainPM.yaml imageRetags so the minor parts agree.\n' >&2
  exit 1
fi

printf 'OK: chart minor and image minor both %s\n' "${CHART_MINOR}"
