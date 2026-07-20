{{/*
Expand the name of the chart.
*/}}
{{- define "ravhub.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "ravhub.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ravhub.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ravhub.labels" -}}
helm.sh/chart: {{ include "ravhub.chart" . }}
{{ include "ravhub.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ravhub.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ravhub.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ravhub.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ravhub.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "ravhub.imageRepository" -}}
{{- if .Values.license.enabled -}}
{{- .Values.image.enterpriseRepository | default "ravhub-enterprise" -}}
{{- else -}}
{{- .Values.image.repository | default "ravhub-core" -}}
{{- end -}}
{{- end }}

{{- define "ravhub.image" -}}
{{- $registry := .Values.global.imageRegistry | default .Values.image.registry | default "" | trimSuffix "/" -}}
{{- $repository := include "ravhub.imageRepository" . -}}
{{- if $registry -}}
{{- printf "%s/%s:%s" $registry $repository (.Values.image.tag | default .Chart.AppVersion) -}}
{{- else -}}
{{- printf "%s:%s" $repository (.Values.image.tag | default .Chart.AppVersion) -}}
{{- end -}}
{{- end }}

{{- define "ravhub.licenseKey" -}}
{{- if .Values.license.enabled -}}
{{- required "license.key is required when license.enabled=true" .Values.license.key -}}
{{- else -}}
{{- .Values.license.key -}}
{{- end -}}
{{- end }}

{{- define "ravhub.validateConfiguration" -}}
{{- if and (not .Values.postgresql.enabled) (not .Values.externalDatabase.host) -}}
{{- fail "externalDatabase.host is required when postgresql.enabled=false" -}}
{{- end -}}
{{- if and (not .Values.postgresql.enabled) (not .Values.externalDatabase.existingSecret) (not .Values.externalDatabase.password) -}}
{{- fail "externalDatabase.password or externalDatabase.existingSecret is required when postgresql.enabled=false" -}}
{{- end -}}
{{- if and (ne .Values.storage.type "filesystem") (not .Values.license.enabled) -}}
{{- fail (printf "storage.type=%s requires license.enabled=true" .Values.storage.type) -}}
{{- end -}}
{{- if and .Values.license.enabled (not .Values.license.key) -}}
{{- fail "license.key is required when license.enabled=true" -}}
{{- end -}}
{{- end }}
