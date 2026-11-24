{{- define "env_vars" -}}
{{- if .Values.cm.dynamic -}}
{{- range $key, $val := .Values.cm.dynamic }}
{{- if ne $val nil }}
{{ $key }}: {{ $val | quote }}
{{- end }}
{{- end }}
{{- end -}}
{{- end -}}

{{- define "env_vars_global" -}}
{{- if .Values.global.env -}}
{{- range $key, $val := .Values.global.env }}
{{- if ne $val nil }}
{{ $key }}: {{ $val | quote }}
{{- end }}
{{- end }}
{{- end -}}
{{- end -}}
