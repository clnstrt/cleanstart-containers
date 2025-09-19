{{/*
Expand the name of the chart.
*/}}
{{- define "go-web-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "go-web-app.fullname" -}}
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
{{- define "go-web-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "go-web-app.labels" -}}
helm.sh/chart: {{ include "go-web-app.chart" . }}
{{ include "go-web-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.cleanstart.enabled }}
cleanstart.com/publisher: {{ .Values.cleanstart.publisher | quote }}
cleanstart.com/verified: {{ .Values.cleanstart.imageVerified | quote }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "go-web-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "go-web-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "go-web-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "go-web-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the config map
*/}}
{{- define "go-web-app.configMapName" -}}
{{- if .Values.configMap.enabled }}
{{- printf "%s-config" (include "go-web-app.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Create the name of the secret
*/}}
{{- define "go-web-app.secretName" -}}
{{- if .Values.secrets.enabled }}
{{- printf "%s-secret" (include "go-web-app.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Create the image name with registry
*/}}
{{- define "go-web-app.image" -}}
{{- if .Values.global.imageRegistry }}
{{- printf "%s/%s:%s" .Values.global.imageRegistry .Values.image.repository (.Values.image.tag | default .Chart.AppVersion) }}
{{- else }}
{{- printf "%s:%s" .Values.image.repository (.Values.image.tag | default .Chart.AppVersion) }}
{{- end }}
{{- end }}

{{/*
Create the CleanStart image verification annotation
*/}}
{{- define "go-web-app.cleanstartAnnotation" -}}
{{- if .Values.cleanstart.enabled }}
cleanstart.com/verified: "true"
cleanstart.com/publisher: {{ .Values.cleanstart.publisher | quote }}
cleanstart.com/security-scan: {{ .Values.cleanstart.securityScan | quote }}
{{- end }}
{{- end }}
