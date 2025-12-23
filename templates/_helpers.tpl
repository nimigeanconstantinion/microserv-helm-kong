{{/*
Expand the name of the chart.
*/}}
{{- define "ms-kong.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ms-kong.fullname" -}}
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
{{- define "ms-kong.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ms-kong.labels" -}}
helm.sh/chart: {{ include "ms-kong.chart" . }}
{{ include "ms-kong.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ms-kong.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ms-kong.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ms-kong.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ms-kong.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}



{{/*
Component-specific labels for MySQL
Usage: {{ include "ms-kong.mysql.labels" . | nindent 4 }}
*/}}
{{- define "ms-kong.mysql.labels" -}}
{{ include "ms-kong.labels" . }}
app.kubernetes.io/component: mysql
{{- end }}

{{/*
Generate the image name with registry prefix if specified
Usage: {{ include "ms-kong.image" (dict "image" .Values.images "global" .Values.global) }}
*/}}
{{- define "ms-kong.image" -}}
{{- if .global.imageRegistry -}}
{{- printf "%s/%s:%s" .global.imageRegistry .image.repository .image.tag -}}
{{- else -}}
{{- printf "%s:%s" .image.repository .image.tag -}}
{{- end -}}
{{- end }}

{{/*
MySQL selector labels
Usage: {{ include "ms-kong.mysql.selectorLabels" . }}
*/}}
{{- define "ms-kong.mysql.selectorLabels" -}}
{{ include "ms-kong.selectorLabels" . }}
app.kubernetes.io/component: mysql
{{- end }}

{{/*
POSTGRES selector labels
Usage: {{ include "ms-kong.postgres.selectorLabels" . }}
*/}}
{{- define "ms-kong.postgres.selectorLabels" -}}
{{ include "ms-kong.selectorLabels" . }}
app.kubernetes.io/component: postgres
{{- end }}
