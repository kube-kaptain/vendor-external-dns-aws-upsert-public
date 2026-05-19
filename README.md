# Vendor External DNS AWS Upsert Public

Vendored ExternalDNS helm chart rendered to plain kubernetes manifests using
the `kubernetes-bundle-vendor-helm-rendered` build type.

The helm chart is fetched from `https://kubernetes-sigs.github.io/external-dns/`
at build time, rendered via `helm template`, and processed through the standard
pipeline (split, map, transform, label, validate). The output is committed plain
manifests in `src/kubernetes/` with no helm runtime dependency.

This package configures ExternalDNS for **AWS Route 53 public zones** using the
`upsert-only` policy (records are created/updated but never deleted).


## Upstream

- Project: https://kubernetes-sigs.github.io/external-dns/
- Chart repo: `https://kubernetes-sigs.github.io/external-dns/`
- Chart name: `external-dns`
- Version tracked in: `src/config/VendorHelmRenderedVersion`


## Versioning

Upstream chart version (e.g. `1.21.1`) stored in `src/config/VendorHelmRenderedVersion`.
Our packaging version appends an increment: `1.21.1.1`, `1.21.1.2`, etc.


## Structure

- `src/config/VendorHelmRenderedVersion` - upstream chart version
- `src/vendor-helm-rendered/values-*.yaml` - version-specific helm values overrides
- `src/kubernetes/` - final committed output (plain manifests)
- `.github/bin/pre-package-prepare.bash` - asserts chart minor matches image minor
