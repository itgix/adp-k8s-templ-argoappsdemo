# ITGix Portal

The existing portal Application and chart support AWS unchanged. On GCP the
Application loads `helm/itgix-portal/values-gcp.yaml`, uses `secretstore-gcp`,
and attaches its ClusterIP Service to the existing shared Gateway. The overlay
adds PostgreSQL with a retained PVC; the existing migration Job and portal image
are reused. No replacement portal chart or new Terraform secret API is required.

Keep the existing private installer YAML format, as in `demo-mini.yml`:

```yaml
itgix_portal_enabled: true
itgix_portal_employee_login_enabled: true
gcp_shared_gateway_enabled: true
custom_secrets:
  - secret_name: itgix-portal-postgres-password
    length: 32
    special: false
  - secret_name: itgix-portal-google-OAuth
    manual: true
    value: '{\"GOOGLE_CLIENT_ID\":\"example\",\"GOOGLE_CLIENT_SECRET\":\"example\"}'
```

Terraform already creates versions from supplied `value`, including with
`manual: true`; without a value, `manual: true` creates only the container.
`custom_secret_names` outputs supply GCP secret IDs to External Secrets. OAuth
payloads stay in the private input, not public Helm defaults. This existing
inline format stores values in generated tfvars/Terraform state, so those
repositories, files, and state must be private and access-controlled.

The GCP Application uses this public repository for chart sources and the customer
GitOps repository for environment facts. `applications_template_repo_branch`
selects the chart revision. It uses the applications destination repository when
configured, otherwise the infrastructure GitOps repository (revision `HEAD`).
The infrastructure template can bootstrap this existing applications chart when
a separate applications bootstrap is not configured; no portal chart is duplicated.

The hostname remains `itgix-portal-<environment>-<region>.<dns_main_domain>`.
The existing OAuth client must already authorize
`https://<portal-host>/login/oauth2/code/google-employee`. The application accepts
only `@itgix.com` employee accounts. Existing Gateway name/namespace overrides
are honored; no separate load balancer or certificate is created. PostgreSQL's
image, storage size and storage class are ordinary chart overrides under
`postgresql`. This single-instance database is a demo, not an HA/backup solution.
Keep its password stable while retaining its data volume.
