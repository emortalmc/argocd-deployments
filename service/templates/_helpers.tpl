{{- define "service.defaultEnv" }}
env:
  - name: {{ printf "%sDEVELOPMENT" .Values.envPrefix }}
    value: "false"
  - name: {{ printf "%sKAFKA_HOST" .Values.envPrefix }}
    value: "default-kafka-bootstrap"
  - name: {{ printf "%sKAFKA_PORT" .Values.envPrefix }}
    value: "9092"
{{- if .Values.mongodb.enabled }}
  - name: {{ printf "%sMONGODB_URI" .Values.envPrefix }}
    valueFrom:
      secretKeyRef:
        name: {{ default (.Values.name) .Values.mongodb.name }}-db-creds
        key: connection-string
{{- end }}
  - name: {{ printf "%sPORT" .Values.envPrefix }}
    value: "9010"
{{- end }}

{{- define "service.env" }}
{{- include "service.defaultEnv" . }}
{{- range $key, $value := .Values.extraEnv }}
  - name: {{ printf "%s%s" $.Values.envPrefix $key }}
    value: "{{ $value }}"
{{- end }}
{{- range $key, $value := .Values.extraSecrets }}
  - name: {{ printf "%s%s" $.Values.envPrefix $key }}
    valueFrom:
      secretKeyRef:
        name: {{ $value.name }}
        key: {{ $value.key }}
        optional: {{ $value.optional }}
{{- end }}
{{- end }}

{{- define "service.resources" }}
{{- if .Values.resources }}
resources:
{{- with .Values.resources }}
{{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}
{{- end }}
